<cf_templateheader title="Mantenimiento Otros Patronos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo Otros Patronos'>
		<cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>			
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 		
			<td valign="top">
			  	<cfinclude template="formMantOtrosPatronos.cfm">
			 </td>		
	 	 </tr>
		<tr>
			<td>
				<form name="formback" action="SalariosOtrosPatronos.cfm">
					<center>
						<input type="submit" name="Regresar" 	class="btnAnterior" 	value="Ir a Salarios Otros Patronos" tabindex="1" >
					</center>	
				</form>	
			</td>
		</tr>	
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
