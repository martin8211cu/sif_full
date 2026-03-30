<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<table border="0" cellpadding="2" cellspacing="0">
	  <!--- Inicio --->
	  <tr>
		<td style="border-bottom: 1px solid black; ">&nbsp;</td>
		<td align="right" style="border-bottom: 1px solid black; "> <img src="/cfmx/rh/imagenes/home.gif" border="0"> </td>
		<td class="etiquetaProgreso" style="border-bottom: 1px solid black; "><a href="index.cfm" tabindex="-1"><strong><cf_translate  key="LB_Inicio">Inicio</cf_translate></strong></a></td>
	  </tr>
	  <!--- 1 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"1") GT 0 >
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
		  <cfelseif Session.Progreso.Pantalla EQ "1">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/menu/num1_small.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Proyecto.cfm" tabindex="-1">Instituciones</a></td>
	  </tr>
	  
	  <!--- 2 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"2") GT 0>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "2">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="/cfmx/rh/imagenes/menu/num2_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/Proyecto/Equipos.cfm" tabindex="-1">Equipos</a></td>
	  </tr>
	 
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"3") GT 0>
			<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "3">
			<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="../../imagenes/menu/num3_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/rh/ExpDeportivo/usuarios/expediente.cfm" tabindex="-1"><cf_translate  key="LB_Personas">Personas</cf_translate></a></td>
	  </tr>
	 <!--- <!--- 4 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif isdefined("Session.Progreso.Pantalla") and Compare(Session.Progreso.Pantalla,"4") GT 0>
			<img src="../w-check.gif" border="0">
			<cfelseif Session.Progreso.Pantalla EQ "4">
			<img src="../addressGo.gif" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="../menu/num4_small.gif" border="0"></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/asp/catalogos/Permisos.cfm" tabindex="-1">Asignaci&oacute;n de Permisos</a></td>
	  </tr>
	 ---> 
	</table>
<cf_web_portlet_end> 
