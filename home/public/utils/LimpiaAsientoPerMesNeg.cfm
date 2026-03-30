<!--- 
			5 Agosto 2010
			Se eliminan posibles registros inconsistentes en la tabla de Asientos Contables.
			Los registros inconsistentes se podrían generar por el manejo de la transacción en la aplicación de asientos contables.
			El asiento se aplica utilizando una transacción, y los registros se eliminan de la tabla de asientos en proceso en otra transacción.
			Si el proceso termina entre ambas transacciones, pueden quedar registros inconsistentes en las estructuras.
			
			Se identifican por tener los valores de Periodo y Mes en negativo.

			Solicitado por Mauricio Esquivel
		--->
	<cfif not isdefined("session.Ecodigo") or session.Ecodigo LT 1 or not isdefined("session.DSN") or len(trim(session.dsn)) EQ 0>
		<p>NO se han definido correctamente los parametros o no está firmado en el sistema</p>
		<p>Proceso Cancelado</p>
		<cfabort>
	</cfif>

	<cfparam name="Arguments.Conexion" default="#session.DSN#">
	<cfparam name="Arguments.Ecodigo" default="#session.Ecodigo#">

	<table cellspacing="2" cellpadding="2">
		<tr>
			<td colspan="7" align="center"><strong>Asientos Inconsistentes a Borrar</strong>
		</tr>
		<tr>
			<td colspan="7" align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="right"><strong>Asiento</strong></td>
			<td align="right"><strong>Periodo</strong></td>
			<td align="right"><strong>Mes</strong></td>
			<td align="right"><strong>Cantidad Lineas</strong></td>
			<td align="right"><strong>Periodo Historico</strong></td>
			<td align="right"><strong>Mes Historico</strong></td>
			<td align="right"><strong>Borrado</strong></td>
		</tr>

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
			<cfset Borrado = " ">

			<cfquery name="rs_AsientosBorrarHistoria" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad, min(Eperiodo) as PeriodoEnc, min(Emes) as MesEnc
				from HEContables
				where IDcontable = #LvarAsientosBorrar_IDcontable#
			</cfquery>

			<cfif LvarAsientosBorrar_IDcontable GT 0 and LvarAsientosBorrar_Eperiodo LT 0 and LvarAsientosBorrar_Emes LT 0 and rs_AsientosBorrarHistoria.Cantidad GT 0>
				<cfset Borrado = "SI">
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
			<cfoutput>
			<tr>
				<td align="right">#LvarAsientosBorrar_IDcontable#</td>
				<td align="right">#LvarAsientosBorrar_Eperiodo#</td>
				<td align="right">#LvarAsientosBorrar_Emes#</td>
				<td align="right">#rs_AsientosBorrarHistoria.Cantidad#</td>
				<td align="right">#rs_AsientosBorrarHistoria.PeriodoEnc#</td>
				<td align="right">#rs_AsientosBorrarHistoria.MesEnc#</td>
				<td align="right">#Borrado#</td>
			</tr>
			</cfoutput>
		</cfloop>
	</table>
