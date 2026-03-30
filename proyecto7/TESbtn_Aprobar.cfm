<cfset LvarBotones 			= "">
<cfset LvarBotonesValues	= "">

<cfif isdefined("rsForm.Multas")>
	<cfset LvarMultas = rsForm.Multas>
<cfelse>
	<cfset LvarMultas = 0>
</cfif>
<cfif modo NEQ 'ALTA'>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select ProcessInstanceId
	  from TESsolicitudPago
	 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESSPid#">
	   and EcodigoOri = #session.Ecodigo#
</cfquery>
<cfset LvarNoHayTramite = rsSQL.ProcessInstanceId EQ "">
</cfif>

<cfif modo NEQ "ALTA">
	<cfif isdefined("form.chkCancelados")>
		<cfset LvarBotones 			= LvarBotones 		& ",Imprimir">
		<cfset LvarBotonesValues	= LvarBotonesValues	& ",Imprimir">
		<cfset LvarBotones 			= LvarBotones 		& ",Duplicar">
		<cfset LvarBotonesValues	= LvarBotonesValues	& ",Duplicar">
		<cfset LvarExclude = "Cambio,Baja,Nuevo">
	<cfelse>

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

		<cfset LvarImprimirSP 	= true>
		<cfif isdefined("LvarEsAprobadorGE")>
			<cfset LvarVerAprobador = true>
		<cfelse>
			<cfset LvarEsAprobadorSP 	= false>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				Select count(1) as cantidad
				  from vUsuarioProcesos
				 where Ecodigo 		= #session.EcodigoSDC#
				   and Usucodigo	= #session.Usucodigo#
				   and SScodigo		= 'SIF'
				   and SMcodigo		= 'TES'
				   and SPcodigo		= 'TSP_099'
			</cfquery>
			<cfset LvarVerAprobador = (rsSQL.Cantidad NEQ 0)>
		</cfif>
		<cfif LvarVerAprobador>
			<cfif LvarCFid EQ "">
				<cfset LvarCFid = -1>
				<cfset LvarEsAprobadorSP = true>
				<cfset rsSPaprobador = structNew()>
				<cfset rsSPaprobador.TESUSPmontoMax = 0>
				<cfset rsSPaprobador.TESUSPcambiarTES = 0>
			<cfelse>
				<cfquery name="rsSPaprobador" datasource="#session.dsn#">
					Select TESUSPmontoMax, TESUSPcambiarTES
					  from TESusuarioSP
					 where CFid 		= #LvarCFid#
					   and Usucodigo	= #session.Usucodigo#
					   and TESUSPaprobador = 1
				</cfquery>

				<cfset LvarEsAprobadorSP = (rsSPaprobador.RecordCount GT 0)>
	
				<!--- Verifica monto maximo aprobar --->
				<cfif LvarEsAprobadorSP AND rsSPaprobador.TESUSPmontoMax NEQ 0>
					<cfquery name="TCsug" datasource="#Session.DSN#">
						select Mcodigo
						  from Empresas
						 where Ecodigo = #Session.Ecodigo#
					</cfquery>
					<cfif TCsug.Mcodigo EQ rsForm.McodigoOri>
						<cfset LvarTC = 1>
					<cfelseif isdefined("rsForm.TESSPtipoCambioOriManual") AND isnumeric(rsForm.TESSPtipoCambioOriManual)>
						<cfset LvarTC = rsForm.TESSPtipoCambioOriManual>
					<cfelse>
						<cfquery name="TCsug" datasource="#Session.DSN#">
							select tc.Hfecha, tc.TCcompra, tc.TCventa
							  from Htipocambio tc
							 where tc.Ecodigo = #Session.Ecodigo#
							   and tc.Mcodigo = #rsForm.McodigoOri#
							   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						</cfquery>
						
						<cfif TCsug.Hfecha EQ "" OR datediff("d",TCsug.Hfecha,now()) GT 30>
							<cfquery name="TCsug" datasource="#Session.DSN#">
								select Miso4217
								  from Monedas
								 where Ecodigo = #Session.Ecodigo#
								   and Mcodigo = #rsForm.McodigoOri#
							</cfquery>
							<cfset LvarError = "El documento esta en moneda '#TCsug.Miso4217#' y no hay tipo de cambio histórico para los últimos 30 días">
							<cfset LvarEsAprobadorSP = false>
							<cfset LvarTC = -1>
						<cfelse>
							<cfset LvarTC = TCsug.TCcompra>
						</cfif>
					</cfif>
					<cfif LvarEsAprobadorSP AND rsSPaprobador.TESUSPmontoMax LT rsForm.TESSPtotalPagarOri*LvarTC>
						<cfset LvarError = "El Total de Pago Solicitado es mayor al Monto Máximo autorizado de Aprobación">
						<cfset LvarEsAprobadorSP = false>
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfset LvarGenerarOP = false>
		<cfset LvarGenerarOPenTESorigen = false>
		<cfif LvarEsAprobadorSP>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				Select count(1) as cantidad
				  from vUsuarioProcesos
				 where Ecodigo 		= #session.EcodigoSDC#
				   and Usucodigo	= #session.Usucodigo#
				   and SScodigo		= 'SIF'
				   and SMcodigo		= 'TES'
				   and SPcodigo		= 'TOP_001'
			</cfquery>

			<cfif rsSQL.Cantidad GT 0>
				<cfquery name="rsTESusuarioOP" datasource="#session.dsn#">
					Select count(1) as cantidad
					  from TESusuarioOP
					 where TESid 		= #LvarTESid#
					   and Usucodigo	= #session.Usucodigo#
					   and TESUOPpreparador = 1
				</cfquery>

				<cfquery name="rsSQL" datasource="#session.dsn#">
					Select EcodigoAdm
					  from Tesoreria
					 where TESid 		= #LvarTESid#
				</cfquery>

				<cfset LvarGenerarOP = (rsTESusuarioOP.Cantidad GT 0 AND rsSQL.EcodigoAdm EQ session.Ecodigo)>
				<cfset LvarGenerarOPenTESorigen = LvarGenerarOP>

				<cfif isdefined("LvarAprobar") AND LvarEsAprobadorSP AND rsSPaprobador.TESUSPcambiarTES EQ "1">
					<cfset LvarGenerarOP = true>
				<cfelse>
				</cfif>
			</cfif>
		</cfif>

		<cfif LvarImprimirSP>
			<cfif isdefined("LvarAprobar") and NOT isdefined('form.tipo')>
				<cfset LvarBotones 			= LvarBotones 		& ",Imprimir">
				<cfset LvarBotonesValues	= LvarBotonesValues	& ",Imprimir">
			<cfelseif NOT isdefined('form.tipo')>
				<cfset LvarBotones 			= LvarBotones 		& ",Imprimir">
				<cfset LvarBotonesValues	= LvarBotonesValues	& ",Impresión Preliminar">
			</cfif>
		</cfif>
		<cfif NOT isdefined("LvarAprobar")>
			<cfset LvarBotones 			= LvarBotones 		& ",AAprobar">
			<cfset LvarBotonesValues	= LvarBotonesValues	& ",Enviar a Aprobar">
		</cfif>
		
		<cfif LvarEsAprobadorSP and LvarNoHayTramite>

			<cfif isdefined("LvarAprobar")>
                <link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
                <table align="center">
                    <tr>
                        <td><a class="btnAprobar" onclick="javascript:  document.getElementById('botonSel').value = 'Aprobar'; if (window.funcAprobar) return funcAprobar();" /></td>
                        <td><a class="btnRechazar" onclick="javascript:  document.getElementById('botonSel').value = 'Rechazar'; if (window.funcRechazar) return funcRechazar();" /></td>
                    </tr>
                </table>
            <cfelse>
                <link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
                <table align="center">
                    <tr>
                        <td><a class="btnAprobar" onclick="javascript: this.form.botonSel.value = Aprobar; if (window.funcAprobar) return funcAprobar();" /></td>
                    </tr>
                </table>
			</cfif>
		</cfif>
		
	<!---  Se quita por el momento la opcion de generar un orden de pago.
		<cfif LvarGenerarOP>
			<cfif NOT isdefined('form.tipo') and LvarNoHayTramite>	
				<cfset LvarBotones 			= LvarBotones 		& ",GenerarOP">
				<cfset LvarBotonesValues	= LvarBotonesValues	& ",Generar Orden Pago">
			</cfif>
		</cfif>--->
	</cfif>
