<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Reporte No1 de Conciliacion**************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
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
<!---Mes--->
<cfquery name="rsMes" datasource="#session.dsn#">
	select vs.VSdesc as MesDesc
	from VSidioma vs
		inner join Idiomas id
		on id.Iid = vs.Iid
		and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
	where  <cf_dbfunction name="to_number" args="VSvalor"> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATmes#">
	and VSgrupo = 1
</cfquery>
<cfif rsMes.recordcount eq 1 and len(trim(rsMes.Mesdesc))>
	<cfset form.mesdesc = rsMes.Mesdesc>
</cfif>
<!---Concepto Contable--->
<cfquery name="rsConcepto" datasource="#session.dsn#">
	select coalesce(cce.Cdescripcion,'NA') as Conceptodesc
	from ConceptoContableE cce
	where cce.Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
	and cce.Ecodigo = #session.ecodigo#
</cfquery>
<cfif rsConcepto.recordcount eq 1 and len(trim(rsConcepto.Conceptodesc))>
	<cfset form.conceptodesc = rsConcepto.Conceptodesc>
</cfif>
<!---Empresa--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!---*******************************************
*******Define que parámetros deben requerirse***
*******Antes de Continuar***********************
********************************************--->
<cfparam name="form.GATperiodo">
<cfparam name="form.mesdesc">
<cfparam name="form.conceptodesc">
<cfparam name="form.Edocumento">
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
*******no requiere transacción******************
********************************************--->
<cf_dbtemp name="CONConsST_V1" returnvariable="CONCILIAR" datasource="#session.dsn#">
	<cf_dbtempcol name="IDcontable" 			type="numeric"		 mandatory="yes">
	<cf_dbtempcol name="Ecodigo"  				type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="GATperiodo"  			type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="GATmes"  				type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="Cconcepto"  			type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="Ocodigo"  				type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="Odescripcion"  			type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="Edocumento"  			type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="CFcuenta"  				type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="CFformato"  			type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="MontoGestion"  			type="money"  		 mandatory="yes">
	<cf_dbtempcol name="MontoAsiento"  			type="money"  		 mandatory="yes">
	<cf_dbtempcol name="Conciliado"  		 	type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="TotalItemsConciliados"  type="numeric"  	 mandatory="yes">
	<cf_dbtempcol name="TotalItems"  			type="numeric"  	 mandatory="yes">
	<cf_dbtempkey cols="IDcontable,Ocodigo,CFcuenta">
</cf_dbtemp>
<cfquery datasource="#Session.Dsn#">
	insert into #CONCILIAR#(IDcontable,
			Ecodigo,
			GATperiodo,
			GATmes,
			Cconcepto,
			Ocodigo,
			Odescripcion,
			Edocumento,
			CFcuenta,
			CFformato,
			MontoGestion,
			MontoAsiento,
			Conciliado,
			TotalItems,
			TotalItemsConciliados)
	select 	a.IDcontable,
			a.Ecodigo,
			a.GATperiodo,
			a.GATmes,
			a.Cconcepto,
			a.Ocodigo,
			d.Odescripcion,
			a.Edocumento,
			a.CFcuenta,
			c.CFformato,
			coalesce(sum(a.GATmonto),0.00) as MontoGestion, 
			000000000.0000 as MontoAsiento,
			0 as Conciliado,
			coalesce(count( 1 ),0) as TotalItems,
			coalesce( sum( case GATestado when 2 then 1 else 0 end ),0) as TotalItemsConciliados
	from GATransacciones a
	inner join CFinanciera c
		on c.CFcuenta = a.CFcuenta
		and	c.Ecodigo = a.Ecodigo
	inner join Oficinas d
		on d.Ecodigo = a.Ecodigo
		and d.Ocodigo = a.Ocodigo
	where a.Ecodigo =#Session.Ecodigo#
	and a.GATperiodo = #Form.GATperiodo#
	and a.GATmes = #Form.GATmes#
	and a.Cconcepto = #Form.Cconcepto#
	and a.Edocumento = #Form.Edocumento#
	group by a.IDcontable,
			a.Ecodigo,
			a.GATperiodo,
			a.GATmes,
			a.Cconcepto,
			a.Ocodigo,
			d.Odescripcion,
			a.Edocumento,
			a.CFcuenta,
			c.CFformato
</cfquery>
<cfquery datasource="#Session.Dsn#">	
	update #CONCILIAR#
		set MontoAsiento = 
		(select coalesce(sum(b.Dlocal*(case b.Dmovimiento when 'D' then 1 else -1 end)),0.00)
		from HDContables b
		where  b.IDcontable = #CONCILIAR#.IDcontable
		and b.Ocodigo = #CONCILIAR#.Ocodigo
		and b.CFcuenta = #CONCILIAR#.CFcuenta
		)
</cfquery>
<cfquery datasource="#Session.Dsn#">		
	update #CONCILIAR#
	set Conciliado = 
	case when TotalItems = TotalItemsConciliados then 1 else 0 end
</cfquery>
<cfquery datasource="#Session.Dsn#">		
	select GATperiodo, GATmes, Cconcepto, Edocumento, CFcuenta, CFformato, IDcontable, Ocodigo, Odescripcion, TotalItems, MontoGestion, MontoAsiento, case Conciliado when 1 then 'Si' else 'No' end as Conciliado
	from #CONCILIAR#
</cfquery>
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
<cfset nCols = 5>
<!---*******************************************
*******Página***********************************
********************************************--->
<cfquery name="rsReporte" datasource="#Session.Dsn#">
	select 	IDcontable,
			Ecodigo,
			GATperiodo,
			GATmes,
			Cconcepto,
			Ocodigo,
			Odescripcion,
			Edocumento,
			CFcuenta,
			CFformato,
			MontoGestion,
			MontoAsiento,
			Conciliado,
			TotalItems,
			TotalItemsConciliados
	from #CONCILIAR#
</cfquery>
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
		<tr><td colspan="#nCols#" class="titulo_reporte">Resumen de Conciliaci&oacute;n por Cuenta</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">#form.mesdesc# de #form.GATperiodo#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Concepto: #form.conceptodesc#</td></tr>
		<tr><td colspan="#nCols#" class="titulo_filtro">Documento: #form.Edocumento#</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="#nCols#" align="center"><hr></td></tr>
		<tr>
			<td class="titulo_columna">Formato</td>
			<td class="titulo_columnar">Cantidad Items</td>
			<td class="titulo_columnar">Monto Asiento Contable</td>
			<td class="titulo_columnar">Monto Gesti&oacute;n</td>
			<td class="titulo_columnac">Conciliado</td>
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
			<cfset pagina = 1>
			<cfset contador = nLnEncabezado>		
			<cfset paginaNueva = false>
			<!---*******************************************
			*******Variables para manejar cortes************
			********************************************--->
			<cfset vOdescripcion = -1>
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
				
				<!--- Agrupamiento por Oficina --->
				<cfif trim(rsReporte.Odescripcion) neq vOdescripcion or paginaNueva>
					<tr><td><br></td></tr>
					<tr><td colspan="#nCols#" class="grupo1">Oficina: #trim(rsReporte.Odescripcion)#</td></tr>
					<cfset contador = contador + 2>
				</cfif>
				<cfset vOdescripcion = trim(rsReporte.Odescripcion)>

				<tr>				
					<td class="detalle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsReporte.CFformato)#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.TotalItems,',9')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.MontoGestion,',9.00')#</td>
					<td class="detaller">#LSNumberFormat(rsReporte.MontoAsiento,',9.00')#</td>
					<td class="detallec">#trim(rsReporte.conciliado)#</td>
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