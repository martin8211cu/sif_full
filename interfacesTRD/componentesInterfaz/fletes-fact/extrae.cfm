
<!--- Extracción de Fletes (Fact)
Se relaizo Modificación a este query el dia 18 de mayo del 2007
Motivo: Poder manejar correctamente Documentos con mas de un detalle en PmiFoliosDetailS--->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<cffunction name="droptable">
<cfquery datasource="sifinterfaces">
if object_id('##TitleTD') is not null
	drop table ##TitleTD
if object_id('##Concep') is not null
	drop table ##Concep
if object_id('##OvsD_comprafletes') is not null
	drop table ##OvsD_comprafletes
if object_id('##OvsD_ventafletes') is not null
	drop table ##OvsD_ventafletes
if object_id('##ComprasVentasfletes') is not null
	drop table ##ComprasVentasfletes
if object_id('##ComprasAlmacenfletes') is not null
	drop table ##ComprasAlmacenfletes
if object_id('##ComprasVAfletes') is not null
	drop table ##ComprasVAfletes
if object_id('##Ventasfletes') is not null
	drop table ##Ventasfletes
if object_id('##pazzoVA') is not null
	drop table ##pazzoVA
if object_id('##SumaCostos') is not null
	drop table ##SumaCostos
if object_id('##FLETES_IE102') is not null
	drop table ##FLETES_IE102
if object_id('##FLETES_IE103') is not null
	drop table ##FLETES_IE103
if object_id('##FLETES_IE104') is not null
	drop table ##FLETES_IE104
if object_id('##FLETES_IE10') is not null
	drop table ##FLETES_IE10
</cfquery>
</cffunction>

<cfset droptable()>

<cfquery datasource="sifinterfaces">
/* --------------------------- CREACION DE TABLA TEMPORAL PARA EL LLENADO DEL ENCABEZADO IE10 ----------*/
SELECT distinct a.i_folio,a.i_anio, a.i_voucher, c.voucher_creation_date, c.voucher_auth_date, 
	null as cost_owner_key6, a.i_empresa, 	    
	a.dt_fecha_recibo,a.dt_fecha_vencimiento, a.c_status, a.c_tipo_folio,
	a.c_orden, a.c_docto_proveedor,a.c_moneda, a.c_transporte,a.f_importe_total,
	0 as ImpTotDet, 'XXXXXXXXXX' as cost_code, 'XXXXXXXXXX' as cost_type_code
