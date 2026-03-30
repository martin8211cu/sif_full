<cfcomponent hint="Ver SACI-03-H038a.doc" extends="base">
	<cffunction name="bloqueo900" access="public" returntype="void">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="MDbloqueado" type="boolean" required="yes">
		<cfargument name="MBmotivo" type="string" default="S">
		<cfargument name="telefono" type="string" required="yes">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="S02CON" type="string" default="0">
		
		
		<cfset control_inicio( Arguments, 'H038a','Origen : ' & Arguments.origen & ' - ' & Arguments.paquete & ' - ' & Arguments.telefono & ' - Bloquear : ' & Arguments.MDbloqueado)>
		<cftry>
							
			<cfif Arguments.paquete is 'T'>	
				<cfquery datasource="#session.dsn#" name="ISBmedioCia">
					select EMid 
					from ISBmedioCia
				</cfquery>
						
				<cfquery datasource="#session.dsn#" name="ISBmedio">										
					If not exists(Select 1 from ISBmedio
					Where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">)
						insert isb.dbo.ISBmedio 
						(MDref
						, MDbloqueado
						, MDBloqueadoPrepago
						, EMid
						, MBmotivo
						, Habilitado
						, BMUsucodigo
						, MDlimite)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MDbloqueado#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBmedioCia.EMid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MBmotivo#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="36">)
					Else									
						update ISBmedio set 
							MDbloqueado = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MDbloqueado#">,
							MBmotivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MBmotivo#">
						from ISBmedio 
						where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">
				</cfquery>
					
			</cfif>				
					
	
			<cfif Arguments.paquete is 'P'>			     			
				<cfquery datasource="#session.dsn#" name="ISBmedioCia">
					select EMid 
					from ISBmedioCia
				</cfquery>
						
				<cfquery datasource="#session.dsn#" name="ISBmedio">										
					If not exists(Select 1 from ISBmedio
					Where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">)
					insert ISBmedio 
					(MDref
					, MDbloqueado
					, MDBloqueadoPrepago
					, EMid
					, MBmotivo
					, Habilitado
					, BMUsucodigo
					, MDlimite)
					values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MDbloqueado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBmedioCia.EMid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="S">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="36">)
					Else									
					update ISBmedio set 
						MDBloqueadoPrepago = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.MDbloqueado#">,
						MBmotivo = 'S'
					from ISBmedio 
					where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">
				</cfquery>
			</cfif>
				
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
			S02CON="#Arguments.S02CON#"
			Error="#Request._saci_intf.Error#"/>
	
		</cfcatch>
		</cftry>
		
	</cffunction>
</cfcomponent>