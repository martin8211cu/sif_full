<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ArqueoCajaChica" default = "Arqueo de Caja Chica" returnvariable="LB_ArqueoCajaChica" xmlfile ="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteArqueo" default = "Reporte de Arqueo" returnvariable="LB_ReporteArqueo" xmlfile ="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile ="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DatosGenerales" default = "Datos Generales" returnvariable="LB_DatosGenerales" xmlfile ="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Responsable" default = "Responsable" returnvariable="LB_Responsable" xmlfile ="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Concepto" default= "Concepto" returnvariable="LB_Concepto" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Registrado" default= "Registrado" returnvariable="LB_Registrado" xmlfile="CCHarqueoRep.xml">	
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fisico" default= "F&iacute;sico" returnvariable="LB_Fisico" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Diferencia" default= "Diferencia" returnvariable="LB_Diferencia" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoAsignado" default= "Monto Asignado" returnvariable="LB_MontoAsignado" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ValesNoLiquidados" default= "Vales no Liquidados" returnvariable="LB_ValesNoLiquidados" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GastosLiquidados" default= "Gastos Liquidados" returnvariable="LB_GastosLiquidados" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_EfectivoDisponible" default= "Efectivo Disponible" returnvariable="LB_EfectivoDisponible" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Total" default= "Total" returnvariable="LB_Total" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_FirmaResponsable" default= "Firma Responsable" returnvariable="LB_FirmaResponsable" xmlfile="CCHarqueoRep.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_FirmaAuditor" default= "Firma Auditor" returnvariable="LB_FirmaAuditor" xmlfile="CCHarqueoRep.xml">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_htmlReportsHeaders 
	title="#LB_ArqueoCajaChica#" 
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

<!---<cfquery name="rsVales" datasource="#session.dsn#">
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

<cfset vales=rsVales.vales+rsVales2.vales>--->

<cfquery name="rsTotal" datasource="#session.dsn#">
    select b.Vales as CCHIanticipos,b.Gastos as CCHIgastos, b.MontoAsignado as CCHImontoasignado,(b.MontoAsignado -(b.Vales+b.Gastos )) as disponible
    from CCHarqueo a
    inner join 	CCHarqueoD b
        on b.CCHAid= a.CCHAid
    where CCHid=#rsform.CCHid#
    and a.CCHAid=#url.CCHAid#
</cfquery>

<cfset vales=rsTotal.CCHIanticipos>
<cfset gastos=rsTotal.CCHIgastos>	

<!---<cfquery name="rsgastos" datasource="#session.dsn#">
    select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #rsform.CCHid#
</cfquery>

<cfif len(trim(rsgastos.disponible)) gt 0>
    <cfset gastos=rsgastos.disponible>
<cfelse>
    <cfset gastos=0>
</cfif>--->


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
			<strong>#LB_ReporteArqueo#</strong>
		</td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center">
			<strong>#LB_Fecha#:</strong>#LSDateformat(rsform.BMfecha,'dd/mm/yyyy')#
		</td>
	</tr>
	<tr>
		<td>
			<fieldset>
			<legend><strong>#LB_DatosGenerales#</strong></legend>
			<table width="100%" >
				<tr>
					<td align="left">
						<strong>#LB_CajaChica#:</strong>#rsform.CCHcodigo#-#rsform.CCHdescripcion#
					</td>
					<td align="left">
						<strong>#LB_Responsable#:</strong>#rsform.CCHresponsable1#
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
			<legend><strong>#LB_ResultadosArqueo#</strong></legend>
			<table width="100%" border="1" bordercolor="666666">
			<tr bgcolor="CCCCCC">	
				<td><strong>#LB_Concepto#</strong></td>
				<td><strong>#LB_Registrado#</strong></td>
				<td><strong>#LB_Fisico#</strong></td>
				<td><strong>#LB_Diferencia#</strong></td>	
			</tr>
			
			<tr>
				<td><strong>#LB_MontoAsignado#</strong></td>
				<td align="right">#NumberFormat(rsMonto.CCHImontoAsignado,",0.00")#</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>
			</tr>
			
			<tr>
				<td><strong>#LB_ValesNoLiquidados#</strong></td>
				<td align="right">#NumberFormat(vales,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHvales,",0.00")#</td>
				<td align="right"><cfset difVales=#vales#-#rsform.CCHvales#>#NumberFormat(difVales,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>#LB_GastosLiquidados#</strong></td>
				<td align="right">#NumberFormat(gastos,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHgastos,",0.00")#</td>
				<td align="right"><cfset difGasto=#gastos#-#rsform.CCHgastos#>#NumberFormat(difGasto,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>#LB_EfectivoDisponible#</strong></td>
				<td align="right"><cfset tot=rsMonto.CCHImontoAsignado-vales-gastos>#NumberFormat(tot,",0.00")#</td>
				<td align="right">#NumberFormat(rsform.CCHefectivo,",0.00")#</td>
				<td align="right"><cfset difEfec=(rsMonto.CCHImontoAsignado-vales-gastos)-rsform.CCHefectivo>#NumberFormat(difEfec,",0.00")#</td>
			</tr>
			
			<tr>
				<td><strong>#LB_Total#</strong></td>
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
					<td align="center">#LB_FirmaResponsable#</td>
					<td align="center">#LB_FirmaAuditor#</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