</cfif>

<cfparam name="LvarExclude" default="">
<cfparam name="LvarInclude" default="">
<cfset LvarInclude = "#LvarInclude#,IrLista">
<cfparam name="LvarIncludeValues" default="">
<cfset LvarIncludeValues = "#LvarIncludeValues#,Lista Solicitudes">

<!---<cf_botones modo='#modo#' tabindex="1" 
	include="#LvarInclude#" 
	includevalues="#LvarIncludeValues#"
	exclude="#LvarExclude#"
	>--->
<cf_botones modo='#modo#' tabindex="1" 
	include="#LvarBotones#" 
	includevalues="#LvarBotonesValues#"
	exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
	>
<cfif not isdefined("form.chkCancelados") and isdefined ('form.tipo')>
	<cfif form.tipo EQ 'ANTCIPO'>
		<cfset LvarTipo='Anticipo'>
	<cfelse>
		<cfset LvarTipo='Liquidacion'>
	</cfif>
	<table>
		<tr>
			<td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
				<cf_navegacion name="chkImprimir" session default="1">
				<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"
						style="background-color:inherit;"
						<cfif form.chkImprimir NEQ "0">
						checked
						</cfif>
				/>
				<label for="chkImprimir" title="Imprime del envio a los procesos de Aprobación">
				<cfoutput>Imprimir #LvarTipo# enviada</cfoutput>
				</label>
			</td>
		</tr>
	</table>
