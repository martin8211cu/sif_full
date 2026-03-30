<!---
	Creado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Nueva consulta de documentos para CxP.
 --->
<cfif isdefined("url.btnConsultar")>

	<cfset campos_extra = ''>
	<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
		<cfset campos_extra = campos_extra & ", '#url.CPTcodigo#' as CPTcodigo" >
	</cfif>
	<cfif isdefined("url.Documento") and len(trim(url.Documento))>
		<cfset campos_extra = campos_extra & ", '#url.Documento#' as Documento" >
	</cfif>
	<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni))>
		<cfset campos_extra = campos_extra & ", '#url.FechaIni#' as FechaIni" >
	</cfif>
	<cfif isdefined("url.FechaFin") and len(trim(url.FechaFin))>
		<cfset campos_extra = campos_extra & ", '#url.FechaFin#' as FechaFin" >
	</cfif>
	<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
		<cfset campos_extra = campos_extra & ", '#url.fSNcodigo#' as fSNcodigo" >
	</cfif>
	<cfif isdefined("url.fSNnumero") and len(trim(url.fSNnumero))>
		<cfset campos_extra = campos_extra & ", '#url.fSNnumero#' as fSNnumero" >
	</cfif>
	<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
		<cfset form.chk_DocSaldo = url.chk_DocSaldo>
	</cfif>
	<cfif isdefined("url.FTimbre") and not isdefined("form.FTimbre")>
		<cfset form.FTimbre = url.FTimbre>
	</cfif>

	<cfset detalleDocumentoUrl = 'RFacturasCP2-DetalleDoc.cfm'>
  <cfif url.CPTcodigo EQ 'RM' or url.CPTcodigo EQ 'DR'>
	  <cfset detalleDocumentoUrl = 'RFacturasCP2-DetalleDoc_remision.cfm'>
	</cfif>

	<cfquery name="rsDocumentos" datasource="#session.DSN#" maxrows="1001">
				select
						hd.IDdocumento,
						hd.CPTcodigo as tipo,
						hd.Ddocumento,
						hd.EDtref as CPTRcodigo,
						Convert(varchar(100),hd.EDdocref) aS DRdocumento,
						s.SNcodigo SNcodigo,
						s.SNnumero,
						s.SNidentificacion,
						s.SNnombre,
						hd.Dfecha Dfecha,
						hd.Dfechavenc,
						s.Mcodigo Mcodigo,
						case when c.CPTtipo = 'D' then hd.Dtotal * -1 else hd.Dtotal end as Monto,
						ed.EDsaldo,
						o.Oficodigo,
						hd.Ccuenta,
						m.Miso4217 as moneda,
						<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' "> as CorteNombre,
						case when cer.timbre is not null
						then '<img border=''0'' src=''/cfmx/sif/imagenes/iindex.gif'' alt=''Mostrar CFDI''>'
						else null end as Timbre,
						#form.FTimbre# as FTimbre
						#preservesinglequotes(campos_extra)#

					from HEDocumentosCP hd
						inner join SNegocios s
							on hd.Ecodigo  = s.Ecodigo
							and hd.SNcodigo = s.SNcodigo
						inner join Oficinas o
							on hd.Ecodigo = o.Ecodigo
							and hd.Ocodigo = o.Ocodigo
						inner join Monedas m
							on  m.Mcodigo = hd.Mcodigo
						inner join CPTransacciones c
							on c.Ecodigo   = hd.Ecodigo
							and c.CPTcodigo = hd.CPTcodigo
					<cfif isdefined("form.FTimbre") and form.FTimbre LT 2>
						LEFT JOIN CERepositorio cer ON cer.IdContable = hd.IDcontable and cer.origen like 'CPFC'
						and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento)) <!--- and cer.IdDocumento = hd.IDdocumento --->
					<cfelseif isdefined("form.FTimbre") and form.FTimbre EQ 2>
						INNER JOIN CERepositorio cer ON cer.IdContable = hd.IDcontable and cer.origen like 'CPFC'
						and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento)) <!--- and cer.IdDocumento = hd.IDdocumento --->
					</cfif>

					<cfif isdefined("form.chk_DocSaldo")>
						inner
					<cfelse>
						left outer
					</cfif>
						join EDocumentosCP ed
							on ed.IDdocumento = hd.IDdocumento

					Where hd.Ecodigo =  #Session.Ecodigo#
					<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
						<cfif DateDiff("d", "#url.FechaIni#", "#url.FechaFin#")>
							and hd.Dfecha  between #lsparsedatetime(url.FechaIni)# and #lsparsedatetime(url.FechaFin)#
						<cfelse>
							and hd.Dfecha  between #lsparsedatetime(url.FechaFin)# and  #lsparsedatetime(url.FechaIni)#
						</cfif>
					</cfif>
					<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and not len(trim(url.FechaFin))>
						and hd.Dfecha >= #lsparsedatetime(url.FechaIni)#
					</cfif>
					<cfif isdefined("url.FechaIni") and not len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
						and hd.Dfecha <= #lsparsedatetime(url.FechaFin)#
					</cfif>

					<cfif isdefined("url.Documento") and len(trim(url.Documento))>
						and hd.Ddocumento like '#url.Documento#%'
					</cfif>
					<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
						and hd.SNcodigo = #url.fSNcodigo#
					</cfif>
					<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
						and hd.CPTcodigo = '#url.CPTcodigo#'
					</cfif>
					<cfif isdefined("form.chk_DocSaldo")>
						and ed.EDsaldo <> 0
					</cfif>
					<cfif isdefined("form.FTimbre") and form.FTimbre EQ 1>
						and cer.IdRep is null
					</cfif>
        
        union (
					select rem.IDdocumento, rem.CPTcodigo as tipo,
					rem.EDdocumento as Ddocumento,
					rem.EDreferencia as CPTRcodigo,
					Convert(varchar(100),rem.EDdocref) aS DRdocumento,
					s.SNcodigo SNcodigo,
					s.SNnumero,
					s.SNidentificacion,
					s.SNnombre,
					rem.EDfecha as Dfecha,
					rem.EDvencimiento as Dfechavenc,
					s.Mcodigo Mcodigo,
					case
							when
								c.CPTtipo = 'D' 
							then
								rem.EDtotal * 1 
							else
								rem.EDtotal 
					end
					as Monto, 0 as EDsaldo, o.Oficodigo, 
					rem.Ccuenta, m.Miso4217 as moneda, 
					s.SNnumero + ' - ' + s.SNnombre + ' ' + '(' + s.SNidentificacion + ')' as CorteNombre,
					null as Timbre,
					#form.FTimbre# as FTimbre
					#preservesinglequotes(campos_extra)#
					from
				EDocumentosCPR rem
				inner join
							SNegocios s 
							on rem.Ecodigo = s.Ecodigo 
							and rem.SNcodigo = s.SNcodigo
						inner join
							Oficinas o 
							on rem.Ecodigo = o.Ecodigo 
							and rem.Ocodigo = o.Ocodigo
						inner join
							Monedas m 
							on m.Mcodigo = rem.Mcodigo 
							inner join
							CPTransacciones c 
							on c.Ecodigo = rem.Ecodigo 
							and c.CPTcodigo = rem.CPTcodigo
							Where rem.Ecodigo =  #Session.Ecodigo#
							and rem.EVestado = 1
							<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
								<cfif DateDiff("d", "#url.FechaIni#", "#url.FechaFin#")>
									and rem.EDfecha  between #lsparsedatetime(url.FechaIni)# and #lsparsedatetime(url.FechaFin)#
								<cfelse>
									and rem.EDfecha  between #lsparsedatetime(url.FechaFin)# and  #lsparsedatetime(url.FechaIni)#
								</cfif>
							</cfif>
							<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and not len(trim(url.FechaFin))>
								and rem.EDfecha >= #lsparsedatetime(url.FechaIni)#
							</cfif>
							<cfif isdefined("url.FechaIni") and not len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
								and rem.EDfecha <= #lsparsedatetime(url.FechaFin)#
							</cfif>
							<cfif isdefined("url.Documento") and len(trim(url.Documento))>
								and rem.EDdocumento like '#url.Documento#%'
							</cfif>
							<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
								and rem.SNcodigo = #url.fSNcodigo#
							</cfif>
							<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
								and rem.CPTcodigo = '#url.CPTcodigo#'
							</cfif>
				)

				<cfif isdefined("form.FTimbre") and form.FTimbre LT 2>
					union
						select 
							-1 as IDdocumento,
							ma.CPTcodigo as tipo,
							ma.Ddocumento,
							min(ma.CPTRcodigo) as CPTRcodigo,
							min(ma.DRdocumento) as DRdocumento,
							min(s.SNcodigo) as SNcodigo,
							min(s.SNnumero) as SNnumero,
							min(s.SNidentificacion) as SNidentificacion,
							min(s.SNnombre) as SNnombre,
							min(ma.Dfecha) as Dfecha,
							min (ma.Dvencimiento) as Dfechavenc,
							min(s.Mcodigo) as Mcodigo,
							sum(ma.Dtotal) as Monto,
							ed.EDsaldo,
							min(o.Oficodigo) as Oficodigo,
							min(ma.Ccuenta) as Ccuenta,
							min(m.Miso4217) as moneda,
							<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' ">  as CorteNombre,
							null as Timbre,
							#form.FTimbre# as FTimbre
							#preservesinglequotes(campos_extra)#

					from BMovimientosCxP ma

						inner join CPTransacciones t
								on t.Ecodigo   = ma.Ecodigo
							and t.CPTcodigo = ma.CPTcodigo

						inner join  SNegocios s
							on s.SNcodigo  = ma.SNcodigo
							and s.Ecodigo   = ma.Ecodigo

						inner join HEDocumentosCP d
								on d.Ecodigo    = ma.Ecodigo
							and d.SNcodigo   = ma.SNcodigo
							and d.CPTcodigo  = ma.CPTRcodigo
							and d.Ddocumento = ma.DRdocumento
						inner join Oficinas o
								on d.Ecodigo = o.Ecodigo
							and d.Ocodigo = o.Ocodigo
						inner join Monedas m
								on m.Mcodigo = d.Mcodigo
						<cfif isdefined("form.chk_DocSaldo")>
							inner
						<cfelse>
							left outer
						</cfif>
							join EDocumentosCP ed
								on ed.IDdocumento = d.IDdocumento

					where  ma.Ecodigo =  #Session.Ecodigo#
						and t.CPTpago   = 1
						<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
							<cfif DateDiff("d", "#url.FechaIni#", "#url.FechaFin#")>
								and ma.Dfecha  between #lsparsedatetime(url.FechaIni)# and #lsparsedatetime(url.FechaFin)#
							<cfelse>
								and ma.Dfecha  between #lsparsedatetime(url.FechaFin)# and  #lsparsedatetime(url.FechaIni)#
							</cfif>
						</cfif>
						<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and not len(trim(url.FechaFin))>
							and ma.Dfecha >= #lsparsedatetime(url.FechaIni)#
						</cfif>
						<cfif isdefined("url.FechaIni") and not len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
							and ma.Dfecha <= #lsparsedatetime(url.FechaFin)#
						</cfif>

						<cfif isdefined("url.Documento") and len(trim(url.Documento))>
							and ma.Ddocumento like '#url.Documento#%'
						</cfif>
						<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
							and ma.SNcodigo = #url.fSNcodigo#
						</cfif>
						<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
							and ma.CPTcodigo = '#url.CPTcodigo#'
						</cfif>
						<cfif isdefined("form.chk_DocSaldo")>
							and ed.EDsaldo <> 0
						</cfif>
					group by ma.CPTcodigo, ma.Ddocumento,ed.EDsaldo,
					<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' ">
					order by SNcodigo, Mcodigo, tipo, Dfecha  desc
				</cfif>
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_ConsDocCxP = t.Translate('Tit_ConsDocCxP','Consulta de Documentos de CxP')>
<cfset LB_Tipo 		= t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_FecDoc = t.Translate('LB_FecDoc','Fecha Doc')>
<cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
<cfset LB_NoDatRel = t.Translate('LB_NoDatRel','No hay datos relacionados')>
<cfset LB_NoDocRel = t.Translate('LB_NoDocRel','El n&uacute;mero de Documentos Resultantes')>
<cfset LB_ConsExc = t.Translate('LB_ConsExc','en la consulta exceden el l&iacute;mite permitido. Delimite la consulta con filtros m&aacute;s detallados.')>
<cfset LB_TimbreFiscal = t.Translate('LB_TimbreFiscal','Timbre Fiscal')>

