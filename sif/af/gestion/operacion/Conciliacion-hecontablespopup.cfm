<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Pasa Parámetros del Url al Form**********
********************************************--->
<cfif isDefined("url.IDcontable") and len(trim(url.IDcontable))>
	<cfset form.IDcontable = url.IDcontable>
</cfif>
<cfif isDefined("url.Dlinea") and len(trim(url.Dlinea))>
	<cfset form.Dlinea = url.Dlinea>
</cfif>
<!---*******************************************
*******Carga Variables Generales****************
********************************************--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #Session.Ecodigo# 
</cfquery>
<!---*******************************************
*******Define que parámetros deben requerirse***
*******Antes de Continuar***********************
********************************************--->
<cfparam name="form.IDcontable">
<cfparam name="form.Dlinea">
<!---*******************************************
*******Consulta*********************************
********************************************--->
<cfquery name="rsForm" datasource="#session.dsn#">
	select a.Eperiodo, a.Emes, a.Cconcepto, a.Edocumento, b.Dlinea, c.Odescripcion, d.Cformato, 
		case b.Dmovimiento when 'D' then 'Débito' else 'Crédito' end as Movimiento, b.Ddescripcion, 
		b.Ddocumento, b.Dreferencia, b.Doriginal, b.Dlocal, b.Dtipocambio, e.Mnombre, 
		vs.VSdesc as MesDesc, coalesce(cce.Cdescripcion,'NA') as Cconceptodesc
	from HEContables a
		inner join HDContables b
				inner join Oficinas c
					on c.Ecodigo = b.Ecodigo
					and c.Ocodigo = b.Ocodigo
				inner join CContables d
					on d.Ecodigo = b.Ecodigo
					and d.Ccuenta = b.Ccuenta
				inner join Monedas e
					on e.Ecodigo = b.Ecodigo
					and e.Mcodigo = b.Mcodigo
			on b.IDcontable = a.IDcontable 
			and b.Ecodigo = a.Ecodigo
			and b.Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dlinea#">
		inner join VSidioma vs
			on <cf_dbfunction name="to_number" args="VSvalor"> = a.Emes
			and VSgrupo = 1	
		inner join Idiomas id
			on id.Iid = vs.Iid
			and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
		inner join ConceptoContableE cce
			on cce.Cconcepto = a.Cconcepto
			and cce.Ecodigo = a.Ecodigo
	where a.Ecodigo =  #session.ecodigo# 
	and a.IDcontable = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Detalle de L&iacute;nea de Asiento Contable</title>
<cf_templatecss/>
</head>
<body>
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
<cfoutput>
<!---*******************************************
*******Encabezado*******************************
********************************************--->
<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr><td class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
	<tr><td class="titulo_reporte">Detalles de L&iacute;nea de Asiento Contable</td></tr>
	<tr><td class="titulo_filtro">#rsForm.mesdesc# de #rsForm.Eperiodo#</td></tr>
	<tr><td class="titulo_filtro">Concepto: #rsForm.cconceptodesc#</td></tr>
	<tr><td class="titulo_filtro">Documento: #rsForm.Edocumento#</td></tr>
	<tr><td class="titulo_filtro">L&iacute;nea #rsForm.Dlinea#</td></tr>
</table>
<!---*******************************************
*******Detalle**********************************
********************************************--->
<br />
<table width="1%" align="center" border="0" cellspacing="1" cellpadding="1">
	<tr>
		
		<td nowrap="nowrap"><strong>Oficina:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Odescripcion#</td>
		<td nowrap="nowrap" width="100%">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Documento:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Ddocumento#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Cuenta:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Cformato#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Referencia:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Dreferencia#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Movimiento:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Movimiento#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Descripci&oacute;n:&nbsp;</strong></td>
		<td nowrap="nowrap" colspan="2">#rsForm.Ddescripcion#</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Moneda:&nbsp;</strong></td>
		<td nowrap="nowrap">#rsForm.Mnombre#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Tipo de Cambio:&nbsp;</strong></td>
		<td nowrap="nowrap" align="right">#LSCurrencyformat(rsForm.Dtipocambio,'none')#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Monto:&nbsp;</strong></td>
		<td nowrap="nowrap" align="right">#LSCurrencyformat(rsForm.Doriginal,'none')#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
	<tr>
		
		<td nowrap="nowrap"><strong>Monto Local:&nbsp;</strong></td>
		<td nowrap="nowrap" align="right">#LSCurrencyformat(rsForm.Dlocal,'none')#</td>
		<td nowrap="nowrap">&nbsp;</td>
	</tr>
</table>
</cfoutput>
<table id="tablabotones2" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<form action="" method="post" name="form1">
<cf_botones names="Cerrar" values="Cerrar" functions="window.close();">
</form>
</td>
</tr>
</table>
<!---*******************************************
*******Manejo de los botones********************
********************************************--->
<script language="javascript1.2" type="text/javascript">
	<!--//
	//funcion para imprimir
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		tablabotones2.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
		tablabotones2.style.display = '';
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
</body>
</html>
