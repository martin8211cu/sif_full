<cfparam name="modo" default="CAMBIO">
<cfparam name="action" default="CuentaPrincipal_tabs.cfm">
<!--- <cfdump var="#FORM#">
<cfabort> --->

<cfif ( isdefined("form.Alta") or isdefined("form.Cambio") ) >
	<cfset errorFoto = false >
	<cfif isdefined('form.Pfoto') and Len(Trim(form.Pfoto)) gt 0>
		<cftry>
			<!--- Copia la imagen a un folder del servidor --->
			<cffile action="Upload" fileField="form.Pfoto"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
			<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
			<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
			<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
			<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
			<!--- Formato para sybase --->
			<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
			<cfif not isArray(tmp)>
				<cfset ts = "">
			</cfif>
			<cfset miarreglo=ListtoArray(ArraytoList(tmp,","),",")>
			<cfset miarreglo2=ArrayNew(1)>
			<cfset temp=ArraySet(miarreglo2,1,8,"")>
		
			<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
				<cfif miarreglo[i] LT 0>
					<cfset miarreglo[i]=miarreglo[i]+256>
				</cfif>
			</cfloop>
		
			<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
				<cfif miarreglo[i] LT 10>
					<cfset miarreglo2[i] = "0" & toString(Hex[(miarreglo[i] MOD 16)+1])>
				<cfelse>
					<cfset miarreglo2[i] = trim(toString(Hex[(miarreglo[i] \ 16)+1])) & trim(toString(Hex[(miarreglo[i] MOD 16)+1]))>
				</cfif>
			</cfloop>
			<cfset temp = ArrayPrepend(miarreglo2,"0x")>
			<cfset ts = ArraytoList(miarreglo2,"")>
	
			<cfcatch type="any">
				<cfset errorFoto = true >
			</cfcatch> 
		</cftry>
	</cfif>	
</cfif>

