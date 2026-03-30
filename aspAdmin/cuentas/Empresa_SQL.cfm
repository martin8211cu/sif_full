<cfparam name="modo"  default="ALTA">
<cfparam name="action"  default="CuentaPrincipal_tabs.cfm">

<cfif ( isdefined("form.AltaE") or isdefined("form.CambioE") ) >
	<cfif Len(Trim(form.logo)) gt 0 >
		<cfinclude template="../Utiles/imagen.cfm">
	</cfif>	
</cfif>

<cftransaction>
<cftry>
	<cfif isdefined("form.AltaE")>
		<cfquery name="empresa_insert"  datasource="#session.DSN#">
			set nocount on
			  insert Usuario ( 
			  	Ulocalizacion, Pnombre, Ppais, TIcodigo, Pid, 
			  	Pdireccion, Poficina, Pfax,Usutemporal,
				Pemail1, Icodigo, Pfoto, Pciudad, PcodPostal, Pprovincia,
				Pweb, BMUsucodigo, BMUlocalizacion, BMUsulogin )
			  values (	<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,			  
					   	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_comercial#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
						<cfif isdefined("ts")>#ts#,<cfelse>null,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">,						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#"> )

			  insert Empresa ( cliente_empresarial, Usucodigo, Ulocalizacion, nombre_comercial, razon_social, 
			                   direccion, web, telefono, fax, cuenta_maestra, 
							   ciudad,provincia,codPostal,Ppais,email,TIcodigo,identificacion,
							   BMUsucodigo, BMUlocalizacion, BMUsulogin, logo)
			  select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
				Usucodigo, Ulocalizacion, Pnombre,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.razon_social#">,
				Pdireccion,	Pweb, Poficina,	Pfax, Usucuenta,
				Pciudad,Pprovincia,PcodPostal,Ppais,Pemail1,TIcodigo,Pid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				Pfoto
			  from Usuario
			  where Usucodigo = @@identity
				and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">

			  select convert(varchar, @@identity) as Ecodigo2

			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >
	<cfelseif isdefined("form.CambioE")>
		<cfquery name="empresa_update" datasource="#session.DSN#">
			set nocount on
				update Usuario				
				set 
					   	u.Pnombre  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_comercial#">,
						u.Ppais 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
						TIcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">,
						u.Pid		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">,
						u.Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">,
						u.Poficina	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">,
						u.Pfax		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
						u.Pemail1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
						u.Icodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
						<cfif isdefined("ts")>Pfoto = #ts#,</cfif>
						u.Pciudad	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">,
						u.PcodPostal= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">,
						u.Pprovincia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">,						
						u.Pweb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">,
						u.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						u.BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
						u.BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				 		u.BMfechamod 	  = getDate()
				from Usuario u, Empresa e
				where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
				  and e.Usucodigo = u.Usucodigo
				  and e.Ulocalizacion = u.Ulocalizacion
				  and u.Usutemporal = 1
				  
				update Empresa
				set nombre_comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_comercial#">,
				    razon_social 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.razon_social#">,
				    direccion 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.direccion#">,
				    web 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web#">,
				    telefono 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.telefono#">,
				    fax 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
				    ciudad 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ciudad#">,					
				    provincia 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.provincia#">,					
				    codPostal 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codPostal#">,					
				    Ppais 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,					
				    email 			 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,										
					Icodigo			 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
					TIcodigo		 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">,
					identificacion	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion#">,
				    BMUsucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				    BMUlocalizacion  = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				    BMUsulogin       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				    BMfechamod       = getDate()
					<cfif isdefined("ts")>,logo=#ts#</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
			set nocount off
		</cfquery>
	
		<cfset modo = "CAMBIO" >		
	<cfelseif isdefined("form.BajaE")>
		<cfquery name="empresa_des" datasource="#session.DSN#">
			set nocount on
			update Empresa
			set activo = 0,
			    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			    BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
			    BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
			    BMfechamod = getDate()
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
			set nocount off
		</cfquery>
		
	<cfelseif isdefined("form.chk") and isdefined("btnActivar")>
		<cfquery name="activo_usuario" datasource="#session.DSN#">	
			<cfloop index="dato" list="#form.chk#">
				set nocount on
				update Empresa
				set activo = 1,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					BMfechamod = getDate()
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
				set nocount off
			</cfloop>
		</cfquery>
		<cfset action = "listaEmpresasRecycle.cfm" >
	
	<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
		<cfquery name="inativo_usuario" datasource="#session.DSN#">
			<cfloop index="dato" list="#form.chk#">
				set nocount on
	
				declare @Usucodigo numeric
				declare @Ulocalizacion char(2)
				select @Usucodigo=Usucodigo, @Ulocalizacion=Ulocalizacion
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">

				update Empresa
				set e.BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				  	e.BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
				  	e.BMUsulogin      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				  	e.BMfechamod      = getDate()				  
				from Empresa e, Usuario u
				where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
				  and e.Usucodigo = u.Usucodigo
				  and e.Ulocalizacion = u.Ulocalizacion
				  and u.Usutemporal = 1

				delete Empresa
				from Empresa e, Usuario u
				where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dato#">
				  and e.Usucodigo = u.Usucodigo
				  and e.Ulocalizacion = u.Ulocalizacion
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
		<cfset action = "listaEmpresasRecycle.cfm" >
	</cfif>
<cfcatch type="database">
	<cfinclude template="../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfif not isdefined("form.ecodigo2") and isdefined("empresa_insert")>
	<cfset form.ecodigo2 = empresa_insert.ecodigo2 >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
	<input name="cliente_empresarial" type="hidden" value="<cfoutput>#cliente_empresarial#</cfoutput>">	

	<cfif modo neq 'ALTA'>
		<input name="ecodigo2" type="hidden" value="#form.ecodigo2#">
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