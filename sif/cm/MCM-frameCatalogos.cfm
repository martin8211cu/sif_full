<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Catálogos">
	<!---►►Pintado de las opciones de Catalogo◄◄--->
	<table border="0" cellpadding="2" cellspacing="0">
		<cfoutput query="rsCatalogosOrd">
			<cfif acceso_uri("/sif/cm/#rsCatalogosOrd.Link#")>	
                <tr>	
                    <td width="1%" align="right" class="etiquetaProgreso"  valign="middle">
                        <div align="right"> 
                            <a href="#rsCatalogosOrd.Link#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a> 
                        </div>
                    </td>
                    <td width="99%" align="left" valign="middle" nowrap class="etiquetaProgreso">
                        <a href="#rsCatalogosOrd.Link#">#rsCatalogosOrd.LDescripcion#</a>
                    </td>
                </tr>
            </cfif>
		</cfoutput>
	</table>
<cf_web_portlet_end>