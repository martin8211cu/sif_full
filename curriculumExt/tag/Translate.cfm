<!---
	usar asi:
	<cf_translate key="Nombre">Nombre: </cf_translate>
--->
<cfparam name="Attributes.Key"     type="string">
<cfparam name="Attributes.XmlFile" type="string" default="">
<cfparam name="Attributes.Idioma"  type="String" default="">

<cfparam name="Attributes.Debug"   type="boolean" default="no">


<cfif Not ThisTag.HasEndTag >
	<cfthrow message="cf_translate requiere de tag de cierre">
</cfif>
<cfif ThisTag.ExecutionMode Is 'End'>
<cftry>
	<cfinvoke component="Translate"
		method="Translate"
		Key="#Attributes.Key#"
		Default="#ThisTag.GeneratedContent#"
		XmlFile="#Attributes.XmlFile#"
		Idioma="#Attributes.Idioma#"
		returnvariable="translated_value"/>
		<cfcatch type="any">
			<cfset translated_value =  ThisTag.GeneratedContent> 
		</cfcatch>		
</cftry>
	<cfif Attributes.Debug>
		<cfsavecontent variable="translated_value">
			<cfoutput>
			<span style="border:1px dotted red; background-color:##FFFF99" title="Key: #Attributes.Key# Default: #HTMLEditFormat(ThisTag.GeneratedContent)#<cfif Len(Attributes.XmlFile)> Attributes.XmlFile:#Attributes.XmlFile#</cfif><cfif Len(Attributes.Idioma)> Attributes.Idioma:#Attributes.Idioma#</cfif>">
				#translated_value#
			</span></cfoutput>
		</cfsavecontent>
	</cfif>
		
	<cfset ThisTag.GeneratedContent = translated_value >
</cfif>