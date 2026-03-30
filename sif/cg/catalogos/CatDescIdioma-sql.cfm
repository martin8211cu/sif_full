<cfset Action = "CatDescIdioma.cfm">
<!---<cf_dump var="#form#">--->
<cfset MODO = "ALTA">

<!--- si viene definido el boton de nuevo regresa al form en modo ALTA --->
<cfif not (isDefined("form.btnNuevoI"))>
	<cfif isDefined("form.Alta")>
        <cftransaction>			
            <cfquery name="ABC_PCDCatalogoIdioma" datasource="#Session.DSN#">
                insert into PCDCatalogoIdioma(PCEcatid ,PCDcatid, Iid, PCDdescripcionI , BMUsucodigo)	
                values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Idioma#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descrip#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
            </cfquery>
        </cftransaction>
		<cfset MODO = "CAMBIO">
	<cfelseif isDefined("form.Cambio")> 
    	<cfset MODO = "CAMBIO">
        <cftransaction>		
 				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="PCDCatalogoIdioma" 
					redirect="#Action#"
					timestamp="#form.ts_rversion#"
					field1="PCEcatid,numeric,#form.PCEcatid#"
                    field2="PCDcatid,numeric,#form.PCDcatid#"
                    field3="Iid,numeric,#form.Idioma#">
                    
           <cfquery name="ABC_PCDCatalogoIdioma" datasource="#Session.DSN#">
                update PCDCatalogoIdioma 
                set	
                    PCDdescripcionI = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descrip#">,
                    BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                where 
                    PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#"> and
                    PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#"> and
                    Iid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Idioma#">
            </cfquery>			
        
		</cftransaction>
        
	<cfelseif isDefined("form.Baja")>
        <cftransaction>			
            <cfquery name="ABC_PCDCatalogoIdioma" datasource="#Session.DSN#">
                delete PCDCatalogoIdioma 
                where 
                    PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#"> and
                    PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#"> and
                    Iid      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Idioma#">
            </cfquery>
        </cftransaction>
	</cfif>
</cfif>


<form action="<cfoutput>#Action#</cfoutput>" method="post" name="form1">
	<cfoutput>
    <input name="PCEcatid" 	type="hidden" value="#form.PCEcatid#">
    <input name="PCDcatid" 	type="hidden" value="#form.PCDcatid#">
    <input type="hidden" name="PCEcodigo" value="#form.PCEcodigo#">
    <input type="hidden" name="PCDvalor" value="#form.PCDvalor#">
    <input type="hidden" name="PCDdescripcion" value="#form.PCDdescripcion#">
	<cfif MODO EQ "CAMBIO">
        <input name="Iid" 		type="hidden" value="#form.Idioma#">
	</cfif>
	</cfoutput>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>