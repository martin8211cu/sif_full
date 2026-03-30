<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnDNuevo")>
	<cfif isdefined("form.btnDBorrar")>
		<cfquery name="delete_proceso" datasource="sdc">
			set nocount on
			update Procesos
			set activo = 0,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				BMfechamod = getDate()
			where uri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uri#">
			  and tipo_uri = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_uri#">
			  and servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">
			set nocount off
		</cfquery>
	
	<cfelseif isdefined("form.btnDGuardar") or isdefined("form.btnHome") >
		<cfquery name="guardar_proceso" datasource="sdc">
			set nocount on
				update Procesos
				set titulo          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo#">,
					tipo_obj        = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_obj#">,
					activo          = 1,
					BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod      = getDate()
				where uri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uri#">
				  and tipo_uri = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_uri#">
				  and servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">

				if @@rowcount = 0 begin
					insert Procesos ( servicio, uri, tipo_uri, titulo, tipo_obj, descripcion, BMUsucodigo, BMUlocalizacion, BMUsulogin )
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uri#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_uri#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_obj#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )
				end
			set nocount off
		</cfquery>

		<cfif isdefined("form.btnHome")>
			<cfquery name="rsHome" datasource="sdc">
				set nocount on
				update Servicios
				set home_uri  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uri#">,
					home_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_uri#">
				where servicio = <cfqueryparam cfsqltype="cf_sql_char" value="#form.servicio#">
				set nocount off
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<form action="Servicio.cfm" method="post" name="sql">
	<input name="sistema"  type="hidden" value="#form.sistema#">
	<input name="modulo"   type="hidden" value="#form.modulo#">
	<input name="servicio" type="hidden" value="#form.servicio#">
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
