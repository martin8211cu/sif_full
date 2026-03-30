<cfcomponent extends="Interfaz_Base" output="yes">
	<cffunction name="Ejecuta" access="public" returntype="any" output="yes">
		<cfargument name="Disparo" required="no" type="boolean" default="true">

		<cfquery name="rsGetParam02" datasource="sifinterfaces">
			SELECT Pvalor
			FROM SIFLD_ParametrosAdicionales
			WHERE Pcodigo = '00002'
		</cfquery>

		<cfset varSoloCorteZ = false>
		<cfif rsGetParam02.RecordCount GT 0 AND rsGetParam02.Pvalor EQ 1>
			<cfset varSoloCorteZ = true>
		</cfif>

		<cfif varSoloCorteZ EQ false>
			<!--- PROCESO NORMAL POR DETALLE --->
			<cfinvoke component="ModuloIntegracion.Componentes.LD_interfaz_CG_Ventas_PorDetalle" method="Ejecuta">
		    	<cfinvokeargument name="Disparo" value="true"/>
		    </cfinvoke>
		<cfelse>
			<!--- PROCESO SOLO POR CORTE Z --->
			<cfinvoke component="ModuloIntegracion.Componentes.LD_interfaz_CG_Ventas_CorteZ" method="Ejecuta">
		    	<cfinvokeargument name="Disparo" value="true"/>
		    </cfinvoke>
		</cfif>
	</cffunction>
</cfcomponent>
