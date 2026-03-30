<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate XmlFile="/rh/generales.xml" key="LB_RecursosHumanos" >Recursos Humanos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			<td valign="top">					  <cfif isdefined("Url.TDid") and len(trim(Url.TDid)) NEQ 0 and not isdefined("form.TDid")>
						<cfset form.TDid = Url.TDid>
					  </cfif>					  <cfparam name="form.TDid" type="numeric">
					  <cfquery name="rsTDeduccion" datasource="#session.DSN#">
						  select TDdescripcion
							from TDeduccion
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						    and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#"> 
					  </cfquery>					  <cfif isdefined("rsTDeduccion") and rsTDeduccion.RecordCount neq 0 and not isdefined("form.TDdescripcion")>
						  <cfset form.TDdescripcion = rsTDeduccion.TDdescripcion>
						</cfif>
					  <script language="JavaScript1.2" type="text/javascript">
							function limpiar2(){
								document.filtro.Identificacion_filtro.value = "";
								document.filtro.Nombre_filtro.value   = "";
							}
						</script>
					  <cfset filtro = "">					  <cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 >
						  <cfset filtro = filtro & " and b.Pid like '%" & trim(form.Identificacion_filtro) & "%'">
						</cfif>					  <cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 >
							<cfset filtro = filtro & " and upper(rtrim(ltrim( {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )}  ))) like '%#ucase(form.Nombre_filtro)#%' " >
						</cfif>
					  <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Cat&aacute;logo de Tipos de Deducci&oacute;n por Usuario">
						  <cfset regresar = "/cfmx/rh/admin/catalogos/TipoDeduccion.cfm">
						  <cfset navBarItems = ArrayNew(1)>
						  <cfset navBarLinks = ArrayNew(1)>
						  <cfset navBarStatusText = ArrayNew(1)>			 
						  <cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
						  <cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
						  <cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
						  <cfinclude template="/rh/portlets/pNavegacion.cfm">
						  
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_identifica"
							Default="Identificaci&oacute;n"
							returnvariable="LB_identifica"/>
				
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Nombre"
							Default="Nombre"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_Nombre"/>						  

						  <table width="100%" border="0" cellpadding="0" cellspacing="0">
							  <tr>
								  <td align="center" colspan="2"><strong><font size="2"> Permiso a Usuarios del Tipo de Deducci&oacute;n: </font></strong> <font size="2"><cfoutput>#form.TDdescripcion#</cfoutput></font>
								  </td>
							  </tr>
							  <tr>
								  <td colspan="2">&nbsp;
								  </td>
							  </tr>
							  <tr>
								  <td valign="top" width="40%">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Filtrar"
											Default="Filtrar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Filtrar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>										  
										  
										  <form style="margin:0;" name="filtro" method="post">
											  <table border="0" width="100%" class="areaFiltro">
											    <tr> 
												  <td><strong><cfoutput>#LB_identifica#</cfoutput>:</strong></td>
												  <td><strong><cfoutput>#LB_Nombre#</cfoutput>:</strong></td>
											    </tr>
											    <tr> 
												  <td><input type="text" name="Identificacion_filtro" value="<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 ><cfoutput>#form.Identificacion_filtro#</cfoutput></cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" ></td>
												  <td><input type="text" name="Nombre_filtro" value="<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 ><cfoutput>#form.Nombre_filtro#</cfoutput></cfif>" size="50" maxlength="60" onFocus="javascript:this.select();" ></td>
												  <td nowrap><input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
												  <input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar2();"></td>
											    </tr>
											  </table>
											  <input type="hidden" id="TDid" name="TDid" value="<cfif isdefined("form.TDid") and len(trim(form.TDid)) neq 0><cfoutput>#form.TDid#</cfoutput></cfif>">
									    </form>						
									  <!--- Lista de Usuarios que tienen permisos --->
									  <cfquery name="rsUsuariosTipoDeduccion" datasource="#Session.DSN#">
										  select distinct Usucodigo
											from RHUsuarioTDeduccion
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">
									  </cfquery>
										
									  <cfif rsUsuariosTipoDeduccion.recordCount GT 0>
										  <cfset filtro = filtro & " and a.Usucodigo in (#ValueList(rsUsuariosTipoDeduccion.Usucodigo, ',')#)">
										<cfelse>
										  <cfset filtro = filtro & " and a.Usucodigo = 0">
									  </cfif>


									  
										
									  <cfinvoke 
										 component="rh.Componentes.pListas"
										 method="pListaRH"
										 returnvariable="pListaRet">
										  <cfinvokeargument name="tabla" value="Usuario a, DatosPersonales b"/>
										  <cfinvokeargument name="columnas" value="a.Usucodigo, b.Pid,{fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} as nombre, '#Form.TDid#' as TDid"/>
										  <cfinvokeargument name="desplegar" value="Pid, nombre"/>
										  <cfinvokeargument name="etiquetas" value="#LB_identifica#,#LB_Nombre#"/>
										  <cfinvokeargument name="formatos" value="V, V"/>
										  <cfinvokeargument name="filtro" value="a.CEcodigo = #Session.CEcodigo#
																				  and a.Uestado = 1 
																				  and a.Utemporal = 0
																				  and a.datos_personales = b.datos_personales 
																				  #filtro# 
																				  order by b.Papellido1, b.Papellido2, b.Pnombre"/>
										  <cfinvokeargument name="align" value="left, left"/>
										  <cfinvokeargument name="ajustar" value="N"/>
										  <cfinvokeargument name="checkboxes" value="N"/>
										  <cfinvokeargument name="debug" value="N"/>
										  <cfinvokeargument name="irA" value="TipoDeduccionPermiso.cfm"/>
										  <cfinvokeargument name="conexion" value="asp"/>
									  </cfinvoke>
								  </td>
								  <td width="60%" valign="top">
									  <input type="hidden" id="TDdescripcion" name="TDdescripcion" value="<cfif isdefined("form.TDdescripcion") and len(trim(form.TDdescripcion)) neq 0><cfoutput>#form.TDdescripcion#</cfoutput></cfif>">
									  <cfinclude template="TipoDeduccionPermiso-form.cfm">
								  </td>
							  </tr>
						  </table>
					  <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>