<!---Este lo modifique yo--->
<cfparam name="url.Tipo" default="">
<cfif isDefined("Url.GELid") and url.GELid NEQ "">
  <cfset form.GELid = Url.GELid>
</cfif>


<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<!---<cfthrow message="GECid #form.GECid# GELid #form.GECid# GEAid  #form.GEAid#">--->

<cf_htmlReportsHeaders 
	title="Impresion de Liquidacion" 
	filename="Liquidacion.xls"
	irA="CaratulaCompViatComEmpForm.cfm"
	download="no"
	preview="no">


<style type="text/css">
<!--
.style3 {font-size: 12px}
-->
</style>

<cfif isdefined ('form.GELid') and form.GELid NEQ ''>
	<cf_dbfunction name="dateadd" args="a.GEADhoraini,a.GEADfechaini,MI" returnVariable="LvarFechaIni">
	<cf_dbfunction name="date_format" args="#LvarFechaIni#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaIni"	delimiters="°">
	<cf_dbfunction name="dateadd" args="a.GEADhorafin,a.GEADfechafin,MI" returnVariable="LvarFechaFin">
	<cf_dbfunction name="date_format" args="#LvarFechaFin#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaFin"	delimiters="°">
	<cf_dbfunction name="concat" args="#LvarFechaIni#¬' - '¬#LvarFechaFin#" returnVariable="LvarFechas"  	delimiters="¬">

	<cfquery name="rsAnticipos" datasource="#session.DSN#">
		select 
					a.GEAid,
					a.Linea,
					a.GEADid,
					a.GECid,
					b.GEAid,
					b.GEADid,
					b.GELAtotal,
					b.GELid,
					c.GEAfechaPagar,
					d.GECid,
					d.GECdescripcion,
					c.GEAnumero
					,c.GEAviatico
					,gep.GEPVdescripcion
					,gec.GECVdescripcion
					,gec.GECVid_Padre
					,#preserveSingleQuotes(LvarFechas)#    as fechas
			from 
				GEanticipoDet a
				inner join 	GEliquidacionAnts b
					on a.GEADid = b.GEADid
					and a.GEAid = b.GEAid
				inner join GEanticipo c
					on a.GEAid=c.GEAid
				inner join GEconceptoGasto d
					on d.GECid=a.GECid
				left join GEPlantillaViaticos gep 
 					on gep.GEPVid= a.GEPVid
				left join GEClasificacionViaticos gec 
					on gep.GECVid=gec.GECVid	
			where  b.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			order by a.GEADfechaini,a.GEADhoraini,gep.GEPVid
	</cfquery>
	<cfquery name="rsLiquidacion" datasource="#session.DSN#">
		select 
				a.GELGid,
				a.GELid,
				a.GELGfecha,
				a.GELGtotalOri,
				a.GECid,
				a.GELGtotal,
				a.GELGnumeroDoc,
				a.GELGproveedor,
				b.GECid,
				b.GECdescripcion,
				c.TESid,
				c.TESdescripcion
		from  GEliquidacionGasto a,
			 GEconceptoGasto b,
			 Tesoreria c
		where b.GECid=a.GECid
		and c.TESid= a.TESid
		and a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	
	
	<cfquery name="rsDeposito" datasource="#session.DSN#">
		select 
				a.GELid,
				a.GELDreferencia,
				a.CBid,
				a.GELDtotal,
				b.CBid,
				b.CBcodigo
		from
				GEliquidacionDeps a
					inner join CuentasBancos b
						on b.CBid=a.CBid
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
        	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
	</cfquery>
	<cfquery name="rsForm" datasource="#session.dsn#">
	select * from GEliquidacion where GELid=#form.GELid#
	</cfquery>
	<cfquery name="rsEncabezado" datasource="#session.DSN#">
		select
				l.GELid,
				l.TESBid,
				l.Mcodigo,
				l.GELfecha,
				l.GELtotalGastos,
				l.GELtotalDepositos,
				l.GELtotalAnticipos,
				l.GELreembolso,
				l.GELdescripcion,
				case l.GELestado
				when 0 then 'Preparacion'
				when 1 then 'En Aprobacion'
				when 2 then 'Aprobada'
				when 3 then 'Rechazada'
				when 4 then 'Finalizada'
				end as Titulo,
				l.GELtipoP,
				case l.GELtipoP
				when 0 then 'Caja Chica'
				when 1 then 'Tesorería'
				end as pago,
				l.GELtotalDevoluciones,
				m.Miso4217
		from GEliquidacion l
		inner join Monedas m
		on m.Mcodigo = l.Mcodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfif rsEncabezado.GELtipoP eq 0>
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CCHcodigo,CCHdescripcion from CCHica where CCHid =(select CCHid from GEliquidacion where GELid=#form.GELid#)		
		</cfquery>
	</cfif>
	
	<cfif rsForm.GEAviatico eq 1>
		<cf_dbfunction name="dateadd" args="gel.GELVhoraini,gel.GELVfechaini,MI" returnVariable="LvarFechaIni">
		<cf_dbfunction name="date_format" args="#LvarFechaIni#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaIni"	delimiters="°">
		<cf_dbfunction name="dateadd" args="gel.GELVhorafin,gel.GELVfechafin,MI" returnVariable="LvarFechaFin">
		<cf_dbfunction name="date_format" args="#LvarFechaFin#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaFin"	delimiters="°">
		<cf_dbfunction name="concat" args="#LvarFechaIni#¬' - '¬#LvarFechaFin#" returnVariable="LvarFechas"  		delimiters="¬">

		<cfquery name="rsLiquidacionesViatico" datasource="#session.dsn#">
			select 
				gep.GEPVid, gep.GEPVdescripcion, gec.GECVid, gec.GECVdescripcion,cg.GECdescripcion, gel.GELVfechaIni, gel.GELVfechaFin, 
				gel.GELVmontoOri, gel.GEPVmontoGastMV, gel.GELVtipoCambio, gel.GELVmonto,gel.GECid, gel.GELVid
				,gec.GECVid_Padre
				,#preserveSingleQuotes(LvarFechas)#    as fechas
		
				from GEliquidacionViaticos gel 
				
				inner join GEconceptoGasto cg
					on gel.GECid=cg.GECid
					
				left join GEPlantillaViaticos gep 
					on gep.GEPVid= gel.GEPVid 
		
				left join GEClasificacionViaticos gec 
					on gep.GECVid=gec.GECVid 
		
				left join Monedas mon 
					on mon.Mcodigo = gep.Mcodigo
					and mon.Ecodigo = gep.Ecodigo 
		
				where gel.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				order by gel.GELVfechaIni,gel.GELVhoraini,gep.GEPVid						
		</cfquery>
	</cfif>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.DSN#" name="DatosEmpleado">
		select 
				TESBeneficiario,
				TESBeneficiarioId
		from TESbeneficiario
		where  TESBid=#rsEncabezado.TESBid#
	</cfquery>
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo,
				ts_rversion
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!---<cfquery name="rsGECid" datasource="#session.dsn#">
		select GELid, GECid from GEliquidacion where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>--->
	
	<cfquery name="rsReporteTotal" datasource="#session.DSN#">
		select e.Edescripcion, li.Mcodigo,co.GECdescripcion as Destino, li.GECid, co.GECdestino, co.GECDid, cD.GECDdescripcion,
		convert(varchar(5),GECnumero)+'/'+convert(varchar(10),GELnumero) +'/'+convert(varchar(10),year(GELfecha)) as Referencia,
		convert(varchar(10),co.GECdesde,103) +' al '+ convert(varchar(10),co.GEChasta,103) as Periodo,
		convert(varchar(10),li.GELdesde,103) +' al '+ convert(varchar(10),li.GELhasta,103) as PeriodoReal,
		case co.GECtipo when 1 then 'Nacional' when 2 then 'Extranjero' when 3 then 'Ambos' end as TipoComision,
		GELtotalDepositosEfectivo,GELtotalTCE,GELtotalGastos,GELtotalAnticipos, co.GECobservacionesLiq, 
		co.GECobservacionesResultado, co.GECobservacionesExceso,GELhasta,GELdesde,
		case when GECtipo = 1 or GECtipo = 2 or GECtipo = 3 
     		then (select case substring(CFdescripcion,1,8) 
       			when 'GERENCIA' then
	  				(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
					 from CFuncional cf 
					 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
					 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
					 where cf.CFid = (select distinct CFidresp from GEcomision c
			   						  inner join CFuncional cf on c.CFid = cf.CFid and c.Ecodigo = cf.Ecodigo
									  inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp  and ef.Ecodigo = cf.Ecodigo
									  where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GECid#"> 
						        	  and c.Ecodigo = co.Ecodigo and ECFencargado = 1)
		  		 	 and cf.Ecodigo = co.Ecodigo and ECFencargado = 1)
       		   when 'SUBDIREC' then
                    (select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
                     from GEcomision c
                     inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
                     inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                     inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GECid#"> 
				  	 and c.Ecodigo = co.Ecodigo 
					 and ECFencargado = 1)
			  when 'DIRECCIO' then
                 <cfif isdefined("DatosEmpleado") and DatosEmpleado.recordcount GT 0>
					(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
				     from CFuncional cf 
					 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            		 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			         where cf.Ecodigo = co.Ecodigo and ECFencargado = 1 and CFdescripcion like 
					'DIRECCION GENERAL')
			    <cfelse>
					(select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
					 from GEcomision c
					 inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
					 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            		 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLiquidacion.GECid#"> 
				     and  c.Ecodigo = co.Ecodigo and ECFencargado = 1)
		    	</cfif>
					end from CFuncional where CFid = co.CFid)
    end as Aprueba,
		case when GECtipo = 1 then ''
			when GECtipo = 2 or GECtipo = 3 then (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
				      from CFuncional cf 
				      inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            		  inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			          where cf.Ecodigo = co.Ecodigo and ECFencargado = 1 and CFdescripcion like 'DIRECCION GENERAL') 
		end as Autoriza	
		from GEliquidacion li
		inner join GEcomision co on li.GECid = co.GECid
		left join Empresas e on e.Ecodigo=li.Ecodigo
		left join GEcategoriaDestino cD on co.GECDid = cD.GECDid
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	
	<cfif rsReporteTotal.GELdesde EQ '' OR rsReporteTotal.GELhasta EQ ''>
		<cfset LvarPeriodoComision = rsReporteTotal.Periodo>
	<cfelse>
		<cfset LvarPeriodoComision = rsReporteTotal.PeriodoReal>
	</cfif>

	<cfquery name ="rsDetGasto" datasource="#session.dsn#">
		select li.GELid, GECdescripcion, liG.Mcodigo, sum(GELGtotalOri) as GELGtotalOri, sum(GELGtotal), sum(GELGmonto), 
		case when GECcomplemento in('37504002','37504004','37602002','37602004') then 'SC' else 'GC' end tipoGasto
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid 
		inner join GEconceptoGasto cG on liG.GECid=cG.GECid
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid, GECdescripcion, liG.Mcodigo,cG.GECcomplemento
	</cfquery>
	
	<cfquery name="rsIva" datasource="#session.dsn#">
		select li.GELid,  liG.Mcodigo, sum(GELGtotalOri) as iva
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid
		inner join GEcomision co on li.GECid=co.GECid
		where Icodigo  is not null 
		and li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid,  liG.Mcodigo
	</cfquery>
<!---<cfthrow message="aprueba  #rsReporteTotal.Aprueba#	">--->

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
		
<cfset LvarStMxpCC = 0>
<cfset LvarStUsdCC = 0>
<cfset LvarStMxpSC = 0>
<cfset LvarStUsdSC = 0>
		
<cfoutput>

		<table width="100%" border="0">
	<tr>
		<td colspan="5" align="center">
			<strong>#rsReporteTotal.Edescripcion#</strong>
		</td>
	</tr>
		<tr>
		<td colspan="5" align="center"><strong>COMPROBACION DE GASTOS </strong></td>
	</tr>
</table>
<br/>
<table  width="100%" border="1">
	<tr>
		<td width="30%">Referencia: <span class="style3">#rsReporteTotal.Referencia#</span></td>
		<td width="30%">Fecha: <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span></td>
		<td width="40%">Comisionado: <span class="style3">#DatosEmpleado.TESBeneficiario#</span></td>
	</tr>
	<tr>
		<td width="30%">Tipo: <span class="style3">#rsReporteTotal.TipoComision#</span></td>
		<td width="30%">Periodo: <span class="style3">#LvarPeriodoComision#</span></td>
		<td width="40%">Destino: <span class="style3">#rsReporteTotal.GECdestino#</span></td>
	</tr>
</table>

<table border="1" width="100%">
		<tr >
			<td width="60%" >Motivo: <span class="style3">#rsEncabezado.GELdescripcion#</span></td>
			<td width="40%">Categoria del Destino: <span class="style3">#rsReporteTotal.GECDdescripcion#</span></td>
		</tr>	

</table>

<br />
<table width="100%" cellspacing="0">
	<tr>
		<td>
			<table width="69%" border="0" >
				<tr>
					<td width="63%" align="center"  style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><strong>Gastos con Comprobante</strong></td>	
					<td width="6%" align="center">&nbsp;</td>
					<td width="31%" align="center"  style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><strong>Gastos sin Comprobante</strong></td>
				</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<td width="100%">
			<table width="69%" border="0" cellspacing="0" >
				<tr>
					<td width="29%" height="23" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">Concepto</td>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> M.N</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> DLS </td>
					<td width="6%" align="center">&nbsp;</td>
					
					<td width="16%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> M.N</td>
					<td width="15%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> DLS </td>
				</tr>
	<cfloop query="rsDetGasto">
				<tr>
					<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#rsDetGasto.GECdescripcion#</span></td>		 
	
					<cfif rsDetGasto.tipoGasto NEQ 'SC' or rsDetGasto.tipoGasto NEQ 'sc'> <!---Para Conceptos Con Comprobante--->
						<cfif rsDetGasto.Mcodigo EQ 32>
						<cfset LvarStMxpCc += rsDetGasto.GELGtotalOri>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotalOri,',9.00')#</span></td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<cfelse>
						<cfset LvarStUsdCc += rsDetGasto.GELGtotalOri>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotalOri,',9.00')#</span></td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						</cfif>					
					<cfelse> <!--- Para Conceptos Sin Comprobante--->
						<cfif rsDetGasto.Mcodigo EQ 32>
						<cfset LvarStMxpSc += rsDetGasto.GELGtotalOri>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotalOri,',9.00')#</span></td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<cfelse>
						<cfset LvarStUsdSc += rsDetGasto.GELGtotalOri>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotalOri,',9.00')#</span></td>
					</cfif>										
  			    </cfif>	
		</cfloop>
				</tr>
			<cfif isdefined("rsIva") and rsIva.RecordCount GT 1 and rsIva.iva GT 0>
				<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">IVA</span></td>
				<cfif rsIva.Mcodigo EQ 32>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				<cfelse>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>					
			</cfif>
				
				<tr>
					<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">Subtotal</td>	
				<cfif LvarStMxpCc GT 1>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#LSNumberFormat(LvarStMxpCc,',9.00')#</td>
				<cfelse>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>	
				<cfif LvarStUsdCc GT 1>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#LSNumberFormat(LvarStUsdCc,',9.00')#</td>
				<cfelse>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>	
			<td width="6%" align="center">&nbsp;</td>
				<cfif LvarStMxpSc GT 1>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#LSNumberFormat(LvarStMxpSc,',9.00')#</td>
				<cfelse>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>	
				<cfif LvarStUsdSC GT 1>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#LSNumberFormat(LvarStUsdSC,',9.00')#</td>
				<cfelse>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>					
		  </table>
		</td>
	</tr>			

	<tr>
		<td>
			<table width="100%" >
				<tr>
					<td width="100%" align="center">&nbsp;</td>	
				</tr>	
				<tr>
					<td width="100%" align="center">&nbsp;</td>	
				</tr>
				
			</table>
		</td>
	</tr>
	<br />
	<tr>
		<td>
			<table width="50%" border="1">
				<tr>
					<td width="50%" align="center" ><strong>Desglose de Pagos</strong></td>	
				</tr>
	  	  </table>
		</td>	
		
	</tr>
	<tr>
		<td>
			<table width="50%" border="1">
				<tr>
					<td width="40%" align="center">Tipo de Pago </td>	
					<td width="30%" align="center"> M.N</td>
					<td width="30%" align="center"> DLS </td>
				</tr>
				<tr>
					<td><span class="style3">Efectivo</span></td>
					<cfset LvarGastoEfectivo = rsReporteTotal.GELtotalGastos-rsReporteTotal.GELtotalTCE>
					<cfif rsMoneda.Mcodigo EQ 32 >
						<td align="center"><span class="style3">#LSNumberFormat(LvarGastoEfectivo,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(LvarGastoEfectivo,',9.00')#</span></td>
					</cfif>
				</tr>
				<tr>
					<td><span class="style3">Tarjeta</span></td>
					<cfif rsMoneda.Mcodigo EQ 32 >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalTCE,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalTCE,',9.00')#</span></td>
					</cfif>	
				</tr>
				<tr>
					<td><span class="style3">Total Gastos</span></td>
					<cfif rsMoneda.Mcodigo EQ 32 >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalGastos,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalGastos,',9.00')#</span></td>
					</cfif>
				</tr>
				<tr>
					<td><span class="style3">Anticipo</span></td>
					<cfif rsMoneda.Mcodigo EQ 32 >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalAnticipos,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalAnticipos,',9.00')#</span></td>
						
					</cfif>
				</tr>
				<tr>					
					<cfset LvarSaldo = rsReporteTotal.GELtotalAnticipos-LvarGastoEfectivo>
					<cfif rsMoneda.Mcodigo EQ 32 >						
							<cfif LvarSaldo LT 0>	
								<td>Reembolso</td>
								<td align="center">#LSNumberFormat(LvarSaldo*-1,',9.00')#</td>
							<cfelse>
								<td>Saldo</td>
								<td align="center">#LSNumberFormat(LvarSaldo,',9.00')#</td>
							</cfif>						
							<td>&nbsp;</td> 
					<cfelse>
						
						
						<cfif LvarSaldo LT 0>	
							<td>Reembolso</td>
							<td>&nbsp;</td> 
							<td align="center">#LSNumberFormat(LvarSaldo*-1,',9.00')#</td>
						<cfelse>
							<td>Saldo</td>
							<td>&nbsp;</td> 
							<td align="center">#LSNumberFormat(LvarSaldo,',9.00')#</td>
						</cfif>
						
					</cfif>
				</tr>
				
		  	</table>
		</td>	
		
	</tr>

