<!--- Este componente se encarga de actualizar el campo Usocodigo de una tabla. 
fue realizado por la necesidad de actualizar el el campo Usocodigo antes de eliminar un registro de la tabla--->
<cfcomponent>
	<cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>
	
	<cffunction name="actualizarUsucodigo" returntype="string" >
		<cfargument name="nombreTabla"			type="string" 									required="yes"  hint="nombre de la tabla a actualizar">
		<cfargument name="nombreCampo"			type="string" 	default="Usucodigo"				required="no"  	hint="nombre del campo en donde se realizara la actualizacion">
		<cfargument name="valorCampo" 			type="numeric" 	default="#session.usucodigo#" 	required="no" 	hint="usoCodigo requerido para actualizacion">
		<cfargument name="condicion" 			type="string" 									required="yes" 	hint="usoCodigo requerido para actualizacion">
		<cfargument name="necesitaTransaccion" 	type="boolean" 	default="true" 					required="no" 	hint="indica si necesita o no un proceso transaccional">

		
		<!--- Si no se envia el DataSource se busca de Session --->
		<cfif not isdefined('Arguments.datasource') and isdefined('Session.dsn')>
            <cfset Arguments.datasource = Session.dsn>
        </cfif>
        
         <!--- Si no se envia la empresa se busca de Session --->
		<cfif not isdefined('Arguments.Ecodigo') and isdefined('Session.Ecodigo')>
            <cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
		
        <cftry><!---trata de actualizar la tabla, en el caso contrario devuelve el error--->
			
			<cfif #Arguments.necesitaTransaccion# eq true >
				
				<!--- comienza transaccion para asegurar proceso de actualizacion--->
				<cftransaction>
					<cfquery datasource="#Arguments.datasource#">
						update #preservesinglequotes(Arguments.nombreTabla)#
						set #preservesinglequotes(Arguments.nombreCampo)# = #preservesinglequotes(Arguments.valorCampo)#
						where #preservesinglequotes(Arguments.condicion)#
					</cfquery>
				</cftransaction>
					
			<cfelse>
					<cfquery datasource="#Arguments.datasource#">
						update #preservesinglequotes(Arguments.nombreTabla)#
						set #preservesinglequotes(Arguments.nombreCampo)# = #preservesinglequotes(Arguments.valorCampo)#
						where #preservesinglequotes(Arguments.condicion)#
					</cfquery>
			</cfif>

				<cfreturn "Y">
				
		<cfcatch>

				<cfreturn #cfcatch.detail#>
				
		</cfcatch>
		
		</cftry>

		
	</cffunction>
</cfcomponent>