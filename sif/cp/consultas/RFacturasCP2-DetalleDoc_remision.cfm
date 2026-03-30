<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_PolSinApl = t.Translate('LB_PolSinApl','Poliza sin aplicar')>
<cfset LB_PolApl 	= t.Translate('LB_PolApl','Poliza aplicada')>
<cfset Lbl_Art		= t.Translate('Lbl_Art','Artículo')>
<cfset Lbl_Serv		= t.Translate('Lbl_Serv','Servicio')>

<cfif not isdefined("url.pop")>
	<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
		<cfset form.SNcodigo = url.SNcodigo>
	</cfif>
	<cfif isdefined("url.fechaini") and not isdefined("form.fechaini")>
		<cfset form.fechaini = url.fechaini>
	</cfif>
	<cfif isdefined("url.fechafin") and not isdefined("form.fechafin")>
		<cfset form.fechafin = url.fechafin>
	</cfif>

	<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
		<cfset form.Ddocumento = url.Ddocumento>
	</cfif>

	<cfif isdefined("url.drdocumento") and not isdefined("form.drdocumento")>
		<cfset form.drdocumento = url.drdocumento>
	</cfif>

	<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
		<cfset form.tipo = url.tipo>
	</cfif>

	<cfif isdefined("url.cptrcodigo") and not isdefined("form.cptrcodigo")>
		<cfset form.cptrcodigo = url.cptrcodigo>
	</cfif>
	<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
		<cfset form.IDdocumento = url.IDdocumento>
	</cfif>

	<cfif isdefined("url.fSNnumero") and not isdefined("form.fSNnumero")>
		<cfset form.SNnumero = url.fSNnumero>
	</cfif>
    <cfif isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
		<cfset form.SNnumero = url.SNnumero>
	</cfif>
    <cfif isdefined("url.FTimbre") and not isdefined("form.FTimbre")>
		<cfset form.FTimbre = url.FTimbre>
	</cfif>
<cfelse>
	<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
		<cfset form.SNcodigo = url.SNcodigo>
	</cfif>
	<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
		<cfset form.IDdocumento = url.IDdocumento>
	</cfif>
	<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
		<cfset form.Ddocumento = url.Ddocumento>
	</cfif>
	<cfif isdefined("url.CPTcodigo") >
		<cfset form.tipo = url.CPTcodigo>
	</cfif>
	<cfquery name="EDocumentosCPR" datasource="#session.DSN#">
	 select IDdocumento from EDocumentosCPR
	  where  Ecodigo = #Session.Ecodigo#
  		and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
  		and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">
  		and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
	<cfset form.IDdocumento = EDocumentosCPR.IDdocumento>
	<cfset form.drdocumento = -1>
	<cfset form.cptrcodigo = -1>
	<cfset form.SNnumero = -1>
	<cfset form.fechaini = "">
	<cfset form.fechafin ="">
</cfif>

<cfquery name="rsTipoTran1" datasource="#session.DSN#">
	select CPTtipo
	from CPTransacciones
	where Ecodigo = #session.Ecodigo#
	and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
</cfquery>

