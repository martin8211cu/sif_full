<!---
	Interfaz 302
	En este mensaje viajará los nuevos empleados y/o modificaciones de estos con algún cambio al nombre del mismo o al centro funcional asociado.
	Dirección de la Inforamción: Sistema Externo CONAVI - SIF
	Elaborado por: Jeffry Castro Bermúdez (jcastro@soin.co.cr)
	Fecha de Creación: 24/02/2010
--->
<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado, Detalles y Salida de Documento XXX de la BD Interfaces. --->

	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz302" datasource="sifinterfaces">
		select IE302.ID,  IE302.CANTIDAD_DOCUMENTOS, ID302.ID, ID302.FECHA_INICIO, ID302.IDENTIFICACION, ID302.NOMBRE, ID302.PRIMER_APELLIDO, ID302.SEGUNDO_APELLIDO, ID302.CENTRO_FUNCIONAL,ESTADO_CIVIL,GENERO,FECHA_NACIMIENTO,TELEFONO,CORREO_ELECTRONICO 
		from IE302 
		inner join  ID302
			on ID302.ID = IE302.ID	
		where IE302.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz302.recordcount eq 0>
		<cfthrow message="Error en Interfaz 302. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
	
	<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas de detalle--->
	<cfquery name="readCantED" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE,
		(select count(1) from ID302	as b where b.ID = a.ID) as cantidaD
		from IE302 as a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
		<cfthrow message="Error en Interfaz 302. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
	</cfif>	
	
	
	<!--- Verifica que los CF de las lineas existan--->
	<cf_dbdatabase table="CFuncional" datasource="minisif" returnvariable="tabCFuncional">
	<cfquery name="readExistCF" datasource="sifinterfaces">
		<!---select a.CFcodigo as centroF
		from #tabCFuncional# as a
		where a.CFcodigo in (select CENTRO_FUNCIONAL from ID302 as b where a.CFcodigo = b.CENTRO_FUNCIONAL and b.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">)--->
		select a.CENTRO_FUNCIONAL from ID302 as a
		where a.CENTRO_FUNCIONAL not in (select b.CFcodigo from #tabCFuncional# as b)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>

	<cfif readExistCF.recordCount NEQ 0>
	   	<cfthrow message="El Centro Funcional no existe">
	</cfif>	
	
	
	<!--- Verifica que los estados civiles de las lineas existan--->
	<cfquery name="rsEstadoCivil" datasource="sifinterfaces">	
		select a.ESTADO_CIVIL
		from ID302 as a  
		where a.ESTADO_CIVIL not in (0,1,2,3,4,5)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif rsEstadoCivil.recordCount NEQ 0>
	   	<cfthrow message="El estado civil no existe">
	</cfif>	
	
	<!--- Verifica que los estados civiles de las lineas existan--->
	<cfquery name="rsGenero" datasource="sifinterfaces">	
		select a.GENERO
		from ID302 as a  
		where a.GENERO not in ('F','M')
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif rsGenero.recordCount NEQ 0>
	   	<cfthrow message="El Genero no existe">
	</cfif>		
		
	<!--- Obtener Moneda Local
	
	<cfquery name="getMoneda" datasource="minisif">
		select Mcodigo
		from Empresas 
		where Ecodigo = #form.ecodigo#
	</cfquery>
	
	<cfset form.Mcodigo = #getMoneda.Mcodigo#>--->
	
		
	<!------>
	<!------>	
	<cf_dbtemp name="EmpIntefaz302_v2" returnvariable="EmpleImport" datasource="sifinterfaces">
			<cf_dbtempcol name="NTIcodigo"   	   type="varchar(1)"   mandatory="yes">
			<cf_dbtempcol name="DEidentificacion"  type="varchar(60)"  mandatory="yes">
			<cf_dbtempcol name="DEnombre"   	   type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="DEapellido1"   	   type="varchar(80)"  mandatory="no">
			<cf_dbtempcol name="DEapellido2"       type="varchar(80)"  mandatory="no">
			<cf_dbtempcol name="DEtelefono1"       type="varchar(30)"  mandatory="no">
			<cf_dbtempcol name="DEemail"  		   type="varchar(120)" mandatory="no">
			<cf_dbtempcol name="DEcivil"  		   type="integer"      mandatory="yes">
			<cf_dbtempcol name="DEfechanac"   	   type="datetime"     mandatory="yes">
			<cf_dbtempcol name="DEsexo"            type="varchar(1)"   mandatory="yes">
			<cf_dbtempcol name="CFcodigo"          type="varchar(10)"  mandatory="yes">
			<cf_dbtempcol name="marca"  		   type="integer"      mandatory="yes">
	</cf_dbtemp> 
		<!---1- Se Copia los empleados a tabla temporal 																		--->
	<!---2- Marca los Empleados existentes con marca=1 																--->
	<cfloop query="readInterfaz302"><!---itera sobre los detalles para insertar en la tabla tempo--->
		<cfquery datasource="sifinterfaces">			
				insert into #EmpleImport# (NTIcodigo,DEidentificacion,DEnombre, DEapellido1,
				DEapellido2, DEtelefono1, DEemail,DEcivil,DEfechanac,DEsexo,CFcodigo,marca)
				values('C',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.IDENTIFICACION#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.NOMBRE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.PRIMER_APELLIDO#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.SEGUNDO_APELLIDO#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.TELEFONO#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.CORREO_ELECTRONICO#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz302.ESTADO_CIVIL#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#readInterfaz302.FECHA_NACIMIENTO#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.GENERO#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz302.CENTRO_FUNCIONAL#">,
				0)
		</cfquery>
	</cfloop>
	<cf_dbdatabase table="DatosEmpleado" datasource="minisif" returnvariable="tabDatosEmpleado">
	<cfquery datasource="sifinterfaces"><!---Actualiza la marca si existe en DatosEmpleado pone 1--->
		  update #EmpleImport# 
		  set marca = 1  
		  where exists (select 1 from #tabDatosEmpleado# where DEidentificacion = #EmpleImport#.DEidentificacion)
	</cfquery>	
	<cfquery name="rsACEmpleadosCF"	datasource="sifinterfaces">
		select NTIcodigo,DEidentificacion, DEnombre,DEapellido1,DEapellido2, DEtelefono1, DEemail,DEcivil,DEfechanac,DEsexo,CFcodigo,marca from #EmpleImport#
	</cfquery>
		
	<!---Llama componente que se encarga de marcar cuales empleados son nuevos o son modificacion de datos, solo se le especifica la query con los empleados--->
	<!---<cftransaction>--->
		<cfinvoke component="sif.Componentes.CIM_EmpleadosCF" method="AltaCambioEmpleadoCF">			
			<cfinvokeargument name="consulta" 	value="#rsACEmpleadosCF#" >
			<!---<cfinvokeargument name="Ecodigo" 	value="#readEcodigoInterfaz302.Ecodigo#" >--->
		</cfinvoke>				
	<!---</cftransaction>--->			

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>