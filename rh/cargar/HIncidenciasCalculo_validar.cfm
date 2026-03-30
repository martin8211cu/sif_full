<!--- 
******************************************
CARGA INICIAL DE INCIDENCIASCALCULO
	FECHA    DE    CREACION:    23/03/2007
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
<!--- Parametro para aumentar el tiempo de respuesta --->
<cfsetting requesttimeout="20000">

<cf_dbfunction name="OP_concat" returnvariable="CAT" > 

<!--- Validacion 100: Validar que no existan campos repetidos <cfinvoke ErrorCode 	= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHICidentificacion, CDRHHICfdesde, CDRHHICfhasta, CDRHHICincidencia, CDRHHICnomina" 
		  ColumnType	= "S,D,D,S,S"
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>
--->

<!--- Validacion 200: Validar que se hayan cargado HRCalculoNomina --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHICnomina, CDRHHICfdesde, CDRHHICfhasta" 
		  ColumnType	= "S,D,D" 
		  TableDest		= "HRCalculoNomina" 
		  ColumnDest	= "Tcodigo, RCdesde, RChasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe HRCalculoNomina"/>

<!--- Validacion 300: Validar que se haya cargado  HRSalarioEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde, CDRHHICfhasta, CDRHHICnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue )
	select 	300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No se ha cargado HSalarioEmpleado',
			'El empleado indicado no tiene un registro en HSalarioEmpleado',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  #ArrColumnName[i]# is not null then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT#
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
				Where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
				  and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and d.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
				  and d.Ecodigo = b.Ecodigo
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 400: Validar que se haya cargado  HPagosEmpleado --->
<!--- BNValores: las nominas especiales NO graban en HPagosEmpleado, entonces deben excluirse de esta validacion --->
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde, CDRHHICfhasta, CDRHHICnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue )
	select 	400, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'No se ha cargado HPagosEmpleado',
			'El empleado indicado no tiene un registro en HPagosEmpleado',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  #ArrColumnName[i]# is not null then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT#
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>
	from #Gvar.table_name#, CalendarioPagos cp
	where CDPcontrolv = 0
	and not exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
					, HPagosEmpleado e
					, CalendarioPagos cp

				Where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
				  and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and d.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
				  and d.Ecodigo = b.Ecodigo
				  and e.RCNid = c.RCNid
				  and e.DEid = c.DEid
				  and cp.CPid = c.RCNid
				  and cp.CPtipo != 1		<!---  Nominas especiales no caen en HPagosEmpleado  --->
			)
    and CDRHHIncidenciasCalculo.Ecodigo = #Gvar.Ecodigo#
    and cp.CPdesde=CDRHHICfdesde
    and cp.CPhasta=CDRHHICfhasta
    and cp.CPtipo != 1
</cfquery>

<!--- Validacion 500: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode		= "500" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHICidentificacion" 
		  TableDest		= "DatosEmpleado" 
		  ColumnDest	= "DEidentificacion" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 600: Que las fechas del Historico coincidan con el Calendario Pagos (CalendarioPagos) --->
<cfinvoke ErrorCode="600" 
		  method="funcVIntegridad" 
		  ColumnName="CDRHHICnomina, CDRHHICfdesde, CDRHHICfhasta" 
		  ColumnType="S,D,D"
		  TableDest="CalendarioPagos" 
		  ColumnDest="Tcodigo, CPdesde, CPhasta" 
		  Filtro="Ecodigo = #Gvar.Ecodigo#"
		  Message="No existe el Calendario de Pagos"/>

