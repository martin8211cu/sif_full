<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 16 de setiembre del 2005
	Motivo: agregar dos parametros mas al url para la impresion de la factura, idioma y firmaAutizada, 
			estos datos se toman de la pantalla de captura Datos para Impresion de Facturas.
	Linea: 27
	
	Modificado por: Ana Villavicencio
	Fecha:  30 de Setiembre del 2005
	Motivo: agregar un nuevo parametro por url a la llamada del pop up de impresion de factura.
 --->
		<cfif isdefined("url.imprimir") and url.imprimir and isdefined("url.Dreferencia") and len(trim(url.Dreferencia)) >
			<script language="javascript1.2" type="text/javascript">
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				<cfoutput>
					function imprime() {
						var params ="";
						popUpWindow("/cfmx/sif/iv/operacion/imprimeFactura.cfm?Dreferencia=#url.Dreferencia#&Idioma=#url.Idioma#&firmaAutorizada=#url.firmaAutorizada#&CCtipo=#url.CCtipo#",250,200,650,400);
					}
					imprime();
				</cfoutput>
			</script>
		</cfif>	
<cf_templateheader title=" Impresi&oacute;n de Facturas">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Impresi&oacute;n de Facturas'>
		<script language="JavaScript" src="../../js/utilesMonto.js"></script>					
		<cfinclude template="impresionFacturas-form.cfm">	
	<cf_web_portlet_end>
<cf_templatefooter>