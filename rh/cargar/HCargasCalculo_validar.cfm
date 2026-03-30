<!--- 
	******************************************
	* CARGA INICIAL DE CARGASCALCULO
	* FECHA DE CREACIÓN:	23/03/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciones
	* Este archivo debe contener todas 
	* las validaciones requeridas, previas
	* a la importación final del archivo.
	******************************************
--->
<cf_dbfunction name="OP_concat" returnvariable="CAT" > 

<!--- Validación 100: Validar que no existan campos repetidos --->
<cfinvoke ErrorCode		= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCCcarga, CDRHHCnomina" 
		  ColumnType	= "S,D,D,S,S"/>
						
<!--- Validacion 200: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCnomina" 
		  TableDest		= "HRCalculoNomina" 
		  ColumnDest	= "RCdesde,RChasta,Tcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  ColumnType	= "D,D,S"/>		
			
<!--- Validacion 300: Validar que se haya cargado  HRSalarioEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCnomina')>
<cfset ArrColumnType = ListToArray('S,D,S,S')>
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
			(	select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
				where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
				  and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and d.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
				  and d.Ecodigo = b.Ecodigo
			)
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validacion 400: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode		= "400" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHCCidentificacion" 
		  TableDest		= "DatosEmpleado" 
		  ColumnDest	= "DEidentificacion" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>
			
<!--- Validación 500: Que las fechas del Historico coincidan con el Calendario Pagos (CalendarioPagos) --->
<cfinvoke ErrorCode		= "500" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHCnomina, CDRHHCCfdesde, CDRHHCCfhasta" 
		  ColumnType	= "S,D,D"
		  TableDest		= "CalendarioPagos" 
		  ColumnDest	= "Tcodigo, CPdesde, CPhasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe el Calendario de Pagos"/>

<!--- Validacion 600: Validar que se haya cargado  HPagosEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	600, 
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

	from #Gvar.table_name#

	where CDPcontrolv = 0
	and not exists
			(	select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
					, HPagosEmpleado e
				where b.Ecodigo=#Gvar.Ecodigo#
				  and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
		          and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
				  and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and d.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
				  and d.Ecodigo = b.Ecodigo
				  and e.RCNid = c.RCNid
				  and e.DEid = c.DEid
			)
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!--- Validación 700: Verifica que la persona este nombrada --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
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
					case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT#
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop>

	from #Gvar.table_name#

	where CDPcontrolv = 0
	and not exists (	select 1
						from DatosEmpleado b
							inner join LineaTiempo j
							on j.DEid = b.DEid
							and j.Ecodigo = b.Ecodigo
						where b.Ecodigo = #Gvar.Ecodigo#
						and b.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
						and #Gvar.table_name#.CDRHHCCfdesde between j.LTdesde and j.LThasta
					)
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>	

