<cfif isdefined("LvarAprobar")>
	<cfif session.Tesoreria.CFid_subordinados EQ 0>
		<cfset LvarCFid		= rsForm.CFid>
	<cfelse>
		<cfset LvarCFid		= session.Tesoreria.CFid_padre>			
	</cfif>
	<cfset LvarTESid	= rsForm.TESid>
<cfelse>
	<cfset LvarCFid		= session.Tesoreria.CFid>
	<cfset LvarTESid	= session.Tesoreria.TESid>
</cfif>
<cfquery name="rsSPaprobador" datasource="#session.dsn#">
	Select TESUSPmontoMax, TESUSPcambiarTES
	from TESusuarioSP
	where CFid 		= #LvarCFid#
	and Usucodigo	= #session.Usucodigo#
	and TESUSPaprobador = 1
</cfquery>
<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>

<cfset btnNameAbajo="">
<cfset btnValueAbajo= "">
<cfset btnNameArriba = "">
<cfset btnValuesArriba= "">
<cfset rechazada=false>
<cfset btnExcluirArriba="">
<cfparam name="LvarSAporComision" default="false">


<cfif LvarSAporComision>
	<cfset btnExcluirArriba 			= "Nuevo,">
	<cfif modo EQ "CAMBIO">
		<cfset btnValuesArriba			= "Nueva Solcitud,">
		<cfset btnNameArriba			= "NuevaSA,">
	</cfif>
	<cfif modoC EQ "CAMBIO">
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			select count(1) as cantidad
			  from GEanticipo
			 where GECid = #form.GECid_comision#
			   and GEAestado <> 3
		</cfquery>
		<cfquery name="rsSQL2" datasource="#session.dsn#">
			select count(1) as cantidad
			  from GEliquidacion
			 where GECid = #form.GECid_comision#
			   and GELestado <> 3
		</cfquery>
		<cfif rsSQL1.cantidad + rsSQL2.cantidad EQ 0>
			<cfset btnValueAbajo			= "Cambio Comisión,Cancelar Comisión,Nueva Comisión,Imprimir, Finalizar Comisión">
			<cfset btnNameAbajo 			= "CambioC,CancelarC,Nuevo,ImprimirC,FinalizarC">
		<cfelse>
			<cfset btnValueAbajo			= "Cambio Comisión,Nueva Comisión,Imprimir,Finalizar Comisión">
			<cfset btnNameAbajo 			= "CambioC,Nuevo,ImprimirC,FinalizarC">
		</cfif>
	<cfelse>
		<cfset btnValueAbajo			= "Agregar Comisión,">
		<cfset btnNameAbajo 			= "AltaC,">
	</cfif>
</cfif>
<cfif modo EQ "CAMBIO">
	<!--- Temporalmente no se puede aprobar COMISION en la pantalla de solicitud aunque sea aprobador --->
	<cfif LvarEsAprobadorSP AND NOT LvarSAporComision>
		<cfset btnNameAbajo			    = btnNameAbajo&",Aprobar">
		<cfset btnValueAbajo	    	= btnValueAbajo	& ",Aprobar">
	<cfelse>
		<cfset btnNameAbajo				= btnNameAbajo&",AAprobar">
		<cfset btnValueAbajo			= btnValueAbajo&",Enviar a Aprobar">
	</cfif>	
	<cfif LvarSAporComision>
		<cfset btnNameAbajo			    = btnNameAbajo&"C">
		<cfset btnValueAbajo	    	= btnValueAbajo	& " Comisión">
	</cfif>
	<cfif isdefined ('form.estado')>
		<cfif estado EQ "Rechazada">
			<cfset rechazada=true>
			<cfset btnNameAbajo				= btnNameAbajo&",Duplicar">
			<cfset btnExcluirArriba			=btnExcluirAbajo>
		</cfif>
	</cfif>
</cfif>

<cfset btnNameArriba 			= btnNameArriba & "IrLista">
<cfset btnValuesArriba			= btnValuesArriba &"Regresar">
<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar">	

<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#">
<cf_botones modo="#modo#" includevalues="#btnValueAbajo#" 	include="#btnNameAbajo#"  exclude="#btnExcluirAbajo#">

<cfif NOT #rechazada#>
		<table><tr><td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
			<cf_navegacion name="chkImprimir" session default="1">
			<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"style="background-color:inherit;"
				<cfif form.chkImprimir NEQ "0">checked</cfif>/>
				<label for="chkImprimir" title="Imprime la Solicitud de Pago despues de enviarla a los procesos de Aprobacion o Emisión">
					<cf_translate key=LB_ImprimirSolicitudEnviada>Imprimir Solicitud enviada</cf_translate>
				</label>
				
		</td></tr></table>
    
</cfif>
<cfoutput>
	 <script language="javascript">
			<cfif modo NEQ "ALTA">
					function funcImprimir()
					{
							<cfif rsForm.GEAtotalOri EQ 0>
									alert("ERROR: No se puede Imprimir una Solicitud con Total Pago Solicitado vacío");
									return false;
							</cfif>
							<!---<cfif isdefined ("rsForm.DEid")>								
								alert("debe de completar");								
						</cfif>	--->	
var url ='/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/imprSolicAnticipo_form.cfm")#  &imprime=1&GEAid=#form.GEAid#';		                               <!---'/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/cfmx/sif/tesoreria/GestionEmpleados/imprSolicAnticipo_form.cfm")#&imprime=1&GEAid=#form.GEAid#';--->
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
					{			<cfif not isdefined ("rsForm.DEid")>								
								alert("No se puede imprimir una solicitud que no se ha ingresado");								
							}	
	</cfif>
	
		</cfif>
				</script>
	</cfoutput>

