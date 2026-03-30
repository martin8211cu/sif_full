<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 29-7-2010.	
 --->
 

<cftransaction>
<cftry>	
    <cfif isdefined("form.OTcodigo")>
        <cfif isDefined("Form.Aceptar")> 
        
        <cfquery name="rsSiguiente" datasource="#Session.DSN#">
            select isnull(max(AAconsecutivo),0)+1 as siguiente
            from Prod_OTArchivo
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
             and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">	
        </cfquery>
        <cfquery datasource="#Session.DSN#">
            insert INTO Prod_OTArchivo (Ecodigo,OTcodigo,AAcontenido,AAnombre,AAdefaultpre,AAconsecutivo,BMUsucodigo,BMfecha)
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">, 
                <cf_dbupload filefield="logo" accept="image/*">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.clientfile#">, 
                0,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSiguiente.siguiente#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                )
        </cfquery>
	<cfelse>
            <cfif isDefined("Form.EliminarArchivo")>
                <cfquery datasource="#Session.DSN#">
                delete Prod_OTArchivo
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and OTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">	
                </cfquery>
            </cfif>
        </cfif>
    </cfif>
<cfcatch type="database">
    <cfinclude template="../../sif/errorPages/BDerror.cfm">
    <cfabort>
</cfcatch>
</cftry>
</cftransaction>

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
