<!--- 
	******************************************
	* CARGA INICIAL DE OFICINAS
	* FECHA DE CREACIÓN:	29/03/2007
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
	insert into Oficinas (Ecodigo, Ocodigo, Oficodigo, Odescripcion)
    select 	#Gvar.Ecodigo#, 
			#Gvar.table_name#.CDRHHOcodigo,
			#Gvar.table_name#.CDRHHOficodigo,
			#Gvar.table_name#.CDRHHOdescripcion
    from  #Gvar.table_name#
	where  CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>
