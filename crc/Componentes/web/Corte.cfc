<cfcomponent output="false" displayname="CRCCortes" 
    extends="crc.Componentes.CRCBase"
    hint="Componente para manejar cortes">
    
    <cffunction name="init" access="private" returntype="CRCCuenta"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(this.DSN, this.Ecodigo)>

		<cfreturn this>
	</cffunction>

    <cffunction name="obtenerUltimosCortesCerradosPorTipo" access="public" returntype="array">
        <cfargument name="tipo"  required="true"  type="string">
        <cfargument name="cantidad"  required="false"  type="numeric" default="3">

        <cfquery name="qUltimosCortesCerrados" datasource="#this.DSN#">
            select top(#arguments.cantidad#) fechainicio, fechafin, codigo from CRCCortes  
                where 
                    status >= 1
                    and Tipo = '#arguments.tipo#'
                    and Ecodigo = #this.Ecodigo#
                    order by FechaFin desc;
        </cfquery>

        <cfreturn this.db.queryToArray(qUltimosCortesCerrados)>
    </cffunction>
</cfcomponent>