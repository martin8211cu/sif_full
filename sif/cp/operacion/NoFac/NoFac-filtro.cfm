<!-- Consultas -->
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select '' as value, 'Todas' as description from dual
	union all
	select CPTcodigo as value, CPTdescripcion as description
	from CPTransacciones
	where Ecodigo =  #Session.Ecodigo# 
	  AND CPTestimacion = 1
	order by 1
</cfquery> 

<cfoutput>
<form action="NoFac-lista.cfm" method="post"  name="frequisicion" style="margin:0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td width="5%">&nbsp;</td>  
			<td width="10%" valign="baseline"><strong>Transacci&oacute;n</strong></td>
			<td width="5%">&nbsp;</td>  
			<td width="20%" valign="baseline"><strong>Documento</strong></td>
			<td width="5%">&nbsp;</td>  			
			<td width="55%"><strong>Fecha</strong></td>
		</tr>
		<tr>
			<td width="8">&nbsp;</td>
			<td>
				<select name="FCPTcodigo">
					<cfloop query="rsTransacciones">
						<option value="#rsTransacciones.value#" <cfif isdefined("Form.FCPTcodigo") AND rsTransacciones.value EQ Form.FCPTcodigo>selected</cfif>>#rsTransacciones.description#</option>
					</cfloop>
				</select>
			</td>
			<td width="18">&nbsp;</td>
			<td>
				<input type="text" name="FDdocumento" <cfif isdefined("form.FDdocumento") and len(form.FDdocumento)>value="#form.FDdocumento#"</cfif> size="20" maxlength="20" value="" style="text-transform: uppercase;" >
			</td>
			<td width="10">&nbsp;</td>  
			<td>
				<cfif isdefined("form.FDfecha") and len(form.FDfecha)>
					<cf_sifcalendario form="frequisicion" name="FDfecha" value="#form.FDfecha#">
				<cfelse>
					<cf_sifcalendario form="frequisicion" name="FDfecha">
				</cfif>
			</td>
			<td width="110" align="center">
				<input type="submit" name="btnFiltro"  value="Filtrar">
		  </td>
		</tr>
	</table>
</form>
</cfoutput>