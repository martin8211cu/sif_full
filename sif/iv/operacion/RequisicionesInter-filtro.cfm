<!-- Consultas -->
<!-- 1. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select distinct a.Aid, a.Bdescripcion
	from Almacen a
	
	inner join ERequisicion	r
	on a.Ecodigo=r.Ecodigo
	and a.Aid=r.Aid
	
	where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by a.Bdescripcion
</cfquery>
<!-- 2. Combo ERUsuario -->
<cfquery datasource="#session.DSN#" name="rsUsuario">
	select distinct ERusuario
	from ERequisicion
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by ERusuario
</cfquery>
	
<cfoutput>
<form action="RequisicionesInter-lista.cfm" name="frequisicion"  method="post" style="margin:0">
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
				<input type="text" name="fERdocumento" <cfif isdefined("form.fERdocumento") and len(form.fERdocumento)>value="#form.fERdocumento#"</cfif> size="15" maxlength="20" value="" style="text-transform: uppercase;"  >
			</td>
			<td width="87">&nbsp;</td>
			<td>
				<input type="text" name="fERdescripcion" <cfif isdefined("form.fERdescripcion") and len(form.fERdescripcion)>value="#form.fERdescripcion#"</cfif> size="30" maxlength="80" value="" style="text-transform: uppercase;" >
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
				<cfif isdefined("form.fERFecha") and len(form.fERFecha)>
					<cf_sifcalendario form="frequisicion" name="fERFecha" value="#form.fERFecha#">
				<cfelse>
					<cf_sifcalendario form="frequisicion" name="fERFecha">
				</cfif>
			</td>
			<td>
				<select name="fUsuario" >
					<option value="all">Todos</option>
					<cfloop query="rsUsuario">					
						<option value="#rsUsuario.ERusuario#" <cfif isdefined("form.fUsuario") and len(form.fUsuario) and form.fUsuario eq rsUsuario.ERusuario>selected</cfif>>#rsUsuario.ERusuario#</option>
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