<!--- Extracción de Swaps (Fact)
Modificada la Interfaz Para mejor Manejo de Errores La extracción se hace ahora dentro de un cf_loop para los detalles
por Ing. Luis Alejandro Bolaños Gómez el 31/08/07
--->
<!--- Tipo de Cobertura
Modificada la Interfaz Para Manejo del tipo de cobertura 
por Ing. Luis Alejandro Bolaños Gómez el 11/10/07
--->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<cfsetting requesttimeout="600">
<cffunction name="droptable">
<cfquery datasource="sifinterfaces">
#DropTableSQL('##SwapFACT_IE10')#
#DropTableSQL('##SwapFACT_ID10')#
#DropTableSQL('##Concep')#
if object_id('##OvsD_swapscompra') is not null
	drop table ##OvsD_swapscompra
if object_id('##swapsVentas') is not null
	drop table ##swapsVentas
if object_id('##swapsAlmacen') is not null
	drop table ##swapsAlmacen
if object_id('##SWAPS_IE103') is not null
	drop table ##SWAPS_IE103
</cfquery>
</cffunction>

<cfset droptable()>

<!---CREA TABLAS---> 
<cfquery datasource="sifinterfaces">
 create table ##SwapFACT_IE10(
  ID int null,
  i_folio int not null,
  i_empresa int not null,
  acct_num int null,
  c_tipo_folio char(2) not null,
  c_docto_proveedor varchar(40) null,
  c_moneda char(8) not null,
  dt_fecha_recibo datetime not null,
  dt_fecha_vencimiento datetime not null,
  voucher_num int not null,
  c_producto char(8) null,
  c_unidad char(8) null,
  voucher_tot_amt float null,
  voucher_curr_code char(8) null,
  f_precio float null,
  f_cantidad float null,
  f_iva float null,
  voucher_creation_date datetime null,
  voucher_book_comp_num int null,
  voucher_book_curr_code char(8) null,
  voucher_creator_init char(3) null,
  voucher_acct_name varchar(15) null,
  voucher_book_comp_name varchar(15) null,
  c_orden char(12) null,
  OrdenComer char(12) null,
  i_anio int null,
  SNid int not null,
  NombreBarco varchar(8) null,
  FechaHoraCarga datetime null,
  FechaHoraSalida datetime null,
  CodEmbarque char(8) null,
  FechaBOL datetime null,
  CodigoDireccionEnvio char(10) null,
  CodigoDireccionFact char(10) null,
  PrecioUnitario float null,
  CodigoUnidadMedida char(1) null,
  ImporteImpuesto float null,
  FechaTipoCambio datetime null,
  CuentaContable varchar(26) null,
  pump_on_date datetime null,
  pump_off_date datetime null
)

create clustered index ID_INDEX 
on ##SwapFACT_IE10(ID)


create table ##SwapFACT_ID10(
	ID int null,
	Consecutivo int null,
	Consecutivo2 int null,
	i_folio int not null,
	i_voucher int not null ,
	i_empresa_prop int not null,
	voucher_tot_amt float null ,
	cost_amt float null,  
	P_unitario_cost float null,
	N_productos int not null ,
	p_s_ind char(2) null,
	cmdty_code char(8) null ,
	order_type_code char(12) null,                 
	acct_ref_num char(12) null,                                     
	real_port_num int not null ,
	trade_num int null  ,
	cost_code char(12) null,
	cost_type_code char(12) null, 
	f_iva float null,
	ConceptoServicio int null,
	vr int null,
	vnr int null
)
 
create clustered index ID_INDEX 
on ##SwapFACT_ID10(ID)
</cfquery>

<!---LLENADO DE ENCABEZADO IE10- --->
<!--- Para Swaps Ganacia --->
<cfquery datasource="sifinterfaces">
insert ##SwapFACT_IE10
select distinct
 null,1 as i_folio,ab.acctNum, aa.acct_num,'RI' as c_tipo_folio, ab.invoice,ac.c_moneda,ab.invoiceDate,ab.dueDate, 
aa.voucher_num,  null, null,  aa.voucher_tot_amt, aa.voucher_curr_code, null,null,null, aa.voucher_creation_date, 
aa.voucher_book_comp_num, aa.voucher_book_curr_code,
aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,null, null, null, 
0 SNid, null,null,null,null,null, null,null,null,null,null,null,null,null,null		

from  #preictsdb#..voucher aa,
        #preictsdb#..PmiInvoice ab,
	#preictsdb#..PmiInvoiceDetail ac,
	#preictsdb#..account ad
