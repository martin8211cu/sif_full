<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoHayConcursantesSeleccionados"
	Default="No hay concursantes seleccionados"
	returnvariable="MSG_NoHayConcursantesSeleccionados"/>


<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="RHPlazas" col="e.RHPdescripcion" returnvariable="LvarRHPdescripcion">
<cfquery name="rsLista" datasource="#session.DSN#">
	select 	a.RHCPid,
			a.RHPid,
			a.RHAlinea,
			(case  when a.DEid is not null
				then b.DEnombre#concat#' '#concat#b.DEapellido1#concat#' '#concat#b.DEapellido2
				else  c.RHOnombre#concat#' '#concat#c.RHOapellido1#concat#' '#concat#c.RHOapellido2
			end)  as  Nombre,
			(case  when a.DEid is not null then DEidentificacion
				else  RHOidentificacion
			end)   as ident,
			(case  when a.DEid is not null then a.DEid
				else a.RHOid
			end) as ID,
			(case  when a.DEid is not null then 'I'
				else 'E'
			end) as tipo,
			(case when a.DEid is not null then '#LB_Interno#' else '#LB_Externo#' end) as Tipo_Concursante,
			d.RHCPpromedio,
			a.RHPid,
			e.RHPcodigo#concat#'-'#concat##LvarRHPdescripcion# as plaza

	from RHAdjudicacion a
		left outer join DatosEmpleado b
			on a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid
		left outer join DatosOferentes c
			on a.Ecodigo = c.Ecodigo
			and a.RHOid = c.RHOid
		inner join RHConcursantes d
			on a.Ecodigo = d.Ecodigo
			and a.RHCconcurso = d.RHCconcurso
			and a.RHCPid = d.RHCPid
		inner join RHPlazas e
			on a.RHPid = e.RHPid

		<!--- left join DatosEmpleado b
			on a.DEid = b.DEid
		left join DatosOferentes c
			on a.RHOid = c.RHOid --->


	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and a.RHAestado in (0, 10)
</cfquery>

