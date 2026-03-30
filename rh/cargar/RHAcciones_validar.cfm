<!---
	******************************************
	* CARGA INICIAL DE ACCIONES DE PERSONAL
	* FECHA DE CREACION:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciones
	* Este archivo debe contener todas
	* las validaciones requeridas, previas
	* a la importación final del archivo.
	******************************************
--->

<!--- Validacion 100: Verifica que la Cédula del Empleado exista --->
<cfset ArrColumnName = ListToArray('CDRHHcedula')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue,
								  Ecodigo )
	select 	100,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'No existe la c&eacute;dula Empleado',
			'La c&eacute;dula o identificaci&oacute;n del Empleado no existe en la tabla DatosEmpleado.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#

	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
						from DatosEmpleado b
                  		where b.Ecodigo = #Gvar.Ecodigo#
						  and b.DEidentificacion = #Gvar.table_name#.CDRHHcedula )
</cfquery>


<!---Rriettie Validacion 150: Validar que no existan campos repetidos --->
<cfinvoke ErrorCode		= "150"
		  method		  = "funcVRepetidos"
		  ColumnName	= "CDRHHcedula, CDRHHtipoAccion, CDRHHfechaIni "
		  ColumnType	= "S,S,D"/>


<!---Rriettie Validacion 175: Verifica que no se nombre mas de una vez a una persona o que la persona no tenga dos veces un mismo tipo de accion--->
<!--- Para la tabla de RHAcciones --->
<cfset ArrColumnName = ListToArray('CDRHHcedula,CDRHHtipoAccion, CDRHHfechaIni')>
<cfset ArrColumnType = ListToArray('S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue,
								  Ecodigo )
	select 	175,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'El empleado tiene mas de una vez un mismo tipo de acci&oacute;n asociado ',
			'En la tabla RHAcciones ya existe un registro de ese empleado con el tipo de acci&oacute;n y fecha de inicio.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#
	where CDPcontrolv = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
	and exists(	select 1
						    from RHAcciones b,
						    		 DatosEmpleado dEmpl,
						    		 RHTipoAccion tipoAcc

                where b.Ecodigo = #Gvar.Ecodigo#
                and dEmpl.Ecodigo = b.Ecodigo
                and dEmpl.DEidentificacion = #Gvar.table_name#.CDRHHcedula
                and dEmpl.DEid= b.DEid

                and tipoAcc.Ecodigo = b.Ecodigo
                and tipoAcc.RHTcodigo = #Gvar.table_name#.CDRHHtipoAccion
                and b.RHTid = tipoAcc.RHTid

						    and b.DLfvigencia = #Gvar.table_name#.CDRHHfechaIni )
</cfquery>


<!--- Validacion 200: Verifica que exista el Tipo de Accion de Personal en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHtipoAccion')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue,
								  Ecodigo )
	select 	200,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'No existe el Tipo de Acci&oacute;n',
			'El c&oacute;digo del Tipo de Acci&oacute;n no existe en la tabla RHTipoAccion.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#

	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
						from RHTipoAccion b
                  		where b.Ecodigo = #Gvar.Ecodigo#
						  and b.RHTcodigo = #Gvar.table_name#.CDRHHtipoAccion )
</cfquery>

<!--- Validacion 300: Verifica que exista el Tipo Nómina en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHtipoNomina')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue ,
								  Ecodigo)
	select 	300,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'No existe el Tipo de N&oacute;mina',
			'El c&oacute;digo del Tipo de N&oacute;mina no existe en la tabla TiposNomina.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#

	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
						from TiposNomina b
                  		where b.Ecodigo = #Gvar.Ecodigo#
						  and b.Tcodigo = #Gvar.table_name#.CDRHHtipoNomina )
</cfquery>

<!--- Validacion 400: Verifica que exista el Régimen de Vacaciones en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHregimen')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue  ,
								  Ecodigo)
	select 	400,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'No existe el Regimen de Vacaciones',
			'El c&oacute;digo del Regimen de Vacaciones no existe en la tabla RegimenVacaciones.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#

	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RegimenVacaciones b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
						  and b.RVcodigo = #Gvar.table_name#.CDRHHregimen )
</cfquery>


<!--- Validacion 500: Verifica que exista la Jornada en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHjornada')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode,
								  ColumnName,
								  ColumnType,
								  Message,
								  Details,
								  ColumnValue,
								  Ecodigo )
	select 	500,
			'#ArrayToList(ArrColumnName)#',
			'#ArrayToList(ArrColumnType)#',
			'No existe la Jornada',
			'El c&oacute;digo de la Jornada no existe en la tabla RHJornadas.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end,',')},
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHJornadas b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHJcodigo = #Gvar.table_name#.CDRHHjornada )
</cfquery>


<!--- Validacion 600: Verifica que exista la plaza en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHplaza')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 600, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe la Plaza','El c&oacute;digo de Plaza no existe en la tabla RHPlazas.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHPlazas b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = #Gvar.table_name#.CDRHHplaza )
</cfquery>


