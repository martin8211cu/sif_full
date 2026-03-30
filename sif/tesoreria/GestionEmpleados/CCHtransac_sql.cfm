<!---                                                                 Limpiar                                                                     --->
<cfif isdefined ('form.Limpiar')>
	<cflocation url="CCHtransac.cfm?Nuevo=nuevo">
</cfif>


<!---                                                                 Nuevo                                                                      --->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="CCHtransac.cfm?Nuevo=nuevo">
</cfif>

<!---                                                                  Regresar                                                                  --->
<cfif isdefined ('form.Regresar')>
	<cflocation url="CCHtransac.cfm">
</cfif>

<!---                                                                 Regresar1                                                                 --->
<cfif isdefined ('form.Regresar1')>
	<cflocation url="CCHtransacA.cfm">
</cfif>

<!---                                                                 Rechazo                                                                   --->
<cfif isdefined ('form.Rechazar')>
	<cfif len(trim(form.motivo)) eq 0>
		<cf_errorCode	code = "50733" msg = "Debe de indicar el motivo de rechazo">
	</cfif>
	<cfquery name="rsRechaza" datasource="#session.dsn#">
		update CCHTransaccionesProceso set CCHTmsj='#form.motivo#',CCHTestado='EN PROCESO', CCHTmonto = 0 where CCHTid=#form.CCHTid#
	</cfquery>
    <cfquery name="dl1" datasource="#session.dsn#">
        delete  from STransaccionesProceso where CCHTid=#form.CCHTid#
    </cfquery>
	<cflocation url="CCHtransacA.cfm">
</cfif>

<!---                                                                 Agregar                                                                  --->
<cfif isdefined ('form.Agregar')>
	<!---<cfquery name="valida" datasource="#session.dsn#">
		select count(1) as cantidad from CCHTransaccionesProceso where
		CCHTestado='EN PROCESO' and CCHid=#form.CCHid# and Ecodigo=#session.Ecodigo#
		and CCHTtipo in ('APERTURA','REINTEGRO','CIERRE','AUMENTO','DISMINUCION')
	</cfquery>
	
	<cfif valida.cantidad gt 0>
		<cf_errorCode	code = "50734" msg = "No se puede tener dos transacciones en proceso">
	</cfif>
	--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFcuenta, Mcodigo, CCHresponsable from CCHica where CCHid=#form.CCHid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif NOT LEN(TRIM(form.montoA))>
    	<cfthrow message="El monto de las transaccion es Invalido [#form.montoA#]">
    </cfif>
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TranProceso" returnvariable="LvarCCHTidProc">
		<cfinvokeargument name="Mcodigo" 		 value="#rsSQL.Mcodigo#"/>
		<cfinvokeargument name="CFcuenta" 		 value="#rsSQL.CFcuenta#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHTestado" 	 value="EN PROCESO"/>
		<cfinvokeargument name="CCHTmonto" 		 value="#replace(form.montoA,',','','ALL')#"/>
		<cfinvokeargument name="CCHTidCustodio"  value="#rsSQL.CCHresponsable#"/>
		<cfinvokeargument name="CCHTtipo" 		 value="#form.Tipo#"/>
		<cfinvokeargument name="CCHid" 			 value="#form.CCHid#"/>
	</cfinvoke>
	
	<cfquery name="rsCFid" datasource="#session.dsn#">
		select CFid from CCHica where CCHid= #form.CCHid# and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select count(1) as cantidad
		from TESusuarioSP
		where CFid = #rsCFid.CFid#
			and Usucodigo  = #session.Usucodigo#
			and TESUSPaprobador = 1
	</cfquery>

	<cfif form.tipo eq 'REINTEGRO'>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="UP_importes">
			<cfinvokeargument name="CCHid"					 value="#form.CCHid#"/>
			<cfinvokeargument name="CCHTid" 				 value="#LvarCCHTidProc#"/>
			<cfinvokeargument name="CCHIreintegroEnProceso"  value="#replace(form.montoA,',','','ALL')#"/>			
		</cfinvoke>
	</cfif>
	<cfif rsSPaprobador.cantidad gt 0>
		<cflocation url="CCHtransac.cfm?CCHTid=#LvarCCHTidProc#&Apro=1">
	<cfelse>
		<cflocation url="CCHtransac.cfm?CCHTid=#LvarCCHTidProc#&CCHid=#form.CCHid#">
	</cfif>
	
