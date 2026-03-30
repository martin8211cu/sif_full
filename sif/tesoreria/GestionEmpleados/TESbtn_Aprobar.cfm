<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DeseaCerrarDefinitivamenteLaComision" default = "¿Desea CERRAR definitivamente la Comisión" returnvariable="MSG_DeseaCerrarDefinitivamenteLaComision" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_SinLiquidarAnticiposNiGastos" default = "sin liquidar Anticipos ni Gastos" returnvariable="MSG_SinLiquidarAnticiposNiGastos" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DeseaEnviarAlProcesoDeAprobacionLaLiquidacion" default = "¿Desea ENVIAR AL PROCESO DE APROBACIÓN la Liquidación" returnvariable="MSG_DeseaEnviarAlProcesoDeAprobacionLaLiquidacion" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ERRORNoSePuedeAprobarUnaLiquidacionVacia" default = "ERROR: No se puede Aprobar una Liquidación vacía" returnvariable="MSG_ERRORNoSePuedeAprobarUnaLiquidacionVacia" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ERRORFaltanGastosODepositosPorIngresar" default = "ERROR: Faltan Gastos o Depositos por ingresar" returnvariable="MSG_ERRORFaltanGastosODepositosPorIngresar" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ERRORFaltanGastosODevolucionesPorIngresar" default = "ERROR: Faltan Gastos o Devoluciones por ingresar" returnvariable="MSG_ERRORFaltanGastosODevolucionesPorIngresar" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ERRORLaLiquidacionNoEstaBalanceada" default = "ERROR: La liquidación no está balanceada" returnvariable="MSG_ERRORLaLiquidacionNoEstaBalanceada" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ElMontoTotalDelGastoDeViaticosEsMayorAlDetalleDeFacturas" default = "El monto total del gasto de viaticos es mayor al detalle de facturas y devoluciones" returnvariable="MSG_ElMontoTotalDelGastoDeViaticosEsMayorAlDetalleDeFacturas" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_TotalViaticos" default = "Total de viaticos" returnvariable="MSG_TotalViaticos" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_TotalFacturas" default = "Facturas" returnvariable="MSG_TotalFacturas" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_TotalDevolucion" default = "Devoluciones" returnvariable="MSG_TotalDevolucion" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DeLosCuales" default = "De los cuales" returnvariable="MSG_DeLosCuales" xmlfile = "TESbtn_Aprobar.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_Suma" default = "Suma" returnvariable="MSG_Suma" xmlfile = "TESbtn_Aprobar.xml">


<cfset btnNameAbajo="">
<cfset btnValueAbajo= "">
<cfset btnNameArriba = "">
<cfset btnNameAnticipos = "">
<cfset btnValuesArriba= "">
<cfset rechazada=false>
<cfset btnExcluirArriba="">


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

