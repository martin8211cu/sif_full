<!--- 
	******************************************
	* CARGA INICIAL DE OFICINAS
	* FECHA DE CREACIÓN:	29/03/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciónes
	* Este archivo debe contener todas 
	* las validaciones requeridas, previas
	* a la importación final del archivo.
	******************************************
--->

<!--- Consulta  max(Ocodigo) de la tabla de Oficinas para crear un consecutivo --->
<cfquery name="rsMaximo" datasource="#Gvar.Conexion#">
	select coalesce(max(Ocodigo),0) as Ocodigo
	from Oficinas
	where Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfset LvarUltimo = rsMaximo.Ocodigo>

<cfquery name="rsUpdate" datasource="#Gvar.Conexion#">
	update CDRHHOficinas
    set CDRHHOcodigo = #LvarUltimo# + (	select count(1)
                                     	from CDRHHOficinas x
                                   		where x.CDRHHOficodigo <= CDRHHOficinas.CDRHHOficodigo )
	Where #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#                                   		
</cfquery>

<!--- Validación 100: Validar que no existan campos repetidos (CDRHHOficinas) --->
<cfinvoke ErrorCode="100" method="funcVRepetidos" ColumnName="CDRHHOficodigo" Filtro="Ecodigo = #Gvar.Ecodigo#" ColumnType="S"/>

<!--- Validacion 200: Que los registros no hayan sido insertados (CDRHHOficinas vs Oficinas) --->
<cfinvoke ErrorCode="200" method="funcVRepetidos" ColumnName="CDRHHOficodigo" 
	TableDest="Oficinas" ColumnDest="Oficodigo" Filtro="Ecodigo = #Gvar.Ecodigo#"
	ColumnType="S"/>
	
<!--- Validacion 300: Que el código de oficina no exista (CDRHHOficinas vs Oficinas) --->
<cfinvoke ErrorCode="300" method="funcVRepetidos" ColumnName="CDRHHOcodigo" 
	TableDest="Oficinas" ColumnDest="Ocodigo" Filtro="Ecodigo = #Gvar.Ecodigo#"
	ColumnType="I"/>
	