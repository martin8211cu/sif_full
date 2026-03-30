<cf_dbfunction name="op_concat" returnvariable="_CNCT">
<style type="text/css">
.titulos {
		text-align: center;
	}
.info {
		text-align: center;
	}
</style>
<cfif not isdefined('url.moneda') or (isdefined('url.moneda') and len(trim(#url.moneda#)) eq 0)>
  <h5 style="color:#F30; text-align:left;">No se ha pasado la moneda al detalle.. <i class="fa fa-frown-o"></i></h5>
  <cfabort> 
</cfif>
<cfif not isdefined('url.tipo') or (isdefined('url.tipo') and len(trim(#url.tipo#)) eq 0)>
   <h5 style="color:#F30; text-align:left;">No se ha pasado el tipo de transaccion (forma de pago o documento) al detalle.. <i class="fa fa-frown-o"></i></h5>
   <cfabort>
</cfif>
<cfif not isdefined('url.ubicacion') or (isdefined('url.ubicacion') and len(trim(#url.ubicacion#)) eq 0)>
     <h5 style="color:#F30; text-align:left;">No se ha indicado si el detalle es de montos por forma de pago o tipo de documento.. <i class="fa fa-frown-o"></i></h5>
     <cfabort>
</cfif>
<cfif not isdefined('url.caja') or (isdefined('url.caja') and len(trim(#url.caja#)) eq 0)>
     <h5 style="color:#F30; text-align:left;">No se ha indicado la caja.. <i class="fa fa-frown-o"></i></h5>
     <cfabort>
</cfif>

<cfquery name="rsMiso4217" datasource="#session.dsn#">
   select Mnombre from Monedas 
    where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">      
    and Ecodigo = #session.Ecodigo#
</cfquery>
<cfif url.ubicacion eq 'D'>
   <cfset ListaTipos = "F, L">
   <cfif listContains(ListaTipos, url.tipo)>
      <cfquery name="rsPagos" datasource="#session.dsn#">
          <cfif url.tipo EQ 'F'>            
            select 
                et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                et.ETfecha as fecha,
                et.ETtotal as MontoOriginal,                              
                  m.Msimbolo,m.Miso4217,
                  'Facturas de contado' as Origen
                  , 'F' as tipo
                  ,ct.CCTdescripcion as trans  
                  ,m.Mcodigo
                 ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc                                  
                from  ETransacciones et                                 
                inner join Monedas m
                  on  et.Mcodigo = m.Mcodigo 
                  and et.Ecodigo = m.Ecodigo
                inner join CCTransacciones ct
                  on et.CCTcodigo = ct.CCTcodigo
                 and et.Ecodigo   = ct.Ecodigo 
                inner join SNegocios sn
                     on et.SNcodigo = sn.SNcodigo
                    and et.Ecodigo  = sn.Ecodigo
               where et.Mcodigo = #url.moneda#
                and et.ETesLiquidacion = 0
                and et.FACid IS NULL
                and et.ETestado = 'C' 
                and ct.CCTvencim = -1
                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#"> 
          </cfif>                
         <cfif #url.tipo# eq 'L'>
           select
               l.NumLote as documento,
               l.Fecha,
                coalesce((select sum(ETtotal)
                from FALiquidacionRuteros a
                LEFT join ETransacciones b
                   on a.NumLote = b.ETlote
                  and a.Ecodigo = b.Ecodigo  
                WHERE b.ETesLiquidacion = 1
                and a.NumLote = l.NumLote
                and a.FCid = l.FCid
                and b.Mcodigo = #url.moneda#),0)
                + coalesce((
                select sum(Ptotal)
                from FALiquidacionRuteros a
                inner join HPagos c
                   on a.NumLote = c.Plote
                  and a.Ecodigo = c.Ecodigo
                and c.PesLiquidacion = 1
                and c.Plote = l.NumLote
                and c.FCid = l.FCid
                and c.Mcodigo = #url.moneda#),0)
                as MontoOriginal,
                (select m.Msimbolo from Monedas m 
                 where Ecodigo = #session.Ecodigo# 
                 and Mcodigo = #url.moneda#) as Msimbolo,
                 (select m.Miso4217 from Monedas m 
                 where Ecodigo = #session.Ecodigo# 
                 and Mcodigo = #url.moneda#) as Miso4217,                          
               'Liquidacion cobradores' as Origen
              , 'L' as tipo
              , l.Descripcion as trans   
              , #url.moneda#                                           
             ,de.DEnombre #_CNCT# ' ' #_CNCT#  de.DEapellido1 #_CNCT# ' '  #_CNCT#   de.DEapellido2 <!---#_CNCT# ' - '  #_CNCT# l.Descripcion --->  as nombreDoc    
         from     FALiquidacionRuteros l
          inner join DatosEmpleado de
            on l.DEid = de.DEid
        where l.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">                
         and l.FACid is null
         and l.estado = 'P'             
         </cfif>           
       </cfquery>
    <cfelseif url.tipo eq 'R'>
       <cfquery name="rsPagos" datasource="#session.dsn#">
        select distinct       
           coalesce( p.Pserie #_CNCT# <cf_dbfunction name="to_char" args="p.Pdocumento">, p.Pcodigo)  as documento,
           p.Pfecha as fecha, 
            p.Ptotal as MontoOriginal,
              m.Msimbolo,m.Miso4217,
              'Recibos' as Origen 
              , '#url.tipo#' as tipo
               ,t.CCTdescripcion as trans
               ,sn.SNnombre as nombreDoc
             from  HPagos p                                  
               inner join BMovimientos b
                       on p.Ecodigo = b.Ecodigo
                       and p.CCTcodigo = b.CCTcodigo
                       and p.Pserie #_CNCT# <cf_dbfunction name="to_char" args="ltrim(p.Pdocumento)">   = b.Ddocumento                                     
                inner join CCTransacciones t
                      on b.CCTcodigo = t.CCTcodigo
                      and b.Ecodigo = t.Ecodigo          
                      and coalesce(t.CCTvencim,0) != -1                             
               inner join Monedas m
                on p.Mcodigo = m.Mcodigo 
               and p.Ecodigo = m.Ecodigo
               inner join SNegocios sn
                on p.SNcodigo = sn.SNcodigo
               and p.Ecodigo  = sn.Ecodigo                               
                where p.Mcodigo = #url.moneda# 
                 and PesLiquidacion = 0
                 and p.FACid IS NULL
                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">     
      UNION ALL
            select   distinct        
            coalesce(p.Pserie #_CNCT#   <cf_dbfunction name="to_char" args="p.Pdocumento">, p.Pcodigo)  as documento,
           p.Pfecha as fecha, 
            p.Ptotal as MontoOriginal,
              m.Msimbolo,m.Miso4217,
              'Recibos' as Origen 
              , '#url.tipo#' as tipo
               ,ct.CCTdescripcion as trans
               ,sn.SNnombre as nombreDoc
                from  HPagos p  
               inner join BMovimientos b
                       on p.Ecodigo = b.Ecodigo
                       and p.CCTcodigo = b.CCTRcodigo
                      and p.Pserie #_CNCT# <cf_dbfunction name="to_char" args="ltrim(p.Pdocumento)">   = b.DRdocumento  
                  inner join CCTransacciones ct
                      on p.CCTcodigo = ct.CCTcodigo
                     and p.Ecodigo   = ct.Ecodigo                                            
               inner join Monedas m
                    on p.Mcodigo = m.Mcodigo 
                   and p.Ecodigo = m.Ecodigo
                inner join SNegocios sn
                    on  p.SNcodigo = sn.SNcodigo
                    and p.Ecodigo  = sn.Ecodigo   
                where p.Mcodigo = #url.moneda#						                    
                 and PesLiquidacion = 0
                 and p.FACid IS NULL
                  and b.CCTRcodigo not in('CE','DT')
                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">      
                 and   <cf_dbfunction name="to_char"  args="p.Pcodigo">  #_CNCT#    p.CCTcodigo  #_CNCT#   <cf_dbfunction name="to_char"  args="p.Ecodigo"> not in  (
                  select distinct   <cf_dbfunction name="to_char"  args="p.Pcodigo">  #_CNCT#    p.CCTcodigo  #_CNCT#   <cf_dbfunction name="to_char"  args="p.Ecodigo">
                from  HPagos p                                  
               inner join BMovimientos b
                       on p.Ecodigo = b.Ecodigo
                       and p.CCTcodigo = b.CCTcodigo
                       and p.Pserie #_CNCT# <cf_dbfunction name="to_char" args="ltrim(p.Pdocumento)">   = b.Ddocumento                                     
                inner join CCTransacciones t
                      on b.CCTRcodigo = t.CCTcodigo
                      and b.Ecodigo = t.Ecodigo          
                      and coalesce(t.CCTvencim,0) != -1    
                where p.Mcodigo = #url.moneda# 
                 and PesLiquidacion = 0
                 and p.FACid IS NULL
                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#"> 
                 )              
        </cfquery>
             
    <cfelseif url.tipo eq 'C'> 
       <cfquery name="rsPagos" datasource="#session.dsn#">
        select 
            et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
            et.ETfecha as fecha,
            ETtotal as MontoOriginal,
              m.Msimbolo, m.Miso4217,
              'Credito' as Origen 
              , '#url.tipo#' as tipo
              ,ct.CCTdescripcion as trans
              ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc
            from  ETransacciones et             
             inner join Monedas m
               on et.Mcodigo = m.Mcodigo 
              and et.Ecodigo = m.Ecodigo
          inner join SNegocios sn
                 on et.SNcodigo = sn.SNcodigo
                and et.Ecodigo  = sn.Ecodigo
            inner join CCTransacciones ct 
              on et.CCTcodigo = ct.CCTcodigo
             and et.Ecodigo = ct.Ecodigo
          where et.Mcodigo = #url.moneda#
            and et.FACid IS NULL
            and et.ETestado = 'C' 
            and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">
            and et.ETesLiquidacion = 0
            and ct.CCTtipo = 'C'
   <!---    and coalesce(ct.CCTvencim,0) <> -1--->          
       </cfquery>
   <cfelseif url.tipo eq 'D'>
       <cfquery name="rsPagos" datasource="#session.dsn#">
             select 
                 p.Pserie #_CNCT# ' ' #_CNCT#  coalesce(<cf_dbfunction name="to_char" args="p.Pdocumento">, p.Pcodigo)  as documento,
                 p.Pfecha as fecha, 
                 p.Ptotal as MontoOriginal,                             
                 m.Msimbolo,m.Miso4217,
                 'Devoluciones' as Origen 
                 ,'D' as tipo
                 ,ct.CCTdescripcion as trans
                 ,sn.SNnombre as nombreDoc 
         from  HPagos p    
           inner join CCTransacciones ct
              on p.CCTcodigo = ct.CCTcodigo
             and p.Ecodigo   = ct.Ecodigo 
           inner join Monedas m
              on p.Mcodigo = m.Mcodigo 
             and p.Ecodigo = m.Ecodigo
          inner join BMovimientos bm
             on p.CCTcodigo = bm.CCTRcodigo
           and p.Pcodigo = bm.DRdocumento
           and p.Ecodigo = bm.Ecodigo
           inner join SNegocios sn
            on p.SNcodigo = sn.SNcodigo
           and p.Ecodigo  = sn.Ecodigo                               
            where p.Mcodigo = #url.moneda# 
             and PesLiquidacion = 0
             and coalesce(PfacturaContado,'N') = 'D'
             and p.FACid IS NULL
             and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">
      </cfquery>
    <cfelseif url.tipo eq 'H'>
    <cfquery name="rsPagos" datasource="#session.dsn#">
            select 
                et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                et.ETfecha as fecha,
                /* Modificación para mostrar el monto por linea */
                case when a.FPMonto is not null then a.FPMonto - a.FPVuelto
                else et.ETtotal
                end as MontoOriginal, 

                coalesce(a.FPReferencia, '-') as Referencia,     
                case when a.Tipo  = 'E' then
                                'Efectivo'
                            when a.Tipo = 'T' then 
                                'Tarjeta'
                            when a.Tipo = 'D' then
                                'Deposito'
                            when a.Tipo = 'C' then
                                'Cheque'
                            when a.Tipo = 'A' then 
                                'Documento'
                            when a.Tipo = 'F' then 
                                'Diferencia'
                            else
                                '-'
                            end            
                             as Tipo,
                                                              
                  m.Msimbolo,m.Miso4217,
                  'Facturas de credito' as Origen
                  , 'H' as tipo
                  ,ct.CCTdescripcion as trans  
                  ,m.Mcodigo
                 ,coalesce(et.ETnombredoc,sn.SNnombre) as nombreDoc                                  
                from  ETransacciones et    
                left join FPagos a
                  on et.ETnumero = a.ETnumero
                 and et.FCid = a.FCid                             
                inner join Monedas m
                  on  et.Mcodigo = m.Mcodigo 
                  and et.Ecodigo = m.Ecodigo
                inner join CCTransacciones ct
                  on et.CCTcodigo = ct.CCTcodigo
                 and et.Ecodigo   = ct.Ecodigo 
                inner join SNegocios sn
                     on et.SNcodigo = sn.SNcodigo
                    and et.Ecodigo  = sn.Ecodigo
               where et.Mcodigo = #url.moneda#
                and et.ETesLiquidacion = 0
                and et.FACid IS NULL
                and et.ETestado = 'C' 
                and coalesce(ct.CCTvencim,0) <> -1
                and ct.CCTtipo = 'D'
                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">     
        </cfquery>         
   </cfif> 
<cfelseif url.ubicacion eq 'P'>
           <cfquery name="rsPagos" datasource="#session.dsn#">
			     select 
                     et.ETserie #_CNCT# ' ' #_CNCT#   <cf_dbfunction name="to_char" args="et.ETdocumento">  as documento,
                    et.ETfecha as fecha,
                    case when a.Mcodigo <> et.Mcodigo then (FPmontoori )
                    else                     
                      (FPmontoori - coalesce(FPVuelto,0)) 
                    end as MontoOriginal,
                      m.Msimbolo,m.Miso4217,                 
                      case when '#url.tipo#'  = 'E' then
                                'Efectivo'
                            when '#url.tipo#' = 'T' then 
                                'Tarjeta'
                            when '#url.tipo#' = 'D' then
                                'Deposito'
                            when '#url.tipo#' = 'C' then
                                'Cheque'
                            when '#url.tipo#' = 'A' then 
                                'Documento'
                            when '#url.tipo#' = 'F' then 
                                'Diferencia'
                            end            
                             as Origen,
                       case when '#url.tipo#'  = 'E' then
                                'Efectivo'
                            when '#url.tipo#' = 'T' then 
                              <cf_dbfunction name="to_char" args="a.FPautorizacion">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="fat.FATdescripcion">
                            when '#url.tipo#' = 'D' then
                              <cf_dbfunction name="to_char" args=" a.FPdocnumero">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="bn.Bdescripcion">
                            when '#url.tipo#' = 'C' then
                              <cf_dbfunction name="to_char" args=" a.FPdocnumero">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="bn.Bdescripcion">
                            when '#url.tipo#' = 'A' then 
                               a.FPdocnumero
                            when '#url.tipo#' = 'F' then 
                               a.FPdocnumero
                            end            
                             as documentoPago      
                      , a.Tipo as tipo
                       ,ct.CCTdescripcion as trans
                      ,m.Mcodigo
                      ,coalesce(et.ETnombredoc, sn.SNnombre) as nombreDoc
                    from FPagos a
                    inner join ETransacciones et
                      on a.ETnumero = et.ETnumero
                     and a.FCid     = et.FCid 
                    inner join SNegocios sn
                     on et.SNcodigo = sn.SNcodigo
                    and et.Ecodigo  = sn.Ecodigo                  
                    inner join CCTransacciones ct
                      on et.CCTcodigo = ct.CCTcodigo
                     and et.Ecodigo   = ct.Ecodigo
                    inner join Monedas m
                      on  a.Mcodigo = m.Mcodigo 
                      and et.Ecodigo = m.Ecodigo
                    left outer join FATarjetas fat
                      on fat.FATid = <cf_dbfunction name="to_number" args="a.FPtipotarjeta"> 
                   and fat.Ecodigo = et.Ecodigo
                     left outer join Bancos bn
                       on a.FPBanco = bn.Bid 
                     and bn.Ecodigo = et.Ecodigo                                                                  
                   where a.Mcodigo = #url.moneda#
                    and et.FACid IS NULL
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">  
                   <!---  and a.Tipo <> 'F'  --->
                    and a.Tipo = '#url.tipo#'  
                    and et.ETestado = 'C'                 
                union all
                  select 
                   coalesce(p.Pserie #_CNCT#  <cf_dbfunction name="to_char" args="p.Pdocumento">, p.Pcodigo) as documento,
                   p.Pfecha as fecha,
                   (FPmontoori- coalesce(PFPVuelto,0)) as MontoOriginal,
                  m.Msimbolo,m.Miso4217,
                  case when '#url.tipo#'  = 'E' then
                            'Efectivo'
                        when '#url.tipo#'= 'T' then 
                            'Tarjeta'
                        when '#url.tipo#' = 'D' then
                            'Deposito'
                        when '#url.tipo#' = 'C' then
                            'Cheque'
                        when '#url.tipo#' = 'A' then 
                            'Documento'
                        when '#url.tipo#' = 'F' then 
                            'Diferencia'
                        end            
                         as Origen,
                   case when '#url.tipo#'  = 'E' then
                            'Efectivo'
                        when '#url.tipo#' = 'T' then 
                          <cf_dbfunction name="to_char" args="a.FPautorizacion">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="fat.FATdescripcion">
                        when '#url.tipo#' = 'D' then
                          <cf_dbfunction name="to_char" args=" a.FPdocnumero">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="bn.Bdescripcion">
                        when '#url.tipo#' = 'C' then
                          <cf_dbfunction name="to_char" args=" a.FPdocnumero">  #_CNCT# ' - ' #_CNCT#  <cf_dbfunction name="to_char" args="bn.Bdescripcion">
                        when '#url.tipo#' = 'A' then 
                           a.FPdocnumero
                        when '#url.tipo#' = 'F' then 
                           a.FPdocnumero
                        end            
                         as documentoPago
                  ,  a.Tipo as tipo
                   ,ct.CCTdescripcion as trans
                  ,m.Mcodigo
                  ,sn.SNnombre as nombreDoc
                from PFPagos a 
                inner join HPagos p
                  on a.CCTcodigo = p.CCTcodigo
                 and a.Pcodigo = p.Pcodigo 
                inner join SNegocios sn
                     on p.SNcodigo = sn.SNcodigo
                    and p.Ecodigo  = sn.Ecodigo
               inner join CCTransacciones ct
                 on p.CCTcodigo = ct.CCTcodigo
                and p.Ecodigo   = ct.Ecodigo   
               inner join Monedas m
                on a.Mcodigo = m.Mcodigo 
               and p.Ecodigo = m.Ecodigo
              left outer join FATarjetas fat
               on fat.FATid = <cf_dbfunction name="to_number" args="a.FPtipotarjeta"> 
              and fat.Ecodigo = p.Ecodigo
              left outer join Bancos bn
                  on a.FPBanco = bn.Bid 
                 and p.Ecodigo = bn.Ecodigo 
                where a.Mcodigo = #url.moneda# 
                 and p.FACid IS NULL
                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.caja#">
                 <!---and a.Tipo <> 'F'--->
                 and a.Tipo = '#url.tipo#'                                                              
			</cfquery>      
</cfif>
<cfset total = 0>
<cfloop query="rsPagos">
    <cfset total += MontoOriginal>
</cfloop>
  <div class="bs-example">
    <ul class="breadcrumb">
        <li class="active" style="color:#06C">Detalle de los montos presentados 
		<cfif url.ubicacion eq 'D'>
         para los documentos
             <cfswitch expression="#url.tipo#">
                <cfcase value="F">
                    de <strong>contado</strong>
                </cfcase>
                <cfcase value="L">
                   de <strong>liquidacion</strong>	
                </cfcase>
                <cfcase value="R">
                   de <strong>recibos</strong> 	
                </cfcase>
                <cfcase value="C">
                   	de <strong>notas de credito</strong>
                </cfcase>
                <cfcase value="D">
                   	de <strong>devoluciones</strong>
                </cfcase> 
                <cfcase value="H">
                   	de <strong>facturas de credito</strong>
                </cfcase>                                
            </cfswitch>
        <cfelseif url.ubicacion eq 'P'>
         para los pagos  
            <cfswitch expression="#url.tipo#">
                <cfcase value="F">
                    de <strong>diferencia</strong>
                </cfcase>
                <cfcase value="D">
                   de <strong>depositos	</strong>
                </cfcase>
                <cfcase value="E">
                   en <strong>efectivo</strong>  	
                </cfcase>
                <cfcase value="T">
                   de <strong>tarjetas</strong>
                </cfcase>
                <cfcase value="C">
                   de <strong>cheques </strong>
                </cfcase>													
                <cfcase value="A">
                    de <strong>documentos</strong>
                </cfcase>
                <!---<cfcase value="F">
                   	de <strong>diferencias</strong>
                </cfcase> --->
            </cfswitch>           
        </cfif>
          en la moneda <cfoutput><strong>#rsMiso4217.Mnombre#</strong></cfoutput>.
        </li>
    </ul>
  </div>
<div class="bs-docs-section">
    <div class="row">
        <div class="col-lg-10">
            <div class="bs-example table-responsive">
             <cfoutput>
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                       <cfset columnsColspan = 4>
                       <cfif url.ubicacion eq 'D'>
                          <cfset columnsColspan = 6>
                        <tr>
                            <th class="titulos"> Factura </th>
                            <th class="titulos"> Transacción </th>
                            <th class="titulos"> Fecha </th>                          
                            <th class="titulos"> Socio o cliente </th>
                            <th class="titulos"> Tipo Pago </th>
                            <th class="titulos"> Referencia </th>
                            <th class="titulos"> Monto </th>                          
                        </tr>
                        <cfelseif url.ubicacion eq 'P'>
                         <tr>
                            <th class="titulos"> Factura </th>
                            <th class="titulos"> Transacción </th>
                            <th class="titulos"> Fecha Pago</th>
                            <th class="titulos"> Documento de pago</th>
                            <th class="titulos"> Monto de pago</th>
                        </tr>
                        </cfif>						
                    </thead>
                    <tbody >   
                    <cfif url.ubicacion eq 'D'>
                         <cfloop query="rsPagos">
                           <tr <cfif CurrentRow MOD 2> class="success" </cfif> >
                            <td class="info">#documento#</td>
                            <td class="info">#trans#</td>
                            <td class="info">#LSDateFormat(fecha,'DD/MM/YYYY')#</td>                         
                            <td class="info">#nombreDoc#</td>
                            <td class="info">
                              <cfif isDefined('Tipo')>
                                #Tipo#
                              <cfelse>
                                -
                              </cfif>
                            </td>
                            <td class="info">
                              <cfif isDefined('Referencia')>
                                #Referencia#
                              <cfelse>
                                -
                              </cfif>
                            </td>
                            <td class="info">#LSCurrencyFormat(MontoOriginal,'none')#</td>                     
                           </tr>
                         </cfloop>                                                                 
                    <cfelseif url.ubicacion eq 'P'>            
                        <cfloop query="rsPagos">
                           <tr <cfif CurrentRow MOD 2> class="success" </cfif> >
                            <td class="info">#documento#</td>
                            <td class="info">#trans#</td>
                            <td class="info">#LSDateFormat(fecha,'DD/MM/YYYY')#</td>
                            <td class="info">#documentoPago#</td>
                            <td class="info">#LSCurrencyFormat(MontoOriginal,'none')#</td>                      
                           </tr>
                         </cfloop> 
                           
                    </cfif>
                          <tr class="danger align:'right'">
                           <td colspan="#columnsColspan#" align="right"><strong>Total:&nbsp;</strong></td>   
                           <td align='left'>&nbsp; #LSCurrencyFormat(total,'none')#</td>                                             
                          </tr>		                                        
                    </tbody>
                </table>
              </cfoutput>
            </div><!-- /example  -->
        </div>
    </div>
</div>