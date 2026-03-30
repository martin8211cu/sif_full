<!---
Componente desarrollado para Obtener la ruta de Guardado de los Documentos Timbrados
Desarrollado por:  Arath Gonzalez 
Fecha : 2022-06-21
--->
<cfcomponent>
        <!---Obtiene la zona horaria para timbrado de archivos--->
        <cffunction name="getZona" access="public" returntype="string" hint="Función para obtener la ruta donde se van a almacenar los documentos timbrados"> 
            <cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">
            <cfargument name="Conexion" type="string" required="false" default="#session.dsn#">

            <cfquery name="rsObtenerZona" datasource="#Arguments.Conexion#"><!--- 17500 --->
                select Pcodigo,Mcodigo,Pdescripcion,Pvalor 
                from Parametros 
                where Mcodigo ='FA' 
                and Pcodigo = 17500
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
               
            <cfreturn rsObtenerZona.Pvalor>
        </cffunction>

        <!---Obtiene el valor de Horario Verano--->
        <cffunction name="getHVerano" access="public" returntype="string" hint="Función para obtener la ruta donde se van a almacenar los documentos timbrados"> 
            <cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">
            <cfargument name="Conexion" type="string" required="false" default="#session.dsn#">

            <cfquery name="rsHorarioVerano" datasource="#Arguments.Conexion#"> <!--- 17600 --->
                select Pcodigo,Mcodigo,Pdescripcion,Pvalor 
                from Parametros 
                where Mcodigo ='FA' 
                and Pcodigo = 17600
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
                
            <cfreturn rsHorarioVerano.Pvalor>
        </cffunction>

        <cffunction name="DiferenciaHorasTimbrado" access="public" returntype="numeric" hint="Función que regresa la diferencia de horas para timbrar Factura"> 
            <cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">
            <cfargument name="Conexion" type="string" required="false" default="#session.dsn#">
            <cfargument name="valor" type="numeric" required="false" default="0">

            <cfset var offsetEmpresa = This.getZona(Ecodigo,Conexion)>
            <cfset var horarioVerano = this.getHVerano(Ecodigo,Conexion)>

            <!--- Si No tiene valor de Zona horaria tomara la zona del servidor actual --->
            <cfif offsetEmpresa eq "" and horarioVerano EQ "">
                <cfreturn Arguments.valor>
            </cfif>

            <cfquery name="rsOffsetServidor" datasource="#Arguments.Conexion#">
                SELECT 
                    FORMAT(SYSDATETIMEOFFSET(), 'zz') AS 'zz'
            </cfquery>

            <cfset var offsetServer = rsOffsetServidor.zz>

            <cfif horarioVerano neq ''>
                <cfset offsetEmpresa = offsetEmpresa+horarioVerano>
            </cfif>

            <cfset var Diferencia = offsetEmpresa-offsetServer>

            <cfreturn Diferencia>            

        </cffunction>
</cfcomponent>