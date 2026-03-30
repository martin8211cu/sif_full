<cfparam name="modo"  default="ALTA">
<cfparam name="action"  default="CuentaPrincipal_tabs.cfm">

<cfif ( isdefined("form.AltaE") or isdefined("form.CambioE") ) >
	<cfif Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../utiles/imagen.cfm">
	</cfif>	
</cfif>

<cftransaction>
<cftry>
	<cfif isdefined("form.AltaE")>
		<cfquery name="cuenta_insert"  datasource="#session.DSN#">
			set nocount on
				<!--- Insercion de la Cuenta Empresarial --->
				insert Usuario 
					(Ulocalizacion, Pnombre
					, Ppais, Icodigo
					, TIcodigo, Pid
					, Pemail1,  Pweb, Pdireccion
					, Pciudad, Pprovincia, PcodPostal
					, Poficina, Pfax
					, Pfoto, Usutemporal, Usucliente_empresarial
					, agente, agente_loc
					, BMUsucodigo, BMUlocalizacion, BMUsulogin)
					values (
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">
					, <cfif isdefined("ts")>#ts#<cfelse>null</cfif>, 1, -1
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)

				declare @newUsuario numeric
				select @newUsuario = @@identity
				
				insert CuentaClienteEmpresarial (cuenta_maestra, TIcodigo, identificacion, nombre
							, razon_social, Icodigo,direccion, ciudad
							, provincia, codPostal, Ppais, telefono
							, fax, email, web, logo
							, alias_login
							, fecha, cache_empresarial
							, ambitoLogin, Usucodigo
							, Ulocalizacion, activo
							, agente, agente_loc
							, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
				select 	Usucuenta, TIcodigo, Pid, Pnombre
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.razon_social#">, Icodigo, Pdireccion, Pciudad
						,Pprovincia, PcodPostal, Ppais, Poficina
						,Pfax, Pemail1, Pweb, Pfoto
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.alias_login#">
						,getDate(), <cfif isdefined("form.cache_empresarial")>1<cfelse>0</cfif>
						,<cfqueryparam cfsqltype="cf_sql_char" value="#form.ambitoLogin#">,Usucodigo
						, Ulocalizacion, activo
						, agente, agente_loc
						, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
				from Usuario
				where Usucodigo = @newUsuario
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				  
				declare @newCliente numeric
				select @newCliente = @@identity
				
				<!--- Insercion de la Empresa default --->
				insert Usuario 
					(Ulocalizacion, Pnombre
					, Ppais, Icodigo
					, TIcodigo, Pid
					, Pemail1,  Pweb, Pdireccion
					, Pciudad, Pprovincia, PcodPostal
					, Poficina, Pfax
					, Pfoto
					, Usutemporal
					, agente, agente_loc
					, BMUsucodigo, BMUlocalizacion, BMUsulogin)
					values (
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">
					, <cfif isdefined("ts")>#ts#<cfelse>null</cfif>
					, 1
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)

				declare @newUsuarioEmp numeric
				select @newUsuarioEmp = @@identity				
				
				insert Empresa 
					(cliente_empresarial, cuenta_maestra, TIcodigo
					, identificacion, nombre_comercial, razon_social, Icodigo
					, direccion, ciudad, provincia, codPostal
					, Ppais, telefono, fax, email
					, web, logo, Usucodigo
					, Ulocalizacion, activo, BMUsucodigo, BMUlocalizacion
					, BMUsulogin, BMfechamod)
					
					Select 
						@newCliente, Usucuenta, TIcodigo
						, Pid, Pnombre, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.razon_social#">, Icodigo
						, Pdireccion,Pciudad,Pprovincia,PcodPostal
						, Ppais, Poficina, Pfax, Pemail1
						, Pweb, Pfoto, Usucodigo
						, Ulocalizacion, activo,  BMUsucodigo, BMUlocalizacion
						, BMUsulogin, BMfechamod
					from Usuario
					where Usucodigo = @newUsuarioEmp
					  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">

				<!--- Insercion del Usuario Administrador default --->
				insert Usuario 
					(Ulocalizacion
					, Pnombre, Papellido1
					, Ppais, Icodigo
					, TIcodigo, Pid
					, Pemail1,  Pweb, Pdireccion
					, Pciudad, Pprovincia, PcodPostal
					, Poficina, Pfax
					, Pfoto, Usutemporal
					, Usucliente_empresarial
					, agente, agente_loc
					, BMUsucodigo, BMUlocalizacion, BMUsulogin)
					values (
					 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">
					, '*ADMINISTRADOR*'
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EmailAdmin#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">
					, <cfif isdefined("ts")>#ts#<cfelse>null</cfif>
					, 1 
					, <cfif form.ambitoLogin EQ 'C'>@newCliente<cfelse>-1</cfif>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)

				declare @newUsuarioUEmp numeric
				select @newUsuarioUEmp = @@identity

		<!--- Insercion del Usuario Empresarial --->
					insert UsuarioEmpresarial 
					(Usucodigo, Ulocalizacion, cliente_empresarial
					, admin, TIcodigo, Pid
					, Pnombre, Papellido1
					, Icodigo, Pdireccion, Pciudad, Pprovincia, PcodPostal
					, Ppais, Poficina
					, Pfax, Pemail1,Pemail2, Pweb, Pfoto
					, activo, BMUsucodigo, BMUlocalizacion
					, BMUsulogin, BMfechamod)
					
					Select 
						 Usucodigo, Ulocalizacion, @newCliente
						, 1, TIcodigo, Pid
						, Pnombre , Papellido1
						, Icodigo, Pdireccion,Pciudad,Pprovincia,PcodPostal
						, Ppais, Poficina
						, Pfax, Pemail1, null, Pweb, Pfoto
						, activo, BMUsucodigo, BMUlocalizacion
						, BMUsulogin, BMfechamod
					from Usuario
					where Usucodigo = @newUsuarioUEmp
					  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">

					insert into UsuarioPermiso (Usucodigo, Ulocalizacion, rol, activo)
					values (@newUsuarioUEmp
							,<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
							,'sys.adminCuenta', 1)

				select convert(varchar,@newCliente) as cliente					
			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >		
	<cfelseif isdefined("form.CambioE")>
		<cfquery name="cuenta_update" datasource="#session.DSN#">
			set nocount on
			update Usuario
			set u.Pnombre         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
				u.Pemail1		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
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
			set 
				TIcodigo       	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">,
				identificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">,
				nombre         	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
				razon_social   	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.razon_social#">,
				Icodigo    		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
				direccion      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">,
				ciudad      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">,				
				provincia      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">,
				codPostal      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">,								
				Ppais      		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,												
				telefono      	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">,
				fax      		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
				email      		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
				web      		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">,																
				alias_login		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.alias_login#">,
				<cfif isdefined("ts")>logo = #ts#,</cfif>
				fecha 			= getDate(),		
				cache_empresarial = <cfif isdefined("form.cache_empresarial")>1<cfelse>0</cfif>,
				ambitoLogin     = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ambitoLogin#">,												
				BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				BMfechamod = getDate()
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >		
	<cfelseif isdefined("form.BajaE")>
		<cfquery name="cuenta_des" datasource="#session.DSN#">
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
		<cfset action = "CuentaPrincipal_tabs.cfm" >
		
	<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
		<cfquery name="inativo_usuario" datasource="#session.DSN#">
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
		<cfquery name="inativo_usuario" datasource="#session.DSN#">
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
	<cfinclude template="../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfif isdefined("cuenta_insert")>
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