



<cfquery datasource="asp" name="users" >
	select count(1) as cant from Usuario
</cfquery>
<cfif users.cant GT 1>
	<cfoutput>
		El portal ya ha sido inicializado.  Adios.
	</cfoutput>
</cfif>
users.cant: <cfoutput>#users.cant#</cfoutput>
<cfif users.cant is 0>
	<cftransaction>
	
		<cfquery datasource="asp">
			insert into Pais (
				Ppais, Pnombre)
			values (
				'CR', 'Costa Rica')
		</cfquery>
	
		<cfquery datasource="asp">
			insert into Moneda (
			  Mcodigo, Mnombre, Msimbolo, Miso4217)
			values (
			  1, 
			  {fn concat({fn concat('Costa Rica, Col', char(243))}, 'n')},
			  {fn concat(char(162), ' ')},
			  'CRC')
		</cfquery>

		<cfquery datasource="asp">
			insert into Direcciones (
			id_direccion, Ppais, atencion, direccion1,
			  direccion2, ciudad, estado, codPostal,
			  BMUsucodigo, BMfechamod)
			values (
			  1, 'CR', 'Portal', 'Parque Empresarial Forum',
			  'Portal', 'Santa Ana', 'San Jose', '901-6155',
			  1, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfquery>

		<cfquery datasource="asp">
			insert into CuentaEmpresarial (
			  CEcodigo, id_direccion, Mcodigo, LOCIdioma,
			  CEnombre, CEcuenta, CEtelefono1, CEtelefono2,
			  CEfax, CEcontrato, CEaliaslogin,
			  BMfecha, BMUsucodigo, CEactiva)
			values (
			  1, 1, 1, 'es',
			  'Cuenta Maestra del Portal', '00506-00001', '204-7151', '504-7150',
			  '204-7155', null, null,
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 0, 1)
		</cfquery>

		<cfquery datasource="asp">
			insert into DatosPersonales (
			  datos_personales, Pid, Pnombre, Papellido1,
			  Papellido2, Pnacimiento, Psexo, Pcasa,
			  Poficina, Pcelular, Pfax, Ppagertel,
			  Ppagernum, Pemail1, Pemail2, Pweb,
			  BMUsucodigo, BMfechamod)
			values (
			  1, '123456789', 'Oficial de Seguridad del Portal', null,
			  null, null, null, null,
			  null, null, null, null,
			  null, null, null, null,
			  0, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfquery>


		<cfquery datasource="asp">
			insert into Usuario (
			  Usucodigo, CEcodigo, id_direccion, datos_personales,
			  LOCIdioma, Usulogin, admin, Ureferencia1,
			  Ureferencia2, Ureferencia3, BMfecha, BMUsucodigo,
			  Uestado, Utemporal, Ufdesde, Ufhasta,
			  Usupregunta, Usurespuesta)
			values (
			  1, 1, 1, 1,
			  null, 'pso', 1, null,
			  null, null, 
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			  0,
			  1, 0,
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">,
			  'Nombre de mi mascota', 'mascota')
		</cfquery>
		usuario insertado
		
		<cfquery datasource="asp">
			<!--- password: park3r --->
			insert into UsuarioPassword (
			Usucodigo, Usulogin, Hash, HashMethod,
			  PasswordSalt, SessionData, SessionExpires, TicketData,
			  TicketExpires, AllowedAccess, PasswordSet)
			values (
			  1, 'pso', 'cf89e8859e68d4e06ae216c9264fe864', 'MD5',
			  'Ch73pV4UD1lX8wbAO5xDdv31CpliduHdpj43pUvNKTldiIP4Pnw4s71s879lk73pTqNBmy7ea8hcA6J2MeVRSRdOJpjHqTwn3NfrkJJe2083CFXD13De8qSBctlrQdii',
			  null, null, null,
			  null, 1,
			  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfquery>
		password insertado
	</cftransaction>
</cfif>

<br>
<a href="../menu/index.cfm">login</a>