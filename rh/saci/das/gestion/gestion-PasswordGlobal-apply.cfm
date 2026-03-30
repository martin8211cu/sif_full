
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

<cfif form.rol EQ "DAS">			<!---Reset de password --->
	
	<cfinvoke component="saci.comp.random-password" returnvariable="clave" method="Generar">
		<cfinvokeargument name="LGnumero" value="#form.logg#">
	</cfinvoke>
	
	<cftransaction>	
		<cfloop query="rsPassword">
			<cfinvoke component="saci.comp.ISBlogin" method="CambioPassword" >			<!---Realiza el cambio de password--->
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="TScodigo" value="#rsPassword.TScodigo#">
				<cfinvokeargument name="SLpassword" value="#clave#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBserviciosLogin" method="conVigencia" >			<!---Pone como plazo de vigencia un dia para que el cliente cambie su password--->
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="TScodigo" value="#rsPassword.TScodigo#">
			</cfinvoke>
		</cfloop>
		<cfif rsPassword.RecordCount EQ 0>
			<cfset ExtraParams ='mensCod=4'>
		<cfelse>
			<cfset ExtraParams ='mensCod=3&cl=#clave#'>
		</cfif>
	</cftransaction>
<cfelse>							<!---Cambio de password --->	
	<cftransaction>	
		<cfloop query="rsPassword">
			<cfinvoke component="saci.comp.ISBlogin" method="CambioPassword" >
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="TScodigo" value="#rsPassword.TScodigo#">
				<cfinvokeargument name="SLpassword" value="#form.SLpassword#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBserviciosLogin" method="sinVigencia" >			<!---Pone como plazo de vigencia un dia para que el cliente cambie su password--->
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="TScodigo" value="#rsPassword.TScodigo#">
			</cfinvoke>
		</cfloop>
		<cfif rsPassword.RecordCount EQ 0>
			<cfset ExtraParams ='mensCod=4'>
		<cfelse>
			<cfset ExtraParams ='mensCod=3'>
		</cfif>
	</cftransaction>
</cfif>


