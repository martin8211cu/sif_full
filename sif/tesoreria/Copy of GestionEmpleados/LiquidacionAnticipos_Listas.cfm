 <cfset LvarTipoDocumento = 7>
<cf_GE_lista tipo="#LvarTipoDocumento#" irA="#LvarSAporEmpleadoCFM#" Estado="0" AprobacionL="false" PorEmpleado="#isdefined("LvarSAporEmpleado")#">
 
<cfif NOT LvarSAporComision>
<table width="100%" border="0">
  <tr><td align="center">  
    <form name="formRedirec" method="post" action="<cfoutput>#LvarSAporEmpleadoCFM#</cfoutput>" style="margin: '0' ">
		<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
    </form>  
  </td></tr>    
 </table>
</cfif>
