<cfset action = "/cfmx/sif/framework/catalogos/UsuariosEmpresariales.cfm">
<cfset modo="ALTA">
<cfset DSN = 'sdc'>

	<cfif not isdefined("Form.Nuevo")>
		<cftransaction>
			<cftry>
				<cfquery name="ABC_datosUsuario" datasource="#DSN#">
					set nocount on
						<cfif isdefined("Form.Alta")>
							  insert Usuario (Ulocalizacion, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo,
								Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular,
								Pfax, Usutemporal, BMUsucodigo, BMUlocalizacion, BMUsulogin)
							  values ('00',
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
								convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">, 103 ),
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
								1,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)
								
							  insert UsuarioEmpresarial (Usucodigo, Ulocalizacion, cliente_empresarial,
								Pnombre, Papellido1, Papellido2, Ppais, TIcodigo,
								Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular,
								Pfax, BMUsucodigo, BMUlocalizacion, BMUsulogin)							
							  select Usucodigo, Ulocalizacion, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
								Pnombre, Papellido1, Papellido2, Ppais, TIcodigo,
								Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular,
								Pfax, BMUsucodigo, BMUlocalizacion, BMUsulogin
							  from Usuario where Usucodigo = @@identity and Ulocalizacion = '00'								
								
							<cfset modo="CAMBIO">
						<cfelseif isdefined("Form.Desactivar")>
							update UsuarioEmpresarial
							set activo = 0
							  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
							  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
							  , BMfechamod = getDate()
							where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
							  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
							  
							<cfset modo="ALTA">
						<cfelseif isdefined("Form.Cambio")>																		
							update Usuario set
							 	Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">
							  , Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">
							  , Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">
							  , Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
							  , TIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">
							  , Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">
							  , Pnacimiento = convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">, 103 )
							  , Psexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">
							  , Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">
							  , Pemail2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">
							  , Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">
							  , Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">
							  , Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">
							  , Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">
							  , Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">
							  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
							  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
							  , BMfechamod = getDate()
							where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
							  and Usutemporal = 1
				
							update UsuarioEmpresarial
							set Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">
							  , Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">
							  , Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">
							  , Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
							  , TIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">
							  , Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">
							  , Pnacimiento = convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">, 103 )
							  , Psexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">
							  , Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">
							  , Pemail2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">
							  , Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">
							  , Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">
							  , Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">
							  , Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">
							  , Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">
							  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							  , BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
							  , BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
							  , BMfechamod = getDate()
							where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
							  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
							  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">						
							  
							<cfset modo="CAMBIO">
						</cfif>
					set nocount off
				</cfquery>
			<cfcatch type="any">
				<cfinclude template="/aspAdmin/errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>
		</cftransaction>	
	</cfif>

	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="Usucodigo" type="hidden" value="<cfif not isdefined('form.Nuevo') and isdefined("form.Usucodigo")><cfoutput>#form.Usucodigo#</cfoutput></cfif>">			
		<input name="Ulocalizacion" type="hidden" value="<cfif not isdefined('form.Nuevo') and isdefined("form.Ulocalizacion")><cfoutput>#form.Ulocalizacion#</cfoutput></cfif>">					
		<input name="cliente_empresarial" type="hidden" value="<cfif not isdefined('form.Nuevo') and isdefined("form.cliente_empresarial")><cfoutput>#form.cliente_empresarial#</cfoutput></cfif>">							
		<input name="o" type="hidden" value="1">		
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
