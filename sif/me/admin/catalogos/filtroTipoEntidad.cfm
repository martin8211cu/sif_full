<cfset filtro = ""> 
<form style="margin: 0" name="filtros" action="TipoEntidad.cfm" method="post">
	<cfset Codigo = "">
	<cfset Descripcion   = "">
	<cfset aux = "">
	
	<cfif isDefined("Form.Codigo") and Trim(Form.Codigo) NEQ "">
		<cfif Trim(Form.Codigo) NEQ "">
			<cfset filtro = filtro & aux & " upper(METEformato) like '%" & Ucase(Trim(Form.Codigo)) & "%'" >
			<cfset Codigo = Trim(Form.Codigo)>
			<cfset aux = " and ">
		</cfif>
	</cfif>
	
	<cfif isDefined("Form.Descripcion") and Trim(Form.Descripcion) NEQ "">
		<cfset filtro = filtro & aux &" upper(METEdesc) like '%" & Ucase(Trim(Form.Descripcion)) & "%'" >
		<cfset Descripcion = Trim(Form.Descripcion)>
		<cfset aux = " and ">
	</cfif>
	
	<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
		<tr> 
			<td width="4%">&nbsp;</td>
			<td><strong>C&oacute;digo</strong></td>
			<td><strong>Descripci&oacute;n</strong></td>
			<td>&nbsp;</td>
		</tr>						
		<tr> 
			<td>&nbsp;</td>
			<td><input name="Codigo" type="text" value="<cfif isDefined("Form.Codigo") and Trim(Form.Codigo) NEQ ""><cfoutput>#Form.Codigo#</cfoutput></cfif>" size="20" maxlength="20"></td>
			<td><input name="Descripcion" type="text" value="<cfif isDefined("Form.Descripcion") and Trim(Form.Descripcion) NEQ ""><cfoutput>#Form.Descripcion#</cfoutput></cfif>" size="20" maxlength="20"></td>													
			<td nowrap> <input name="Filtrar" type="submit" value="Filtrar"> 
				<input name="Limpiar" type="button" value="Limpiar" onClick="javascript: LimpiarFiltros(this.form); "> 
			</td>
		</tr>
	</table>
</form>