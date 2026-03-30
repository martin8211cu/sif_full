<cfparam name="form.Autorizacion" default="false">
<cfif form.Autorizacion>
	<cfset USRInicia = 'Autorizacion'>
<cfelse>
	<cfset USRInicia = 'Usuario'>
</cfif>
<cfset ComProyRenta  = createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<!---►►►Eliminar◄◄◄--->
<cfif isdefined('form.BTNEliminar')>
	<cftransaction>
		<cfquery datasource="#session.DSN#">
			delete from RHDLiquidacionRenta				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>
        <cfquery datasource="#session.DSN#">
			delete from RHRentaOrigenes				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>	
		<cfquery datasource="#session.DSN#">
			delete from RHLiquidacionRenta				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>
        <cfset param = "&DEid="&form.DEid>
     </cftransaction>
<!---►►►Enviar a Autorización◄◄◄--->
<cfelseif isdefined('form.BTNEnviar_a_Autorizacion')>
	<cftransaction>
		<cfset ComProyRenta.CambioRHLiquidacionRenta(form.RHRentaId,10)>
	</cftransaction>
	<cfset param = "&DEid="&form.DEid>
<!---►►►Rechazar◄◄◄--->
<cfelseif isdefined('form.BTNRechazar')>
	<cftransaction>
		<cfset ComProyRenta.CambioRHLiquidacionRenta(form.RHRentaId,20)>
	</cftransaction>
	<cfset param = "&DEid="&form.DEid>
<!---►►►Finalizar◄◄◄--->
<cfelseif isdefined('form.BTNFinalizar')>
		<cftransaction>
			<cfset ComProyRenta.CambioRHLiquidacionRenta(form.RHRentaId,30,form.RentaAnual,form.RentaRetenida,form.ImpuestoRetener,form.RetenidoExceso,form.RentaImponible,form.ImpuestoAnualDet,form.CreditoIVA)>
		</cftransaction>
        <cfset param = "&DEid="&form.DEid>
<!---►►►Regresar◄◄◄--->
<cfelseif isdefined('form.BTNRegresar')>
	<cfset param = "&DEid="&form.DEid>
<!---►►►Guardar◄◄◄--->
<cfelseif isdefined('form.BTNGuardar') or isdefined('form.BTNAplicar')>
	
    <cfset rsFRentaBruta = ComProyRenta.GetLineasReporte('GLRB')>
    <cfset rsFDeduc 	 = ComProyRenta.GetLineasReporte('GLRD')>      
	<!---Se obtiene la renta de otros/Ex Empleados configurada--->
    <cfquery datasource="#session.DSN#" name="rsOrigenes">
        select RHROid 
            from RHRentaOrigenes 
        where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
    </cfquery>
    <cftransaction>
    	<!---Se Actualiza la Renta de Otros/Ex Patrones --->
        <cfloop query="rsOrigenes">
            <cfquery datasource="#session.DSN#">	
                update RHRentaOrigenes set 
                    <cfif form.Autorizacion>
                   		RentaNetaAut = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.rentaOtrasA#rsOrigenes.RHROid#'),',','','all')#">,
                    <cfelse>
                    	RentaNetaEmp = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.rentaOtrasE#rsOrigenes.RHROid#'),',','','all')#">,
                    </cfif>
                        BMfechaalta  = <cf_dbfunction name="now">,
                        BMUsucodigo  = #session.Ecodigo#
                where RHROid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrigenes.RHROid#">										
            </cfquery>
        </cfloop>
        <cfoutput query="rsFRentaBruta">
            <cfset result = InsUpdRHDLiquidacionRenta(form.RHRentaId,rsFRentaBruta.RHCRPTid,form.Autorizacion)>
        </cfoutput>
        <cfoutput query="rsFDeduc">
            <cfset result = InsUpdRHDLiquidacionRenta(form.RHRentaId,rsFDeduc.RHCRPTid,form.Autorizacion)>
        </cfoutput>
    </cftransaction>

    <!---►►►Actualización de los montos del Encabezado◄◄◄--->
    	<cfif not isdefined('form.RHLRentaRetenida')><cfset form.RHLRentaRetenida = -1></cfif>
        <cfif not isdefined('form.RHLIVAplanilla_A')><cfset form.RHLIVAplanilla_A = -1></cfif>
        
    	<cfset ComProyRenta.UpdMontosRHLiquidacionRenta(form.RHRentaId,replace(form.RHLIVAplanilla_A,',',''),replace(form.RHLIVAplanilla_E,',',''),replace(form.RHLRentaRetenida,',',''))>
    <cfset param = "&DEid="&form.DEid&'&RHRentaId='&form.RHRentaId>
</cfif>
<cfif form.Autorizacion>
	<cflocation url="/cfmx/rh/nomina/liquidacionRenta/liquidacionRentaGTA.cfm?#param#">	
<cfelse>
	<cflocation url="liquidacionRenta.cfm?#param#">	
</cfif>
<!---►►►Manejo del Detalle de las lineas de la Liquidacion, Actualiza o Inserta dependiente de si ya existe la linea◄◄◄--->
    <cffunction name="InsUpdRHDLiquidacionRenta" access="public" returntype="void">
        <cfargument name="RHRentaId" 	type="numeric" required="true">
        <cfargument name="RHCRPTid" 	type="numeric" required="true">
        <cfargument name="Autorizacion" type="boolean" required="yes">
      
        <cfset Observaciones = "">
        <cfset MontoHistorico  = Replace(Evaluate('Calculado#Arguments.RHCRPTid#'),',','','all')>
        <cfset MontoEmpleado   = Replace(Evaluate('Empleado#Arguments.RHCRPTid#'),',','','all')>
        <cfif Arguments.Autorizacion>
                <cfset MontoAutorizado = Replace(Evaluate('Autorizado#Arguments.RHCRPTid#'),',','','all')>
            <cfif isdefined('Observaciones#Arguments.RHCRPTid#') and Evaluate('Observaciones#Arguments.RHCRPTid#') NEQ 'Sin Observaciones'>
                <cfset Observaciones   = Evaluate('Observaciones#Arguments.RHCRPTid#')>
            </cfif>
        <cfelse>
                <cfset MontoAutorizado = -1>
        </cfif>
                <cfset ComProyRenta.CambioRHDLiquidacionRenta(Arguments.RHRentaId,Arguments.RHCRPTid,MontoHistorico,MontoEmpleado,MontoAutorizado,Observaciones)>
        <cfreturn>
    </cffunction>