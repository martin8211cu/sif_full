<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Reporte No1 de Conciliacion**************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->

<!---*******************************************
*******Pasa Parámetros del Url al Form**********
********************************************--->
<cfif isDefined("url.GATperiodo") and len(trim(url.GATperiodo))>
	<cfset form.GATperiodo = url.GATperiodo>
</cfif>
<cfif isDefined("url.GATmes") and len(trim(url.GATmes))>
	<cfset form.GATmes = url.GATmes>
</cfif>
<cfif isDefined("url.Cconcepto") and len(trim(url.Cconcepto))>
	<cfset form.Cconcepto = url.Cconcepto>
</cfif>
<cfif isDefined("url.Edocumento") and len(trim(url.Edocumento))>
	<cfset form.Edocumento = url.Edocumento>
</cfif>
<cfif isDefined("url.Ocodigo") and len(trim(url.Ocodigo))>
	<cfset form.Ocodigo = url.Ocodigo>
</cfif>
<cfif isDefined("url.CFcuenta") and len(trim(url.CFcuenta))>
	<cfset form.CFcuenta = url.CFcuenta>
</cfif>
<!---*******************************************
*******Carga Variables Generales****************
********************************************--->
<cfquery name="rsMes" datasource="#session.dsn#">
	select vs.VSdesc as MesDesc
	from VSidioma vs
		inner join Idiomas id
		on id.Iid = vs.Iid
		and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
	where <cf_dbfunction name="to_number" args="VSvalor"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
	and VSgrupo = 1
</cfquery>
<cfif rsMes.recordcount eq 1 and len(trim(rsMes.Mesdesc))>
	<cfset form.mesdesc = rsMes.Mesdesc>
</cfif>
<cfquery name="rsConcepto" datasource="#session.dsn#">
	select coalesce(cce.Cdescripcion,'NA') as Conceptodesc
	from ConceptoContableE cce
	where cce.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
	and cce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<cfif rsConcepto.recordcount eq 1 and len(trim(rsConcepto.Conceptodesc))>
	<cfset form.conceptodesc = rsConcepto.Conceptodesc>
</cfif>
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---*******************************************
*******Define que parámetros deben requerirse***
*******Antes de Continuar***********************
********************************************--->
<cfparam name="form.GATperiodo">
<cfparam name="form.mesdesc">
<cfparam name="form.conceptodesc">
<cfparam name="form.Edocumento">
<cfparam name="form.Ocodigo">
<cfparam name="form.CFcuenta">
<!---*******************************************
*******Estilos para pintar el reporte***********
********************************************--->
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
	.titulo_columnac {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:center;}
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
	.detallec {
		font-size:10px;
		text-align:center;}
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
</style>
<!---*******************************************
*******Pinta los botones de regresar, imprimir**
*******y guardar en excel/word******************
********************************************--->
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
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
<!---*******************************************
*******Consulta para pintar el reporte**********
********************************************--->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select a.ID, a.GATplaca, 
	<cf_dbfunction name="spart"   args="a.GATdescripcion,1,25"> as GATdescripcion, 
	<cf_dbfunction name="concat" args="d.CFcodigo ,' - ',d.CFdescripcion "> as CentroFuncional, 
	<cf_dbfunction name="concat" args="e.ACcodigodesc ,' - ', e.ACdescripcion "> as Categoria, 
	<cf_dbfunction name="concat" args=" f.ACcodigodesc ,' - ' , f.ACdescripcion"> as Clase, 
	a.GATmonto as MontoGestion, case coalesce(act.Aid,0) when 0 then 'Adquisici&oacute;n' else case when a.GATmonto < 0 then 'Retiro' else 'Mejora' end end as Movimiento
	from GATransacciones a
			inner join CFinanciera c
				on c.CFcuenta = a.CFcuenta
				and	c.Ecodigo = a.Ecodigo
			left outer join CFuncional d
				on d.Ecodigo = a.Ecodigo
				and d.CFid = a.CFid
			left outer join ACategoria e
				on e.Ecodigo = a.Ecodigo
				and e.ACcodigo = a.ACcodigo
			left outer join AClasificacion f
				on f.Ecodigo = a.Ecodigo
				and f.ACcodigo = a.ACcodigo
				and f.ACid = a.ACid
			left outer join Activos act
				on act.Ecodigo = a.Ecodigo
				and act.Aplaca = a.GATplaca
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GATperiodo#">
			and a.GATmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GATmes#">
			and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cconcepto#">
			and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Edocumento#">
			and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">
			and a.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
	order by a.GATdescripcion
</cfquery>
<!---*******************************************
*******Consultas adicionales para los***********
*******detalles de la Conciliacion**************
********************************************--->
<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
	<cfquery name="rsOdescripcion" datasource="#session.dsn#">
		select Odescripcion from Oficinas where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
	</cfquery>
	<cfset form.Odescripcion = rsOdescripcion.Odescripcion>
</cfif>
<cfif isdefined("form.CFcuenta") and len(trim(form.CFcuenta))>
	<cfquery name="rsCFcuenta" datasource="#session.dsn#">
		select CFformato from CFinanciera where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">
	</cfquery>
	<cfset form.CFformato = rsCFcuenta.CFformato>
