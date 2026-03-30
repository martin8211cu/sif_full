<cfparam name="modo" default="CAMBIO">
<cfparam name="action" default="listaAdmin.cfm">

<cftransaction>
<cftry>
	<cfif not isdefined("form.Nuevo") >
		<cfif isdefined("form.Cambio") >
			<cfquery name="update_usuario" datasource="sdc">
				set nocount on

				update Usuario
				set	  Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					  Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
					  Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
					  TIcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  Psexo			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  Pnacimiento	= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
					  Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					  Ppais			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					  Poficina		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  Pcelular		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  Pfax			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					  Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					  Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">
				where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
				  and Usutemporal = 1

				update UsuarioEmpresarial
				set	  Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					  Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
					  Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
					  TIcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  Pnacimiento	= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
					  Psexo			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					  Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					  Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					  Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  Poficina		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  Pcelular		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  Pfax			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
				  	  BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				      BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				      BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				      BMfechamod = getDate()
				where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">

				set nocount off
			</cfquery>
			
			<cfset action = "formUsuario.cfm" >
			
		<cfelseif isdefined("form.Alta")>

			<cfquery name="insert_usuario" datasource="sdc">
				set nocount on
			  	insert Usuario( Ulocalizacion, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, 
			  				  	Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Usutemporal, BMUsucodigo, BMUlocalizacion, BMUsulogin)
					values ( '00',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
							 <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					  		 <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  		 convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
					  		 <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					  		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
							 1,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				  			 <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
				  			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )

				insert UsuarioEmpresarial( Usucodigo, Ulocalizacion, cliente_empresarial, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo,
											 Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, BMUsucodigo, 
											 BMUlocalizacion, BMUsulogin, admin)
				select Usucodigo, Ulocalizacion, #form.cliente_empresarial#, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, 
					   Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, BMUsucodigo, BMUlocalizacion, BMUsulogin, 1
				from Usuario 
				where Usucodigo = @@identity and Ulocalizacion = '00'

				set nocount off
			</cfquery>

		<cfelseif isdefined("form.chk") and isdefined("form.btnDesactivar")>
			<cfquery name="inativo_usuario" datasource="sdc">
				<cfloop index="dato" list="#form.chk#">
					<cfset datos = ListToArray(dato,'|')>
						update UsuarioEmpresarial
						set activo = 0,
						    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						    BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
						    BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						    BMfechamod = getDate()
						where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
						  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
						  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
				</cfloop>
			</cfquery>

			<cfelseif isdefined("form.Baja")>
				<cfquery name="inactivo_usuario" datasource="sdc">
					update UsuarioEmpresarial
					set activo = 0,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
						BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						BMfechamod = getDate()
					where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
					  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
				</cfquery>

				<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
					<cfquery name="inativo_usuario" datasource="sdc">
						<cfloop index="dato" list="#form.chk#">
							<cfset datos = ListToArray(dato,'|')>
								update UsuarioEmpresarial
								set activo = 1,
									BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
									BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
									BMfechamod = getDate()
								where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
								  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
								  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
						</cfloop>
					</cfquery>
				<cfset action = "listaAdminRecycle.cfm" >

				<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
					<cfquery name="inativo_usuario" datasource="sdc">
						<cfloop index="dato" list="#form.chk#">
							<cfset datos = ListToArray(dato,'|')>
								set nocount on
								update UsuarioEmpresarial
								set ue.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
								  , ue.BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
								  , ue.BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
								  , ue.BMfechamod = getDate()
								from Usuario u, UsuarioEmpresarial ue
								where ue.Usucodigo = u.Usucodigo
								  and ue.Ulocalizacion = u.Ulocalizacion
								  and ue.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
								  and ue.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
								  and ue.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
								  and u.Usutemporal = 1
	
								delete UsuarioEmpresarial
								from Usuario u, UsuarioEmpresarial ue
								where ue.Usucodigo = u.Usucodigo
								  and ue.Ulocalizacion = u.Ulocalizacion
								  and ue.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
								  and ue.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
								  and ue.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
								  and u.Usutemporal = 1

								if not exists (select Usucodigo from UsuarioEmpresarial
								where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
								  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">)
								begin
									update Usuario
									set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
									  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
									  , BMfechamod = getDate()
									where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
									  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
									  and Usutemporal = 1
									  
									delete Usuario
									where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
									  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
									  and Usutemporal = 1
								end
								set nocount off
						</cfloop>
					</cfquery>
				<cfset action = "listaAdminRecycle.cfm" >
		</cfif>
	<cfelse>
		<cfset action = "formUsuario.cfm" >
	</cfif>

<cfcatch type="database">
	<cfinclude template="../error/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfoutput>
<form action="#action#" method="post">
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<cfif isdefined("form.Cambio") >
		<input type="hidden" name="Usucodigo"     value="#form.Usucodigo#">
		<input type="hidden" name="Ulocalizacion" value="#form.Ulocalizacion#">
		<input type="hidden" name="MODO" value="Cambio">
	<cfelseif isdefined("form.Nuevo")>
		<input type="hidden" name="MODO" value="Alta">
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