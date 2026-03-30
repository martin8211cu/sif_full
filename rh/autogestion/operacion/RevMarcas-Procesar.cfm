<!--- 
	**********************
	RevMarcas-Procesar.cfm
	Procesamiento       de
	Marcas  por  parte del
	Supervisor.
	Creado  el: 16/10/2006
	Creado por:     Dorian
	Abarca Gómez (DAG).
	**********************
Comportamiento estándard del proceso (copiado del tab de Agrupamiento) --->
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<!--- Obtiene las traducciones de textos de las pantallas --->
<cfinclude template="RevMarcas-ProcesarTranslate.cfm">
<!--- Consultas para los filtros --->
<cfquery name="rsGrupos" datasource="#session.DSN#">
	select  b.Gid, b.Gdescripcion
	from RHCMAutorizadoresGrupo a
		inner join RHCMGrupos b
			on a.Gid = b.Gid
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfif rsGrupos.recordcount eq 0>
	<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
<cfelseif rsGrupos.recordcount eq 1>
	<cfparam name="Form.FAGrupo" default="#rsGrupos.Gid#">
</cfif>
<cfquery name="rsJornadas" datasource="#session.DSN#">
	select RHJid,RHJcodigo, RHJdescripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- Vaiables Locales del Proceso --->
<cfset Lvar_navegacion = 'tab=3'>
<cfset Lvar_vnMaxrows = 50>
<cfset Lvar_FAfechaInicial = ''>
<cfset Lvar_FAfechaFinal = DateFormat(Now(),'dd/mm/yyyy')>
<!--- Tratamiento de variables de Filtro (Se agregan a form cuando vienen en url y carga 
Lvar_navegacion) Ademaas se cargan algunas variables locales referentes a los filtros. --->
<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
	<cfset form.Grupo = url.Grupo>
</cfif>
<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
</cfif>
<cfif isdefined("url.FAfechaInicial") and len(trim(url.FAfechaInicial)) and not isdefined("form.FAfechaInicial")>
	<cfset form.FAfechaInicial = url.FAfechaInicial>
</cfif>
<cfif isdefined("form.FAfechaInicial") and len(trim(form.FAfechaInicial))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "FAfechaInicial=" & Form.FAfechaInicial>
	<cfset Lvar_FAfechaInicial = form.FAfechaInicial>
</cfif>
<cfif isdefined("url.FAfechaFinal") and len(trim(url.FAfechaFinal)) and not isdefined("form.FAfechaFinal")>
	<cfset form.FAfechaFinal = url.FAfechaFinal>
</cfif>
<cfif isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "FAfechaFinal=" & Form.FAfechaFinal>
	<cfset Lvar_FAfechaFinal = form.FAfechaFinal>
</cfif>
<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) and not isdefined("form.RHJid")>
	<cfset form.RHJid = url.RHJid>
</cfif>
<cfif isdefined("url.btnFAFiltrar")>
	<cfset form.btnFAFiltrar = url.btnFAFiltrar>
</cfif>
<cfif isdefined("form.btnFAFiltrar")>
	<cfset Lvar_navegacion = Lvar_navegacion & '&btnFAFiltrar'>
</cfif>
<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "RHJid=" & Form.RHJid>
</cfif>
<cfif isdefined("url.FADEid") and len(trim(url.FADEid)) and not isdefined("form.FADEid")>
	<cfset form.FADEid = url.FADEid>
</cfif>
<cfif isdefined("form.FADEid") and len(trim(form.FADEid))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "FADEid=" & Form.FADEid>
</cfif>
<cfif isdefined("url.FAver") and len(trim(url.FAver)) and not isdefined("form.FAver")>
	<cfset form.FAver = url.FAver>
</cfif>
<cfif isdefined("form.FAver") and len(trim(form.FAver))>
	<cfset Lvar_navegacion = Lvar_navegacion & Iif(Len(Trim(Lvar_navegacion)), DE("&"), DE("")) & "FAver=" & Form.FAver>
	<cfset Lvar_vnMaxrows = form.FAver>
