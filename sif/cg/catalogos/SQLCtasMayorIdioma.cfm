<cfset Action = "CtasMayorIdioma.cfm">
<!---<cf_dump var="#form#">--->
<cfset modoI = "ALTA">

<!--- si viene definido el boton de nuevo regresa al form en modo ALTA --->
<cfif not (isDefined("form.btnNuevoI"))>
	<cfif isDefined("form.Alta")>
        <cftransaction>			
            <cfquery name="ABC_CtasMayorIdioma" datasource="#Session.DSN#">
                insert into CtasMayorIdioma(Ecodigo ,Cmayor, Iid, CdescripcionMI)	
                values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Idioma#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CdescripcionMI#">)
            </cfquery>
        </cftransaction>
		<cfset modoI = "CAMBIO">
	<cfelseif isDefined("form.Cambio")> 
    	<cfset modoI = "CAMBIO">
        <cftransaction>		
           <cfquery name="ABC_CtasMayorIdioma" datasource="#Session.DSN#">
                update CtasMayorIdioma 
                set	
                    CdescripcionMI = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CdescripcionMI#">
                where 
                    Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> and
                    Cmayor 	= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#"> and
                    Iid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Idioma#">
            </cfquery>			
		</cftransaction>
        
	<cfelseif isDefined("form.Baja")>
        <cftransaction>			
            <cfquery name="ABC_CtasMayorIdioma" datasource="#Session.DSN#">
                delete CtasMayorIdioma 
                where 
                    Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> and
                    Cmayor 	= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#"> and
                    Iid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Idioma#">
            </cfquery>
        </cftransaction>
	</cfif>
</cfif>


<form action="<cfoutput>#Action#</cfoutput>" method="post" name="form1">
	<cfoutput>
    <input name="Cmayor" 	type="hidden" value="#form.Cmayor#">
 	<input type="hidden" name="Cdescripcion" value="#Form.Cdescripcion#" />
    
	<cfif modoI EQ "CAMBIO">
        <input name="Iid" 		type="hidden" value="#form.Idioma#">
	</cfif>
	</cfoutput>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>