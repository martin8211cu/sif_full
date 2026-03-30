<cfcomponent>
<cffunction name="AgendaMedica" access="public" returntype="numeric">

	<cfargument name="create" type="boolean" default="no">
	<cfargument name="throw" type="boolean" default="yes">

	<cfquery datasource="#session.dsn#" name="AgendaMedicaQuery">
		select Pvalor
		from RHParametros
		where Pcodigo = 220
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif Len(AgendaMedicaQuery.Pvalor)>
		<cfquery datasource="asp" name="VerSiExisteAgenda">
			select * from ORGAgenda
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AgendaMedicaQuery.Pvalor#">
		</cfquery>
		<cfif VerSiExisteAgenda.RecordCount>
			<cfreturn AgendaMedicaQuery.Pvalor>
		</cfif>
	</cfif>
	
	<cfif not Arguments.Create>
		<cfif Arguments.throw>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Error1"
			Default="Todavía no se ha definido la agenda médica.<br>El médico de empresa u otro responsable debe definir el horario para las citas médicas."
			returnvariable="LB_Error1"/> 
			<cf_throw message="#LB_Error1#" errorCode="12000">
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cfif>
	
	<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
	<cfset newValue = ComponenteAgenda.CrearAgenda('R', 
		session.datos_personales.nombre & ' ' & session.datos_personales.apellido1 &
		' ' & session.datos_personales.apellido2)>
	<cfset This.UsarAgenda(newValue)>
	<cfreturn newValue>
</cffunction>

<cffunction name="UsarAgenda" output="false" access="public">
	
	<cfargument name="agenda" type="numeric" required="yes">

	<cfinvoke component="home.Componentes.Agenda" method="InfoAgenda" returnvariable="Info">
		<cfinvokeargument name="agenda" value="#Arguments.agenda#">
		<cfinvokeargument name="permiso" value="propietario">
	</cfinvoke>
	
	<cfquery datasource="#session.dsn#" name="existe">
		select * from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 220
	</cfquery>

	<cfif existe.RecordCount Is 0>
		<cfquery datasource="#session.dsn#">
			insert RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				220, 'Agenda Médica',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Agenda#">)
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			update RHParametros 
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Agenda#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 220
		</cfquery>
	</cfif>	

</cffunction>

</cfcomponent>