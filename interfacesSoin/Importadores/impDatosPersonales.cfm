<!--- Componente de Interfaces --->
<cfinclude template="/interfacesSoin/Componentes/interfaces.cfc">

<!--- Se asigna el Número de Interfaz para el proceso --->
<cfset LvarInterfaz = 202>

<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="INTERFAZ_ERRORDP" returnvariable="INTERFAZ_ERRORDP" datasource="#session.dsn#">
	<cf_dbtempcol name="Empresa" 			type="varchar(5)" 	mandatory="no">
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)" 	mandatory="no">
	<cf_dbtempcol name="Mensaje" 			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" 	type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 			type="integer" 		mandatory="no">
</cf_dbtemp>
<!--- 0. Modo --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Modo inválido.', Modo, 0
	from #table_name#
	where Modo not in ('A','B','C')
</cfquery>

<!--- 1. Validacion de la empresa --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select '', IdentificacionEmpleado, 'Empresas Nulas.', Empresa, 100
	from #table_name#
	where Empresa is null
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Empresa no encontrada en la corporación.', Empresa, 200
	from #table_name#
	where not exists(select 1 from Empresa where CEcodigo = #session.cecodigo# and Enumero = #table_name#.Empresa)
</cfquery>

<!--- 2. Tipo de Identificacion --->
<!--- 2.1 Identificacion no nula --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Tipo de Identificacion nulo.', TipoIdentificacion, 300
	from #table_name#
	where TipoIdentificacion is null
</cfquery>
<!--- 2.2 Valor incorrecto --->
<!---
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Tipo de Identificacion incorrecto.', TipoIdentificacion, 310
	from #table_name#
	where  TipoIdentificacion != '0'
</cfquery>
--->

<!--- 3. Identificacion del empleado--->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Identificación nula.', IdentificacionEmpleado, 400
	from #table_name#
	where IdentificacionEmpleado is null
</cfquery>

<!--- 4. Nombre del empleado--->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Nombre de Empleado nulo.', Nombre, 500
	from #table_name#
	where Nombre is null
</cfquery>

<!--- 5. Sexo del empleado--->
<!--- 5.1 sexo nulo --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Sexo nulo.', Sexo, 600
	from #table_name#
	where Sexo is null
</cfquery>
<!--- 5.2 sexo no valido --->
<cfquery datasource="#session.dsn#" name="x">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Sexo inválido.', Sexo, 600
	from #table_name#
	where ltrim(rtrim(Sexo)) not in ('F','M')
</cfquery>

<!--- 6. fecha de nacimiento --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Fecha de nacimiento nula.', FechaNacimiento, 800
	from #table_name#
	where FechaNacimiento is null
</cfquery>

<!--- <!--- banco --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Código de banco nulo.', CuentaBancaria, 1020
	from #table_name#
	where Banco is null
</cfquery>

<!--- 7. cuenta bancaria --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Cuenta bancaria nula.', CuentaBancaria, 900
	from #table_name#
	where CuentaBancaria is null
</cfquery> --->

<!--- 8. estado civil --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Estado civil nulo.', <cf_dbfunction name="to_char" args="EstadoCivil">, 1000
	from #table_name#
	where EstadoCivil is null
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'Estado civil inválido.', <cf_dbfunction name="to_char" args="EstadoCivil">, 1010
	from #table_name#
	where EstadoCivil not in (0,1,2,3,4,5)
</cfquery>

<!--- Pais incorrecto --->
<!---
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERRORDP# (Empresa, DEidentificacion, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, 'País inválido.', Pais, 1100
	from #table_name#
	where upper(Pais) != 'GT'
</cfquery>
--->

<!---
***Mcodigo

EcodigoSDC
Imodo
TipoIdentificacion
IdentificacionEmpleado
Nombre
Sexo
FechaNacimiento
CuentaBancaria
EstadoCivil
--->

<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Empresa, DEidentificacion, Mensaje, DatoIncorrecto 
	from #INTERFAZ_ERRORDP#
	order by Empresa, DEidentificacion, ErrorNum
</cfquery>

<!--- Inicia el proceso si no hay errores --->
<cfif err.recordcount eq 0>

<!--- Obtiene los datos de la tabla temporal --->
<cfquery name="r" datasource="#session.dsn#">
	select 	Ecodigo as Empresa,
			Modo,
			IdentificacionEmpleado,
			TipoIdentificacion,
			EstadoCivil,
			Nombre,
			Apellido1,
			Apellido2,
			Sexo,
			FechaNacimiento,
			Banco,
			CuentaBancaria,
			CarnetMarcas,
			Pais,
			DatoVariable1,
			DatoVariable2,
			DatoVariable3,
			DatoVariable4,
			DatoVariable5,
			DatoVariable6,
			DatoVariable7,
			DatoInformativo1,
			DatoInformativo2,
			DatoInformativo3,
			DatoInformativo4,
			DatoInformativo5,
			DatoObservacion1,
			DatoObservacion2,
			DatoObservacion3,
			DatoObservacion4,
			DatoObservacion5

	from #table_name# tn
		inner join Empresa em
		on  em.CEcodigo = #session.cecodigo# 
		and em.Enumero = tn.Empresa
</cfquery>

<!--- Crea una invocación a interfaz por cada registro de la tabla temporal --->
<cftransaction>

	<cfloop query="r">
		<cfset LvarID  = fnSiguienteIdProceso()>
		<cfquery datasource="sifinterfaces">
			insert into IE202 ( ID, 
						   EcodigoSDC, 
						   Imodo, 
						   IdentificacionEmpleado, 
						   TipoIdentificacion, 
						   EstadoCivil, 
						   Nombre, 
						   Apellido1, 
						   Apellido2, 
						   Sexo, 
						   FechaNacimiento, 
						   Banco,
						   CuentaBancaria, 
						   CarnetMarcas, 
						   Pais, 
						   DatoVariable1, 
						   DatoVariable2, 
						   DatoVariable3, 
						   DatoVariable4, 
						   DatoVariable5, 
						   DatoVariable6, 
						   DatoVariable7, 
						   DatoInformativo1, 
						   DatoInformativo2, 
						   DatoInformativo3, 
						   DatoInformativo4, 
						   DatoInformativo5, 
						   DatoObservacion1, 
						   DatoObservacion2, 
						   DatoObservacion3, 
						   DatoObservacion4, 
						   DatoObservacion5, 
						   BMUsucodigo)

			values(		<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.Empresa#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Modo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.IdentificacionEmpleado#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.TipoIdentificacion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.EstadoCivil#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Nombre#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Apellido1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Apellido2#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Sexo#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedatetime(r.FechaNacimiento)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Banco#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.CuentaBancaria#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.CarnetMarcas#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Pais#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable2#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable3#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable4#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable5#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable6#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoVariable7#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoInformativo1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoInformativo2#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoInformativo3#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoInformativo4#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoInformativo5#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoObservacion1#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoObservacion2#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoObservacion3#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoObservacion4#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.DatoObservacion5#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )		
		</cfquery>
		<cfset LvarMSG = fnProcesoNuevoExterno(LvarInterfaz, LvarID, '#session.Usulogin#')>
		<cfif LvarMSG NEQ "OK">
			<cftransaction action="rollback"/>
			<cfthrow message="#LvarMSG#">
		</cfif>
	</cfloop>

</cftransaction>

</cfif>