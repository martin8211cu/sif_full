<cfparam name="request.sinUsuario" default="false">
<cfparam name="request.sinInicio" default="false">

<cfset tDB = createObject("component","sif.Componentes.TranslateDB")>

<cfif isdefined("Request.NavegacionActiva")>
	<cfreturn>
</cfif>
<cfset request.NavegacionActiva=true>

<cfif isdefined("Request.PNAVEGACION_SHOWN")>
	<ol class="breadcrumb">
        <cfif findnocase('erp.css',session.sitio.css)>
			<cfinclude template="/plantillas/erp/headerAyuda.cfm">
            <cfinclude template="/plantillas/erp/headerBuscador.cfm">
        </cfif>
	  <li><a href="index.cfm"><cf_translate xmlFile="/rh/generales.xml" key="LB_Inicio">Inicio</cf_translate></a></li>
	  <li><cfoutput><a href="empresa.cfm">#session.Enombre#</a></cfoutput></li>
	  <cfif not find('menu/empresa.cfm',cgi.SCRIPT_NAME) and isdefined("session.Sistema")>
	  <li class="active"><cfoutput>#session.Sistema#</cfoutput></li>
	  </cfif>
	</ol>
<cfreturn>
</cfif>
<cfif isdefined("session.menues.omite_pnavegacion")><cfreturn></cfif>
<cfsilent>
	<cfset Request.PNAVEGACION_SHOWN = 1>
    <!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->
    <cfset nav__SScodigo = session.monitoreo.SScodigo>
    <cfset nav__SMcodigo = session.monitoreo.SMcodigo>
    <cfset nav__SPcodigo = session.monitoreo.SPcodigo>
    <cfset nav__SSdescripcion = nav__SScodigo>
    <cfset nav__SMdescripcion = nav__SMcodigo>
    <cfset nav__SPdescripcion = nav__SPcodigo>
    <cfset nav__SShomeuri = '/home/menu/sistema.cfm?s=' & URLEncodedFormat(nav__SScodigo)>
    <cfset nav__SMhomeuri = '/home/menu/modulo.cfm?s='  & URLEncodedFormat(nav__SScodigo) & '&amp;m=' & URLEncodedFormat(nav__SMcodigo)>
    <cfset nav__SPhomeuri = '/home/menu/proceso.cfm?s=' & URLEncodedFormat(nav__SScodigo) & '&amp;m=' & URLEncodedFormat(nav__SMcodigo) & '&amp;p=' & URLEncodedFormat(nav__SPcodigo)>
    <cfquery datasource="asp" name="nav__query" debug="no" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
        select SSdescripcion, SShomeuri
        from SSistemas
        where SScodigo = '#nav__SScodigo#'
    </cfquery>
    <cfif nav__query.RecordCount>
        <cfset nav__SSdescripcion = nav__query.SSdescripcion>
    </cfif>
    <cfif Len(nav__query.SShomeuri) GT 1>
        <cfset nav__SShomeuri     = nav__query.SShomeuri>
    </cfif>
    <cfquery datasource="asp" name="nav__query" debug="no" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
        select SMdescripcion, SMhomeuri
        from SModulos
        where SScodigo = '#nav__SScodigo#'
          and SMcodigo = '#nav__SMcodigo#'
    </cfquery>
    <cfif nav__query.RecordCount>
        <cfset nav__SMdescripcion = nav__query.SMdescripcion>
    </cfif>
    <cfif Len(nav__query.SMhomeuri) GT 1>
        <cfset nav__SMhomeuri     = nav__query.SMhomeuri>
    </cfif>
    <cfquery datasource="asp" name="nav__query" debug="no" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
        select SPdescripcion, SPhomeuri
        from SProcesos
        where SScodigo = '#nav__SScodigo#'
          and SMcodigo = '#nav__SMcodigo#'
          and SPcodigo = '#nav__SPcodigo#'
           <cfif isdefined('CGI.CF_TEMPLATE_PATH') and find('modulo.cfm',CGI.CF_TEMPLATE_PATH,1)>
            and 1 = 2
          </cfif>
    </cfquery>
    <cfif nav__query.RecordCount>
        <cfset nav__SPdescripcion = nav__query.SPdescripcion>
    <cfelse>
        <cfset nav__SPdescripcion = nav__SMdescripcion>
    </cfif>
    <cfif Len(nav__query.SPhomeuri) GT 1>
        <cfset nav__SPhomeuri     = nav__query.SPhomeuri>
    </cfif>
    <cfquery name="RS_modulo" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
        select  SMdescripcion  from SModulos
        where SScodigo = '#session.monitoreo.SScodigo#'
        and SMcodigo   = '#session.monitoreo.SMcodigo#'
    </cfquery>
    <cfset session.monitoreo.Modulo   = RS_modulo.SMdescripcion>
</cfsilent>
<cfset LvarUri = trim(nav__SPhomeuri)>
<cfif right(LvarUri,1) EQ "&">
	<cfset LvarUri = left(LvarUri,len(LvarUri)-1)>
</cfif>
<cfset LvarPto = listLast(LvarUri,".")>
<cfset LvarParm = listLast(LvarPto,"?")>
<cfif LvarPto EQ LvarParm>
	<cfset LvarUri = LvarUri & "?_">
<cfelse>
	<cfset LvarUri = LvarUri & "&_">
</cfif>
<ol class="breadcrumb noprint">
    <cfif findnocase('erp.css',session.sitio.css)>
		<cfinclude template="/plantillas/erp/headerAyuda.cfm">
    	<cfinclude template="/plantillas/erp/headerBuscador.cfm">
    </cfif>
  	<cfif request.sinInicio>
	<cfelse>
		<li><cfoutput><a href="/cfmx/home/menu/empresa.cfm"><cf_translate key="inicio" XmlFile="/home/menu/general.xml" >Inicio</cf_translate></a></cfoutput></li>
	</cfif>
		<li><cfoutput><a href="/cfmx#nav__SShomeuri#">#tDB.translate(nav__SScodigo,nav__SSdescripcion,101)#</a></cfoutput></li>
		<li><cfoutput><a href="/cfmx#nav__SMhomeuri#">#tDB.translate(nav__SScodigo&'.'&nav__SMcodigo,nav__SMdescripcion,102)#</a></cfoutput></li>
	<cfif IsDefined("Regresar") and Len(Regresar) Neq 0>
		<cfset Regresar2 = Replace(Regresar,'/cfmx','')>
			<cfif Not IsDefined('acceso_uri')>
				<cfinclude template="/home/check/acceso_uri.cfm">
			</cfif>
		<cfif (Regresar2 neq nav__SPhomeuri) And acceso_uri(Regresar2)>

			<li><cfoutput><a href="/cfmx#Regresar2#"><cf_translate key="regresar" XmlFile="/home/menu/general.xml" >Regresar</cf_translate></a></cfoutput></li>
		</cfif>
	</cfif>
  <cfif not find('menu/modulo.cfm',cgi.SCRIPT_NAME)>
	  <li><cfoutput><a href="/cfmx#LvarUri#" class="currentProcess">#tDB.translate(nav__SScodigo&'.'&nav__SMcodigo&'.'&nav__SPcodigo,nav__SPdescripcion,103)#</a></cfoutput></li>
  </cfif>
</ol>
