<!--- Archivo    :  futurosabiertosA-sql.cfm
	  --->
	  
<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>

<cfset session.FechaFolio = vFechaI>

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>

<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

<!--- Para desarrollo "sif_interfacesser.." y para produccción "sif_interfaces.."  --->
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfquery datasource="sifinterfaces">
	delete from #sifinterfacesdb#..futurosabiertosPMI where sessionid = #session.monitoreo.sessionid#
	delete from #sifinterfacesdb#..futurosabiertosPMI where fecharegistro < dateadd (dd, -2, getdate())
</cfquery> 

<!---   tablas de trabajo creadas en sif_interfacesser para pruebas y en sif_interfaces para producción
drop table sif_interfaces..futurosabiertosPMI
go
create table sif_interfaces..futurosabiertosPMI (
		fecharegistro   date         null,
		sessionid       numeric      null,
		
		trade_num       integer      null,
		acct_ref_num    char(10)     null,
		acct_num        int          null,
		broker_num      int          null,
		broker_name     varchar(20)  null,
		
		port_num        integer      null,
		port_short_name varchar (15) null,
		mtm_pl          float        null,
		currency_code   char(8)      null,
		venta_realizada bit      not null,
		cobertura_VR_FE char(10)     null, /* porque si corta 'FEB03' a char(2) pareceria 'FE', y no es lo mismo. se pone a 10 para el msg de error */
		
		mensajeerror    varchar(200) null,
		Documento       char(20)     null,
		Modulo          char(10)     null,
		SNid            numeric      null,
		Mcodigo         numeric      null)
--->

<!--- Crea query de futuros abiertos 
Si se tarda mucho, ejecutar lo siguiente en preicts
	update statistics pmi_unrealized_profits
	update statistics pmi_unrealized_profits_detail
	update statistics trade
	update statistics trade_item
	update statistics trade_order
--->
<cfquery datasource="preicts">
	if object_id ('##portafolios') is not null drop table ##portafolios
</cfquery>
<cfquery datasource="preicts">
	<!--- Trae total por portafolio --->
	select 
		det.port_num, rp.currency_code, rp.clr_brkr_num as broker_num, acct.acct_full_name as broker_name,
		max (port_short_name) as port_short_name,
		sum (det.mtm_pl) as mtm_pl,
		(select tgo.tag_option_desc
			from portfolio_tag_option tgo, portfolio_tag pt
			where tgo.tag_name = 'CLASS'
			  and tgo.tag_option = pt.tag_value
			  and pt.port_num = det.port_num
			  and pt.tag_name = 'CLASS' ) as cobertura_VR_FE
	into ##portafolios
	from pmi_unrealized_profits rp
		inner join pmi_unrealized_profits_detail det
			on det.unrealized_profits_num = rp.unrealized_profits_num
		inner join trade_order oo
			on oo.trade_num = det.trade_num
			and oo.order_num = det.order_num
		inner join trade tr <!--- trade del futuro --->
			on tr.trade_num = oo.trade_num
		inner join account acct
			on acct.acct_num = rp.clr_brkr_num
	where rp.market_day = <cfqueryparam cfsqltype="cf_sql_date" value="#vFechaI#">
	  and (rp.market_day IS NOT null)
	  and rp.owner_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
	<!---  and det.mtm_pl <> 0--->
	<!---  and rp.unrealized_profits_amount <> 0 --->
	group by 
		det.port_num, rp.currency_code, rp.clr_brkr_num, acct.acct_full_name
<!---
	insert into ##portafolios values (123456, 'MXN', 227, 'TANGANANICA',   'PORT no EX', 2279)
	insert into ##portafolios values (123456, 'MXN', 48894, 'TANGANANICA', 'PORT SIN LIN', 9987)
	
	select * into #sifinterfacesdb#..tmp_portafolios from ##portafolios
--->
</cfquery>
<cfquery datasource="preicts">
	insert into #sifinterfacesdb#..futurosabiertosPMI (
		fecharegistro, sessionid, Documento,
	    trade_num, acct_ref_num, acct_num, broker_num, broker_name,
		port_num, port_short_name, mtm_pl, currency_code, venta_realizada , cobertura_VR_FE)
	select distinct
		getdate(), #session.monitoreo.sessionid# as sessionid,
			'FU_A#DateFormat(session.FechaFolio,'yyyymm')#-' || convert (varchar, po.broker_num) as Documento,
		to2.trade_num, tr2.acct_ref_num, tr2.acct_num, po.broker_num, po.broker_name,
		po.port_num, po.port_short_name, po.mtm_pl, po.currency_code,
		(
			<!--- DETERMINAR SI LA VENTA ESTA REALIZADA O NO (VR/VNR)--->
			select count(1)
			from allocation_item ai
			where ai.trade_num = to2.trade_num
			<!--- no aplica, sino daría duplicados por order_num o item_num
					y solamente quiero ver si hay alguna venta realizada para este trade_num
			  and ai.order_num = to2.order_num
			  and ai.item_num  = ti.item_num--->
				<!--- p_s_ind = S (*Venta*), P (Compra) --->
			  and ti.p_s_ind = 'S'
			  and ai.title_tran_date is not null
			  and ai.title_tran_date <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#session.FechaFolio#"> 
		) as venta_realizada,
		po.cobertura_VR_FE
	from ##portafolios po
		left join (
			trade_item ti
			join trade tr2 <!--- trade de orden comercial producto --->
				on tr2.trade_num = ti.trade_num
				and trade_status_code != 'DELETE'
			join trade_order to2 <!--- trade de orden comercial producto --->
				on to2.trade_num = tr2.trade_num
				and to2.order_num = ti.order_num
				and order_type_code = 'PHYSICAL' )
			on ti.real_port_num = po.port_num
			and ti.p_s_ind = 'S'
	if object_id ('##portafolios') is not null drop table ##portafolios
