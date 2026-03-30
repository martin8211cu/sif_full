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
<cfif isDefined("url.GATid") and len(trim(url.GATid))>
	<cfset form.GATid = url.GATid>
</cfif>
<!---*******************************************
*******Carga Variables Generales****************
********************************************--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---*******************************************
*******Define que parámetros deben requerirse***
*******Antes de Continuar***********************
********************************************--->
<cfparam name="form.GATid">
<!---*******************************************
*******Consulta*********************************
********************************************--->
<cfinclude template="Conciliacion-common.cfm">
<cfquery name="rsForm" datasource="#session.dsn#">
	select a.ID as GATid, a.Ecodigo, a.Cconcepto, a.GATperiodo, a.GATmes, a.Edocumento, 
		a.GATfecha, a.GATdescripcion, a.Ocodigo, a.ACid, a.ACcodigo, a.AFMid, a.AFMMid, a.GATserie, 
		a.GATplaca, a.GATfechainidep, a.GATfechainirev, a.CFid, coalesce(a.GATmonto,0.00) as GATmonto, 
		a.fechaalta, a.BMUsucodigo, a.ts_rversion, a.Referencia1, a.Referencia2, a.Referencia3, a.CFcuenta, 
		a.AFCcodigo, a.AFRmotivo
		,b.CFcodigo, b.CFdescripcion <!--- para el tag de centros funcionales --->
		,c.ACcodigo, c.ACcodigodesc, c.ACdescripcion, c.ACmascara <!--- para el tag de categorias --->
		,d.ACid, d.ACcodigodesc as ACcodigodesc_clas, d.ACdescripcion as ACdescripcion_clas<!--- para el tag de clases --->
		,e.AFMcodigo, e.AFMdescripcion <!--- para el tag de marcas --->
		,f.AFMMcodigo, f.AFMMdescripcion <!--- para el tag de modelos --->
		,g.AFCcodigoclas, g.AFCdescripcion <!--- para el tag de tipos --->
		,h.Cmayor, h.CFformato, h.Ccuenta <!--- para el tag de cuentas --->
		,a.GATReferencia
		from GATransacciones a
			left outer join CFuncional b
				on b.CFid = a.CFid
				and b.Ecodigo = a.Ecodigo
			left outer join ACategoria c
				on c.ACcodigo = a.ACcodigo
				and c.Ecodigo = a.Ecodigo
			left outer join AClasificacion d
				on d.ACid = a.ACid
				and d.ACcodigo = a.ACcodigo
				and d.Ecodigo = a.Ecodigo
			left outer join AFMarcas e
				on e.AFMid = a.AFMid
				and e.Ecodigo = a.Ecodigo
			left outer join AFMModelos f
				on f.AFMid = a.AFMid
				and f.AFMMid = a.AFMMid
				and f.Ecodigo = a.Ecodigo
			left outer join AFClasificaciones g
				on g.AFCcodigo = a.AFCcodigo
				and g.Ecodigo = a.Ecodigo
			left outer join CFinanciera h
				on h.CFcuenta = a.CFcuenta
				and h.Ecodigo = a.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATid#">
</cfquery>
<cfquery name="rsAFRmotivo" datasource="#session.dsn#">
	select AFRmotivo as value, AFRdescripcion as description
	from AFRetiroCuentas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
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
	<tr><td class="titulo_reporte">Detalles de L&iacute;nea de Transacci&oacute;n</td></tr>
	<tr><td class="titulo_filtro">
		<cfloop query="rsMeses">
			<cfif value eq rsForm.GATMes>#description#</cfif>
		</cfloop> 
		de 
		#rsForm.GATperiodo#
	</td></tr>
	<tr><td class="titulo_filtro">
		Concepto: 
		<cfloop query="rsConceptos">
			<cfif value eq rsForm.Cconcepto>#description#</cfif>
		</cfloop>
	</td></tr>
	<tr><td class="titulo_filtro">Documento: #rsForm.Edocumento#</td></tr>
</table>
<br />
<!---*******************************************
*******Detalle**********************************
********************************************--->
<table width="100%" align="center" border="0" cellspacing="1" cellpadding="1">
	  <tr>
	  	<td align="right" nowrap="nowrap" class="fileLabel"><strong>Fecha:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#LSDateFormat(rsForm.GATfecha,'dd/mm/yyyy')#		</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><strong>Centro Funcional:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#rsForm.CFcodigo# - #rsForm.CFdescripcion#		</td>
	  </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Categor&iacute;a:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.ACcodigodesc# - #rsForm.ACdescripcion#        </td>
	    <td nowrap="nowrap">&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel"><strong>Clase:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.ACcodigodesc_clas# - #rsForm.ACdescripcion_clas#		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Placa:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.GATplaca#        </td>
	    <td nowrap="nowrap">&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel"><strong>Descripci&oacute;n:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.GATdescripcion#        </td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Marca:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.AFMcodigo# - #rsForm.AFMdescripcion#        </td>
	    <td nowrap="nowrap">&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel"><strong>Modelo:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.AFMMcodigo# - #rsForm.AFMMdescripcion#        </td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Tipo:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.AFCcodigoclas# - #rsForm.AFCdescripcion#        </td>
	    <td nowrap="nowrap">&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel"><strong>Serie:&nbsp;</strong></td>
	    <td nowrap="nowrap">
			#rsForm.GATserie#        </td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Fecha Ini. Dep.:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#LSDateFormat(rsForm.GATfechainidep,'dd/mm/yyyy')#		</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><strong>Fecha Ini. Rev.:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#LSDateFormat(rsForm.GATfechainirev,'dd/mm/yyyy')#		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap="nowrap" class="fileLabel"><strong>Cuenta:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#rsForm.CFformato#		
		</td>
		<td nowrap="nowrap">&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><strong>Referencia:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#rsForm.GATReferencia#
		</td>		
	  </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel"><strong>Monto:&nbsp;</strong></td>
		<td nowrap="nowrap">
			#LSCurrencyFormat(rsForm.GATmonto,'none')#		</td>
		<td nowrap="nowrap">&nbsp;</td>
		<cfif rsForm.GATmonto lt 0>
		<td align="right" nowrap="nowrap" class="fileLabel"><div id="div_retiro_label"><strong>Motivo de Retiro:&nbsp;</strong></div></td>
		<td nowrap="nowrap">
			<cfset e = 0>
			<cfloop query="rsAFRmotivo">
				<cfif rsForm.AFRmotivo eq rsAFRmotivo.value><cfset e = 1>#rsAFRmotivo.description#</cfif>
			</cfloop>
			<cfif e eq 0>
				-
			</cfif>
		</td>
		<cfelse>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		</cfif>
	  </tr>
</table>
</cfoutput>
<table id="tablabotones2" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<form action="" method="post" name="form1">
<cf_botones names="Cerrar, Modificar" values="Cerrar, Modificar" functions="window.close();,window.opener.location.href='Transacciones.cfm?GATperiodo=#rsForm.GATperiodo#&GATmes=#rsForm.GATmes#&Cconcepto=#rsForm.Cconcepto#&Edocumento=#rsForm.Edocumento#&GATid=#rsForm.GATid#';window.close();">
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
