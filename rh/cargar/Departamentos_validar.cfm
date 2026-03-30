<!--- 
	******************************************
	* CARGA INICIAL DE DEPARTAMENTOS
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciones
	* Este archivo debe contener todas 
	* las validaciones requeridas, previas
	* a la importacion final del archivo.
	******************************************
--->

<!--- Consulta  max(Dcodigo) de la tabla de Departamentos para crear un consecutivo --->
<cfquery name="rsMaximo" datasource="#Gvar.Conexion#">
	select coalesce(max(Dcodigo),0) as Dcodigo
	from Departamentos
	where Ecodigo = #Gvar.Ecodigo#
</cfquery>
<cfset LvarUltimo = rsMaximo.Dcodigo>

<cfquery name="rsUpdate" datasource="#Gvar.Conexion#">
	update CDRHHDepartamentos
    set CDRHHDcodigo = #LvarUltimo# + (	select count(1)
                                     	from CDRHHDepartamentos x
                                   		where x.CDRHHDptoCodigo <= CDRHHDepartamentos.CDRHHDptoCodigo )
	Where Ecodigo = #Gvar.Ecodigo#                                   		
</cfquery>

<!--- Validación 100: Validar que no existan campos repetidos (CDRHHDepartamentos) --->
<cfinvoke ErrorCode	 = "100" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHDptoCodigo" 
		  ColumnType = "S"/>

<!--- Validacion 200: Que los registros no hayan sido insertados (Departamentos) --->
<cfinvoke ErrorCode	 = "200" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHDptoCodigo" 
		  TableDest	 = "Departamentos" 
		  ColumnDest = "Deptocodigo" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"
		  ColumnType = "S"/>
		
<!--- Validacion 300: Que el código de departamento no exista (Departamentos) --->
<cfinvoke ErrorCode	 = "300" 
		  method	 = "funcVRepetidos" 
		  ColumnName = "CDRHHDcodigo" 
		  TableDest	 = "Departamentos" 
		  ColumnDest = "Dcodigo" 
		  Filtro	 = "Ecodigo = #Gvar.Ecodigo#"
		  ColumnType = "I"/>