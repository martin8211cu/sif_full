<!---
	usar asi:
	<cf_traducir key="nombre">Nombre</cf_traducir>
--->
<cfparam name="Attributes.key"     type="string">
<cfparam name="Attributes.xmlFile" type="string" default="#session.saci.diccionario#">
<cfparam name="Attributes.idioma"  type="string" default="#session.idioma#">
<cfparam name="Attributes.debug"   type="boolean" default="no">


<cfif Not ThisTag.HasEndTag >
	<cfthrow message="cf_traducir requiere de tag de cierre">
</cfif>
<cfif ThisTag.ExecutionMode Is 'End'>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="#Attributes.key#"
		Default="#ThisTag.GeneratedContent#"
		XmlFile="#Attributes.xmlFile#"
		Idioma="#Attributes.Idioma#"
		returnvariable="translated_value"/>

	<cfif Attributes.Debug>
		<cfsavecontent variable="translated_value">
			<cfoutput>
			<span style="border:1px dotted red; background-color:##FFFF99" title="Key: #Attributes.Key# Default: #HTMLEditFormat(ThisTag.GeneratedContent)#<cfif Len(Attributes.XmlFile)> Attributes.XmlFile:#Attributes.XmlFile#</cfif><cfif Len(Attributes.Idioma)> Attributes.Idioma:#Attributes.Idioma#</cfif>">
				#translated_value#
			</span></cfoutput>
		</cfsavecontent>
	</cfif>
		
	<cfset ThisTag.GeneratedContent = translated_value>
</cfif>
