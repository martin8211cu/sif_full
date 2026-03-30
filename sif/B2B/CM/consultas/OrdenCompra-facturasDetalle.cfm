<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset params = '' >

<cfif isdefined("url.EOidorden") and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>
<cfif isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
	<cfset form.SNnumero = url.SNnumero >
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset form.Ddocumento = url.Ddocumento >
</cfif>
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfif isdefined("url.DRdocumento") and not isdefined("form.DRdocumento")>
	<cfset form.DRdocumento = url.DRdocumento >
</cfif>
<cfif isdefined("url.CPTRcodigo") and not isdefined("form.CPTRcodigo")>
	<cfset form.CPTRcodigo = url.CPTRcodigo >
</cfif>
<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
	<cfset form.IDdocumento = url.IDdocumento >
</cfif>

<cfif isdefined("form.SNcodigo")>
	<cfset params = params & '&SNcodigo=#form.SNcodigo#' >
</cfif>
<cfif isdefined("form.SNnumero")>
	<cfset params = params & '&SNnumero=#form.SNnumero#' >
</cfif>
<cfif isdefined("form.Ddocumento")>
	<cfset params = params & '&Ddocumento=#form.Ddocumento#' >
</cfif>
<cfif isdefined("form.tipo")>
	<cfset params = params & '&tipo=#form.tipo#' >
</cfif>
<cfif isdefined("form.DRdocumento")>
	<cfset params = params & '&DRdocumento=#form.DRdocumento#' >
</cfif>
<cfif isdefined("form.CPTRcodigo")>
	<cfset params = params & '&CPTRcodigo=#form.CPTRcodigo#' >
</cfif>
<cfif isdefined("form.IDdocumento")>
	<cfset params = params & '&IDdocumento=#form.IDdocumento#' >
</cfif>

