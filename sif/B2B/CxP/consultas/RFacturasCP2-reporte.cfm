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

	<cfquery name="rsDocumentos" datasource="#session.DSN#" maxrows="1001">
		 select 
				hd.IDdocumento, 
				hd.CPTcodigo as tipo, 
				hd.Ddocumento,
				hd.EDtref as CPTRcodigo,
				hd.EDdocref as DRdocumento, 
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
				<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' "> as CorteNombre
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
			<cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
				and hd.SNcodigo = #session.B2B.SNcodigo#
			</cfif>
			<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
				and hd.CPTcodigo = '#url.CPTcodigo#'
			</cfif>
			<cfif isdefined("form.chk_DocSaldo")>
				and ed.EDsaldo <> 0
			</cfif>

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
				<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' ">  as CorteNombre
				 
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
	        <cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
				and ma.SNcodigo = #session.B2B.SNcodigo#
			</cfif>
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
			<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
				and ma.CPTcodigo = '#url.CPTcodigo#'
			</cfif>
			<cfif isdefined("form.chk_DocSaldo")>
				and ed.EDsaldo <> 0
			</cfif>
		group by ma.CPTcodigo, ma.Ddocumento,ed.EDsaldo, 
		<cf_dbfunction name="concat" args="s.SNnumero,' - ',s.SNnombre,'   ', '(',s.SNidentificacion,')' ">
		order by SNcodigo, Mcodigo, tipo, Dfecha  desc
	</cfquery>
</cfif>

<cf_templateheader title="Consulta de Documentos de CxP">
<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr><td colspan="2" align="center" style="font:bold; padding:4px;" bgcolor="#CCCCCC"><h2>Consulta de Documentos de CxP.</h2></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="8" align="right">
			<cfset params = "&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#&btnConsultar=#url.btnConsultar#">
			
			<cfif isdefined("url.CPTcodigo")>
				<cfset params = params & '&CPTcodigo=#url.CPTcodigo#'>
			</cfif>
			
			<cf_rhimprime datos="/sif/B2B/CxP/consultas/RFacturasCP2-reporte.cfm" paramsuri="#params#">
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
							desplegar="Tipo, Ddocumento,  Dfecha, Dfechavenc, Moneda, monto, EDsaldo, Oficodigo"
							etiquetas="Tipo Transacci&oacute;n, Documento,  Fecha Doc, Fecha Venc., Moneda, Monto,Saldo, Oficina"
							formatos="S, S,  D, D, S, M,M, S"
							align="left, left,  center, center, center, right,right, right"
							showlink="true"
							Cortes="CorteNombre"
							maxrows="0"
							pageindex=""
							ira="RFacturasCP2-DetalleDoc.cfm"/>  
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr valign="top" align="center"><td colspan="2">***************************** Fin de la Consulta ***************************** </td></tr>
			<cfelse>
				<tr valign="top" align="center"> 
					<td colspan="2"   bgcolor="#CCCCCC" align="center">
						<span style="font-size: 16px"><strong>*** No hay datos relacionados ***</strong></span>
					</td>
				</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
		<cfelseif isdefined('rsDocumentos') and rsDocumentos.RecordCount GTE 1001> 
			<tr valign="top" align="center"> 
				<td colspan="2"   bgcolor="#CCCCCC" align="center">
					<span style="font-size: 16px"><strong>*** El n&uacute;mero de Documentos Resultantes *** <br>
					*** en la consulta exceden el l&iacute;mite permitido. Delimite la consulta con filtros m&aacute;s detallados. ***</strong></span>
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
				<input type="hidden" name="btnConsultar" value="Consultar" />
				</cfoutput>
				<cf_botones exclude="Alta,Limpiar" include="Regresar">		
			</form>
		</td></tr>
	</table>	
<cf_templatefooter >

