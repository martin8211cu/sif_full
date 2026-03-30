<cfinclude template="query.cfm">
<iframe src="" id="prueba" style="visibility:hiddend"  frameborder="0" width="0" height="0" ></iframe>

<cfif isDefined("url.periodo") and len(trim(url.periodo))>
	<cfset form.periodo = url.periodo>
</cfif>
<cfif isDefined("url.mes") and len(trim(url.mes))>
	<cfset form.mes = url.mes>
</cfif>
<cfif isDefined("url.mesDescrip") and len(trim(url.mesDescrip))>
	<cfset form.mesDescrip = url.mesDescrip>
</cfif>
<cfif isDefined("url.conceptoDescrip") and len(trim(url.conceptoDescrip))>
	<cfset form.conceptoDescrip = url.conceptoDescrip>
</cfif>
<cfif isDefined("url.concepto") and len(trim(url.concepto))>
	<cfset form.concepto = url.concepto>
</cfif>
<cfif isDefined("url.Edocumento") and len(trim(url.Edocumento))>
	<cfset form.Edocumento = url.Edocumento>
</cfif>

<!--- Filtros --->
<cfset periodoD  = "(No definido)">
<cfset mesD      = "(No definido)">
<cfset conceptoD = "(No definido)">
<cfset documentoD = "(No definido)">
<cfif isDefined("form.periodo") and len(trim(form.periodo))>
	<cfset periodoD = form.periodo>
</cfif>
<cfif isDefined("form.mes") and len(trim(form.mes))>
	<cfset mesD = form.mesDescrip>
</cfif>
<cfif isDefined("form.concepto") and len(trim(form.concepto))>
	<cfset conceptoD = form.conceptoDescrip>
</cfif>
<cfif isDefined("form.Edocumento") and (len(trim(form.Edocumento)) and trim(form.Edocumento) neq 0)>
	<cfset documentoD = form.Edocumento>
</cfif>

<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset LvarSelect = fnAsignaquery()>

<!--- Consulta --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	#preservesinglequotes(LvarSelect)#
</cfquery>


