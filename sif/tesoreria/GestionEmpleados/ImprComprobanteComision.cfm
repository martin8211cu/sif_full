<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_TituloImpresionLiquidacion" default = "Comprobaci&oacute;n de Viaticos por Comisi&oacute;n a Empleados" returnvariable="LB_TituloImpresionLiquidacion" xmlfile = "ImprComprobanteComision.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_MonedaLocal" default = "M.N" returnvariable="LB_MonedaLocal" xmlfile = "ImprComprobanteComision.xml">
<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_MonedaExtranjera" default = "DLS" returnvariable="LB_MonedaExtranjera" xmlfile = "ImprComprobanteComision.xml">

<!---Desarrollado  por Israel Rodríguez Ruiz Enero 2012--->
<!--- Se modifica la parte de las Firmas, de acuerdo a la Solicitud.
La comprobación de viáticos debe estar autorizada por el Director del Área
En caso de que el titular de la Dirección sea el comisionado, la comprobación de viáticos debe estar autorizada por el Director General. 
En caso de que el comisionado sea el Director General, la comprobación de viáticos debe estar autorizada por el Director de Administración y Finanzas 08032012IRR. 
Se Realiza la siguiente Modificación  para que sea Considerada la OIC como Dirección para las firmas de Autorización 1640312IRR
Se Realiza la siguiente Modificación  para que las Subdirecciones dependientes de Dirección General sean tratadas como Dirección para las firmas de Autorización, se cambia la palabra prueba por Autoriza 10092012IRR
--->
<cfparam name="url.Tipo" default="">
<cfif isDefined("Url.GELid") and url.GELid NEQ "">
  <cfset form.GELid = Url.GELid>
</cfif>


<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<!---<cfthrow message="GECid #form.GECid# GELid #form.GECid# GEAid  #form.GEAid#">--->

<cf_htmlReportsHeaders 
	title="#LB_TituloImpresionLiquidacion#" 
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
    <cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
    </cfquery>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre, Miso4217
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- JMRV 09/10/2014. Inicio. Obtener Etiqueta de moneda (Miso4217) para moneda extranjera --->
		<cfif rsMoneda.Mcodigo eq rsMonedaLocal.Mcodigo>
			<cfset LB_MonedaExtranjera = '-'>
		<cfelse>
			<cfset LB_MonedaExtranjera = #rsMoneda.Miso4217#>
		</cfif>
	<!--- JMRV 09/10/2014. Fin. --->
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
	
	<cfquery name="rsGECid" datasource="#session.dsn#">
		select GELid, GECid, CFid from GEliquidacion where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="rsBeneficiario">
		select B.TESBeneficiario
		from GEcomision C
		inner join TESbeneficiario B on C.TESBid = B.TESBid 
		where C.GECid = #rsGECid.GECid# and B.DEid = (select de.DEid
						    from GEcomision c
							inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
							inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            			    inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			                where c.GECid = #rsGECid.GECid#
							and  c.Ecodigo = #session.Ecodigo# and ECFencargado = 1)
    </cfquery>
	<cfquery name="rsReporteTotal" datasource="#session.DSN#">
		select e.Edescripcion, li.Mcodigo,co.GECdescripcion as Destino, li.GECid, co.GECdestino, co.GECDid, cD.GECDdescripcion,
		convert(varchar(5),GECnumero)+'/'+convert(varchar(10),GELnumero) +'/'+convert(varchar(10),year(GELfecha)) as Referencia,
		convert(varchar(10),co.GECdesde,103) +' al '+ convert(varchar(10),co.GEChasta,103) as Periodo,
		convert(varchar(10),li.GELdesde,103) +' al '+ convert(varchar(10),li.GELhasta,103) as PeriodoReal,
		case co.GECtipo when 1 then 'Nacional' when 2 then 'Extranjero' when 3 then 'Ambos' end as TipoComision,
		GELtotalDepositosEfectivo,GELtotalTCE,GELtotalGastos,GELtotalAnticipos, co.GECobservacionesLiq, 
		co.GECobservacionesResultado, co.GECobservacionesExceso,GELhasta,GELdesde,GECtipo,
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
									  where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGECid.GECid#"> 
						        	  and c.Ecodigo = co.Ecodigo and ECFencargado = 1)
		  		 	 and cf.Ecodigo = co.Ecodigo and ECFencargado = 1)
			   when 'AREA DE ' then
                     (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
					  from  GEcomision c
    				  inner join CFuncional cf on c.CFid = cf.CFid 
					  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
					  inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
					  where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGECid.GECid#">
					  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					  and ECFencargado = 1)	 
       		   when 'SUBDIREC' then
                    (select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre 
                     from GEcomision c
                     inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
                     inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                     inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGECid.GECid#"> 
				  	 and c.Ecodigo = co.Ecodigo 
					 and ECFencargado = 1)
              when 'ORGANO I' then
              	    <cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
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
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGECid.GECid#"> 
				     and  c.Ecodigo = co.Ecodigo and ECFencargado = 1) 
		    	</cfif>    
			  when 'DIRECCIO' then
      <!--- <cfif rsGECid.CFid EQ 16 OR  rsGECid.CFid EQ 22 OR  rsGECid.CFid EQ 29 OR  rsGECid.CFid EQ 36 OR  rsGECid.CFid EQ 38>--->
				<cfif isdefined("rsBeneficiario") and rsBeneficiario.recordcount GT 0>
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
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGECid.GECid#"> 
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
    
     <cfset Aprueba = rsReporteTotal.Aprueba>
    <cfif rsReporteTotal.Aprueba EQ rsBeneficiario.TESBeneficiario>
		<cfquery name = "rsDirFin" datasource="#session.dsn#">
        	select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre --, cf.CFid, CFdescripcion
			from CFuncional cf 
			inner join EmpleadoCFuncional ef on ef.CFid = cf.CFid and ef.Ecodigo = cf.Ecodigo
            inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
			where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and ECFencargado = 1 and CFdescripcion like  'DIRECCION DE ADMINISTRACION Y FINANZAS'
        </cfquery>
        <cfset Aprueba = rsDirFin.Nombre>
	</cfif>
	
	<cfif rsReporteTotal.GELdesde EQ '' OR rsReporteTotal.GELhasta EQ ''>
		<cfset LvarPeriodoComision = rsReporteTotal.Periodo>
	<cfelse>
		<cfset LvarPeriodoComision = rsReporteTotal.PeriodoReal>
	</cfif>

	<cfquery name ="rsDetGasto" datasource="#session.dsn#">
		select li.GELid, GECdescripcion, liG.Mcodigo, sum(GELGtotalOri) as GELGtotalOri, sum(GELGtotal) as GELGtotal, sum(GELGmonto), 
		case when GECcomplemento in('37504002','37504004','37602002','37602004') then 'SC' else 'GC' end tipoGasto
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid 
		inner join GEconceptoGasto cG on liG.GECid=cG.GECid
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid, GECdescripcion, liG.Mcodigo,cG.GECcomplemento
	</cfquery>
	
	<cfquery name="rsIva" datasource="#session.dsn#">
		select li.GELid,  liG.Mcodigo, sum(GELGtotal) as iva
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
		<td colspan="5" align="center"><strong><cf_translate key = LB_ComprobacionGastos xmlfile = "ImprComprobanteComision.xml">COMPROBACION DE GASTOS</cf_translate> </strong></td>
	</tr>
