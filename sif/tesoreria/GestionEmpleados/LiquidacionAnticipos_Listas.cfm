<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default = "Nuevo" returnvariable="BTN_Nuevo" xmlfile = "LiquidacionAnticipos_Listas.xml">

<cfset LvarTipoDocumento = 7>
<cf_GE_lista tipo="#LvarTipoDocumento#" irA="#LvarSAporEmpleadoCFM#" Estado="0" PorEmpleado="#isdefined("LvarSAporEmpleado")#" PorSolicitante="#isdefined("LvarSAporEmpleadoSolicitante")#">
 
<cfif NOT LvarSAporComision>
<table width="100%" border="0">
  <tr><td align="center">  
    <form name="formRedirec" method="post" action="<cfoutput>#LvarSAporEmpleadoCFM#</cfoutput>" style="margin: '0' ">
		<cfoutput><input name="Nuevo" type="submit" value="#BTN_Nuevo#" tabindex="2"></cfoutput>
    </form>  
  </td></tr>    
 </table>
</cfif>
