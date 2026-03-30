<cfparam name="action" default="Roles.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isDefined("Form.rNuevo") >
	<cftry>
		<cfquery name="Acciones" datasource="#Session.DSN#">
			set nocount on
			
			<!--- Agregar Rol --->
			<cfif isDefined("Form.rAlta") or isdefined("form.rCambio") >
				<cfif isDefined("form.rAlta")>
					<cfset rol = trim(form.sistema) & "." & trim(form.rol)>
				<cfelse>
					<cfset rol = trim(form.rol)>
				</cfif>

				update Rol
				set nombre      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
					descripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
					Rolinfo     	= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.rolinfo#">,
					empresarial 	= <cfif isdefined("form.empresarial")>1<cfelse>0</cfif>,
					interno     	= <cfif isdefined("form.interno")>1<cfelse>0</cfif>,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="00">,
					BMUsulogin		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod		= getdate()
				where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
				  and upper(rol)     = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(rol))#">

				if @@rowcount = 0 begin
					insert Rol (rol, Rolcod, sistema, nombre, descripcion, Rolinfo, empresarial, interno, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod )
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rol)#">,
							 0,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.sistema)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
							 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.rolinfo#">,
							 <cfif isdefined("form.empresarial")>1<cfelse>0</cfif>,
							 <cfif isdefined("form.interno")>1<cfelse>0</cfif>,
							 1,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="00">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
							 getdate()
					)
				end

			<!--- Borrar Rol --->
			<cfelseif isDefined("Form.rBaja")>
				update Rol
				set activo          = 0,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="00">,
					BMUsulogin		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod		= getdate()
				where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
				  and rol     = <cfqueryparam cfsqltype="cf_sql_char" value="#form.rol#">

			<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
				<cfloop index="dato" list="#form.chk#">
					set nocount on
					update Rol
					set activo = 1
					where rol = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
					set nocount off
				</cfloop>
				<cfset action = "RolesRecycle.cfm">
				<cfset upd    = true >
				
			<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
				<cfloop index="dato" list="#form.chk#">
					update Rol
					set BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMUlocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						BMUsulogin 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						BMfechamod		 = getDate()
					where rol = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
	
					delete Rol
					where rol = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
					  and activo = 0
				</cfloop>
				<cfset action = "RolesRecycle.cfm">
			</cfif>			
			set nocount off
		</cfquery>

	<cfcatch>
		<cfinclude template="/aspAdmin/errorPages/BDerror.cfm">
		<cfabort>	
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="#modo#">
	<input name="sistema" type="hidden" value="#Form.sistema#">
	<cfif isdefined("form.modulo")><input name="modulo" type="hidden" value="#Form.modulo#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<cfif isdefined("upd")>
		<input type="hidden" name="update" value="true">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>