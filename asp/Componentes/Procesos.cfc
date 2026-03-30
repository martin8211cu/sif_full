<cfcomponent>   
    <cffunction name="ValidarProcesos" access="public" returntype="boolean" hint="verifica si existen los procesos parael usuario">
		<cfargument name="Usucodigo" 	type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="yes">
        <cfargument name="SScodigo" 	type="string" 	required="yes">
        <cfargument name="SPcodigo" 	type="string" 	required="yes">
        <cfargument name="Conexion" 	type="string" 	required="no" default="asp">
        <cfquery name="rsProcesos" datasource="#Arguments.Conexion#">
        	select count(1) as siExiste
            from UsuarioProceso
            where Usucodigo = #Arguments.Usucodigo#
            	  and Ecodigo	=  #Arguments.Ecodigo#
                  and SScodigo	= '#Arguments.SScodigo#'
                  and SPcodigo	= '#Arguments.SPcodigo#'
        </cfquery>
        <cfreturn rsProcesos.siExiste EQ 0>	  
    </cffunction>
    <!---===============Carga los Roles del Usuario en session=================--->
    <cffunction name="CargarProcesosSession" access="public" hint="Carga los Procesos del Usuario en session">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfif isdefined('session.Usucodigo') and Not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <!---ljs se consulta por los ecodigo para usar y sacar los roles por empresa y no corporativo--->
        <cfquery name="rsReferencia" datasource="#session.dsn#">
			select Ecodigo
             from Empresa 
            where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
        	
   		<cfquery name="rs" datasource="asp">
			select RTRIM(SPcodigo) SPcodigo
             from vUsuarioProcesos 
            where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            and Ecodigo = #rsReferencia.Ecodigo#
		</cfquery>
        <cfset session.Procesos = ValueList(rs.SPcodigo)>
	</cffunction>
    <!---=============Verifica si un Empleado tienen un Rol====================--->
     <cffunction name="VerificaProceso" access="public" returntype="boolean" hint="Verifica si un Empleado tienen un Proceso">
		<cfargument name="SPcodigo" 	type="string" 	required="yes">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfif isdefined('session.Usucodigo') and Not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('session.Procesos')>
        	<cfset CargarProcesosSession()>
        </cfif>
        <cfreturn IIF(LISTFIND(session.Procesos,Arguments.SPcodigo) GT 0,TRUE,FALSE)>
     </cffunction>
     <!---- ============= FUNCION PARA OBTENER LISTA DE ROLES LOGEADOS=====================---->
     <cffunction name="getProcesoByUser" returntype="array" > 
	    <cfargument name="search" 		type="string" required="true">  
        <cfargument name="Usucodigo" 	type="numeric" required="yes">   
        <cfset var data=""> 
        <cfset var result=ArrayNew(1)> 
        
        <!----- limpieza del string----->
        <cfset LvarBusca = ucase(trim(arguments.search))>
        <cfset LvarBusca = replace(LvarBusca,'Ñ','N')>
        <cfset LvarBusca = replace(LvarBusca,'Á','A')>
        <cfset LvarBusca = replace(LvarBusca,'É','E')>
        <cfset LvarBusca = replace(LvarBusca,'Í','I')>
        <cfset LvarBusca = replace(LvarBusca,'Ó','O')>
        <cfset LvarBusca = replace(LvarBusca,'Ú','U')>
        
        <cf_dbfunction name="sReplace" args="upper(ltrim(rtrim(sp.SPdescripcion)))¬'Ñ'¬'N'" delimiters="¬" returnvariable="LvarSearch">
        <cf_dbfunction name="sReplace" args="#LvarSearch#¬'Á'¬'A'" delimiters="¬" returnvariable="LvarSearch">
        <cf_dbfunction name="sReplace" args="#LvarSearch#¬'É'¬'E'" delimiters="¬" returnvariable="LvarSearch">
        <cf_dbfunction name="sReplace" args="#LvarSearch#¬'Í'¬'I'" delimiters="¬" returnvariable="LvarSearch">
        <cf_dbfunction name="sReplace" args="#LvarSearch#¬'Ó'¬'O'" delimiters="¬" returnvariable="LvarSearch">
        <cf_dbfunction name="sReplace" args="#LvarSearch#¬'Ú'¬'U'" delimiters="¬" returnvariable="LvarSearch">
        
    	<cfquery datasource="asp" name="dataSearchComb" maxrows="25">
            select  distinct sm.SMdescripcion,sp.SPdescripcion,sp.SPhomeuri
            from  vUsuarioProcesos pr
                inner join SProcesos sp
                    on sp.SPcodigo = pr.SPcodigo
                    and sp.SMcodigo = pr.SMcodigo
                inner join SModulos sm
                    on sm.SMcodigo = pr.SMcodigo
            where pr.Usucodigo = #arguments.Usucodigo#  and ( sp.SPcodigo like '%AUTO%' or SPmenu=1)
            	and #preservesinglequotes(LvarSearch)# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LvarBusca#%">
			order by sp.SPdescripcion,sm.SMdescripcion
        </cfquery>
        
         <cfloop query="dataSearchComb"> 
       		 <cfset returnStruct = StructNew() /> 
			<cfset returnStruct["label"] = SPdescripcion&' ('&SMdescripcion&')'/> 
            <cfset returnStruct["url"] = SPhomeuri />  
            <cfset ArrayAppend(result,returnStruct) /> 
        </cfloop>
        
        <cfreturn result /> 
    </cffunction>
    <cffunction name="getInfo" returntype="struct" output="no">
    	<cfargument name="SScodigo" required="yes" type="string">
        <cfargument name="SMcodigo" required="yes" type="string">
        <cfargument name="SPcodigo" required="yes" type="string">

            <cfset nav__SScodigo = arguments.SScodigo>
            <cfset nav__SMcodigo = arguments.SMcodigo>
            <cfset nav__SPcodigo = arguments.SPcodigo>
            <cfquery datasource="asp" name="nav__query" debug="no">
                select SSdescripcion
                from SSistemas
                where SScodigo = '#nav__SScodigo#'
            </cfquery>
            <cfif nav__query.RecordCount>          
                <cfset nav__SSdescripcion = nav__query.SSdescripcion> 
            </cfif>
            <cfquery datasource="asp" name="nav__query" debug="no">
                select SMdescripcion
                from SModulos
                where SScodigo = '#nav__SScodigo#'
                  and SMcodigo = '#nav__SMcodigo#'
            </cfquery>
            <cfif nav__query.RecordCount>
                <cfset nav__SMdescripcion = nav__query.SMdescripcion>
            </cfif>
            <cfquery datasource="asp" name="nav__query" debug="no">
                select SPdescripcion
                from SProcesos
                where SScodigo = '#nav__SScodigo#'
                  and SMcodigo = '#nav__SMcodigo#'
                  and SPcodigo = '#nav__SPcodigo#'
            </cfquery>
            <cfif nav__query.RecordCount>
                <cfset nav__SPdescripcion = nav__query.SPdescripcion>
            <cfelse>
                <cfset nav__SPdescripcion = nav__SMdescripcion>
            </cfif> 
            <cfinvoke component="sif.Componentes.TranslateDB" method="Translate" returnvariable="nav__SSdescripcion">
                <cfinvokeargument name="VSvalor" value="#nav__SScodigo#">
                <cfinvokeargument name="VSgrupo" value="101">
                <cfinvokeargument name="Default" value="#nav__SSdescripcion#">
            </cfinvoke>
            <cfinvoke component="sif.Componentes.TranslateDB" method="Translate" returnvariable="nav__SMdescripcion">
                <cfinvokeargument name="VSvalor" value="#nav__SScodigo#.#nav__SMcodigo#">
                <cfinvokeargument name="VSgrupo" value="102">
                <cfinvokeargument name="Default" value="#nav__SMdescripcion#">
            </cfinvoke>
            <cfinvoke component="sif.Componentes.TranslateDB" method="Translate" returnvariable="nav__SPdescripcion">
                <cfinvokeargument name="VSvalor" value="#nav__SScodigo#.#nav__SMcodigo#.#nav__SPcodigo#">
                <cfinvokeargument name="VSgrupo" value="103">
                <cfinvokeargument name="Default" value="#nav__SPdescripcion#">
            </cfinvoke>
            <cfset LvarStructReturn = StructNew()>
            	<cfset LvarStructReturn.SScodigo=nav__SScodigo>
                <cfset LvarStructReturn.SSdescripcion=nav__SSdescripcion>
               	<cfset LvarStructReturn.SMcodigo=nav__SMcodigo>
                <cfset LvarStructReturn.SMdescripcion=nav__SMdescripcion>
            	<cfset LvarStructReturn.SPcodigo=nav__SPcodigo>
                <cfset LvarStructReturn.SPdescripcion=nav__SPdescripcion>
            <cfreturn LvarStructReturn>
    </cffunction>
</cfcomponent>