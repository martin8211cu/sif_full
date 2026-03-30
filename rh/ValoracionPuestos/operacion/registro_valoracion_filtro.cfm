<cfif isdefined("Url.fRHVPdescripcion") and not isdefined("Form.fRHVPdescripcion")>
	<cfparam name="Form.fRHVPdescripcion" default="#Url.fRHVPdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fRHVPdescripcion") and Len(Trim(Form.fRHVPdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHVPdescripcion) like '%" & UCase(Form.fRHVPdescripcion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHVPdescripcion=" & Form.fRHVPdescripcion>
</cfif>


<form action="registro_valoracion.cfm" method="post" style="margin:0" name="form1">
<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" class="areafiltro">
  <tr>
    <td><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripción</cf_translate></td>
    <td>
		<cfif isdefined("form.fRHVPdescripcion") and len(trim(form.fRHVPdescripcion)) gt 0>
			<cfoutput>
				<input tabindex="0" name="fRHVPdescripcion" type="text" value="#form.fRHVPdescripcion#" size="60" maxlength="60">
			</cfoutput>
		<cfelse>
			<input tabindex="0" name="fRHVPdescripcion" type="text" value="" size="60" maxlength="60">
		</cfif>
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
	f.fRHVPdescripcion.focus();
</script>