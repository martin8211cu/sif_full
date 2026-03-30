<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Sistema"/>
				<cfinvokeargument name="columnas" value="rtrim(sistema) as sistema, nombre, rtrim(nombre_cache) as nombre_cache,orden,'CAMBIO' as s_modo"/>
				<cfinvokeargument name="desplegar" value="orden,sistema,nombre,nombre_cache"/>
				<cfinvokeargument name="etiquetas" value="Orden,Sistema,Nombre,Conexión"/>
				<cfinvokeargument name="formatos" value="S,S,S,S"/>
				<cfinvokeargument name="filtro" value="activo = 1 order by orden, upper(sistema)"/>
				<cfinvokeargument name="align" value="rigth,left,left,left"/>
				<cfinvokeargument name="ajustar" value="s"/>
				<cfinvokeargument name="irA" value="SistemasPrincipal.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="sistema"/>
			</cfinvoke>
		</td>
		<td valign="top" width="50%"><cfinclude template="formSistemas.cfm"></td>
	</tr>
</table>