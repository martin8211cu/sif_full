<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

	<cffunction name="getCargasEmpleado" access="public" returntype="query">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <cfquery name="rsCargasEmpleado" datasource="#session.DSN#">
        	select ce.DEid, ce.DClinea, ce.CEdesde, ce.CEhasta, ce.CEvalorpat, ce.CEvaloremp,
            	dc.DCcodigo, dc.DCmetodo, dc.DCdescripcion, dc.DCvaloremp, dc.DCvalorpat
            from CargasEmpleado ce
            	inner join DCargas dc
            	on dc.DClinea = ce.DClinea
			where ce.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and ce.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">
        </cfquery>
        <cfreturn rsCargasEmpleado>
    </cffunction>

	<cffunction name="vExiste" access="public" returntype="string">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        
        <cfquery name="vinsertCar" datasource="#session.DSN#">
        	select 1 from CargasEmpleado 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">
<!---               and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.CEdesde)#">
			      between CEdesde and coalesce(CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">) --->
        </cfquery>
        <cfreturn vinsertCar.recordcount GT 0>
    </cffunction>
    
    <cffunction name="vNuevo" access="public" returntype="string">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <cfquery name="vmovimientos" datasource="#session.DSN#">
        	select 1 from CargasCalculo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">
        </cfquery>
        <cfreturn vmovimientos.recordcount eq 0>
    </cffunction>
    
	<cffunction name="Alta" access="public" returntype="string">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <cfargument name="CEdesde" type="string" required="yes">
        <cfargument name="CEvalorpat" type="string" required="no" default="0.00">
        <cfargument name="CEvaloremp" type="string" required="no" default="0.00">
        
        <cfif vExiste(Arguments.DEid, Arguments.DClinea, Arguments.CEdesde)>
        	<cfthrow message="Error en Componente ACCargas. M&eacute;todo Alta. Existe una Carga para la misma fecha del mismo tipo para ese empleado. Proceso Cancelado!">
        </cfif>

        <cfquery name="InsertCarga" datasource="#session.DSN#">
			insert into CargasEmpleado ( DEid, DClinea, CEdesde, CEhasta, CEvalorpat, CEvaloremp  )
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Arguments.CEdesde)#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.CEvalorpat#" null="#Arguments.CEvalorpat EQ 0.00#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.CEvaloremp#" null="#Arguments.CEvaloremp EQ 0.00#">
			)
		</cfquery>
    </cffunction>
    
	<cffunction name="Cambio" access="public">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">
        <cfargument name="CEdesde" type="string" required="yes">

<!---         <cfif not vNuevo(Arguments.DEid,Arguments.DClinea)>
        	<cfthrow message="Error en Componente ACCargas. M&eacute;todo Cambio. La Carga tiene movimientos, ya no puede ser modificada. Proceso Cancelado!">
        </cfif>
 ---> 
        <cfquery name="UpdateCarga" datasource="#session.DSN#">
			update CargasEmpleado set
				CEdesde	= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Arguments.CEdesde)#">,
				CEhasta	= null
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">
		</cfquery>
	</cffunction>

	<cffunction name="Baja" access="public">
    	<cfargument name="DEid" type="string" required="yes">
        <cfargument name="DClinea" type="string" required="yes">

        <cfif not vNuevo(Arguments.DEid,Arguments.DClinea)>
        	<cfthrow message="Error en Componente ACCargas. M&eacute;todo Baja. La Carga tiene movimientos, ya no puede ser eliminada. Proceso Cancelado!">
        </cfif>

        <cfquery name="DeleteCarga" datasource="#session.DSN#">
			delete from CargasEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#">
		</cfquery>
    </cffunction>
</cfcomponent>