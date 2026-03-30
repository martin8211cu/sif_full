<cfset Lvar_FAMcodigo = "">
<cfset Lvar_FAMdescripcion = "">
<cfif isdefined("url.FAMcodigo") and len(trim(url.FAMcodigo)) 
			and (
			 (not isdefined("form.FAMcodigo"))
			 or 
			 (isdefined("form.FAMcodigo") and len(trim(url.FAMcodigo)) EQ 0)
			)>
		<cfset form.FAMcodigo = url.FAMcodigo>
</cfif>
<cfif isdefined("url.FAMdescripcion") and len(trim(url.FAMdescripcion)) 
			and (
			 (not isdefined("form.FAMdescripcion"))
			 or 
			 (isdefined("form.FAMdescripcion") and len(trim(url.FAMdescripcion)) EQ 0)
			)>
		<cfset form.FAMdescripcion = url.FAMdescripcion>
</cfif>
<cfset nav = "">
<cfif isdefined("form.FAMcodigo") and len(trim(form.FAMcodigo))>
	<cfset Lvar_FAMcodigo = form.FAMcodigo>
	<cfset nav = nav & "&FAMcodigo=#form.FAMcodigo#">
</cfif>
<cfif isdefined("form.FAMdescripcion") and len(trim(form.FAMdescripcion))>
	<cfset Lvar_FAMdescripcion = form.FAMdescripcion>
	<cfset nav = nav & "&FAMdescripcion=#form.FAMdescripcion#">
</cfif>
<cfoutput>
<form action="cierresup.cfm" method="post" style="margin:0" name="form1">
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td align="right">Código</td>
    <td align="left">
		<input tabindex="0" name="FAMcodigo" type="text" value="#Lvar_FAMcodigo#" size="30" maxlength="30">
	</td>
    <td align="right">Descripción</td>
    <td align="left">
		<input tabindex="0" name="FAMdescripcion" type="text" value="#Lvar_FAMdescripcion#" size="40" maxlength="40">
	</td>
    <td><center><input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar"></center></td>
  </tr>
</table>
</form>
</cfoutput>