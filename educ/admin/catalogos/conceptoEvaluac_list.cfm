<script language="javascript" type="text/javascript">
	function bajar(cod) {
		document.listaConceptos.CECODIGO.value = cod;
		document.listaConceptos._ActionTag.value = "pushDown";
		document.listaConceptos.action = "conceptoEvaluac_SQL.cfm";
		document.listaConceptos.submit();
	}
	
	function subir(cod) {
		document.listaConceptos.CECODIGO.value = cod;
		document.listaConceptos._ActionTag.value = "pushUp";
		document.listaConceptos.action = "conceptoEvaluac_SQL.cfm";
		document.listaConceptos.submit();
	}
</script>


	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td width="40%" valign="top">
				<cfif session.monitoreo.SMcodigo EQ "CAPACITA"><cfset LvarFiltro = "CEorigen = 1"><cfelseif session.monitoreo.SMcodigo EQ "RECLUTA"><cfset LvarFiltro = "CEorigen = 2"><cfelse><cfset LvarFiltro = "CEorigen = 0"></cfif>
				<cfinvoke component="educ.componentes.pListas" 
						  method="pListaEdu" 
						  returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ConceptoEvaluacion"/>
					<cfinvokeargument name="columnas" value="convert(varchar,CEcodigo) as CEcodigo
							, CEnombre
							, CEorden
							, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
					, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>
					<cfinvokeargument name="desplegar" value="CEnombre,  upImg, downImg"/>
					<cfinvokeargument name="etiquetas" value="Nombre Concepto,  &nbsp;, &nbsp;"/>
					<cfinvokeargument name="formatos"  value="V,IMG,IMG"/>
					<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# AND #LvarFiltro# order by CEorden, upper(CEnombre)"/>
					<cfinvokeargument name="align" value="left,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="funcion" value=" , subir, bajar"/>
					<cfinvokeargument name="fparams" value="CEcodigo"/>
					<cfinvokeargument name="funcionByCols" value="true"/>
					<cfinvokeargument name="irA" value="conceptoEvaluac.cfm"/>
					<cfinvokeargument name="formName" value="listaConceptos"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="botones" value="Nuevo"/>					
				</cfinvoke>
			</td>
		</tr>	
	</table>		  
