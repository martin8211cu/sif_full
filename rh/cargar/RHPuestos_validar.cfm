<!--- 
	******************************************
	* CARGA INICIAL DE RHPUESTOS
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


<!--- Validación 100: Validar que no existan campos repetidos (CDRHHPuestos) --->
<cfinvoke ErrorCode="100" method="funcVRepetidos" ColumnName="CDRHHPcodigo" ColumnType="S"/>

<!--- Validacion 200: Que los registros no hayan sido insertados (RHPuestos) --->
<cfinvoke ErrorCode="200" method="funcVRepetidos" ColumnName="CDRHHPcodigo" 
	TableDest="RHPuestos" ColumnDest="RHPcodigo" Filtro="Ecodigo = #Gvar.Ecodigo#"
	ColumnType="S"/>
	
<!--- Validacion 300: Verifica que el Maestro de Puestos Presupuestarios no exista con el Codigo a generar --->
<cfset ArrColumnName = ListToArray('CDRHHPcodigo')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 300, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Existe el Maestro de Puestos Presupuestarios','El código de Maestro de Puestos Presupuestarios ya existe.',
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
	and exists ( select 1 
					 from RHMaestroPuestoP b
                  	 where b.Ecodigo = #Gvar.Ecodigo#
						and b.RHMPPcodigo = {fn concat('PP-', ltrim(rtrim(#Gvar.table_name#.CDRHHPcodigo)))} )
</cfquery>


<!----Valida que exista el tipo de puesto ------>
<cfset ArrColumnName = ListToArray('CDRHHPtipoPuesto')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
			(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 	400, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No Existe el Tipo de Puesto',
			'El código de Tipo de Puesto no existe en la tabla de RHTPuestos',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then 
									<cfif trim(ArrColumnType[i]) EQ 'D'>
										<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
									<cfelse>
										<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
									</cfif> else 'NULL' end
								,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists ( select 1 
					 from RHTPuestos b
                  	 where b.Ecodigo = #Gvar.Ecodigo#
						and ltrim(rtrim(b.RHTPcodigo)) = ltrim(rtrim(#Gvar.table_name#.CDRHHPtipoPuesto)) )
</cfquery>

<!--- Validacion 301: Valida que el codigo de ocupacion: CDRHHPocupacion exista en la tabla RHOcupaciones--->
<cfinvoke ErrorCode	 = "301" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHHPocupacion" 
		  TableDest	 = "RHOcupaciones" 
		  ColumnDest = "RHOcodigo"/>	
		  
<!--- Validacion 302: Valida que el codigo de puesto Externo:  CDRHHPcodigoExt exista en la tabla RHPuestosExternos--->
<cfinvoke ErrorCode	 = "302" 
		  method	 = "funcVIntegridad" 
		  ColumnName = "CDRHHPcodigoExt" 
		  ColumnType = "S"
		  TableDest	 = "RHPuestosExternos" 
		  ColumnDest = "RHPEcodigo" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"/>		  


<!-----
<!--- Validacion 400: Verifica que el Maestro de Puestos Presupuestarios no exista con el Codigo a generar --->
<cfset ArrColumnName = ListToArray('CDRHHPtipoPuesto')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 400, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'No Existe el Tipo de Puesto','El código de Tipo de Puesto no existe en la tabla de RHTPuestos',
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
	and not exists ( select 1 
					 from RHTPuestos b
                  	 where b.Ecodigo = #Gvar.Ecodigo#
						and ltrim(rtrim(b.RHTPcodigo)) = ltrim(rtrim(#Gvar.table_name#.CDRHHPtipoPuesto)) )
</cfquery>
----->


