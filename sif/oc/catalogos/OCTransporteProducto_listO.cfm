<cf_dbfunction name="to_char" args="a.OCid" returnvariable="vOCid">
<cf_dbfunction name="to_char" args="a.Aid" returnvariable="vAid">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="OCtransporteProducto a 
			inner join OCordenProducto b
					on  a.OCid = b.OCid
					and a.Aid = b.Aid	
					and a.Ecodigo = b.Ecodigo
			inner join OCordenComercial c
				on  b.OCid = c.OCid
				and b.Ecodigo = c.Ecodigo
			inner join Articulos d
				on b.Aid      = d.Aid
				and b.Ecodigo = d.Ecodigo"
	columnas="a.OCid,a.Aid,a.OCTid,c.OCcontrato,d.Acodigo,OCTPcantidadTeorica,OCTPprecioUniTeorico,OCTPprecioTotTeorico,
	'<img src=''../../imagenes/Borrar01_S.gif'' onclick=''javascript: eliminar(' #_Cat# #vOCid# #_Cat# ',' #_Cat# #vAid# #_Cat#');'' />' as imagen"
	filtro="a.OCTid=#form.OCTid# and a.Ecodigo = #Session.Ecodigo# and a.OCtipoOD = 'O' order by c.OCcontrato,b.Aid"
	desplegar="OCcontrato,Acodigo,OCTPcantidadTeorica,OCTPprecioUniTeorico,OCTPprecioTotTeorico,imagen"
	etiquetas="Contrato,Artículo,Cantidad,precio unitario,Total,&nbsp;"
	formatos="S,S,UM,UM,UM,U"
	align="left,left,right,right,right,right"
	ajustar="N"
	ira="OCordenComercial.cfm"
	form_method="post"
	keys="OCid,Aid,OCTid"
	mostrar_filtro="no"
	showLink="false"
	formName ="form3"
	filtrar_automatico="yes"
	
/>


