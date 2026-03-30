<cfsilent>
<cfparam name="Attributes.VSvalor" type="string">
<cfparam name="Attributes.VSgrupo" type="string">
<cfparam name="Attributes.Idioma"  type="String" default="">

<cfparam name="Attributes.Debug"   type="boolean" default="no">

<cfif Not ThisTag.HasEndTag >
	<cfthrow message="cf_translate requiere de tag de cierre">
</cfif>
<cfif ThisTag.ExecutionMode Is 'End'>
	<cfinvoke component="TranslateDB"
		method="Translate"
		VSvalor="#Attributes.VSvalor#"
		Default="#ThisTag.GeneratedContent#"
		VSgrupo="#Attributes.VSgrupo#"
		Idioma="#Attributes.Idioma#"
		returnvariable="translated_value"/>

	<cfif Attributes.Debug>
		<cfsavecontent variable="translated_value">
			<cfoutput>
			<span style="border:1px dotted red; background-color:##FFFF99" title="Key: #Attributes.Key# Default: #HTMLEditFormat(ThisTag.GeneratedContent)#<cfif Len(Attributes.XmlFile)> Attributes.XmlFile:#Attributes.XmlFile#</cfif><cfif Len(Attributes.Idioma)> Attributes.Idioma:#Attributes.Idioma#</cfif>">
				#translated_value#
			</span>
			</cfoutput>
		</cfsavecontent>
	</cfif>
		
	<cfset ThisTag.GeneratedContent = translated_value >
</cfif>
</cfsilent>