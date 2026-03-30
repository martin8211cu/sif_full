<cfcomponent>
<cffunction name="Sincronizo" access="public" >
 	<cfargument name="conexion"   		type="string"  	required="yes" 	hint="Nombre del DataSource">
    <cfargument name="Periodoinicio"  	type="numeric" 	required="yes" 	hint="Año Inicio del periodo">
    <cfargument name="Periodofin" 		type="numeric" 	required="yes" 	hint="Año Fin del periodo">   
   	<cfargument name="CAAgrupado" 	  	type="string" 	required="yes" 	hint="Agrupador de datos">
    
  	<cfinvoke method="SincronizoEliminando">  
		<cfinvokeargument name="Periodoinicio" 	value="#Arguments.Periodoinicio#">
        <cfinvokeargument name="Periodofin" 	value="#Arguments.Periodofin#">
		<cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
        <cfinvokeargument name="CAAgrupado" 	value="#Arguments.CAAgrupado#">
    </cfinvoke>
    <cfinvoke  method="SincronizoInsertando"> 
		<cfinvokeargument name="Periodoinicio" 	value="#Arguments.Periodoinicio#">
        <cfinvokeargument name="Periodofin" 	value="#Arguments.Periodofin#">
        <cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
        <cfinvokeargument name="CAAgrupado" 	value="#Arguments.CAAgrupado#">
    </cfinvoke> 
</cffunction>
   
<!---RECORRO TABLA RHFeriados BUSCO QUE CONTENGA EL PERIODO Y ELIMINO--->
<cffunction name="SincronizoEliminando" access="private">
	 <cfargument name="conexion"   		type="string"  	required="yes" 	hint="Nombre del DataSource">
     <cfargument name="Periodoinicio"  	type="numeric" 	required="yes" 	hint="Año Inicio del periodo">
     <cfargument name="Periodofin" 		type="numeric" 	required="yes" 	hint="Año Fin del periodo">   
        <cfquery name="rsSQL" datasource="#session.dsn#">     
            SELECT RHFid
            FROM RHFeriados
            WHERE 	<cf_dbfunction name="date_part"	args="YYYY, RHFfecha" datasource="#Arguments.conexion#" returnvariable="date" > #date# = #Arguments.Periodoinicio# OR
             		<cf_dbfunction name="date_part"	args="YYYY, RHFfecha" datasource="#Arguments.conexion#" returnvariable="dateF" > #dateF# = #Arguments.Periodofin#
     	</cfquery>
    <cfloop query="rsSQL">
        <cfquery datasource="#session.dsn#">     
                 DELETE FROM RHDFeriados
                 WHERE RHFid       = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSQL.RHFid#">
       	</cfquery>
        <cfquery datasource="#Arguments.conexion#">     
            DELETE FROM RHFeriados
            	WHERE RHFid       = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSQL.RHFid#">
        </cfquery>
	</cfloop>
