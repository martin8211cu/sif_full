<!--- 
******************************************
CARGA INICIAL DE HSALARIOEMPLEADO
	FECHA    DE    CREACIÓN:    20/03/2007
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
<!--- Validación 100: Validar que no existan campos repetidos --->
<cfinvoke ErrorCode="100" method="funcVRepetidos" ColumnName="CDRHHSEidentificacion, CDRHHSEfdesde, CDRHHSEfhasta, CDRHHSEnomina" ColumnType="S,D,D,S"/>
<!--- Validacion 200: Verificar que los registro no se hayan cargado anticipidamente --->
<cfset ArrColumnName = ListToArray('CDRHHSEidentificacion, CDRHHSEfdesde, CDRHHSEfhasta, CDRHHSEnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfset Gvar_Debug = False>
<cfif Gvar_Debug>
<cfset d = Now()>
</cfif>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 200, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Ya existe la informaci&oacute;n en la tabla HSalarioEmpleado','Los datos de las columnas indicadas ya existen en la tabla destino',
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
			(
			select 1 
			from HRCalculoNomina b, DatosEmpleado d, HSalarioEmpleado c
        	Where b.Ecodigo = #Gvar.Ecodigo#
	        and b.Tcodigo = #Gvar.table_name#.CDRHHSEnomina	
			and b.RCdesde = #Gvar.table_name#.CDRHHSEfdesde
	        and b.RChasta = #Gvar.table_name#.CDRHHSEfhasta
	        and d.DEidentificacion = #Gvar.table_name#.CDRHHSEidentificacion
			and d.Ecodigo = b.Ecodigo
			and c.RCNid = b.RCNid
			and c.DEid = d.DEid
			)
</cfquery>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validacion 300: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode="300" method="funcVIntegridad" ColumnName="CDRHHSEidentificacion" 
			TableDest="DatosEmpleado" ColumnDest="DEidentificacion" Filtro="Ecodigo = #Gvar.Ecodigo#" debug = Gvar_Debug/>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validación 400: Que las fechas del Historico coincidan con el Calendario Pagos (CalendarioPagos) --->
<cfinvoke ErrorCode="400" method="funcVIntegridad" ColumnName="CDRHHSEnomina, CDRHHSEfdesde, CDRHHSEfhasta" ColumnType="S,D,D"
			TableDest="CalendarioPagos" ColumnDest="Tcodigo, CPdesde, CPhasta" Filtro="Ecodigo = #Gvar.Ecodigo#"
			Message="No existe el Calendario de Pagos"/>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validación 500: SalarioBruto + Incidencias - (Cargas_emp + deducciones+ renta) = Liquido --->
<cfinvoke ErrorCode="500" method="funcVFormula" ColumnName="CDRHHSEliquido" ColumnType="M"
			Formula="round(CDRHHSEsalariobruto + CDRHHSEincidencias - CDRHHSEcargasemp - CDRHHSErenta - CDRHHSEdeducciones - CDRHHSEliquido,0) <> 0">
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validacion 600: Existir encabezado de la relacion de calculo --->
<cfinvoke ErrorCode="600" method="funcVIntegridad" ColumnName="CDRHHSEnomina, CDRHHSEfdesde, CDRHHSEfhasta" ColumnType="S,D,D"
			TableDest="HRCalculoNomina" ColumnDest="Tcodigo, RCdesde, RChasta" Filtro="Ecodigo = #Gvar.Ecodigo#"
			Message="No existe la Relaci&oacute;n de C&aacute;lculo"/>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validación 700: Se registran todos los datos de la tabla temporal (JOIN de insert) --->
<cfset ArrColumnName = ListToArray('CDRHHSEidentificacion, CDRHHSEfdesde, CDRHHSEfhasta, CDRHHSEnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Incompleta informaci&oacute;n a insertar','Los datos de las columnas indicadas no existen en HRCalculoNomina/DatosEmpleado',
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
	and not exists
			(   
			select 1 
			from HRCalculoNomina b, DatosEmpleado d
        	Where b.Ecodigo = #Gvar.Ecodigo#
	        and b.Tcodigo = #Gvar.table_name#.CDRHHSEnomina	
			and b.RCdesde = #Gvar.table_name#.CDRHHSEfdesde
	        and b.RChasta = #Gvar.table_name#.CDRHHSEfhasta
	        and d.DEidentificacion = #Gvar.table_name#.CDRHHSEidentificacion
			and d.Ecodigo = b.Ecodigo
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cfdump var="#r#">
<cfset d = Now()>
</cfif>
<!--- Validación 800: Verifica que la persona este nombrada --->
<!--- Comentado porque es necesario subir hist�rico de empleados inactivos
<cfset ArrColumnName = ListToArray('CDRHHSEidentificacion, CDRHHSEfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'El empleado no ha sido nombrado','El empleado indicado no tiene un registro vigente para la fecha de la n&oacute;mina',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end,',')},
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">)}</cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists(	select 1
					from DatosEmpleado b
						inner join LineaTiempo j
							on j.DEid = b.DEid
							and j.Ecodigo = b.Ecodigo
					where b.DEidentificacion = #Gvar.table_name#.CDRHHSEidentificacion
						and b.Ecodigo = #Gvar.Ecodigo#
						and j.LTdesde <= #Gvar.table_name#.CDRHHSEfhasta
						and j.LThasta >= #Gvar.table_name#.CDRHHSEfdesde
				   )
	and Ecodigo = #Gvar.Ecodigo#			   
</cfquery>
<cfif Gvar_Debug>
<cfset r = datediff("s",d,Now())>
<cf_dump var="#r#">
<cfset d = Now()>
</cfif>
--->
<!--- Validación 900: Verifica que el tipo de nomina sea igual a la de nombramiento
<cfset ArrColumnName = ListToArray('CDRHHSEidentificacion, CDRHHSEfdesde, CDRHHSEnomina')>
<cfset ArrColumnType = ListToArray('S,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 900, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Tipo de n&oacute;mina inv&aacute;lido','El Tipo de N&oacute;mina del empleado no coincide en el de su nombramiento, para la fecha de la n&oacute;mina',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			{fn concat({fn concat(case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
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
			and b.DEidentificacion = #Gvar.table_name#.CDRHHSEidentificacion
			and #Gvar.table_name#.CDRHHSEfdesde between j.LTdesde and j.LThasta
			and j.DEid = b.DEid
			and j.Ecodigo = b.Ecodigo
			and j.Tcodigo = #Gvar.table_name#.CDRHHSEnomina
			)
</cfquery> --->