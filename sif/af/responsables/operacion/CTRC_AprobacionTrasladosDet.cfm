<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="now" returnvariable="hoy">
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.AFTRtipo,case a.AFTRtipo when 1 then 'De responsable a responsable' else 'De centro custodia a centro custodia' end as tipotraslado, 
			rtrim(e.CRTDcodigo) #_Cat# ' - ' #_Cat# rtrim(e.CRTDdescripcion) as CRTipoDocumento,
			ACORI.Aplaca as placaOri, 
			EMPORI.DEidentificacion  #_Cat# ' - ' #_Cat# EMPORI.DEnombre #_Cat# ' ' #_Cat# EMPORI.DEapellido1 #_Cat# ' ' #_Cat# EMPORI.DEapellido2 as CedOri, 
			CFOri.CFdescripcion as CFuncionalORI, 
			CCORI.CRCCcodigo #_Cat# ' - ' #_Cat# CCORI.CRCCdescripcion  as Centros, b.AFRfini, 
			b.CRDRdescripcion,
			ACDES.Aplaca as placaDES, 
			EMPDES.DEidentificacion  #_Cat# ' - ' #_Cat# EMPDES.DEnombre #_Cat# ' ' #_Cat# EMPDES.DEapellido1 #_Cat# ' ' #_Cat# EMPDES.DEapellido2 as CedDes, 
			CFDes.CFdescripcion  as CFuncionalDES, 
			CCDES.CRCCcodigo#_Cat# ' - ' #_Cat# CCDES.CRCCdescripcion as CentroCDES,
			us.Usulogin
	from AFTResponsables a
	
	inner join Usuario us
		on us.Usucodigo = a.Usucodigo	
		
	inner join AFResponsables b 
		on b.Ecodigo = #session.Ecodigo# 
		and a.AFRid = b.AFRid
	inner join CRCCUsuarios c 
		on a.CRCCid = c.CRCCid 
		and c.Usucodigo = #session.Usucodigo#
	inner join Activos ACORI 
		on b.Aid = ACORI.Aid 
		and b.Ecodigo = ACORI.Ecodigo 
	left outer join Activos ACDES 
		on a.Aid = ACDES.Aid 
	inner join CRCentroCustodia CCORI 
		on b.Ecodigo = CCORI.Ecodigo 
		and b.CRCCid = CCORI.CRCCid
	inner join CRCentroCustodia CCDES 
		on a.CRCCid = CCDES.CRCCid
	left outer join CRTipoDocumento e 
		on b.Ecodigo = e.Ecodigo 
		and b.CRTDid =e.CRTDid 
	inner join DatosEmpleado EMPORI 
		on b.DEid = EMPORI.DEid 
		and b.Ecodigo = EMPORI.Ecodigo 
	left outer join DatosEmpleado EMPDES 
		on a.DEid = EMPDES.DEid 
	left outer join CFuncional CFOri 
		on b.Ecodigo = CFOri.Ecodigo 
		and b.CFid =CFOri.CFid 
<!---	--caso 1: Empresa usa RH
--->	left outer join LineaTiempo LT 
		on LT.DEid = a.DEid 
			and #hoy# between LT.LTdesde and LT.LThasta 
	left outer join RHPlazas RP 
		on RP.RHPid = LT.RHPid
<!---	--caso 2: Empresa NO usa RH
--->	left outer join EmpleadoCFuncional decf
		on decf.DEid = a.DEid
		and #hoy# between decf.ECFdesde and decf.ECFhasta
	left outer join CFuncional CFDes 
		on CFDes.CFid = coalesce(RP.CFid, decf.CFid)
	where  a.AFTRestado in(10,40)
	and a.AFTRid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.AFTRid#">
</cfquery>
<title>
	Detalle del traslado de vales
</title>
<cfoutput>
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table width="100%"  cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Información General
				</legend>				
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>					
					<tr>
						<td width="40%" align="right"><b>Tipo de Traslado</b></td>
						<td>#rsDatos.tipotraslado#</td>
					</tr>	
					<tr>
						<td align="right"><b>Tipo de Documento</b></td>
						<td>#rsDatos.CRTipoDocumento#</td>
					</tr>			
					<tr>
						<td align="right"><b>No. de Placa</b></td>
						<td>#rsDatos.placaOri#</td>
					</tr>		
					<tr>
						<td align="right"><b>Descripción</b></td>
						<td>#rsDatos.CRDRdescripcion#</td>
					</tr>	
					<tr>
						<td align="right"><b>Fecha</b></td>
						<td>#LSDateFormat(rsDatos.AFRfini,'dd/mm/yyyy')#</td>
					</tr>	
					<cfif isdefined("rsDatos.AFTRtipo") and rsDatos.AFTRtipo eq 2>
						<tr>
							<td align="right"><b>Centro Funcional</b></td>
							<td>#rsDatos.CFuncionalORI#</td>
						</tr>			
						<tr>
							<td align="right"><b>Empleado</b></td>
							<td>#rsDatos.CedOri#</td>
						</tr>
					</cfif>					
					<tr>
						<td align="right"><b>Usuario</b></td>
						<td>#rsDatos.Usulogin#</td>
					</tr>																						
				</table>
			</fieldset>	
		</td>
	</tr>
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							
	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Origen
				</legend>
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>
					<tr valign="top">
						<td width="40%" align="right"><b>Centro de Custodia</b></td>
						<td>#rsDatos.Centros#</td>
					</tr>	
					<cfif isdefined("rsDatos.AFTRtipo") and rsDatos.AFTRtipo eq 1>
						<tr>
							<td align="right"><b>Centro Funcional</b></td>
							<td>#rsDatos.CFuncionalORI#</td>
						</tr>			
						<tr>
							<td align="right"><b>Empleado</b></td>
							<td>#rsDatos.CedOri#</td>
						</tr>						
					</cfif>
				</table>
			</fieldset>	
		</td>
	</tr>	
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							
	<tr>
		<td>
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<legend align="center" style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Destino
				</legend>				
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td colspan="2"align="center">&nbsp;</td>
					</tr>					
					<tr  valign="top">
						<td width="40%" align="right"><b>Centro de Custodia</b></td>
						<td>#rsDatos.CentroCDES#</td>
					</tr>	
					<cfif isdefined("rsDatos.AFTRtipo") and rsDatos.AFTRtipo eq 1>
						<tr>
							<td align="right"><b>Centro Funcional</b></td>
							<td>#rsDatos.CFuncionalDES#</td>
						</tr>			
						<tr>
							<td align="right"><b>Empleado</b></td>
							<td>#rsDatos.CedDes#</td>
						</tr>					
					</cfif>
				</table>
			</fieldset>	
		</td>
	</tr>
	<tr>
		<td colspan="2"align="center">&nbsp;</td>
	</tr>							
	<tr>
		<td colspan="2"align="center">
			<input type="button" value="Cerrar" onClick="javascript: window.close();">
		</td>
	</tr>							
</table>
</cfoutput>