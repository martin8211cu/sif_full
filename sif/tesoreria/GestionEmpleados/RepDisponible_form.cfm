<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DisponibleCajaChica" default = "Disponible en Caja Chica" returnvariable="LB_DisponibleCajaChica" xmlfile = "RepDisponible_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Disponible" default = "Disponible" returnvariable="LB_Disponible" xmlfile = "RepDisponible_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Anticipos" default = "Anticipos" returnvariable="LB_Anticipos" xmlfile = "RepDisponible_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Devoluciones" default = "Devoluciones" returnvariable="LB_Devoluciones" xmlfile = "RepDisponible_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Rembolsos" default = "Reembolsos" returnvariable="LB_Rembolsos" xmlfile = "RepDisponible_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Gastos" default = "Gastos" returnvariable="LB_Gastos" xmlfile = "RepDisponible_form.xml">

<cf_htmlReportsHeaders
	title="#LB_DisponibleCajaChica#"
	filename="Disponible.xls"
	irA="RepDisponible#LvarCFM#.cfm?regresar=1"
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

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select
			Edescripcion,
			Ecodigo
	from Empresas
	where Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsTotal" datasource="#session.dsn#">
	select CCHIanticipos,CCHIgastos, CCHImontoasignado,(CCHImontoasignado-(CCHIanticipos+CCHIgastos)) as disponible
	from CCHImportes
	where CCHid=#form.CCHid#
</cfquery>

<cfquery name="rsAnticipo" datasource="#session.dsn#">
    select isnull(sum(CCHEMmontoOri),0)  Anticipos  from CCHespecialMovs
    where CCHEMtipo ='S' and GELid is null
</cfquery>

<cfquery name="rsDevolucion" datasource="#session.dsn#">
	select isnull((select isnull(sum(CCHEMmontoOri),0) Devoluciones
	from CCHespecialMovs where CCHEMtipo ='E' and CCHEMdescripcion like '%Efectivo%') -
	(select isnull(sum(CCHEMmontoOri),0) DevolucionesCanceladas
	from CCHespecialMovs where CCHEMtipo ='E' and CCHEMdescripcion like '%Efectivo%' and CCHEMCancelado = 1),0) as Devoluciones
	<!---select isnull(sum(CCHEMmontoOri),0) Devoluciones from CCHespecialMovs
    where CCHEMtipo ='E'
    and CCHEMdescripcion  like '%Efectivo%'--->
</cfquery>

<cfquery name="rsReembolso" datasource="#session.dsn#">
	select isnull(sum(CCHEMmontoOri),0) Reembolsos from CCHespecialMovs
	where CCHEMtipo ='S' and GELid>0
</cfquery>

<cfquery name="rsRep" datasource="#session.dsn#">
	select a.CCHTAtranRelacionada, a.CCHTAmonto, p.CCHTrelacionada
	from CCHTransaccionesAplicadas a
		inner join CCHTransaccionesProceso p
		on p.CCHTid = a.CCHTAtranRelacionada
	where a.CCHid=#form.CCHid#
	  and a.CCHTAreintegro=-1
	  and a.CCHTtipo='ANTICIPO'
	  and (
	  		select count(1)
			from GEliquidacionAnts an
				inner join GEliquidacion l
				on l.GELid=an.GELid
				and l.GELestado in (0,1,2,4,5)
			where an.GEAid   = p.CCHTrelacionada
		  ) = 0
			order by p.CCHTrelacionada
</cfquery>

<cfquery name="rsRep1" datasource="#session.dsn#">
	select a.CCHTAtranRelacionada, a.CCHTAmonto, p.CCHTrelacionada
	from CCHTransaccionesAplicadas a
		inner join CCHTransaccionesProceso p
		on p.CCHTid = a.CCHTAtranRelacionada
	where a.CCHid=#form.CCHid#
	 and a.CCHTAreintegro=-1
	  and a.CCHTtipo='ANTICIPO'
	  and ((
	  		select count(1)
			from GEliquidacionAnts an
				inner join GEliquidacion l
				on l.GELid=an.GELid
				and l.GELestado in (0,1)
			where an.GEAid   = p.CCHTrelacionada
		  ) > 0
		  or
            ( select count(1)
             from GEliquidacionAnts an
             inner join GEliquidacion l
             on l.GELid=an.GELid
             and l.GELestado in(4,5)
             inner join GEanticipoDet d
              on d.GEAid = an.GEAid
              and (d.GEADmonto - d.GEADutilizado) > 0
             where an.GEAid = p.CCHTrelacionada ) > 0)