<script type="text/javascript" language="javascript1.2">
	var popUpWin2 = 0;
	function popUpWindow2(URLStr, left, top, width, height){
		if(popUpWin2){
			if(!popUpWin2.closed) popUpWin2.close();
		}
			popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcManteDatos(parLlave){
		param = '?RHAlinea='+parLlave
		popUpWindow2("AdjudicacionPlazas-datosoferente-form.cfm"+param,200,200,650,370);
	}
</script>

	<table width="100%" cellpadding="0" cellspacing="0">
		<form name="formPaso1" method="post" action="AdjudicacionPlazas.cfm?Paso=2&RHCconcurso=<cfoutput>#form.RHCconcurso#</cfoutput>">
			<input name="RHCconcurso" type="hidden" value="<cfif isdefined("Form.RHCconcurso") and len(trim(form.RHCconcurso))><cfoutput>#Form.RHCconcurso#</cfoutput></cfif>">
			<tr>
				<td>
					<table width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td class="titulolistas">&nbsp;</td>
							<td class="titulolistas" width="35%"><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
							<td class="titulolistas" width="10%"><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
							<td class="titulolistas" width="5%"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
							<td class="titulolistas" width="5%" nowrap><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
							<td class="titulolistas" width="35%"><strong><cf_translate key="LB_Plaza">Plaza</cf_translate></strong></td>
							<td class="titulolistas" width="5%" nowrap><strong><cf_translate key="LB_Acciones">Acciones</cf_translate>&nbsp;</strong></td>
						</tr>
						<cfif rsLista.Recordcount  EQ 0>
							<tr><td>&nbsp;</td></tr>
							<tr><td colspan="7" align="center"><strong>---- <cf_translate key="LB_NoHayConcursantesPorAplicar">No hay concursantes por aplicar</cf_translate> ----</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
						<cfelse>
							<tr>
								<td><input type="checkbox" name="chkTodos" value="" onClick="javascript: funcTodos();"></td>
								<td colspan="6"><strong><cf_translate key="LB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></strong></td>
							</tr>
							<cf_translatedata name="get" tabla="RHTipoAccion" col="RHTdesc" returnvariable="LvarRHTdesc">
							<cfoutput query="rsLista">
								<cfif rsLista.tipo EQ 'I'>
									<!----Verificar el parametro segun el tipo de concursante (Interno)--->

									<cfquery name="rsParam" datasource="#session.DSN#">
										select Pvalor,RHTcodigo,#LvarRHTdesc# as RHTdesc,b.RHTid
										from RHParametros a
											left outer join RHTipoAccion b
												on a.Ecodigo = b.Ecodigo
												and a.Pvalor = <cf_dbfunction name="to_char" args="b.RHTid">
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Pcodigo = 470
									</cfquery>
								<cfelse>
									<!----Verificar el parametro segun el tipo de concursante (Externo)--->
									<cfquery name="rsParam" datasource="#session.DSN#">
										select Pvalor,RHTcodigo,#LvarRHTdesc# as RHTdesc,RHTid
										from RHParametros a
											left outer join RHTipoAccion b
												on a.Ecodigo = b.Ecodigo
												and a.Pvalor = <cf_dbfunction name="to_char" args="b.RHTid">
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Pcodigo = 460
									</cfquery>
								</cfif>
								<!--- Obtener DEid generado por el aplicar cuando el concursante es un oferente externo --->
								<cfif rsLista.tipo EQ 'E'>
									<cfquery name="consDEid" datasource="#Session.DSN#">
										select coalesce(DEid, 0) as DEid
										from DatosOferentes
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.ID#">
									</cfquery>
									<cfset DEidOferente = consDEid.DEid>
								</cfif>

								<!---Verificar si tiene acciones pendientes segun el tipo de accion en el parametro--->
								<cfquery name="rsAcciones" datasource="#session.DSN#">
									select count(RHAlinea) as cont
									from RHAcciones a
										inner join RHTipoAccion b
											on a.Ecodigo = b.Ecodigo
											and a.RHTid = b.RHTid
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										<cfif rsLista.tipo EQ 'E'>
											and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEidOferente#">
										<cfelse>
											and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.ID#">
										</cfif>
										<cfif isdefined("rsParam") and len(trim(rsParam.Pvalor))><!----Si hay parametro verifica si tiene una accion segun el parametro--->
											and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
										<cfelse><!---Si no hay parametro verifica si tiene alguno del tipo: 6: Cambio(concursantes internos) 1: Nombramiento (concursantes externos)---->
											<cfif rsLista.tipo EQ 'I'>
												and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="6">
											<cfelse>
												and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
											</cfif>
										</cfif>
								</cfquery>

								<tr <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>style="cursor: pointer; "</cfif> class="<cfif rsLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="<cfif rsLista.currentrow mod 2>this.className='listaPar';<cfelse>this.className='listaNon';</cfif>">
									<td>
										<cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>
											<input type="checkbox" name="chk" value="#rsLista.RHAlinea#" onClick="javascript: funcMarcar();">
										</cfif>
										<input type="hidden" name="tipo_#rsLista.RHAlinea#" value="#rsLista.tipo#">
									</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="40%">#rsLista.Nombre#</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="10%">#rsLista.ident#</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="5%">#rsLista.Tipo_Concursante#</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="5%">#rsLista.RHCPpromedio#</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="30%">#rsLista.plaza#</td>
									<td <cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>onClick="javascript: funcManteDatos(#rsLista.RHAlinea#);"</cfif> width="5%">
										<cfif isdefined("rsAcciones") and rsAcciones.cont EQ 0>
											<img border="0" src="/cfmx/rh/imagenes/unchecked.gif">
										<cfelse>
											<img border="0" src="/cfmx/rh/imagenes/checked.gif">
										</cfif>
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Anterior"
						Default="Anterior"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Anterior"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Aplicar"
						Default="Aplicar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Aplicar"/>
					<cfoutput>
					<input type="submit" name="btnAnterior" value="<<#BTN_Anterior#">&nbsp;
					<input type="button" name="btnAplicar" value="#BTN_Aplicar#" onClick="javascript: funcAplicar();">
					</cfoutput>
				</td>
			</tr>
		</form>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<script type="text/javascript" language="javascript1.2">
	function funcAplicar(){
		if (document.formPaso1.chk && document.formPaso1.chk.type) {
			if (document.formPaso1.chk.checked){
				document.formPaso1.action = 'AdjudicacionPlazas-aplicar.cfm';
				document.formPaso1.submit();
				return true
			}
		}
		else{
			if (document.formPaso1.chk){
				for (var i=0; i<document.formPaso1.chk.length; i++) {
					if (document.formPaso1.chk[i].checked){
						document.formPaso1.action = 'AdjudicacionPlazas-aplicar.cfm';
						document.formPaso1.submit();
						return true;
					}
				}
			}
		}
		alert('<cfoutput>#MSG_NoHayConcursantesSeleccionados#</cfoutput>');
		return false
	}
	//Funcion para marcar los checks segun el check de Todos
	function funcTodos(){
		if (document.formPaso1.chkTodos.checked){
			if (document.formPaso1.chk && document.formPaso1.chk.type) {
				document.formPaso1.chk.checked = true
			}
			else{
				if (document.formPaso1.chk){
					for (var i=0; i<document.formPaso1.chk.length; i++) {
						document.formPaso1.chk[i].checked = true
					}
				}
			}
		}
		else{
			if (document.formPaso1.chk && document.formPaso1.chk.type) {
				document.formPaso1.chk.checked = false
			}
			else{
				if (document.formPaso1.chk){
					for (var i=0; i<document.formPaso1.chk.length; i++) {
						document.formPaso1.chk[i].checked = false
						//return true;
					}
				}
			}
		}
	}
	//Funcion para marcar o desmarcar check de Todos
	function funcMarcar(){
		var chequeados =0
		if (document.formPaso1.chk && document.formPaso1.chk.type) {
			if(document.formPaso1.chk.checked){
				document.formPaso1.chkTodos.checked = true
			}
			else{
				if (document.formPaso1.chk){
					document.formPaso1.chkTodos.checked = false
				}
			}
		}
		else{
			if (document.formPaso1.chk){
				for (var i=0; i<document.formPaso1.chk.length; i++) {
					if(document.formPaso1.chk[i].checked){
						chequeados=chequeados+1
					}
				}
			}
			if (document.formPaso1.chk){
				if(document.formPaso1.chk.length == chequeados){
					document.formPaso1.chkTodos.checked = true
				}
				else{
					document.formPaso1.chkTodos.checked = false
				}
			}
		}
	}
</script>
