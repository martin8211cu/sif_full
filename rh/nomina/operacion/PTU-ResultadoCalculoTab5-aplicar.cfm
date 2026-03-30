<cfoutput>
    <form action="PTU-ResultadoCalculoTab5-lista.cfm" method="post" name="formRegresar">
        <input name="RCNid" type="hidden" value="#Form.RCNid#">
        <input name="RHPTUEid" type="hidden" value="#Form.RHPTUEid#">
        <input name="tab" type="hidden" value="5">
    </form>
</cfoutput>
<cfset Regresar="javascript: document.formRegresar.submit();">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
<br>
<cfinclude template="/rh/portlets/pRelacionCalculoPTU.cfm">
<cfinclude template="PTU-ResultadoCalculoTab5-aplicarForm.cfm">