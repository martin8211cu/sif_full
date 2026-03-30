<!--- 
******************************************
CARGA INICIAL DE DEDUCCIONESCALCULO
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
<cfsetting requesttimeout="7200">

<cf_dbfunction name="OP_concat" returnvariable="CAT" > 

<!--- Validacion 100: Validar que no existan campos repetidos --->
<cfinvoke ErrorCode		= "100" 
		  method		= "funcVRepetidos" 
		  ColumnName	= "CDRHHDCidentificacion, CDRHHDCfdesde, CDRHHDCfhasta, CDRHHDCdeduccion, CDRHHDCsocio, CDRHHDCnomina" 
		  ColumnType	= "S,D,D,S,S,S"/>

<!--- Validacion 200: Validar que se hayan cargado HRCalculoNomina --->
<cfinvoke ErrorCode		= "200" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDCnomina, CDRHHDCfdesde, CDRHHDCfhasta" 
		  ColumnType	= "S,D,D" 
		  TableDest		= "HRCalculoNomina" 
		  ColumnDest	= "Tcodigo, RCdesde, RChasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe HRCalculoNomina"/>

<cfquery datasource="#Gvar.Conexion#">
	update #Gvar.table_name#
    SET CDRHHDCRCNid = (
    	SELECT min(RCNid)
        FROM HRCalculoNomina
        WHERE Ecodigo = #Gvar.Ecodigo#
		  AND Tcodigo = #Gvar.table_name#.CDRHHDCnomina
          AND RCdesde = #Gvar.table_name#.CDRHHDCfdesde
		  AND RChasta = #Gvar.table_name#.CDRHHDCfhasta
    )
</cfquery>

