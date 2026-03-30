<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Seguimiento de Acciones a Seguir"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Empleado"
			Default="Empleado"	
			returnvariable="LB_Empleado"/>						
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Todos"
			Default="Todos"	
			returnvariable="LB_Todos"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"	
			returnvariable="BTN_Filtrar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"	
			returnvariable="LB_Fecha"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Tipo"
			Default="Tipo"	
			returnvariable="LB_Tipo"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Supervisor"
			Default="Supervisor"	
			returnvariable="LB_Supervisor"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Anotacion"
			Default="Anotación"	
			returnvariable="LB_Anotacion"/>			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Accion"
			Default="Acción"	
			returnvariable="LB_Accion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Anotar"
			Default="Anotar en expediente y cerrar"	
			returnvariable="BTN_Anotar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar seguimiento sin anotaci&oacute;n"	
			returnvariable="BTN_Cerrar"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ConfirmaAnotar"
			Default="Desea procesar los registros seleccionados"	
			returnvariable="MSG_ConfirmaAnotar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ConfirmaCerrar"
			Default="Desea cerrar las anotaciones seleccionadas"	
			returnvariable="MSG_ConfirmaCerrar"/>
		
		<cfquery name="rsGrupos" datasource="#session.DSN#">
			select  b.Gid, b.Gdescripcion
			from RHCMGrupos b					
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfset navegacion = ''>
		<cfset arrayEmpleado = ArrayNew(1)>
		<cfset vnMaxrows = 50>
		
		<cfif isdefined("url.btnFiltrar")>
			<cfset form.btnFiltrar = url.btnFiltrar>
		</cfif>
		<cfif isdefined("form.btnFiltrar")>
			<cfset navegacion = navegacion & '&btnFiltrar'>
		</cfif>
		<cfif isdefined("url.FDEid") and len(trim(url.FDEid)) and not isdefined("form.FDEid")>
			<cfset form.FDEid = url.FDEid>	
		</cfif>
		<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FDEid=" & Form.FDEid>
			<cfset ArrayAppend(arrayEmpleado, form.FDEid)>
		</cfif>
		<cfif isdefined("url.FDEIdentificacion") and len(trim(url.FDEIdentificacion)) and not isdefined("form.FDEIdentificacion")>
			<cfset form.FDEIdentificacion = url.FDEIdentificacion>	
		</cfif>
		<cfif isdefined("form.FDEIdentificacion") and len(trim(form.FDEIdentificacion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FDEIdentificacion=" & Form.FDEIdentificacion>
			<cfset ArrayAppend(arrayEmpleado, form.FDEIdentificacion)>
		</cfif>
		<cfif isdefined("url.FNombre") and len(trim(url.FNombre)) and not isdefined("form.FNombre")>
			<cfset form.FNombre = url.FNombre>	
		</cfif>
		<cfif isdefined("form.FNombre") and len(trim(form.FNombre))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FNombre=" & Form.FNombre>
			<cfset ArrayAppend(arrayEmpleado, form.FNombre)>
		</cfif>
		<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
			<cfset form.Grupo = url.Grupo>	
		</cfif>
		<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
		</cfif>				
		<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio)) and not isdefined("form.fechaInicio")>
			<cfset form.fechaInicio = url.fechaInicio>	
		</cfif>
		<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaInicio=" & Form.fechaInicio>
			<cfset fechaInicio = form.fechaInicio>
		</cfif>			
		<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
			<cfset form.fechaFinal = url.fechaFinal>	
		</cfif>
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaFinal=" & Form.fechaFinal>
			<cfset fechaFinal = form.fechaFinal>
		</cfif>		
		<cfif isdefined("url.RHASnegativo") and len(trim(url.Estado)) and not isdefined("form.RHASnegativo")>
			<cfset form.RHASnegativo = url.RHASnegativo>	
		</cfif>
		<cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "RHASnegativo=" & Form.RHASnegativo>
		</cfif>	
		
		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<form name="form1" action="SeguimientoAcciones-sql.cfm" method="post">					
					<input  type="hidden" name="tab" value="1">
					<table width="100%" cellpadding="3" cellspacing="0">
						<tr>
							<td>
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td width="14%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
										<td colspan="4">
											<cfif isdefined("form.DEid") and len(trim(form.DEid))>
												<cfquery name="rsEmpleado" datasource="#session.DSN#">
													select 	DEid, 
															{fn concat({fn concat({fn concat({ fn concat(DEnombre, ' ') },DEapellido1)}, ' ')},DEapellido2) } NombreEmp,
															DEidentificacion,					
															NTIcodigo
													from DatosEmpleado
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
												</cfquery>
												<cf_rhempleado form="form1" size="60" query="#rsEmpleado#" tabindex="1">
											<cfelse>
												<cf_rhempleado form="form1" size="60" tabindex="1">												
											</cfif>
										</td>
									</tr>
									<tr>										
										<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaInicial">Fecha inicial</cf_translate>:&nbsp;</strong></td>
										<td width="20%" nowrap>
											<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
												<cf_sifcalendario  tabindex="2" form="form1" name="fechaInicio" value="#LSDateFormat(form.fechaInicio,'dd/mm/yyyy')#">
											<cfelse>
												<cf_sifcalendario  tabindex="2" form="form1" name="fechaInicio">
											</cfif>
										</td>
										<td width="19%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
										<td width="34%">
											<cfoutput><select name="Grupo" tabindex="3">
												<option value="">--- #LB_Todos# ---</option>
												<cfloop query="rsGrupos">
													<option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
												</cfloop>
											</select></cfoutput>
										</td>
										<td width="13%">
											<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#" onClick="javascript: funcDeshabilitar(); document.form1.action = ''; ">
										</td>
									</tr>
									<tr>
										<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaFinal">Fecha final</cf_translate>:&nbsp;</strong></td>										
										<td nowrap>
											<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
												<cf_sifcalendario  tabindex="2" form="form1" name="fechaFinal" value="#LSDateFormat(form.fechaFinal,'dd/mm/yyyy')#">
											<cfelse>
												<cf_sifcalendario  tabindex="2" form="form1" name="fechaFinal">
											</cfif>
										</td>
										<td width="19%" align="right" nowrap><strong><cf_translate key="LB_TipoAccionSeguir">Tipo de acci&oacute;n a seguir</cf_translate>:&nbsp;</strong></td>										
										<td>
											<select name="RHASnegativo" tabindex="5">
												<option value="">--- #LB_Todos# ---</option>
												<option value="0" <cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo)) and form.RHASnegativo EQ 0>selected</cfif>><cf_translate key="LB_Positivos">Positivos</cf_translate></option>
												<option value="1" <cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo)) and form.RHASnegativo EQ 1>selected</cfif>><cf_translate key="LB_Negativos">Negativos</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>									
								</table>
							</td>
						</tr>
						<!----LISTA---->
						<tr>
							<td>
								<input type="checkbox" name="chkTodos" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
								<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
							</td>
						</tr>
						<tr>
							<td align="center">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr><td>
										<cfquery name="rsLista" datasource="#session.DSN#">
											select 	a.CMBfecha,
													a.CMBid,
													e.RHASdescripcion,
													{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado,
													case e.RHASnegativo when 0 then '+' else '-' end as Tipo,
													{fn concat({fn concat({fn concat({fn concat(d.Papellido1 , ' ' )}, d.Papellido2 )},  ' ' )}, d.Pnombre)} as Supervisor,
													{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/iindex.gif'' onClick="javascript: return funcAnotaciones(', '''')}, <cf_dbfunction name="to_char" args="a.CMBid"> )}, ''');">') } as Anotaciones
											from RHCMBitacoraAccionesSeguir a
												inner join DatosEmpleado b
													on a.DEid = b.DEid
											
												inner join Usuario c
													on a.UsucodigoSup = c.Usucodigo
													
													inner join DatosPersonales d
														on c.datos_personales = d.datos_personales
											
												inner join RHAccionesSeguir e
													on a.RHASid = e.RHASid
													<cfif isdefined("form.RHASnegativo") and len(trim(form.RHASnegativo))>
														and e.RHASnegativo = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.RHASnegativo#">
													</cfif>
											
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and CMBestado = 'A'		
												<cfif isdefined("form.DEid") and len(trim(form.DEid))>
													and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
												</cfif>
												<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
													and exists (select 1
																from RHCMEmpleadosGrupo f
																where a.DEid = f.DEid
																	and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">)
												</cfif>																									
												<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) and isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
													<cfif form.fechaInicio GT form.fechaFinal>
														and a.CMBfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaFinal#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaInicio#">
													<cfelseif form.fechaFinal GT form.fechaInicio>
														and a.CMBfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaInicio#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaFinal#">
													<cfelse>
														and a.CMBfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaInicio#">
													</cfif>
												<cfelseif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) and (not isdefined("form.fechaFinal") or  len(trim(form.fechaFinal)) EQ 0)>
													and a.CMBfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaInicio#">
												<cfelseif isdefined("form.fechaFinal") and len(trim(form.fechaFinal)) and (not isdefined("form.fechaInicio") or  len(trim(form.fechaInicio)) EQ 0)>
													and a.CMBfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaFinal#">
												</cfif>	
											order by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}, a.CMBfecha
										</cfquery>

										<cfinvoke 
											 component="rh.Componentes.pListas"
											 method="pListaQuery"
											  returnvariable="pListaEmpl">
												<cfinvokeargument name="query" value="#rsLista#"/>
												<cfinvokeargument name="desplegar" value="Empleado,CMBfecha,Tipo,RHASdescripcion,Supervisor,Anotaciones"/>
												<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_Fecha#,#LB_Tipo#,#LB_Accion#,#LB_Supervisor#,#LB_Anotacion#"/>
												<cfinvokeargument name="formatos" value="V,D,V,V,V,V"/>
												<cfinvokeargument name="align" value="left,left,center,left,left,center"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="checkboxes" value="S"/>
												<cfinvokeargument name="irA" value=""/>
												<cfinvokeargument name="keys" value="CMBid"/>
												<cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
												<cfinvokeargument name="incluyeForm" value="false"/>
												<cfinvokeargument name="formName" value="form1"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="showEmptyListMsg" value="yes"/>
										</cfinvoke>	
									</td></tr>										
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<cfif isdefined("rsLista") and rsLista.RecordCount NEQ 0>
							<tr>
								<td align="center">
									<table width="50%" cellpadding="0" cellspacing="0" align="center">
										<tr>
											<td width="46%">
												<input type="submit" name="btnAnotar" value="#BTN_Anotar#" onClick="javascript: if ( confirm('#MSG_ConfirmaAnotar#') ){funcHabilitar();}else{return false;}">
											</td>
											<td width="54%">
												<input type="submit" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript: if ( confirm('#MSG_ConfirmaCerrar#') ){funcHabilitar();}else{return false;}">	
											</td>
										</tr>
								  </table>
								</td>
							</tr>	
						</cfif>						
					</table>
				</form>
			</cfoutput>						
		<cf_web_portlet_end>

		<cf_qforms form="form1">
		<script type="text/javascript" language="javascript1.2">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function funcAnotaciones(prn_CMBid){
				document.form1.nosubmit = true;
				popUpWindow("/cfmx/rh/marcas/operacion/PopUp-AnotacionesSeguimiento.cfm?CMBid="+prn_CMBid,150,200,700,300);	
			}
			
			function funcDeshabilitar(){
				<cfif isdefined("form.btnFiltrar") and isdefined("rsLista") and rsLista.RecordCount NEQ 0>
					objForm.chk.required = false;			
				</cfif>
			}
			function funcHabilitar(){
				objForm.chk.description="<cfoutput>#LB_Accion#</cfoutput>";
				objForm.chk.required = true;			
			}

			function funcChequeaTodos(){		
				if (document.form1.chkTodos.checked){			
					if (document.form1.chk && document.form1.chk.type) {						
						if (!document.form1.chk.disabled){
							document.form1.chk.checked = true
						}
					}
					else{
						if (document.form1.chk){
							for (var i=0; i<document.form1.chk.length; i++) {
								if (!document.form1.chk[i].disabled){
									document.form1.chk[i].checked = true	
								}				
							}
						}
					}
				}	
				else{
					<cfset url.Todos = 0>
					if (document.form1.chk && document.form1.chk.type) {
						document.form1.chk.checked = false
					}
					else{
						if (document.form1.chk){
							for (var i=0; i<document.form1.chk.length; i++) {
								document.form1.chk[i].checked = false					
							}
						}
					}
				}
			}
			function funcMarcar(){
				var chequeados =0
				if (document.form1.chk && document.form1.chk.type) {
					if(document.form1.chk.checked){
						document.form1.chkTodos.checked = true
					}
					else{
						if (document.form1.chk){
							document.form1.chkTodos.checked = false
						}	
					}
				}
				else{					
					if (document.form1.chk){
						for (var i=0; i<document.form1.chk.length; i++) {
							if(document.form1.chk[i].checked){
								chequeados=chequeados+1
							}				
						}
					}
					if (document.form1.chk){
						if(document.form1.chk.length == chequeados){
							document.form1.chkTodos.checked = true
						}
						else{
							document.form1.chkTodos.checked = false
						}
					}
				}
			}
		</script>	
<cf_templatefooter>	