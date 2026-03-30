<!---Modificado por Israel Rodríguez Ruiz Enero 2012--->
<!--- Se modifica la parte de las Firmas, de acuerdo a la Solicitud.
La comprobación de viáticos debe estar autorizada por el Director del Área
En caso de que el titular de la Dirección sea el comisionado, la comprobación de viáticos debe estar autorizada por el Director General.
En caso de que el comisionado sea el Director General, la comprobación de viáticos debe estar autorizada por el Director de Administración y Finanzas.
Se eliminan  las firmas de Comisionado  y  de Autorizacion  del  Reporte de Liquidacion 08032012IRR
Se Realiza la siguiente Modificación  para que sea Considerada la OIC como Dirección para las firmas de Autorización 160312IRR
--->


<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Impresi&oacute;n de Liquidaci&oacute;n" returnvariable="LB_Titulo" xmlfile ="LiquidacionImpresion_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Archivo" default="Liquidacion" returnvariable="LB_Archivo"
xmlfile ="LiquidacionImpresion_form.xml"/>

<cfparam name="url.Tipo" default="">
<cfif isDefined("Url.GELid") and url.GELid NEQ "">
  <cfset form.GELid = Url.GELid>
</cfif>
<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<cf_htmlReportsHeaders
	title="#LB_Titulo#"
	filename="#LB_Archivo#.xls"
	irA="../../../home/menu/modulo.cfm?s=SIF&m=GE"
	download="no"
	preview="no">


