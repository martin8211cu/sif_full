
<cfif isdefined("url.id_requisito") and not isdefined("form.id_requisito")>
	<cfset form.id_requisito = url.id_requisito >
</cfif>




<cfquery name="request.rsReporte" datasource="#session.tramites.dsn#" maxrows=170>
select 
a.id_requisito,
a.descripcion_requisito as descripcion_requis,
a.codigo_requisito,
a.nombre_requisito,
a.vigente_desde,
a.vigente_hasta,
a.id_vistapopup,
<!--- case a.id_vistapopup
	 when null then 'No'
	 else 'Si' end as id_vistapop, 	 --->

case a.es_documental
	 when 0 then 'No'
	 else 'Si' end as es_document,

case a.es_custodia
	 when 0 then 'No'
	 else 'Si' end as es_custodi,

case a.es_personal
	 when 0 then 'No'
	 else 'Si' end as es_person,

case a.es_autoverificar
	 when 0 then 'No'
	 else 'Si' end as es_autover,

case a.es_conexion
	 when 0 then 'No'
	 else 'Si' end as es_conex,

case a.es_capturable
	 when 0 then 'No'
	 else 'Si' end as es_captur,

case a.es_impedimento
	 when 0 then 'Si'
	 else 'No' end as es_impediment,

case a.es_criterio_and
	 when 0 then 'No'
	 else 'Si' end as es_crit_and,

case a.texto_completado
	 when null then 'El requisito ha sido completado'
	 else  a.texto_completado end as texto_complet,

 		<!--- (D-Documental ,C-Servicios de Citas, P-Pago, A-Aprobacion o Visto Bueno) --->		
case a.comportamiento
	when 'D' then 'Documental'
	when 'C' then 'Servicios de Citas'
	when 'P' then 'Pago'
	when 'A' then 'Aprobacion o Visto Bueno'
	end as comport,

g.id_tiposerv, g.codigo_tiposerv, g.nombre_tiposerv,			<!--- /*Tipo servicio*/ --->
f.id_tiporeq, f.codigo_tiporeq, f.nombre_tiporeq,				<!--- /*(id_tiporeq : id_tiporeq - codigo_tiporeq- nombre_tiporeq*/ --->
h.id_inst, h.codigo_inst, h.nombre_inst,			<!--- /*Institucion Responsable*/ --->
i.id_documento, i.codigo_documento, i.nombre_documento,

a.id_documento_pago,
(select m.nombre_documento
 from TPDocumento m
 where m.id_documento = a.id_documento_pago)as documentoPago

,c.id_tipoident,									<!--- Lista de identificadores --->
c.codigo_tipoident,
c.nombre_tipoident

from TPRequisito a
	
	left outer join TPTipoIdentReq b
	on 	b.id_requisito = a.id_requisito

	left outer join TPTipoIdent c
	on c.id_tipoident =  b.id_tipoident
	
	left outer join  TPTipoReq f
	on f.id_tiporeq = a.id_tiporeq

	left outer join  TPTipoServicio g
	on g.id_tiposerv = a.id_tiposerv
	
	left outer join  TPInstitucion h
	on h.id_inst = a.id_inst
	
	left outer join  TPDocumento i
	on i.id_documento = a.id_documento
	
</cfquery>

 <!--- <cfquery name="Request.rsSubReporte" datasource="#session.tramites.dsn#">
		select 
		a.id_requisito,
		c.id_tipoident, 
		c.codigo_tipoident,
		c.nombre_tipoident
		
		from TPRequisito a
		
			left outer join TPTipoIdentReq b
			on 	b.id_requisito = a.id_requisito
			
			left outer join TPTipoIdent c
			on c.id_tipoident =  b.id_tipoident
			
			left outer join  TPTipoReq f
			on f.id_tiporeq = a.id_tiporeq
		
			left outer join  TPTipoServicio g
			on g.id_tiposerv = a.id_tiposerv
		<!--- where a.id_requisito =	request.rsReporte --->
</cfquery> 
 --->

	
<cfset formato = "flashpaper">

<!--- INVOCA EL REPORTE --->
<cfreport format="#formato#" template= "requisitos.cfr" query="request.rsReporte">
	<!--- <cfreportparam name="id_requisito" value="#form.id_requisito#"> --->
	<!--- <cfreportparam name="Edescripcion" value="#session.Enombre#"> --->
</cfreport>


