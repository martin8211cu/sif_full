﻿<!---
	Importador IMPDATFAM
	Importador de Datos de Entrada Para Interfaz de Datos Familiares
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 13/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->

<!--- Componente de Interfaces --->
<cfinclude template="/interfacesSoin/Componentes/interfaces.cfc">

<!--- Se asigna el Número de Interfaz para el proceso --->
<cfset LvarInterfaz = 203>

<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="INTERFAZ_ERROR203" returnvariable="INTERFAZ_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Empresa" 				type="varchar(5)" 	mandatory="no">
	<cf_dbtempcol name="IdentificacionEmpleado" type="varchar(60)" 	mandatory="no">
	<cf_dbtempcol name="IdentificacionFamiliar" type="varchar(60)"  mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="no">
</cf_dbtemp>

<!--- Identificacion de Errores Triviales que pueden generar inconsistencias en este proceso (Inserción en la tabla de interfaz) --->
<!--- VERIFICA SI EL CAMPO DE LA EMPRESA VIENE VACIO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa,IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select '', '', '', 'Empresas Nulas.', <cf_dbfunction name="to_char" args="count(1)">, 100
	from #table_name#
	where Empresa is null
	having count(1) > 0
</cfquery>
<!--- VERIFICA SI LA EMPRESA EXISTE --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado,IdentificacionFamiliar, 'Empresa no encontrada en la corporación.', <cf_dbfunction name="to_char" args="count(1)">, 200
	from #table_name#
	where not exists(select 1 from Empresa where CEcodigo = #session.cecodigo# and Enumero = #table_name#.Empresa)
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>
<!--- VERIFICA SI EL MODO EXISTE --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado,IdentificacionFamiliar, 'Modo incorrecto. Debe ser A(Inclusión), B(Baja o Exclusión), C(Cambio)', <cf_dbfunction name="to_char" args="count(1)">, 300
	from #table_name#
	where #table_name#.Modo not in ('A','B','C')
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>
<!--- VERIFICA SI EL SEXO EXISTE --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado,IdentificacionFamiliar, 'Sexo incorrecto. Debe ser M (Masculino) o F(Femenino)', <cf_dbfunction name="to_char" args="count(1)">, 400
	from #table_name#
	where #table_name#.Sexo not in ('F','M')
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>
<!--- VERIFICA SI EL CAMPO IDENTIFICACIONEMPLEADO VENGA EN NULO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa,IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, '', IdentificacionFamiliar, 'Identificación del Empleado Nulos.', <cf_dbfunction name="to_char" args="count(1)">, 500
	from #table_name#
	where IdentificacionEmpleado is null
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>

<!--- VERIFICA SI EL CAMPO IDENTIFICACIONFAMILIAR VENGA EN NULO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa,IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, '', 'Identificación del Familiar Nulos.', <cf_dbfunction name="to_char" args="count(1)">, 600
	from #table_name#
	where IdentificacionFamiliar is null
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>

<!--- VERIFICA SI EL CAMPO NOMBRE DEL FAMILIAR VENGA EN NULO PARA ALTA Y CAMBIO--->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa,IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IdentificacionEmpleado, IdentificacionFamiliar, 'Nombre del Familiar Nulos.', <cf_dbfunction name="to_char" args="count(1)">, 700
	from #table_name#
	where Nombre is null
	  and Modo in ('A','C')
	group by Empresa, IdentificacionEmpleado,IdentificacionFamiliar
	having count(1) > 0
</cfquery>

<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Empresa, IdentificacionEmpleado,IdentificacionFamiliar,Mensaje, DatoIncorrecto 
	from #INTERFAZ_ERROR#
	order by Empresa,  ErrorNum
</cfquery>

<!--- Inicia el proceso si no hay errores --->
<cfif err.recordcount eq 0>
	
	<!--- Obtiene los datos de la tabla temporal --->
	<cfquery name="r" datasource="#session.dsn#">
		select em.Ecodigo as Empresa ,
			tn.Modo,
			tn.IdentificacionEmpleado,
			tn.IdentificacionFamiliar,
			tn.TipoIdentificacion,
			tn.Nombre,
			tn.Apellido1,
			tn.Apellido2,
			case tn.TipoParentezco 
					when 1 then 3
					when 2 then 2
					when 3 then 23
					when 4 then 24
					when 5 then 25
					when 6 then 26
					when 7 then 27
					when 8 then 28
					when 9 then 29
					when 10 then 30
					when 11 then 1
					when 12 then 1
					when 13 then 33
					when 14 then 34 
					else TipoParentezco end as TipoParentezco,
			tn.FechaNacimiento,
			tn.Sexo,
			tn.Direccion
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
				insert into IE203(ID, 
								  EcodigoSDC, 
								  Imodo, 
								  IdentificacionEmpleado, 
								  IdentificacionFamiliar, 
								  TipoIdentificacion, 
								  Nombre,
								  Apellido1, 
								  Apellido2, 
								  TipoParentezco, 
								  FechaNacimiento, 
								  Sexo, 
								  Direccion,
								  BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.Empresa#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Modo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.IdentificacionEmpleado#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.IdentificacionFamiliar#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.TipoIdentificacion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Nombre#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Apellido1#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Apellido2#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#r.TipoParentezco#">, 
					<cfqueryparam cfsqltype="cf_sql_date" 	 value="#r.FechaNacimiento#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Sexo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Direccion#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
			<cfset LvarMSG = fnProcesoNuevoExterno(LvarInterfaz, LvarID, '#session.Usulogin#')>
			<cfif LvarMSG NEQ "OK">
				<cftransaction action="rollback"/>
				<cfthrow message="#LvarMSG#">
			</cfif>
		</cfloop>
	</cftransaction>
</cfif>