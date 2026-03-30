<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetE" returnvariable="rsEs">
</cfinvoke>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsEs#"
	desplegar="RHEVFcodigo,RHEVFdescripcion"
	etiquetas="#LB_Codigo#,#LB_Descripcion#"
	formatos="S,S"
	align="left,left"
	ira="Valoracion.cfm"
	showlink="true" 
	incluyeform="true"
	form_method="post"
	showEmptyListMsg="yes"
	keys="RHEVFid"
	botones="Nuevo"	
	usaAJAX = "true"
	conexion = "#session.DSN#"	
	PageIndex = "1"
	mostrar_filtro 	="true"		
/>		

