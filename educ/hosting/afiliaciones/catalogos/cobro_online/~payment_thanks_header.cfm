<cfquery datasource="#session.dsn#" name="cobros">
	select
		p.Pnombre, p.Papellido1, p.Papellido2, p.Pid,
		r.nombre_programa,
		v.nombre_vigencia,
		c.fecha_cobro, c.moneda,
		c.importe,
		pa.importe_doc, pa.moneda_doc,
		pa.importe_pago, pa.moneda_pago,
		g.importe as importe_total_pago,
		g.moneda  as moneda_total_pago
	from sa_cobros c
		join sa_afiliaciones a
			on  a.id_persona = c.id_persona
			and a.id_programa = c.id_programa
			and a.id_vigencia = c.id_vigencia
		join sa_vigencia v
			on  v.id_programa = c.id_programa
			and v.id_vigencia = c.id_vigencia
		join sa_programas r
			on  r.id_programa = c.id_programa
		join sa_personas p
			on  p.id_persona = c.id_persona
		join sa_pago_aplicado pa
			on  pa.id_persona = c.id_persona
			and pa.id_programa = c.id_programa
			and pa.id_vigencia = c.id_vigencia
			and pa.id_cobro    = c.id_cobro
		join sa_pagos g
			on  g.id_pago     = pa.id_pago
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and pa.id_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pago#" list="yes">
</cfquery>
Cobros seleccionados:
<cfinvoke component="sif.rh.Componentes.pListas" method="pListaQuery"
	query="#cobros#"
	desplegar="Pnombre,Papellido1,Papellido2,Pid,nombre_programa,nombre_vigencia,fecha_cobro,moneda,importe,importe_pago"
	etiquetas="Nombre,Apellidos, ,C&eacute;dula,Programa,Vigencia,Fecha, ,Importe,Pago"
	align="left,left,left,left,left,left,left,right,right,right"
	formatos="S,S,S,S,S,S,D,S,M,M"
	irA="javascript:void(0)"
	MAXROWS="0"
	totales="importe,importe_pago" />
<cfoutput>
<table width="100%">
<tr><td class="subTitulo tituloListas">Pago recibido: &nbsp; #cobros.moneda_total_pago# #NumberFormat(cobros.importe_total_pago,',0.00')#</td></tr>
</table>
</cfoutput>
