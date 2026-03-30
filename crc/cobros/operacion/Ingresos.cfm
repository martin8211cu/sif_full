<cfset LvarPagina ="Ingresos.cfm">
<cfset LvarSQLPagina ="Ingresos_sql.cfm">
<cfset LvarTransaccionPagina ="TransaccionesCRC.cfm">
<cfinclude template="/sif/fa/operacion/listaTransaccionesFA.cfm">


<cfif isdefined('url.ET') && trim(url.ET) neq ''>
    <cfoutput>
        <script>
            window.open('ticketPago.cfm?ET=#url.ET#');
        </script>
    </cfoutput>
</cfif>