</table>

<table width="100%"  border="1" >
	<tr>
		<td><span class="style3"><strong>Observaciones: </strong>#rsReporteTotal.GECobservacionesLiq#</strong></span></td>
	</tr>	
</table>
<br />
<span class="style3"><strong>Resultados: Explique brevemente los resultados obtenidos o eventos realizados durante la Comisión: </strong><span class="style3">
<table width="100%" border="1">
	<tr>
		<td><span class="style3">#rsReporteTotal.GECobservacionesResultado#<span class="style3"></td>
	</tr>
</table>
  <br />
    <span class="style3"><strong>En caso de haber excedido las tarifas autorizadas. Explique los motivos </strong></span>  
	<table width="100%" border="1">
	<tr>
		<td><span class="style3">#rsReporteTotal.GECobservacionesExceso#</span></td>
	</tr>
</table>
  <br />
    <span class="style3"><strong>EL comisionado manifiesta bajo  protesta de decir verdad,  que las fechas arriba indicadas constituyen el período de la Comisión</strong></span>
    </p>
      <br />
    </p>
  <table width="100%">
					<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
					</tr>
					<tr>
						<td width="30%" align="center">____________________________________</td>
						<td width="40%" align="center">____________________________________</td>
						
					</tr>
					<tr>
						<td  align="center">#DatosEmpleado.TESBeneficiario#</td>
						<td  align="center">#rsReporteTotal.Aprueba#</td>
						
					</tr>
					<tr>
						<td  align="center"><strong>&nbsp;Comisionado&nbsp; </strong></td>
						<td  align="center"><strong>&nbsp;Aprueba&nbsp;</strong></td>
						
					</tr>
</table>


</cfoutput>
 </cfif>       
