<!---verificamos que haya al menos un servicio por conservar--->

<cfif isdefined("session.saci.cambioPQ")>	
	
	<cfset conservarL = session.saci.cambioPQ.logConservar.login>
	<cfset conservarS = session.saci.cambioPQ.logConservar.servicios>
	<cfif listLen(servConservar)>
		<cfset conservarL = conservarL & IIF(len(trim(conservarL)),DE(','),DE(''))& logConservar>
		<cfset conservarS = conservarS &IIF(len(trim(conservarS)),DE(','),DE(''))& servConservar>
	</cfif>
	
	<cfif not listLen(conservarL)>
		<cfset mensajeError=mensajeError & " Debe existir al menos un servicio por conservar para el nuevo paquete.">
	</cfif>
	
	<cfif listLen(conservarL)>
		
		<cfquery datasource="#session.DSN#" name="rsCantidadServicios">
			select a.TScodigo, a.SVcantidad, a.SVminimo
			from ISBservicio a 
			where a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
				and a.Habilitado=1
				and a.TScodigo != 'CABM'
		</cfquery>
		
		<cfif rsCantidadServicios.RecordCount GT 0>
			<cfset muchos = "">
			<cfset pocos = "">
			<cfloop query="rsCantidadServicios">
		
				<cfif ListValueCount(conservarS, rsCantidadServicios.TScodigo,',') GT rsCantidadServicios.SVcantidad> 
					<cfset muchos = rsCantidadServicios.TScodigo>
				</cfif>
				<cfif rsCantidadServicios.SVminimo GT  ListValueCount(conservarS, rsCantidadServicios.TScodigo,',')> 
					<cfset pocos = rsCantidadServicios.TScodigo>
				</cfif>
			</cfloop>
			
			<cfif len(muchos)><cfset mensajeError=" La cantidad de servicios de tipo #muchos# es mayor a la cantidad de servicios m&aacute;ximos que puede poseer el paquete."></cfif>
			<cfif len(pocos)><cfset mensajeError=mensajeError & " La cantidad de servicios de tipo #pocos# es menor a la cantidad de servicios m&iacute;nimos que puede poseer el paquete."></cfif>
		</cfif>
	</cfif>
</cfif>

