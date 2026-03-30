<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
</cfif>
<cfparam name="session.menues.Ecodigo" type="string" default="">
<cfparam name="session.menues.SScodigo" type="string" default="">
<cfparam name="session.menues.SMcodigo" type="string" default="">
<cfparam name="url.s" default="#session.menues.SScodigo#">
<cfparam name="url.m" default="#session.menues.SMcodigo#">
<cfparam name="url.n" default="-1">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = -1>
<cfif session.menues.Ecodigo EQ "">
	<cflocation url="index.cfm">
</cfif>
<cfif Len(url.s) is 0>
	<cflocation url="empresa.cfm">
</cfif>
<cfif Len(url.m) is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
</cfif>
<cfset LvarCont = 0>
<cfset LvarCFMXpath = expandPath("/")>
<cfset LvarBASEpath = expandPath("")>
<cfset LvarCURRpath = mid(LvarBASEpath,len(LvarCFMXpath),1000)>

<cfquery name="rsContents" datasource="asp">
	select 	mn.SScodigo,
		mn.SMcodigo,
		mn.SMNcodigo,
		mn.SMNcodigoPadre,
		mn.SMNtipoMenu, mn.SMNnivel
	from SMenues mn
 	where <cfif url.n EQ -1> mn.SMNnivel = 0 <cfelse> mn.SMNcodigo = #url.n#</cfif>
	  and mn.SScodigo = '#url.s#'
	  and mn.SMcodigo = '#url.m#'
</cfquery>
<cfif url.n EQ -1>
	<cfset session.menues.SScodigo = trim(url.s)>
	<cfset session.menues.SMcodigo = trim(url.m)>
	<cfset session.menues.SMNcodigo = "-1">
<cfelse>
	<cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
	<cfset session.menues.SMcodigo = trim(rsContents.SMcodigo)>
	<cfset session.menues.SMNcodigo = trim(url.n)>
</cfif>
<cfset session.monitoreo.SScodigo = session.menues.SScodigo>
<cfset session.monitoreo.SMcodigo = session.menues.SMcodigo>

<cfquery name="RS_modulo" datasource="asp">
	select  SMdescripcion  from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
	and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SMcodigo#">
</cfquery>
<cfset session.monitoreo.Modulo   = RS_modulo.SMdescripcion>

<cfif rsContents.recordCount EQ 0>
	<cfset rsContents.SMNnivel = 0>
