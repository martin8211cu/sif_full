<cf_template>
<cf_templatearea name="title">Mi cuenta</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
<cfparam name="url.sect" default="1">
<cfif ListFind("1,2,3,4", url.sect) EQ 0><cfset url.sect = 1></cfif>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_MiCuenta"
Default="Mi Cuenta"
returnvariable="LB_MiCuenta"/>

<cf_web_portlet_start titulo="#LB_MiCuenta#">

<cfif not isdefined('verLista')>
	<cfset verLista = 1>	
</cfif>

 <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td>
		<cfif verLista EQ 1>
			<cfinclude template="buzon-listaMensajes.cfm">
		<cfelse>
			<cfinclude template="buzon-verMensaje.cfm">
		</cfif>	
	</td>
  </tr>
</table>

<cf_web_portlet_end>

</cf_templatearea>
</cf_template>
