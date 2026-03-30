<cfif isdefined("url.tipo") and len(trim(url.tipo)) and url.tipo eq 1><!--- COMPORTAMIENTOS --->
	<cfquery name="rsHabilidad" datasource="#session.DSN#">
		select RHHcodigo,RHHdescripcion from RHHabilidades
		where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#">
	</cfquery>
	<cfquery name="rsComportamientos" datasource="#session.DSN#">
		select RHCOcodigo,RHCOdescripcion from RHComportamiento
		where  RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#">
		order by RHCOcodigo
	</cfquery>
	<cfoutput>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="3"><font size="+1" color="black">#rsHabilidad.RHHcodigo#&nbsp;#rsHabilidad.RHHdescripcion#</font></td>
			</tr>
			<cfloop query="rsComportamientos">
				<tr>
					<td>&nbsp;</td>
					<td valign="top">#rsComportamientos.currentRow#</td>
					<td>&iquest;&nbsp;#rsComportamientos.RHCOdescripcion#&nbsp;?</td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>

<cfelseif isdefined("url.tipo") and len(trim(url.tipo)) and url.tipo eq 2><!--- OBJETIVOS --->

</cfif>