</table>
<br/>
<table  width="100%" border="1">
	<tr>
		<td width="30%"><cf_translate key = LB_Referencia xmlfile = "ImprComprobanteComision.xml">Referencia</cf_translate>: <span class="style3">#rsReporteTotal.Referencia#</span></td>
		<td width="30%"><cf_translate key = LB_Fecha xmlfile = "ImprComprobanteComision.xml">Fecha</cf_translate>: <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span></td>
		<td width="40%"><cf_translate key = LB_Comisionado xmlfile = "ImprComprobanteComision.xml">Comisionado</cf_translate>: <span class="style3">#DatosEmpleado.TESBeneficiario#</span></td>
	</tr>
	<tr>
		<td width="30%"><cf_translate key = LB_Tipo xmlfile = "ImprComprobanteComision.xml">Tipo</cf_translate>: <span class="style3">#rsReporteTotal.TipoComision#</span></td>
		<td width="30%"><cf_translate key = LB_Periodo xmlfile = "ImprComprobanteComision.xml">Periodo</cf_translate>: <span class="style3">#LvarPeriodoComision#</span></td>
		<td width="40%"><cf_translate key = LB_Destino xmlfile = "ImprComprobanteComision.xml">Destino</cf_translate>: <span class="style3">#rsReporteTotal.GECdestino#</span></td>
	</tr>
</table>

<table border="1" width="100%">
		<tr >
			<td width="60%" ><cf_translate key = LB_Motivo xmlfile = "ImprComprobanteComision.xml">Motivo</cf_translate>: <span class="style3">#rsEncabezado.GELdescripcion#</span></td>
			<td width="40%"><cf_translate key = LB_CategoriaDestino xmlfile = "ImprComprobanteComision.xml">Categoria del Destino</cf_translate>: <span class="style3">#rsReporteTotal.GECDdescripcion#</span></td>
		</tr>	

</table>

