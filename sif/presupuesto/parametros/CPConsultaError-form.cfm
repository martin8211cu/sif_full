<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Regresar = t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>

<cfif isdefined("form.CPPid")>
	<cfset vs_CPPid = "#form.CPPid#">
<cfelse>
	<cfset vs_CPPid = "">
</cfif>

<cfquery name="rsErrores" datasource="#Session.DSN#">
	select Linea,Mensaje from MensAplCompromiso
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    order by Linea
</cfquery>

<cfoutput>
<form method="post" name="form1" action="CPCompromisoAut.cfm" style="margin: 0;">
	<table>
        <tr>
            <td >
                <strong>Linea</strong>:&nbsp;
            </td>
            <td>
                <strong>Mensaje</strong>:&nbsp;
            </td>
        </tr>
        <cfloop query="rsErrores">
            <tr>
                <td>#rsErrores.Linea#</td>
                <td>#rsErrores.Mensaje#</td>
            </tr>
        </cfloop>
        <tr>    
        	<td colspan="6" align="center">
          		<input type="button" name="btnRegresarErr" value="#BTN_Regresar#" onclick="javascript: location.href='CPCompromisoAut.cfm';">
            </td>
        </tr>
	</table>
    <!---<input type="hidden" name="CPCCid" value="#vs_CPCCid#">--->
    <input type="hidden" name="CPPid"  value="#vs_CPPid#">
</form>
</cfoutput>
