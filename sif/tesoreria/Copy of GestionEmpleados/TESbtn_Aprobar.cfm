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
	
	<!---cfset btnNameAbajo				= btnNameAbajo&",Imprimir">
	<cfset btnValueAbajo			= btnValueAbajo&",Impresión Preliminar">--->

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
					Imprimir Solicitud enviada
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
	function funcAAprobar()
	{	
		if (fnVerificaMonto())
			return confirm('¿Desea ENVIAR AL PROCESO DE APROBACIÓN la Liquidación ## #rsform.GELnumero#?');
			
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
		<cfif rsForm.GELtotalAnticipos neq rsForm.GELtotalDevoluciones or rsForm.GELtotalAnticipos eq 0>
			<cfif rsTotalReal.total gt rsForm.GELtotalGastos>
				alert("El monto total del gasto de viaticos es mayor al detalle de facturas \n Total de viaticos: "+#rsTotalReal.total#+"  y Total de facturas: "+#rsForm.GELtotalGastos# +"");
				return false;
			</cfif>
		</cfif>
		<cfif rsForm.GELtotalGastos EQ 0 and rsForm.GELtotalAnticipos EQ 0 and rsForm.GELtotalDepositos EQ 0>
			alert("ERROR: No se puede Aprobar una Liquidación vacía");
			return false;
		<cfelseif rsForm.GELreembolso EQ 0>
			<cfif rsForm.GELtipoP EQ 1>
				<cfif rsForm.GELtotalAnticipos - (rsForm.GELtotalGastos + rsForm.GELtotalDepositos) GT 0>
					alert("ERROR: Faltan Gastos o Depositos por ingresar");
					return false;
				<cfelse>
					return true;
				</cfif>
			<cfelse>
				<cfif rsForm.GELtotalAnticipos - (rsForm.GELtotalGastos + rsForm.GELtotalDevoluciones) GT 0>
					alert("ERROR: Faltan Gastos o Devoluciones por ingresar");
					return false;
				<cfelse>
					return true;
				</cfif>
			</cfif>
		<cfelseif rsForm.GELreembolso gte 0>
			return true;
		<cfelse>
			return true;
		</cfif>
	}
</cfif>

</script>
</cfoutput>
