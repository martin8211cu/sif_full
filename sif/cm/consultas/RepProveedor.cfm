<!--- <cf_dump var="#form#"> --->
<!--- <cfprocessingdirective pageEncoding="utf-8"> --->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfsetting requesttimeout="3600">
<cfparam name="ordenar" default="Proveedor">
<cfparam name="form.FechaDesde" default="">
<cfparam name="form.FechaHasta" default="">
<cfif structKeyExists(form,"ordenar")>
	<cfset ordenar = form.ordenar>
</cfif>
<cfif structKeyExists(form,"FechaDesde")>
	<cfset FechaDesde = form.FechaDesde>
</cfif>
<cfif structKeyExists(form,"FechaHasta")>
	<cfset FechaHasta = form.FechaHasta>
</cfif>
<!--- Exporta el Contenido a Excel --->
<cfif isDefined("form.toExcel")>
	<cfif form.toExcel eq "true">
		<cfheader name="Content-Disposition" value="inline; filename=ReporteActividadProveedores.xls">
		<cfcontent type="application/vnd.ms-excel charset=windows-1252">
	</cfif>
</cfif>

<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfsavecontent variable="myquery">

		DECLARE @Ecodigo  INT = 3;
		DECLARE @FechaIni DATE = '<cfoutput>#FechaDesde#</cfoutput>';
		DECLARE @FechaFin DATE = '<cfoutput>#FechaHasta#</cfoutput>';
		WITH
			info AS (
				SELECT	s.SNnumero, s.Ecodigo, s.SNcodigo, SNFecha, RTRIM(LTRIM(SNnombre)) Proveedor, RTRIM(LTRIM(SNidentificacion)) RFC,
				RTRIM(LTRIM(SNdireccion)) Direccion, SNtelefono, SNemail, SNCDdescripcion Giro, TESTPBanco +' '+TESTPcuenta InfoBancaria
				FROM	SNegocios s
					LEFT JOIN SNClasificacionSN c
						INNER JOIN SNClasificacionE ce
							INNER JOIN SNClasificacionD cd on ce.SNCEid = cd.SNCEid
						ON c.SNCDid = cd.SNCDid AND upper(SNCEcodigo) LIKE 'GIRO%'
					ON s.SNid = c.SNid
					LEFT JOIN TEStransferenciaP p on s.SNid = p.SNidP
				WHERE 1=1
				AND s.Ecodigo = @Ecodigo
				AND s.SNtiposocio in ('A','P')),
			Venta AS (
				SELECT count(1) ventas, sum(EOtotal) total, e.Ecodigo, e.SNcodigo,
				CASE
				WHEN count(1) = 0 THEN 'Sin Actividad'
				WHEN count(1) = 1 THEN 'Compra Única'
				WHEN count(1) > 1 THEN
					CASE
						WHEN sum(EOtotal) >= 0 AND sum(EOtotal) < 100000.00 THEN 'BAJA'
						WHEN sum(EOtotal) >= 100000.00 AND sum(EOtotal) < 300000.00 THEN 'MEDIA'
						WHEN sum(EOtotal) >= 300000.00 THEN 'ALTA'
					END
			END AS Actividad
				FROM EOrdenCM E
					INNER JOIN info i ON e.Ecodigo = i.Ecodigo AND e.SNcodigo = i.SNcodigo
				WHERE e.Ecodigo = @Ecodigo
				AND EOfalta BETWEEN @FechaIni AND @FechaFin
				GROUP BY e.Ecodigo, e.SNcodigo
				)
		SELECT CAST(SNFecha AS  DATE) FechaAlta, ventas, total, i.SNnumero, i.SNcodigo Codigo, Proveedor, RFC, Direccion, SNtelefono Telefono, SNemail Email, Giro, InfoBancaria,
			Actividad
		FROM Venta v
			INNER JOIN info i ON v.Ecodigo = i.Ecodigo and v.SNcodigo = i.SNcodigo
		GROUP BY SNFecha, i.SNnumero, i.SNcodigo, Proveedor, RFC, Direccion, SNtelefono, SNemail, Giro, InfoBancaria, Actividad,ventas, total
		ORDER BY <cfoutput>#ordenar#</cfoutput>

</cfsavecontent>

<!--- Filtros --->
<cfset FechaDesde = "(No definida)">
<cfset FechaHasta = "(No definida)">
<cfif isDefined("form.FechaDesde")>
	<cfset FechaDesde = form.FechaDesde>
</cfif>
<cfif isDefined("form.FechaHasta")>
	<cfset FechaHasta = form.FechaHasta>
</cfif>

<!--- Estilos --->
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-weight:bold;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.titulo_columnar {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		white-space: nowrap;}
	.titulo_columnaC {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:center;
		white-space: nowrap;}
	.detalle {
		font-size:10px;
		text-align:left;
		font-weight: bolder;}
	.detalle2 {
		font-size:10px;
		text-align:left;}
	.detallec {
		font-size:10px;
		text-align:center;}
	.detaller {
		font-size:10px;
		text-align:right;
		white-space: nowrap;}
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
</style>

<!--- Variables --->
<cfif isDefined("form.toExcel") and form.toExcel eq "true"> <!--- Total de líneas por página --->
	<cfset MaxLineasReporte = 9999999>
<cfelse><cfset MaxLineasReporte = 99999999>
</cfif>
<cfset nLnEncabezado = 9>		 <!--- Total de líneas del encabezado --->
<cfset nCols = 6>				 <!--- Total de columnas del encabezado --->

