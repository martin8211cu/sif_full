<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
</cfif>
<cfparam name="url.s" type="string" default="">
<cfif Len(url.s) is 0>
	<cflocation url="empresa.cfm">
</cfif>

<cfquery name="rsContents" datasource="asp" >
	select
	  rtrim(m.SScodigo) as SScodigo,
	  rtrim(m.SMcodigo) as SMcodigo,
	  m.SMdescripcion,
	  m.SMhomeuri,
	  datalength (SSlogo) as SSlogosz,
	  datalength (SMlogo) as SMlogosz, m.ts_rversion SMtimestamp,
	  SMhablada
	from SSistemas s, SModulos m
	where exists (select * from vUsuarioProcesos up
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and up.SScodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and up.SScodigo = m.SScodigo
	  and up.SScodigo = s.SScodigo
	  and up.SMcodigo = m.SMcodigo)
	  and s.SScodigo = m.SScodigo
	  and m.SMmenu = 1
	order by coalesce(m.SMorden, 9999), upper( m.SMdescripcion )
</cfquery>
<cfif rsContents.RecordCount EQ 1>
	<cfif Len(Trim(rsContents.SMhomeuri))>
		<cflocation url="/cfmx#Trim(rsContents.SMhomeuri)#">
	<cfelse>
		<cflocation url="modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#">
	</cfif>
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

<cfquery name="empresa" datasource="asp">
	select Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfif empresa.RecordCount eq 0>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="sistema" datasource="asp">
	select SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>
<cfif sistema.RecordCount eq 0>
	<cflocation url="empresa.cfm">
</cfif>

<link href="menu.css" rel="stylesheet" type="text/css">

<table class="navbar"><tr>
	<td nowrap><a href="index.cfm">Inicio</a></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput><a href="empresa.cfm">#empresa.Enombre#</a></cfoutput></td>
	<td nowrap>|</td>
	<td nowrap><cfoutput>#sistema.SSdescripcion#</cfoutput></td>
	<td width="100%">&nbsp;</td>
	<td nowrap><a href="passch.cfm">Cambiar contrase&ntilde;a </a></td>
</tr>
</table>

<cfinclude template="usuarioempresa.cfm">
	
<cfif rsContents.RecordCount gt 1 >

	<cf_web_portlet titulo="#sistema.SSdescripcion#">
	<table border="0" cellpadding="4" cellspacing="4" align="center">

	<tr><cfoutput query = "rsContents">
		<cfif Len(Trim(rsContents.SMhomeuri))>
			<cfset uri = '/cfmx' & Trim(rsContents.SMhomeuri)>
		<cfelse>
			<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
		</cfif>
		
		<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & ".cfm">
		<cfif not FileExists( ExpandPath( snapshot))>
			<cfset snapshot = "">
		</cfif>
		
		<td class="">
		<cfif len(trim(snapshot)) eq 0>
			<a class="menutitulo plantillaMenutitulo" href="#uri#">
				<cfif #rsContents.SMlogosz# GT 1>
				
					<cfinvoke 
						 component="sif.Componentes.DButils"
						 method="toTimeStamp"
						 returnvariable="tsurl">
							<cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>
						</cfinvoke>
						<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&ts=#tsurl#" border="0">

				<cfelse>
					<img src="content_arrow.gif" border="0">
				</cfif></a>
		</cfif>
		</td>
		<td>
		<cfif len(trim(snapshot)) eq 0>
			<a class="menutitulo plantillaMenutitulo" href="#uri#">
				#rsContents.SMdescripcion#
			</a><cfif Len(Trim(rsContents.SMhablada))><br>#rsContents.SMhablada#</cfif>
		<cfelse>
			<cftry>
				<cfinclude template="#snapshot#">
				<cfcatch>#rsContents.SMdescripcion#</cfcatch>
			</cftry>
		</cfif>
		<cfif rsContents.CurrentRow mod 2 eq 0>
			</tr><tr>
		</cfif>
		</td>
	</cfoutput>
	</tr>
	</table>
	</cf_web_portlet>
<cfelseif rsContents.RecordCount eq 1>
	<cflocation url="/cfmx#rsContents.Shomeuri#">
<cfelseif rsContents.RecordCount eq 0>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>

<cfinclude template="footer.cfm">

</cf_templatearea>
</cf_template>