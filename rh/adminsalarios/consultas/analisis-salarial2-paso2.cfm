
<!--- VARIABLES DE TRADICCION --->
<cfinvoke Key="LB_ListaDePuestos" Default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeTiposDePuesto" Default="Lista de Tipos de Puesto" returnvariable="LB_ListaDeTiposDePuesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronRegistros" Default="No se encontraron registos" returnvariable="MSG_NoSeEncontraronRegistros"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Perceptil" Default="Percentil" returnvariable="LB_Perceptil" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DeseaEliminarLosPuestosSeleccionados" Default="Desea eliminar los puestos seleccionados?" returnvariable="MSG_DeseaEliminarLosPuestosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" Default="Debe seleccionar al menos un registro para relizar esta acción."	 returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADICCION --->
<cfif isdefined('url.RHASid') and not isdefined('form.RHASid')>
	<cfset form.RHASid = url.RHASid>
</cfif>
<cfif isdefined('url.EEid') and not isdefined('form.EEid')>
	<cfset form.EEid = url.EEid>
</cfif>
<cfif isdefined('url.modo')>
	<cfset modo = url.modo>
</cfif>
<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.RHASid, rtrim(b.RHPcodigo) as RHPcodigo, b.RHPdescpuesto, 
		   case when a.RHASPperceptil = 1 then '25'
		   		when a.RHASPperceptil = 2 then '50'
				when a.RHASPperceptil = 3 then '75'
				when a.RHASPperceptil = 4 then 'PROM'
				when a.RHASPperceptil = 5 then 'VAR'
		   end as RHASPperceptil
	from RHASalarialPuestos a
		inner join RHPuestos b
			on b.Ecodigo = a.Ecodigo
			and b.RHPcodigo = a.RHPcodigo
	where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	order by b.RHPcodigo, b.RHPdescpuesto