<cfelse>
	<cfquery name="rsContents1" datasource="asp">
		select
				p.SScodigo,
				p.SMcodigo,
				p.SPcodigo,
				p.SPhomeuri,
				p.SPhablada,

				mn.SMNcodigoPadre,
				mn.SMNcodigo,
				mn.SMNtipo,
				mn.SMNcolumna,

				case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
				case when mn.SMNtipo = 'P' then p.ts_rversion else mn.ts_rversion end as ts_rversion

		  from SMenues mn
          		inner join SSistemas s on s.SScodigo = mn.SScodigo
                inner join SModulos m  on m.SScodigo = mn.SScodigo and m.SMcodigo = mn.SMcodigo
          		left outer join SProcesos p
                    on p.SScodigo = mn.SScodigo
                   and p.SMcodigo = mn.SMcodigo
                   and p.SPcodigo = mn.SPcodigo
                   and p.SPmenu = 1

		 where s.SSmenu = 1
		   and m.SMmenu = 1
		<cfif rsContents.SMNtipoMenu EQ "1" OR rsContents.SMNtipoMenu EQ "3">
		   and mn.SMNcodigo = #rsContents.SMNcodigo#
		<cfelseif rsContents.SMNtipoMenu EQ "2" OR rsContents.SMNtipoMenu EQ "4">
		   and mn.SMNcodigoPadre = #rsContents.SMNcodigo#
		</cfif>
		   and (
				select count(1)
				  from vUsuarioProcesos up
				 where up.Usucodigo = #Session.Usucodigo#
				   and up.Ecodigo = #Session.Ecodigosdc#
				   and up.SScodigo = mn.SScodigo
				   and up.SMcodigo = mn.SMcodigo

			) > 0
           and (mn.SMNcodigo in (
                select mnp.SMNcodigoPadre
                from vUsuarioProcesos up
                inner join SMenues mnp
                on up.SScodigo = mnp.SScodigo
                and up.SMcodigo = mnp.SMcodigo
                and up.SPcodigo = mnp.SPcodigo
                where up.Usucodigo = #Session.Usucodigo#
                and mnp.SScodigo= '#url.s#'
                and mnp.SMcodigo= '#url.m#'
                and up.Ecodigo = #Session.Ecodigosdc#
                group by mnp.SMNcodigoPadre
			    )
				or mn.SMNcodigoPadre = #rsContents.SMNcodigo#
			    )
			and mn.SMNcodigo in (
				select 	mn1.SMNcodigoPadre
						  from SMenues mn1
		                  	inner join SSistemas s on s.SScodigo = mn1.SScodigo
		                    inner join SModulos m  on m.SScodigo = mn1.SScodigo and m.SMcodigo = mn1.SMcodigo
		                    left outer join SProcesos p
		                    on mn1.SScodigo = p.SScodigo
		                    and mn1.SMcodigo = p.SMcodigo
		                    and mn1.SPcodigo = p.SPcodigo
		                    and p.SPmenu = 1

						 where s.SSmenu = 1
						   and m.SMmenu = 1
						   and mn1.SMNcodigoPadre = mn.SMNcodigo
						   and (
								select count(1)
								  from vUsuarioProcesos up
								 where up.Usucodigo = #Session.Usucodigo#
								   and up.Ecodigo = #Session.Ecodigosdc#
								   and up.SScodigo = mn1.SScodigo
								   and up.SMcodigo = mn1.SMcodigo
								   and (up.SPcodigo = mn1.SPcodigo or mn1.SMNtipo = 'M')
							) > 0
			)
	<cfif rsContents.SMNtipoMenu EQ 4>
	order by SMNcolumna, mn.SMNpath asc
	<cfelse>
	order by mn.SMNpath asc
	</cfif>
	</cfquery>
</cfif>
<cfquery name="empresa" datasource="asp">
	select Enombre
	from Empresa
	where Ecodigo = #session.EcodigoSDC#
</cfquery>
<cfif empresa.RecordCount eq 0>
	<cflocation url="index.cfm">
</cfif>
<cfquery name="sistema" datasource="asp">
	select SScodigo as SScodigo, SSdescripcion as SSdescripcion
	from SSistemas
	where SScodigo = '#url.s#'
</cfquery>
<cfif sistema.RecordCount eq 0>
	<cflocation url="empresa.cfm">
</cfif>
<cfquery name="modulo" datasource="asp">
	select distinct SScodigo, SMcodigo
	  from vUsuarioProcesos
	 where Usucodigo = #Session.Usucodigo#
	   and Ecodigo = #Session.Ecodigosdc#
	   and SScodigo = '#url.s#'
</cfquery>
<cfif modulo.RecordCount is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
<cfelseif modulo.RecordCount is 1>
	<cfset session.menues.Modulo1 = true>
<cfelse>
	<cfset session.menues.Modulo1 = false>
</cfif>
<cfquery name="modulo" datasource="asp">
	select SMdescripcion
	from SModulos
	where SScodigo = '#url.s#'
	  and SMcodigo = '#url.m#'
</cfquery>
<cfif modulo.RecordCount is 0>
	<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_OpcionesDeMenuParaUnModulo"
	default="Opciones de Menú para un Módulo"
	returnvariable="LB_OpcionesDeMenuParaUnModulo"/>
<cfset portletWidth = 900>
<cfif rsContents.recordCount NEQ 0>
	<cfquery dbtype="query" name="columnas">
		select distinct SMNcolumna from rsContents1
	</cfquery>
	<cfif columnas.RecordCount>
		<cfset portletWidth = 900 / columnas.RecordCount>
	</cfif>
</cfif>
<cf_templateheader title="#LB_OpcionesDeMenuParaUnModulo#" Pnavegacion="true">
<!--Variable de session del SMcodigo  -->
<cfset LvarSMcodigo="#session.menues.SMcodigo#">

