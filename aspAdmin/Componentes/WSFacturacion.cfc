<cfcomponent displayname="WSFacturacion">
	<cffunction name="TraeFacturas" access="remote" returntype="string">
		<cfargument name="Cuenta" type="string" required="true" default="<!--- Cuenta Maestra de la Empresa--->">
		<cfargument name="Cliente" type="string" required="true" default="<!--- ID Cliente --->">
		<cfargument name="usuario" type="string" required="false" default="<!--- usuario con el que el WS se conecta --->">
		<cfargument name="password" type="string" required="false" default="<!--- pwd del usuario con el que el WS se conecta--->">
		<cfargument name="contrato" type="string" required="true" default="<!--- Numero de Contrato --->">
		<cfargument name="Conexion" type="string" required="true" default="<!--- DSN de conexion para Obtener Facturas --->">
		
		<cfquery name="rsFacturas" datasource="#Conexion#">
			select 
				a.Ecodigo, 
				a.CCTcodigo, 
				a.Ddocumento, 
				a.SNcodigo, 
				a.Mcodigo, 
				a.Dtipocambio, 
				a.Dtotal, 
				a.Dsaldo, 
				a.Dfecha, 
				a.Dvencimiento
			from Documentos a, CCTransacciones b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cuenta#">
			  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cliente#">
			  and a.CCTcodigo = b.CCTcodigo
			  and a.Dsaldo > 0
			  and b.CCTtipo = 'D'
			  and b.CCTvencim != -1
		</cfquery>
		
		<!--- Create an XML document object containing the data --->
		<cfxml variable="facturas">
		   <Contrato>
			   <documentos>
				  <cfoutput query="rsFacturas">
					  <factura numero="#CCTcodigo#-#Ddocumento#">
						<Moneda>#Mcodigo#</Moneda>
						<tipocambio>#Dtipocambio#</tipocambio>
						<total>#Dtotal#</total>
						<saldo>#Dsaldo#</saldo>
						<fechadoc>#Dfecha#</fechadoc>
						<vencimiento>#Dvencimiento#</vencimiento>
					  </factura>
				  </cfoutput>
			   </documentos>
		   </Contrato>
		</cfxml>
		<cfset salida = tostring(facturas)>
		<cfoutput>#salida#</cfoutput>
		<!--- <cfreturn salida> --->
	</cffunction>
</cfcomponent>