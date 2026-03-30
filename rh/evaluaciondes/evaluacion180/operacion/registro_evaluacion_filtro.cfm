<cfif isdefined("Url.fREdescripcion") and not isdefined("Form.fREdescripcion")>
	<cfparam name="Form.fREdescripcion" default="#Url.fREdescripcion#">
</cfif>
<cfif isdefined("Url.fREestado") and not isdefined("Form.fREestado")>
	<cfparam name="Form.fREestado" default="#Url.fREestado#">
</cfif>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fREdescripcion") and Len(Trim(Form.fREdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(REdescripcion) like '%" & UCase(Form.fREdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fREdescripcion=" & Form.fREdescripcion>
</cfif>
<cfif isdefined("Form.fREestado") and Len(Trim(Form.fREestado)) NEQ 0>
 	<cfset filtro = filtro & " and REestado = " & Form.fREestado>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fREestado=" & Form.fREestado>
</cfif>

<form action="registro_evaluacion.cfm" method="post" style="margin:0" name="form1">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td><cf_translate key="LB_Descripcion" xmlfile="/rh/generales.xml">Descripción</cf_translate></td>
    <td>
		<cfif isdefined("form.fREdescripcion") and len(trim(form.fREdescripcion)) gt 0>
			<cfoutput>
				<input tabindex="0" name="fREdescripcion" type="text" value="#form.fREdescripcion#" size="60" maxlength="60">
			</cfoutput>
		<cfelse>
			<input tabindex="0" name="fREdescripcion" type="text" value="" size="60" maxlength="60">
		</cfif>
	</td>
<!---
    <td><cf_translate key="LB_Estado" >Estado</cf_translate></td>
    <td>
		<select name="fREestado" tabindex="0">
			<option value="">Todos</option>
			<option value="0" <cfif  isdefined("form.fREestado") and form.fREestado eq 0>selected</cfif>>En Captura</option>
			<option value="1" <cfif  isdefined("form.fREestado") and form.fREestado eq 1>selected</cfif>>Asociando Empleados</option>
			<option value="2" <cfif  isdefined("form.fREestado") and form.fREestado eq 2>selected</cfif>>Lista para Evaluar</option>
		</select>
	</td>
--->	
    <td><input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar"></td>
  </tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	var f = document.form1;
	f.fREdescripcion.focus();
</script>