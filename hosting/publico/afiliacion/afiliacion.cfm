<cf_template>
	<cf_templatearea name="title">
		<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
			Mis Datos Personales
		<cfelse>
			Registro de Miembros
		</cfif>
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

		<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
			<!--- Chequear que el usuario tenga datos en MEPersona --->
			<cfquery name="rsExistsMEPersona" datasource="#Session.DSN#">
				select 1
				from asp..UsuarioReferencia a, MEPersona b
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and a.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="MEPersona">
				  and convert(numeric, a.llave) = b.MEpersona
			</cfquery>
			
			<cfif rsExistsMEPersona.recordCount EQ 0>
				<cfquery name="insertMEPersona" datasource="#Session.DSN#">
					declare @persona numeric
					
					insert MEPersona 
					(	MEOid, cliente_empresarial, Ecodigo, Pnombre, Papellido1, Papellido2, Ppais, Icodigo, TIcodigo, Pid, 
						Pnacimiento, Psexo, Pemail1, Pemail2, Pweb, Pdireccion, Pdireccion2, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, 
						Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, activo, BMfechamod
					)
					select 
						(select min(a.MEOid)
						from MEOcupacion a
						where a.Ppais = t.Ppais
						  and a.Icodigo = u.LOCIdioma
						),
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">,
						v.Pnombre,
						v.Papellido1,
						v.Papellido2,
						t.Ppais,
						u.LOCIdioma,
						'LIC',
						'',
						v.Pnacimiento,
						v.Psexo,
						v.Pemail1,
						null,
						null,
						t.direccion1,
						t.direccion2,
						t.ciudad,
						t.estado,
						t.codPostal,
						v.Pcasa, 
						v.Poficina, 
						v.Pcelular,
						Pfax, 
						null,
						null,
						null,
						null,
						null,
						1,
						getDate()
					from asp..Usuario u, asp..Direcciones t, asp..DatosPersonales v
					where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					and u.id_direccion = t.id_direccion
					and u.datos_personales = v.datos_personales
					
					select @persona = @@identity
					
					insert asp..UsuarioReferencia (Usucodigo, Ecodigo, STabla, llave, BMfecha, BMUsucodigo)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">, 
						'MEPersona', 
						convert(varchar, @persona), 
						getDate(), 
						0
				</cfquery>
			</cfif>
		</cfif>
	
		<cfinclude template="afiliacion-form.cfm">
	
	</cf_templatearea>
</cf_template>
