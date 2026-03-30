<cftransaction>
<cfquery name="rsPassword" datasource="#session.DSN#">
	select a.LGnumero, a.Contratoid, a.LGnumero,
		b.TScodigo, b.PQcodigo, b.SLpassword, b.SLcese, b.Habilitado
	from ISBlogin a
		inner join ISBserviciosLogin b
		on b.LGnumero=a.LGnumero
		and b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
		and b.Habilitado=1
	where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
		and a.Habilitado =1
</cfquery>	
<cfloop query="rsPassword">
	<cfinvoke component="saci.comp.ISBserviciosLogin"
		method="Cambio" >
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="TScodigo" value="#rsPassword.TScodigo#">
		<cfinvokeargument name="PQcodigo" value="#rsPassword.PQcodigo#">
		<cfinvokeargument name="SLpassword" value="#form.SLpassword#">
		<cfinvokeargument name="SLcese" value="#rsPassword.SLcese#">
		<cfinvokeargument name="Habilitado" value="#rsPassword.Habilitado#">
	</cfinvoke>
	<cfset ExtraParams ='mensCod=3'>
</cfloop>
</cftransaction>
<cfinclude template="gestion-redirect.cfm">
