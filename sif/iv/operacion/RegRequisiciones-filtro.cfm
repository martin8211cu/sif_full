<!-- Consultas -->
<!-- 1. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion
</cfquery>
<!-- 2. Combo ERUsuario -->
<cfquery datasource="#session.DSN#" name="rsUsuario">
	select distinct ERusuario, Estado
	from ERequisicion
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by ERusuario
</cfquery>

<cfoutput>
<form action="RegRequisiciones-lista.cfm?LvarUsuarioAprobador=#LvarUsuarioAprobador#&LvarUsuarioDespachador=#LvarUsuarioDespachador#" name="frequisicion"  method="post" style="margin:0">
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
			
			<cfif LvarUsuarioAprobador eq 'true' or LvarUsuarioDespachador eq 'true'>
				<td><strong>Estado</strong></td>
			</cfif>
			
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
			
			<cfif LvarUsuarioAprobador eq 'true'>
				<td>
					<select name="fEstado" >
						<option value="-1" selected>Todos</option>
						<option value="0" <cfif isdefined("form.fEstado") and len(form.fEstado) and form.fEstado eq 0>selected</cfif>>Pendiente</option>
						<option value="1" <cfif isdefined("form.fEstado") and len(form.fEstado) and form.fEstado eq 1>selected</cfif>>Aprobado</option>
						<option value="2" <cfif isdefined("form.fEstado") and len(form.fEstado) and form.fEstado eq 2>selected</cfif>>Despachado</option>
					</select>
				</td>
			</cfif>
			
			<cfif LvarUsuarioDespachador eq 'true'>
				<td>
					<select name="fEstado" >
						<option value="-1" selected>Todos</option>
						<option value="1" <cfif isdefined("form.fEstado") and len(form.fEstado) and form.fEstado eq 1>selected</cfif>>Aprobado</option>
						<option value="2"<cfif isdefined("form.fEstado") and len(form.fEstado) and form.fEstado eq 2>selected</cfif>>Despachado</option>
					</select>
				</td>
			</cfif>
			
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