<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
    <cfinvoke Key="LB_nombre_proceso" Default="Calculo del Salario Base de Cotizacion (SDI)" returnvariable="LB_nombre_proceso" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
    <cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
    <cfinvoke key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Nombre" Default="Nombre" returnvariable="vNombre" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Usuario" Default="Usuario" returnvariable="LB_Usuario" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Filtrar" Default="Filtrar" returnvariable="vFiltrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_CalcularSDI" Default="Calcular SDI" returnvariable="LB_CalcularSDI" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/catalogos/expediente-cons.xml"/>
    <cfinvoke key="LB_Activos" Default="Activos" returnvariable="vActivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Inactivos" Default="Inactivos" returnvariable="vInactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Todos" Default="Todos" returnvariable="vTodos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
    <cfinvoke key="LB_Estado" Default="Estado" returnvariable="vEstado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
    <cfinvoke key="LB_Fuente" Default="Fuente" returnvariable="LB_Fuente" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
    <cfinvoke key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
    <cfinvoke key="LB_Mes" Default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
    <cfinvoke key="LB_Estado" Default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<!---<cf_dump var="#session.Ecodigo#">--->
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

					<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
						<cfif isdefined("Url.FechaFiltro") and not isdefined("Form.FechaFiltro")>
							<cfparam name="Form.FechaFiltro" default="#Url.FechaFiltro#">
						</cfif>
						<cfif isdefined("Url.FuenteFiltro") and not isdefined("Form.FuenteFiltro")>
							<cfparam name="Form.FuenteFiltro" default="#Url.FuenteFiltro#">
						</cfif>
						<cfif isdefined("Url.usuarioFiltro") and not isdefined("Form.usuarioFiltro")>
							<cfparam name="Form.usuarioFiltro" default="#Url.usuarioFiltro#">
						</cfif>
						<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
							<cfparam name="Form.filtrado" default="#Url.filtrado#">
						</cfif>
						<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
							<cfparam name="Form.DEid" default="#Url.DEid#">
						</cfif>
						<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
							<cfparam name="Form.sel" default="#Url.sel#">
						</cfif>
						<cfset filtro = "">
						<cfset navegacion = "">

						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
						<cfif isdefined("Form.FechaFiltro") and Len(Trim(Form.FechaFiltro)) NEQ 0>
							<cfset filtro = filtro & " and a.BMfecha ='"& #LSDateFormat(Form.FechaFiltro,'yyyymmdd')# & "'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FechaFiltro=" & Form.FechaFiltro>
						</cfif>
						<cfif isdefined("Form.FuenteFiltro") and Len(Trim(Form.FuenteFiltro)) NEQ 0>
							<cfset filtro = filtro & " and a.RHHfuente = " & Form.FuenteFiltro>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FuenteFiltro=" & Form.FuenteFiltro>
						</cfif>
						<cfif isdefined("Form.usuarioFiltro") and Len(Trim(Form.usuarioFiltro)) NEQ 0>
							<cfset filtro = filtro & " and b.Usulogin = " & Form.usuarioFiltro>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "usuarioFiltro=" & Form.usuarioFiltro>
						</cfif>
						<cfif isdefined("Form.sel") and form.sel NEQ 1>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>
						</cfif>
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr style="display: ;" id="verFiltroListaEmpl">
								<td> <!---
							  		<form name="formFiltroListaEmpl" method="post" action="expediente-lista.cfm">
										<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
										<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr>
												<td width="27%" height="17" class="fileLabel"><cfoutput>#LB_Fecha#</cfoutput></td>
												<td width="50%" class="fileLabel"><cfoutput>#LB_Fuente#</cfoutput></td>
												<td width="18%" class="fileLabel"><cfoutput>#LB_Usuario#</cfoutput></td>
												<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
											</tr>
											<tr>
												<td>
													<select name="FuenteFiltro" id="FuenteFiltro">
														<cfoutput>
														<option value="0" <cfif isdefined("form.FuenteFiltro") and form.FuenteFiltro eq 0>selected</cfif>>Autom&aacute;tico</option>
														<option value="1" <cfif isdefined("form.FuenteFiltro") and form.FuenteFiltro eq 1>selected</cfif>>Sistema</option>
														</cfoutput>
													</select>
												</td>
												<td><input name="FechaFiltro" 	type="text" id="FechaFiltro2" size="60" maxlength="260" value="<cfif isdefined('form.FechaFiltro')><cfoutput>#form.FechaFiltro#</cfoutput></cfif>"></td>
												<td><input name="UsuarioFiltro" type="text" id="UsuarioFiltro2" size="60" maxlength="260" value="<cfif isdefined('form.UsuarioFiltro')><cfoutput>#form.UsuarioFiltro#</cfoutput></cfif>"></td>

											</tr>
             				 			</table>
          						  	</form>
							  	--->
                                </td>
						  	</tr>

        				  	<tr style="display: ;" id="verLista">
          				  		<td>
                                	<!---<cfset navegacion = "">

                                    <cfif isdefined("form.fTipo") and len(trim(form.fTipo)) NEQ 0 and form.fTipo NEQ 'T'>
                                           <cfset ffiltro = ffiltro & " and Ctipo = '" & form.fTipo & "'">
                                           <cfset navegacion = navegacion & "&fTipo=#trim(form.fTipo)#">
                                    </cfif>--->


									<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  		<tr>
											<td>

												<cfquery name="rsLista" result="rsLista_PlistaResult_" datasource="#session.DSN#">
													select distinct <cf_dbfunction name="date_format"	args="a.BMfecha,dd/mm/yyyy" > as BMfecha,
													case when a.RHHfuente = 0 then 'Indefinido'
                                                    	 when a.RHHfuente = 1 then 'Nombramiento'
                                                         when a.RHHfuente = 2 then 'Bimestral'
														 when a.RHHfuente = 3 then 'Aniversario'
														 when a.RHHfuente = 4 then 'Aumento'
                                                    end as RHHfuente,
													a.BMUsucodigo,
													b.Usulogin,
													a.RHHperiodo,
													a.RHHmes,
                                                    case when a.RHHaplicado  = 1 then 'Aplicado'
                                                    	 when a.RHHaplicado  = 0 then 'No Aplicado'
                                                    end as estado
													FROM RHHistoricoSDI a
														inner join Usuario b
															on b.Usucodigo = a.BMUsucodigo
													where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													and a.RHHfuente <> 3
													<cfif isdefined("filtro") and len(trim(filtro))>
														#PreserveSingleQuotes(filtro)#
													</cfif>
													order by RHHperiodo desc,BMfecha desc
													<!---order By a.BMfecha DESC--->
												</cfquery>


												<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpl">
                                                    <cfinvokeargument name="query" value="#rsLista#"/>
                                                    <cfinvokeargument name="useAJAX" value="yes">
                                                    <cfinvokeargument name="queryresult" value="#rsLista_PlistaResult_#">
                                                    <cfinvokeargument name="datasource" value="#session.DSN#">
                                                    <cfinvokeargument name="desplegar" value="BMfecha,Usulogin,RHHperiodo,RHHmes, estado"/>
                                                    <cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Usuario#,#LB_Periodo#,#LB_Mes#,#LB_Estado#"/>
                                                    <cfinvokeargument name="align" value="left,left,left,left,left"/>
                                                    <cfinvokeargument name="formatos" value=""/>
                                                    <cfinvokeargument name="formName" value="listaEmpleados"/>
                                                    <cfinvokeargument name="ajustar" value="N"/>
                                                    <cfinvokeargument name="irA" value="HistoricoSDI.cfm"/>
                                                    <cfinvokeargument name="navegacion" value="#navegacion#"/>
                                                    <cfinvokeargument name="keys" value="BMfecha,RHHfuente,Usulogin,RHHperiodo,RHHmes,estado"/>
												</cfinvoke>
											</td>
								  		</tr>
			  					  		<tr>
								  			<td align="center">
												<form name="formNuevoEmplLista" method="post" action="CalculoSDI.cfm">
													<input type="hidden" name="o" value="1">
													<input type="hidden" name="sel" value="1">

													<input name="btnCalcularSDI" class="btnCalcularSDI" type="submit" value="<cfoutput>#LB_CalcularSDI#</cfoutput>">
												</form>
											</td>
			 							</tr>
									</table>
		 				 		</td>
        					</tr>
     			 		</table>
				<script language="JavaScript" type="text/javascript">
                    var Bandera = "L";
                    function limpiaFiltrado(){
                        document.formFiltroListaEmpl.filtrado.value = "";
                        document.formFiltroListaEmpl.sel.value = 0;
                    }
				</script>
			<cf_web_portlet_end>
		</td>
	</tr>
</table>
<cf_templatefooter>
