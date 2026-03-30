<!--- Pasos:
		1- Verifica Presupuesto
		2- Verifica Disponible en caja
		3- Inicia Transacción
		4- Actualiza el estado de la transacción
		5- Componente que crea la Transacción en proceso (Crea las transacciones en seguimiento---Actualiza el estado de las transacciones En proceso)
		6- Actulización del estado del Anticipo
		7- 
--->
<!--- Valida El Usuario Aprobador--->

	<cfquery datasource="#session.dsn#" name="rsAnticipo">
			select 
					a.GEAid,
					a.GEAtotalOri,
					a.CCHTid, 
					a.CFid,
					a.Mcodigo,
					a.GEAdescripcion,
					a.GEAtotalOri
			from GEanticipo a
			where a.GEAID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">	
	</cfquery>
	
	<cfquery name="rsCajaChica" datasource="#session.dsn#">
			select 
					CCHid,
					CCHresponsable,
					CCHtipo
			from CCHica 
			where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">
			and		Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfset LvarCCHTid=rsAnticipo.CCHTid>
	<cfquery name="rsSPaprobador" datasource="#session.dsn#">
		Select TESUSPmontoMax, TESUSPcambiarTES
		from TESusuarioSP
	 	where CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.CFid#"> 
		and Usucodigo	= #session.Usucodigo#
		and TESUSPaprobador = 1
	</cfquery>
<!--- Valida El Usuario Aprobador--->

<cftransaction>
	<!--- Invoka componente de Presupuesto--->
	<cfinvoke component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="ReservaAnticipo">
		<cfinvokeargument name="GEAid" 			value="#rsAnticipo.GEAid#"/>	
		<cfinvokeargument name="CCHtipoCaja" 	value="#rsCajaChica.CCHtipo#"/>	
	</cfinvoke>	
	
	<!---Inserta en transacciones Aplicadas.--->
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="TAplicadas">
		<cfinvokeargument name="CCHid"    				value="#rsCajaChica.CCHid#"/>
		<cfinvokeargument name="Mcodigo" 				value="#rsAnticipo.Mcodigo#"/>
		<cfinvokeargument name="CCHTdescripcion"    	value="#rsAnticipo.GEAdescripcion#"/>
		<cfinvokeargument name="CCHTestado"		    	value="APLICADO"/>
		<cfinvokeargument name="CCHTmonto"   			value="#rsAnticipo.GEAtotalOri#"/>
		<cfinvokeargument name="CCHTidCustodio"    		value="#rsCajaChica.CCHresponsable#"/>
		<cfinvokeargument name="Sufijo" 				value="ANTICIPO"/>
		<cfinvokeargument name="CCHTid"    				value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTtipo"		    	value="ANTICIPO"/>
	</cfinvoke>	
	
	<!---Actualiza el estado de las transacciones En proceso He inserta en seguimiento--->
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
		<cfinvokeargument name="CCHTid"    			value="#LvarCCHTid#"/>
		<cfinvokeargument name="CCHTestado" 		value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHtipo"    		value="#url.LvarTipo#"/>
		<cfinvokeargument name="CCHTrelacionada"    value="#rsAnticipo.GEAid#"/>
		<cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
	</cfinvoke>	
	
	<!--- Actulización del estado del Anticipo--->
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update GEanticipo set 
				GEAestado =2, 
				CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">,
				GEAtipoP=0
		where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<!--- Crea la transaccion del Custodio--->
	<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="TranCustodioP" returnvariable="LvarCCHTCid">
		<cfinvokeargument name="CCHTCestado"        value="POR CONFIRMAR"/>
		<cfinvokeargument name="CCHTtipo"       	value="#url.LvarTipo#"/>
		<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
		<cfinvokeargument name="CCHTCrelacionada"   value="#url.GEAid#"/>
		<cfinvokeargument name="CCHTid"         	value="#url.LvarCCHTidProc#"/>
	</cfinvoke>  
</cftransaction>

<cfif isdefined ('url.referencia') and referencia eq 'SA'>
	<cflocation url="solicitudesAnticipo.cfm">
<cfelse>
	<cflocation url="AprobarTrans.cfm">
</cfif>
