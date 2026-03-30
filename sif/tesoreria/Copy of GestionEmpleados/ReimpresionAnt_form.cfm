<cfif isdefined ('url.id')>
	<cfset form.GEAid=#url.id#>
<cfelse>
	<cf_htmlReportsHeaders 
			title="Impresion de Anticipo" 
			filename="Aticipos.xls"
			irA="ReimpresionAnt.cfm?regresar=1"
			download="no"
			preview="no"
			>
</cfif>	
<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

<cfif isdefined ('form.GEAid') and form.GEAid NEQ ''>
	<cfquery name="rsAnticipos" datasource="#session.DSN#">
		select 
			a.GEAfechaSolicitud,
			a.Mcodigo,
			(select Miso4217 from Monedas where Mcodigo=a.Mcodigo) as moneda,
			a.GEAtotalOri,
			a.GEAestado,
			a.GEAdescripcion,
			a.GEAtipoP,
			a.TESBid,
			case a.GEAtipoP
				when 0 then 'Caja Chica'
				when 1 then 'Tesoreria'
			end as pago,
			a.GEAmanual,
			a.GEAnumero,
			a.CFid,
			a.GECid
		from GEanticipo a
		where a.GEAid=#form.GEAid#
	</cfquery>	
	
	<cfif rsAnticipos.GECid NEQ "">
		<cflocation url="imprSolicAnticipoCOM.cfm?GEAid=#form.GEAid#&GECid=#rsAnticipos.GECid#&url=ReimpresionAnt.cfm">
	</cfif>

	<cfif rsAnticipos.GEAtipoP eq 0>
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CCHcodigo,CCHdescripcion from CCHica where CCHid =(select CCHid from GEanticipo where GEAid=#form.GEAid#)		
		</cfquery>
	</cfif>
	
	<cfquery name="rsAnticiposD" datasource="#session.DSN#">
		select 
				d.GEAid,
				d.GECid,
				(select GECdescripcion from GEconceptoGasto where GECid=d.GECid) as concepto,
				d.BMUsucodigo,
				d.GEADmonto,
				d.CFcuenta,
				(select CFformato from CFinanciera where CFcuenta=d.CFcuenta) as cuenta		
		from GEanticipoDet d
		where GEAid=#form.GEAid#
	</cfquery>	
	
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipos.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.DSN#" name="DatosEmpleado">
		select 
				TESBeneficiario,
				TESBeneficiarioId
		from TESbeneficiario
		where  TESBid=#rsAnticipos.TESBid#
	</cfquery>
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
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
<cfoutput>
		
	<table align="center" width="100%" border="0" summary="ImpresioLiquidaciones">
		
		<tr>
			<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="8"><strong>Sistema de Anticipos a Empleados</strong></td>
		</tr>
		<tr>
			<td align="center" colspan="8" nowrap="nowrap"> <strong>Empleado:&nbsp;#DatosEmpleado.TESBeneficiarioId#-#DatosEmpleado.TESbeneficiario#</strong>			</td>
		</tr>
		<tr>
			<td align="center" nowrap="nowrap" colspan="8"><strong> Anticipo N:&nbsp;&nbsp;#rsAnticipos.GEAnumero#</strong>			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Solicitud de Anticipo</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha de Solicitud:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="8">
			  <span class="style3">#dateFormat(rsAnticipos.GEAfechaSolicitud,"DD/MM/YYYY")#</span>		  </td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Moneda:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsAnticipos.moneda#</span></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Anticipos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsAnticipos.GEAtotalOri,',9.00')#			    </span></td>
		</tr>
		
			<td align="left" nowrap="nowrap"><strong>Estado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3"><!---#rsEncabezado.Titulo#	--->Finalizada		    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Forma de Pago:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsAnticipos.pago#			    </span></td>
		</tr>
		<cfif rsAnticipos.GEAtipoP eq 0>
			<tr>
			<td align="left" nowrap="nowrap"><strong>Caja Chica:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</span></td>
		</tr>
		</cfif>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Descripción:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsAnticipos.GEAdescripcion#</span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Tipo de Cambio:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsAnticipos.GEAmanual#</span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Detalle de Anticipos</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Concepto</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Monto</strong></td>			
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Cuenta</strong></td>
		</tr>
	<cfloop query="rsAnticiposD">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsAnticiposD.concepto#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsAnticiposD.GEADmonto,',9.00')#  </span></td>			
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#rsAnticiposD.cuenta#</span></td>
		</tr>	
	</cfloop>
		<tr>
			<td align="right" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Total:</strong>#LSNumberFormat(rsAnticipos.GEAtotalOri,',9.00')#</td>
		</tr>
		
	</table>
</cfoutput>
</cfif>