<style type="text/css">
<!--
.style3 {font-size: 10px}
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
				a.GELGreferencia,
				b.GECid,
				b.GECdescripcion,
				c.TESid,
				c.TESdescripcion,
		        d.GELTreferencia as Voucher,
				e.GETtipo,
				e.GETdescripcion
		from  GEliquidacionGasto a
              inner join  GEconceptoGasto b on b.GECid=a.GECid
			  inner join  Tesoreria c on c.TESid= a.TESid
              left join   GEliquidacionTCE d  on a.GELGid=d.GELGid
			  inner join GEtipoGasto e on e.GETid=b.GETid
		where  a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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
				l.GELnumero,
				l.TESBid,
				l.Mcodigo,
				l.GELfecha,
				l.GELtotalGastos,
				l.GELtotalDepositos,
				l.GELtotalAnticipos,
				l.GELreembolso,
				l.GELdescripcion,
				case l.GELestado
				when 0 then 'Preparacin'
				when 1 then 'En Aprobacin'
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
				m.Miso4217,
				isnull(l.GECid,-1) GECid,
				GECnumero,
				GECdescripcion,
				GECobservacionesLiq,
				GECobservacionesResultado,
				GECobservacionesExceso,
				co.GECdestino,
				GECDdescripcion,
				GECDmonto,
				l.GELdesde,
				l.GELhasta,
				PeriodoCom = convert(varchar(10),co.GECdesde,103)+' al '+convert(varchar(10),co.GEChasta,103),
				convert(varchar(10),l.GELdesde,103) +' al '+ convert(varchar(10),l.GELhasta,103) as PeriodoReal,
				case  convert(int,co.GEChasta)-convert(int,co.GECdesde) +1
					when  1 then GECDmonto * 0.5
					else GECDmonto * (convert(int,co.GEChasta)-convert(int,co.GECdesde) +1 )
				end as montoMaxCom,
				convert(int,co.GEChasta)-convert(int,co.GECdesde)+1  as DiasCom,
				convert(int,l.GELhasta)-convert(int,l.GELdesde)+1  as DiasComliq,
				case  convert(int,l.GELhasta)-convert(int,l.GELdesde) +1
					when  1 then GECDmonto * 0.5
					else GECDmonto * (convert(int,l.GELhasta)-convert(int,l.GELdesde) +1 )
				end as montoMax
		from GEliquidacion l
		inner join Monedas m on m.Mcodigo = l.Mcodigo
		left join GEcomision co on l.GECid = co.GECid
		left join GEcategoriaDestino cD on co.GECDid = cD.GECDid
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>

	<cfif rsEncabezado.GELdesde EQ '' OR rsEncabezado.GELhasta EQ ''>
		<cfset LvarPeriodoComision = rsEncabezado.PeriodoCom>
		<cfset LvarDiasComision = rsEncabezado.DiasCom>
		<cfset LvarMontoMaxComision = rsEncabezado.montoMaxCom>
	<cfelse>
		<cfset LvarPeriodoComision = rsEncabezado.PeriodoReal>
		<cfset LvarDiasComision = rsEncabezado.DiasComliq>
		<cfset LvarMontoMaxComision = rsEncabezado.montoMax>
	</cfif>

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
	

	<cfquery name="rsIva" datasource="#session.dsn#">
		select li.GELid,  liG.Mcodigo, sum(GELGtotalOri) as iva, liG.GELGnumeroDoc, li.GELfecha
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid
		inner join GEcomision co on li.GECid=co.GECid
		where Icodigo  is not null
		and li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid, liG.Mcodigo, liG.GELGnumeroDoc, li.GELfecha
	</cfquery>
		<cfquery name="rsGECid" datasource="#session.dsn#">
		select GELid, ISNULL(GECid,-1) as GECid, CFid from GEliquidacion where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfquery name="rsIvaCajaC" datasource="#session.dsn#">
		select li.GELid,  liG.Mcodigo, sum(GELGtotalOri) as iva, liG.GELGnumeroDoc, li.GELfecha
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid
		where Icodigo  is not null
		and li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid, liG.Mcodigo, liG.GELGnumeroDoc, li.GELfecha
	</cfquery>
		<cfquery name="rsGECid" datasource="#session.dsn#">
		select GELid, ISNULL(GECid,-1) as GECid, CFid from GEliquidacion where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfquery name="rsRet" datasource="#session.dsn#">
		select sum(liG.GELGtotalRet) as monto
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		and liG.GELGtotalRet > 0
		group by li.GELid, liG.Mcodigo, liG.GELGnumeroDoc, li.GELfecha
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
	
	<cfquery name="rsFirmas" datasource="#session.dsn#">
		select GECtipo, li.CFid, case when GECtipo = 1 or GECtipo = 2 or GECtipo = 3
     		then (select case substring(CFdescripcion,1,8)
       			when 'GERENCIA' then
	  				(select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
					 from CFuncional cf
					 inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
					 inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = cf.Ecodigo
					 where cf.CFid = (select distinct CFidresp from GEcomision c
			   						  inner join CFuncional cf on c.CFid = cf.CFid and c.Ecodigo = cf.Ecodigo
									  inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp  and ef.Ecodigo = cf.Ecodigo
									  where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.GECid#">
						        	  and c.Ecodigo = co.Ecodigo and ECFencargado = 1)
		  		 	 and cf.Ecodigo = co.Ecodigo and ECFencargado = 1)
			   when 'AREA DE ' then
                     (select de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
					  from  GEcomision c
					  inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = 1
					  inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
					  inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
					  where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.GECid#">
					  and c.Ecodigo = 1 and ECFencargado = 1)
       		   when 'SUBDIREC' then
                    (select distinct de.DEapellido1+' '+de.DEapellido2+' '+de.DEnombre as Nombre
                     from GEcomision c
                     inner join CFuncional cf on c.CFid = cf.CFid and cf.Ecodigo = c.Ecodigo
                     inner join EmpleadoCFuncional ef on ef.CFid = cf.CFidresp and ef.Ecodigo = cf.Ecodigo
                     inner join DatosEmpleado de on de.DEid = ef.DEid and ef.Ecodigo = c.Ecodigo
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.GECid#">
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
			         where c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.GECid#">
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
		left join GEcomision co on li.GECid = co.GECid
		left join Empresas e on e.Ecodigo=li.Ecodigo
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
    <cfset Aprueba = rsFirmas.Aprueba>
    <cfif rsFirmas.Aprueba EQ rsBeneficiario.TESBeneficiario>
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
			<td rowspan="6">
			  <cfinvoke
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
					<cfoutput>
						<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="120" width="200" />
					</cfoutput>
			</td>
			<td align="left">
<tr>
				<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
</tr>
			<tr>
				<td align="center" valign="top" colspan="8"><strong><cf_translate key=LB_SistGastosEmp>Sistema de Gastos de Empleado</cf_translate></strong></td>
			</tr>
			<tr>
				<td align="center" colspan="8" nowrap="nowrap"> <strong><cf_translate key=LB_Empleado>Empleado</cf_translate>:&nbsp;#DatosEmpleado.TESBeneficiarioId#--#DatosEmpleado.TESbeneficiario#</strong>			</td>
			</tr>
			<tr>
				<td align="center" nowrap="nowrap" colspan="8">
					<strong> <cf_translate key=LB_NumeroComision>Numero de Comisión</cf_translate>:  #rsEncabezado.GECnumero#  -- #rsEncabezado.GECdestino#</strong>
				</td>
			</tr>
			<tr>
				<td align="center" nowrap="nowrap" colspan="8">
					<strong> <cf_translate key=LB_LiquidacionGastos>Liquidación de Gastos </cf_translate>
						<cfif #rsform.GEAviatico# eq 1>
							<cfif #rsform.GEAtipoviatico# eq 1>
								dentro del país
							<cfelseif #rsform.GEAtipoviatico# eq 2>
								al Exterior
							</cfif>
						</cfif>
						N:&nbsp;&nbsp;#rsEncabezado.GELnumero#
					</strong>
				</td>
			</tr>
			<tr>
				<td align="left" nowrap="nowrap" colspan="2"></td>
			</tr>
			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong><cf_translate key=LB_ResumenTransaccion>Resumen de la Transacción</cf_translate></strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong><cf_translate key=LB_FechaLiquidacion>Fecha Liquidación</cf_translate>:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1">
			  <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span>		  </td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_Moneda>Moneda</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#rsEncabezado.Miso4217#</span></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_MontoAnticipos>Monto Anticipos</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#			    </span></td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_MontoGastos>Monto Gastos</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#			    </span></td>
		</tr>
		<tr>
		<cfif rsEncabezado.GELtipoP eq 1>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_MontoDepositos>Monto Depositos</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#			    </span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_MontoDevoluciones>Monto Devoluciones</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#			    </span></td>
		</cfif>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_PagoEmpleado>Pago al Empleado</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELreembolso,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#rsEncabezado.Titulo#</span></td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_FormaPago>Forma de Pago</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#rsEncabezado.pago#</span></td>
		</tr>
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_CajaChica>Caja Chica</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</span></td>
		</tr>
		</cfif>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_Descripcion>Descripción</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.GELdescripcion#</span>
			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_DetalleComision>Detalle de la Comision</cf_translate>: #rsEncabezado.GECnumero#</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong><cf_translate key=LB_Destino>Destino</cf_translate>:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#rsEncabezado.GECdestino#</span>
			</td>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_CategoriaDestino>Categoria Destino</cf_translate>:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4"><span class="style3">#rsEncabezado.GECDdescripcion#</span></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong><cf_translate key=LB_PeriodoComision>Periodo de la Comision</cf_translate>:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#LvarPeriodoComision#</span></td>
			<td align="left" nowrap="nowrap"><strong><cf_translate key=LB_DiasComision>Dias de Comision</cf_translate>: </strong></td>
			<td align="left" nowrap="nowrap" colspan="4"><span class="style3">#LvarDiasComision#</span></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#rsEncabezado.GECdescripcion#</span></td>
			<td align="left" nowrap="nowrap">&nbsp;</td>
			<td align="left" nowrap="nowrap" colspan="4">&nbsp;</td>
		</tr>

		<tr><td align="left" nowrap="nowrap" colspan="2"></td></tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong><cf_translate key=LB_ImporteMaximoComision>Importe Max. de Comisión</cf_translate>:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(LvarMontoMaxComision,',9.00')#</td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>

		</tr>

			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_AnticiposAsociados>Anticipos Asociados</cf_translate></strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_AnticipoLineaConcepto>Anticipo-Linea-Concepto</cf_translate></strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FechaAnticipo>Fecha Anticipo</cf_translate></strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FechaDetalle>Fecha Detalle</cf_translate></strong></td>
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_MontoAnticipo>Monto del Anticipo</cf_translate></strong></td>
		</tr>
	<cfloop query="rsAnticipos">
		<cfif len(trim(#GECVid_Padre#))>
			<cfquery name="rsGECVid_Padre" datasource="#session.dsn#">
				select GECVdescripcion from GEClasificacionViaticos where GECVid=#GECVid_Padre#
			</cfquery>
		</cfif>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsAnticipos.GEAnumero#-#rsAnticipos.Linea#-
				<cfif len(trim(#rsAnticipos.GECVdescripcion#))>
					<cfif isdefined('rsGECVid_Padre.GECVdescripcion') and len(#rsGECVid_Padre.GECVdescripcion#)>
						#rsGECVid_Padre.GECVdescripcion#-
					</cfif>
					#rsAnticipos.GECVdescripcion#-#rsAnticipos.GEPVdescripcion#
				<cfelse>
					#rsAnticipos.GECdescripcion#
				</cfif>
				</span>
			</td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsAnticipos.GEAfechaPagar,"DD/MM/YYYY")# </span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#fechas# </span></td>
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsAnticipos.GELAtotal,',9.00')# </span></td>
		</tr>
	</cfloop>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>

		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#</td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>

		</tr>
		<cfif rsForm.GEAviatico eq 1>
			<tr></tr><tr></tr><tr></tr>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_DatosLiquidacion>Datos de la Liquidación</cf_translate></strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_LiquidacionConcepto>Liquidación-Concepto</cf_translate></strong></td>
				<td width="33%" align="center" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FechaLiquidacion>Fecha Liquidación</cf_translate></strong></td>
				<td width="21%" align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_MontoLiquidacion>Monto de la Liquidación</cf_translate></strong></td>
			</tr>
			<cfset totalLiq=0>
			<cfloop query="rsLiquidacionesViatico">
				<cfif len(trim(#GECVid_Padre#))>
					<cfquery name="rsGECVid_Padre2" datasource="#session.dsn#">
						select GECVdescripcion from GEClasificacionViaticos where GECVid=#GECVid_Padre#
					</cfquery>
				</cfif>
				<tr>
					<td align="left" valign="top" nowrap="nowrap"><span class="style3">
					<cfif len(trim(#rsLiquidacionesViatico.GECVdescripcion#))>
							<cfif isdefined('rsGECVid_Padre2.GECVdescripcion') and len(#rsGECVid_Padre2.GECVdescripcion#)>
								#rsGECVid_Padre2.GECVdescripcion#-
							</cfif>
							#rsLiquidacionesViatico.GECVdescripcion#-#rsLiquidacionesViatico.GEPVdescripcion#
						<cfelse>
							#rsLiquidacionesViatico.GECdescripcion#
				  </cfif>
					<td align="center" valign="top" nowrap="nowrap"><span class="style3">
						#fechas# </span>
					</td>
					<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsLiquidacionesViatico.GELVmonto,',9.00')# </span></td>
				</tr>
			<cfset totalLiq+=#rsLiquidacionesViatico.GELVmonto#>
			</cfloop>
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(totalLiq,',9.00')#</td>
			</tr>
		</cfif>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>

		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_GastosAsociados>Gastos Asociados</cf_translate></strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_GastoLineaConcepto>Gasto-Linea-Concepto</cf_translate></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_TipoGasto>Tipo Gasto</cf_translate></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_NDocumento>N.Documento</cf_translate></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Voucher</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FechaGasto>Fecha Gasto</cf_translate></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_ProveedorServicio>Proveedor Servicio</cf_translate></strong></td>
			<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_MontoGasto>Monto del Gasto</cf_translate></strong></td>
		</tr>
	<cfloop query="rsLiquidacion">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GELnumero#-#rsLiquidacion.GECdescripcion#</span></td>
			<td align="left" width="10%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GETdescripcion#</span></td>
			<td align="left" width="10%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGnumeroDoc#</span></td>
			<td align="left" width="10%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.Voucher#</span></td>
			<td align="left" width="10%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsLiquidacion.GELGfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGreferencia#</span></td>
			<td align="right" width="10%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsLiquidacion.GELGtotal,',9.00')#</span></td>
		</tr>
	</cfloop>
	<cfif isdefined("rsIva") and rsIva.RecordCount GTE 1>
	  <cfloop query ="rsIva">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3"><cf_translate key=LB_IVA>IVA</cf_translate></span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsIva.GELGnumeroDoc#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsIva.GELfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
		</tr>
	  </cfloop>
	</cfif>
	<cfif isdefined("rsIvaCajaC") and rsIvaCajaC.RecordCount GTE 1>
	  <cfloop query ="rsIvaCajaC">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3"><cf_translate key=LB_IVA>IVA</cf_translate></span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsIvaCajaC.iva,',9.00')#</span></td>
		</tr>
	  </cfloop>
	</cfif>

	<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#</td>
	</tr>
	<cfif isdefined("rsRet") and rsRet.RecordCount GTE 1>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_Retenciones>Retenciones</cf_translate></strong></td>
		</tr>
		<cfset totalret=0>
	  <cfloop query ="rsRet">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">Retenciones</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsRet.monto,',9.00')#</span></td>
		</tr>
		<cfset totalret = totalret+rsRet.monto>
		</cfloop>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(totalret,',9.00')#</td>
		</tr>
	</cfif>

		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>

		</tr>
		

		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>

		</tr>
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_DevolucionesAsociadas>Devoluciones Asociados</cf_translate></strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_Monto>Monto</cf_translate>:</strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong>#rsEncabezado.GELtotalDevoluciones#</strong></td>
			</tr>
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#</td>
			</tr>
		<cfelse>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_DepositosAsociados>Depositos Asociados</cf_translate></strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_Referencia>Referencia</cf_translate></strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_BancoChequera>Banco-Chequera</cf_translate></strong></td>
				<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_MontoDeposito>Monto Deposito</cf_translate></strong></td>
			</tr>
			<cfloop query="rsDeposito">
				<tr>
					<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.GELDreferencia#</span></td>
					<td align="center" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.CBcodigo#</span></td>
					<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsDeposito.GELDtotal,',9.00')#</span></td>
				</tr>
			</cfloop>
			<tr>
				<td align="left" nowrap="nowrap" colspan="8"></td>

			</tr>
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#</td>
			</tr>
		</cfif>
		<table border="1" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_Observaciones>Observaciones</cf_translate></strong></td>
			</tr>
			<tr>
				<td width="100%" align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesLiq#</span></td>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_Resultados>Resultados: Explique brevemente los resultados obtenidos durante la Comision</cf_translate></strong></td>
			</tr>
			<tr>
			  <td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesResultado#</span></td>
			<tr>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key=LB_MotivoExcedente>En caso de haber excedido las tarifas autorizadas. Explique los Motivos</cf_translate></strong></td>
			</tr>
			<tr>
			  	<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesExceso#</span></td>
			<tr>

		<!---parte de las firmas--->
		<!---<tr>
			<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>--->
		</table>
		<!---<table border="1" width="100%" cellpadding="0" cellspacing="0"><tr>
			<td>
				<table align="center" border="0" width="100%">
				  <tr>
					<td align="left" nowrap="nowrap"> Declaro bajo juramento que lo arriba expresado es una relación exacta de los gastos incurridos en asuntos oficiales. </td>
				  </tr>
				   <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center" valign="top" nowrap="nowrap"><strong>________________________________________________</strong></td>
				  </tr>
				   <tr>
					<td align="center" valign="top" nowrap="nowrap"><strong>#DatosEmpleado.TESbeneficiario#</strong></td>
				  </tr>
				</table>
			</td>
			<td>
				<table align="center" border="0" width="100%">
				  <tr>
					<td align="left" nowrap="nowrap"><strong>Autorizado por:</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>


					<td align="left" valign="top" nowrap="nowrap"><strong>____________________________________________</strong></td>

				  </tr>

				  <tr>
				  <!---<cfif rsFirmas.GECtipo EQ 1>--->
					<!---<td align="center" valign="top" nowrap="nowrap"><strong>#rsFirmas.Aprueba#</strong></td>--->
                    <td align="center" valign="top" nowrap="nowrap"><strong>#Aprueba#</strong></td>
				  <!---<cfelse>
					<td align="center" valign="top" nowrap="nowrap"><strong>#rsFirmas.Autoriza#</strong></td>
				  </cfif>--->
				  </tr>
				</table>
			</td>
		</tr>
	</table>--->
		</cfoutput>
        </cfif>