<cf_templateheader title="#Tit_ConsDocCxP#">
<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td colspan="2" align="center" style="font:bold; padding:4px;" bgcolor="#CCCCCC"><cfoutput><h2>#Tit_ConsDocCxP#.</h2></cfoutput></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="8" align="right">
			<cfset params = "&fSNcodigo=#url.fSNcodigo#&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#&btnConsultar=#url.btnConsultar#&FTimbre=#url.FTimbre#">

			<cfif isdefined("url.CPTcodigo")>
				<cfset params = params & '&CPTcodigo=#url.CPTcodigo#'>
			</cfif>

			<cf_rhimprime datos="/sif/cp/consultas/RFacturasCP2-reporte.cfm" paramsuri="#params#">
			<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
		</td>
	</tr>
		<cfif isdefined("url.btnConsultar") and rsDocumentos.RecordCount LT 1001>
			<cfif rsDocumentos.RecordCount GT 0>
				<tr>
					<td colspan="2">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#rsDocumentos#"
							desplegar="Tipo, Ddocumento,  Dfecha, Dfechavenc, Moneda, monto, EDsaldo, Oficodigo, Timbre"
							etiquetas="#LB_Tipo# #LB_Transaccion#, #LB_Documento#, #LB_FecDoc#, #LB_FecVenc#, #LB_Moneda#, #LB_Monto#,#LB_Saldo#, #LB_Oficina#, #LB_TimbreFiscal#"
							formatos="S, S,  D, D, S, M,M, S, S"
							align="left, left,  center, center, center, right,right, right, center"
							showlink="true"
							Cortes="CorteNombre"
							maxrows="0"
							pageindex=""
							ira="#detalleDocumentoUrl#"/>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
                <cfoutput>
				<tr valign="top" align="center"><td colspan="2">***************************** #LB_FinCons# ***************************** </td></tr>
                </cfoutput>
			<cfelse>
				<tr valign="top" align="center">
					<td colspan="2"   bgcolor="#CCCCCC" align="center">
                    	<cfoutput>
						<span style="font-size: 16px"><strong>*** #LB_NoDatRel# ***</strong></span>
                        </cfoutput>
					</td>
				</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
		<cfelseif isdefined('rsDocumentos') and rsDocumentos.RecordCount GTE 1001>
			<tr valign="top" align="center">
				<td colspan="2"   bgcolor="#CCCCCC" align="center">
					<span style="font-size: 16px"><strong><cfoutput>*** #LB_NoDocRel# *** <br>
					*** #LB_ConsExc# ***</cfoutput></strong></span>
				</td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="5">
			<form style="margin:0;" action="RFacturasCP2.cfm" method="post">
				<cfoutput>
				<input type="hidden" name="CPTcodigo" value="<cfif isdefined('url.CPTcodigo')>#url.CPTcodigo#</cfif>" />
				<input type="hidden" name="Documento" value="<cfif isdefined('url.Documento')>#url.Documento#</cfif>" />
				<input type="hidden" name="FechaFin" value="<cfif isdefined('url.FechaFin')>#url.FechaFin#</cfif>" />
				<input type="hidden" name="FechaIni" value="<cfif isdefined('url.FechaIni')>#url.FechaIni#</cfif>" />
				<input type="hidden" name="SNcodigo" value="<cfif isdefined('url.fSNcodigo')>#url.fSNcodigo#</cfif>" />
				<input type="hidden" name="SNnumero" value="<cfif isdefined('url.fSNnumero')>#url.fSNnumero#</cfif>" />
				<input type="hidden" name="FTimbre" value="<cfif isdefined('url.FTimbre')>#url.FTimbre#</cfif>" />
				<input type="hidden" name="btnConsultar" value="Consultar" />
				</cfoutput>
				<cf_botones exclude="Alta,Limpiar" include="Regresar">
			</form>
		</td></tr>
	</table>
<cf_templatefooter >

