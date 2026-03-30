<!--- Consultas--->
<!--- 1. Impuestos --->
<cfquery name="rsImpuestos" datasource="#session.dsn#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Idescripcion
</cfquery>

<form style="margin: 0" action="listaCodigoAduanal.cfm" method="post" name="filtroCodigosAduanales" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<!--- Código Aduanal --->
			<td align="right"><strong>C&oacute;digo:</strong></td>
			<td>
				<input name="CAcodigo" type="text" value="<cfif isdefined("form.CAcodigo") and len(trim(form.CAcodigo)) gt 0><cfoutput>#form.CAcodigo#</cfoutput></cfif>" id="CAcodigo" size="20" maxlength="20">
			</td>
			<!--- Descripción --->
			<td align="right"><strong>Descripci&oacute;n:</strong></td>
			<td>
				<input name="CAdescripcion" size="40" value="<cfif isdefined("form.CAdescripcion") and len(trim(form.CAdescripcion)) gt 0><cfoutput>#form.CAdescripcion#</cfoutput></cfif>">
			</td>
			<!--- Grupo de impuestos --->
			<td align="right"><strong>Grupo de impuestos:</strong></td>
			<td>
				<select name="Icodigo">
					<option value="">Todos</option>
					<cfloop query="rsImpuestos">
						<option value="<cfoutput>#rsImpuestos.Icodigo#</cfoutput>"
								<cfif isdefined("form.Icodigo") and len(trim(form.Icodigo)) gt 0 and trim(rsImpuestos.Icodigo) eq trim(form.Icodigo)>
									selected
								</cfif>
								><cfoutput>#rsImpuestos.Idescripcion#</cfoutput>
						</option>
					</cfloop>
				</select>
			</td>

			<td align="center" colspan="2">
				<input type="submit" name="btnFiltro" value="Filtrar">
				<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
			</td>
		</tr>

	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtroCodigosAduanales.CAcodigo.value = "";
		document.filtroCodigosAduanales.CAdescripcion.value = "";
		document.filtroCodigosAduanales.Icodigo.value = "";
	}
</script>
