<!---
	usar asi:
	<cf_locale name="date/number" value="#rs.fecha#"/ returnvariable="Lvarfecha">
--->
<cfif Not ThisTag.HasEndTag >
	<cf_errorCode	code = "99999" msg = "cf_locale requiere de tag de cierre">
</cfif>
<cfif ThisTag.ExecutionMode Is 'Start'>
	<cfparam name="Attributes.name"     type="string">
	<cfparam name="Attributes.value" type="string" default="">
	<cfparam name="Attributes.Idioma"  type="String" default="">
	<cfparam name="Attributes.returnvariable"  type="String" default="">
</cfif>
<cfif ThisTag.ExecutionMode Is 'End'>
<cfsilent>
	<cftry>
		<cfif ucase(Attributes.name) eq 'DATE'>
			<cfinvoke component="commons.Componentes.locale" method="date" value="#Attributes.value#" Idioma="#Attributes.Idioma#" returnvariable="locale_value"/>
		</cfif>
		<cfif ucase(Attributes.name) eq 'NUMBER'>
			<cfinvoke component="commons.Componentes.locale" method="number" value="#Attributes.value#" Idioma="#Attributes.Idioma#" returnvariable="locale_value"/>
		</cfif>
	<cfcatch type="any">
		<cfset locale_value =  ThisTag.GeneratedContent> 
	</cfcatch>		
	</cftry>
	<cfif len(trim(attributes.returnvariable))>
		<cfset Caller[Attributes.returnvariable] = locale_value>	
	<cfelse>	
		<cfset ThisTag.GeneratedContent = locale_value >
	</cfif>
	
</cfsilent>
</cfif>

