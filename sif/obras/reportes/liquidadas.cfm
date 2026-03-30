<cfset LvarTitulo = "Reporte Contable de Obras liquidadas">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cf_cboOBPid>
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="OBobra"
			columnas="OBOid,OBOcodigo,OBOdescripcion, 
						case OBOestado 
							when '0' then 'Inactivo'
							when '1' then 'Abierto'
							when '2' then 'Cerrado'
							when '3' then 'Liquidado'
						end as Estado	
					"
			filtro="OBPid=#session.obras.OBPid# AND OBOestado = '3' order by OBOcodigo,OBOdescripcion"
			desplegar="OBOcodigo,OBOdescripcion,Estado"
			etiquetas="Codigo,Descripcion de la Obra,Estado"
			formatos="S,S,S"
			align="left,left,left"
			ira="liquidadas_imprimir.cfm"
			form_method="post"
			keys="OBOid"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
		/>
	<cf_web_portlet_end>
<cf_templatefooter>
