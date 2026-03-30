<!--- 
			5 Agosto 2010
			Se eliminan posibles registros inconsistentes en la tabla de Asientos Contables.
			Los registros inconsistentes se podrían generar por el manejo de la transacción en la aplicación de asientos contables.
			El asiento se aplica utilizando una transacción, y los registros se eliminan de la tabla de asientos en proceso en otra transacción.
			Si el proceso termina entre ambas transacciones, pueden quedar registros inconsistentes en las estructuras.
			
			Se identifican por tener los valores de Periodo y Mes en negativo.

			Solicitado por Mauricio Esquivel
		--->
<cfparam name="Arguments.Conexion" default="minisif">
<cfparam name="Arguments.Ecodigo" default="1">

		<cfquery name="rs_AsientosBorrar" datasource="#Arguments.Conexion#">
			select IDcontable, Eperiodo, Emes
			from EContables
			where Ecodigo = #arguments.Ecodigo#
			  and Eperiodo < 0
			  and Emes     < 0  
		</cfquery>

		<cfloop query="rs_AsientosBorrar">
			<cfset LvarAsientosBorrar_IDcontable = rs_AsientosBorrar.IDcontable>
			<cfset LvarAsientosBorrar_Eperiodo   = rs_AsientosBorrar.Eperiodo>
			<cfset LvarAsientosBorrar_Emes       = rs_AsientosBorrar.Emes>

			<cfquery name="rs_AsientosBorrarHistoria" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad
				from HEContables
				where IDcontable = #LvarAsientosBorrar_IDcontable#
			</cfquery>
            <cfdump var="#rs_AsientosBorrarHistoria#">

			<cfif LvarAsientosBorrar_IDcontable GT 0 and LvarAsientosBorrar_Eperiodo LT 0 and LvarAsientosBorrar_Emes LT 0 and rs_AsientosBorrarHistoria.Cantidad GT 0>
				<cftransaction>
					<cfquery datasource="#Arguments.Conexion#">
						delete from DContables 
						where IDcontable = #LvarAsientosBorrar_IDcontable#
					</cfquery>
                
					<cfquery datasource="#Arguments.Conexion#">
						delete from EContables 
						where IDcontable = #LvarAsientosBorrar_IDcontable#
					</cfquery>
                    <cftransaction action="commit"/>
				</cftransaction>
			</cfif>
		</cfloop>