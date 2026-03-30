<!---
	Modificado por: Ana Villavicencio
	Fecha: 28 de octubre del 2005
	Motivo: Se acomodaron los datos para una mejor presentacion visual.
			Se agregaron variables ocultas para mantener los valores del filtro cuando regresara.
			Se cambio la forma de regresar, ahora se hace por medio de un submit a RFacturasCC2.cfm.
	Modificado por Gustavo Fonseca H.
		Fecha: 15-12-2005.
		Motivo: Se arregla la pantalla por que no estaba encontrando varios valores que venÃ­an por form.
	Modificado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Se agregan los registros de tipo Pago a los querys(rsDoc y rsDetDoc).
	Modificado por Gustavo Fonseca H.
		Fecha: 27-4-2006.
		Motivo: Se agrega el subtotal, IMPUESTO, observaciones y el ASIENTO.

 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Articulo = t.Translate('LB_Articulo','Art&iacute;culo','RFacturasCC2.cfm')>
<cfset LB_Servicio = t.Translate('LB_Servicio','Servicio','RFacturasCC2.cfm')>
<cfset LB_PolSinApl = t.Translate('LB_PolSinApl','Poliza sin aplicar')>
<cfset LB_PolApl = t.Translate('LB_PolApl','Poliza aplicada')>

<cfif isdefined("url.HDid") and not isdefined("form.HDid")>
	<cfset form.HDid = url.HDid>
</cfif>

<cfif isdefined("url.pop")>
	<cfif not isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
		<cfset url.SNcodigo = -1>
	</cfif>
	<cfif not isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
		<cfset url.Ddocumento = -1>
	</cfif>
	<cfif not isdefined("url.tipo") and not isdefined("form.tipo")>
		<cfset url.tipo = -1>
	</cfif>
	<cfif not isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
		<cfset url.SNnumero = -1>
	</cfif>
	<cfif not isdefined("url.FECHAINI") and not isdefined("form.FECHAINI")>
		<cfset url.FECHAINI = ''>
	</cfif>
	<cfif not isdefined("url.FECHAFIN") and not isdefined("form.FECHAFIN")>
		<cfset url.FECHAFIN = ''>
	</cfif>
	<cfif not isdefined("url.DOCUMENTO") and not isdefined("form.DOCUMENTO")>
		<cfset url.DOCUMENTO = ''>
	</cfif>
</cfif>
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset form.Ddocumento = url.Ddocumento>
</cfif>
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo>
</cfif>
<cfif isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
	<cfset form.SNnumero = url.SNnumero>
</cfif>
<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isdefined("url.DDtipo") and not isdefined("form.DDtipo")>
	<cfset form.DDtipo = url.DDtipo>
</cfif>

<cfquery name="rsverDetalle" datasource="#session.DSN#">
	select count(1) as Cantidad
	from HDDocumentos
	where HDid = #form.HDid#
</cfquery>

<cfif rsverDetalle.recordcount GT 0 and rsverDetalle.Cantidad GT 0>
	<cfquery name="rsDoc" datasource="#session.DSN#">
		select
			(
				select (round(sum(dos.DDtotal) ,2))
				from HDDocumentos dos
				where dos.HDid = d.HDid
			) as subtotal,

			coalesce(d.DEobservacion, 'N/A') as DEobservacion,
			-1 as HDid, d.CCTcodigo as tipo, d.Ddocumento,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre,
			d.Dfecha , d.Dvencimiento  , s.Mcodigo , d.Dtotal as Monto , round(d.Dtotal, 2) as Dsaldo,
			o.Oficodigo+' - '+o.Odescripcion as Oficodigo,
			d.Ccuenta , m.Miso4217 as moneda,
			coalesce((
				select min(dv.Dsaldo)
				from Documentos dv
				where dv.Ecodigo = d.Ecodigo
				  and dv.Ddocumento = d.Ddocumento
				  and dv.CCTcodigo = d.CCTcodigo)
				, 0.00) as SaldoActual
			, Dtref as Dtref
			, Ddocref as Ddocref
			, t.CCTtipo
			,' - '+isnull(t.CCTdescripcion,'') as CCTdescripcion
			,cf.CFdescripcion
			,d.Dtipocambio
		from HDocumentos d
			inner join CCTransacciones t
				on  t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			inner join SNegocios s
					on s.SNcodigo = d.SNcodigo
					and s.Ecodigo = d.Ecodigo
			inner join Oficinas o
				  on o.Ecodigo = d.Ecodigo
				 and o.Ocodigo = d.Ocodigo

			inner join Monedas m
				  on m.Mcodigo = d.Mcodigo
	 	    left outer join CFuncional cf
			     on d.CFid = cf.CFid
			    and d.Ecodigo = cf.Ecodigo

		where d.HDid = #form.HDid#
	</cfquery>

