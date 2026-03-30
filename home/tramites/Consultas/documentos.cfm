<cfset request.diccdatoui = CreateObject("component", "diccdatoui")>

<cfquery name="rsReporte" datasource="#session.tramites.dsn#">
select 

b.id_inst,
b.codigo_inst,
b.nombre_inst,

a.id_documento,
a.codigo_documento,
a.nombre_documento,
a.vigente_desde,
a.vigente_hasta,
a.descripcion_documento,
a.id_tipo,

case a.es_pago
when 1 then 'Si'
else 'No' end as es_pago,

a.moneda_pago,

c.id_tipodoc,
c.codigo_tipodoc,
c.nombre_tipodoc,

d.id_campo,
d.nombre_campo,

case e.es_persona
when 1 then 'Si'
else 'No' end
as es_persona,

f.id_tipoident, 
f.nombre_tipoident,


g.id_tipo as req_id_tipo,
g.id_campo as req_id_campo,
g.id_tipocampo as req_id_tipocampo,
g.orden_campo as req_orden_campo,
g.nombre_campo as req_nombre_campo,
'' as req_tipo,

case when g.es_llave      =1 then 'I' else null end ||
case when g.es_obligatorio=1 then 'R' else null end ||
case when g.es_descripcion=1 then 'L' else null end
as req_flgs,

h.es_documento as req_es_documento,
h.clase_tipo as req_clase_tipo,
h.tipo_dato as req_tipo_dato,
h.nombre_tabla as req_nombre_tabla,
h.longitud as req_longitud,
h.escala as req_escala,
(select nombre_documento from TPDocumento dc where dc.id_tipo = h.id_tipo) as req_nombre_documento,
h.es_persona as req_es_persona,

gg.nombre_campo as req_nombre_campo2,
hh.clase_tipo as req_clase_tipo2,
hh.es_documento as req_es_documento2,
hh.tipo_dato as req_tipo_dato2,
hh.nombre_tabla as req_nombre_tabla2,
hh.longitud as req_longitud2,
hh.escala as req_escala2,
(select nombre_documento from TPDocumento dc where dc.id_tipo = hh.id_tipo)as req_nombre_documento2

from
	TPDocumento a
	
	left outer join TPInstitucion b
	on b.id_inst = a.id_inst

	left outer join TPTipoDocumento c
	on c.id_tipodoc = a.id_tipodoc

	left outer join DDTipoCampo d
	on d.id_campo = a.id_campo_pago		

	left outer join DDTipo e
	on e.id_tipo = a.id_tipo		

	left outer join TPTipoIdent f
	on f.id_tipo = a.id_tipo


    left outer join DDTipoCampo g
	on g.id_tipo = a.id_tipo
   
	left outer join  DDTipo h
   	on h.id_tipo = g.id_tipocampo	

	left join DDTipoCampo gg 
	on gg.id_tipo = g.id_tipocampo
	and gg.es_llave = 1

	left join DDTipo hh
	on hh.id_tipo = gg.id_tipocampo	
	 	
order by b.id_inst, id_documento,g.orden_campo
</cfquery>

<cfset formato = "flashpaper">

<cfreport format="#formato#" template= "documentos.cfr" query="rsReporte">
	<!--- <cfreportparam name="req_tipo" value="#rsReporte.req_tipo#"> --->
	<!--- <cfreportparam name="id_requisito" value="#form.id_requisito#"> --->
	<!--- <cfreportparam name="Edescripcion" value="#session.Enombre#"> --->
</cfreport>
