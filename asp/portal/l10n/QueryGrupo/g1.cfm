<cfset grupo = QueryNew('valor,descr,grupo,refer')>
<cfloop from="1" to="12" index="n">
	<cfset QueryAddRow(grupo)>
	<cfset QuerySetCell(grupo, 'valor', n)>
	<cfset QuerySetCell(grupo, 'descr', MonthAsString(n))>
</cfloop>

