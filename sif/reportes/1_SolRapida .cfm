<cfinclude template="../Utiles/sifConcat.cfm">
<cfquery datasource="#session.DSN#" name="rsReporte">
	select b.DSconsecutivo, 
		b.Aid,
		b.DSmontoest,
		b.DStotallinest,  
		b.DScant,
		b.Ucodigo,
		c.Adescripcion, 
		a.ESfecha,
		a.EStotalest,
		'Pendiente' as DescDet,
			case when a.ESestado = 0 then 'Pendiente' 
			when a.ESestado = 10 then 'En Trámite Aprobación'
			when a.ESestado = 20 then 'Lista para Procesar'
			when a.ESestado = 30 then 'En Proceso Compra'
			when a.ESestado = 40 then 'Parcialmente Surtida'
			when a.ESestado = 50 then 'Surtida'
			when a.ESestado = 60 then 'Cancelada' end as ESestado,
		a.ESobservacion,
		(rtrim(ltrim(d.CFcodigo)) #_Cat# '-' #_Cat# rtrim(ltrim(d.CFdescripcion))) as CFdescripcion,
		(rtrim(ltrim(a.CMTScodigo)) #_Cat# '-' #_Cat# rtrim(ltrim(e.CMTSdescripcion))) as tipoTramite,
		
		a.ESnumero,
		m.Mnombre as Moneda,
		a.ESfalta,
		case DStipo when 'A' then coalesce(c.Adescripcion,'') 
		when 'S' then coalesce(k.Cdescripcion,'')
		when 'F' then coalesce(ac.ACdescripcion,'') 
		end as descServ,	

		case DStipo when 'A' then 'Código Artículo'
		else  ''
		end as codServ, 
		b.Alm_Aid,
		al.Almcodigo as Bodega,
			case DStipo when 'A'  then coalesce(c.Acodigo,'') 
			when 'S' then coalesce(k.Ccodigo,'')
			end as Art_Serv,
		c.Acodalterno,
		em.Edescripcion, 
			(select cpp.CPPfechaDesde
			from CPresupuestoPeriodo cpp
			where a.ESfecha between cpp.CPPfechaDesde and cpp.CPPfechaHasta
			and cpp.CPPestado = 1
			and cpp.Ecodigo = a.Ecodigo 
			) as CPPfechaDesde,
			(select cpp.CPPfechaHasta
			from CPresupuestoPeriodo cpp
			where a.ESfecha between cpp.CPPfechaDesde and cpp.CPPfechaHasta
			and cpp.CPPestado = 1
			and cpp.Ecodigo = a.Ecodigo 
			) as CPPfechaHasta,
			(select cpp.CPPanoMesDesde / 100
			from CPresupuestoPeriodo cpp
			where a.ESfecha between cpp.CPPfechaDesde and cpp.CPPfechaHasta
			and cpp.CPPestado = 1
			and cpp.Ecodigo = a.Ecodigo 
			) as CPPano,
		cfcta.CFformato,
		a.ESobservacion,
		coalesce(rtrim(a.ESobservacion),'') as Observacion,
		'#LSTimeFormat(now(),"hh:mm:ss")#' as HoraHoy
from ESolicitudCompraCM a
     inner join DSolicitudCompraCM b
       on a.Ecodigo = b.Ecodigo
       and a.ESidsolicitud = b.ESidsolicitud 
    inner join CFuncional d
      on a.Ecodigo = d.Ecodigo
      and a.CFid = d.CFid
    inner join CMTiposSolicitud e	
       on a.Ecodigo = e.Ecodigo
       and a.CMTScodigo = e.CMTScodigo
    inner join Monedas m	
       on m.Ecodigo = a.Ecodigo
       and m.Mcodigo = a.Mcodigo
    left outer join Articulos c
        on c.Aid=b.Aid
        and c.Ecodigo=b.Ecodigo 
    left outer join Almacen al
      on  al.Ecodigo = b.Ecodigo
      and al.Aid = b.Alm_Aid
    left outer join Conceptos k
        on b.Cid=k.Cid
        and b.Ecodigo=k.Ecodigo 
    left outer join AClasificacion ac
      on b.Ecodigo = ac.Ecodigo
      and b.ACcodigo = ac.ACcodigo
      and b.ACid = ac.ACid  
    inner join Empresas em
      on a.Ecodigo = em.Ecodigo
    inner join CFinanciera cfcta
      on b.Ecodigo = cfcta.Ecodigo
      and b.CFcuenta = cfcta.CFcuenta
	  
	where a.Ecodigo = #session.Ecodigo#
		and a.ESnumero = #rsTipoSolicitud.ESnumero#
		and a.CMSid = #rsTipoSolicitud.CMSid#
</cfquery>
<cfreport format="flashpaper" template="1_SOLRapida .cfr" query="rsReporte"></cfreport>

	
