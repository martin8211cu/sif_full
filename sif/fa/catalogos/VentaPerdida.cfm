<cf_templateheader title="Tipo de Venta Perdida">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Tipo de Venta Perdida">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  	<td valign="top" width="30%">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 		value="TipoVentaPerdida"/>
						<cfinvokeargument name="columnas" 	value="Ecodigo ,VPid ,VPnombre"/>
						<cfinvokeargument name="desplegar" 	value="VPnombre"/>
						<cfinvokeargument name="etiquetas" 	value="Descripción"/>
						<cfinvokeargument name="formatos" 	value="S"/>
						<cfinvokeargument name="filtro" 	value="Ecodigo = #Session.Ecodigo#"/>
						<cfinvokeargument name="align" 		value="left"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" 		value="VentaPerdida.cfm"/>
					</cfinvoke>
				</td>
				<td >
					<cfinclude template="VentaPerdida_form.cfm">
				</td>
			  </tr>
			</table> 
		<cf_web_portlet_end>
<cf_templatefooter>