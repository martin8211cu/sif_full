<cfif isdefined('form.Aprobar') >
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PDTDeposito"
		redirect="aprobacionDepositos.cfm?modo=CAMBIO&PDTDid=#form.PDTDid#"
		timestamp="#form.ts_rversion#"
		field1="PDTDid" 
		type1="numeric" 
		value1="#form.PDTDid#">
	
	<cfquery name="rsUpdateDoc" datasource="#session.dsn#">
	  update PDTDeposito 
	    set PDTDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.documento#">,
		PDTDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">  
	     where 
	  PDTDid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDTDid#">
	</cfquery>	
	<cfquery name="rsTipoTrans" datasource="#session.DSN#">
		select <cf_dbfunction name="to_integer" args="Pvalor"> as BTid from Parametros where Pcodigo = 1800
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoTrans.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoTrans.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			
		<cfif isdefined("form.EMid") and len(trim(form.EMid))>
			and EMid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">
		</cfif>	
			
	</cfquery>			
		
	<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfquery name="transaccion" datasource="#session.DSN#">
			select BTdescripcion 
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
		</cfquery>
		<cfquery name="cuenta" datasource="#session.DSN#">
			select CBdescripcion 
			from CuentasBancos
			where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>	
		<cfset Request.Error.Backs = 1 >
			<cfthrow message="No se puede procesar el Movimiento pues ya existe uno con mismos datos: <br> -Documento: #form.documento# <br> -Transacción: #transaccion.BTdescripcion# <br> -Cuenta Bancaria:#cuenta.CBdescripcion#. <br>El proceso fue cancelado">
	</cfif>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select cf.Dcodigo, cf.CFid, cf.CFcuentaingreso, p.cuentac, p.CFComplemento Complemento,p.Pdescripcion
		from Peaje p
			inner join CFuncional cf
				on cf.CFid = p.CFid and cf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		where p.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and p.Pid = <cfqueryparam value="#form.peajeID#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	  <!--- Actividad empresarial --->
	  <cfif len(#rsCFuncional.Complemento#) eq 0>
	    <cfthrow message="Falta definir la Actividad empresarial en el Centro Funcional asociado al peaje">
	  </cfif>
	  <cfset LvarActividad = #rsCFuncional.Complemento#>
	
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<cfset LvarFormatoCuenta = mascara.AplicarMascara(rsCFuncional.CFcuentaingreso,rsCFuncional.cuentac)>
	<cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,REReplace(LvarActividad,"-","","ALL"), '_')>

	
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
		<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
		<cfinvokeargument name="Lprm_fecha" 			value="#form.fecha#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
		<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
	</cfinvoke>
	<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
			<cf_errorCode	code = "50314"
							msg  = "@errorDat_1@ [@errorDat_2@]"
							errorDat_1="#LvarError#"
							errorDat_2="#LvarFormatoCuenta#"
			>
	</cfif>
	<!--- Obtienes las cuentas generadas--->
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="LvarCuentas">
		<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
		<cfinvokeargument name="Lprm_fecha" 			value="#form.fecha#"/>
		<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
		<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
	</cfinvoke>	
	<cftransaction>
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTA"
			fecha="#form.fecha#"
			tipoSocio="#form.tipoSocio#"
			descripcion="#rsCFuncional.Pdescripcion#-#form.descripcion#"
			referencia="#form.peaje#"
			documento="#form.documento#"
			cuentaBancaria="#form.CBid#"
			tipoTransaccion="#form.BTid#"
			tipocambio="#form.EMtipocambio#"
			total="#form.monto#"		
			empresa="#session.Ecodigo#"
			Ocodigo="#form.Ocodigo#"
			returnvariable="LvarEMid"
		/>
		
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTAD"
			EMid="#LvarEMid#"
			Ecodigo="#session.Ecodigo#"
			Ccuenta="#LvarCuentas.Ccuenta#"
			CFcuenta="#LvarCuentas.CFcuenta#"
			Dcodigo="#rsCFuncional.Dcodigo#"
			monto="#Form.monto#"
			descripcion="#Form.peaje# - #Form.turno# - #Form.fechaCreacion#"
			CFid="#rsCFuncional.CFid#"
			returnvariable="LvarDMid"
		/>
		
		<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="EMid" value="#LvarEMid#"/>				
			<cfinvokeargument name="usuario" value="#session.usucodigo#"/>			
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="transaccionActiva" value="true"/>							
		</cfinvoke>
		
		<cfinvoke component="conavi.Componentes.aprobacionDepositos" method="AprobarDeposito">
			<cfinvokeargument name="PDTDid" value="#form.PDTDid#"/>
			<cfinvokeargument name="fechaReal" value="#form.fecha#"/>					
		</cfinvoke>
	</cftransaction>
	<cflocation url="listaAprobacionDepositos.cfm?modo=ALTA">

</cfif>
