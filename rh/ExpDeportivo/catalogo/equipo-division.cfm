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
Key="LB_EquipoDivision"
Default="Equipo-Divisi&oacute;n"
returnvariable="LB_EquipoDivision"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Equipo"
Default="Equipo"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Equipo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="Codigo"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Codigo"/>
									
<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
								
									document.filtro.fEdescripcion.value   = "";
									document.filtro.fEcodigo.value   = "";
																}
															</script>									
									
<cf_templateheader title="#LB_EquipoDivision#">
<cfset filtro = "where 1=1">
							
							<cfif isdefined("form.fEdescripcion") and len(trim(form.fEdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(Edescripcion) like '%#ucase(form.fEdescripcion)#%' " >
							</cfif>
							<cfif isdefined("form.fEcodigo") and len(trim(form.fEcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(Ecodigo) like '%#ucase(form.fEcodigo)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by Ecodigo">

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
							<td valign="top">
						<cf_web_portlet_start titulo="#LB_EquipoDivision#">
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
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">Codigo</cf_translate></td>
									<td colspan="2"><cf_translate key="LB_Equipo" XmlFile="/rh/ExpDeportivo/generales.xml">Equipo</cf_translate></td>
											</tr>
											<tr> 
								<td><input type="text" name="fEcodigo" tabindex="1" value="<cfif isdefined("form.fEcodigo")
								 and len(trim(form.fEcodigo)) gt 0 ><cfoutput>#form.fEcodigo#</cfoutput></cfif>"
								 size="20" maxlength="60" onFocus="javascript:this.select();" ></td>
								<td><input type="text" name="fEdescripcion" tabindex="1" value="<cfif isdefined("form.fEdescripcion")
								 and len(trim(form.fEdescripcion)) gt 0 ><cfoutput>#form.fEdescripcion#</cfoutput></cfif>"
								 size="20" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td width="36%" nowrap>
																
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
									select EDid, Ecodigo, Edescripcion
									from Equipo 									
									#PreserveSingleQuotes(filtro)#
								
						</cfquery>		
							<!--- where TEid <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#"> --->
						
						<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="Ecodigo, Edescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Equipo#"/>
									<cfinvokeargument name="formatos" value="V,V"/>
									<cfinvokeargument name="align" value="left, left"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="equipo-division.cfm"/>
									<cfinvokeargument name="keys" value="EDid"/>
									<cfinvokeargument name="EmptyListMsg" value="true"/>
									</cfinvoke> 
								
											<!--- AREA DE BUSQUEDA --->
											
											
											<td width="50%" valign="top"><cfinclude template="equipo-division-form.cfm"></td>  
										</tr>
									</table>
							  </td>
					
							</tr>
							</table> 
						
						
	