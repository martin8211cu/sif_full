<cfsilent>
<cfparam name="Attributes.template" type="string" default="">
<cfparam name="Attributes.title" type="string" default="Untitled Document">
<cfparam name="Attributes.pNavegacion" type="boolean" default="yes">
<cfparam name="Attributes.bodyTag" type="string" default="">

<cfif Len(Attributes.template) Is 0 and IsDefined('session.sitio.template')>
	<cfset Attributes.template=session.sitio.template>
</cfif>

<!--- indicar al cf_templatecss que ya se ha incluido el css --->
<cfset Request.TemplateCSS = true>

<cfif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'YES'>
	<cf_errorCode	code = "50719" msg = "cf_templateheader no debe tener tag de cierre">
</cfif>

<!--- inicia bloque repetido de template.cfm --->
<cfif FileExists(ExpandPath(Attributes.template))>
	<cfif Right(Attributes.template,4) EQ ".cfm">		
		<cftry>
		<cfsavecontent variable="templatedata">
			<cfinclude template="#Attributes.template#">
		</cfsavecontent>
		<cfcatch type="any">
			<cfsavecontent variable="templatedata">
				<cfoutput>
					<html><head><title>$$TITLE$$</title></head>
					<body marginheight="0" marginwidth="0">
					<div style="background-color:red;color:white;font-weight:bold">
						Error en plantilla: #cfcatch.Message# <br> #cfcatch.Detail#
						<br>
						<a href="/cfmx#Attributes.template#" style="color:white ">&gt;&gt;Revisar plantilla para ver más detalles</a>
						</div>
						
					<cf_onEnterKey>
					<table border="50"><tr><td>$$LEFT OPTIONAL$$</td><td>$$BODY$$</td></tr></table></body></html>
				</cfoutput>
			</cfsavecontent>
		</cfcatch>
		</cftry>
	<cfelse>
		
		<cffile action="read" file="#ExpandPath(Attributes.template)#" variable="templatedata">
	</cfif>
<cfelseif FileExists(ExpandPath("/home/public/plantilla.cfm"))>
	<cfsavecontent variable="templatedata">
		<cfinclude template="/home/public/plantilla.cfm">
	</cfsavecontent>
<cfelse>
	<cfset templatedata='<html><head><title>$$TITLE$$</title></head><body><table><tr><td>$$LEFT OPTIONAL$$</td><td>$$BODY$$</td></tr></table></body></html>'>
</cfif>
<!--- termina bloque repetido de template.cfm --->

<cfset templatedata = REReplaceNoCase(templatedata, '\$\$TITLE[^$]*\$\$', Attributes.title)>
<cfset LvarPto = findNoCase("<body",templatedata)>
<cfif LvarPto GT 0>
	<cfset LvarPto = findNoCase(">",templatedata,LvarPto)>
	<cfset LvarBodyTag = trim(attributes.bodyTag)>
	<cfif LvarBodyTag NEQ "">
		<cfset LvarBodyTag = " #LvarBodyTag#">
	</cfif>
	<cfset LvarCrLn = chr(13) & chr(10)>
	<cfsavecontent variable="LvarOnEnterKey">
		<cf_onEnterKey>
	</cfsavecontent>
	<cfset templatedata = mid(templatedata,1,LvarPto-1) & 
				"#LvarBodyTag#>#LvarCrLn##LvarOnEnterKey#" & 
				mid(templatedata,LvarPto+1,len(templatedata))
	>
</cfif>

<cfset _dolar_dolar_1 = FindNoCase('$$BODY', templatedata)>
<cfset _dolar_dolar_2 = _dolar_dolar_1>
<cfloop condition="true">
	<cfset _dolar_dolar_next = Find('$$', templatedata, _dolar_dolar_2+1)>
	<cfif _dolar_dolar_next LE 0>
		<cfbreak>
	</cfif>
	<cfset _dolar_dolar_2 = _dolar_dolar_next>
</cfloop><!------>
</cfsilent>
<cfoutput># REReplaceNoCase(
	 Mid(templatedata, 1, _dolar_dolar_1 - 1),
	 '\$\$[A-Z]+[^$]*\$\$', '', 'all')#</cfoutput>
<cfset Request.templatefooterdata =  REReplaceNoCase(
	Mid(templatedata, _dolar_dolar_2 + 2, Len(templatedata) - _dolar_dolar_2 - 1),
	 '\$\$[A-Z]+[^$]*\$\$', '', 'all')>
<cfif Attributes.pNavegacion>
	<cfinclude template="../../home/menu/pNavegacion.cfm">
</cfif>

<link rel="stylesheet" type="text/css" href="/cfmx/sif/TagsSIF/niftyCorners.css">
<script type="text/javascript" src="/cfmx/sif/TagsSIF/niftycube.js"></script>
<cfset session.porlets ="">


