<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Se corrige la lista por que no permitÃ­a escoger un registro para irse a la pantalla de los detalles.
			- Se corrige el filtro de las fechas, ahora se trata con el datediff de coldfusion.
			- Se le pone un tÃ­tulo a la consulta "Consulta de Documentos de CxC.". 
			- Se agregan los registros de tipo Pago.

	Modificado por Mauricio Esquivel
		Fecha: 2 / Mayo / 2006
		Motivo:  limitar en el cfqery "rsDocumentos" la cantidad maxima de registros obtenidos del server
		Se limita con una variable MaximoRegistros, inicialmente definida en 1001 para que sean hasta 1000 documentos
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

<cfset params = ''>
<cfset MaximoRegistros = 1001>
<cfsetting requesttimeout="3600">

<cfif isdefined("url.btnConsultar") OR url.botonSel eq 'btnConsultar'>
	<!--- Timbre --->
	<cfset dataurl = 'consultas/RFacturasCC2-reporte.cfm?botonSel=btnConsultar&btnConsultar=Consultar&'>

	<cfif isdefined("url.FTimbre") and not isdefined("form.FTimbre")>
		<cfset form.FTimbre = url.FTimbre>
		<cfset dataurl = dataurl&'FTimbre='&url.FTimbre&'&'>
	</cfif>
	<cfif isdefined("url.Documento") and len(trim(url.Documento))>
		<cfset dataurl = dataurl&'Documento='&url.Documento&'&'>
	<cfelse>
		<cfset dataurl = dataurl&'Documento=&'>
	</cfif>
	<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni))>
		<cfset dataurl = dataurl&'fechaIni='&url.fechaIni&'&'>
	</cfif>
	<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin))>
		<cfset dataurl = dataurl&'fechaFin='&url.fechaFin&'&'>
	</cfif>
	<cfif isdefined("url.fechaVenIni") and len(trim(url.fechaVenIni))>
		<cfset dataurl = dataurl&'fechaVenIni='&url.fechaVenIni&'&'>
	</cfif>
	<cfif isdefined("url.fechaVenFin") and len(trim(url.fechaVenFin))>
		<cfset dataurl = dataurl&'fechaVenFin='&url.fechaVenFin&'&'>
	</cfif>
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset dataurl = dataurl&'CFid='&url.CFid&'&'>
	</cfif>
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfset dataurl = dataurl&'SNcodigo='&url.SNcodigo&'&'>
	<cfelse>
		<cfset dataurl = dataurl&'SNcodigo=&'>
	</cfif>
	<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
		<cfset dataurl = dataurl&'CCTcodigo='&url.CCTcodigo&'&'>
	</cfif>
	<cfif isdefined("url.DocumentoSaldo") and len(trim(url.DocumentoSaldo))>
		<cfset form.DocumentoSaldo = url.DocumentoSaldo>
		<cfset dataurl = dataurl&'DocumentoSaldo='&url.DocumentoSaldo&'&'>
	</cfif>

	<cfif isdefined("url.TipoItem") and len(trim(url.TipoItem))>
		<cfset dataurl = dataurl&'TipoItem='&url.TipoItem&'&'>
	</cfif>

	<cfquery name="rsDocumentos" datasource="#session.DSN#" maxrows="#MaximoRegistros#">
		  select 
			hd.HDid, hd.CCTcodigo as tipo, hd.Dtref, hd.Ddocumento, hd.Ddocref,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
			hd.Dfecha , hd.Dvencimiento  , s.Mcodigo , hd.Dtotal as Monto , 
			ed.Dsaldo, 
			(select o.Oficodigo
				from Oficinas o <cf_dbforceindex name="PK_OFICINAS">
				  where o.Ecodigo = hd.Ecodigo
						 and o.Ocodigo = hd.Ocodigo	
			) as oficodigo,
			hd.Ccuenta , 
			(select m.Miso4217 
				from Monedas m <cf_dbforceindex name="Monedas_01">
				  where m.Ecodigo = hd.Ecodigo
				  and m.Mcodigo = hd.Mcodigo
			) as moneda, 
			<cf_dbfunction name="concat" args="s.SNnumero,s.SNnombre,' ','(',s.SNidentificacion,')' ">as CorteNombre,
			
			case when cer.timbre is not null
					then '<img border=''0'' src=''/cfmx/sif/imagenes/iindex.gif'' alt=''Mostrar CFDI''>'
				else null end as Timbre,
			#form.FTimbre# as FTimbre,
			CASE
			   WHEN ee.Eperiodo IS NOT NULL THEN CAST(ee.Eperiodo AS varchar) 
			   WHEN he.Eperiodo IS NOT NULL THEN CAST(he.Eperiodo AS varchar) 
			   WHEN he2.Eperiodo IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(he2.Eperiodo AS varchar) 
			   WHEN ee2.Eperiodo IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(ee2.Eperiodo AS varchar) 

			   WHEN he3.Eperiodo IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(he3.Eperiodo AS varchar) 
			   WHEN ee3.Eperiodo IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(ee3.Eperiodo AS varchar)
			   ELSE '--'
			END AS Eperiodo,
			CASE
			   WHEN ee.Emes IS NOT NULL THEN CAST(ee.Emes AS varchar) 
			   WHEN he.Emes IS NOT NULL THEN CAST(he.Emes AS varchar) 
			   WHEN he2.Emes IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(he2.Emes AS varchar) 
			   WHEN ee2.Emes IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(ee2.Emes AS varchar) 

			   WHEN he3.Emes IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(he3.Emes AS varchar) 
			   WHEN ee3.Emes IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(ee3.Emes AS varchar)
			   ELSE '--'
			END AS Emes,
			CASE
			   WHEN ee.Edocumento IS NOT NULL THEN CAST(ee.Edocumento AS varchar) 
			   WHEN he.Edocumento IS NOT NULL THEN CAST(he.Edocumento AS varchar) 
			   WHEN he2.Edocumento IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(he2.Edocumento AS varchar) 
			   WHEN ee2.Edocumento IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(ee2.Edocumento AS varchar)

			   WHEN he3.Edocumento IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(he3.Edocumento AS varchar) 
			   WHEN ee3.Edocumento IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(ee3.Edocumento AS varchar)
			   ELSE '--'
			END AS Edocumento,
			CASE
			   WHEN ee.Oorigen IS NOT NULL THEN CAST(ee.Oorigen AS varchar) 
			   WHEN he.Oorigen IS NOT NULL THEN CAST(he.Oorigen AS varchar) 
			   WHEN he2.Oorigen IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(he2.Oorigen AS varchar) 
			   WHEN ee2.Oorigen IS NOT NULL AND hd.CCTcodigo='RE' and b.IdContable IS NOT NULL
			   THEN CAST(ee2.Oorigen AS varchar)

			   WHEN he3.Oorigen IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(he3.Oorigen AS varchar) 
			   WHEN ee3.Oorigen IS NOT NULL AND hd.CCTcodigo='RE' and b2.IdContable IS NOT NULL
			   THEN CAST(ee3.Oorigen AS varchar)
			   ELSE '--'
			END AS Oorigen
			from HDocumentos hd
				inner join SNegocios s
				  on s.Ecodigo = hd.Ecodigo
				 and s.SNcodigo = hd.SNcodigo

			  	inner join CCTransacciones t
			    	on t.Ecodigo   = hd.Ecodigo
					and t.CCTcodigo  = hd.CCTcodigo
					<!--- and t.CCTtipo = 'D' --->
					and t.CCTpago = 0
					
					<cfif isdefined("form.DocumentoSaldo")>
						inner join Documentos ed
					<cfelse>
						left outer join Documentos ed
					</cfif>
						on ed.Ecodigo     = hd.Ecodigo
						and ed.CCTcodigo  = hd.CCTcodigo
						and ed.Ddocumento = hd.Ddocumento
						and ed.SNcodigo   = hd.SNcodigo
					<!--- Timbre --->
		 			<cfif isdefined("form.FTimbre") and form.FTimbre LT 2><!--- Mostrar Todos o sin timbre --->
				LEFT JOIN CERepositorio cer ON cer.IdContable = hd.IDcontable and cer.origen like 'CCFC'
						and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento)) <!--- and cer.IdDocumento = hd.IDdocumento --->
					<cfelseif isdefined("form.FTimbre") and form.FTimbre EQ 2><!--- Mostrar con timbre --->
				INNER JOIN CERepositorio cer ON cer.IdContable = hd.IDcontable and cer.origen like 'CCFC'
						and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento)) <!--- and cer.IdDocumento = hd.IDdocumento --->
					</cfif><!--- Fin Timbre --->
			LEFT OUTER JOIN EContables ee 
				ON ee.IDcontable = hd.IDcontable
			LEFT OUTER JOIN HEContables he
				ON he.IDcontable = hd.IDcontable
			outer apply(SELECT top 1  bm.IDcontable
			   FROM BMovimientos bm
			   WHERE bm.CCTcodigo ='RE'
			      and bm.IDcontable is not null
			     AND bm.Ddocumento=  rtrim(ltrim(hd.Ddocumento)) )b
			LEFT OUTER JOIN HEContables he2 ON he2.IDcontable =b.IDcontable
			LEFT OUTER JOIN EContables ee2 ON ee2.IDcontable = b.IDcontable
			outer apply(SELECT top 1  hhd.IDcontable from HDContables hhd
						where hhd.Ddocumento =  rtrim(ltrim(hd.Ddocumento))
 						and hhd.Dreferencia='RE'
						)b2
			LEFT OUTER JOIN HEContables he3 ON he3.IDcontable = b2.IDcontable
			LEFT OUTER JOIN EContables ee3 ON ee3.IDcontable = b2.IDcontable

			Where hd.Ecodigo = #Session.Ecodigo#
			<cfif isdefined("url.Documento") and len(trim(url.Documento)) eq 0>
				<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
					<cfif DateDiff("d", "#url.FechaIni#", "#url.FechaFin#")>
						and hd.Dfecha  between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">  
									   and  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#"> 
					<cfelse>
						and hd.Dfecha  between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#">  
									   and  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#"> 
					</cfif>
				</cfif>
				<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni)) and isdefined("url.FechaFin") and not len(trim(url.FechaFin))>
					and hd.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaIni)#">
				</cfif>
				<cfif isdefined("url.FechaIni") and not len(trim(url.FechaIni)) and isdefined("url.FechaFin") and len(trim(url.FechaFin))>
					and hd.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaFin)#"> 
				</cfif>
			</cfif>
            
			<cfif isdefined("url.FechaVenIni") and len(trim(url.FechaVenIni)) and isdefined("url.FechaVenFin") and len(trim(url.FechaVenFin))>
				<cfif DateDiff("d", "#url.FechaVenIni#", "#url.FechaVenFin#")>
                    and hd.Dvencimiento  between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenIni)#">  
                                   and  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenFin)#"> 
                <cfelse>
                    and hd.Dvencimiento  between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenFin)#">  
                                   and  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenIni)#"> 
                </cfif>
            </cfif>
            <cfif isdefined("url.FechaVenIni") and len(trim(url.FechaVenIni)) and isdefined("url.FechaVenFin") and not len(trim(url.FechaVenFin))>
                and hd.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenIni)#">
            </cfif>
            <cfif isdefined("url.FechaVenIni") and not len(trim(url.FechaVenIni)) and isdefined("url.FechaVenFin") and len(trim(url.FechaVenFin))>
                and hd.Dvencimiento <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.FechaVenFin)#"> 
            </cfif>
            
			<cfif isdefined("url.Documento") and len(trim(url.Documento))>
				and hd.Ddocumento = '#url.Documento#'
			</cfif>
			<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
				and hd.SNcodigo = #url.SNcodigo#
			</cfif>
			<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
				and hd.CCTcodigo = '#url.CCTcodigo#'
			</cfif>
            <cfif isdefined("url.CFid") and len(trim(url.CFid))>
                and exists (select 1 from HDDocumentos hdd
                		   where coalesce(hdd.CFid,0) = #url.CFid#
                           and hdd.HDid = hd.HDid)
            </cfif>
			<cfif isdefined("url.DocumentoSaldo") and len(trim(url.DocumentoSaldo))>
                and ed.Dsaldo > 0
            </cfif>
			<!--- Sin timbre--->
			<cfif isdefined("form.FTimbre") and form.FTimbre EQ 1>
				and cer.IdRep is null
			</cfif><!--- --->
			
		order by s.SNcodigo, s.Mcodigo, hd.CCTcodigo, hd.Ddocumento
	</cfquery>
	<cfif isdefined("url.botonExcel")>
		<cfquery name="rsDocexcel" dbtype="query" maxrows="1001">
			select Tipo as TipoTransaccion,
			SNnumero as Num_SN, 
			SNidentificacion+'-'+SNnombre as SocioNegocio,
			 Ddocumento as Documento,  Dfecha as FechaDoc, DVencimiento as FechaVenc, Moneda as Moneda, monto as Monto, Dsaldo as Saldo, Oficodigo as Oficina,Edocumento as Poliza,Eperiodo as Periodo,Emes as Mes			
			from rsDocumentos
		</cfquery>
		<cf_QueryToFile query="#rsDocexcel#" filename="ConsultadeDocumentosdeCC#DateFormat(Now(), "m/d/y")#.xls" titulo="Consulta de Documentos de CC #DateFormat(Now(), "m/d/y")#">
	</cfif>


	<!--- <cfif isdefined("rsDocumentos") and rsDocumentos.recordcount GT 5000>
		<cf_errorCode	code = "50167"
						msg  = "La consulta generó mas de 5000 registros (@errorDat_1@), debe restringir el criterio de selección"
						errorDat_1="#rsDocumentos.recordcount#"
		>
		<cfabort>
	</cfif> --->