<cfif isdefined("Vbajar_arch") or rsReporte.recordcount GT 3000>
<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
			<cfoutput>#LvarSelect#</cfoutput>
		</cf_jdbcquery_open>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="TransSinApl_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.txt" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
	<cflocation addtoken="no" url="gabtransaccionesEliminadas.cfm">
	<cfabort>
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
			text-align:right;}
		.grupo1 {
			font-size:10px;
			font-weight:bold;
			background-color:#CCCCCC;
			text-align:left;}		
		.detalle {
			font-size:10px;
			text-align:left;}
		.detaller {
			font-size:10px;
			text-align:right;}
		.mensaje {
			font-size:10px;
			text-align:center;}
		.paginacion {
			font-size:10px;
			text-align:center;}
	</style>
	
	<!--- Botones --->
	<cfif not isdefined('url.export')> 
		<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
		<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<cfoutput>
			<tr> 
				<td align="right" nowrap>
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
			<tr><td><hr></td></tr>
			</cfoutput>
		</table>
	</cfif>
	
	<!--- Variables --->
	<cfset MaxLineasReporte = 57>	<!--- Máximo de líneas del reporte. --->
	<cfset nLnEncabezado = 12>		<!--- Total de líneas del encabezado. Se le suma el agrupamiento. --->
	<cfset nCols = 7>				<!--- Total de columnas del encabezado. --->
	
	<!--- Página --->
	<cfif rsReporte.recordCount gt 0>
		<cfset paginas = rsReporte.recordCount / (MaxLineasReporte - nLnEncabezado)>
		<cfset pf = #Fix(paginas)#>
		<cfif #paginas# gt #pf#>
			<cfset paginas = #pf# + 1>
		</cfif>
	<cfelse>
		<cfset pagina = 1>
		<cfset paginas = 1>
	</cfif>
	
	<!--- Llena el Encabezado --->
	<cfsavecontent variable="encabezado">
		<cfoutput>	
			<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_reporte">Transacciones Eliminadas</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">#mesD# de #periodoD#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">Concepto: #conceptoD#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">Documento: #documentoD#</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="#nCols#" align="center"><hr></td></tr>
			<tr>
				<td class="titulo_columna">Cuenta</td>
				<td class="titulo_columna">Placa</td>
				<td class="titulo_columna">Descripci&oacute;n</td>
				<td class="titulo_columna">Marca</td>
				<td class="titulo_columna">Modelo</td>
				<td class="titulo_columnar">Monto</td>
				<td class="titulo_columnar">Transacci&oacute;n</td>			
			</tr>
			<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		</cfoutput>
	</cfsavecontent>
	
		<!--- Pinta el Reporte --->
	<cfif isdefined('url.export')>
		<cfcontent type="application/msexcel">
			<cfheader 	name="Content-Disposition"  
				value="attachment;filename=TransEliminadas#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" >
	</cfif> 
	
	<!--- Llena el Detalle --->
	<cfif rsReporte.recordcount gt 0>
		<cfset pagina = 1>
		<cfset contador = nLnEncabezado>		
		<cfset paginaNueva = false>
		<cfset vCentroFuncional = -1>
		<cfset vCategoria = -1>
		<cfset vClase = -1>
		
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">	
			<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
				<cfoutput>#encabezado#</cfoutput>
			<cfloop query="rsReporte">
			<!--- Pinta el Encabezado --->
				<cfif contador gte MaxLineasReporte>
					<cfoutput>#encabezado#</cfoutput>
					<cfset paginaNueva = true>
					<cfset contador = nLnEncabezado>
					<cfset pagina = pagina + 1>
				</cfif>
		
			<!--- Agrupamiento por Centro Funcional --->
				<cfif #trim(centroFuncional)# neq #vCentroFuncional# or #paginaNueva#>
					<tr><td><br></td></tr>
					<tr><td colspan="#nCols#" class="grupo1">Centro Funcional: #trim(centroFuncionalD)#</td></tr>
					<cfset vCategoria = -1>
					<cfset vClase = -1>
					<cfset contador = contador + 2>
				</cfif>
					<cfset vCentroFuncional = #trim(centroFuncional)#>		
		
		<!--- Agrupamiento por Categoría --->
				<cfif #trim(categoria)# neq #vcategoria# or #paginaNueva#>
					<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;Categor&iacute;a: #trim(categoriaD)#</td></tr>
					<cfset vClase = -1>
					<cfset contador = contador + 1>
				</cfif> 
				<cfset vCategoria = #trim(categoria)#>			
		
		<!--- Agrupamiento por Clase --->
				<cfif #trim(clase)# neq #vClase# or #paginaNueva#>
					<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;Clase: #trim(claseD)#</td></tr>
					<cfset contador = contador + 1>
				</cfif>
				<cfset vClase = #trim(clase)#>

				<tr>
				<cfoutput>
					<td class="detalle">#trim(cuentaFormato)#</td>
					<td class="detalle">#trim(placa)#</td>
					<td class="detalle">#mid(trim(placaD),1,35)#</td>
					<td class="detalle">#trim(marcaD)#</td>
					<td class="detalle">#trim(modeloD)#</td>
					<td class="detaller">#LSNumberFormat(monto,',9.00')#</td>
					<cfif len(trim(AFRmotivo)) GT 0 and AFRmotivo NEQ 0>
					<td class="detaller">Retiro</td>
					<cfelseif len(trim(GATvutil)) GT 0 and GATvutil NEQ 0>
					<td class="detaller">Mejora</td>
					<cfelse>
					<td class="detaller">Adquisici&oacute;n</td>
					</cfif>	
				</cfoutput>																							
			</tr>				
			<cfset contador = contador + 1>
			<cfset paginaNueva = false>
		</cfloop>
			<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
			<tr><td colspan="#nCols#" class="paginacion"> - P&aacute;g #pagina# / #paginas# - </td></tr>
	</table>
<cfelse>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
		<cfoutput>#encabezado#</cfoutput>
		<tr></tr>
		<tr><td colspan="15" class="mensaje"> --- La consulta no gener&oacute; ning&uacute;n resultado --- </td></tr>
	</table>
</cfif>

	<cfset params = 'export=1' >
	<cfif isdefined("form.periodo")>
		<cfset params = params & "&periodo=#form.periodo#" >
	</cfif>
	<cfif isdefined("form.mes")>
		<cfset params = params & "&mes=#form.mes#" >
	</cfif>
	<cfif isdefined("form.concepto")>
		<cfset params = params & "&concepto=#form.concepto#" >	
	</cfif>
	<cfif isdefined("form.Edocumento")>
		<cfset params = params & "&Edocumento=#form.Edocumento#" >	
	</cfif>
	<cfif isdefined("form.mesDescrip")>
		<cfset params = params & "&mesDescrip=#form.mesDescrip#" >	
	</cfif>
	<cfif isdefined("form.conceptoDescrip")>
		<cfset params = params & "&conceptoDescrip=#form.conceptoDescrip#" >	
	</cfif>				
	
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
			var ira = '?<cfoutput>#jsstringformat(params)#</cfoutput>';
			document.getElementById("prueba").src="gabtransaccionesEliminadasRep.cfm" + ira;
		}
	</script>