</cfquery>
<cfquery name="rsDatosASalarial" datasource="#Session.DSN#">
		select  a.RHASid, a.Ecodigo, a.EEid, a.ETid, a.Eid, a.Mcodigo, a.NoSalario, a.RHASdescripcion, 
				a.RHASref, a.HYERVid, a.ESid, a.RHASporcentaje, a.BMUsucodigo, 
				b.EEnombre, c.ETdescripcion, d.Edescripcion, e.Mnombre, 
				<!--- f.HYERVid, f.HYERVdescripcion,  --->
				g.ESid, g.EScodigo, g.ESdescripcion, rtrim(g.EScodigo) || ' ' || g.ESdescripcion as EscalaSalarial
		from RHASalarial a
			inner join EncuestaEmpresa b
				on b.EEid = a.EEid
			inner join EmpresaOrganizacion c
				on c.ETid = a.ETid
			inner join Encuesta d
				on d.Eid = a.Eid
			inner join Monedas e
				on e.Mcodigo = a.Mcodigo
			inner join RHEscalaSalHAY g
				on g.ESid = a.ESid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	</cfquery>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function Eliminar(c, v) {
		<cfoutput>
		if (confirm("Está seguro de que desea eliminar el puesto " + v + " de este reporte?")) {
			document.listaPuestos.RHPcodigo_Del.value = c;
			document.listaPuestos.submit();
		}
		</cfoutput>
	}

	function doConlisPuestos() {
		var width = 650;
		var height = 450;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var params = '?f=form1&EEid=#rsDatosASalarial.EEid#&HYERVid=#rsDatosASalarial.HYERVid#&p1=RHPcodigo&p2=RHPdescpuesto';
		</cfoutput>
		var nuevo = window.open('analisis-salarial2-conlisPuestos.cfm'+params,'conlisASalarial','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}

	//Obtiene la descripción con base al código
	function TraePuesto(dato) {
		<cfoutput>
		var params = '?f=form1&Ecodigo=#Session.Ecodigo#&conexion=#Session.DSN#&EEid=#rsDatosASalarial.EEid#&p1=RHPcodigo&p2=RHPdescpuesto&dato='+dato;
		</cfoutput>
		var fr = document.getElementById('frASalarialPuesto');
		fr.src = 'analisis-salarial-puestoquery.cfm'+params;
	}

	function changeTodos(f) {
		if (f.chkTodos.checked) {
			objForm.RHPcodigo.required = false;
		} else {
			objForm.RHPcodigo.required = true;
		}
	}
	
</script>

<cfoutput>
	<form name="form1" method="post" action="analisis-salarial2-sql.cfm" style="margin: 0;">
		<cfinclude template="analisis-salarial2-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
				<td>&nbsp;</td>
				<td align="right" nowrap="nowrap"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
				<td><cf_rhcfuncional size="30"></td>
		    	<td colspan="3">
					<input name="chkDependencias" type="checkbox" id="chkDependencias" value="1"><strong>Incluir dependencias</strong>
				</td>
			</tr>	
		  	<tr>
				<td width="60">&nbsp;</td>
				<td align="right" class="fileLabel"><cf_translate key="LB_TipoDePuesto">Tipo de Puesto</cf_translate>:&nbsp;</td>
				<td nowrap>
					<cf_conlis 
						campos="RHTPid,Ecodigo, RHTPcodigo, RHTPdescripcion"
						size="0,0,10,40"
						desplegables="N,N,S,S"
						modificables="N,N,S,N"
						valuesArray=""
						title="#LB_ListaDeTiposDePuesto#"
						tabla="RHTPuestos"
						columnas="RHTPid,Ecodigo, RHTPcodigo, RHTPdescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						filtrar_por="RHTPcodigo, RHTPdescripcion"
						desplegar="RHTPcodigo, RHTPdescripcion"
						etiquetas="#LB_Codigo#, #LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignar="RHTPid,Ecodigo,RHTPcodigo, RHTPdescripcion"
						asignarFormatos="I,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoSeEncontraronRegistros# --- "/> 
					<input type="hidden" name="EEid" id="EEid" value="#rsDatosASalarial.EEid#">
				</td>
			</tr>
			<tr>
				<td width="60">&nbsp;</td>
				<td align="right" class="fileLabel"><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td>
				<td nowrap>
					<cf_conlis 
						campos="EEid,Ecodigo, RHPcodigo, RHPdescpuesto"
						size="0,0,10,40"
						desplegables="N,N,S,S"
						modificables="N,N,S,N"
						valuesArray=""
						title="#LB_ListaDePuestos#"
						tabla="RHEncuestaPuesto a
								inner join RHPuestos b
								   on b.Ecodigo = a.Ecodigo
								   and b.RHPcodigo = a.RHPcodigo"
						columnas="distinct a.EEid,a.Ecodigo, b.RHPcodigo, b.RHPdescpuesto"
						filtro="a.Ecodigo = #Session.Ecodigo#
								and a.EEid = #rsDatosASalarial.EEid#
								and not exists (
									select 1
									from RHASalarialPuestos c
									where c.RHASid = #Form.RHASid#
									and c.Ecodigo = a.Ecodigo
									and c.RHPcodigo = a.RHPcodigo
								)"
						filtrar_por="a.RHPcodigo, RHPdescpuesto"
						desplegar="RHPcodigo, RHPdescpuesto"
						etiquetas="#LB_Codigo#, #LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignar="EEid,Ecodigo,RHPcodigo, RHPdescpuesto"
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoSeEncontraronRegistros# --- "/> 

				</td>
				<td>
					<input name="chkTodos" type="checkbox" id="chkTodos" value="1" onClick="javascript: changeTodos(this.form)">
				<strong><cf_translate key="LB_IncluirTodos">Incluir Todos</cf_translate></strong></td>
			</tr>
			<tr>
				<td>&nbsp; </td>
				<td align="right" class="fileLabel"><cf_translate key="LB_Percentil">Percentil</cf_translate>:&nbsp;</td>
				<td>
					<select name="RHASPperceptil">
						<option value="1">25</option>
						<option value="2">50</option>
						<option value="3">75</option>
						<option value="4">PROM</option>
						<option value="5">VAR</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="center" colspan="3"><input type="submit" name="btnAgregar"  value="Agregar"></td>
		  </tr>
		  <tr>
		    <td colspan="6">&nbsp;</td>
	      </tr>
		</table>
	</form>

	<form name="listaPuestos" method="post" action="analisis-salarial2-sql.cfm" style="margin: 0;">
		<cfinclude template="analisis-salarial2-hiddens.cfm">
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
				<td align="right">
					<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
					<input type="checkbox" name="chkTodosP" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
				</td>
			</tr>
		  	<tr>
				<td>
					<cfset filtro = ''>
					<cfset navegacion = ''>
					<cfset filtro = filtro & ' and RHASid =' & Form.RHASid>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paso=2">
					<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHASid=" & Form.RHASid>
					</cfif>
					<cfif isdefined("Form.EEid") and Len(Trim(Form.EEid)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EEid=" & Form.EEid>
					</cfif>
					<cfif isdefined("modo") and Len(Trim(modo)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "modo=" & modo>
					</cfif>
					<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaEduRet">
							<cfinvokeargument name="tabla" value="RHASalarialPuestos a
																	inner join RHPuestos b
																		on b.Ecodigo = a.Ecodigo
																		and b.RHPcodigo = a.RHPcodigo"/>
							<cfinvokeargument name="columnas" value="a.RHASid, rtrim(b.RHPcodigo) as RHPcodigo, b.RHPdescpuesto, 
																	   case when a.RHASPperceptil = 1 then '25'
																			when a.RHASPperceptil = 2 then '50'
																			when a.RHASPperceptil = 3 then '75'
																			when a.RHASPperceptil = 4 then 'PROM'
																			when a.RHASPperceptil = 5 then 'VAR'
																	   end as RHASPperceptil"/>
							<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescpuesto, RHASPperceptil"/>
							<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_Perceptil#"/>
							<cfinvokeargument name="formatos" value="S,S,S"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by RHPcodigo, RHPdescpuesto"/>
							<cfinvokeargument name="align" value="left, left,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="analisis-salarial2.cfm"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="MaxRows" value="15"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="formName" value="form1"/>
							<cfinvokeargument name="checkboxes" value="D"/>
							<cfinvokeargument name="keys" value="RHPcodigo"/>
							<cfinvokeargument name="showlink" value="no"/>
							<cfinvokeargument name="formName" value="listaPuestos"/>
						</cfinvoke>
				</td>
		  	</tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center">
				<input type="submit" name="btnAnterior"  value="Anterior" class="btnAnterior"
					onClick="javascript: return funcAnterior2(this.form, #Form.paso#); ">
				<input type="submit" name="btnEliminar" class="btnEliminar"
					value="Eliminar" onClick="javascript: funcEliminar2(this.form, #Form.paso#); ">
				<input type="submit" name="btnSiguiente"  value="Siguiente" class="btnSiguiente" 
					onClick="javascript: return funcSiguiente2(this.form, #Form.paso#); ">
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</form>

</cfoutput>
<iframe name="frASalarialPuesto" id="frASalarialPuesto" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
<!--- 	objForm.RHPcodigo.required = true;
	objForm.RHPcodigo.description = "Puesto";
 --->
 	function hayMarcados(){
		var form = document.listaPuestos;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
		return result;
	}
	
	function funcEliminar2(){
		if (hayMarcados() && confirm('<cfoutput>#MSG_DeseaEliminarLosPuestosSeleccionados#</cfoutput>')){
			document.listaPuestos.submit();
		}else{
			return false;
		}
	}
	function funcChequeaTodos(){
		var c = document.listaPuestos.chkTodosP;
		
		if (document.listaPuestos.chk) {
			if (document.listaPuestos.chk.value) {
				if (!document.listaPuestos.chk.disabled) { 
					document.listaPuestos.chk.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.listaPuestos.chk.length; counter++) {
					if (!document.listaPuestos.chk[counter].disabled) {
						document.listaPuestos.chk[counter].checked = c.checked;
					}
				}
			}
		}
	}
	function funcAnterior2(){
		document.listaPuestos.paso.value = 1;
		document.listaPuestos.submit();
	}
	function funcSiguiente2(){
		document.listaPuestos.paso.value = 3;
		document.listaPuestos.submit();
	}

 </script>
