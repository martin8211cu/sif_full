<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cat&aacute;logos">
<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 1
		and Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<table border="0" cellpadding="2" cellspacing="0" >
	  <tr valign="middle">
	    <td width="1%" align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/CuentasMayor.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		<td width="99%" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/CuentasMayor.cfm" tabindex="-1">Agregar
		    Cuenta de Mayor</a></td>
	  </tr>

	  <tr valign="middle">
	    <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/SubCuentasLista.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/SubCuentasLista.cfm" tabindex="-1">Agregar
            Subcuenta </a></td>
      </tr>
	  <tr valign="middle">
	    <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/ConceptoContableE.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	    <td class="etiquetaProgreso" ><a href="/cfmx/sif/cg/catalogos/ConceptoContableE.cfm" tabindex="-1">Agregar
		    Conceptos Contables</a></td>
	  </tr>

	   <tr valign="middle">
	     <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/Htipocambio.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
	     <td class="etiquetaProgreso" ><a href="/cfmx/sif/cg/catalogos/Htipocambio.cfm" tabindex="-1"> Históricos de Tipo de Cambio</a></td>
	  </tr>
	<cfif rsParametros.RecordCount NEQ 0 and rsParametros.Pvalor EQ 'S'>

		  <tr valign="middle">
		    <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/MascarasCuentas.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		    <td class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/MascarasCuentas.cfm" tabindex="-1">Agregar
				M&aacute;scara al Plan de Cuentas</a></td>
		  </tr>
	
		  <tr valign="middle">
		    <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/Catalogos-lista.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
		    <td class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/Catalogos-lista.cfm" tabindex="-1">Agregar
				Cat&aacute;logo al Plan de Cuentas</a></td>
		  </tr>
	 </cfif>
	 
	<!--- Monedas--->
	<tr valign="middle">
      <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/Clasificacion-lista.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
      <td class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/Clasificacion-lista.cfm" tabindex="-1">Agregar Clasificaci&oacute;n de Cat&aacute;logo</a></td>
    </tr>
	<tr> 
		<td align="center"><a href="/cfmx/sif/ad/catalogos/Monedas.cfm" ><img align="middle" src="../imagenes/16x16_flecha_right.gif" border="0"></a></td>
		<td class="etiquetaProgreso" nowrap><a href="/cfmx/sif/ad/catalogos/Monedas.cfm">Agregar Monedas</a></td>
	</tr>
	
	<!--- Cuentas intercompañía--->
	<tr valign="middle">
      <td align="right" class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/CtasInterCia.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
      <td class="etiquetaProgreso"><a href="/cfmx/sif/cg/catalogos/CtasInterCia.cfm" tabindex="-1">Agregar Cuentas Intercompan&iacute;a</a></td>
    </tr>
	 
</table>
<cf_web_portlet_end>