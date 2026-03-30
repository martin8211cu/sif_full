<cfparam name="Attributes.Idioma" default="Español" type="String">
<cfparam name="Attributes.Etiqueta" default="" type="string">
<cfparam name="Attributes.default" default="" type="string">
<cfparam name="Attributes.File" default="" type="string">
<cfparam name="Attributes.debug" default="N" type="string">

<cfif Len(Trim(Attributes.File)) EQ 0>
	<cfset Pagina = GetToken(GetTemplatePath(),1,".") & ".xml">
<cfelse>
	<cfset Pagina = ExpandPath(Attributes.File)>
</cfif>
<cfif Attributes.debug EQ "S">
	<cfoutput>
		#File#<br>
		#Pagina#<br>
		#Attributes.Idioma#<br>
		#Attributes.Etiqueta#
	</cfoutput>
</cfif>
<cffile action="read" file="#Pagina#" variable="xmlTrans">
<cfset xml=XmlParse(xmlTrans)>
<cfset nodo = xmlSearch(xml,"//Idioma[@id='#Trim(Attributes.Idioma)#']/#Trim(Attributes.Etiqueta)#")>
<cfif ArrayLen(nodo) gt 0>
	<cfoutput>#nodo[1].xmlText#</cfoutput>
<cfelse>
	<cfoutput>#Attributes.default#</cfoutput>
</cfif>