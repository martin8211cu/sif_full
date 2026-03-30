<cfif isdefined("Request.PNAVEGACION_SHOWN")><cfreturn></cfif>
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
    <cfquery datasource="asp" name="nav__query" debug="no">
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
    <cfquery datasource="asp" name="nav__query" debug="no">
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
    <cfquery datasource="asp" name="nav__query" debug="no">
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
    <cfquery name="RS_modulo" datasource="asp">
        select  SMdescripcion  from SModulos
        where SScodigo = '#session.monitoreo.SScodigo#'
        and SMcodigo   = '#session.monitoreo.SMcodigo#'
    </cfquery>
    <cfset session.monitoreo.Modulo   = RS_modulo.SMdescripcion>
</cfsilent>
<table class="navbar noprint" border="0">
  <tr>
	<td nowrap><cfoutput><a href="/cfmx/home/menu/empresa.cfm"><cf_translate key="inicio" XmlFile="/home/menu/general.xml" >Inicio</cf_translate></a></cfoutput></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput><a href="/cfmx#nav__SShomeuri#"><cf_TranslateDB VSvalor="#nav__SScodigo#" VSgrupo="101" >#nav__SSdescripcion#</cf_TranslateDB></a></cfoutput></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput><a href="/cfmx#nav__SMhomeuri#"><cf_TranslateDB VSvalor="#nav__SScodigo#.#nav__SMcodigo#" VSgrupo="102" >#nav__SMdescripcion#</cf_TranslateDB></a></cfoutput></td>
	<cfif IsDefined("Regresar") and Len(Regresar) Neq 0>
		<cfset Regresar2 = Replace(Regresar,'/cfmx','')>
			<cfif Not IsDefined('acceso_uri')>
				<cfinclude template="/home/check/acceso_uri.cfm">
			</cfif>
			<cfif (Regresar2 neq nav__SPhomeuri) And acceso_uri(Regresar2)>
			<td nowrap>&gt;</td>
			<td nowrap><cfoutput><a href="/cfmx#Regresar2#"><cf_translate key="regresar" XmlFile="/home/menu/general.xml" >Regresar</cf_translate></a></cfoutput></td>
		</cfif>
	</cfif>
	<td width="100%">&nbsp;</td>
	<cfif IsDefined('session.usuario') And Len(session.usuario)>
	<td nowrap><cf_translate key="usuario" XmlFile="/home/menu/general.xml" >Usuario</cf_translate>:</td>
	<td nowrap>
		<cfoutput>
			<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0 and IsDefined('session.datos_personales')>
				  <font color="##87888e" style="font-size:9px;font-weight:bold;" >
					<cfoutput>#HTMLEditFormat(session.datos_personales.nombre)# #HTMLEditFormat(session.datos_personales.apellido1)# #HTMLEditFormat(session.datos_personales.apellido2)#</cfoutput>
				 
       		</cfif><strong></strong>
			(# HTMLEditFormat(session.usuario) #) </font>
		</cfoutput></td>
	</cfif>
</tr>
<tr>
  <td nowrap class="navbig" colspan="11"><cfoutput><a href="/cfmx#nav__SPhomeuri#?_"><cf_TranslateDB VSvalor="#nav__SScodigo#.#nav__SMcodigo#.#nav__SPcodigo#" VSgrupo="103" >#nav__SPdescripcion#</cf_TranslateDB></a></cfoutput></td>
  </tr>
</table>
