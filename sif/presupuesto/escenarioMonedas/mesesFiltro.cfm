<cfset escenario = getCVTCEscenario(form.cvtid)>
<cfoutput>
<form action="#GCurrentPage#" method="post" name="formfiltroMeses">
<input type="hidden" name="btnMeses" value="1">
<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="AreaFiltro">
  <tr>
    <td nowrap>
			<strong>Escenario&nbsp;:&nbsp;</strong>
		</td>
		<td nowrap>
			#escenario.CVTdescripcion#
		</td>
		<td nowrap width="100%" rowspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td nowrap>
			<label for="Fmcodigo"><strong>Moneda&nbsp;:&nbsp;</strong></label>
		</td>
		<td nowrap>
			<select name="Fmcodigo" id="Fmcodigo" onChange="javascript: this.form.submit();">
					<option value="-1" >(Todas la Monedas)</option>
					<cfloop query="monedas">
						<option value="#monedas.mcodigo#" <cfif isdefined("form.Fmcodigo") and form.Fmcodigo equal monedas.mcodigo>selected</cfif>>#monedas.mnombre#</option>
					</cfloop>
			</select>
		</td>
  </tr>
  <tr>
    <td nowrap>
			<label for="Fano"><strong>A&ntilde;o&nbsp;:&nbsp;</strong></label>
		</td>
		<td nowrap>
			<select name="Fano" id="Fano" onChange="javascript: this.form.submit();">
					<cfloop query="anos">
						<option value="#anos.ano#" <cfif isdefined("form.Fano") and form.Fano equal anos.ano>selected</cfif>>#anos.ano#</option>
					</cfloop>
			</select>
		</td>
  </tr>
</table>
<input type="hidden" value="#form.cvtid#" name="cvtid">
<input name="PAGENUM" type="hidden" value="<cfif isDefined("form.PAGENUM")>#form.PAGENUM#</cfif>">
</form></cfoutput>