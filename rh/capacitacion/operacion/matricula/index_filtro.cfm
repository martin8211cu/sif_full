<!--- <cfif isdefined("Url.fRHPcodigo") and not isdefined("Form.fRHPcodigo")>
	<cfparam name="Form.fRHPcodigo" default="#Url.fRHPcodigo#">
</cfif> --->
<cfif isdefined("Url.fRHRCdescripcion") and not isdefined("Form.fRHRCdescripcion")>
	<cfparam name="Form.fRHRCdescripcion" default="#Url.fRHRCdescripcion#">
</cfif>
<cfif isdefined("Url.fRHRCestado") and not isdefined("Form.fRHRCestado")>
	<cfparam name="Form.fRHRCestado" default="#Url.fRHRCestado#">
</cfif>
<cfset filtro = "">
<cfset navegacion = "">
<!--- <cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and b.RHPcodigo = '" & Form.fRHPcodigo & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & Form.fRHPcodigo>
</cfif> --->
<cfif isdefined("Form.fRHRCdescripcion") and Len(Trim(Form.fRHRCdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHRCdescripcion) like '%" & UCase(Form.fRHRCdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHRCdescripcion=" & Form.fRHRCdescripcion>
</cfif>
<cfif isdefined("Form.fRHRCestado") and Len(Trim(Form.fRHRCestado)) NEQ 0>
 	<cfset filtro = filtro & " and RHRCestado = " & Form.fRHRCestado>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHRCestado=" & Form.fRHRCestado>
</cfif>

<form action="index.cfm" method="post" style="margin:0" name="form1">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <!--- <td>Puesto</td>
    <td>
		<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0>
			<cfquery name="rsPuestoLocal" datasource="#session.dsn#">
				select RHPcodigo as fRHPcodigo, RHPdescpuesto
				from RHPuestos
				where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fRHPcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cf_rhpuesto name="fRHPcodigo" query="#rsPuestoLocal#">
		<cfelse>
			<cf_rhpuesto name="fRHPcodigo">
		</cfif>
	</td> --->
    <td>Descripci&oacute;n</td>
    <td>
		<cfif isdefined("form.fRHRCdescripcion") and len(trim(form.fRHRCdescripcion)) gt 0>
			<cfoutput>
				<input tabindex="0" name="fRHRCdescripcion" type="text" value="#form.fRHRCdescripcion#" size="60" maxlength="60">
			</cfoutput>
		<cfelse>
			<input tabindex="0" name="fRHRCdescripcion" type="text" value="" size="60" maxlength="60">
		</cfif>
	</td>
    <td>Estado</td>
    <td>
		<select name="fRHRCestado" tabindex="0">
			<option value="">Todos</option>
			<option value="0" <cfif  isdefined("form.fRHRCestado") and form.fRHRCestado eq 0>selected</cfif>>En Captura</option>
			<option value="1" <cfif  isdefined("form.fRHRCestado") and form.fRHRCestado eq 1>selected</cfif>>Asociando Empleados</option>
			<option value="2" <cfif  isdefined("form.fRHRCestado") and form.fRHRCestado eq 2>selected</cfif>>Lista para Evaluar</option>
		</select>
	</td>
    <td><input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar"></td>
  </tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	var f = document.form1;
	f.fRHRCdescripcion.focus();
</script>