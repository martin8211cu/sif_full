<cfif isdefined("Session.Compras.ProcesoCompra.Pantalla") and Session.Compras.ProcesoCompra.Pantalla NEQ 0>
	<cfset Session.Compras.ProcesoCompra.Pantalla = 0>
</cfif>
<cfset fnGeneraOpcionesMenuCM()>
<cf_templateheader title="Compras">
		<cfinclude template="../portlets/pNavegacionCM.cfm">
		<!--- ======================== --->
		<!--- Pinta los TABS--->
		<!--- ======================== --->
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Men&uacute; Principal de Compras'>
					<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; ">
						<tr>
							<td valign="top">
								<cf_tabs width="100%">
									<div id="opcion1" <cfif tabChoice neq 1>style="display:none; vertical-align:top"</cfif>>
										<cf_tab text="#tabNames[1]#" selected="#tabChoice eq 1#">
										<cfinclude template="MCM-OpcionesPC.cfm">
										</cf_tab>
									</div>
									<div id="opcion2" <cfif tabChoice neq 2>style="display:none; vertical-align:top"</cfif>>
										<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
										<cfinclude template="MCM-OpcionesRR.cfm">
										</cf_tab>
									</div>
									<div id="opcion3" <cfif tabChoice neq 3>style="display:none; vertical-align:top"</cfif>>
										<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
										<cfinclude template="MCM-OpcionesCI.cfm">
										</cf_tab>
									</div>
									<div id="opcion4" <cfif tabChoice neq 4>style="display:none; vertical-align:top"</cfif>>
										<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
										<cfinclude template="MCM-OpcionesCR.cfm">
										</cf_tab>
									</div>
								</cf_tabs>
							</td>
							<cfflush interval="20">
							<td valign="top" align="center" width="25%">
								<table width="95%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cfinclude template="MCM-frameCatalogos.cfm"></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td><cfinclude template="MCM-frameOtros.cfm"></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<cf_web_portlet_end>
<cf_templatefooter>
<!--- ======================================== --->
<!--- HACE LA REDIRECCION AL TAB SELECCIONADO  --->
<!--- ======================================== --->
<script language="JavaScript" type="text/javascript">
	function opciones(seleccion,liga,cantidad){
		var noSeleccionada = '<cfoutput>#Session.Preferences.Skin#_tabnorm</cfoutput>';
		var seleccionada = '<cfoutput>#Session.Preferences.Skin#_tabsel</cfoutput>';

		for ( var i=1; i<=cantidad; i++  ){
			if (seleccion==i){
				document.getElementById("td_"+i).className = seleccionada;
				document.getElementById("opcion"+i).style.display = '';
			}
			else{
				document.getElementById("td_"+i).className = noSeleccionada;
				document.getElementById("opcion"+i).style.display = 'none';
			}
		}
	}
