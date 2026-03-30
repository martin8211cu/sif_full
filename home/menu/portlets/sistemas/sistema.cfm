<cfparam name="url.s" type="string" default="">
<cfset session.menues.SMcodigo = "">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Modulo1=false>

<cfquery name="rsContents" datasource="asp" >
	select
	  rtrim(m.SScodigo) as SScodigo,
	  rtrim(m.SMcodigo) as SMcodigo,
	  m.SMdescripcion, 
	  m.SMhomeuri,
	  SSlogo,
	  SMlogo, m.ts_rversion SMtimestamp,
	  SMhablada, s.ts_rversion SStimestamp, s.SSdescripcion, s.SShablada
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
	<cfset session.menues.Modulo1 = true>
	<cfif Len(Trim(rsContents.SMhomeuri))>
		<cflocation url="/cfmx#Trim(rsContents.SMhomeuri)#">
	<cfelse>
		<cfset url.s=rsContents.SScodigo>
		<cfset url.m=rsContents.SMcodigo>
		<cfinclude template="modulo.cfm">
	</cfif>
<cfelseif rsContents.RecordCount eq 0>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>


<cfquery name="empresa" datasource="asp">
	select Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfquery name="sistema" datasource="asp">
	select SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>

<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

<table class="navbar">
<tr>
	<td nowrap><a href="index.cfm">Inicio</a></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput><a href="empresa.cfm">#empresa.Enombre#</a></cfoutput></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput>#sistema.SSdescripcion#</cfoutput></td>
	<td width="100%" align="right">|</td>
	<td nowrap><a href="passch.cfm">Cambiar contrase&ntilde;a </a></td>
	<td nowrap>|</td>
	<td nowrap><a href="../public/logout.cfm">Salir</a></td>
</tr>
</table>

<cfinclude template="usuarioempresa.cfm">
	
<cfif rsContents.RecordCount gt 1 >
	<table border="0" cellpadding="0" cellspacing="0" align="center" width="510">
		<tr><td width="1%"></td><td width="1%"></td><td width="98%"></td></tr>
		<tr>
		<cfoutput>
			<td class="menuhead plantillaMenuhead" colspan="3" style="border:0px solid">
					<cfset snapshot = "snapshot/" & rsContents.SScodigo& ".cfm">
					<cfif not FileExists( ExpandPath( snapshot))>
						<cfset snapshot = "">
					</cfif>
					<cfif Len(Trim(snapshot)) EQ 0>
						<cfif Len(rsContents.SSlogo) GT 1>
							<cfinvoke 
							 component="sif.Componentes.DButils"
							 method="toTimeStamp"
							 returnvariable="tsurl">
								<cfinvokeargument name="arTimeStamp" value="#rsContents.SStimestamp#"/>
							</cfinvoke>
							<img src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" width="245" height="155">
							<br>
						<cfelse>
							<img src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" width="245" height="155">
							<br>
						</cfif>
						#rsContents.SSdescripcion#
					<cfelse>
						<cftry>
							<cfinclude template="#snapshot#">
							<cfcatch>#rsContents.SSdescripcion#<cfset snapshot=""></cfcatch>
						</cftry>
					</cfif>
					<cfif Len(Trim(rsContents.SShablada))><br><span class="menuhablada plantillaMenuhablada">#rsContents.SShablada#</span></cfif><br>
				</td></tr>
				<tr><td style="height:5px;">&nbsp;</td></tr>
		</cfoutput>
		<cfoutput query = "rsContents">
				<tr>
					<cfif Len(Trim(rsContents.SMhomeuri))>
						<!--- <cfset uri = '/cfmx' & Trim(rsContents.SMhomeuri)> --->
						<cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
					<cfelse>
						<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
					</cfif>
					
					<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & ".cfm">
					<cfif not FileExists( ExpandPath( snapshot))>
						<cfset snapshot = "">
					</cfif>
					
					<td class="" align="center" valign="top">
					<cfif len(trim(snapshot)) eq 0>
						<a class="menutitulo plantillaMenutitulo" href="#uri#">
						<cfif Len(rsContents.SMlogo) GT 1>
							
							<cfinvoke 
							 component="sif.Componentes.DButils"
							 method="toTimeStamp"
							 returnvariable="tsurl">
								<cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>
							</cfinvoke>
							<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&amp;ts=#tsurl#" border="0">
						<cfelse>
							<img src="../public/imagen.cfm?f=/home/menu/imagenes/content_arrow.gif" border="0">
						</cfif>
					</cfif>
					</td>
					<td>&nbsp;</td>
					<td class="" align="left" valign="top">
					<cfif len(trim(snapshot)) eq 0>
						<a class="menutitulo plantillaMenutitulo" href="#uri#">
							#rsContents.SMdescripcion#
						</a>
					<cfelse>
						<cftry>
							<cfinclude template="#snapshot#">
							<cfcatch>#rsContents.SMdescripcion#</cfcatch>
						</cftry>
					</cfif>
					<cfif Len(Trim(rsContents.SMhablada))><br><span class="menuhablada plantillaMenuhablada">#rsContents.SMhablada#<br></span></cfif><br>
					</td>
		</tr></cfoutput>
	</table>
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<cfif isdefined("session.menues.Sistema1") and NOT session.menues.Sistema1>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="empresa.cfm">Cambiar Sistema</a></td></tr>
		</cfif>
		<cfif isdefined("session.menues.Empresa1") and NOT session.menues.Empresa1>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="menuanterior plantillaMenuAnterior"><a class="menuanterior plantillaMenuAnterior" href="index.cfm">Cambiar Empresa</a></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>	
</cfif>
