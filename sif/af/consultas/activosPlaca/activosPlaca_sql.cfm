<!---Se excluyeron los frames:
Activos_frameRevDevaluacion.cfm y Activos_frameTrasDepreciacion.cfm
Se cambio el orden de las listas --->
<cffunction name="getMesDescription">
	<cfargument name="v" required="yes">
	<cfquery name="m" datasource="#session.dsn#">
		select VSdesc as m
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSgrupo = 1
			and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#v#">
		where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	</cfquery>
	<cfreturn m.m>
</cffunction>

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
	.tituloListas {
		font-size:12px;
		font-weight:bold;}
</style>
<!---*******************************************
*******Pinta los botones de regresar, imprimir**
*******y guardar en excel/word******************
********************************************--->

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
<cfif not isdefined('varURL')>
	<cfoutput>
	<tr> 
		<td align="right" nowrap>
<!---		<cfif not isdefined ('url.Aid')>
--->			<a href="javascript:regresar();" tabindex="-1">
				<img src="/cfmx/sif/imagenes/back.gif"
				alt="Regresar"
				name="regresar"
				border="0" align="absmiddle">
			</a>		
		<!---</cfif>	--->	
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
	</cfif>
</table>

<!---*******************************************
*******Arma el Reporte*************************
********************************************--->
<cfsavecontent variable="reporte">
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr><td>&nbsp;</td><td class="titulo_empresa">#Session.Enombre#</td><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td><td class="titulo_reporte">Consulta de Activo Fijo</td><td>&nbsp;</td></tr>
<cfif isdefined("form.Periodoini") and len(trim(form.Periodoini)) and form.Periodoini gt 0>
	<cfparam name="form.Mesini" default="1">
	<cfif form.Mesini eq 0><cfset form.Mesini = 1></cfif>
	<tr><td>&nbsp;</td><td class="titulo_reporte">Desde #getMesDescription(form.Mesini)# del #form.Periodoini#</td><td>&nbsp;</td></tr>
</cfif>
<cfif isdefined("form.Periodofin") and len(trim(form.Periodofin)) and form.Periodofin gt 0>
	<cfparam name="form.Mesfin" default="12">
	<cfif form.Mesfin eq 0><cfset form.Mesfin = 12></cfif>
	<tr><td>&nbsp;</td><td class="titulo_reporte">Hasta #getMesDescription(form.Mesfin)# del #form.Periodofin#</td><td>&nbsp;</td></tr>
</cfif>

  <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameInformacion.cfm"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameMejora.cfm"></td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameDepreciacion.cfm"></td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameRevaluacion.cfm"></td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameTraslados.cfm"></td>
    <td>&nbsp;</td>
  </tr>

    <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameCambioPlacas.cfm"></td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td>&nbsp;</td>
    <td><cfinclude template="/sif/af/catalogos/Activos_frameRetiro.cfm"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
			<tr>
			  <td align="center" height="17" nowrap="nowrap" width="100%"><strong>--Fin del Reporte--</strong></td>
			</tr>
			</tbody>
		</table>
	</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>
</cfsavecontent>
<!---*******************************************
*******Pinta el Reporte*************************
********************************************--->
<cfoutput>
<cfparam name="reporte" default="">
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
		document.location="activosPlaca.cfm";
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
