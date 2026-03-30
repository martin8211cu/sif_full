<!--- 
	******************************************
	* CARGA INICIAL DE CENTROS FUNCIONALES
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

<!--- Validación 100: Validar que no existan campos repetidos (CDRHHCFuncional) --->
<cfinvoke ErrorCode		= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHCFcodigo" 
		  ColumnType	= "S"/>

<!--- Validacion 200: Que el código del Centro Funcional no este repetido (CDRHHCFuncional vs CFuncional) --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHCFcodigo" 
		  TableDest		= "CFuncional" 
		  ColumnDest	= "CFcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  ColumnType	= "S"/>

<!--- Validacion 300: Verifica que exista el Departamento --->
<cfset ArrColumnName = ListToArray('CDRHHDptoCodigo')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No existe el Departamento',
			'El c&oacute;digo de Departamento no existe en la tabla de Departamentos',
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
		and not exists( select 1
						from Departamentos dpto
						where dpto.Ecodigo = #Gvar.Ecodigo#
							and rtrim(dpto.Deptocodigo) = rtrim(#Gvar.table_name#.CDRHHDptoCodigo) )
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo# 
</cfquery>

<!--- Validacion 400: Verifica que existan las Oficinas --->
<cfset ArrColumnName = ListToArray('CDRHHOficodigo')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	400, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No existe la Oficina','El c&oacute;digo de Oficna no existe en la tabla de Oficinas',
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
		and not exists( select 1
						from Oficinas ofic
						where ofic.Ecodigo = #Gvar.Ecodigo# 
							and ofic.Oficodigo = #Gvar.table_name#.CDRHHOficodigo )
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 500: Verifica que exista el Centro Funcional Responsable o Padre --->
<cfset ArrColumnName = ListToArray('CDRHHCFcodigoPadre')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	500, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Existe la Centro Funcional Responsable',
			'El código del Centro Funcional Responsable ya existe en la tabla de CFuncional',
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
		and #Gvar.table_name#.CDRHHCFcodigoPadre not in ( select CDRHHCFcodigo from #Gvar.table_name# )
		and rtrim(ltrim(#Gvar.table_name#.CDRHHCFcodigoPadre)) <> 'RAIZ'
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>