<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.value" type="string" default="">
<cfparam name="Attributes.id_tipocampo" type="numeric">
<cfset DDValor = QueryNew("")>
<cfquery name="rsDDValor" datasource="tramites">
	select id_tipo, id_valor, valor
	from DDValor
	where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_tipocampo#">
</cfquery>
<cfoutput>
<select name="#Attributes.name#">
	<cfloop query="rsDDValor">
		<option value="#valor#" <cfif valor eq Attributes.value>selected</cfif>>#valor#</option>
	</cfloop>
</select>
</cfoutput>