<!--- Validacion 700: Verifica que la persona este nombrada --->
<!--- Comentado porque es necesario subir histórico de empleados inactivos
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 700, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'El empleado no ha sido nombrado','El empleado indicado no tiene un registro vigente para la fecha de la n&oacute;mina',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end #CAT# ','  #CAT#
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists(	select 1
					from DatosEmpleado b
						inner join LineaTiempo j
							on j.DEid = b.DEid
							and j.Ecodigo = b.Ecodigo
					where b.Ecodigo = #Gvar.Ecodigo#
						and b.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
						and j.LTdesde <= #Gvar.table_name#.CDRHHICfhasta
						and j.LThasta >= #Gvar.table_name#.CDRHHICfdesde
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>
--->

<!--- Validacion 800: Verifica que la nomina de carga es igual a la linea del tiempo
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde, CDRHHICnomina')>
<cfset ArrColumnType = ListToArray('S,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#
	(ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue)
	select 800, '#ArrayToList(ArrColumnName)#', '#ArrayToList(ArrColumnType)#', 
	'Tipo de n&oacute;mina inv&aacute;lido','El Tipo de N&oacute;mina del empleado no coincide en el de su nombramiento, para la fecha de la n&oacute;mina',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			case when  #ArrColumnName[i]# is not null then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end #CAT# ','  #CAT#
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(select 1
			from DatosEmpleado b, LineaTiempo j
			where b.Ecodigo = #Gvar.Ecodigo#
			and b.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
			and #Gvar.table_name#.CDRHHICfdesde between j.LTdesde and j.LThasta
			and j.DEid = b.DEid
			and j.Ecodigo = b.Ecodigo
			and rtrim(j.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
			and b.Ecodigo = #Gvar.Ecodigo#	
			)
	and Ecodigo = #Gvar.Ecodigo#		
</cfquery> --->

<!--- Validacion 900: Valida que los datos no hayan sido insertados anteriormente --->
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde, CDRHHICfhasta, CDRHHICincidencia, CDRHHICnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S,S')>
<!---
<cfquery datasource="#Gvar.Conexion#" name="jc">
		select count(1)
		from #Gvar.table_name#
	where CDPcontrolv = 0
	and exists
			(
			Select 1 
			from HRCalculoNomina b,
			     HSalarioEmpleado c,
   			     HPagosEmpleado d,
   			     HIncidenciasCalculo e,
   			     DatosEmpleado f
			Where b.Ecodigo = #Gvar.Ecodigo#
				and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
				and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
				and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
				
				and c.RCNid = b.RCNid
				
				and d.RCNid = c.RCNid
				and d.DEid = c.DEid
				and	d.DEid = f.DEid
				
				and e.RCNid = c.RCNid
				and e.DEid = c.DEid
				
				and f.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
				and	f.Ecodigo =  b.Ecodigo
				and b.Ecodigo = #Gvar.Ecodigo#	
			)
	and Ecodigo = #Gvar.Ecodigo#
		</cfquery>
		<cf_dump label="dos" var="#jc#">
--->	
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select	900, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Ya existe la informaci&oacute;n en la tabla HIncidenciasCalculo',
			'Los datos de las columnas indicadas ya existen en la tabla destino',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT#
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and exists
			(
			Select 1 
			from HRCalculoNomina b,
			     HSalarioEmpleado c,
   			     HPagosEmpleado d,
   			     HIncidenciasCalculo e,
   			     DatosEmpleado f
			Where b.Ecodigo = #Gvar.Ecodigo#
				and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
				and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
				and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
				
				and c.RCNid = b.RCNid
				
				and d.RCNid = c.RCNid
				and d.DEid = c.DEid
				and	d.DEid = f.DEid
				
				and e.RCNid = c.RCNid
				and e.DEid = c.DEid
				
				and f.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
				and	f.Ecodigo =  b.Ecodigo
				and b.Ecodigo = #Gvar.Ecodigo#	
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 1000: Incidencias Existen --->
<cfinvoke ErrorCode		= "1000" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHICincidencia" 
		  TableDest		= "CIncidentes" 
		  ColumnDest	= "CIcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 1100: CFuncional Existe Si Viene --->
<cfinvoke ErrorCode		= "1100" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHICcfuncional" 
		  AllowNulls	= "true"
		  TableDest		= "CFuncional" 
		  ColumnDest	= "CFcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 1200: Validar que la Suma de todas las Incidencias sean igual al Monto Indicado en HSalarioEmpleados --->
<cfset ArrColumnName = ListToArray('CDRHHICvalor,CDRHHICidentificacion, CDRHHICfdesde')>
<cfset ArrColumnType = ListToArray('M,S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	1200, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'La suma de las incidencias no concuerda',
			'La suma de las incidencias es disitinta que el monto de incidencias de HSalarioEmpleado',
			<cf_dbfunction name="to_char" args="sum(#Gvar.table_name#.CDRHHICvalor)" datasource="#Gvar.Conexion#">

	from #Gvar.table_name#,
		HRCalculoNomina b, 
		HSalarioEmpleado c, 
		DatosEmpleado e

	Where CDPcontrolv = 0
		and b.Ecodigo = #Gvar.Ecodigo#
		and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
		and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
		and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
		and c.RCNid = b.RCNid
		and c.DEid = e.DEid
		and e.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
		and e.Ecodigo = b.Ecodigo
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#	
		
	group by b.RCNid, c.DEid, c.SEincidencias
	having floor(c.SEincidencias) <> floor(sum(#Gvar.table_name#.CDRHHICvalor))
</cfquery>

<!--- Validacion 1300: Todos los Registros Existen --->
<cfset ArrColumnName = ListToArray('CDRHHICidentificacion, CDRHHICfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue )
	select 	1300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Incompleta informaci&oacute;n a insertar',
			'Los datos de las columnas indicadas no existen en HRCalculoNomina\DatosEmpleado\HSalarioEmpleado\CIncidentes.',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT#
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>

	from #Gvar.table_name#

	where CDPcontrolv = 0
	and not exists
			(	select 1 
				from HRCalculoNomina b, 
		 	 	DatosEmpleado c, 
		 	 	HSalarioEmpleado d, 
		 	 	CIncidentes e
			where 	b.Ecodigo = #Gvar.Ecodigo#
			and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
			and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
			and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
			
			and c.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
			and c.Ecodigo = b.Ecodigo
			
			and d.RCNid = b.RCNid
			and d.DEid = c.DEid
			
			and rtrim(e.CIcodigo) = rtrim(#Gvar.table_name#.CDRHHICincidencia)
			and e.Ecodigo = b.Ecodigo
			and b.Ecodigo = #Gvar.Ecodigo#	)
	and Ecodigo = #Gvar.Ecodigo#			
</cfquery>

