<cfinclude template="../../Utiles/sifConcat.cfm">

<cfinvoke key="MSG_NoIncluiOP" default="No se puede incluir una Orden de Pago manualmente"	returnvariable="MSG_NoIncluiOP"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Cheque" default="CHEQUE"	returnvariable="LB_Cheque"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_TransImpresa" default="TRANSFERENCIA IMPRESA"	returnvariable="LB_TransImpresa"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_TransElectronica" default="TRANSFERENCIA ELECTRÓNICA"	returnvariable="LB_TransElectronica"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_TransManual" default="TRANSFERENCIA MANUAL"	returnvariable="LB_TransManual"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Autorizacion" default="AUTORIZACION"	returnvariable="LB_Autorizacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_TipIncorrecto" default="TIPO INCORRECTO"	returnvariable="LB_TipIncorrecto"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>

<cfinvoke key="LB_Preparacion" default="En Preparación"	returnvariable="LB_Preparacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Emision" default="En Emisión"	returnvariable="LB_Emision"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Impreso" default="Impreso"	returnvariable="LB_Impreso"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_YContabilizado" default="y Contabilizado"	returnvariable="LB_YContabilizado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_SinContabilizar" default="sin Contabilizar"	returnvariable="LB_SinContabilizar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Entegado" default="Entregado"	returnvariable="LB_Entegado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Anulado" default="Anulado"	returnvariable="LB_Anulado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_RegYContabilizado" default="Registrado y Contabilizado"	returnvariable="LB_RegYContabilizado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>

<cfoutput>
<cfif isdefined('form.TESOPid') and len(trim(form.TESOPid))>
	<cfset modo = 'CAMBIO'> 
<cfelse>
	<cf_errorCode	code = "50750" msg = "#MSG_NoIncluiOP#">
</cfif>
</cfoutput>

