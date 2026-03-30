<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset preictsdb       = Application.dsinfo.preicts.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>
<cfsetting requesttimeout="600">
<!--- Extracción de Gastos (Fact)--->

<!--- Correccion al Proceso para el manejo del IVA por el ajuste realizado por PMI, 
realizada por Ing. Luis A. Bolaños Gómez 11-jun-2007 --->

<cffunction name="droptable">
<cfquery datasource="sifinterfaces">
#DropTableSQL('##Ajuste')#
#DropTableSQL('##FAlmacenGA')#
#DropTableSQL('##ComprasAlmacenGA')#
#DropTableSQL('##FComprasGA')#
#DropTableSQL('##Concepto')#
#DropTableSQL('##GADCNO')#
#DropTableSQL('##GADCSI')#
#DropTableSQL('##GADDis')#
#DropTableSQL('##GADDis2')#
#DropTableSQL('##GADalmacen')#
#DropTableSQL('##GADalmacenDis')#
#DropTableSQL('##GADcompras')#
#DropTableSQL('##GADfletes')#
#DropTableSQL('##GADfletes2')#
#DropTableSQL('##GADnoalloc')#
#DropTableSQL('##GADsernoalloc')#
#DropTableSQL('##GADservicio')#
#DropTableSQL('##GADventas')#
#DropTableSQL('##GADventasDis')#
#DropTableSQL('##GastosA10D')#
#DropTableSQL('##GastosA10')#
#DropTableSQL('##GADCNO')#
#DropTableSQL('##GADCSI')#
#DropTableSQL('##OvsD_fletesGA')#
#DropTableSQL('##OvsD_fletesGA2')#
#DropTableSQL('##OvsD_ventaGA')#
#DropTableSQL('##VentasGAfletes')#
#DropTableSQL('##GastosIVA')#
#DropTableSQL('##OvsD_ventasGA')#
#DropTableSQL('##VAlmacenGA')#
#DropTableSQL('##VComprasGA')#
</cfquery>
</cffunction>

