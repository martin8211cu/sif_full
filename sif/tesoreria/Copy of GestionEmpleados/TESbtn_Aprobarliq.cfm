
<cfset LvarBotones 			= "">
<cfset LvarBotonesValues	= "">

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
		<cfif rsSQL.Cantidad NEQ 0>
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
					<cfif TCsug.Mcodigo EQ rsForm.Mcodigo>
						<cfset LvarTC = 1>
					<cfelseif isdefined("rsForm.GELtipoCambio") AND isnumeric(rsForm.GELtipoCambio)>
						<cfset LvarTC = rsForm.GELtipoCambio>
					<cfelse>
						<cfquery name="TCsug" datasource="#Session.DSN#">
							select tc.Hfecha, tc.TCcompra, tc.TCventa
							  from Htipocambio tc
							 where tc.Ecodigo = #Session.Ecodigo#
							   and tc.Mcodigo = #rsForm.Mcodigo#
							   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						</cfquery>
						
						<cfif TCsug.Hfecha EQ "" OR datediff("d",TCsug.Hfecha,now()) GT 30>
							<cfquery name="TCsug" datasource="#Session.DSN#">
								select Miso4217
								  from Monedas
								 where Ecodigo = #Session.Ecodigo#
								   and Mcodigo = #rsForm.Mcodigo#
							</cfquery>
							<cfset LvarError = "El documento esta en moneda '#TCsug.Miso4217#' y no hay tipo de cambio histórico para los últimos 30 días">
							<cfset LvarEsAprobadorSP = false>
							<cfset LvarTC = -1>
						<cfelse>
							<cfset LvarTC = TCsug.TCcompra>
						</cfif>
					</cfif>
					<cfif LvarEsAprobadorSP AND rsSPaprobador.TESUSPmontoMax LT rsForm.GELtotalGastos*LvarTC>
						<cfset LvarError = "El Total de la Liquidación tiene un Monto Mayor al autorizado por Aprobar">
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
			<cfif isdefined("LvarAprobar") and not isdefined ('form.tipo')>
				<cfset LvarBotones 			= LvarBotones 		& ",Imprimir">
				<cfset LvarBotonesValues	= LvarBotonesValues	& ",Imprimir">
			<cfelseif  not isdefined ('form.tipo')>
				<cfset LvarBotones 			= LvarBotones 		& ",Imprimir">
				<cfset LvarBotonesValues	= LvarBotonesValues	& ",Impresión Preliminar">
			</cfif>
		</cfif>
		<cfif NOT isdefined("LvarAprobar")>
			<cfset LvarBotones 			= LvarBotones 		& ",Aprobar">
			<cfset LvarBotonesValues	= LvarBotonesValues	& ",Aprobar">
			<cfset LvarBotones 			= LvarBotones 		& ",Rechazar">
			<cfset LvarBotonesValues	= LvarBotonesValues	& ",Rechazar">
		</cfif>
	</cfif>
</cfif>

<cfparam name="LvarExclude" default="">
<cfparam name="LvarInclude" default="">
<cfset LvarInclude = "#LvarInclude#,irLista">
<cfparam name="LvarIncludeValues" default="">
<cfset LvarIncludeValues = "#LvarIncludeValues#,Lista Liquidaciones">

<cf_botones modo='#modo#' tabindex="1" 
	include="#LvarInclude#" 
	includevalues="#LvarIncludeValues#"
	exclude="#LvarExclude#,Cambio,Baja,Nuevo,Alta,Limpiar"
	>
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
	<table align="center" cols="4">
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
<cfoutput>
<cfif isdefined("LvarError")>
	<br>
	<font color="##CC0000"><strong>No se puede Aprobar:</strong> #LvarError#</font>
	<br>
</cfif>

<script language="javascript">
<cfif modo NEQ "ALTA">
	<cfif isdefined("LvarAprobar") AND LvarEsAprobadorSP AND rsSPaprobador.TESUSPcambiarTES EQ "1">
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
		var Lvar_btnGenerarOP = document.form1.GenerarOP;
		Lvar_btnGenerarOP.disabled = <cfif LvarGenerarOPenTESorigen>false<cfelse>true</cfif>;
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
			if (fnVerificaMonto())
				return confirm('¿Desea APROBAR la Solicitud de Pago ## #rsform.GELnumero#, y GENERAR una Orden de Pago particular para la Solicitud?');
			else
				return false;
		}
	<cfelse>
		function sb_cboCambioTESid_OnChange()
		{
			return;
		}
	<!---	function funcGenerarOP()
		{
			if (fnVerificaMonto())
				return confirm('¿Desea APROBAR la Solicitud de Pago ## #rsform.GELnumero#, y GENERAR una Orden de Pago particular para la Solicitud?');
			else
				return false;
		}--->
	</cfif>

	
	function funcImprimir()
	{
	<!---<cfif rsForm.GELtotalGastos EQ 0>
		alert("ERROR: No se puede Imprimir una Solicitud vacía");
		return false;
	</cfif>
	  var url = '/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/GestionEmpleados/LiquidacionImpresion_form.cfm")#&imprime=1&GELid=#form.GELid#';
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
	  return false;--->
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
			return confirm('¿Desea ENVIAR AL PROCESO DE APROBACIÓN la Liquidación ## #encaliqui.GELnumero#?');
		else
			return false;
	}	
	function fnVerificaMonto()
	{
		<cfif encaliqui.GELtotalGastos EQ 0 and encaliqui.GELtotalAnticipos EQ 0 and encaliqui.GELtotalDepositos EQ 0>
			alert("ERROR: No se puede Aprobar una Liquidación vacía");
			return false;
			
<!---//		<cfelseif encaliqui.GELtotalGastos NEQ 0 and encaliqui.GELtotalAnticipos EQ 0 and encaliqui.GELtotalDepositos EQ 0>
//			alert("ERROR: Faltan Anticipos");
//			return false;--->
		
		<!---<cfelseif encaliqui.GELtotalGastos EQ 0 and encaliqui.GELtotalAnticipos EQ 0 and encaliqui.GELtotalDepositos NEQ 0>
			alert("ERROR: Faltan Anticipos");
			return false;--->
								
		<cfelseif encaliqui.GELreembolso EQ 0>
			<cfif encaliqui.GELtotalAnticipos - (encaliqui.GELtotalGastos + encaliqui.GELtotalDepositos) GT 0>
				alert("ERROR: Faltan Gastos o Depositos por ingresar");
				return false;
			<cfelse>
				return true;
			</cfif>
		<cfelse>
			return true;
		</cfif>
	}
</cfif>
</script>
</cfoutput>