<cfif isDefined("url.m") and url.m neq "">
	<cfset LvarSMcodigo="#url.m#">
</cfif>

<!--- <!-- Enlace de seccion de parametros -->
<div style="position: fixed; width: 75px; height: 60px; padding: 10px;  bottom: 10px; right: 10px; z-index: 4;">
	<span>
		<a href="/cfmx/sif/ad/catalogos/ParametrosAuxiliaresAD.cfm?SMcodigo=<cfoutput>#LvarSMcodigo#</cfoutput>"
			data-toggle="tooltip" data-placement="top" title="Parametros!">
			<i class="fa fa fa-cogs fa-3x"></i>
		</a>
	</span>
</div> --->


<!--- posiscion widget indicadores --->
<div class="row">
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" tipo="I" posicion="modulo_i_t"/>
</div>
<div class="row">
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" tipo="C" posicion="modulo_t"/>
</div>
<div class="row">
	<cfset sContent = 12>
	<cfset lContent = 0>
	<cfset rContent = 0>
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_l" mostrar="V" extraClass="col-md-3"/>
	<cfif isdefined("request.widgetCount") and request.widgetCount GT 0>
		<cfset sContent = sContent - 3>
		<cfset lContent = 3>
	</cfif>
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_r" mostrar="V" extraClass="col-md-3 col-md-push-#sContent -3#"/>
	<cfif isdefined("request.widgetCount") and request.widgetCount GT 0>
		<cfset sContent = sContent - 3>
		<cfset rContent = 3>
	</cfif>
	<div class="col col-md-<cfoutput>#sContent#</cfoutput> <cfif lContent+rContent GT 0><cfif lContent EQ 0 or rContent GT 0>col-md-pull-3</cfif></cfif>">
		<div class="row">
			<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_c" mostrar="H" extraClass="col-md-12" widgetSize="6"/>
		</div>
		<cfset LvarMenues=false>
		<div class="row">
		<cfif rsContents.recordCount NEQ 0>
			<cfoutput>
			<cfif rsContents.SMNtipoMenu EQ 4>
				<cfset LvarColumna = rsContents1.SMNcolumna>
				<div class="col col-md-6">
			</cfif>
			<cfloop query="rsContents1">
				<cfset LvarMenues=true>
				<cfif rsContents.SMNtipoMenu EQ 4 AND LvarColumna NEQ rsContents1.SMNcolumna>
					</div>
					<div class="col col-md-6">
					<cfset LvarColumna = rsContents1.SMNcolumna>
				</cfif>
				<cfif rsContents1.SMNtipo EQ "P">
					<cfset fnTitulo ("#rsContents1.SMNtitulo#","#rsContents1.SPhablada#")>
					<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					vsvalor="#Trim(rsContents1.SScodigo)#.#Trim(rsContents1.SMcodigo)#.#Trim(rsContents1.SPcodigo)#"
					default="#rsContents1.SMNtitulo#"
					vsgrupo="103"
					returnvariable="translated_Opcion"/>
					<cfset fnOpcion ("#translated_Opcion#","pagina.cfm?n=#URLEncodedFormat(rsContents1.SMNcodigo)#",#rsContents1.SPlogo#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents1.SMNcodigo)#",#rsContents1.ts_rversion#)>
				<cfelse>
					<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					vsvalor="#rsContents1.SMNcodigo#"
					default="#rsContents1.SMNtitulo#"
					vsgrupo="105"
					returnvariable="translated_Menu"/>
					<cf_web_portlet_start titulo="#translated_Menu#"  width="#portletWidth#">
					<cfquery name="rsContents2" datasource="asp">
						select 	mn.SMNcodigo,
								case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
								mn.SMNimagenPequena,
								mn.SMNtipo,
								mn.SMNnivel, SMNenConstruccion,
								case when mn.SMNtipo = 'P' then p.ts_rversion else mn.ts_rversion end as ts_rversion,
								p.SPhomeuri, p.SScodigo,p.SMcodigo,p.SPcodigo, p.SPlogo,coalesce(p.SPorden,9999) as SPorden
						  from SMenues mn
		                  	inner join SSistemas s on s.SScodigo = mn.SScodigo
		                    inner join SModulos m  on m.SScodigo = mn.SScodigo and m.SMcodigo = mn.SMcodigo
		                    left outer join SProcesos p
		                    on mn.SScodigo = p.SScodigo
		                    and mn.SMcodigo = p.SMcodigo
		                    and mn.SPcodigo = p.SPcodigo
		                    and p.SPmenu = 1

						 where s.SSmenu = 1
						   and m.SMmenu = 1
						   and mn.SMNcodigoPadre = #rsContents1.SMNcodigo#
						   and (
								select count(1)
								  from vUsuarioProcesos up
								 where up.Usucodigo = #Session.Usucodigo#
								   and up.Ecodigo = #Session.Ecodigosdc#
								   and up.SScodigo = mn.SScodigo
								   and up.SMcodigo = mn.SMcodigo
								   and (up.SPcodigo = mn.SPcodigo or mn.SMNtipo = 'M')
							) > 0
						order by  s.SScodigo,  m.SMcodigo, p.SPorden
					</cfquery>
					<ul>
						<cfloop query="rsContents2">
							<cfinvoke component="sif.Componentes.TranslateDB"
							method="Translate"
							vsvalor="#Trim(rsContents2.SScodigo)#.#Trim(rsContents2.SMcodigo)#.#Trim(rsContents2.SPcodigo)#"
							default="#rsContents2.SMNtitulo#"
							vsgrupo="103"
							returnvariable="translated_Opcion"/>
							<cfif rsContents2.SMNenConstruccion EQ "1" OR (rsContents2.SMNtipo EQ "P" AND fnUri(rsContents2.SPhomeuri) EQ "/cfmx/")>
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_LaOpcionNoEstaDisponibleEnEsteMomento"
								default="La Opción no está  disponible en este momento"
								returnvariable="LB_LaOpcionNoEstaDisponibleEnEsteMomento"/>
								<cfset fnOpcion ("#translated_Opcion#","javascript:alert('#LB_LaOpcionNoEstaDisponibleEnEsteMomento#');")>
							<cfelseif rsContents2.SMNtipo EQ "P">
								<cfset fnOpcion ("#translated_Opcion#","pagina.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.SPlogo#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.ts_rversion#)>
							<cfelseif rsContents2.SMNtipo EQ "M">
								<cfinvoke component="sif.Componentes.TranslateDB"
								method="Translate"
								vsvalor="#rsContents2.SMNcodigo#"
								default="#rsContents2.SMNtitulo#"
								vsgrupo="105"
								returnvariable="translated_Menu1"/>
								<cf_web_portlet_start titulo="#translated_Menu1#"  width="#portletWidth#">
									<cfquery name="rsContents3" datasource="asp">
										select 	mn.SMNcodigo,
												case when mn.SMNtipo = 'P' then p.SPdescripcion else mn.SMNtitulo end as SMNtitulo,
												mn.SMNimagenPequena,
												mn.SMNtipo,
												mn.SMNnivel, SMNenConstruccion,
												case when mn.SMNtipo = 'P' then p.ts_rversion else mn.ts_rversion end as ts_rversion,
												p.SPhomeuri, p.SScodigo,p.SMcodigo,p.SPcodigo, p.SPlogo,coalesce(p.SPorden,9999) as SPorden
										from SMenues mn
											inner join SSistemas s on s.SScodigo = mn.SScodigo
											inner join SModulos m  on m.SScodigo = mn.SScodigo and m.SMcodigo = mn.SMcodigo
											left outer join SProcesos p
											on mn.SScodigo = p.SScodigo
											and mn.SMcodigo = p.SMcodigo
											and mn.SPcodigo = p.SPcodigo
											and p.SPmenu = 1
										where s.SSmenu = 1
										and m.SMmenu = 1
										and mn.SMNcodigoPadre = #rsContents2.SMNcodigo#
										and (
												select count(1)
												from vUsuarioProcesos up
												where up.Usucodigo = #Session.Usucodigo#
												and up.Ecodigo = #Session.Ecodigosdc#
												and up.SScodigo = mn.SScodigo
												and up.SMcodigo = mn.SMcodigo
												and (up.SPcodigo = mn.SPcodigo or mn.SMNtipo = 'M')
											) > 0
										order by  s.SScodigo,  m.SMcodigo, p.SPorden
									</cfquery>
									<ul>
										<cfloop query="rsContents3">
											<cfinvoke component="sif.Componentes.TranslateDB"
											method="Translate"
											vsvalor="#Trim(rsContents3.SScodigo)#.#Trim(rsContents3.SMcodigo)#.#Trim(rsContents3.SPcodigo)#"
											default="#rsContents3.SMNtitulo#"
											vsgrupo="103"
											returnvariable="translated_Opcion"/>
											<cfif rsContents3.SMNenConstruccion EQ "1" OR (rsContents3.SMNtipo EQ "P" AND fnUri(rsContents3.SPhomeuri) EQ "/cfmx/")>
												<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="LB_LaOpcionNoEstaDisponibleEnEsteMomento"
												default="La Opción no está  disponible en este momento"
												returnvariable="LB_LaOpcionNoEstaDisponibleEnEsteMomento"/>
												<cfset fnOpcion ("#translated_Opcion#","javascript:alert('#LB_LaOpcionNoEstaDisponibleEnEsteMomento#');")>
											<cfelseif rsContents3.SMNtipo EQ "P">
												<cfset fnOpcion ("#translated_Opcion#","pagina.cfm?n=#URLEncodedFormat(rsContents3.SMNcodigo)#",#rsContents3.SPlogo#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents3.SMNcodigo)#",#rsContents2.ts_rversion#)>
											<cfelse>
												<cfset fnOpcion ("#translated_Opcion#","modulo.cfm?n=#rsContents3.SMNcodigo#&p=#url.n#",#rsContents3.SMNimagenPequena#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents3.SMNcodigo)#",#rsContents2.ts_rversion#)>
											</cfif>
										</cfloop>
									</ul>
								<cf_web_portlet_end>
							<cfelse>
								<cfset fnOpcion ("#translated_Opcion#","modulo.cfm?n=#rsContents2.SMNcodigo#&p=#url.n#",#rsContents2.SMNimagenPequena#,"logo_menu.cfm?n=#URLEncodedFormat(rsContents2.SMNcodigo)#",#rsContents2.ts_rversion#)>
							</cfif>
						</cfloop>
					</ul>
					<cf_web_portlet_end>
				</cfif>
			</cfloop>
			<cfif rsContents.SMNtipoMenu EQ 4>
				</div>
			</cfif>
			</cfoutput>
		</cfif>
		</div>
		<div class="row">
			<div class="col col-md-12">
			<cfif rsContents.SMNnivel EQ "0" or rsContents.recordCount EQ 0>
				<cfoutput>
				<cfquery name="rsContentsP" datasource="asp">
					select
			        	p.SPcodigo as SPcodigo,
						p.SPdescripcion as SPdescripcion,
						p.ts_rversion as ts_rversion,
						p.SPhomeuri as SPhomeuri,
			            p.SPlogo as SPlogo,
			            p.SScodigo as SScodigo,
			            p.SMcodigo as SMcodigo
					from vUsuarioProcesos up
			        	inner join SSistemas s on up.SScodigo = s.SScodigo
			            inner join SModulos m  on up.SScodigo = m.SScodigo and up.SMcodigo = m.SMcodigo
			            inner join SProcesos p on up.SScodigo = p.SScodigo and up.SMcodigo = p.SMcodigo and up.SPcodigo = p.SPcodigo
					where up.Usucodigo = #Session.Usucodigo#
					  and up.Ecodigo   = #Session.Ecodigosdc#
					  and up.SScodigo  = '#url.s#'
					  and up.SMcodigo  = '#url.m#'
					  and s.SSmenu = 1
					  and m.SMmenu = 1
					  and p.SPmenu = 1
					  and (
							select count(1)
							  from SMenues mnp
							 where up.SScodigo = mnp.SScodigo
							   and up.SMcodigo = mnp.SMcodigo
							   and up.SPcodigo = mnp.SPcodigo
						) = 0
					order by s.SSorden, s.SScodigo, m.SMorden, m.SMcodigo, SPorden
				</cfquery>

				<cfif rsContentsP.recordCount EQ 1 AND (NOT isdefined("rsContents2") OR rsContents2.recordCount EQ 0)>
					<cfset url.p = Trim(rsContentsP.SPcodigo)>
					<cfset StructDelete(url, 'n')>
					<cfinclude template="pagina.cfm"><cfabort>
					<cflocation url="pagina.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(Trim(rsContentsP.SPcodigo))#" addtoken="no">
				<cfelseif rsContentsP.recordCount GT 0>
					<cfif rsContents.recordCount GT 0 AND rsContents.SMNtipoMenu NEQ "1">
						<cfset fnTitulo ("Otras Opciones en #modulo.SMdescripcion#","")>
					<cfelse>
						<cfset fnTitulo ("Opciones en #modulo.SMdescripcion#","")>
					</cfif>
					<ul>
					<cfloop query="rsContentsP">
						<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						vsvalor="#Trim(rsContentsP.SScodigo)#.#Trim(rsContentsP.SMcodigo)#.#Trim(rsContentsP.SPcodigo)#"
						default="#rsContentsP.SPdescripcion#"
						vsgrupo="103"
						returnvariable="translated_SPdescripcion"/>
						<cfif fnUri(rsContentsP.SPhomeuri) EQ "/cfmx/">
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_LaOpcionNoEstaDisponibleEnEsteMomento"
							default="La Opción no está disponible en este momento"
							returnvariable="LB_LaOpcionNoEstaDisponibleEnEsteMomento"/>
							<cfset fnOpcion ("#translated_SPdescripcion#","javascript:alert('<cfoutput>#LB_LaOpcionNoEstaDisponibleEnEsteMomento#</cfoutput>');",#rsContentsP.SPlogo#,"logo_proceso.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(Trim(rsContentsP.SPcodigo))#",#rsContentsP.ts_rversion#)>
						<cfelse>
							<cfset fnOpcion ("#translated_SPdescripcion#","pagina.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(rsContentsP.SPcodigo)#",#rsContentsP.SPlogo#,"logo_proceso.cfm?s=#URLEncodedFormat(url.s)#&m=#URLEncodedFormat(url.m)#&p=#URLEncodedFormat(Trim(rsContentsP.SPcodigo))#",#rsContentsP.ts_rversion#)>
						</cfif>
					</cfloop>
					</ul>
				</cfif>
				</cfoutput>
			</cfif>
			</div>
		</div>
		<cfif isdefined("rsContents2")>
			<div class="row">
			<cfif rsContents1.recordCount EQ 1 AND rsContents2.recordCount EQ 1 AND (not isdefined("rsContentsP") OR rsContentsP.recordCount EQ 0)>
				<cfif rsContents2.SMNenConstruccion EQ "1" OR (rsContents2.SMNtipo EQ "P" AND fnUri(rsContents2.SPhomeuri) EQ "/cfmx/")>
				<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="left" class="menutitulo plantillaMenutitulo" valign="top" colspan="6">
					<cf_translate  key="LB_LaOpcionNoEstaDisponibleEnEsteMomento">La Opción no está disponible en este momento</cf_translate>
				</td>
				</tr>
				<cfelseif rsContents2.SMNtipo EQ "P">
					<cflocation url="pagina.cfm?n=#rsContents2.SMNcodigo#">
				<cfelseif rsContents.SMNtipoMenu EQ "2" or rsContents.SMNtipoMenu EQ "4">
					<cfparam name="url.p" default="-1">
					<cfif url.p EQ "-1">
						<cflocation url="modulo.cfm?n=#rsContents2.SMNcodigo#">
					<cfelse>
						<cflocation url="modulo.cfm?n=#rsContents2.SMNcodigo#&p=#url.p#">
					</cfif>
				</cfif>
			</cfif>
			</div>
		</cfif>
	</div>
</div>
<div class="row">
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_b" mostrar="H" extraClass="col-md-12" widgetSize="4"/>
</div>
<div class="row">
	<cf_poswidget sistema="#Session.menues.SSCODIGO#" modulo="#Session.menues.SMCODIGO#" posicion="modulo_bl" mostrar="H" extraClass="col-md-12" widgetSize="12"/>
</div>

<cf_templatefooter>

<cffunction name="fnTitulo" output="true" displayname="fnTitulo" hint="fnTitulo">
	<cfargument name="Titulo" type="string">
	<cfargument name="Explicacion" type="string">
	<cfargument name="Imagen" type="any">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<tr>
		<td width="10">&nbsp;</td>
		<td width= "1">&nbsp;</td>
		<td width= "1">&nbsp;</td>
		<td width="95">&nbsp;</td>
		<td width="10">&nbsp;</td>
		<td width="1000">&nbsp;</td>
	</tr>
	<cfif rsContents.SMNtipoMenu EQ "4">
		<tr>
			<td rowspan="2">&nbsp;</td>
			<td valign="top" colspan="5" class="menuhead plantillaMenuhead">
			<cfif isdefined("Imagen") AND isBinary("#Imagen#")>
				<cfset fnDesplegarImg (Imagen,ImagenUrl,ts)>
				<br>
			</cfif>
				<strong style="color:##000000">#titulo#</strong>
			</td>
		</tr>
		<tr>
			<td valign="middle" colspan="5" class="menuhablada plantillaMenuhablada">
				#explicacion#
			</td>
		</tr>
	<cfelseif isdefined("Imagen") AND isBinary("#Imagen#")>
		<tr>
			<td height="70" rowspan="2">&nbsp;</td>
			<td height="70" rowspan="2" colspan="3" valign="top" align="center">
				<cfset fnDesplegarImg (Imagen,ImagenUrl,ts)>
			</td>
			<td height="70" rowspan="2">&nbsp;</td>
			<td height="1" valign="top" class="menuhead plantillaMenuhead">
				#titulo#
			</td>
		</tr>
		<tr>
			<td height="69" valign="middle" class="menuhablada plantillaMenuhablada">
				#explicacion#
			</td>
		</tr>
	<cfelse>
		<tr>
			<td rowspan="2">&nbsp;</td>
			<td valign="top" colspan="5" class="menuhead plantillaMenuhead">
				#titulo#
			</td>
		</tr>
		<tr>
			<td valign="middle" colspan="5" class="menuhablada plantillaMenuhablada">
				#explicacion#
			</td>
		</tr>
	</cfif>
	<tr><td style="height:5px;">&nbsp;</td></tr>
</cffunction>

<cffunction name="fnOpcion" output="true" displayname="fnOpcion" hint="fnOpcion">
	<cfargument name="Titulo" type="string">
	<cfargument name="Pagina" type="string">
	<cfargument name="Imagen" type="any">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<li>
		<cfif !(Titulo EQ "")>
			<a href="#Pagina#">
				<cfif isdefined("Imagen") AND isBinary("#Imagen#")>
					<cfset fnDesplegarImg (Imagen, ImagenUrl, ts)>
				</cfif>
				#Titulo#
			</a>
		</cfif>
	</li>
</cffunction>

<cffunction name="fnUri" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn "/cfmx" & pUri>
		<cfelse>
			<cfreturn "/cfmx/" & pUri>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnDesplegarImg" output="true">
	<cfargument name="Imagen" type="binary">
	<cfargument name="ImagenUrl" type="string">
	<cfargument name="ts" type="any">
	<!--- Procesar el BLOB --->
	<cfinvoke
	 component="sif.Componentes.DButils"
	 method="toTimeStamp"
	 returnvariable="ts2">
		<cfinvokeargument name="arTimeStamp" value="#ts#"/>
	</cfinvoke>
	<cfoutput>
	<img src="../public/#ImagenUrl#&amp;ts=#ts2#" border="0">
	</cfoutput>
</cffunction>
<script type="text/javascript">
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});
</script>