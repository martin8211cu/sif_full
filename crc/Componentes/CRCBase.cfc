<cfcomponent output="false" displayname="CRCBase" hint="Componente base para Credito">
    <cfset this.DSN = "">
    <cfset this.Ecodigo = "">
    <cfset this.db = createObject("component","home.Componentes.datamgr.DataMgr")>

    <cfset logStack = "">

    <cffunction name="init" access="public" output="no" returntype="CRCBase" hint="constructor del componente con parametros de entradas primarios">  
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >
 
		<cfset this.DSN 	= arguments.DSN>
		<cfset this.Ecodigo = arguments.Ecodigo>
        <cfset this.db.init(this.DSN, "MSSQL")>

		<cfreturn this>

	</cffunction>

    <cffunction name="log" access="public" returntype="void" output="no" hint="Registra un log en el archivo de logs del servidor">
    	<cfargument name="texto" type="string" required="true">
		<cfargument name="tipo" type="string" required="false" default="Information">
        <cfargument name="logFile" type="string" required="false" default="CRC_LOG">

    	<cflog file="#arguments.logFile#" application="no" text="#arguments.texto#" type="#arguments.tipo#">
		<cfset logStack = '#logStack# #arguments.texto# <br>'>
    </cffunction>
</cfcomponent>