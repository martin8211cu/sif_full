<cf_templateheader title="SIF - Contabilidad General">
	<cfinclude template="../portlets/pNavegacion.cfm">
	<br>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Men&uacute; Principal de Contabilidad General">
	 <style>
		.smenu1 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #ffffff; background-color: #98B1C4; text-decoration: none; }
		.smenu2, .smenu3 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #293D6B; background-color: #C8D7E3; text-decoration: none; }
		.smenu33 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #293D6B; background-color: #ffffff; text-decoration: none; }
		.smenu4, .smenu5 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: normal; color: #293D6B; background-color: #C8D7E3; text-decoration: none; }
		.smenu55 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: normal; color: #293D6B; background-color: #ffffff; text-decoration: none; }
		.table_border_gray{border:1px solid #ccc;}
	</style>	
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		 <tr>
		 	<td  rowspan="2" valign="top"  width="20%" >
				<cf_menu sscodigo="SIF" smcodigo="CG">
			</td>
			<td  valign="top" width="80%" height="50%">
			
			<cfif FileExists(expandpath('./EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm'))>
					<cfset Undelivr = ExpandPath('/sif/cg/')>
					<cfdirectory action="list" directory="#Undelivr#" name="lista" filter="EstadoResultados_*.cfm">
						<cfset LvarG = DateDiff('n', '#lista.DateLastModified#', dateformat(NOW(),'dd/mm/yy')& ' ' & timeFormat(now(),"hh:mm:ss tt "))>
						<cfif LvarG gte 15>
							<cfinclude template="MenuConsulta.cfm">
						</cfif>
					<cfset finished = Now()>

				<cfinclude template="./EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm">
			<cfelse>
				<cfinclude template="MenuConsulta.cfm">
			</cfif>
			</td>
		 </tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>