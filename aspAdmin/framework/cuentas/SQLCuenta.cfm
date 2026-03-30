<cfparam name="modo"  default="ALTA">
<cfparam name="action"  default="Cuenta.cfm">

<cfif ( isdefined("form.AltaE") or isdefined("form.CambioE") ) >
	<cfif Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../utiles/imagen.cfm">
	</cfif>	
</cfif>

<cftransaction>
<cftry>

	<cfif isdefined("form.AltaE")>
		<cfquery name="cuenta_insert"  datasource="sdc">
			set nocount on
			insert Usuario (Ulocalizacion, Pnombre, Ppais, TIcodigo, Pid, Usutemporal, BMUsucodigo, BMUlocalizacion, BMUsulogin)
			values ( '00',
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
					 'CR',
					 'CED', 
					 '*', 
					 1,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
				   )
			
			insert CuentaClienteEmpresarial (Usucodigo, Ulocalizacion, nombre, descripcion,cache_empresarial, cuenta_maestra, fecha, BMUsucodigo, BMUlocalizacion, BMUsulogin, logo)
			select 	Usucodigo, 
					Ulocalizacion, 
					Pnombre,
					'#form.descripcion#',
					<cfif isdefined("form.cache_empresarial")>1<cfelse>0</cfif>,
					Usucuenta,
					getDate(),
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					 <cfif isdefined("ts")>#ts#<cfelse>null</cfif>
			from Usuario
			where Usucodigo = @@identity
			  and Ulocalizacion = '00'
			select convert(varchar, @@identity) as cliente
			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >
		
	<cfelseif isdefined("form.CambioE")>
		<cfquery name="cuenta_update" datasource="sdc">
			set nocount on
			update Usuario
			set u.Pnombre         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
				u.BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				u.BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				u.BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				u.BMfechamod      = getDate()
			from Usuario u, CuentaClienteEmpresarial cce
			where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			  and cce.Usucodigo = u.Usucodigo
			  and cce.Ulocalizacion = u.Ulocalizacion
			  and u.Usutemporal = 1
			  
			update CuentaClienteEmpresarial
			set nombre            = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
				descripcion       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">,
				cache_empresarial = <cfif isdefined("form.cache_empresarial")>1<cfelse>0</cfif>,
				BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				BMfechamod = getDate()
				<cfif isdefined("ts")>,logo = #ts#</cfif>
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >
		
	<cfelseif isdefined("form.BajaE")>
		<cfquery name="cuenta_des" datasource="sdc">
			set nocount on
			update CuentaClienteEmpresarial
			set activo = 0,
				BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				BMfechamod = getDate()
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			set nocount off
		</cfquery>
		
	<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
		<cfquery name="inativo_usuario" datasource="sdc">
			<cfloop index="dato" list="#form.chk#">
				set nocount on
				update CuentaClienteEmpresarial
				set activo = 1,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
					BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod = getDate()
				where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
				set nocount off
			</cfloop>
		</cfquery>
		<cfset action = "listaCuentasRecycle.cfm" >
	
	<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
		<cfquery name="inativo_usuario" datasource="sdc">
			<cfloop index="dato" list="#form.chk#">
					set nocount on
	
					declare @Usucodigo numeric
					declare @Ulocalizacion char(2)
					select @Usucodigo=Usucodigo, @Ulocalizacion=Ulocalizacion
					from CuentaClienteEmpresarial
					where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
					
					update CuentaClienteEmpresarial
					set cce.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						cce.BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
						cce.BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						cce.BMfechamod = getDate()				  
					from CuentaClienteEmpresarial cce, Usuario u
					where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
					  and cce.Usucodigo = u.Usucodigo
					  and cce.Ulocalizacion = u.Ulocalizacion
					  and u.Usutemporal = 1
					delete CuentaClienteEmpresarial
					from CuentaClienteEmpresarial cce, Usuario u
					where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
					  and cce.Usucodigo = u.Usucodigo
					  and cce.Ulocalizacion = u.Ulocalizacion
					  and u.Usutemporal = 1
					
					update Usuario
					set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
						BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						BMfechamod = getDate()				  
					where Usucodigo = @Usucodigo
					  and Ulocalizacion = @Ulocalizacion
					  and Usutemporal = 1
					delete Usuario
					where Usucodigo = @Usucodigo
					  and Ulocalizacion = @Ulocalizacion
					  and Usutemporal = 1				  
	
					set nocount off
			</cfloop>
		</cfquery>
		<cfset action = "listaCuentasRecycle.cfm" >
	</cfif>
<cfcatch type="database">
	<cfinclude template="../error/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfif not isdefined("form.cliente_empresarial") and isdefined("cuenta_insert")>
	<cfset form.cliente_empresarial = cuenta_insert.cliente >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">

	<cfif modo neq 'ALTA'>
		<input name="cliente_empresarial" type="hidden" value="#form.cliente_empresarial#">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif modo neq 'ALTA' and isdefined("pagina")>#pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>