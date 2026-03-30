<!--- PASO 1 --->
<!--- Carga el archivo desde el cliente al servidor --->
<cfoutput>
 <cffile   action = "upload" 
	fileField = "ARCHIVO" 
	destination = "#GetTempDirectory()#" 
	nameConflict = "overwrite">
</cfoutput>
<cfset uploadedFilename=#cffile.serverDirectory# & "/" & #cffile.serverFile#>
<!--- PASO 2 --->
<!--- carga el archivo importado y lo graba en una variable llamada Contenido --->
<cffile 	action = "read" 	
	file = "#uploadedFilename#"	
	variable = "Contenido">
<!--- PASO 3 --->
<!--- Recorre el archivo linea por linea para procesarlo --->
<cfset action = "ROLLBACK">   
<cftransaction action="begin">
<!--- PASO 4 --->
<!--- Separacion por filas --->
	<cfloop  list="#Contenido#"  delimiters="#chr(13)#" index="registro">
		<!--- PASO 5 --->
		<!--- Separacion por columnas --->
		<cfloop  list="#registro#"  delimiters="," index="columna">
			<!--- PASO 6 --->
			<!--- Validacion de campos --->
			
			<!--- PASO 7 --->
			<!--- Insertar registros --->		
				
		</cfloop>
	</cfloop>
	<!--- PASO X --->
	<!--- Valida el estado de la transaccion--->
	<cfset action = "COMMIT">
	<cftransaction action = "#action#"/>   
</cftransaction>	
	