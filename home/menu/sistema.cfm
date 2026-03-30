<cfset t=createObject("component", "sif.Componentes.Translate")>

<cfif REFind('soinasp01_sapiens.css',session.sitio.CSS)>
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
		  SMhablada, s.ts_rversion SStimestamp, s.SSdescripcion, s.SShablada,m.SGcodigo
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
	<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#sistema.SScodigo#"
				Default="#sistema.SSdescripcion#"
				VSgrupo="101"
				returnvariable="translated_Sistema"/>
	<cf_templateheader title="#LvarTitulo#">
		<!--- <cfinclude template="usuarioempresa.cfm"> --->
	<cfif rsContents.RecordCount gt 1 >
		<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#rsContents.SScodigo#"
		Default="#rsContents.SSdescripcion#"
		VSgrupo="101"
		returnvariable="translated_Sistema"/>
		<cf_web_portlet_start titulo="#translated_Sistema#">

		<table border="0" cellpadding="0" cellspacing="0" align="center" <cfif url.s eq'RH'> width="950" height="550"<cfelse> width="500" </cfif>>
			<tr>
				<cfif url.s eq'RH'>
					<td width="40%" rowspan="50" height="90%" style="background-repeat:no-repeat" background="../../plantillas/Sapiens/css/sapiens/images/espora2.png"></td>
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
											<img src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" width="130" height="105">
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
	<!---Todas las demas plantillas--->
<cfelse>

	<cfif session.EcodigoSDC is 0>
		<cflocation url="index.cfm">
	</cfif>

	<cfparam name="url.s" type="string" default="">

	<cfif Len(url.s) is 0>
		<cflocation url="empresa.cfm">
	</cfif>
	<cfset session.menues.SMcodigo  = "">
	<cfset session.menues.SPcodigo  = "">
	<cfset session.menues.SMNcodigo = "-1">
	<cfset session.menues.Modulo1   = false>
	<cfquery name="rsContents" datasource="asp" >
		select
		  rtrim(m.SScodigo) as SScodigo,
		  rtrim(m.SMcodigo) as SMcodigo,
		  m.SMdescripcion, s.SSdescripcion,
		  m.SMhomeuri,SMlogo,
		  m.ts_rversion SMtimestamp,
		  s.ts_rversion SStimestamp,
		 <cf_dbfunction name="length" args="s.SSlogo">	  as SSlogo,
		 <cf_dbfunction name="length" args="m.SMhablada"> as SMhablada,
		 <cf_dbfunction name="length" args="s.SShablada"> as SShablada,
		 m.SMhablada as descModulo,
		 m.IconFonts,
		 m.SMorden,m.SGcodigo,
		 s.SShomeuri
		from SSistemas s
			inner join SModulos m
				on s.SScodigo = m.SScodigo
		where s.SScodigo  = '#url.s#'
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
		order by m.SMorden,m.IconFonts desc, upper( m.SMdescripcion )desc
	</cfquery>

	<cfif rsContents.RecordCount EQ 1 or (isDefined("rsContents.SShomeuri") and rsContents.SShomeuri NEQ '')>
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

	<cfset request.PNAVEGACION_SHOWN = 1>
	<cfset LvarTitulo = "Cambio de Módulo">

	<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#sistema.SScodigo#"
		Default="#sistema.SSdescripcion#"
		VSgrupo="101"
		returnvariable="translated_Sistema"/>
	<cfset session.Sistema = translated_Sistema>

	<cf_templateheader title="#LvarTitulo#">
	<!--- <cfinclude template="usuarioempresa.cfm"> --->
	<cfif rsContents.RecordCount gt 1 >
		<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#Trim(rsContents.SSCODIGO)#"
				Default="#rsContents.SSdescripcion#"
				VSgrupo="101"
				returnvariable="translated_Opcion"/>
		<div class="row divSistema">
			<div class="col-xs-12">
				<cfif isDefined("url.s") and listfindnocase('RH,SIF',url.s)>
					<cfinclude template="sistemaGrupado.cfm">
				<cfelse>
					<cfset LvarCorte=0>
					<cfoutput query = "rsContents">
						<cfif LvarCorte eq 0>
							<div class="row"><!---Inicio pintado de los modulos row --->
						</cfif>
						<cfset LvarCorte+=1>

							<!---Traducción del modulo--->
							<cfinvoke component="sif.Componentes.TranslateDB"
									method="Translate"
									VSvalor="#Trim(rsContents.SScodigo)#.#Trim(rsContents.SMcodigo)#"
									Default="#rsContents.SMdescripcion#"
									VSgrupo="102"
									returnvariable="translated_Opcion"/>
							<!---Direccion URL del modulo--->



							<cfif Len(Trim(rsContents.SMhomeuri))>
								<cfset uri = 'pagina.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
							<cfelse>
								<cfset uri = 'modulo.cfm?s=' & URLEncodedFormat(rsContents.SScodigo) & '&m=' & URLEncodedFormat(rsContents.SMcodigo)>
							</cfif>



								<div class="ModuloFather col-lg-2 col-md-2 col-sm-6 col-xs-12">
									<div class="Modulo" onclick="location.href='#uri#';" id="MM-#rsContents.SMcodigo#">
										<div class="Modulo-icon">
											<cfif Len(Trim(rsContents.IconFonts)) gt 0>
												<span class="#rsContents.IconFonts# IconFont"></span>
											<cfelse>
												<span class="icon-expediente-nomina IconFont">
												</span>
											</cfif>
										</div>
										<div class="Modulo-Up"></div>
										<div class="Modulo-Label">#translated_Opcion#</div>
									</div><!--- fin del modulo---->
									<!---Descripcion del modulo--->
										<cfset DescricionModulo = rsContents.SMhablada>

										<cfset snapshot = "snapshot/" & rsContents.SScodigo & "_" & rsContents.SMcodigo & ".cfm">

										<cfif not FileExists( ExpandPath( snapshot))>
											<cfset snapshot = "">
										</cfif>

										<!---<cfif len(trim(snapshot)) eq 0>
											<a class="menutitulo plantillaMenutitulo" href="#uri#">
											<cfif Len(rsContents.SMlogo) GT 1>
												<cfinvoke  component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl">
													<cfinvokeargument name="arTimeStamp" value="#rsContents.SMtimestamp#"/>
												</cfinvoke>
												<img src="../public/logo_modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&m=#URLEncodedFormat(rsContents.SMcodigo)#&amp;ts=#tsurl#" border="0">
											</cfif>
										</cfif>--->

										<cfif len(trim(snapshot)) eq 0>
											<a class="menutitulo plantillaMenutitulo" href="#uri#"></a>
										<cfelse>
											<cftry>
												<cfinclude template="#snapshot#">
												<cfcatch>#translated_Opcion#</cfcatch>
											</cftry>
										</cfif>
								</div><!----- fin modulo father--->
						<cfif LvarCorte eq 6 or rsContents.currentrow eq rsContents.recordcount >
							</div><!---Fin Pintado de los modulos row--->
							<cfset LvarCorte=0>
						</cfif>
					</cfoutput>
				</cfif>
			</div><!----- fin de la cuadricula derecha---->
		</div>
	</cfif>
	<cfif isdefined('session.sitio.footer') and LEN(trim(session.sitio.footer))>
		<cf_templatefooter>
	<cfelse>
		<cfinclude template="footer.cfm">
	</cfif>

</cfif>