<!--- Validacion 300: Validar que se haya cargado  HSalarioEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde, CDRHHDCfhasta, CDRHHDCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo )
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
			,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
				Where b.RCNid = #Gvar.table_name#.CDRHHDCRCNid
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and ltrim(rtrim(d.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
				  and d.Ecodigo = b.Ecodigo
			)
	and Ecodigo = #Gvar.Ecodigo#		
</cfquery>

<!--- Validacion 400: Validar que se haya cargado  HPagosEmpleado --->
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde, CDRHHDCfhasta, CDRHHDCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue,Ecodigo )
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
			,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(	Select 1 
				from  HRCalculoNomina b
					, HSalarioEmpleado c
					, DatosEmpleado d
					, HPagosEmpleado e
				Where b.RCNid = #Gvar.table_name#.CDRHHDCRCNid
				  and c.RCNid = b.RCNid
				  and d.DEid = c.DEid
				  and ltrim(rtrim(d.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
				  and d.Ecodigo = b.Ecodigo
				  and e.RCNid = c.RCNid
				  and e.DEid = c.DEid
			)
	and Ecodigo = #Gvar.Ecodigo#			
</cfquery>

<!--- Validacion 500: La Cedula del Empleado exista (DatosEmpleado) --->
<cfinvoke ErrorCode="500" method="funcVIntegridad" ColumnName="CDRHHDCidentificacion" 
			TableDest="DatosEmpleado" ColumnDest="DEidentificacion" Filtro="Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 600: Que las fechas del Historico coincidan con el Calendario Pagos (CalendarioPagos) --->
<cfinvoke ErrorCode		= "600" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDCnomina, CDRHHDCfdesde, CDRHHDCfhasta" 
		  ColumnType	= "S,D,D"
		  TableDest		= "CalendarioPagos" 
		  ColumnDest	= "Tcodigo, CPdesde, CPhasta" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"
		  Message		= "No existe el Calendario de Pagos"/>

<!--- Validacion 700: Verifica que la persona este nombrada --->
<!--- Comentado porque es necesario subir histórico de empleados inactivos
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue,Ecodigo )
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
			,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists ( select 1
					 from DatosEmpleado b
						inner join LineaTiempo j
							on j.DEid = b.DEid
							and j.Ecodigo = b.Ecodigo
					 where b.Ecodigo = #Gvar.Ecodigo#
						and ltrim(rtrim(b.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
						and j.LTdesde <= #Gvar.table_name#.CDRHHDCfhasta
						and j.LThasta >= #Gvar.table_name#.CDRHHDCfdesde
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>
--->

<!--- Validacion 800: Verifica que la nomina de carga es igual a la linea del tiempo 
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde, CDRHHDCnomina')>
<cfset ArrColumnType = ListToArray('S,D,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo )
	select 	800, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
	'Tipo de n&oacute;mina inv&aacute;lido','El Tipo de N&oacute;mina del empleado no coincide en el de su nombramiento, para la fecha de la n&oacute;mina',
	<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
			case when  #ArrColumnName[i]# is not null then 
				<cfif trim(ArrColumnType[i]) EQ 'D'>
					<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
				<cfelse>
					<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
				</cfif> else 'NULL' end #CAT# ','  #CAT# 
	</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">  </cfloop>
	,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(select 1
			from DatosEmpleado b, LineaTiempo j
			where b.Ecodigo = #Gvar.Ecodigo#
			and ltrim(rtrim(b.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
			and #Gvar.table_name#.CDRHHDCfdesde between j.LTdesde and j.LThasta
			and j.DEid = b.DEid
			and j.Ecodigo = b.Ecodigo
			and ltrim(rtrim(j.Tcodigo)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCnomina))
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>--->
<!---
<!--- Validacion 900: Valida que los datos no hayan sido insertados anteriormente --->
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde, CDRHHDCfhasta, CDRHHDCdeduccion, CDRHHDCnomina')>
<cfset ArrColumnType = ListToArray('S,D,D,S,S')>
<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue,Ecodigo )
	select 	900, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Ya existe la informaci&oacute;n en la tabla HDeduccionesCalculo',
			'Los datos de las columnas indicadas ya existen en la tabla destino',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT# 
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">  </cfloop>
			,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and exists
			(
			Select 1 
			from HRCalculoNomina b,
			     HSalarioEmpleado c,
   			     HPagosEmpleado d,
   			     HDeduccionesCalculo e,
   			     DeduccionesEmpleado f,
   			     TDeduccion g,
  			     DatosEmpleado h
				Where b.RCNid = #Gvar.table_name#.CDRHHDCRCNid
				
				and c.RCNid = b.RCNid
				
				and d.RCNid = c.RCNid
				and d.DEid = c.DEid
				and	d.DEid = h.DEid
				
				and e.RCNid = c.RCNid
				and e.DEid = c.DEid
				
				and f.Did = e.Did
				
				and g.TDid = f.TDid
				and ltrim(rtrim(g.TDcodigo)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCdeduccion))
				and g.Ecodigo = b.Ecodigo
				
				and ltrim(rtrim(h.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
				and	h.Ecodigo =  b.Ecodigo
			)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>
--->

<!--- Validacion 1000: Deducciones Existen --->
<cfinvoke ErrorCode		= "1000" 
		  method		= "funcVIntegridad" 
		  ColumnName	= "CDRHHDCdeduccion" 
		  ColumnType 	= "S"
		  TableDest		= "TDeduccion" 
		  ColumnDest	= "TDcodigo" 
		  Filtro		= "Ecodigo = #Gvar.Ecodigo#"/>

<!--- Validacion 1100: Validar que la Suma de todas las Deducciones sean igual al Monto Indicado en HSalarioEmpleados --->
<cfset ArrColumnName = ListToArray('CDRHHDCnomina, CDRHHDCfdesde, CDRHHDCfhasta, CDRHHDCidentificacion')>
<cfset ArrColumnType = ListToArray('S,D,D,S,M,M')>

<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo )
    select 	1100, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'La suma de las deducciones no concuerda','La misma debe se igual a SEdeducciones en HSalarioEmpleado',
        
                <cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
                        case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
                            <cfif trim(ArrColumnType[i]) EQ 'D'>
                                <cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
                            <cfelse>
                                <cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
                            </cfif> else 'NULL' end #CAT# ','  #CAT# 
                </cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i"> </cfloop> #CAT#                          
                <cf_dbfunction name="to_char" args="c.SEdeducciones" datasource="#Gvar.Conexion#">  #CAT# ','  #CAT#   					
                <cf_dbfunction name="to_char" args="sum(#Gvar.table_name#.CDRHHDCvalor)" datasource="#Gvar.Conexion#">,  
				#Gvar.Ecodigo#
    from #Gvar.table_name#,
		HRCalculoNomina b, 
		HSalarioEmpleado c, 
		DatosEmpleado e
	
    Where CDPcontrolv = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
		and b.RCNid = #Gvar.table_name#.CDRHHDCRCNid
		
		and c.RCNid = b.RCNid
		and c.DEid = e.DEid
		
		and ltrim(rtrim(e.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
		and e.Ecodigo = b.Ecodigo
		
	group by #Gvar.table_name#.CDRHHDCnomina, 
        #Gvar.table_name#.CDRHHDCfdesde, 
        #Gvar.table_name#.CDRHHDCfhasta, 
        #Gvar.table_name#.CDRHHDCidentificacion, 
        c.SEdeducciones
	
    having floor(c.SEdeducciones) <> floor(sum(#Gvar.table_name#.CDRHHDCvalor))
</cfquery>


<!--- Validacion 1200: Todos los Registros Existen --->
<cfset ArrColumnName = ListToArray('CDRHHDCidentificacion, CDRHHDCfdesde')>
<cfset ArrColumnType = ListToArray('S,D')>

<cfquery datasource="#Gvar.Conexion#">
	insert into #err_table_name#( ErrorCode, ColumnName, ColumnType, Message, Details, ColumnValue, Ecodigo )
	select 	1200, 
			'#ArrayToList(ArrColumnName)#', 
			'#ArrayToList(ArrColumnType)#', 
			'Incompleta informaci&oacute;n a insertar',
			'Los datos de las columnas indicadas no existen en HRCalculoNomina\DatosEmpleado\HSalarioEmpleado\TDeduccion\DeduccionesEmpleado',
			<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">
					case when  {fn LENGTH(#ArrColumnName[i]#)} > 0 then 
						<cfif trim(ArrColumnType[i]) EQ 'D'>
							<cf_dbfunction name="date_format" args="#ArrColumnName[i]#,DD/MM/YY" datasource="#Gvar.Conexion#">
						<cfelse>
							<cf_dbfunction name="to_char" args="#ArrColumnName[i]#" datasource="#Gvar.Conexion#">
						</cfif> else 'NULL' end #CAT# ','  #CAT# 
			</cfloop>''<cfloop From="1" To="#ArrayLen(ArrColumnName)#" index="i">  </cfloop>
			,#Gvar.Ecodigo#
	from #Gvar.table_name#
	where CDPcontrolv = 0
	and not exists
			(	select 1 
			from
		 	 	HRCalculoNomina b, 
		 	 	DatosEmpleado c, 
		 	 	HSalarioEmpleado d, 
		 	 	TDeduccion e,
		 	 	DeduccionesEmpleado f
			Where b.RCNid = #Gvar.table_name#.CDRHHDCRCNid
			
			and ltrim(rtrim(c.DEidentificacion)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCidentificacion))
			and c.Ecodigo = b.Ecodigo
			
			and d.RCNid = b.RCNid
			and d.DEid = c.DEid
			
			and ltrim(rtrim(e.TDcodigo)) = ltrim(rtrim(#Gvar.table_name#.CDRHHDCdeduccion))
			and e.Ecodigo = b.Ecodigo
			
			and f.TDid = e.TDid
			and f.DEid = c.DEid)
	and Ecodigo = #Gvar.Ecodigo#
</cfquery>
