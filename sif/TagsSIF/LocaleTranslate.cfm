<cfparam name="Attributes.Etiqueta"		type="string">
<cfparam name="Attributes.Default"		type="string" 	Default="">
<cfparam name="Attributes.Idioma"		type="string" 	Default="">
<cfparam name="Attributes.PorPagina"	type="boolean" 	Default="false">
<cfparam name="Attributes.Automatico"	type="boolean" 	Default="true">
<cfparam name="Attributes.Eliminar"		type="boolean" 	Default="false">

<cfif NOT isdefined("request.localeChange")>
	<cfinclude template="/aspAdmin/Componentes/LocaleFunctions.cfm">
</cfif>

<cfparam name="Attributes.ConCambio" default="false">
<cfif NOT Attributes.ConCambio>
	<cfoutput>#Request.fnLocaleTranslate(Attributes.Etiqueta,Attributes.Default,Attributes.Idioma,Attributes.PorPagina,Attributes.Automatico,Attributes.Eliminar)#</cfoutput><cfreturn>
<cfelse>
	<cfset Request.fnLocaleChange()>
	<cfoutput>
	<span name="locLblT__#Attributes.Etiqueta#">#Request.fnLocaleTranslate(Attributes.Etiqueta,Attributes.Default,Attributes.Idioma,Attributes.PorPagina,Attributes.Automatico,Attributes.Eliminar)#</span>
	</cfoutput>
</cfif>

