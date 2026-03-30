<cfset post = Form.TScodigo>

<cfquery name="rsPassword" datasource="#session.DSN#">
	select a.LGnumero, a.Contratoid, a.LGnumero,
		b.TScodigo, b.PQcodigo, b.SLpassword, b.SLcese, b.Habilitado
	from ISBlogin a
		inner join ISBserviciosLogin b
		on b.LGnumero=a.LGnumero
		and b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
		and b.TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#post#">
		and b.Habilitado=1
	where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
		and a.Habilitado =1
</cfquery>	
<cfset pass = 'pass_'& post>
<cfif isdefined("form.Ant_#post#") and len(trim(Evaluate("form.Ant_#post#")))
	and isdefined("form.pass_#post#") and len(trim(Evaluate("form.pass_#post#")))
	and isdefined("form.pass2_#post#") and len(trim(Evaluate("form.pass2_#post#")))>
	<cfset ant='Ant_'& post>
	<cftransaction>
		<cfquery name="rsVerifica" datasource="#session.DSN#">	
			select	a.LGnumero 
			from	ISBlogin a
				inner join ISBserviciosLogin b
				on b.LGnumero =a.LGnumero
				and b.TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#post#">
				and b.SLpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form[ant]#">
				and b.Habilitado=1 
			where	a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#"> 	
				and a.Contratoid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#"> 	
				and a.Habilitado=1
		</cfquery>
		<cfif rsVerifica.recordCount EQ 1>	
			<cfinvoke component="saci.comp.ISBserviciosLogin"
				method="Cambio" >
				<cfinvokeargument name="LGnumero" value="#rsPassword.LGnumero#">
				<cfinvokeargument name="TScodigo" value="#post#">
				<cfinvokeargument name="PQcodigo" value="#rsPassword.PQcodigo#">
				<cfinvokeargument name="SLpassword" value="#form[pass]#">
				<cfinvokeargument name="SLcese" value="#rsPassword.SLcese#">
				<cfinvokeargument name="Habilitado" value="#rsPassword.Habilitado#">
			</cfinvoke>
			<cfset ExtraParams ='mensCod=1'>
		<cfelse>
			<cfset ExtraParams ='mensCod=2'>
		</cfif>	
	</cftransaction>	
<cfelse>
	<cfset ExtraParams ='mensCod=2'>	
</cfif>

<cfinclude template="gestion-redirect.cfm">
