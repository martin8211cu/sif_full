<cf_template>
<cf_templatearea name="title">Medios de Pago</cf_templatearea>
<cf_templatearea name="body">

	<cfset navegacion=ListToArray('index.cfm,Registro de Medios de Pago',';')>
<cfinclude template="../../pNavegacion.cfm">


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> 
  <td valign="top" width="45%"><cfinclude template="autorizador_list.cfm">
  </td>
  <td valign="top" width="10%">
  </td>
  <td valign="top" width="45%">
  <cfif isdefined("form.autorizador")>
  <cfinclude template="autorizador_p.cfm">
  </cfif>
  </td>
</tr>
</table>
</cf_templatearea>
</cf_template>