<cfelse>
	<cfquery name="rsDoc" datasource="#session.DSN#">
		select
			d.Dtotal as subtotal,
			coalesce(d.DEobservacion, 'N/A') as DEobservacion,
			-1 as HDid, d.CCTcodigo as tipo, d.Ddocumento,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre,
			d.Dfecha , d.Dvencimiento  , s.Mcodigo , d.Dtotal as Monto , round(d.Dtotal, 2) as Dsaldo, 
			o.Oficodigo+' - '+o.Odescripcion as Oficodigo,
			d.Ccuenta , m.Miso4217 as moneda,
			coalesce((
				select min(dv.Dsaldo)
				from Documentos dv
				where dv.Ecodigo = d.Ecodigo
				  and dv.Ddocumento = d.Ddocumento
				  and dv.CCTcodigo = d.CCTcodigo)
				, 0.00) as SaldoActual
			, Dtref as Dtref
			, Ddocref as Ddocref
			, t.CCTtipo
			,' - '+isnull(t.CCTdescripcion,'') as CCTdescripcion
            ,d.Dtipocambio
			,cf.CFdescripcion
            ,d.Dtipocambio
		from HDocumentos d
			inner join CCTransacciones t
				on  t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			inner join SNegocios s
					on s.SNcodigo = d.SNcodigo
					and s.Ecodigo = d.Ecodigo
			inner join Oficinas o
				  on o.Ecodigo = d.Ecodigo
				 and o.Ocodigo = d.Ocodigo

			inner join Monedas m
				  on m.Mcodigo = d.Mcodigo
			left outer join CFuncional cf
			     on d.CFid = cf.CFid
			    and d.Ecodigo = cf.Ecodigo

		where d.HDid = #form.HDid#
	</cfquery>

</cfif>

<cfif rsDoc.recordCount eq 0>
	<cfthrow message="Opcion no disponible">
</cfif>

<cfif trim(rsDoc.Dtref) NEQ "" and trim(rsDoc.Dtref) NEQ "-1">
	<cfquery name="rsAsiento" datasource="#Session.DSN#">
		select he.Cconcepto, he.Edocumento as Asiento, he.Eperiodo, he.Emes,
			case
				when ee.Edocumento is not null then '#LB_PolSinApl#'
				when he.Edocumento is not null then '#LB_PolApl#'
				else 'IDcontable'
			end as TipoAsiento
		from BMovimientos bm
			left outer join HEContables he
				on he.IDcontable = bm.IDcontable
			left outer join EContables ee
				on ee.IDcontable = bm.IDcontable
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
		  and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Dtref#">
		  and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocref#">
	</cfquery>
<cfelse>
	<cfquery name="rsAsiento" datasource="#Session.DSN#">
		select he.Cconcepto, he.Edocumento as Asiento, he.Eperiodo, he.Emes,
			case
				when ee.Edocumento is not null then '#LB_PolSinApl#'
				when he.Edocumento is not null then '#LB_PolApl#'
				else 'IDcontable'
			end as TipoAsiento
		from BMovimientos bm
			left outer join HEContables he
				on he.IDcontable = bm.IDcontable
			left outer join EContables ee
				on ee.IDcontable = bm.IDcontable
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
		  and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
	</cfquery>
