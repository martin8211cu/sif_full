<!-- Consultas -->
<!-- 1. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion
</cfquery>
<!-- 2. Combo EAUsuario -->
<cfquery datasource="#session.DSN#" name="rsUsuario">
	select distinct EAusuario
	from EAjustes a inner join Almacen b on a.Aid = b.Aid and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by EAusuario
</cfquery>
	
<cfoutput>
<form action="Ajustes-lista.cfm" name="frequisicion"  method="post" style="margin:0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td width="8">&nbsp;</td>  
			<td valign="baseline"><strong>Documento</strong></td>
			<td width="87">&nbsp;</td>  			
			<td valign="baseline"><strong>Descripci&oacute;n</strong></td>
			<td width="4">&nbsp;</td>  
			<td valign="baseline"><strong>Almac&eacute;n</strong></td>			
			<td width="4">&nbsp;</td>  
			<td><strong>Fecha</strong></td>
			<td colspan="2" valign="baseline"><strong>Usuario</strong></td>
		</tr>
		<tr>
			<td width="8">&nbsp;</td>
			<td>
				<input type="text" name="fEAdocumento" <cfif isdefined("form.fEAdocumento") and len(form.fEAdocumento)>value="#form.fEAdocumento#"</cfif> size="15" maxlength="20" value="" style="text-transform: uppercase;"  >
			</td>
			<td width="87">&nbsp;</td>
			<td>
				<input type="text" name="fEAdescripcion" <cfif isdefined("form.fEAdescripcion") and len(form.fEAdescripcion)>value="#form.fEAdescripcion#"</cfif> size="30" maxlength="80" value="" style="text-transform: uppercase;" >
			</td>
			<td width="4">&nbsp;</td>  
			<td >
				<select name="fAid" >
					<option value="all">Todos</option>
					<cfloop query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#" <cfif isdefined("form.fAid") and len(form.fAid) and form.fAid eq rsAlmacen.Aid>selected</cfif>>#rsAlmacen.Bdescripcion#</option>
					</cfloop>						
				</select>
			</td>
			<td width="4">&nbsp;</td>  
			<td>
				<cfif isdefined("form.fEAFecha") and len(form.fEAFecha)>
					<cf_sifcalendario form="frequisicion" name="fEAFecha" value="#form.fEAFecha#">
				<cfelse>
					<cf_sifcalendario form="frequisicion" name="fEAFecha">
				</cfif>
			</td>
			<td>
				<select name="fUsuario" >
					<option value="all">Todos</option>
					<cfloop query="rsUsuario">					
						<option value="#rsUsuario.EAusuario#" <cfif isdefined("form.fUsuario") and len(form.fUsuario) and form.fUsuario eq rsUsuario.EAusuario>selected</cfif>>#rsUsuario.EAusuario#</option>
					</cfloop>						
				</select>
			</td>
			<td align="center">
				<input type="submit" name="btnFiltro"  value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>