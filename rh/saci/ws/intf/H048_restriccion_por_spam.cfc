<cfcomponent extends="base">
	<cffunction name="tiene_restriccion" access="public" returntype="boolean" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">
		<cfargument name="cedula" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<cfset control_inicio( Arguments, 'H048' & ' - ' & Arguments.cedula)>
		<cftry>
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="spam">
				exec ss154_Verif_Restriccion_SPAM 
				  @cCLTCED = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.cedula)#">
				, @ctipo_salida = '0'
				, @cresultado = '0'
				, @vmensaje = '0'
			</cfquery>
	
		<cfset control_final( )>
	 	
		<cfif spam.resultado is 'V'>
			<cfset control_mensaje( 'ISB-0025', 'La cédula #Arguments.cedula# tiene restricción por spam.' )>
			<cfreturn true> 	
		<cfelse>
			<cfset control_mensaje( 'ISB-0025', 'La cédula #Arguments.cedula# no tiene restricción por spam.' )>
			<cfreturn false> 	
		</cfif>
		
		
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
			<cfreturn false>	
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>