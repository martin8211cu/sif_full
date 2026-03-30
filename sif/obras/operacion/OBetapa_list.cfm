<cf_cboOBPid conControl="true">
<cf_dbfunction name="to_char" args="OBEid" returnvariable="LvarOBEidToChar">
<cf_dbfunction name="OP_concat" returnvariable="_CAT">

<cfquery datasource="#session.dsn#" name="rsStatus">
	select '' as value, '(todas...) ' as description from dual
	UNION
	select '0' as value, 'Nuevas' as description from dual
	UNION
	select '1' as value, 'Abiertas' as description from dual
	UNION
	select '2' as value, 'Cerradas' as description from dual
	order by value
</cfquery>
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="		OBetapa e 
					inner join Oficinas o 
					   on o.Ecodigo=e.Ecodigo and o.Ocodigo=e.Ocodigo
					inner join OBobra ob
					   on ob.OBOid=e.OBOid
		"
	columnas="e.OBOid,
				'Obra: ' #_CAT# OBOcodigo #_CAT# ' ' #_CAT# OBOdescripcion as Obra, 
				'&nbsp;&nbsp;Oficina: ' #_CAT# Oficodigo #_CAT# ' ' #_CAT# Odescripcion as Oficina, 
				e.OBEid,e.OBEcodigo,e.OBEdescripcion,
				case OBEestado 
					when '0' then 'Nueva'
					when '1' then 'Abierta'
					when '2' then 'Cerrada'
				end as Estado
				,case OBEestado 
					when '0' then 
						        '<img src=''/cfmx/sif/imagenes/arrow3.gif''	title=''Abrir una Etapa inactiva'' style=''cursor:pointer;'' 		onclick=''fnOperacion(""A"", ' #_CAT# #LvarOBEidToChar# #_CAT# ');''>'
					when '1' then 
						        '<img src=''/cfmx/sif/imagenes/pause3.gif''		title=''Cerrar una Etapa abierta'' style=''cursor:pointer;'' 		onclick=''fnOperacion(""C"", ' #_CAT# #LvarOBEidToChar# #_CAT# ');''>'
						#_CAT#'&nbsp;<img src=''/cfmx/sif/imagenes/Base.gif''		title=''Activar Cuentas Nuevas'' style=''cursor:pointer;''	onclick=''fnOperacion(""G"", ' #_CAT# #LvarOBEidToChar# #_CAT# ');''>'
						#_CAT#'&nbsp;<img src=''/cfmx/sif/imagenes/w-check.gif''	title=''Verificar Reglas Nuevas'' style=''cursor:pointer;''	onclick=''fnOperacion(""V"", ' #_CAT# #LvarOBEidToChar# #_CAT# ');''>'
					when '2' then 
						        '<img src=''/cfmx/sif/imagenes/arrow3.gif''	title=''Abrir una Etapa cerrada'' style=''cursor:pointer;'' 			onclick=''fnOperacion(""A"", ' #_CAT# #LvarOBEidToChar# #_CAT# ');''>'
				end as imagen
	"
	filtro="e.OBPid=#session.Obras.OBPid# 
			and ob.OBOestado = '1'
			order by e.OBOid, e.Ocodigo, e.OBEcodigo"
	cortes="Obra,Oficina"
	desplegar="imagen, OBEcodigo,OBEdescripcion,Estado"
	etiquetas="OP,Código,Descripcion de la Etapa,Estado"
	formatos="S,S,S,S"
	align="center,left,left,left"
	ira="OBetapa.cfm"
	form_method="post"
	keys="OBEid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_por="'Obra: ' #_CAT# OBOcodigo #_CAT# ' ' #_CAT# OBOdescripcion, OBEcodigo,OBEdescripcion,OBEestado"
	rsEstado="#rsStatus#"
	showlink="yes"
/>
<font style="font-size:11px">
<BR><strong>Operaciones:</strong><BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/arrow3.gif" title="Abrir" /> Abrir Etapa<BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/pause3.gif" title="Cerrar" /> Cerrar Etapa<BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/Base.gif" title="Generar Cuentas Presupuesto" /> Activar Cuentas Nuevas<BR>
</font>
<script language="javascript">
	function fnOperacion(tipo, OBEid)
	{
		document.lista.nosubmit = true;
		if (tipo == 'G')
		{
			if (!confirm('¿Desea activar todas la Cuentas Financieras nuevas de la etapa?'))
				return;
		}
		else if (tipo == 'V')
		{
			if (!confirm('¿Desea verificar las reglas de todas la Cuentas Financieras activas de la etapa?'))
				return;
		}
		else if (tipo == 'C')
		{
			if (!confirm('¿Desea cerrar la Etapa y bloquear todas sus Cuentas Financieras Activas?'))
				return;
		}
		location.href='OBetapa_sql.cfm?OP=' + tipo + '&OBEid=' + OBEid;
	}
</script>