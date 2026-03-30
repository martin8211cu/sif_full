<cfquery name="rsJerarquia" datasource="#Session.DSN#">
	select rtrim(c.CFpath) as CFpath
	from RHPuestos a
	
	inner join CFuncional c
	on a.Ecodigo = c.Ecodigo
	and a.CFid = c.CFid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cfoutput>
<cfif isdefined("rsJerarquia.CFpath") and Len(Trim(rsJerarquia.CFpath))>
	<cfset centros = ListToArray(rsJerarquia.CFpath, '/')>
	<table border="0" align="center" cellpadding="0" cellspacing="0" width="90%">
	<cfloop from="1" to="#ArrayLen(centros)#" index="i">
		<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
			select {fn concat(rtrim(CFcodigo),{fn concat(' - ',CFdescripcion)})} as centro
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#centros[i]#">
		</cfquery>
		<tr>
			<td colspan="#i#" align="right">
				<img src="/cfmx/rh/js/xtree/images/L.png" border="1">
			</td>
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