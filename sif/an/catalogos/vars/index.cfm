<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Definici&oacute;n de Variables" 
returnvariable="LB_Titulo" xmlfile="Index.xml"/>
<cfif isdefined("url.AVid") and len(trim(url.AVid))><cfset form.AVid = url.AVid></cfif>
<cfoutput>
<cf_templateheader title="#LB_Titulo#">
		<cf_web_portlet_start titulo="#LB_Titulo#">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<br>
			<table 
				width="98%"  
				align="center"
				border="0" 
				cellspacing="0" 
				cellpadding="0">
			<tr>
			<td valign="top" width="59%">
				<cfinclude template="lista.cfm">
			</td>
			<td width="2%">&nbsp;</td>
			<td valign="top" width="39%">
				<cfinclude template="form.cfm">
			</td>
			</tr>
			</table>
			<br>
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfoutput>