<cfset variable = 2>
<cfset LvarCondicion2     = " ">

<cfinclude template="query.cfm">
<iframe src="" id="prueba" style="visibility:hiddend"  frameborder="0" width="0" height="0" ></iframe>

<cfif isDefined("url.concepto") and len(trim(url.concepto))>
	<cfset form.concepto = url.concepto>
</cfif>
<cfif isDefined("url.Edocumento") and len(trim(url.Edocumento))>
	<cfset form.Edocumento = url.Edocumento>
</cfif>
<cfif isDefined("url.estado") and len(trim(url.estado))>
	<cfset form.estado = url.estado>
</cfif>

<!--- Pasa Parámetros del url al form para cuando el reporte es llamado por url --->
<cfif isDefined("url.periodo") and len(trim(url.periodo))>
	<cfset form.periodo = url.periodo>
</cfif>
<cfif isDefined("url.mes") and len(trim(url.mes))>
	<cfset form.mes = url.mes>
	<cfquery name="rsMes" datasource="#session.dsn#">
		select vs.VSdesc as MesDescrip
		from VSidioma vs
			inner join Idiomas id
			on id.Iid = vs.Iid
			and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
		where <cf_dbfunction name="to_number" args="VSvalor"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
		and VSgrupo = 1
	</cfquery>
	<cfif rsMes.recordcount eq 1 and len(trim(rsMes.MesDescrip))>
		<cfset form.mesDescrip = rsMes.MesDescrip>
	<cfelse>
		<cfset form.mesDescrip = "">
	</cfif>
</cfif>
<cfif isDefined("url.concepto") and len(trim(url.concepto))>
	<cfset form.concepto = url.concepto>
	<cfquery name="rsConcepto" datasource="#session.dsn#">
		select coalesce(cce.Cdescripcion,'NA') as ConceptoDescrip
		from ConceptoContableE cce
		where cce.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.concepto#">
		and cce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
	<cfif rsConcepto.recordcount eq 1 and len(trim(rsConcepto.ConceptoDescrip))>
		<cfset form.conceptoDescrip = rsConcepto.ConceptoDescrip>
	<cfelseif form.concepto eq -10>
		<cfset form.conceptoDescrip = "No Asignado">
	<cfelse>
		<cfset form.conceptoDescrip = "">
	</cfif>
</cfif>
<cfif isDefined("url.Edocumento") and len(trim(url.Edocumento))>
	<cfset form.Edocumento = url.Edocumento>
	<cfif url.Edocumento eq -10>
		<cfset form.EdocumentoDescrip = "No Asignado">
	</cfif>
</cfif>
<cfif isDefined("url.estado") and url.estado neq "-1">
	<cfset form.estado = url.estado>
	<cfswitch expression="#url.estado#">
	<cfcase value="0"><cfset form.estadoDescrip = 'Incompleto'></cfcase>
	<cfcase value="1"><cfset form.estadoDescrip = 'Completo'></cfcase>
	<cfcase value="2"><cfset form.estadoDescrip = 'Conciliado'></cfcase>
	<cfcase value="3"><cfset form.estadoDescrip = 'Aplicado'></cfcase>
	</cfswitch>
</cfif>

<!--- Filtros --->
	<cfset periodoD   = "(No definido)">
	<cfset mesD       = "(No definido)">
	<cfset conceptoD  = "(No definido)">
	<cfset documentoD = "(No definido)">
	<cfset estadoD    = "(No definido)">
	
<cfif isDefined("form.periodo") and len(trim(form.periodo))>
	<cfset periodoD = form.periodo>
</cfif>
<cfif isDefined("form.mes") and len(trim(form.mes))>
	<cfset mesD = form.mesDescrip>
</cfif>
<cfif isDefined("form.concepto") and len(trim(form.concepto))>
	<cfset conceptoD = form.conceptoDescrip>
</cfif>
<cfif isDefined("form.Edocumento") and len(trim(form.Edocumento))>
	<cfif isDefined("form.EdocumentoDescrip") and len(trim(form.EdocumentoDescrip))>
		<cfset documentoD = form.EdocumentoDescrip>
	<cfelse>
		<cfset documentoD = form.Edocumento>
	</cfif>
</cfif>
<cfif isDefined("form.estado") and form.estado neq "-1">
	<cfset estadoD = form.estadoDescrip>
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
	<cflocation addtoken="no" url="gabTransaccionesSinAplicarRep.cfm">
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
	<cfset nLnEncabezado = 13>		<!--- Total de líneas del encabezado. Se le suma el agrupamiento. --->
	<cfset nCols = 14>				<!--- Total de columnas del encabezado. --->
	
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
			<tr><td colspan="#nCols#" class="titulo_reporte">Transacciones Sin Aplicar</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">#mesD# de #periodoD#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">Concepto: #conceptoD#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">Documento: #documentoD#</td></tr>
			<tr><td colspan="#nCols#" class="titulo_filtro">Estado: #estadoD#</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="#nCols#" align="center"><hr></td></tr>
			<tr>
				<td class="titulo_columna">Cuenta</td>
				<cfif not isdefined("resumido")>
					<td class="titulo_columna">Placa</td>
				</cfif>
				<td class="titulo_columna">Descripci&oacute;n</td>
				<cfif not isdefined("resumido")>
					<td class="titulo_columna">Marca</td>
					<td class="titulo_columna">Modelo</td>
				</cfif>
				<td class="titulo_columnar">Monto</td>
				<td class="titulo_columnar">&nbsp;Transacci&oacute;n</td>
				<td class="titulo_columna">Estado</td>
				<cfif not isdefined("resumido")>
					<td class="titulo_columna">Oficina</td>
					<td class="titulo_columna">Inicio Dep</td>
					<td class="titulo_columna">Inicio Rev</td>
					<td class="titulo_columna">Asiento</td>
					<td class="titulo_columna">Poliza</td>
					<td class="titulo_columna">Referencia</td>
				</cfif>
			</tr>
			<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		</cfoutput>
	</cfsavecontent>
	
	<!--- Pinta el Reporte --->
	<cfif isdefined('url.export')>
		<cfcontent type="application/msexcel">
			<cfheader 	name="Content-Disposition"  
				value="attachment;filename=TransSinAplicar#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" >
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
		<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
		<cfoutput>#encabezado#</cfoutput>
		<cfset paginaNueva = true>
		<cfset contador = nLnEncabezado>
		<cfset pagina = pagina + 1>
	</cfif>
<cfif not isdefined("resumido")>
	<!--- Agrupamiento por Centro Funcional --->
	<cfif #trim(centroFuncional)# neq #vCentroFuncional# or #paginaNueva#>
		<tr><td><br></td></tr>
		<cfoutput>
		<tr><td colspan="#nCols#" class="grupo1">Centro Funcional: #trim(centroFuncionalD)#</td></tr>
		</cfoutput>
		<cfset vCategoria = -1>
		<cfset vClase = -1>
		<cfset contador = contador + 2>
	</cfif>
	<cfset vCentroFuncional = #trim(centroFuncional)#>
	
	<!--- Agrupamiento por Categoría --->
	<cfif #trim(categoria)# neq #vcategoria# or #paginaNueva#>
		<cfoutput>
		<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;Categor&iacute;a: #trim(categoriaD)#</td></tr>
		</cfoutput>
		<cfset vClase = -1>
		<cfset contador = contador + 1>
	</cfif> 
	<cfset vCategoria = #trim(categoria)#>
	
	<!--- Agrupamiento por Clase --->
	<cfif #trim(clase)# neq #vClase# or #paginaNueva#>
		<cfoutput>
		<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;Clase: #trim(claseD)#</td></tr>
		</cfoutput>
		<cfset contador = contador + 1>
	</cfif>
	<cfset vClase = #trim(clase)#>
</cfif>
		<tr>
			<cfoutput>		
				<td class="detalle">#trim(cuentaFormato)#</td>
				<cfif not isdefined("resumido")>
					<td class="detalle">#trim(placa)#</td>
				</cfif>
					<td class="detalle">#mid(trim(placaD),1,35)#</td>
				<cfif not isdefined("resumido")>
					<td class="detalle">#trim(marcaD)#</td>
					<td class="detalle">#trim(modeloD)#</td>
				</cfif>
				<td class="detaller">#LSNumberFormat(monto,',9.00')#</td>
				<td class="detaller">#Transaccion#</td>
				<td class="detalle">#trim(GATestadoD)#</td>
				<cfif not isdefined("resumido")>
				<td class="detalle">#trim(Oficodigo)#<cfif Odescripcion NEQ ""> - </cfif>#trim(Odescripcion)#</td>
					<td class="detalle">#LSDateFormat(GATfechainidep, 'dd/mm/yyyy')#</td>
					<td class="detalle">#LSDateFormat(GATfechainirev, 'dd/mm/yyyy')#</td>
					<td class="detalle">#Asiento#</td>
					<td class="detalle">#Poliza#</td>
					<td class="detalle">#Referencia#</td>
				</cfif>
			</cfoutput>
		</tr>
		<cfset contador = contador + 1>
		<cfset paginaNueva = false>	
	</cfloop>
		<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
		<tr><td colspan="19" class="paginacion"><cfoutput> - P&aacute;g #pagina# / #paginas# - </cfoutput></td></tr>
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
	<cfif isdefined("form.estado")>
		<cfset params = params & "&estado=#form.estado#" >	
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
			document.getElementById("prueba").src="gabTransaccionesSinAplicarRep.cfm" + ira;
		}	
				
	</script>


