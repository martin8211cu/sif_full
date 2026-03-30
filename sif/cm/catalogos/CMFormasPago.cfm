<cf_templateheader title="Compras - Compradores ">
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
			//-->
		</script>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Formas de Pago'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacionCM.cfm">
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="#session.DSN#">
							select CMFPid, Ecodigo , CMFPcodigo,  CMFPdescripcion ,CMFPplazo ,Usucodigo  ,fechaalta  
							from CMFormasPago
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by CMFPcodigo
						</cfquery>
<!---  <cfdump var="#rsLista#">
<cfabort>  --->
						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CMFPcodigo,CMFPdescripcion, CMFPplazo"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripcion, Plazo"/>
							<cfinvokeargument name="formatos" value="V, V, V"/>
							<cfinvokeargument name="align" value="left,left, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="CMFormasPago.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CMFPid"/>
						</cfinvoke>
					</td>
					<td width="55%">
						<cfinclude template="CMFormasPago-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>