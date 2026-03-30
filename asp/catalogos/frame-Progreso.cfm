<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<table border="0" cellpadding="2" cellspacing="0">
	  <!--- Inicio --->
	  <tr>
		<td style="border-bottom: 1px solid black; ">&nbsp;</td>
		<td align="right" style="border-bottom: 1px solid black; "> <img src="/cfmx/asp/imagenes/home.gif" border="0"> </td>
		<td class="etiquetaProgreso" style="border-bottom: 1px solid black; "><a href="/cfmx/asp/index.cfm" tabindex="-1"><strong>Inicio</strong></a></td>
	  </tr>
	  <cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
	  <!--- 1 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		  <cfelseif Session.Progreso.Pantalla EQ "1">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/asp/imagenes/menu/num1_small.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Cuentas.cfm" tabindex="-1">Cuentas Empresariales</a></td>
	  </tr>
	  <!--- 1a --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1a") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		  <cfelseif Session.Progreso.Pantalla EQ "1a">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right">&nbsp;</td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Modulos.cfm" tabindex="-1">a) M&oacute;dulos</a></td>
	  </tr>
	  
	  <!--- 1b --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1b") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		  <cfelseif Session.Progreso.Pantalla EQ "1b">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right">&nbsp;</td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Caches.cfm" tabindex="-1">b) Caches</a></td>
	  </tr>
	  
	  <!--- 1c --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1c") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
		  <cfelseif Session.Progreso.Pantalla EQ "1c">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right">&nbsp;</td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/CuentaAutentica.cfm" tabindex="-1">c) Seguridad</a></td>
	  </tr></cfif>
	  
	  <cfif acceso_uri('/asp/catalogos/Empresas.cfm')>
	  <!--- 2 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"2") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "2">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/asp/imagenes/menu/num2_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Empresas.cfm" tabindex="-1">Empresas</a></td>
	  </tr></cfif>
	  
	  <cfif acceso_uri('/asp/catalogos/Usuarios.cfm')>
	  <!--- 3 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"3") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "3">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/asp/imagenes/menu/num3_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Usuarios.cfm" tabindex="-1">Usuarios</a></td>
	  </tr></cfif>
	  <cfif acceso_uri('/asp/catalogos/Permisos.cfm')>
	  <!--- 4 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"4") GT 0>
			<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "4">
			<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/asp/imagenes/menu/num4_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Permisos.cfm" tabindex="-1">Asignaci&oacute;n de Permisos</a></td>
	  </tr></cfif>
	</table>
<cf_web_portlet_end> 