<cf_rhimprime datos="/sif/B2B/CM/consultas/OrdenCompra-facturasDetalle.cfm" paramsuri="&EOidorden=#form.EOidorden#"> 
<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Nueva consulta de documentos para CxP.
 --->
 <cfquery name="rsDoc" datasource="#session.DSN#">
		  select 
			 IDdocumento, CPTcodigo as tipo, EDtref, Ddocumento, EDdocref,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
			Dfecha , Dfechavenc, s.Mcodigo , Dtotal as Monto ,  EDsaldo, o.Oficodigo,
			Ccuenta , m.Miso4217 as moneda

			from HEDocumentosCP hd
				inner join SNegocios s
				  on hd.Ecodigo = s.Ecodigo
						 and hd.SNcodigo = s.SNcodigo
				inner join Oficinas o
				  on hd.Ecodigo = o.Ecodigo
						 and hd.Ocodigo = o.Ocodigo	
				inner join Monedas m
				  on m.Ecodigo = hd.Ecodigo
				  and m.Mcodigo = hd.Mcodigo
			
			Where hd.Ecodigo =  #session.Ecodigo# 
			  and hd.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			
			  and hd.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
			  and hd.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">

	union all
	
		 select 
			-1 as IDdocumento, ma.CPTcodigo as tipo, ma.CPTRcodigo, ma.Ddocumento, ma.DRdocumento,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
			ma.Dfecha , ma.Dvencimiento  , s.Mcodigo , ma.Dtotal as Monto , 0.00 as Dsaldo, o.Oficodigo,
			ma.Ccuenta , m.Miso4217 as moneda

			from SNegocios s 
			inner join CPTransacciones t
			    on t.Ecodigo   = s.Ecodigo
			   and t.CPTpago   = 1
			inner join BMovimientosCxP ma 		<!--- -- (index BMovimientos03) --->
				 on ma.SNcodigo  = s.SNcodigo
				and ma.Ecodigo   = s.Ecodigo
			    and ma.CPTcodigo = t.CPTcodigo
				and ma.Ecodigo   = t.Ecodigo
				and ma.CPTcodigo <> ma.CPTRcodigo
			    
			inner join HEDocumentosCP d 		<!--- -- (index HDocumentos01) --->
			    on d.Ecodigo    = ma.Ecodigo
			   and d.SNcodigo   = ma.SNcodigo
			   and d.CPTcodigo  = ma.CPTRcodigo
			   and d.Ddocumento = ma.DRdocumento
			inner join Oficinas o
				  on d.Ecodigo = o.Ecodigo
						 and d.Ocodigo = o.Ocodigo	
			 inner join Monedas m
				  on m.Ecodigo = d.Ecodigo
				  and m.Mcodigo = d.Mcodigo
		where  ma.Ecodigo =  #session.Ecodigo# 
	   	  and s.SNcodigo = #session.B2B.SNcodigo#

			 and ma.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
			and ma.DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DRdocumento#">

			and ma.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			and ma.CPTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTRcodigo#">

		order by SNcodigo, Mcodigo, tipo, Dfecha  desc
	</cfquery>
	<cfquery name="rsDetDoc" datasource="#session.DSN#">
	  select hdd.DDcantidad as cantidad, 
	  		#LvarOBJ_PrecioU.enSQL_AS("hdd.DDpreciou","preciou")#, 
			hdd.DDtotallin as total, 
			  case when  hdd.DDtipo = 'A' then 'Articulo'  else 'Servicio' end  as tipo, <cf_dbfunction name="sPart" args="hdd.DDdescalterna,1,20"> as descItem
		from HEDocumentosCP hd
		inner join HDDocumentosCP hdd
		  on hd.IDdocumento = hdd.IDdocumento
		Where hd.Ecodigo =  #Session.Ecodigo# 
		   and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
			   
	union all

		select	
			 hdd.DDcantidad as cantidad, 
			 #LvarOBJ_PrecioU.enSQL_AS("hdd.DDpreciou","preciou")#, 
			 hdd.DDtotallin as total, 
			  case when  hdd.DDtipo = 'A' then 'Articulo'  else 'Servicio' end  as tipo, <cf_dbfunction name="sPart" args="hdd.DDdescalterna,1,20"> as descItem
			from SNegocios s 
			inner join CPTransacciones t
				on t.Ecodigo   = s.Ecodigo
			   and t.CPTpago   = 1
			inner join BMovimientosCxP ma <!--- -- (index BMovimientos03) --->
				 on ma.SNcodigo  = s.SNcodigo
				and ma.Ecodigo   = s.Ecodigo
				and ma.CPTcodigo = t.CPTcodigo
				and ma.Ecodigo   = t.Ecodigo
				and ma.CPTcodigo <> ma.CPTRcodigo
				
			inner join HEDocumentosCP hd <!--- -- (index HDocumentos01) --->
				on hd.Ecodigo    = ma.Ecodigo
			   and hd.SNcodigo   = ma.SNcodigo
			   and hd.CPTcodigo  = ma.CPTRcodigo
			   and hd.Ddocumento = ma.DRdocumento
			inner join HDDocumentosCP hdd
				 on hd.IDdocumento = hdd.IDdocumento
			inner join Oficinas o
				  on o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo	
			 inner join Monedas m
				  on m.Ecodigo = hd.Ecodigo
				  and m.Mcodigo = hd.Mcodigo
		Where ma.Ecodigo =  #session.Ecodigo# 
			and s.SNcodigo = #session.B2B.SNcodigo#

			and ma.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
			and ma.DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DRdocumento#">

			and ma.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			and ma.CPTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTRcodigo#">
	</cfquery> 
	<cfquery name="rsHistorialPagos" datasource="#session.DSN#">
		select <cf_dbfunction name="to_sdateDMY" args="bm.Dfecha"> as Fecha , bm.CPTcodigo as CPTcodigo, bm.Ddocumento as Documento, m.Miso4217, bm.BMmontoref as Aplicado
		 from HEDocumentosCP hd
			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.SNcodigo = hd.SNcodigo
				and bm.CPTRcodigo = hd.CPTcodigo
				and bm.DRdocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CPTRcodigo <> bm.CPTcodigo or bm.DRdocumento <> bm.Ddocumento)
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">

		union all
			
		 select <cf_dbfunction name="to_sdateDMY" args="bm.Dfecha"> as Fecha , bm.CPTRcodigo as CPTcodigo, bm.DRdocumento as Documento, m.Miso4217, bm.BMmontoref as Aplicado
		 from HEDocumentosCP hd
			inner join BMovimientosCxP bm
				on bm.Ecodigo = hd.Ecodigo
				and bm.SNcodigo = hd.SNcodigo
				and bm.CPTcodigo = hd.CPTcodigo
				and bm.Ddocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CPTRcodigo <> bm.CPTcodigo or bm.DRdocumento <> bm.Ddocumento)
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where bm.Ecodigo =  #session.Ecodigo# 
			and bm.SNcodigo = #session.B2B.SNcodigo#

			and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
			and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DRdocumento#">

			and bm.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			and bm.CPTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTRcodigo#">
		
		order by 1
	</cfquery> 



	
