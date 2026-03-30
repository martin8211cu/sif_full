<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
</cfif>

<cfparam name="url.s" type="string" default="">

<cfif Len(url.s) is 0>
	<cflocation url="empresa.cfm">
</cfif>

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
	where s.SScodigo  = '#url.s#'
	  and s.SScodigo = m.SScodigo
	  and m.SMmenu = 1
	  and exists (
		select 1 
		from vUsuarioProcesos up
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo   = #Session.EcodigoSDC#
		  and up.SScodigo  = '#url.s#'
		  and up.SScodigo = m.SScodigo
		  and up.SScodigo = s.SScodigo
		  and up.SMcodigo = m.SMcodigo)
	order by coalesce(m.SMorden, 9999), upper( m.SMdescripcion )
</cfquery>

<cfif rsContents.RecordCount EQ 1>
	<cfset session.menues.Modulo1 = true>
		<cfif Len(Trim(rsContents.SMhomeuri))>
			<cflocation url="/cfmx#Trim(rsContents.SMhomeuri)#">
		<cfelse>
			<cflocation url="modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#">
		</cfif>
<cfelseif rsContents.RecordCount eq 0>
	<cfoutput><cf_translate  key="LB_AunNoHaSidoAfiliadoANingunModulo">A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo</cf_translate></cfoutput>
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
	select SScodigo, SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>

<cfif sistema.RecordCount eq 0>
	<cflocation url="empresa.cfm">
</cfif>

<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->
<cfset request.PNAVEGACION_SHOWN = 1>
<cfset LvarTitulo = "Cambio de Módulo">
<cf_templateheader title="#LvarTitulo#">
<table class="navbar">
	<tr>
		<td nowrap><a href="index.cfm"><cf_translate  key="LB_Inicio">Inicio</cf_translate></a></td>
		<td nowrap>&gt;</td>
		<td nowrap><cfoutput><a href="empresa.cfm">#empresa.Enombre#</a></cfoutput></td>
		<td nowrap>&gt;</td>
			<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#sistema.SScodigo#"
			Default="#sistema.SSdescripcion#"
			VSgrupo="101"
			returnvariable="translated_Sistema"/> 
		<td nowrap><cfoutput>#translated_Sistema#</cfoutput></td>
		<td width="100%" align="right">|</td>
		<td nowrap><a href="passch.cfm"><cf_translate  key="LB_CambiarContrasena">Cambiar contrase&ntilde;a</cf_translate> </a></td>
		<td nowrap>|</td>
		<td nowrap><a href="../public/logout.cfm"><cf_translate  key="LB_Salir">Salir</cf_translate></a></td>
	</tr>