<cfquery name="rsDoc" datasource="#session.DSN#">
	select
	cfi.CFformato,
	d.SNcodigo,
	d.CPTcodigo,
	d.Ecodigo,
	d.EDdocumento as Ddocumento,
	d.Rcodigo,
	dato.Pnombre #_Cat# ' ' #_Cat# dato.Papellido1 #_Cat# ' ' #_Cat# dato.Papellido2 as nombre,
	d.EDtipocambio as Dtipocambio,
	cfi.CFdescripcion,
	cfi.CFcuenta,
	rt.Rdescripcion,
	rt.Rporcentaje,
    coalesce (ee.Cconcepto, he.Cconcepto) 						as Cconcepto,
	coalesce (ee.Edocumento, he.Edocumento, d.IDcontable ) 	as Asiento,
    coalesce (ee.Eperiodo, he.Eperiodo) 			as Eperiodo,
    coalesce (ee.Emes, he.Emes) 						as Emes,
	case
		when ee.Edocumento is not null then '#LB_PolSinApl#'
		when he.Edocumento is not null then '#LB_PolApl#'
		else 'IDcontable'
	end															as TipoAsiento,
	(
		select round(sum (dos.DDtotallinea),2)
		from DDocumentosCPR dos
		where dos.IDdocumento = d.IDdocumento
	) as subtotal,
	d.EDtotal - coalesce((
		select round(sum (dos.DDtotallinea),2)
		from DDocumentosCPR dos
		where dos.IDdocumento = d.IDdocumento), 0.00
        ) as impuesto,
	d.IDdocumento as IDdocumento,
	d.CPTcodigo as tipo,
	d.CPTcodigo,
	d.EDdocumento,
	null as DRdocumento,
	s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre,
	EDvencimiento, 0 as EDsaldo,
	d.EDfecha as Dfecha, d.EDvencimiento  as DFechavenc, s.Mcodigo , d.EDtotal as Monto , 
    0.00 as Dsaldo, o.Oficodigo,
	d.Ccuenta , m.Miso4217 as moneda,
	e.Edescripcion as Empresa
	from EDocumentosCPR d
		left join Usuario usu
		on usu.Usulogin  = d.EDusuario
		left join DatosPersonales dato
		on usu.datos_personales = dato.datos_personales
		left outer join CFinanciera cfi
		on cfi.Ccuenta = d.Ccuenta
		left outer   join Retenciones rt
		on rt.Rcodigo = d.Rcodigo
		and rt.Ecodigo = d.Ecodigo
		inner join SNegocios s
		on s.SNcodigo = d.SNcodigo
		and s.Ecodigo = d.Ecodigo
		inner join CPTransacciones t
		on t.CPTcodigo = d.CPTcodigo
		and t.Ecodigo  = d.Ecodigo
		--left outer join BMovimientosCxP ma
		left outer join EContables ee
		on ee.IDcontable = d.IDcontable
		left outer join HEContables he
		on he.IDcontable = d.IDcontable
		--on ma.SNcodigo = d.SNcodigo
		--and ma.Ecodigo = d.Ecodigo
		--and ma.CPTcodigo = d.CPTcodigo
		--and ma.Ddocumento = d.EDdocumento
		--and ma.CPTRcodigo = d.CPTcodigo
		--and ma.DRdocumento = d.EDdocumento
		left outer join Oficinas o
		on o.Ecodigo = d.Ecodigo
		and o.Ocodigo = d.Ocodigo
		left outer join Monedas m
		on m.Mcodigo = d.Mcodigo
		inner join Empresas e
        on e.Ecodigo = d.Ecodigo
		where d.SNcodigo = #form.SNcodigo#
		and d.EDdocumento = '#trim(form.Ddocumento)#'
		and d.CPTcodigo = '#form.tipo#'
		and d.Ecodigo = #session.Ecodigo#
</cfquery>
      
<cfif NOT rsDoc.recordCount>
	<cfset MSG_NoReqDoc = t.Translate('MSG_NoReqDoc','NO SE PUDO RECUPERAR EL DOCUMENTO')>
	<cfdump var="#rsDoc#" abort>
    <cfthrow message="#MSG_NoReqDoc#">
</cfif>

<cfquery name="rsRetencion" datasource="#session.dsn#">
	select 	coalesce(r.Rporcentaje,0) / 100.0 *
		coalesce((
			select sum(DDtotallinea)
				from DDocumentosCPR d
				inner join Impuestos i
			    on i.Ecodigo = d.Ecodigo
				and i.Icodigo = d.Icodigo
				where d.IDdocumento = e.IDdocumento
				and i.InoRetencion = 0
		),0.00) + coalesce(e.EDretencionVariable,0) as Monto
		from EDocumentosCPR e
		left join Retenciones r
		on r.Ecodigo = e.Ecodigo
	    and r.Rcodigo = e.Rcodigo
		where e.SNcodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDoc.SNcodigo#">
        and e.EDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDoc.Ddocumento#">
        and e.CPTcodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDoc.CPTcodigo#">
        and e.Ecodigo    = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDoc.Ecodigo#">
</cfquery>

<cfquery name="rsSeguimiento" datasource="#session.dsn#">
    select 
    EDusuario as Usulogin,
    (case when EVestado = 0 then 'Creado' 
    when EVestado = 1 then 'Aplicado'
    when EVestado = 2 then 'Cancelado'
    end) as FTdescripcion,
                EDfecha as BMfecha,
                IDdocumento as EVfactura,
                EVestado,
                EDdocumento as EVObservacion
    from EDocumentosCPR a
    where a.SNcodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDoc.SNcodigo#">
		  and a.EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.Ddocumento#">
		  and a.CPTcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.CPTcodigo#">
		  and a.Ecodigo     = #session.Ecodigo#
</cfquery>

<cfquery name="rsDetDoc" datasource="#session.DSN#">
	select  cfi.CFdescripcion, cfi.CFformato, hdd.DDcantidad as cantidad, hdd.DDpreciou as preciou, 
        hdd.DDtotallinea as total, case when  hdd.DDtipo = 'A' then '#Lbl_Art#'  else '#Lbl_Serv#' end  as tipo,
	    <cf_dbfunction name="sPart" args="hdd.DDdescalterna,1,20"> as descItem, 
        e.Edescripcion as Empresa
	    from EDocumentosCPR hd
		inner join DDocumentosCPR hdd
  		on hd.IDdocumento = hdd.IDdocumento
		left outer join CFinanciera cfi
		on cfi.CFcuenta = hdd.CFcuenta
        inner join Empresas e
        on e.Ecodigo = hdd.Ecodigo
		Where hd.Ecodigo = #Session.Ecodigo#
		and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">

