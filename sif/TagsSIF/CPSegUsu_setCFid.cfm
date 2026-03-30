<cfparam name="Attributes.name" 		default="CFid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.value" 		default="-2" type="numeric"> <!--- Nombre del código de la moneda --->

<cfparam name="session.CPSegUsu.#Attributes.name#"	default="-1">
<cfif Attributes.value NEQ -2>
	<cfset session.CPSegUsu[Attributes.name] = Attributes.value>
	<cfset form[Attributes.name] = Attributes.value>
<cfelseif isdefined("form.#Attributes.name#")>
	<cfset session.CPSegUsu[Attributes.name] = form[Attributes.name]>
<cfelse>
	<cfset form[Attributes.name] = session.CPSegUsu[Attributes.name]>
</cfif>
