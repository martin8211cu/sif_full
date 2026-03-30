<cfparam name="FORM.SEL" type="numeric">
<cfquery name="rs_evaluacion_header" datasource="#session.DSN#">
	select REdescripcion, REdesde
	from RHRegistroEvaluacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and REid = <cfif isdefined("form.REid") and len(trim(form.REid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"><cfelse>0</cfif>
</cfquery>
<cfswitch expression="#FORM.SEL#">
	<cfcase value="1"><cfset vTitulo = "Registro de la Relaci&oacute;n"></cfcase>
	<cfcase value="2"><cfset vTitulo = "Indicaciones"></cfcase>
	<cfcase value="3"><cfset vTitulo = "Conceptos"></cfcase>
	<cfcase value="4"><cfset vTitulo = "Grupos"></cfcase>
	<cfcase value="5"><cfset vTitulo = "Lista de Empleados"></cfcase>
	<cfcase value="6"><cfset vTitulo = "Lista de Evaluadores"></cfcase>
	<cfcase value="7"><cfset vTitulo = "Publicar Evaluaci&oacute;n"></cfcase>	
</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion" valign="middle" style="border-bottom:1px solid gray;" ><strong><font color="##000099">#vTitulo#</font></strong></td>
  </tr>
  <cfif rs_evaluacion_header.RecordCount gt 0>
  <tr>
    <td class="subtitulo_seccion_small" align="left"><strong><font color="##000099">#rs_evaluacion_header.REdescripcion#&nbsp;Vigencia&nbsp;#LSDateFormat(rs_evaluacion_header.REdesde,'dd/mm/yyyy')#</font></strong></td>
  </tr>
  </cfif>
</table>
</cfoutput>