<cfif modo eq 'CAMBIO'>
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
		where CFid 		= (select CFid from GEliquidacion where GELid=#form.GELid#)
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
</cfif>

<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>

<cfif isdefined("LvarAprobar")>
		<cfset LvarImprimirSP 	= true>
</cfif>
<cfif modo NEQ "CAMBIO" AND NOT LvarSAporComision>
	<cfset btnNameArriba 			= btnNameArriba & "Anticipos">	
	<cfset btnValuesArriba			= btnValuesArriba &"Anticipos Empleado">
</cfif>

	<cfset btnNameArriba 			= btnNameArriba & ",IrLista" >
	<cfset btnValuesArriba			= btnValuesArriba &",Lista Liquidaciones">

	<cfset btnExcluirAbajo			="Cambio,Baja,Nuevo,Alta,Limpiar,Enviar a Aprobar">	


<cfif modo EQ "CAMBIO">
	

	<!---BOTON CERRAR--->
	<cfif LvarSAporComision and LvarVacia>
		<cfset btnNameAbajo		= btnNameAbajo&",CerrarVacia">
		<cfset btnValueAbajo	= btnValueAbajo&",Cerrar">
	</cfif>
	
	<!---FIN BOTON CERRAR--->

	<cfif isdefined ('form.estado') and len(trim(form.estado)) gt 0 and form.estado eq 'Rechazada'>
		<cfset rechazada=true>
		<cfset btnExcluirArriba	= btnExcluirAbajo>
	
		<cfif LvarEsAprobadorSP>
			<cfset btnNameAbajo		= btnNameAbajo&",Aprobar">
			<cfset btnValueAbajo	= btnValueAbajo&",Aprobar">
		<cfelse>
			<cfset btnNameAbajo		= btnNameAbajo&",AAprobar">
			<cfset btnValueAbajo	= btnValueAbajo&",Enviar a Aprobar">
		</cfif>
	<cfelse>
				<cfset btnNameAbajo		= btnNameAbajo&",AAprobar">
				<cfset btnValueAbajo	= btnValueAbajo&",Enviar a Aprobar">
			<cfif rsSPaprobador.recordcount gt 0>
				<cfset btnNameAbajo		= btnNameAbajo&",Aprobar">
				<cfset btnValueAbajo	= btnValueAbajo&",Aprobar">
			</cfif>		
		</cfif>
</cfif>

<cf_botones modo="#modo#" includevalues="#btnValuesArriba#" include="#btnNameArriba#" exclude="#btnExcluirArriba#">
<cf_botones modo="#modo#" includevalues="#btnValueAbajo#" 	include="#btnNameAbajo#"  exclude="#btnExcluirAbajo#">

<cfif NOT rechazada and modo neq "ALTA">
	<table>
		<tr>
			<td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
			<cf_navegacion name="chkImprimir" session default="1">
			<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"style="background-color:inherit;"
				<cfif form.chkImprimir NEQ "0">checked</cfif>/>
				<label for="chkImprimir" title="Imprime la Solicitud de Pago despus de enviarla a los procesos de Aprobacin o Emisión">
					<cf_translate key = BTN_ImprimirSolicitudEnviada xmlfile = "TESbtn_Aprobar.xml">Imprimir Solicitud enviada</cf_translate>
				</label>
			</td>
		</tr>
	</table>
    
</cfif>

<cfquery name="rsTotalReal" datasource="#session.dsn#">
	select sum (GELVmonto)as total 
		from GEliquidacionViaticos
		<cfif isdefined ('rsForm.GELid')>
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.GELid#">
		</cfif>
</cfquery>

<cfoutput>
<script language="javascript">

<cfif modo NEQ "ALTA">

		function funcImprimir()
		{
		<cfif rsForm.GELtotalGastos EQ 0 and rsForm.GELtotalDepositos EQ 0>
			alert("ERROR: No se puede Imprimir una Liquidación vacía");
			return false;
		</cfif>
		  var url ='/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/LiquidacionImpresion_form.cfm")#&Imprimir=1&GELid=#form.GELid#';
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
			var win = window.open('', 'printerWindow', 'width=500,height=500,resizable,scrollbars,toolbar,menubar');
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
	
	<!---FUNCIÓN BOTON CERRAR--->
		
		<cfif LvarSAporComision and LvarVacia>
			function funcCerrarVacia()
			{	
				return confirm('#MSG_DeseaCerrarDefinitivamenteLaComision# ## #rsGEcomision.GECnumero# #MSG_SinLiquidarAnticiposNiGastos#?');
			}	
		</cfif>
		
		<!---FIN FUNCIÓN BOTON CERRAR--->
		
	function funcAAprobar()
	{	
		if (fnVerificaMonto())
			return confirm('#MSG_DeseaEnviarAlProcesoDeAprobacionLaLiquidacion# ## #rsform.GELnumero#?');
			
		else
			return false;
	}	
	function funcAprobar()
	{	
		if (fnVerificaMonto())
			return true;			
		else
			return false;
	}	
	function fnVerificaMonto()
	{
		<cfif rsForm.GELtotalGastos EQ 0 and rsForm.GELtotalAnticipos EQ 0 and LvarDevoluciones EQ 0 and rsForm.GELtotalTCE EQ 0>
			alert("#MSG_ERRORNoSePuedeAprobarUnaLiquidacionVacia#");
			return false;
		<cfelseif LvarTotal LT -0.001>
			<cfif rsForm.GELtipoPago EQ 'TES'>
				alert("#MSG_ERRORFaltanGastosODepositosPorIngresar#: #numberFormat(-LvarTotal,",.99")#");
				return false;
			<cfelse>
				alert("#MSG_ERRORFaltanGastosODevolucionesPorIngresar#: #numberFormat(-LvarTotal,",.99")#");
				return false;
			</cfif>
		<cfelseif LvarTotal GT 0.001>
			alert("#MSG_ERRORLaLiquidacionNoEstaBalanceada#: #numberFormat(LvarTotal,",.99")#");
			return false;
		<cfelseif rsTotalReal.total GT (rsForm.GELtotalGastos + rsForm.MiDevolucion)>
			<!--- 
					sum (GELVmonto) as total se supone debe ser IGUAL a GELtotalGastos, 
					(es el total de viaticos real gastado)
					pero se convierte en mínimo porque puede haber facturas que corresponden 
					a gastos que no son viaticos 
			--->
			alert("#MSG_ElMontoTotalDelGastoDeViaticosEsMayorAlDetalleDeFacturas# \n #MSG_TotalViaticos# : "+#rsTotalReal.total#+" y #MSG_Suma#: "+#rsForm.MiDevolucion + rsForm.GELtotalGastos#+"\n #MSG_DeLosCuales#: \n #MSG_TotalFacturas#: "+#rsForm.GELtotalGastos#+" + #MSG_TotalDevolucion#: "+#rsForm.MiDevolucion#);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
</cfif>

</script>
</cfoutput>