</cfquery>

<cfquery name="rsRepG" datasource="#session.dsn#">
	select a.CCHTAtranRelacionada, a.CCHTAmonto, p.CCHTrelacionada
	from CCHTransaccionesAplicadas a
		inner join CCHTransaccionesProceso p
		on p.CCHTid = a.CCHTAtranRelacionada
        and p.CCHTestado <>'RECHAZADO'
	where a.CCHid=#form.CCHid#
	  and a.CCHTAreintegro=-1
	  and a.CCHTtipo='GASTO'
</cfquery>

<cfquery name="rsRepG1" datasource="#session.dsn#">
    select a.CCHTAtranRelacionada, a.CCHTAmonto, p.CCHTrelacionada,a.CCHTAreintegro
    from CCHTransaccionesAplicadas a
        inner join CCHTransaccionesProceso p
        on p.CCHTid = a.CCHTAtranRelacionada
        inner join CCHTransaccionesProceso r
        on r.CCHTid=a.CCHTAreintegro
        and r.CCHTtipo='REINTEGRO'
        and r.CCHTestado in ('EN PROCESO','EN APROBACION CCH','EN APROBACION TES','POR CONFIRMAR')
   where a.CCHid=#form.CCHid#
	  and a.CCHTtipo='GASTO'
</cfquery>

<cfquery name="rsCCH" datasource="#session.dsn#">
	select CCHcodigo,CCHdescripcion, CCHtipo
	from CCHica
	where CCHid =#form.CCHid#
</cfquery>


<table width="100%" cellpadding="0" cellspacing="0">
<cfoutput>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong>#rsEmpresa.Edescripcion#</strong></td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong><cf_translate key = LB_DisponibleCajaChica xmlfile = "RepDisponible_form.xml">Disponible de Caja Chica</cf_translate></strong></td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong><cf_translate key = LB_CajaChica xmlfile = "RepDisponible_form.xml">Caja Chica</cf_translate>: #rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</strong></td>
	</tr>