</cfif>
<cfset docSal="">
<cfset LB_DetDocto = t.Translate('LB_DetDocto','Detalle del Documento')>
<cfset Regresar = t.Translate('Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_ConsDoctoCC = t.Translate('LB_ConsDoctoCC','Consulta de Documentos de CxC')>
<cfset LB_USUARIO = t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_FechaDesde = t.Translate('LB_FechaDesde','Fecha Desde')>
<cfset LB_FechaHasta = t.Translate('LB_FechaHasta','Fecha Hasta')>
<cfset LB_Tipo = t.Translate('LB_TipoTrans','Tipo Transacci&oacute;n','RFacturasCC2.xml')>

<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>

<cfset LB_Documento = t.Translate('LB_Documento','Documento','RFacturasCC2.xml')>
<cfset LB_FechaDoc = t.Translate('LB_FechaDoc','Fecha Doc')>
<cfset LB_FechaVenc = t.Translate('LB_FechaVenc','Fecha Venc.')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_TimbreFiscal = t.Translate('LB_TimbreFiscal','Timbre Fiscal')>
<cfset LB_Poliza = t.Translate('LB_Poliza','Poliza')>
<cfset LB_Periodo = t.Translate('LB_Periodo','Periodo')>
<cfset LB_Mes = t.Translate('LB_Mes','Mes')>
<cfset LB_Origen = t.Translate('LB_Origen','Origen')>

<cfif isdefined("url.DocumentoSaldo")>
	<cfset docSal="DocumentoSaldo=#url.DocumentoSaldo#">
</cfif>
<cf_templateheader title="#LB_ConsDoctoCC#">
<table cellpadding="2" cellspacing="0" border="0" width="100%">
	<tr>
		
		<tr><td colspan="8" align="center" style="font:bold; padding:4px;" bgcolor="#CCCCCC"><cfoutput><h2>#LB_ConsDoctoCC#.</h2></cfoutput></td></tr>
		<tr><td colspan="8" align="right">
				<cfoutput><a onclick="fnImgDownload('#dataurl#'); " style="cursor:pointer;" >Descarga</a>
				<a onclick="fnImgDownload('#dataurl#');">	
					<img src="/cfmx/sif/imagenes/Cfinclude.gif" style="cursor:pointer" class="noprint" title="Download" border="0">
				</a></cfoutput>
		</td></tr>
		<td colspan="8" align="right">
			<!--- <cfset params = "&SNcodigo=#url.SNcodigo#&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#&btnConsultar=#url.btnConsultar#&FechaVenIni=#url.FechaVenIni#&FechaVenFin=#url.FechaVenFin#&#docSal#&FTimbre=#url.FTimbre#"> --->
			<cfset params = dataurl>
			<cfif isdefined("url.CCTcodigo")>
				<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
			</cfif>
			
            <cfif isdefined("url.CFid")>
				<cfset params = params & '&CFid=#url.CFid#'>
			</cfif>
            
            <cfif isdefined("url.TipoItem")>
				<cfset params = params & '&DDtipo=#url.TipoItem#'>
			</cfif>
			<cf_rhimprime datos="/sif/cc/consultas/RFacturasCC2-reporte.cfm" paramsuri="#params#">
			<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
		</td>
      
	</tr>
	<tr><td colspan="9">&nbsp;</td></tr>
		<cfif isdefined("url.btnConsultar") and rsDocumentos.RecordCount LT MaximoRegistros>
			<cfif rsDocumentos.RecordCount GT 0>
				<tr>
					<td colspan="9">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#rsDocumentos#"
							desplegar="Tipo, Ddocumento, Dfecha, DVencimiento, Moneda, monto, Dsaldo, Oficodigo, Timbre,Edocumento,Eperiodo,Emes,Oorigen"
							etiquetas="#LB_Tipo#, #LB_Documento#, #LB_FechaDoc#, #LB_FechaVenc#, #LB_Moneda#, #LB_Monto#, #LB_Saldo#, #Oficina#,#LB_TimbreFiscal#,#LB_Poliza#,#LB_Periodo#,#LB_Mes#,#LB_Origen#"
							formatos="S, S, D, D, S, M, M, S, S, S, S, S, S"
							align="left, left, center, center, center, right, right, right, center, center, center, center, center"
							showlink="true"
							Cortes="CorteNombre"
							maxrows="0"
							pageindex=""
							ira="RFacturasCC2-DetalleDoc.cfm?1=1#params#"/>  
					</td>
				</tr>
				<tr><td colspan="9">&nbsp;</td></tr>
<cfset LB_FinConsulta = t.Translate('LB_FinConsulta','Fin de la Consulta')>
				<tr valign="top" align="center"><td colspan="9"><cfoutput>***************************** #LB_FinConsulta# *********************************</cfoutput></td></tr>
			<cfelse>
				<tr valign="top" align="center"> 
					<td colspan="9"   bgcolor="#CCCCCC" align="center">
<cfset LB_NoDatosRel = t.Translate('LB_NoDatosRel','No hay datos relacionados')>
                    
						<span style="font-size: 16px"><strong><cfoutput>*** #LB_NoDatosRel# ***</cfoutput></strong></span>
					</td>
				</tr>
			</cfif>
			<tr><td colspan="9">&nbsp;</td></tr>
		<cfelseif isdefined('rsDocumentos') and rsDocumentos.RecordCount GTE MaximoRegistros> 
			<tr valign="top" align="center"> 
				<td colspan="9"   bgcolor="#CCCCCC" align="center">
<cfset LB_NoDoctRes = t.Translate('LB_NoDoctRes','El n&uacute;mero de Documentos Resultantes')>
<cfset LB_ConsExc = t.Translate('LB_ConsExc','en la consulta exceden el l&iacute;mite permitido. Delimite la consulta con filtros m&aacute;s detallados')>
					<span style="font-size: 16px"><strong><cfoutput>*** #LB_NoDoctRes# *** <br>
					*** #LB_ConsExc#. ***</cfoutput></strong></span>
				</td>
			</tr>
		</cfif>
	</table>		
<cf_templatefooter >

<script language="javascript" type="text/javascript">
	function fnImgDownload(param){
		alert("hola"+param);
		window.location.replace("../"+param+'botonExcel=1');
	}
</script>