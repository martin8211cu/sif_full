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
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	<cfloop from="1" to="#ArrayLen(centros)#" index="i">
		<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
			select {fn concat(rtrim(CFcodigo),{fn concat(' - ',CFdescripcion)})} as centro
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#centros[i]#">
		</cfquery>
		<tr>
			<td colspan="#i#" align="right" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">
				<img src="/cfmx/rh/js/xtree/images/L.png" border="0">
			</td>
			<td colspan="#(ArrayLen(centros)+1)-i#" nowrap style="font-family: Times New Roman;font-size: 18px;font-weight:font-style: italic;">
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
		<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;</td>
	</cfloop>
	</tr>
	</table>
</cfif>
</cfoutput>