</script>
<cffunction name="fnGeneraOpcionesMenuCM" access="private" output="no">
	<!--- ======================== --->
	<!--- Nombres de los TABS--->
	<!--- ======================== --->
	<cfset tabNames = ArrayNew(1)>
	<cfset tabNames[1] = "Proceso de Compra">
	<cfset tabNames[2] = "Recepci&oacute;n y Reclamo">
	<cfset tabNames[3] = "C&aacute;lculo de Importaciones">
	<cfset tabNames[4] = "Consultas y Reportes">

	<cfset tabLinks = ArrayNew(1)>
	<cfset tabLinks[1] = "MenuCM_2.cfm?o=1">
	<cfset tabLinks[2] = "MenuCM_2.cfm?o=4">
	<cfset tabLinks[3] = "MenuCM_2.cfm?o=2">
	<cfset tabLinks[4] = "MenuCM_2.cfm?o=3">

	<cfset tabStatusText = ArrayNew(1)>
	<cfset tabStatusText[1] = "Proceso de Compra">
	<cfset tabStatusText[2] = "Recepci&oacute;n y Reclamo">
	<cfset tabStatusText[3] = "C&aacute;lculo de Importaciones">
	<cfset tabStatusText[4] = "Consultas y Reportes">

	<!----Verificar si esta encendido el parámetro de múltiples contratos---->
	<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
			and Pcodigo = 730
	</cfquery>

	<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->

	<cfset fnVerificaOpcionesMenuCMPC()>
	<cfset fnGeneraOpcionesCMRR()>
	<cfset fnGeneraOpcionesCMCI()>

	<cfset opcion = StructNew()>	<!--- Uri, Titulo --->

	<cfset fnGeneraOpcionesCMCR()>
	<cfset fnGeneraOpcionesCatalogosCM()>
	<cfset fnGeneraOpcionesMenuCMOtros()>

	<cfset tabChoice = 1>
	<cfif isdefined("url.o") and len(trim(url.o))>
		<cfset tabChoice = url.o >
	<cfelse>
		<cfset m1List = "">
		<cfloop from="1" to="#ArrayLen(menu1)#" index="i">
			<cfset m1List = ListAppend(m1List, menu1[i].uri, '!')>
		</cfloop>
		<cfset m2List = "">
		<cfloop from="1" to="#ArrayLen(menu4)#" index="i">
			<cfset m2List = ListAppend(m2List, menu4[i].uri, '!')>
		</cfloop>
		<cfset m3List = "">
		<cfloop from="1" to="#ArrayLen(menu2)#" index="i">
			<cfset m3List = ListAppend(m3List, menu2[i].uri, '!')>
		</cfloop>
		<cfset m4List = "">
		<cfloop from="1" to="#ArrayLen(menu3)#" index="i">
			<cfset m4List = ListAppend(m4List, menu3[i].uri, '!')>
		</cfloop>
		<cfif isdefined("cgi.HTTP_REFERER") and Len(Trim(cgi.HTTP_REFERER))>
			<cfif FindNoCase('/sif', cgi.HTTP_REFERER) GT 0>
				<cfif ListFindNoCase(m1List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
					<cfset tabChoice = 1>
					<cfset Request.tabChoice = 1>
				<cfelseif ListFindNoCase(m2List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
					<cfset tabChoice = 2>
					<cfset Request.tabChoice = 2>
				<cfelseif ListFindNoCase(m3List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
					<cfset tabChoice = 3>
					<cfset Request.tabChoice = 3>
				<cfelseif ListFindNoCase(m4List, Mid(cgi.HTTP_REFERER, FindNoCase('/sif', cgi.HTTP_REFERER), Len(cgi.HTTP_REFERER)), '!')>
					<cfset tabChoice = 4>
					<cfset Request.tabChoice = 4>
				</cfif>
			<cfelse>
				<cfset tabChoice = 1>
				<cfset Request.tabChoice = 1>
			</cfif>
		<cfelse>
			<cfset tabChoice = 1>
			<cfset Request.tabChoice = 1>
		</cfif>
	</cfif>
</cffunction>
<cffunction name="fnVerificaOpcionesMenuCMPC" access="private" output="no">
	<cfset menu1 = ArrayNew(1)>		<!--- Coleccion de Opciones --->

	<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
		<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
		<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#">
			select 1
			from CMUsuarioAutorizado
			where Ecodigo   = #session.Ecodigo#
			  and Usucodigo = #session.Usucodigo#
		</cfquery>
	</cfif>
	<cfif isdefined("session.Compras.solicitante") and len(trim(session.Compras.solicitante))>
		<!--- Opciones solo de Solicitantes --->
		<cfif acceso_uri("/sif/cm/operacion/solicitudes-lista.cfm") >
			<cfset opcion.uri = "/sif/cm/operacion/solicitudes-lista.cfm">
			<cfset opcion.titulo = "Registro de Solicitudes de Compra">
			<cfset opcion.descripcion = "Este proceso permite la inclusi&oacute;n de solicitudes de compra para cualquier art&iacute;culo,
			servicio o activo que la empresa requiera adquirir, este proceso se realiza de forma individual por cada uno de
			los solicitantes de la empresa previo a su aprobaci&oacute;n y tr&aacute;mite en el &aacute;rea de proveedur&iacute;a de la empresa.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>
	</cfif>

	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/compraProceso.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/compraProceso.cfm">
			<cfset opcion.titulo = "Publicaci&oacute;n de Compra">
			<cfset opcion.descripcion = "Mediante este proceso se puede iniciar un trámite de compra, que incluye la selecci&oacute;n de las
			líneas de cada solicitud de compra que se desea incluir en el proceso, la selecci&oacute;n de los proveedores que se desea que
			participen, mediante cotizaciones, la publicaci&oacute;n del proceso, la importaci&oacute;n de las cotizaciones de los proveedores, y
			la cotizaci&oacute;n manual, de ser necesario.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>
		<cfif acceso_uri("/sif/cm/operacion/evaluarCotizaciones.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/evaluarCotizaciones.cfm">
			<cfset opcion.titulo = "Evaluaci&oacute;n de Cotizaciones">
			<cfset opcion.descripcion = "Este proceso de la aplicaci&oacute;n es utilizado por los compradores de la empresa, el mismo permite a
			cada uno de estos realizar la comparaci&oacute;n de las diferentes ofertas o cotizaciones que fueron realizadas a fin de abastecer o
			surtir solicitudes de materiales. Como resultado de este proceso se obtiene una o varias &oacute;rdenes de compra que abastecen las
			necesidades de las solicitudes de materiales que se cotizaron y que se evaluaron como parte del proceso.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>

		<cfif acceso_uri("/sif/cm/operacion/listaOrdenCM.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/listaOrdenCM.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra">
			<cfset opcion.descripcion = "Este proceso permite realizar la creaci&oacute;n de &oacute;rdenes de compra de forma manual, este tipo de
			&oacute;rdenes de compra se realiza en aquellos casos en que se desea realizar una compra directa o que no involucra una solicitud
			de materiales o el proceso de cotizaron hacia proveedores.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>

		<cfif acceso_uri("/sif/cm/operacion/anulaOrden.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/anulaOrden.cfm">
			<cfset opcion.titulo = "Anulaci&oacute;n &Oacute;rdenes de Compra">
			<cfset opcion.descripcion = "Este proceso permite anular una Orden de Compra que no ha sido Aplicada.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>

		<cfif acceso_uri("/sif/cm/operacion/autorizaOrden.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/autorizaOrden.cfm">
			<cfset opcion.titulo = "Autorizar &Oacute;rdenes de Compra">
			<cfset opcion.descripcion = "Este proceso permite aprobar o rechazar la Orden de Compra, cuando el comprador que tramita la orden que no tiene monto autorizado.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>
	<cfelseif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0>
		<cfif acceso_uri("/sif/cm/operacion/listaOrdenCM.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
			<cfset opcion.uri = "/sif/cm/operacion/listaOrdenCM.cfm">
			<cfset opcion.titulo = "&Oacute;rdenes de Compra">
			<cfset opcion.descripcion = "Este proceso permite realizar la creaci&oacute;n de &oacute;rdenes de compra de forma manual, este tipo de
			&oacute;rdenes de compra se realiza en aquellos casos en que se desea realizar una compra directa o que no involucra una solicitud
			de materiales o el proceso de cotizaron hacia proveedores.">
			<cfset ArrayAppend(menu1,opcion)>
		</cfif>
	</cfif>
    <cfif acceso_uri("/sif/cm/operacion/evaluarCotizacionesSolicitante.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/operacion/evaluarCotizacionesSolicitante.cfm">
        <cfset opcion.titulo = "Evaluaci&oacute;n de Cotizaciones(Solicitante)">
        <cfset opcion.descripcion = "Este proceso de la aplicaci&oacute;n es utilizado por los compradores de la empresa, el mismo permite a
        cada uno de estos realizar la comparaci&oacute;n de las diferentes ofertas o cotizaciones que fueron realizadas a fin de abastecer o
        surtir solicitudes de materiales. Como resultado de este proceso se obtiene una o varias &oacute;rdenes de compra que abastecen las
        necesidades de las solicitudes de materiales que se cotizaron y que se evaluaron como parte del proceso.">
        <cfset ArrayAppend(menu1,opcion)>
    </cfif>
</cffunction>
<cffunction name="fnGeneraOpcionesCMRR" access="private" output="no">
	<cfset menu4 = ArrayNew(1)><!--- Coleccion de Opciones --->

    <!--- Obtiene el parámetro de Aprobación de Tolerancia para Compradores --->
    <cfquery name="rsParametroAprobacionTolerancia" datasource="#session.dsn#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
          and Pcodigo = 760
    </cfquery>

    <cfif acceso_uri("/sif/cm/operacion/documentos-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/operacion/documentos-lista.cfm?tipo=R">
        <cfset opcion.titulo = "Registro de Documentos de Recepci&oacute;n">
        <cfset opcion.descripcion = "Este proceso permite posterior a la creaci&oacute;n y autorizaci&oacute;n de la orden de compra, realizar el
        surtido de la misma. Se registra el ingreso de la mercadería solicitada para una o varias &oacute;rdenes de compra
        definidas por el usuario que realiza la recepci&oacute;n de mercadería.">
        <cfset ArrayAppend(menu4,opcion)>
    </cfif>

    <cfif acceso_uri("/sif/cm/operacion/devolucion-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/operacion/devolucion-lista.cfm">
        <cfset opcion.titulo = "Registro de Documentos de Devoluci&oacute;n">
        <cfset opcion.descripcion = "Este proceso permite realizar la devoluci&oacute;n de mercadería al proveedor en aquellas ocasiones en que
        esta ha sido previamente registrada. Esta devoluci&oacute;n se realiza con el fin de eliminar existencias del inventario e iniciar un
        proceso de reclamo al proveedor por la mercadería devuelta por múltiples circunstancias.">
        <cfset ArrayAppend(menu4,opcion)>
    </cfif>

    <cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
        <cfif rsParametroAprobacionTolerancia.RecordCount gt 0 and rsParametroAprobacionTolerancia.Pvalor eq 1>
            <cfif acceso_uri("/sif/cm/operacion/docsAprobarExcTolerancia-lista.cfm")>
				<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
                <cfset opcion.uri = "/sif/cm/operacion/docsAprobarExcTolerancia-lista.cfm">
                <cfset opcion.titulo = "Aprobaci&oacute;n de Documentos con Exceso de Tolerancia">
                <cfset opcion.descripcion = "Este proceso permite aprobar o rechazar las l&iacute;neas de recepci&oacute;n que presentan excesos en tolerancias.">
                <cfset ArrayAppend(menu4,opcion)>
            </cfif>
        </cfif>

        <cfif acceso_uri("/sif/cm/operacion/reclamos-lista.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/operacion/reclamos-lista.cfm">
            <cfset opcion.titulo = "Trabajar con Reclamos">
            <cfset opcion.descripcion = "Este proceso permite dar seguimiento a las l&iacute;neas de recepci&oacute;n que presentan reclamos en la entrega.">
            <cfset ArrayAppend(menu4,opcion)>
        </cfif>

        <cfif acceso_uri("/sif/cm/operacion/LiqSaldos-ListaOrdenes.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/operacion/LiqSaldos-ListaOrdenes.cfm">
            <cfset opcion.titulo = "Liquidación de Saldos de Orden de Compra">
            <cfset opcion.descripcion = "">
            <cfset ArrayAppend(menu4,opcion)>
        </cfif>
    </cfif>
</cffunction>
<cffunction name="fnGeneraOpcionesCMCI" access="private" output="no">
	<cfset menu2 = ArrayNew(1)><!--- Coleccion de Opciones --->
    <cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
        <cfif acceso_uri("/sif/cm/operacion/EDocumentos-lista.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/operacion/EDocumentos-lista.cfm">
            <cfset opcion.titulo = "Registro de Transacciones">
            <cfset opcion.descripcion = "Este proceso permite registrar los documentos (facturas, notas de cr&eacute;dito) que se presentan en una importaci&oacute;n.">
            <cfset ArrayAppend(menu2,opcion)>
        </cfif>

        <cfif acceso_uri("/sif/cm/operacion/anulaEDocumentosI.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/operacion/anulaEDocumentosI.cfm">
            <cfset opcion.titulo = "Anulación de Transacciones">
            <cfset opcion.descripcion = "">
            <cfset ArrayAppend(menu2,opcion)>
        </cfif>

        <cfif acceso_uri("/sif/cm/operacion/polizaDesalmacenaje.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/operacion/polizaDesalmacenaje.cfm">
            <cfset opcion.titulo = "P&oacute;lizas de Desalmacenaje">
            <cfset opcion.descripcion = "Este proceso permite registrar la p&oacute;liza de desalmacenaje. En este proceso tambi&eacute;n se realiza el c&aacute;lculo
            final del costo de los productos importados.">
            <cfset ArrayAppend(menu2,opcion)>
        </cfif>

        <cfif acceso_uri("/sif/cm/proveedor/trackingRegistro-lista.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/proveedor/trackingRegistro-lista.cfm">
            <cfset opcion.titulo = "Administraci&oacute;n de Embarques">
            <cfset opcion.descripcion = "Este proceso permite dar seguimiento a las mercanc&iacute;as que se desean importar. Tambi&eacute;n se permite realizar consolidados
            de mercanc&iacute;as que provengan de diferentes lugares.">
            <cfset ArrayAppend(menu2,opcion)>
        </cfif>

        <cfif acceso_uri("/sif/cm/proveedor/trackingSeguimiento-lista.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/proveedor/trackingSeguimiento-lista.cfm">
            <cfset opcion.titulo = "Seguimiento de Embarques">
            <cfset opcion.descripcion = "Este proceso permite registrar y verificar el seguimiento de los productos importados. ">
            <cfset ArrayAppend(menu2,opcion)>
        </cfif>
    </cfif>
</cffunction>
<cffunction name="fnGeneraOpcionesCMCR" access="private" output="no">
	<!--- Parametros Adicionales --->
    <cfquery name="verifica_Parametro" datasource="#session.dsn#">
        select 1
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 730
        and Pvalor = '1'
    </cfquery>

    <cfquery name="rsParametroConsolidaOCs" datasource="#session.dsn#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
            and Pcodigo = 770
    </cfquery>

    <cfset menu3 = ArrayNew(1)>
    <!--- Coleccion de Opciones --->
    <!---
			Para efectos de que funcione el menú Dinamicmente, se requiere que se el nombre del link posea el nombre
			del menú al que pertenecen, ejemplo: Elemento Ordenes de Compra - En el if se preguntará si existe la Palabra Ordenes -
	--->
    <!--- Solicitudes de Compra
		Se comento la seguridad por solicitante para liberar todas las opciones y se validen solo por rol
		Opciones solo de Solicitantes: Llave: Solicitudes
	--->
    <cfif acceso_urilocal("/sif/cm/consultas/MisSolicitudes-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/MisSolicitudes-lista.cfm">
        <cfset opcion.titulo = "Solicitudes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <cfif acceso_urilocal("/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SeguimientoSolicitudes-lista.cfm">
        <cfset opcion.titulo = "Seguimiento de Solicitudes">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <cfif acceso_urilocal("/sif/cm/consultas/SegSolDet-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SegSolDet-lista.cfm">
        <cfset opcion.titulo = "Seguimiento de Solicitudes Detallada por Usuario">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
	 <cfif acceso_urilocal("/sif/cm/consultas/SegSolDetGen-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SegSolDetGen-lista.cfm">
        <cfset opcion.titulo = "Seguimiento de Solicitudes Detallada General">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Opciones solo de Compradores --->
    <cfif acceso_urilocal("/sif/cm/consultas/SolicitudesPendCotizar.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SolicitudesPendCotizar.cfm">
        <cfset opcion.titulo = "Solicitudes Pendientes">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
	<!--- Se comento esta opcion pues el reporte no esta terminado
	     Tiene muchas incosistencias y no esta claro el uso del mismo.
		 descomentar las lineas cuando se termine el desarrollo
    <cfif acceso_urilocal("/sif/cm/consultas/SolicitudCotLocal.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SolicitudCotLocal.cfm">
        <cfset opcion.titulo = "Solicitudes de Cotizaciones Locales">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
	--->
    <cfif acceso_urilocal("/sif/cm/consultas/ReasignacionSolicitudes.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ReasignacionSolicitudes.cfm">
        <cfset opcion.titulo = "Reasignaci&oacute;n de Solicitudes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <cfif acceso_urilocal("/sif/cm/consultas/saldosSolicitudCompraConsolidado.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/saldosSolicitudCompraConsolidado.cfm">
        <cfset opcion.titulo = "Solicitudes de Compra (Montos y Estatus) consolidados">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!---Procesos de Compras--->
    <cfif acceso_urilocal("/sif/cm/consultas/TiposProcesosCompras-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/TiposProcesosCompras-lista.cfm">
        <cfset opcion.titulo = "Procesos de Publicaciónes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Ordenes de Compra --->
    <cfif acceso_urilocal("/sif/cm/consultas/OCLocalProveedor.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/OCLocalProveedor.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra Locales (Proveedor)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/OrdenesCompra-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/OrdenesCompra-lista.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/saldosOrdenCompra.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/saldosOrdenCompra.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra (Saldos)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/saldosOrdenCompra.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/saldosOrdenCompra-rp.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra (Saldos y Montos)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ComprasProveedor.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ComprasProveedor.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra (Proveedor)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ComprasProveedorRP.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ComprasProveedorRP.cfm">
        <cfset opcion.titulo = "&Oacute;rdenes de Compra (Proveedor, Montos) ">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ReasignacionOrdenes.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ReasignacionOrdenes.cfm">
        <cfset opcion.titulo = "Reasignaci&oacute;n de &Oacute;rdenes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif rsParametroConsolidaOCs.RecordCount gt 0 and rsParametroConsolidaOCs.Pvalor eq '1'>
        <cfif acceso_urilocal("/sif/cm/consultas/ConsolidadoOCs-filtro.cfm")>
			<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
            <cfset opcion.uri = "/sif/cm/consultas/ConsolidadoOCs-filtro.cfm">
            <cfset opcion.titulo = "Saldos de Consolidados de &Oacute;rdenes de Compra">
            <cfset ArrayAppend(menu3,opcion)>
        </cfif>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/RepcambioestadoimpresionOC-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/RepcambioestadoimpresionOC-lista.cfm">
        <cfset opcion.titulo = "Cambio de estado impresión de &Oacute;rdenes de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

	<cfif acceso_urilocal("/sif/cm/consultas/saldosOrdenCompraConsolidado.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/saldosOrdenCompraConsolidado.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra (Saldos y Montos) consolidados">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

   	<cfif acceso_urilocal("/sif/cm/consultas/OrdenesPendientes.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/OrdenesPendientes.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra por Comprador (Estados)">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

	<cfif acceso_urilocal("/sif/cm/consultas/RProveedor.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/RProveedor.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra - Reporte de Proveedores por Actividad">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ListadoConsecutivoOrdenes.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/ListadoConsecutivoOrdenes.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra (Listado Consecutivo)">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/OrdenesSurtidasComprador.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/OrdenesSurtidasComprador.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de compra por Comprador (Estad&iacute;sticas)">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

	<cfif acceso_urilocal("/sif/cm/consultas/OrdenesCompraPorArticulo.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/OrdenesCompraPorArticulo.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de Compra por Artículo">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/EstadisticasProveedor.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/EstadisticasProveedor.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de compra por Proveedor (Estad&iacute;sticas)">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/rpSegOrdenesTransito.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/rpSegOrdenesTransito.cfm">
		<cfset opcion.titulo = "Reporte de Seguimiento de &Oacute;rdenes de Compra en Tr&aacute;nsito">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ReporteCristal.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
		<cfset opcion.uri = "/sif/cm/consultas/ReporteCristal.cfm">
		<cfset opcion.titulo = "&Oacute;rdenes de compra-Resumen General">
		<cfset ArrayAppend(menu3,opcion)>
	</cfif>

	<cfif acceso_urilocal("/sif/cm/consultas/CmAnalisisProv.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/CmAnalisisProv.cfm">
        <cfset opcion.titulo = "An&aacute;lisis de Proveedores">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ordenSolicitudCompraConsolidado.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ordenSolicitudCompraConsolidado.cfm">
        <cfset opcion.titulo = "Ordenes y Solicitudes de Compra consolidados">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/RepCiclos-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/RepCiclos-lista.cfm">
        <cfset opcion.titulo = "Ciclos de Compra">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Datos de los Solicitantes --->
    <cfif acceso_urilocal("/sif/cm/consultas/DatosSolicitante-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/DatosSolicitante-lista.cfm">
        <cfset opcion.titulo = "Datos de Solicitantes">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/PermisosSolicitante-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/PermisosSolicitante-lista.cfm">
        <cfset opcion.titulo = "Permisos de Solicitantes">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Datos de los Compradores --->
    <cfif acceso_urilocal("/sif/cm/consultas/DatosComprador.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/DatosComprador.cfm">
        <cfset opcion.titulo = "Datos de los Compradores">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/DatosCompradorRango.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/DatosCompradorRango.cfm">
        <cfset opcion.titulo = "Datos de los Compradores por Rango">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/listadoCompradores.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/listadoCompradores.cfm">
        <cfset opcion.titulo = "Listado de los Compradores">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Recepción --->
    <cfif acceso_urilocal("/sif/cm/consultas/RecepMerc-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/RecepMerc-lista.cfm">
        <cfset opcion.titulo = "Recepci&oacute;n de Mercader&iacute;a">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <!--- Recepción Por Lote --->
    <cfif acceso_urilocal("/sif/cm/consultas/RecepMercaderia.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/RecepMercaderia.cfm">
        <cfset opcion.titulo = "Recepci&oacute;n de Mercader&iacute;a (Por Lote)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <!--- Recepción por Aplicar  --->
    <cfif acceso_urilocal("/sif/cm/consultas/RecepMercNoAplic.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/RecepMercNoAplic.cfm">
        <cfset opcion.titulo = "Recepci&oacute;n de Mercader&iacute;a (Por Aplicar)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Reclamos --->
    <cfif acceso_urilocal("/sif/cm/consultas/ReclamosHistV2.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ReclamosHistV2.cfm">
        <cfset opcion.titulo = "Hist&oacute;rico de Reclamos">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ReclamosHist.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ReclamosHist.cfm">
        <cfset opcion.titulo = "Hist&oacute;rico de Reclamos (Seguimiento)">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/HRecepcionReclamos.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/HRecepcionReclamos.cfm">
        <cfset opcion.titulo = "Hist&oacute;rico de Recepci&oacute;n / Reclamos">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Trámites --->
    <cfif acceso_urilocal("/sif/tr/consultas/solicitados.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/tr/consultas/solicitados.cfm">
        <cfset opcion.titulo = "Mis Tr&aacute;mites Solicitados">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/tr/consultas/pendientes.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/tr/consultas/pendientes.cfm">
        <cfset opcion.titulo = "Mis Tr&aacute;mites Pendientes">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Pólizas de Desalmacenaje --->
    <cfif acceso_urilocal("/sif/cm/consultas/polizaDesalmacenaje.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/polizaDesalmacenaje.cfm">
        <cfset opcion.titulo = "Consulta de P&oacute;lizas de Desalmacenaje">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/proveedor/seguimientoTracking-filtro.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/proveedor/seguimientoTracking-filtro.cfm">
        <cfset opcion.titulo = "Consulta de Embarques">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/proveedor/seguimientoTrackingRango-filtro.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/proveedor/seguimientoTrackingRango-filtro.cfm">
        <cfset opcion.titulo = "Seguimiento de Embarques">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/AnulaTransaccion-lista.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/AnulaTransaccion-lista.cfm">
        <cfset opcion.titulo = "Consulta de Transacciones">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/ComparacionCodigosAduanales.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ComparacionCodigosAduanales.cfm">
        <cfset opcion.titulo = "Comparaci&oacute;n de C&oacute;digos Aduanales">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/SaldosMercaderiaTransito.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/SaldosMercaderiaTransito.cfm">
        <cfset opcion.titulo = "Reporte de Saldos de la Mercader&iacute;a en Tr&aacute;nsito">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <cfif acceso_urilocal("/sif/cm/consultas/TotalesMercaderiaTransito.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/TotalesMercaderiaTransito.cfm">
        <cfset opcion.titulo = "Reporte de Totales de la Mercader&iacute;a en Tr&aacute;nsito">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Lista de polizas  de desalmacenaje--->
    <cfif acceso_urilocal("/sif/cm/consultas/listaPolizaDesalmacenaje.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/listaPolizaDesalmacenaje.cfm">
        <cfset opcion.titulo = "Lista de P&oacute;lizas de Desalmacenaje">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

	<!--- Seguimiento de Agencia Aduanal--->
    <cfif acceso_urilocal("/sif/cm/consultas/rpAgenciaAduanal.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/rpAgenciaAduanal.cfm">
        <cfset opcion.titulo = "Reporte de Agencia Aduanal">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>

    <!--- Trámites --->
    <cfif acceso_urilocal("/sif/cm/consultas/ConsumoCantContratos.cfm")>
		<cfset opcion = StructNew()>	<!--- Uri, Titulo, Descripcion --->
        <cfset opcion.uri = "/sif/cm/consultas/ConsumoCantContratos.cfm">
        <cfset opcion.titulo = "Consumo de Cantidades en Contratos ">
        <cfset ArrayAppend(menu3,opcion)>
    </cfif>
    <cfset letra = 15 >
	<cfset TituloSol = 0>
    <cfset TituloPro = 0>
    <cfset TituloOrd = 0>
    <cfset TituloPer = 0>
    <cfset TituloRec = 0>
    <cfset TituloCom = 0>
    <cfset TituloTra = 0>
    <cfset TituloDes = 0>
    <cfset TituloRecep = 0>
    <cfset TituloAn = 0>
    <cfset TituloContrato = 0>
</cffunction>

<cffunction name="acceso_urilocal" returntype="boolean" output="false">
	<cfargument name="proceso" required="yes">
	<cfargument name="setcontext" type="boolean" default="false">
	<cfreturn true>
</cffunction>

<cffunction name="fnGeneraOpcionesCatalogosCM" output="no" access="private" hint="Genera las Opciones de Catalogos">
	<cfset rsCatalogos   = QueryNew("LDescripcion, Link, Orden")>
	<!--- ============================ --->
	<!--- OPCIONES DE CATALOGOS --->
	<!--- ============================ --->

	<!--- Configuración Inicial--->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Configuración de Tipos de Solicitud")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/compraConfig-inicio.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 1)>

	<!--- Solicitantes --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Solicitantes")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/solicitantes-inicio.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 2)>

	<!--- Compradores --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Compradores")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/Compradores.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 3)>

	<!--- Tipos de Orden de Compra --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de Orden de Compra")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/TiposOrdenCompra.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 4)>

	<!--- Grupos de Criterios de Comparacion --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Grupos de Criterios de Comparación")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/GruposCriterios.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 5)>

	<!--- Contratos --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Contratos")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/contratos-lista.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 6)>

	<!--- Edición de Contratos --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Edicion de Contratos")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/contratosEditar-lista.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 6)>
	<!--- Tipos de Documento --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de Documentos")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/tipoDocumento.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 7)>

	<!--- Tipos de Transacción --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de Transacción")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/TipoTransaccion.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 8)>

	<!--- Formas de Pago  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Formas de Pago")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/CMFormasPago.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 9)>

	<!--- Términos Internacionales de Comercio  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "T&eacute;rminos Internacionales de Comercio")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/CMIncoterm.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 10)>

	<!--- Seguros  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Seguros")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/Seguros.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 10)>

	<!--- Couriers  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Couriers")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/Courier.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 11)>

	<!--- Tipos de análisis de proveedore  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de análisis de proveedores")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/CMTipoAnalisis.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 12)>

	<!--- Tipos de Procesos de compra  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de Procesos de Compras")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/TiposProcesosCompras.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 13)>

		<!--- Tipos de Procesos de compra  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Tipos de garantía")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/TipoGarantia.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 14)>

    <!--- Tipos de Procesos de compra  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Proveeduría Corporativa")>
	<cfset QuerySetCell(rsCatalogos, "Link", "catalogos/ProveduriaCorp.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 15)>

    <!--- Estados por Tracking  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Estados por Tracking")>
	<cfset QuerySetCell(rsCatalogos, "Link", "proveedor/trackingEstados.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 15)>

    <!--- Estados por Tracking  --->
	<cfset QueryAddRow(rsCatalogos, 1)>
	<cfset QuerySetCell(rsCatalogos, "LDescripcion", "Actividad por Tracking")>
	<cfset QuerySetCell(rsCatalogos, "Link", "proveedor/trackingActividad.cfm")>
	<cfset QuerySetCell(rsCatalogos, "Orden", 15)>

	<cfquery name="rsCatalogosOrd" dbtype="query">
		select * from rsCatalogos
		order by Orden
	</cfquery>
</cffunction>

<cffunction name="fnGeneraOpcionesMenuCMOtros" access="private" output="no" hint="Genera las opciones de menu para el menu de Compras - Otros">
	<cfif isdefined("rsParametro_MultipleContrato") and rsParametro_MultipleContrato.Pvalor EQ 1>
		<!----Verificar que el usuario logueado sea un usuario autorizador de OC's---->
		<cfquery name="rsUsuario_autorizado" datasource="#session.DSN#">
			select 1 from CMUsuarioAutorizado
			where Ecodigo   = #session.Ecodigo#
			  and Usucodigo = #session.Usucodigo#
		</cfquery>
	</cfif>
	<cfset rsOtros   = QueryNew("LTitulo, LDescripcion, Link, Orden")>
	<cfif isdefined("session.Compras.solicitante") and len(trim(session.Compras.solicitante))>
		<cfif acceso_uri("/sif/cm/operacion/solicitudes-reimprimir.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Reimpresi&oacute;n de Solicitudes de Compra")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite realizar la impresión física de todas aquellas solicitudes de compra que han sido previamente creadas; la reimpresión de solicitudes posibles es solamente para aquellas creadas por el mismo solicitante que esta realizando la consulta de reimpresiones.")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/solicitudes-reimprimir.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/orden-reimprimir.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Reimpresi&oacute;n de Ordenes de Compra")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite realizar la impresión física de todas aquellas ordenes de compra que han sido previamente creadas; la reimpresión de ordenes posibles es solamente para aquellas creadas por el mismo comprador que esta realizando la consulta de reimpresiones.")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/orden-reimprimir.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/cancelacionSolicitudesAdm.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Cancelaci&oacute;n de Solicitudes de Compra")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "El proceso de cancelación de Solicitudes de Compra, permite cancelar solicitudes previamente aprobadas.  La cancelación de la solicitud de materiales implica que las mismas no serán abastecidas como parte del proceso de compra de la empresa. Se puede realizar esta acción para cualquier solicitante")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/cancelacionSolicitudesAdm.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>

	<cfif acceso_uri("/sif/cm/operacion/cancelacionSolicitudes.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Cancelaci&oacute;n de Solicitudes de Compra por Usuario")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "El proceso de cancelación de Solicitudes de Compra, permite cancelar solicitudes previamente aprobadas.  La cancelación de la solicitud de materiales implica que las mismas no serán abastecidas como parte del proceso de compra de la empresa.")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/cancelacionSolicitudes.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>

	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador)) or (isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0)>
		<cfif acceso_uri("/sif/cm/operacion/ordenCompraACancelar.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Cancelaci&oacute;n de Ordenes de Compra")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite realizar la cancelación de órdenes de compra, de manera que las mismas no serán surtidas.  El proceso de cancelación de órdenes implica la liberación o desurtido de aquellas solicitudes de materiales que se encuentran incluidas en la orden de compra que se cancela.")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/ordenCompraACancelar.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/CancelacionMasiva.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Cancelación Masiva de Compras")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite realizar la cancelación Masiva de las órdenes y solicitudes de compra, de manera que las mismas no serán surtidas.")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/CancelacionMasiva.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>

		<cfif acceso_uri("/sif/cm/operacion/solicitudesRechazadas.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Solicitudes de Compra Rechazadas")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite reintentar la aplicación de solicitudes de compra, que han sido rechazadas por presupuesto.  El proceso podría recibir un nuevo rechazo o ser aceptado definitivamente, lo que conllevaría las implicaciones normales de una solicitud de compra.")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/solicitudesRechazadas.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	<cfif isdefined("session.Compras.solicitante") and len(trim(session.Compras.solicitante))></cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/ordenCompraRechazada.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Ordenes de Compra Rechazadas")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "Este proceso permite reintentar la aplicación de ordenes de compra, que han sido rechazadas por presupuesto.  El proceso podría recibir un nuevo rechazo o ser aceptado definitivamente, lo que conllevaría las implicaciones normales de una orden de compra.")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/ordenCompraRechazada.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/reasignarCargas.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Reasignar Cargas de Trabajo")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "Reasignar Cargas de Trabajo.")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/reasignarCargas.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/reasignarOrden.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Reasignar Ordenes de Compra")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/reasignarOrden.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/reasignarAutorizadorOrden.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Reasignar Autorizador de Ordenes de Compra")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/reasignarAutorizadorOrden.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden",1)>
		</cfif>
	</cfif>
	<cfif isdefined("session.Compras.comprador") and len(trim(session.Compras.comprador))>
		<cfif acceso_uri("/sif/cm/operacion/generarTrackingOC.cfm")>
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Generaci&oacute;n de Embarques por OC")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/generarTrackingOC.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<cfif acceso_uri("/sif/cm/operacion/listaOrdenCM_cambioFP.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Cambio de Forma de Pago")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/listaOrdenCM_cambioFP.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>
	<!----  Mantenimiento de selección de proveedores ----->
	<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))><!---Si esta definido el comprador---->
		<cfif acceso_uri("/sif/cm/operacion/CompradorAutSolicitudes-lista.cfm")><!----Si tiene permisos---->
			<cfset QueryAddRow(rsOtros, 1)>
			<cfset QuerySetCell(rsOtros, "LTitulo", "Selección de proveedores")>
			<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
			<cfset QuerySetCell(rsOtros, "Link", "operacion/CompradorAutSolicitudes-lista.cfm")>
			<cfset QuerySetCell(rsOtros, "Orden", 1)>
		</cfif>
	</cfif>
	<!---======= Opción de cambio de estado de impresion de las OC's ============---->
	<cfif acceso_uri("/sif/cm/operacion/CambioestadoimpresionOC-lista.cfm")>
		<cfset QueryAddRow(rsOtros, 1)>
		<cfset QuerySetCell(rsOtros, "LTitulo", "Cambio de estado de impresión OC")>
		<cfset QuerySetCell(rsOtros, "LDescripcion", "")>
		<cfset QuerySetCell(rsOtros, "Link", "operacion/CambioestadoimpresionOC-lista.cfm")>
		<cfset QuerySetCell(rsOtros, "Orden", 1)>
	</cfif>
	<cfquery name="rsOtrosOrd" dbtype="query">
		select * from rsOtros
		order by Orden
	</cfquery>
</cffunction>
