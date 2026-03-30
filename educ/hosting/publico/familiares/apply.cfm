
		<cftry>
			<cfif isdefined("Form.Eliminar") and Form.Eliminar eq "S">
				<cfquery name="rs_insert" datasource="#Session.DSN#">
					delete MERelacionFamiliar
					where MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.MEPersona#">
						and MEpersona2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona2#">
					
					delete MEPersona
					where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona2#">
				</cfquery>
			
			<cfelseif isdefined("Form.Registrar")>
				<cfquery name="rs_insert" datasource="#Session.DSN#">
				
					declare @insertado numeric
					
					insert MEPersona 
					(	MEOid, cliente_empresarial, Ecodigo, Pnombre, Papellido1, Papellido2, Icodigo, TIcodigo, Pid, 
						Pnacimiento, Psexo, Pemail1, Pemail2, Pweb, Ppais, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, 
						Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMfechamod
					)
					select 
						<cfif len(trim(Form.MEOcupacion)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOcupacion#"><cfelse>null</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.cecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">, 
						'LIC', 
						'', 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.Pnacimiento,'yyyymmdd')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
						null, 
						null, 
						<cfif isdefined("Form.Ppais")><cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ppais#"><cfelse>Ppais</cfif>, 
						<cfif isdefined("Form.Pdireccion")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#"><cfelse>Pdireccion</cfif>, 
						<cfif isdefined("Form.Pdireccion2")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#"><cfelse>Pdireccion2</cfif>, 
						<cfif isdefined("Form.Pciudad")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#"><cfelse>Pciudad</cfif>, 
						<cfif isdefined("Form.Pprovincia")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#"><cfelse>Pprovincia</cfif>, 
						<cfif isdefined("Form.PcodPostal")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#"><cfelse>PcodPostal</cfif>, 
						<cfif isdefined("Form.Pcasa")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcasa#"><cfelse>Pcasa</cfif>, 
						<cfif isdefined("Form.Poficina")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Poficina#"><cfelse>null</cfif>, 
						<cfif isdefined("Form.Pcelular")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#"><cfelse>null</cfif>, 
						<cfif isdefined("Form.Pfax")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#"><cfelse>Pfax</cfif>, 
						null, 
						null, 
						null, 
						null, 
						null, 
						1,
						getdate()
					from MEPersona
					where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.MEPersona#">
					
					select @insertado  = @@identity
					
					insert MERelacionFamiliar(
						MEpersona1, MEpersona2, MEPid
					)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">, @insertado, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEParentesco#">
					)
					
				</cfquery>

			<cfelseif isdefined("Form.Actualizar")>
				<cfquery name="rs_insert" datasource="#Session.DSN#">
					update MEPersona set 
						<cfif len(trim(Form.MEOcupacion)) gt 0>MEOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOcupacion#">,</cfif>
						Pnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pnombre#">, 
						Papellido1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido1#">, 
						Papellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Papellido2#">, 
						Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">, 
						Pnacimiento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.Pnacimiento,'yyyymmdd')#">,
						Psexo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Psexo#">, 
						Pemail1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">, 
						<cfif isdefined("Form.Ppais")>Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ppais#">,</cfif>
						<cfif isdefined("Form.Pdireccion")>Pdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion#">,</cfif>
						<cfif isdefined("Form.Pdireccion2")>Pdireccion2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pdireccion2#">,</cfif>
						<cfif isdefined("Form.Pciudad")>Pciudad = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pciudad#">,</cfif>
						<cfif isdefined("Form.Pprovincia")>Pprovincia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pprovincia#">,</cfif>
						<cfif isdefined("Form.PcodPostal")>PcodPostal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PcodPostal#">,</cfif>
						<cfif isdefined("Form.Pcasa")>Pcasa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcasa#">,</cfif> 
						<cfif isdefined("Form.Poficina")>Poficina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Poficina#">,</cfif>
						<cfif isdefined("Form.Pcelular")>Pcelular = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcelular#">,</cfif>
						<cfif isdefined("Form.Pfax")>Pfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pfax#">,</cfif>
						BMfechamod = getdate()
					where 
						MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona2#">
					
					update MERelacionFamiliar
					set MEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEParentesco#">
					where MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.MEPersona#">
						and MEpersona2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEpersona2#">
					
				</cfquery>

			</cfif>
		
		<cfcatch type="any">
			<cfinclude template="/sif/errorpages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	
	<cflocation url="familiares.cfm">