<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_htmlReportsHeaders 
	title="Arqueo de Caja Chica" 
	filename="Arqueo.xls"
	irA="arqueo.cfm?regresar=1"
	download="no"
	preview="no"
>
<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

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
<cfquery name="rsEmp" datasource="#session.dsn#">
	select Edescripcion from Empresas where Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsform" datasource="#session.dsn#">
	select
	 a.CCHAid,
	 a.CCHid,
	 a.CCHvales,
	 a.CCHgastos,
	 a.CCHefectivo,
	 a.CCHfaltante, 
	 a.CCHsobrante,
	 c.CCHresponsable,
	 a.BMfecha,
	 c.CCHcodigo,
	 c.CCHdescripcion,
	(select DEnombre #LvarCNCT#' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 from DatosEmpleado where DEid=c.CCHresponsable) as CCHresponsable1
	from CCHarqueo a 
		inner join CCHica c
		on c.CCHid=a.CCHid
	where CCHAid=#url.CCHAid#
</cfquery>

<cfquery name="rsform1" datasource="#session.dsn#">
	select Efectivo
	 from CCHarqueoD a 
	where CCHAid=#url.CCHAid#
</cfquery>

<cfquery name="rsMonto" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid=#rsform.CCHid#	
</cfquery>

<cfquery name="rsVales" datasource="#session.dsn#">
	select coalesce(sum(a.CCHTAmonto),0) as vales
	from CCHTransaccionesAplicadas a
		inner join CCHTransaccionesProceso p
		on p.CCHTid = a.CCHTAtranRelacionada
	   and p.CCHTestado='CONFIRMADO'
	where a.CCHid=#rsform.CCHid#
	  and a.CCHTAreintegro=-1
	  and a.CCHTtipo='ANTICIPO'
	  and (
	  		select count(1)
			from GEliquidacionAnts an
				inner join GEliquidacion l
				on l.GELid=an.GELid
				and l.GELestado in (0,1,2,3,4,5)				
			where an.GEAid   = p.CCHTrelacionada
		  ) = 0			
</cfquery>

<cfquery name="rsVales2" datasource="#session.dsn#">
	select  coalesce(sum(a.CCHTAmonto),0) as vales
	from CCHTransaccionesAplicadas a
		inner join CCHTransaccionesProceso p
		on p.CCHTid = a.CCHTAtranRelacionada
	where a.CCHid=#rsform.CCHid#
	 and a.CCHTAreintegro=-1
	  and a.CCHTtipo='ANTICIPO'
	  and (
	  		select count(1)
			from GEliquidacionAnts an
				inner join GEliquidacion l
				on l.GELid=an.GELid
				and l.GELestado in (0,1)				
			where an.GEAid   = p.CCHTrelacionada
		  ) > 0
</cfquery>

<cfset vales=rsVales.vales+rsVales2.vales>


<cfquery name="rsgastos" datasource="#session.dsn#">
		select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #rsform.CCHid#
	</cfquery>
	
	<cfif len(trim(rsgastos.disponible)) gt 0>
		<cfset gastos=rsgastos.disponible>
	<cfelse>
		<cfset gastos=0>
	</cfif>


<cfquery name="rsReintegro" datasource="#session.dsn#">
	select 	
		NumTransac,
		Monto,         
		Estado,        
		Fecha ,        
		CCHAid
	from CCHarqueoReintegro where CCHAid=#url.CCHAid#
</cfquery>


<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<!---Encabezado--->
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center">
			<strong>#rsEmp.Edescripcion#</strong>
		</td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center">
			<strong>Reporte de Arqueo</strong>
		</td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center">
			<strong>Fecha:</strong>#LSDateformat(rsform.BMfecha,'dd/mm/yyyy')#
		</td>
	</tr>
	<tr>
		<td>
			<fieldset>
			<legend><strong>Datos Generales</strong></legend>
			<table width="100%" >
				<tr>
					<td align="left">
						<strong>Caja Chica:</strong>#rsform.CCHcodigo#-#rsform.CCHdescripcion#
					</td>
					<td align="left">
						<strong>Responsable:</strong>#rsform.CCHresponsable1#
					</td>
				</tr>	
			</table>
			</fieldset>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>

	
	
	
	
	
	<tr>
		<td colspan="3">
			<fieldset>
			<cfoutput>
			<legend><strong>Resultados del arqueo</strong></legend>
			<table width="100%" border="1" bordercolor="666666">
			<tr bgcolor="CCCCCC">	
				<td><strong>Concepto</strong></td>
				<td><strong>Registrado</strong></td>
				<td><strong>Físico</strong></td>
				<td><strong>Diferencia</strong></td>	
			</tr>
			
			<tr>
				<td><strong>Monto Asignado</strong></td>
				<td align="right">#NumberFormat(rsMonto.CCHImontoAsignado,",0.00")#</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>
			</tr>
			
			<tr>
				<td><strong>Vales no Liquidados</strong></td>
				<td align="right">#NumberFormat(vales,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHvales,",0.00")#</td>
				<td align="right"><cfset difVales=#vales#-#rsform.CCHvales#>#NumberFormat(difVales,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>Gastos Liquidados</strong></td>
				<td align="right">#NumberFormat(gastos,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHgastos,",0.00")#</td>
				<td align="right"><cfset difGasto=#gastos#-#rsform.CCHgastos#>#NumberFormat(difGasto,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>Efectivo Disponible</strong></td>
				<td align="right"><cfset tot=rsMonto.CCHImontoAsignado-vales-gastos>#NumberFormat(tot,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHefectivo,",0.00")#</td>
				<td align="right"><cfset difEfec=(rsMonto.CCHImontoAsignado-vales-gastos)-rsform.CCHefectivo>#NumberFormat(difEfec,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>Total</strong></td>
				<td align="right"><cfset tot1=vales+gastos+tot>#NumberFormat(tot1,",0.00")#</td>
				<td align="right"><cfset tot2=rsform.CCHvales+rsform.CCHgastos+rsform.CCHefectivo>#NumberFormat(tot2,",0.00")#</td>
				<td align="right"><cfset tot3=difVales+difGasto+difEfec>#NumberFormat(tot3,",0.00")#</td>
			</tr>
			
			</table>
			
			</cfoutput>
			</fieldset>
		
		</td>
	</tr>
	
	
	
	
	
				
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>

	<tr>
		<td>
			<table width="100%">
				<tr>
					<td align="center">___________________________</td>
					<td align="center">___________________________</td>
				</tr>
				<tr>
					<td align="center">Firma Responsable</td>
					<td align="center">Firma Auditor</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
