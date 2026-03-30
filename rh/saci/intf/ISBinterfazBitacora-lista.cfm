<cf_templateheader title="Monitor de interfaces">
<cf_web_portlet_start titulo="Mensajes de interfaces">
<style type="text/css">
.pStyle_msg { width:500px; }
.pStyle_asunto, .pStyle_fecha, .pStyle_codMensaje {
	white-space:nowrap;
}
</style>
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBinterfazBitacora a
			left join ISBinterfazDetalle b
				on a.IBid = b.IBid
				and b.IBlinea = (select max(c.IBlinea) from ISBinterfazDetalle c
					where a.IBid = c.IBid)"
		columnas="top 500 a.IBid, a.interfaz,
			'<img align=top width=16 height=16 border=0 src=''' || 
			case 
				when a.severidad = 0 or resuelto_por is not null then 'info16.png''> '
				when a.severidad = -10 then 'debug16.png''> '
				when a.severidad = 10 then 'warning16.png''> '
				when a.severidad = 20 then 'error16.png''> '
			end  || coalesce (b.codMensaje, 'INFO') as codMensaje
			, a.fecha, b.msg, b.servicio, a.origen, a.asunto"
		filtro="1=1 order by a.IBid desc"
		desplegar="IBid,fecha,interfaz,origen,asunto,codMensaje,servicio,msg"
		filtrar_por="a.IBid,fecha,interfaz,origen,asunto,codMensaje,servicio,msg"
		etiquetas="Núm,Fecha,Interfaz,Origen,Asunto,Código,Servicio,Mensaje"
		formatos="S,DT,S,S,S,S,S,S"
		align="left,left,left,left,left,left,left,left"
		ira="ISBinterfazBitacora-form.cfm"
		form_method="get"
		keys="IBid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones=""
		showEmptyListMsg="yes"
		EmptyListMsg="No hay mensajes por mostrar"
		debug="N"
		maxRows="50"
	/>
<cf_web_portlet_end>
<cf_templatefooter>