<!--- 
	******************************************
	* CARGA INICIAL DE DEPARTAMENTOS
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de generaración final
	* Este archivo requiere es para
	* realizar la copia final de la
	* atabla temporal a la tabla real.
	******************************************
--->

<cfquery datasource="#Gvar.Conexion#">
	insert into Departamentos (Ecodigo, Dcodigo, Deptocodigo, Ddescripcion)
    select 	#Gvar.Ecodigo#, 
			#Gvar.table_name#.CDRHHDcodigo, 
			#Gvar.table_name#.CDRHHDptoCodigo, 
			#Gvar.table_name#.CDRHHDdescripcion
    from  #Gvar.table_name#
	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and Ecodigo = #Gvar.Ecodigo#
</cfquery>
