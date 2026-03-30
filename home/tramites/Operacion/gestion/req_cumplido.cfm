<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 09 de Agosto del 2005
	Motivo: Terminar el proceso de diseño de la forma q muestra los datos de un requisito cumplido.
 --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Sucursal</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">
<cfif isdefined('url.identificacion_persona') and not isdefined('urlid_persona')>
	<cfset url.id_persona = url.identificacion_persona>
</cfif>
<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	returnvariable="instancia" />


<cfquery datasource="#session.tramites.dsn#" name="RSTramite">
	select codigo_tramite, nombre_tramite  from  TPTramite
	where id_tramite   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">                
</cfquery>


<cfquery datasource="#session.tramites.dsn#" name="total_header">
	select costo_requisito as saldo,costo_requisito as importe,moneda,nombre_requisito  from  TPRequisito
	where id_requisito   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">                
</cfquery>


<cfset param = 'id_tramite='& #url.id_tramite# & '&id_persona='& #url.id_persona# & '&id_requisito=' & #url.id_requisito#  & '&id_tipoident=' & #url.id_tipoident#>
<table border="0" align="center" width="510" cellpadding="0" cellspacing="0">
		<cfif not isdefined('imprimir')>
		<tr><td align="right" colspan="2">
<!--- 		<cf_rhimprime datos="/home/tramites/Operacion/gestion/req_cumplido.cfm" paramsuri="&#param#"></td></tr> --->
		
		</cfif>
	<tr>
		<td colspan="2">
			<table border="0" align="center" width="510" cellspacing="0" cellpadding="0">
				<cfoutput>
				<tr >
					<td bgcolor="##ECE9D8" style="font-size:20px; padding:3px; border-bottom:1px solid black; border-top:1px solid black; " width="447"><strong>#RSTramite.nombre_tramite#</strong></td>
					<td width="1%" bgcolor="##ECE9D8" style="font-size:20px; padding:3px; border-bottom:1px solid black; border-top:1px solid black; " >
					<a href="javascript:imprimir();" id="imp">
								<img src="../../images/impresora.gif" border="0" alt="Imprimir">
							</a></td>
					<td width="1%" bgcolor="##ECE9D8"  style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; " align="right">
							
							<a href="javascript:infoTramite(#id_tramite#)">
					<img alt="Ver Detalle del Tramite #trim(RSTramite.codigo_tramite)# - #RSTramite.nombre_tramite#" 
						src="/cfmx/home/tramites/images/info.gif" border="0"></a>
					</td> 
				</tr>
				<tr>
					<td colspan="2" bgcolor="##ECE9D8" style="font-size:18px; padding:3px; "><strong>#total_header.nombre_requisito#</strong></td>
					<td bgcolor="##ECE9D8"  width="43" align="right">
						<a href="javascript:infoRequisito(#id_requisito#,#id_tramite#)">
						<img style="cursor:hand;" alt="Ver Detalle del Requisito #trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#" 
							src="/cfmx/home/tramites/images/info.gif" border="0"></a>
					</td>
				</tr>
				<tr>
				  <td colspan="3"><cfinclude template="hdr_persona.cfm"></td>
				</tr></cfoutput>
			</table>
		</td>
	</tr>
	<tr>
	  <td valign="top"><cfinclude template="hdr_tramite.cfm"></td>
	  <td valign="top"><cfinclude template="hdr_requisito.cfm"></td>
	</tr>
	<tr>
	  <td colspan="2">&nbsp;</td>
	</tr>
	<tr>
	  <td colspan="2"><cfinclude template="detalleTramitecumplido.cfm"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td align="center" colspan="2" id="botones">
				<input type="button"  onClick="javascript:Regresar();" value="Regresar" class="boton">		
		</td>
	</tr>
</table>
</body>
</html>

<script language="javascript1.2" type="text/javascript">
	function Regresar(){
		<cfif isdefined('url.misreq')>
			var misreq = true;
		<cfelse>
			var misreq = false;
		</cfif>
		if (misreq){
			location.href = 'TramiteEnProceso.cfm?id_tramite=<cfoutput>#url.id_tramite#</cfoutput>&id_persona=<cfoutput>#id_persona#</cfoutput><cfif isdefined('url.id_tipoident')>&id_tipoident=<cfoutput>#url.id_tipoident#</cfoutput></cfif>'
		}else{
			location.href = 'gestion-form.cfm?loc=gestion&id_tramite=<cfoutput>#url.id_tramite#</cfoutput>&identificacion_persona=<cfoutput>#id_persona#</cfoutput><cfif isdefined('url.id_tipoident')>&id_tipoident=<cfoutput>#url.id_tipoident#</cfoutput></cfif>&id_requisito=<cfoutput>#url.id_requisito#</cfoutput>'
		}
	}
	function imprimir() {
		var botones = document.getElementById("botones");
		var imp = document.getElementById("imp");
		imp.style.display = 'none';
        botones.style.display = 'none';
		window.print()	
        botones.style.display = ''
		imp.style.display = ''
	}	
	function infoTramite(tramite) {
			var params ="";
			params = "?id_tramite="+tramite;
			popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoTramite.cfm"+params,250,200,650,400);
		}
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function infoRequisito(requisito,tramite) {
		var params ="";
		params = "?id_requisito="+requisito;
		params += "&id_tramite="+tramite;
		popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,250,200,650,400);
	}				
</script>