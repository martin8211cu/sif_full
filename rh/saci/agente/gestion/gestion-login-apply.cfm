<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&rol=#form.rol#&paso=#Form.paso#&cue=#Form.cue#&pkg=#Form.pkg#&logg=#Form.logg#">
<cfif isdefined("form.Cambiar")>
	<cftransaction>
		<cfquery datasource="#session.DSN#" name="rsLogin">
			select 	LGnumero,LGlogin,Contratoid,Snumero,LGrealName,LGmailQuota,
					LGroaming,LGprincipal,LGapertura,LGcese,LGserids,Habilitado,
					LGbloqueado,LGmostrarGuia,LGtelefono
			from 	ISBlogin 
			where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
					and Habilitado =1
		</cfquery>
		<!---Actualizacion del Login--->
		<cfinvoke component="saci.comp.ISBlogin"
			method="Cambio" >
			<cfinvokeargument name="LGnumero" value="#form.logg#">
			<cfinvokeargument name="Contratoid" value="#rsLogin.Contratoid#">
			<cfinvokeargument name="Snumero" value="#rsLogin.Snumero#">
			<cfinvokeargument name="LGlogin" value="#login2#">
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
			<cfinvokeargument name="LGtelefono" value="#rsLogin.LGtelefono#">
		</cfinvoke>
		<!---Insercion en la Cambio de logines--->
		<cfinvoke component="saci.comp.ISBcambioLogin"
			method="Alta"  >
			<cfinvokeargument name="LGnumero" value="#form.logg#">
			<cfinvokeargument name="LGloginAnterior" value="#rsLogin.LGlogin#">
			<cfinvokeargument name="LGfechaCambio" value="#now()#">
		</cfinvoke>
		
		<cfinclude template="gestion-redirect.cfm">
	</cftransaction>
</cfif>