</cfif>
<!---*******************************************
*******Varibles que definen comportarmiento*****
*******del pintado******************************
********************************************--->
<!---*******************************************
*******Máximo de líneas del reporte*************
********************************************--->
<cfset MaxLineasReporte = 57>
<!---*******************************************
*******Total de líneas del encabezado.**********
*******Se le suma el agrupamiento***************
********************************************--->
<cfset nLnEncabezado = 13>
<!---*******************************************
*******Total de columnas del encabezado*********
********************************************--->
<cfset nCols = 4>
<!---*******************************************
*******Página***********************************
********************************************--->
<cfif rsReporte.recordCount gt 0>
	<cfset paginas = rsReporte.recordCount / (MaxLineasReporte - nLnEncabezado)>
	<cfset pf = Fix(paginas)>
	<cfif paginas gt pf>
		<cfset paginas = pf + 1>
	</cfif>
<cfelse>
	<cfset pagina = 1>
	<cfset paginas = 1>
</cfif>
<!---*******************************************
*******Define el Encabezado*********************
********************************************--->
<cfsavecontent variable="encabezado">
	<cfoutput>	
		<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_reporte">Detalles de Asiento Contable</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">#form.mesdesc# de #form.GATperiodo#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Concepto: #form.conceptodesc#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Documento: #form.Edocumento#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Oficina: #form.Odescripcion#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Cuenta: #form.CFformato#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		<tr>
			<td class="titulo_columna">Placa</td>
			<td class="titulo_columna">Descripci&oacute;n</td>
			<td class="titulo_columna">Movimiento</td>
			<td class="titulo_columnar">Monto</td>
		</tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	</cfoutput>
</cfsavecontent>
<!---*******************************************
*******Define el Detalle************************
********************************************--->
<cfsavecontent variable="detalle">
	<cfoutput>
		<cfif rsReporte.recordcount gt 0>
			<!---*******************************************
			*******Variables para manejar paginación********
			********************************************--->
			<cfset pagina = 1>
			<cfset contador = nLnEncabezado>		
			<cfset paginaNueva = false>
			<!---*******************************************
			*******Variables para manejar cortes************
			********************************************--->
			<cfset vCentroFuncional = -1>
			<cfset vCategoria = -1>
			<cfset vClase = -1>
			<cfloop query="rsReporte">
 				<!---*******************************************
				*******Pinta el Encabezado**********************
				********************************************--->
				<cfif contador gte MaxLineasReporte>
					<tr><td class="paginacion" colspan="#nCols#"> - P&aacute;g #pagina# / #paginas# - </td></tr>
					<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
					#encabezado#
					<cfset paginaNueva = true>
					<cfset contador = nLnEncabezado>
					<cfset pagina = pagina + 1>
				</cfif>

				<!--- Agrupamiento por Centro Funcional --->
				<cfif trim(CentroFuncional) neq vCentroFuncional or paginaNueva>
					<tr><td><br></td></tr>
					<tr><td colspan="#nCols#" class="grupo1">Centro Funcional: #trim(CentroFuncional)#</td></tr>
					<cfset vCategoria = -1>
					<cfset vClase = -1>
					<cfset contador = contador + 2>
				</cfif>
				<cfset vCentroFuncional = trim(CentroFuncional)>

				<!--- Agrupamiento por Categoría --->
				<cfif trim(Categoria) neq vCategoria or paginaNueva>
					<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;Categor&iacute;a: #trim(Categoria)#</td></tr>
					<cfset vClase = -1>
					<cfset contador = contador + 1>
				</cfif> 
				<cfset vCategoria = trim(Categoria)>

				<!--- Agrupamiento por Clase --->
				<cfif trim(Clase) neq vClase or paginaNueva>
					<tr><td colspan="#nCols#" class="grupo1">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;Clase: #trim(Clase)#</td></tr>
					<cfset contador = contador + 1>
				</cfif>
				<cfset vClase = trim(Clase)>
				
				<tr>				
					<td class="detalle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(GATplaca)#</td>
					<td class="detalle">#GATdescripcion#</td>
					<td class="detalle">#Movimiento#</td>
					<td class="detaller">#LSNumberFormat(MontoGestion,',9.00')#</td>
				</tr>
				<cfset contador = contador + 1>
				<cfset paginaNueva = false>
			</cfloop>
		<cfelse>
			<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
			<tr><td colspan="#nCols#" class="mensaje"> --- La consulta no gener&oacute; ning&uacute;n resultado --- </td></tr>
		</cfif>
	</cfoutput>
</cfsavecontent>
<!---*******************************************
*******Define el pintado del Reporte************
********************************************--->
<cfoutput>
<cfsavecontent variable="reporte">
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		#encabezado#
		#detalle#
		<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
		<tr><td colspan="#nCols#" class="paginacion"> - P&aacute;g #pagina# / #paginas# - </td></tr>
	</table>
</cfsavecontent>
</cfoutput>
<!---*******************************************
*******Pinta el Reporte*************************
********************************************--->
<cfoutput>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	#reporte#
	<cfset tempfile = GetTempDirectory()>
	<cfset session.tempfile_xls = #tempfile# & "/tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".xls">
	<cffile action="write" file="#session.tempfile_xls#" output="#reporte#" nameconflict="overwrite">		
</table>
</cfoutput>
<!---*******************************************
*******Manejo de los botones********************
********************************************--->
<script language="javascript1.2" type="text/javascript">
	<!--//
	//funcion para regresar
	function regresar() {
		history.back();
	}
	//funcion para imprimir
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}
	//funcion para guardar en excell/word
	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		//EXCEL.style.visibility='hidden';
		var file =  "to_excel.cfm";
		var string=  "width=400,height=200,toolbar=no,directories=no,menubar=yes,resizable=yes,dependent=yes"    
		hwnd = window.open(file,'excel',string) ;                    
		if (navigator.appName == "Netscape") {   
			 hwnd.focus();
        }   
	}
	//-->
</script>