<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="rsContents" datasource="asp" >
	select distinct
	  rtrim(up.SScodigo) as SScodigo,
	  rtrim(up.SMcodigo) as SMcodigo,
	  s.SSdescripcion,
	  s.SShomeuri,
	  m.SMdescripcion,
	  m.SMhomeuri,
	  datalength (SSlogo) as SSlogosz,
	  datalength (SMlogo) as SMlogosz
	from vUsuarioProcesos up, SModulos m, SSistemas s
	where m.SScodigo = s.SScodigo
	  and up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and up.SScodigo = m.SScodigo
	  and up.SMcodigo = m.SMcodigo
	  and s.SSmenu = 1
	  and m.SMmenu = 1
	order by s.SSorden, upper( s.SSdescripcion ), coalesce(m.SMorden, 9999), upper( m.SMdescripcion )
</cfquery>
<cfquery name="rsSistema" dbtype="query">
	select distinct SScodigo
	from rsContents
</cfquery>
<cfif rsSistema.RecordCount EQ 1>
	<cfif Len(Trim(rsContents.SShomeuri))>
		<cfset session.menues.SScodigo = rsContents.SScodigo>
		<cfset session.menues.SMcodigo = "-1">
		<cfset session.menues.SPcodigo = "-1">
		<cflocation url="/cfmx#Trim(rsContents.SShomeuri)#">
	</cfif>
</cfif>
<cfif rsContents.RecordCount EQ 1>
	<cfset session.menues.SScodigo = rsContents.SScodigo>
	<cfset session.menues.SMcodigo = rsContents.SMcodigo>
	<cfset session.menues.SPcodigo = "-1">
	<cfif Len(Trim(rsContents.SMhomeuri))>
		<cflocation url="/cfmx#Trim(rsContents.SMhomeuri)#">
	<cfelse>
		<cflocation url="modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#">
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
	<td nowrap><cfoutput>#empresa.Enombre#</cfoutput></td>
	<td width="100%">&nbsp;</td>
	<td nowrap><a href="passch.cfm">Cambiar contrase&ntilde;a </a></td>
</tr>
</table>

<cfinclude template="usuarioempresa.cfm">

<cfif rsContents.RecordCount gt 0 >
	<cfset td = ArrayNew(1)>
	<cfset td[1] = "">
	<cfset td[2] = "">
	<cfset td_i = 1>
	<cf_web_portlet titulo="Sistemas">
	<table border="0" cellpadding="4" cellspacing="0" align="center" width="90%">
	<cfoutput query="rsContents" group="SScodigo">
		<cfsavecontent variable="thistd">
			<cfif Len(Trim(rsContents.SShomeuri))>
				<cfset uri = '/cfmx' & Trim(rsContents.SShomeuri)>
			<cfelse>
				<cfset uri = 'sistema.cfm?s=' & URLEncodedFormat(rsContents.SScodigo)>
			</cfif>
			<tr><td class="menuhead plantillaMenuhead" colspan="2" style="border-bottom:1px solid ">
				<a class="menuhead plantillaMenuhead" href="#uri#">
				<cfset snapshot = "snapshot/" & rsContents.SScodigo& ".cfm">
				<cfif not FileExists( ExpandPath( snapshot))>
					<cfset snapshot = "">
				</cfif>
				<cfif Len(Trim(snapshot)) EQ 0>
					<cfif #rsContents.SSlogosz# GT 1>
						<cf_leerimagen autosize="true" border="false" tabla="SSistemas" campo="SSlogo"
							condicion="SScodigo = '#rsContents.SScodigo#' and datalength(SSlogo) > 1 "
							conexion="asp" imgname="imgss#rsContents.SScodigo#"><br>
					</cfif>
					#rsContents.SSdescripcion#
				<cfelse>
					<cftry>
						<cfinclude template="#snapshot#">
						<cfcatch>#rsContents.SSdescripcion#<cfset snapshot=""></cfcatch>
					</cftry>
				</cfif>
				</a>
			</td></tr>

			<cfif Len(snapshot) IS 0>
			<cfoutput><tr>
				<cfif Len(Trim(rsContents.SMhomeuri))>
					<cfset uri = '/cfmx' & Trim(rsContents.SMhomeuri)>
				<cfelse>
					<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
				</cfif>
				
				<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & ".cfm">
				<cfif not FileExists( ExpandPath( snapshot))>
					<cfset snapshot = "">
				</cfif>
				
				<td width="1%" class="" align="left">
				<cfif len(trim(snapshot)) eq 0>
					<a class="menutitulo plantillaMenutitulo" href="#uri#">
					<cfif #rsContents.SMlogosz# GT 1>
						<cf_leerimagen autosize="true" border="false" tabla="SModulos" campo="SMlogo"
							condicion="SScodigo = '#rsContents.SScodigo#' and SMcodigo = '#rsContents.SMcodigo#' and datalength(SMlogo) > 1 "
							conexion="asp" imgname="imgsp#rsContents.SScodigo##rsContents.SMcodigo#">
					<cfelse>
						<img src="content_arrow.gif" border="0">
					</cfif>
				</cfif>
				</td>
				<td class="" align="left">
				<cfif len(trim(snapshot)) eq 0>
					<a class="menutitulo plantillaMenutitulo" href="#uri#">
					#rsContents.SMdescripcion#</a><br>
				<cfelse>
					<cftry>
						<cfinclude template="#snapshot#">
						<cfcatch>#rsContents.SMdescripcion#</cfcatch>
					</cftry>
				</cfif>
				</td>
				</tr>
			</cfoutput>
			</cfif>
		</cfsavecontent>
		<cfset td[td_i] = td[td_i]  & thistd>
		<cfset td_i = 3 - td_i>
	</cfoutput>
	
	<cfoutput>
	<tr><td valign="top"><table width="100%">#td[1]#</table></td><td valign="top"><table width="100%">#td[2]#</table></td></tr>
	</cfoutput>
	
	</table>
	</cf_web_portlet>
<cfelse>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>

<cfinclude template="footer.cfm">

</cf_templatearea>
</cf_template>