</cfif>


<cfquery name="rsDetDoc" datasource="#session.DSN#">
	select
		hdd.DDcantidad as cantidad,
		hdd.DDpreciou as preciou,
		hdd.DDtotal as total,
		hdd.DDtipo,
		case when  hdd.DDtipo = 'A' then '#LB_Articulo#'  else '#LB_Servicio#' end  as tipo,
		case hdd.DDdescalterna when '' then
        	substring(hdd.DDescripcion,1,27)
        else
            substring(coalesce(hdd.DDdescalterna, hdd.DDescripcion),1,27)
        end as descItem,
        cf.CFdescripcion
	from HDocumentos hd
		inner join HDDocumentos hdd
		  on hd.HDid = hdd.HDid
		inner join CFuncional cf
		   on hdd.CFid = cf.CFid
	Where hd.HDid = #form.HDid#
    <cfif isdefined("form.DDtipo") and len(trim(form.DDtipo)) and form.DDtipo neq 'T'>
        and hdd.DDtipo = '#form.DDtipo#'
    </cfif>

</cfquery>

<cfif rsDoc.CCTtipo EQ "D">
	<cfquery name="rsHistorialPagos" datasource="#session.DSN#">
		select
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha,
			bm.CCTcodigo as CCTcodigo,
			bm.Ddocumento as Documento,
			m.Miso4217,
			round(bm.Dtotalref, 2) as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.DRdocumento = hd.Ddocumento
				and bm.CCTRcodigo = hd.CCTcodigo
				and bm.Ecodigo = hd.Ecodigo
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		order by 1
	</cfquery>
<cfelse>
	<cfquery name="rsHistorialPagos" datasource="#session.DSN#">
		select
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha,
			bm.CCTRcodigo as CCTcodigo,
			bm.DRdocumento as Documento,
			m.Miso4217,
			bm.Dtotalref as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.Ecodigo = hd.Ecodigo
				and bm.CCTcodigo = hd.CCTcodigo
				and bm.Ddocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				and (bm.CCTRcodigo = '#rsDoc.Dtref#' or bm.DRdocumento = '#rsDoc.Ddocref#')
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		union
		select
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha,
			bm.CCTcodigo as CCTcodigo,
			bm.Ddocumento as Documento,
			m.Miso4217,
			bm.Dtotalref as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.Ecodigo = hd.Ecodigo
				and bm.CCTRcodigo = hd.CCTcodigo
				and bm.DRdocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				and (bm.CCTRcodigo <> '#rsDoc.Dtref#' or bm.DRdocumento <> '#rsDoc.Ddocref#')
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		order by 1
	</cfquery>
</cfif>
<!--- TIMBRE FISCAL --->
<cfquery name="rstimbre" datasource="#session.DSN#">
	select min(cer.IdRep) as IdRep, min(cer.IdContable) as IDcontable, min(cer.linea) as linea
	from HDocumentos hd
		inner join CERepositorio cer
		on hd.IDcontable = cer.IdContable and cer.origen like 'CCFC'
		and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento))
	where HDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HDid#">
</cfquery>

