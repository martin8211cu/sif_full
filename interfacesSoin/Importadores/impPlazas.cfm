﻿<!---
	Importador IMPPLAZAS
	Importador de Datos de Entrada Para Interfaz de Plazas
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: D.A.G. (dabarca@soin.co.cr)
	Fecha de Creación: 10/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->

<!--- Componente de Interfaces --->
<cfinclude template="/interfacesSoin/Componentes/interfaces.cfc">

<!--- Se asigna el Número de Interfaz para el proceso --->
<cfset LvarInterfaz = 201>

<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="INTERFAZ201_ERROR" returnvariable="INTERFAZ_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Empresa" 		type="varchar(5)" 	mandatory="no">
	<cf_dbtempcol name="CodigoPlaza" 	type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="no">
</cf_dbtemp>

<!--- Identificacion de Errores Triviales que pueden generar inconsistencias en este proceso (Inserción en la tabla de interfaz) --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, CodigoPlaza, Mensaje, DatoIncorrecto, ErrorNum)
	select '', '', 'Empresas Nulas.', <cf_dbfunction name="to_char" args="count(1)">, 100
	from #table_name#
	where Empresa is null
	having count(1) > 0
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, CodigoPlaza, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, '', 'Empresa no encontrada en la corporación.', <cf_dbfunction name="to_char" args="count(1)">, 200
	from #table_name#
	where not exists(select 1 from Empresa where CEcodigo = #session.cecodigo# and Enumero = #table_name#.Empresa)
	group by Empresa
	having count(1) > 0
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, CodigoPlaza, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, CodigoPlaza, 'Modo Inválido.', Modo, 300
	from #table_name#
	where not (Modo = 'A'
		or Modo = 'C')
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, CodigoPlaza, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, CodigoPlaza, 'Estado Inválido.', <cf_dbfunction name="to_char" args="Estado">, 400
	from #table_name#
	where not (Estado = 0
		or Estado = 1)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, CodigoPlaza, Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, CodigoPlaza, 'Plaza Resp.', <cf_dbfunction name="to_char" args="PlazaResp">, 500
	from #table_name#
	where not (PlazaResp = 0
		or PlazaResp = 1)
</cfquery>

<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Empresa, CodigoPlaza, Mensaje, DatoIncorrecto 
	from #INTERFAZ_ERROR#
	order by Empresa, CodigoPlaza, ErrorNum
</cfquery>

<!--- Inicia el proceso si no hay errores --->
<cfif err.recordcount eq 0>

<!--- Obtiene los datos de la tabla temporal --->
<cfquery name="r" datasource="#session.dsn#">
	select 	em.Ecodigo, Modo, CodigoPlaza, Descripcion, CodigoPuesto, CodigoCentroFuncional, FechaActivacion, Estado, PlazaResp
	from #table_name# tn
		inner join Empresa em
		on  em.CEcodigo = #session.cecodigo# 
		and em.Enumero = tn.Empresa
</cfquery>
<cf_dump var="#r#">
<!--- Crea una invocación a interfaz por cada registro de la tabla temporal --->
<cftransaction>

	<cfloop query="r">
		<cfset LvarID  = fnSiguienteIdProceso()>
		<cfquery datasource="sifinterfaces">
			insert into IE201
			(ID, EcodigoSDC, Imodo, CodigoPlaza, DescripcionPlaza, CodigoPuesto, CodigoCentroFuncional, FechaActivacion, Estado, PlazaResp, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Modo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.CodigoPlaza#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.Descripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.CodigoPuesto#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.CodigoCentroFuncional#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#r.FechaActivacion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.Estado#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.PlazaResp#">, 
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