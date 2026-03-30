<cfif isdefined("url.Snumero") and len(trim(url.Snumero)) and isdefined("url.LGnumero") and len(trim(url.LGnumero)) and isdefined("url.conexion") and Len(Trim(url.conexion))>
	<!--- Desasignar sobre asignado anteriormente --->
	<cfquery name="rsSobre" datasource="#session.dsn#">
		select Snumero
		from ISBlogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(url.LGnumero)#">
	</cfquery>
	<cfif Len(Trim(rsSobre.Snumero))>
		<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
			<cfinvokeargument name="Snumero" value="#Trim(rsSobre.Snumero)#">
		</cfinvoke>
	</cfif>

	<!--- Asignar el nuevo sobre al Login --->
	<cfinvoke component="saci.comp.ISBlogin" method="Asignar_Sobre">
		<cfinvokeargument name="LGnumero" value="#Trim(url.LGnumero)#">
		<cfinvokeargument name="Snumero" value="#Trim(url.Snumero)#">
	</cfinvoke>

	<!--- Asignar el login al sobre --->
	<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
		<cfinvokeargument name="Snumero" value="#Trim(url.Snumero)#">
		<cfinvokeargument name="LGnumero" value="#Trim(url.LGnumero)#">
	</cfinvoke>
</cfif>
