<cfquery datasource="#session.dsn#" name="cobros">
	select
		p.Pnombre, p.Papellido1, p.Papellido2, p.Pid,
		r.nombre_programa,
		v.nombre_vigencia,
		c.fecha_cobro, c.moneda,
		c.importe,
		c.importe - c.pagado as saldo
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
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	<cfif IsDefined('url.cobros')>
	  and c.id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cobros#" list="yes">)
	<cfelse>
	  and c.id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cobros#" list="yes">)
	</cfif>
</cfquery>
<cfquery dbtype="query" name="total_header">
	select sum (saldo) as saldo, sum(importe) as importe, max(moneda) as moneda
	from cobros
</cfquery>
<cfquery dbtype="query" name="count_monedas">
	select count(distinct moneda) as cnt from cobros
</cfquery>
<cfif count_monedas.cnt gt 1>
	<cfthrow message="Debe realizar los pagos de cada moneda por separado">
</cfif>

Cobros seleccionados:
<cfinvoke component="sif.rh.Componentes.pListas" method="pListaQuery"
	query="#cobros#"
	desplegar="Pnombre,Papellido1,Papellido2,Pid,nombre_programa,nombre_vigencia,fecha_cobro,moneda,importe,saldo"
	etiquetas="Nombre,Apellidos, ,C&eacute;dula,Programa,Vigencia,Fecha, ,Importe,Saldo"
	align="left,left,left,left,left,left,left,right,right,right"
	formatos="S,S,S,S,S,S,D,S,M,M"
	irA="javascript:void(0)"
	MAXROWS="0"
	totales="importe,saldo" />