</cfif>


<!---                                                                 Enviar a Aprobar                                                                  --->
<cfif isdefined ('form.Enviar')>

	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
		<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
		<cfinvokeargument name="CCHTtipo" value="#form.tipo#"/>
		<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoA,',','','ALL')#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
		<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
	</cfinvoke>
	
	<cflocation url="CCHtransac.cfm">
</cfif>


<!---                                                                 Aprobar                                                                         --->
<cfif isdefined ('form.Aprobar')>
	<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
	<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHTestado,CCHTtipo,CCHTdescripcion,coalesce(SEC_NAP,0) as SEC_NAP from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
	</cfquery>

	<cftransaction>
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
			<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
			<cfinvokeargument name="CCHTtipo" value="#rsSQL.CCHTtipo#"/>
			<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoAP,',','','ALL')#"/>
			<cfinvokeargument name="CCHTdescripcion" value="#rsSQL.CCHTdescripcion#"/>
			<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
		</cfinvoke>
		
		<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION CCH"/>
				<cfinvokeargument name="CCHtipo" 	value="#rsSQL.CCHTtipo#"/>
			</cfinvoke>	
		</cfif>
		
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CFcuenta,CCHresponsable,Mcodigo,CFid,CCHtipo as CCHtipo_caja from CCHica where CCHid=#form.CCHid#
		</cfquery>
		<!---crear solicitud de pago--->
		<cfif rsSQL.CCHTtipo eq 'AUMENTO'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="crearSP" returnvariable="TESSPid">
				<cfinvokeargument name="CCHtipo" 			value="8">
				<cfinvokeargument name="DEid" 				value="#rsCCH.CCHresponsable#"> 
				<cfinvokeargument name="CCHfechaPagar" 		value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
				<cfinvokeargument name="Mcodigo" 			value="#rsCCH.Mcodigo#"> 			
				<cfinvokeargument name="CCHtotalOri" 		value="#replace(form.montoAP,',','','ALL')#"> 		
				<cfinvokeargument name="CFid" 				value="#rsCCH.CFid#"> 
				<cfinvokeargument name="CFcuenta"  			value="#rsCCH.CFcuenta#"> 			
				<cfinvokeargument name="CCHdescripcion" 	value="#rsSQL.CCHTdescripcion#">  
				<cfinvokeargument name="CCHtransaccion"  	value="#form.CCHTid#"> 
				<cfinvokeargument name="CCHcod"  			value="#form.CCHcod#"> 
				<cfinvokeargument name="CCHTid"    			value="#form.CCHTid#">
				<cfinvokeargument name="CCHreferencia"    	value="#rsSQL.CCHTtipo#">
			</cfinvoke>	
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION TES"/>
				<cfinvokeargument name="CCHtipo" 	value="#rsSQL.CCHTtipo#"/>
				<cfinvokeargument name="CCHTrelacionada" 	value="#TESSPid#"/>
				<cfinvokeargument name="CCHTtrelacionada" 	value="Solicitud de Pago"/>
			</cfinvoke>	
		<cfelseif rsSQL.CCHTtipo eq 'REINTEGRO'>
			<cfif rsSQL.SEC_NAP gt 0>
                <cfset form.CCHcod = form.CCHcod&'- #rsSQL.SEC_NAP#'>
            </cfif>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="crearSPreintegro" returnvariable="TESSPid">
				<cfinvokeargument name="CCHid" 				value="#form.CCHid#">
				<cfinvokeargument name="CCHtipo_caja"		value="#rsCCH.CCHtipo_caja#">
				<cfinvokeargument name="DEid" 				value="#rsCCH.CCHresponsable#"> 
				<cfinvokeargument name="CCHfechaPagar" 		value="#LSDateFormat(now(),'DD/MM/YYYY')#"> 
				<cfinvokeargument name="Mcodigo" 			value="#rsCCH.Mcodigo#"> 			
				<cfinvokeargument name="CCHtotalOri" 		value="#replace(form.montoAP,',','','ALL')#"> 		
				<cfinvokeargument name="CFid" 				value="#rsCCH.CFid#"> 
				<cfinvokeargument name="CFcuenta"  			value="#rsCCH.CFcuenta#"> 			
				<cfinvokeargument name="CCHdescripcion" 	value="#rsSQL.CCHTdescripcion#">  
				<cfinvokeargument name="CCHtransaccion"  	value="#form.CCHTid#"> 
				<cfinvokeargument name="CCHcod"  			value="#form.CCHcod#"> 
				<cfinvokeargument name="CCHTid"	    		value="#form.CCHTid#">
				<cfinvokeargument name="CCHreferencia"    	value="#rsSQL.CCHTtipo#">
			</cfinvoke>	
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="EN APROBACION TES"/>
				<cfinvokeargument name="CCHtipo" 	value="#rsSQL.CCHTtipo#"/>
				<cfinvokeargument name="CCHTrelacionada" 	value="#TESSPid#"/>
				<cfinvokeargument name="CCHTtrelacionada" 	value="Solicitud de Pago"/>
			</cfinvoke>	
		<cfelseif rsSQL.CCHTtipo eq 'CIERRE' or rsSQL.CCHTtipo eq 'DISMINUCION'>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 	value="#form.CCHTid#"/>
				<cfinvokeargument name="CCHTestado" value="POR CONFIRMAR"/>
				<cfinvokeargument name="CCHtipo" 	value="#rsSQL.CCHTtipo#"/>
			</cfinvoke>	
		</cfif>
	</cftransaction>
	
	<cfif isdefined('form.entrada') and len(trim(form.entrada)) gt 0>
		<cflocation url="CCHtransacA.cfm">
	<cfelse>
		<cflocation url="CCHtransac.cfm">
	</cfif>
