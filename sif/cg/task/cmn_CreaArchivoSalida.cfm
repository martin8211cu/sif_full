<cffunction name="fnGeneraSalidaArchivo" access="private" output="no">
	<cfargument name="LLAVE" type="numeric" default="-1">
	<cfargument name="USER"  type="string" default="-1">
	<cfargument name="MostrarSalida" type="boolean" default="false">
	<cfargument name="conexion" type="string" required="yes">
	<cfargument name="ProcesarForzado" type="boolean" required="no" default="false">

	<cfsetting requesttimeout="1800">	
	<cfinvoke 
		component="cmn_CreaArchivoSalida" 
		method="fnGeneraSalidaArchivo" 
		returnvariable="Procesado">
		<cfinvokeargument name="LLAVE" value="#LLAVE#">
		<cfinvokeargument name="USER"  value="#USER#">
		<cfinvokeargument name="MostrarSalida" value="false">
		<cfinvokeargument name="conexion" value="#dsn#">
		<cfinvokeargument name="ProcesarForzado" value="#forzar#">
	</cfinvoke>
</cffunction>
