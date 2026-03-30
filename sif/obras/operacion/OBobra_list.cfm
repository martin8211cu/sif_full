<cf_cboOBPid>
<cf_dbfunction name="to_char" args="OBOid" returnvariable="LvarOBOidToChar">
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
	tabla="OBobra"
	columnas="OBOid,OBOcodigo,OBOdescripcion, 
				case OBOestado 
					when '0' then 'Nueva'
					when '1' then 'Abierta'
					when '2' then 'Cerrada'
					when '3' then 'Liquidada'
				end as Estado,
				case OBOestado 
					when '0' then 
						        '<img src=''/cfmx/sif/imagenes/arrow3.gif''	title=''Abrir una Obra inactiva'' style=''cursor:pointer;'' 		onclick=''fnOperacion(""A"", ' #_CAT# #LvarOBOidToChar# #_CAT# ');''>'
					when '1' then 
						        '<img src=''/cfmx/sif/imagenes/pause3.gif''	title=''Cerrar una Obra abierta'' style=''cursor:pointer;'' 		onclick=''fnOperacion(""C"", ' #_CAT# #LvarOBOidToChar# #_CAT# ');''>'
						#_CAT#'&nbsp;<img src=''/cfmx/sif/imagenes/Base.gif''	title=''Generar las Cuentas de Presupuesto'' style=''cursor:pointer;''	onclick=''fnOperacion(""G"", ' #_CAT# #LvarOBOidToChar# #_CAT# ');''>'
					when '2' then 
						        '<img src=''/cfmx/sif/imagenes/arrow3.gif''	title=''Reactivar una Obra cerrada'' style=''cursor:pointer;'' 			onclick=''fnOperacion(""A"", ' #_CAT# #LvarOBOidToChar# #_CAT# ');''>'
						#_CAT#'&nbsp;<img src=''/cfmx/sif/imagenes/home.gif''	title=''Liquidar la Obra en Activos'' style=''cursor:pointer;''		onclick=''fnOperacion(""L"", ' #_CAT# #LvarOBOidToChar# #_CAT# ');''>'
				end as imagen
			"
	filtro="OBPid=#session.obras.OBPid# AND OBOestado <> '3' order by OBOcodigo,OBOdescripcion"
	desplegar="imagen, OBOcodigo,OBOdescripcion,Estado"
	etiquetas="OP,Codigo,Descripcion de la Obra,Estado"
	formatos="U,S,S,S"
	align="center,left,left,left"
	ira="OBobra.cfm"
	form_method="post"
	keys="OBOid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_por="OBOid,OBOcodigo,OBOdescripcion,OBOestado"
	rsEstado="#rsStatus#"
	showlink="no"
/>
<font style="font-size:11px">
<BR><strong>Operaciones:</strong><BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/arrow3.gif" title="Abrir" /> Abrir Obra<BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/pause3.gif" title="Cerrar" /> Cerrar Obra<BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/Base.gif" title="Generar Cuentas Presupuesto de toda la Obra" /> Activar Cuentas Nuevas de toda la Obra<BR>
&nbsp;&nbsp;<img src="/cfmx/sif/imagenes/home.gif" title="Liquidar" /> Liquidar Obra en Activo Fijo<BR>
</font>

<script>
	function fnOperacion(tipo, OBOid)
	{
		if (tipo == 'L')
		{
			location.href='OBobra.cfm?OP=L&OBOid=' + OBOid;
			return;
		}
		else if (tipo == 'G')
		{
			if (!confirm('¿Desea activar todas las Cuentas Financieras nuevas de todas las Etapas de la Obra?'))
				return;
		}
		location.href='OBobra_sql.cfm?OP=' + tipo + '&OBOid=' + OBOid;
	}
</script>
