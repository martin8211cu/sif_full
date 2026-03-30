	<cf_htmlReportsHeaders 
		title="Impresion de Transacciones de Caja Chica" 
		filename="Transacciones.xls"
		irA="ConsultaTRAN.cfm?regresar=1"
		download="no"
		preview="no"
		>

<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>

<cfif isdefined ('form.tipoMovimiento') and #form.tipoMovimiento# neq 'ALL'>
	 <cfif #form.tipoMovimiento# eq 1>
	  	<cfset LvarFiltro = "'APERTURA','AUMENTO','DISMINUCION','CIERRE'">
	  	<cfset LvarTipoMov = "Afectan Monto Asignado">
	 <cfelseif #form.tipoMovimiento# eq 2>
	  	<cfset LvarFiltro = "'ANTICIPO','GASTO','COMISION'">
	  	<cfset LvarTipoMov = "Entrega de Efectivo">
	 <cfelseif #form.tipoMovimiento# eq 3>
	  	<cfset LvarFiltro = "'REINTEGRO'">
	  	<cfset LvarTipoMov = "Reintegros">
	 </cfif>
<cfelse>
	  	<cfset LvarTipoMov = "TODOS">
</cfif> 	


<cfquery name="rsTransac" datasource="#session.dsn#">
	select tp.CCHcod,(select Usulogin from Usuario where Usucodigo=tp.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
	tp.BMfecha,tp.CCHTtipo, CCHid,CCHTid
	 from CCHTransaccionesProceso tp where CCHid= #form.CCHid#
	<cfif isdefined ('form.tipoMovimiento') and #form.tipoMovimiento# neq 'ALL'>
	 	and CCHTtipo in (#preservesinglequotes(LvarFiltro)#)
     </cfif>
	 <cfif isdefined ('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I)) gt 0>
	 	and BMfecha >=#LSParseDateTime(form.TESSPfechaPago_I)#
	 </cfif>
	 <cfif isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0>
	 	and BMfecha <=#LSParseDateTime(form.TESSPfechaPago_F)#
	 </cfif>
</cfquery>

<cfquery name="rsCCH" datasource="#session.dsn#">
	select CCHcodigo,CCHdescripcion from CCHica where CCHid= #form.CCHid#
</cfquery>
<cfoutput>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<table width="100%">
	<tr>
		<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong>Transacciones de Caja Chica</strong></td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong>Caja Chica:#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</strong></td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong>Tipo de Movimiento:#LvarTipoMov#</strong></td>
	</tr>
    
	<cfloop query="rsTransac">

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
	 where CCHTid=#rsTransac.CCHTid#
	 and CCHTtipo  in ('APERTURA','DISMINUCION','CIERRE','AUMENTO') 
	 --and CCHTid=#rsTransac.CCHTid#
</cfquery>
	<tr>
		<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Transacción:</strong>#rsTransac.CCHTtipo#</td>
	</tr>
	<tr>
		<td align="left" nowrap="nowrap"><strong>Seguimiento de Transacción</strong></td>
	</tr>
	<tr  class="listaPar">
		<td align="left" nowrap="nowrap"><strong>Estado</strong></td>
		<td align="left" nowrap="nowrap"><strong>Usuario Aprobador</strong></td>
		<td align="left" nowrap="nowrap"><strong>Fecha</strong></td>
		<td align="left" nowrap="nowrap"><strong>Transaccion Relacionada</strong></td>
		<td align="left" nowrap="nowrap"><strong>Monto</strong></td>
	</tr>
<cfloop query="rsRep">
	<tr>
		<td align="left" nowrap="nowrap">#rsRep.CCHTestado#</td>
		<td align="left" nowrap="nowrap">#rsRep.Usu#</td>
		<td align="left" nowrap="nowrap">#LSDateFormat(rsRep.CCHTfecha,'DD/MM/YYYY')#</td>
		<td align="left" nowrap="nowrap">#rsRep.CCHTtrelacionada# #rsRep.rel#</td>
		<td align="left" nowrap="nowrap">#rsRep.monto#</td>
	</tr>
</cfloop>
	<tr>
		<td>&nbsp;
		 
		</td>
	</tr>

</cfloop>
</table>
</cfoutput>
