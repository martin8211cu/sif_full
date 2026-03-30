<cfparam name="s_modo"  default="ALTA">
<cfparam name="action"  default="SistemasPrincipal.cfm">

<cfif isdefined("sistema") and len(trim(sistema)) gt 0 and not isdefined("form.sBaja") and not isdefined("form.sNuevo")>
	<cfset s_modo = "CAMBIO">
</cfif>

<cftransaction>
<cftry>
	<cfif isdefined("form.sAlta") or isDefined("form.sCambio")>
		<cfquery name="sistema_insert"  datasource="sdc">
			set nocount on

			update Sistema
			set nombre 		 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
				nombre_cache 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre_cache)#">,
 				orden        	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">,
				BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMUlocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				BMUsulogin 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				BMfechamod		 = getDate()
			where upper(sistema) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(ucase(form.sistema))#">

			if @@rowcount = 0 begin
				insert Sistema ( sistema, nombre, nombre_cache, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod )
				values ( <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(form.sistema)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre_cache)#">,
						 1,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						 getDate()
					   )
			 end  
				   
			exec sp_OrdenSistema
				@sistema = <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(form.sistema)#">,
				@orden   = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.orden)#">
				   
			set nocount off
		</cfquery>
		<cfset s_modo = "CAMBIO" >
		
	<cfelseif isdefined("form.sBaja")>
		<cfquery name="cuenta_des" datasource="sdc">
			set nocount on
			update Sistema
			set activo = 0
			where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.sistema)#">
			set nocount off
		</cfquery>

	<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
		<cfquery name="cuenta_act" datasource="sdc">
			<cfloop index="dato" list="#form.chk#">
				set nocount on
				update Sistema
				set activo = 1
				where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
				set nocount off
			</cfloop>
		</cfquery>
		<cfset action = "SistemasRecycle.cfm">
		<cfset upd = true >
		
	<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
		<cfquery name="cuenta_del" datasource="sdc">
			<cfloop index="dato" list="#form.chk#">
				update Sistema
				set BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					BMUsulogin 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod		 = getDate()
				where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">

				delete Sistema
				where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
				  and activo = 0
			</cfloop>
		</cfquery>
		<cfset action = "SistemasRecycle.cfm">
	</cfif>
<cfcatch type="database">
	<cfinclude template="../error/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="s_modo" type="hidden" value="<cfoutput>#s_modo#</cfoutput>">

	<cfif s_modo neq 'ALTA'>
		<input name="sistema" type="hidden" value="#form.sistema#">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif s_modo neq 'ALTA' and isdefined("pagina")>#pagina#</cfif>">
	<cfif isdefined("upd")>
		<input type="hidden" name="update" value="true">
	</cfif>

</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>