</cffunction> 
<!---RECORRO TABLA RHFeriados INSERTO--->
<cffunction name="SincronizoInsertando" access="private">
	<cfargument name="conexion"   		type="string"  	required="yes" 	hint="Nombre del DataSource">
    <cfargument name="Periodoinicio"  	type="numeric" 	required="yes" 	hint="Año Inicio del periodo">
    <cfargument name="Periodofin" 		type="numeric" 	required="yes" 	hint="Año Fin del periodo">  
    <cfargument name="Usucodigo"  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
	<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
    <cfargument name="CAAgrupado" 	  	type="string" 	required="yes" 	hint="Agrupador de datos">
 		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
            <cfset Arguments.conexion = session.DSN>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
    <cfinvoke  method="GetAgendaSincronizacionPrimerPeriodo" returnvariable="rsSQL">  
    	<cfinvokeargument name="Periodoinicio" 	value="#Arguments.Periodoinicio#">
        <cfinvokeargument name="Periodofin" 	value="#Arguments.Periodofin#">
        <cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
        <cfinvokeargument name="CAAgrupado" 	value="#Arguments.CAAgrupado#">
    </cfinvoke>
    
    <cfloop query="rsSQL">  
		<cfset years= DateFormat(rsSQL.CAFechaIni,"YYYY")>
        <cfif #years# neq #Arguments.Periodoinicio#>
            <cfset dia= DateFormat(rsSQL.CAFechaIni,"DD")>
            <cfset mm= DateFormat(rsSQL.CAFechaIni,"MM")>
             <cfset dia= DateFormat(rsSQL.CAFechaIni,"DD")>
             <cfset variable = #Arguments.Periodoinicio#&"-"&#mm#&"-"&#dia#>
             <cfset nfecha = LsparseDateTime(variable)>
        <cfelse>
            <cfset nfecha = #rsSQL.CAFechaIni#>
        </cfif>
             <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
             INSERT INTO RHFeriados (
                       Ecodigo,
                       RHFfecha,
                       RHFdescripcion,
                       RHFregional,
                       RHFpagooblig,
                       BMUsucodigo
                )
                VALUES(
                       #Arguments.Ecodigo#,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#nfecha#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#rsSQL.CADescripcion#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="0">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0"   voidNull>,
                       #Arguments.Usucodigo#
                )     <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
            </cfquery> 
                <cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIdentity">
    </cfloop>
    
       <cfinvoke  method="GetAgendaSincronizacionSegundoPeriodo" returnvariable="rsSQL2">  
    	<cfinvokeargument name="Periodoinicio" 	value="#Arguments.Periodoinicio#">
        <cfinvokeargument name="Periodofin" 	value="#Arguments.Periodofin#">
        <cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
        <cfinvokeargument name="CAAgrupado" 	value="#Arguments.CAAgrupado#">
    </cfinvoke>
    
    <cfloop query="rsSQL2">  
    	<cfset years= DateFormat(rsSQL2.CAFechaIni,"YYYY")>
		<cfif #years# neq #Arguments.Periodofin#>
            <cfset dia= DateFormat(rsSQL2.CAFechaIni,"DD")>
            <cfset mm= DateFormat(rsSQL2.CAFechaIni,"MM")>
             <cfset dia= DateFormat(rsSQL2.CAFechaIni,"DD")>
             <cfset variable = #Arguments.Periodofin#&"-"&#mm#&"-"&#dia#>
             <cfset nfecha = LsparseDateTime(variable)>
        <cfelse>
            <cfset nfecha = #rsSQL.CAFechaIni#>
        </cfif>
             <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
             INSERT INTO RHFeriados (
                       Ecodigo,
                       RHFfecha,
                       RHFdescripcion,
                       RHFregional,
                       RHFpagooblig,
                       BMUsucodigo
                )
                VALUES(
                       #Arguments.Ecodigo#,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#nfecha#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#rsSQL2.CADescripcion#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="0">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="0"   voidNull>,
                       #Arguments.Usucodigo#
                )     <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
            </cfquery> 
                <cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIdentity">
    </cfloop>
</cffunction>  
<!---Obtener Primer Periodo Datos para la Sincronizacion--->
<cffunction name="GetAgendaSincronizacionPrimerPeriodo" access="public" returntype="query">
        <cfargument name="CAAgrupado" 		type="string" 	required="yes" 	hint="Agrupador de datos">
        <cfargument name="conexion"   		type="string"  	required="yes" 	hint="Nombre del DataSource">
        <cfargument name="Periodoinicio"  	type="numeric" 	required="yes" 	hint="Año Inicio del periodo">
     	<cfargument name="Periodofin" 		type="numeric" 	required="yes" 	hint="Año Fin del periodo">  
			<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
                <cfset Arguments.conexion = session.dsn>
            </cfif>
    <cfquery name="rsSQL" datasource="#Arguments.conexion#">
        SELECT CAAid,
               Ecodigo,
               CADescripcion,
               CAAgrupador,
               CAFechaIni,
               CAFechaFin,
               CARepite,
               BMUsucodigo,
               BMfecha,
               ts_rversion
          FROM Agenda
         WHERE CAAgrupador  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#CAAgrupado#"> AND
         	   <cf_dbfunction name="date_part"	args="YYYY, CAFechaIni" returnvariable="dateI" > #dateI# <= #Arguments.Periodoinicio# AND
               <cf_dbfunction name="date_part"	args="YYYY, CAFechaFin" returnvariable="dateF" > #dateF# >= #Arguments.Periodoinicio# 
      </cfquery>
    <cfreturn rsSQL>
</cffunction>  
<!---Obtener Segundo Periodo Datos para la Sincronizacion--->
<cffunction name="GetAgendaSincronizacionSegundoPeriodo" access="public" returntype="query">
        <cfargument name="CAAgrupado" 		type="string" 	required="yes" 	hint="Agrupador de datos">
        <cfargument name="conexion"   		type="string"  	required="yes" 	hint="Nombre del DataSource">
        <cfargument name="Periodoinicio"  	type="numeric" 	required="yes" 	hint="Año Inicio del periodo">
     	<cfargument name="Periodofin" 		type="numeric" 	required="yes" 	hint="Año Fin del periodo">  
			<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
                <cfset Arguments.conexion = session.dsn>
            </cfif>
    <cfquery name="rsSQL" datasource="#Arguments.conexion#">
        SELECT CAAid,
               Ecodigo,
               CADescripcion,
               CAAgrupador,
               CAFechaIni,
               CAFechaFin,
               CARepite,
               BMUsucodigo,
               BMfecha,
               ts_rversion
          FROM Agenda
         WHERE CAAgrupador  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#CAAgrupado#"> AND
         	   <cf_dbfunction name="date_part"	args="YYYY, CAFechaIni" returnvariable="dateI" > #dateI# <= #Arguments.Periodofin# AND
               <cf_dbfunction name="date_part"	args="YYYY, CAFechaFin" returnvariable="dateF" > #dateF# >= #Arguments.Periodofin# 
      </cfquery>
    <cfreturn rsSQL>
