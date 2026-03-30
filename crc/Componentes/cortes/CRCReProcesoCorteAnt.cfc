<cfcomponent displayname="CRCReProcesoCorte" extends="crc.Componentes.cortes.CRCProcesoCorte" hint="Recalcula el corte en los estados de saldo vencido calculado(2) y monto a pagar(1). Extiende del componente de proceos de corte">

	<cffunction name="reProcesarCorte">
		<cfargument name="cuentaID" type ="string" required="false" default="">  
		<cfargument name="dsn" type ="string" required="false" default="#session.DSN#">  
		<cfargument name="ecodigo" type ="string" required="false" default="#this.Ecodigo#">  
    
		<!--- se procesan el corte en estado dos donde esta involucrada la cuenta--->
		<cfset cCorte = createobject("component", "crc.Componentes.cortes.CRCCortes").init(TipoCorte = "",
																					       conexion  = #arguments.dsn#, 
																					       ECodigo   = #arguments.ecodigo#)>	 
		<cfset init(isReproceso=true)>
		<cfset this.isReproceso=true>
		<cfset inicializarParametros()>
		<cfset validarArgumentoTipoCuenta(cuentaID=#arguments.cuentaID#)>
		<cfset This.cortesAnteriores = cCorte.obtenerCortePorStatus(Tipo_Producto=#This.Tipo_Producto#, status = 2)>
		<cfset this.cortesACerrar = cCorte.obtenerCortePorStatus(Tipo_Producto=#This.Tipo_Producto#, status = 1)>
 		
		<cfif  This.cortesAnteriores neq ''>
			<cfset calculoParaCorteAnterior()>
			<cfset CrearActualizarMccPorCortes(cortes=#This.cortesAnteriores#, anterior=true)>
		</cfif>

		<cfif This.cortesACerrar neq ''>
			<cfset calculoParaMC()>
			<cfset CrearActualizarMccPorCortes(cortes=#This.cortesACerrar# , anterior=false)>	
		</cfif>

		<cfif  This.cortesAnteriores neq ''>
			<cfset afectarSoloSAldo(#arguments.cuentaID#)>
		</cfif>

		<cfset actualizarCuentas()>

		<cfset actualizarEstadoCuenta()>
	      
	</cffunction>

 


</cfcomponent>