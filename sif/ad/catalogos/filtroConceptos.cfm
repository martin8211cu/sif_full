<cfoutput>
<form name="filtro" method="post" style="margin:0;" action="Conceptos.cfm">

	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<strong>
				<td>C&oacute;digo: 
				</td>
				<td>Descripci&oacute;n:
				</td>
				<td>Tipo:</td>
			</strong>
		</tr>
		
		<tr>
			<td><input name="fCcodigo" type="text" value=" <cfif isdefined("form.fCcodigo") and len(trim(form.fCcodigo)) neq 0>#trim(form.fCcodigo)#</cfif>" size="10" maxlength="10">
			</td>
			<td><input name="fCdescripcion" type="text" value=" <cfif isdefined("form.fCdescripcion") and len(trim(form.fCdescripcion)) neq 0>#trim(form.fCdescripcion)#</cfif>" size="35" maxlength="50">
			</td>
			<td>
				<select name="fTipo" onChange="document.filtro.submit();">
					<option value="T" <cfif isdefined("form.fTipo") and form.fTipo eq 'T'>selected</cfif> >Todos</option>
					<option value="I" <cfif isdefined("form.fTipo") and form.fTipo eq 'I'>selected</cfif> >Ingresos</option>
					<option value="G" <cfif isdefined("form.fTipo") and form.fTipo eq 'G'>selected</cfif> >Gastos</option>
				</select>
				<input type="submit" name="filtrar" value="filtrar">
			</td>
		</tr>
	</table>
	<!---  <input type="hidden" name="fCcodigo" value="<cfif isdefined("form.fCcodigo") and len(trim(form.fCcodigo)) neq 0>#form.fCcodigo#</cfif>"> 
	 <input type="hidden" name="fCdescripcion" value="<cfif isdefined("form.fCdescripcion") and len(trim(form.fCdescripcion)) neq 0>#form.fCdescripcion#</cfif>"> 
	 <input type="hidden" name="fTipo" value="<cfif isdefined("form.fTipo") and len(trim(form.fTipo)) neq 0>#form.fTipo#</cfif>">  --->
</form>
</cfoutput>