<!--- Validacion 700: Verifica que exista el Puesto en el Catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHpuesto')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue , Ecodigo)
	select 700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe el Puesto','El c&oacutedigo del Puesto no existe en la tabla RHPuestos.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHPuestos b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = #Gvar.table_name#.CDRHHpuesto )
</cfquery>


<!--- Validacion 800: Verifica que exista la Categoría en el Catálogo
<cfset ArrColumnName = ListToArray('CDRHHcategoria')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue , Ecodigo)
	select 800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe la Categor&iacute;a','El c&oacute;digo de la Categor&iacute;a no existe en la tabla RHCategoria.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHCategoria b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHCcodigo = #Gvar.table_name#.CDRHHcategoria )
</cfquery>
--->

<!--- Validacion 900: Verifica que exista el Centro Funcional en el catálogo --->
<cfset ArrColumnName = ListToArray('CDRHHcentroCosto')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue , Ecodigo)
	select 900, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe el Centro Funcional','El c&oacute;digo del Centro Funcional no existe en la tabla CFuncional.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from CFuncional b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.CFcodigo = #Gvar.table_name#.CDRHHcentroCosto )
</cfquery>


<!--- Validacion 1000: Verifica que el Puesto este relacionado a la Plaza --->
<cfset ArrColumnName = ListToArray('CDRHHpuesto, CDRHHplaza')>
<cfset ArrColumnType = ListToArray('S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue , Ecodigo)
	select 1000, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe relaci&oacute;n entre Puestos y Plazas','El c&oacute;digo del Puesto no esta relacionado con el c&oacute;digo de la Plaza.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHPuestos b, RHPlazas c
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = #Gvar.table_name#.CDRHHpuesto
							and c.Ecodigo = #Gvar.Ecodigo#
							and c.RHPcodigo = #Gvar.table_name#.CDRHHplaza
 							and b.RHPcodigo = c.RHPpuesto )
</cfquery>


<!--- Validacion 1100: Verifica que la Plaza tenga Plaza Presupuestaria Asociada --->
<cfset ArrColumnName = ListToArray('CDRHHplaza')>
<cfset ArrColumnType = ListToArray('S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1100, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe Plaza Presupuestario Asociada','El c&oacute;digo de Plaza esta asociado a una Plaza Presupuestaria.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHPlazas b, RHPlazaPresupuestaria c
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = #Gvar.table_name#.CDRHHplaza
							and c.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = c.RHPPcodigo )
</cfquery>


<!--- Validacion 1200: Verifica que la Plaza este relacionado con el Centro Funcional --->
<cfset ArrColumnName = ListToArray('CDRHHplaza, CDRHHcentroCosto')>
<cfset ArrColumnType = ListToArray('S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1200, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'No existe Centro Funcional Asociado','El c&oacute;digo de Plaza no esta asociado a un Centro Funcional.',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and not exists(	select 1
					 	from RHPlazas b, CFuncional c
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and b.RHPcodigo = #Gvar.table_name#.CDRHHplaza
							and c.Ecodigo = #Gvar.Ecodigo#
							and c.CFcodigo = #Gvar.table_name#.CDRHHcentroCosto
							and b.CFid = c.CFid )
</cfquery>

<!--- Validación 1250: Valida Repetidos en las Plazas--->
<!--- OPARRALES 2018-08-29 Se modifica validacion entre Plaza y Empleados... debe ser unica la combinacion. --->
<cfinvoke ErrorCode	 = "1250"
		  method	 = "funcVRepetidos"
		  ColumnType	= "S,S"
		  ColumnName = "CDRHHcedula,CDRHHplaza"
		  />

<!--- Montos Salariales --->