<br />
<table width="100%" cellspacing="0">
	<tr>
		<td>
			<table width="69%" border="0" >
				<tr>
					<td width="63%" align="center"  style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><strong><cf_translate key = LB_GastosConComprobante xmlfile = "ImprComprobanteComision.xml">Gastos con Comprobante</cf_translate></strong></td>	
					<td width="6%" align="center">&nbsp;</td>
					<td width="31%" align="center"  style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><strong><cf_translate key = LB_GastosSinComprobante xmlfile = "ImprComprobanteComision.xml">Gastos sin Comprobante</cf_translate></strong></td>
				</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<td width="100%">
			<table width="69%" border="0" cellspacing="0" >
				<tr>
					<td width="29%" height="23" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><cf_translate key = LB_Concepto xmlfile = "ImprComprobanteComision.xml">Concepto</cf_translate></td>	
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> #LB_MonedaLocal#</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> #LB_MonedaExtranjera# </td>
					<td width="6%" align="center">&nbsp;</td>
					
					<td width="16%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> #LB_MonedaLocal#</td>
					<td width="15%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"> #LB_MonedaExtranjera# </td>
				</tr>
	<cfloop query="rsDetGasto">
				<tr>
					<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#rsDetGasto.GECdescripcion#</span></td>		 
	
					<cfif rsDetGasto.tipoGasto NEQ 'SC' or rsDetGasto.tipoGasto NEQ 'sc'> <!---Para Conceptos Con Comprobante--->
						<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo>
						<cfset LvarStMxpCc += rsDetGasto.GELGtotal>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotal,',9.00')#</span></td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<cfelse>
						<cfset LvarStUsdCc += rsDetGasto.GELGtotal>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotal,',9.00')#</span></td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						</cfif>					
					<cfelse> <!--- Para Conceptos Sin Comprobante--->
						<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo>
						<cfset LvarStMxpSc += rsDetGasto.GELGtotal>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotal,',9.00')#</span></td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<cfelse>
						<cfset LvarStUsdSc += rsDetGasto.GELGtotal>
						<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsDetGasto.GELGtotal,',9.00')#</span></td>
					</cfif>										
  			    </cfif>	
		</tr></cfloop>
				
			<cfif isdefined("rsIva") and rsIva.RecordCount GTE 1 and rsIva.iva GT 0>
				<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3"><cf_translate key = LB_IVA xml = "ImprComprobanteComision.xml">IVA</cf_translate></span></td>
				<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
					<cfset LvarStMxpCc += rsIva.iva>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				<cfelse>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
					<cfset LvarStUsdCc += rsIva.iva>
					<td width="6%" align="center">&nbsp;</td>					
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					<td width="17%" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
				</cfif>					
			</cfif>
				
				<tr>
					<td width="29%" height="23" align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;border-left-width: 1px; border-left-style: solid; border-left-color: gray;border-top-width: 1px; border-top-style: solid; border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;"><cf_translate key = LB_Subtotal xmlfile = "ImprComprobanteComision.xml">Subtotal</cf_translate></td>	
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
					<td width="50%" align="center" ><strong><cf_translate key = LB_DesglocePagos xmlfile = "ImprComprobanteComision.xml">Desglose de Pagos</cf_translate></strong></td>	
				</tr>
	  	  </table>
		</td>	
		
	</tr>
	<tr>
		<td>
			<table width="50%" border="1">
				<tr>
					<td width="40%" align="center"><cf_translate key = LB_TipoPago xmlfile = "ImprComprobanteComision.xml">Tipo de Pago</cf_translate></td>	
					<td width="30%" align="center"> #LB_MonedaLocal#</td>
					<td width="30%" align="center"> #LB_MonedaExtranjera# </td>
				</tr>
				<tr>
					<td><span class="style3"><cf_translate key = LB_Efectivo xmlfile = "ImprComprobanteComision.xml">Efectivo</cf_translate></span></td>
					<cfset LvarGastoEfectivo = rsReporteTotal.GELtotalGastos-rsReporteTotal.GELtotalTCE>
					<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo >
						<td align="center"><span class="style3">#LSNumberFormat(LvarGastoEfectivo,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(LvarGastoEfectivo,',9.00')#</span></td>
					</cfif>
				</tr>
				<tr>
					<td><span class="style3"><cf_translate key = LB_Tarjeta xmlfile = "ImprComprobanteComision.xml">Tarjeta</cf_translate></span></td>
					<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalTCE,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalTCE,',9.00')#</span></td>
					</cfif>	
				</tr>
				<tr>
					<td><span class="style3"><cf_translate key = LB_TotalGastos xmlfile = "ImprComprobanteComision.xml">Total Gastos</cf_translate></span></td>
					<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalGastos,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalGastos,',9.00')#</span></td>
					</cfif>
				</tr>
				<tr>
					<td><span class="style3"><cf_translate key = LB_Anticipos xmlfile = "ImprComprobanteComision.xml">Anticipo</cf_translate></span></td>
					<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo >
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalAnticipos,',9.00')#</span></td>
						<td>&nbsp;</td> 
					<cfelse>
						<td>&nbsp;</td>
						<td align="center"><span class="style3">#LSNumberFormat(rsReporteTotal.GELtotalAnticipos,',9.00')#</span></td>
						
					</cfif>
				</tr>
				<tr>					
					<cfset LvarSaldo = rsReporteTotal.GELtotalAnticipos-LvarGastoEfectivo>
					<cfif rsMoneda.Mcodigo EQ rsMonedaLocal.Mcodigo >						
							<cfif LvarSaldo LT 0>	
								<td><cf_translate key = LB_Rembolso xmlfile = "ImprComprobanteComision.xml">Reembolso</cf_translate></td>
								<td align="center">#LSNumberFormat(LvarSaldo*-1,',9.00')#</td>
							<cfelse>
								<td><cf_translate key = LB_Saldo xmlfile = "ImprComprobanteComision.xml">Saldo</cf_translate></td>
								<td align="center">#LSNumberFormat(LvarSaldo,',9.00')#</td>
							</cfif>						
							<td>&nbsp;</td> 
					<cfelse>
						
						
						<cfif LvarSaldo LT 0>	
							<td><cf_translate key = LB_Rembolso xmlfile = "ImprComprobanteComision.xml">Reembolso</cf_translate></td>
							<td>&nbsp;</td> 
							<td align="center">#LSNumberFormat(LvarSaldo*-1,',9.00')#</td>
						<cfelse>
							<td><cf_translate key = LB_Saldo xmlfile = "ImprComprobanteComision.xml">Saldo</cf_translate></td>
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
		<td><span class="style3"><strong><cf_translate key = LB_Observaciones xmlfile = "ImprComprobanteComision.xml">Observaciones</cf_translate>: </strong>#rsReporteTotal.GECobservacionesLiq#</strong></span></td>
	</tr>	
