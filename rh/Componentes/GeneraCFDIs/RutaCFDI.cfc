<!---
Componente desarrollado para Obtener la ruta de Guardado de los Documentos Timbrados
Desarrollado por:  Arath Gonzalez 
Fecha : 2022-06-16
--->
<cfcomponent>
        <!---Obtiene la ruta de guardado de los documentos timbrados--->
        <cffunction name="getRuta" access="public" returntype="string" hint="Función para obtener la ruta donde se van a almacenar los documentos timbrados"> 
            <cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">
            <cfargument name="Pcodigo" type="numeric" required="true">
            <cfargument name="Conexion" type="string" required="false" default="#session.dsn#">


            <cfquery name="rsObtenerRuta" datasource="#Arguments.Conexion#">
                select Pcodigo,Mcodigo,Pdescripcion,Pvalor 
                from Parametros 
                where Mcodigo ='FA' 
                and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>

            <cfif len(trim(rsObtenerRuta.Pvalor))  lte 3>
                <cfset ruta = "C:/Enviar">
            <cfelse>
               <cfset ruta = "#rsObtenerRuta.Pvalor#">
            </cfif>    
            <cfreturn ruta>
        </cffunction>
</cfcomponent>