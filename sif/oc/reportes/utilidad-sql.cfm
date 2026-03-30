<!---
form.comparar in 'costo,compras'
form.resumido in '0,1'
--->

<cfquery datasource="#session.dsn#">
if object_id ('##oc' ) is not null drop table ##oc
if object_id ('##cc' ) is not null drop table ##cc
if object_id ('##cp' ) is not null drop table ##cp
if object_id ('##cc1') is not null drop table ##cc1
if object_id ('##cp1') is not null drop table ##cp1
if object_id ('##costocompra') is not null drop table ##costocompra
if object_id ('##kardex') is not null drop table ##kardex
</cfquery>
<cfquery datasource="#session.dsn#">
select distinct a.OCTid
into ##oc
from HDDocumentos a
	join HDocumentos b
		on a.HDid = b.HDid
		and b.Ecodigo = a.Ecodigo
	join BMovimientos m
		on  m.Ecodigo     = b.Ecodigo
		and m.CCTcodigo   = b.CCTcodigo
		and m.Ddocumento  = b.Ddocumento
		and m.CCTRcodigo  = b.CCTcodigo
		and m.DRdocumento = b.Ddocumento
	join OCordenComercial oc
		on oc.OCid = a.OCid
		and oc.Ecodigo = a.Ecodigo
where a.DDcodartcon is not null
  and a.DDtipo in ( 'A' , 'O' )
  and a.OCid is not null
  and a.DDcodartcon is not null
  and m.BMperiodo * 100 + m.BMmes between #form.perini * 100 + form.mesini# and #form.perfin * 100 + form.mesfin#
<cfif Len(form.OC)>
  and oc.OCcontrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OC#">
  </cfif>
  and a.Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery datasource="#session.dsn#">
select
	<cfif form.resumido is '0'>doc = b.Ddocumento,</cfif>
	lin = a.HDDlinea, Aid = a.DDcodartcon, des = a.DDescripcion, a.OCTid, OC = oc.OCcontrato,
	can = case when ttr.CCTtipo = 'D' then +1 else -1 end * a.DDcantidad,
	tot = case when ttr.CCTtipo = 'D' then +1 else -1 end * a.DDtotal,
	tc  = b.EDtipocambioVal,
	SN = b.SNcodigo, UM = art.Ucodigo,
	Mon = b.Mcodigo, per = m.BMperiodo, mes = m.BMmes
into ##cc
from HDDocumentos a
	join HDocumentos b
		on a.HDid = b.HDid
		and b.Ecodigo = a.Ecodigo
	join CCTransacciones ttr
		on ttr.CCTcodigo = b.CCTcodigo
		and ttr.Ecodigo = b.Ecodigo
	join BMovimientos m
		on  m.Ecodigo     = b.Ecodigo
		and m.CCTcodigo   = b.CCTcodigo
		and m.Ddocumento  = b.Ddocumento
		and m.CCTRcodigo  = b.CCTcodigo
		and m.DRdocumento = b.Ddocumento
	left join Articulos art
		on art.Aid = a.DDcodartcon
		and a.DDtipo in ('A', 'O')
	join OCordenComercial oc
		on oc.OCid = a.OCid
		and oc.Ecodigo = a.Ecodigo
