<cfset btnNameAbajo="">
<cfset btnValueAbajo= "">
<cfset btnNameArriba = "">
<cfset btnValuesArriba= "">
<cfset rechazada=false>
<!---<cfset btnExcluirArriba="">--->


<cfset btnNameAbajo 			= btnNameAbajo & "IrLista">
<cfset btnValueAbajo			= btnValueAbajo &"Lista Solicitudes">
<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	
<cfif modo EQ "CAMBIO">
	<cfset btnNameAbajo		= btnNameAbajo&",Imprimir">
	<cfset btnValueAbajo	= btnValueAbajo&",Impresión Preliminar">
	<cfset btnNameAbajo		= btnNameAbajo&",Aprobar">
	<cfset btnValueAbajo	= btnValueAbajo&",Enviar a Aprobar">	
		
	<cfset btnNameAbajo		= btnNameAbajo&",Rechazar">
	<cfset btnValueAbajo	= btnValueAbajo&",Rechazar">	
		
	<cfif isdefined("LvarAprobar")>
		<cfset btnNameAbajo 	= btnNameAbajo 	& ",Rechazar">
		<cfset btnValueAbajo	= btnValueAbajo	& ",Rechazar">
	</cfif>
			
	<cfif isdefined ('form.estado')>
		<cfif estado EQ "Rechazada">
			<cfset rechazada=true>
			<cfset btnNameAbajo		= btnNameAbajo&",Duplicar">
			<cfset btnValueAbajo	= btnValueAbajo&",Duplicar">
			<cfset btnExcluirArriba	= btnExcluirAbajo>
		<cfelse>
				
		</cfif>
	</cfif>
</cfif>

<!---<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#">
---><cf_botones modo="#modo#" includevalues="#btnValueAbajo#" 	include="#btnNameAbajo#"  exclude="#btnExcluirAbajo#">

<cfif NOT #rechazada#>
		<table align="center">
		  <tr><td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
			<cf_navegacion name="chkImprimir" session default="1">
			<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"style="background-color:inherit;"
				<cfif form.chkImprimir NEQ "0">checked</cfif>/>
				<label for="chkImprimir" title="Imprime la Solicitud de Pago despues de enviarla a los procesos de Aprobacion o Emisión">
					Imprimir Solicitud enviada
				</label>
				
  </td></tr></table>
    
</cfif>
<cfoutput>

	 <script language="javascript">
	 
			<cfif modo NEQ "ALTA">
			
					function funcImprimir()
					{
							<!---<cfif Form.GEAtotalOri EQ 0>
									alert("ERROR: No se puede Imprimir una Solicitud con Total Pago Solicitado vacío");
									return false;
							</cfif>--->
							<!---<cfif isdefined ("rsForm.DEid")>								
								alert("debe de completar");								
						</cfif>	--->	
var url =
'/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/prueba_imp.cfm")#  &imprime=1&GELid=#form.GELid#';	
							  if (window.print && window.frames && window.frames.printerIframe) {
									var html = '';
									html += '<html>';
									html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
									html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
									html += '<\/body><\/html>';
							
									var ifd = window.frames.printerIframe.document;
									ifd.open();
									ifd.write(html);
									ifd.close();
	 							 }
							  else
								  {
										var win = window.open('', 'printerWindow','width=600,height=300,resizable,scrollbars,toolbar,menubar');
										var html = '';
										html += '<html>';
										html += '<frameset rows="100%, *" ' 
											 +  'onload="opener.printFrame(window.urlToPrint);window.close();">';
										html += '<frame name="urlToPrint" src="' + url + '" \/>';
										html += '<frame src="about:blank" \/>';
										html += '<\/frameset><\/html>';
										win.document.open();
										win.document.write(html);
										win.document.close();
	  								}
	 						 return false;
								}	

	function printFrame (frame) 
	{
	  if (frame.print) 
	  {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}
	<cfelse>
				function funcImprimir()
					{			<cfif not isdefined ("Form.DEid")>								
								alert("No se puede imprimir una solicitud que no se ha ingresado");								
							}	
	</cfif>
	
		</cfif>
				</script>
	</cfoutput>


