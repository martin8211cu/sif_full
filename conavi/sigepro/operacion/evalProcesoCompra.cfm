<title>Evaluación del Proceso de Compra -  SIGEPRO</title>
<cfif isdefined('url.tipo') and len(trim(#url.tipo#)) gt 0>
    <cfset LvarTipo = #url.tipo#>
<cfelseif isdefined('form.tipo') and len(trim(#form.tipo#)) gt 0>
    <cfset LvarTipo = #form.tipo#>
</cfif> 
	<cfif isdefined('url.proceso') and len(trim(#url.proceso#)) gt 0>
		<cfset LvarProceso = #url.proceso#>
	<cfelseif isdefined('form.proceso') and len(trim(#form.proceso#)) gt 0>	
		   <cfset LvarProceso = #form.proceso#>
	</cfif> 


	<cfif isdefined('url.solicitud') and len(trim(#url.solicitud#)) gt 0>
		<cfset LvarSolicitud = #url.solicitud#>
	<cfelseif isdefined('form.solicitud') and len(trim(#form.solicitud#)) gt 0>
	    <cfset LvarSolicitud = #form.solicitud#>
	</cfif> 
	
	<cfif isdefined('url.linea') and len(trim(#url.linea#)) gt 0>
		<cfset LvarLinea = #url.linea#>
	<cfelseif isdefined('form.linea') and len(trim(#form.linea#)) gt 0>
	 	<cfset LvarLinea = #form.linea#> 
	</cfif> 
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3">
		</td>
	</tr>
	<tr>				
		<td valign="top">
		  <cfif LvarTipo eq 'I'>
		     <cfinclude template="ItemProceso.cfm">
		  <cfelseif LvarTipo eq 'C'>
		     <cfinclude template="CotizacionProceso.cfm">
		 </cfif>
		</td>
	</tr>
	<tr> 
	  <td align="center">&nbsp; 
         
	  </td>
	</tr>
	<tr> 

	</tr>
</table>	

