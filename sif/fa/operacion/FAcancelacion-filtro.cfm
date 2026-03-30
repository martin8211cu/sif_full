

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>
<cfoutput>
<form style="margin: 0" action="FAcancelacion.cfm" name="form1" method="post">
<!---<input type="hidden" name="tipoCoti" value="#form.tipoCoti#">	Se quita ya no se usa el tipo de Coti --->
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	<tr>
		<td width="118" align="right" nowrap><strong>Documento:</strong></td>
		<td width="90" align="left">
			<input name="PFdocumento" type="text" id="PFdocumento" <cfif isdefined('form.PFdocumento')> value="#form.PFdocumento#"</cfif> style="text-align: right" size="20" maxlength="20" tabindex="1">
		</td>
		<td width="79" align="right"><strong>Socio:</strong></td>
		<td width="180" align="left"  colspan="3">
			<cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo))>
           		<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C"  size="55" idquery="#form.SNcodigo#">
				   
	        <cfelse>
			    <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C" size="55" frame="frame2">
       	    </cfif>			
		</td>
		
		
		<td width="16"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
    </tr>

 </table>
</form>
</cfoutput>