</cfoutput>
<!-----**********************------>
  <cfset LvarTot= 0>
        <cfloop query="rsRep">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion,a.GEAfechaPagar,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Pagada xmlfile = "RepDisponible_form.xml">Pagada</cf_translate>'
						when  5 then '<cf_translate key = LB_Liquidada xmlfile = "RepDisponible_form.xml">Liquidada</cf_translate>'
                        when  6 then '<cf_translate key = LB_PCD xmlfile = "RepDisponible_form.xml">PCD</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep.CCHTrelacionada#

			</cfquery>

            <cfif rsAnt.recordcount gt 0>
				<cfset LvarTotA=rsAnt.GEAtotalOri>
				<cfset LvarTot =LvarTot+LvarTotA>
            </cfif>
		</cfloop>
        <cfloop query="rsRep1">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion,a.GEAfechaPagar,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Pagada xmlfile = "RepDisponible_form.xml">Pagada</cf_translate>'
						when  5 then '<cf_translate key = LB_Liquidada xmlfile = "RepDisponible_form.xml">Liquidada</cf_translate>'
                        when  6 then '<cf_translate key = LB_PCD xmlfile = "RepDisponible_form.xml">PCD</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep1.CCHTrelacionada#
			</cfquery>

            <cfif rsAnt.recordcount gt 0>
				<cfset LvarTotB=rsAnt.GEAtotalOri>
                <cfset LvarTot=LvarTot+LvarTotB>
            </cfif>
		</cfloop>

		<cfset LvarTot1=0>
		<cfset LvarDev=0>
		<cfset LvarTotF=0>

		<cfloop query="rsRepG">
			<cfquery name="rsGas" datasource="#session.dsn#">
				select
					a.GELnumero,a.TESBid,GELid,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GELdescripcion,
					coalesce(a.GELtotalAnticipos,0) as GELtotalAnticipos,
					coalesce(a.GELtotalGastos,0) as GELtotalGastos,
					coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Finalizada xmlfile = "RepDisponible_form.xml">Finalizada</cf_translate>'
						when  5 then '<cf_translate key = LB_PorReintegrar xmlfile = "RepDisponible_form.xml">Por Reintegrar</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estadoL,
					a.Mcodigo
				from GEliquidacion a
				where GELid=#rsRepG.CCHTrelacionada#
			</cfquery>

            <cfif rsGas.recordcount gt 0>
     			<cfset LvarTot1=LvarTot1+rsGas.GELtotalGastos>
	     		<cfset LvarDev= LvarDev+rsGas.GELtotalDevoluciones>
            </cfif>
		</cfloop>

		<cfloop query="rsRepG1">
			<cfquery name="rsGas" datasource="#session.dsn#">
				select
					a.GELnumero,a.TESBid,GELid,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GELdescripcion,
					coalesce(a.GELtotalAnticipos,0) as GELtotalAnticipos,
					coalesce(a.GELtotalGastos,0) as GELtotalGastos,
					<cfif rsCCH.CCHtipo eq 2>
						coalesce(a.GELtotalDepositosEfectivo,0) as GELtotalDevoluciones,
					<cfelse>
						coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones,
					</cfif>
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Finalizada xmlfile = "RepDisponible_form.xml">Finalizada</cf_translate>'
						when  5 then '<cf_translate key = LB_PorReintegrar xmlfile = "RepDisponible_form.xml">Por Reintegrar</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estadoL,
					a.Mcodigo
				from GEliquidacion a
				where GELid=#rsRepG1.CCHTrelacionada#
			</cfquery>

            <cfif rsGas.recordcount gt 0>
				<cfset LvarTot1=LvarTot1+rsGas.GELtotalGastos>
                <cfset LvarDev=LvarDev+rsGas.GELtotalDevoluciones>
            </cfif>
		</cfloop>
<cfif rsCCH.CCHtipo eq 2>
	<cfset LvarAnticipos  =  rsAnticipo.Anticipos>
    <cfset LvarReembolsos =  rsReembolso.Reembolsos>
	<cfset LvarDevoluciones = rsDevolucion.Devoluciones>
	<cfset LvarDisponible = rsTotal.CCHImontoasignado - rsAnticipo.Anticipos - rsReembolso.Reembolsos  + rsDevolucion.Devoluciones>
<cfelse>
	<cfset LvarAnticipos  =  Lvartot>
	<cfset LvarDevoluciones = Lvartot1>
	<cfset LvarDisponible = rsTotal.CCHImontoasignado - Lvartot  - Lvartot1>
</cfif>

