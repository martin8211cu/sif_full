<!---
	Creado por JARR
		Fecha: 23-11-2020.
		Motivo: Excel consulta de documentos para CC.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

<cfset params = ''>
<cfset MaximoRegistros = 1001>
<cfsetting requesttimeout="3600">

<cfif isdefined("url.btnExcel")>
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

	<cfquery name="rsDocumentos" datasource="#session.DSN#" >
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
			END AS Oorigen,

			CAST( isnull( (select top 1 timbre as timbre
							from CERepositorio
						    where Ecodigo  =3
						   	and IdRep = tim.IdRep),hd.TimbreFiscal) AS varchar) as UUID,
			isnull(icero.ticero,0) as re_iva0,
			isnull(i16.tid16,0) as re_iva16,
			hd.Dtotal - (select (round(sum(dos.DDtotal) ,2))
							from HDDocumentos dos
							where dos.HDid = hd.HDid
						) as re_IVA
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
			outer apply (select min(cer.IdRep) as IdRep, min(cer.IdContable) as IDcontable, min(cer.linea) as linea
							from CERepositorio cer
							where cer.origen like 'CCFC'
								and cer.IdContable = hd.IDcontable
								and ltrim(rtrim(cer.numDocumento)) = ltrim(rtrim(hd.Ddocumento)) ) tim
			outer apply (  select dd.DDpreciou as ticero from HDDocumentos dd
					 where HDid = hd.HDid 
					 and Icodigo='IVA0')icero
			outer apply (select dd.DDpreciou as tid16 from HDDocumentos dd
					  where HDid = hd.HDid 
					 and Icodigo='IVA16')i16
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

		<cfquery name="rsDocexcel" dbtype="query" >
			select Tipo as TipoTransaccion,
			SNnumero as Num_SN, 
			SNidentificacion+'-'+SNnombre as SocioNegocio,
			 Ddocumento as Documento,  Dfecha as FechaDoc, DVencimiento as FechaVenc, Moneda as Moneda,re_iva0 as Base_IVA_0,re_iva16 as Base_IVA_16,re_IVA as IVA, monto as Monto, Dsaldo as Saldo, Oficodigo as Oficina,Edocumento as Poliza,Eperiodo as Periodo,Emes as Mes,UUID			
			from rsDocumentos
		</cfquery>
		<cf_QueryToFile query="#rsDocexcel#" filename="ConsultadeDocumentosdeCC#DateFormat(Now(), "m/d/y")#.xls" titulo="Consulta de Documentos de CC #DateFormat(Now(), "m/d/y")#">

	<!--- <cflocation url="/cfmx/sif/cc/consultas/RFacturasCC2.cfm"> --->
</cfif>
<!---<script language="javascript" type="text/javascript">
document.form1.action            = "RFacturasCC2-reporte.cfm";
</script>--->
<cfinclude template="RFacturasCC2.cfm"></td>