<!--- ----------------- --->
<!--- Valida si se encontro el Componente Salarial --->
<!--- ----------------- --->
<cfset ArrColumnName = ListToArray('CDRHHCS1,CDRHHCS2,CDRHHCS3,CDRHHCS4,CDRHHCS5,CDRHHCS6,CDRHHCS7,CDRHHCS8,CDRHHCS9,CDRHHCS10,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,S,S,S,S,S,S,S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1275, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Hay Componentes Salariales no v&aacute;lidos',
	'El c&oacute;digo del componente no existe en la tabla ComponentesSalariales',
 <cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else '' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
	and not exists(	select 1
					 	from ComponentesSalariales b
                  	 	where b.Ecodigo = #Gvar.Ecodigo#
							and (	#Gvar.table_name#.CDRHHCS1 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS2 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS3 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS4 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS5 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS6 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS7 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS8 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS9 = b.CScodigo
									or #Gvar.table_name#.CDRHHCS10 = b.CScodigo ) )
</cfquery>



<!--- --------------------------------------------------- --->
<!--- Valida que no se ingreso el Componente Salarial, siembargo se ingreso un monto para ese componente. Validacion para todos los componentes --->
<!--- --------------------------------------------------- --->

<!--- Validacion 1300:  Valida que exista el CDRHHCS1 y CDRHHCSMonto1 --->
<cfset ArrColumnName = ListToArray('CDRHHCS1,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1300, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS1 no existe para el monto salarial 1',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS1 is null
		and CDRHHCSMonto1 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1400:  Valida que exista el CDRHHCS2 y CDRHHCSMonto2 --->
<cfset ArrColumnName = ListToArray('CDRHHCS2,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1400, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS2 no existe para el monto salarial 2',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS2 is null
		and CDRHHCSMonto2 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1500:  Valida que exista el CDRHHCS3 y CDRHHCSMonto3 --->
<cfset ArrColumnName = ListToArray('CDRHHCS3,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1500, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS3 no existe para el monto salarial 3',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS3 is null
		and CDRHHCSMonto3 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1600:  Valida que exista el CDRHHCS4 y CDRHHCSMonto4 --->
<cfset ArrColumnName = ListToArray('CDRHHCS4,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1600, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS4 no existe para el monto salarial 4',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS4 is null
		and CDRHHCSMonto4 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1700:  Valida que exista el CDRHHCS5 y CDRHHCSMonto5 --->
<cfset ArrColumnName = ListToArray('CDRHHCS5,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS5 no existe para el monto salarial 5',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#

	from #Gvar.table_name#
	where CDRHHCS5 is null
		and CDRHHCSMonto5 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1800:  Valida que exista el CDRHHCS6 y CDRHHCSMonto6 --->
<cfset ArrColumnName = ListToArray('CDRHHCS6,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue , Ecodigo)
	select 1800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS6 no existe para el monto salarial 6',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS6 is null
		and CDRHHCSMonto6 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1900:  Valida que exista el CDRHHCS7 y CDRHHCSMonto7 --->
<cfset ArrColumnName = ListToArray('CDRHHCS7,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 1900, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS7 no existe para el monto salarial 7',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS7 is null
		and CDRHHCSMonto7 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2000:  Valida que exista el CDRHHCS8 y CDRHHCSMonto8 --->
<cfset ArrColumnName = ListToArray('CDRHHCS8,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2000, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS8 no existe para el monto salarial 8',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS8 is null
		and CDRHHCSMonto8 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2100:  Valida que exista el CDRHHCS9 y CDRHHCSMonto9 --->
<cfset ArrColumnName = ListToArray('CDRHHCS9,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2100, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS9 no existe para el monto salarial 9',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS9 is null
		and CDRHHCSMonto9 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2200:  Valida que exista el CDRHHCS10 y CDRHHCSMonto10 --->
<cfset ArrColumnName = ListToArray('CDRHHCS9,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('S,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2200, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el monto pero no el componente salarial asociado','El CS10 no existe para el monto salarial 10',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS10 is null
		and CDRHHCSMonto10 >= 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- ----------------- --->
<!--- Valida que se ingreso el Componente Salarial, siembargo el monto para ese componente es nulo. Validacion para todos los componentes --->
<!--- ----------------- --->

<!--- Validacion 2300:  Valida que exista el CDRHHCSMonto1 y CDRHHCS1 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto1,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2300, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 1 no existe para el CS1',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS1 is not null
		and CDRHHCSMonto1 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2400:  Valida que exista el CDRHHCSMonto2 y CDRHHCS2 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto2,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2400, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 2 no existe para el CS2',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS2 is not null
		and CDRHHCSMonto2 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2500:  Valida que exista el CDRHHCSMonto3 y CDRHHCS3 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto3,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2500, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 3 no existe para el CS3',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS3 is not null
		and CDRHHCSMonto3 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2600:  Valida que exista el CDRHHCSMonto4 y CDRHHCS4 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto4,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2600, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 4 no existe para el CS4',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS4 is not null
		and CDRHHCSMonto4 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2700:  Valida que exista el CDRHHCSMonto5 y CDRHHCS5 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto5,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 5 no existe para el CS5',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS5 is not null
		and CDRHHCSMonto5 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2800:  Valida que exista el CDRHHCSMonto6 y CDRHHCS6 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto6,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 6 no existe para el CS6',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS6 is not null
		and CDRHHCSMonto6 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 2900:  Valida que exista el CDRHHCSMonto7 y CDRHHCS7 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto7,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 2900, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 7 no existe para el CS7',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS7 is not null
		and CDRHHCSMonto7 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 3000:  Valida que exista el CDRHHCSMonto8 y CDRHHC8 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto8,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 3000, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 8 no existe para el CS8',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS8 is not null
		and CDRHHCSMonto8 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 3100:  Valida que exista el CDRHHCSMonto9 y CDRHHC9 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto9,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 3100, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 9 no existe para el CS9',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS9 is not null
		and CDRHHCSMonto9 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 3200:  Valida que exista el CDRHHCSMonto10 y CDRHHC10 --->
<cfset ArrColumnName = ListToArray('CDRHHCSMonto10,CDRHHcedula,CDRHHtipoAccion,CDRHHfechaFin')>
<cfset ArrColumnType = ListToArray('M,S,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo)
	select 3200, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#',
	'Se definio el Componente Salarial pero no el Monto asociado','El Monto Salarial 10 no existe para el CS10',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  #ArrColumnName[i]# is not null then
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>,
		#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDRHHCS10 is not null
		and CDRHHCSMonto10 is null
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>



