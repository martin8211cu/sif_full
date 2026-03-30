<cfif isdefined('form.ALTA') >
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PAjustes 
			where PAdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.documento#">
				and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
				and Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#">
	</cfquery>
	<cfquery name="rsPeaje" datasource="#session.DSN#">
		select Ecodigo from Peaje where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">		
	</cfquery>	
	<cfif rsExiste.existe gt 0 or rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El documento asignado al ajuste ya existe. Digite otro documento.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.ajustes" method="ALTA"
			CBid="#form.CBid#"
			BTid="#form.BTid#"			
			Pid="#form.selectPeaje#"		
			Mcodigo="#form.Mcodigo#"
			monto="#form.monto#"
			descripcion="#form.descripcion#"
			documento="#form.documento#"
			fecha="#form.fecha#"
			estado="1"	
			returnvariable="LvarId"		
		/>
		<cflocation url="ajustes.cfm?modo=CAMBIO&PAid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.BAJA') >
	<cfinvoke component="conavi.Componentes.ajustes" method="BAJA"
		PAid="#form.PAid#"
		returnvariable="LvarId"				
	/>
	<cflocation url="listaAjustes.cfm">
	
<cfelseif isdefined('form.CAMBIO') >
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PAjustes"
		redirect="ajustes.cfm?modo=CAMBIO&PAid=#form.PAid#"
		timestamp="#form.ts_rversion#"
		field1="PAid" 
		type1="numeric" 
		value1="#form.PAid#">
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PAjustes 
			where PAdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.documento#">
			and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#">
			and PAid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAid#">
	</cfquery>
	<cfquery name="rsPeaje" datasource="#session.DSN#">
		select Ecodigo from Peaje where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	</cfquery>	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.documento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">		
	</cfquery>	
	<cfif rsExiste.existe gt 0 or rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El documento asignado al ajuste ya existe. Digite otros datos.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.ajustes" method="CAMBIO"
			PAid="#form.PAid#"
			CBid="#form.CBid#"
			BTid="#form.BTid#"			
			Pid="#form.selectPeaje#"		
			Mcodigo="#form.Mcodigo#"
			monto="#form.monto#"
			descripcion="#form.descripcion#"
			documento="#form.documento#"
			fecha="#form.fecha#"
			estado="1"	
			returnvariable="LvarId"		
		/>
		<cflocation url="ajustes.cfm?modo=CAMBIO&PAid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.APLICAR') >
	
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PAjustes"
		redirect="ajustes.cfm?modo=CAMBIO&PAid=#form.PAid#"
		timestamp="#form.ts_rversion#"
		field1="PAid" 
		type1="numeric" 
		value1="#form.PAid#">
	<cfquery name="rsAjustes" datasource="#session.dsn#">
		select pa.PAid, p.Pid, p.Pcodigo, b.Bid, bt.BTid, pa.PAdocumento, pa.PAdescripcion, pa.PAmonto, pa.PAfecha, m.Mcodigo, m.Mnombre,
			cb.CBid, cb.CBcodigo, cb.CBdescripcion, coalesce(htc.TCcompra,1) as tipoCambio, p.Ecodigo, p.Pdescripcion
		from PAjustes pa 
			inner join CuentasBancos cb 
				inner join Bancos b 
					on cb.Bid = b.Bid 
					and cb.Ecodigo = b.Ecodigo 
				on cb.CBid = pa.CBid 
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				 left outer join Htipocambio htc 
					on htc.Mcodigo = m.Mcodigo 
					and htc.Ecodigo = #session.Ecodigo# 
					and pa.PAfecha BETWEEN htc.Hfecha and htc.Hfechah
			inner join Peaje p 
				on p.Pid = pa.Pid 
			inner join BTransacciones bt 
				on bt.BTid = pa.BTid 
		where pa.PAid = <cfqueryparam value="#form.PAid#" cfsqltype="cf_sql_numeric" >
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
		  and pa.PAestado = 1 
		  and p.Ecodigo = #session.Ecodigo# 
		  order by p.Pcodigo DESC 
	</cfquery>
	<cfquery name="rsPeaje" datasource="#session.DSN#">
		select Ecodigo from Peaje where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.Pid#">
	</cfquery>
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsAjustes.PAdocumento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.CBid#">
	</cfquery>	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeaje.Ecodigo#">
			and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsAjustes.PAdocumento)#">
			and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.BTid#">
			and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.CBid#">		
	</cfquery>			
		
	<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfquery name="transaccion" datasource="#session.DSN#">
			select BTdescripcion 
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.BTid#">
		</cfquery>
		<cfquery name="cuenta" datasource="#session.DSN#">
			select CBdescripcion 
			from CuentasBancos
			where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAjustes.CBid#">
            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>	
		<cfset Request.Error.Backs = 1 >
		<cfthrow message="No se puede procesar el Movimiento pues ya existe uno con mismos datos: <br> -Documento: #rsAjustes.PAdocumento# <br> -Transacción: #transaccion.BTdescripcion# <br> -Cuenta Bancaria: #cuenta.CBdescripcion#. <br>El proceso fue cancelado">
	</cfif>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select cf.Dcodigo, cf.CFid, cf.CFcuentaingreso, p.cuentac, o.Ocodigo, p.CFComplemento Complemento
		from Peaje p
			inner join CFuncional cf
				inner join Oficinas o
					on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
				on cf.CFid = p.CFid and cf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		where p.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and p.Pid = <cfqueryparam value="#rsAjustes.Pid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	  <!--- Actividad empresarial --->
	  <cfif len(#rsCFuncional.Complemento#) eq 0>
	    <cfthrow message="Falta definir la Actividad empresarial en el Centro Funcional asociado al peaje">
	  </cfif>
	  <cfset LvarActividad = #rsCFuncional.Complemento#>
	
	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
	<cfset LvarFormatoCuenta = mascara.AplicarMascara(rsCFuncional.CFcuentaingreso,rsCFuncional.cuentac)>
	<cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,REReplace(LvarActividad,"-","","ALL"), '_')>
	
	<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera"
			  method="fnGeneraCuentaFinanciera"
			  returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
				<cfinvokeargument name="Lprm_fecha" 			value="#form.fecha#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
	</cfinvoke>
	<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
			<cf_errorCode	code = "508050"
							msg  = "@errorDat_1@ [@errorDat_2@]"
							errorDat_1="#LvarError#"
							errorDat_2="#LvarFormatoCuenta#"
			>
	</cfif>
	<!--- Se obtiene la Ccuenta por medio del request guardado por la funcion 'fnGeneraCuentaFinanciera'--->
	<cfset Ccuenta = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfset CFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
	<cftransaction>
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTA"
			fecha="#rsAjustes.PAfecha#"
			tipoSocio="0"
			descripcion="#rsAjustes.Pdescripcion#-#rsAjustes.PAdescripcion#"
			referencia="#rsAjustes.Pcodigo#"
			documento="#rsAjustes.PAdocumento#"
			cuentaBancaria="#rsAjustes.CBid#"
			tipoTransaccion="#rsAjustes.BTid#"
			tipocambio="#rsAjustes.tipoCambio#"
			total="#rsAjustes.PAmonto#"		
			empresa="#session.Ecodigo#"
			Ocodigo="#rsCFuncional.Ocodigo#"
			returnvariable="LvarEMid"
		/>
		
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTAD"
			EMid="#LvarEMid#"
			Ecodigo="#session.Ecodigo#"
			Ccuenta="#Ccuenta#"
			CFcuenta="#CFcuenta#"
			Dcodigo="#rsCFuncional.Dcodigo#"
			monto="#rsAjustes.PAmonto#"
			descripcion="#rsAjustes.Pcodigo# - #rsAjustes.PAfecha#"
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
		
		<cfinvoke component="conavi.Componentes.ajustes" method="APLICAR"
			PAid="#form.PAid#"
			estado="2"	
			returnvariable="LvarId"		
		/>
		
	</cftransaction>

	<cflocation url="listaAjustes.cfm">
</cfif>