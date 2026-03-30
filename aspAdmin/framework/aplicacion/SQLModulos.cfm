<cfparam name="m_modo" default="ALTA">
<cfparam name="action" default="SistemasPrincipal.cfm">

<cfif not isDefined("Form.mNuevo") >
	<cftry>
		<cfquery name="Acciones" datasource="#Session.DSN#">
			set nocount on
			
			<!--- Agregar Modulo --->
			<cfif isDefined("Form.mAlta") or isdefined("Form.mCambio")>
				<cfif isDefined("Form.mAlta")>
					<cfset modulo = trim(form.sistema) & "." & trim(form.modulo)>
				<cfelse>
					<cfset modulo = trim(form.modulo)>
				</cfif>
			
				update Modulo
				set nombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">
				  , facturacion 	= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.facturacion)#">
				  , tarifa 			= <cfif form.facturacion eq 0><cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.tarifa)#"><cfelse>0.00</cfif>
				  , componente 		= <cfif form.facturacion eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.componente)#"><cfelse>null</cfif>
				  , metodo 			= <cfif form.facturacion eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.metodo)#"><cfelse>null</cfif>
				  , BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				  , BMUsulogin 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#sessiOn.usuario#">
				  , BMfechamod 		= getdate()
				where upper(modulo) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(modulo))#">

				if @@rowcount = 0 begin
					insert Modulo (modulo, sistema, nombre, facturacion, tarifa, componente, metodo, descripcion, activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
					values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.sistema)#.#trim(form.modulo)#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.sistema)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.facturacion)#">,
							 <cfif form.facturacion eq 0><cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.tarifa)#"><cfelse>0.00</cfif>,
							 <cfif form.facturacion eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.componente)#"><cfelse>null</cfif>,
							 <cfif form.facturacion eq 2><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.metodo)#"><cfelse>null</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre)#">,
							 1,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#sessiOn.usuario#">,
							 getdate()
					)
				end
			
				exec sp_OrdenModulo
					@sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.sistema)#">,
					@modulo  = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(modulo)#">,
					@orden   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">

			<!--- Borrar Modulo --->
			<cfelseif isDefined("Form.mBaja")>
				update Modulo
				set activo = 0
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.modulo)#">

			<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
				<cfloop index="dato" list="#form.chk#">
					set nocount on
					update Modulo
					set activo = 1
					where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
					set nocount off
				</cfloop>
				<cfset action = "ModulosRecycle.cfm">
				<cfset upd    = true >
				
			<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
				<cfloop index="dato" list="#form.chk#">
					update Modulo
					set BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMUlocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						BMUsulogin 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						BMfechamod		 = getDate()
					where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
	
					delete Modulo
					where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(dato)#">
					  and activo = 0
				</cfloop>
				<cfset action = "ModulosRecycle.cfm">
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
	<input name="s_modo" type="hidden" value="CAMBIO">
	<input name="m_modo" type="hidden" value="<cfif isdefined("m_modo")>#m_modo#</cfif>">
	<input name="sistema" type="hidden" value="#form.sistema#">
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