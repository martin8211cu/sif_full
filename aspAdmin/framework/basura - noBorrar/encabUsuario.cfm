<cfif isdefined('form.Usucodigo') and form.Usucodigo NEQ '' and isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ '' >
	<cfquery name="rsEncabUsuario" datasource="sdc">
		select (u.Pnombre + ' ' + u.Papellido1 + ' ' + u.Papellido2) as NombreUsuario, u.Pid, TInombre
		from Usuario u,
			UsuarioEmpresarial ue,
			TipoIdentificacion ti
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
			  and u.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
			 and u.Usucodigo = ue.Usucodigo
			  and u.Ulocalizacion = ue.Ulocalizacion
			  and ue.activo = 1
			and u.TIcodigo=ti.TIcodigo
	</cfquery>
</cfif>

<!--- Encabezado con los datos del Usuario --->
<cfif isdefined('rsEncabUsuario')>
  <cfoutput> 
    <table width="100%" border="0" cellspacing="6" cellpadding="6">
      <tr>
		<td width="94%" valign="top">
			<table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
			  <tr> 
				<td width="33%" class="fileLabel"><strong>Nombre completo</strong></td>
				<td width="67%">#rsEncabUsuario.NombreUsuario#</td>
			  </tr>
			  <tr> 
				<td class="fileLabel"><strong>#rsEncabUsuario.TInombre#</strong></td>
				<td>#rsEncabUsuario.Pid#</td>
			  </tr>
		  </table>		
		</td>
      </tr>
    </table>
  </cfoutput> 
</cfif>
