
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="OCordenProducto a
	inner join Unidades u
		on a.Ecodigo = u.Ecodigo
		and a.Ucodigo = u.Ucodigo  
	inner join Articulos b
		on a.Ecodigo = b.Ecodigo
		and a.Aid = b.Aid"
	columnas="a.Aid,a.OCid,a.OCPlinea,b.Acodigo,u.Udescripcion,OCPcantidad,OCPprecioUnitario,OCPprecioTotal"
	filtro="a.OCid=#form.OCid# and a.Ecodigo = #Session.Ecodigo# order by a.Ucodigo,b.Acodigo"
	desplegar="OCPlinea,Acodigo,Udescripcion,OCPcantidad,OCPprecioUnitario"
	etiquetas="Línea,Artículo,Unidad,Cantidad,Precio Unitario"
	formatos="S,S,S,M,UM"
	ajustar="N"
	align="right,left,left,right,right"
	ira="OCordenComercial.cfm"
	form_method="post"
	keys="Aid,OCid"
	mostrar_filtro="no"
	filtrar_automatico="yes"
	
/>
