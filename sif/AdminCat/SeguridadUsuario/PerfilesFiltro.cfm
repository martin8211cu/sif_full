<!--- 
	Creado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: No contaba con filtro para la lista de cuentas de mayor.
	
	Modificado por: Gustavo Fonseca H.
		Fecha: 8-3-2006.
		Motivo: Se agrega tabindex="1" en los elementos del form. Esto para ordenar la navegación de la pantalla 
		por tabs.
 --->

<cfset filtro = "">
<cfset navegacion = "">
<cfset addCols = "">
                           

<cfif isdefined("Form.ADSPcodigoF") and Len(Trim(Form.ADSPcodigoF)) NEQ 0>
	<cfset filtro = filtro & " and upper(ADSPcodigo) like '%" & #UCase(Form.ADSPcodigoF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ADSPcodigoF=" & Form.ADSPcodigoF>
	<cfset addCols = addCols & ", '#Form.ADSPcodigoF#' as ADSPcodigoF">
</cfif>
<cfif isdefined("Form.ADSPdescripcionF") and Len(Trim(Form.ADSPdescripcionF)) NEQ 0>
	<cfset filtro = filtro & " and upper(ADSPdescripcion) like '%" & #UCase(Form.ADSPdescripcionF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ADSPdescripcionF=" & Form.ADSPdescripcionF>
	<cfset addCols = addCols & ", '#Form.ADSPdescripcionF#' as ADSPdescripcionF">
</cfif>
<cfif isdefined("Form.CtipoF") and Len(Trim(Form.CtipoF)) NEQ 0>
	<cfset filtro = filtro & " and Ctipo = '" & Trim(Form.CtipoF) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CtipoF=" & Form.CtipoF>
	<cfset addCols = addCols & ", '#Form.CtipoF#' as CtipoF">
</cfif>


	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
  
		<table  border="0" cellspacing="0" cellpadding="0" class="areafiltro">
		<form name="filtroPerfiles" method="post" action="#CurrentPage#"><cfoutput>
			<tr>
				<td align="left" ><strong>Código</strong></td>
				<td align="left" ><strong>Descripci&oacute;n</strong></td>
			</tr>
			<tr>
				<td><input name="ADSPcodigoF" type="text" size="6" tabindex="1" maxlength="4" 
					<cfif isdefined("form.ADSPcodigoF") and len(trim(form.ADSPcodigoF)) gt 0>value="#form.ADSPcodigoF#"</cfif> /></td>
				<td align="left" >
					<input name="ADSPdescripcionF" type="text" size="30" tabindex="1" maxlength="80" <cfif isdefined("form.ADSPdescripcionF") and len(trim(form.ADSPdescripcionF)) gt 0>value="#form.ADSPdescripcionF#"</cfif>>
				</td>
			
				<td align="center">
					<input name="Filtrar" class="BtnFiltrar" type="submit" value="Filtrar" tabindex="1">
				</td>
			</tr></cfoutput>
           
		</form>
	</table>
	
