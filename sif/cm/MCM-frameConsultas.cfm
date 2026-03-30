<cfset fnGeneraOpcionesMenuConsultasCMframe()>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consultas">
<table border="0" cellpadding="2" cellspacing="0">
	<cfoutput query="rsConsultas">
        <tr>	
            <td width="1%" align="right" class="etiquetaProgreso"  valign="middle">
                <div align="right"> 
                    <a href="#rsConsultas.Link#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a> 
                </div>
            </td>
            <td width="99%" align="left" valign="middle" nowrap class="etiquetaProgreso">
                <a href="#rsConsultas.Link#">#rsConsultas.LDescripcion#</a>
            </td>
        </tr>
	</cfoutput>
</table>
<cf_web_portlet_end>
<cffunction name="fnGeneraOpcionesMenuConsultasCMframe" access="private" output="no">
	<cfset rsConsultas   = QueryNew("LDescripcion, Link, Orden")>
	<!--- ============================ --->
	<!--- =   OPCIONES DE CONSULTAS  = --->
	<!--- ============================ --->
	<!--- Solicitudes Pendientes a Cotizar 
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", "Solicitudes Pendientes a Cotizar") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "consultas/SolicitudesPendCotizar.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 1) >
	<!--- Solicitud de Cotizacion Local --->
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", "Solicitud de Cotizacion Local") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "consultas/SolicitudCotLocal.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 2) >
	<!--- Ordenes Compra Locales por Proveedor --->
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", " Ordenes Compra Locales por Proveedor") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "consultas/OCLocalProveedor.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 3) >
	<!--- Historico de Reclamos de Ordenes Compra --->
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", " Hist&oacute;rico de Reclamos de Ordenes de Compra ") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "consultas/ReclamosHist.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 4) >
	<!--- Mis solicitudes (solicitante)--->
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", " Mis Solicitudes") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "consultas/MisSolicitudes-lista.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 5) >--->
	<cfset fila = QueryAddRow(rsConsultas, 1)>
	<cfset tmp  = QuerySetCell(rsConsultas, "LDescripcion", "Menú de Consultas de Compras") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Link", "MenuConsultasCM.cfm") >
	<cfset tmp  = QuerySetCell(rsConsultas, "Orden", 1) >
</cffunction>