<cftransaction>
<cftry>
	<cfif not isdefined("form.Nuevo") >
		<cfif isdefined("form.Cambio") >
			<cfquery name="update_usuario" datasource="#session.DSN#">
				set nocount on
				
				update Usuario
				set	  Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					  Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
					  Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
					  TIcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  Psexo			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  Pnacimiento	= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
				  	  Icodigo       = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
					  Ppais			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					  Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					  Pciudad		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pciudad#">,
					  PcodPostal	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PcodPostal#">,
					  Pprovincia	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pprovincia#">,					  
					  Poficina		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  Pcelular		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  Pfax			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					  Ppagertel		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,					  
					  Ppagernum		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,					  					  					  
					  Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					  Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					  Pweb			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pweb#">
					  <cfif errorFoto EQ false and isdefined("ts")>
						  ,Pfoto 	= #ts#
					  </cfif>					  
				where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
				  and Usutemporal = 1

				update UsuarioEmpresarial
				set	  Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					<cfif form.PPtipo EQ "A">
					  <cfparam name="form.admin" default="0">
					  admin = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.admin#">,
					</cfif>
					<cfif form.PPtipo EQ "C">
					  TFcodigo		= <cfif form.TFcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TFcodigo#">,<cfelse>null,</cfif>
					</cfif>
					  Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
					  Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
					  TIcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  Psexo			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  Pnacimiento	= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
				  	  Icodigo       = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
					  Ppais			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					  Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					  Pciudad		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pciudad#">,
					  PcodPostal	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PcodPostal#">,
					  Pprovincia	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pprovincia#">,					  
					  Poficina		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  Pcelular		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  Pfax			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					  Ppagertel		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,					  
					  Ppagernum			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,					  					  					  
					  Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					  Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					  Pweb			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pweb#">,					  					  
				  	  BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				      BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				      BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				      BMfechamod = getDate()
					  <cfif errorFoto EQ false and isdefined("ts")>
						  ,Pfoto 	= #ts#
					  </cfif>
				where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
				  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">

				set nocount off
				<cfif form.PPtipo EQ "A">
				  <cfif form.admin EQ "1">
				    if exists(select 1 from UsuarioPermiso
								where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
								  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
								  and rol = 'sys.adminCuenta')
						update UsuarioPermiso
						   set activo = 1
						 where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
						   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
						   and rol = 'sys.adminCuenta'
					else
						insert into UsuarioPermiso (Usucodigo, Ulocalizacion, rol, activo)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
								,<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
								,'sys.adminCuenta', 1)
				  <cfelse>
					update UsuarioPermiso
					   set activo = 0
					 where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
					   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
					   and rol = 'sys.adminCuenta'
				  </cfif>
				</cfif>
			</cfquery>
			
		<cfelseif isdefined("form.Alta")>

			<cfif form.PPtipo EQ "A">
			  <cfparam name="form.admin" default="1">
			<cfelse>
		      <cfparam name="form.admin" default="0">
			</cfif>
		    <cfparam name="form.TFcodigo" default="">
			<cfquery name="insert_usuario" datasource="#session.DSN#">
				set nocount on
				declare @newUsucodigo numeric
				declare @ambitoLogin char(1)
				select @ambitoLogin = ambitoLogin from CuentaClienteEmpresarial where cliente_empresarial = #form.cliente_empresarial#
			  	insert Usuario( Ulocalizacion, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, 
			  				  	Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Pfoto, Usutemporal, 
								Pciudad, PcodPostal, Pprovincia, Ppagertel, Pweb, Ppagernum, Usucliente_empresarial,
								BMUsucodigo, BMUlocalizacion, BMUsulogin)
					values ( <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
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
							 <cfif errorFoto EQ false and isdefined("ts")>#ts#,<cfelse>null,</cfif>
							 1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pciudad#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PcodPostal#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pprovincia#">,					  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,					  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pweb#">,					  					  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,					  
							case when @ambitoLogin = 'C' then #form.cliente_empresarial# else -1 end,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				  			<cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
				  			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )

				select @newUsucodigo = @@identity
				
				insert UsuarioEmpresarial( Usucodigo, Ulocalizacion, cliente_empresarial, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo,
											 Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, 
											 Pciudad, PcodPostal, Pprovincia, Ppagertel, Pweb, Ppagernum,
											 BMUsucodigo, BMUlocalizacion, BMUsulogin, 
											 admin, TFcodigo,
											 Pfoto)
				select Usucodigo, Ulocalizacion, #form.cliente_empresarial#, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, 
					   Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax,
					   Pciudad, PcodPostal, Pprovincia, Ppagertel, Pweb, Ppagernum,
					   BMUsucodigo, BMUlocalizacion, BMUsulogin, 
						<cfqueryparam cfsqltype="cf_sql_bit" value="#form.admin#">,
						<cfif form.TFcodigo NEQ ""><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TFcodigo#">,<cfelse>null,</cfif>
					   Pfoto
				from Usuario 
				where Usucodigo = @newUsucodigo 
					and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">

				set nocount off

				<cfif form.PPtipo EQ "A" AND form.admin EQ "1">
					insert into UsuarioPermiso (Usucodigo, Ulocalizacion, rol, activo)
					values (@newUsucodigo
							,<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
							,'sys.adminCuenta', 1)
				<cfelse>
					insert into UsuarioPermiso (Usucodigo, Ulocalizacion, rol, activo)
					values (@newUsucodigo
							,<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
							,'sys.public', 1)
				</cfif>
			</cfquery>

		<cfelseif isdefined("form.chk") and isdefined("form.btnDesactivar")>
			<cfquery name="inativo_usuario" datasource="#session.DSN#">
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
			<cfquery name="inactivo_usuario" datasource="#session.DSN#">
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
			<cfquery name="inativo_usuario" datasource="#session.DSN#">
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

		<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
			<cfquery name="inativo_usuario" datasource="#session.DSN#">
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
		<cfelseif isdefined("form.chk") and isdefined("btnReafiliar")>
			<!--- EJB --->
			<cfset EjbUser = 'guest'>
			<cfset EjbPass = 'guest'>
			<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>
			<cfscript>
				function getAfiliacionEJB ( )
				{
					var home = 0;
					var prop = 0;
			
					if (IsDefined ("__AfiliacionStub")) {
						return __AfiliacionStub;
					}
			
					// initial context
					prop = CreateObject("java", "java.util.Properties" );
					initContext = CreateObject("java", "javax.naming.InitialContext" );
					// especificar propiedades, esto se requiere para objetos remotos
					prop.init();
					prop.put(initContext.SECURITY_PRINCIPAL, EjbUser);
					prop.put(initContext.SECURITY_CREDENTIALS, EjbPass);
					initContext.init(prop);
					
					// ejb lookup
					home = initContext.lookup(EjbJndi);
					
					// global var, reuse
					__AfiliacionStub = home.create();
					return __AfiliacionStub;
				}
			</cfscript>
			<cfquery name="rsUsuario" datasource="#session.DSN#">
				<cfloop index="dato" list="#form.chk#">
					<cfset datos = ListToArray(dato,'|')>
						set nocount on
						select u.Usucodigo, u.Ulocalizacion
							from Usuario u
							where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
							  and u.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
							  and u.activo = 1
							  and u.Usutemporal = 1
						set nocount off
				</cfloop>
			</cfquery>
			<cfif rsUsuario.recordCount GT 0>
			  <cfset getAfiliacionEJB().prepararUsuarioTemporal(rsUsuario.Usucodigo,rsUsuario.Ulocalizacion,true)>
			</cfif>
		</cfif>
	</cfif>

<cfcatch type="any">
	<cfinclude template="../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfoutput>
<form action="#action#" method="post">
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<input type="hidden" name="ppTipo"     value="<cfif isdefined('form.ppTipo')>#form.ppTipo#</cfif>">
	<input type="hidden" name="ppInactivo" value="<cfif isdefined('form.ppInactivo')>#form.ppInactivo#</cfif>">	
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