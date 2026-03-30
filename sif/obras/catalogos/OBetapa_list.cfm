<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfquery datasource="#session.dsn#" name="rsOBO">
	select 	p.OBPid, p.OBPcodigo, p.OBPdescripcion, 
			o.OBOid, o.OBOcodigo, o.OBOdescripcion
	  from OBobra o
	  	inner join OBproyecto p
			on p.OBPid = o.OBPid
	 where o.OBOid=#form.OBOid#
</cfquery>
<cfoutput>
<table>
		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top">
				<strong>#rsOBO.OBPcodigo# - #rsOBO.OBPdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Obra</strong>
			</td>
			<td valign="top">
				&nbsp;&nbsp;&nbsp;
			</td>
			<td valign="top">
				<strong>#rsOBO.OBOcodigo# - #rsOBO.OBOdescripcion#</strong>
			</td>
		</tr>
</table>
</cfoutput>
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
	tabla="OBetapa e inner join Oficinas o on o.Ecodigo=e.Ecodigo and o.Ocodigo=e.Ocodigo"
	columnas="e.OBOid,'Oficina: ' #_CAT# Odescripcion as Oficina, e.OBEid,e.OBEcodigo,e.OBEdescripcion,
				case OBEestado 
					when '0' then 'Nueva'
					when '1' then 'Abierta'
					when '2' then 'Cerrada'
				end as Estado,
				#session.Ecodigo# as Ecodigo
	"
	filtro="e.OBOid=#form.OBOid# order by e.Ocodigo, e.OBEcodigo"
	cortes="Oficina"
	desplegar="OBEcodigo,OBEdescripcion,Estado"
	etiquetas="Código,Descripcion de la Etapa,Estado"
	formatos="S,S,S"
	align="left,left,left"
	ira="OBobra.cfm"
	form_method="post"
	keys="Ecodigo,OBOid,OBEid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_por="OBEcodigo,OBEdescripcion,OBEestado"
	rsEstado="#rsStatus#"
	botones=""
	pageIndex="2"
	formname="listaEtapa"
/>
<script language="javascript">
	function funcNuevo()
	{
		document.listaEtapa.OBOID.value = "<cfoutput>#form.OBOid#</cfoutput>";
		document.listaEtapa.OBEID.value = "";
	}
	document.listaEtapa.OBOID.value = "<cfoutput>#form.OBOid#</cfoutput>";
	document.listaEtapa.OBEID.value = "<cfoutput>#form.OBEid#</cfoutput>";
</script>