<cfcomponent>

    <cffunction name ="tipos" access="public" returntype="query">
    <cfargument name="DEid" type="string" required="yes" 	>
    	<cfquery name="rstipos" datasource="#session.DSN#">
            select distinct RHAEtipo
            from RHArchEmp
            where  DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">  
            order by RHAEtipo
        </cfquery>
        <cfreturn rstipos>
    </cffunction>
    
    <cffunction name ="getLista" access="public" returntype="query">  
    <cfargument name="DEid" 			type="string"required="yes">
    <cfargument name="RHAEtipoFiltro"  	type="string" required="no" >
    <cfargument name="txtRHAEdescr"  	type="string" required="no" >
    <cfargument name="vRHAEid"  		type="string" required="no" >
    <cfargument name="LB_Modificar"  		type="string" required="yes" >
	<cfargument name="LB_Descargar"  		type="string" required="yes" >
     	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        <cf_dbfunction name="to_char" args="RHAEid" returnvariable="vRHAEid">
        <cfquery name="rsLista" datasource="#session.DSN#">
                select RHAEid,DEid,RHAEdescr,RHAEfecha,RHAEarchivo,RHAEtipo,
                '<a href="javascript: Editar(''' #_Cat#  #vRHAEid# #_Cat# ''');"><img alt=''#LB_Modificar#'' src=''/cfmx/rh/imagenes/iindex.gif'' border=''0''></a>' as Editar,
                '<a href="javascript: Descargar('''#_Cat# #vRHAEid# #_Cat#''');"><img alt=''#LB_Descargar#'' src=''/cfmx/rh/imagenes/Cfinclude.gif'' border=''0''></a>' as Descargar, 
                10 as o,
                1  as sel
                from RHArchEmp 
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">  
                <cfif isdefined("Arguments.txtRHAEdescr") and len(trim(Arguments.txtRHAEdescr))>
                     and upper(RHAEdescr)  like '%#UCase(Arguments.txtRHAEdescr)#%'
                </cfif>
                <cfif isdefined("Arguments.RHAEtipoFiltro") and len(trim(Arguments.RHAEtipoFiltro))>
                    and RHAEtipo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHAEtipoFiltro#">  
                </cfif>
                order by RHAEfecha desc
		</cfquery>
        <cfreturn rsLista>
     </cffunction>   
     
    <cffunction name ="getDatos" access="public" returntype="query">  
    <cfargument name="RHAEid"  		type="numeric" required="yes" >
     		<cfquery name="rsdataObj" datasource="#session.DSN#">
				select RHAEid,DEid,RHAEdescr,RHAEfecha,RHAEtipo,RHAEruta, ts_rversion
				from RHArchEmp
				where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAEid#">  
			</cfquery>
    	<cfreturn rsdataObj> 
    </cffunction>
   
    <cffunction name ="altaArchivo" access="public" returntype="query">
        <cfargument name="DEid" 		type="string"required="yes">
        <cfargument name="RHAEdescr"  	type="string" required="yes" >
        <cfargument name="RHAEfecha"  	type="string" required="yes" >
				<cfif isdefined("form.archivo") and Len(Trim(form.archivo)) gt 0 >
                    <cfinclude template="/rh/Utiles/imagen.cfm">
                </cfif>
          	<cfquery name="insRHArchEmp" datasource="#Session.DSN#">	
                insert into RHArchEmp 
                (DEid, Ecodigo, RHAEdescr, RHAEfecha,BMusumod, BMfechamod,Archivo)
                values (
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.RHAEdescr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#LSParsedateTime(Arguments.RHAEfecha)#">,					
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                <cfif isdefined("ts")>
                    <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
                 <cfelse>
                    null
                 </cfif>
                )
                <cf_dbidentity1 datasource="#Session.DSN#">
            </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insRHArchEmp">
    	<cfreturn insRHArchEmp>    
    </cffunction>   
    
    <cffunction name ="cambioArchivo" access="public" >
        <cfargument name="vRHAEid" 			type="string"	required="yes">
        <cfargument name="nombreArchivo"  	type="string" 	required="yes">
        <cfargument name="serverDirectory"  type="string" 	required="yes">
    	<cfargument name="serverFileExt"  	type="string" 	required="yes">
            <cfquery name="updRHArchEmp" datasource="#Session.DSN#">
                update RHArchEmp set 
                    RHAEarchivo			=  '#Arguments.vRHAEid#_#Arguments.nombreArchivo#',
                    RHAEruta 			=  <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.serverDirectory#">,
                    RHAEtipo 			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.serverFileExt#">
                where RHAEid = #Arguments.vRHAEid#
            </cfquery> 
    </cffunction> 
    
 	<cffunction name ="datoObjet" access="public" >
        <cfargument name="RHAEid"	type="string"	required="yes">  
            <cfquery name="rsdataObj" datasource="#session.DSN#">
                select ltrim(rtrim(RHAEruta)) as RHAEruta ,ltrim(rtrim(RHAEarchivo)) as RHAEarchivo
                from RHArchEmp
                where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAEid#">  
            </cfquery>
    	<cfreturn rsdataObj>   
    </cffunction>
    
    <cffunction name ="bajaArchivo" access="public" >
    	<cfargument name="RHAEid"	type="string"	required="yes"> 
        <cfquery name="delRHArchEmp" datasource="#Session.DSN#">
            delete from RHArchEmp 
            where RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAEid#">
        </cfquery>
    </cffunction> 
    <cffunction name ="cambiaoaArchivoF" access="public" >
    	<cfargument name="RHAEdescr"type="string"	required="yes">
        <cfargument name="RHAEfecha"type="string" 	required="no">
        <cfargument name="RHAEid"  	type="string" 	required="yes">

            <cfquery name="updRHArchEmp" datasource="#Session.DSN#">
                update RHArchEmp set
                    RHAEdescr			=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHAEdescr#">,
                    <cfif isdefined("Arguments.RHAEfecha")>
                    RHAEfecha 			=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(Arguments.RHAEfecha)#">,
                    </cfif>
                    BMusumod 			=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    BMfechamod 			=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">							
                where RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAEid#">
            </cfquery>
    </cffunction>
    
    <cffunction name ="descargaArchivo" access="public" >
 		<cfargument name="RHAEid"  	type="string" 	required="yes">
            <cfquery name="rsdataObj" datasource="#session.DSN#">
                select  ltrim(rtrim(RHAEarchivo)) as RHAEarchivo ,RHAEtipo, Archivo
                from RHArchEmp
                where  RHAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAEid#">  
            </cfquery>
    	<cfreturn rsdataObj>   
    </cffunction> 
</cfcomponent>