</cffunction>           
<!---Obtener Datos para la Agenda--->
<cffunction name="GetAgenda" access="public" returntype="query">
        <cfargument name="CAAgrupado" type="string" required="yes" 	hint="Agrupador de datos">
        <cfargument name="conexion"   type="string"  required="no" 	hint="Nombre del DataSource">
                <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
                    <cfset Arguments.conexion = session.dsn>
                </cfif>
    <cfquery name="rsSQL" datasource="#Arguments.conexion#">
        SELECT CAAid,
               Ecodigo,
               CADescripcion,
               CAAgrupador,
               CAFechaIni,
               CAFechaFin,
               CARepite,
               BMUsucodigo,
               BMfecha,
               ts_rversion
          FROM Agenda
         WHERE CAAgrupador  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#CAAgrupado#">               
      </cfquery>
    <cfreturn rsSQL>
</cffunction>
<!---Obtiene los feriados de un Mes no repetidos para la Agenda--->
<cffunction name="GetAgendaM" access="public" returntype="query">
        <cfargument name="CAAgrupado" 	type="string" required="yes" 	hint="Agrupador de datos">
        <cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
        <cfargument name="Mes" 			type="string" required="yes" 	hint="Agrupador de datos">
        <cfargument name="Year" 		type="string" required="yes" 	hint="Agrupador de datos"> 
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
            <cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        <cfset Lvar="0">
    <cfquery name="rsSQL" datasource="#Arguments.conexion#">
        SELECT CAAid,
               Ecodigo,
               CADescripcion,
               CAAgrupador,
               CAFechaIni,
               CAFechaFin,
               CARepite,
               BMUsucodigo,
               BMfecha,
               ts_rversion
          FROM Agenda
         WHERE CAAgrupador  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#CAAgrupado#"> AND
         		CARepite  = <cf_jdbcQuery_param cfsqltype="cf_sql_bit" len="2"   	value="#Lvar#"> AND
                <cf_dbfunction name="date_part"	args="YYYY, CAFechaIni" returnvariable="date" > #date# = #Year# AND
                <cf_dbfunction name="date_part"	args="mm, CAFechaIni" returnvariable="mes2" > #mes2# = #Mes#
      </cfquery>
	<cfreturn rsSQL>
</cffunction> 
<!---Obtiene los feriados de un Mes repetidos para la Agenda--->
<cffunction name="GetAgendaMRepetidos" access="public" returntype="query">
        <cfargument name="CAAgrupado" 	type="string" required="yes" 	hint="Agrupador de datos">
        <cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
        <cfargument name="Mes" 			type="string" required="yes" 	hint="Agrupador de datos">
        <cfargument name="Year" 		type="string" required="yes" 	hint="Agrupador de datos"> 
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
            <cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        <cfset Lvar="1">
    <cfquery name="rsSQL" datasource="#Arguments.conexion#">
        SELECT CAAid,
               Ecodigo,
               CADescripcion,
               CAAgrupador,
               CAFechaIni,
               CAFechaFin,
               CARepite,
               BMUsucodigo,
               BMfecha,
               ts_rversion
          FROM Agenda
         WHERE CAAgrupador  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" value="#CAAgrupado#"> AND
         		CARepite  = <cf_jdbcQuery_param cfsqltype="cf_sql_bit" len="2"   	value="#Lvar#"> AND
                <cf_dbfunction name="date_part"	args="mm, CAFechaIni" returnvariable="mes2"> #mes2# = #Mes# AND
                <cf_dbfunction name="date_part"	args="YYYY, CAFechaFin" returnvariable="date" > #date# >= #Year# AND
                <cf_dbfunction name="date_part"	args="YYYY, CAFechaIni" returnvariable="fecha" > #fecha# <= #Year# 
      </cfquery>
	<cfreturn rsSQL>
