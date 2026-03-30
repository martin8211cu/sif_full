<form name="lista" action="OCComplementoSocio.cfm" method="post">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="SNegocios s left join OCcomplementoSNegocio cs on cs.SNid = s.SNid"
		columnas="s.SNid,s.SNnumero, s.SNnombre, 
				case when cs.SNid is null then 'N' else 'S' end as TieneComplemento,
				coalesce(CFcomplementoTransito,cuentac) 	as ComplementoTransito,
				coalesce(CFcomplementoCostoVenta,cuentac)	as ComplementoVentas,
				coalesce(CFcomplementoIngreso,cuentac)		as CFcomplementoIngreso"
		filtro="s.Ecodigo = #Session.Ecodigo# order by SNnumero"
		desplegar="SNnumero,SNnombre,TieneComplemento,ComplementoTransito,ComplementoVentas,CFcomplementoIngreso"
		etiquetas="Número,Nombre,Tiene Complemento,Complemento Transito,Complemento Ventas,Complemento Ingreso"
		formatos="S,S,U,U,U,U"
		align="left,left,left,left,left,left"
		ira="OCComplementoSocio.cfm"
		form_method="post"
		incluirForm="no"
		keys="SNid,TieneComplemento"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
	/>
</form>

