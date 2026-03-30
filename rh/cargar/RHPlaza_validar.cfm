<!--- 
	******************************************
	* CARGA INICIAL DE RHPLAZAS
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciónes
	* Este archivo debe contener todas 
	* las validaciones requeridas, previas
	* a la importación final del archivo.
	******************************************
--->

<!--- Validación 100: Validar que no existan campos repetidos (CDRHHPlazas) --->
<cfinvoke ErrorCode	 = "100" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHPLcodigo" 
		  ColumnType = "S"/>

<!--- Validación 200: Validar que no existan campos repetidos (CDRHHPlazas) --->
<cfinvoke ErrorCode	 = "200" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHPLcodigo" 
		  TableDest	 = "RHPlazas" 
		  ColumnDest = "RHPcodigo" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"
		  ColumnType = "S"/>
		
<!--- Validacion 300: Verifica que el codigo del Puesto Asociado Exista --->
<cfset ArrColumnName = ListToArray('CDRHHPcodigo')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue )
	select 	300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Existe el Puesto Asociado',
			'El código del Puesto Asociado ya existe en la tabla RHPuestos.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#	
	and not exists ( select 1 
					 from RHPuestos b
                  	 where b.Ecodigo = #Gvar.Ecodigo#
						and b.RHPcodigo = #Gvar.table_name#.CDRHHPcodigo )
</cfquery>	

<!--- Validacion 400: Verifica que el codigo del Puesto y Centro Funcional Existan --->
<cfset ArrColumnName = ListToArray('CDRHHPcodigo,CDRHHCFcodigo')>
<cfset ArrColumnType = ListToArray('S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 400, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Existe el Centro Funcional/Puesto','El código de Centro Funcional/Puesto ya existe en las tablas CFuncional/RHPuestos.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#	
	and not exists ( select 1 
					 from CFuncional b, RHPuestos c
                  	 where #Gvar.table_name#.CDRHHCFcodigo = b.CFcodigo
						and b.Ecodigo = #Gvar.Ecodigo#
						and #Gvar.table_name#.CDRHHPcodigo = c.RHPcodigo
						and c.Ecodigo = #Gvar.Ecodigo# )
</cfquery>							
	