</table>
<br />
<span class="style3"><strong><cf_translate key = LB_Resultados xmlfile = "ImprComprobanteComision.xml">Resultados: Explique brevemente los resultados obtenidos o eventos realizados durante la Comisión</cf_translate>: </strong><span class="style3">
<table width="100%" border="1">
	<tr>
		<td><span class="style3">#rsReporteTotal.GECobservacionesResultado#<span class="style3"></td>
	</tr>
</table>
  <br />
    <span class="style3"><strong><cf_translate key = LB_EnCasoDeHaberExcedidoLasTarifasAutorizadasExpliqueLosMotivos xmlfile = "ImprComprobanteComision.xml">En caso de haber excedido las tarifas autorizadas. Explique los motivos</cf_translate></strong></span>  
	<table width="100%" border="1">
	<tr>
		<td><span class="style3">#rsReporteTotal.GECobservacionesExceso#</span></td>
	</tr>
</table>
  <br />
   <!--- <span class="style3"><strong>EL comisionado manifiesta bajo  protesta de decir verdad,  que las fechas arriba indicadas constituyen el período de la Comisión</strong></span>
   <span class="style3"><strong><cf_translate key = LB_ElComisionadoManifiestaQueLaInformacion xmlfile = "ImprComprobanteComision.xml">El comisionado manifiesta que la información y documentación presentadas es verdadera y concuerdan fielmente con los gastos reales realizados en esta comisión laboral.</cf_translate></strong></span>
--->
   <span class="style3"><strong><cf_translate key = LB_ElComisionadoManifiestaQueLaInformacion xmlfile = "ImprComprobanteComision.xml">El comisionado manifiesta que la información y documentación presentadas en la presente comprobación son verdaderas y concuerdan fielmente con los gastos realizados en esta comisión laboral en estricto apego a las Normas vigentes que regulan los viáticos y otros gastos de viaje.</cf_translate></strong></span>

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
						<td  align="center">#DatosEmpleado.TESBeneficiario# </td>
						<!---<cfif rsReporteTotal.GECtipo EQ 2>
						<td  align="center">#rsReporteTotal.Autoriza#</td>--->
						
						<!---<cfelse>--->
						<td  align="center">#Aprueba#</td>
						<!---</cfif>--->
					</tr>
					<tr>
						<td  align="center"><strong>&nbsp;<cf_translate key = LB_Comisionado xmlfile = "ImprComprobanteComision.xml">Comisionado</cf_translate>&nbsp; </strong></td>
						<td  align="center"><strong>&nbsp;<cf_translate key = LB_Autoriza xmlfile = "ImprComprobanteComision.xml">Autoriza</cf_translate>&nbsp;</strong></td>
						
					</tr>
</table>


</cfoutput>
 </cfif>       
