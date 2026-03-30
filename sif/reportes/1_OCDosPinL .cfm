<cfquery datasource="#session.DSN#" name="rsReporte">
select rtrim(c.Edescripcion) as TituloEmpresa, 
                       e.CMCnombre as NombreComprador, 
                        coalesce(f.SNtelefono,'') as TelefonoProveedor, 
                        coalesce(f.SNFax,'') as FaxProveedor, 
                        coalesce(f.SNemail,'') as EmailProveedor, 
                        f.SNdireccion as Direccion,
                        coalesce(g.ESnumero,0) as NumeroCotizacion,
                        a.EOfecha as FechaOC, 
                        f.SNnombre as NombreProveedor,
                        f.SNidentificacion as CedulaJuridica,
                        coalesce('#session.datos_personales.oficina#','') as TelefonoComprador,
						coalesce('#session.datos_personales.fax#','') as FaxComprador,
						coalesce('#session.datos_personales.email2#','') as ApartadoComprador,
						coalesce('#session.datos_personales.email1#','') as EmailComprador,
                        'Pendiente' as Representante,
                        'Pendiente' as Embarque, 
                        a.EOplazo as TerminoPlazo,
                        'Pendiente' as FechaArrivo,
                        'Pendiente' as Embarcadores,
                        b.DOconsecutivo as NumeroLinea,
/*                        coalesce(b.DSlinea,0) as NumeroSolicitud,*/
                        coalesce(g.ESnumero,0) as NumeroSolicitud,
                        h.Ucodigo as TipoUnidad,
                        b.DOcantidad as Cantidad,
                        b.DOpreciou as PrecioUnitario,
                        b.DOtotal as TotalLinea,
                        a.Mcodigo as CodigoMoneda,
                        i.Mnombre as NombreMoneda,
                        i.Msimbolo as SimboloMoneda,
                case CMtipo when 'A' then coalesce(j.Adescripcion,'') 
                        when 'S' then coalesce(k.Cdescripcion,'')
                        when 'F' then coalesce(ac.ACdescripcion,'') 
                end as Descripcion,
                        case CMtipo when 'A' then coalesce(j.Acodalterno,'') else '' end as NumeroParte,
                        coalesce(rtrim(b.DOdescripcion),'') as DescripcionDetalle,
                        coalesce(b.DOobservaciones,'') as Observacion,
                        coalesce(alm.Bdescripcion,'') as Bodega,
                        a.EOdesc as DescuentoOC,
                  (select sum (b1.DOtotal) from DOrdenCM b1
                inner join EOrdenCM a1
                    on a1.Ecodigo = a.Ecodigo
                       and a1.EOnumero = a.EOnumero
                       and a1.Ecodigo = b1.Ecodigo                                                      
                       and a1.EOidorden = b1.EOidorden 
                group by a1.EOnumero  ) as SubtotalOC,
                        a.Impuesto as ImpuestoOC,
                                    (select sum (b1.DOtotal) from DOrdenCM b1
                                                            inner join EOrdenCM a1
                                                            on a1.Ecodigo = a.Ecodigo
                                           and a1.EOnumero = a.EOnumero
                                           and a1.Ecodigo = b1.Ecodigo
                                                            and a1.EOidorden = b1.EOidorden 
                        group by a1.EOnumero  ) - a.EOdesc + a.Impuesto as TotalOC,
            'COPIA NO NEGOCIABLE' as CopiaEtiqueta,
                        'GERENCIA DE PROVEEDURIA' as GerenciaEtiqueta,
                        'Pagina: ' as PaginaEtiqueta,
                        a.SNcodigo as CodigoProveedor,
                        'Orden de Compra  Local  No.' as OCEtiqueta,
                       a.EOnumero as NumeroOC,
                        '' as Vacio,
                        coalesce(rtrim(b.DOalterna),'') as DescripcionAltena,
                                          b.DOfechareq as FechaReq,
                                          b.DOfechaes as FechaEs,
                                          coalesce(a.Observaciones,'') as ObservacionEncabezado
from      EOrdenCM a 
                        left outer join DOrdenCM b
                                    on a.Ecodigo = b.Ecodigo
                                    and a.EOidorden = b.EOidorden
                        inner join Empresas c 
                                    on a.Ecodigo = c.Ecodigo
                        inner join CMTipoOrden d
                                   on a.Ecodigo = d.Ecodigo
                                    and a.CMTOcodigo = d.CMTOcodigo
                        inner join CMCompradores e
                                    on a.Ecodigo = e.Ecodigo 
                                    and a.CMCid = e.CMCid
                        inner join SNegocios f
                                    on a.Ecodigo = f.Ecodigo
                                    and a.SNcodigo = f.SNcodigo
                        inner join Unidades h
                                    on  b.Ecodigo = h.Ecodigo
                                    and b.Ucodigo = h.Ucodigo
                        inner join Monedas i
                                    on  a.Ecodigo = i.Ecodigo
                                    and a.Mcodigo = i.Mcodigo                     
                        left outer join DSolicitudCompraCM g
                                    on   g.Ecodigo = b.Ecodigo
                                    and g.ESidsolicitud = b.ESidsolicitud 
                                    and g.DSlinea = b.DSlinea 
                        left outer join Articulos j
                                   on b.Aid=j.Aid
                                   and b.Ecodigo=j.Ecodigo 
                        left outer join Conceptos k
                                   on b.Cid=k.Cid
                                   and b.Ecodigo=k.Ecodigo 
                        left outer join AClasificacion ac
                                   on b.Ecodigo = ac.Ecodigo
                                   and b.ACcodigo = ac.ACcodigo
                                   and b.ACid = ac.ACid  
                        left outer join ACategoria atl
                                   on b.Ecodigo = atl.Ecodigo
                                   and b.ACcodigo = atl.ACcodigo
                        left outer join Almacen alm
                                    on b.Alm_Aid = alm.Aid
                                    and b.Ecodigo = alm.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
	   and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoOrden.EOnumero#">
	  and d.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoOrden.CMTOCODIGO#">
</cfquery>
<cfreport format="flashpaper" template="1_OCDosPinL .cfr" query="rsReporte"></cfreport>
	
