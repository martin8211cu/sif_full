<cfset fnGeneraOpcionesMenuConsultasCM()>
<cf_templateheader title="Consultas y Reportes de Compras">
	<br>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consultas y Reportes de Compras">
	<cfflush interval="20">
	<cfinclude template="../portlets/pNavegacion.cfm">
	<table width="75%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr >
			<td valign="top" height="50%">
				<br>
				<cfif ArrayLen(consultas) gt 0>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<cfloop from="1" to="#ArrayLen(consultas)#" index="i">
							<cfset opcion = consultas[i]>
							<cfoutput>
								<cfif findnocase("Solicitudes",opcion.titulo,1)  and TituloSol EQ 0>
									<tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Solicitudes de Compra</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloSol = TituloSol +1>
								</cfif>
								<cfif findnocase("Solicitudes",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("&Oacute;rdenes",opcion.titulo,1)  and TituloOrd EQ 0>
									<cfif TituloSol GT 0>
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td>&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead"style="font-size:#letra#px; " colspan="2" align="left">&Oacute;rdenes de Compra</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloOrd = TituloOrd +1>
								</cfif>
								<cfif findnocase("&Oacute;rdenes",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="left" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo" align="left"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("Recepci&oacute;n",opcion.titulo,1)  and TituloRecep EQ 0>
									<cfif TituloOrd GT 0>
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Recepci&oacute;n</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloRecep = TituloRecep +1>
								</cfif>
								<cfif findnocase("Recepci&oacute;n",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
							</cfoutput>
						</cfloop>
						<cfif TituloCom GT 0>
							<tr><td colspan="2">__________________________________________________________</td></tr>
						</cfif>
					</table>
				<cfelse>
					Gab Usted No tiene acceso para realizar ninguna operaci&oacute;n en este M&oacute;dulo.
				</cfif>
				<br>
			</td>
			<td height="50%" valign="top">
				<br>
				<cfif ArrayLen(consultas) gt 0>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<cfloop from="1" to="#ArrayLen(consultas)#" index="i">
							<cfset opcion = consultas[i]>
							<cfoutput>
								<cfif findnocase("los Compradores",opcion.titulo,1)  and TituloCom EQ 0>
									<cfif TituloRecep GT 0>
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Compradores</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloCom = TituloCom +1>
								</cfif>
								<cfif findnocase("los Compradores",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("de Solicitantes",opcion.titulo,1)  and TituloPer EQ 0>
									<tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Solicitantes</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloPer = TituloPer +1>
								</cfif>
								<cfif findnocase("de Solicitantes",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("Reclamos",opcion.titulo,1)  and TituloRec EQ 0>
									<cfif TituloPer GT 0>
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead" style="font-size:#letra#px; " colspan="2">Reclamos</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloRec = TituloRec +1>
								</cfif>
								<cfif findnocase("Reclamos",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("Tr&aacute;mites",opcion.titulo,1)  and TituloTra EQ 0>
									<cfif TituloRec GT 0>
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; ">Tr&aacute;mites</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloTra = TituloTra +1>
								</cfif>
								<cfif findnocase("Tr&aacute;mites",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<!-------------------------- Contratos--------------------------------------->
								<cfif verifica_Parametro.recordcount GT 0 >
									<cfif findnocase("Contratos",opcion.titulo,1)  and TituloTra EQ 0>
										<cfif TituloRec GT 0>
											<!---<tr><td colspan="2">&nbsp;</td></tr>--->
											<tr><td colspan="2">__________________________________________________________</td></tr>
											<tr><td colspan="2">&nbsp;</td></tr>
										</cfif>
										<tr><td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; ">Contratos</td></tr>
										<tr><td>&nbsp;</td></tr>
										<cfset TituloTra = TituloTra +1>
									</cfif>
									<cfif findnocase("Contratos",opcion.titulo,1)>
										<tr>
											<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
											<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
										</tr>
									</cfif>
								</cfif>
								<!-------------------------- Contratos --------------------------------------->
								<cfif findnocase("Desalmacenaje",opcion.titulo,1)  and TituloDes EQ 0>
									<cfif TituloTra GT 0>
										<!---<tr><td colspan="2">&nbsp;</td></tr>--->
										<tr><td colspan="2">__________________________________________________________</td></tr>
										<tr><td colspan="2">&nbsp;</td></tr>
									</cfif>
									<tr><td class="menuhead plantillaMenuhead" colspan="2" style="font-size:#letra#px; ">Desalmacenaje</td></tr>
									<tr><td>&nbsp;</td></tr>
									<cfset TituloDes = TituloDes +1>
								</cfif>
								<cfif findnocase("Desalmacenaje",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
								<cfif findnocase("Embarque",opcion.titulo,1)>
									<tr>
										<td valign="middle" width="1%" align="right" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
										<td valign="middle" class="menutitulo plantillaMenutitulo"><a href="/cfmx#opcion.uri#">#opcion.titulo#</a></td>
									</tr>
								</cfif>
							</cfoutput>
						</cfloop>
						<cfif TituloDes GT 0>
							<tr><td colspan="2">__________________________________________________________</td></tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</cfif>
					</table>
				</cfif>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cffunction name="fnGeneraOpcionesMenuConsultasCM" access="private" output="no">
	<!--- ============================ --->
	<!---     OPCIONES DE CONSULTAS    --->
	<!--- ============================ --->

	<cfset letra = 13 >
	<cfset TituloSol = 0> 
	<cfset TituloOrd = 0>
	<cfset TituloPer = 0> 
	<cfset TituloRec = 0>
	<cfset TituloCom = 0>
	<cfset TituloTra = 0>
	<cfset TituloDes = 0>

	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
	
	<!--- Coleccion de Opciones --->
	<cfset consultas = ArrayNew(1)>
	<cfset opcion = StructNew()>

	<!---	
		Para efectos de que funcione el menú Dinamicmente, se requiere que se el nombre del link posea el nombre 
		del menú al que pertenecen, ejemplo: Elemento Ordenes de Compra - En el if se preguntará si existe la Palabra Ordenes -
	--->
	
	<!--- Solicitudes de Compra --->
	<cfif isdefined("session.Compras.solicitante") and len(trim(session.Compras.solicitante))>
		<!--- Opciones solo de Solicitantes --->
		<!--- LLlave: Solicitudes --->
		<cfif acceso_uri("/sif/cm/consultas/MisSolicitudes-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/MisSolicitudes-lista.cfm">
			<cfset opcion.titulo = "Solicitudes de Compra">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		<cfif acceso_uri("/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm">
			<cfset opcion.titulo = "Seguimiento de Solicitudes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	</cfif>
	
	<!--- Parametros Adicionales --->
	<cfquery name="verifica_Parametro" datasource="#session.dsn#">
		select 1 from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 730
		and Pvalor = '1'
	</cfquery>
	
	
	<!--- Recepción --->
	<cfif acceso_uri("/sif/cm/consultas/RecepMercNoAplic.cfm")>
		<cfset opcion = StructNew()><!--- Uri, Titulo --->
		<cfset opcion.uri = "/sif/cm/consultas/RecepMercNoAplic.cfm">
		<cfset opcion.titulo = "Recepci&Oacute;n Mercader&iacute; (por aplicar)">
		<cfset ArrayAppend(consultas,opcion)>
	</cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<!--- Opciones solo de Compradores --->
		<cfif acceso_uri("/sif/cm/consultas/SolicitudesPendCotizar.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/SolicitudesPendCotizar.cfm">
			<cfset opcion.titulo = "Solicitudes Pendientes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		<cfif acceso_uri("/sif/cm/consultas/SolicitudCotLocal.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/SolicitudCotLocal.cfm">
			<cfset opcion.titulo = "Solicitudes de Cotizaciones Locales">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		<cfif acceso_uri("/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm">
			<cfset opcion.titulo = "Seguimiento de Solicitudes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		<!--- Ordenes de Compra --->
		<cfif acceso_uri("/sif/cm/consultas/OCLocalProveedor.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/OCLocalProveedor.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra Locales (Proveedor)">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<cfif acceso_uri("/sif/cm/consultas/OrdenesCompra-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/OrdenesCompra-lista.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra (Comprador)">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<cfif acceso_uri("/sif/cm/consultas/saldosOrdenCompra.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/saldosOrdenCompra.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra (Saldos)">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	
		<cfif acceso_uri("/sif/cm/consultas/ComprasProveedor.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/ComprasProveedor.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra (Proveedor)">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		<!--- Solicitante --->
		<cfif acceso_uri("/sif/cm/consultas/DatosSolicitante-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/DatosSolicitante-lista.cfm">
			<cfset opcion.titulo = "Datos de Solicitantes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<cfif acceso_uri("/sif/cm/consultas/PermisosSolicitante-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/PermisosSolicitante-lista.cfm">
			<cfset opcion.titulo = "Permisos de Solicitantes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<!--- Reclamos --->
		<cfif acceso_uri("/sif/cm/consultas/ReclamosHist.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/ReclamosHist.cfm">
			<cfset opcion.titulo = "Hist&oacute;rico de Reclamos">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<cfif acceso_uri("/sif/cm/consultas/HRecepcionReclamos.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/HRecepcionReclamos.cfm">
			<cfset opcion.titulo = "Hist&oacute;rico de Recepci&oacute;n / Reclamos">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	
		<!--- Recepción --->
		<cfif acceso_uri("/sif/cm/consultas/RecepMerc-lista.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/RecepMerc-lista.cfm">
			<cfset opcion.titulo = "Recepci&Oacute;n Mercader&iacute;">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	
		<!--- Datos --->
		<cfif acceso_uri("/sif/cm/consultas/DatosComprador.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/DatosComprador.cfm">
			<cfset opcion.titulo = "Datos de los Compradores">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
		
		<cfif acceso_uri("/sif/cm/consultas/DatosCompradorRango.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/DatosCompradorRango.cfm">
			<cfset opcion.titulo = "Datos de los Compradores por Rango">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	
		<!--- Trámites --->
		<cfif acceso_uri("/sif/tr/consultas/solicitados.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/tr/consultas/solicitados.cfm">
			<cfset opcion.titulo = "Mis Tr&aacute;mites Solicitados">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	
		<cfif acceso_uri("/sif/tr/consultas/pendientes.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/tr/consultas/pendientes.cfm">
			<cfset opcion.titulo = "Mis Tr&aacute;mites Pendientes">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>

		<!--- Trámites --->
		<cfif acceso_uri("/sif/cm/consultas/ConsumoCantContratos.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/ConsumoCantContratos.cfm">
			<cfset opcion.titulo = "Consumo de Cantidades en Contratos ">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>

		<!--- Pólizas de Desalmacenaje --->
		<cfif acceso_uri("/sif/cm/consultas/polizaDesalmacenaje.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/consultas/polizaDesalmacenaje.cfm">
			<cfset opcion.titulo = "Consulta de P&oacute;lizas de Desalmacenaje">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>

		<cfif acceso_uri("/sif/cm/proveedor/seguimientoTracking-filtro.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/proveedor/seguimientoTracking-filtro.cfm">
			<cfset opcion.titulo = "Consulta de Embarques">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>

		<cfif acceso_uri("/sif/cm/proveedor/seguimientoTrackingRango-filtro.cfm")>
			<cfset opcion = StructNew()><!--- Uri, Titulo --->
			<cfset opcion.uri = "/sif/cm/proveedor/seguimientoTrackingRango-filtro.cfm">
			<cfset opcion.titulo = "Seguimiento de Embarques">
			<cfset ArrayAppend(consultas,opcion)>
		</cfif>
	</cfif>
</cffunction>