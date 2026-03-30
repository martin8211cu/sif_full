<!--- Consultas --->
<!--- 1. Clasificaciones --->
<cfquery name="rsprofundidad" datasource="#session.DSN#" >
	select Pvalor 
	from Parametros 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=530
</cfquery>
<cfset profundidad = 1>
<cfif rsprofundidad.recordcount gt  0 and  len(trim(rsprofundidad.Pvalor))>
	<cfset profundidad = rsprofundidad.Pvalor-1>
</cfif>

<cfquery datasource="#session.DSN#" name="rsClasificaciones">
	select Ccodigo, Cdescripcion 
	from Clasificaciones
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and Cnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#profundidad#">
	order by Cdescripcion
</cfquery>

<form style="margin: 0" action="articulos-lista.cfm" method="post" name="farticulos" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td align="right"><strong>Clasificaci&oacute;n:</strong></td>
			<td>
				<select name="fCcodigo">
					<option value="" ></option>
					<cfoutput query="rsClasificaciones">
						<cfif isdefined("Form.fCcodigo") AND #Form.fCcodigo# NEQ "" AND #Form.fCcodigo# EQ #rsClasificaciones.Ccodigo# >
							<option value="#rsClasificaciones.Ccodigo#" selected >#rsClasificaciones.Cdescripcion#</option>
						<cfelse>
							<option value="#rsClasificaciones.Ccodigo#" >#rsClasificaciones.Cdescripcion#</option>							
						</cfif>
					</cfoutput>
				</select>
			</td>

			<td align="right"><strong>C&oacute;digo:</strong></td>
			<td>
				<input name="fAcodigo" size="15" maxlength="15" value="<cfif isdefined("Form.fAcodigo") AND #Form.fAcodigo# NEQ ""><cfoutput>#Form.fAcodigo#</cfoutput></cfif>" >
			</td>

			<td align="right"><strong>Descripci&oacute;n:</strong></td>
			<td>
				<input name="fAdescripcion" size="50" maxlength="40" value="<cfif isdefined("Form.fAdescripcion") and len(trim(form.fAdescripcion)) gt 0 ><cfoutput>#form.fAdescripcion#</cfoutput></cfif>" >
			</td>

			<td align="center" colspan="2" >
				<input type="submit" name="btnFiltro"  value="Filtrar">
				<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
			</td>
		</tr>

	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.farticulos.fAcodigo.value     = ""
		document.farticulos.fCcodigo.value = ""
		document.farticulos.fAdescripcion.value = ""
	}
</script>
