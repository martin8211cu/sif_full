<cf_templateheader title="Mantenimiento de Configuración de la Bitácora">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Configuración de la Bitácora'>
		<table width="100%" border="0" cellspacing="6">
			<tr>
    			<td valign="top">

					<cfinvoke component="sif.Componentes.pListas" method="pLista" conexion="asp"
						tabla="PBitacora"
						columnas="PBtabla,PCache"
                        filtro="1=1 order by PBtabla"
						desplegar="PBtabla,PCache"
						etiquetas="Tabla,Cache"
						formatos="S,S"
						align="left,left"
						ira="PBitacora.cfm"
						form_method="post"
						keys="PBtabla"
						PageIndex="1"
					/>
				</td>

				<td valign="top">
					<cfinclude template="tablas-form.cfm">
				</td>
  			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


