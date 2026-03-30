<!--- <cfdump var="#form#">
<cf_dump var="#url#">
 --->
<cfif isDefined("Form.btnNuevo")>
	<cfset Action = "PTU.cfm">
<cfelse>
	<cfset Action = "PTU.cfm">
</cfif>
<cfif isDefined("Form.chk") and isDefined("Form.btnEliminar")>
	<cfset Action = "PTU.cfm">
	<cftry>
		<cfset vchk = ListToArray(Form.chk)>
		<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
        	<cfquery name="rsVerificaBorrado" datasource="#Session.DSN#"> <!---SML Modificacion para guardar los calculos de PTU en su empresa correspondiente--->
				select count(1) as cantidad
				from RCalculoNomina
				where <!---Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and --->
                RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                and RCestado <> 3 <!--- No se pude eliminar una nomina que ya se pagó. --->
			</cfquery>
            <cfif rsVerificaBorrado.cantidad gt 0>
                <cfquery name="rsNomina" datasource="#Session.DSN#"> <!---SML Modificacion para guardar los calculos de PTU en su empresa correspondiente--->
                    select RChasta
                    from RCalculoNomina
                    where<!--- Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and---> RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>
                <cfquery datasource="#Session.DSN#">
                    delete Incidencias
                    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                      and Iespecial = 1
                      and exists( 	select 1
                                    from IncidenciasCalculo ic
                                    where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                                      and ic.Iid = Incidencias.Iid 
                                      and ic.RCNid = Incidencias.RCNid )
                </cfquery>	  
                    
                <cfquery datasource="#Session.DSN#">
                    delete IncidenciasCalculo 
                    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>
                
                <cfquery datasource="#Session.DSN#">
                    delete Incidencias
                    where RCNid is not null
                      and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                      and Iespecial = 1
                </cfquery>
                
                <cfquery datasource="#Session.DSN#">
                    delete PagosEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>
    
                <cfquery datasource="#Session.DSN#">
                    delete CargasCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>
                
                <cfquery datasource="#Session.DSN#">
                    delete DeduccionesCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>	
    
                <cfquery datasource="#Session.DSN#">
                    delete SalarioEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>				
                
                <cfquery datasource="#Session.DSN#">
                    delete RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
                </cfquery>
            </cfif>
		</cfloop>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>
    <form action="#Action#" method="post" name="sql">
        <input name="RHPTUEid" type="hidden" value="#form.RHPTUEid#">
        <input name="tab" type="hidden" value="5">
        
        <cfif not isDefined("Form.btnNuevo")>
            <input name="RCNid" type="hidden" value="#Form.RCNid#">
            <input name="Tcodigo" type="hidden" value="#Form.Tcodigo#">
        </cfif>
    </form>
</cfoutput>

<HTML>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>
