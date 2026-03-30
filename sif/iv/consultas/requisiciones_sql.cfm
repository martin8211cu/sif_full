<cfsetting requesttimeout="36000">
<cfif form.formato neq 'bightml'>
	<cfquery datasource="#session.dsn#" name="contar">
		select count(1) as cantidad
		from ERequisicion enc
			<cfif form.Tipo NEQ 'resumido'>
				inner join DRequisicion det
					on det.ERid = enc.ERid
					<cfif len(trim(form.CFiddesde)) and form.CFiddesde GT 0
							and len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						and det.CFid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFiddesde#">
						and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidhasta#">
					<cfelseif len(trim(form.CFiddesde)) and form.CFiddesde GT 0>
						and det.CFid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFiddesde#">
					<cfelseif len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						and det.CFid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidhasta#">
					</cfif>
			</cfif>
		where enc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		<cfif len(trim(form.ERdocumento))>
			and enc.ERdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ERdocumento#">
		</cfif>
		<cfif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0
				and len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
			and enc.ERFecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ERfechadesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ERfechahasta)#">
		<cfelseif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0>
			and enc.ERFecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ERfechadesde)#">
		<cfelseif len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
			and enc.ERFecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ERfechahasta)#">
		</cfif>
		<cfif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0
				and len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
			and enc.Aid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aiddesde#">
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aidhasta#">
		<cfelseif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0>
			and enc.Aid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aiddesde#">
		<cfelseif len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
			and enc.Aid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aidhasta#">
		</cfif>
		<cfif len(trim(form.TRcodigo)) and form.TRcodigo GT 0>
			and enc.TRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TRcodigo#">
		</cfif>
	</cfquery>
	<cfif contar.cantidad GT 5000>
		<cfset form.formato = 'bightml'>
	</cfif>
</cfif>

<cfsavecontent variable="myquery">
	<cfoutput>
		select enc.ERid, enc.ERdocumento as Documento, enc.ERdescripcion as Descripcion, enc.ERFecha as Fecha, 
			alm.Bdescripcion as Almacen, tre.TRdescripcion as TipoRequisicion
			<cfif form.Tipo NEQ 'resumido'>, cfu.CFdescripcion as CentroFuncional, 
			art.Acodigo as CodigoArticulo, art.Adescripcion as DescripcionArticulo, 
			round(coalesce(det.DRcantidad,0.0000),4) as Cantidad, round(coalesce(ext.Ecostou,0.0000),4) as CostoPromedio, 
			round(( coalesce(det.DRcantidad,0) * coalesce(ext.Ecostou,0) ) ,2) as Total, enc.ERusuario 
			</cfif>
		from ERequisicion enc
			<cfif form.Tipo NEQ 'resumido'>
				inner join DRequisicion det
						inner join CFuncional cfu
							on cfu.CFid = det.CFid
						inner join Articulos art
							on art.Aid = det.Aid
					on det.ERid = enc.ERid
					<cfif len(trim(form.CFiddesde)) and form.CFiddesde GT 0
							and len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						and det.CFid between #form.CFiddesde#
						and #form.CFidhasta#
					<cfelseif len(trim(form.CFiddesde)) and form.CFiddesde GT 0>
						and det.CFid >= #form.CFiddesde#
					<cfelseif len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						and det.CFid <= #form.CFidhasta#
					</cfif>
				inner join Existencias ext
					on ext.Aid = det.Aid
					and ext.Alm_Aid = enc.Aid
			</cfif>
			inner join Almacen alm
				on alm.Aid = enc.Aid
			inner join TRequisicion tre
				on tre.TRcodigo = enc.TRcodigo
				and tre.Ecodigo = enc.Ecodigo
		where enc.Ecodigo = #session.ecodigo#
		<cfif len(trim(form.ERdocumento))>
			and enc.ERdocumento = '#form.ERdocumento#'
		</cfif>
		<cfif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0
				and len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
			and <cf_dbfunction name="to_datechar" args="enc.ERFecha"> between #LSParseDateTime(form.ERfechadesde)#
			and #LSParseDateTime(form.ERfechahasta)#
		<cfelseif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0>
			and enc.ERFecha >= #LSParseDateTime(form.ERfechadesde)#
		<cfelseif len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
			and enc.ERFecha <= #LSParseDateTime(form.ERfechahasta)#
		</cfif>
		<cfif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0
				and len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
			and enc.Aid between #form.Alm_Aiddesde#
			and #form.Alm_Aidhasta#
		<cfelseif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0>
			and enc.Aid >= #form.Alm_Aiddesde#
		<cfelseif len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
			and enc.Aid <= #form.Alm_Aidhasta#
		</cfif>
		<cfif len(trim(form.TRcodigo)) and form.TRcodigo GT 0>
			and enc.TRcodigo = '#form.TRcodigo#'
		</cfif>
		order by enc.ERid
	</cfoutput>
