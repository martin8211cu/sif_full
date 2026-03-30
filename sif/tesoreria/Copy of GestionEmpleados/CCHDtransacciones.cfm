
<cf_templatecss>
<cfquery name="rsEmp" datasource="#session.dsn#">
	select Edescripcion from Empresas where Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsCod" datasource="#session.dsn#">
	select CCHcod from CCHTransaccionesProceso where CCHTid=#url.CCHTid#
</cfquery>
<cfquery name="rsRep" datasource="#session.dsn#">
	select CCHTtipo,CCHTestado,(select Usulogin from Usuario where Usucodigo=STransaccionesProceso.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
	CCHTfecha, CCHTtrelacionada,
	case CCHTtrelacionada when 'Solicitud de Pago' then	 
		(select TESSPnumero from TESsolicitudPago where TESSPid=STransaccionesProceso.CCHTrelacionada)
	else
		(select TESOPnumero from TESordenPago where TESOPid=STransaccionesProceso.CCHTrelacionada)
	end as rel,
	
	case CCHTtrelacionada when 'Solicitud de Pago' then	 
		(select TESSPtotalPagarOri from TESsolicitudPago where TESSPid=STransaccionesProceso.CCHTrelacionada)
	else 
		(select TESOPtotalPago from TESordenPago where TESOPid=STransaccionesProceso.CCHTrelacionada)
	end as monto
	 from STransaccionesProceso 
	 where CCHTid=#url.CCHTid#
	 and CCHTtipo  in ('APERTURA','REINTEGRO','DISMINUCION','CIERRE','AUMENTO')
</cfquery>

<cfoutput>
<table width="100%">
	<tr style="font-size:24px">
		<td colspan="5" align="center">
			<strong>#rsEmp.Edescripcion#</strong>
		</td>
	</tr>
	<tr>
		<td colspan="5" align="center">
			<strong>#LSDateFormat(now(),'DD/MM/YYYY')#</strong>
		</td>
	</tr>
	<tr>
		<td colspan="5" align="center">
			<strong>Seguimiento de Transacciones</strong>
		</td>
	</tr>	
	<tr>
		<td colspan="5" align="center">
			<strong>Transacción: #rsCod.CCHcod#</strong>
		</td>
	</tr>
		
</table>
<table width="100%" cellpadding="0" cellspacing="0" border="1">
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td>
			<strong>Tipo</strong>
		</td>
		<td>
			<strong>Estado</strong>
		</td>
		<td>
			<strong>Usuario Aprobador</strong>
		</td>
		<td>
			<strong>Fecha</strong>
		</td>
		<td>
			<strong>Transaccion</br>Relacionada</strong>
		</td>
		<td>
			<strong>Monto</strong>
		</td>
	</tr>
	<cfloop query="rsRep">
	<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
		<td>
			#rsRep.CCHTtipo#
		</td>
		<td>
			#rsRep.CCHTestado#
		</td>
		<td>
			#rsRep.Usu#
		</td>
		<td>
			#LSDateFormat(rsRep.CCHTfecha,'DD/MM/YYYY')#
		</td>
		<td>
			<cfif len(trim(#rsRep.CCHTtrelacionada#)) gt 0>
				#rsRep.CCHTtrelacionada# #rsRep.rel#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td>
		<cfif len(trim(#rsRep.monto#)) gt 0>
			#rsRep.monto#
		<cfelse>
				&nbsp;
			</cfif>	
		</td>
	</tr>
	</cfloop>
</table>
</cfoutput>
