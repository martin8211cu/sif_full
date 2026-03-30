<cfset Request.Error.Url = "gestion.cfm?cli=#form.cli#&ppaso=#Form.ppaso#&lpaso=#Form.lpaso#&cpaso=#Form.cpaso#&cue=#Form.cue#&pkg=#Form.pkg#&logg=#Form.logg#">
<cfif isdefined("form.Cambiar")>
	<cftransaction>
		<cfquery name="rsLoginRepetido" datasource="#session.DSN#">
			select count(1) as existe
			from  ISBcambioLogin 
			where LGnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
			and LGloginAnterior=<cfqueryparam cfsqltype="cf_sql_varchar" value="#login2#">
		</cfquery>
		
		<cfif rsLoginRepetido.existe EQ 0>	
			<!---Actualizacion del Login--->
			<cfinvoke component="saci.comp.ISBlogin"method="CambioLogin" >
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="LGlogin" value="#form.login2#">
			</cfinvoke>
		<cfelse>
			<cfthrow message="Error: debe digitar un login diferente a los que ha tenido.">
		</cfif>
	</cftransaction>
</cfif>