<cfset LB_DetDocto = t.Translate('LB_DetDocto','Detalle del Documento','RFacturasCC2-reporte.xml')>
<cfset LB_DatosDocto = t.Translate('LB_DatosDocto','Datos del Documento')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio','RFacturasCC2.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento')>
<cfset LB_TipoTrans  = t.Translate('LB_TipoTrans','Tipo de Transacci&oacute;n','RFacturasCC2.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Centro_Funcional = t.Translate('LB_Centro_Funcional','Centro Funcional','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento')>
<cfset LB_Impuesto = t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_PerCont = t.Translate('LB_PerCont','Peri&oacute;do Contable')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_SaldoAct = t.Translate('LB_SaldoAct','Saldo Actual')>
<cfset LB_Obser = t.Translate('LB_Obser','Observaciones')>
<cfset LB_DetLinea = t.Translate('LB_DetLinea','Detalles de L&iacute;nea(s) del Documento')>
<cfset LB_HistPag = t.Translate('LB_HistPag','Historial de Pagos/Aplicaciones')>
<cfset LB_Cant = t.Translate('LB_Cant','Cant')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_CFunc = t.Translate('LB_CFunc','C.Func.')>
<cfset LB_DescItem = t.Translate('LB_DescItem','Desc Item')>
<cfset LB_PrecioUni = t.Translate('LB_PrecioUni','Precio Unitario')>
<cfset LB_TotalLin = t.Translate('LB_TotalLin','Total Linea')>
<cfset LB_FinDet = t.Translate('LB_FinDet','Fin de Detalle')>
<cfset LB_FinHist = t.Translate('LB_FinHist','Fin de Historial')>
<cfset LB_FecPago = t.Translate('LB_FecPago','Fecha Pago')>
<cfset LB_NumPago = t.Translate('LB_NumPago','Num. Pago')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','RFacturasCC2-reporte.xml')>
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Timbre = t.Translate('LB_Timbre','Timbre Fiscal')>

<cfif not isdefined("url.pop")>
	<cf_templateheader title="SIF - Cuentas por Cobrar">
    <cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_DetDocto#">
    </cfoutput>
    <cfset params=''>
	<cfif not isdefined("url.FechaVenIni") and not isdefined("form.FechaVenIni")>
		<cfset url.FechaVenIni = ''>
	</cfif>
	<cfif not isdefined("url.FechaVenFin") and not isdefined("form.FechaVenFin")>
		<cfset url.FechaVenFin = ''>
	</cfif>
	<cfset params = "&SNcodigo=#url.SNcodigo#&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#&btnConsultar=true&FechaVenIni=#url.FechaVenIni#&FechaVenFin=#url.FechaVenFin#&FTimbre=#url.FTimbre#">

    <cfif isdefined("url.CCTcodigo")>
        <cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
    </cfif>

    <cfif isdefined("url.CFid")>
        <cfset params = params & '&CFid=#url.CFid#'>
    </cfif>

    <cfif isdefined("url.DDtipo")>
        <cfset params = params & '&TipoItem=#url.DDtipo#'>
    </cfif>


	<form name="form1" method="post" action="RFacturasCC2.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td valign="top" width="50%">
						<cfinclude template="/sif/portlets/pNavegacionCC.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td colspan="4"><!--- Pintamos el icono de imprimir --->
							<cf_rhimprime datos="/sif/cc/consultas/RFacturasCC2-DetalleDoc.cfm" paramsuri="#params#">
							<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="right">
								<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
							</td>
						</tr>
						<tr>
							<td colspan="4" class="tituloListas"><cfoutput>#LB_DatosDocto#:</cfoutput></td>
						</tr>
						<tr>
							<td colspan="4" bgcolor="CCCCCC">
								<cfoutput>
									<span style="font-size: 18px">N° Doc: &nbsp;#rsDoc.Ddocumento#</span>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
							<!---  --->
								<cfoutput>
									<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
										<tr><td colspan="4">&nbsp</td></tr>
										<tr><td colspan="4"><strong>Informacion Contable</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;"><strong>#rsAsiento.TipoAsiento#:&nbsp;</strong></td>
											<td style="">#rsAsiento.Cconcepto# - #rsAsiento.Asiento#</td>
											<td style="">
										<cfif len(trim(rsAsiento.Eperiodo))>
											<strong>#LB_PerCont#:&nbsp;</strong>
											<cfelse>&nbsp;
										</cfif></td>
                                            <td style="">
										<cfif len(trim(rsAsiento.Eperiodo))>#rsAsiento.Eperiodo#/#rsAsiento.Emes#
                                        	<cfelse>&nbsp;
										</cfif></td>
									 	</tr>
										<tr><cfoutput>
											<td colspan="2">&nbsp;</td>
											<cfif rstimbre.recordcount GT 0 and rstimbre.IdRep NEQ "">
												<td colspan="2"><strong>#LB_Timbre#: &nbsp; </strong><img border='0' src='/cfmx/sif/imagenes/Description.gif' style='cursor:pointer' alt='Mostrar CFDI' onclick="javascript:InfCFDI(#rstimbre.IDcontable#,#rstimbre.linea#,#rstimbre.IdRep#);"</td>
											<cfelse>
												<td colspan="2">#LB_Timbre#: &nbsp; --</td>
											</cfif>
											</cfoutput>
										</tr>
										<tr><td colspan="4" style="padding-top:15px;"><strong>Informacion del socio de negocios</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Socio#:</strong></td>
										  	<td style="">#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
										  	<td style="">&nbsp</td>
										  	<td style="">&nbsp</td>
									 	</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Identificacion#:&nbsp;</strong></td>
										  	<td style="">#rsDoc.SNidentificacion#</td>
										  	<td style="">&nbsp</td>
										  	<td style="">&nbsp</td>
									  	</tr>
										<tr><td colspan="4" style="padding-top:15px;"><strong>Informacion del documento</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;" nowrap><strong>#LB_TipoTrans#:&nbsp;</strong></td>
											<td style="">#rsDoc.Tipo# #rsDoc.CCTdescripcion#</td>
											<td style=""><strong>#LB_Moneda#:&nbsp;</strong></td>
											<td style="">#rsDoc.Moneda#</td>
										</tr>
										<tr>
										  	<td style="text-align:right;" nowrap ><strong>#LB_Centro_Funcional#:&nbsp;</strong></td>
										  	<td  style="" nowrap>#rsDoc.CFdescripcion#&nbsp;&nbsp;</td>
											<td style=""><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.Dtipocambio,"none")#</td>
										</tr>
										<tr>
										  	<td style="text-align:right;"><strong>#Oficina#:&nbsp;</strong></td>
										  	<td style="">#rsDoc.Oficodigo#</td>
											<td style="">&nbsp;</td>
										  	<td style="">&nbsp;</td>
										</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Fecha#:&nbsp;</strong></td>
										  	<td style="">#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
											<td style="">&nbsp;</td>
										  	<td style="">&nbsp;</td>
										</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Vencimiento#:&nbsp;</strong></td>
										  	<td style="">#LSDateformat(rsDoc.DVencimiento,"dd/mm/yyyy")# </td>
											<td colspan="2"></td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Subtotal#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Impuesto#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.monto - rsDoc.subtotal,"none")#</td>
										</tr>

										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Monto#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_SaldoAct#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.SaldoActual,"none")#</td>
										</tr>

									</table>
									<cfset saldo = rsDoc.Dsaldo>
									<cfset listaSNnumero = ListtoArray(form.SNnumero)>
									<cfset listaSNcodigo = ListtoArray(form.SNcodigo)>
									<cfif ArrayLen(listaSNnumero) GT 1>
									<input name="SNnumero" type="hidden" value="#listaSNnumero[1]#">
									<input name="SNcodigo" type="hidden" value="#listaSNcodigo[1]#">
									</cfif>
									<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
										<input name="CCTcodigo" type="hidden" value="#form.CCTcodigo#">
									</cfif>
									<cfif isdefined("form.Documento") and len(trim(form.Documento))>
										<input name="Documento" type="hidden" value="#form.Documento#">
									</cfif>
									<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
										<input name="fechaIni" type="hidden" value="#form.fechaIni#">
									</cfif>
									<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
										<input name="fechaFin" type="hidden" value="#form.fechaFin#">
									</cfif>
									<cfif isdefined("form.Documento") and len(trim(form.Documento))>
										<input name="consultar" type="hidden" value="#form.Documento#">
									</cfif>
							</td>
						</tr>
						<tr>
							<td style="padding:5px;"><strong>#LB_Obser#:</strong>&nbsp; #rsDoc.DEobservacion# </td>
							<td colspan="3">&nbsp;</td>
						</tr>
						</cfoutput>
					</table>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
                    	<cfoutput>
						<tr>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#LB_DetLinea#</strong></td>

						</tr>
                    	</cfoutput>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                 	<cfoutput>
									<tr>
										<td nowrap align="center"><strong>#LB_Cant#&nbsp;</strong></td>
										<td nowrap ><strong>#LB_Tipo#&nbsp;</strong></td>
										<td nowrap ><strong>#LB_CFunc#&nbsp;</strong></td>
										<td nowrap><strong>#LB_DescItem#</strong></td>
										<td nowrap align="right"><strong>#LB_PrecioUni#</strong></td>
										<td nowrap align="right"><strong>#LB_TotalLin#</strong></td>
									</tr>
                                    </cfoutput>
									<cfoutput query="rsDetDoc">
									<!---  --->
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
												<td align="center">#rsDetDoc.cantidad#&nbsp;</td>
												<td>#rsDetDoc.tipo#&nbsp;</td>
												<td>#rsDetDoc.CFdescripcion#&nbsp;&nbsp;</td>
												<td>#rsDetDoc.descItem#</td>
												<td align="right">#LScurrencyFormat(rsDetDoc.preciou,"none")# &nbsp;&nbsp;</td>
												<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
											</tr>
										</tr>
									</cfoutput>
                                 	<cfoutput>
                                 	<tr>
                                 		<td colspan="6" nowrap style="padding:15px 0; text-align:center;">***** #LB_FinDet# *****</td>
                                 	</tr>
                                 	</cfoutput>
							  </table>
							</td>
						</tr>
						<tr>
							<cfoutput>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#LB_HistPag#</strong></td>
							</cfoutput>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<cfif not len(trim(saldo))>
									<cfset nuevoSaldo = 0.00>
								<cfelse>
									<cfset nuevoSaldo = saldo>
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
                                    	<cfoutput>



									  <td nowrap><strong>&nbsp;#LB_FecPago#</strong></td>
										<td nowrap><strong>#LB_Tipo#</strong></td>
										<td nowrap ><strong>#LB_NumPago#</strong></td>
										<td nowrap align="right"><strong>#LB_Monto#</strong></td>
										<td nowrap align="right"><strong>#LB_Saldo#</strong></td>
                                     </tr>
									</cfoutput>
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#lsdateformat(CreateDate(left(rsHistorialPagos.Fecha,4),mid(rsHistorialPagos.Fecha,5,2),mid(rsHistorialPagos.Fecha,7,2)),'dd/mm/yyyy')#</td>
											<td  nowrap>#rsHistorialPagos.CCTcodigo# </td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">
												#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")#
											</td>
											<cfif len(trim(rsHistorialPagos.Aplicado))>
												<cfset nuevoSaldo = (round(nuevoSaldo * 100) - round(rsHistorialPagos.Aplicado * 100)) / 100>
											</cfif>
											<td  nowrap align="right">
													#LScurrencyFormat(nuevoSaldo,"none")#
											</td>
										</tr>
									</cfoutput>
                                    <cfoutput>
									<tr><td colspan="5" nowrap style="padding:15px 0; text-align:center;">***** #LB_FinHist# *****</td></tr>
                                 	</cfoutput>
								</table>
							</td>
						</tr>
						<!--- <tr align="center" valign="top"><td colspan="2">&nbsp;</td></tr> --->
					</table>
				</td>
			</tr>
            <cfoutput>
			<tr><td align="center" class="noprint"><input type="button"  value="#LB_Regresar#" name="btnConsultar" onclick="Regresar();"></td></tr>
            </cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
			<cfoutput>
				<script language="javascript" type="text/javascript">
					function Regresar(){
					 document.form1.action='RFacturasCC2-reporte.cfm?#params#';
					 document.form1.submit();
					}
				</script>
			</cfoutput>
			<cf_web_portlet_end>
	<cf_templatefooter>
