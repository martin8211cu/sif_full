<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfset LvarFiltro = "d.Ecodigo = #session.Ecodigo#">
<cfif session.Obras.OBD.OBEid NEQ "">
	<cfset LvarFiltro	= LvarFiltro & " and d.OBEid = #form.OBEid#">
	<cfset LvarBotones	= "Nuevo">
<cfelseif session.Obras.OBD.OBOid NEQ "">
	<cfset LvarFiltro	= LvarFiltro & " and d.OBOid = #form.OBOid#">
	<cfset LvarBotones	= "Obra">
	<cfif NOT isdefined("url.btnEtapas")>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBEid IS NULL">
		<cfset LvarBotones	= "Nuevo,Etapas">
	</cfif>
<cfelseif session.Obras.OBD.OBPid NEQ "">
	<cfset LvarFiltro	= LvarFiltro & " and d.OBPid = #form.OBPid#">
		<cfset LvarBotones	= "Proyecto,Obras,Etapas">
	<cfif isdefined("url.btnObras")>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBEid IS NULL">
		<cfset LvarBotones	= "Proyecto,Etapas">
	<cfelseif isdefined("url.btnEtapas")>
		<cfset LvarFiltro	= LvarFiltro & "">
		<cfset LvarBotones	= "Proyecto,Obras">
	<cfelse>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBOid IS NULL">
		<cfset LvarBotones	= "Nuevo,Obras,Etapas">
	</cfif>
<cfelseif session.Obras.OBD.OBTPid NEQ "">
	<cfset LvarFiltro	= LvarFiltro & " and d.OBTPid = #form.OBTPid#">
	<cfif isdefined("url.btnProyectos")>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBOid IS NULL">
		<cfset LvarBotones	= "Tipo_Proyecto,Obras,Etapas">
	<cfelseif isdefined("url.btnObras")>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBEid IS NULL">
		<cfset LvarBotones	= "Tipo_Proyecto,Proyectos,Etapas">
	<cfelseif isdefined("url.btnEtapas")>
		<cfset LvarFiltro	= LvarFiltro & "">
		<cfset LvarBotones	= "Tipo_Proyecto,Proyectos,Obras">
	<cfelse>
		<cfset LvarFiltro	= LvarFiltro & " and d.OBPid IS NULL">
		<cfset LvarBotones	= "Nuevo,Proyectos,Obras,Etapas">
	</cfif>
<cfelse>
	<cfset LvarBotones = "">
	<cfset LvarCortes = "TipoProyecto,Proyecto,Obra,Etapa">
</cfif>
<cfif LvarBotones NEQ "">
	<cfset LvarBotones	= "Nuevo">
	<cfset LvarCortes = "">
</cfif>

<cf_dbfunction name="to_char" args="OBDid" datasource="#Session.DSN#" returnvariable="LvarOBDid">
<cfset LvarImgDelete	= "'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Borrar01_S.gif'' onClick=''javascript:sbDelete(' #_CAT# #LvarOBDid# #_CAT# ');''>'">
<cfset LvarImgDownload	= "case when OBDarchivo <> '*TEXTO*' then '<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/RS_D.gif'' onClick=''javascript:sbDownload(' #_CAT# #LvarOBDid# #_CAT# ');''>' end">
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="
			OBdocumentacion d
				left join OBtipoProyecto tp
					on tp.OBTPid = d.OBTPid
				left join OBproyecto p
					on p.OBPid = d.OBPid
				left join OBobra o
					on o.OBOid = d.OBOid
				left join OBetapa e
					on e.OBEid = d.OBEid
		"
	columnas="
				'TIPO PROYECTO:	' #_CAT# tp.OBTPcodigo #_CAT# ' - ' #_CAT# tp.OBTPdescripcion as TipoProyecto
			,	case 
					when p.OBPid is not null then
						'&nbsp;&nbsp;PROYECTO: ' #_CAT# p.OBPcodigo #_CAT# ' - ' #_CAT# p.OBPdescripcion 
				end as Proyecto
			,	case 
					when o.OBOid is not null then 
						'&nbsp;&nbsp;&nbsp;&nbsp;OBRA: ' #_CAT# o.OBOcodigo #_CAT# ' - ' #_CAT# o.OBOdescripcion 
				end as Obra
			,	case 
					when e.OBEid is not null then 
						'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ETAPA: ' #_CAT# e.OBEcodigo #_CAT# ' - ' #_CAT# e.OBEdescripcion 
				end as Etapa
			,	tp.OBTPid, p.OBPid, o.OBOid, e.OBEid, d.OBDid, OBDarchivo, OBDdescripcion
			, 	#LvarImgDownload# as Descargar
		"
	filtro="#LvarFiltro# order by tp.OBTPcodigo, p.OBPcodigo, o.OBOcodigo, e.OBEcodigo, OBDfechaInclusion"
	cortes="#LvarCortes#"
	desplegar="OBDdescripcion, OBDarchivo, Descargar"
	etiquetas="Descripcion, Archivo, Descargar"
	formatos="S,S,U"
	align="left, left, center"
	ira="OBdocumentacion.cfm"
	form_method="post"
	keys="OBDid"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	botones="#LvarBotones#"
	formName="formLista"
/>
<script language="javascript">
	function funcTipo_Proyecto()
	{
		location.href = "OBdocumentacion.cfm";
		return false;
	}
	function funcProyectos()
	{
		location.href = "OBdocumentacion.cfm?btnProyectos=1";
		return false;
	}
	function funcProyecto()
	{
		location.href = "OBdocumentacion.cfm";
		return false;
	}
	function funcObras()
	{
		location.href = "OBdocumentacion.cfm?btnObras=1";
		return false;
	}
	function funcObra()
	{
		location.href = "OBdocumentacion.cfm";
		return false;
	}
	function funcEtapas()
	{
		location.href = "OBdocumentacion.cfm?btnEtapas=1";
		return false;
	}
	function funcEtapa()
	{
		location.href = "OBdocumentacion.cfm";
		return false;
	}

	function sbDownload(OBDid)
	{
		document.formLista.nosubmit = true;
		location.href = "OBdocumentacion_sql.cfm?OBDid=" + OBDid + "&Download";
	}
	function sbDelete(OBDid)
	{
		if (confirm("¿Desea Eliminar el Registro?"))
		{
			document.formLista.nosubmit = true;
			location.href = "OBdocumentacion_sql.cfm?OBDid=" + OBDid + "&Baja";
		}
		else
		{
			document.formLista.nosubmit = true;
			return false;
		}
	}
</script>