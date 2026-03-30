<cfquery name="rs1" datasource="sifinterfaces">
	select FechaDocumento
    from IE10
    where ID = 623087
</cfquery>


<!--- 
<cfquery name="rs1" datasource="minisif">
	select Fecha as FechaDocumento
    from TFecha
</cfquery>
 --->

<cfif rs1.recordcount gt 0>
	<cfset Lvarrs = fnFecha(rs1.FechaDocumento)>
    <cfdump var="#Lvarrs#">
<cfelse>
	<cfoutput>No se encontró el Id 623087 en la tabla IE10 de sif_interfaces</cfoutput>
</cfif>


<cffunction name="fnFecha" access="public" output="yes" returntype="any">
	<cfargument name="tcFecha" type="date" required="yes">
    
    <cfquery name="rsP" datasource="minisif">
        select Pvalor as Mcodigo 
          from Parametros 
         where Ecodigo = 8
           and Pcodigo = 441
    </cfquery>
    <cfset LvarCOSTOS.VALUACION.Mcodigo = rsP.Mcodigo>
    
    
    <cfquery name="rs" datasource="minisif">
        select *
          from Htipocambio tc
         where tc.Ecodigo =  8
           and tc.Mcodigo =  #LvarCOSTOS.VALUACION.Mcodigo#
           and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.tcFecha#">
           and tc.Hfechah  >  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.tcFecha#">
    </cfquery>
    <cfreturn rs>
</cffunction>