</cffunction> 
<!---Agregar un Feriado--->
<cffunction name="AltaAgenda" access="public" returntype="numeric">
		<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" 	hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"   	type="string" 	required="no" 	hint="Nombre del DataSource">
        <cfargument name="repite" 			type="string" 	required="yes"	hint="Repite feriado cada año">
        <cfargument name="CAAgrupado" 		type="string" 	required="yes" 	hint="Agrupador de datos">
        <cfargument name="fecha" 			type="string" 	required="yes" 	hint="Fecha del feriado">
		<cfargument name="descripcion"   	type="string"  	required="yes" 	hint="Descripcion del Feriado">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
			<cfset Arguments.conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
        <cfif repite eq 'ON'>
        	<cfset Lvar="1">
            <cfset LtiempoFin="6100-01-01">
        <cfelse>
        	<cfset Lvar="0">
            <cfset LtiempoFin=Arguments.fecha>
        </cfif>
          <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
                INSERT INTO Agenda (
                        Ecodigo,
                        CADescripcion,
                        CAAgrupador,
                        CAFechaIni,
                        CAFechaFin,
                        CARepite,
                        BMUsucodigo,
                        BMfecha
                )
                VALUES(
                       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" len="5"   value="#Arguments.Ecodigo#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#Arguments.descripcion#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"         	value="#CAAgrupado#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_date"  			value="#LsparseDateTime(Arguments.fecha)#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	   			value="#LsparseDateTime(LtiempoFin)#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_bit" len="2"   	value="#Lvar#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   		value="#Arguments.Usucodigo#">,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"  		value="#Now()#">)                 
              <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
        </cfquery> 
        <cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert">
            <cfreturn rsInsert.identity>
</cffunction>
<!---Actualiza los cambios en la agenda--->
    <cffunction name="CambioAgenda" access="public" >
        <cfargument name="Ecodigo" 	  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
        <cfargument name="CAAid" 	  		type="string" 	required="yes" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" 	hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"   	type="string" 	required="no" 	hint="Nombre del DataSource">
        <cfargument name="repite" 			type="string" 	required="yes" 	hint="Repite feriado cada año">
        <cfargument name="CAAgrupado" 		type="string" 	required="yes" 	hint="Agrupador de datos">
        <cfargument name="fecha" 			type="string" 	required="yes" 	hint="Fecha del feriado">
		<cfargument name="descripcion"   	type="string"  	required="yes"	hint="Descripcion del Feriado">
		<cfif not isdefined('Arguments.CAAid') and isdefined('session.CAAid')>
			<cfset Arguments.CAAid = session.CAAid>
		</cfif>
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
			<cfset Arguments.conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
        <cfif repite eq 'ON'>
        	<cfset Lvar="1">
            <cfset LtiempoFin="6100-01-01">
        <cfelse>
        	<cfset Lvar="0">
            <cfset LtiempoFin=Arguments.fecha>
        </cfif>
              <cfquery datasource="#session.dsn#" name="rsUpdate">     
                UPDATE  Agenda 
                     SET    Ecodigo       = #Arguments.Ecodigo#,
                            CADescripcion  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"value="#Arguments.Descripcion#">,
                            CAAgrupador = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"         	value="#CAAgrupado#">,
                            CAFechaIni  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  	value="#Arguments.fecha#">,
                            CAFechaFin  = <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	   			value="#LsparseDateTime(LtiempoFin)#">,
                            CARepite    = <cf_jdbcQuery_param cfsqltype="cf_sql_bit" len="1"   		value="#Lvar#">,
                            BMUsucodigo   = #Arguments.Usucodigo#,
                            BMfecha		=	<cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"  		value="#Now()#">				   
                     WHERE CAAid  = <cfoutput>#Arguments.CAAid#</cfoutput>
            </cfquery>
    </cffunction>
<!---Actualiza la fecha fin--->
    <cffunction name="CambioAgendaFechaFin" access="public" >
        <cfargument name="Ecodigo" 	  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
        <cfargument name="CAAid" 	  		type="string" 	required="yes" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" 	hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"   	type="string" 	required="no" 	hint="Nombre del DataSource">
        <cfargument name="fecha" 			type="string" 	required="yes" 	hint="Fecha del feriado">
		<cfif not isdefined('Arguments.CAAid') and isdefined('session.CAAid')>
			<cfset Arguments.CAAid = session.CAAid>
		</cfif>
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
			<cfset Arguments.conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
              <cfquery datasource="#session.dsn#" name="rsUpdate">     
                UPDATE  Agenda 
                     SET   
                            CAFechaFin  = <cf_jdbcQuery_param cfsqltype="cf_sql_date" 	   			value="#Arguments.fecha#">,
                            BMfecha		=	<cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"  		value="#Now()#">				   
                     WHERE CAAid  = <cfoutput>#Arguments.CAAid#</cfoutput> 
            </cfquery>
    </cffunction>
<!--- Elimina Feriados de la Agenda--->
<cffunction name="BajaAgenda" access="public" >
    	<cfargument name="Ecodigo" 	  	type="numeric" 	required="no" hint="Codigo de la Empresa">        		
        <cfargument name="CAAid" 	  	type="string" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  	required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
       <cfquery datasource="#Arguments.conexion#">     
           DELETE FROM Agenda
     		WHERE CAAid          = <cfoutput>#Arguments.CAAid#</cfoutput> 
       </cfquery>
     </cffunction>
</cfcomponent>