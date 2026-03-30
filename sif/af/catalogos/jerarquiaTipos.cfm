<cfoutput>
<cfif isdefined("rsActivo.AFCpath") and Len(Trim(rsActivo.AFCpath))>
	<cfset centros = ListToArray(rsActivo.AFCpath, '/')>
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="#ArrayLen(centros)+1#">&nbsp;</td>
		</tr>
		<cfloop from="1" to="#ArrayLen(centros)#" index="i">
			<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
				select <cf_dbfunction name="concat" args="rtrim(AFCcodigoclas) ,' - ' , AFCdescripcion"> as centro
				from AFClasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
					and AFCcodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#centros[i]#">
			</cfquery>
			<tr>
 				<cfloop from="1" to="#i-1#" index="e">
					<td width="1%">&nbsp;&nbsp;&nbsp;</td>
				</cfloop>					

				<cfif i EQ 1 >
					<td width="1%">&nbsp;&nbsp;&nbsp;</td>
				<cfelse>
					<td align="right" width="1%"><img src="/cfmx/sif/js/xtree/images/L.png" border="0" ></td>
				</cfif>
	
				<td colspan="#(ArrayLen(centros)+1)-i#" nowrap>
					<cfif i EQ ArrayLen(centros)>
						<strong>#rsCentroFuncional.centro#</strong>
					<cfelse>
						#rsCentroFuncional.centro#
					</cfif>
				</td>
			</tr>
		</cfloop>
		<tr>
			<cfloop from="1" to="#ArrayLen(centros)#" index="i">
				<td>&nbsp;</td>
			</cfloop>
		</tr>
	</table>
</cfif>
</cfoutput>
