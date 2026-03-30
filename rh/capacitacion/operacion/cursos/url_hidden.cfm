<cfinclude template="url_params.cfm">

<cfoutput>
<input type="hidden" name="filtro_RHIAid" value="#HTMLEditFormat(url.filtro_RHIAid)#">
<input type="hidden" name="filtro_RHGMid" value="#HTMLEditFormat(url.filtro_RHGMid)#">
<input type="hidden" name="filtro_RHACid" value="#HTMLEditFormat(url.filtro_RHACid)#">
<input type="hidden" name="filtro_Mnombre" value="#HTMLEditFormat(url.filtro_Mnombre)#">
<input type="hidden" name="filtro_RHCfdesde" value="#HTMLEditFormat(url.filtro_RHCfdesde)#">
<input type="hidden" name="filtro_RHCfhasta" value="#HTMLEditFormat(url.filtro_RHCfhasta)#">
<input type="hidden" name="filtro_RHCcupo" value="#HTMLEditFormat(url.filtro_RHCcupo)#">
<input type="hidden" name="filtro_disponible" value="#HTMLEditFormat(url.filtro_disponible)#">
</cfoutput>