INTO ##FLETES_IE10
FROM #preictsdb#..PmiFolios a, #preictsdb#..voucher c
WHERE
	a.i_voucher=c.voucher_num 
	and a.c_tipo_folio in ('CI')
	and (convert(varchar(8),c.voucher_creation_date ,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">)
	<!--- Empresa de Trading, solo aqui se usa --->
	<!--- CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
	and a.i_empresa_prop=<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#"> --->
	and a.i_empresa_prop=<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	and (a.i_voucher is not null or a.i_voucher > 0)
	and a.c_status not like  'RE'
	and not exists(select 1 from InterfazBitacoraProcesos ib, IE10 ie where a.c_docto_proveedor = ie.Documento
					and a.c_tipo_folio = ie.CodigoTransacion and a.i_empresa = convert(int,ie.NumeroSocio) and ib.IdProceso 
					= ie.ID and MsgError like 'OK') 
ORDER BY 
 	a.i_folio
</cfquery>

<cfquery datasource="sifinterfaces">
alter table ##FLETES_IE10 modify ImpTotDet float not null
</cfquery>

<cfquery datasource="sifinterfaces">
/*Actualiza el monto del ducumento con la suma de los costos relacionados*/
select a.i_folio,c.cost_amt
into ##SumaCostos
from ##FLETES_IE10 a, #preictsdb#..voucher_cost b, #preictsdb#..cost c
	where a.i_voucher = b.voucher_num
	and b.cost_num = c.cost_num
	and c.cost_code in ('CHARHIRE','FREIGHTO','FREIGHTB','FLETMUER','FRHTDIFF','ADITFRHT','PORTEXP','ADDPORT','ADITIVE','ADVPAPEX','BAPRTEXP',
	'BUNKERS', 'CUSTBROK', 'CUSTDUTI', 'DEADFR','DEMURRAG',  'FRHTPERF', 'FRHTREIM', 'INSPECT', 'PREMREIN', 'OFEXP', 'PROTAGNT', 'PASC')	
	and c.cost_status in ('PAID','VOUCHED')
	and c.cost_code not in ('IVA','RETENCIO','TAX')

update ##FLETES_IE10
set ImpTotDet = (select sum(cost_amt) from  ##SumaCostos c where a.i_folio=c.i_folio group by i_folio)
	from ##FLETES_IE10 a

/*Actualiza el cost_code y el cost_type_code*/
update ##FLETES_IE10
set cost_code = (select min(cost_code) from  #preictsdb#..cost c where 	b.cost_num=c.cost_num 
	and c.cost_code in ('CHARHIRE','FREIGHTO','FREIGHTB','FLETMUER','FRHTDIFF','ADITFRHT','PORTEXP','ADDPORT','ADITIVE','ADVPAPEX','BAPRTEXP',
	'BUNKERS', 'CUSTBROK', 'CUSTDUTI', 'DEADFR','DEMURRAG',  'FRHTPERF', 'FRHTREIM', 'INSPECT', 'PREMREIN', 'OFEXP', 'PROTAGNT', 'PASC')
	and c.cost_status in ('PAID','VOUCHED')
	and c.cost_code not in ('IVA','RETENCIO','TAX') group by cost_num)
	from ##FLETES_IE10 a, #preictsdb#..voucher_cost b
	where a.i_voucher = b.voucher_num
	
update ##FLETES_IE10
set cost_type_code = (select min(cost_type_code) from  #preictsdb#..cost c where b.cost_num=c.cost_num and
	c.cost_code = a.cost_code)
	from ##FLETES_IE10 a, #preictsdb#..voucher_cost b
	where a.i_voucher = b.voucher_num
	
/*Asigna el trade_num de la orden que indica el documento*/
update ##FLETES_IE10 set  a.cost_owner_key6 = b.trade_num from ##FLETES_IE10 a, #preictsdb#..trade b
where a.cost_owner_key6 is null and b.acct_ref_num = c_orden and b.trade_status_code not like 'DELETE'


update ##FLETES_IE10
set cost_code = '' where cost_code like 'XXXXXXXXXX'
update ##FLETES_IE10
set cost_type_code = '' where cost_type_code like 'XXXXXXXXXX'

</cfquery>

<cfquery datasource="sifinterfaces">
ALTER TABLE ##FLETES_IE10 add ConceptoServicio int null 
</cfquery>

<cfquery datasource="sifinterfaces">
/*--------------------------------------------- ACTUALIZAR CONCEPTO SERVICIO ------------------------------------*/
select sb.subconcepto_id, ff.i_folio, ff.cost_code,ff.cost_type_code
	INTO ##Concep	
	FROM #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r, #tesoreriadb#..subconceptos_detalle s, ##FLETES_IE10 ff
	WHERE s.costo_id = ff.cost_code
		  AND s.tipo_costo = ff.cost_type_code
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
		 --AND sb.subconcepto_id = cp.converCcodigo

UPDATE ##FLETES_IE10 set ConceptoServicio = b.subconcepto_id from ##FLETES_IE10 a,  ##Concep b WHERE a.i_folio=b.i_folio
UPDATE ##FLETES_IE10 SET ConceptoServicio =10 from ##FLETES_IE10  where ConceptoServicio IS NULL



/*  ----------------------------------------------------ACTUALIZA DIRECCIONES ----------------------------------------*/

ALTER TABLE ##FLETES_IE10 add CodigoDireccionFact char(10) null
</cfquery>
<cfquery datasource="sifinterfaces">


UPDATE ##FLETES_IE10 SET CodigoDireccionFact =c.SNcodigoext 
	FROM ##FLETES_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
	WHERE a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid 


UPDATE ##FLETES_IE10 SET CodigoDireccionFact =c.SNcodigoext 
	FROM ##FLETES_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
	WHERE a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre like 'FLETADOR'

ALTER TABLE ##FLETES_IE10 add ID int null
</cfquery>

<cfquery datasource="sifinterfaces">
create clustered index i_folio_INDEX 
on ##FLETES_IE10(i_folio)

/* ------------------------------------------------------------- Creacin de ID ------------------------------------------------------ */
<!--- Modificacion realizada el 18/05/2007 por Alejandro Bolaños
los documentos de Fletes pueden contener mas de un detalle en la tabla PMI folios, por lo que al extraer los
datos se generaba una multiplicacion de registros por un producto cruzado, este caso no se habia dado, por lo que
no se habia tomado en cuenta al generar el proceso de extraccion, esta modificacion debe resolver dicho error

/*Se genera La tabla de Encabezados (Documentos) */
select distinct 0 as ID,
i_folio,i_empresa,c_tipo_folio,c_docto_proveedor,c_moneda,dt_fecha_recibo,dt_fecha_vencimiento,i_voucher,CodigoDireccionFact,
f_importe_total
into ##FLETES_IE101
from ##FLETES_IE10

create clustered index i_folio_INDEX 
on ##FLETES_IE101(i_folio)


/* Genera el ID del Encabezado y Detalle */
declare @i int
select @i= 0<!---(select Consecutivo
					from sif_interfaces..IdProceso)--->

UPDATE ##FLETES_IE101 set ID=@i + 1,@i=@i+1 

update ##FLETES_IE10
set ID = e.ID
from ##FLETES_IE10  d, ##FLETES_IE101 e
where d.i_folio = e.i_folio

<!--- Fin de la Modificacion Ahora la tabla con la que se llena la IE10 es ##FLETES_IE101 ---> --->
</cfquery>


<cfquery datasource="sifinterfaces">
/**********************************************************************************************************************************************************************/
/* ---------------------------------- CREACION DE TABLA TEMPORAL PARA EL LLENADO DEL DETALLE ID10 ----------------------------------*/
/* PROCESO PARA BUSCAR LAS ORDENES DE VENTA o ALMACEN ASOCIADAS AL FLETE */
select distinct
v.i_folio,v.Socio_Factura,v.Costo_Factura,v.trade_num as Orden_Origen_num, v.acct_ref_num as Orden_Origen, v.alloc_item_type as Movimiento_Origen,
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
into ##OvsD_comprafletes
from 
(
select  distinct c.i_folio,c.i_empresa as Socio_Factura,c.ImpTotDet as Costo_Factura,a.trade_num,a.acct_ref_num, a.alloc_num,a.alloc_item_type,a.title_tran_date as FTipoCambio,
aa.trade_num as trade2,aa.acct_ref_num as acct_ref_num_2, aa.alloc_num as alloc2,aa.alloc_item_type as alloctype2, aa.title_tran_date as FTipoCambio2,
ab.trade_num as trade3,ab.acct_ref_num as acct_ref_num_3, ab.alloc_num as alloc3,ab.alloc_item_type as alloctype3, ab.title_tran_date as FTipoCambio3,
ac.trade_num as trade4,ac.acct_ref_num as acct_ref_num_4, ac.alloc_num as alloc4,ac.alloc_item_type as alloctype4, ac.title_tran_date as FTipoCambio4
from #preictsdb#..allocation_item a,#preictsdb#..allocation_item aa, #preictsdb#..allocation_item ab,#preictsdb#..allocation_item ac,##FLETES_IE10  c
where 
a.trade_num = c.cost_owner_key6
and a.alloc_num=aa.alloc_num
and aa.alloc_item_type in ('R','N','I','T')
and a.trade_num != aa.trade_num
and aa.trade_num = ab.trade_num
and ab.trade_num != a.trade_num
and ab.alloc_item_type in ('R','I','T')
and ab.alloc_num = ac.alloc_num
and ac.trade_num != a.trade_num
and ac.alloc_item_type in ('R','I') 
) v

/* ---------------------------------------- ARMADO DE CUENTAS CONTABLES ----------------------------------------- */
/* ----- Este Proceso genera la cuenta apartir del proceso anterior --------------------------------------- */
/* PROCESO PARA LOS SOLO ALOCADOS A ALMACEN */
/* --------------------------------------------------------------------------------------------------------------------- */
select q.*
into ##ComprasAlmacenfletes
from 
(
/* Carga los productos de las ventas y la Amortizacion por producto */
select l.*,count(distinct cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct cmdty_code) as Amortiza, 'A' as Tipo
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y, #preictsdb#..trade_item tit,
(
/* Este sub-query obtiene todos las compras asociadas solo a Almacen */
select * from ##OvsD_comprafletes a
where Movimiento_Destino in ('C','I')
and not exists (select 1 from ##OvsD_comprafletes b where a.Orden_Origen = b.Orden_Origen
			and b.Movimiento_Destino = 'R')
) z
where
y.trade_num = z.Orden_Final_num
and tit.trade_num = y.trade_num
and tit.order_num = y.order_num
and tit.p_s_ind = 'P'
and exists (select 1 from #preictsdb#..allocation_item ax where ax.cmdty_code = y.cmdty_code and ax.trade_num = z.Orden_Origen_num)
--order by z.Orden_Final
) m
group by Orden_Origen 
)l
group by Orden_Final,Orden_Origen
) q
	
 /* --------------------------------------------------------------------------------------------------------------------- */


/* PROCESO PARA LOS ALOCADOS A COMPRAS */
/* --------------------------------------------------------------------------------------------------------------------- */
/* Arma la cuenta tanto para las ordenes existentes en OCordenComercial como las que no */
select q.*
into ##ComprasVentasfletes
from 
(
/* Carga los productos de las ventas y la Amortizacion por producto */
select l.*,count(distinct cmdty_code) as NProductos, l.Costo_Factura/l.NVentas/count(distinct cmdty_code) as Amortiza, 'O' as Tipo
from 
(
select distinct m.*,count(distinct Orden_Final) as NVentas
from
(
select distinct z.*,y.cmdty_code
from #preictsdb#..allocation_item y,
(
/* Este sub-query obtiene todos las compras asociadas solo a ventas */
select * from ##OvsD_comprafletes a
where Movimiento_Destino = 'R'
) z
where
y.trade_num = z.Orden_Final_num
--order by z.Orden_Final
) m
group by Orden_Origen 
)l
group by Orden_Final,Orden_Origen
) q

/* CREA LA TABLA CON LAS DISTRIBUCIONES Y LAS CUENTAS CREADAS */

select a.* 
into ##FLETES_IE103
from 
(
select a.*, b.cmdty_code as Producto, b.NProductos, Orden_Final,Orden_Origen,Amortiza,Movimiento_Destino,Tipo, Costo_Factura
--into ComprasAmortiza
from ##FLETES_IE10 a inner join ##ComprasAlmacenfletes b on
b.i_folio = a.i_folio
where Amortiza is not null
--order by i_folio

union

select a.*, b.cmdty_code as Producto,b.NProductos,Orden_Final,Orden_Origen,Amortiza,Movimiento_Destino,Tipo, Costo_Factura
--into ComprasAmortiza
from ##FLETES_IE10  a inner join ##ComprasVentasfletes b on
b.i_folio = a. i_folio
where Amortiza is not null
--order by i_folio
) a


/* GENERA LA TABLA TEMPORAL DE DETALLES */
select 
a.ID,a.i_folio,0 as Consecutivo,0 as Consecutivo2,a.Producto,a.c_transporte,a.Amortiza as PUnitario,
a.voucher_creation_date,a.Amortiza,a.Orden_Origen,a.Orden_Final,
a.ConceptoServicio, a.Movimiento_Destino,a.Tipo, a.Costo_Factura
into ##FLETES_IE104
from ##FLETES_IE103 a
order by i_folio

update ##FLETES_IE10 set a.c_tipo_folio = 'FW' 
from ##FLETES_IE10 a, ##FLETES_IE104 b 
where a.i_folio = b.i_folio and b.Movimiento_Destino in ('C','I')
</cfquery>

<cfquery datasource="sifinterfaces">
/* Genera el ID del Encabezado y Detalle */
declare @i int
select @i= 0

UPDATE ##FLETES_IE10 set ID=@i + 1,@i=@i+1 

<!--- La fecha Tipo Cambio es la del documento, en caso de que se desee cambiar esto aplicar este fragmento al query
isnull((select min(FTipoCambio) from ##FLETES_IE104 b where a.ID = b.ID),dt_fecha_recibo !--->

/* ------------------------------------------------------- Insercin de datos IE10 ------------------------------------------------*/

INSERT #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid,
	ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
	Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
	Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
	CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
	FechaTipoCambio, StatusProceso)

SELECT distinct
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
ID,
<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
convert (varchar,i_empresa), 'CP' ,c_tipo_folio,
	c_docto_proveedor, null,c_moneda, dt_fecha_recibo, dt_fecha_vencimiento,
	'1', 'ICTS',convert(varchar,i_voucher),null,null ,
	null ,0 , null, convert(varchar,CodigoDireccionFact), 
	 dt_fecha_recibo, 1
FROM ##FLETES_IE10 a

</cfquery>
<cfquery datasource="sifinterfaces">
/* ----------- ID DE DETALLE SwapFACT2_ID10 ------------ */

update ##FLETES_IE104
set ID = e.ID
from ##FLETES_IE104  d, ##FLETES_IE10 e
where d.i_folio = e.i_folio

/* ------------ CONSECUTIVO SwapFACT_ID10 -------------*/
declare @a int
select @a=0
update ##FLETES_IE104 
set Consecutivo2 = @a+1,@a=@a+1
from ##FLETES_IE104  d, ##FLETES_IE10 e
where d.ID = e.ID

select @a=0
UPDATE ##FLETES_IE104 set Consecutivo= @a+1, @a = 
case 
when exists (select 1 from ##FLETES_IE104 c where c.ID = d.ID and c.Consecutivo2 = d.Consecutivo2 + 1)  
then  @a+1 
else 0 
end
from ##FLETES_IE104 d
</cfquery>

<cfquery datasource="sifinterfaces">
/*Ajuste de Centavos de Diferencia */
update ##FLETES_IE104 set Amortiza = 
case 
when 
isnull(abs((select round(sum(Amortiza),2) from ##FLETES_IE104 b where b.ID = a.ID group by ID) - 
(select round(f_importe_total,2) from  ##FLETES_IE10 c where a.ID = c.ID)),0) < 1
then 
	Amortiza + round(isnull(abs((select round(f_importe_total,2) from  ##FLETES_IE10 c where a.ID = c.ID)),0) - 
						(select round(sum(Amortiza),2) from ##FLETES_IE104 b where b.ID = a.ID group by ID),2)
else
Amortiza
end
from ##FLETES_IE104 a
where a.Consecutivo = (select min(d.Consecutivo) from ##FLETES_IE104 d where d.ID = a.ID group by ID) 
</cfquery>

<cfquery datasource="sifinterfaces">
/* INSERTAR CAMPOS EN ID10 */
insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
CodigoDepartamento, PrecioTotal, CentroFuncional, 
CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)

SELECT distinct
<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
a.ID, a.Consecutivo, a.Tipo, a.Producto  , null, 
null, null,0,'',0, 
0, null, '0',a.voucher_creation_date,null, 
a.Orden_Final, null, null,null, case when a.Movimiento_Destino in ('D','R') then null else a.Orden_Final end,
null,convert(money,round(a.Amortiza,2)),null,
null,
case when a.Tipo like 'O' then (select min(OCTtipo) from #minisifdb#..OCtransporte dx, #minisifdb#..OCtransporteProducto cx,
								#minisifdb#..OCordenComercial ax where a.Orden_Final = ax.OCcontrato 
								and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid and dx.OCTtransporte = a.Orden_Origen)
else null end,
case when a.Tipo like 'O' then a.Orden_Origen else null end,
a.Orden_Final,convert(char,a.ConceptoServicio)
FROM ##FLETES_IE104 a
</cfquery>

<cfquery datasource="sifinterfaces">
/* Validacion de Errores */

/*Verifica que exista el socio de Negocios*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + 'Socio de Negocios NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where not exists (select 1 from  #minisifdb#..SNegocios b where b.SNcodigoext = a.NumeroSocio)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica la clasificacion del socio como Fletador*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Socio de Negocios sin direccion FLETADOR ' 
from #sifinterfacesdb#..PMIINT_IE10 a, #minisifdb#..SNegocios b
where b.SNcodigoext = a.NumeroSocio
and not exists (select 1 from #minisifdb#..SNDirecciones c where b.SNid = c.SNid and c.SNnombre like 'FLETADOR')
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que exista Orden Comercial*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' No se encontro Orden Comercial relacionada a este documento o a sus costos ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
(
not exists (select 1 from #sifinterfacesdb#..PMIINT_ID10 b where a.ID = b.ID and a.sessionid = b.sessionid)
or 
exists (select 1 from #sifinterfacesdb#..PMIINT_ID10 b where a.ID = b.ID and b.ContractNo is null and a.sessionid = b.sessionid)
)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica numero de documento correcto*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Numero de Documento Invalido ' 
where Documento is null or len(Documento) < 1
and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que tenga configurada cuenta en su direccion FLETADOR*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Direccion FLETADOR sin cuenta Proveedor ' 
from #sifinterfacesdb#..PMIINT_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c
where b.SNcodigoext = a.NumeroSocio
and b.SNid = c.SNid 
and c.SNnombre like 'FLETADOR'
and c.SNDCFcuentaProveedor is null
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que la suma de los detalles sea igual al monto encabezado*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' No se logro extraer todos los costos relacionados al documento, verifique que las ordenes relacionadas a estos sean PHYSICAL ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where
abs((select round(sum(Amortiza),2) from ##FLETES_IE104 b where b.ID = a.ID group by ID) - 
(select round(f_importe_total,2) from  ##FLETES_IE10 c where a.ID = c.ID)) > .005
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica el codigo de Moneda*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Codigo de Moneda Incorrecto ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where not exists (select 1 from  #minisifdb#..Monedas b where b.Miso4217 = a.CodigoMoneda)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el Almacen Exista*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Almacen NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a,#sifinterfacesdb#..PMIINT_ID10 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..Almacen c where c.Almcodigo = b.CodigoAlmacen)
and b.CodigoAlmacen is not null
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
and a.sessionid = b.sessionid

/*Verifica que el Articulo Exista*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Articulo NO existe ' 
from #sifinterfacesdb#..PMIINT_IE10 a,##FLETES_IE104 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..Articulos c where ltrim(rtrim(c.Acodigo)) = ltrim(rtrim(b.Producto)) and c.Ecodigo = 8)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el Documento no haya sido aplicado antes*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Documento Ya aplicado en SOIN ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
(
exists (select 1 from  #minisifdb#..EDocumentosCxP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.EDdocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
or
exists (select 1 from  #minisifdb#..EDocumentosCP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.Ddocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
or
exists (select 1 from  #minisifdb#..HEDocumentosCP c, #minisifdb#..SNegocios d where ltrim(rtrim(c.Ddocumento)) like ltrim(rtrim(a.Documento)) and c.CPTcodigo like a.CodigoTransacion and d.SNcodigoext like a.NumeroSocio and c.SNcodigo = d.SNcodigo and c.Ecodigo = 8)
)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que la orden comercial Exista en la estrcutura de OC*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Orden Comercial no encontrada en estructura de SOIN V6 ' 
from #sifinterfacesdb#..PMIINT_IE10 a,##FLETES_IE104 b
where 
a.ID = b.ID
and not exists (select 1 from  #minisifdb#..OCordenComercial c where ltrim(rtrim(c.OCcontrato)) = ltrim(rtrim(b.Orden_Final)) and c.Ecodigo = 8)
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el documento no se encuentre en la cola de procesos*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Documento en Cola Procesos Interfaz 10 ' 
from #sifinterfacesdb#..PMIINT_IE10 a
where 
exists(select 1 from InterfazColaProcesos ib, IE10 ie where a.Documento = ie.Documento
		and a.CodigoTransacion = ie.CodigoTransacion and a.NumeroSocio = ie.NumeroSocio and ib.IdProceso = ie.ID) 
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">

/*Verifica que el Concepto de Servicio Exista*/
update #sifinterfacesdb#..PMIINT_IE10
set MensajeError = MensajeError + ' Concepto de Servicio No existe en SOIN ' 
from #sifinterfacesdb#..PMIINT_IE10 a, #sifinterfacesdb#..PMIINT_ID10 b
where 
a.ID = b.ID
and not exists(select 1 from #minisifdb#..Conceptos c where b.OCconceptoCompra like c.Ccodigo) 
and a.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
and a.sessionid = b.sessionid

</cfquery>


