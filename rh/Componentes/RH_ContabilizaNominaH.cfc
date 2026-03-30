
<cfcomponent>
	<cffunction name="ContabilizaNominaH" access="public" output="true"  returntype="any">
		<cfargument name="conexion" 		type="string" 	required="no" default="#Session.DSN#">		
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		<cfargument name="RCNid"   			type="numeric" 	required="yes">
		<cfargument name="Usucodigo" 		type="numeric" 	required="yes" default="#session.Usucodigo#">
		<cfargument name="Ulocalizacion" 	type="string" 	required="no" default="00">
		<cfargument name="debug" 			type="boolean" 	required="no" default="false">

		
        <cfquery name="rsDocumentos" datasource="#session.DSN#">
			select RHEnumero, Periodo, Mes
			  from RHEjecucion
			 where RCNid = #Arguments.RCNid#
			order by RHEnumero
		</cfquery>
        
       <cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from RHParametros 
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 25
		</cfquery>

		<!--- Default unificado --->
		<cfset LvarUnificarGastosCargas = (rsSQL.Pvalor NEQ "0")>
        
        
		<!--- Genera Asiento Contable: (Gastos sin unificar) o (Gastos y Cargas Unificadas) --->
        <cfif LvarUnificarGastosCargas>
            <!--- Asiento Unificado: Gastos y Cargas) --->
            <cfinvoke 
                component="rh.Componentes.RH_PagoNomina"
                method="sbAsientoContable"
                returnvariable="Vsalida"> 
                <cfinvokeargument name="RCNid" value="#Arguments.RCNid#"/>
                <cfinvokeargument name="RHEnumero" value="#rsDocumentos.RHEnumero#"/>
                <cfinvokeargument name="Tipo" value="U"/>
                <cfinvokeargument name="historico" value="true"/>
            </cfinvoke>               
        <cfelse>
            <!--- Asiento No Unificado: Gastos --->
            <cfinvoke 
                component="rh.Componentes.RH_PagoNomina"
                method="sbAsientoContable"
                returnvariable="Vsalida"> 
                <cfinvokeargument name="RCNid" value="#Arguments.RCNid#"/>
                <cfinvokeargument name="RHEnumero" value="#rsDocumentos.RHEnumero#"/>
                <cfinvokeargument name="Tipo" value="G"/>
                <cfinvokeargument name="historico" value="true"/>
            </cfinvoke> 
            <!--- Asiento No Unificado: Cargas --->
             <cfinvoke 
                component="rh.Componentes.RH_PagoNomina"
                method="sbAsientoContable"
                returnvariable="Vsalida2"> 
                <cfinvokeargument name="RCNid" value="#Arguments.RCNid#"/>
                <cfinvokeargument name="RHEnumero" value="#rsDocumentos.RHEnumero#"/>
                <cfinvokeargument name="Tipo" value="C"/>
                <cfinvokeargument name="historico" value="true"/>
            </cfinvoke> 
        </cfif>

		<cfif isdefined("Vsalida")>
			<cfreturn Vsalida >
		</cfif>
		<cfif isdefined("Vsalida2")>
			<cfreturn Vsalida2 >
		</cfif>

	</cffunction>
</cfcomponent>