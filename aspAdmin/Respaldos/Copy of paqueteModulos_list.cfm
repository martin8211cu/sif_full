<table width="100%" border="0" cellspacing="0" cellpadding="0">	
  <tr>
	<td valign="top" width="45%">	
		<cfinvoke component="aspAdmin.Componentes.pListasASP" 
				  method="pLista" 
				  returnvariable="pListaModulosXPaquete">
			<cfinvokeargument name="tabla" value="
					PaqueteModulo pm
					, Paquete p
					, Modulo m"/>
			<cfinvokeargument name="columnas" value="
					convert(varchar, pm.PAcodigo) as PAcodigo
					, pm.modulo
					, nombre"/>
			<cfinvokeargument name="desplegar" value="nombre"/>
			<cfinvokeargument name="etiquetas" value="M&oacute;dulo"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value="
					pm.PAcodigo = #form.PAcodigo#
					and activo = 1
					and pm.PAcodigo=p.PAcodigo
					and pm.modulo=m.modulo
					order by orden"/>
			<cfinvokeargument name="align" value="left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="PAcodigo,modulo"/>
			<cfinvokeargument name="irA" value="paquete.cfm"/>
			<cfinvokeargument name="formName" value="form_listaModulosXPaquete"/>
		</cfinvoke> 		
	</td>
	<td valign="top" width="55%">
			<cfinclude template="paqueteModulos_form.cfm">
	</td>
  </tr>
</table> 
