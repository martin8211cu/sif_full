<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cf_cboOBPid OBPid="#session.obras.OBPid#">

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="	OBproyectoReglas pr
			left join Oficinas o
			  on pr.Ecodigo = o.Ecodigo
			 and pr.Ocodigo = o.Ocodigo"
	columnas="OBPRid,CFformatoRegla,
				case when pr.Ocodigo is null then 'Reglas Generales'
				     else 'Reglas para la oficina: ' #_Cat# Oficodigo #_Cat# ' - ' #_Cat# Odescripcion
				end as Oficina"
	filtro="	  pr.Ecodigo	= #session.Ecodigo# 
			  and pr.OBPid		= #session.obras.OBPid# 
			order by Oficodigo"
	cortes="Oficina"
	desplegar="CFformatoRegla"
	etiquetas="Regla de Inclusion"
	formatos="S"
	align="left"
	ira="OBproyecto.cfm"
	form_method="post"
	keys="OBPRid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	formName="listaOBPR"
/>
