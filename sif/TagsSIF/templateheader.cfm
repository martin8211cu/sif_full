<cfsilent>
<cfparam name="Attributes.template" 	type="string" 	default="">
<cfparam name="Attributes.title" 		type="string" 	default="">
<cfparam name="Attributes.pNavegacion" 	type="boolean" 	default="yes">
<cfparam name="Attributes.bodyTag" 		type="string" 	default="">
<cfparam name="Attributes.skin" 		type="string"	default="Normal">
<cfparam name="Attributes.bloquear" 	type="boolean"	default="false">

<cfif Len(Attributes.template) Is 0 and IsDefined('session.sitio.template')>
	<cfset Attributes.template=session.sitio.template>
</cfif>

<!-----20141028 fcastro, si no se selecciona un titulo especifico para el encabezado se le coloca el del proceso de ser posible--->
<cfif not len(trim(Attributes.title)) and isDefined("session.monitoreo.SScodigo") and isDefined("session.monitoreo.SMcodigo") and isDefined("session.monitoreo.SPcodigo")><!----- fcastro si no se selecciona un titulo especifico para el encabezado se le coloca el del proceso de ser posible, sino el nombre de la corporación--->
	<cfquery datasource="asp" name="translate_SPcodigo" maxrows="1">
		select SPdescripcion from SProcesos where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#"> and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#"> and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="#translate_SPcodigo.SPdescripcion#" VSgrupo="103" returnvariable="Attributes.title"/>
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
					<table><tr><td>$$LEFT OPTIONAL$$</td><td>$$BODY$$</td></tr></table></body></html>
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
	<cfset request.usepNavegacion=true>
</cfif>
<cfset session.porlets ="">
<cfif Attributes.bloquear>
	<cfset Request.bloquear = true>
	<script type="text/javascript">
        !window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.js"><\/script>');
    </script>
    <script type="text/javascript" src="/cfmx/jquery/librerias/jquery.blockUI.js"></script>
    <style type="text/css">
	</style>
    <script type="text/javascript">
        $.blockUI({ 
			message: '<h1><img src="/cfmx/jquery/imagenes/busy.gif" /> Espere mientras se carga la p&aacute;gina.</h1>', 
			overlayCSS: {backgroundColor: '#000', opacity: 0.1 },
			centerY: 0, 
            css: { top: '10px', left: '', right: '10px', backgroundColor: '#0489B1', color: '#fff'  } 
		});
    </script>
</cfif>


