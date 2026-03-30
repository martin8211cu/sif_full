<cfsilent>
<cfparam name="Attributes.template" type="string" default="">

<cfif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'YES'>
	<cf_errorCode	code = "50717" msg = "cf_templatefooter no debe tener tag de cierre">
</cfif>

<cfif Not IsDefined('Request.templatefooterdata')>
	<cf_errorCode	code = "50718" msg = "cf_templateheader debe preceder a cf_templatefooter">
</cfif>
</cfsilent>
<cfoutput>#Request.templatefooterdata#</cfoutput>


<form name="x">
	<input type="text" name="xobj" value="" style="display:none">
</form>
<script type="text/javascript" language="javascript1.2">
	<cfset arreglo = listtoarray(session.porlets)>							
	NiftyLoad=function(){
	<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
		<cfset arreglo2 = listtoarray(arreglo[i],'|')>
		Nifty("<cfoutput>#arreglo2[1]#</cfoutput>","<cfoutput>#arreglo2[2]#</cfoutput>");
	</cfloop>
	}
</script>
<table width="980" height="42" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="140"  background="/cfmx/plantillas/Sapiens/css/sapiens/portlet/SoinA.gif"></td>
		<td width="600" bgcolor="1e2051" align="center">
		<cfoutput><font color="##FFFFFF">&##169;</font></cfoutput>
		<font color="#FFFFFF">SOIN, Soluciones Integrales 2010. Este producto está protegido por copyright y distribuido bajo
		licencias que restringen la copia, modificación, distribución y descompilación.</font></td>
		<td width="240" background="/cfmx/plantillas/Sapiens/css/sapiens/portlet/final1.gif">&nbsp;</td>
	</tr>
</table>



<cfset session.porlets ="">


