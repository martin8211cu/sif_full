<cfset didsometing = false>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfset Request.CEnombre = rsCE.CEAliaslogin>
<cfif isdefined("form.cmdEstructura")>
		<cfinclude template="parametros-estructura.cfm">
		<cfabort>
</cfif>
<cfif isdefined("form.doit")>
	<cfquery datasource="sifinterfaces">
		update Interfaz
			set Componente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Componente#"> 
				, MinutosRetardo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MinutosRetardo#" null="#len(form.MinutosRetardo) EQ 0#"> 
				, Activa = <cfif isdefined("form.Activa")>1<cfelse>0</cfif>
				, ejecutarSpFinal = <cfif isdefined("form.ejecutarSpFinal")>'S'<cfelse>'N'</cfif>
		where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#"> 
	</cfquery>
	<cfset didsometing = true>
</cfif>
<cfif isdefined("form.dointerfaz")>
	<cfquery datasource="sifinterfaces">
		update Interfaz
			set Activa = 1
		where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#"> 
	</cfquery>
	<cfset didsometing = true>
</cfif>
<cfif isdefined("form.undointerfaz")>
	<cfquery datasource="sifinterfaces">
		update Interfaz
			set Activa = 0
		where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#"> 
	</cfquery>
	<cfset didsometing = true>
</cfif>
<cfif isdefined("form.doMotor")>
	<cftry>
		<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
		<cfset StructDelete(Application.interfazSoin,"CE_#session.CEcodigo#")>
		<cfset rsMotor = LobjColaProcesos.fnActivarMotor (session.CEcodigo, form.UrlServidorMotor, true)>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
				set Activo = 1, MsgError = null
					 , urlServidorMotor = '#rsMotor.urlServidorMotor#'
					 , spFinal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.spFinal#">
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
		<cfif trim(form.spFinal) EQ "">
			<cfquery datasource="sifinterfaces">
				update Interfaz
					set ejecutarSpFinal = 'N'
				<!--- where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#"> --->
			</cfquery>
		</cfif>
	<cfcatch>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
				set urlServidorMotor = '#trim(form.UrlServidorMotor)#'
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
	</cfcatch>
	</cftry>

	<cfset didsometing = true>
</cfif>
<cfif isdefined("form.undoMotor")>
	<cfquery datasource="sifinterfaces">
		update InterfazMotor
			set Activo = 0
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
	</cfquery>
	<cfset didsometing = true>
	<cfschedule action		= "delete"
				task		= "Tarea Asincrona Motor Interfaces #session.CEcodigo#" 
	>
	<cfschedule action		= "delete"
				task		= "Tarea Asincrona Motor Interfaces CE=#session.CEcodigo#" 
	>
</cfif>