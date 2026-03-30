<cfparam name="Param" 	default="">

<cfif isdefined('GENERAR')>
	<cfinvoke component="sif.Componentes.DPagoRenta" method="generaRetencion">
		<cfinvokeargument name="DREstado" 	value="1">
		<cfinvokeargument name="periodo" 	value="#form.periodo#">
		<cfinvokeargument name="mes" 			value="#form.mes#">
		<cfinvokeargument name="Oficina" 	value="#form.Oficina#">
		<cfinvokeargument name="periodo" 	value="#form.periodo#">
		<cfinvokeargument name="Rcodigo" 	value="#form.Rcodigo#">
	</cfinvoke>
		<cflocation url="DPagoRenta.cfm" addtoken="no">
<cfelseif isdefined('NUEVO')>
		<cflocation url="DPagoRenta.cfm?Nuevo=nuevo" addtoken="no">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.DPagoRenta" method="CAMBIO_Dpago_Retencion">
		<cfinvokeargument name="DRid" 				 value="#form.DRid#">
		<cfinvokeargument name="Bid" 					 value="#form.Bid#">
		<cfinvokeargument name="CBid"  				 value="#form.CBid#">
		<cfinvokeargument name="CFid"  				 value="#form.CFid#">
		<cfinvokeargument name="DRNumConfirmacion" value="#form.DRNumConfirmacion#">
	</cfinvoke>
		<cflocation url="DPagoRenta.cfm?DRid=#form.DRid#" addtoken="no">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.DPagoRenta" method="Elimina_declaracion_pago_retencion">
		<cfinvokeargument name="DRid" 			value="#form.DRid#">
	</cfinvoke>
	<cflocation url="DPagoRenta.cfm" addtoken="no">
	
	
<cfelseif isdefined('form.APLICAR') >
	
	<cf_dbtimestamp datasource="#session.dsn#"
		table="EDRetenciones"
		redirect="DPagoRenta.cfm?modo=CAMBIO&DRid=#form.DRid#"
		timestamp="#form.ts_rversion#"
		field1="DRid" 
		type1="numeric" 
		value1="#form.DRid#">
		
	<cfquery name="rsDRPago" datasource="#session.dsn#">
		select 
			enc.BMfecha,
			enc.DRid,
			enc.ts_rversion,
			enc.BTid,
			enc.DRNumConfirmacion as confirmacion,
			a.Dtipocambio,
			enc.Bid,
			enc.CBid,
			enc.Ocodigo,
			a.Pfecha, 
			coalesce((a.MontoR * a.Dtipocambio),0) as montolocal,
			Rdescripcion as Tipo_Retencion
		from EDRetenciones enc
			inner join DDRetenciones a
				on enc.DRid = a.DRid
			inner join Retenciones rt
				on rt.Rcodigo = a.Rcodigo
				and rt.Ecodigo = a.Ecodigo
	  	where   
	  	  enc.DRid = #form.DRid#
		  and a.Ecodigo =  #session.Ecodigo#
	</cfquery>
	
	
	<cfquery name="rsTotaMontoR" dbtype="query">
		select sum(montolocal) as montoTotalR
		from rsDRPago
	</cfquery>
	
	<cfset LvarMontoTotal = round(#rsTotaMontoR.montoTotalR#)>

	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsDRPago.confirmacion)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsDRPago.confirmacion)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">		
	</cfquery>	
	
		
	<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfquery name="cuenta" datasource="#session.DSN#">
			select CBdescripcion 
			from CuentasBancos
			where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDRPago.CBid#">
            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>	
		
		<cfset Request.Error.Backs = 1 >
		<cfthrow message="No se puede procesar el Movimiento pues ya existe uno con mismos datos: <br> -Documento: #rsDRPago.confirmacion# <br> -Cuenta Bancaria: #cuenta.CBdescripcion#. <br>El proceso fue cancelado">
	</cfif>
	
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select cf.Dcodigo, cf.CFid,o.Ocodigo,r.Ccuentaretp  ,Rdescripcion as Tipo_Retencion,r.Rcodigo,
		sum(a.MontoR * a.Dtipocambio) as montolocal
		from EDRetenciones p
			inner join CFuncional cf
				inner join Oficinas o
					on o.Ocodigo = cf.Ocodigo 
					and o.Ecodigo = cf.Ecodigo
				on cf.CFid = p.CFid and cf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			left outer join DDRetenciones a
				on p.DRid = a.DRid
			inner join Retenciones r
				on a.Rcodigo =r.Rcodigo
				and a.Ecodigo =r.Ecodigo
		where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and a.DRid = <cfqueryparam value="#rsDRPago.DRid#" cfsqltype="cf_sql_numeric">
		group by cf.Dcodigo, cf.CFid, o.Ocodigo,r.Ccuentaretp  ,Rdescripcion ,cf.Ecodigo,r.Rcodigo			
	</cfquery>
	
	<cftransaction>
	
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTA"
			fecha="#rsDRPago.BMfecha#"
			tipoSocio="0"
			descripcion="Pago de Retenciones"
			referencia="#rsDRPago.confirmacion#"
			documento="#rsDRPago.confirmacion#"
			cuentaBancaria="#rsDRPago.CBid#"
			tipoTransaccion="#rsDRPago.BTid#"
			tipocambio="#rsDRPago.Dtipocambio#"
			total="#LvarMontoTotal#"		
			empresa="#session.Ecodigo#"
			Ocodigo="#rsDRPago.Ocodigo#"
			returnvariable="LvarEMid"
		/>		
		
		<cfif isdefined("rsCFuncional") and rsCFuncional.recordcount gt 0>
			<cfloop query="rsCFuncional">		
				<cfinvoke component="sif.Componentes.MovimientosBancarios"
					method="ALTAD"
					EMid="#LvarEMid#"
					Ecodigo="#session.Ecodigo#"
					Ccuenta="#rsCFuncional.Ccuentaretp#"
					Dcodigo="#rsCFuncional.Dcodigo#"
					monto="#rsCFuncional.montolocal#"
					descripcion="#rsCFuncional.Tipo_Retencion#"
					CFid="#rsCFuncional.CFid#"
					returnvariable="LvarDMid"
				/>
			</cfloop>
 	  </cfif>		
	  
		<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="EMid" value="#LvarEMid#"/>				
			<cfinvokeargument name="usuario" value="#session.usucodigo#"/>			
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="transaccionActiva" value="true"/>							
		</cfinvoke>
		
		<cfinvoke component="sif.Componentes.DPagoRenta" method="APLICAR">
			<cfinvokeargument name="DRid"   value="#form.DRid#"/>
			<cfinvokeargument name="estado" value="2"/>
		</cfinvoke>
		
	</cftransaction>
	<cflocation url="DPagoRenta.cfm" addtoken="no">
</cfif>	
