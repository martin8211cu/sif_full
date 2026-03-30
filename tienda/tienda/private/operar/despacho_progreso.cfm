<cfparam name="despacho_progreso_paso" default="1">
<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<table border="0" cellpadding="2" cellspacing="0">
	  <!--- Inicio --->
	  <tr>
		<td style="border-bottom: 1px solid black; ">&nbsp;</td>
		<td align="right" style="border-bottom: 1px solid black; "> <img src="../../../Imagenes/menu/home.gif" width="14" height="15" border="0"> </td>
		<td class="etiquetaProgreso" style="border-bottom: 1px solid black; "><a href="despacho.cfm" tabindex="-1"><strong>Despacho de pedidos </strong></a></td>
	  </tr>
	  <!--- 1 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif despacho_progreso_paso gt 1 >
			<img src="../../../Imagenes/menu/check.gif" width="12" height="12" border="0">
		  <cfelseif despacho_progreso_paso EQ 1>
			<img src="../../../Imagenes/menu/addressGo.gif" width="14" height="13" border="0">
		  </cfif>
		</td>
		<td width="1%" align="right"> <img src="../../../Imagenes/menu/num1_small.gif" width="20" height="20" border="0"> </td>
		<td class="etiquetaProgreso" nowrap>Seleccionar pedido </td>
	  </tr>
	  <!--- 1a --->
	  <!--- 1b --->
	  <!--- 2 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif despacho_progreso_paso GT 2>
			<img src="../../../Imagenes/menu/check.gif" width="12" height="12" border="0">
			<cfelseif despacho_progreso_paso EQ 2>
			<img src="../../../Imagenes/menu/addressGo.gif" width="14" height="13" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="../../../Imagenes/menu/num2_small.gif" width="20" height="20" border="0"></td>
		<td class="etiquetaProgreso" nowrap>Registrar env&iacute;o </td>
	  </tr>
	  <!--- 3 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif despacho_progreso_paso gt 3>
			<img src="../../../Imagenes/menu/check.gif" width="12" height="12" border="0">
			<cfelseif despacho_progreso_paso EQ 3>
			<img src="../../../Imagenes/menu/addressGo.gif" width="14" height="13" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="../../../Imagenes/menu/num3_small.gif" width="20" height="20" border="0"></td>
		<td class="etiquetaProgreso" nowrap>Cargar env&iacute;o a tarjeta de cr&eacute;dito </td>
	  </tr>
	  <!--- 4 --->
	  <tr>
		<td width="1%" align="right">
		  <cfif despacho_progreso_paso gt 4>
			<img src="../../../Imagenes/menu/check.gif" width="12" height="12" border="0">
			<cfelseif despacho_progreso_paso EQ 4>
			<img src="../../../Imagenes/menu/addressGo.gif" width="14" height="13" border="0">
		  </cfif>
		</td>
		<td align="right"><img src="../../../Imagenes/menu/num4_small.gif" width="20" height="20" border="0"></td>
		<td class="etiquetaProgreso" nowrap>Enviar paquete por mensajer&iacute;a </td>
	  </tr>
	  <tr>
        <td align="right">
          <cfif despacho_progreso_paso gt 5>
            <img src="../../../Imagenes/menu/check.gif" width="12" height="12" border="0">
            <cfelseif despacho_progreso_paso EQ 5>
            <img src="../../../Imagenes/menu/addressGo.gif" width="14" height="13" border="0">
          </cfif>
        </td>
        <td align="right"><img src="../../../Imagenes/menu/num5_small.gif" width="20" height="20" border="0"></td>
        <td class="etiquetaProgreso" nowrap>Cerrar pedido </td>
      </tr>
	</table>
</cf_web_portlet> 
