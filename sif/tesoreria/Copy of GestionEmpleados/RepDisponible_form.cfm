<cf_htmlReportsHeaders 
	title="Disponible de Caja Chica" 
	filename="Disponible.xls"
	irA="RepDisponible.cfm?regresar=1"
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
				and l.GELestado in (0,1,2,3,4,5)				
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
             and l.GELestado = 5 
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
	select CCHcodigo,CCHdescripcion 
	from CCHica 
	where CCHid =#form.CCHid#	
</cfquery>


<table width="100%" cellpadding="0" cellspacing="0"> 
<cfoutput>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong>#rsEmpresa.Edescripcion#</strong></td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong>Disponible de Caja Chica</strong></td>
	</tr>
	<tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
		<td align="center" valign="top" colspan="6"><strong>Caja Chica: #rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</strong></td>
	</tr>
</cfoutput>
<cfflush interval="20">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<cfset rsPieGraph = QueryNew("Monto,Porc")>
			<cfset QueryAddrow(rsPieGraph,3)>
			<cfset QuerySetCell(rsPieGraph,"Monto",rsTotal.disponible,1)>
			<cfset QuerySetCell(rsPieGraph,"Porc","Disponible",1)>
			<cfset QuerySetCell(rsPieGraph,"Monto",rsTotal.CCHIanticipos,2)>
			<cfset QuerySetCell(rsPieGraph,"Porc","Anticipos",2)>
			<cfset QuerySetCell(rsPieGraph,"Monto",rsTotal.CCHIgastos,3)>
			<cfset QuerySetCell(rsPieGraph,"Porc","Gastos",3)>
					
			<fieldset><legend><strong>Gráfico de montos</strong></legend>
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
		<td align="right" colspan="3"><strong>Total Asignado:</strong></td>
		<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(rsTotal.CCHImontoasignado, ",9.00")#</cfoutput></strong></td>
	</tr>
	<tr>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="6">Anticipos</td>
	</tr>
	<!---Anticipos sin Liquidar--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong>Anticipos Sin Liquidar</strong></td>
	</tr>
		<cfset tot=0>
	<cfif rsRep.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***No se encontraron registros***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong>No. Anticipo</strong></td>
			<td><strong>Empleado</strong></td>
			<td><strong>Descripción</strong></td>
			<td align="left" nowrap="nowrap"><strong>Estado</strong></td>
			<td><strong>Total</strong></td>
			<td><strong>Moneda</strong></td>
		</tr>
	
		<cfloop query="rsRep">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select 
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then 'En Preparaci&oacute;n'
						when  1 then 'En Aprobaci&oacute;n'
						when  2 then 'Aprobada'
						when  3 then 'Rechazada'
						when  4 then 'Pagada'
						when  5 then 'Liquidada' 
						else 'Estado desconocido'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep.CCHTrelacionada#
			
			</cfquery>
			
			<cfif rsAnt.recordcount gt 0>
			<cfset totA=rsAnt.GEAtotalOri*rsAnt.GEAmanual>
			<cfoutput>
			<tr>
				<td>
					<a href="javascript:doConlis(#rsAnt.GEAid#,'A');">
							#rsAnt.GEAnumero#
					</a>	
				</td>
				<td>#rsAnt.name#</td>
				<td>#rsAnt.GEAdescripcion#</td>
				<td align="left" nowrap="nowrap">#rsAnt.estado#</td>
				<td>#NumberFormat(rsAnt.GEAtotalOri,",0.00")#</td>
				<td>#rsAnt.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot=tot+totA>
			</cfif>
			<cfflush>
		</cfloop>
	</cfif>
	<!---Anticipo relacionados con alguna liquidacion--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong>Anticipos Liquidados</strong></td>
	</tr>
	<cfif rsRep1.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***No se encontraron registros***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong>No. Anticipo</strong></td>
			<td><strong>Empleado</strong></td>
			<td><strong>Descripción</strong></td>
			<td><strong>Estado</strong></td>
			<td ><strong>Total</strong></td>
			<td><strong>Moneda</strong></td>
		</tr>
	
		<cfloop query="rsRep1">
			<cfquery name="rsAnt" datasource="#session.dsn#">
				select 
					a.GEAnumero,a.TESBid,GEAid,a.GEAmanual,
					(select TESBeneficiario from TESbeneficiario where TESBid=a.TESBid) as name,
					a.GEAdescripcion,
					coalesce(a.GEAtotalOri,0) as GEAtotalOri,
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case a.GEAestado
						when  0 then 'En Preparaci&oacute;n'
						when  1 then 'En Aprobaci&oacute;n'
						when  2 then 'Aprobada'
						when  3 then 'Rechazada'
						when  4 then 'Pagada'
						when  5 then 'Liquidada' 
						else 'Estado desconocido'
						end as estado,
					a.Mcodigo
				from GEanticipo a
				where GEAid=#rsRep1.CCHTrelacionada#
			</cfquery>
			
			<cfif rsAnt.recordcount gt 0>
			<cfset totA=rsAnt.GEAtotalOri*rsAnt.GEAmanual>
			<cfoutput>
			<tr>
				<td>
					<a href="javascript:doConlis(#rsAnt.GEAid#,'A');">
							#rsAnt.GEAnumero#
					</a>	
				</td>
				<td>#rsAnt.name#</td>
				<td>#rsAnt.GEAdescripcion#</td>
				<td>#rsAnt.estado#</td>
				<td>#NumberFormat(rsAnt.GEAtotalOri,",0.00")#</td>
				<td>#rsAnt.Miso#</td>
			</tr>
			</cfoutput>
			<cfset tot=tot+totA>
			</cfif>
			<cfflush>
		</cfloop>
	</cfif>
	<cfif rsRep1.recordcount gt 0 or rsRep.recordcount gt 0>
		<tr>
			<td align="right" colspan="3" ><strong>Total Anticipos:</strong></td>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(tot, ",9.00")#</cfoutput></strong></td>
		</tr>
	</cfif>
	<tr>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="6">Gastos</td>
	</tr>
	<!---Liquidaciones sin reintegro--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong>Liquidaciones sin Reintegro</strong></td>
	</tr>
		<cfset tot1=0>
		<cfset dev=0>
		<cfset totF=0>
	<cfif rsRepG.recordcount eq 0>
		<tr>
			<td  colspan="6" align="center">***No se encontraron registros***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong>No. Liquidación</strong></td>
			<td><strong>Empleado</strong></td>
			<td><strong>Descripción</strong></td>
			<td><strong>Estado</strong></td>
			<td><strong>Gastos</strong></td>
			<td><strong>Moneda</strong></td>
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
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then 'En Preparación'
						when  1 then 'En Aprobación'
						when  2 then 'Aprobada'
						when  3 then 'Rechazada'
						when  4 then 'Finalizada'
						when  5 then 'Por Reintegrar'
						else 'Estado desconocido'
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
			<cfset dev=dev+rsGas.GELtotalDevoluciones>
			</cfif>
			<cfflush>
		</cfloop>
	</cfif>
	<!---Liquidaciones asociadas a un reintegro--->
	<!---Liquidaciones sin reintegro--->
	<tr class="listaPar">
		<td colspan="6" align="center"><strong>Liquidaciones con Reintegro sin Emitir</strong></td>
	</tr>
	<cfif rsRepG1.recordcount eq 0>
		<tr>
			<td colspan="6" align="center">***No se encontraron registros***</td>
		</tr>
	<cfelse>
		<tr>
			<td><strong>No. Liquidación</strong></td>
			<td><strong>Empleado</strong></td>
			<td><strong>Descripción</strong></td>
			<td><strong>Estado</strong></td>
			<td><strong>Gastos</strong></td>
			<td><strong>Moneda</strong></td>
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
					(select Miso4217 from Monedas where Mcodigo =a.Mcodigo) as Miso,
					case GELestado
						when  0 then 'En Preparación'
						when  1 then 'En Aprobación'
						when  2 then 'Aprobada'
						when  3 then 'Rechazada'
						when  4 then 'Finalizada'
						when  5 then 'Por Reintegrar'
						else 'Estado desconocido'
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
			<cfset dev=dev+rsGas.GELtotalDevoluciones>
			</cfif>
			<cfflush>
		</cfloop>
	</cfif>
	<cfif rsRepG1.recordcount gt 0 or rsRepG.recordcount gt 0>
		<tr>
			<td align="right" colspan="3"><strong>Total Gastos:</strong></td>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(tot1, ",9.00")#</cfoutput></strong></td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr>
			<td align="right" colspan="3"><strong>Disponible:</strong></td>
			<td align="right" colspan="1"><strong><cfoutput>#NumberFormat(rsTotal.CCHImontoasignado - tot - tot1, ",9.00")#</cfoutput></strong></td>
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

