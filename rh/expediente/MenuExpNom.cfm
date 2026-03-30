<!--- 
	Creado por: Ana Villavicencio
	Fecha: 19 de enero del 2006
	Motivo: Reordenar el menu de Expediente y Nómina, para que no se vea tan saturado.
 --->
<!--- SE MODIFICO EL QUERY PORQUE NO ESTABA TOMANDO EN CUENTA LOS PROCESOS ASIGNADOS POR USUARIO, 
	ESTABA PONIENDO TODAS LAS OPCIONES.--->
<cfset session.monitoreo.forzar = true>
<cfset session.menues.SScodigo = "RH">
<cfset session.menues.SMcodigo = "NOMINA">
<cfset session.menues.SPcodigo = "INCIDENCIA">

<cfquery name="rsOpcionesMenu" datasource="asp">	
	select  case coalesce(mn.opcionprin,0) when 0 then 0 else 1 end as procesoPrincipal,
			case coalesce(mn.siempreabierto,0) when 0 then 0 else 1 end as menuAbierto,
			mn.SMNtitulo as Menu, 
			case mn.SMNnivel when 1 
				then mn.SMNcodigo 
				else mn.SMNcodigoPadre 
			end as MenuID, 
			sp.SScodigo,sp.SMcodigo,sp.SPcodigo,
			sp.SPdescripcion as Proceso, 
			SPhomeuri as ProcesoLink,
			SMNnivel as nivel,
			SMNcodigoPadre as padre,
			SMNcodigo  as ID,
			mn.SMNorden,
			mn.SMNcolumna,
			sp.SPorden, 
			SMNtipoMenu
		from SMenues mn
			left outer join SProcesos sp
				on mn.SScodigo = sp.SScodigo
				and mn.SMcodigo = sp.SMcodigo
				and mn.SPcodigo = sp.SPcodigo
				and sp.SPmenu = 1
		where rtrim(upper(mn.SScodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase('RH')#">
			and rtrim(upper(mn.SMcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase('NOMINA')#">
			and mn.SMNnivel > 0
	
	AND ( sp.SPcodigo IS NULL 		
				OR exists ( select *
					from vUsuarioProcesos up
					left outer join SMenues mp
					on up.SScodigo = mp.SScodigo
					and up.SMcodigo = mp.SMcodigo
					and up.SPcodigo = mp.SPcodigo
	
					where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					  and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					  and up.SScodigo = mn.SScodigo
					  and up.SMcodigo = mn.SMcodigo
					  and up.SPcodigo = mn.SPcodigo))
	order by mn.SMNcolumna,mn.SMNorden,sp.SPorden
</cfquery>

<cfquery name="rsMenus" dbtype="query">
	select *
	from rsOpcionesMenu
	where nivel = 1
</cfquery>
<cfquery name="rsColumnas" dbtype="query">
	select distinct(SMNcolumna)
	from rsMenus
</cfquery>
<cfset Lvar_PorcCol = 100/rsColumnas.RecordCount>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ExpedienteYNomina" Default="Expediente y Nómina" returnvariable="LB_ExpedienteYNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#rsMenus.ID#" Default="#rsMenus.Menu#" VSgrupo="105" returnvariable="translated_Menu"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ExpedienteYNomina#">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
	<style type="text/css">
	.menu_letra_sec{	font:Arial, Helvetica, sans-serif;
						font-size:10px;
						font-weight:normal;
						color: black;
	} 
	</style> 
	<cfset skin = 'azul' >
	<cfif isdefined("session.sitio.css") and len(trim(session.sitio.css))>
		<cfset skin_tmp = listtoarray(session.sitio.css, '_') >
		<cfif arraylen(skin_tmp) gte 2>
			<cfset skin_tmp2 = listtoarray(skin_tmp[2], '.') >
			<cfif arraylen(skin_tmp2) eq 2>
				<cfif listfind('azul,verde,rosa,naranja,gris', skin_tmp2[1])>
					<cfset skin = skin_tmp2[1] >				
				</cfif>
			</cfif>	
		</cfif>
	</cfif>
	
<table border="0"  width="100%">
	<tr>
		<cfloop query="rsColumnas">
			<cfquery name="rsOpciones" dbtype="query">
				select *
				from rsMenus
				where SMNcolumna = #rsColumnas.SMNcolumna#
			</cfquery>
			
		<td valign="top" width="<cfoutput>#Lvar_PorcCol#</cfoutput>%">
			<cfloop query="rsOpciones">
				<cfset Lvar_MenuID =  rsOpciones.MenuID>
				<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#rsOpciones.ID#" Default="#rsOpciones.Menu#" VSgrupo="105" returnvariable="translated_Menu1"/>
				<cf_web_portlet_start border="true" titulo="#translated_Menu1#">
					<cfif rsOpciones.Menu NEQ 'Consultas y Reportes'>
						<table width="100%"cellpadding="2" cellspacing="0" border="0">
							<cfoutput query="rsOpcionesMenu">
								<cfif rsOpcionesMenu.padre EQ Lvar_MenuID>
									<cfif LEN(TRIM(rsOpcionesMenu.Proceso))>
										<tr >
											<td width="1%">&nbsp;</td>
											<td>
												<a href="/cfmx#rsOpcionesMenu.Procesolink#">
												<font class="imagen_sistema">&##9658;</font>				
												</a>
											</td>
											<td width="1%">&nbsp;</td>
											<td width="100%">
												<a href="/cfmx#rsOpcionesMenu.Procesolink#">
												<cf_translatedb VSvalor="#Trim(rsOpcionesMenu.SScodigo)#.#Trim(rsOpcionesMenu.SMcodigo)#.#Trim(rsOpcionesMenu.SPcodigo)#" VSgrupo="103">
												#rsOpcionesMenu.Proceso#
												</cf_translatedb>
												</a>
											</td>
										</tr>
									<cfelse>
										<cfquery name="rsSubmenu" dbtype="query">
											select  *
											from rsOpcionesMenu
											where padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOpcionesMenu.ID#">
										</cfquery>
										
											<cfif rsSubmenu.RecordCount GT 0>
										<tr >
											<td width="3%"	>&nbsp;</td>
											<td> 
												<a href="##">
												<font class="imagen_sistema">#chr(9658)#</font>											
												&nbsp;
												<cf_translatedb VSvalor="#rsOpcionesMenu.ID#" VSgrupo="105">
												#rsOpcionesMenu.Menu#
												</cf_translatedb>											
												</a>
											</td>
										</tr>
												<cfloop query="rsSubmenu">
										<tr id="td#rsSubmenu.ID#">
											<td width="5%">&nbsp;</td>
											<td>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<a href="/cfmx#rsSubmenu.Procesolink#" >
												<font class="imagen_sistema">#chr(9658)#</font>				
												&nbsp;
												<cf_translatedb VSvalor="#Trim(rsSubmenu.SScodigo)#.#Trim(rsSubmenu.SMcodigo)#.#Trim(rsSubmenu.SPcodigo)#" VSgrupo="103">
												#rsSubmenu.Proceso#
												</cf_translatedb>
												</a>
											</td>
										</tr>
												</cfloop>
											
											</cfif>
									</cfif>
								</cfif>
							</cfoutput>
						</table>
					<cfelse>
						<table width="100%">
							<tr>
									<cf_tabs width="100%">								
									<td>
										<cfoutput query="rsOpcionesMenu">
											<cfif rsOpcionesMenu.padre EQ Lvar_MenuID>												
												<cfquery name="rsSubmenu" dbtype="query">
													select  *
													from rsOpcionesMenu
													where padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOpcionesMenu.ID#">
													order by SMNorden
												</cfquery>
												
												<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#rsOpcionesMenu.ID#" Default="#rsOpcionesMenu.Menu#" VSgrupo="105" returnvariable="translated_value"/>
													<cf_tab text="#translated_value#">																				
															<table width="100%" cellpadding="2" cellspacing="0" border="0">
															<cfquery name="rsColumnas" dbtype="query">
																select distinct(SMNcolumna)
																from rsSubmenu
															</cfquery>									
															<tr>
															<cfloop query="rsColumnas">
															<td valign="top">															
															<cfset Lvar_col=rsColumnas.SMNcolumna>
															<cfquery name="rs" dbtype="query">
																select * from rsSubmenu
																where SMNcolumna =#Lvar_col#
															</cfquery>															
															<cfloop query="rs">		
																<cfset Lvar_OPSubmenu = rs.ID>
																	<cfquery name="rsNietos" dbtype="query">
																		select  *
																		from rsOpcionesMenu
																		where padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_OPSubmenu#">
																		order by SMNorden
																	</cfquery>		
																	<cfif rsNietos.recordcount gt 0>																																														
																		<table>
																		<tr>															
																		<td colspan="2">
																			<strong>#rs.menu#</strong>
																		</td>
																		</tr>
																		<cfloop query="rsNietos">															
																		<tr id="td#rsNietos.ID#" >
																			<td valign="middle"><a href="/cfmx#rsNietos.Procesolink#">
																				<font class="imagen_sistema">#chr(9658)#</font>				
																			</td>
																			<td valign="middle" >
																				<a href="/cfmx#rsNietos.Procesolink#">
																				<cf_translatedb VSvalor="#Trim(rsNietos.SScodigo)#.#Trim(rsNietos.SMcodigo)#.#Trim(rsNietos.SPcodigo)#" VSgrupo="103">
																				<font class="menu_letra_sec" color="##000000">#rsNietos.Proceso#</font>
																				</cf_translatedb>
																				</a>
																			</td>
																		</tr>
																		</cfloop>
																		<tr><td>&nbsp;</td></tr>
																		</table>																			
																																		
																	</cfif>
															
															
															<cfif isdefined("rs.procesolink") and len(trim(rs.procesolink))>																
																<tr id="td#rs.ID#" >
																	<td align="left"><a href="/cfmx#rs.Procesolink#">
																		<font class="imagen_sistema">#chr(9658)#</font>				
																	</td>
																	<td>
																		<a href="/cfmx#rs.Procesolink#">
																		<cf_translatedb VSvalor="#Trim(rs.SScodigo)#.#Trim(rs.SMcodigo)#.#Trim(rs.SPcodigo)#" VSgrupo="103">
																		<font class="menu_letra_sec" color="##000000">#rs.Proceso#</font>
																		</cf_translatedb>
																		</a>
																	</td>
																</tr>
															</cfif>	
															</cfloop>			
															</td>																						
															</cfloop>
															</tr>
															</table>															
													</cf_tab>
													<!---</cfloop>--->
												</cfif>												
											</cfoutput>
									</cf_tabs>
								</td>
							</tr>
						</table>			
					</cfif>
			<cf_web_portlet_end>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			</table>			
		</cfloop>
	</td>
	</cfloop>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<cf_templatefooter>
