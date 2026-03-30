<!--- 
	******************************************
	* CARGA INICIAL DE CARGASCALCULO
	* FECHA DE CREACIÓN:	26/03/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de validaciónes
	* Este archivo debe contener todas 
	* las validaciones requeridas, previas
	* a la importación final del archivo.
	******************************************
--->
<cfquery datasource="#Gvar.Conexion#">
	insert into HCargasCalculo(
		DClinea, 
		RCNid, 
		DEid, 
		CCvaloremp, 
		CCvalorpat, 
		CCvalorempant, 
		CCvalorpatant)
		
	select 	e.DClinea, 
			b.RCNid, 
			c.DEid, 
			#Gvar.table_name#.CDRHHCvaloremp,
			#Gvar.table_name#.CDRHHCvalorpat,
			#Gvar.table_name#.CDRHHCvaloremp,
			#Gvar.table_name#.CDRHHCvalorpat 
	
	from #Gvar.table_name#
		inner join HRCalculoNomina b
		on b.Ecodigo = #Gvar.Ecodigo#
		and b.RCdesde = #Gvar.table_name#.CDRHHCCfdesde
		and b.RChasta = #Gvar.table_name#.CDRHHCCfhasta
		and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHCnomina)
			
		inner join DatosEmpleado c
		on c.DEidentificacion = #Gvar.table_name#.CDRHHCCidentificacion
		and c.Ecodigo = b.Ecodigo
			
		inner join DCargas e
		on rtrim(e.DCcodigo) = rtrim(#Gvar.table_name#.CDRHHCCcarga)
		and e.Ecodigo = b.Ecodigo
		
	where  CDPcontrolv = 1
	and CDPcontrolg = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>
