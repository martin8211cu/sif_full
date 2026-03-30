<form name="lista" action="OCComplementoArticulo.cfm" method="post">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="Articulos a"
		columnas="Aid,Acodigo, 
				Adescripcion, 
				case when (select count(1) from OCcomplementoArticulo oc where oc.Aid = a.Aid) > 0 then 'S' else 'N' end as TieneComplemento,
				((select min(CFcomplementoTransito) from OCcomplementoArticulo oc where oc.Aid = a.Aid)) as ComplementoTransito,
				((select min(CFcomplementoCostoVenta) from OCcomplementoArticulo oc where oc.Aid = a.Aid)) as ComplementoVentas,
				((select min(CFcomplementoIngreso) from OCcomplementoArticulo oc where oc.Aid = a.Aid)) as CFcomplementoIngreso"
		filtro="Ecodigo = #Session.Ecodigo# order by Acodigo"
		desplegar="Acodigo,Adescripcion,TieneComplemento,ComplementoTransito,ComplementoVentas,CFcomplementoIngreso"
		etiquetas="Código,Artículo,Tiene Complemento,Complemento Transito,Complemento Ventas,Complemento Ingreso"
		formatos="S,S,U,U,U,U"
		align="left,left,left,left,left,left"
		ira="OCComplementoArticulo.cfm"
		form_method="post"
		incluirForm="no"
		keys="Aid,TieneComplemento"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
	/>
</form>

