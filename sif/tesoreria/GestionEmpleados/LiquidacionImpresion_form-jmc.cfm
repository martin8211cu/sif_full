<!---Este lo modifique yo--->
<cfparam name="url.Tipo" default="">
<cfif isDefined("Url.GELid") and url.GELid NEQ "">
  <cfset form.GELid = Url.GELid>
</cfif>
<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<cf_htmlReportsHeaders 
	title="Impresion de Liquidacion" 
	filename="Liquidacion.xls"
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
		        d.GELTreferencia as Voucher
		from  GEliquidacionGasto a 
              inner join  GEconceptoGasto b on b.GECid=a.GECid
			  inner join  Tesoreria c on c.TESid= a.TESid
              left join   GEliquidacionTCE d  on a.GELGid=d.GELGid
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
				l.GECid,
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
		inner join GEcomision co on l.GECid = co.GECid
		inner join GEcategoriaDestino cD on co.GECDid = cD.GECDid
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
	
	<cfquery name="rsFirmas" datasource="#session.dsn#">
		select GECtipo, case when GECtipo = 1 or GECtipo = 2 or GECtipo = 3 
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
		where li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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
				<td align="center" valign="top" colspan="8"><strong>Sistema de Gastos de Empleado</strong></td>
			</tr>
			<tr>
				<td align="center" colspan="8" nowrap="nowrap"> <strong>Empleado:&nbsp;#DatosEmpleado.TESBeneficiarioId#--#DatosEmpleado.TESbeneficiario#</strong>			</td>
			</tr>
			<tr>
				<td align="center" nowrap="nowrap" colspan="8">
					<strong> Numero de Comisión:  #rsEncabezado.GECnumero#  -- #rsEncabezado.GECdestino#</strong>
				</td>
			</tr>
			<tr>
				<td align="center" nowrap="nowrap" colspan="8">
					<strong> Liquidación de Gastos 
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
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Transacción</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha Liquidación:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1">
			  <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span>		  </td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong>Moneda:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#rsEncabezado.Miso4217#</span></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Anticipos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#			    </span></td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong>Monto Gastos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#			    </span></td>
		</tr>
		<tr>
		<cfif rsEncabezado.GELtipoP eq 1>
			<td align="left" nowrap="nowrap"><strong>Monto Depositos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#			    </span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong>Monto Devoluciones:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#			    </span></td>
		</cfif>	
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong>Pago al Empleado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELreembolso,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Estado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="1">
				<span class="style3">#rsEncabezado.Titulo#</span></td>
		<!---</tr>
		<tr>--->
			<td align="left" nowrap="nowrap"><strong>Forma de Pago:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4">
				<span class="style3">#rsEncabezado.pago#</span></td>
		</tr>
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
			<td align="left" nowrap="nowrap"><strong>Caja Chica:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</span></td>
		</tr>
		</cfif>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Descripción:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.GELdescripcion#</span>
			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Detalle de la Comision: #rsEncabezado.GECnumero#</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Destino:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#rsEncabezado.GECdestino#</span>	
			</td>
			<td align="left" nowrap="nowrap"><strong>Categoria Destino:</strong></td>
			<td align="left" nowrap="nowrap" colspan="4"><span class="style3">#rsEncabezado.GECDdescripcion#</span></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Periodo de la Comision:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#LvarPeriodoComision#</span></td>
			<td align="left" nowrap="nowrap"><strong>Dias de Comision: </strong></td>
			<td align="left" nowrap="nowrap" colspan="4"><span class="style3">#LvarDiasComision#</span></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Descripcion:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="1"><span class="style3">#rsEncabezado.GECdescripcion#</span></td>
			<td align="left" nowrap="nowrap">&nbsp;</td>
			<td align="left" nowrap="nowrap" colspan="4">&nbsp;</td>			
		</tr>
		
		<tr><td align="left" nowrap="nowrap" colspan="2"></td></tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Importe Max. de Comisión:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(LvarMontoMaxComision,',9.00')#</td>
		</tr>
	
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
			
		</tr>
		
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Anticipos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Anticipo-Linea-Concepto</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha Anticipo</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha detalle</strong></td>				
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Monto del Anticipo</strong></td>
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
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Datos de la Liquidación</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong>Liquidación-Concepto</strong></td>
				<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha Liquidación</strong></td>			
				<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Monto de la Liquidación</strong></td>
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
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Gastos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Gasto-Linea-Concepto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>N.Documento</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Voucher</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Fecha Gasto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Proveedor Servicio</strong></td>			
			<td align="right" valign="top" nowrap="nowrap"><strong>Monto del Gasto</strong></td>
		</tr>
	<cfloop query="rsLiquidacion">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GELnumero#-#rsLiquidacion.GECdescripcion#</span></td>
			<td align="left" width="15%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGnumeroDoc#</span></td>
			<td align="left" width="15%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.Voucher#</span></td>
			<td align="left" width="15%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsLiquidacion.GELGfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGreferencia#</span></td>
			<td align="right" width="15%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsLiquidacion.GELGtotal,',9.00')#</span></td>
		</tr>	
	</cfloop>
	<cfif isdefined("rsIva") and rsIva.RecordCount GT 1>
	  <cfloop query ="rsIva">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">IVA</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsIva.GELGnumeroDoc#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsIva.GELGfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">&nbsp;</span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsIva.iva,',9.00')#</span></td>
		</tr>
	  </cfloop>
	</cfif>
	
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#</td>
		</tr>
		
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Devoluciones Asociados</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong>Monto:</strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong>#rsEncabezado.GELtotalDevoluciones#</strong></td>			
			</tr>			
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#</td>
			</tr>
		<cfelse>		
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Depositos Asociados</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong>Referencia</strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong>Banco-Chequera</strong></td>			
				<td align="right" valign="top" nowrap="nowrap"><strong>Monto Deposito</strong></td>
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
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Observaciones</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesLiq#</span></td>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Resultados: Explique brevemente los resultados obtenidos durante la Comision</strong></td>
			</tr>	
			<tr>
			  <td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesResultado#</span></td>
			<tr>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>En caso de haber excedido las tarifas autorizadas. Explique los Motivos</strong></td>
			</tr>
			<tr>
			  	<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GECobservacionesExceso#</span></td>
			<tr>
			
		<!---parte de las firmas--->
		<tr>
			<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<table border="1" width="100%" cellpadding="0" cellspacing="0"><tr>
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
				  
				  	<!---<cfif rsFirmas.GECtipo EQ 1>--->
					<td align="left" valign="top" nowrap="nowrap"><strong>____________________________________________</strong></td>
					<!---<cfelse>	
						<td align="left" valign="top" nowrap="nowrap"><strong>Nombre:</strong><u>#rsFirmas.Autoriza#</u></strong></td>
					</cfif>--->
				  </tr>
				   
				  <tr>					
					<td align="center" valign="top" nowrap="nowrap"><strong>#rsFirmas.Aprueba#</strong></td>
				  </tr>
				</table>
			</td>
		</tr></table>
		</cfoutput>
        </cfif>
