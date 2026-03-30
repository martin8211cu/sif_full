
<cfif isdefined ('url.id') and not isdefined ('form.GELid')>
	<cfset form.GELid=#url.id#>
<cfelse>
	<cfif isdefined("LvarSAporEmpleadoCFM") eq false>
		<cfset LvarSAporEmpleadoCFM = "uidacionForm">
	</cfif>
	<cf_htmlReportsHeaders 
		title="Impresion de Solicitud de Pago" 
		filename="Liquidacion.xls"
		irA="ReimpresionLiq#LvarSAporEmpleadoCFM#.cfm?regresar=1"
		download="no"
		preview="no"
		>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

<cfif isdefined ('form.GELid') and form.GELid NEQ ''>
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
		from 
				GEanticipoDet a,
				GEliquidacionAnts b,
				GEanticipo c,
				GEconceptoGasto d
		where a.GEAid = b.GEAid
		and   a.GEAid = c.GEAid
		and a.GEADid = b.GEADid
		and a.GEAid=c.GEAid
		and d.GECid=a.GECid
		and b.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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
    
	<cfquery name="rsDepositoEfectivo" datasource="#session.DSN#">
		select 
			a.GELDEid,
			a.GELDreferencia,
			a.GELDtotalOri,
			a.GELDtotal,
			a.GELid,
			a.GELDfecha,
			a.CCHid,
			(select Mo.Miso4217
				from Monedas Mo
				where DL.Mcodigo=Mo.Mcodigo
			)as MonedaEncabezado,
			a.Mcodigo, m.Miso4217,
			b.CCHid,
			b.CCHcodigo,
            b.CCHdescripcion     
		from GEliquidacionDepsEfectivo a
			inner join Monedas m
				on m.Mcodigo = a.Mcodigo
			inner join CCHica b 
				 on b.CCHid=a.CCHid
				and b.CCHtipo in (2,3)
			inner join GEliquidacion DL
				on DL.GELid = a.GELid
		where a.GELid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GELid#">         	
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
                l.GELestado,
                l.GELtotalDepositosEfectivo ,
				case l.GELestado
                    when 0 then 'Preparacin'
                    when 1 then 'En Aprobacin'
                    when 2 then 'Aprobada'
                    when 3 then 'Rechazada'
                    when 4 then 'Finalizada'
                    when 5 then 'Por reintegrar'
				end as Titulo,
				l.GELtipoP,
				case l.GELtipoP
                    when 0 then 'Caja Chica'
                    when 1 then 'Tesorería'
				end as pago,
				l.GELtotalDevoluciones,
				m.Miso4217,
                l.CFid,
                coalesce(l.UsucodigoAprobacion,-1) as UsucodigoAprobacion,
                b.TESSPnumero,
                cf.CFcodigo,
                cf.CFdescripcion
		from GEliquidacion l
			inner join Monedas m
				on m.Mcodigo = l.Mcodigo
        	left join TESsolicitudPago b
        		on b.TESSPid= coalesce(l.TESSPid,l.TESSPid_Adicional) 
            left join CFuncional cf 
				on cf.CFid = l.CFid    
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
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



	<cfif rsEncabezado.GELtipoP eq 0>
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CCHcodigo,CCHdescripcion from CCHica where CCHid =(select CCHid from GEliquidacion where GELid=#form.GELid#)		
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
    
	<cfquery name="rsIvaCajaC" datasource="#session.dsn#">
		select li.GELid,  liG.Mcodigo, sum(GELGtotalOri) as iva, liG.GELGnumeroDoc, li.GELfecha,i.Idescripcion
		from GEliquidacionGasto liG
		inner join GEliquidacion li on liG.GELid=li.GELid
		inner join Impuestos i
		on i.Icodigo = liG.Icodigo
		where liG.Icodigo  is not null
		and li.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and li.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		group by li.GELid, liG.Mcodigo, liG.GELGnumeroDoc, li.GELfecha,i.Idescripcion
	</cfquery>

    <cfif rsEncabezado.GELestado eq 1>
        <cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
        <cfquery name="rsTESU" datasource="#Session.DSN#">
            select 
                     u.Usulogin
                    , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                    , cf.CFcodigo, cf.CFdescripcion
                    
            from TESusuarioSP tu
                inner join Usuario u
                    inner join DatosPersonales dp
                       on dp.datos_personales = u.datos_personales
                    on u.Usucodigo = tu.Usucodigo
                inner join CFuncional cf
                    on cf.CFid = tu.CFid
            where tu.CFid 		= #rsEncabezado.CFid#
            and tu.TESUSPaprobador = 1
        </cfquery>
        
    <cfelseif listFind("2,4,5",rsEncabezado.GELestado)>
        <cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
        <cfquery name="rsTESU" datasource="#Session.DSN#">
            select 
                     u.Usulogin
                    , dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
                    
            from Usuario u
                    inner join DatosPersonales dp
                       on dp.datos_personales = u.datos_personales
            where u.Usucodigo =#rsEncabezado.UsucodigoAprobacion#
        </cfquery>
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
			<td rowspan="5">
				 <cfinvoke
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> 
				</cfinvoke>
				<cfoutput>
				<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="120" width="200" />
				</cfoutput>
			</td>
			<td align="center" valign="top" colspan="7"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="7"><strong>Tesorería: #rsLiquidacion.TESdescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="7"><strong>Sistema de Gastos de Empleado</strong></td>
		</tr>
		<tr>
			<td align="center" colspan="7" nowrap="nowrap"> <strong>Empleado:&nbsp;#DatosEmpleado.TESBeneficiarioId#-#DatosEmpleado.TESbeneficiario#</strong>			</td>
		</tr>
		<tr>
			<td align="center" nowrap="nowrap" colspan="7"><strong> Liquidación de Gastos N:&nbsp;&nbsp;#rsEncabezado.GELnumero#</strong>			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Transacción</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha Liquidación:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="8">
			  <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span>		  </td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Moneda:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.Miso4217#</span></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Anticipos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Gastos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#			    </span></td>
		</tr>
		<tr>
		<cfif rsEncabezado.GELtipoP eq 1>
			<td align="left" nowrap="nowrap"><strong>Monto Depositos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#			    </span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong>Monto Devoluciones:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#			    </span></td>
		</cfif>	
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Pago al Empleado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELreembolso,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Estado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.Titulo#</span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Forma de Pago:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.pago#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Centro Funcional:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.CFdescripcion#</span></td>
		</tr>
        <tr>
			<td align="left" nowrap="nowrap"><strong>Solicitud de pago Nº:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.TESSPnumero#</span></td>
		</tr>

		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
			<td align="left" nowrap="nowrap"><strong>Caja Chica:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</span></td>
		</tr>
		</cfif>
        <cfif rsEncabezado.GELestado eq 1>
            <tr>
                <td align="left" nowrap="nowrap"><strong>Aprobadores:</strong></td>
                <td align="left" colspan="8">
                    <span class="style3"><cfloop query="rsTESU">#rsTESU.Usunombre#, &nbsp; </cfloop></span></td>
            </tr>
        </cfif>    
        <cfif listFind("2,4,5",rsEncabezado.GELestado)>
            <tr>
                <td align="left" nowrap="nowrap"><strong>Aprobado por:</strong></td>
                <td align="left" colspan="8">
                    <span class="style3">#rsTESU.Usunombre# &nbsp;</span></td>
            </tr>
        </cfif>    

		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Anticipos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Anticipo-Linea-Concepto</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha Anticipo</strong></td>			
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Monto del Anticipo</strong></td>
		</tr>
	<cfloop query="rsAnticipos">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsAnticipos.GEAnumero#-#rsAnticipos.Linea#-#rsAnticipos.GECdescripcion#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsAnticipos.GEAfechaPagar,"DD/MM/YYYY")# </span></td>			
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
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Gastos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Gasto-Linea-Concepto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>N.Documento</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Fecha Gasto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Proveedor Servicio</strong></td>			
			<td align="right" valign="top" nowrap="nowrap"><strong>Monto del Gasto</strong></td>
		</tr>
	<cfloop query="rsLiquidacion">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GELnumero#-#rsLiquidacion.GECdescripcion#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGnumeroDoc#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsLiquidacion.GELGfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGproveedor#</span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsLiquidacion.GELGtotal,',9.00')#</span></td>
		</tr>	
	</cfloop>
	<cfloop query="rsIvaCajaC">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsIvaCajaC.Idescripcion#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsIvaCajaC.iva,',9.00')#</span></td>
		</tr>	
	</cfloop>

	
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Retenciones</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Retenciones</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong></strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong></strong></td>			
			<td align="right" valign="top" nowrap="nowrap"><strong>Monto </strong></td>
		</tr>
		<cfset montoRet =0>
	<cfloop query="rsRet">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">Retenciones</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3"></span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsRet.monto,',9.00')#</span></td>
		</tr>
		<cfset montoRet = montoRet+rsRet.monto>
	</cfloop>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(montoRet,',9.00')#</td>
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
            <td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Depositos en Efectivo Asociados</strong></td>
        </tr>
        <tr>
            <td align="left" valign="top" nowrap="nowrap"><strong>Referencia</strong></td>
            <td align="center" valign="top" nowrap="nowrap"><strong>Caja de Efectivo</strong></td>			
            <td align="right" valign="top" nowrap="nowrap"><strong>Monto Deposito</strong></td>
        </tr>
        <cfloop query="rsDepositoEfectivo">
            <tr>
                <td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsDepositoEfectivo.GELDreferencia#</span></td>
                <td align="center" valign="top" nowrap="nowrap"><span class="style3">#rsDepositoEfectivo.CCHcodigo#-#rsDepositoEfectivo.CCHdescripcion#</span></td>			
                <td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsDepositoEfectivo.GELDtotal,',9.00')#</span></td>
            </tr>	
        </cfloop>
        <tr>
            <td align="left" nowrap="nowrap" colspan="8"></td>
            
        </tr>
        <tr>
            <td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
            <td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDepositosEfectivo,',9.00')#</td>
        </tr>

		
	</table>
</cfoutput>

</cfif>






