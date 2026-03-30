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
Key="LB_Tipos_de_Equipo"
Default="Tipos de Equipo"
returnvariable="LB_Tipos_de_Equipo"/>

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
									document.filtro.codigo.value = "";
									document.filtro.descripcion.value   = "";
																}
															</script>									
									
<cf_templateheader title="#LB_Tipos_de_Equipo#">
<cfset filtro = "">
							<cfif isdefined("form.codigo") and len(trim(form.codigo)) gt 0 >
								<cfset filtro = filtro & " and upper(TEcodigo) like '%#ucase(form.codigo)#%' " >
							</cfif>
							<cfif isdefined("form.descripcion") and len(trim(form.descripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(TEdescripcion) like '%#ucase(form.descripcion)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by TEcodigo">

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
							<td valign="top">
						<cf_web_portlet_start titulo="#LB_Tipos_de_Equipo#">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 			 
							<tr> 
							  <td colspan="3" >
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								   
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
								<td><input type="text" name="codigo" tabindex="1" value="<cfif isdefined("form.codigo") 
								and len(trim(form.codigo)) gt 0 ><cfoutput>#form.codigo#</cfoutput></cfif>" 
								size="5" maxlength="5" onFocus="javascript:this.select();"></td>
								<td><input type="text" name="descripcion" tabindex="1" value="<cfif isdefined("form.descripcion")
								 and len(trim(form.descripcion)) gt 0 ><cfoutput>#form.descripcion#</cfoutput></cfif>"
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
										
						</td>
														
					<cfquery name="rsLista" datasource="#session.DSN#">
									select TEid, TEcodigo, TEdescripcion
									from EDTiposEquipo
									where 1=1
									#PreserveSingleQuotes(filtro)#
								
						</cfquery>		
							<!--- where TEid <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#"> --->
						
						<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="TEcodigo, TEdescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
									<cfinvokeargument name="formatos" value="C,V"/>
									<cfinvokeargument name="align" value="left, left"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="TiposEquipo.cfm"/>
									<cfinvokeargument name="keys" value="TEid"/>
									<cfinvokeargument name="EmptyListMsg" value="true"/>
									</cfinvoke> 
								
											<!--- AREA DE BUSQUEDA --->
											
											
											<td width="50%" valign="top"><cfinclude template="TiposEquipo-form.cfm"></td>
										</tr>
									</table>
							  </td>
					
							</tr>
							</table> 
						
						
						
						
						
						  </td>
					  </tr>
					</table>
	<cf_templatefooter>