<cfinclude template="../Utiles/sifConcat.cfm">
<cfquery datasource="#session.DSN#" name="rsReporte">
	select
	e.DScant as Cantidad_Item,
	e.DSconsecutivo as Consecutivo_Item,	
	e.DSlinea as Linea_Item,
	case when e.DStipo = 'A' then 'Artículo' 
		 when e.DStipo = 'S' then 'Servicio'
		 when e.DStipo = 'F' then 'Activo Fijo'	
	end as Tipo_Servicio,
	case when e.DStipo = 'A' then coalesce(Art.Acodigo,'') 
		 when e.DStipo = 'S' then coalesce(Con.Ccodigo,'')
		 when e.DStipo = 'F' then coalesce(ACl.ACcodigodesc,'') 
	end as Codigo_Item,
	e.DSmontoest as Precio_Unitario,
	coalesce(rtrim(e.Ucodigo)#_Cat#' - '#_Cat#rtrim(f.Udescripcion),'') as Tipo_Unidad,
	e.DStotallinest as Total_Linea,
	coalesce(rtrim(e.DSdescripcion),'') as Descripcion_Item,
	
	coalesce(rtrim(c.CFdescripcion),'') as Centro_Funcional,
	
	a.CMSid as Codigo_Solicitante,	
	case when a.ESestado = 0 then 'Pendiente'
		 when a.ESestado = 10 then 'En Trámite Aprobación'
		 when a.ESestado = 20 then 'Lista para Procesar'
		 when a.ESestado = 30 then 'En Proceso de Compra'
		 when a.ESestado = 40 then 'Parcialmente Surtida'
		 when a.ESestado = 50 then 'Surtida'		
	end as Estado,
	coalesce(a.ESfecha,'') as Fecha,	
	a.ESnumero as Numero_Solictud, 
	coalesce(rtrim(a.ESobservacion),'') as Observacion,
	coalesce(rtrim(a.CMTScodigo)#_Cat#' - '#_Cat#rtrim(d.CMTSdescripcion),'') as Tipo_Solicitud,
	
	coalesce(rtrim(b.CMSnombre),'') as Solicitante
	from ESolicitudCompraCM a
			inner join CMSolicitantes b
				on a.Ecodigo = b.Ecodigo
				and a.CMSid = b.CMSid
			inner join CFuncional c
				on a.Ecodigo = c.Ecodigo
				and a.CFid = c.CFid
			inner join CMTiposSolicitud d
				on a.Ecodigo = d.Ecodigo
				and a.CMTScodigo = d.CMTScodigo
			inner join DSolicitudCompraCM e
				on a.Ecodigo = e.Ecodigo
				and a.ESidsolicitud = e.ESidsolicitud
			inner join Unidades f	
				on e.Ecodigo = f.Ecodigo
				and e.Ucodigo = f.Ucodigo
			-- Sirve para sacar datos cuando son Articulos
			left outer join Articulos Art 	
				on e.Ecodigo = Art.Ecodigo
				and e.Aid = Art.Aid
			-- Sirve para sacar datos cuando son Bienes o Servicios
			left outer join Conceptos Con	
				on e.Ecodigo = Con.Ecodigo
				and e.Cid = Con.Cid
			-- Sirve para sacar datos cuando son Activos Fijos
			left outer join AClasificacion ACl
				on e.Ecodigo = ACl.Ecodigo
				and e.ACcodigo = ACl.ACcodigo
				and e.ACid = ACl.ACid  
			left outer join ACategoria ACa
				on e.Ecodigo = ACa.Ecodigo
				and e.ACcodigo = ACa.ACcodigo
	where a.Ecodigo = #session.Ecodigo#
		and a.ESnumero = #rsTipoSolicitud.ESnumero#
		and a.CMSid = #rsTipoSolicitud.CMSid#
</cfquery>
<cfreport format="flashpaper" template="1_SOLorden.cfr" query="rsReporte"></cfreport>
