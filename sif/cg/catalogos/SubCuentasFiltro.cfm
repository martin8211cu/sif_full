<cfif isdefined("Url.Cmayor") and not isdefined("Form.Cmayor")>
	<cfparam name="Form.Cmayor" default="#Url.Cmayor#">
</cfif>
<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>
<cfif isdefined("Url.Ctipo") and not isdefined("Form.Ctipo")>
	<cfparam name="Form.Ctipo" default="#Url.Ctipo#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor)) NEQ 0>
	<cfset filtro = filtro & " and upper(Cmayor) like '%" & #UCase(Form.Cmayor)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Cmayor=" & Form.Cmayor>
</cfif>
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & #UCase(Form.Cdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Cdescripcion=" & Form.Cdescripcion>
</cfif>
<cfif isdefined("Form.Ctipo") and Len(Trim(Form.Ctipo)) NEQ 0>
	<cfset filtro = filtro & " and Ctipo = '" & Trim(Form.Ctipo) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ctipo=" & Form.Ctipo>
</cfif>

<cfoutput>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<form name="filtroCuentasMayor" method="post" action="#CurrentPage#">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td align="right" class="etiquetaCampo">Cuenta : 
		
	</td>
    <td>
		<input name="Cmayor" type="text" size="10" maxlength="4" <cfif isdefined("form.Cmayor") and len(trim(form.Cmayor)) gt 0>value="#form.Cmayor#"</cfif>>
	</td>
    <td align="right" class="etiquetaCampo">Descripci&oacute;n : 
		<input name="Cdescripcion" type="text" size="80" maxlength="80" <cfif isdefined("form.Cdescripcion") and len(trim(form.Cdescripcion)) gt 0>value="#form.Cdescripcion#"</cfif>>
	</td>
    <td>
		
	</td>
    <td align="right" class="etiquetaCampo">Tipo : 
		<select name="Ctipo">
			<option value=""></option>
			<option value="A" <cfif isdefined("form.Ctipo") and form.Ctipo eq "A">selected</cfif>>Activo</option>
			<option value="P" <cfif isdefined("form.Ctipo") and form.Ctipo eq "P">selected</cfif>>Pasivo</option>
			<option value="C" <cfif isdefined("form.Ctipo") and form.Ctipo eq "C">selected</cfif>>Capital</option>
			<option value="I" <cfif isdefined("form.Ctipo") and form.Ctipo eq "I">selected</cfif>>Ingreso</option>
			<option value="G" <cfif isdefined("form.Ctipo") and form.Ctipo eq "G">selected</cfif>>Gasto</option>
			<option value="O" <cfif isdefined("form.Ctipo") and form.Ctipo eq "O">selected</cfif>>Orden</option>
		</select>		
	</td>
    <td>
		
	</td>
    <td align="center"><input name="Filtrar" type="submit" value="Filtrar"></td>
  </tr>
</table>
</form>
</cfoutput>