<!---
	Importador IMPACCIONPERSONAL
	Importador de Datos de Entrada Para Interfaz de 
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 11/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
	14/09/2007	anav	modificacion en el importador de datos para que todos los campos sean obligatorios
--->
<!--- SE BUSCA EL NUMERO DE INTERFAZ PARA EL PROCESO --->
<cfinclude template="/interfacesSoin/Componentes/interfaces.cfc">
<cfset LvarInterfaz = 204>
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="INTERFAZ_ERROR204" returnvariable="INTERFAZ_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Empresa" 		type="varchar(5)" 	mandatory="no">
	<cf_dbtempcol name="IDEmpleado" 	type="varchar(60)" 	mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="no">
</cf_dbtemp>
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select '', '','Empresas Nulas.', Empresa, 100
	from #table_name#
	where Empresa is null
</cfquery>

<!--- VALIDA QUE EL ID DEL EMPLEADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Tipo de Acción Nula.', TipoAccionPersonal, 101
	from #table_name#
	where TipoAccionPersonal is null
</cfquery>
<!--- VALIDA QUE LA FECHA RIGE NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Fecha Rige Nulas.', FechaRige, 102
	from #table_name#
	where FechaRige is null
</cfquery>

<!--- VALIDA QUE LA FECHA VENCE NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Fecha Vence Nula.', FechaVence, 103
	from #table_name#
	where FechaVence is null
</cfquery>

<!--- VALIDA QUE EL ID DEL EMPLEADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, '','Identificación de Empleado Nulas.', IDEmpleado, 104
	from #table_name#
	where IDEmpleado is null
</cfquery>

<!--- VALIDA QUE EL CODIGO DE LA PLAZA ASIGNADA NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Código de Plaza Nulo.', '', 105
	from #table_name#
	where CodPlaza is null
</cfquery>
<!--- VALIDA QUE EL CODIGO DEL TIPO DE NOMINA ASIGNADA NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Código del Tipo de Nómina Nulo.', '', 106
	from #table_name#
	where CodTipoNomina is null
</cfquery>
<!--- VALIDA QUE EL CODIGO DEL TIPO DE JORNADA ASIGNADA NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Código del Tipo de Jornada Nulo.', '', 107
	from #table_name#
	where CodTipoJornada is null
</cfquery>
<!--- VALIDA QUE EL CODIGO DEL REGIMEN DE VACACIONES ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Código del Régimen de Vacaciones Nulo.', '', 108
	from #table_name#
	where CodRegVaca is null
</cfquery>
<!--- VALIDA QUE EL COMPONENTE SALARIAL 1 ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Componente Salarial 1 Nulo.', '', 109
	from #table_name#
	where CompSalarial1 is null
</cfquery>
<!--- VALIDA QUE EL MONTO PARA COMPONENTE SALARIAL 1 ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Monto del Componente Salarial 1 Nulo.', '', 111
	from #table_name#
	where MontoSal1 is null
</cfquery>
<!--- VALIDA QUE EL MONTO PARA COMPONENTE SALARIAL 2 ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Monto del Componente Salarial 2 Nulo.', '', 112
	from #table_name#
	where CompSalarial2 is not null
	  and MontoSal2 is null
</cfquery>
<!--- VALIDA QUE EL MONTO PARA COMPONENTE SALARIAL 3 ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Monto del Componente Salarial 3 Nulo.', '', 112
	from #table_name#
	where CompSalarial3 is not null
	  and MontoSal3 is null
</cfquery>
<!--- VALIDA QUE EL MONTO PARA COMPONENTE SALARIAL 4 ASIGNADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #INTERFAZ_ERROR# (Empresa, IDEmpleado,Mensaje, DatoIncorrecto, ErrorNum)
	select Empresa, IDEmpleado,'Monto del Componente Salarial 4 Nulo.', '', 112
	from #table_name#
	where CompSalarial4 is not null
	  and MontoSal4 is null
</cfquery>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Empresa, IDEmpleado, Mensaje, DatoIncorrecto 
	from #INTERFAZ_ERROR#
	order by Empresa, IDEmpleado,ErrorNum
</cfquery>

<cfif err.recordcount eq 0>

	<cfquery name="r" datasource="#session.dsn#">
		select em.Ecodigo,
			TipoAccionPersonal,
			FechaRige,
			FechaVence,
			IDEmpleado,
			CodRegVaca,
			CodTipoJornada,
			CompSalarial1,
			MontoSal1,
			CodTipoNomina,
			CompSalarial2,
			coalesce(MontoSal2,0) as MontoSal2,
			CompSalarial3,
			coalesce(MontoSal3,0) as MontoSal3,
			CompSalarial4,
			coalesce(MontoSal4,0) as MontoSal4,
			CodPlaza
		from #table_name# tn
			inner join Empresa em
			on  em.CEcodigo = #session.cecodigo# 
			and em.Enumero = tn.Empresa 
	</cfquery>
	<cftransaction>
		<cfloop query="r">
			<cfset LvarID  = fnSiguienteIdProceso()>
			<cfquery datasource="sifinterfaces">
				insert into IE204
					(ID, 
						EcodigoSDC, 
						TipoAccionPersonal, 
						FechaRige, 
						FechaVence, 
						IdentificacionEmpleado, 
						CodigoRegVacaciones, 
						CodigoTipoJornada, 
						ComponenteSalarial1, 
						MontoSalarial1, 
						CodigoTipoNomina, 
						ComponenteSalarial2, 
						MontoSalarial2, 
						ComponenteSalarial3, 
						MontoSalarial3, 
						ComponenteSalarial4, 
						MontoSalarial4, 
						CodigoPlazaAsignada, 
						BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#r.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.TipoAccionPersonal#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#r.FechaRige#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#r.FechaVence#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#r.IDEmpleado#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CodRegVaca#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CodTipoJornada#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CompSalarial1#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#r.MontoSal1#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CodTipoNomina#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CompSalarial2#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#r.MontoSal2#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CompSalarial3#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#r.MontoSal3#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CompSalarial4#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#r.MontoSal4#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#r.CodPlaza#">,
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
