<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Habilidades" Default="Habilidades" returnvariable="LB_Habilidades" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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
				<td valign="top">
	            	<cfset filtro = "a.Ecodigo = #Session.Ecodigo#">	              
				  	<cfif isdefined("form.fRHHcodigo") and len(trim(form.fRHHcodigo)) gt 0 >
						<cfset filtro = filtro & " and RHHcodigo like '%#ucase(form.fRHHcodigo)#%' " >
		            </cfif>
					<cfif isdefined("form.fRHHdescripcion") and len(trim(form.fRHHdescripcion)) gt 0 >
						<cfset filtro = filtro & " and upper(RHHdescripcion) like '%#ucase(form.fRHHdescripcion)#%' " >
		            </cfif>
					<cfquery name="data_bezinger" datasource="#session.DSN#">
						select Pvalor
						from RHParametros
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and Pcodigo=450
		            </cfquery>

	              	<cf_web_portlet_start titulo="#LB_Habilidades#">
						<cfif isdefined("url.RHHcodigo") and not isdefined("form.RHHcodigo")>
							<cfset form.RHHcodigo = url.RHHcodigo >
						</cfif>
		
						<cfif isdefined("url.modo") and not isdefined("form.modo")>
							<cfset form.modo = url.modo >
						</cfif>
		
						<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = "Administración de Puestos">
						<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
		
						<cfinclude template="/rh/portlets/pNavegacion.cfm">

						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="50%">
									<form style="margin:0" name="filtro" method="post">
										<table border="0" width="100%" class="tituloListas">
											<tr> 
												<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
												<td><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
											</tr>
											<tr> 
												<td>
													<input type="text" name="fRHHcodigo"  size="5" maxlength="5" tabindex="1"
														value="<cfif isdefined("form.fRHHcodigo") and len(trim(form.fRHHcodigo)) gt 0 ><cfoutput>#form.fRHHcodigo#</cfoutput></cfif>" 
														onFocus="javascript:this.select();">
												</td>
												<td>
													<input type="text" name="fRHHdescripcion"  size="60" maxlength="60" tabindex="1"
													value="<cfif isdefined("form.fRHHdescripcion") and len(trim(form.fRHHdescripcion)) gt 0 ><cfoutput>#form.fRHHdescripcion#</cfoutput></cfif>" 
													onFocus="javascript:this.select();" >
												</td>
											</tr>	
											<tr>
												<td colspan="2" align="right">
													<cfoutput>
													<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
													<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
													</cfoutput>
												</td>
											</tr>
										</table>
									</form>
									<cf_dbfunction name="length" args="a.RHHdescripcion" returnvariable="RHHdescripcion_length">
									<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
									<cf_dbfunction name="sPart" args="a.RHHdescripcion,1,57" returnvariable="RHHdescripcion_sPart">
									<cfif  isdefined("data_bezinger") and  data_bezinger.Pvalor EQ 1>
									<cfquery name="rsLista" datasource="#session.DSN#">
									   select a.RHHid, a.RHHcodigo, 
										 case when #preservesinglequotes(RHHdescripcion_length)# > 60 then 
										 	#preservesinglequotes(RHHdescripcion_sPart)# #_CAT# '...'
											else a.RHHdescripcion end as RHHdescripcion,
										  a.PCid, a.RHHubicacionB as Ubicacion,
											b.PCid, b.PCcodigo, b.PCnombre, 
											{fn concat(coalesce(b.PCcodigo,'Sin '),{fn concat(' - ',coalesce(b.PCnombre,'Asociar a Cuestionario'))})} as NombCuestionario
										
									   from RHHabilidades a 
										  left outer join PortalCuestionario b
											on a.PCid = b.PCid
										Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
											<cfif isdefined("form.fRHHcodigo") and len(trim(form.fRHHcodigo)) gt 0>
												and upper(a.RHHcodigo) like upper('%#form.fRHHcodigo#%')
											</cfif>
											<cfif isdefined("form.fRHHdescripcion") and len(trim(form.fRHHdescripcion)) gt 0>
												and upper(a.RHHdescripcion) like upper('%#form.fRHHdescripcion#%')
											</cfif>
									</cfquery>
									
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Ubicacion"
										Default="Ubicaci&oacute;n"
										returnvariable="LB_Ubicacion"/>
									
									
									<cfinvoke component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
											
											<cfinvokeargument name="desplegar" value="RHHcodigo, RHHdescripcion, Ubicacion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Ubicacion#"/>
											<cfinvokeargument name="formatos" value="V, V, V "/>
											<cfinvokeargument name="cortes" value="NombCuestionario"/>
											<cfinvokeargument name="filtro" value="#filtro# and a.PCid = b.PCid "/>
											<cfinvokeargument name="align" value="left, left, left "/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="PuestosHabilidades.cfm"/>
											<cfinvokeargument name="keys" value="RHHid"/>
											<cfinvokeargument name="maxrows" value="30"/>
										</cfinvoke>
									<cfelse>
									
										<cfquery name="rsLista" datasource="#session.DSN#">
											select RHHid, RHHcodigo, 
											case when #preservesinglequotes(RHHdescripcion_length)# > 60 
												then #preservesinglequotes(RHHdescripcion_sPart)# #_CAT# '...'
												else RHHdescripcion end as RHHdescripcion, 
											a.PCid, 
											{fn concat(coalesce(b.PCcodigo,'Sin '), {fn concat(' - ',coalesce(b.PCnombre,'Asociar a Cuestionario'))})} as NombCuestionario 
											from RHHabilidades a 
											left outer join PortalCuestionario b
											  on a.PCid = b.PCid	
											Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
												<cfif isdefined("form.fRHHcodigo") and len(trim(form.fRHHcodigo)) gt 0>
													and upper(a.RHHcodigo) like upper('%#form.fRHHcodigo#%')
												</cfif>
												<cfif isdefined("form.fRHHdescripcion") and len(trim(form.fRHHdescripcion)) gt 0>
													and upper(a.RHHdescripcion) like upper('%#form.fRHHdescripcion#%')
												</cfif>				
										
										</cfquery>
										
										<cfinvoke component="rh.Componentes.pListas"
										 method="pListaQuery"
										 returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="RHHcodigo, RHHdescripcion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
											<cfinvokeargument name="cortes" value="NombCuestionario"/>
											<cfinvokeargument name="formatos" value="V, V"/>
											<cfinvokeargument name="align" value="left, left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="PuestosHabilidades.cfm"/>
											<cfinvokeargument name="keys" value="RHHid"/>
											<cfinvokeargument name="maxrows" value="30"/>
										</cfinvoke>
									</cfif>
										
									</td>
								<td width="50%" valign="top"><cfinclude template="formPuestosHabilidades.cfm"></td>
							</tr>
						</table>
		            <cf_web_portlet_end>
                  	<script type="text/javascript" language="javascript1.2">
						function limpiar(){
							document.filtro.fRHHcodigo.value = '';
							document.filtro.fRHHdescripcion.value = '';
						}
                    </script>		
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>	