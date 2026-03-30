<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		SIF - Interfases P.M.I.
	</cf_templatearea>
	
	<cf_templatearea name="body">
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo 
            de Productos'>
	
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
                  </td>
              </tr>
              <tr> 
                <td valign="top"> 
                  <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				 returnvariable="pListaReten">
                    <cfinvokeargument name="tabla" value="CatProductos"/>
                    <cfinvokeargument name="columnas" value="CodigoICTS, Descripcion,LineaNegocio"/>
                    <cfinvokeargument name="desplegar" value="CodigoICTS, Descripcion, LineaNegocio"/>
                    <cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n,L&iacute;neaNegocio"/>
                    <cfinvokeargument name="formatos" value=""/>
                    <cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by CodigoICTS"/>
                    <cfinvokeargument name="align" value="left, left"/>
                    <cfinvokeargument name="ajustar" value="N"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
                    <cfinvokeargument name="irA" value="Productos.cfm"/>
                  </cfinvoke>
                </td>
                <td  align="left" valign="top" width="50%"><cfinclude template="formProductos.cfm"></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>