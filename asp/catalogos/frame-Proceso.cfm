<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.Pantalla")
      and ListContainsNoCase("1,1a,1b,1c,2,3,4",Session.Progreso.Pantalla,',') NEQ 0>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Opciones'>
	<cfoutput>
		<table border="0" cellpadding="2" cellspacing="0">
			<cfif Left(Session.Progreso.Pantalla,1) EQ "1">
				<cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: showList(true);" tabindex="-1">Seleccionar Cuenta</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm?o=2" tabindex="-1">Nueva Cuenta</a></td>
			  </tr></cfif>
			
			<cfelseif Session.Progreso.Pantalla EQ "2">
				<cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm?o=1" tabindex="-1">Seleccionar Cuenta</a></td>
			  </tr></cfif>
			  <cfif acceso_uri('/asp/catalogos/Empresas.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: if (window.showList) { showList(true); } else { location.href='/cfmx/asp/catalogos/Empresas.cfm?o=1'; }" tabindex="-1">Seleccionar Empresa</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Empresas.cfm?o=2" tabindex="-1">Nueva Empresa</a></td>
			  </tr></cfif>
			
			<cfelseif Session.Progreso.Pantalla EQ "3">
			<cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm?o=1" tabindex="-1">Seleccionar Cuenta</a></td>
			  </tr></cfif>
			  <cfif acceso_uri('/asp/catalogos/Usuarios.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: showList(true);" tabindex="-1">Seleccionar Usuario</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Usuarios.cfm?o=2" tabindex="-1">Nuevo Usuario</a></td>
			  </tr></cfif>
			
			<cfelseif Session.Progreso.Pantalla EQ "4">
				<cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm?o=1" tabindex="-1">Seleccionar Cuenta</a></td>
			  </tr></cfif>
			  <cfif acceso_uri('/asp/catalogos/Usuarios.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/sif/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Permisos.cfm" tabindex="-1">Seleccionar Usuario</a></td>
			  </tr></cfif>
			
			</cfif>
		</table>
	</cfoutput>	  
	<cf_web_portlet_end> 
<cfelse>
	&nbsp;
</cfif>
