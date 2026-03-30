<cfcomponent>
	<cffunction name="datos_fijos" access="public" returntype="query" output="false">
		
		<cfset var myQuery = QueryNew('codigo,nombre,columna,tipo_dato')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','IDN')>
		<cfset QuerySetCell(myQuery, 'nombre','Número de Identificación')>
		<cfset QuerySetCell(myQuery, 'columna','identificacion_persona')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','NOM')>
		<cfset QuerySetCell(myQuery, 'nombre','Nombre')>
		<cfset QuerySetCell(myQuery, 'columna','nombre')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','AP1')>
		<cfset QuerySetCell(myQuery, 'nombre','Apellido 1')>
		<cfset QuerySetCell(myQuery, 'columna','apellido1')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','AP2')>
		<cfset QuerySetCell(myQuery, 'nombre','Apellido 2')>
		<cfset QuerySetCell(myQuery, 'columna','apellido2')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','TEL')>
		<cfset QuerySetCell(myQuery, 'nombre','Número de teléfono')>
		<cfset QuerySetCell(myQuery, 'columna','casa')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','CEL')>
		<cfset QuerySetCell(myQuery, 'nombre','Número de celular')>
		<cfset QuerySetCell(myQuery, 'columna','celular')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>

		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','FAX')>
		<cfset QuerySetCell(myQuery, 'nombre','Número de fax')>	
		<cfset QuerySetCell(myQuery, 'columna','fax')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','EML')>
		<cfset QuerySetCell(myQuery, 'nombre','Correo electrónico')>
		<cfset QuerySetCell(myQuery, 'columna','email1')>	
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','NAC')>
		<cfset QuerySetCell(myQuery, 'nombre','Fecha de nacimiento')>	
		<cfset QuerySetCell(myQuery, 'columna','nacimiento')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'F')>
		
		<cfset QueryAddRow(myQuery)>
		<cfset QuerySetCell(myQuery, 'codigo','SEX')>
		<cfset QuerySetCell(myQuery, 'nombre','Sexo')>
		<cfset QuerySetCell(myQuery, 'columna','sexo')>
		<cfset QuerySetCell(myQuery, 'tipo_dato', 'S')>
		
		<cfreturn myQuery>
	</cffunction>
</cfcomponent>