<!--- Validacion 800: Verifica que la nomina de carga es igual a la linea del tiempo --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCnomina')>
<cfset ArrColumnType = ListToArray('S,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	800, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Tipo de n&oacute;mina inv&aacute;lido',
			'El Tipo de N&oacute;mina del empleado no coincide en el de su nombramiento, para la fecha de la n&oacute;mina',
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
	and not exists (	select 1
						from DatosEmpleado b, LineaTiempo j
						where b.Ecodigo = #Gvar.Ecodigo#
						  and b.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
						  and #Gvar.table_name#.CDRHHCCfdesde between j.LTdesde and j.LThasta
						  and j.DEid = b.DEid
						  and j.Ecodigo = b.Ecodigo
						  and rtrim(j.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
					)
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>	

<!--- Validación 900: Valida que los datos no hayan sido insertados anteriormente --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCCcarga, CDRHHCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S,S')>
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
	and Ecodigo = #Gvar.Ecodigo#
	and exists	( 	select 1 
					from HRCalculoNomina b,
						 HSalarioEmpleado c,
						 HPagosEmpleado d,
						 HCargasCalculo e,
						 DatosEmpleado f,
						 DCargas g
						 
					where b.Ecodigo = #Gvar.Ecodigo#
						and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
						and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
						and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
						
						and c.RCNid = b.RCNid
						
						and d.RCNid = c.RCNid
						and d.DEid = c.DEid
						and	d.DEid = f.DEid
						
						and e.RCNid = c.RCNid
						and e.DEid = c.DEid
						
						and f.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
						and	f.Ecodigo =  b.Ecodigo
						
						and g.DClinea = e.DClinea
						and rtrim(g.DCcodigo) = rtrim(#Gvar.table_name#.CDRHHCCcarga)
						and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
			)
</cfquery>

<!--- Validación 1000: Cargas Existen --->
<cfinvoke ErrorCode="1000" 
		  method="funcVIntegridad" 
		  ColumnName="CDRHHCCcarga" 
		  TableDest="DCargas" 
		  ColumnDest="DCcodigo" 
		  Filtro="Ecodigo = #Gvar.Ecodigo#"/>	

<!--- Validación 1100: Validar que la Suma de todas las Cargas del Empleado sean igual al Monto Indicado en HSalarioEmpleados --->
<cfset ArrColumnName = ListToArray('CDRHHCvaloremp')>
<cfset ArrColumnType = ListToArray('M')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	1100, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'La suma de las cargas del empleado no concuerda',
			'La suma de las cargas del empleado es disitinta que el monto de cargas de HSalarioEmpleado',
			<cf_dbfunction name="to_char" args="sum(#Gvar.table_name#.CDRHHCvaloremp)" datasource="#Gvar.Conexion#">

	from #Gvar.table_name#,
		HRCalculoNomina b, 
		HSalarioEmpleado c, 
		DatosEmpleado e

	where CDPcontrolv = 0
		and b.Ecodigo = #Gvar.Ecodigo#
		and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
		and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
		and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
		
		and c.RCNid = b.RCNid
		and c.DEid = e.DEid
		
		and e.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
		and e.Ecodigo = b.Ecodigo
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
	group by b.RCNid, c.DEid, c.SEcargasempleado
	having floor(c.SEcargasempleado) <> floor(sum(#Gvar.table_name#.CDRHHCvaloremp))
</cfquery>
	
<!--- Validación 1200: Validar que la Suma de todas las Cargas del Patrono sean igual al Monto Indicado en HSalarioEmpleados --->
<cfset ArrColumnName = ListToArray('CDRHHCvalorpat')>
<cfset ArrColumnType = ListToArray('M')>
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
			'La suma de las cargas del patrono no concuerda',
			'La suma de las cargas del patrono es disitinta que el monto de cargas de HSalarioEmpleado',
			<cf_dbfunction name="to_char" args="sum(#Gvar.table_name#.CDRHHCvalorpat)" datasource="#Gvar.Conexion#">

	from #Gvar.table_name#,
		HRCalculoNomina b, 
		HSalarioEmpleado c, 
		DatosEmpleado e

	where CDPcontrolv = 0
		
		and b.Ecodigo = #Gvar.Ecodigo#
		and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
		and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
		and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
		
		and c.RCNid = b.RCNid
		and c.DEid = e.DEid
		
		and e.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
		and e.Ecodigo = b.Ecodigo
		
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
	group by b.RCNid, c.DEid, c.SEcargaspatrono
	having floor(c.SEcargaspatrono) <> floor(sum(#Gvar.table_name#.CDRHHCvalorpat))
</cfquery>

<!--- Validación 1300: Todos los Registros Existen --->
<cfset ArrColumnName = ListToArray('CDRHHCCidentificacion, CDRHHCCfdesde, CDRHHCCfhasta, CDRHHCCcarga, CDRHHCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, 
								  ColumnName, 
								  ColumnType, 
								  Message, 
								  Details, 
								  ColumnValue )
	select 	1300, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Incompleta informaci&oacute;n a insertar',
			'Los datos de las columnas indicadas no existen en HRCalculoNomina\HSalarioEmpleado\DatosEmpleado\CIncidentes',
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
	and Ecodigo = #Gvar.Ecodigo#
	and not exists
			(	select 1 
				from
					HRCalculoNomina b, 
					DatosEmpleado c, 
					HSalarioEmpleado d, 
					DCargas e
				Where 	b.Ecodigo = #Gvar.Ecodigo#
				and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
				and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
				and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
				
				and c.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
				and c.Ecodigo = b.Ecodigo
				
				and d.RCNid = b.RCNid
				and d.DEid = c.DEid
				
				and rtrim(e.DCcodigo) = rtrim(#Gvar.table_name#.CDRHHCCcarga)
				and e.Ecodigo = b.Ecodigo
				and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
			)
</cfquery>