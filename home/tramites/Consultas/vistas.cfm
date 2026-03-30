
<cfquery name="request.rsReporte" datasource="#session.tramites.dsn#">
select 
			v.id_vista,
			v.nombre_vista, 
			v.titulo_vista,
			v.vigente_desde, 
			v.vigente_hasta, 
			bb.nombre_tipo as nombre_doc,
			
			case v.es_masivo
			when 1 then 'Permite registro masivo'
			else ''
			end as es_masivo, 
			
			case v.es_individual
			when 1 then 'Permite registro individual'
			else ''
			end as es_invividual,
			
			case bb.es_persona
			when 1 then 'Los documentos de este tipo siempre estan asociados a una persona'
			else 'Los documentos de este tipo NO estan asociados a una persona'
			end as es_persona,

			vg.id_vistagrupo as id_grupo,
			vg.etiqueta as grupo,

			vc.id_campo,
			vc.etiqueta_campo as campo,
			
			case vc.es_obligatorio
				when 0 then 'No'
				else 'Si' end
				as es_obligatorio,

			case vc.es_encabezado
				when 0 then 'No'
				else 'Si' end
				as es_encabezado
			 
		from DDVista v
			
		    left outer join DDTipo bb
				on bb.id_tipo = v.id_tipo

			left outer join  DDVistaGrupo vg
				on vg.id_vista = v.id_vista
			
			left outer join  DDVistaCampo vc
				on vc.id_vista = v.id_vista
				and vc.id_vistagrupo = vg.id_vistagrupo
			
</cfquery>

	
<cfset formato = "flashpaper">

<cfreport format="#formato#" template= "vistas.cfr" query="request.rsReporte">
	<!--- <cfreportparam name="id_requisito" value="#form.id_requisito#"> --->
	<!--- <cfreportparam name="Edescripcion" value="#session.Enombre#"> --->
</cfreport>


