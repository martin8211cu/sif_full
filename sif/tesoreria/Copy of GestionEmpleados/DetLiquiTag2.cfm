<!---GASTOSEMPLEADOS--->

<table width="100%"  border="0">
 <tr><td>	<cfinclude template="LiquidacionAnticiposDet_lista.cfm">
 </td>
 <td><cfinclude template="LiquidacionAnticiposDet_form.cfm">
 </td>
 </tr>
	</table>
	 
		<td colspan="2"><hr></td>						
	  <
	  <tr>
		<td valign="top" width="50%">
			<cfset LvarIncluyeForm=true>
			<table width="100%">
			<tr><td>
		
			<cfinclude template="DetLiquidaciones.cfm"></td></tr></table>
		
		</td>
		<td valign="top" width="50%">
	<cfif isdefined('form.ID_det_liquidacion') and len(trim(form.ID_det_liquidacion))>
			<cfinclude template="LiquidacionAnticiposDet_form.cfm">
	</cfif>
		</td>
	  </tr>


