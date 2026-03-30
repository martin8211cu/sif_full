<cfif isdefined("url.seleccionar_EcodigoSDC")>
	<cfset session.menues.Ecodigo = session.Ecodigo>
</cfif>
<cfset session.menues.SScodigo = "">
<cfset session.menues.SMcodigo = "">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Sistema1=false>
<cfset session.menues.Modulo1=false>

<cfquery name="rsContents" datasource="asp" >
	select 
	  rtrim(s.SScodigo) as SScodigo,
	  rtrim(m.SMcodigo) as SMcodigo,
	  s.SSdescripcion, s.SShablada,
	  s.SShomeuri,
	  m.SMdescripcion,
	  m.SMhomeuri,
	  SSlogo, s.ts_rversion SStimestamp,
	  SMlogo, m.ts_rversion SMtimestamp
	from SModulos m, SSistemas s
	where m.SScodigo = s.SScodigo
	  and exists (
	  		select * from vUsuarioProcesos up
			 join SProcesos p
				on up.SScodigo = p.SScodigo
			   and up.SMcodigo = p.SMcodigo
			   and up.SPcodigo = p.SPcodigo
			   and p.SPmenu = 1 
		where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
		  and up.SScodigo = m.SScodigo
		  and up.SMcodigo = m.SMcodigo)
	  and s.SSmenu = 1
	  and m.SMmenu = 1
	order by s.SSorden, upper( s.SSdescripcion ), coalesce (m.SMorden, 9999), upper( m.SMdescripcion )
</cfquery>

<cfquery name="rsSistema" dbtype="query">
	select distinct SScodigo
	from rsContents
</cfquery>
<cfif rsSistema.RecordCount EQ 1>
	<cfset session.menues.Sistema1=true>
	<cfif Len(Trim(rsContents.SShomeuri))>
		<cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
		<cfset session.menues.SMcodigo = "">
		<cfset session.menues.SPcodigo = "">

		<cfset url.s = rsContents.SScodigo>
		<cfinclude template="pagina.cfm"><cfreturn>
	</cfif>
</cfif>
<cfif rsContents.RecordCount EQ 1>
	<cfset session.menues.Modulo1=true>
	<cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
	<cfset session.menues.SMcodigo = trim(rsContents.SMcodigo)>
	<cfset session.menues.SPcodigo = "">
	<cfif Len(Trim(rsContents.SMhomeuri))>
		<cfset url.s = rsContents.SScodigo>
		<cfset url.m = rsContents.SMcodigo>
		<cfinclude template="pagina.cfm"><cfreturn>

	<cfelse>
		<cfset url.s = rsContents.SScodigo>
		<cfset url.m = rsContents.SMcodigo>
		<cfinclude template="modulo.cfm"><cfreturn>
	</cfif>
</cfif>

<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

<cfset MostrarHablada = true>

<cfif rsContents.RecordCount gt 0 >

<table width="510" border="0" cellpadding="2" cellspacing="0" >
	<cfset i = 1 >
	<cfset fila = 0 >
	<cfoutput query="rsContents" group="SScodigo">
			<cfif i mod 2 >
				<tr>
				<cfset fila = fila+1 >
			</cfif>
			<cfset columna = abs((i mod 2)-2) >
			<td width="50%" valign="top">
				<cf_web_portlet border="true" skin="Gray" tituloalign="left" titulo='#rsContents.SSdescripcion#'>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" >
					

					<tr> 
						<td colspan="2" valign="top"> 
							<table width="100%" cellpadding="3" cellspacing="0" >
								<tr>
									<td align="center">
										<cfif Len(rsContents.SSlogo) GT 1>
											<cfinvoke 
											 component="sif.Componentes.DButils"
											 method="toTimeStamp"
											 returnvariable="tsurl">
												<cfinvokeargument name="arTimeStamp" value="#rsContents.SStimestamp#"/>
											</cfinvoke>
											<img align="middle" src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" >
										<cfelse>
											<img align="middle" src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" >
										</cfif>
									</td>
								</tr>
								
								<tr>
									<td valign="top">
										<cfset j = 1 >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<cfoutput>
												<!--- ///////////////////////////////////////////////////////////// --->
												<cfif Len(Trim(rsContents.SShomeuri))>
													<!--- <cfset uri = '/cfmx' & Trim(rsContents.SShomeuri)> --->
													<cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo)>
												<cfelse>
													<!--- <cfset uri = 'sistema.cfm?s=' & URLEncodedFormat(rsContents.SScodigo)> --->
													<cfset uri = "">
												</cfif>
												<cfif Len(Trim(rsContents.SMhomeuri))>
													<!--- <cfset uri = '/cfmx' & Trim(rsContents.SMhomeuri)> --->
													<cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
												<cfelse>
													<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
												</cfif>
												<!--- ///////////////////////////////////////////////////////////// --->
												
												<cfif j mod 2 ><tr></cfif>
												<td valign="top">
													<table width="100%" border="0" cellpadding="0" >
														<tr>
															<!---<a class="menutitulo plantillaMenutitulo" href="#uri#">--->
															<td valign="top" width="1%">
															<cfif Len(rsContents.SMlogo) GT 1>
																<cfinvoke 
																 component="sif.Componentes.DButils"
																 method="toTimeStamp"
																 returnvariable="tsurl">
																	<cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>
																</cfinvoke>
																<!---<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&amp;ts=#tsurl#" border="0">--->
																<a class="menutitulo plantillaMenutitulo" href="#uri#">
																<img align="top" src="../imagenes/bl-bullet.gif" border="0" height="8" width="2">
																<!---<img src="../imagenes/role_1005.gif" border="0">---></a>
															<cfelse>
																<img align="top" src="../imagenes/bl-bullet.gif" border="0" height="8" width="2">
															</cfif>
															</td>
															<td valign="middle" ><a class="fbox" href="#uri#">#rsContents.SMdescripcion#</a></td>
															</a>
														</tr>
													</table>
												</td>
												<cfif not j mod 2></tr></cfif>
												<cfset j = j+1 >
											</cfoutput>
											<!--- cierra el ultimo tr, si hay uno abierto --->
											<cfif not j mod 2></tr></cfif>
										</table>
									</td>
								</tr>
								
							</table>
						</td>
					</tr>
				</table>
				</cf_web_portlet>

			</td>
			<cfif (not i mod 2) >
				</tr>
			</cfif>
	
			<cfset i = i+1 >
	</cfoutput>
	<!--- cierra el ultimo tr abierto --->
	<cfif (not i mod 2) >
		</tr>
	</cfif>

</table>
<cfelse>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
</cfif>