where a.OCTid in (select OCTid from ##oc)
  and a.Ecodigo  = #session.Ecodigo#
  and b.Ecodigo  = #session.Ecodigo#
  and oc.Ecodigo = #session.Ecodigo#
<!--- esta condición solamente aplica para ventas, no para compras --->
  and m.BMperiodo * 100 + m.BMmes between #form.perini * 100 + form.mesini# and #form.perfin * 100 + form.mesfin#
</cfquery>
<cfquery datasource="#session.dsn#">
select
	<cfif form.resumido is '0'>doc = b.Ddocumento,</cfif>
	lin = a.DDlinea,  Aid = a.DDcoditem,   des = a.DDescripcion, a.OCTid, OC = oc.OCcontrato,
	can = case when ttr.CPTtipo = 'C' then +1 else -1 end * a.DDcantidad,
	tot = case when ttr.CPTtipo = 'C' then +1 else -1 end * a.DDtotallin,
	tc = b.EDtipocambioVal,
	SN = b.SNcodigo, UM = coalesce (a.Ucodigo, art.Ucodigo),
	Mon = b.Mcodigo, per = m.BMperiodo, mes = m.BMmes
into ##cp
from HDDocumentosCP a
	join HEDocumentosCP b
		on a.IDdocumento = b.IDdocumento
	join CPTransacciones ttr
		on ttr.CPTcodigo = b.CPTcodigo
		and ttr.Ecodigo = b.Ecodigo
	left join BMovimientosCxP m
		on  m.Ecodigo     = b.Ecodigo
		and m.CPTcodigo   = b.CPTcodigo
		and m.Ddocumento  = b.Ddocumento
		and m.CPTRcodigo  = b.CPTcodigo
		and m.DRdocumento = b.Ddocumento
	join OCordenComercial oc
		on oc.OCid = a.OCid
	left join Articulos art
		on art.Aid = a.DDcoditem
		and a.DDtipo in ('A', 'O')
where a.OCTid in (select OCTid from ##oc)
  and a.Ecodigo  = #session.Ecodigo#
  and b.Ecodigo  = #session.Ecodigo#
  and oc.Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery datasource="#session.dsn#">
select
	c.OCTid, c.per, c.mes, c.Aid, c.des,
	c.OC, c.SN, c.UM, m.Miso4217 as mon, oct.OCTtransporte,
<cfif form.resumido is '1'>
	sum(c.can) as can, sum(c.tot) as tot, sum(c.tot*c.tc) as totloc
<cfelse>
	c.can, c.tot, c.doc, c.tot*c.tc as totloc
</cfif>
into ##cp1
from ##cp c
	left join Monedas m
		on m.Ecodigo = #session.Ecodigo#
		and m.Mcodigo = c.Mon
	left join OCtransporte oct
		on oct.OCTid = c.OCTid
<cfif form.resumido is '1'>
group by
	c.OCTid, c.per, c.mes, c.Aid, c.des,
	c.OC, c.SN, c.UM, m.Miso4217, oct.OCTtransporte</cfif>
</cfquery>
<cfquery datasource="#session.dsn#">
select
	c.OCTid, c.per, c.mes, c.Aid, c.des,
	c.OC, c.SN, c.UM, m.Miso4217 as mon, oct.OCTtransporte,
<cfif form.resumido is '1'>
	sum(c.can) as can, sum(c.tot) as tot, sum(c.tot*c.tc) as totloc
<cfelse>
	c.can, c.tot, c.doc, c.tot*c.tc as totloc
</cfif>
into ##cc1
from ##cc c
	left join Monedas m
		on m.Ecodigo = #session.Ecodigo#
		and m.Mcodigo = c.Mon
	left join OCtransporte oct
		on oct.OCTid = c.OCTid
<cfif form.resumido is '1'>
group by
	c.OCTid, c.per, c.mes, c.Aid, c.des,
	c.OC, c.SN, c.UM, m.Miso4217, oct.OCTtransporte</cfif>
</cfquery>


<cfquery datasource="#session.dsn#">
select Aid, OCTid,
	case when sum(can) = 0 then
		0
	else
		sum (tot) / sum(can)
	end as costo
into ##costocompra
from ##cp1
group by Aid, OCTid
</cfquery>
<cfquery datasource="#session.dsn#">
	<!--- Calcular para ordenes comerciales de almacenes, tanto compras como ventas --->
	select c.Aid as Aid, alm.Aid as Alm_Aid, c.mes, c.per,
		e.Eexistencia as exist, e.Ecostototal as costototal, $0 as Kcosto
	
	into ##kardex
	
	from ##cc1 c
	join Almacen alm
		on alm.Almcodigo = c.OCTtransporte
		and alm.Ecodigo  = #session.Ecodigo#
	join Existencias e
		on e.Aid = c.Aid
		and e.Alm_Aid = alm.Aid

	union

	select c.Aid as Aid, alm.Aid as Alm_Aid, c.mes, c.per,
		e.Eexistencia as exist, e.Ecostototal as total, $0 as Kcosto
	from ##cp1 c
	join Almacen alm
		on alm.Almcodigo = c.OCTtransporte
		and alm.Ecodigo  = #session.Ecodigo#
	join Existencias e
		on e.Aid = c.Aid
		and e.Alm_Aid = alm.Aid
</cfquery>
<cfquery datasource="#session.dsn#">
	update ##kardex
	set exist = exist - (
		select isnull ( sum (Kunidades), 0)
		from Kardex
		where Kardex.Aid      = ##kardex.Aid
		  and Kardex.Alm_Aid  = ##kardex.Alm_Aid
		  and Kperiodo >= ##kardex.per
		  and Kperiodo * 100 + Kmes > ##kardex.per * 100 + ##kardex.mes )
</cfquery>
<cfquery datasource="#session.dsn#">
	update ##kardex
	set costototal = costototal - (
		select isnull ( sum (Kcosto), 0)
		from Kardex
		where Kardex.Aid      = ##kardex.Aid
		  and Kardex.Alm_Aid  = ##kardex.Alm_Aid
		  and Kperiodo >= ##kardex.per
		  and Kperiodo * 100 + Kmes > ##kardex.per * 100 + ##kardex.mes )
</cfquery>
<cfquery datasource="#session.dsn#">
	update ##kardex
	set Kcosto = costototal / exist
	where exist != 0
</cfquery>
<cfquery datasource="#session.dsn#" name="rep">
	<!--- ventas --->
	select
		<cfif form.resumido is '0'>c.doc,</cfif>
		c.OCTid, c.per, c.mes, art.Acodigo as Art, c.des, 'CC' as tipo,
		c.OC, sn.SNnombre as SN, c.UM, c.mon, c.OCTtransporte,
		c.can, c.tot, c.totloc, alm.Almcodigo
	from ##cc1 c
	left join Almacen alm
		on alm.Almcodigo = c.OCTtransporte
		and alm.Ecodigo  = #session.Ecodigo#
	left join SNegocios sn
		on sn.SNcodigo = c.SN
		and sn.Ecodigo = #session.Ecodigo#
	left join Articulos art
		on art.Aid = c.Aid

	UNION ALL

<cfif form.comparar is 'compras'>
	<!--- compras --->
	select
		<cfif form.resumido is '0'>c.doc,</cfif>
		c.OCTid, c.per, c.mes, art.Acodigo as Art, c.des, 'CP' as tipo,
		c.OC, sn.SNnombre as SN, c.UM, c.mon, c.OCTtransporte,
		c.can,
		case when alm.Almcodigo is not null <!--- almacén --->
		then
			c.can * coalesce (k.Kcosto, 0) <!--- costo promedio según kardex --->
		else
			c.tot <!--- valor de compras --->
		end as tot, c.totloc, alm.Almcodigo
	from ##cp1 c
	left join Almacen alm
		on alm.Almcodigo = c.OCTtransporte
		and alm.Ecodigo  = #session.Ecodigo#
	left join SNegocios sn
		on sn.SNcodigo = c.SN
		and sn.Ecodigo = #session.Ecodigo#
	left join Articulos art
		on art.Aid = c.Aid
	left join ##kardex k
		on k.Alm_Aid = alm.Aid
		and k.per = c.per
		and k.mes = c.mes
		and k.Aid = c.Aid
<cfelseif form.comparar is 'costo'>
	<!--- costo de ventas: traer las ventas pero a precio de kardex --->
	select
		<cfif form.resumido is '0'>c.doc,</cfif>
		c.OCTid, c.per, c.mes, art.Acodigo as Art, c.des, 'CP' as tipo,
		c.OC, ' ' as SN, c.UM, c.mon, c.OCTtransporte,
		c.can,
		case when alm.Almcodigo is not null <!--- almacén --->
		then
			c.can * coalesce (k.Kcosto, 0)  <!--- costo promedio según kardex --->
		else
			c.can * coalesce (cos.costo, 0) <!--- costo promedio según compras --->
		end as tot,
		case when alm.Almcodigo is not null <!--- almacén --->
		then
			<!--- aplicar el tipo de cambio promedio ponderado de las ventas --->
			c.can * coalesce (k.Kcosto, 0)*case when c.tot = 0 then 1 else c.totloc/c.tot end
		else
			c.can * coalesce (cos.costo, 0)*case when c.tot = 0 then 1 else c.totloc/c.tot end
		end as totloc, alm.Almcodigo
	from ##cc1 c

	left join Almacen alm
		on alm.Almcodigo = c.OCTtransporte
		and alm.Ecodigo  = #session.Ecodigo#
	left join Articulos art
		on art.Aid = c.Aid
	left join ##kardex k
		on k.Alm_Aid = alm.Aid
		and k.per = c.per
		and k.mes = c.mes
		and k.Aid = c.Aid
	left join ##costocompra cos
		on cos.Aid = c.Aid
		and cos.OCTid = c.OCTid

</cfif>


order by OCTtransporte, Art, mon, per, mes, OC<cfif form.resumido is '0'>,c.doc</cfif>
</cfquery>
