<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td>
		<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH"
			returnvariable="rsLista"
			columnas="RHTMid, RHTMcodigo, RHTMdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			tabla="RHTipoMovimiento"
			filtro="Ecodigo=#Session.Ecodigo# order by RHTMcodigo,RHTMdescripcion"
			mostrar_filtro="true"
			filtrar_automatico="true"
			desplegar="RHTMcodigo, RHTMdescripcion"
			filtrar_por="RHTMcodigo, RHTMdescripcion"
			align="left, left"
			botones="Nuevo"
			formatos="S, S"
			ira="RHtabsTipoMov.cfm"
		/>		
	</td>
  </tr>
</table>
