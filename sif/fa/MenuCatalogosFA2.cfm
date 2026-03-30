<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default= "Cat&aacute;logos" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cajas" Default= "Cajas" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_Cajas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TiposTransaccionCaja" Default= "Tipos de Transacci&oacute;n x Caja" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_TiposTransaccionCaja"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TiposVentaPerdida" Default= "Tipos de Venta P&eacute;rdida" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_TiposVentaPerdida"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptosFacturacion" Default= "Conceptos de Facturaci&oacute;n" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_ConceptosFacturacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Talonario" Default= "Talonario" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_Talonario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vendedores" Default= "Vendedores" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_Vendedores"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaPrecios" Default= "Lista de Precios" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_ListaPrecios"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SociosNegocios" Default= "Socios de Negocio" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_SociosNegocios"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ZonasVenta" Default= "Zonas de Venta" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_ZonasVenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoTransaccionesPreFactura" Default= "Tipos de Transacciones Pre-Factura" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_TipoTransaccionesPreFactura"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CalendariosVenta" Default= "Calendarios de Venta" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_CalendariosVenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodigosConceptos" Default= "C&oacute;digos de Conceptos" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_CodigosConceptos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TiposGeneracionFactura" Default= "Tipos de Generaci&oacute;n de Facturas" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_TiposGeneracionFactura"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Parametros" Default= "Parametros de conexión PAC" XmlFile="MenuCatalogosFA2.xml" returnvariable="LB_Parametros"/>

<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="#LB_Titulo#">

<table border="0" cellpadding="2" cellspacing="0" >
	  <!---<tr valign="middle">
	    <td width="1%" align="right" class="etiquetaProgreso"><a href="catalogos/Cajas.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td width="99%" class="etiquetaProgreso"><a href="catalogos/Cajas.cfm" tabindex="-1"><cfoutput>#LB_Cajas#</cfoutput></a></td>
	  </tr>

	  <tr valign="middle">
	    <td align="right" class="etiquetaProgreso"><a href="catalogos/TipoTransaccionCaja.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td class="etiquetaProgreso"><a href="catalogos/TipoTransaccionCaja.cfm" tabindex="-1"><cfoutput>#LB_TiposTransaccionCaja#</cfoutput></a></td>
      </tr>

	  <tr valign="middle">
        <td align="right" class="etiquetaProgreso"><a href="catalogos/VentaPerdida.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
        <td class="etiquetaProgreso"><a href="catalogos/VentaPerdida.cfm" tabindex="-1"><cfoutput>#LB_TiposVentaPerdida#</cfoutput></a></td>
  </tr>
	  <tr valign="middle">
	    <td align="right" class="etiquetaProgreso"><a href="../ad/catalogos/Conceptos.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td class="etiquetaProgreso"><a href="../ad/catalogos/Conceptos.cfm" tabindex="-1"><cfoutput>#LB_ConceptosFacturacion#</cfoutput></a></td>
      </tr>

	  <tr valign="middle">
	    <td align="right" class="etiquetaProgreso"><a href="catalogos/Talonarios.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td class="etiquetaProgreso" ><a href="catalogos/Talonarios.cfm" tabindex="-1"><cfoutput>#LB_Talonario#</cfoutput></a></td>
	  </tr>

	   <tr valign="middle">
	     <td align="right" class="etiquetaProgreso"><a href="catalogos/Vendedores.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	     <td class="etiquetaProgreso" ><a href="catalogos/Vendedores.cfm" tabindex="-1"><cfoutput>#LB_Vendedores#</cfoutput></a></td>
	  </tr>

	  <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/listaLPrecios.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/listaLPrecios.cfm" tabindex="-1"><cfoutput>#LB_ListaPrecios#</cfoutput></a></td>
	  </tr>--->

	  <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="../ad/catalogos/listaSocios.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="../ad/catalogos/listaSocios.cfm" tabindex="-1"><cfoutput>#LB_SociosNegocios#</cfoutput></a></td>
	  </tr>

	 <!--- <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/ZonaVenta.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/ZonaVenta.cfm" tabindex="-1"><cfoutput>#LB_ZonasVenta#</cfoutput></a></td>
	  </tr>--->
	  
      <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/TipoTransaccionesPF.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/TipoTransaccionesPF.cfm" tabindex="-1"><cfoutput>#LB_TipoTransaccionesPreFactura#</cfoutput></a></td>
	  </tr>
	  
      <!---<tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/TipoTransaccionesPF.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
        
		<td class="etiquetaProgreso"><a href="catalogos/CalendariosVenta.cfm" tabindex="-1"><cfoutput>#LB_CalendariosVenta#</cfoutput></a></td>
	  </tr>	
      <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/TipoTransaccionesPF.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/CodigosConceptos.cfm" tabindex="-1"><cfoutput>#LB_CodigosConceptos#</cfoutput></a></td>
	  </tr>	
      <cfif acceso_uri("/sif/fa/catalogos/TiposGeneracion.cfm")>
          <tr valign="middle">
            <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/fa/catalogos/TiposGeneracion.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
            <td class="etiquetaProgreso"><a href="/cfmx/sif/fa/catalogos/TiposGeneracion.cfm" tabindex="-1"><cfoutput>#LB_TiposGeneracionFactura#</cfoutput></a></td>
          </tr>
      </cfif>--->
      <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/TipoPagoFact.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/TipoPagoFact.cfm" tabindex="-1">Tipo de Pago de Factura</a></td>
      </tr>	   
      <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/RegFiscalFact.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/RegFiscalFact.cfm" tabindex="-1">R&eacute;gimen Fiscal</a></td>
	  </tr>
     <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="catalogos/Konesh.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="catalogos/Konesh.cfm" tabindex="-1">Parametros de Conexion</a></td>
	  </tr>
	  <tr valign="middle">
		<td align="right" class="etiquetaProgreso"><a href="/cfmx/rh/admin/catalogos/RH_CFDI_Certificados.cfm">
		<img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td class="etiquetaProgreso"><a href="/cfmx/rh/admin/catalogos/RH_CFDI_Certificados.cfm" tabindex="-1">Certificados CSD</a></td>
	  </tr>
</table>
	<cf_web_portlet_end>