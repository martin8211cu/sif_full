<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>
	<cfset form.RCNid = url.RCNid>
</cfif>

<cfif not isdefined("form.RCNid") or (isdefined("form.RCNid") and len(trim(form.RCNid)) eq 0)>
    <cfquery name="rsRCN" datasource="#session.DSN#">
        select b.RCNid
        from RHPTUE a
	        inner join RCalculoNomina b
           	  on b.RHPTUEid = a.RHPTUEid
        where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
          and a.Ecodigo = #session.Ecodigo#
    </cfquery>
    <cfset form.RCNid = rsRCN.RCNid>
    <cfset form.Regresar = 'Relacion'>
    
</cfif>


<cfif isdefined("url.Regresar") and not isdefined("form.Regresar")>
	<cfset form.Regresar = url.Regresar>
</cfif>

<cfset navegacion = "RHPTUEid=" & Form.RHPTUEid>
<!--- <cfset navegacion = navegacion & "&tab=5"> --->
<cfset LvarPantalla1 = ''>
<cfset LvarPantalla2 = ''>

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<cfif isdefined("form.RCNid") and len(trim(form.RCNid))>
	<cfif isdefined("form.Regresar") and form.Regresar eq 'Relacion' and not isdefined("form.CPid")>
    	<cfset LvarPantalla1 = 'PTU-RelacionCalculoTab5-lista.cfm'>
        <cfset LvarPantalla2 = 'PTU-RelacionCalculoTab5-form.cfm'>
	<cfelseif isdefined("form.CPid") and isdefined("form.CPid")>
	    <cfset LvarPantalla1 = 'PTU-ResultadoCalculoTab5.cfm'>
    <cfelseif isdefined("form.Accion") and form.Accion eq "Aplicar">
    	<cfset LvarPantalla1 = 'PTU-ResultadoCalculoTab5-aplicar.cfm'>
    <cfelse>
    	<cfset LvarPantalla1 = 'PTU-ResultadoCalculoTab5-listaForm.cfm'>
    </cfif>
<cfelse>
	<cfset LvarPantalla1 = 'PTU-RelacionCalculoTab5-lista.cfm'>
    <cfset LvarPantalla2 = 'PTU-RelacionCalculoTab5-form.cfm'>
</cfif>

<!---<cfdump var="#form#">
<cfdump var="#url#"> --->

<!--- <cfdump var="LvarPantalla 1 = #LvarPantalla1#">
<cfdump var="LvarPantalla 2 = #LvarPantalla2#"> --->  

<table width="100%" cellpadding="1" cellspacing="1">
	<tr>
    	<td width="25%">
        	<cfinclude template="#LvarPantalla1#">
        </td>
        <td width="75%">
        	<cfif len(trim(LvarPantalla2))>
            	<cfinclude template="#LvarPantalla2#">
            <cfelse>
            	&nbsp;
            </cfif>
        	
        </td>
    </tr>
</table>
