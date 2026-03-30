<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
        	
			<cfif  Form.tab eq 1>
               <cfset cmayor = Form.txt_Cmayor1>
               <cfset CPTCtipo = 'I'>
            <cfelseif Form.tab eq 2>
               <cfset CPTCtipo = 'E'>
               <cfset cmayor = Form.txt_Cmayor2>
            <cfelseif Form.tab eq 3>
               <cfset CPTCtipo = 'C'>
               <cfset cmayor = Form.txt_Cmayor3>
            <cfelseif Form.tab eq 4>
               <cfset CPTCtipo = 'X'>
               <cfset cmayor = Form.txt_Cmayor4>
            </cfif>  
   			
           	<cfquery name="rsContar" datasource="#Session.DSN#" maxrows="1">
                select CPTCmascara as lenT
                from CPtipoCtas
                where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                      
                	and CPTCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">
               		and CPPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
            </cfquery>

            <cfif len(#rsContar.lenT#) EQ len(Form.CPmascaraExcepciones) >
            	<!--- Verificar que la cuenta ingresada respete el formato de las anteriores, en caso de existir --->
				<cfset mascara = #rsContar.lenT#>
                <cfset guion_pos = -1>
                <cfset index = 1>
                <cfloop condition= "guion_pos NEQ 0 AND len(mascara) GT 0">
                    <cfset guion_pos = #find("-", mascara)#>
                        <cfif guion_pos NEQ 0>
                            <cfif guion_pos EQ 1>
                                <cfset mascara_n = guion_pos>
                            <cfelse>
                                <cfset mascara_n = guion_pos>
                            </cfif>
                            <cfset mascara = #removechars(mascara, 1, guion_pos)#>
                            <cfset tagArray[index] = mascara_n>
                        <cfelseif guion_pos EQ 0 AND len(mascara) GT 0>
                            <cfset tagArray[index] = trim('final')>
                        </cfif>
                    <cfset index = index+1>
                </cfloop>
                
                <cfset mascara2 = #Form.CPmascaraExcepciones#>
                <cfset guion_pos2 = -1>
                <cfset index2 = 1>
                <cfloop condition= "guion_pos2 NEQ 0 AND len(mascara2) GT 0">
                    <cfset guion_pos2 = #find("-", mascara2)#>
                        <cfif guion_pos2 NEQ 0>
                            <cfif guion_pos2 EQ 1>
                                <cfset mascara_n2 = guion_pos2>
                            <cfelse>
                                <cfset mascara_n2 = guion_pos2>
                            </cfif>
                            <cfset mascara2 = #removechars(mascara2, 1, guion_pos2)#>
                            <cfset tagArray2[index2] = mascara_n2>
                            
                        <cfelseif guion_pos2 EQ 0 AND len(mascara2) GT 0>
                            <cfset tagArray2[index2] = trim('final')>
                        </cfif>
                    <cfset index2 = index2+1>
                </cfloop>
                <cfloop from="1" to="#arrayLen(tagArray)#" index="i">
                	<cfif #tagArray[i]# EQ #tagArray2[i]#>
						<cfset comparacion = 1>
                    <cfelse>
						<cfset comparacion = 0>
                        <cfbreak>
                    </cfif>
                </cfloop>
            <cfelseif len(trim(rsContar.lenT)) EQ 0>
           		<cfset comparacion = 1>  
            <cfelse> 
            	<cfset comparacion = 0>
            </cfif>
            
            <cfif comparacion EQ 1>
				<cfset Form.CPmascaraExcepciones = replace(Form.CPmascaraExcepciones,"?","_","ALL")>
	           	<cfif CPTCtipo EQ 'I'>
                	 <cfquery name="rsVerificarCtasIng" datasource="#Session.DSN#">
                        Select count(1) as ingresoDisponible from CFinanciera c
                        inner join CtasMayor m on m.Ecodigo=c.Ecodigo and m.Cmayor = c.Cmayor
                        where
                            (
                                m.Ctipo IN ('A','G')       	
                            and
                                (
                                select count(1) from CPtipoCtas t
                                where t.CPPid     =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                                and t.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                      
                                and t.Cmayor      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                                and t.CPTCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">
                                and t.CPTCtipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">
                                )=0)
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                            and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                    </cfquery>
                    <cfif #rsVerificarCtasIng.ingresoDisponible# GT 0>
                        <cfquery name="rsInsertCPtipoCtas" datasource="#Session.DSN#">
                            insert into CPtipoCtas(CPPid, CPTCtipo, Ecodigo, Cmayor, CPTCmascara, CPTCdescripcion) 
                            values ( 
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
                                    <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,                        
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">
                                    )
                        </cfquery>
                  	</cfif>
                    
                <cfelseif CPTCtipo EQ 'E'>
                	 <cfquery name="rsVerificarCtasEgre" datasource="#Session.DSN#">
                        Select count(1) as egresoDisponible from CFinanciera c
                        inner join CtasMayor m on m.Ecodigo=c.Ecodigo and m.Cmayor = c.Cmayor
                        where
                            (
                                m.Ctipo NOT IN ('A','G')       	
                            and
                                (
                                select count(1) from CPtipoCtas t
                                where t.CPPid     =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                                and t.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                      
                                and t.Cmayor      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                                and t.CPTCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">
                                and t.CPTCtipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">
                                )=0)
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                            and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                    </cfquery>
                    <cfif #rsVerificarCtasEgre.egresoDisponible# GT 0>
                        <cfquery name="rsInsertCPtipoCtas" datasource="#Session.DSN#">
                            insert into CPtipoCtas(CPPid, CPTCtipo, Ecodigo, Cmayor, CPTCmascara, CPTCdescripcion) 
                            values ( 
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
                                    <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,                        
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">
                                    )
                        </cfquery>
                    </cfif>
                           
                <cfelse>
                	<cfquery name="rsVerificarCostos" datasource="#Session.DSN#">
                        Select count(1) as costoDisponible from CFinanciera c
                        inner join CtasMayor m on m.Ecodigo=c.Ecodigo and m.Cmayor = c.Cmayor
                        where (
                                (
                                select count(1) from CPtipoCtas t
                                where t.CPPid     =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                                and t.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                      
                                and t.Cmayor      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                                and t.CPTCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">
                                and t.CPTCtipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">
                                )=0)
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                            and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">
                    </cfquery>
                    <cfif #rsVerificarCostos.costoDisponible# GT 0>
                        <cfquery name="rsInsertCPtipoCtas" datasource="#Session.DSN#">
                            insert into CPtipoCtas(CPPid, CPTCtipo, Ecodigo, Cmayor, CPTCmascara, CPTCdescripcion) 
                            values ( 
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
                                    <cfqueryparam cfsqltype="cf_sql_char" value="#CPTCtipo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,                        
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cmayor#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPmascaraExcepciones#">,
                                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.Descripcion#" len="40">
                                    )
                        </cfquery>
                    </cfif>
                </cfif>
            </cfif>
			
           
		<cfelseif isdefined("Form.BorrarD") AND Form.BorrarD EQ "BORRAR">
			<cfif isdefined("Form.CPTCid") AND isdefined("Form.CPTCtipo")>
            	<cfquery name="rsDeleteCPtipoCtas" datasource="#session.DSN#">
                    delete from CPtipoCtas 
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
                        and CPTCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPTCid#"> 
                        and CPTCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTCtipo#">
                </cfquery>			
			</cfif>	
		</cfif>
	 </cfif>
<cfoutput>
    <form action="cuentasTipoPresupuesto.cfm" method="post" name="sql">
        <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
        <input name="tab" type="hidden" value="#form.tab#">
    </form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>