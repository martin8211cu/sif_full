<form name="lista" action="OCordenComercial.cfm" method="post">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="OCordenComercial"
		columnas="case OCtipoOD when 'O' then 'ORIGENES' when 'D' then 'DESTINOS' end as OCtipoOD,case OCtipoIC when 'I' then 'Inventario' when 'C' then 'Comercial' when 'V' then 'Venta Almacén' end as OCtipoIC,  OCid,OCcontrato,OCfecha,OCtrade_num,OCorder_num"
		filtro="Ecodigo = #Session.Ecodigo# order by OCtipoOD desc,OCtipoIC,OCfecha"
		desplegar="OCfecha,OCcontrato,OCtrade_num,OCorder_num"
		etiquetas="Fecha,Orden Comercial,No.&nbsp;Trade,No.&nbsp;Order"
		formatos="D,S,I,I"
		Cortes= "OCtipoOD,OCtipoIC"
		align="left,left,left,left"
		ira="OCordenComercial.cfm"
		form_method="post"
		incluirForm="no"
		keys="OCid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo,Importar"
	/>
</form>