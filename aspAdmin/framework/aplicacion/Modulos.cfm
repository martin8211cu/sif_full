<table width="98%" cellpadding="0" cellspacing="0" style="padding-left: 5px; padding-right: 5px;">
	<tr>
		<td width="50%" valign="top">

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Modulo"/>
				<cfinvokeargument name="columnas" value="sistema, modulo, orden, nombre, case facturacion when '0' then 'Tarifa Fija' when '1' then 'Comisión por Servicio' when '2' then 'Cálculo Especial' end as facturacion, 'CAMBIO' as s_modo, 'CAMBIO' as m_modo"/>
				<cfinvokeargument name="desplegar" value="orden, modulo,nombre,facturacion"/>
				<cfinvokeargument name="etiquetas" value="Orden,M&oacute;dulo,Nombre,Facturacion"/>
				<cfinvokeargument name="formatos" value="V,V,V,V"/>
				<cfinvokeargument name="filtro" value="sistema='#form.sistema#' and activo=1 order by orden"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="irA" value="SistemasPrincipal.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="formName" value="listaModulo"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="keys" value="modulo"/>
			</cfinvoke>
		</td>
		
		<td width="50%" valign="top">
			<cfinclude template="formModulos.cfm">
		</td>
		
	</tr>
</table>