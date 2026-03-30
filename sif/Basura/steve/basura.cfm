<cfinvoke component="cmMisFunciones" method="tmp_MostrarTabla" returnvariable="rs" />

<cf_web_portlet border="true" titulo="LISTA DE CLIENTES" skin="info1">
<table width="100%">
	<tr><td></td></tr>
	<tr>
		<td colspan="2">
			<cfinvoke 
				component="sif.rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
					query="#rs#"
					Conexion="minisif"
					desplegar="cedula,nombre,apellidos"
					etiquetas="C&eacute;dula,Nombre,Apellidos"
					formatos="S,S,S"
					align="left,left,left"
					ajustar="S,S,S"
					irA="basura2.cfm"
					showEmptyListMsg="true"
					form_method="get">
			</cfinvoke>		
		</td>
	</tr>
	<tr> 
	  <td colspan="2" align="right">&nbsp;</td>
  </tr>
  	<form name="fMantenimiento" method="get" action="basura2.cfm">
		<tr bgcolor="#CCCCCC">
			<td width="45%" align="right">
				<input name="btnNuevo" type="submit" value="Nuevo">
			<td width="44%" align="right">&nbsp;</td>
		</tr>
	</form>
</table>
</cf_web_portlet>