<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		'#session.enombre#' as TituloEmpresa, 
		a.EOplazo as TerminoPlazo,
		a.Mcodigo as CodigoMoneda,
		a.EOfecha as FechaOC, 
		coalesce(a.Observaciones,'') as ObservacionEncabezado,
		a.EOdesc as DescuentoOC,
		a.Impuesto as ImpuestoOC,
		
		coalesce(rtrim(b.DOalterna),'') as DescripcionAltena,
		b.DOfechareq as FechaReq,
		b.DOfechaes as FechaEs,
		b.DOconsecutivo as NumeroLinea,
		b.DOcantidad as Cantidad,
		b.DOpreciou as PrecioUnitario,
		b.DOtotal as TotalLinea,
		
		i.Mnombre as NombreMoneda,
		i.Msimbolo as SimboloMoneda,
		
		e.CMCnombre as NombreComprador, 
				
		f.SNnombre as NombreProveedor,
		f.SNidentificacion as CedulaJuridica,
		f.SNdireccion as Direccion,
		coalesce(f.SNtelefono,'') as TelefonoProveedor, 
		coalesce(f.SNFax,'') as FaxProveedor, 
		coalesce(f.SNemail,'') as EmailProveedor, 
		
		coalesce(g.ESnumero,0) as NumeroCotizacion,
		coalesce(g.ESnumero,0) as NumeroSolicitud,
		
		h.Ucodigo as TipoUnidad,
		
		coalesce('#session.datos_personales.oficina#','') as TelefonoComprador,
		coalesce('#session.datos_personales.fax#','') as FaxComprador,
		coalesce('#session.datos_personales.email2#','') as ApartadoComprador,
		coalesce('#session.datos_personales.email1#','') as EmailComprador,
	
		case CMtipo when 'A' then coalesce(j.Adescripcion,'') 
				when 'S' then coalesce(k.Cdescripcion,'')
				when 'F' then coalesce(ac.ACdescripcion,'') 
		end as Descripcion,
		
		case CMtipo when 'A' then coalesce(j.Acodalterno,'') else '' end as NumeroParte,
		coalesce(rtrim(b.DOdescripcion),'') as DescripcionDetalle,
		coalesce(b.DOobservaciones,'') as Observacion,
		coalesce(alm.Bdescripcion,'') as Bodega,
		
			
		  (select sum (b1.DOtotal) 
		  	from DOrdenCM b1
			where b1.Ecodigo=a.Ecodigo
			and b1.EOidorden=a.EOidorden
		  ) as SubtotalOC,
		
		(select sum (b1.DOtotal) from DOrdenCM b1
		where b1.Ecodigo=a.Ecodigo
		and b1.EOidorden=a.EOidorden  ) - a.EOdesc + a.Impuesto as TotalOC,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoOrden.EOnumero#">  as NumeroOC
	
	from      EOrdenCM a 
			inner join CMCompradores e
			on  a.CMCid = e.CMCid
			
			inner join SNegocios f
			on a.Ecodigo = f.Ecodigo
			and a.SNcodigo = f.SNcodigo
			
			inner join Monedas i
			on  a.Mcodigo = i.Mcodigo 
			
			left outer join DOrdenCM b
					inner join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo
			
					left outer join DSolicitudCompraCM g
					on   g.DSlinea = b.DSlinea 
				
					left outer join Articulos j
					on b.Aid=j.Aid
					
					left outer join Conceptos k
					on b.Cid=k.Cid
									
					left outer join AClasificacion ac
					on b.Ecodigo = ac.Ecodigo
					and b.ACcodigo = ac.ACcodigo
					and b.ACid = ac.ACid  
					
					left outer join ACategoria atl
					on b.Ecodigo = atl.Ecodigo
					and b.ACcodigo = atl.ACcodigo
					
					left outer join Almacen alm
					on b.Alm_Aid = alm.Aid
					
			on a.Ecodigo = b.Ecodigo
			and a.EOidorden = b.EOidorden
	
	where a.Ecodigo = #session.Ecodigo#
	   and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoOrden.EOnumero#">
	  and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoOrden.CMTOCODIGO#">
</cfquery>

<cfreport format="flashpaper" template="1_OCLocal.cfr" query="rsReporte"></cfreport>


