<cfif isdefined("Url.fRHEEdescripcion") and not isdefined("Form.fRHEEdescripcion")>
	<cfparam name="Form.fRHEEdescripcion" default="#Url.fRHEEdescripcion#">
</cfif>
<cfif isdefined("Url.fRHEEestado") and not isdefined("Form.fRHEEestado")>
	<cfparam name="Form.fRHEEestado" default="#Url.fRHEEestado#">
</cfif>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fRHEEdescripcion") and Len(Trim(Form.fRHEEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHEEdescripcion) like '%" & UCase(Form.fRHEEdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHEEdescripcion=" & Form.fRHEEdescripcion>
</cfif>
<cfif isdefined("Form.fRHEEestado") and Len(Trim(Form.fRHEEestado)) NEQ 0>
 	<cfset filtro = filtro & " and RHEEestado = " & Form.fRHEEestado>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHEEestado=" & Form.fRHEEestado>
</cfif>

<form action="registro_evaluacion.cfm" method="post" style="margin:0" name="form1">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripción</cf_translate></td>
    <td>
		<cfif isdefined("form.fRHEEdescripcion") and len(trim(form.fRHEEdescripcion)) gt 0>
			<cfoutput>
				<input tabindex="0" name="fRHEEdescripcion" type="text" value="#form.fRHEEdescripcion#" size="60" maxlength="60">
			</cfoutput>
		<cfelse>
			<input tabindex="0" name="fRHEEdescripcion" type="text" value="" size="60" maxlength="60">
		</cfif>
	</td>
    <td><cf_translate key="LB_Estado" XmlFile="/rh/generales.xml">Estado</cf_translate></td>
    <td>
		<select name="fRHEEestado" tabindex="0">
			<option value=""><cf_translate key="CMB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></option>
			<option value="0" <cfif  isdefined("form.fRHEEestado") and form.fRHEEestado eq 0>selected</cfif>><cf_translate key="CMB_EnCaptura">En Captura</cf_translate></option>
			<option value="1" <cfif  isdefined("form.fRHEEestado") and form.fRHEEestado eq 1>selected</cfif>><cf_translate key="CMB_AsociandoEmpleados">Asociando Empleados</cf_translate></option>
			<option value="2" <cfif  isdefined("form.fRHEEestado") and form.fRHEEestado eq 2>selected</cfif>><cf_translate key="CMB_ListaParaEvaluar">Lista para Evaluar</cf_translate></option>
		</select>
	</td>
    <td>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>		
		<input tabindex="0" name="btnBuscar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
	</td>
  </tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	var f = document.form1;
	f.fRHEEdescripcion.focus();
</script>