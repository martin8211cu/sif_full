<cfset IDtrans = 6>
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
	<cfquery name="rsValidaMascaraAutomatica" datasource="#session.dsn#">
            select Pvalor from Parametros
            where Pcodigo = 200050
	</cfquery>
    
     <cfif isdefined("rsValidaMascaraAutomatica") and rsValidaMascaraAutomatica.Pvalor EQ 1>
		<cfset IDtrans = 200050>
	</cfif>
<cfinclude template="agtProceso_listaGrupos.cfm">