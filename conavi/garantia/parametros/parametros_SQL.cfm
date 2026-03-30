<cfif isdefined('form.CAMBIO')>
	<cftransaction>
	<cfif len(trim(form.CFid)) gt 0>
		<cfif form.hayCFSolicitud eq '1'>
			<cfset a = updateDato(3200,form.CFid)>
		<cfelseif form.hayCFSolicitud eq '0'>
			<cfset b = insertDato(3200,'GP','Centro Funcional para Solictud de Garantía',form.CFid)>
		</cfif>
	</cfif>
	<cfif len(trim(form.consecutivo)) gt 0>
		<cfquery name="rsConseGarantiaH" datasource="#session.DSN#">
			select coalesce(max(COEGReciboGarantia),1) as consecutivo
			from COHEGarantia
			where COEGVersionActiva = 1 <!--- Activa --->
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfquery name="rsConseGarantia" datasource="#session.DSN#">
			select coalesce(max(COEGReciboGarantia),1) as consecutivo
			from COEGarantia
			where COEGVersionActiva = 1 <!--- Activa --->
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfif rsConseGarantia.consecutivo gt rsConseGarantiaH.consecutivo>
			<cfset LvarConsecutivoSugerido = rsConseGarantia.consecutivo>
		<cfelse>
			<cfset LvarConsecutivoSugerido = rsConseGarantiaH.consecutivo>
		</cfif>
		<cfif LvarConsecutivoSugerido gte form.consecutivo>
			<cfthrow message="El consecutivo debe de ser mayor al ultimo numero de garantía generado(#LvarConsecutivoSugerido#).">
		</cfif>
		<cfset insertDato(4000,'GP','Consecutivo Recibo Número de Garantia',form.consecutivo)>
	</cfif>
	</cftransaction>
	<cflocation url="parametros_form.cfm">
</cfif>


<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >		
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="mcodigo" type="string" required="true">
	<cfargument name="pdescripcion" type="string" required="true">
	<cfargument name="pvalor" type="string" required="true">			
	
	
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros 
		where Ecodigo = #Session.Ecodigo#
		 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
				)
		</cfquery>	
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>			
	</cfif>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="updateDato" >					
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="pvalor" type="string" required="true">
	<cfquery name="updDato" datasource="#Session.DSN#">
		update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>