</cfsavecontent>

<cfif isdefined("form.btnDownload")>
	<cftry>
		<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
		<cfoutput>
			#myquery#
		</cfoutput>
		</cf_jdbcquery_open>
		<cf_QueryToFile query="#rsReporte#" filename="Requisiciones#form.Tipo#.xls" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
<cfelseif isdefined("form.btnConsultar")>
	<cftry>
		<cfif form.formato eq 'bightml'>
			<cfheader name="Content-Disposition" value="attachment;filename=Requisiciones#form.Tipo#.htm" >
		</cfif>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
		<cfoutput>
			#myquery#
		</cfoutput>
		</cf_jdbcquery_open>
		<cfif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0>
			<cfquery datasource="#session.DSN#" name="rsAlmdesde">
				select Bdescripcion
				from Almacen
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
				and Aid = <cfqueryparam value="#form.Alm_Aiddesde#" cfsqltype="cf_sql_numeric" >  
			</cfquery>
		</cfif>
		<cfif len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
			<cfquery datasource="#session.DSN#" name="rsAlmhasta">
				select Bdescripcion
				from Almacen
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
				and Aid = <cfqueryparam value="#form.Alm_Aidhasta#" cfsqltype="cf_sql_numeric" >  
			</cfquery>
		</cfif>
		<cfif len(trim(form.TRcodigo)) and form.TRcodigo GT 0>
			<cfquery datasource="#session.DSN#" name="rsTRequisicion">
				select TRcodigo, TRdescripcion
				from TRequisicion 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
				and TRcodigo = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char" >  
			</cfquery>
		</cfif>
		<cfif form.Tipo NEQ 'resumido'>
			<cfif len(trim(form.CFiddesde)) and form.CFiddesde GT 0>
				<cfquery datasource="#session.DSN#" name="rsCFdesde">
					select CFdescripcion
					from CFuncional
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
					and CFid = <cfqueryparam value="#form.CFiddesde#" cfsqltype="cf_sql_numeric" >  
				</cfquery>
			</cfif>
			<cfif len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
				<cfquery datasource="#session.DSN#" name="rsCFhasta">
					select CFdescripcion
					from CFuncional
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
					and CFid = <cfqueryparam value="#form.CFidhasta#" cfsqltype="cf_sql_numeric" >  
				</cfquery>
			</cfif>
		</cfif>
		<html>
		<head>
			<meta http-equiv="content-type" content="text/html; charset=utf-8" />
			<style>
					h1.corte {
						PAGE-BREAK-AFTER: always;}
					.titulo_empresa {
						font-size:16px;
						font-weight:bold;
						text-align:center;}
					.titulo_empresa2 {
						font-size:14px;
						font-weight:bold;
						text-align:center;}
					.titulo_reporte {
						font-size:12px;
						font-style:italic;
						text-align:center;}
					.titulo_filtro {
						font-size:10px;
						font-style:italic;
						text-align:center;}
					.titulo_columna {
						font-size:10px;
						font-weight:bold;
						background-color:#CCCCCC;
						text-align:left;}
					.titulo_columnar {
						font-size:10px;
						font-weight:bold;
						background-color:#CCCCCC;
						text-align:right;}
					.grupo1 {
						font-size:10px;
						font-weight:bold;
						background-color:#CCCCCC;
						text-align:left;}
					.detalle {
						font-size:10px;
						text-align:left;}
					.detaller {
						font-size:10px;
						text-align:right;}
					.mensaje {
						font-size:10px;
						text-align:center;}
					.paginacion {
						font-size:10px;
						text-align:center;}
				</style>
		</head>
		<body>
		<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
		<table id="tablabotones" width="98%" align="center" cellpadding="0" cellspacing="0" border="0" >
			<cfif form.formato neq 'bightml'>
			<tr> 
				<td align="right" nowrap>
					<a href="javascript:regresar();" tabindex="-1">
						<img src="/cfmx/sif/imagenes/back.gif"
						alt="Regresar"
						name="regresar"
						border="0" align="absmiddle">
					</a>
					<a href="javascript:imprimir();" tabindex="-1">
						<img src="/cfmx/sif/imagenes/impresora.gif"
						alt="Imprimir"
						name="imprimir"
						border="0" align="absmiddle">
					</a>
					<!--- <a id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
						<img src="/cfmx/sif/imagenes/Cfinclude.gif"
						alt="Salvar a Excel"
						name="SALVAEXCEL"
						border="0" align="absmiddle">
					</a> --->
				</td>
			</tr>
			<tr><td><hr></td></tr>
			</cfif>
		</table>
		<cfset ncols=5>
		<cfset rowsbypage=57>
		<cfset rowcount=0>
		<cfset encrows=0>
		<cfset encsinpage=0>
		<cfsavecontent variable="encabezado">
			<cfoutput>
				<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_empresa">#session.Enombre#</td></tr>
				<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_empresa2">Reporte #Form.Tipo# de Requisiciones</td></tr>
				<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">Fecha del Reporte: #LSDateFormat(Now(),'dd/mm/yyyy')#</td></tr>
				<cfif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0
						and len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Desde #LSDateFormat(form.ERfechadesde,'dd/mm/yyyy')#
							hasta #LSDateFormat(form.ERfechahasta,'dd/mm/yyyy')#
					</td></tr>
				<cfelseif len(trim(form.ERfechadesde)) and form.ERfechadesde GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Desde #LSDateFormat(form.ERfechadesde,'dd/mm/yyyy')#
					</td></tr>
				<cfelseif len(trim(form.ERfechahasta)) and form.ERfechahasta GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Hasta #LSDateFormat(form.ERfechahasta,'dd/mm/yyyy')#
					</td></tr>
				</cfif>
				<cfif len(trim(form.ERdocumento))>
					<tr><td colspan="#nCols#" class="titulo_reporte">Documento #form.ERdocumento#</td></tr>
				</cfif>
				<cfif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0
						and len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Desde el Almac&eacute;n #rsAlmdesde.Bdescripcion#
							hasta #rsAlmhasta.Bdescripcion#
					</td></tr>
				<cfelseif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Desde el Almac&eacute;n #rsAlmdesde.Bdescripcion#
					</td></tr>
				<cfelseif len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Hasta el Almac&eacute;n #rsAlmhasta.Bdescripcion#
					</td></tr>
				</cfif>
				<cfif len(trim(form.TRcodigo)) and form.TRcodigo GT 0>
					<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
							Tipo de Requisici&oacute;n #rsTRequisicion.TRdescripcion#
					</td></tr>
				</cfif>
				<cfif form.Tipo NEQ 'resumido'>
					<cfif len(trim(form.CFiddesde)) and form.CFiddesde GT 0
							and len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
								Desde el Centro Funcional #rsCFdesde.CFdescripcion#
								hasta #rsCFhasta.CFdescripcion#
						</td></tr>
					<cfelseif len(trim(form.CFiddesde)) and form.CFiddesde GT 0>
						<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
								Desde el Centro Funcional #rsCFdesde.CFdescripcion#
						</td></tr>
					<cfelseif len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
						<cfset encrows=encrows+1><tr><td colspan="#nCols#" class="titulo_reporte">
								Hasta el Centro Funcional #rsCFhasta.CFdescripcion#
						</td></tr>
					</cfif>
				</cfif>
				<cfset encrows=encrows+1><tr><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
			</cfoutput>
		</cfsavecontent>
		<cfsavecontent variable="cortepagina">
			<cfoutput>
			<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
			</cfoutput>
		</cfsavecontent>
		<cfsavecontent variable="reporte">
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
				<cfoutput>
					#encabezado#
				</cfoutput>
				<cfif form.Tipo EQ 'resumido'>
					<tr>
						<td class="titulo_columna">Documento:&nbsp;</td>
						<td class="titulo_columna">Descripci&oacute;n:&nbsp;</td>
						<td class="titulo_columna">Fecha:&nbsp;</td>
						<td class="titulo_columna">Almac&eacute;n:&nbsp;</td>
						<td class="titulo_columna">Tipo de Requisici&oacute;n:&nbsp;</td>
					</tr>
				</cfif>
				<cfset corte = "">
				<cfset Totalcorte = 0>
				<cfoutput query="rsReporte" group="ERid">
					<cfif form.Tipo NEQ 'resumido'>
						<cfsavecontent variable="tituloscorte">
							<tr>
								<td colspan="#nCols#">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td class="titulo_columna">Documento:&nbsp;</td>
										<td class="titulo_columna">#Documento#</td>
										<td class="titulo_columna">Descripci&oacute;n:&nbsp;</td>
										<td class="titulo_columna">#Descripcion#</td>
										<td class="titulo_columna">Fecha:&nbsp;</td>
										<td class="titulo_columna">#LSDateFormat(Fecha,'dd/mm/yyyy')#</td>
									  </tr>
									  <tr>
										<td class="titulo_columna">Almac&eacute;n:&nbsp;</td>
										<td class="titulo_columna">#Almacen#</td>
										<td class="titulo_columna">Tipo de Requisici&oacute;n:&nbsp;</td>
										<td class="titulo_columna">#TipoRequisicion#</td>
										<td class="titulo_columna">Centro Funcional:&nbsp;</td>
										<td class="titulo_columna">#CentroFuncional#</td>
									  </tr>
									  <tr>
										<td class="titulo_columna">Usuario:&nbsp;</td>
										<td  colspan="5 " class="titulo_columna">#ERusuario#</td>

									  </tr>									  
									</table>
								</td>
							</tr>
							<tr>
								<td class="titulo_columna">Art&iacute;culo</td>
								<td class="titulo_columna">Descripci&oacute;n</td>
								<td class="titulo_columnar">Catidad</td>
								<td class="titulo_columnar">Costo Promedio</td>
								<td class="titulo_columnar">Total</td>
							</tr>
						</cfsavecontent>
						<cfsavecontent variable="Totales">
							<tr>
								<td  align="right" colspan="#nCols-1#">
									<strong>Total por requisicin</strong>
								</td>
								<td align="right">
									#LSNumberFormat(Totalcorte,',9.00')#
								</td>
							</tr>
							<tr>
								<td  colspan="#nCols#">&nbsp;</td>
							</tr>	
							<cfset Totalcorte = 0>
						</cfsavecontent>
						
						<cfif ( rowcount + encrows + ( 3 * encsinpage ) + 1 ) lte rowsbypage>
							<cfif corte neq ''>
								#Totales#
							</cfif>
							<cfset corte = ERid>
							#tituloscorte#
						</cfif>
						<cfset encsinpage = encsinpage + 1>
						<cfoutput>
							<cfset rowcount = rowcount + 1>
							<cfif ( rowcount + encrows + ( 3 * encsinpage ) + 1 ) gt rowsbypage>
									#cortepagina#
									#encabezado#
									#tituloscorte#
									<cfset rowcount=1>
									<cfset encsinpage=1>									
							</cfif>
							<tr>
								<td>#CodigoArticulo#</td>
								<td>#DescripcionArticulo#</td>
								<td align="right">#LSNumberFormat(Cantidad,'9.00')#</td>
								<td align="right">#LSNumberFormat(CostoPromedio,'9.0000')#</td>
								<td align="right">#LSNumberFormat(Total,'9.00')#</td>
							</tr>
							<cfset Totalcorte = Totalcorte + Total>
						</cfoutput>
					<cfelse>
						<tr>
							<td>#Documento#</td>
							<td>#Descripcion#</td>
							<td>#LSDateFormat(Fecha,'dd/mm/yyyy')#</td>
							<td>#Almacen#</td>
							<td>#TipoRequisicion#</td>
						  </tr>
					</cfif>
				</cfoutput>
				<cfoutput>
				<cfif form.Tipo NEQ 'resumido'>
					<tr>
						<td  align="right" colspan="#nCols-1#">
							<strong>Total por requisicin</strong>
						</td>
						<td align="right">
							#LSNumberFormat(Totalcorte,',9.00')#
						</td>
					</tr>
					<tr>
						<td  colspan="#nCols#">&nbsp;</td>
					</tr>	
				</cfif>
				<tr><td colspan="#nCols#">&nbsp;</td></tr>
				<tr><td colspan="#nCols#" class="titulo_filtro">(**) El costo final se determina cuando se aplica el documento</td></tr>
				<tr><td colspan="#nCols#" class="titulo_filtro">--Fin del Reporte--</td></tr>
				</cfoutput>
			</table>
		</cfsavecontent>
		<!--- Pinta el Reporte --->
		<cfoutput>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td>
				#reporte#
				<cfset tempfile = GetTempDirectory()>
				<cfset session.tempfile_xls = #tempfile# & "/tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".xls">
				<cffile action="write" file="#session.tempfile_xls#" output="#reporte#" nameconflict="overwrite">
			</td>
			</tr>
		</table>
		</cfoutput>
		<table id="tablabotones2" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<tr><td>&nbsp;</td></tr>
			<tr>
			<td>
			<cfoutput>
			<form action="requisiciones.cfm" method="post" name="form1" style="margin:0">
				<input type="hidden" name="ERfechadesde" id="ERfechadesde" value="#form.ERfechadesde#"/>
				<input type="hidden" name="ERfechahasta" id="ERfechahasta" value="#form.ERfechahasta#"/>
				<input type="hidden" name="ERdocumento" id="ERdocumento" value="#form.ERdocumento#"/>
				<input type="hidden" name="Alm_Aiddesde" id="Alm_Aiddesde" value="#form.Alm_Aiddesde#"/>
				<input type="hidden" name="Alm_Aidhasta" id="Alm_Aidhasta" value="#form.Alm_Aidhasta#"/>
				<input type="hidden" name="CFiddesde" id="CFiddesde" value="#form.CFiddesde#"/>
				<input type="hidden" name="CFidhasta" id="CFidhasta" value="#form.CFidhasta#"/>
				<input type="hidden" name="TRcodigo" id="TRcodigo" value="#form.TRcodigo#"/>
				<input type="hidden" name="Formato" id="Formato" value="#form.Formato#"/>
				<input type="hidden" name="Tipo" id="Tipo" value="#form.Tipo#"/>
				<input type="hidden" name="rptpaso" id="rptpaso" value="1"/>
				<!---<cf_botones values="Regresar" tabindex="2">--->
			</form>
			</cfoutput>
			</td>
			</tr>
		</table>
		<!--- Manejo de los Botones --->
		<script language="javascript1.2" type="text/javascript">
			function regresar() {
				document.form1.submit();
			}
		
			function imprimir() {
				var tablabotones = document.getElementById("tablabotones");
				var tablabotones2 = document.getElementById("tablabotones2");
				tablabotones.style.display = 'none';
				tablabotones2.style.display = 'none';
				window.print();
				tablabotones.style.display = '';
				tablabotones2.style.display = '';
			}
		
			function SALVAEXCEL() {
				var EXCEL = document.getElementById("EXCEL");
				var file =  "to_excel.cfm";
				var string=  "width=400,height=200,toolbar=no,directories=no,menubar=yes,resizable=yes,dependent=yes";
				var hwnd = window.open(file,'excel',string) ;
				if (navigator.appName == "Netscape") {   
					 hwnd.focus();
				}
			}
		</script>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfif>

