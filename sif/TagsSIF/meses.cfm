<cfparam name="Attributes.name" default="Mes">
<cfparam name="Attributes.todos" default="">
<cfparam name="Attributes.value" default="0">
<cfparam name="Attributes.tabindex" default="" type="string">
<cfparam name="Attributes.readonly" default="false" type="boolean">

<cfquery name="m" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	order by <cf_dbfunction name="to_number" args="b.VSvalor">
</cfquery>
<cfif not isdefined("request.qrymeses")>
	<cfset request.qrymeses = m>
</cfif>
<select name="<cfoutput>#Attributes.name#</cfoutput>" 
	<cfif isdefined("Attributes.tabindex") and len(trim(Attributes.tabindex))>tabindex="<cfoutput>#Attributes.tabindex#</cfoutput>"</cfif>
	<cfif isdefined("Attributes.readonly") and Attributes.readonly>disabled</cfif>
>
	<cfif len(trim(Attributes.todos))><option value="0"><cfoutput>#Attributes.todos#</cfoutput></option></cfif>
	<cfoutput query="m">
		<option value="#m.v#" <cfif Attributes.value eq m.v>selected</cfif>>#m.m#</option>
	</cfoutput>
</select>