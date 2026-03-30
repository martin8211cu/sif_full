<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 27 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de ordenes de pago
----------->
<cfinvoke key="LB_TitDetalle" default="Detalle de la Orden de Pago"	returnvariable="LB_TitDetalle"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="ordenesPagoAnularform.xml"/> 

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset titulo = "">
<cfoutput><cfset titulo = '#LB_TitDetalle#'></cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfquery datasource="#session.dsn#" name="lista">
		select 
			sp.TESOPid,
			sp.TESSPid,
			dp.TESDPid,
			op.CBidPago,ss
			mp.Mnombre, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago,
			sp.TESSPnumero,
			sp.TESSPfechaPagar,
			e.Edescripcion,
			dp.TESDPmoduloOri,
			dp.TESDPdocumentoOri, 
			dp.TESDPreferenciaOri,
			dp.Miso4217Ori,
			dp.TESDPmontoAprobadoOri,
			coalesce(op.TESOPtipoCambioPago, 0) as TESOPtipoCambioPago,
			coalesce(dp.TESDPtipoCambioOri, 0) as TESDPtipoCambioOri,
			coalesce(dp.TESDPfactorConversion, 0) as TESDPfactorConversion,
			coalesce(dp.TESDPmontoPago, 0) as TESDPmontoPago,
			dp.TESDPmontoPagoLocal 
		from TESsolicitudPago sp
			inner join Empresas e
				 on e.Ecodigo = sp.EcodigoOri
			inner join TESdetallePago dp
				inner join Monedas m
					 on m.Miso4217	= dp.Miso4217Ori
					and m.Ecodigo	= dp.EcodigoOri
				 on dp.TESid 	= sp.TESid
				and dp.TESOPid 	= sp.TESOPid
				and dp.TESSPid	= sp.TESSPid
			inner join TESordenPago op
				left join Empresas ep
					inner join Monedas mep
						 on mep.Mcodigo = ep.Mcodigo
						and mep.Ecodigo = ep.Ecodigo
					 on ep.Ecodigo = op.EcodigoPago
				left join Monedas mp
					 on mp.Miso4217	= op.Miso4217Pago
					and mp.Ecodigo	= op.EcodigoPago
				 on op.TESid 	= sp.TESid
				and op.TESOPid 	= sp.TESOPid
		where sp.TESid = #session.tesoreria.TESid#
		  and sp.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.TESOPid#">
		  and sp.TESSPestado = 12
	</cfquery>	
	
	<table align="center" cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<tr class="tituloListas">
			<td  align="left"><strong><cf_translate key=LB_NumSolicitud>Num.<BR>Solicitud</cf_translate></strong></td>
			<td align="center"><strong><cf_translate key=LB_FecSolicitud>Fecha Pago<BR>Solicitada</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Origen>Origen</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Documento>Num.<BR>Documento</cf_translate></strong></td>
			<td align="left"><strong><cf_translate key=LB_Referencia>Referencia</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_MontoDoc>Monto<BR>Documento</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_TCDoc>Tipo&nbsp;Cambio<BR>Documento</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key=LB_FactorConver>Factor<BR>Conversion</cf_translate></strong></td>
			<td align="right"><strong>Monto Pago<BR><cfoutput>#lista.Mnombre#</cfoutput></strong></td>
			<td>&nbsp;</td><td>&nbsp;</td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">
		<cfset LvarSolicitud = "">
		<cfoutput query="lista">
			<cfset LvarTotalSP = LvarTotalSP + TESDPmontoPago>
			<cfif LvarLista NEQ "ListaPar">
				<cfset LvarLista = "ListaPar">
			<cfelse>
				<cfset LvarLista = "ListaNon">
			</cfif>
			<cfif LvarSolicitud NEQ lista.TESSPid>
				<cfset LvarSolicitud = lista.TESSPid>
			<tr class="#LvarLista#">
				<td align="center" nowrap>
					#TESSPnumero#
				</td>
				<td align="left" nowrap>
					#LSDateFormat(TESSPfechaPagar,"DD/MM/YYYY")#
				</td>
				<td align="left" nowrap colspan="7">
					<strong>Empresa que solicita: #Edescripcion#</strong>
				</td>
				<cfif LvarLista NEQ "ListaPar">
					<cfset LvarLista = "ListaPar">
				<cfelse>
					<cfset LvarLista = "ListaNon">
				</cfif>
				<td>&nbsp;</td><td>&nbsp;</td>
			</tr></cfif>
		
		<tr class="#LvarLista#">
			<td colspan="2">&nbsp;</td>
			<td align="center" nowrap>
				#TESDPmoduloOri#
			</td>
			<td align="left" nowrap>
				#TESDPdocumentoOri#
			</td>
			<td align="left" nowrap>
				#TESDPreferenciaOri#
			</td>
			<td align="right" nowrap>
				#NumberFormat(TESDPmontoAprobadoOri,",0.00")#  #Miso4217Ori#
			</td>

		<cfif Miso4217Ori EQ Miso4217EmpresaPago>
			<td align="right" nowrap>1.0000</td>
		<cfelseif CBidPago EQ "" OR Miso4217Ori EQ Miso4217Pago>
			<td align="right" nowrap>#NumberFormat(TESOPtipoCambioPago,",0.0000")#</td>
		<cfelse>
			<td align="right" nowrap>#NumberFormat(TESDPtipoCambioOri,",0.0000")#</td>
		</cfif>
		<cfif Miso4217Ori EQ Miso4217Pago>
			<td align="right" nowrap>1.0000</td>
		<cfelseif CBidPago EQ "" OR Miso4217EmpresaPago EQ Miso4217Pago or Miso4217EmpresaPago EQ Miso4217Ori>
			<td align="right" nowrap>#NumberFormat(TESDPtipoCambioOri,",0.0000")#</td>
		<cfelse>
			<td align="right" nowrap>#NumberFormat(TESDPfactorConversion,",0.0000")#</td>
		</cfif>
		<cfif CBidPago EQ "">
			<td align="right" nowrap>0.00</td>
		<cfelseif Miso4217Ori EQ Miso4217Pago OR Miso4217EmpresaPago EQ Miso4217Ori>
			<td align="right" nowrap>#NumberFormat(TESDPmontoAprobadoOri,",0.00")#</td>
		<cfelse>
			<td align="right" nowrap>#NumberFormat(TESDPmontoPago,",0.00")#</td>
		</cfif>
			<td>&nbsp;</td><td>&nbsp;</td>
		</tr>
	</cfoutput>
		<tr><td colspan="10">&nbsp;</td></tr>
	</table>
	<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
	function fnVerificarDet()
	{
<cfif rsform.CBidPago NEQ "">
	<cfoutput query="lista">
		document.form1.TESDPtipoCambioOri_#TESDPid#.value 	= qf(form1.TESDPtipoCambioOri_#TESDPid#.value);
		document.form1.TESDPmontoPago_#TESDPid#.value 		= qf(form1.TESDPmontoPago_#TESDPid#.value);
		document.form1.TESDPfactorConversion_#TESDPid#.value= qf(form1.TESDPfactorConversion_#TESDPid#.value);
		if (parseFloat(document.form1.TESDPtipoCambioOri_#TESDPid#.value) == 0)
		{
			alert("Faltan digitar tipos de cambio");
			document.form1.TESDPtipoCambioOri_#TESDPid#.focus();
			return false;
		}
		if (parseFloat(document.form1.TESDPmontoPago_#TESDPid#.value) == 0)
		{
			alert("Faltan digitar Montos a Pagar");
			document.form1.TESDPmontoPago_#TESDPid#.focus();
			return false;
		}
	</cfoutput>
</cfif>
		return true;
	}
<cfif rsForm.CBidPago NEQ "">
	function sbCambioTCP(obj)
	{
		var LvarTCP = obj;
	<cfoutput query="lista">
		{
			var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_#TESDPid#");
			var LvarTC = document.getElementById ("TESDPtipoCambioOri_#TESDPid#");
			var LvarFC = document.getElementById ("TESDPfactorConversion_#TESDPid#");
			var LvarMP = document.getElementById ("TESDPmontoPago_#TESDPid#");
		<cfif Miso4217Ori EQ Miso4217EmpresaPago>
			LvarTC.value = "1.0000";
		<cfelseif Miso4217Ori EQ Miso4217Pago>
			LvarTC.value = fm(qf(LvarTCP),4);
		</cfif>
			LvarFactor 	 = parseFloat(qf(LvarTC)) / parseFloat(qf(LvarTCP));
			LvarFC.value = fm(LvarFactor,4);
			LvarMP.value = fm(parseFloat(qf(LvarMO)) * LvarFactor,2);
		}
	</cfoutput>
	}
	function sbCambioTC(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = obj;
		var LvarFC = document.getElementById ("TESDPfactorConversion_" + LvarTESDPid);
		var LvarMP = document.getElementById ("TESDPmontoPago_" + LvarTESDPid);

		LvarFactor 	 = parseFloat(qf(LvarTC)) / parseFloat(qf(LvarTCP));
		LvarFC.value = fm(LvarFactor,4);
		LvarMP.value = fm(parseFloat(qf(LvarMO)) * LvarFactor,2);
	}
	function sbCambioFC(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = document.getElementById ("TESDPtipoCambioOri_" + LvarTESDPid);
		var LvarFC = obj;
		var LvarMP = document.getElementById ("TESDPmontoPago_" + LvarTESDPid);

		LvarMP.value = fm(parseFloat(qf(LvarMO)) * parseFloat(qf(LvarFC)),2);
		LvarTC.value = fm(parseFloat(qf(LvarFC)) * parseFloat(qf(LvarTCP)),4);
	}
	function sbCambioMonto(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = document.getElementById ("TESDPtipoCambioOri_" + LvarTESDPid);
		var LvarFC = document.getElementById ("TESDPfactorConversion_" + LvarTESDPid);
		var LvarMP = obj;

		LvarFactor 	 = parseFloat(qf(LvarMP)) / parseFloat(qf(LvarMO));
		LvarFC.value = fm(LvarFactor,4);
		LvarTC.value = fm(LvarFactor * parseFloat(qf(LvarTCP)),4);
	}
</cfif>
</script>
