<cfcomponent>

	<cffunction access="private" name="getEmpleados">
	    <cfargument name="DEnombre" type="string" required="no" default="">
    	<cfquery datasource="minisif" name="rsEmp" maxrows="10">
        	select DEid,DEidentificacion,DEnombre,DEapellido1,DEapellido2,DEfechanac
            from DatosEmpleado
            <cfif len(trim(arguments.DEnombre))>
            where upper(DEnombre) like '%#ucase(arguments.DEnombre)#%'
            </cfif>
        </cfquery>
        <cfreturn rsEmp>
    </cffunction>
    
    
   	<cffunction name="getEmpleadosJSON"  access="remote" returnformat="json">
    	<cfargument name="DEnombre" type="string" required="no" default="">
        <cfreturn getEmpleados(arguments.DEnombre)>
    </cffunction>

    <cffunction name="getEmpleadosTable" returntype="string" access="remote">
    	<cfargument name="DEnombre" type="string" required="no" default="">
        
    	<table>
        <tr>
        	<td>DEnombre</td>
            <td>DEidentificacion</td>
            <td>DEapellido1</td>
            <td>DEapellido2</td>
            <td>DEfnac</td>
        </tr>
        <cfoutput>
    	<cfloop query="#getEmpleados(arguments.DEnombre)#">
        <tr>
        	<td>#DEnombre#</td>
            <td>#DEidentificacion#</td>
            <td>#DEapellido1#</td>
            <td>#DEapellido2#</td>
            <td>#dateformat(DEfechanac,'dd/mm/yyyy')#</td>
        </tr>
        </cfloop>
        </table>
        </cfoutput>
    </cffunction>
    
</cfcomponent>