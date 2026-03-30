<form name="form1" method="post" style="margin: 0;">
	<cfoutput>
		<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />	
		<cfinclude template="agente-hiddens.cfm">
		<cfset ExisteInfoServ = true>
		<cfset desplTodos = 1>		
		
		<table width="100%"  border="0"  cellspacing="0" cellpadding="0">
		  <tr>
			<td><cfinclude template="../../cliente/gestion/gestion-infoServicios.cfm"></td>
		  </tr>
		</table>
	</cfoutput>		
</form>		
