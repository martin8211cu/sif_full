<!--- Menú Principal de AF --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cf_importlibs>
			<link href="/cfmx/plantillas/erp/css/erp.css" rel="stylesheet" type="text/css">
			<style>body {background-color:#dee7e5}</style> <!--656565  4f4f4f-->
		<cf_web_portlet_start >
			<table align="center" >
				<tr>					
					<td valign="top">
						<cfinclude template="MenuAF-principal.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
