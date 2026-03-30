<cf_rhimprime datos="/sif/cm/consultas/OrdenCompra-facturas.cfm" paramsuri="&EOidorden=#url.EOidorden#"> 
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsDocumentos" datasource="#session.DSN#">
		 select hd.IDdocumento, 
				hd.CPTcodigo as tipo, 
				hd.Ddocumento,
				hd.Dfecha as Dfecha, 
				hd.Mcodigo as Mcodigo,
				hd.SNcodigo as SNcodigo,
				hd.Ocodigo as Ocodigo,
				min(hd.Ddocumento) as DRdocumento,
				min(hd.CPTcodigo) as CPTRcodigo,
				min(s.SNnumero) as SNnumero,
				min(hd.Dfechavenc) as Dfechavenc, 
				sum(hdd.DDtotallin) as Monto,
				min(hd.Dtotal) as MontoDoc, 
				(select min(o.Oficodigo) from Oficinas o where o.Ecodigo = hd.Ecodigo and o.Ocodigo = hd.Ocodigo) as Oficodigo,
				(select min(m.Miso4217) from Monedas m where m.Mcodigo = hd.Mcodigo) as Moneda, 
				min(s.SNnumero #_Cat# ' - ' #_Cat# s.SNnombre #_Cat# '   ' #_Cat# '(' #_Cat#s.SNidentificacion #_Cat# ')')  as CorteNombre,
				#url.EOidorden# as EOidorden 

			from DOrdenCM do

					inner join HDDocumentosCP hdd

							inner join HEDocumentosCP  hd

									inner join SNegocios s
									on s.SNcodigo = hd.SNcodigo
									and s.Ecodigo = hd.Ecodigo

							on hd.IDdocumento = hdd.IDdocumento

					on hdd.DOlinea = do.DOlinea

			where do.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
			group by 
				hd.IDdocumento,
				hd.CPTcodigo,
				hd.Ddocumento,
				hd.Mcodigo,
				hd.Ecodigo,
				hd.Ocodigo, 
				hd.SNcodigo,
				hd.Dfecha
	order by hd.SNcodigo, hd.Mcodigo, hd.CPTcodigo, hd.Dfecha  desc
	</cfquery>
<br>

<table width="98%" align="center" border="0" cellpadding="1" cellspacing="1" >
<tr><td colspan="2"><cfinclude template="AREA_HEADER.cfm"></td></tr>
	<tr><td colspan="2" align="center" style="font:bold; padding:4px;" class="tituloListas"><h2>Consulta de Documentos de CxP.</h2></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
		<cfif rsDocumentos.RecordCount LT 1001>
			<cfif rsDocumentos.RecordCount GT 0>
				<tr>
					<td colspan="2">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#rsDocumentos#"
							desplegar="Tipo, Ddocumento,  Dfecha, Dfechavenc, Moneda, Monto, MontoDoc, Oficodigo"
							etiquetas="Tipo Transacci&oacute;n, Documento,  Fecha Doc, Fecha Venc., Moneda, Monto, MontoDoc, Oficina"
							formatos="S, S,  D, D, S, M, M, S"
							align="left, left,  center, center, center, right, right, right"
							showlink="true"
							Cortes="CorteNombre"
							maxrows="0"
							pageindex=""
							ira="OrdenCompra-facturasDetalle.cfm"/>  
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr valign="top" align="center"><td colspan="2">*** Fin de la Consulta ***</td></tr>
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
	</table>	