</cfif>
<cfif not isdefined("form.chkCancelados") and not isdefined ('form.tipo')>
	<table>
		<tr>
			<td style="background-color: #D4D0C8; border:outset 2px #FFFFFF;">
				<cf_navegacion name="chkImprimir" session default="1">
				<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"
						style="background-color:inherit;"
						<cfif form.chkImprimir NEQ "0">
						checked
						</cfif>
				/>
				<label for="chkImprimir" title="Imprime la Solicitud de Pago después de enviarla a los procesos de Aprobación o Emisión">
				Imprimir Solicitud enviada
				</label>
			</td>
		</tr>
	</table>
</cfif>
<cfoutput>
<cfif isdefined("LvarError")>
	<br>
	<font color="##CC0000"><strong>No se puede Aprobar:</strong> #LvarError#</font>
	<br>
</cfif>

<script language="javascript">
<cfif modo NEQ "ALTA">
	<cfquery name="rsNoCedido" datasource="#session.dsn#">
		select sum(TESDPmontoSolicitadoOri) as Total
		  from TESdetallePago
		 where TESSPid = #rsForm.TESSPid#
		   and (CPCid is null OR TESDPmontoSolicitadoOri < 0)
	</cfquery>
	<cfif isdefined("LvarAprobar") AND LvarEsAprobadorSP AND rsSPaprobador.TESUSPcambiarTES EQ "1" and not isdefined ('form.tipo')>
		<cfquery name="rsTesorerias" datasource="#session.dsn#">
			Select 	t.TESid, 
					{fn concat({fn concat(t.TEScodigo, ' - ')}, t.TESdescripcion)} as TESdescripcion, 
					e.Edescripcion, t.EcodigoAdm, TESUOPpreparador as esPreparador
			  from Tesoreria t
				inner join Empresas e
					on e.Ecodigo = t.EcodigoAdm
			  	left join TESusuarioOP u
				  on u.TESid		= t.TESid
				 and u.Usucodigo	= #session.Usucodigo#
				 and TESUOPpreparador = 1
			 where t.CEcodigo	= #session.CEcodigo#
		</cfquery>
		// El Usuario Aprobador tiene autorización de cambiar la Tesorería destino para el Centro Funcional
		var LvarTESidPago = document.getElementById("cboCambioTESid");
		<cfset LvarIdx = 1>
		<cfloop query="rsTesorerias">
		<cfif rsForm.TESid NEQ rsTesorerias.TESid>
		LvarTESidPago.options[#LvarIdx#] = new Option('#rsTesorerias.TESdescripcion# (Adm: #rsTesorerias.Edescripcion#)','#rsTesorerias.TESid#');
		<cfset LvarIdx = LvarIdx + 1>
		</cfif>
		</cfloop>
<!---LO dejo asi mientras se define que realizar
			var Lvar_btnGenerarOP = document.form1.GenerarOP;
			Lvar_btnGenerarOP.disabled = <cfif LvarGenerarOPenTESorigen>false<cfelse>true</cfif>;
--->
		function sb_cboCambioTESid_OnChange()
		{
		<cfif LvarGenerarOP>
			if (LvarTESidPago.value == "") Lvar_btnGenerarOP.disabled = <cfif LvarGenerarOPenTESorigen>false<cfelse>true</cfif>;
			<cfloop query="rsTesorerias">
			else if (LvarTESidPago.value == "#rsTesorerias.TESid#") Lvar_btnGenerarOP.disabled = <cfif rsTesorerias.esPreparador EQ "1" AND rsTesorerias.EcodigoAdm EQ #session.Ecodigo#>false<cfelse>true</cfif>;
			</cfloop>
		</cfif>
			return;
		}
		function funcGenerarOP()
		{
		<cfif LvarGenerarOP>
			if (LvarTESidPago.value == "")
			{
			<cfif LvarGenerarOPenTESorigen>
				// Si puede generar OP
			<cfelse>
				alert('El usuario no tiene permisos de Generar Órdenes de Pago en la Tesorería Destino');
				return false;
			</cfif>
			}
			<cfloop query="rsTesorerias">
				<cfif rsTesorerias.esPreparador NEQ "1">
			else if (LvarTESidPago.value == "#rsTesorerias.TESid#")
			{
				alert('El usuario no tiene permisos de Generar Órdenes de Pago en la Tesorería Destino');
				return false;
			}
				<cfelseif rsTesorerias.EcodigoAdm NEQ #session.Ecodigo#>
			else if (LvarTESidPago.value == "#rsTesorerias.TESid#")
			{
				alert('La Tesorería Destino pertenece a otra Empresa Administradora');
				return false;
			}
				</cfif>
			</cfloop>
		</cfif>
		<cfif rsForm.TESSPtotalPagarOri EQ 0>
			alert ('No se puede generar una Orden de Pago con Pago 0');
			return false;
		<cfelse>
			if (fnAplicar_TESOPFP) 
			  if (!fnAplicar_TESOPFP()) return false;
			if (fnVerificaMonto())
				return confirm('¿Desea APROBAR la Solicitud de Pago ## #rsform.TESSPnumero#, y GENERAR una Orden de Pago particular para la Solicitud?');
			else
				return false;
		</cfif>
		}
	<cfelse>
		function sb_cboCambioTESid_OnChange()
		{
			return;
		}
		function funcGenerarOP()
		{
		<cfif rsForm.TESSPtotalPagarOri EQ 0>
			alert ('No se puede generar una Orden de Pago con Pago 0');
			return false;
		<cfelse>
			if (fnVerificaMonto())
				return confirm('¿Desea APROBAR la Solicitud de Pago ## #rsform.TESSPnumero#, y GENERAR una Orden de Pago particular para la Solicitud?');
			else
				return false;
		</cfif>
		}
	</cfif>

	
	function funcImprimir()
	{
	<cfif rsForm.TESSPtotalPagarOri EQ 0 AND LvarMultas EQ 0>
		alert("ERROR: No se puede Imprimir una Solicitud vacía");
		return false;
	</cfif>
<cfif not isdefined ('form.tipo') and isdefined ('form.TESSPid')>
	  var url = '/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/Solicitudes/imprSolicitPago_form.cfm")#&imprime=1&TESSPid=#form.TESSPid#';
</cfif>
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
		var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
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
		if (fnAplicar_TESOPFP) 
		  if (!fnAplicar_TESOPFP()) return false;
		if (fnVerificaMonto())
			return confirm('¿Desea ENVIAR AL PROCESO DE APROBACIÓN la Solicitud de Pago ## #rsform.TESSPnumero#?');
		else
			return false;
	}	

	function funcAprobar()
	{
		if (fnAplicar_TESOPFP) 
		  if (!fnAplicar_TESOPFP()) return false;
	<cfif isdefined("LvarError")>
		alert("#LvarError#");
		return false;
	<cfelse>
		if (fnVerificaMonto())
			<cfif rsForm.TESSPtotalPagarOri EQ 0 AND LvarMultas GT 0>
				return confirm('¿Desea APROBAR Y APLICAR la Solicitud de Pago ## #rsform.TESSPnumero# SIN PROCESO DE PAGO?');
			<cfelseif not isdefined ('form.tipo')>
				return confirm('¿Desea APROBAR la Solicitud de Pago ## #rsform.TESSPnumero#?');
			<cfelse>
				return confirm('¿Desea APROBAR la Transaccion ## #rsform.TESSPnumero#?');
			</cfif>
		else
			return false;
	</cfif>
	}	

	function fnVerificaMonto()
	{
	<cfif rsForm.TESSPtotalPagarOri LT 0>
		alert("ERROR: La suma de Débitos debe ser mayor que la de Créditos");
		return false;
	<cfelseif rsNoCedido.Total LT 0>
		alert("ERROR: La suma de Débitos debe ser mayor que la de Créditos en Montos no cedidos: #rsNoCedido.Total#");
		return false;
	<cfelseif rsForm.TESSPtotalPagarOri EQ 0 AND LvarMultas EQ 0>
		alert("ERROR: No se puede Aprobar una Solicitud vacía");
		return false;
	<cfelse>
		return true;
	</cfif>
	}
</cfif>

	function funcIrLista()
	{
		<cfif not isdefined ('form.tipo')>
			location.href='#Session.Tesoreria.solicitudesCFM#';
			return false;
		<cfelse>
			location.href='#LvarHomePage#';
			return false;
		</cfif>
	}
</script>
</cfoutput>