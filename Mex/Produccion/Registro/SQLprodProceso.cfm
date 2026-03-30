<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 28-7-2010.	
 --->
 
<cfif isDefined("Form.Aceptar")>
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertProceso" >		
		<cfargument name="pOTcodigo"   	type="string" required="true">
		<cfargument name="pOTseq"      	type="numeric" required="true">
		<cfargument name="pAPcodigo" 	type="numeric" required="true">
		<cfargument name="pChecked" 	type="numeric" required="true">
        
		<cfquery name="rsProdproceso" datasource="#Session.DSN#">
			select 1 
			from Prod_Proceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
             and OTseq    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">
		</cfquery>
        <cfif "#Arguments.pChecked#" EQ 1>
			<cfif isdefined('rsProdproceso') and rsProdproceso.recordCount EQ 0>
                <cfquery datasource="#Session.DSN#">
                    insert INTO Prod_Proceso (Ecodigo, OTcodigo,OTseq, APcodigo)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#"> 
                        )
                </cfquery>
            <cfelse>
                <cfquery datasource="#Session.DSN#">
                    update Prod_Proceso
                        set APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
                        and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                        and OTseq    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">	
                </cfquery>				
            </cfif>
		<cfelse>
        	<cfif isdefined('rsProdproceso') and rsProdproceso.recordCount NEQ 0>
            	<cfquery datasource="#Session.DSN#">
                    Delete Prod_Proceso
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
                        and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                        and OTseq    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pOTseq#">	
                </cfquery>
            </cfif>
        </cfif>
		<cfreturn true>
	</cffunction>
    
	<cftransaction>
	<cftry>	
        <cfloop from="1" to="#form.NprodArea#" index="id"> 
        	<cfset vOrden = "Orden#id#">
            <cfset vAPcodigo ="APCodigo#id#">
            
            <cfif isdefined("form.chk#id#")>
            	<cfset vArreglo = 1>
            <cfelse> 
				<cfset vArreglo = 0>
            </cfif>
            
<!---<cfif isdefined("form.Orden#id#") and len(trim(form['#vOrden#']))>  
<cfelse>         
<cf_dump var=#form['#vOrden#']#>
</cfif>
--->            
			<cfif isdefined("form.Orden#id#") and len(trim(form['#vOrden#'])) and isdefined("form.APCodigo#id#")>
				<cfset b = insertProceso(#form.OTcodigo#,#form['#vOrden#']#,#form['#vAPCodigo#']#,#vArreglo#)>
            </cfif>
		</cfloop>
	<cfcatch type="database">
		<cfinclude template="../../../sif/errorPages/BDerror.cfm"
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
    
</cfif>
<form action="RegOrdenTr.cfm" method="post" name="sql">
<input type="hidden" name="OTCodigo" value="<cfif isdefined("Form.OTcodigo")><cfoutput>#Form.OTcodigo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>


<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
