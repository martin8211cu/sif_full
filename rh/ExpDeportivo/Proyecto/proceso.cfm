

     <!---  and ListContainsNoCase("1,1a,1b,1c,2,3,4",Session.Progreso.Pantalla,',') NEQ 0> --->
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Opciones'>

		<table border="0" cellpadding="2" cellspacing="0">
			<cfif form.Pantalla EQ "1">
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos-lista.cfm" tabindex="-1">Seleccionar Equipo</a></td>
			  </tr>
			 <!---  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos-form.cfm" tabindex="-1">Crear Equipo</a></td>
			  </tr> --->
			
			<cfelseif form.Pantalla EQ "2">
					  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos-lista.cfm" tabindex="-1">Seleccionar Equipo</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos-form.cfm" tabindex="-1">Crear Equipo</a></td>
			  </tr>
			   <!--- <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos.cfm?o=2" tabindex="-1">Asignar Divisiones</a></td>
			  </tr> --->
			
			<!--- <cfelseif Session.Progreso.Pantalla EQ "3">
			<!---<cfif acceso_uri('Proyecto.cfm')>
			   <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="Proyecto.cfm?o=1" tabindex="-1">Seleccionar Equipo</a></td>
			  </tr></cfif>
			  <cfif acceso_uri('expediente.cfm')> --->
			   <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Proyecto.cfm?o=1" tabindex="-1">Seleccionar Instituci&oacute;n</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos.cfm?o=1" tabindex="-1">Seleccionar Equipo</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos.cfm?o=2" tabindex="-1">Nuevo Equipo</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap> <a href="javascript: if (window.showList) { showList(true); } else { location.href='/cfmx/rh/ExpDeportivo/usuarios/expediente.cfm?o=1'; }" tabindex="-1">Seleccionar Persona</a></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/usuarios/expediente.cfm?o=3" tabindex="-1">Nuevo Persona</a></td>
			  </tr><!--- </cfif> --->
			
			<cfelseif Session.Progreso.Pantalla EQ "4">
				<cfif acceso_uri('Proyecto.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td width="1%" align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="Proyecto.cfm?o=1" tabindex="-1">Seleccionar Instituci&oacute;n</a></td>
			  </tr></cfif>
			  <cfif acceso_uri('expediente.cfm')>
			  <tr>
				<td>&nbsp;</td>
				<td align="right"><img src="/cfmx/rh/imagenes/iedit.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="Permisos.cfm" tabindex="-1">Seleccionar Persona</a></td>
			  </tr></cfif>
			 --->
		
		</table>
       
	<cf_web_portlet_end> 
<cfelse>
	&nbsp;
</cfif>