<!--- Botones --->
<cfif not isDefined("form.toExcel")>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0">
		<cfoutput>
		<tr>
			<td colspan="#nCols#" align="right" nowrap>
				<a href="javascript:regresar();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/back.gif"
					alt="Regresar"
					name="regresar"
					border="0" align="absmiddle">
				</a>
				<a href="javascript:imprimir();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/impresora.gif"
					alt="Imprimir"
					name="imprimir"
					border="0" align="absmiddle">
				</a>
				<a id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Cfinclude.gif"
					alt="Salvar a Excel"
					name="SALVAEXCEL"
					border="0" align="absmiddle">
				</a>
			</td>
		</tr>
		<tr><td  colspan="#nCols#"><hr></td></tr>
		</cfoutput>
	</table>
</table>
</cfif>

<!--- Llena el Encabezado --->
<cfsavecontent variable="Encabezado">
<cfoutput>
	<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
	<tr><td colspan="#nCols#" class="titulo_reporte">Reporte de Proveedores</td></tr>
	<tr><td colspan="#nCols#" class="titulo_filtro">Desde: #FechaDesde# - Hasta: #FechaHasta#</td></tr>
	<tr><td colspan="#nCols#" class="paginacion">#trim(LSDateFormat(Now(),'dd/mm/yyyy'))# #trim(LSTimeFormat(Now(),'HH:mm:ss'))#</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	<!--- COLUMNAS --->
	<tr>
		<td class="titulo_columna"></td>
		<td class="titulo_columna">Proveedor</td>
		<td class="titulo_columnac">Clasificación</td>
		<td class="titulo_columnac">Giro</td>
		<td class="titulo_columnac">RFC&nbsp;&nbsp;&nbsp;</td>
		<td class="titulo_columnar">&nbsp;&nbsp;&nbsp;Datos Bancarios&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
</cfoutput>
</cfsavecontent>

<!--- Pinta el Reporte --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<cfoutput>

	<!--- Encabezado --->
	#Encabezado#

	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
			<cfoutput>#myquery#</cfoutput>

		</cf_jdbcquery_open>

		<!--- Detalle --->
		<cfset contador = nLnEncabezado>
		<cfloop query="rsReporte">
			<cfif contador gte MaxLineasReporte>
				<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
				#Encabezado#
				<cfset contador = nLnEncabezado>
			</cfif>
			<tr>
				<td class="detalle">#trim(SNnumero)#&nbsp;</td>
				<td class="detalle">#trim(Proveedor)#&nbsp;</td>
				<td class="detallec">#trim(Actividad)#&nbsp;</td>
				<td class="detallec">#trim(Giro)#&nbsp;</td>
				<td class="detallec">#trim(RFC)#&nbsp;</td>
				<td class="detaller">#trim(InfoBancaria)#</td>
			</tr>
			<tr>
				<td rowspan="2" class="titulo_columna">Contacto y Dirección:</td>
				<td rowspan="2" class="detalle2">#Direccion#</td>
				<td rowspan="2" class="detalle2">Teléfono:&nbsp;</td>
				<td rowspan="2" class="detalle2">#Telefono#&nbsp;</td>
				<td rowspan="2" colspan="2" class="detalle2">Email:&nbsp;#Email#&nbsp;&nbsp;</td>
				<!--- <td rowspan="2" class="detalle2"></td> --->
			</tr>
			<tr>
			</tr>
			<tr>
				<td colspan="#nCols#"><hr></td>
<!--- 				<td class="detaller">#trim(Actividad)#</td>
				<td class="detaller">#trim(Giro)#</td>
				<td class="detaller">#trim(RFC)#</td>
				<td class="detaller">#trim(InfoBancaria)#</td> --->
			</tr>
			<cfset contador = contador + 1>
		</cfloop>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfoutput>
</table>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
<cfoutput>
	<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
	<tr><td colspan="#nCols#" class="paginacion"> - Fin del Reporte - </td></tr>
</cfoutput>
</table>

<cfoutput>
<form name="FormExcel" id="FormExcel" method="post" action="RepProveedor.cfm">
	<input type="hidden" name="toExcel" id="toExcel" value="false">
	<input type="hidden" name="FechaDesde" id="FechaDesde" value="#FechaDesde#">
	<input type="hidden" name="FechaHasta" id="FechaHasta" value="#FechaHasta#">
<!--- 	<input type="hidden" name="CMayor_CCuenta1" value="<cfif isDefined("form.CMayor_CCuenta1")>#form.CMayor_CCuenta1#</cfif>">
	<input type="hidden" name="CMayor_CCuenta2" value="<cfif isDefined("form.CMayor_CCuenta2")>#form.CMayor_CCuenta2#</cfif>">
	<input type="hidden" name="Consultar" value="<cfif isDefined("form.Consultar")>#form.Consultar#</cfif>">
	<input type="hidden" name="Cuenta1Desc" value="<cfif isDefined("form.Cuenta1Desc")>#form.Cuenta1Desc#</cfif>">
	<input type="hidden" name="Cuenta2Desc" value="<cfif isDefined("form.Cuenta2Desc")>#form.Cuenta2Desc#</cfif>">
	<input type="hidden" name="ocodigo" value="<cfif isDefined("form.ocodigo")>#form.ocodigo#</cfif>">
	<input type="hidden" name="oficodigo" value="<cfif isDefined("form.oficodigo")>#form.oficodigo#</cfif>">
	<input type="hidden" name="oDescripcion" value="<cfif isDefined("form.oDescripcion")>#form.oDescripcion#</cfif>"> --->
</form>
</cfoutput>

<!--- Manejo de los Botones --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		history.back();
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}

	function SALVAEXCEL() {
		var fExcel = document.getElementById("FormExcel");
		var btnExcel = document.getElementById("toExcel");
		btnExcel.value = 'true';
		fExcel.submit();
	}
</script>