<cfelse>
	<cfoutput>
	<title>#LB_DetDocto#</title>
	</cfoutput>
	<cf_templatecss>
	<fieldset><legend><cfoutput>#LB_DetDocto#</cfoutput></legend>
		<table width="100%" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td valign="top" width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td colspan="4" class="tituloListas"><cfoutput>#LB_DatosDocto#:</cfoutput></td>
						</tr>
						<tr>
							<td colspan="4" bgcolor="CCCCCC">
								<cfoutput>
									<span style="font-size: 18px">N° Doc: &nbsp;#rsDoc.Ddocumento#</span>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
							<!---  --->
								<cfoutput>
									<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
										<tr><td colspan="4">&nbsp</td></tr>
										<tr><td colspan="4"><strong>Informacion Contable</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;"><strong>#rsAsiento.TipoAsiento#:&nbsp;</strong></td>
											<td style="">#rsAsiento.Cconcepto# - #rsAsiento.Asiento#</td>
											<td style="">
										<cfif len(trim(rsAsiento.Eperiodo))>
											<strong>#LB_PerCont#:&nbsp;</strong>
											<cfelse>&nbsp;
										</cfif></td>
                                            <td style="">
										<cfif len(trim(rsAsiento.Eperiodo))>#rsAsiento.Eperiodo#/#rsAsiento.Emes#
                                        	<cfelse>&nbsp;
										</cfif></td>
										</tr>
										<tr><cfoutput>
											<td colspan="2">&nbsp;</td>
											<cfif rstimbre.recordcount GT 0 and rstimbre.IdRep NEQ "">
												<td colspan="2"><strong>#LB_Timbre#: &nbsp; </strong><img border='0' src='/cfmx/sif/imagenes/Description.gif' style='cursor:pointer' alt='Mostrar CFDI' onclick="javascript:InfCFDI(#rstimbre.IDcontable#,#rstimbre.linea#,#rstimbre.IdRep#);"</td>
											<cfelse>
												<td colspan="2">#LB_Timbre#: &nbsp; --</td>
											</cfif>
											</cfoutput>
										</tr>
										<tr><td colspan="4" style="padding-top:15px;"><strong>Informacion del socio de negocios</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Socio#:</strong></td>
										  	<td style="">#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
										  	<td style="">&nbsp</td>
										  	<td style="">&nbsp</td>
									 	</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Identificacion#:&nbsp;</strong></td>
										  	<td style="">#rsDoc.SNidentificacion#</td>
										  	<td style="">&nbsp</td>
										  	<td style="">&nbsp</td>
									  	</tr>
										<tr><td colspan="4" style="padding-top:15px;"><strong>Informacion del documento</strong></td></tr>
										<tr><td colspan="4"><hr></td></tr>
										<tr>
											<td style="text-align:right;" nowrap><strong>#LB_TipoTrans#:&nbsp;</strong></td>
											<td style="">#rsDoc.Tipo#</td>
											<td style=""><strong>#LB_Moneda#:&nbsp;</strong></td>
											<td style="">#rsDoc.Moneda#</td>
										</tr>
										<tr>
										  	<td style="text-align:right;" nowrap ><strong>#LB_Centro_Funcional#:&nbsp;</strong></td>
										  	<td  style="" nowrap>#rsDoc.CFdescripcion#&nbsp;&nbsp;</td>
											<td style=""><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.Dtipocambio,"none")#</td>
										</tr>
										<tr>
										  	<td style="text-align:right;"><strong>#Oficina#:&nbsp;</strong></td>
										  	<td style="">#rsDoc.Oficodigo#</td>
											<td style="">&nbsp;</td>
										  	<td style="">&nbsp;</td>
										</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Fecha#:&nbsp;</strong></td>
										  	<td style="">#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
											<td style="">&nbsp;</td>
										  	<td style="">&nbsp;</td>
										</tr>
										<tr>
											<td style="text-align:right;"><strong>#LB_Vencimiento#:&nbsp;</strong></td>
										  	<td style="">#LSDateformat(rsDoc.DVencimiento,"dd/mm/yyyy")# </td>
											<td colspan="2"></td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Subtotal#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Impuesto#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.monto - rsDoc.subtotal,"none")#</td>
										</tr>
											<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_Monto#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>
										</tr>
											<tr>
											<td colspan="2">&nbsp;</td>
											<td style=""><strong>#LB_SaldoAct#:&nbsp;</strong></td>
										  	<td style="">#LScurrencyFormat(rsDoc.SaldoActual,"none")#</td>
										</tr>
									</table>
									<cfset saldo = rsDoc.Dsaldo>
							</td>
						</tr>
						<tr>
							<td style="padding:5px;"><strong>#LB_Obser#:</strong>&nbsp; #rsDoc.DEobservacion# </td>
							<td colspan="3">&nbsp;</td>
						</tr>
						</cfoutput>
					</table>
					<!---  --->
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
                    	<cfoutput>
						<tr>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#LB_DetLinea#</strong></td>
						</tr>
                    	</cfoutput>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                 	<cfoutput>
									<tr>
										<td nowrap align="center"><strong>#LB_Cant#&nbsp;</strong></td>
										<td nowrap ><strong>#LB_Tipo#&nbsp;</strong></td>
										<td nowrap ><strong>#LB_CFunc#&nbsp;</strong></td>
										<td nowrap><strong>#LB_DescItem#</strong></td>
										<td nowrap align="right"><strong>#LB_PrecioUni#</strong></td>
										<td nowrap align="right"><strong>#LB_TotalLin#</strong></td>
									</tr>
                                    </cfoutput>
									<cfoutput query="rsDetDoc">
									<!---  --->
									<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<td align="center">#rsDetDoc.cantidad#&nbsp;</td>
											<td>#rsDetDoc.DDtipo#&nbsp;</td><!--- Revisarlo --->
											<td>#rsDetDoc.CFdescripcion#&nbsp;&nbsp;</td>
											<td>#rsDetDoc.descItem#</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.preciou,"none")# &nbsp;&nbsp;</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
										</tr>
									</tr>
									</cfoutput>
                                 	<cfoutput>
                                 	<tr>
                                 		<td colspan="6" nowrap style="padding:15px 0; text-align:center;">***** #LB_FinDet# *****</td>
                                 	</tr>
                                 	</cfoutput>
							    </table>
							</td>
						</tr>
						<tr>
							<cfoutput>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>#LB_HistPag#</strong></td>
							</cfoutput>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<cfif not len(trim(saldo))>
									<cfset nuevoSaldo = 0.00>
								<cfelse>
									<cfset nuevoSaldo = saldo>
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
                                    	<cfoutput>
									  	<td nowrap><strong>&nbsp;#LB_FecPago#</strong></td>
										<td nowrap><strong>#LB_Tipo#</strong></td>
										<td nowrap ><strong>#LB_NumPago#</strong></td>
										<td nowrap align="right"><strong>#LB_Monto#</strong></td>
										<td nowrap align="right"><strong>#LB_Saldo#</strong></td>
									</tr>
                                        </cfoutput>
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#lsdateformat(CreateDate(left(rsHistorialPagos.Fecha,4),mid(rsHistorialPagos.Fecha,5,2),mid(rsHistorialPagos.Fecha,7,2)),'dd/mm/yyyy')#</td>
											<td  nowrap>#rsHistorialPagos.CCTcodigo#</td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">
												#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")#
											</td>
											<cfif len(trim(rsHistorialPagos.Aplicado))>
												<cfset nuevoSaldo = (round(nuevoSaldo * 100) - round(rsHistorialPagos.Aplicado * 100)) / 100>
											</cfif>
											<td  nowrap align="right">
													#LScurrencyFormat(nuevoSaldo,"none")#
											</td>
										</tr>
									</cfoutput>
                                 	<cfoutput>
									<tr><td colspan="5" nowrap style="padding:15px 0; text-align:center;">***** #LB_FinHist# *****</td></tr>
                                 	</cfoutput>
								</table>
							</td>
						</tr>
						<!--- <tr align="center" valign="top"><td colspan="2">&nbsp;</td></tr> --->
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