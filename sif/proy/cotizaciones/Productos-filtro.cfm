<!-- Consultas -->
<!-- 2. Combo EAUsuario -->
<cfquery datasource="#session.DSN#" name="rsUsuario">
	select distinct Ucodigo
	from PRJPproducto a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Ucodigo
</cfquery>
	
<cfoutput>
<form action="Productos-lista.cfm" name="frmprod"  method="post" style="margin:0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td width="8">&nbsp;</td>  
			<td valign="baseline"><strong>Codigo</strong></td>
			<td width="87">&nbsp;</td>  			
			<td valign="baseline"><strong>Descripci&oacute;n</strong></td>
			<td width="4">&nbsp;</td>  
			<td><strong>Fecha</strong></td>
			<td colspan="2" valign="baseline"><strong>Usuario</strong></td>
		</tr>
		<tr>
			<td width="8">&nbsp;</td>
			<td>
				<input type="text" name="fPRJPPcodigo" <cfif isdefined("form.fPRJPPcodigo") and len(form.fPRJPPcodigo)>value="#form.fPRJPPcodigo#"</cfif> size="15" maxlength="20" value="" style="text-transform: uppercase;"  >
			</td>
			<td width="87">&nbsp;</td>
			<td>
				<input type="text" name="fPRJPPdescripcion" <cfif isdefined("form.fPRJPPdescripcion") and len(form.fPRJPPdescripcion)>value="#form.fPRJPPdescripcion#"</cfif> size="30" maxlength="80" value="" style="text-transform: uppercase;" >
			</td>
			<td width="4">&nbsp;</td>  			
			<td>
				<cfif isdefined("form.fPRJPPfechaini") and len(form.fPRJPPfechaini)>
					<cf_sifcalendario form="frmprod" name="fPRJPPfechaini" value="#form.fPRJPPfechaini#">
				<cfelse>
					<cf_sifcalendario form="frmprod" name="fPRJPPfechaini">
				</cfif>
			</td>
			<td>
				<select name="fUcodigo" >
					<option value="all">Todos</option>
					<cfloop query="rsUsuario">					
						<option value="#rsUsuario.Ucodigo#" <cfif isdefined("form.fUcodigo") and len(form.fUcodigo) and form.fUcodigo eq rsUsuario.Ucodigo>selected</cfif>>#rsUsuario.Ucodigo#</option>
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