<cf_templatecss>
	<form name="form1" method="url" action="OrdenCompra-facturas.cfm">
		<table width="98%" align="center" cellpadding="2" cellspacing="0" align="center">
			<tr><td colspan="2"><cfinclude template="AREA_HEADER.cfm"></td></tr>	
			<tr>
				<td valign="top" width="50%">
					<cfset regresar = "/cfmx/sif/cp/consultas/RFacturasCP2.cfm"> 
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">		
						<tr><td colspan="4" align="center" style="font:bold; padding:4px;" class="tituloListas"><h2>Consulta de Detalle de Documentos de CxP.</h2></td></tr>
						<tr><td colspan="4" class="tituloListas" align="center"><strong>&nbsp;Documento: <cfoutput>&nbsp;#rsDoc.Ddocumento#</cfoutput></strong></td></tr>
						<tr>
							<td colspan="2" align="center">
								<cfoutput>
									<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center"> 
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
											<td align="right"><strong>Socio:&nbsp;</strong></td>
										  	<td >#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
										  	<td align="right"><strong>Fecha:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
									 	</tr>
										<tr>
											<td align="right"><strong>Identificaci&oacute;n:&nbsp;</strong></td>
										  	<td>#rsDoc.SNidentificacion#</td>
										  	<td align="right"><strong>Vencimiento:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.Dfechavenc,"dd/mm/yyyy")# </td>
									  	</tr>
										<tr>
											<td align="right"><strong>Tipo Transacci&oacute;n:&nbsp;</strong></td>
											<td>#rsDoc.Tipo#</td>
											<td align="right"><strong>Moneda:&nbsp;</strong></td>
											<td>#rsDoc.Moneda#</td>
										</tr>
										<tr>
										  	<td align="right"><strong>Oficina:&nbsp;</strong></td>
										  	<td>#rsDoc.Oficodigo#</td>
										  	<td align="right"><strong>Monto:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr><td colspan="4">&nbsp;</td></tr>
									</table>
									<cfset saldo = rsDoc.EDsaldo>
									<cfset listaSNnumero = ListtoArray(form.SNnumero)>
									<cfset listaSNcodigo = ListtoArray(form.SNcodigo)>
									<cfif ArrayLen(listaSNnumero) GT 1>
									<input name="SNnumero" type="hidden" value="#listaSNnumero[1]#">
									<input name="SNcodigo" type="hidden" value="#listaSNcodigo[1]#">
									</cfif>
								</cfoutput>
							</td>
						</tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" >
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid gray;">  
									<tr><td colspan="4" class="tituloListas" style="border-bottom: 1px solid gray;" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td></tr>
									<tr>
										<td nowrap align="center"><strong>Cantidad</strong></td>
										<td nowrap><strong>Desc Item</strong></td>
										<td nowrap align="right"><strong>Precio Unitario</strong></td>
										<td nowrap align="right"><strong>Total Linea</strong></td>
									</tr>
									<cfoutput query="rsDetDoc">
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<td align="center">#rsDetDoc.cantidad#</td>
											<td> #rsDetDoc.descItem# (#rsDetDoc.tipo#)</td>
											<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDetDoc.preciou)#&nbsp;&nbsp;</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
										</tr>
									</cfoutput>
									<td colspan="4" nowrap align="center">**** Fin de Detalle ****</td>
							  </table>
							</td>
							<td>&nbsp;</td>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid gray;">
									<tr><td colspan="5" class="tituloListas" style="border-bottom: 1px solid gray;" ><strong>Historial de Pagos/Aplicaciones</strong></td></tr>
									<tr>
									  <td nowrap><strong>&nbsp;Fecha Pago</strong></td>
										<td nowrap><strong>Tipo</strong></td>
										<td nowrap ><strong>Num. Pago</strong></td>
										<td nowrap align="right"><strong>Monto</strong></td>
										<td nowrap align="right"><strong>Saldo</strong></td></tr>
										<cfset nuevoSaldo = saldo> 
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#LSDateformat(rsHistorialPagos.Fecha,"dd/mm/yyyy")#</td>
											<td  nowrap>#rsHistorialPagos.CPTcodigo#</td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")# </td>
											<td  nowrap align="right">#LScurrencyFormat(abs(nuevoSaldo-rsHistorialPagos.Aplicado),"none")#
											  <cfset nuevoSaldo = abs(nuevoSaldo - rsHistorialPagos.Aplicado)>
											</td>
										</tr>
									</cfoutput>
									<tr><td colspan="5" nowrap align="center">**** Fin de Historial ****</td></tr>
								</table>
							</td>
						</tr>
						<tr align="center" valign="top"><td colspan="2">&nbsp;</td></tr>
					</table>
				</td>	
			</tr>
			<tr><td align="center"><cfif not isdefined("url.imprimir")><input type="submit" class="btnAnterior" value="Regresar" name="btnConsultar" ></cfif></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>	
		
			<cfoutput>
			<input type="hidden" name="EOidorden" value="<cfif isdefined('form.EOidorden')>#form.EOidorden#</cfif>" />
			</cfoutput>
		</form>
