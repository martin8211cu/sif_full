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
<cfif isdefined("Form.CmayorF") and Len(Trim(Form.CmayorF)) NEQ 0>
	<cfset filtro = filtro & " and upper(Cmayor) like '%" & #UCase(Form.CmayorF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CmayorF=" & Form.CmayorF>
	<cfset addCols = addCols & ", '#Form.CmayorF#' as CmayorF">
</cfif>
<cfif isdefined("Form.CdescripcionF") and Len(Trim(Form.CdescripcionF)) NEQ 0>
	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & #UCase(Form.CdescripcionF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CdescripcionF=" & Form.CdescripcionF>
	<cfset addCols = addCols & ", '#Form.CdescripcionF#' as CdescripcionF">
</cfif>
<cfif isdefined("Form.CtipoF") and Len(Trim(Form.CtipoF)) NEQ 0>
	<cfset filtro = filtro & " and Ctipo = '" & Trim(Form.CtipoF) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CtipoF=" & Form.CtipoF>
	<cfset addCols = addCols & ", '#Form.CtipoF#' as CtipoF">
</cfif>


	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
  
		<table  border="0" cellspacing="0" cellpadding="0" class="areafiltro">
		<form name="filtroCuentasMayor" method="post" action="#CurrentPage#"><cfoutput>
			<tr>
				<td align="left" ><strong>Cuenta</strong></td>
				<td align="left" ><strong>Descripci&oacute;n</strong></td>
				<td align="left" ><strong>Tipo</strong></td>
			</tr>
			<tr>
				<td>
					<input name="CmayorF" type="text" size="6" tabindex="1" maxlength="4" 
					<cfif isdefined("form.CmayorF") and len(trim(form.CmayorF)) gt 0>value="#form.CmayorF#"</cfif>>
				</td>
				<td align="left" >
					<input name="CdescripcionF" type="text" size="30" tabindex="1" maxlength="80" <cfif isdefined("form.CdescripcionF") and len(trim(form.CdescripcionF)) gt 0>value="#form.CdescripcionF#"</cfif>>
				</td>
				<td align="left">
					<select name="CtipoF" tabindex="1">
						<option value="">---Seleccione un Tipo---</option>
						<option value="A" <cfif isdefined("form.CtipoF") and form.CtipoF eq "A">selected</cfif>>Activo</option>
						<option value="P" <cfif isdefined("form.CtipoF") and form.CtipoF eq "P">selected</cfif>>Pasivo</option>
						<option value="C" <cfif isdefined("form.CtipoF") and form.CtipoF eq "C">selected</cfif>>Capital</option>
						<option value="I" <cfif isdefined("form.CtipoF") and form.CtipoF eq "I">selected</cfif>>Ingreso</option>
						<option value="G" <cfif isdefined("form.CtipoF") and form.CtipoF eq "G">selected</cfif>>Gasto</option>
						<option value="O" <cfif isdefined("form.CtipoF") and form.CtipoF eq "O">selected</cfif>>Orden</option>
					</select>		
				</td>
				<td align="center">
					<input name="Filtrar" class="BtnFiltrar" type="submit" value="Filtrar" tabindex="1">
				</td>
			</tr></cfoutput>
		</form>
	</table>
	
