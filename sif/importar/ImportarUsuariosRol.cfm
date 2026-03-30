<!--- 
	Inicialización del Componente de Seguridad del Framework 
	Se Invoca en el proceso de generación de usuarios en la seguridad
--->
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<!---
	Datos de empresa y corporación de la base de datos asp
--->

<cfquery name="rsEmpresaRef" datasource="asp">
	select a.Ecodigo as EcodigoCorp, a.CEcodigo, a.Ereferencia as Ecodigo, b.Ccache as DSN
	from Empresa a
		inner join Caches b
		on b.Cid = a.Cid
	where a.CEcodigo = #session.CEcodigo#
	  and a.Ereferencia = #session.Ecodigo#
</cfquery>

<cfset EmpresaASP = rsEmpresaRef.EcodigoCorp>

<!--- 
	Encontrar el Idioma y Pais de la Cuenta Empresarial 
--->
<cfquery name="rsDatosCuenta" datasource="asp">
	select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
	from CuentaEmpresarial a
		inner join Direcciones b
		on b.id_direccion = a.id_direccion
	where a.CEcodigo = #rsEmpresaRef.CEcodigo#
</cfquery>

<!--- 
	Obtener los datos de la tabla de importación
--->
<cfquery name="rsUsuarios" datasource="#session.dsn#">
	select Login, Cedula, Nombre, ApellidoP, ApellidoM, Sexo, TelefonoCasa, TelefonoCel, CorreoE, Direccion, Sistema, Rol
	from #table_name#
</cfquery>

<!--- 
	Crear Usuarios 
--->
<cfloop query="rsUsuarios">
	<cfquery name="rsBuscaUsuario" datasource="asp">
		select count(1) as Cantidad
		from Usuario
		where CEcodigo = #session.CEcodigo#
		  and Usulogin = '#rsUsuarios.Login#'
	</cfquery>

	<cfif rsBuscaUsuario.Cantidad EQ 0>

		<cftransaction>
			<!--- Datos personales --->
			<cfquery datasource="asp" name="DPinserted">
				insert into DatosPersonales (
					Pid, Pnombre, Papellido1, Papellido2, 
					Psexo, Pcasa, Pcelular, Pemail1, 
					BMUsucodigo, BMfechamod)
				values (
					'#rsUsuarios.Cedula#', '#rsUsuarios.Nombre#', '#rsUsuarios.ApellidoP#', '#rsUsuarios.ApellidoM#', 
					'#rsUsuarios.Sexo#', '#rsUsuarios.TelefonoCasa#', '#rsUsuarios.TelefonoCel#', '#rsUsuarios.CorreoE#',
					#session.Usucodigo#,
					#now()#
					)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="DPinserted">

			<!--- Inserta la direccion --->
			<cfquery datasource="asp" name="Dinserted">
				insert into Direcciones (
					atencion, direccion1, Ppais,
					BMUsucodigo, BMfechamod)
				values (
					'#Trim(rsUsuarios.Nombre & ' ' & rsUsuarios.ApellidoP & ' ' & rsUsuarios.ApellidoM)#',
					'#rsUsuarios.Direccion#',
					'#rsDatosCuenta.Ppais#',
					#session.Usucodigo#,
					#now()#
					)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="Dinserted">

		</cftransaction>	
		<!--- 
			Inserta el usuario, le asocia la direccion y los datos personales 
		--->
		<cfset enviar_password = Len(Trim(rsUsuarios.CorreoE)) NEQ 0>
		<cfset usuario = sec.crearUsuario(Session.CEcodigo, Dinserted.identity, DPinserted.identity, rsDatosCuenta.LOCIdioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), rsUsuarios.Login, enviar_password)>
		<cfset rolIns = sec.insUsuarioRol(usuario, EmpresaASP, rsUsuarios.Sistema, rsUsuarios.Rol)>
	</cfif>	
	<!--- 
		Inserta asignar el rol al usuario
	--->
</cfloop>
