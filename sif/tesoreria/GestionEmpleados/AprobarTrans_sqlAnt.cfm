<cfif IsDefined("form.CalcularTC")>
	<cflocation url="SolAntViaticoTC_form.cfm?GEAid=#form.GEAid#&LvarSAporEmpleadoCFM=#form.LvarSAporEmpleadoCFM#">
</cfif>

<cfif isdefined ('form.Imprimir')>
	<cf_Imprime_Aprobacion location="AprobarTrans.cfm">
		<cflocation url="AprobarTrans.cfm">
</cfif>
<cfset LvarTipo='ANTICIPO'>
<cfquery datasource="#session.dsn#" name="rsAnticipo">
			select GEAtotalOri,CCHTid,GEAmanual, GEAviatico, GEAtipoviatico,<cf_dbfunction name="date_format"	args="GEAdesde,DD/MM/YYYY" > as GEAdesde
			from GEanticipo 
			where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">	
</cfquery>
<cfquery name="rsCajaChica" datasource="#session.dsn#">
	select CCHid,CCHresponsable
	from CCHica 
	where 	CCHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FormaPago#">
	and		Ecodigo=#session.Ecodigo#
</cfquery>

<!---Aprueba la solicitud de Anticipo--->
<cfif IsDefined("form.Aprobar")>
	<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEanticipo_Aprobar">
		<cfinvokeargument name="GEAid"  		value="#form.GEAid#">
		<cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
		<!--- Actualiza la transaccion de caja existente --->
		<cfinvokeargument name="CCHTid"  		value="#rsAnticipo.CCHTid#">
	</cfinvoke>	
	<cfif isdefined ('form.chkImprimir')>
		<!--- <cf_SP_imprimir location="AprobarTrans.cfm"> --->
		<cf_Imprime_Aprobacion location="AprobarTrans.cfm">
	</cfif>
	<cflocation url="AprobarTrans.cfm">
</cfif>


<cfif isdefined('form.Rechazar')><!--- and LvarCancela EQ 0--->>


	
	<!---Actualiza el estado de las transacciones En proceso--->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
			<cfinvokeargument name="CCHTid"    value="#rsAnticipo.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="RECHAZADO"/>
			<cfinvokeargument name="CCHtipo" value="ANTICIPO"/>
		</cfinvoke>
		<!--- Crea las transacciones en seguimiento con el NUEVO ESTADO--->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="SeguimientoT">
			<cfinvokeargument name="CCHTid"      value="#rsAnticipo.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="RECHAZADO"/>
			<cfinvokeargument name="CCHtipo"    value="ANTICIPO"/>
		</cfinvoke> 
	<!--- Actulización del estado del Anticipo--->
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update GEanticipo set
						GEAestado =3,
						GEAmsgRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GEAmsgRechazo#">
			where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cflocation url="AprobarTrans.cfm">
</cfif>

<cfif isdefined ('form.Imprimir')>
	<cf_SP_imprimir location="solicitudesAnticipo.cfm">
</cfif>