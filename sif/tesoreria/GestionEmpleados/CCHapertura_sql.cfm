<!---Agregar--->
<cfif isdefined ('form.Agregar')>
	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad from CCHica where CCHcodigo=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">
	</cfquery>
	
	<cfif rsSQL.cantidad gt 0>
		<cf_errorCode	code = "50727" msg = "El código de la caja chica ya existe en el sistema">
	</cfif>

	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select 
				<cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo
			from 
				Empresas
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	<cfif NOT ISDEFINED('form.McodigoOri') OR NOT LEN(TRIM(form.McodigoOri))>
    	<cfthrow message="No se envio la moneda Origen">
    </cfif>
	<cfquery name="TCsug" datasource="#session.dsn#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo  = <cf_jdbcquery_param value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and tc.Hfecha  <= <cf_dbfunction name="now">
		  and tc.Hfechah  > <cf_dbfunction name="now">
		  and Mcodigo=#form.McodigoOri#
	</cfquery>  
	<cfif rsMonedaLocal.Mcodigo neq form.McodigoOri>
    	<cfif NOT TCsug.RecordCount>
    		<cfthrow message="No se pudo obtener el tipo de cambio de Venta">
    	</cfif>
        <cftry>
			<cfset montoCaja=#replace(form.asignado,',','','ALL')#*#TCsug.TCventa#>
        	<cfcatch type="any">
        		<cfthrow message="No se pudo calcular el Monto de la Caja, Monto Asignado [#replace(form.asignado,',','','ALL')#], Tipo de Cambio [#TCsug.TCventa#]">
            </cfcatch>
        </cftry>
	<cfelse>
		<cfset montoCaja=#replace(form.asignado,',','','ALL')#>
	</cfif>
	
	<cfquery name="rsValida" datasource="#session.dsn#">
		select CCHCmonto from CCHconfig where Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfif montoCaja gt rsValida.CCHCmonto>
		<cf_errorCode	code = "50728" msg = "No se puede registrar la caja porque el monto asignado sobrepasa el monto máximo configurado para las Cajas Chicas">
	</cfif>

	<cfif form.CCHtipo EQ 1 AND form.CFcuentaRecepcion NEQ "">
		<cfset form.CFcuentaRecepcion = "">
	<cfelseif (form.CCHtipo EQ 2 or form.CCHtipo EQ 3) AND form.CFcuentaRecepcion EQ "">
		<cfthrow type="toUser" message="La Cuenta Transitoria para Recepcion de Efectivo es obligatoria para este tipo de Caja">
	</cfif>

	<cftransaction>
		<cfif form.CCHtipo EQ 3>
			<cfset LvarError = "">
			<cfset form.CFcuenta = form.CFcuentaRecepcion>
			<cfquery name="inSQL" datasource="#session.dsn#">
				insert into CCHica(
					CFcuenta, CFcuentaRecepcion,
					Ecodigo,
					CFid,
					Mcodigo,
					CCHcodigo,
					CCHdescripcion,
					CCHestado,
					CCHmax,
					CCHmin,
					CCHminSaldo,
					CCHmontoA,
					CCHresponsable,
					BMUsucodigo,
					BMfecha,
					CCHtipo,
					TESidCCH     
				)
				values
				(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaRecepcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVA">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
					<cfqueryparam cfsqltype="cf_sql_money" value="0">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					#session.usucodigo#,
					<cf_dbfunction name="today">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESidCCH#" null="true">
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="inSQL">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="inSQL" returnvariable="LvarCCHid">
			<cfset form.CCHid=#LvarCCHid#>
	
			<cfquery name="inserCF" datasource="#session.dsn#">
				insert into CCHicaCF (
					CCHid,
					CFid,
					Ecodigo)
					values
				(
					#form.CCHid#,
					#form.CFid#,
					#session.Ecodigo#		
				)
			</cfquery>
		
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" value="#form.McodigoOri#"/>
				<cfinvokeargument name="CFcuenta" value="#form.CFcuenta#"/>
				<cfinvokeargument name="CCHTdescripcion" value="Apertura de Caja"/>
				<cfinvokeargument name="CCHTestado" value="EN PROCESO"/>
				<cfinvokeargument name="CCHTmonto" value="#replace(form.asignado,',','','ALL')#"/>
				<cfinvokeargument name="CCHTidCustodio" value="#form.DEid#"/>
				<cfinvokeargument name="CCHTtipo" value="APERTURA"/>
				<cfinvokeargument name="CCHid" value="#LvarCCHid#"/>
			</cfinvoke>
		<cfelse>
			<cfquery name="inSQL" datasource="#session.dsn#">
				insert into CCHica(
					CFcuenta, CFcuentaRecepcion,
					Ecodigo,
					CFid,
					Mcodigo,
					CCHcodigo,
					CCHdescripcion,
					CCHestado,
					CCHmax,
					CCHmin,
					CCHminSaldo,
					CCHmontoA,
					CCHresponsable,
					BMUsucodigo,
					BMfecha,
					CCHtipo,
					TESidCCH     
				)
				values
				(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuenta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaRecepcion#" null="#form.CFcuentaRecepcion EQ ""#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="EN PROCESO">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Maximo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Minimo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MinimoSaldo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.asignado,',','','ALL')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					#session.usucodigo#,
					<cf_dbfunction name="today">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESidCCH#">
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="inSQL">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="inSQL" returnvariable="LvarCCHid">
			<cfset form.CCHid=#LvarCCHid#>
	
			<cfquery name="inserCF" datasource="#session.dsn#">
				insert into CCHicaCF (
					CCHid,
					CFid,
					Ecodigo)
					values
				(
					#form.CCHid#,
					#form.CFid#,
					#session.Ecodigo#		
				)
			</cfquery>
		
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
				<cfinvokeargument name="Mcodigo" value="#form.McodigoOri#"/>
				<cfinvokeargument name="CFcuenta" value="#form.CFcuenta#"/>
				<cfinvokeargument name="CCHTdescripcion" value="Apertura de Caja"/>
				<cfinvokeargument name="CCHTestado" value="EN PROCESO"/>
				<cfinvokeargument name="CCHTmonto" value="#replace(form.asignado,',','','ALL')#"/>
				<cfinvokeargument name="CCHTidCustodio" value="#form.DEid#"/>
				<cfinvokeargument name="CCHTtipo" value="APERTURA"/>
				<cfinvokeargument name="CCHid" value="#LvarCCHid#"/>
			</cfinvoke>
	
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#LvarCCHTidProc#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHtipo" 	value="APERTURA"/>
			</cfinvoke>	
		
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="importes" returnvariable="LvarError">
				<cfinvokeargument name="CCHid" value="#LvarCCHid#"/>
				<cfinvokeargument name="CCHTid" value="#LvarCCHTidProc#"/>
			</cfinvoke>
		
			<cfquery name="rsCod" datasource="#session.dsn#">
				select CCHcod from CCHTransaccionesProceso where CCHTid=#LvarCCHTidProc#
			</cfquery>
			
			<cfquery name="rsCuenta" datasource="#session.dsn#">
				select CFcuenta from CCHica where CCHid=#LvarCCHid#
			</cfquery>
			
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="crearSP" returnvariable="TESSPid">
				<cfinvokeargument name="CCHtipo" 			value="8">
				<cfinvokeargument name="DEid" 				value="#form.DEid#"> 
				<cfinvokeargument name="CCHfechaPagar" 		value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
				<cfinvokeargument name="Mcodigo" 			value="#form.McodigoOri#"> 			
				<cfinvokeargument name="CCHtotalOri" 		value="#replace(form.asignado,',','','ALL')#"> 		
				<cfinvokeargument name="CFid" 				value="#form.CFid#"> 
				<cfinvokeargument name="CFcuenta"  			value="#rsCuenta.CFcuenta#"> 			
				<cfinvokeargument name="CCHdescripcion" 	value="Apertura de la caja: #form.descrip#">  
				<cfinvokeargument name="CCHtransaccion"  	value="#LvarCCHTidProc#"> 
				<cfinvokeargument name="CCHcod"  			value="#form.codigo#"> 
				<cfinvokeargument name="CCHTid"   	 		value="#LvarCCHTidProc#">
				<cfinvokeargument name="CCHreferencia"    	value="Apertura de caja">
			</cfinvoke>
			
			<cfset TESSPid=#TESSPid#>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#LvarCCHTidProc#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION TES"/>
				<cfinvokeargument name="CCHtipo" 	value="APERTURA"/>
				<cfinvokeargument name="CCHTrelacionada" 	value="#TESSPid#"/>
				<cfinvokeargument name="CCHTtrelacionada" 	value="Solicitud de Pago"/>
			</cfinvoke>	
		</cfif>
	</cftransaction>
	<cflocation url="CCHapertura.cfm?CCHid=#LvarCCHid#&LvarE=#LvarError#">
</cfif>

<!---Regresar--->
<cfif isdefined ('form.Regresar')>
	<cflocation url="CCHapertura.cfm">
</cfif>

<!---Nuevo--->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="CCHapertura.cfm?Nuevo=nuevo">
</cfif>

<cfif isdefined ('form.Limpiar')>
	<cflocation url="CCHapertura.cfm?Nuevo=nuevo">
</cfif>

<!---Modificar--->
<cfif isdefined ('form.modificar')>
	<cfif form.CCHtipo EQ 1 AND isdefined('form.CFcuentaRecepcion') and form.CFcuentaRecepcion NEQ "">
		<cfset form.CFcuentaRecepcion = "">
	<cfelseif (form.CCHtipo EQ 2 or form.CCHtipo EQ 3) AND isdefined('form.CFcuentaRecepcion') and form.CFcuentaRecepcion EQ "">
		<cfthrow type="toUser" message="La Cuenta Transitoria para Recepcion de Efectivo es obligaria para este tipo de Caja">
	</cfif>
	<cfquery name="rsMod" datasource="#session.dsn#">
		update CCHica set 
			CCHdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descrip#">,
			CCHmax=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Maximo#">,
			CCHmin=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Minimo#">,
			CCHminSaldo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MinimoSaldo#">,
			CCHtipo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHtipo#">,
			TESidCCH=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESidCCH#">,
			CCHunidadReintegro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#REPLACE(form.CCHunidadReintegro,",","","ALL")#">
            <cfif isdefined('form.CFcuentaRecepcion')>
				,CFcuentaRecepcion=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaRecepcion#" null="#form.CFcuentaRecepcion EQ ""#">
            </cfif>

			<cfif isdefined ('form.suspender')>
				,CCHestado='SUSPENDIDA'
			</cfif>
		where CCHid=#form.CCHid#		
	</cfquery>
	<cflocation url="CCHapertura.cfm?CCHid=#form.CCHid#">
</cfif>

<!---Transacciones--->
<cfif isdefined ('form.Transacciones')>
	<cflocation url="CCHapertura.cfm?CCHid=#form.CCHid#&Transac=1">
</cfif>

<!---Centro Funcional--->
<cfif isdefined ('form.cFuncional')>
	<cflocation url="CCHapertura.cfm?CCHid=#form.CCHid#&Cfunc=1">
</cfif>


<!---Eliminar--->
<cfif isdefined ('form.Eliminar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHestado from CCHica where CCHid=#form.CCHid#
	</cfquery>
	<cfquery name="importe" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid=#form.CCHid#
	</cfquery>

		<cfif rsSQL.CCHestado eq 'EN PROCESO'>	
			<cfquery name="del" datasource="#session.dsn#">
				delete from CCHImportes where CCHid=#form.CCHid#
			</cfquery>
			<cfquery name="del" datasource="#session.dsn#">
				delete from CCHica where CCHid=#form.CCHid#
			</cfquery>
		<cfelse>
			<cfquery name="valida1" datasource="#session.dsn#">
				select count(1) as cantidad from GEanticipo where CCHid=#form.CCHid# and GEAestado in (0,1,2)
			</cfquery>
				<cfif valida1.cantidad gt 0>
					<cf_errorCode	code = "50729" msg = "No se puede eliminar la caja porque tiene Anticipos relacionados">
				</cfif>
			<cfquery name="valida2" datasource="#session.dsn#">
				select count(1) as cantidad from GEliquidacion where CCHid=#form.CCHid# and GELestado  in (0,1,2)
			</cfquery>
				<cfif valida2.cantidad gt 0>
					<cf_errorCode	code = "50730" msg = "No se puede eliminar la caja porque tiene Liquidaciones relacionadas">
				</cfif>
			<cfquery name="valida3" datasource="#session.dsn#">
				select count(1) as cantidad from CCHTransaccionesProceso where CCHid=#form.CCHid# and CCHTestado in ('EN PROCESO','EN APROBACION CCH','EN APROBACION TES','POR CONFIRMAR')
			</cfquery>
				<cfif valida3.cantidad gt 0>
					<cf_errorCode	code = "50731" msg = "No se puede eliminar la caja porque tiene Transacciones por realizar">
				</cfif>
			<cfif valida1.cantidad eq 0 and valida2.cantidad eq 0 and valida3.cantidad eq 0>
				<cfquery name="del" datasource="#session.dsn#">
					delete from CCHImportes where CCHid=#form.CCHid#
				</cfquery>
				<cfquery name="del" datasource="#session.dsn#">
					delete from CCHica where CCHid=#form.CCHid#
				</cfquery>
			</cfif>		
		</cfif>


	<!---<cflocation url="CCHapertura.cfm">--->
</cfif>

<!---Agregar Centros Funcionales--->
<cfif isdefined ('form.agregaCF')>
	<cfquery name="inserCF" datasource="#session.dsn#">
		insert into CCHicaCF (
			CCHid,
			CFid,
			Ecodigo)
			values
		(
			#form.CCHid#,
			#form.CFid#,
			#session.Ecodigo#		
		)
	</cfquery>
	<cflocation url="CCHapertura.cfm?CCHid=#form.CCHid#&Cfunc=1">
</cfif>

<!---Nuevo Centros Funcionales--->
<cfif isdefined ('form.nuevoCF')>
	<cflocation url="CCHapertura.cfm?Cfunc=1&CCHid=#form.CCHid#">
</cfif>

<!---Eliminar Centros Funcionales--->
<cfif isdefined ('form.eliminaCF')>
	<cfquery name="delCF" datasource="#session.dsn#">
		delete from CCHicaCF where CFid=#form.CFid# and CCHid=#form.CCHid#
	</cfquery>
	<cflocation url="CCHapertura.cfm?CCHid=#form.CCHid#&Cfunc=1">
</cfif>

