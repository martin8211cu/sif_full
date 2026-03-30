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
<cfif Len(url.p) is 0>
	<cflocation url="modulo.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#">
</cfif>

<cfquery name="rsContents" datasource="asp" >
	select distinct
	  rtrim(up.SScodigo) as SScodigo,
	  rtrim(up.SMcodigo) as SMcodigo,
	  rtrim(up.SPcodigo) as SPcodigo,
	  p.SCuri,
	  upper(p.SCuri)
	from vUsuarioProcesos up
		inner join SComponentes p
			on up.SScodigo = p.SScodigo
	       and up.SMcodigo = p.SMcodigo
	       and up.SPcodigo = p.SPcodigo
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and up.SScodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and up.SMcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and coalesce ( rtrim ( p.SCuri ),'') != ''
	order by upper(p.SCuri)
</cfquery>
<cfif rsContents.RecordCount EQ 1>
	<cflocation url="/cfmx#Trim(rsContents.SCuri)#">
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
	select rtrim(SMcodigo) as SMcodigo, SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
</cfquery>
<cfif modulo.RecordCount is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
</cfif>

<cfquery name="proceso" datasource="asp">
	select SPdescripcion
	from SProcesos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
</cfquery>
<cfif proceso.RecordCount is 0>
	<cflocation url="modulo.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#">
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

<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

<table class="navbar"><tr>
	<td nowrap><a href="index.cfm">Inicio</a></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="empresa.cfm">#empresa.Enombre#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="sistema.cfm?s=#URLEncodedFormat(sistema.SScodigo)#">#sistema.SSdescripcion#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="modulo.cfm?s=#URLEncodedFormat(sistema.SScodigo)#&m=#URLEncodedFormat(modulo.SMcodigo)#">#modulo.SMdescripcion#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput>#proceso.SPdescripcion#</cfoutput></td>
	<td width="100%">&nbsp;</td>
	<td nowrap><a href="passch.cfm">Cambiar contrase&ntilde;a </a></td>
</tr>
</table>
<cfinclude template="usuarioempresa.cfm">
	
<cfif rsContents.RecordCount gt 0 >
	<cf_web_portlet titulo="#sistema.SSdescripcion#">
	<table border="0" cellpadding="4" cellspacing="4" align="center">
	<cfoutput>
	<tr>
	  <td colspan="4" >#sistema.SSdescripcion#</td>
	  </tr>
	<tr>
	  <td >&nbsp;</td>
	  <td colspan="3" >#modulo.SMdescripcion#</td>
	  </tr>
	<tr>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  <td colspan="2" >#proceso.SPdescripcion#</td></tr>
	<tr>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  <td >&nbsp;</td>
	  <td >No se ha definido la p&aacute;gina de inicio de este proceso. </td>
	</tr>
	</cfoutput>
	</table>
	</cf_web_portlet>

<cfelseif rsContents.RecordCount eq 0>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>

<cfinclude template="footer.cfm">


</cf_templatearea>
</cf_template>