<!--- <cfflush interval="20"> --->
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<cfset rsPieGraph = QueryNew("Monto,Porc")>
			<cfif rsCCH.CCHtipo eq 2>
				<cfset QueryAddrow(rsPieGraph,4)>
            <cfelse>
            	<cfset QueryAddrow(rsPieGraph,3)>
            </cfif>

			<cfset QuerySetCell(rsPieGraph,"Monto",LvarDisponible,1)>
			<cfset QuerySetCell(rsPieGraph,"Porc","#LB_Disponible#",1)>
			<cfset QuerySetCell(rsPieGraph,"Monto",LvarAnticipos,2)>
			<cfset QuerySetCell(rsPieGraph,"Porc","#LB_Anticipos#",2)>
			<cfset QuerySetCell(rsPieGraph,"Monto",LvarDevoluciones,3)>
			<cfif rsCCH.CCHtipo eq 2>
				<cfset QuerySetCell(rsPieGraph,"Porc","#LB_Devoluciones#",3)>
                <cfset QuerySetCell(rsPieGraph,"Monto",LvarReembolsos,4)>
   				<cfset QuerySetCell(rsPieGraph,"Porc","#LB_Rembolsos#",4)>
			<cfelse>
				<cfset QuerySetCell(rsPieGraph,"Porc","#LB_Gastos#",3)>
			</cfif>

			<fieldset><legend><strong><cf_translate key = LB_GraficoMontos xmlfile = "RepDisponible_form.xml">Gráfico de montos</cf_translate></strong></legend>
				<cfchart
				format = "flash"
				chartwidth = "350"
				scalefrom = "0"
				scaleto = "0"
				showxgridlines = "yes"
				showygridlines = "yes"
				gridlines = "5"
				seriesplacement = "stacked"
				showborder = "no"
				font = "Arial"
				fontsize = "10"
				fontbold = "no"
				fontitalic = "no"
				labelformat = "number"
				xaxistitle = "Vencimiento en Das"
				yaxistitle = "Monto Vencimiento"
				sortxaxis = "no"
				show3d = "yes"
				rotated = "no"
				showlegend = "yes"
				tipstyle = "MouseOver"
				showmarkers = "yes"
				markersize = "50"
				pieslicestyle="sliced" >

				<cfchartseries
				type="pie"
				query="rsPieGraph"
				valuecolumn="Monto"
				itemcolumn="porc"
				colorlist="##0066FF,##009933,##CC0099,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
			</fieldset>
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr>
		<td align="right" colspan="4"><strong><cf_translate key = LB_TotalAsignado xmlfile = "RepDisponible_form.xml">Total Asignado</cf_translate>:</strong></td>
		<td align="right" colspan="2"><strong><cfoutput>#NumberFormat(rsTotal.CCHImontoasignado, ",9.00")#</cfoutput></strong></td>
	</tr>
	<tr>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="7"><cf_translate key = LB_Anticipos xmlfile = "RepDisponible_form.xml">Anticipos</cf_translate></td>
	</tr>
	<!---Anticipos sin Liquidar--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong><cf_translate key = LB_AnticiposSinLiquidar xmlfile = "RepDisponible_form.xml">Anticipos Sin Liquidar</cf_translate></strong></td>
	</tr>
		<cfset tot=0>
	<cfif rsRep.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***<cf_translate key = LB_NoSeEncontraronRegistros xmlfile = "RepDisponible_form.xml">No se encontraron registros</cf_translate>***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong><cf_translate key = LB_NoAnticipo xmlfile = "RepDisponible_form.xml">No. Anticipo</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Empleado xmlfile = "RepDisponible_form.xml">Empleado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Descripcion xmlfile = "RepDisponible_form.xml">Descripción</cf_translate></strong></td>
			<td align="center"><strong><cf_translate key = LB_FechaAnticipo xmlfile = "RepDisponible_form.xml">Fecha Anticipo</cf_translate></strong></td>
			<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_Estado xmlfile = "RepDisponible_form.xml">Estado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Total xmlfile = "RepDisponible_form.xml">Total</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Moneda xmlfile = "RepDisponible_form.xml">Moneda</cf_translate></strong></td>
		</tr>

		<cfloop query="rsRep">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion, a.GEAfechaPagar,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Pagada xmlfile = "RepDisponible_form.xml">Pagada</cf_translate>'
						when  5 then '<cf_translate key = LB_Liquidada xmlfile = "RepDisponible_form.xml">Liquidada</cf_translate>'
                        when  6 then '<cf_translate key = LB_PCD xmlfile = "RepDisponible_form.xml">PCD</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep.CCHTrelacionada#
				order by a.GEAfechaPagar
			</cfquery>

			<cfif rsAnt.recordcount gt 0>
			<cfset totA=rsAnt.GEAtotalOri>
			<cfoutput>
			<tr>
				<td>
					<a href="javascript:doConlis(#rsAnt.GEAid#,'A');">
							#rsAnt.GEAnumero#
					</a>
				</td>
				<td>#rsAnt.name#</td>
				<td>#rsAnt.GEAdescripcion#</td>
				<td align="center">#dateFormat(rsAnt.GEAfechaPagar,"DD/MM/YYYY")#</td>
				<td align="left" nowrap="nowrap">#rsAnt.estado#</td>
				<td>#NumberFormat(rsAnt.GEAtotalOri,",0.00")#</td>
				<td>#rsAnt.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot=tot+totA>
			</cfif>
			<!--- <cfflush> --->
		</cfloop>
	</cfif>
	<!---Anticipo relacionados con alguna liquidacion--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong><cf_translate key = LB_AnticiposLiquidados xmlfile = "RepDisponible_form.xml">Anticipos Liquidados</cf_translate></strong></td>
	</tr>
	<cfif rsRep1.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***<cf_translate key = LB_NoSeEncontraronRegistros xmlfile = "RepDisponible_form.xml">No se encontraron registros</cf_translate>***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong><cf_translate key = LB_NoAnticipo xmlfile = "RepDisponible_form.xml">No. Anticipo</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Empleado xmlfile = "RepDisponible_form.xml">Empleado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Descripcion xmlfile = "RepDisponible_form.xml">Descripción</cf_translate></strong></td>
			<td align="center"><strong><cf_translate key = LB_FechaAnticipo xmlfile = "RepDisponible_form.xml">Fecha Anticipo</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Estado xmlfile = "RepDisponible_form.xml">Estado</cf_translate></strong></td>
			<td ><strong><cf_translate key = LB_Total xmlfile = "RepDisponible_form.xml">Total</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Moneda xmlfile = "RepDisponible_form.xml">Moneda</cf_translate></strong></td>
		</tr>

		<cfloop query="rsRep1">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion, a.GEAfechaPagar,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparaci&oacute;n</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobaci&oacute;n</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Pagada xmlfile = "RepDisponible_form.xml">Pagada</cf_translate>'
						when  5 then '<cf_translate key = LB_Liquidada xmlfile = "RepDisponible_form.xml">Liquidada</cf_translate>'
                        when  6 then '<cf_translate key = LB_PCD xmlfile = "RepDisponible_form.xml">PCD</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep1.CCHTrelacionada#
				order by a.GEAfechaPagar
			</cfquery>

			<cfif rsAnt.recordcount gt 0>
			<cfset totA=rsAnt.GEAtotalOri>
			<cfoutput>
			<tr>
				<td>
					<a href="javascript:doConlis(#rsAnt.GEAid#,'A');">
							#rsAnt.GEAnumero#
					</a>
				</td>
				<td>#rsAnt.name#</td>
				<td>#rsAnt.GEAdescripcion#</td>
				<td align="center">#dateFormat(rsAnt.GEAfechaPagar,"DD/MM/YYYY")#</td>
				<td>#rsAnt.estado#</td>
				<td>#NumberFormat(rsAnt.GEAtotalOri,",0.00")#</td>
				<td>#rsAnt.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot=tot+totA>
			</cfif>
			<!--- <cfflush> --->
		</cfloop>
	</cfif>
	<cfif rsRep1.recordcount gt 0 or rsRep.recordcount gt 0>
		<tr>
			<td align="right" colspan="3" ><strong><cf_translate key = LB_TotalAnticipos xmlfile = "RepDisponible_form.xml">Total Anticipos</cf_translate>:</strong></td>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(LvarAnticipos, ",9.00")#</cfoutput></strong></td>
		</tr>
	</cfif>
	<tr>
	<cfif rsCCH.CCHtipo eq 2>
    	<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="7"><cf_translate key = LB_Rembolsos xmlfile = "RepDisponible_form.xml">Reembolsos</cf_translate></td>
        <tr><td align="right" colspan="3"><strong><cf_translate key = LB_TotalRembolsos xmlfile = "RepDisponible_form.xml">Total Reembolsos</cf_translate>:</strong></td>
        <td align="right" colspan="1"><strong><cfoutput>#NumberFormat(LvarReembolsos, ",9.00")#</cfoutput></strong></td></tr>
    	<tr><td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="7"><cf_translate key = LB_Devoluciones xmlfile = "RepDisponible_form.xml">Devoluciones</cf_translate></td>

	<cfelse>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="7"><cf_translate key = LB_Gastos xmlfile = "RepDisponible_form.xml">Gastos</cf_translate></td>
	</tr>
	<!---Liquidaciones sin reintegro--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong><cf_translate key = LB_LiquidacionesSinRegistro xmlfile = "RepDisponible_form.xml">Liquidaciones sin Reintegro</cf_translate></strong></td>
	</tr>
		<cfset tot1=0>
		<cfset dev=0>
		<cfset totF=0>
	<cfif rsRepG.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***<cf_translate key = LB_NoSeEncontraronRegistros xmlfile = "RepDisponible_form.xml">No se encontraron registros</cf_translate>***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong><cf_translate key = LB_NoLiquidacion xmlfile = "RepDisponible_form.xml">No. Liquidación</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Empleado xmlfile = "RepDisponible_form.xml">Empleado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Descripcion xmlfile = "RepDisponible_form.xml">Descripción</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Estado xmlfile = "RepDisponible_form.xml">Estado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Gastos xmlfile = "RepDisponible_form.xml">Gastos</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Moneda xmlfile = "RepDisponible_form.xml">Moneda</cf_translate></strong></td>
		</tr>

		<cfloop query="rsRepG">
			<cfquery name="rsGas" datasource="#session.dsn#">
				select
					a.GELnumero,a.TESBid,GELid,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GELdescripcion,
					coalesce(a.GELtotalAnticipos,0) as GELtotalAnticipos,
					coalesce(a.GELtotalGastos,0) as GELtotalGastos,
					coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones,
					coalesce(a.GELtotalDepositosEfectivo,0) as GELtotalDepositosEfectivo,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparación</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobación</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Finalizada xmlfile = "RepDisponible_form.xml">Finalizada</cf_translate>'
						when  5 then '<cf_translate key = LB_PorReintegrar xmlfile = "RepDisponible_form.xml">Por Reintegrar</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estadoL,
					a.Mcodigo
				from GEliquidacion a
				where GELid=#rsRepG.CCHTrelacionada#
			</cfquery>
			<cfif rsGas.recordcount gt 0>
			<cfoutput>
			<tr>
				<td>
					<a href="javascript:doConlis(#rsGas.GELid#,'L');">
							#rsGas.GELnumero#
					</a>
				</td>
				<td>#rsGas.name#</td>
				<td>#rsGas.GELdescripcion#</td>
				<td>#rsGas.estadoL#</td>
				<td>#NumberFormat(rsGas.GELtotalGastos,",0.00")#</td>
				<td>#rsGas.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot1=tot1+rsGas.GELtotalGastos>
			<cfif rsCCH.CCHtipo eq 2>
				<cfset dev=dev+rsGas.GELtotalDepositosEfectivo>
			<cfelse>
				<cfset dev=dev+rsGas.GELtotalDevoluciones>
			</cfif>
			</cfif>
			<!--- <cfflush> --->
		</cfloop>
	</cfif>
	<!---Liquidaciones asociadas a un reintegro--->
	<!---Liquidaciones sin reintegro--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong><cf_translate key = LB_LiquidacionesConReintegroSinEmitir xmlfile = "RepDisponible_form.xml">Liquidaciones con Reintegro sin Emitir</cf_translate></strong></td>
	</tr>
	<cfif rsRepG1.recordcount eq 0>
		<tr>
			<td colspan="6" align="center">***<cf_translate key = LB_NoSeEncontraronRegistros xmlfile = "RepDisponible_form.xml">No se encontraron registros</cf_translate>***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong><cf_translate key = LB_NoLiquidacion xmlfile = "RepDisponible_form.xml">No. Liquidación</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Empleado xmlfile = "RepDisponible_form.xml">Empleado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Descripcion xmlfile = "RepDisponible_form.xml">Descripción</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Estado xmlfile = "RepDisponible_form.xml">Estado</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Gastos xmlfile = "RepDisponible_form.xml">Gastos</cf_translate></strong></td>
			<td><strong><cf_translate key = LB_Moneda xmlfile = "RepDisponible_form.xml">Moneda</cf_translate></strong></td>
		</tr>

		<cfloop query="rsRepG1">
			<cfquery name="rsGas" datasource="#session.dsn#">
				select
					a.GELnumero,a.TESBid,GELid,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GELdescripcion,
					coalesce(a.GELtotalAnticipos,0) as GELtotalAnticipos,
					coalesce(a.GELtotalGastos,0) as GELtotalGastos,
					coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones,
					coalesce(a.GELtotalDepositosEfectivo,0) as GELtotalDepositosEfectivo,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then '<cf_translate key = LB_EnPreparacion xmlfile = "RepDisponible_form.xml">En Preparación</cf_translate>'
						when  1 then '<cf_translate key = LB_EnAprobacion xmlfile = "RepDisponible_form.xml">En Aprobación</cf_translate>'
						when  2 then '<cf_translate key = LB_Aprobada xmlfile = "RepDisponible_form.xml">Aprobada</cf_translate>'
						when  3 then '<cf_translate key = LB_Rechazada xmlfile = "RepDisponible_form.xml">Rechazada</cf_translate>'
						when  4 then '<cf_translate key = LB_Finalizada xmlfile = "RepDisponible_form.xml">Finalizada</cf_translate>'
						when  5 then '<cf_translate key = LB_PorReintegrar xmlfile = "RepDisponible_form.xml">Por Reintegrar</cf_translate>'
						else '<cf_translate key = LB_EstadoDesconocido xmlfile = "RepDisponible_form.xml">Estado desconocido</cf_translate>'
						end as estadoL,
					a.Mcodigo
				from GEliquidacion a
				where GELid=#rsRepG1.CCHTrelacionada#
			</cfquery>
			<cfif rsGas.recordcount gt 0>
			<cfoutput>
			<tr>
				<td>
				<a href="javascript:doConlis(#rsGas.GELid#,'L');">
							#rsGas.GELnumero#
					</a>
				</td>
				<td>#rsGas.name#</td>
				<td>#rsGas.GELdescripcion#</td>
				<td>#rsGas.estadoL#</td>
				<td>#NumberFormat(rsGas.GELtotalGastos,",0.00")#</td>
				<td>#rsGas.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot1=tot1+rsGas.GELtotalGastos>
			<cfif rsCCH.CCHtipo eq 2>
				<cfset dev=dev+rsGas.GELtotalDepositosEfectivo>
			<cfelse>
				<cfset dev=dev+rsGas.GELtotalDevoluciones>
			</cfif>
			</cfif>
			<!--- <cfflush> --->
		</cfloop>
	</cfif>
	</cfif>
	<cfif rsRepG1.recordcount gt 0 or rsRepG.recordcount gt 0>
		<tr>
		  <cfif rsCCH.CCHtipo eq 2>
			<td align="right" colspan="3"><strong><cf_translate key = LB_TotalDevoluciones xmlfile = "RepDisponible_form.xml">Total Devoluciones</cf_translate>:</strong></td>
			<cfelse>
			<td align="right" colspan="3"><strong><cf_translate key = LB_TotalGastos xmlfile = "RepDisponible_form.xml">Total Gastos</cf_translate>:</strong></td>
			</cfif>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(LvarDevoluciones, ",9.00")#</cfoutput></strong></td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr>
			<td align="right" colspan="3"><strong><cf_translate key = LB_Disponible xmlfile = "RepDisponible_form.xml">Disponible</cf_translate>:</strong></td>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(LvarDisponible, ",9.00")#</cfoutput></strong></td>
		</tr>
	</cfif>
</table>



<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(id,tipo){
<cfoutput>
	popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/RepDisponible_popUp.cfm?id="+id+"&transac="+tipo,350,250,800,500);
</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

function funcfiltro(){
<cfoutput>
	document.detAFVR.action='inconsistencias_form.cfm';
	document.detAFVR.submit();
</cfoutput>
}
</script>

