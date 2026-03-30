<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
	  <cf_web_portlet_start border="true" titulo="Detalle de Tipo de Deducción" skin="#Session.Preferences.Skin#">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="3"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>				
			
				<tr>
					<td valign="top" width="35%">
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="conexion" value="#Session.DSN#"/>
							<cfinvokeargument name="columnas" value="TDid, TDcodigo, TDdescripcion, TDfecha"/>
							<cfinvokeargument name="tabla" value="TDeduccion"/>
							<cfinvokeargument name="desplegar" value="TDcodigo, TDdescripcion, TDfecha"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción, Fecha"/>
							<cfinvokeargument name="formatos" value="S,S,D"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="irA" value="DTipoDeduccion.cfm"/>
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="keys" value="TDid"/>
						</cfinvoke>			
					</td>
					
					<!-- Establecimiento del modo -->
					<cfif isdefined("form.Cambio")>
						<cfset modo="CAMBIO">
					<cfelse>
						<cfif not isdefined("Form.modo")>
							<cfset modo="ALTA">
						<cfelseif form.modo EQ "CAMBIO">
							<cfset modo="CAMBIO">
						<cfelse>
							<cfset modo="ALTA">
						</cfif>
					</cfif>
					
					<td width="1%">&nbsp;</td>
					
					<td width="64%" valign="top">
						<cfif modo neq 'ALTA'>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<cfinclude template="formDTipoDeduccion.cfm">
									</td>
								</tr>
							</table>
						<cfelse>	
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>	  	
	  <cf_web_portlet_end>
<cf_templatefooter>