</cfif>
<!--- Consulta con base en los filtros dados --->
<cfinclude template="RevMarcas-ProcesarQuery.cfm">
<!--- Filtro y Lista se pintan ambos dentro de 1 solo formulario para solucionar el problema de navegacioon de los filtros manuales --->
<form name="form3" action="RevMarcas-tabs.cfm" method="post" style="margin:0px;">
	<!--- Filtro --->
	<cfoutput>
	<input  type="hidden" name="tab" value="3">
	<table width="100%" border="0" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<fieldset style="text-indent:inherit">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" nowrap><strong>#LB_Grupo#:&nbsp;</strong></td>
						<td>
							<cfif rsGrupos.RecordCount LTE 1>
								<input type="hidden" name="FAGrupo" value="#rsGrupos.Gid#">
								#rsGrupos.Gdescripcion#
							<cfelse>
								<select name="FAGrupo" tabindex="1">
									<option value="">--- #LB_Todos# ---</option>
									<cfloop query="rsGrupos">
										<option value="#rsGrupos.Gid#" <cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo)) and form.FAGrupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
									</cfloop>
								</select>
							</cfif>
						</td>
						<td align="right" nowrap><strong>#LB_FechaInicial#:&nbsp;</strong></td>
						<td>
							<cf_sifcalendario  tabindex="2" form="form3" name="FAfechaInicial" value="#Lvar_FAfechaInicial#">
						</td>
						<td>
							<cf_botones names="btnFAFiltrar,btnFAReporte" values="#BTN_Filtrar#,#BTN_Reporte#" tabindex="3">
						</td>								
					</tr>
					<tr>									
						<td align="right" nowrap><strong>#LB_Jornada#:&nbsp;</strong></td>
						<td>
							<select name="RHJid" tabindex="1">
								<option value="">--- #LB_Todos# ---</option>
								<cfloop query="rsJornadas">
									<option value="#rsJornadas.RHJid#" <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) and form.RHJid EQ rsJornadas.RHJid>selected</cfif>>#rsJornadas.RHJcodigo# - #rsJornadas.RHJdescripcion#</option>
								</cfloop>
							</select>
						</td>
						<td align="right" nowrap><strong>#LB_FechaFinal#:&nbsp;</strong></td>										
						<td>
							<cf_sifcalendario  tabindex="2" form="form3" name="FAfechaFinal" value="#Lvar_FAfechaFinal#">
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="right" nowrap><strong>#LB_Empleado#:&nbsp;</strong></td>
						<td>
							<cfset FAarrayEmpleado = ArrayNew(1)>
							<cfif isdefined("form.FADEid") and len(trim(form.FADEid)) gt 0>
								<cfquery name="rsFAEmpleado" datasource="#session.dsn#">
									select c.DEid as FADEid, c.DEidentificacion as FADEidentificacion, {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as FANombre
									from DatosEmpleado c
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FADEid#">
								</cfquery>
								<cfset ArrayAppend(FAarrayEmpleado,rsFAEmpleado.FADEid)>
								<cfset ArrayAppend(FAarrayEmpleado,rsFAEmpleado.FADEidentificacion)>
								<cfset ArrayAppend(FAarrayEmpleado,rsFAEmpleado.FANombre)>
							</cfif>
							<cf_conlis
							   campos="FADEid,FADEidentificacion,FANombre"
							   desplegables="N,S,S"
							   modificables="N,S,N"
							   size="0,20,40"
							   title="#LB_ListaDeEmpleados#"
							   tabla=" RHCMAutorizadoresGrupo a
										inner join RHCMEmpleadosGrupo b
											on a.Gid = b.Gid
											and a.Ecodigo = b.Ecodigo
											
											inner join DatosEmpleado c
												on b.DEid = c.DEid
												and b.Ecodigo = c.Ecodigo"
							   columnas="b.DEid as FADEid, c.DEidentificacion as FADEidentificacion, {fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as FANombre"
							   filtro="a.Ecodigo = #session.Ecodigo#
										and a.Usucodigo = #session.Usucodigo#"
							   desplegar="FADEidentificacion,FANombre"
							   filtrar_por="c.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)}"
							   filtrar_por_delimiters="|"
							   etiquetas="#LB_Identificacion#,#LB_Empleado#"
							   valuesArray="#FAarrayEmpleado#"
							   formatos="S,S"
							   align="left,left"
							   form="form3"
							   asignar="FADEid,FADEidentificacion,FANombre"
							   asignarformatos="S,S,S"
							   showEmptyListMsg="true"
							   EmptyListMsg="-- #LB_NoSeEncontraronRegistros# --"
							   tabindex="1">
						</td>
						<td width="15%" align="right"><strong><cf_translate key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>
						<td>
							<cf_inputNumber name="FAver" 
								value="#Lvar_vnMaxrows#" 
								enteros="3" 
								tabindex="2">
						</td>
						<td>&nbsp;</td>
					</tr>								
					<tr><td colspan="5" align="right" style="color: ##FF0000 ">#LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes#&nbsp;</td></tr>
					<tr><td colspan="5" align="right" style="color: ##00CC00 ">#LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas#&nbsp;</td></tr>
                    <tr><td>&nbsp;</td></tr>
				</table>
				</fieldset>
			</td>
		</tr>	
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		<td>
			<input 
				type="checkbox" 
				id="chkTodos" 
				name="chkTodos" 
				value="" 
				onclick="javascript: funcChequeaTodos();"
				tabindex="4">
			<label for="chkTodos"><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></label>
		</td>
	  </tr>
	</table>
	</cfoutput>
	<!--- Lista --->
	<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		  returnvariable="pListaEmpl">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Empleado,CAMfdesde,CAMfhasta,Jornada,HT,HO,HL,HR,HN,HEA,HEB,MFeriado,permiso"/>
			<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_FDesde#,#LB_FHasta#,#LB_Jornada#,#LB_HT#,#LB_HO#,#LB_HL#,#LB_HR#,#LB_HN#,#LB_HEA#,#LB_HEB#,#LB_MFeriado#,#LB_Permiso#"/>
			<cfinvokeargument name="formatos" value="V,D,D,V,M,M,M,M,M,M,M,M,S,S"/>
			<cfinvokeargument name="align" value="left,left,left,left,center,center,center,center,center,center,center,left,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="funcion" value="funcModificar"/>
			<cfinvokeargument name="fparams" value="CAMid,CAMpermiso"/>
			<cfinvokeargument name="irA" value="RevMarcas-tabs.cfm"/>
			<cfinvokeargument name="keys" value="CAMid"/>
			<cfinvokeargument name="maxRows" value="#Lvar_vnMaxrows#"/>
			<cfinvokeargument name="incluyeForm" value="false"/>
			<cfinvokeargument name="formName" value="form3"/>
			<cfinvokeargument name="navegacion" value="#Lvar_navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			<!---<cfinvokeargument name="checkbox_function" value="funcChequeaUno(this.checked)"/>--->
			<cfinvokeargument name="botones" value="Eliminar,Generar"/>
			<cfinvokeargument name="inactivecol" value="inactivecol"/>
            <cfinvokeargument name="lineaRoja" value="inconsistencia"/>
			<cfinvokeargument name="lineaVerde" value="marcaIgual"/>
	</cfinvoke>	
</form>
<cfoutput><script language="javascript" type="text/javascript">
	/*instancia de las pantallas emergentes de generar y modificar 
	se maneja solo una porque no tiene sentido estar modificando un 
	registro y genearando al mismo tiempo.
	*/
	var popUpWindowRMProcesar=0;
	/*asigna el foco al primer objeto activo de la pantalla*/
	<cfif rsGrupos.RecordCount GT 1>
		document.form3.FAGrupo.focus();
	<cfelse>
		document.form3.RHJid.focus();
	</cfif>
	/*levanta una pantalla emergente con las dimenciones dadas*/
	function funcPopUpWindowRMProcesar(URLStr, left, top, width, height, scrollbars){
		if(popUpWindowRMProcesar){
			if(!popUpWindowRMProcesar.closed) 
				popUpWindowRMProcesar.close();
		}
		popUpWindowRMProcesar = open(URLStr, 'popUpWindowRMProcesar', 'toolbars=no, location=no, directories=no, status=no, menubars=no, scrollbars='+scrollbars+', resizable=yes, copyhistory=yes, width='+width+', height='+height+', left='+left+', top='+top+', screenX='+left+', screenY='+top);
	}
	/*sincroniza los check boxes individuales con el check box de todos, al hacer click en el check box de todos*/
	/*function funcChequeaTodos(vchecked){
		if (document.form3.chk && document.form3.chk.type) {						
			document.form3.chk.checked = vchecked;
		}
		else if (document.form3.chk) {
			for (var i=0; i<document.form3.chk.length; i++) {
				alert(eval('document.form3.CAMPERMISO_'+i+'.value'));
				document.form3.chk[i].checked = vchecked;
			}
		}
	}*/
		function funcChequeaTodos(){		
				if (document.form3.chkTodos.checked){			
					if (document.form3.chk && document.form3.chk.type) {						
						if (!document.form3.chk.disabled){
							document.form3.chk.checked = true
						}
					}
					else{
						if (document.form3.chk){
							for (var i=0; i<document.form3.chk.length; i++) {
								if (!document.form3.chk[i].disabled){
									document.form3.chk[i].checked = true	
								}				
							}
						}
					}
				}	
				else{
					<cfset url.Todos = 0>
					if (document.form3.chk && document.form3.chk.type) {
						document.form3.chk.checked = false
					}
					else{
						if (document.form3.chk){
							for (var i=0; i<document.form3.chk.length; i++) {
								document.form3.chk[i].checked = false					
							}
						}
					}
				}
			}
	/*sincroniza el check box de todos con los individuales, al hacer click en uno individual*/
	function funcChequeaUno(vchecked){ 
		if (vchecked) {
			if (document.form3.chk && document.form3.chk.type) {
				vchecked = document.form3.chk.checked;
			}
			else if (document.form3.chk) {
				for (var i=0; i<document.form3.chk.length; i++) {
					if (!document.form3.chk[i].checked){
						vchecked = false;
						break;
					}
				}
			}
		}
		document.form3.chkTodos.checked = vchecked;
	}
	/*valida que al filtrar no pueda ir un valor en el campo ver que sea mayor que 500 registros*/
	function funcbtnFAFiltrar() {
		if (document.form3.FAver.value > 500) {
			alert('#MSG_CantidadMayor#'); 
			document.form3.FAver.value = 500; 
			return false;
		}
	}
	function funcbtnFAReporte() {
		funcPopUpWindowRMProcesar("RevMarcas-ProcesarReporte-PopUp.cfm",50,50,1000,800,'yes');
		return false;
	}
	/*solicita confirmacioon al usuario antes de enviar al sql (RevMarcas-Procesar-sql.cfm) que se encargaría de
	eliminar  los  registros  marcados  (quita  el  numlote  a  las marcas y elimina el registros del caalculo)*/
	function funcEliminar() {
		if (confirm('#MSG_ConfirmaEliminar#')) {
			document.form3.action = "RevMarcas-Procesar-sql.cfm";
			return true;
		}
		return false;
	}
	/*lavanta una ventana emergen con una pantalla para capturar los parámetros de generacioon*/
	function funcGenerar() {
		funcPopUpWindowRMProcesar("RevMarcas-ProcesarGenerarPopUp.cfm",100,100,600,400,'no');
		return false;
	}
	/*lavanta una ventana emergen con una pantalla para capturar los parámetros de modificacioon*/
	function funcModificar(CAMid,Permiso) {
		if (Permiso == 0){
		funcPopUpWindowRMProcesar("RevMarcas-ProcesarModificarPopUp.cfm?CAMid="+CAMid,100,100,600,400,'no');
		}
		return false;
	}
</script></cfoutput>