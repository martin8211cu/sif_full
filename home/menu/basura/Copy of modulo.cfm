<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
</cfif>
<cfparam name="url.s" type="string" default="">
<cfif Len(url.s) is 0>
	<cflocation url="empresa.cfm">
</cfif>
<cfif Len(url.m) is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
</cfif>

<cfquery name="rsContents" datasource="asp" >
	select
	  rtrim(p.SScodigo) as SScodigo,
	  rtrim(p.SMcodigo) as SMcodigo,
	  rtrim(p.SPcodigo) as SPcodigo,
	  p.SPdescripcion,
	  p.SPhomeuri,
	  datalength (SPlogo) as SPlogosz,
	  SPhablada
	from SProcesos p
	where exists (select * from vUsuarioProcesos up
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and up.SScodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and up.SMcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and up.SScodigo = p.SScodigo
	  and up.SMcodigo = p.SMcodigo
	  and up.SPcodigo = p.SPcodigo)
	  and p.SPmenu = 1
	order by p.SPorden, upper( p.SPdescripcion )
</cfquery>
<cfif rsContents.RecordCount EQ 1>
	<cfif Len(Trim(rsContents.SPhomeuri)) GT 1>
		<cflocation url="/cfmx#Trim(rsContents.SPhomeuri)#">
	<cfelse>
		<cflocation url="proceso.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&p=#URLEncodedFormat(rsContents.SPcodigo)#">
	</cfif>
</cfif>

<cfquery name="empresa" datasource="asp">
	select Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfif empresa.RecordCount eq 0>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="sistema" datasource="asp">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>
<cfif sistema.RecordCount eq 0>
	<cflocation url="empresa.cfm">
</cfif>

<cfquery name="modulo" datasource="asp">
	select SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
</cfquery>
<cfif modulo.RecordCount is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	SIF
</cf_templatearea>
<cf_templatearea name="left">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<!--- 
	<cfinclude template="/sif/menu.cfm">--->
</cf_templatearea>
<cf_templatearea name="body">

<link href="menu.css" rel="stylesheet" type="text/css">

<table class="navbar"><tr>
	<td nowrap><a href="index.cfm">Inicio</a></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="empresa.cfm">#empresa.Enombre#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="sistema.cfm?s=#URLEncodedFormat(sistema.SScodigo)#">#sistema.SSdescripcion#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput>#modulo.SMdescripcion#</cfoutput></td>
	<td width="100%">&nbsp;</td>
	<td nowrap><a href="passch.cfm">Cambiar contrase&ntilde;a </a></td>
</tr>
</table>
<cfinclude template="usuarioempresa.cfm">
	
<cfif rsContents.RecordCount gt 1 >

	<cf_web_portlet titulo="#modulo.SMdescripcion#">
	<table border="0" cellpadding="4" cellspacing="4" align="center">
	<cfoutput query = "rsContents">
		<tr>
		<cfif Len(Trim(rsContents.SPhomeuri)) GT 1>
			<cfset uri = '/cfmx' & Trim(rsContents.SPhomeuri)>
		<cfelse>
			<cfset uri = 'proceso.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo) & '&p=' & URLEncodedFormat(rsContents.SPcodigo)>
		</cfif>
		
		<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & "_" & rsContents.SPcodigo & ".cfm">
		<cfif not FileExists( ExpandPath( snapshot))>
			<cfset snapshot = "">
		</cfif>
		
		<td class="">
		<cfif len(trim(snapshot)) eq 0>
			<a class="menutitulo plantillaMenutitulo" href="#uri#">
			<cfif #rsContents.SPlogosz# GT 1>
				<cf_leerimagen autosize="true" border="false" tabla="SProcesos" campo="SPlogo"
					condicion="SScodigo = '#rsContents.SScodigo#' and SMcodigo = '#rsContents.SMcodigo#' and SPcodigo = '#rsContents.SPcodigo#' and datalength(SPlogo) > 1 "
					conexion="asp" imgname="imgsp#rsContents.SScodigo##rsContents.SMcodigo##rsContents.SPcodigo#">
			<cfelse>
				<img src="content_arrow.gif" border="0">
			</cfif></a>
		</cfif>
		</td><td class="">
		<cfif len(trim(snapshot)) eq 0>
			<a class="menutitulo plantillaMenutitulo" href="#uri#">
				#rsContents.SPdescripcion#</a>
			<cfif Len(Trim(rsContents.SPhablada))><br>#rsContents.SPhablada#</cfif>
		<cfelse>
			<cftry>
				<cfinclude template="#snapshot#">
				<cfcatch>#rsContents.SPdescripcion#</cfcatch>
			</cftry>
		</cfif>
		</td></tr>
	</cfoutput>
	</table>
	</cf_web_portlet>
<cfelseif rsContents.RecordCount eq 1>
	<cflocation url="/cfmx#rsContents.SPhomeuri#">
<cfelseif rsContents.RecordCount eq 0>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>

<cfinclude template="footer.cfm">

</cf_templatearea>
</cf_template>