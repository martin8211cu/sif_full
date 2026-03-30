
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Equipos"
Default="Equipos"
returnvariable="LB_Equipos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="BTN_Filtrar"/>
																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Limpiar"
Default="Limpiar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="BTN_Limpiar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Descripcion"/>
									
<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.fEcodigo.value = "";
									document.filtro.fEdescripcion.value   = "";
																}
															</script>									
									
<cf_templateheader title="#LB_Equipos#">
<cfset filtro = "">
							<cfif isdefined("form.fEcodigo") and len(trim(form.fEcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(Ecodigo) like '%#ucase(form.fEcodigo)#%' " >
							</cfif>
							<cfif isdefined("form.fEdescripcion") and len(trim(form.fEdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(Edescripcion) like '%#ucase(form.fEdescripcion)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by Ecodigo">

					
						<cf_web_portlet_start titulo="#LB_Equipos#">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 			 
							<tr> 
							<td valign="top">
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</tr>	
							<tr><td>   
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
											

			<form name="filtro" method="post">  
									<table border="0" width="100%" class="tituloListas">
											<tr> 
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate></td>
									<td colspan="2"><cf_translate key="LB_Descripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate></td>
											</tr>
											<tr> 
								<td><input type="text" name="fEcodigo" tabindex="1" value="<cfif isdefined("form.fEcodigo") 
								and len(trim(form.fEcodigo)) gt 0 ><cfoutput>#form.fEcodigo#</cfoutput></cfif>" 
								size="5" maxlength="5" onFocus="javascript:this.select();"></td>
								<td><input type="text" name="fEdescripcion" tabindex="1" value="<cfif isdefined("form.fEdescripcion")
								 and len(trim(form.fEdescripcion)) gt 0 ><cfoutput>#form.fEdescripcion#</cfoutput></cfif>"
								 size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td nowrap>
																
																<cfoutput>
																<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
																<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
																</cfoutput>
															</td>
														</tr>
														
										</table>
												</form> 	 					
										
						
														
					<cfquery name="rsLista" datasource="#session.DSN#">
									select EDid, Ecodigo, Edescripcion
									from Equipo
									where 1=1
									#PreserveSingleQuotes(filtro)#
								
						</cfquery>		
							<!--- where TEid <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#"> --->
						
						<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="Ecodigo, Edescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
									<cfinvokeargument name="formatos" value="C,V"/>
									<cfinvokeargument name="align" value="left, left"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="Equipos.cfm"/>
									<cfinvokeargument name="keys" value="EDid"/>
									<cfinvokeargument name="EmptyListMsg" value="true"/>
									</cfinvoke> 
								
											<!--- AREA DE BUSQUEDA --->
											
										</td>	
											<td width="50%" valign="top">   
											<table border="0" width="100%">
											<cfinclude template="Equipos-form.cfm"></td>
										</tr>   
									</table> 
							  </td> 
					
							</tr> 
						</table> 
						
						
						
						
					
	<cf_templatefooter>