<cfset droptable()>
<!---GENERA EL ENCABEZADO--->
<cfquery datasource="sifinterfaces">
SELECT distinct 0 as ID,a.i_folio,a.i_anio,a.i_voucher, a.i_empresa, a.dt_fecha_recibo,a.dt_fecha_vencimiento,c.voucher_creation_date,
a.c_tipo_folio,	a.c_docto_proveedor,case when a.c_moneda like 'MXN' then 'MXP' when a.c_moneda like 'EURO' then 'EUR' else a.c_moneda end as c_moneda,
'XXXXXXXXXX' as CodigoConceptoServicio, 'XXX' as Codigo_Retencion,
'XXXXXXXXXXXXXXXXXXXX' as Direccion,abs(a.f_importe_total) as f_importe_total, abs(f_iva) as f_iva
INTO ##GastosA10
FROM #preictsdb#..PmiFolios a, #preictsdb#..voucher c
WHERE
	a.c_tipo_folio in ('FS','CC','FI','IC','MA','SC','SI','GA')
	and a.c_status not like 'RE'
	and a.i_voucher=c.voucher_num 
	and (convert(varchar(8),c.voucher_creation_date ,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">)
	<!---and a.i_empresa_prop=<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#"> --->
	and a.i_empresa_prop=<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	and (a.i_voucher is not null or a.i_voucher > 0)
	<!---and not exists (select 1 from #preictsdb#..PmiFoliosDetailS b, #preictsdb#..PmiFolios c where a.i_folio = b.i_folio and a.i_anio = b.i_anio and a.i_folio = c.i_folio and a.i_anio = c.i_anio and  b.c_concepto like 'RETENCIO' and c.dt_fecha_recibo < convert(date,'20070411',112))--->
ORDER BY 
	a.i_folio
</cfquery>
<cfquery datasource="sifinterfaces">
delete ##GastosA10
from ##GastosA10 a
where not exists (select 1 from #preictsdb#..voucher_cost d,#preictsdb#..cost e 
				where d.cost_num=e.cost_num and e.cost_status in ('PAID','VOUCHED')
				and	a.i_voucher=d.voucher_num)
</cfquery>
<!--- Elimina aquellos Registros que ya fueron procesados--->
<cfquery datasource="sifinterfaces">
delete ##GastosA10
from ##GastosA10 a
where exists(select 1 from InterfazBitacoraProcesos ib, #sifinterfacesdb#..IE10 ie where a.c_docto_proveedor = ie.Documento and a.c_tipo_folio = ie.CodigoTransacion and a.i_empresa = convert(int,ie.NumeroSocio) and ib.IdProceso 					= ie.ID and MsgError like 'OK' and ib.IdBitacora != 0 and ib.NumeroInterfaz = 10 and ib.SecReproceso >= 0) 
</cfquery>

<!---Actualiza la Direccion--->
<cfquery datasource="sifinterfaces">
update ##GastosA10 set Direccion = isnull(
	(select min(c.SNcodigoext) from #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c
	 where convert(int,b.SNcodigoext) = a.i_empresa								
	 and c.SNnombre in ('INSPECTOR','FLETADOR','AGENTE NAVIERO','AGENTE ADUANAL','OTRO ACREEDOR') 
	 and b.SNid = c.SNid 
	 and b.Ecodigo = c.Ecodigo 
	 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	 group by b.SNid,b.id_direccion),'XXXXXXXXXXXXXXXXXXXX')
from ##GastosA10 a
</cfquery>
<cfquery datasource="sifinterfaces">
update ##GastosA10 set Direccion = c.SNcodigoext
from ##GastosA10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c
where convert(int,b.SNcodigoext) = a.i_empresa
and c.SNnombre like '% - Principal' and b.SNid = c.SNid
and b.Ecodigo = c.Ecodigo 
and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
and a.Direccion = 'XXXXXXXXXXXXXXXXXXXX' 
</cfquery>
<cfquery datasource="sifinterfaces">
update ##GastosA10 set Direccion = ''
from ##GastosA10 a
where a.Direccion = 'XXXXXXXXXXXXXXXXXXXX' 
</cfquery>

<cfquery datasource="sifinterfaces">
alter table ##GastosA10
modify Codigo_Retencion varchar(5) null
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Actualiza el Codigo de Retencion --->
<!--- modificado danim, 26-nov-2007 --->
<!---
update ##GastosA10
set Codigo_Retencion = isnull(convert(varchar,(select min(i_iva_retencion) from #preictsdb#..PmiFoliosDetailS b where a.i_folio = b.i_folio and a.i_anio = b.i_anio and b.c_concepto like 'RETENCIO')),'WR')
from ##GastosA10 a
where exists (select 1 from #preictsdb#..PmiFoliosDetailS c where a.i_folio = c.i_folio and a.i_anio = c.i_anio and c.c_concepto like 'RETENCIO')
--->


update ##GastosA10
set Codigo_Retencion = isnull(convert(varchar,(
	select min(i_iva_retencion)
	from #preictsdb#..PmiFoliosDetailS b
	where a.i_folio = b.i_folio
	  and a.i_anio = b.i_anio
	  and b.c_concepto like 'RETENCIO')),'WR')
from ##GastosA10 a
where 1 = (
	select count(1)
	from #preictsdb#..PmiFoliosDetailS c
	where a.i_folio = c.i_folio
	  and a.i_anio = c.i_anio
	  and c.c_concepto like 'RETENCIO')
	  
	  


update ##GastosA10
set Codigo_Retencion = coalesce (
	(

	<!---
		obtener la retención compuesta que tenga la misma composición que las
		retenciones en PmiFoliosDetailS.
		Esto se valida viendo que no haya en la composición una retención que
		no esté en PmiFoliosDetailS y viceversa.
	--->

	select min (Rcodigo)
	from #minisifdb#..Retenciones r
	where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and r.Rcodigo in (<!--- que sea compuesta --->
		select Rcodigo
		from #minisifdb#..RetencionesComp rc
		where rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)

		
	  	<!---
			que todas las retenciones de la composición estén en pmifolios
			o sea que no hay retenciones en la compuesta que no estén en pmifolios
			rc = Desglose de la retención
			fd = Todos los PmiFoliosDetailS de esta factura
		--->
	  and not exists (
	  	select 1
		from #minisifdb#..RetencionesComp rc
		where rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and rc.Rcodigo = r.Rcodigo
		  and not exists (
			select 1
			from #preictsdb#..PmiFoliosDetailS fd
			where a.i_folio = fd.i_folio
			  and a.i_anio  = fd.i_anio
			  and fd.c_concepto like 'RETENCIO'
			  and rc.RcodigoDet = convert(char(2), fd.i_iva_retencion)
		  )
	  )
	  
	  	<!---
			que todas las retenciones en pmifolios estén en la composición
			o sea que no hay retenciones en la compuesta que no estén en pmifolios
			rc = Desglose de la retención
			fd = Todos los PmiFoliosDetailS de esta factura
		--->
	  and not exists (
	  	select 1
		from #preictsdb#..PmiFoliosDetailS fd
		where a.i_folio = fd.i_folio
		  and a.i_anio  = fd.i_anio
		  and fd.c_concepto like 'RETENCIO'
		  and not exists (
			select 1
			from #minisifdb#..RetencionesComp rc
			where rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  	  and rc.Rcodigo = r.Rcodigo
			  and rc.RcodigoDet = convert(char(2), fd.i_iva_retencion)
		  )
	  )
	), 'WX')<!--- indicar un tipo de error distinto --->
from ##GastosA10 a
where 1 < (
	select count(1)
	from #preictsdb#..PmiFoliosDetailS c
	where a.i_folio = c.i_folio
	  and a.i_anio = c.i_anio
	  and c.c_concepto like 'RETENCIO')

</cfquery>

<!---************* GENERA EL DETALLE **************--->
<cfquery datasource="sifinterfaces">
select  0 as Consecutivo,0 as Consecutivo2,0 as CIVA,a.*,b.cost_owner_key6,b.cost_owner_key7,cost_owner_key8,
'XXXXXXXXXXXXXXXXXXXXX' as c_orden,
case when cost_pay_rec_ind  = 'R'  then b.cost_amt * -1 else  b.cost_amt end as cost_amt, null as iva, b.cost_qty, b.cost_qty_uom_code,b.cost_unit_price, b.cost_code, 
'XXX' as Codigo_Impuesto
into ##GastosA10D
from ##GastosA10 a, #preictsdb#..cost b,#preictsdb#..voucher_cost c
where 
c.voucher_num = a.i_voucher
and b.cost_num = c.cost_num
and b.cost_code not in ('IVA','RETENCIO','TAX')
and b.cost_amt != 0
order by i_folio
</cfquery>

<!---  CONCEPTO  --->
<cfquery datasource="sifinterfaces">
select distinct sb.subconcepto_id, ff.cost_code
	INTO ##Concepto
	FROM #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r, #tesoreriadb#..subconceptos_detalle s,  ##GastosA10D ff
	WHERE s.costo_id = ff.cost_code
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id

UPDATE ##GastosA10D  set CodigoConceptoServicio = convert(varchar,b.subconcepto_id) from ##GastosA10D a,  ##Concepto b WHERE a.cost_code=b.cost_code
UPDATE ##GastosA10D set CodigoConceptoServicio =''  WHERE CodigoConceptoServicio='XXXXXXXXXX'
UPDATE ##GastosA10 set a.CodigoConceptoServicio = (select min(b.CodigoConceptoServicio) from ##GastosA10D b WHERE a.i_folio = b.i_folio and a.i_anio = b.i_anio group by i_folio)
from ##GastosA10 a

#DropTableSQL('##Concepto')#
</cfquery>

<cfquery datasource="sifinterfaces">
alter table ##GastosA10D
modify iva float null
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Actualiza la orden Comercial --->
update ##GastosA10D set 
c_orden = acct_ref_num
from ##GastosA10D a, #preictsdb#..trade c
where a.cost_owner_key6 = c.trade_num

update ##GastosA10D set 
c_orden = ''
from ##GastosA10D a
where a.c_orden = 'XXXXXXXXXXXXXXXXXXXXX' 
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- Actualiza el CIVA --->
declare @a int
select @a = 0
update ##GastosA10D
set CIVA = @a+1, @a = @a +1

<!---Actualiza El IVA --->
update ##GastosA10D
set iva = abs(b.f_importe)
from ##GastosA10D a, #preictsdb#..PmiFoliosDetailS b
where a.i_folio = b.i_folio
and a.i_anio = b.i_anio
and b.c_concepto in ('IVA','TAX')
and exists (select 1 from #preictsdb#..PmiFoliosDetailS c where c.i_folio = a.i_folio and c.i_anio = a.i_anio and a.cost_code = c.c_concepto)
and CIVA = (select min(CIVA) from ##GastosA10D d where d.i_folio = a.i_folio and d.i_anio = a.i_anio and iva is null group by i_folio) 
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Si el iva lo trae en el encabezado --->
update ##GastosA10D
set iva = abs(b.f_iva)
from ##GastosA10D a, #preictsdb#..PmiFolios b
where a.i_folio = b.i_folio
and a.i_anio=b.i_anio
and b.c_status not like 'RE'
and abs(b.f_iva) > 0 
and CIVA = (select min(CIVA) from ##GastosA10D d where d.i_folio = a.i_folio and a.i_anio = b.i_anio group by i_folio) 
and a.iva is null 

<!---Cambia el iva null a 0--->
update ##GastosA10D
set iva = 0
from ##GastosA10D a
where a.iva is null 
</cfquery>

<!---Se Elimina este ajuste por que ocasiona Error en los Importes 13/sep/07--->
<!--- Ajuste de costos con total de folio 
<cfquery datasource="sifinterfaces">
select distinct i_folio, i_anio,f_importe_total,sum(cost_amt) as Sub_total, sum(iva) as IVA ,sum(cost_amt) + sum(iva) as Total, 
(f_importe_total + f_iva) - (sum(cost_amt) + sum(iva)) as Dif, Codigo_Retencion, 
case when Codigo_Retencion = '01' then sum(cost_amt)  *.04 else 0 end as Retencion,
case when Codigo_Retencion = '01' then (sum(cost_amt) + sum(iva))-(sum(cost_amt) *.04) else sum(cost_amt) + sum(iva) end as Total_Retencion
into ##Ajuste
from ##GastosA10D group by i_folio order by i_folio

update ##GastosA10D set cost_amt = a.cost_amt + b.Dif
from ##GastosA10D a, ##Ajuste b
where a.i_folio = b.i_folio and a.i_anio = b.i_anio
and (a.Codigo_Retencion like 'XXX' or a.Codigo_Retencion is null)
and CIVA = case when b.Dif >= 0 then (select min(CIVA) from ##GastosA10D d where d.i_folio = a.i_folio 
and d.i_anio = a.i_anio group by i_folio) 
else (select min(CIVA) from ##GastosA10D d where d.i_folio = a.i_folio and d.i_anio = a.i_anio
	and d.cost_amt = (select max(cost_amt) from ##GastosA10D e where d.i_folio = e.i_folio 
						and d.i_anio = e.i_anio group by i_folio) group by i_folio) end
and b.Dif < 10 

#DropTableSQL('##Ajuste')#
</cfquery>
--->
<cfquery datasource="sifinterfaces">
alter table ##GastosA10D
modify Codigo_Impuesto varchar(5) null
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Actualiza el Codigo de Impuesto --->
update ##GastosA10D
set Codigo_Impuesto = isnull(convert(varchar,(select min(i_iva_retencion) from #preictsdb#..PmiFoliosDetailS b where a.i_folio = b.i_folio and a.i_anio = b.i_anio and b.c_concepto like 'IVA')),'ERROR')
from ##GastosA10D a
where exists (select 1 from #preictsdb#..PmiFoliosDetailS c where a.i_folio = c.i_folio and a.i_anio = c.i_anio and c.c_concepto like 'IVA')
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Query que selecciona los gastos asociados Tipo Servicio--->
select distinct * 
into ##GADservicio
from ##GastosA10D
where cost_owner_key6 is null
order by i_folio

<!--- Query que selecciona los gastos asociados a Compras --->
select distinct a.* 
into ##GADcompras
from ##GastosA10D a, #preictsdb#..allocation_item b
where a.cost_owner_key6 = b.trade_num 
and b.alloc_item_type = 'R' 
order by i_folio

<!--- Query que selecciona los gastos asociados a Ventas --->
select distinct a.* 
into ##GADventas
from ##GastosA10D a, #preictsdb#..allocation_item b
where a.cost_owner_key6 = b.trade_num and
b.alloc_item_type = 'D' 
order by i_folio

<!--- Query que selecciona los gastos asociados a Fletes --->
select distinct a.* 
into ##GADfletes
from ##GastosA10D a, #preictsdb#..allocation_item b
where a.cost_owner_key6 = b.trade_num and
b.alloc_item_type in ('T','N')
order by i_folio

<!--- Query que selecciona los gastos asociados a Almacen --->
select distinct a.* 
into ##GADalmacen
from ##GastosA10D a, #preictsdb#..allocation_item b
where a.cost_owner_key6 = b.trade_num and
b.alloc_item_type in ('C','I') 
order by i_folio

<!--- Query que selecciona los gastos no alocados --->
select distinct a.* 
into ##GADnoalloc
from ##GastosA10D a
where not exists (select 1 from  #preictsdb#..allocation_item b where a.cost_owner_key6 = b.trade_num)
and cost_owner_key6 is not null
order by i_folio
</cfquery>
<!--- Se quita esta funcion para evitar descuadre de Datos --->
<!--- Se eliminan los gastos asociados que se encuentren en mas de una de las clasificaciones 
<cfquery datasource="sifinterfaces">
delete ##GADalmacen
from ##GADalmacen a
where 
exists (select 1 from ##GADcompras b where a.i_folio = b.i_folio) or exists (select 1 from ##GADventas b 
where a.i_folio = b.i_folio and a.i_anio = b.i_anio) 
or exists (select 1 from ##GADfletes b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)

delete ##GADfletes 
from ##GADfletes a
where 
exists (select 1 from ##GADcompras b where a.i_folio = b.i_folio and a.i_anio = b.i_anio ) 
or exists (select 1 from ##GADventas b where a.i_folio = b.i_folio and a.i_anio = b.i_anio) 

delete ##GADventas
from ##GADventas a
where 
exists (select 1 from ##GADcompras b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
</cfquery>
--->

<!--- G A S T O S   A S O C I A D O S   A    V E N T A S --->
<cfquery datasource="sifinterfaces">
<!--- PROCESO PARA LOS QUE SOLO VAN A VENTA --->
<!--- OBTIENE ORIGEN DE LA VENTA SEA ALMACEN O COMPRA --->
select distinct
v.CIVA,v.i_folio,v.i_anio,v.Socio_Factura,v.Costo_Factura,v.trade_num as Orden_Origen_num, v.acct_ref_num as Orden_Origen, v.alloc_item_type as Movimiento_Origen,
case 
when v.alloctype2 in ('R','I') then v.alloctype2
when v.alloctype3 in ('R','I') then v.alloctype3
when v.alloctype4 in ('R','I') then v.alloctype4
else null end as Movimiento_Destino,
case 
when v.alloctype2 in ('R','I') then v.trade2
when v.alloctype3 in ('R','I') then v.trade3
when v.alloctype4 in ('R','I') then v.trade4
else null end as Orden_Final_num,
case 
when v.alloctype2 in ('R','I') then v.acct_ref_num_2
when v.alloctype3 in ('R','I') then v.acct_ref_num_3
when v.alloctype4 in ('R','I') then v.acct_ref_num_4
else null end as Orden_Final,
case 
when v.alloctype2 in ('R','I') then v.FTipoCambio2
when v.alloctype3 in ('R','I') then v.FTipoCambio3
when v.alloctype4 in ('R','I') then v.FTipoCambio4
else null end as FTipoCambio
into ##OvsD_ventasGA
from 
(
select  distinct c.CIVA,c.i_folio,c.i_anio,c.i_empresa as Socio_Factura,round(c.cost_amt,2) as Costo_Factura,a.trade_num,a.acct_ref_num, a.alloc_num,a.alloc_item_type,a.title_tran_date as FTipoCambio,
aa.trade_num as trade2,aa.acct_ref_num as acct_ref_num_2, aa.alloc_num as alloc2,aa.alloc_item_type as alloctype2,
aa.title_tran_date as FTipoCambio2,
ab.trade_num as trade3,ab.acct_ref_num as acct_ref_num_3, ab.alloc_num as alloc3,ab.alloc_item_type as alloctype3,
ab.title_tran_date as FTipoCambio3,
ac.trade_num as trade4,ac.acct_ref_num as acct_ref_num_4, ac.alloc_num as alloc4,ac.alloc_item_type as alloctype4,
ac.title_tran_date as FTipoCambio4
from #preictsdb#..allocation_item a,#preictsdb#..allocation_item aa, #preictsdb#..allocation_item ab, #preictsdb#..allocation_item ac, ##GADventas c
where 
a.trade_num = c.cost_owner_key6
and a.alloc_num=aa.alloc_num
and aa.alloc_item_type in ('R','N','T','I')
and a.trade_num != aa.trade_num
and aa.trade_num = ab.trade_num
and ab.trade_num != a.trade_num
and ab.alloc_item_type in ('R','I','T')
and ab.alloc_num = ac.alloc_num
and ac.trade_num != a.trade_num
and ac.alloc_item_type in ('R','I') 
) v order by i_folio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- Este Proceso genera la cuenta apartir del proceso anterior --->
<!--- PROCESO PARA LOS SOLO ALOCADOS A ALMACEN --->
select q.*
into ##VAlmacenGA
from  
(
<!--- Carga los productos de las ventas y la Amortizacion por producto --->
select l.*,count(distinct l.cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct l.cmdty_code) as Amortiza, 'A' as Tipo
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y, #preictsdb#..trade_item tit,
(
/* Este sub-query obtiene todos las compras asociadas solo a Almacen */
select * from ##OvsD_ventasGA a
where Movimiento_Destino in ('C','I')
and not exists (select 1 from ##OvsD_ventasGA b where a.Orden_Origen = b.Orden_Origen
			and b.Movimiento_Destino = 'R')
) z
where
y.trade_num = z.Orden_Final_num
and tit.trade_num = y.trade_num
and tit.order_num = y.order_num
and tit.p_s_ind = 'P'
<!--- Se quita esta opcion en ventas para eliminar cuando el producto de venta sea una transformacion --->
<!---and exists (select 1 from #preictsdb#..allocation_item ax where ax.cmdty_code = y.cmdty_code and ax.trade_num = z.Orden_Origen_num)--->
) m
group by Orden_Origen 
)l 
group by Orden_Final,Orden_Origen
) q
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- PROCESO PARA LOS ALOCADOS SOLO A COMPRA--->
select q.*
into ##VComprasGA
from 
(
<!--- Carga los productos de las ventas y la Amortizacion por producto --->
select l.*,count(distinct cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct cmdty_code) as Amortiza,'O' as Tipo 
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y,
(
/* Este sub-query obtiene todos las compras asociadas solo a compras */
select * from ##OvsD_ventasGA a
where Movimiento_Destino = 'R'
) z
where
y.trade_num = z.Orden_Final_num
) m
group by Orden_Origen 
)l
group by Orden_Final,Orden_Origen
) q
select a.* 
into ##GADventasDis
from 
(
select a.*, b.cmdty_code, b.NProductos, Orden_Final,Orden_Origen,Amortiza,Movimiento_Destino,Tipo
from ##GADventas a inner join ##VAlmacenGA b on
b.i_folio = a.i_folio and b.i_anio = a.i_anio
and a.CIVA = b.CIVA
and b.Orden_Origen_num = a.cost_owner_key6
where Amortiza is not null

union

select a.*, b.cmdty_code,b.NProductos,Orden_Final,Orden_Origen,Amortiza,Movimiento_Destino,Tipo
from ##GADventas a inner join ##VComprasGA b on
b.i_folio = a. i_folio and b.i_anio = a.i_anio
and a.CIVA = b.CIVA
and b.Orden_Origen_num = a.cost_owner_key6
where Amortiza is not null
) a order by i_folio
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- Genera el ID del Encabezado --->
declare @i int
select @i= 0

UPDATE ##GastosA10 set ID=@i + 1,@i=@i+1 
</cfquery>
<!--- Inserta datos PMIINT_IE10 --->
<cfquery datasource="sifinterfaces">
INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid,
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,14, convert (varchar,i_empresa), 'CP' ,c_tipo_folio,
	isnull(c_docto_proveedor,'ERROR DOCUMENTO'), null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
	'1', 'ICTS',convert(varchar,i_voucher),null,case when a.Codigo_Retencion = 'XXX' then null else a.Codigo_Retencion end,
	null ,0 , case when Direccion like '' then null else convert(varchar,Direccion) end, case when Direccion like '' then null else convert(varchar,Direccion) end,
	 dt_fecha_recibo, 1
FROM  ##GastosA10 a  
where exists(select 1 from ##GADventasDis b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and not exists(select 1 from #sifinterfacesdb#..PMIINT_IE10 c where a.ID = c.ID and c.sessionid = #session.monitoreo.sessionid#)
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- ID DE DETALLE --->
update  ##GADventasDis
set ID = e.ID
from  ##GADventasDis   d, ##GastosA10  e
where d.i_folio = e.i_folio and d.i_anio = e.i_anio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- CONSECUTIVO SwapFACT_ID10 --->
declare @a int
select @a=0
update ##GADventasDis
set Consecutivo2 = @a+1,@a=@a+1
from ##GADventasDis d, ##GastosA10 e
where d.ID = e.ID

select @a=0
UPDATE ##GADventasDis set Consecutivo= @a+1+isnull((select  max(Consecutivo) from #sifinterfacesdb#..PMIINT_ID10 id where id.ID = d.ID and id.sessionid = #session.monitoreo.sessionid#),0), @a = 
case 
when exists (select 1 from ##GADventasDis c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##GADventasDis d
</cfquery>

<!---Reajusta IVA--->
<cfquery datasource="sifinterfaces">
update ##GADventasDis
set iva = 0
from ##GADventasDis a where iva > 0 
and Consecutivo > (select min(Consecutivo) from ##GADventasDis b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and (select count(ID) from ##GADventasDis c where a.i_folio = c.i_folio and a.i_anio = c.i_anio group by i_folio) > 1
</cfquery>
<!--- INSERTAR CAMPOS EN PMIINT_ID10 --->
<cfquery datasource="sifinterfaces">
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid, 
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, a.Tipo, a.cmdty_code  , null, 
null, null,0,'',0, 
0, null, '0',a.voucher_creation_date,null, 
a.Orden_Final, case when a.Codigo_Impuesto like 'XXX' then case when exists (select 1 from ##GADventasDis b where a.ID = b.ID and isnull(b.iva,0) > 0) then 'IVA15' else null end else a.Codigo_Impuesto end,0,0, case when a.Movimiento_Destino in ('D','R') then null else a.Orden_Final end,
null,convert(money,round(a.Amortiza,2)),null,
null,
case when a.Tipo like 'O' then (select min(OCTtipo) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.Orden_Final = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid)
else null end,
case when a.Tipo like 'O' then (select min(OCTtransporte) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.Orden_Final = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid)
else null end,
a.Orden_Final,convert(varchar,a.CodigoConceptoServicio)
FROM ##GADventasDis a
</cfquery>

<!---  G A S T O S   A S O C I A D O S   D E   S E R V I C I O--->
<cfquery datasource="sifinterfaces">
select a.* 
into ##GADsernoalloc
from 
(select * from ##GADservicio 
union 
select * from ##GADnoalloc
) a order by i_folio
</cfquery>
<!--- Inserta datos PMIINT_IE10 --->
<cfquery datasource="sifinterfaces">
INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid,
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct 
	<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
	ID,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
	convert (varchar,i_empresa), 'CP' ,c_tipo_folio,isnull(c_docto_proveedor,'ERROR DOCUMENTO'), 
	null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,'1', 'ICTS',
	convert(varchar,i_voucher),null,case when a.Codigo_Retencion = 'XXX' then null else a.Codigo_Retencion end,
	null ,0 , case when Direccion like '' then null else convert(varchar,Direccion) end, 
	case when Direccion like '' then 	null else convert(varchar,Direccion) end,
	dt_fecha_recibo, 1
FROM  ##GastosA10 a  
where exists(select 1 from ##GADsernoalloc b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and not exists(select 1 from #sifinterfacesdb#..PMIINT_IE10 c where a.ID = c.ID and c.sessionid = #session.monitoreo.sessionid#)
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ID DE DETALLE --->
update  ##GADsernoalloc
set ID = e.ID
from  ##GADsernoalloc d, ##GastosA10  e
where d.i_folio = e.i_folio and d.i_anio = e.i_anio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- CONSECUTIVO SwapFACT_ID10 --->
declare @a int
select @a=0
update ##GADsernoalloc
set Consecutivo2 = @a+1,@a=@a+1
from ##GADsernoalloc d, ##GastosA10 e
where d.ID = e.ID

select @a=0
UPDATE ##GADsernoalloc set Consecutivo= @a+1+isnull((select  max(Consecutivo) from #sifinterfacesdb#..PMIINT_ID10 id where id.ID = d.ID and id.sessionid = #session.monitoreo.sessionid#),0), @a = 
case 
when exists (select 1 from ##GADsernoalloc c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##GADsernoalloc d
</cfquery>
<!--- INSERTAR CAMPOS EN PMIINT_ID10 --->
<cfquery datasource="sifinterfaces">
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid, 
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, 'S', convert(varchar,a.CodigoConceptoServicio), null, 
null, null,convert(money ,round(a.cost_amt,2)),'',1, 
0, null, '0',a.voucher_creation_date,null, 
null, case when a.Codigo_Impuesto like 'XXX' then case when exists (select 1 from ##GADsernoalloc b where a.ID = b.ID and isnull(b.iva,0) > 0) then 'IVA15' else null end else a.Codigo_Impuesto end,0,0, null,
null,convert(money,round(a.cost_amt,2)),null,
null,null,null,null,convert(varchar,a.CodigoConceptoServicio)
FROM ##GADsernoalloc a
</cfquery>

<!--- G A S T O S   A S O C I A D O S   A    A L M A C E N --->
<cfquery datasource="sifinterfaces">
select q.*, '' as Cuenta
into ##GADalmacenDis
from #minisifdb#..SNegocios u, #minisifdb#..Articulos t, #minisifdb#..OCcomplementoArticulo s, #minisifdb#..OCconceptoCompra oz,
(
<!--- Carga los productos de las ventas y la Amortizacion por producto --->
select l.*,count(distinct cmdty_code) as NProductos, round(l.cost_amt,2)/count(distinct cmdty_code) as Amortiza 
from 
(
select distinct m.*,count(distinct cost_owner_key6) as NVentas
from
(
select distinct z.*, ar.Acodigo as cmdty_code
from #minisifdb#..Articulos ar, #minisifdb#..Existencias ex, #minisifdb#..Almacen am, ##GADalmacen z
where
am.Almcodigo = z.c_orden
and ex.Alm_Aid = am.Aid
and ar.Aid = ex.Aid
and ar.Ecodigo = ex.Ecodigo 
and ar.Ecodigo = am.Ecodigo 
and ar.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
<!---order by z.Orden_Final--->
) m
group by i_folio
)l
group by cost_owner_key6
) q
	where q.i_empresa= convert(int,u.SNcodigoext)
		and t.Acodigo=q.cmdty_code 
		and t.Aid=s.Aid 
		and oz.OCCcodigo=q.CodigoConceptoServicio order by i_folio
</cfquery>
<!--- Inserta datos PMIINT_IE10 --->
<cfquery datasource="sifinterfaces">
INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid, 
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
	convert (varchar,i_empresa), 'CP' ,c_tipo_folio,
	isnull(c_docto_proveedor,'ERROR DOCUMENTO'), null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
	'1', 'ICTS',convert(varchar,i_voucher),null,case when a.Codigo_Retencion = 'XXX' then null else a.Codigo_Retencion end,
	null ,0 , case when Direccion like '' then null else convert(varchar,Direccion) end, case when Direccion like '' then null else convert(varchar,Direccion) end,
	 dt_fecha_recibo, 1
FROM  ##GastosA10 a  
where exists(select 1 from ##GADalmacenDis b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and not exists(select 1 from #sifinterfacesdb#..PMIINT_IE10 c where a.ID = c.ID and c.sessionid = #session.monitoreo.sessionid#)
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ID DE DETALLE --->
update  ##GADalmacenDis
set ID = e.ID
from  ##GADalmacenDis   d, ##GastosA10  e
where d.i_folio = e.i_folio and d.i_anio = e.i_anio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- CONSECUTIVO SwapFACT_ID10 --->
declare @a int
select @a=0
update ##GADalmacenDis
set Consecutivo2 = @a+1,@a=@a+1
from ##GADalmacenDis d, ##GastosA10 e
where d.ID = e.ID

select @a=0
UPDATE ##GADalmacenDis set Consecutivo= @a+1+isnull((select  max(Consecutivo) from #sifinterfacesdb#..PMIINT_ID10 id where id.ID = d.ID and id.sessionid = #session.monitoreo.sessionid#),0), @a = 
case 
when exists (select 1 from ##GADalmacenDis c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##GADalmacenDis d
</cfquery>
<!--- INSERTAR CAMPOS EN PMIINT_ID10 --->
<cfquery datasource="sifinterfaces">
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid, 
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, 'A', a.cmdty_code  , null, 
null, null,0,'',0,
0, null, '0',a.voucher_creation_date,null, 
a.c_orden, case when a.Codigo_Impuesto like 'XXX' then case when exists (select 1 from ##GADalmacenDis b where a.ID = b.ID and isnull(b.iva,0) > 0) then 'IVA15' else null end else a.Codigo_Impuesto end,0,0, (select min(acct_ref_num) from #preictsdb#..trade b where b.trade_num = a.cost_owner_key6),
null,convert(money,round(a.Amortiza,2)),null,
a.Cuenta,null,null,a.c_orden,convert(varchar,a.CodigoConceptoServicio)
FROM ##GADalmacenDis a
</cfquery>

<!--- G A S T O S   A S O C I A D O S   A    F L E T E S--->
<cfquery datasource="sifinterfaces">
<!--- PROCESO PARA BUSCAR LAS ORDENES DE COMPRA o ALMACEN ASOCIADAS AL FLETE --->
select distinct
v.CIVA,v.i_folio,v.i_anio,v.Socio_Factura,v.Costo_Factura,v.trade_num as Orden_Origen_num,
v.acct_ref_num as Orden_Origen, v.alloc_item_type as Movimiento_Origen,
case 
when v.alloctype2 in ('R','I') then v.alloctype2
when v.alloctype3 in ('R','I') then v.alloctype3
when v.alloctype4 in ('R','I') then v.alloctype4
else null end as Movimiento_Destino,
case 
when v.alloctype2 in ('R','I') then v.trade2
when v.alloctype3 in ('R','I') then v.trade3
when v.alloctype4 in ('R','I') then v.trade4
else null end as Orden_Final_num,
case 
when v.alloctype2 in ('R','I') then v.acct_ref_num_2
when v.alloctype3 in ('R','I') then v.acct_ref_num_3
when v.alloctype4 in ('R','I') then v.acct_ref_num_4
else null end as Orden_Final,
case 
when v.alloctype2 in ('R','I') then v.FTipoCambio2
when v.alloctype3 in ('R','I') then v.FTipoCambio3
when v.alloctype4 in ('R','I') then v.FTipoCambio4
else null end as FTipoCambio
into ##OvsD_fletesGA
from 
(
select  distinct c.CIVA,c.i_folio,c.i_anio,c.i_empresa as Socio_Factura,round(c.cost_amt,2) as Costo_Factura,a.trade_num,a.acct_ref_num, a.alloc_num,a.alloc_item_type,a.title_tran_date as FTipoCambio,
aa.trade_num as trade2,aa.acct_ref_num as acct_ref_num_2, aa.alloc_num as alloc2,aa.alloc_item_type as alloctype2,
aa.title_tran_date as FTipoCambio2,
ab.trade_num as trade3,ab.acct_ref_num as acct_ref_num_3, ab.alloc_num as alloc3,ab.alloc_item_type as alloctype3, 
ab.title_tran_date as FTipoCambio3,
ac.trade_num as trade4,ac.acct_ref_num as acct_ref_num_4, ac.alloc_num as alloc4,ac.alloc_item_type as alloctype4, 
ac.title_tran_date as FTipoCambio4
from #preictsdb#..allocation_item a,#preictsdb#..allocation_item aa, #preictsdb#..allocation_item ab,#preictsdb#..allocation_item ac,##GADfletes c
where 
a.trade_num = c.cost_owner_key6
and a.alloc_num=aa.alloc_num
and aa.alloc_item_type in ('R','N','I','T')
and a.trade_num != aa.trade_num
and aa.trade_num = ab.trade_num
and ab.trade_num != a.trade_num
and ab.alloc_item_type in ('R','I')
and ab.alloc_num = ac.alloc_num
and ac.trade_num != a.trade_num
and ac.alloc_item_type in ('R','I') 
) v order by i_folio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- PROCESO PARA LOS QUE SOLO VAN A ALMACEN --->
select q.*,'' as Cuenta
into ##FAlmacenGA
from 
(
<!--- Carga los productos de las ventas y la Amortizacion por producto --->
select l.*,count(distinct cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct cmdty_code) as Amortiza, 'A' as Tipo 
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y, #preictsdb#..trade_item tit,
(
<!--- Este sub-query obtiene todos las compras asociadas solo a Almacen --->
select * from ##OvsD_fletesGA a
where Movimiento_Destino in ('C','I')
and not exists (select 1 from ##OvsD_fletesGA b where a.Orden_Origen = b.Orden_Origen
			and b.Movimiento_Destino = 'R')
) z
where
y.trade_num = z.Orden_Final_num
and tit.trade_num = y.trade_num
and tit.order_num = y.order_num
and tit.p_s_ind = 'P'
and exists (select 1 from #preictsdb#..allocation_item ax where ax.cmdty_code = y.cmdty_code and ax.trade_num = z.Orden_Origen_num)
<!---order by z.Orden_Final--->
) m
group by Orden_Origen 
)l
group by Orden_Final,Orden_Origen
) q
		order by i_folio
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- PROCESO PARA LOS QUE VAN A COMPRAS --->
select q.*, '' as Cuenta
into ##FComprasGA
from 
(
<!--- Carga los productos de las ventas y la Amortizacion por producto --->
select l.*,count(distinct cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct cmdty_code) as Amortiza, 'O' as Tipo
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y,
(
<!--- Este sub-query obtiene todos las compras asociadas solo a ventas --->
select * from ##OvsD_fletesGA a
where Movimiento_Destino = 'R'
) z
where
y.trade_num = z.Orden_Final_num
<!---order by z.Orden_Final--->
) m
group by Orden_Origen 
)l
group by Orden_Final,Orden_Origen 
) q
order by i_folio
</cfquery>

<cfquery datasource="sifinterfaces">
<!--- CREA LA TABLA CON LAS DISTRIBUCIONES Y LAS CUENTAS CREADAS --->
select a.* 
into ##GADfletes2 
from 
(
select a.*, b.cmdty_code, b.NProductos, Orden_Final,Orden_Origen,Amortiza,Cuenta,Movimiento_Destino,b.Tipo
from ##GADfletes a inner join ##FAlmacenGA b on
b.i_folio = a.i_folio and b.i_anio = a.i_anio
and a.CIVA = b.CIVA
and a.cost_owner_key6 = b.Orden_Origen_num
where Amortiza is not null
<!---order by i_folio--->

union

select a.*, b.cmdty_code as Producto,b.NProductos,Orden_Final,Orden_Origen,Amortiza,Cuenta,Movimiento_Destino,b.Tipo
from ##GADfletes  a inner join ##FComprasGA b on
b.i_folio = a. i_folio and b.i_anio = a.i_anio
and a.CIVA = b.CIVA
and a.cost_owner_key6 = b.Orden_Origen_num
where Amortiza is not null
<!---order by i_folio--->
) a 
order by i_folio
</cfquery>
<!--- Inserta datos PMIINT_IE10 --->
<cfquery datasource="sifinterfaces">
INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid, 
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,14, convert (varchar,i_empresa), 'CP' ,c_tipo_folio,
	isnull(c_docto_proveedor,'ERROR DOCUMENTO'), null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
	'1', 'ICTS',convert(varchar,i_voucher),null,case when a.Codigo_Retencion = 'XXX' then null else a.Codigo_Retencion end,
	null ,0 , case when Direccion like '' then null else convert(varchar,Direccion) end, case when Direccion like '' then null else convert(varchar,Direccion) end,
	 dt_fecha_recibo, 1
FROM  ##GastosA10 a  
where exists(select 1 from ##GADfletes2 b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and not exists(select 1 from #sifinterfacesdb#..PMIINT_IE10 c where a.ID = c.ID and c.sessionid = #session.monitoreo.sessionid#)
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ----------- ID DE DETALLE ------------ --->
update  ##GADfletes2
set ID = e.ID
from  ##GADfletes2  d, ##GastosA10  e
where d.i_folio = e.i_folio and d.i_anio = e.i_anio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ------------ CONSECUTIVO SwapFACT_ID10 ---------------->
declare @a int
select @a=0
update ##GADfletes2
set Consecutivo2 = @a+1, @a=@a+1
from ##GADfletes2 d, ##GastosA10 e
where d.ID = e.ID

select @a=0
UPDATE ##GADfletes2 set Consecutivo= @a+1+isnull((select  max(Consecutivo) from #sifinterfacesdb#..PMIINT_ID10 id where id.ID = d.ID and id.sessionid = #session.monitoreo.sessionid#),0), @a = 
case 
when exists (select 1 from ##GADfletes2 c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##GADfletes2 d
</cfquery>
<cfquery datasource="sifinterfaces">
<!---Reajusta IVA--->
update ##GADfletes2
set iva = 0
from ##GADfletes2 a where iva > 0 
and Consecutivo > (select min(Consecutivo) from ##GADfletes2 b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and (select count(ID) from ##GADfletes2 c where a.i_folio = c.i_folio and a.i_anio = c.i_anio group by i_folio) > 1
</cfquery>
<!--- INSERTAR CAMPOS EN PMIINT_ID10 --->
<cfquery datasource="sifinterfaces">
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid, 
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, a.Tipo, a.cmdty_code, null, 
null, null,0,'',0,
0, null, '0',a.voucher_creation_date,null, 
a.Orden_Final, case when a.Codigo_Impuesto like 'XXX' then case when exists (select 1 from ##GADfletes2 b where a.ID = b.ID and isnull(b.iva,0) > 0) then 'IVA15' else null end else a.Codigo_Impuesto end,0,0, case when a.Movimiento_Destino in ('D','R') then null else a.Orden_Final end,
null,convert(money,round(a.Amortiza,2)),null,
a.Cuenta,
case when a.Tipo like 'O' then (select min(OCTtipo) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.Orden_Final = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid
and dx.Ecodigo = cx.Ecodigo and dx.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
else null end,
case when a.Tipo like 'O' then (select min(OCTtransporte) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.Orden_Final = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid and ax.Ecodigo = cx.Ecodigo and ax.Ecodigo = dx.Ecodigo and ax.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">) else null end,a.Orden_Final,convert(varchar,a.CodigoConceptoServicio)
FROM ##GADfletes2 a
</cfquery>

<!--- G A S T O S   A S O C I A D O S   A    C O M P R A S--->
<cfquery datasource="sifinterfaces">
select q.*, '' as Cuenta
into ##GADDis
from #minisifdb#..SNegocios u, #minisifdb#..Articulos t, #minisifdb#..OCcomplementoArticulo s, #minisifdb#..OCconceptoCompra oz,
(
<!--- Carga los productos de las compras y la distribución por producto --->
select l.*,count(distinct cmdty_code) as NProductos, round(l.cost_amt,2)/count(distinct cmdty_code) as Amortiza 
from 
(
select distinct m.*,count(distinct cost_owner_key6) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y,
##GADcompras z
where
y.trade_num = z.cost_owner_key6
) m
group by i_folio
)l
group by cost_owner_key6
) q
	where q.i_empresa= convert(int,u.SNcodigoext)
		and t.Acodigo=q.cmdty_code 
		and t.Aid=s.Aid 
		and oz.OCCcodigo=q.CodigoConceptoServicio 
		and u.Ecodigo = t.Ecodigo and u.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by i_folio

select e.*,OCTtransporte,OCTtipo 
into ##GADDis2
from #minisifdb#..OCtransporte d, #minisifdb#..OCtransporteProducto c, #minisifdb#..OCordenComercial a, ##GADDis e
where e.c_orden = a.OCcontrato and a.OCid = c.OCid and c.OCTid = d.OCTid
and d.Ecodigo = c.Ecodigo and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
order by i_folio
</cfquery>
<!--- Inserta datos PMIINT_IE10 --->
<cfquery datasource="sifinterfaces">
INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid, 
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct 
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,14, convert (varchar,i_empresa), 'CP' ,c_tipo_folio,
	isnull(c_docto_proveedor,'ERROR DOCUMENTO'), null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
	'1', 'ICTS',convert(varchar,i_voucher),null,case when a.Codigo_Retencion = 'XXX' then null else a.Codigo_Retencion end,
	null ,0 , case when Direccion like '' then null else convert(varchar,Direccion) end, case when Direccion like '' then null else convert(varchar,Direccion) end,
	 dt_fecha_recibo, 1
FROM  ##GastosA10 a  
where exists(select 1 from ##GADDis b where a.i_folio = b.i_folio and a.i_anio = b.i_anio)
and not exists(select 1 from #sifinterfacesdb#..PMIINT_IE10 c where a.ID = c.ID and c.sessionid = #session.monitoreo.sessionid#)
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ID DE DETALLE --->
update  ##GADDis
set ID = e.ID
from  ##GADDis d, ##GastosA10  e
where d.i_folio = e.i_folio and d.i_anio = e.i_anio
</cfquery>
<cfquery datasource="sifinterfaces">
<!--- ------------ CONSECUTIVO SwapFACT_ID10 ---------------->
declare @a int
select @a=0
update ##GADDis
set Consecutivo2 = @a+1, @a=@a+1
from ##GADDis d, ##GastosA10 e
where d.ID = e.ID

select @a=0
UPDATE ##GADDis set Consecutivo= @a+1+isnull((select  max(Consecutivo) from #sifinterfacesdb#..PMIINT_ID10 id where id.ID = d.ID and id.sessionid = #session.monitoreo.sessionid#),0), @a = 
case 
when exists (select 1 from ##GADDis c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##GADDis d
</cfquery>
<!--- INSERTAR CAMPOS EN PMIINT_ID10 --->
<cfquery datasource="sifinterfaces">
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid, 
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT distinct
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, 'O', a.cmdty_code  , null, 
null, null,0,'',0, 
0, null, '0',a.voucher_creation_date,null, 
a.c_orden,case when a.Codigo_Impuesto like 'XXX' then case when exists (select 1 from ##GADDis b where a.ID = b.ID and isnull(b.iva,0) > 0) then 'IVA15' else null end else a.Codigo_Impuesto end,0,0, null,
null,convert(money,round(a.Amortiza,2)),null,
a.Cuenta,(select min(OCTtipo) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.c_orden = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid and dx.Ecodigo = cx.Ecodigo and dx.Ecodigo = ax.Ecodigo and dx.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">),(select min(OCTtransporte) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx, #minisifdb#..OCordenComercial ax where a.c_orden = ax.OCcontrato and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid and dx.Ecodigo = cx.Ecodigo and dx.Ecodigo = ax.Ecodigo and dx.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">), a.c_orden,convert(varchar,a.CodigoConceptoServicio)
FROM ##GADDis a
where a.c_docto_proveedor is not null
</cfquery>

<!--- Tabla Para IVA --->
<cfquery  name="TUNION" datasource="sifinterfaces">
select a.ID,a.iva, a.Monto, a.i_folio, a.cost_owner_key6, a.Tipo, c_orden, cmdty_code, Orden_Final
into ##GastosIVA
from 
(
select ID,Consecutivo,iva, Amortiza as Monto, i_folio, i_anio, cost_owner_key6, 'Venta' as Tipo, c_orden, cmdty_code, Orden_Final from ##GADventasDis
union
select ID,Consecutivo,iva,cost_amt as Monto, i_folio, i_anio, cost_owner_key6,'Servicio' as Tipo, c_orden, '' as cmdty_code, '' as Orden_Final from ##GADsernoalloc 
union
select ID,Consecutivo,iva, Amortiza as Monto, i_folio, i_anio, cost_owner_key6,'Almacen' as Tipo, c_orden, cmdty_code, '' as Orden_Final from ##GADalmacenDis
union
select ID,Consecutivo,iva, Amortiza as Monto, i_folio, i_anio, cost_owner_key6,'Flete' as Tipo, c_orden, cmdty_code, Orden_Final from ##GADfletes2
union
select ID,Consecutivo,iva, Amortiza as Monto, i_folio, i_anio, cost_owner_key6,'Compra' as Tipo, c_orden, cmdty_code, '' as Orden_Final from ##GADDis
) a order by ID
</cfquery>

<!---Rutina para validacion de errores Modificada 30/08/07 por Ing. Luis Alejandro Bolaños Gómez --->
<!--- Validacion de Errores --->

<cfset LvarBanderaErrores = false>
<cfquery name="rsGASTOIE10" datasource="sifinterfaces">
	select * from #sifinterfacesdb#..PMIINT_IE10
	where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<cfif rsGASTOIE10.recordcount GT 0>
	<cfloop query="rsGASTOIE10">
		<!---Ajuste de centavos entre el encabezado y los detalles se elimina por optimizacion de proceso--->
		<!---Busca el folio del documento --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select f_importe_total,i_folio,i_anio 
			from  ##GastosA10
			where ID = #rsGASTOIE10.ID#
		</cfquery>
		<!--- Si se encuentra realiza el ajuste de centavos --->
		<cfif rsVerifica.recordcount EQ 1>
			<cfquery name="Reten" datasource="preicts">
				select sum(f_importe) as RETEN from PmiFoliosDetailS 
				where i_folio = #rsVerifica.i_folio# and i_anio = #rsVerifica.i_anio#
				and c_concepto like 'RETENCIO'
			</cfquery>
			<cfquery name="IVA" datasource="preicts">
				select sum(f_importe) as IMPU from PmiFoliosDetailS 
				where i_folio = #rsVerifica.i_folio# and i_anio = #rsVerifica.i_anio#
				and c_concepto in ('IVA','TAX') 
			</cfquery>
			<cfset ga_reten = #Reten.RETEN#>
			<cfset ga_iva = #IVA.IMPU#>
			<cfif ga_reten EQ ''>
				<cfset ga_reten = 0.0>
			</cfif>
			<cfif ga_iva EQ ''>
				<cfset ga_iva = 0.0>
			</cfif>
			<cfquery name="rsAjusteD" datasource="sifinterfaces">
				select sum(PrecioTotal) as Suma from PMIINT_ID10
				where ID = #rsGASTOIE10.ID#
				and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			</cfquery>
			<cfset ga_ImporteTotal = rsVerifica.f_importe_total>
			<cfset ga_SumaDetalle = rsAjusteD.Suma>
			<cfif ga_ImporteTotal EQ ''>
				<cfset ga_ImporteTotal = 0.0>
			</cfif>
			<cfif ga_SumaDetalle EQ ''>
				<cfset ga_SumaDetalle = 0.0>
			</cfif>
			<cfset ga_Ajuste = (ga_ImporteTotal + abs(ga_reten) - abs(ga_iva))- ga_SumaDetalle>
			<cfif ga_Ajuste EQ ''>
				<cfset ga_Ajuste = 0.0>
			</cfif>
			<cfif ga_Ajuste LE 1 and ga_Ajuste GT -1 and ga_Ajuste NEQ 0>
				<cfquery datasource="sifinterfaces">
					update PMIINT_ID10 set PrecioTotal = PrecioTotal + #ga_Ajuste#
					where ID = #rsGASTOIE10.ID#
					and Consecutivo = (select min(Consecutivo) from PMIINT_ID10 where ID  = #rsGASTOIE10.ID#
										and sessionid = 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">)
					and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
				</cfquery>
			</cfif>
		</cfif>
<!---
	<cfdump var="Documento:#rsGASTOIE10.Documento#">	
	<cfdump var="Total:#ga_ImporteTotal#">
	<cfdump var="Suma:#ga_SumaDetalle#">
	<cfdump var="Retencion:#ga_reten#">
	<cfdump var="IVA:#ga_iva#">
	<cfdump var="Ajuste:#ga_Ajuste#">
--->
		<cfset LvarTipoError = "">
		<cfset ga_ID = rsGASTOIE10.ID>
		<cfset ga_Modulo = rsGASTOIE10.Modulo>
		<!--- Verifica si hay Costos No relacionados a ningun trade --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from ##GastosIVA 
				where Orden_Final is null and Tipo in ('Venta', 'Flete')
				and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ga_ID#">
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfquery datasource="sif_interfaces">
				update PMIINT_IE10
				set MensajeError = null
				where ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#ga_ID#">
			</cfquery>
			<cfloop query="reVerifica">
				<cfif rsVerifica.recordcount EQ 0>
					<cfset LvarBanderaErrores = true>
					<cfset Busqueda =
						find("Orden #rsVerifica.c_orden# No esta relacionada a ninguna Orden de Compra",#LvarTipoError#)>
					<cfif Busqueda EQ 0>
						<cfif len(LvarTipoError)>
							<cfset LvarTipoError = LvarTipoError & ", ">
						</cfif>
						<cfset LvarTipoError = 
							LvarTipoError & "Orden #rsVerifica.c_orden# No esta relacionada a ninguna Orden de Compra">
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<!---Verifica que exista el socio de Negocios--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select SNcodigo from #minisifdb#..SNegocios 
				where SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.NumeroSocio#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio de Negocios NO existe en SOIN-SIF">
		</cfif>
		<cfset SNcodigo = rsVerifica.SNcodigo>
		
		
		<!---Verifica la clasificacion del socio --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#..SNegocios a 
							inner join 
										#minisifdb#..SNDirecciones b
							on a.SNid = b.SNid and a.Ecodigo = b.Ecodigo
			where
			a.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.NumeroSocio#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.SNnombre in ('FLETADOR','INSPECTOR','AGENTE ADUANAL','AGENTE NAVIERO','OTRO ACREEDOR')
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio de Negocios sin Clasificación">
		</cfif>
		<!---Verifica numero de documento correcto--->
		<cfif len(rsGASTOIE10.Documento) EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Numero de Documento Invalido">
		</cfif>
		<!---Verifica que tenga configurada cuenta en su direccion --->
		<cfif rsGASTOIE10.CodigoDireccionFact NEQ '' AND len(trim(rsGASTOIE10.CodigoDireccionFact)) GT 0>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select b.SNDCFcuentaProveedor,b.SNDCFcuentaCliente,b.SNnombre
				from #minisifdb#..SNegocios a 
								inner join 
											#minisifdb#..SNDirecciones b
								on a.SNid = b.SNid and a.Ecodigo = b.Ecodigo
				where
				a.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.NumeroSocio#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoDireccionFact#"> 
			</cfquery>
			<cfif (trim(rsGASTOIE10.Modulo) EQ "CP" AND len(rsVerifica.SNDCFcuentaProveedor) EQ 0) 
					OR (trim(rsGASTOIE10.Modulo) EQ "CC" AND len(rsVerifica.SNDCFcuentaCliente) EQ 0)>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Direccion #rsVerifica.SNnombre# sin cuenta #rsGASTOIE10.Modulo# parametrizada ">
			</cfif>
		</cfif>
		<!---Verifica el codigo de Moneda*/--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#.. Monedas 
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoMoneda#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Codigo de Moneda Incorrecto #rsGASTOIE10.CodigoMoneda#">
		</cfif>
		<!---Verifica que el Documento no haya sido aplicado antes--->
		<cfif Len(SNcodigo)>
			<cfif trim(rsGASTOIE10.Modulo) EQ "CP">
				<cfquery name="rsVerifica" datasource="sifinterfaces">
				select count(*) as Documentos from 
				(select EDdocumento from  #minisifdb#..EDocumentosCxP c
				 where 
				 ltrim(rtrim(c.EDdocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 union all
				 select Ddocumento from  #minisifdb#..EDocumentosCP c
				 where 
				 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 union all
				 select Ddocumento from  #minisifdb#..HEDocumentosCP c
				 where 
				 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 ) f
				</cfquery>
			<cfelseif trim(rsGASTOIE10.Modulo) EQ "CC">
				<cfquery name="rsVerifica" datasource="sifinterfaces">
				select count(*) as Documentos from 
				(select EDdocumento from  #minisifdb#..EDocumentosCxC c
				 where 
				 ltrim(rtrim(c.EDdocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 union all
				 select Ddocumento from  #minisifdb#..Documentos c
				 where 
				 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 union all
				 select Ddocumento from  #minisifdb#..HDocumentos c
				 where 
				 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
				 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
				 and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">
				 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 ) f
				</cfquery>
			</cfif>
			<cfif rsVerifica.Documentos GT 0>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Documento ya aplicado en SOIN-SIF V6">
			</cfif>
		</cfif>
		<!---Verifica que el documento no se encuentre en la cola de procesos--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select IdProceso from InterfazColaProcesos ib inner join IE10 ie on ib.IdProceso = ie.ID
			where ie.Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.Documento#">
			and ie.CodigoTransacion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoTransacion#">
			and ie.NumeroSocio like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.NumeroSocio#">
			and ie.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfquery>
		<cfif rsVerifica.recordcount GT 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & 
			"Documento en la Consola de Administración de Procesos ID:#rsVerifica.IdProceso#">
		</cfif>
		<!---Verifica que el codigo de Rentención sea correcto--->
		<cfif rsGASTOIE10.CodigoRetencion EQ 'WR' >
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Código de Retención No Asignado en ICTS">
		<cfelseif rsGASTOIE10.CodigoRetencion EQ 'WX' >
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			
			<!---
			<cfquery datasource="sifinterfaces" name="retenciones">
				select fd.i_iva_retencion
				from #preictsdb#..PmiFoliosDetailS fd
				where fd.i_folio = #a.i_folio#
				  and fd.i_anio  = #a.i_anio#
				  and fd.c_concepto like 'RETENCIO'
			</cfquery>
			--->
			
			<cfset LvarTipoError = LvarTipoError & "No hay un código de retención compuesta equivalente en SOIN">

		<cfelse>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select 1 from #minisifdb#..Retenciones 
				where Rcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOIE10.CodigoRetencion#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
			</cfquery>
			<cfif rsVerifica.recordcount EQ 0 and rsGASTOIE10.CodigoRetencion NEQ ''>
				<cfset LvarBanderaErrores = true>
				<cfif len(LvarTipoError)>
					<cfset LvarTipoError = LvarTipoError & ", ">
				</cfif>
				<cfset LvarTipoError = LvarTipoError & "Codigo de Retención #rsGASTOIE10.CodigoRetencion# No existe en SOIN">
			</cfif>
		</cfif>
		
		<!---Verifica que exista Orden Comercial--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from PMIINT_ID10
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			and ID = #ga_ID#
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Ninguna Orden Comerical de Producto relacionada al Documento ">
		</cfif>
		<cfset LvarBanderaErrores_registro = False>
		<cfquery name="rsGASTOID10" datasource="sifinterfaces">
			select * from #sifinterfacesdb#..PMIINT_ID10
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			and ID = #ga_ID#
		</cfquery>
		<cfif rsGASTOID10.recordcount GT 0>
			<cfloop query="rsGASTOID10">
				<cfif trim(rsGASTOID10.TipoItem) EQ "O" OR trim(rsGASTOID10.TipoItem) EQ "A">
					<!---Verifica que el Articulo Exista--->
					<cfif rsGASTOID10.CodigoItem NEQ '' AND len(trim(rsGASTOID10.CodigoItem)) GT 0>
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from  #minisifdb#..Articulos c 
							where ltrim(rtrim(c.Acodigo)) like 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOID10.CodigoItem#">
							 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<cfif rsVerifica.recordcount EQ 0>
							<cfset LvarBanderaErrores = true>
							<cfset Busqueda =
									find("Articulo no existe en SOIN-SIF #rsGASTOID10.CodigoItem#",#LvarTipoError#)>
							<cfif Busqueda EQ 0>
								<cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
								</cfif>
								<cfset LvarTipoError = 
										LvarTipoError & "Articulo no existe en SOIN-SIF #rsGASTOID10.CodigoItem#">
							</cfif>
						</cfif>
					</cfif>
					<!---Verifica que la orden comercial Exista en la estrcutura de OC--->
					<cfif rsGASTOID10.OCcontrato NEQ '' AND len(trim(rsGASTOID10.OCcontrato)) GT 0>
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from  #minisifdb#..OCordenComercial c 
							where ltrim(rtrim(c.OCcontrato)) = 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOID10.OCcontrato#">
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<cfif rsVerifica.recordcount EQ 0>
							<cfset LvarBanderaErrores = true>
							<cfset Busqueda = 
							find("Orden Comercial no encontrada en SOIN-SIF V6: #rsGASTOID10.OCcontrato#",#LvarTipoError#)>
							<cfif Busqueda EQ 0>
								<cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
								</cfif>
								<cfset LvarTipoError =
								LvarTipoError & "Orden Comercial no encontrada en SOIN-SIF V6: #rsGASTOID10.OCcontrato#">
							</cfif>
						</cfif>
					</cfif>
					<!---Verifica que el Concepto de Servicio Exista--->
					<cfif trim(ga_Modulo) EQ "CP">
						<cfset ga_Concepto = rsGASTOID10.OCconceptoCompra>
						<cfset ga_ConceptoIC = "Compra">
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from #minisifdb#..OCconceptoCompra c 
							where OCCcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#ga_Concepto#"> 
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>	
					<cfelseif trim(ga_Modulo) EQ "CC">
						<cfset ga_Concepto = rsGASTOID10.OCconceptoIngreso>
						<cfset ga_ConceptoIC = "Ingreso">
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from #minisifdb#..OCconceptoIngreso c 
							where OCIcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#ga_Concepto#"> 
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>	
					</cfif>
					<cfif ga_Concepto NEQ '' AND len(trim(ga_Concepto)) GT 0>
						<cfif rsVerifica.recordcount EQ 0>
							<cfset LvarBanderaErrores = true>
							<cfset Busqueda = find("Concepto #ga_Concepto# de #ga_ConceptoIC# NO Valido",#LvarTipoError#)>
							<cfif Busqueda EQ 0>
							   <cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
							   </cfif>
							   <cfset LvarTipoError = LvarTipoError & "Concepto #ga_Concepto# de #ga_ConceptoIC# NO Valido">
							</cfif>						
						</cfif>
					</cfif>
				</cfif>
				<cfif trim(rsGASTOID10.TipoItem) EQ "S">
					<!---Verifica que el Concepto de Servicio Exista--->
					<cfquery name="rsVerifica" datasource="sifinterfaces">
						select 1 from #minisifdb#..Conceptos c 
						where Ccodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOID10.CodigoItem#"> 
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>	
					<cfif rsVerifica.recordcount EQ 0>
						<cfset LvarBanderaErrores = true>
						<cfset Busqueda = 
						find("Concepto #ga_Concepto# de Servicio NO existe en SOIN-SIF V6",#LvarTipoError#)>
						<cfif Busqueda EQ 0>
							<cfif len(LvarTipoError)>
								<cfset LvarTipoError = LvarTipoError & ", ">
							</cfif>
							<cfset LvarTipoError = 
							LvarTipoError & "Concepto #ga_Concepto# de Servicio NO existe en SOIN-SIF V6">
						</cfif>
					</cfif>
				</cfif>
				<!---Verifica que el codigo de Impuesto sea correcto--->
				<cfif rsGASTOID10.CodigoImpuesto EQ 'ERROR' >
					<cfset LvarBanderaErrores = true>
					<cfset Busqueda = find("Codigo de Impuesto No Asignado en ICTS",#LvarTipoError#)>
					<cfif Busqueda EQ 0>
						<cfif len(LvarTipoError)>
							<cfset LvarTipoError = LvarTipoError & ", ">
						</cfif>
						<cfset LvarTipoError = LvarTipoError & "Codigo de Impuesto No Asignado en ICTS">
					</cfif>
				</cfif>
			
				<cfquery name="rsVerifica" datasource="sifinterfaces">
					select 1 from #minisifdb#..Impuestos 
					where Icodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGASTOID10.CodigoImpuesto#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">				
				</cfquery>
				<cfif rsVerifica.recordcount EQ 0 and rsGASTOID10.CodigoImpuesto NEQ '' and 
				rsGASTOID10.CodigoImpuesto NEQ 'ERROR'>
					<cfset LvarBanderaErrores = true>
					<cfset Busqueda = 
							find("Codigo de Impuesto #rsGASTOID10.CodigoImpuesto# No existe en SOIN",#LvarTipoError#)>
					<cfif Busqueda EQ 0>
						<cfif len(LvarTipoError)>
							<cfset LvarTipoError = LvarTipoError & ", ">
						</cfif>
						<cfset LvarTipoError = LvarTipoError & 
						"Codigo de Impuesto #rsGASTOID10.CodigoImpuesto# No existe en SOIN">	
					</cfif>
				</cfif>
			</cfloop>
		</cfif> 
	<!---Actualiza Mensaje de Error--->
	<cfquery datasource="sifinterfaces">
		UPDATE PMIINT_IE10
			SET MensajeError = case 
								when '#LvarTipoError#' = '' then MensajeError
								else
									case 
									 when MensajeError is null then '#LvarTipoError#'
									 else MensajeError + ', #LvarTipoError#'
									end 
							   end
		from PMIINT_IE10
		where ID = #ga_ID#
		and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	</cfloop>
</cfif>

<!--- Verifica que la suma de los detalles sea igual al monto encabezado --->

<cfquery datasource="sifinterfaces">
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' La suma de los detalles de la Factura '
+ convert (varchar, 
	(select round((f_importe_total + c.f_iva + isnull((select sum(abs(f_importe)) from #preictsdb#..PmiFoliosDetailS d where d.i_folio = c.i_folio and d.i_anio = c.i_anio and d.c_concepto like 'RETENCIO'),0)),2) from  ##GastosA10 c where a.ID = c.ID) , 1) +
' no es Igual al Importe Total '
+ convert (varchar, 
	(select round((sum(c.Monto) + sum(c.iva)),2) from ##GastosIVA c where a.ID = c.ID group by c.ID) , 1)

from #sifinterfacesdb#..PMIINT_IE10 a
where
abs((select round((sum(c.Monto) + sum(c.iva)),2) from ##GastosIVA c where a.ID = c.ID group by c.ID) -
(select round((f_importe_total + c.f_iva + isnull((select sum(abs(f_importe)) from #preictsdb#..PmiFoliosDetailS d where d.i_folio = c.i_folio and d.i_anio = c.i_anio and d.c_concepto like 'RETENCIO'),0)),2) from  ##GastosA10 c where a.ID = c.ID)) > .5
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<cfset droptable()>
