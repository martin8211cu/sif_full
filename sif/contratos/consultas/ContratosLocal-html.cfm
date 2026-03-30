<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfset max_lineas = 10 * 1.0>


<cfif isdefined("url.CTContid") and len(trim(url.CTContid)) and not isdefined("form.CTContid")>
	<cfset form.CTContid = url.CTContid >
</cfif>

<cfif not (isdefined("form.CTContid") and len(trim(form.CTContid)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definido el Contrato que desa imprimir.">
</cfif>

<cf_templatecss>
<style type="text/css">
	.areaNumero {
		BORDER-RIGHT: #000000 2px solid;
		PADDING-RIGHT: 3px;
		BORDER-TOP: #000000 2px solid;
		PADDING-LEFT: 3px;
		PADDING-BOTTOM: 3px;
		BORDER-LEFT: #000000 2px solid;
		COLOR: #000000;
		PADDING-TOP: 3px;
		BORDER-BOTTOM: #000000 2px solid;

	}
	.LetraDetalle{
		font-size:11px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
</style>

<cfquery name="data" datasource="#session.DSN#">
	select a.CPDDid, a.ACcodigo, a.Ccodigo,a.CTDCconsecutivo,
case a.CMtipo when 'A' then 'Artículo'  when 'C' then 'Artículo' when 'S' then 'Servicio' when 'F'
then 'Activo' when 'P' then 'Obras' end as CMTipodesc, a.Alm_Aid,a.Cid, c.CFcodigo,c.CFid,c.CFdescripcion, cp.CPcuenta, cp.CPformato, cp.CPdescripcion,
a.CTDCmontoTotalOri,a.CTDCont, g.Ccodigo as id, g.Cdescripcion,a.ts_rversion,h.Ccodigoclas, h.Cdescripcion,h.Cnivel,h.Ccodigo,i.ACcodigo, b.CTtipoCambio,
case when a.CPDDid is not null then 'Suf'end as ref,
case CMtipo when 'A' then f.Acodigo when 'C' then '-' when 'F' then '-' when 'S' then g.Ccodigo when 'P' then 'P' end as Codigo
		from CTDetContrato a
			inner join CTContrato b
            	on a.CTContid = b.CTContid
                and a.Ecodigo = b.Ecodigo
			inner join CFuncional c
				on c.Ecodigo = a.Ecodigo and c.CFid = a.CFid
            left outer join CPresupuesto cp
             	on a.CPcuenta = cp.CPcuenta
			left outer join Almacen e
				on e.Aid = a.Alm_Aid
			left outer join Articulos f
				on f.Aid = a.Aid
            left outer join Clasificaciones h
            	on a.Ccodigo = h.Ccodigo
                and a.Ecodigo = h.Ecodigo
			left outer join Conceptos g
				on g.Cid = a.Cid
            left outer join AClasificacion i
            	on a.ACcodigo = i.ACcodigo
		where a.Ecodigo = #Session.Ecodigo#
		  and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
</cfquery>



<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Ocodigo
</cfquery>


<cfquery name="rsContrato" datasource="#Session.DSN#">
            select a.*, b.SNcodigo, d.Mcodigo,d.Mnombre,b.SNnombre,c.CTTCdescripcion, rtrim(ce.Edescripcion) as TituloEmpresa,
			case a.CTCestatus when 0 then 'Captura' when 1 then 'Aplicado' when 2 then 'Cancelado' end as Estatus, e.CTFLdescripcion,f.CTPCdescripcion
			 from CTContrato a
            inner join SNegocios b
                on a.SNid = b.SNid
                and a.Ecodigo = b.Ecodigo
            inner join CTTipoContrato c
                on a.CTTCid = c.CTTCid
                and a.Ecodigo = c.Ecodigo
            inner join Monedas d
                on a.CTMcodigo = d.Mcodigo
                and a.Ecodigo = d.Ecodigo
            inner join CTFundamentoLegal e
                on a.CTFLid = e.CTFLid
                and a.Ecodigo = e.Ecodigo
            inner join CTProcedimientoContratacion f
                on a.CTPCid = f.CTPCid
                and a.Ecodigo = f.Ecodigo
            inner join CTCompradores g
                on a.CTCid = g.CTCid
                and a.Ecodigo = g.Ecodigo
			inner join Empresas ce
					on a.Ecodigo = ce.Ecodigo
            where a.Ecodigo = #Session.Ecodigo#
		  	and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
	</cfquery>
    

<cfset Monto = rsContrato.CTmonto * rsContrato.CTtipoCambio>


<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle del Contrato">
</cfif>



<cfoutput>

<cfsavecontent variable="encabezado">
	<table width="98%" border="0" cellpadding="0"  cellspacing="0" align="center">
		<tr>
			<td align="center"><strong><font size="2">#rsContrato.TituloEmpresa#</font></strong></td>
		</tr>
		<tr>
			<td align="center" bgcolor="##CCCCCC"><font size="1">C O N T R A T O S</font></td>
		</tr>
		<tr>
			<td align="center" bgcolor="##CCCCCC"><font size="1">------------------</font></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><strong><font size="2">CONTRATO No: #rsContrato.CTCnumContrato#</font></strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
					<tr>
						<td nowrap class="LetraEncab">Tipo de Contrato:</td>
						<td nowrap class="LetraDetalle">#rsContrato.CTTCdescripcion#</td>
						<td nowrap class="LetraEncab">Fecha:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(rsContrato.CTfecha,'dd/mm/yyyy')#</td>
						<td nowrap class="LetraEncab">Proveedor:</td>
						<td nowrap class="LetraDetalle">#rsContrato.SNnombre#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Fecha Firma:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(rsContrato.CTfechaFirma,'dd/mm/yyyy')#</td>
						<td nowrap class="LetraEncab">Vigencia Inicio:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(rsContrato.CTfechaIniVig,'dd/mm/yyyy')#</td>
						<td nowrap class="LetraEncab">Vigencia Fin:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(rsContrato.CTfechaFinVig,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Moneda:</td>
						<td nowrap class="LetraDetalle">#rsContrato.Mnombre#</td>
						<td nowrap class="LetraEncab">Tipo Cambio:</td>
						<td nowrap class="LetraDetalle">#rsContrato.CTtipoCambio#</td>
						<td nowrap class="LetraEncab">Oficina:</td>
						<td nowrap class="LetraDetalle">#rsOficinas.Odescripcion#</td>
					</tr>

					<tr>
						<td nowrap class="LetraEncab">Procedimiento de Contrataci&oacute;n:</td>
						<td nowrap class="LetraDetalle">#rsContrato.CTPCdescripcion#</td>
						<td nowrap class="LetraEncab">Importe:</td>
						<td nowrap class="LetraDetalle">#LSCurrencyFormat(rsContrato.CTmonto,'none')#</td>
						<td nowrap class="LetraEncab">Fundamento Legal:</td>
						<td nowrap class="LetraDetalle">#rsContrato.CTFLdescripcion#</td>
					</tr>

					<tr>
						<td nowrap class="LetraEncab">Importe en #rsContrato.Mnombre#:</td>
						<td nowrap class="LetraDetalle">#LSCurrencyFormat(rsContrato.CTmonto,'none')#</td>
						<td nowrap class="LetraEncab">Descripcion:</td>
						<td nowrap class="LetraDetalle">#rsContrato.CTCdescripcion#</td>
						<td nowrap class="LetraEncab">Estatus:</td>
						<td nowrap class="LetraDetalle">#rsContrato.Estatus#</td>
					</tr>

					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>

	</table>
</cfsavecontent>

<cfset contador = 0 >


	<table width="98%" cellpadding="2" cellspacing="0" align="center">
		<cfloop query="data">
			<cfif (isdefined("Url.imprimir") and contador eq max_lineas) or data.Currentrow eq 1>
				<tr><td colspan="6">
					#encabezado#
				</td></tr>
				<tr class="titulolistas">
					<td class="LetraEncab">L&iacute;nea</td>
					<td class="LetraEncab">Ref.</td>
					<td class="LetraEncab">Tipo</td>
					<td class="LetraEncab">C&oacute;digo</td>
					<td class="LetraEncab">Descripcion.</td>
					<td class="LetraEncab">Total</td>

				</tr>
				<cfset contador = 0 >
			</cfif>

			<tr>
				<td class="LetraDetalle">#data.CTDCconsecutivo#</td>
				<td class="LetraDetalle">#data.ref#</td>
				<td class="LetraDetalle">#data.CMTipodesc#</td>
				<td class="LetraDetalle">#data.Codigo#</td>
				<td class="LetraDetalle">#data.CFdescripcion#</td>
				<td class="LetraDetalle">#data.CTDCmontoTotalOri#</td>

			</tr>

			<cfif isdefined("Url.imprimir") and data.Currentrow NEQ data.recordCount and data.Currentrow mod max_lineas EQ 0>
			<tr>
				<td colspan="6" align="right" class="LetraDetalle">
					<strong>PÃ¡g. #Int(data.Currentrow / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong>
				</td>
			</tr>
			<tr class="pageEnd">
				<td colspan="6">&nbsp;</td>
			</tr>
			</cfif>

			<cfset contador = contador + 1 >
		
		</cfloop>
	</table>


</cfoutput>