</table>
<!--- <cfinclude template="usuarioempresa.cfm"> --->
<cfif rsContents.RecordCount gt 1 >
	<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#rsContents.SScodigo#"
	Default="#rsContents.SSdescripcion#"
	VSgrupo="101"
	returnvariable="translated_Sistema"/> 
	<cf_web_portlet_start titulo="#translated_Sistema#">
	<table border="0" cellpadding="0" cellspacing="0" align="center" <cfif url.s eq'RH'> width="950"<cfelse> width="500"</cfif> >
		<tr>
			<cfif url.s eq'RH'>
				<td width="40%" rowspan="29" background="../../plantillas/Sapiens/css/sapiens/images/espora21.png" style=""></td>
				<td width="1%"></td>
				<td width="1%"></td>
				<td width="34%"></td>
			<cfelse>
				<td width="1%"></td>
				<td width="1%"></td>
				<td width="98%"></td>
			</cfif>
		</tr>
		<tr>
			<cfoutput>
				<td class="menuhead plantillaMenuhead"  style="border:0px solid" <cfif url.s eq'RH'> colspan="3" align="left"<cfelse>colspan="3"</cfif>>
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
									<cfinvokeargument name="arTimeStamp" value="#rsContents.SStimestamp#"/></cfinvoke>
									<cfif url.s eq'RH'>
										<img src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#1&amp;ts=#tsurl#" border="0" width="130" height="105">
									<cfelse>
										<img src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" width="150" height="100">
									</cfif>
										<br>
								<cfelse>
									<img src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" width="245" height="155">
									<br>
								</cfif>
								
								<cfif url.s neq'RH'>
									<cfinvoke component="sif.Componentes.TranslateDB"
									method="Translate"
									VSvalor="#Trim(rsContents.SSCODIGO)#"
									Default="#rsContents.SSdescripcion#"
									VSgrupo="101"
									returnvariable="translated_Opcion"/>
									#HTMLEditFormat(translated_Opcion)#
								</cfif>
							<cfelse>
								<cftry>
									<cfinclude template="#snapshot#">
									<cfcatch>#rsContents.SSdescripcion#<cfset snapshot=""></cfcatch>
								</cftry>
							</cfif>
						<cfif Len(Trim(rsContents.SShablada))><br><span class="menuhablada plantillaMenuhablada">#rsContents.SShablada#</span></cfif><br>
				</td>
			</cfoutput>
		</tr>
		<tr><td style="height:5px;">&nbsp;</td></tr>
			
		<cfoutput query = "rsContents">
		<tr>				
			<cfif Len(Trim(rsContents.SMhomeuri))>
				<cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
			<cfelse>
				<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
			</cfif>
			
			<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & ".cfm">
			
			<cfif not FileExists( ExpandPath( snapshot))>
				<cfset snapshot = "">
			</cfif>
			<td <cfif url.s eq'RH'>align="right" width="900"<cfelse>align="left"</cfif> valign="top">
				<cfif len(trim(snapshot)) eq 0>
					<a class="menutitulo plantillaMenutitulo" href="#uri#">
					<cfif Len(rsContents.SMlogo) GT 1>
						<cfinvoke 
						 component="sif.Componentes.DButils"
						 method="toTimeStamp"
						 returnvariable="tsurl">
						<cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>	</cfinvoke>
						<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&amp;ts=#tsurl#" border="0">
					<cfelse>
						<!---<img src="../public/imagen.cfm?f=/home/menu/imagenes/content_arrow.gif" border="0">--->
						<!--- chr(9658) es el codigo ascii de ► en codificacion UTF-8 --->
						<font class="imagen_sistema">&##9658;</font>				
					</cfif>
				</cfif>
			</td>
				<td width="600">&nbsp;</td>
				<td class=""  align="left" valign="top">
					<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#Trim(rsContents.SScodigo)#.#Trim(rsContents.SMcodigo)#"
					Default="#rsContents.SMdescripcion#"
					VSgrupo="102"
					returnvariable="translated_Opcion"/>
					<cfif len(trim(snapshot)) eq 0>
						<a class="menutitulo plantillaMenutitulo" href="#uri#">
							<cfif url.s eq'RH'>
								<font color="131d52">#translated_Opcion#</font>
							<cfelse>
								<font style="text-decoration:underline";font:"bold">#translated_Opcion#	</font>
							</cfif>
						</a>
					<cfelse>
						<cftry>
							<cfinclude template="#snapshot#">
							<cfcatch>#translated_Opcion#</cfcatch>
						</cftry>
					</cfif>
					<cfif Len(Trim(rsContents.SMhablada))><br><span class="menuhablada plantillaMenuhablada">#rsContents.SMhablada#<br></span></cfif><br>					
				</td>
		</tr>
		</cfoutput>
		<tr>
			<td>&nbsp;</td>
			<td colspan="3">
				<cfoutput>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<cfif isdefined("session.menues.Sistema1") and NOT session.menues.Sistema1>
							<tr><td>&nbsp;</td></tr>
							<tr><td class="menuanterior plantillaMenuAnterior" align="right"><a class="menuanterior plantillaMenuAnterior" href="empresa.cfm"><cf_translate  key="LB_CambiarSistema">Cambiar Sistema</cf_translate></a></td></tr>
						</cfif>
						<cfif isdefined("session.menues.Empresa1") and NOT session.menues.Empresa1>
							<tr><td>&nbsp;</td></tr>
							<tr><td class="menuanterior plantillaMenuAnterior" align="right"><a class="menuanterior plantillaMenuAnterior" href="index.cfm"><cf_translate  key="LB_CambiarEmpresa">Cambiar Empresa</cf_translate></a></td></tr>
						</cfif>
						<tr><td>&nbsp;</td></tr>
					</table>
				</cfoutput>	
			</td>
		</tr>
</table>
	<cf_web_portlet_end>
</cfif>
<!---<cfinclude template="footer.cfm">--->
<cf_templatefooter>