<cfquery datasource="#session.dsn#" name="rsTESendoso">
	select TESEcodigo, TESEdescripcion 
	  from TESendoso
	 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rsForm">
	Select 
		op.TESOPid, op.TESOPnumero, op.TESOPfechaPago,
		op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario,
		ep.Edescripcion #_Cat# ' - ' #_Cat# op.Miso4217Pago #_Cat# ' - ' #_Cat# bp.Bdescripcion  #_Cat# ' - ' #_Cat# cb.CBcodigo as CtaPago,
		op.TESOPtipoCambioPago, op.Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago, mep.Mnombre as Mempresa
	  , case op.TESOPestado
	  		when 10 then '#LB_Preparacion#'
	  		when 11 then '#LB_Emision#'
            when 110 then 'Sin Aplicar'
	  		when 12 then 'Aplicada'
	  		when 13 then 'Anulada'
	  		when 20 then 'En Aprobación'
	  		when 21 then 'Rechazada'
		end OPestado
	  , op.TESOPestado
	  ,	rtrim(mpg.TESMPcodigo) #_Cat# ' - ' #_Cat# rtrim(mpg.TESMPdescripcion) as MedioPago
	  ,	case mpg.TESTMPtipo
			when 1 then ' <strong>#LB_Cheque#</strong>'
			when 2 then ' <strong>#LB_TransImpresa#</strong>'
			when 3 then ' <strong>#LB_TransElectronica#</strong>'
			when 4 then ' <strong>#LB_TransManual#</strong>'
			when 5 then ' <strong>#LB_Autorizacion#</strong>'
				   else ' <strong>#LB_TipIncorrecto#</strong>'
		end	as DocPago
	  ,	case mpg.TESTMPtipo
			when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
			when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
		end as NumPago
	  ,	
	  	  case mpg.TESTMPtipo
			when 1 then 
				case (select fd.TESCFDestado from TEScontrolFormulariosD fd where fd.TESid = op.TESid and fd.CBid = op.CBidPago and fd.TESMPcodigo = op.TESMPcodigo and fd.TESCFDnumFormulario = op.TESCFDnumFormulario)
					when 0 then '#LB_Emision#'
					when 1 then '#LB_Impreso#' #_Cat# case when op.TESOPestado=12 then ' #LB_YContabilizado#' else ' #LB_SinContabilizar#' end
					when 2 then '#LB_Entegado#'
					when 3 then '#LB_Anulado#'
				end 
			else
				case (select fd.TESTDestado from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					when 0 then '#LB_Emision#'
					when 1 then '#LB_RegYContabilizado#'
					when 2 then '#LB_Entegado#'
					when 3 then '#LB_Anulado#'
				end 
		  end
		as EstadoPago
	  ,	mpg.TESTMPtipo
		
	  ,	mp.Mnombre, op.TESOPtotalPago, TESEcodigo

	  ,	TESOPfechaGeneracion,op.TESCFDnumFormulario, op.TESTDid
	  , op.CBidPago, op.TESMPcodigo, op.EcodigoPago, op.Miso4217Pago
		
	  ,	op.TESOPobservaciones
	  ,	op.TESOPmsgRechazo
	  ,	op.TESOPinstruccion
	  ,	tp.TESTPbanco #_Cat# ' - ' #_Cat# tp.Miso4217 #_Cat# ' - ' #_Cat# tp.TESTPcuenta as CtaTransferir
	from TESordenPago op
		left join Monedas mp
			 on mp.Ecodigo	= op.EcodigoPago
			and mp.Miso4217	= op.Miso4217Pago
		left join Empresas ep
			inner join Monedas mep
				 on mep.Ecodigo	= ep.Ecodigo
				and mep.Mcodigo	= ep.Mcodigo
			 on ep.Ecodigo = op.EcodigoPago
		left join CuentasBancos cb
			inner join Bancos bp
				 on bp.Bid = cb.Bid
			 on cb.CBid=op.CBidPago
		left join TESmedioPago mpg
			 on mpg.TESid		= op.TESid
			and mpg.CBid		= op.CBidPago
			and mpg.TESMPcodigo = op.TESMPcodigo
		left join TEStransferenciaP tp
			 on tp.TESid	= op.TESid
		   	and tp.TESTPid	= op.TESTPid
	where op.TESOPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
	  and op.TESid = #session.Tesoreria.TESid#
	  and op.TESOPestado in (12,110)
</cfquery>

<cfoutput>
<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_NumOrden>Num. Orden</cf_translate>:</strong></td>
		<td valign="top"> #LSNumberFormat(rsForm.TESOPnumero)# </td>
		<td valign="top" align="right"> <strong><cf_translate key=LB_FecOrden>Fecha Orden</cf_translate>:</strong>: </strong></td>
		<td>#LSDateFormat(rsForm.TESOPfechaGeneracion,"DD/MM/YYYY")# </td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_EstadoOrden>Estado Orden</cf_translate>:</strong></td>
		<td>#rsForm.OPestado#</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right">
			<strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong>
		</td>
		<td valign="top" colspan="3"> #rsForm.TESOPbeneficiario# </td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	<cfif rsForm.TESTMPtipo EQ 5>
		<td valign="top" align="right"><strong><cf_translate key=LB_TarjCredito>Tarjeta de Crédito</cf_translate>:</strong></td>
	<cfelse>
		<td valign="top" align="right"><strong><cf_translate key=LB_CtaBanco>Cuenta de Pago</cf_translate>:</strong></td>
	</cfif>
		<td colspan="3">#rsForm.CtaPago#</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
		<td colspan="3"> 
			#rsForm.MedioPago# 
		</td>
		<td>&nbsp;</td>
	</tr>
	<cfif #rsForm.DocPago# NEQ "">
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right">
			<strong>NUM. #rsForm.DocPago#:</strong>
		</td>
		<td>#rsForm.NumPago#</td>
		<td valign="top" align="right">
			<strong><cf_translate key=LB_EdoDoc>Estado Doc</cf_translate>:</strong>
		</td>
		<td>#rsForm.EstadoPago#</td>
		
	</tr>
	</cfif>
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_MonEmpPago>Moneda Empresa Pago</cf_translate>:</strong></td>
		<td valign="top"> #rsForm.Mempresa# </td>
		<td valign="top" align="right" rowspan="3">
			<strong><cf_translate key=LB_Observaciones>Observaciones</cf_translate>:</strong>
		<td valign="top" rowspan="3">
			<textarea name="TESOPobservaciones" cols="50" rows="4" id="TESOPobservaciones" readonly><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
		</td>
		<td rowspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_TotPagar>Total a Pagar</cf_translate>:</strong></td>
		<td valign="top"> 
			#numberFormat(rsForm.TESOPtotalPago,",0.00")# #rsForm.Mnombre# 
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_TC>Tipo de Cambio</cf_translate>:</strong></td>
		<td valign="top" align="left">
			<cfif rsForm.Miso4217Pago EQ "">
			<cfelseif rsForm.Miso4217Pago EQ rsForm.Miso4217EmpresaPago>
				n/a
			<cfelse>
				#NumberFormat(rsForm.TESOPtipoCambioPago,",0.0000")#
			</cfif>
			#rsForm.Miso4217EmpresaPago#s/#rsForm.Miso4217Pago# 
		</td>
	</tr>
	<tr>
		<td >&nbsp;</td>
		<td valign="top" align="right"><strong><cf_translate key=LB_FecPagoSol>Fecha Pago Solicitado</cf_translate>:</strong></td>
		<td valign="top"> #LSDateFormat(rsForm.TESOPfechaPago,'dd/mm/yyyy')# </td>
	<cfif rsForm.TESTMPtipo EQ 1>
		<td valign="top" align="right">
			<strong><cf_translate key=LB_CodEndoso>Código Endoso</cf_translate>:</strong>
		</td>
		<td valign="top">
		  <cfif LEN(rsform.TESEcodigo) gt 0>
			#rsTESendoso.TESEdescripcion#
		  <cfelse>
			<cf_translate key=LB_SinCodEndoso>Sin Código de Endoso</cf_translate>
		  </cfif>
		</td>
	<cfelseif rsForm.TESTMPtipo NEQ 5>
		<td valign="top" align="right">
			<strong><cf_translate key=LB_CtaDest>Cuenta Destino</cf_translate>:</strong>
		</td>
		<td valign="top">
			#rsForm.CtaTransferir#
		</td>
	</cfif>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	<cfif rsForm.TESTMPtipo EQ 1>
		<td valign="top" align="right">
			<strong><cf_translate key=LB_InstrBanco>Instrucción al Banco</cf_translate>:</strong>
		</td>
		<td valign="top">
			<cfif trim(rsForm.TESOPinstruccion) NEQ ''>
				#trim(rsForm.TESOPinstruccion)#
			<cfelse>
				<cf_translate key=LB_SinInstrBanco>Sin Instrucción</cf_translate>
			</cfif>
		</td>
		<td>&nbsp;</td>
	</cfif>
	</tr>
	<cfif rsForm.TESOPmsgRechazo NEQ "">
	<tr>
		<td>&nbsp;</td>
		<td valign="top" align="right">
		  <cfif isdefined("form.chkCancelados")>
			<strong><cf_translate key=LB_MotRechazo>Motivo Rechazo</cf_translate>:</strong>
			<cfelse>
			<strong><cf_translate key=LB_RechazoAnt>Rechazo Anterior</cf_translate>:</strong>
		  </cfif>
		</td>
		<td colspan="3" valign="top"><font style="color:##FF0000; font-weight:bold;">#rsForm.TESOPmsgRechazo#</font></td>
		<td>&nbsp;</td>
	</tr>
	</cfif>
</table>
</cfoutput>


