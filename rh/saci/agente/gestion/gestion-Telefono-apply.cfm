<cftransaction>	
	<cfquery name="rsLogin" datasource="#session.DSN#">
		select LGnumero, Contratoid, Snumero, LGlogin, LGrealName, LGvacationMsg, LGmailQuota, LGroaming, LGprincipal, LGapertura, LGcese, LGserids, Habilitado, LGbloqueado, LGmostrarGuia, LGtelefono, BMUsucodigo 
		from ISBlogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
			and Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pkg#">
			and Habilitado=1
	</cfquery>
	<cfinvoke component="saci.comp.ISBlogin"
		method="Cambio" >
		<cfinvokeargument name="LGnumero" value="#rsLogin.LGnumero#">
		<cfinvokeargument name="Contratoid" value="#rsLogin.Contratoid#">
		<cfinvokeargument name="Snumero" value="#rsLogin.Snumero#">
		<cfinvokeargument name="LGlogin" value="#rsLogin.LGlogin#">
		<cfinvokeargument name="LGrealName" value="#rsLogin.LGrealName#">
		<cfinvokeargument name="LGmailQuota" value="#rsLogin.LGmailQuota#">
		<cfinvokeargument name="LGroaming" value="#rsLogin.LGroaming#">
		<cfinvokeargument name="LGprincipal" value="#rsLogin.LGprincipal#">
		<cfinvokeargument name="LGapertura" value="#rsLogin.LGapertura#">
		<cfinvokeargument name="LGcese" value="#rsLogin.LGcese#">
		<cfinvokeargument name="LGserids" value="#rsLogin.LGserids#">
		<cfinvokeargument name="Habilitado" value="#rsLogin.Habilitado#">
		<cfinvokeargument name="LGbloqueado" value="#rsLogin.LGbloqueado#">
		<cfinvokeargument name="LGmostrarGuia" value="#rsLogin.LGmostrarGuia#">
		<cfinvokeargument name="LGtelefono" value="#form.nuevoLGtelefono#">
	</cfinvoke>
</cftransaction>	

<cfinclude template="gestion-redirect.cfm">
