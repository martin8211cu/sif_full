<cf_cboOBPid OBPid="#session.obras.OBPid#">
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="OBproyectoOficinas po
			left join Oficinas o
			  on po.Ecodigo = o.Ecodigo
			 and po.Ocodigo = o.Ocodigo"
	columnas="po.Ecodigo, po.Ocodigo, Oficodigo, Odescripcion"
	filtro="	  po.Ecodigo	= #session.Ecodigo# 
			  and po.OBPid		= #session.obras.OBPid# 
			order by Oficodigo"
	desplegar="Oficodigo, Odescripcion"
	etiquetas="Codigo, Descripcion de Oficina"
	formatos="S,S"
	align="left,left"
	ira="OBproyecto.cfm"
	form_method="post"
	keys="Ecodigo,Ocodigo"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	formName="listaOBPO"
/>