</cfquery>

<cfset LvarControlSocio = "">
<cfset LvarControlTipo = "">
<cfset LvarControlDocto = "">
<cfset ArregloProductos = ArrayNew(1)>

<!--- Existencia del Socio de Negocio  --->
<!--- Se cambia la busqueda del SNid se busca el SNid del broker no se necestia el del socio de la orden de producto --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET SNid = a2.SNid
	from #sifinterfacesdb#..futurosabiertosPMI a1, SNegocios a2 
	where a2.Ecodigo = #session.ecodigo#
	  and convert(int,a2.SNcodigoext)  = a1.broker_num <!---a1.acct_num--->
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!--- Moneda es Valida  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET Mcodigo = a2.Mcodigo
	from #sifinterfacesdb#..futurosabiertosPMI a1, Monedas a2 
	where a2.Ecodigo = #session.ecodigo#
	  and a2.Miso4217  = case 
	  						when a1.currency_code = 'MXN' then 'MXP'
						 	else substring(a1.currency_code,1,3)
						 end
	  and a1.sessionid = #session.monitoreo.sessionid#
</cfquery>

<!---- // INICIA NUEVA VALIDACION --->
<!--- verifica que no existe en EContablesImportacion/EContables  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'Registro ya procesado'
	where exists (
		select Ecodigo from EContablesImportacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Edocbase = #sifinterfacesdb#..futurosabiertosPMI.Documento
	)

	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'Registro ya procesado'
	where exists (
		select Ecodigo from EContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Edocbase = #sifinterfacesdb#..futurosabiertosPMI.Documento
	)

	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'Registro ya procesado'
	where exists (
		select Ecodigo from HEContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Edocbase = #sifinterfacesdb#..futurosabiertosPMI.Documento
	)
</cfquery>

<!--- Existencia del Socio de Negocio  --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No existen órdenes comerciales de producto'
	where trade_num is null

	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No se indica el socio'
	where trade_num is not null
	  and acct_num is null
<!---Modificacion para manejar el SNid del Broker ver linea: 160 se cambia acct_num por broker_num  ---> 
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'El socio ' || convert (varchar, acct_num) || ' no existe en SIF'
	where <!---trade_num is not null and ---> 
	  broker_num is not null
	  and SNid is null
</cfquery>

<!--- Moneda es Valida  --->

<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'Moneda ' || currency_code || ' incorrecta'
	where Mcodigo is null
</cfquery>

<!--- portnum es valido  --->

<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No. de portafolio no existe'
	where port_num is null
</cfquery>

<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'Cobertura inválida: "' || cobertura_VR_FE || '" debe ser VR/FE'
	where cobertura_VR_FE not in ('VR', 'FE')
</cfquery>

<!--- validar Tipo de cambio  --->

<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No existe el tipo de cambio'
	where not exists (
		select *
		from Htipocambio tca
			where tca.Mcodigo = #sifinterfacesdb#..futurosabiertosPMI.Mcodigo
			and tca.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#vFechaI#"> )
</cfquery>

<!--- validar complemento financiero de socio de negocio    --->
<!--- Se cambia acct_num por broker_num ver linea: 160 --->
<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No hay complemento para el socio ' || convert (varchar, broker_num)
	where SNid is not null
	  and not exists (
		select Ecodigo from SNegocios sn
		where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and sn.SNid = #sifinterfacesdb#..futurosabiertosPMI.SNid
		  and sn.cuentac is not null
		  and datalength(sn.cuentac) > 1
	)
</cfquery>

<cfquery datasource="#session.dsn#">
	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No existe el broker ' || convert (varchar, broker_num) || ' como socio'
	where not exists (
		select Ecodigo from SNegocios sn
		where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and sn.SNcodigoext = convert(varchar, #sifinterfacesdb#..futurosabiertosPMI.broker_num)
	)

	UPDATE #sifinterfacesdb#..futurosabiertosPMI SET mensajeerror = mensajeerror || case when mensajeerror is null then null else '$$' end ||
		'No ha definido la cuenta de ' ||
			case when mtm_pl < 0 then 'CxP' else 'CxC' end
				|| '  para el broker ' || convert (varchar, broker_num) || ' ' || broker_name
	where exists (
		select Ecodigo from SNegocios sn
		where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and sn.SNcodigoext = convert(varchar, #sifinterfacesdb#..futurosabiertosPMI.broker_num)
		  and (sn.SNcuentacxp is null and #sifinterfacesdb#..futurosabiertosPMI.mtm_pl <  0
			or sn.SNcuentacxc is null and #sifinterfacesdb#..futurosabiertosPMI.mtm_pl >= 0 )
	)
</cfquery>
<!---- // FIN VALIDACION --->
