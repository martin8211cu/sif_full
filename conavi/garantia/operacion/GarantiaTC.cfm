<cfif isdefined('url.TCsug')>
	<cfparam name="arguments.TCxUsar" default="V" type="string">
	<cfquery name="rsLocal" datasource="#session.dsn#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfif rsLocal.Mcodigo eq url.CODGMcodigo>
		<cfset LvarTC = 1.00>
	<cfelse>
    	<cfquery name="rsTC" datasource="#session.DSN#">
            select TCventa, TCcompra
            from Htipocambio
            where Mcodigo = #url.CODGMcodigo#
              and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#url.CODGFecha#">
              and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#url.CODGFecha#">
        </cfquery>
    	<cfif rsTC.recordcount eq 0>
            <cfquery name="rsMiso" datasource="#session.dsn#">
                select Miso4217
                from Monedas 
                where Mcodigo = #url.CODGMcodigo#
            </cfquery>
            <cfthrow message="No se ha incluido un tipo de cambio para la moneda '#rsMiso.Miso4217#' en la fecha #url.CODGFecha#">
        </cfif>
        
        <cfif arguments.TCxUsar eq 'V'>
            <cfset LvarTC = rsTC.TCventa>
        <cfelse>
            <cfset LvarTC = rsTC.TCcompra>
        </cfif>
    </cfif>

    <cfoutput>
        <script language="javascript">
            parent.document.form2.CODGTipoCambio.value = "#numberformat(LvarTC,",9.0000")#";
            parent.document.form2.TCsug.value		 = "#numberformat(LvarTC,",9.0000")#";
        </script>
    </cfoutput>
    <cfabort>
</cfif>