</cfquery>

<!--- Buscar asociaciones con la remision : 
    1.- ordenes de compra
    2.- documentos de cuentas por pagar
    3.- notas de credito
---->
<cfquery name="rsHistorialOrdenCompra" datasource="#session.DSN#">
    select 
    subq.CFdescripcion, subq.CFformato, subq.Fecha, subq.CPTcodigo,
    subq.Documento, subq.Miso4217, subq.Aplicado
    from (select distinct eo.EOidorden,
    cfi.CFdescripcion, cfi.CFformato, eo.EOfecha as Fecha , eo.CMTOcodigo as CPTcodigo, eo.Observaciones as Documento, m.Miso4217,
                    coalesce(eo.EOtotal, 0.00) as Aplicado
    from DDocumentosCPR dd
    inner join DOrdenCM do on
    dd.Linea = do.DRemisionlinea
    inner join EDocumentosCPR d
    on d.IDdocumento = dd.IDdocumento
    inner join EOrdenCM eo
    on do.EOidorden = eo.EOidorden
    left outer join CFinanciera cfi
    on cfi.Ccuenta = d.Ccuenta
    inner join Monedas m
    on m.Mcodigo = d.Mcodigo
    and m.Ecodigo = d.Ecodigo
    inner join CPTransacciones cpt
    on cpt.Ecodigo   = d.Ecodigo
    and cpt.CPTcodigo = d.CPTcodigo
    where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">) subq
    order by subq.EOidorden asc
</cfquery>

<cfquery name="rsHistorialDocumentos" datasource="#session.DSN#">
    select 
    subq.CFdescripcion, subq.CFformato, subq.Fecha, subq.CPTcodigo,
    subq.Documento, subq.Miso4217, subq.Aplicado
    from (select distinct dx.IDdocumento,
    cfi.CFdescripcion, cfi.CFformato, dx.EDfecha as Fecha , dx.CPTcodigo as CPTcodigo, dx.EDdocumento as Documento, m.Miso4217,
                    coalesce(dx.EDtotal, 0.00) as Aplicado
    from DDocumentosCPR dd
    inner join DDocumentosCxP ddx
    on dd.DFacturalinea = ddx.Linea
    inner join EDocumentosCPR d
    on d.IDdocumento = dd.IDdocumento
    inner join EDocumentosCxP dx
    on ddx.IDdocumento = dx.IDdocumento
    left outer join CFinanciera cfi
    on cfi.Ccuenta = d.Ccuenta
    inner join Monedas m
    on m.Mcodigo = d.Mcodigo
    and m.Ecodigo = d.Ecodigo
    inner join CPTransacciones cpt
    on cpt.Ecodigo   = d.Ecodigo
    and cpt.CPTcodigo = d.CPTcodigo
    where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">) subq
    order by subq.IDdocumento asc
</cfquery>

<cfset LvarSaldoActual = 0.00>
<cfset Lbl_DetDoct	= t.Translate('Lbl_DetDoct','Detalle del Documento')>
<cfset Lbl_DatDoct	= t.Translate('Lbl_DatDoct','Datos del Documento')>
<cfset Lbl_Socio	= t.Translate('Lbl_Socio','Socio')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset Lbl_Ident	= t.Translate('Lbl_Ident','Identificaci&oacute;n')>
<cfset LB_Venc 	= t.Translate('LB_Venc','Vencimiento')>
<cfset LB_TpoTrans = t.Translate('LB_TpoTrans','Tipo Transacci&oacute;n')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Impuesto 	= t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_DigPor 	= t.Translate('LB_DigPor','Digitado por')>
<cfset LB_Tipo_de_Cambio 	= t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset LB_Retenc 	= t.Translate('LB_Retenc','Retenci&oacute;n')>
<cfset LB_TpoPorReq	= t.Translate('LB_TpoPorReq','Tipo - Porcentaje Requisici&oacute;n')>
<cfset LB_EMPRESA = t.Translate('LB_EMPRESA','Empresa','/sif/generales.xml')>
<cfset LB_PerCont	= t.Translate('LB_PerCont','Peri&oacute;do Contable')>
<cfset LB_Timbre	= t.Translate('LB_Timbre','Timbre Fiscal')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset MSG_DetLinea = t.Translate('MSG_DetLinea','Detalles de L&iacute;nea(s) del Documento')>
<cfset MSG_HistPag = t.Translate('MSG_HistPag','Historial de Pagos/Aplicaciones')>
<cfset Lbl_Cantidad	= t.Translate('Lbl_Cantidad','Cantidad')>
<cfset Lbl_PrecioU	= t.Translate('Lbl_PrecioU','Precio Unitario')>
<cfset Lbl_DescItem	= t.Translate('Lbl_DescItem','Desc Item')>
<cfset Lbl_TotLinea	= t.Translate('Lbl_TotLinea','Total Linea')>
<cfset LB_CtaFin 	= t.Translate('LB_CtaFin','Cuenta Financiera')>
<cfset LB_CtaPrv 	= t.Translate('LB_CtaPrv','Cuenta Proveedor')>
<cfset Lbl_Empresa	= t.Translate('Lbl_Empresa','Empresa')>
<cfset Lbl_FinDet	= t.Translate('Lbl_FinDet','Fin de Detalle')>
<cfset Lbl_FecPago	= t.Translate('Lbl_FecPago','Fecha Pago')>
<cfset LB_Tipo 		= t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset Lbl_NumPag	= t.Translate('Lbl_NumPag','Num. Pago')>
<cfset Lbl_FinHist	= t.Translate('Lbl_FinDet','Fin de Historial')>
<cfset Lbl_SegFact	= t.Translate('Lbl_SegFact','Seguimiento de Factura')>
<cfset LB_Estado 	= t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset Lbl_Obser	= t.Translate('Lbl_Obser','Observaci&oacute;n')>
<cfset LB_Usuario 	= t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset Lbl_Asiento	= t.Translate('Lbl_Asiento','Asiento')>
<cfset Msg_DetLin	= t.Translate('Msg_DetLin','Detalles de L&iacute;nea(s) del Documento')>
<cfset Msg_HistPgo	= t.Translate('Msg_HistPgo','Historial de Pagos/Aplicaciones')>
<cfset BTN_Regresar = t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>

<cfif not isdefined("url.pop")>
    <cf_templateheader title="SIF - Cuentas por Pagar">
    <cf_templatecss>
    <cfoutput>
        <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Lbl_DetDoct#">
    </cfoutput>
    <form name="form1" method="url" action="RFacturasCP2.cfm">
        <table width="100%" cellpadding="2" cellspacing="0" align="center">
            <tr>
                <td valign="top" width="50%">
                    <cfset regresar="/cfmx/sif/cp/consultas/RFacturasCP2.cfm">
                    <cfinclude template="/sif/portlets/pNavegacionCP.cfm">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                        <tr>
                            <td>&nbsp;</td>
                            <td colspan="8" align="right">
                                <cfparam name="form.FechaIni" default="">
                                <cfparam name="form.FechaFin" default="">
                                <cfset params=''>
                                <cfset params="&SNcodigo=#form.SNcodigo#&FechaIni=#form.FechaIni#&FechaFin=#form.FechaFin#&Ddocumento=#form.Ddocumento#">
                                <cfset params = params & '&fSNcodigo=#form.SNcodigo#&fSNnumero=#form.SNnumero#'>
                                <cfif isdefined( "form.CPTcodigo")>
                                <cfset params=params & '&CPTcodigo=#form.CPTcodigo#'>
                                </cfif>
                                <cf_rhimprime datos="/sif/cp/consultas/RFacturasCP2-DetalleDoc_remision.cfm" paramsuri="#params#">
                                <iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="10" class="tituloListas">
                                <strong>
                                    <cfoutput>&nbsp;#Lbl_DatDoct#</cfoutput>
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="10" bgcolor="CCCCCC">
                                <span style="font-size: 18px">
                                    <cfoutput>&nbsp;N&deg; Doc: #rsDoc.Ddocumento#</cfoutput>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <cfoutput>
                                    <table width="80%" border="0" cellspacing="1" cellpadding="0" align="center">
                                        <tr>
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><strong>Informaci&oacute;n Contable</strong></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="">
                                                <hr class="tituloLista">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#rsDoc.TipoAsiento#:&nbsp;</strong></td>
                                            <td>#rsDoc.Cconcepto# - #rsDoc.Asiento#</td>
                                            <td align="right" nowrap="nowrap">
                                                <cfif len(trim(rsDoc.Eperiodo)) and (rsDoc.TipoAsiento eq 'Poliza aplicada' or rsDoc.TipoAsiento eq 'IDcontable')><strong>#LB_PerCont#:&nbsp;</strong>
                                                <cfelse>
                                                &nbsp;</cfif>
                                            </td>
                                            <td>
                                                <cfif len(trim(rsDoc.Eperiodo)) and (rsDoc.TipoAsiento eq 'Poliza aplicada' or rsDoc.TipoAsiento eq 'IDcontable')>#rsDoc.Eperiodo#/#rsDoc.Emes#
                                                <cfelse>
                                                &nbsp;</cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td align="right" nowrap="nowrap"><strong>#LB_Timbre#:&nbsp;</strong></td>
                                            <td>-</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><strong>Informaci&oacute;n del Socio de Negocios</strong></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="">
                                                <hr class="tituloLista">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#Lbl_Socio#:&nbsp;</strong></td>
                                            <td nowrap="nowrap">#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
                                            <td align="right"><strong>#Lbl_Ident#:&nbsp;</strong></td>
                                            <td>#rsDoc.SNidentificacion#</td>
                                        </tr>
                                        <tr>
                                            <td align="right" nowrap="nowrap"><strong>#LB_CtaPrv#:</strong></td>
                                            <td colspan="3" align="left">#rsDoc.CFformato# - #rsDoc.CFdescripcion#</td>
                                        </tr>
                                        </tr>
                                        <tr>
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><strong>Informaci&oacute;n del Documento</strong></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="">
                                                <hr class="tituloLista">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
                                            <td>#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
                                            <td align="right"><strong>#LB_Venc#:&nbsp;</strong></td>
                                            <td>#LSDateformat(rsDoc.Dfechavenc,"dd/mm/yyyy")# </td>
                                        </tr>
                                        <tr>
                                            <td align="right" nowrap="nowrap"><strong>#LB_TpoTrans#:&nbsp;</strong></td>
                                            <td>#rsDoc.Tipo#</td>
                                            <td align="right"><strong>#LB_Oficina#:&nbsp;</strong></td>
                                            <td>#rsDoc.Oficodigo#</td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#LB_DigPor#:&nbsp;</strong></td>
                                            <td nowrap="nowrap">#rsDoc.nombre#&nbsp;</td>
                                            <td align="right" valign="top" nowrap="nowrap"><strong>#LB_EMPRESA#:&nbsp;</strong></td>
                                            <td nowrap="nowrap" valign="top">#trim(rsDoc.Empresa)#</td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>
                                            <td>#rsDoc.Moneda#</td>
                                            <td align="right" nowrap="nowrap"><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
                                            <td>#rsDoc.Dtipocambio#</td>
                                        </tr>
                                        <tr>
                                            <td align="right"><strong>#LB_Retenc#:&nbsp;</strong></td>
                                            <td>
                                                <cfif len(trim(rsDoc.Rcodigo))>Si
                                                <cfelse>
                                                No</cfif>
                                            </td>
                                            <td align="right" nowrap="nowrap"><strong>#LB_TpoPorReq#:&nbsp;</strong></td>
                                            <td nowrap="nowrap"> #rsDoc.Rdescripcion# - #rsDoc.Rporcentaje# <strong>Total:</strong>(#numberFormat(rsRetencion.Monto,",9.99")#)</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td align="right"><strong>#LB_Subtotal#:&nbsp;</strong></td>
                                            <td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td align="right"><strong>#LB_Impuesto#:&nbsp;</strong></td>
                                            <td>#LScurrencyFormat(rsDoc.impuesto,"none")#</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td align="right"><strong>#LB_Monto#:&nbsp;</strong></td>
                                            <td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                            <td align="right"><strong>#LB_Saldo#:&nbsp;</strong></td>
                                            <td>#LScurrencyFormat(LvarSaldoActual,"none")#</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <cfset saldo=rsDoc.EDsaldo>
                                    <cfset listaSNnumero=ListtoArray(form.SNnumero)>
                                    <cfset listaSNcodigo=ListtoArray(form.SNcodigo)>
                                    <cfif ArrayLen(listaSNnumero) GT 1>
                                    <input name="SNnumero" type="hidden" value="#listaSNnumero[1]#">
                                    <input name="SNcodigo" type="hidden" value="#listaSNcodigo[1]#">
                                    </cfif>
                                </cfoutput>
                            </td>
                        </tr>
                    </table>
                    <!--- TABLAS DE DETALLES Y ASOCIACIONES --->
                    <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
                        <tr>
                            <cfoutput>
                                <td class="tituloListas" style="border-bottom: 1px solid black;"><strong>#MSG_DetLinea#</strong></td>
                            </cfoutput>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <cfoutput>
                                        <tr>
                                            <td nowrap align="center"><strong>#Lbl_Cantidad#</strong></td>
                                            <td nowrap><strong>&nbsp;#Lbl_DescItem#</strong></td>
                                            <td nowrap align="left"><strong>&nbsp;#LB_CtaFin#</strong></td>
                                            <td nowrap align="left"><strong>&nbsp;#Lbl_Empresa#</strong></td>
                                            <td nowrap align="right"><strong>&nbsp;#Lbl_PrecioU#</strong></td>
                                            <td nowrap align="right"><strong>&nbsp;#Lbl_TotLinea#</strong></td>
                                        </tr>
                                    </cfoutput>
                                    <cfoutput query="rsDetDoc">
                                        <tr class="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td align="center">&nbsp;#rsDetDoc.cantidad#</td>
                                            <td nowrap>&nbsp;#rsDetDoc.descItem# (#rsDetDoc.tipo#)</td>
                                            <td nowrap align="left">&nbsp;(#rsDetDoc.CFformato# - #rsDetDoc.CFdescripcion#)</td>
                                            <td align="right" nowrap="nowrap">&nbsp;#rsDetDoc.Empresa#</td>
                                            <td align="right">&nbsp;#LvarOBJ_PrecioU.enCF_RPT(rsDetDoc.preciou)#&nbsp;&nbsp;</td>
                                            <td align="right">&nbsp;#LScurrencyFormat(rsDetDoc.total,"none")#</td>
                                        </tr>
                                    </cfoutput>
                                    <td colspan="6" nowrap align="center">
                                        <cfoutput>***** #Lbl_FinDet# *****</cfoutput>
                                    </td>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp</td>
                        </tr>
                        <tr>
                            <cfoutput>
                                <td class="tituloListas" style="border-bottom: 1px solid black;"><strong>#MSG_HistPag#</strong></td>
                            </cfoutput>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <cfoutput>
                                            <td nowrap><strong>&nbsp;#Lbl_FecPago#</strong></td>
                                            <td nowrap><strong>&nbsp;#LB_Tipo#</strong></td>
                                            <td nowrap><strong>&nbsp;#Lbl_NumPag#</strong></td>
                                            <td nowrap align="right"><strong>&nbsp;#LB_Monto#</strong></td>
                                            <td nowrap align="right"><strong>&nbsp;#LB_Saldo#</strong></td>
                                            <td nowrap align="left"><strong>&nbsp;#LB_CtaFin#</strong></td>
                                        </cfoutput>
                                    </tr>
                                    <cfset nuevoSaldo=saldo>
                                    <cfset nuevoSaldo=rsDoc.Monto>
                                    <cfoutput query="rsHistorialOrdenCompra">
                                        <tr class="<cfif rsHistorialOrdenCompra.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td nowrap>#LSDateformat(rsHistorialOrdenCompra.Fecha,"dd/mm/yyyy")#</td>
                                            <td nowrap>#rsHistorialOrdenCompra.CPTcodigo#</td>
                                            <td nowrap>#rsHistorialOrdenCompra.Documento#</td>
                                            <td nowrap align="right">#LScurrencyFormat(abs(rsHistorialOrdenCompra.Aplicado),"none")# </td>
                                            <td nowrap align="right">
                                                #LScurrencyFormat(0,"none")#
                                                <!---#LScurrencyFormat(nuevoSaldo + rsHistorialOrdenCompra.Aplicado,"none")#
                                                <cfset nuevoSaldo=nuevoSaldo + rsHistorialOrdenCompra.Aplicado>--->
                                            </td>
                                            <td align="right" nowrap="nowrap">&nbsp;(#rsHistorialOrdenCompra.CFformato# - #rsHistorialOrdenCompra.CFdescripcion#)</td>
                                        </tr>
                                    </cfoutput>
                                    <cfoutput query="rsHistorialDocumentos">
                                        <tr class="<cfif rsHistorialDocumentos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td nowrap>#LSDateformat(rsHistorialDocumentos.Fecha,"dd/mm/yyyy")#</td>
                                            <td nowrap>#rsHistorialDocumentos.CPTcodigo#</td>
                                            <td nowrap>#rsHistorialDocumentos.Documento#</td>
                                            <td nowrap align="right">#LScurrencyFormat(abs(rsHistorialDocumentos.Aplicado),"none")# </td>
                                            <td nowrap align="right">
                                                #LScurrencyFormat(0,"none")#
                                                <!---#LScurrencyFormat(nuevoSaldo + rsHistorialDocumentos.Aplicado,"none")#
                                                <cfset nuevoSaldo=nuevoSaldo + rsHistorialDocumentos.Aplicado>--->
                                            </td>
                                            <td align="right" nowrap="nowrap">&nbsp;(#rsHistorialDocumentos.CFformato# - #rsHistorialDocumentos.CFdescripcion#)</td>
                                        </tr>
                                    </cfoutput>
                                    <tr>
                                        <td colspan="6" nowrap align="center">
                                            <cfoutput>***** #Lbl_FinHist# *****</cfoutput>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="tituloListas" style="border-bottom: 1px solid black;" align="center">
                                <strong>
                                    <cfoutput>#Lbl_SegFact#:</cfoutput>
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td width="50%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <cfoutput>
                                            <td nowrap align="left"><strong>#LB_Estado#</strong></td>
                                            <td nowrap align="left"><strong>#Lbl_Obser#</strong></td>
                                            <td nowrap align="left"><strong>#LB_Fecha#</strong></td>
                                            <td nowrap align="left"><strong>#LB_Usuario#</strong></td>
                                        </cfoutput>
                                    </tr>
                                    <cfoutput query="rsSeguimiento">
                                        <tr class="<cfif rsSeguimiento.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td align="left">#rsSeguimiento.FTdescripcion#</td>
                                            <td align="left"> #rsSeguimiento.EVObservacion#</td>
                                            <td align="left">#DateFormat(rsSeguimiento.BMfecha,'DD/MM/YYYY')#</td>
                                            <td align="left">#rsSeguimiento.Usulogin#</td>
                                        </tr>
                                    </cfoutput>
                                    <td colspan="4" nowrap align="center">
                                        <cfoutput>***** #Lbl_FinDet# *****</cfoutput>
                                    </td>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <input type="submit" value=
                    <cfoutput>"&lt;&lt; #BTN_Regresar#"</cfoutput>
                    name="btnConsultar" onclick="javascript: document.form1.action='RFacturasCP2-reporte.cfm' ">
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <cfoutput>
			<input type="hidden" name="CPTcodigo" value="<cfif isdefined('form.CPTcodigo')>#form.CPTcodigo#</cfif>" />
			<input type="hidden" name="Documento" value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>" />
			<input type="hidden" name="FechaFin" value="<cfif isdefined('form.FechaFin')>#form.FechaFin#</cfif>" />
			<input type="hidden" name="FechaIni" value="<cfif isdefined('form.FechaIni')>#form.FechaIni#</cfif>" />
			<input type="hidden" name="fSNcodigo" value="<cfif isdefined('form.fSNcodigo')>#form.fSNcodigo#</cfif>" />
			<input type="hidden" name="fSNnumero" value="<cfif isdefined('form.fSNnumero')>#form.fSNnumero#</cfif>" />
			<input type="hidden" name="FTimbre" value="<cfif isdefined('form.FTimbre')>#form.FTimbre#</cfif>" />
			<input type="hidden" name="btnConsultar" value="Consultar" />
		</cfoutput>
    </form>
    <cf_web_portlet_end>
	<cf_templatefooter>
<cfelse>
    <title><cfoutput>#Lbl_DetDoct#</cfoutput></title>
	<cf_templatecss>
    <fieldset><legend><cfoutput>#Lbl_DetDoct#</cfoutput></legend>
        <table width="100%" cellpadding="2" cellspacing="0" align="center">
            <tr>
                <td valign="top" width="50%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="4" class="tituloListas"><strong><cfoutput>&nbsp;#Lbl_DatDoct#</cfoutput></strong></td></tr>
						<tr><td colspan="4"  bgcolor="CCCCCC"><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDoc.Ddocumento#</cfoutput></span></td></tr>
						<tr>
							<td colspan="2" align="center">
								<cfoutput>
									<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
											<td align="right"><strong>#Lbl_Socio#:&nbsp;</strong></td>
											<td >#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
											<td align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
											<td>#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
										</tr>
										<tr>
											<td align="right"><strong>#Lbl_Ident#:&nbsp;</strong></td>
											<td>#rsDoc.SNidentificacion#</td>
											<td align="right"><strong>#LB_Venc#:&nbsp;</strong></td>
											<td>#LSDateformat(rsDoc.Dfechavenc,"dd/mm/yyyy")# </td>
										</tr>
										<tr>
											<td align="right"><strong>#LB_TpoTrans#:&nbsp;</strong></td>
											<td>#rsDoc.Tipo#</td>
											<td align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>
											<td>#rsDoc.Moneda#</td>
										</tr>
										<tr>
											<td align="right"><strong>#LB_Oficina#:&nbsp;</strong></td>
											<td>#rsDoc.Oficodigo#</td>
											<td align="right"><strong>#LB_Subtotal#:&nbsp;</strong></td>
											<td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td align="right"><strong>#Lbl_Asiento#:&nbsp;</strong></td>
											<td>#rsDoc.Cconcepto# - #rsDoc.Asiento#</td>
											<td align="right"><strong>Impuesto:&nbsp;</strong></td>
											<td>#LScurrencyFormat(rsDoc.impuesto,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td align="right"><strong>#LB_Monto#:&nbsp;</strong></td>
											<td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>

										<tr><td colspan="4">&nbsp;</td></tr>
										<tr><td colspan="4">&nbsp;</td></tr>
									</table>
									<cfset saldo = rsDoc.EDsaldo>
								</cfoutput>
							</td>
						</tr>
					</table>
                    <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
                        <cfoutput>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#Msg_DetLin#</strong></td>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#Msg_HistPgo#</strong></td>
						</cfoutput>
                        </tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
                                    	<cfoutput>
										<td nowrap align="center"><strong>#Lbl_Cantidad#</strong></td>
										<td nowrap><strong>#Lbl_DescItem#</strong></td>
										<td nowrap align="right"><strong>#Lbl_PrecioU#</strong></td>
										<td nowrap align="right"><strong>#Lbl_TotLinea#</strong></td>
										<td nowrap align="right"><strong>#LB_CtaFin#</strong></td>
                                        </cfoutput>
									</tr>
									<cfoutput query="rsDetDoc">
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<td align="center">#rsDetDoc.cantidad#</td>
											<td> &nbsp;#rsDetDoc.descItem# (#rsDetDoc.tipo#)</td>
											<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDetDoc.preciou)# &nbsp;&nbsp;</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
											<td align="right" nowrap="nowrap">(#rsDetDoc.CFformato# - #rsDetDoc.CFdescripcion#)</td>
										</tr>
									</cfoutput>
									<td colspan="4" nowrap align="center"><cfoutput>***** #Lbl_FinDet# *****</cfoutput></td>
							  </table>
							</td>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
                                    	<cfoutput>
									  	<td nowrap><strong>&nbsp;#Lbl_FecPago#</strong></td>
										<td nowrap><strong>&nbsp;#LB_Tipo#</strong></td>
										<td nowrap ><strong>&nbsp;#Lbl_NumPag#</strong></td>
										<td nowrap align="right"><strong>&nbsp;#LB_Monto#</strong></td>
										<td nowrap align="right"><strong>&nbsp;#LB_Saldo#</strong></td>
										<td nowrap align="right"><strong>&nbsp;#LB_CtaFin#</strong></td>
                                    	</cfoutput>
									</tr>
									<cfset nuevoSaldo = saldo>
									<cfset nuevoSaldo = rsDoc.Monto>
									<cfoutput query="rsHistorialOrdenCompra">
                                        <tr class="<cfif rsHistorialOrdenCompra.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td nowrap>#LSDateformat(rsHistorialOrdenCompra.Fecha,"dd/mm/yyyy")#</td>
                                            <td nowrap>#rsHistorialOrdenCompra.CPTcodigo#</td>
                                            <td nowrap>#rsHistorialOrdenCompra.Documento#</td>
                                            <td nowrap align="right">#LScurrencyFormat(abs(rsHistorialOrdenCompra.Aplicado),"none")# </td>
                                            <td nowrap align="right">
                                                #LScurrencyFormat(0,"none")#
                                                <!---#LScurrencyFormat(nuevoSaldo + rsHistorialOrdenCompra.Aplicado,"none")#
                                                <cfset nuevoSaldo=nuevoSaldo + rsHistorialOrdenCompra.Aplicado>--->
                                            </td>
                                            <td align="right" nowrap="nowrap">&nbsp;(#rsHistorialOrdenCompra.CFformato# - #rsHistorialOrdenCompra.CFdescripcion#)</td>
                                        </tr>
                                    </cfoutput>
                                    <cfoutput query="rsHistorialDocumentos">
                                        <tr class="<cfif rsHistorialDocumentos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
                                            <td nowrap>#LSDateformat(rsHistorialDocumentos.Fecha,"dd/mm/yyyy")#</td>
                                            <td nowrap>#rsHistorialDocumentos.CPTcodigo#</td>
                                            <td nowrap>#rsHistorialDocumentos.Documento#</td>
                                            <td nowrap align="right">#LScurrencyFormat(abs(rsHistorialDocumentos.Aplicado),"none")# </td>
                                            <td nowrap align="right">
                                                #LScurrencyFormat(0,"none")#
                                                <!---#LScurrencyFormat(nuevoSaldo + rsHistorialDocumentos.Aplicado,"none")#
                                                <cfset nuevoSaldo=nuevoSaldo + rsHistorialDocumentos.Aplicado>--->
                                            </td>
                                            <td align="right" nowrap="nowrap">&nbsp;(#rsHistorialDocumentos.CFformato# - #rsHistorialDocumentos.CFdescripcion#)</td>
                                        </tr>
                                    </cfoutput>
									<tr><td colspan="5" nowrap align="center"><cfoutput>***** #Lbl_FinHist# *****</cfoutput></td></tr>
								</table>
							</td>
						</tr>
					</table>
                </td>
            </tr>
            <tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
        </table>
    </fieldset>
</cfif>

<script type="text/javascript" language="javascript">
	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function InfCFDI(IDContable,Dlinea,IdRep) {
		var left = 110;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 50;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEInfoCFDI.cfm?info=1&IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep, left+'px', top+'px', window.screen.width*0.6+'px', window.screen.height*0.75+'px');
	}
</script>
<!---<cfdump  var="#rsHistorialDocumentos#">---->