</cfif>


<!---                                                                 Eliminar                                                                              --->
<cfif isdefined ('form.Eliminar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHTestado from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
	</cfquery>
		<cfif rsSQL.CCHTestado eq 'EN PROCESO'>
			<cfquery name="dl1" datasource="#session.dsn#">
				delete  from STransaccionesProceso where CCHTid=#form.CCHTid#
			</cfquery>
			<cfquery name="dl1" datasource="#session.dsn#">
				delete  from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50732" msg = "No se puede eliminar una transacción que tiene estado diferente a 'EN PROCESO'">
		</cfif>
		<cflocation url="CCHtransac.cfm">
</cfif>

<!---                                                                 Modificar                                                                       --->
<cfif isdefined ('form.Modificar')>
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="modificarTP">
		<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
		<cfinvokeargument name="CCHTtipo" value="#form.tipo#"/>
		<cfinvokeargument name="CCHTmontoA" value="#replace(form.montoA,',','','ALL')#"/>
		<cfinvokeargument name="CCHTdescripcion" value="#form.descrip#"/>
		<cfinvokeargument name="CCHid" value="#form.CCHid#"/>
	</cfinvoke>
	<cflocation url="CCHtransac.cfm?CCHTid=#form.CCHTid#&CCHid=#form.CCHid#">
</cfif>

	<cfset CCHTestado = "POR CONFIRMAR">
<!---                                                              Ingresar Deposito                                                                  --->
<cfif isdefined ('form.Ingresar')>

	<cfquery name="rsLinea" datasource="#session.dsn#">
		select CCHDlinea from CCHdepositos where CCHTid=#form.CCHTid#
	</cfquery>
	
	<cfif rsLinea.recordcount eq 0>
		<cfset Linea=1>
	<cfelse>
		<cfset Linea= rsLinea.CCHDlinea+1>	
	</cfif>
	
	<cfquery name="inDep" datasource="#session.dsn#">
		insert into CCHdepositos(
			CCHTid,
			CCHDreferencia,
			CCHDlinea,
			Ecodigo,
			CCHDfecha,
			CCHDtipoCambio,
			CCHDtotalOri,
			CCHDtotal,
			CBid,
			BTid,
			BMUsucodigo,
			Mcodigo)
		values
			(	
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHTid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Linea#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.fechadep,'DD/MM/YYYY')#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.tipoCambio,',','','ALL')#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.totalD,',','','ALL')#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.montoDep,',','','ALL')#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(form.CBid, 1, '|')#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(form.CBid, 2, '|')#">
			)
	</cfquery>
	<cflocation url="CCHtransac.cfm?CCHTtipo=#form.CCHTtipo#&CCHTid=#form.CCHTid#&CCHTestado=#CCHTestado#">
</cfif>

<!---                                                             nuevo Deposito                                                                     --->
<cfif isdefined('form.NuevoD')>
	<cflocation url="CCHtransac.cfm?CCHTtipo=#form.CCHTtipo#&CCHTid=#form.CCHTid#&CCHTestado=#CCHTestado#">
</cfif>

<!---                                                              Eliminar Deposito                                                                  --->
<cfif isdefined('form.EliminarD')>
	<cfquery name="elDepo" datasource="#session.dsn#">
		delete from CCHdepositos where CCHDid=#form.CCHDid#
	</cfquery>
	<cflocation url="CCHtransac.cfm?CCHTtipo=#form.CCHTtipo#&CCHTid=#form.CCHTid#&CCHTestado=#CCHTestado#">
</cfif>

<!---                                                             Modificar Deposito                                                                  --->
<cfif isdefined('form.ModificarD')>
	<cfquery name="upDepo" datasource="#session.dsn#">
		update CCHdepositos
			set 
			CCHDreferencia=		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.referencia#">,
			CCHDfecha=			<cfqueryparam cfsqltype="cf_sql_date" value="#form.fechadep#">,
			CCHDtipoCambio=		<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.tipoCambio,',','','ALL')#">,
			CCHDtotalOri=		<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.totalD,',','','ALL')#">,
			CCHDtotal=			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.montoDep,',','','ALL')#">,
			CBid=				<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(form.CBid, 1, '|')#">,
			BTid=				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">,
			Mcodigo=			<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(form.CBid, 2, '|')#">
		where CCHDid=#form.CCHDid#
	</cfquery>
	<cflocation url="CCHtransac.cfm?CCHTtipo=#form.CCHTtipo#&CCHTid=#form.CCHTid#&CCHTestado=#CCHTestado#&CCHDid=#form.CCHDid#">
</cfif>

<!---                                                              Regresar Depositos                                                                 --->
<cfif isdefined('form.RegresarD')>

<cflocation url="CCHtransac.cfm?CCHTestado=#CCHTestado#">
</cfif>

<!---                                                                      Confirmar                                                                  --->
<cfif isdefined('form.Confirmar')>

	<cfquery name="tot" datasource="#session.dsn#">
		select sum(CCHDtotalOri) as total from CCHdepositos where CCHTid=#form.CCHTid#
	</cfquery>
	
	<cfif tot.total gt 0>
		<cfset tota=#replace(tot.total,',','','ALL')#>
	<cfelse>
		<cfset tota=0>
	</cfif>

	<cfif tota lt replace(form.montoT,',','','ALL')>
		<cf_errorCode	code = "50735" msg = "No se puede insertar este deposito porque es menor que el monto aceptable">
	</cfif>

		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="sbContabilidadDeposito">
			<cfinvokeargument name="CCHTid" value="#form.CCHTid#"/>
		</cfinvoke>		
	
<cflocation url="CCHtransac.cfm">
</cfif>

