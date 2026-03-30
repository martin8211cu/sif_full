<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.value" type="string" default="">
<cfparam name="Attributes.valueid" type="string" default="">
<cfparam name="Attributes.id_tipocampo" type="numeric">

<cfquery name="rsDDValor" datasource="#session.tramites.dsn#">
	select id_tipo, id_valor, valor
	from DDValor
	where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id_tipocampo#">
	order by valor
</cfquery>
<cfoutput>
<cfset vistascfc = CreateObject("component","home.tramites.componentes.vistas")>
<select name="#HTMLEditFormat(Attributes.name)#">
	<cfloop query="rsDDValor">
		<cfif Len(Attributes.valueid)>
			<cfset selected = Attributes.valueid EQ id_valor>
		<cfelse>
			<cfset selected = Attributes.value   EQ valor>
		</cfif>
		<option value="#HTMLEditFormat(vistascfc.unir_valor(id_valor,valor))#" <cfif selected>selected</cfif>>#HTMLEditFormat(valor)#</option>
	</cfloop>
</select>
</cfoutput>
