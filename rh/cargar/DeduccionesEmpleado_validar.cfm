<!--- 
******************************************
CARGA INICIAL DE DEDUCCIONESEMPLEADO
	FECHA    DE    CREACION:    22/03/2007
	CREADO   POR:   DORIAN   ABARCA  GOMEZ
******************************************
*********************************
Archivo      de      validaciones
Este  archivo debe contener todas 
las    validaciones   requeridas, 
previas  a  la  importacion final 
del archivo.
*********************************
--->
<cf_dbfunction name="OP_concat" returnvariable="CAT" >   

<!--- Validacion 100: Validar que no existan campos repetidos --->
<cfinvoke ErrorCode		= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHDEidentificacion, CDRHHDEfdesde, CDRHHDEfhasta, CDRHHDEdeduccion, CDRHHDEsocio, CDRHHDEnomina" 
		  ColumnType	= "S,D,D,S,S,S"/>

<!--- Validacion 200: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDEidentificacion" 
		  TableDest		= "DatosEmpleado" 
		  ColumnDest	= "DEidentificacion" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 300: Verifica que la persona este nombrada --->
<!--- Comentado porque es necesario subir histórico de empleados inactivos
<cfset ArrColumnName = ListToArray('CDRHHDEidentificacion, CDRHHDEfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 300, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
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
					where b.Ecodigo = #Gvar.Ecodigo#
						and b.DEidentificacion = #Gvar.table_name#.CDRHHDEidentificacion
						and j.LTdesde <= #Gvar.table_name#.CDRHHDEfhasta
						and j.LThasta >= #Gvar.table_name#.CDRHHDEfdesde
					)
	and Ecodigo = #Gvar.Ecodigo#				
</cfquery>
--->

<!--- Validacion 400: Deducciones Existen --->
<cfinvoke ErrorCode		= "400" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDEdeduccion" 
		  ColumnType 	= "S"
		  TableDest		= "TDeduccion" 
		  ColumnDest	= "TDcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 500: Socio de Negocios --->
<cfinvoke ErrorCode		= "500" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDEsocio" 
		  TableDest		= "SNegocios" 
		  ColumnDest	= "SNnumero" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 600: Todos los Registros Existen --->
<cfset ArrColumnName = ListToArray('CDRHHDEidentificacion, CDRHHDEfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#(	ErrorCode, 
									ColumnName, 
									ColumnType, 
									Message, 
									Details, 
									ColumnValue)
	select 	600, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Incompleta informaci&oacute;n a insertar',
			'Los datos de las columnas indicadas no existen en SNegocios\TDeduccion\DatosEmpleado',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					 case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end  #CAT# ','  #CAT# 
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">  </cfloop>
						
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(select 1
			from SNegocios b, 
				TDeduccion c,
				DatosEmpleado d
			where b.Ecodigo = #Gvar.Ecodigo#
				and rtrim(b.SNnumero) = rtrim(#Gvar.table_name#.CDRHHDEsocio)
				
				and rtrim(c.TDcodigo) = rtrim(#Gvar.table_name#.CDRHHDEdeduccion)
				and c.Ecodigo = b.Ecodigo
				
				and d.DEidentificacion = #Gvar.table_name#.CDRHHDEidentificacion
				and d.Ecodigo = b.Ecodigo
			)
	and Ecodigo = #Gvar.Ecodigo#		
</cfquery>

<!--- Validacion 700: Valida que los datos no hayan sido insertados anteriormente 
<cfset ArrColumnName = ListToArray('CDRHHDEidentificacion, CDRHHDEfdesde, CDRHHDEfhasta, CDRHHDEdeduccion, CDRHHDEsocio')>
<cfset ArrColumnType = ListToArray('S,D,D,S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Ya existe la informaci&oacute;n en la tabla DeduccionesEmpleado','Los datos de las columnas indicadas ya existen en la tabla destino',
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
	and Ecodigo = #Gvar.Ecodigo#
	and exists
			(select 1
			from SNegocios b,
				TDeduccion c, 
				DatosEmpleado d,
				DeduccionesEmpleado e
			where b.Ecodigo = #Gvar.Ecodigo#
				and rtrim(b.SNnumero) = rtrim(#Gvar.table_name#.CDRHHDEsocio)
				
				and rtrim(c.TDcodigo) = rtrim(#Gvar.table_name#.CDRHHDEdeduccion)
				and c.Ecodigo = b.Ecodigo
				
				and d.DEidentificacion = #Gvar.table_name#.CDRHHDEidentificacion
				and d.Ecodigo = b.Ecodigo
			
			   and e.DEid = d.DEid
			   and e.TDid = c.TDid
			   and e.SNcodigo = b.SNcodigo
			   and e.Dfechaini = #Gvar.table_name#.CDRHHDEfdesde
			   and e.Dfechafin = #Gvar.table_name#.CDRHHDEfhasta
			)
</cfquery> --->