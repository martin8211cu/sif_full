<!---
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		RH-Grupos de Materias
	</cf_templatearea>
	
	<cf_templatearea name="body">
---->	
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			//-->
		</script>
<!----
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Grupos de Materias'>
---->		
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!---
				<tr> 
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
---->
				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="#session.DSN#">
							select RHGMid,RHGMcodigo,Descripcion
							from RHGrupoMaterias
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by RHGMcodigo, Descripcion
						</cfquery>

						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="RHGMcodigo,Descripcion"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="educacion.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="RHGMid"/>
						</cfinvoke>
					</td>
					<td width="55%">
						<cfinclude template="educacion-form.cfm">
					</td>
				</tr>
			</table>
<!----		
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
----->
