<!--- 
******************************************
CARGA INICIAL DE HRCALCULONOMINA
	FECHA    DE    CREACIÓN:    19/03/2007
	CREADO   POR:   DORIAN   ABARCA  GÓMEZ
******************************************
*********************************
Archivo      de      validaciónes
Este  archivo debe contener todas 
las    validaciones   requeridas, 
previas  a  la  importación final 
del archivo.
*********************************
--->
<!--- Validación 100: Validar que no existan datos repetidos --->
<cfinvoke ErrorCode		= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEfhasta,CDRHHPEsalario, CDRHHPEnomina,CDRHHPEfcorteinic, CDRHHPEfcortefin" 
		  ColumnType	= "S,D,D,M,S,D,D"/>

<!--- Validacion 200: Validar que se hayan cargado HRCalculoNómina --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHPEnomina,CDRHHPEfdesde,CDRHHPEfhasta" 
		  ColumnType	= "S,D,D" 
		  TableDest		= "HRCalculoNomina" 
		  ColumnDest	= "Tcodigo, RCdesde, RChasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe HRCalculoNomina"/>

<!--- Validacion 300: Validar que se haya cargado  HRSalarioEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEfhasta, CDRHHPEsalario, CDRHHPEnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,M,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 	300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No se ha cargado HSalarioEmpleado',
			'El empleado indicado no tiene un registro en HSalarioEmpleado',
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
	and not exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
				Where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHPEfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHPEfhasta
				  and b.Tcodigo = #Gvar.table_name#.CDRHHPEnomina
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and d.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
			)
</cfquery>

<!--- Validacion 400: Validar existencia Empleado --->
<cfinvoke ErrorCode		= "400" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHPEidentificacion" 
		  ColumnType	= "S" 
		  TableDest		= "DatosEmpleado" 
		  ColumnDest	= "DEidentificacion" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validación 500: Que las fechas del Historico coincidan con el Calendario Pagos (CalendarioPagos) --->
<cfinvoke ErrorCode		= "500" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHPEnomina, CDRHHPEfdesde, CDRHHPEfhasta" 
		  ColumnType	= "S,D,D"
		  TableDest		= "CalendarioPagos" 
		  ColumnDest	= "Tcodigo, CPdesde, CPhasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe el Calendario de Pagos"/>

<!--- Validacion 600: Validar que todos los registros no hayan sido generados anteriormente --->
<cfset ArrColumnName = ListToArray('CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEfhasta,CDRHHPEsalario, CDRHHPEnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,M,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( 	ErrorCode, 
									ColumnName, 
									ColumnType, 
									Message, 
									Details, 
									ColumnValue )
	select 	600, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Ya se cargo HPagosEmpleado',
			'El empleado indicado ya tiene un registro en HPagosEmpleado',
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
	and exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, HPagosEmpleado d
					, DatosEmpleado e
				Where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHPEfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHPEfhasta
				  and b.Tcodigo = #Gvar.table_name#.CDRHHPEnomina
				  and c.RCNid = b.RCNid
				  and d.RCNid = c.RCNid
				  and d.DEid = c.DEid
				  and e.DEid = d.DEid
				  and e.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
			)
</cfquery>

<!--- Validacion 700: Verifica que la persona ya este nombrada. --->
<cfset ArrColumnName = ListToArray('CDRHHPEidentificacion, CDRHHPEfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#(	ErrorCode, 
									ColumnName, 
									ColumnType, 
									Message, 
									Details, 
									ColumnValue )
	select 	700, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'El empleado no ha sido nombrado',
			'El empleado indicado no tiene un registro vigente para la fecha de la n&oacute;mina',
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
	and not exists(	select 1
					from DatosEmpleado b
						inner join LineaTiempo j
							on j.DEid = b.DEid
							and j.Ecodigo = b.Ecodigo
					where b.Ecodigo = #Gvar.Ecodigo#
						and b.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
						and j.LTdesde <= #Gvar.table_name#.CDRHHPEfhasta
						and j.LThasta >= #Gvar.table_name#.CDRHHPEfdesde
				)
</cfquery>

<!--- Validacion 800: Verifica que la nomina de carga es igual a la linea del tiempo
<cfset ArrColumnName = ListToArray('CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEnomina')>
<cfset ArrColumnType = ListToArray('S,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Tipo de n&oacute;mina inv&aacute;lido','El Tipo de N&oacute;mina del empleado no coincide en el de su nombramiento, para la fecha de la n&oacute;mina',
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
	and not exists
			(select 1
			from DatosEmpleado b, LineaTiempo j
			where b.Ecodigo = #Gvar.Ecodigo#
			and b.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
			and #Gvar.table_name#.CDRHHPEfdesde between j.LTdesde and j.LThasta
			and j.DEid = b.DEid
			and j.Ecodigo = b.Ecodigo
			and j.Tcodigo = #Gvar.table_name#.CDRHHPEnomina
			)
</cfquery> --->

<!--- Validación 900: Se registran todos los datos de la tabla temporal (JOIN de insert) --->
<cfset ArrColumnName = ListToArray('CDRHHPEidentificacion, CDRHHPEfdesde, CDRHHPEfhasta, CDRHHPEnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	900, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Incompleta informaci&oacute;n a insertar',
			'Los datos de las columnas indicadas no existen en la HRCalculoNomina/DatosEmpleado/LineaTiempo',
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
	and not exists
			(   select 1 					
				from 
					DatosEmpleado b, 
					HRCalculoNomina c, 
					LineaTiempo j,
					RHJornadas d
				where b.Ecodigo = #Gvar.Ecodigo#
					and b.DEidentificacion = #Gvar.table_name#.CDRHHPEidentificacion
					and c.Ecodigo = b.Ecodigo
					and c.RCdesde = #Gvar.table_name#.CDRHHPEfdesde
					and c.RChasta = #Gvar.table_name#.CDRHHPEfhasta
					and c.Tcodigo = #Gvar.table_name#.CDRHHPEnomina
					and j.DEid =  b.DEid
					and j.LTdesde <= #Gvar.table_name#.CDRHHPEfhasta
					and j.LThasta >= #Gvar.table_name#.CDRHHPEfdesde
					and d.RHJid = j.RHJid
			)
</cfquery>