where 
 	ab.paginaFact = 1
	and ab.bookingCo = ad.acct_short_name
	<!---and ad.acct_num =<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#"> --->
	and ad.acct_num =<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	and ab.voucherNum = ac.voucherNum
 	and ab.voucherNum = aa.voucher_num
	and (ab.invoiceType = 'f')
	and ab.status_xml = 'F'
	and (convert(varchar(8),aa.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#"> )
	/*and not exists(select 1 from InterfazBitacoraProcesos ib, IE10 ie where ab.invoice = ie.Documento
					and 'RI' = ie.CodigoTransacion and ab.acctNum = convert(int,ie.NumeroSocio) and ib.IdProceso 					
					= ie.ID and MsgError like 'OK') */
</cfquery>	
<!--- Para Swaps Perdida --->
<cfquery datasource="sifinterfaces">
insert ##SwapFACT_IE10
select
 null,ab.i_folio,ab.i_empresa, aa.acct_num,ab.c_tipo_folio, ab.c_docto_proveedor,ab.c_moneda,ab.dt_fecha_recibo,ab.dt_fecha_vencimiento, 
aa.voucher_num,  null, null,  aa.voucher_tot_amt, aa.voucher_curr_code, null,null,ab.f_iva, aa.voucher_creation_date, 
aa.voucher_book_comp_num, aa.voucher_book_curr_code,
aa.voucher_creator_init, aa.voucher_acct_name, aa.voucher_book_comp_name,ab.c_orden, null, ab.i_anio, 
0 SNid, null,null,null,null,null, null,null,null,null,null,null,null,null,null		

from  #preictsdb#..voucher aa,
        #preictsdb#..PmiFolios ab
where 
       ab.i_voucher = aa.voucher_num
	   and c_status not like 'RE'
	   <!---and   ab.i_empresa_prop =<cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#">--->
	   and   ab.i_empresa_prop =<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
       and (ab.c_tipo_folio = 'RI')
       and (convert(varchar(8),aa.voucher_creation_date,112) between 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaI, 'yyyymmdd' )#"> and
		<cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">)
      and not exists(select 1 from InterfazBitacoraProcesos ib, IE10 ie where ab.c_docto_proveedor = ie.Documento
					and ab.c_tipo_folio = ie.CodigoTransacion and ab.i_empresa = convert(int,ie.NumeroSocio) and 
					ib.IdProceso = ie.ID and MsgError like 'OK') 
</cfquery>

<!--- ACTUALIZAR SOCIO DE NEGOCIO --->
<cfquery datasource="sifinterfaces">
update ##SwapFACT_IE10 set SNid=a.SNid from #minisifdb#..SNegocios a, ##SwapFACT_IE10  b where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
and SNcodigoext= convert(varchar,b.i_empresa)
</cfquery>

<!--- ACTUALIZA DIRECCIONES --->
<cfquery datasource="sifinterfaces">
UPDATE ##SwapFACT_IE10 SET CodigoDireccionEnvio = c.SNcodigoext
from ##SwapFACT_IE10 a, #minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c 
where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre = 'COBERTURAS'
</cfquery>

<cfquery datasource="sifinterfaces">
UPDATE ##SwapFACT_IE10 SET CodigoDireccionFact =c.SNcodigoext from ##SwapFACT_IE10 a, 
#minisifdb#..SNegocios b, #minisifdb#..SNDirecciones c where a.i_empresa=convert(int,b.SNcodigoext) and b.SNid=c.SNid and c.SNnombre = 'COBERTURAS'
</cfquery>

<!--- ACTUALIZA CAMBIO DE PROPIEDAD --->
<cfquery datasource="sifinterfaces">
UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=NULL
UPDATE ##SwapFACT_IE10 SET FechaTipoCambio=dt_fecha_recibo from ##SwapFACT_IE10  where FechaTipoCambio IS NULL
</cfquery>

<!--- Genera el ID del Encabezado  --->
<cfquery datasource="sifinterfaces">
declare @i int
select @i=0 
UPDATE ##SwapFACT_IE10 set ID=@i + 1,@i=@i+1 
</cfquery>

<!--- Se generan los detalles para el SWAP en la tabla--->
<cfquery name="rsSWAPE" datasource="sifinterfaces">
	select * from ##SwapFACT_IE10
</cfquery>
<cfif rsSWAPE.recordcount GT 0>
<cfset consecutivo2 = 0>
<cfloop query="rsSWAPE">
	<cfset consecutivo = 0>
	<cfset sw_ID = #rsSWAPE.ID#>
	<cfset sw_Folio = #rsSWAPE.i_folio#>
	<cfset sw_Voucher = #rsSWAPE.voucher_num#>
	<cfset sw_Empresa = #rsSWAPE.i_empresa#>
	<cfset sw_Total = #rsSWAPE.voucher_tot_amt#>
	<cfquery name="rsSWAPD" datasource="sifinterfaces">
		select a.port_num,a.cost_code,a.cost_type_code, a.cost_amt
		from #preictsdb#..cost a 
				inner join 		
						#preictsdb#..voucher_cost b
				on a.cost_num = b.cost_num
		where b.voucher_num = #rsSWAPE.voucher_num#
		and a.cost_type_code='SWAP'
	</cfquery>
	<cfif rsSWAPD.recordcount GT 0>
	<cfloop query="rsSWAPD">
		<cfset sw_Costo = #rsSWAPD.cost_amt#>
		<cfset sw_Portfolio = #rsSWAPD.port_num#>
		<cfset sw_CostCode = #rsSWAPD.cost_code#>
		<cfset sw_CTypeCode = #rsSWAPD.cost_type_code#>
		<cfif sw_Folio EQ 1>
			<cfset sw_ControlCV = 'S'>
		<cfelse>
			<cfset sw_ControlCV = 'P'>
		</cfif>
		<cfquery name="rsSWAPT" datasource="sifinterfaces">
		select  distinct 
				f.NVentas,  
                g.N_productos,
                f.p_s_ind ,
                f.cmdty_code ,
                f.order_type_code,                 
                f.acct_ref_num,                                     
                f.real_port_num,
                f.trade_num
		from 
		(select	distinct
				h.real_port_num,
				h.p_s_ind,
                h.cmdty_code ,
                h.order_type_code,                 
                az.NVentas,
				h.acct_ref_num,
                h.trade_num
		from
			(select  distinct 
                     t.real_port_num,
					 t.p_s_ind,
                     t.cmdty_code,
                     o.order_type_code,
                     tr.acct_ref_num,
                     t.trade_num
			 from            
                     #preictsdb#..trade_item t, 
                     #preictsdb#..trade_order o,
                     #preictsdb#..trade tr
					 --,#preictsdb#..cost ct
             where          
                     t.trade_num=o.trade_num
                     and t.order_num=o.order_num
                     --and ct.cost_owner_key6 = t.trade_num
					 --and ct.cost_type_code = 'WPP'
					 and o.order_type_code='PHYSICAL'
                     and t.p_s_ind='#sw_ControlCV#'
                     and tr.trade_num=t.trade_num ) h,
			(select  distinct 
					 am.real_port_num,
					 count(distinct am.trade_num) as NVentas
             from            
                     #preictsdb#..trade_item am, 
                     #preictsdb#..trade_order an,
                     #preictsdb#..trade ao
					 --,#preictsdb#..cost ap
             where          
                     am.trade_num=an.trade_num
                     and am.order_num=an.order_num
                     --and ap.cost_owner_key6 = am.trade_num
					 --and ap.cost_type_code = 'WPP'
					 and an.order_type_code='PHYSICAL'
                     and am.p_s_ind='#sw_ControlCV#'
                     and ao.trade_num=an.trade_num 
					 group by am.real_port_num) az
		where h.real_port_num = #rsSWAPD.port_num# and az.real_port_num = h.real_port_num) f,
		(select distinct 
                t.real_port_num,
                tr.acct_ref_num,
                (count( distinct t.cmdty_code)) as N_productos,
                t.cmdty_code
                  from            
                          #preictsdb#..trade_item t, 
                          #preictsdb#..trade_order o,
                          #preictsdb#..trade tr
						  --, #preictsdb#..cost ct
                  where          
                          t.trade_num=o.trade_num
                          and t.order_num=o.order_num
                  		  --and ct.cost_owner_key6 = t.trade_num
						  --and ct.cost_type_code = 'WPP'
						  and o.order_type_code='PHYSICAL'
                          and t.p_s_ind='#sw_ControlCV#'
                          and tr.trade_num=t.trade_num                                                     
		and t.real_port_num = #rsSWAPD.port_num#
		                   group by  t.real_port_num,tr.acct_ref_num) g
		</cfquery>
		<cfif rsSWAPT.recordcount GT 0>
		<cfloop query="rsSWAPT">
			<cfset sw_cXventa = sw_Costo / rsSWAPT.Nventas>
			<cfset sw_cXproducto = sw_cXventa / rsSWAPT.N_productos>
			<cfset consecutivo = consecutivo + 1>
			<cfset consecutivo2 = consecutivo2 + 1>
			<cfquery datasource="sifinterfaces">
				INSERT INTO ##SwapFACT_ID10
				values  (#sw_ID#,#consecutivo#,#consecutivo2#,#sw_Folio#, #sw_Voucher#, #sw_Empresa#,#sw_Total# ,
				#sw_cXventa#, #sw_cXproducto#, #rsSWAPT.N_productos#, '#rsSWAPT.p_s_ind#', '#rsSWAPT.cmdty_code#'
				,'#rsSWAPT.order_type_code#', '#rsSWAPT.acct_ref_num#', #sw_Portfolio#, #rsSWAPT.trade_num#,
				'#sw_CostCode#','#sw_CTypeCode#',0,null,null,null)
			</cfquery>
		</cfloop>
		<cfelse>
			<cfset consecutivo = consecutivo + 1>
			<cfset consecutivo2 = consecutivo2 + 1>
			<cfquery datasource="sifinterfaces">
				INSERT INTO ##SwapFACT_ID10
				values  (#sw_ID#,#consecutivo#,#consecutivo2#,#sw_Folio#, #sw_Voucher#, #sw_Empresa#,#sw_Total# ,
				0, 0, 0, null, null,
				null, null, #sw_Portfolio#, null,
				'#sw_CostCode#','#sw_CTypeCode#',0,null,null,null)
			</cfquery>
		</cfif>
	</cfloop>
	</cfif>
</cfloop>
</cfif>

<!--- ACTUALIZAR CONCEPTO SERVICIO --->
<cfquery datasource="sifinterfaces">
select sb.subconcepto_id, ff.i_folio, ff.cost_code,ff.cost_type_code
	INTO tempdb..##Concep 
	FROM #tesoreriadb#..subconceptos sb, #tesoreriadb#..rel_subconceptos_detalles r, #tesoreriadb#..subconceptos_detalle s,  ##SwapFACT_ID10 ff
	WHERE s.costo_id = ff.cost_code
		  AND s.tipo_costo = ff.cost_type_code
		  AND s.payable_receivable = 'P' 
		  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
		  AND sb.subconcepto_id = r.subconcepto_id
		 --AND sb.subconcepto_id = cp.converCcodigo

UPDATE ##SwapFACT_ID10 set ConceptoServicio = b.subconcepto_id from ##SwapFACT_ID10 a,   tempdb..##Concep b WHERE a.i_folio=b.i_folio
UPDATE ##SwapFACT_ID10 set ConceptoServicio =22 from ##SwapFACT_ID10  where ConceptoServicio IS NULL
</cfquery>



<!---Rutina para saber si las ventas son realizadas o no realizadas CxC--->
<cfquery name="rsSWAPD" datasource="sifinterfaces">
	select * from ##SwapFACT_ID10 
	where i_folio = 1 
	and ID is not null
	and acct_ref_num is not null
	order by real_port_num
</cfquery>
<cfloop query="rsSWAPD">
	<cfquery name="rsVRVNR" datasource="sifinterfaces">
		select distinct a.port_num,d.title_tran_date,d.trade_num, #rsSWAPD.trade_num# as tradeSWAP,
						'#rsSWAPD.cmdty_code#' as Producto, #rsSWAPD.cost_amt# as Costo, #rsSWAPD.i_folio# as Folio,
						 #rsSWAPD.i_voucher# as Voucher
		from preicts..cost a 
						inner join 
								preicts..trade_item b 
										inner join 
												preicts..trade_order c 
										on b.trade_num = c.trade_num 
										and b.order_num = c.order_num 
										and c.order_type_code like 'PHYSICAL'
						on a.port_num = b.real_port_num and a.cost_owner_key6 = b.trade_num 
						and a.cost_owner_key7 = b.order_num 
						and a.cost_owner_key8 = b.item_num
						and b.p_s_ind like 'S'
						inner join 
								preicts..allocation_item d
						on a.cost_owner_key6 = d.trade_num and a.cost_owner_key7 = d.order_num 
						and a.cost_owner_key8 = d.item_num
		where a.port_num = #rsSWAPD.real_port_num# and b.trade_num = #rsSWAPD.trade_num#
		and d.title_tran_date <= <cfqueryparam cfsqltype="cf_sql_varchar" value="# DateFormat(vFechaF, 'yyyymmdd' )#">
	</cfquery>
	<cfif rsVRVNR.recordcount EQ 0 >
		<cfset sw_VR = 0>
		<cfset sw_VNR = 1>
	<cfelse>
		<cfset sw_VR = 1>
		<cfset sw_VNR = 0>
	</cfif>
	<cfquery datasource="sifinterfaces">
		update ##SwapFACT_ID10 
		set vr = <cfqueryparam cfsqltype="cf_sql_integer" value="#sw_VR#">,
			vnr = <cfqueryparam cfsqltype="cf_sql_integer" value="#sw_VNR#">
		where ID = #rsSWAPD.ID# and Consecutivo2 = #rsSWAPD.Consecutivo2# and Consecutivo = #rsSWAPD.Consecutivo#
	</cfquery>
</cfloop>

<!---Rutina para saber si las ventas son realizadas o no realizadas CxP--->
<cfquery name="rsSWAPD" datasource="sifinterfaces">
	select distinct * from ##SwapFACT_ID10 
	where i_folio != 1 
	and ID is not null
	and acct_ref_num is not null
	order by real_port_num
</cfquery>
<cfloop query="rsSWAPD">
	<cfquery name="rsVRVNR" datasource="preicts">
	 select venta_realizada, count(1) as cantidad from 
	 	(	
		select  case when min(d.title_tran_date) is not null
						 and min(d.title_tran_date) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaF#">
						 then 'Y'
						 else 'N' end as venta_realizada,
						 min(d.title_tran_date) as title_tran_date,b.trade_num,b.order_num,b.item_num
		from cost a 
						inner join 
								trade_item b 
										inner join 
												trade_order c 
										on b.trade_num = c.trade_num 
										and b.order_num = c.order_num 
										and c.order_type_code like 'PHYSICAL'
						on a.port_num = b.real_port_num and a.cost_owner_key6 = b.trade_num 
						and a.cost_owner_key7 = b.order_num 
						and a.cost_owner_key8 = b.item_num
						and b.p_s_ind like 'S'
						inner join 
								allocation_item d
						on a.cost_owner_key6 = d.trade_num and a.cost_owner_key7 = d.order_num 
						and a.cost_owner_key8 = d.item_num
		where a.port_num = #rsSWAPD.real_port_num#
		<!---and b.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#INTICTS.CodICTS#">--->
		and b.booking_comp_num  = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
		and d.title_tran_date is not null
		group by b.trade_num,b.order_num,b.item_num
		) cta
		group by venta_realizada
		order by venta_realizada 
	</cfquery>
	<!--- ORDEN: N {row 1}, Y {row 2} --->
	<cfif rsVRVNR.recordcount EQ 0>
		<cfset sw_VR =0>
		<cfset sw_VNR =0>
	<cfelseif rsVRVNR.recordcount IS 1>
		<cfif trim(rsVRVNR.venta_realizada) IS 'Y'>
			<cfset sw_VR =rsVRVNR.cantidad >
			<cfset sw_VNR =0>
		<cfelse>
			<cfset sw_VR =0>
			<cfset sw_VNR =rsVRVNR.cantidad>
		</cfif>
	<cfelse>
		<cfif rsVRVNR.cantidad [ 2 ] EQ ''>
			<cfset sw_VR =0>
		<cfelse>
			<cfset sw_VR =rsVRVNR.cantidad [ 2 ]>
		</cfif>
		<cfif rsVRVNR.cantidad [ 1 ] EQ ''>
			<cfset sw_VNR =0>
		<cfelse>
			<cfset sw_VNR = rsVRVNR.cantidad [ 1 ]>
		</cfif>
	</cfif>
	<cfquery datasource="sifinterfaces">
		update ##SwapFACT_ID10 
		set vr = <cfqueryparam cfsqltype="cf_sql_integer" value="#sw_VR#">,
			vnr = <cfqueryparam cfsqltype="cf_sql_integer" value="#sw_VNR#">
		where ID = #rsSWAPD.ID# and Consecutivo2 = #rsSWAPD.Consecutivo2# and Consecutivo = #rsSWAPD.Consecutivo#
	</cfquery>
</cfloop>

<!---Inserta Datos en las tablas PMIINT --->
<cfquery name="rsSWAPIE10" datasource="sifinterfaces">
	select * from ##SwapFACT_IE10
		where ID is not null
</cfquery>
<cfif rsSWAPIE10.recordcount GT 0>
<cfloop query="rsSWAPIE10">
	<cfset sw_FDocumento = rsSWAPIE10.dt_fecha_recibo>
	<cfset sw_ID = rsSWAPIE10.ID>
	<cfif rsSWAPIE10.i_folio EQ 1>
		<cfset sw_Modulo = "CC">
		<cfset sw_TipoOrden = "Ventas">
	<cfelse>
		<cfset sw_Modulo = "CP">
		<cfset sw_TipoOrden = "Compras">
	</cfif>
	<cfset sw_Consecutivo = 0>
	<!---Inserta Datos en la tabla de encabezados IE10 --->
	<cfquery datasource="sifinterfaces">
		insert #sifinterfacesdb#..PMIINT_IE10 (FechaRegistro,sessionid,
		ID,EcodigoSDC, NumeroSocio, Modulo,CodigoTransacion, 
		Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, 
		Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion,
		CodigoOficina, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
		FechaTipoCambio, StatusProceso)
		values
		(<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSWAPIE10.ID#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.i_empresa#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Modulo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.c_tipo_folio#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.c_docto_proveedor#">,
		 null,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.c_moneda#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#rsSWAPIE10.dt_fecha_recibo#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#rsSWAPIE10.dt_fecha_vencimiento#">,
		'S', 'ICTS',<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.voucher_num#">,'22',null,
		null , 0 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoDireccionEnvio#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoDireccionFact#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#rsSWAPIE10.FechaTipoCambio#">, 1)
	</cfquery>
	<cfquery name="rsSWAPID10" datasource="sifinterfaces">
		select * from ##SwapFACT_ID10
		where ID is not null
		and ID = #rsSWAPIE10.ID#
	</cfquery>
	<cfif rsSWAPID10.recordcount GT 0>
	<cfloop query="rsSWAPID10">
		<!--- Si tiene portafolio, buscar clasificación de cobertura --->
		<cfif Len(rsSWAPID10.real_port_num) NEQ 0>
			<cfquery datasource="preicts" name="cobertura">
				<!---Se tendria que cambiar por right(tgo.tag_option_desc,2)--->
				select tgo.tag_option_desc, pt.tag_value
				from portfolio_tag_option tgo, portfolio_tag pt
				where tgo.tag_name = 'CLASS'
				  and tgo.tag_option = pt.tag_value
				  and pt.port_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSWAPID10.real_port_num#">
				  and pt.tag_name = 'CLASS'
			</cfquery>
			<!--- VERIFICA QUE LA COBERTURA VENGA Y VENGA BIEN ("FE" o "VR"), SI NO MUESTRA ERROR --->
			<cfif cobertura.RecordCount is 0>
				<cfquery datasource="sifinterfaces">
					update PMIINT_IE10
					set MensajeError = case when MensajeError is null
					then 'No. de Portafolio #rsSWAPID10.real_port_num# no tiene Clasificación contable de cobertura
					 (FE/VR)'
					else MensajeError + ', No. de Portafolio #rsSWAPID10.real_port_num# no tiene Clasificación contable de
					cobertura (FE/VR)' end
					where ID = #sw_ID#
					and 
					(MensajeError not like 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rsSWAPID10.real_port_num#%FE/VR%">
						OR
					 MensajeError is null)
					and sessionid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
				</cfquery>
			<cfelseif ListFind('FE,VR', cobertura.tag_option_desc) is 0>
				<cfquery datasource="sifinterfaces">
					update PMIINT_IE10
					set MensajeError = case when MensajeError is null
					then 'No. de Portafolio #rsSWAPID10.real_port_num# Clasificación contable inválida 
					(#cobertura.tag_value#, #cobertura.tag_option_desc#), debe ser FE o VR'
					else MensajeError + ', No. de Portafolio #rsSWAPID10.real_port_num# Clasificación contable inválida 
					(#cobertura.tag_value#, #cobertura.tag_option_desc#), debe ser FE o VR' end
					where ID = #sw_ID#
					and 
					(MensajeError not like 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="%#rsSWAPID10.real_port_num#%FE o VR%">
						OR
					 MensajeError is null)
					and sessionid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
				</cfquery>
			</cfif>
			<!--- CLASIFICACION_DE_COBERTURA: FE (FLUJO DE EFECTIVO), VR (VALOR RAZONABLE) --->
			<cfif cobertura.tag_option_desc is 'VR'>
				<cfset CLASIFICACION_DE_COBERTURA = 'VR'>
			<cfelse>
				<cfset CLASIFICACION_DE_COBERTURA = 'FE'>
			</cfif>
		</cfif>
			<cfif rsSWAPID10.vr EQ ''>
				<cfset sw_VR = 0>
			<cfelse>
				<cfset sw_VR = rsSWAPID10.vr>
			</cfif>
			<cfif rsSWAPID10.vnr EQ ''>
				<cfset sw_VNR = 0>
			<cfelse>
				<cfset sw_VNR = rsSWAPID10.vnr>
			</cfif>
			<cfset sw_TotalVentas =  sw_VR + sw_VNR>
			<cfif sw_TotalVentas GT 0>
				<cfset sw_MontoVR =  cost_amt * sw_VR / sw_TotalVentas>
				<cfset sw_MontoVNR =  cost_amt * sw_VNR / sw_TotalVentas>
			<cfelse>
				<cfquery datasource="sifinterfaces">
				update PMIINT_IE10
				set MensajeError = case when MensajeError is null
				then 'No existen #sw_TipoOrden# asociadas a este portfolio:#rsSWAPID10.real_port_num# '
				else MensajeError + ',No existen #sw_TipoOrden# asociadas a este portfolio:#rsSWAPID10.real_port_num# ' 
				end
				where ID = #sw_ID#
				and 
				(MensajeError not like <cfqueryparam cfsqltype="cf_sql_varchar" value="%:#rsSWAPID10.real_port_num#%">
					OR
				 MensajeError is null)
				and sessionid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
				</cfquery>
				<!--- Inserta el detalle para Mostrar el Error --->
				<cfset sw_Consecutivo = sw_Consecutivo + 1>
				<cfset sw_MontoVR =  0>
				<cfset sw_MontoVNR =  0>
				<cfquery datasource="sifinterfaces">
					/*--------INSERTA LA INFORMACION EN LA TABLA ID10-------*/
					insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
					ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
					FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
					ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
					CodigoDepartamento, PrecioTotal, CentroFuncional, 
					CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso)
						values(<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSWAPID10.ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sw_Consecutivo#">,
					'O',<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.cmdty_code#">,
					null,null, null,0,'',0,
					0, null,'0',<cfqueryparam cfsqltype="cf_sql_date" value="#sw_FDocumento#">,
					null, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.acct_ref_num#">, 
					null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSWAPID10.f_iva#">,
					0,null,null,round(#sw_MontoVR#,2), null, 
					null,null,null,null,null,null)
				</cfquery>
			</cfif>
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select dx.OCTtransporte,dx.OCTtipo from OCtransporte dx,
				OCtransporteProducto cx, OCordenComercial ax 
				where  ax.OCcontrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.acct_ref_num#">
				and ax.OCid = cx.OCid and cx.OCTid = dx.OCTid
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset sw_OCTtransporte = rsVerifica.OCTtransporte>
				<cfset sw_OCTtipo = rsVerifica.OCTtipo>
			<cfelse>
				<cfset sw_OCTtransporte = "">
				<cfset sw_OCTtipo = "">
			</cfif>
			<!---Hay Ventas Realizadas--->
			<cfif sw_MontoVR GT 0>
				<cfset sw_Consecutivo = sw_Consecutivo + 1>
				<cfif rsSWAPID10.i_folio EQ 1>
					<cfif CLASIFICACION_DE_COBERTURA EQ 'VR'>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "118-VR2">
						<cfset sw_TipoItem = "O">
						<cfset sw_CodigoItem = rsSWAPID10.cmdty_code>
						<cfset sw_OCcontrato_VR = rsSWAPID10.acct_ref_num>
						<cfset sw_OCTtipo_VR = sw_OCTtipo>
						<cfset sw_OCTtransporte_VR = sw_OCTtransporte>
					<cfelse>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "118-FE4">
						<cfset sw_TipoItem = "O">
						<cfset sw_CodigoItem = rsSWAPID10.cmdty_code>
						<cfset sw_OCcontrato_VR = rsSWAPID10.acct_ref_num>
						<cfset sw_OCTtipo_VR = sw_OCTtipo>
						<cfset sw_OCTtransporte_VR = sw_OCTtransporte>
					</cfif>
				<cfelse>
					<cfif CLASIFICACION_DE_COBERTURA EQ 'VR'>
						<cfset sw_Ccompra = "26-VR2">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "O">
						<cfset sw_CodigoItem = rsSWAPID10.cmdty_code>
						<cfset sw_OCcontrato_VR = rsSWAPID10.acct_ref_num>
						<cfset sw_OCTtipo_VR = sw_OCTtipo>
						<cfset sw_OCTtransporte_VR = sw_OCTtransporte>
					<cfelse>
						<cfset sw_Ccompra = "26-FE4">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "O">
						<cfset sw_CodigoItem = rsSWAPID10.cmdty_code>
						<cfset sw_OCcontrato_VR = rsSWAPID10.acct_ref_num>
						<cfset sw_OCTtipo_VR = sw_OCTtipo>
						<cfset sw_OCTtransporte_VR = sw_OCTtransporte>
					</cfif>
				</cfif>
			<!--- Si hay monto para las ventas realizadas inserta un detalle --->
				<cfquery datasource="sifinterfaces">
					/*--------INSERTA LA INFORMACION EN LA TABLA ID10-------*/
					insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
					ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
					FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
					ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
					CodigoDepartamento, PrecioTotal, CentroFuncional, 
					CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso,
					cobertura)
						values(<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSWAPID10.ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sw_Consecutivo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_TipoItem#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_CodigoItem#">,
					null,null, null,<cfif sw_TipoItem is "S">
										round(#sw_MontoVR#,2),
									<cfelse>
									 	0,
									</cfif>
					'',<cfif sw_TipoItem is "S">
							1,
					   <cfelse>
						 	0,
					   </cfif>
					0, null,'0',<cfqueryparam cfsqltype="cf_sql_date" value="#sw_FDocumento#">,
					null, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.acct_ref_num#">, 
					null, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSWAPID10.f_iva#">,
					0,null,null,round(#sw_MontoVR#,2), null, 
					null,<cfif sw_TipoItem is "S">
							null,
						 <cfelse>
						 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCTtipo_VR#">,
						 </cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCTtransporte_VR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCcontrato_VR#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Ccompra#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Venta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASIFICACION_DE_COBERTURA#-VR">)
				</cfquery>
			</cfif>
			<!---Hay Ventas NORealizadas--->
			<cfif sw_MontoVNR GT 0>
				<cfset sw_Consecutivo = sw_Consecutivo + 1>
				<cfif rsSWAPID10.i_folio EQ 1>
					<cfif CLASIFICACION_DE_COBERTURA EQ 'VR'>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "S">
						<cfset sw_CodigoItem = "118-FE3">
						<cfset sw_OCcontrato_VNR = "">
						<cfset sw_OCTtipo_VNR = "">
						<cfset sw_OCTtransporte_VNR = "">
						<cfquery datasource="sifinterfaces">
							update PMIINT_IE10
							set MensajeError = case when MensajeError is null
							then 'Error Venta No realizada en Valor Razonable'
							else MensajeError + ',Error Venta No realizada en Valor Razonable' end
							where ID = #sw_ID#
							and 
							(MensajeError not like <cfqueryparam cfsqltype="cf_sql_varchar" value="%No realizada%">
								OR
				 			MensajeError is null)
							and sessionid =  
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
						</cfquery>
					<cfelse>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "S">
						<cfset sw_CodigoItem = "118-FE3">
						<cfset sw_OCcontrato_VNR = "">
						<cfset sw_OCTtipo_VNR = "">
						<cfset sw_OCTtransporte_VNR = "">
					</cfif>
				<cfelse>
					<cfif CLASIFICACION_DE_COBERTURA EQ 'VR'>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "S">
						<cfset sw_CodigoItem = "26-FE3">
						<cfset sw_OCcontrato_VNR = "">
						<cfset sw_OCTtipo_VNR = "">
						<cfset sw_OCTtransporte_VNR = "">
						<cfquery datasource="sifinterfaces">
							update PMIINT_IE10
							set MensajeError = case when MensajeError is null
							then 'Error Venta No realizada en Valor Razonable'
							else MensajeError + ',Error Venta No realizada en Valor Razonable' end
							where ID = #sw_ID#
							and 
							(MensajeError not like <cfqueryparam cfsqltype="cf_sql_varchar" value="%No realizada%">
								OR
				 			MensajeError is null)
							and sessionid =  
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
						</cfquery>
					<cfelse>
						<cfset sw_Ccompra = "">
						<cfset sw_Venta = "">
						<cfset sw_TipoItem = "S">
						<cfset sw_CodigoItem = "26-FE3">
						<cfset sw_OCcontrato_VNR = "">
						<cfset sw_OCTtipo_VNR = "">
						<cfset sw_OCTtransporte_VNR = "">
					</cfif>
				</cfif>
			<!--- Si hay monto para las ventas NO realizadas inserta un detalle --->
				<cfquery datasource="sifinterfaces">
					/*--------INSERTA LA INFORMACION EN LA TABLA ID10-------*/
					insert #sifinterfacesdb#..PMIINT_ID10 (FechaRegistro,sessionid,
					ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
					FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
					ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
					CodigoDepartamento, PrecioTotal, CentroFuncional, 
					CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra, OCconceptoIngreso,
					cobertura)
						values(
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, #session.monitoreo.sessionid#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSWAPID10.ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#sw_Consecutivo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_TipoItem#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_CodigoItem#">,
					null,null, null,<cfif sw_TipoItem is "S">
										round(#sw_MontoVNR#,2),
									<cfelse>
									 	0,
									</cfif>
					'',<cfif sw_TipoItem is "S">
							1,
					   <cfelse>
						 	0,
					   </cfif>
					0, null,'0',<cfqueryparam cfsqltype="cf_sql_date" value="#sw_FDocumento#">,
					null, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.acct_ref_num#">, 
					null, round(<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsSWAPID10.f_iva#">,2),
					0,null,null,round(#sw_MontoVNR#,2), null, 
					null,<cfif sw_TipoItem is "S">
							null,
						 <cfelse>
						 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCTtipo_VNR#">,
						 </cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCTtransporte_VNR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_OCcontrato_VNR#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Ccompra#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Venta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASIFICACION_DE_COBERTURA#-VNR">)
				</cfquery>
			</cfif>
	</cfloop>
	</cfif>
</cfloop>
</cfif>

<!--- Ajuste de Centavos de Diferencia --->
<cfquery name="rsAjusteE" datasource="sifinterfaces">
	select distinct ID,voucher_tot_amt from  ##SwapFACT_IE10
</cfquery>
<cfloop query="rsAjusteE">
	<cfquery name="rsAjusteD" datasource="sifinterfaces">
		select ID,sum(PrecioTotal) as Suma from PMIINT_ID10
		where ID = #rsAjusteE.ID#
		and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
		group by ID
	</cfquery>
	<cfset sw_Ajuste = rsAjusteE.voucher_tot_amt - rsAjusteD.Suma>
	<cfif sw_Ajuste LE 1>
		<cfquery datasource="sifinterfaces">
			update PMIINT_ID10 set PrecioTotal = PrecioTotal + #sw_Ajuste#
			where ID = #rsAjusteE.ID#
			and Consecutivo = (select min(Consecutivo) from PMIINT_ID10 where ID  = #rsAjusteE.ID# 
							and sessionid = 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">)
			 and sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
		</cfquery>
	</cfif>
</cfloop>
<!---Rutina para validacion de errores Modificada 30/08/07 por Ing. Luis Alejandro Bolaños Gómez --->
<!--- Validacion de Errores --->
<cfset LvarBanderaErrores = false>
<cfquery name="rsSWAPIE10" datasource="sifinterfaces">
	select * from #sifinterfacesdb#..PMIINT_IE10
	where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
</cfquery>
<cfif rsSWAPIE10.recordcount GT 0>
	<cfloop query="rsSWAPIE10">
		<cfset LvarTipoError = "">
		<cfset sw_ID = rsSWAPIE10.ID>
		<cfset sw_Modulo = rsSWAPIE10.Modulo>
		<!---Verifica que exista el socio de Negocios--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#..SNegocios 
				where SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio de Negocios NO existe en SOIN-SIF">
		</cfif>
		<!---Verifica la clasificacion del socio como Coberturas--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#..SNegocios a 
							inner join 
										#minisifdb#..SNDirecciones b
							on a.SNid = b.SNid and a.Ecodigo = b.Ecodigo
			where
			a.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.SNnombre like 'COBERTURAS'
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Socio de Negocios sin direccion COBERTURAS">
		</cfif>
		<!---Verifica numero de documento correcto--->
		<cfif len(rsSWAPIE10.Documento) EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Numero de Documento Invalido">
		</cfif>
		<!---Verifica que tenga configurada cuenta en su direccion COBERTURAS--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select b.SNDCFcuentaProveedor,b.SNDCFcuentaCliente
			from #minisifdb#..SNegocios a 
							inner join 
										#minisifdb#..SNDirecciones b
							on a.SNid = b.SNid and a.Ecodigo = b.Ecodigo
			where
			a.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.SNnombre like 'COBERTURAS'
		</cfquery>
		<cfif (trim(rsSWAPIE10.Modulo) EQ "CP" AND len(rsVerifica.SNDCFcuentaProveedor) EQ 0) 
				OR (trim(rsSWAPIE10.Modulo) EQ "CC" AND len(rsVerifica.SNDCFcuentaCliente) EQ 0)>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Direccion COBERTURAS sin cuenta #rsSWAPIE10.Modulo# parametrizada ">
		</cfif>
		<!---Verifica el codigo de Moneda*/--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from #minisifdb#.. Monedas 
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoMoneda#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Codigo de Moneda Incorrecto #rsSWAPIE10.CodigoMoneda#">
		</cfif>
		<!---Verifica que el Documento no haya sido aplicado antes--->
		<cfif trim(rsSWAPIE10.Modulo) EQ "CP">
			<cfquery name="rsVerifica" datasource="sifinterfaces">
			select count(*) as Documentos from 
			(select EDdocumento from  #minisifdb#..EDocumentosCxP c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.EDdocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
			 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 union
			 select Ddocumento from  #minisifdb#..EDocumentosCP c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
			 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 union
			 select Ddocumento from  #minisifdb#..HEDocumentosCP c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CPTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
			 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 ) f
			</cfquery>
		<cfelseif trim(rsSWAPIE10.Modulo) EQ "CC">
			<cfquery name="rsVerifica" datasource="sifinterfaces">
			select count(*) as Documentos from 
			(select EDdocumento from  #minisifdb#..EDocumentosCxC c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.EDdocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
			 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 union
			 select Ddocumento from  #minisifdb#..Documentos c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
			 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			 union
			 select Ddocumento from  #minisifdb#..HDocumentos c, #minisifdb#..SNegocios d 
			 where 
			 ltrim(rtrim(c.Ddocumento)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			 and c.CCTcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			 and d.SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
			 and c.SNcodigo = d.SNcodigo 
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
		<!---Verifica que el documento no se encuentre en la cola de procesos--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select IdProceso from InterfazColaProcesos ib inner join IE10 ie on ib.IdProceso = ie.ID
			where ie.Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.Documento#">
			and ie.CodigoTransacion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.CodigoTransacion#">
			and ie.NumeroSocio like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPIE10.NumeroSocio#">
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
		<!---Verifica que exista Orden Comercial--->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * from PMIINT_ID10
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			and ID = #sw_ID#
		</cfquery>
		<cfif rsVerifica.recordcount EQ 0>
			<cfset LvarBanderaErrores = true>
			<cfif len(LvarTipoError)>
				<cfset LvarTipoError = LvarTipoError & ", ">
			</cfif>
			<cfset LvarTipoError = LvarTipoError & "Ninguna Orden Comerical de Producto relacionada al Documento ">
		</cfif>
		<cfset LvarBanderaErrores_registro = False>
		<cfquery name="rsSWAPID10" datasource="sifinterfaces">
			select * from #sifinterfacesdb#..PMIINT_ID10
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			and ID = #sw_ID#
		</cfquery>
		<cfif rsSWAPID10.recordcount GT 0>
			<cfloop query="rsSWAPID10">
				<cfif trim(rsSWAPID10.TipoItem) EQ "O">
					<!---Verifica que el Articulo Exista--->
					<cfif rsSWAPID10.CodigoItem NEQ '' AND len(trim(rsSWAPID10.CodigoItem)) GT 0>
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from  #minisifdb#..Articulos c 
							where ltrim(rtrim(c.Acodigo)) = 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.CodigoItem#">
							 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<cfif rsVerifica.recordcount EQ 0>
							<cfset LvarBanderaErrores = true>
							<cfset Busqueda =
									find("Articulo no existe en SOIN-SIF #rsSWAPID10.CodigoItem#",#LvarTipoError#)>
							<cfif Busqueda EQ 0>
								<cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
								</cfif>
								<cfset LvarTipoError = 
										LvarTipoError & "Articulo no existe en SOIN-SIF #rsSWAPID10.CodigoItem#">
							</cfif>
						</cfif>
					</cfif>
					<!---Verifica que la orden comercial Exista en la estrcutura de OC--->
					<cfif rsSWAPID10.OCcontrato NEQ '' AND len(trim(rsSWAPID10.OCcontrato)) GT 0>
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from  #minisifdb#..OCordenComercial c 
							where ltrim(rtrim(c.OCcontrato)) = 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.OCcontrato#">
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<cfif rsVerifica.recordcount EQ 0>
							<cfset LvarBanderaErrores = true>
							<cfset Busqueda = 
							find("Orden Comercial no encontrada en SOIN-SIF V6: #rsSWAPID10.OCcontrato#",#LvarTipoError#)>
							<cfif Busqueda EQ 0>
								<cfif len(LvarTipoError)>
									<cfset LvarTipoError = LvarTipoError & ", ">
								</cfif>
								<cfset LvarTipoError =
								LvarTipoError & "Orden Comercial no encontrada en SOIN-SIF V6: #rsSWAPID10.OCcontrato#">
							</cfif>
						</cfif>
					</cfif>
					<!---Verifica que el Concepto de Servicio Exista--->
					<cfif trim(sw_Modulo) EQ "CP">
						<cfset sw_Concepto = rsSWAPID10.OCconceptoCompra>
						<cfset sw_ConceptoIC = "Compra">
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from #minisifdb#..OCconceptoCompra c 
							where OCCcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Concepto#"> 
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>	
					<cfelseif trim(sw_Modulo) EQ "CC">
						<cfset sw_Concepto = rsSWAPID10.OCconceptoIngreso>
						<cfset sw_ConceptoIC = "Ingreso">
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select 1 from #minisifdb#..OCconceptoIngreso c 
							where OCIcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#sw_Concepto#"> 
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>	
					</cfif>
					<cfif IsDefined("sw_Concepto")>
						<cfif sw_Concepto NEQ '' AND len(trim(sw_Concepto)) GT 0>
							<cfif rsVerifica.recordcount EQ 0>
								<cfset LvarBanderaErrores = true>
								<cfset Busqueda = find("Concepto #sw_Concepto# de #sw_ConceptoIC# NO Valido",#LvarTipoError#)>
								<cfif Busqueda EQ 0>
								   <cfif len(LvarTipoError)>
										<cfset LvarTipoError = LvarTipoError & ", ">
								   </cfif>
								   <cfset LvarTipoError = LvarTipoError & "Concepto #sw_Concepto# de #sw_ConceptoIC# NO Valido">
								</cfif>						
							</cfif>
						</cfif>
					</cfif>
				</cfif>
				<cfif trim(rsSWAPID10.TipoItem) EQ "S">
					<!---Verifica que el Concepto de Servicio Exista--->
					<cfquery name="rsVerifica" datasource="sifinterfaces">
						select 1 from #minisifdb#..Conceptos c 
						where Ccodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSWAPID10.CodigoItem#"> 
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>	
					<cfif rsVerifica.recordcount EQ 0>
						<cfset LvarBanderaErrores = true>
						<cfset Busqueda = 
						find("Concepto #rsSWAPID10.CodigoItem# de Servicio NO existe en SOIN-SIF V6",#LvarTipoError#)>
						<cfif Busqueda EQ 0>
							<cfif len(LvarTipoError)>
								<cfset LvarTipoError = LvarTipoError & ", ">
							</cfif>
							<cfset LvarTipoError = 
							LvarTipoError & "Concepto #rsSWAPID10.CodigoItem# de Servicio NO existe en SOIN-SIF V6">
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
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
		where ID = #sw_ID#
		and sessionid = #session.monitoreo.sessionid#
	</cfquery>
	</cfloop>
</cfif>
<cfset droptable()>
