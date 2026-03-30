<cfset didsometing = false>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfset Request.CEnombre = rsCE.CEAliaslogin>
<cfif isdefined("form.cmdEstructura")>
		<cfinclude template="parametrosInterfaz-estructura.cfm">
		<cfabort>
</cfif>
<cfif isdefined("form.doit")>
	<cfparam name="form.spFinalTipo"	default="N">
	<cfparam name="form.spFinal"		default="">
	<cfparam name="form.minutosAborto"	default="">
	<cfif form.spFinalTipo EQ "C">
		<cfif NOT fileExists(expandPath(form.spFinal))>
			<cfthrow message="No existe el fuente '#form.spFinal#' del Componente Coldfusion spFinal">
		</cfif>
	</cfif>
	<cfparam name="form.TipoRetardo" default="M">
	<cfparam name="form.ProcesosPorRequest" default="0">
	<cfquery datasource="sifinterfaces">
		update Interfaz
			set Componente 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Componente#"> 
				, TipoRetardo	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoRetardo#"> 
				<cfif form.TipoRetardo EQ "M">
					<cfif form.MinutosRetardo eq "">
						<cfset LvarMinutosRetardo = "0">
					<cfelse>
						<cfset LvarMinutosRetardo = form.MinutosRetardo>
					</cfif>
				<cfelse>
					<cfif form.MinutosRetardoHH eq "">
						<cfset LvarMinutosRetardoHH = "0">
					<cfelse>
						<cfset LvarMinutosRetardoHH = form.MinutosRetardoHH>
					</cfif>
					<cfif form.MinutosRetardoMM eq "">
						<cfset LvarMinutosRetardoMM = "0">
					<cfelse>
						<cfset LvarMinutosRetardoMM = form.MinutosRetardoMM>
					</cfif>
					<cfset LvarMinutosRetardo = form.MinutosRetardoHH*60 + form.MinutosRetardoMM>
				</cfif>
				, MinutosRetardo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMinutosRetardo#"> 
				, MinutosAborto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MinutosAborto#" null="#form.MinutosAborto EQ "" OR form.MinutosAborto LT "5"#"> 
				, Activa 		= <cfif isdefined("form.Activa")>1<cfelse>0</cfif>
				, spFinalTipo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.spFinalTipo#"> 
				, spFinal		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.spFinal#" null="#find(form.spFinalTipo,"SC") EQ 0#"> 
				, ProcesosPorRequest = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ProcesosPorRequest#"> 
				, eMailErrores	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnEmails(form.eMailErrores)#" null="#find ("@",form.eMailErrores) EQ 0#"> 
		where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#"> 
	</cfquery>
	<cfset didsometing = true>
	<cflocation url="parametrosInterfaz.cfm?NumeroInterfaz=#form.NumeroInterfaz#">
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
					set spFinalTipo = 'N'
					  , spFinal 	= null
				  where spFinalTipo = 'D'
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

<cflocation url="parametrosInterfaz.cfm">

<cffunction name="fnEmails" output="no" access="private" returntype="string">
	<cfargument name="eMails" required="yes">
	
	<cfset var x=Arguments.eMails>
	<cfset x=replace(x," ",";","ALL")>
	<cfset x=replace(x,"#chr(10)#",";","ALL")>
	<cfset x=replace(x,"#chr(13)#",";","ALL")>
	<cfset x=replace(x,";;",";","ALL")>
	<cfset x=listToArray(x,";")>
	<cfloop index="i" from="1" to="#ArrayLen(x)#">
		<cfif NOT find ("@",x[i])>
			<cfset x[i] = "">
		</cfif>
		<cfset x[i] = trim(x[i])>
	</cfloop>
	<cfset x=ArrayToList(x,";")>
	<cfset x=replace(x,";;",";","ALL")>
	<cfset x=replace(x,";",";#chr(13)##chr(10)#","ALL")>
	<cfif find(";",x) GT 1>
		<cfset x &= ";">
	</cfif>
	
	<cfreturn trim(x)>
</cffunction>
