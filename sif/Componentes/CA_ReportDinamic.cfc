<cfcomponent output="no">
	<cffunction name="ALTAReportDinamic" access="public" output="no">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="ERDcodigo" 	type="string" 	required="yes">
		<cfargument name="ERDdesc" 		type="string" 	required="yes">
		<cfargument name='ERDmodulo' 	type='string' 	required="yes">
        <cfargument name='ERDbody' 	    type='string' 	required="yes">
        <cfargument name='BMUsucodigo' 	type='numeric' 	required="no">
		<cfargument name='fechaalta' 	type='date' 	required="no">
        
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
       	<cfif NOT ISDEFINED('Arguments.fechaalta')>
			<cfset Arguments.fechaalta = NOW()>
        </cfif>

        <cfif NOT ISDEFINED('Arguments.BMUsucodigo') and ISDEFINED('Session.Usucodigo')>
			<cfset Arguments.BMUsucodigo = Session.Usucodigo>
        </cfif>
       
		<cfquery datasource="#session.dsn#" name="Insert">
			insert INTO EReportDinamic (Ecodigo,ERDcodigo, ERDdesc, ERDmodulo, ERDbody,BMUsucodigo, fechaalta )
            values(
            		<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Ecodigo#"> ,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  	value="#Arguments.ERDcodigo#">,
           			<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120"  	value="#Arguments.ERDdesc#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"  	value="#Arguments.ERDmodulo#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_clob"					value="#Arguments.ERDbody#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.BMUsucodigo#">,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         	value="#Arguments.fechaalta#"> 
            	   )
               <cf_dbidentity1 conexion="#session.dsn#" verificar_transaccion="false">
		</cfquery>
        <cf_dbidentity2 name="Insert" conexion="#session.dsn#" verificar_transaccion="false">
        
        <cfinvoke component="sif.Componentes.CA_ReportDinamic" method="InsertVariables">
            <cfinvokeargument name="ERDid" 			value="#Insert.identity#">
            <cfinvokeargument name="BMUsucodigo" 	value="#Arguments.BMUsucodigo#">
            <cfinvokeargument name="fechaalta" 		value="#Arguments.fechaalta#">
            <cfinvokeargument name="ERDmodulo" 		value="#Arguments.ERDmodulo#">
            <cfinvokeargument name="ERDbody" 		value="#Arguments.ERDbody#">
        </cfinvoke>							
	</cffunction>
    
    <cffunction name="CAMBIODetalleReportDinamic" access="public" output="no">
    	<cfargument name="ERDid" 		type="numeric" 	required="yes">
        <cfargument name='BMUsucodigo' 	type='numeric' 	required="no">
		<cfargument name='fechaalta' 	type='date' 	required="no">
        <cfargument name='AnexoCon' 	type='numeric' 	required="no">
        <cfargument name='DRDNegativo' 	type='numeric' 	required="no">
		<cfargument name='AVid' 		type='numeric' 	required="no">
        <cfargument name='ANHCid' 		type='numeric' 	required="no"> 
        <cfargument name='DRDMeses' 	type='numeric' 	required="no"> 
        
        <cfif NOT ISDEFINED('Arguments.fechaalta')>
			<cfset Arguments.fechaalta = NOW()>
        </cfif>

        <cfif NOT ISDEFINED('Arguments.BMUsucodigo') and ISDEFINED('Session.Usucodigo')>
			<cfset Arguments.BMUsucodigo = Session.Usucodigo>
        </cfif>

	  <cfquery name="rs" datasource="#Session.dsn#">
       	update DReportDinamic  
         set
         	<cfif isdefined("Arguments.DRDMeses")>
            	DRDMeses 	=	<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   	value="#Arguments.DRDMeses#">, 
            </cfif>
            <cfif isdefined("Arguments.AVid")>
            	AVid 		=	<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   	value="#Arguments.AVid#">, 
            </cfif>
            <cfif isdefined("Arguments.DRDValor")>
            	DRDValor	=  <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.DRDValor#" >,
            </cfif>
			<cfif isdefined("Arguments.ANHCid")>
            	ANHCid		=  <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.ANHCid#" >,
             </cfif>
            <cfif isdefined("Arguments.AnexoCon")>
            	AnexoCon 	=	<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   	value="#Arguments.AnexoCon#">, 
            </cfif>
            <cfif isdefined("Arguments.DRDNegativo")>
            	DRDNegativo =	<cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   			value="#Arguments.DRDNegativo#">,
            </cfif>
            	BMUsucodigo =   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.BMUsucodigo#">,
            	fechaalta   = 	<cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         	value="#Arguments.fechaalta#"> 
        where  DRDNombre = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" scale="0" 	value="#Arguments.DRDNombre#">
        	and ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 			value="#Arguments.ERDid#">
       </cfquery>
    </cffunction>
	
	<cffunction name="CAMBIOReportDinamic" access="public" output="no">
    	<cfargument name="ERDid" 		type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="ERDcodigo" 	type="string" 	required="yes">
		<cfargument name="ERDdesc" 		type="string" 	required="yes">
		<cfargument name='ERDmodulo' 	type='string' 	required="yes">
        <cfargument name='ERDbody' 	    type='string' 	required="yes">
        <cfargument name='BMUsucodigo' 	type='numeric' 	required="no">
		<cfargument name='fechaalta' 	type='date' 	required="no">
        <cfargument name='AnexoCon' 	 type='string' 	required="no">
        <cfargument name='DRDNegativo' 	type='numeric' 	required="no">
		<cfargument name='AVid' 		type='numeric' 	required="no">
		
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
       	<cfif NOT ISDEFINED('Arguments.fechaalta')>
			<cfset Arguments.fechaalta = NOW()>
        </cfif>

        <cfif NOT ISDEFINED('Arguments.BMUsucodigo') and ISDEFINED('Session.Usucodigo')>
			<cfset Arguments.BMUsucodigo = Session.Usucodigo>
        </cfif>
        
        <cfquery datasource="#session.dsn#" name="Insert">
        	update EReportDinamic 
			set 
                ERDcodigo 	=   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  	value="#Arguments.ERDcodigo#">,
           		ERDdesc 	=	<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120"  	value="#Arguments.ERDdesc#">,
                ERDmodulo   = 	<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"  	value="#Arguments.ERDmodulo#">,
                ERDbody     =	<cf_jdbcQuery_param cfsqltype="cf_sql_clob"					value="#Arguments.ERDbody#">,
                BMUsucodigo =   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.BMUsucodigo#">,
                fechaalta   = 	<cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         	value="#Arguments.fechaalta#"> 
            where  Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Ecodigo#">
	          and ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
		</cfquery>  

       
			<cfinvoke component="sif.Componentes.CA_ReportDinamic" method="InsertVariables">
                <cfinvokeargument name="ERDid" 			value="#Arguments.ERDid#">
                <cfinvokeargument name="BMUsucodigo" 	value="#Arguments.BMUsucodigo#">
                <cfinvokeargument name="fechaalta" 		value="#Arguments.fechaalta#">
                <cfinvokeargument name="ERDmodulo" 		value="#Arguments.ERDmodulo#">
                <cfinvokeargument name="ERDbody" 		value="#Arguments.ERDbody#">
            </cfinvoke>
	</cffunction>

    <cffunction name="InsertVariables" acces="public" output="no">
    	<cfargument name="ERDid" 		type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name='ERDbody' 	    type='string' 	required="yes">
        <cfargument name='BMUsucodigo' 	type='numeric' 	required="yes">
		<cfargument name='fechaalta' 	type='date' 	required="yes">
        <cfargument name='AnexoCon' 	type='string' 	required="no" default="1">
        <cfargument name='DRDNegativo' 	type='numeric' 	required="no" default="0">
		<cfargument name='AVid' 		type='numeric' 	required="no" default="0">
     	
		<cfset texto = Arguments.ERDbody>
		<cfset cont =1>
     	<cfset variblesNuevas = ArrayNew(1)>
       	<cfset ch=''>
       	<cfset variable="" >
     	<cfset inicia= false>
       <cfloop from="0" to="#LEN(texto)-1#" index="i">
       	<cfset ch = texto.charAt(i)>
			<cfif ch eq '##' AND inicia EQ false>
            	<cfset variable="">
            	<cfset inicia = true> 
            <cfelseif inicia EQ true AND  ch NEQ '##'>
             	<cfset variable = variable & ch>
            <cfelseif inicia EQ true AND  ch EQ '##'>
            	<cfset variblesNuevas [cont]= variable>
                <cfset cont = cont+1 >
                
                    <cfquery datasource="#session.dsn#" name="rsBusca">
                        select * from DReportDinamic 
                        where DRDNombre =  <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  	value="#variable#">
                            and ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
                    </cfquery>
   
                <cfif rsBusca.recordcount EQ 0>
                	<cfquery datasource="#session.dsn#" name="rsInserto">
                      insert INTO DReportDinamic (ERDid,DRDNombre, AnexoCon, DRDNegativo, AVid,BMUsucodigo, fechaalta )
                            values(
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#"> ,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  	value="#variable#">,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   			value="#AnexoCon#">,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"				value="#DRDNegativo#">,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" len="2"  	value="#AVid#">,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.BMUsucodigo#">,
                                    <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         	value="#Arguments.fechaalta#"> 
                                   )
                    </cfquery>
                </cfif>
                <cfset variable="" >
                <cfset inicia = false>
            </cfif>
       </cfloop>

        <cfquery datasource="#session.dsn#" name="rsVariabExistente">
            select DRDNombre from DReportDinamic 
            where ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
        </cfquery>
       <cfloop query="rsVariabExistente">
            <cfset eliminar = true>
            <cfloop from="1" to="#cont-1#" index="i">
                <cfif variblesNuevas[i] eq rsVariabExistente.DRDNombre>
                    <cfset  eliminar = false>
                </cfif>
            </cfloop>
                <cfif eliminar eq true>
                    <cfquery datasource="#session.dsn#" name="rsExiste">
                        delete DReportDinamic 
                        where DRDNombre =  <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#rsVariabExistente.DRDNombre#">
                            and ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
                    </cfquery>
                </cfif>
       </cfloop>
     </cffunction>

   
   	<cffunction name="BAJAReportDinamic" access="public" output="no">
    	<cfargument name="ERDid" 		type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
		<cfquery datasource="#session.dsn#" >
			delete DReportDinamic 
            	where ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
		</cfquery>	
        
		<cfquery datasource="#session.dsn#" >
			delete EReportDinamic 
            	where Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Ecodigo#">
	                and ERDid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.ERDid#">
		</cfquery>		
	</cffunction>
</cfcomponent>
