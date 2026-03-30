<cffunction name="Translate" displayname="Translate" output="false" hint="Translate">
	<cfargument name="Etiqueta" default="" type="string" required="false">
	<cfargument name="default" default="" type="string" required="false">
	<cfargument name="File" default="" type="string" required="false">
	<cfargument name="Idioma" default="" type="String" required="false">

    <cfparam name="Session.Idioma" default="ES_CR">
	<cfset Idioma = Session.Idioma>

	<cfif Len(Trim(File)) EQ 0>
		<cfset Pagina = GetToken(GetTemplatePath(),1,".") & ".xml">
	<cfelse>
		<cfset Pagina = ExpandPath(File)>
	</cfif>
	<cftry>
		<cffile action="read" file="#Pagina#" variable="xmlTrans">
		<cfset xml=XmlParse(xmlTrans)>
		<cfset nodo = xmlSearch(xml,"//Idioma[@id='#Trim(Idioma)#']/#Trim(Etiqueta)#")>
		<cfif ArrayLen(nodo) gt 0> <!--- Encontro el dato ---->
			<cfreturn #Trim(nodo[1].xmlText)#>
		<cfelse> <!--- NO Encontro el dato ---->
			<cfreturn #Trim(default)#>
		</cfif>
	<cfcatch type="Application">
		<cfif findnocase('java.io.FileNotFoundException',cfcatch.Detail)>
			<cftry>
			<cffile action='write' file='#Pagina#' output='<?xml version="1.0" encoding="iso-8859-1"?>' addnewline="yes" nameconflict="skip">
			<cffile action='append' file='#Pagina#' output='<Etiquetas>' addnewline="yes">
			<cffile action='append' file='#Pagina#' output='	<Idioma id="#Trim(Session.Idioma)#">' addnewline="yes">			
			<cffile action='append' file='#Pagina#' output='		<#Trim(Etiqueta)#>' addnewline="yes">			
			<cffile action='append' file='#Pagina#' output='			#default#' addnewline="yes">			
			<cffile action='append' file='#Pagina#' output='		</#Trim(Etiqueta)#>' addnewline="yes">			
			<cffile action='append' file='#Pagina#' output='	</Idioma>' addnewline="yes">			
			<cffile action='append' file='#Pagina#' output='</Etiquetas>' addnewline="yes">
			<cfcatch>
				<cfreturn>
			</cfcatch>
			</cftry>
		</cfif>
	</cfcatch>
	<cfcatch type="expression">
		<cfreturn>
	</cfcatch>
	</cftry>
</cffunction>
<cfset Request.Translate = Translate>