<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfset Form.CPCCmascara = replace(Form.CPCCmascara,"?","_","ALL")>
            <cfquery name="rsVerificarCtas" datasource="#Session.DSN#">
                Select count(1) as ingresoDisponible from CFinanciera c
                inner join CtasMayor m on m.Ecodigo=c.Ecodigo and m.Cmayor = c.Cmayor
                where
                    (
                    select count(1) from CPresupuestoComprometidas t
                    where t.CPPid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
                    and t.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                      
                    and t.Cmayor      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txt_Cmayor1#">
                    and t.CPCCmascara = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPCCmascara#">
                    )=0
                and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txt_Cmayor1#">
            </cfquery>
        
			<cfif #rsVerificarCtas.ingresoDisponible# GT 0>
                <cfquery name="rsInsertCPtipoCtas" datasource="#Session.DSN#">
                    insert into CPresupuestoComprometidas(CPPid, Ecodigo, Cmayor, CPCCmascara, CPCCdescripcion, BMUsucodigo) 
                    values ( 
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,                        
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txt_Cmayor1#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPCCmascara#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usucodigo#">
 			               	)
                </cfquery>
            </cfif>
           
    	<cfelseif isdefined("Form.BorrarD") and len(trim(Form.BorrarD)) gt 0>
			<cfif isdefined("Form.CPCCid")>
                <cfquery name="rsDeleteCPtipoCtas" datasource="#session.DSN#">
                    delete from CPresupuestoComprometidas 
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
                    and CPCCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCCid#"> 
                </cfquery>	
                
                		
            </cfif>	  		
    	</cfif>	
	</cfif>
 
<cfoutput>
    <form action="CPCompromisoAut.cfm" method="post" name="sql">
        <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("Form.btnFiltrar")>
			<input name="descripcion" type="hidden" value="<cfif isdefined("descripcion")>#Form.descripcion#</cfif>">
			<input name="TXT_CMAYOR1" type="hidden" value="<cfif isdefined("TXT_CMAYOR1")>#Form.TXT_CMAYOR1#</cfif>">
		</cfif>
	</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>