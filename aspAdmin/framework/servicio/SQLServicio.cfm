<cfparam name="modo" default="ALTA">

<cfset servicio = "-1">
<cfif isdefined("form.servicio")>
	<cfif form.editar neq 'ALTA'>
		<cfset servicio = form.servicio >
	<cfelse>
		<cfset servicio = form.modulo & "." & form.servicio>
	</cfif>
</cfif>

<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("form.btnBorrar")>
			<cfquery name="delete_servicio" datasource="sdc">
				set nocount on
				update Servicios
				set activo = 0
				  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
				  , BMfechamod = getDate()
				where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">
				set nocount off
			</cfquery>
	
		<cfelseif isdefined("form.btnGuardar")>
			<cfquery name="guardar_servicio" datasource="sdc">
				set nocount on
				update Servicios
				set nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
					menu = <cfif isdefined("menu")>1<cfelse>0</cfif>,
					home = <cfif isdefined("home")>1<cfelse>0</cfif>,
					agregacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.agregacion#">,
					activo = 1,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod = getDate()
				where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">
	
				if @@rowcount = 0 begin
					insert Servicios (servicio, modulo, nombre, menu, home, agregacion, BMUsucodigo, BMUlocalizacion, BMUsulogin )
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.modulo#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
							 <cfif isdefined("menu")>1<cfelse>0</cfif>,
							 <cfif isdefined("home")>1<cfelse>0</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.agregacion#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )
				end
				else begin
					update ServiciosRol
					set activo = 0,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						BMfechamod = getDate()
					where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">
	
					delete ServiciosRol
					where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">
				end
				set nocount off
			</cfquery>
			
			<cfquery name="orden_servicio" datasource="sdc">
				exec sp_OrdenServicio
					@modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.modulo#">,
					@servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">,
					@orden = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">
			</cfquery>		
	
			<cfif isdefined("form.rol")>
				<cfquery name="guardar_ServiciosRol" datasource="sdc">
					set nocount on
					<cfloop index="dato" list="#form.rol#">
							insert into ServiciosRol (servicio, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin)
							values ( <cfqueryparam cfsqltype="cf_sql_char" value="#servicio#">,
									 <cfqueryparam cfsqltype="cf_sql_char" value="#dato#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )
					</cfloop>
					set nocount off
				</cfquery>
			</cfif>
	</cfif>
</cfif>

<cfoutput>
<form action="Servicio.cfm" method="post" name="sql">
	<input name="sistema" type="hidden" value="#form.sistema#">
	<input name="modulo" type="hidden" value="#form.modulo#">
	<cfif form.editar neq 'ALTA' and not isdefined("form.btnNuevo") and not isdefined("form.btnBorrar")>
		<input name="servicio" type="hidden" value="#form.servicio#">
	</cfif>
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
