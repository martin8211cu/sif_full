<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			//-->
		</script>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Programas'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
					</td>
				</tr>
				<tr> 
					<td valign="top" align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<form name="formFiltro" method="post" action="grupoMaterias.cfm">
								<cfoutput>
									<cfif isdefined('form.RHGMid') and len(trim(form.RHGMid))>
										<input type="hidden" name="RHGMid" value="#form.RHGMid#">
									</cfif>
	
								  <tr class="areaFiltro">
									<td width="30%"><strong>C&oacute;digo:</strong></td>
									<td width="44%">
										<input type="text" name="F_RHGMcodigo" size="10" maxlength="15" value="<cfif isdefined('form.F_RHGMcodigo') and Len(trim(form.F_RHGMcodigo))>#trim(form.F_RHGMcodigo)#</cfif>" onfocus="this.select();" >
									</td>
									<td width="26%" rowspan="2" align="center" valign="middle">
										<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
									</td>							
								  </tr>
									  <tr class="areaFiltro">
										<td><strong>Descripci&oacute;n:</strong></td>
										<td>
										<input type="text" name="F_Descripcion" size="60" maxlength="80" value="<cfif isdefined('form.F_Descripcion') and Len(trim(form.F_Descripcion))>#trim(form.F_Descripcion)#</cfif>" onfocus="this.select();"></td>
									  </tr>	
								  </cfoutput>
							   </form>				  
						  <tr>
							<td colspan="3">
								<cfset navegacion = "">			
								<cfquery name="rsLista" datasource="#session.DSN#">
									select RHGMid,RHGMcodigo,Descripcion
									from RHGrupoMaterias
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										<cfif isdefined('form.F_RHGMcodigo') and len(trim(form.F_RHGMcodigo))>
											and upper(RHGMcodigo) like '%#UCase(form.F_RHGMcodigo)#%'
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_RHGMcodigo=" & Form.F_RHGMcodigo>
										</cfif>
										<cfif isdefined('form.F_Descripcion') and len(trim(form.F_Descripcion))>
											and upper(Descripcion) like '%#UCase(form.F_Descripcion)#%'
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Descripcion=" & Form.F_Descripcion>
										</cfif>										
									order by RHGMcodigo, Descripcion
								</cfquery>
		
								<cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHGMcodigo,Descripcion"/>
									<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
									<cfinvokeargument name="formatos" value="V, V"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="grupoMaterias.cfm"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="keys" value="RHGMid"/>
								</cfinvoke>							
							</td>
						  </tr>
						</table>


					</td>
					<td width="55%" valign="top">
						<cfinclude template="grupoMaterias-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
