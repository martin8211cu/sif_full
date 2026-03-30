<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Nueva consulta de documentos para CxP.
 --->
<cfset LvarTablaUsar = "HEDocumentosCP ">
<cfset LvarTablaUsarD = "HDDocumentosCP ">

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
    
	<cfif isdefined("url.CPTcodigo")>
		<cfset form.tipo = url.CPTcodigo>
	</cfif>
    
	<cfquery name="HEDocumentosCP" datasource="#session.DSN#">
	 select IDdocumento from HEDocumentosCP
	  where  Ecodigo = #Session.Ecodigo#
  		and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
  		and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">
  		and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
	<cfif HEDocumentosCP.recordcount LT 1>
		<cfset LvarTablaUsar  = "EDocumentosCP ">
		<cfset LvarTablaUsarD = "DDocumentosCP ">
		<cfquery name="HEDocumentosCP" datasource="#session.DSN#">
		 select IDdocumento from EDocumentosCP
		  where  Ecodigo = #Session.Ecodigo#
			and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">
			and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfquery>
	</cfif>
	<cfset form.IDdocumento = HEDocumentosCP.IDdocumento>
		<cfset form.drdocumento = -1>
		<cfset form.cptrcodigo = -1>
		<cfset form.SNnumero = -1>
		<cfset form.fechaini = "">
		<cfset form.fechafin ="">
</cfif>
	<cfquery name="rsTipoTran" datasource="#session.DSN#">
		select count(1) as cantidad
		from CPTransacciones
		where Ecodigo = #session.Ecodigo#
			and CPTpago = 1
			and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
	</cfquery>

	<cfquery name="rsTipoTran1" datasource="#session.DSN#">
		select CPTtipo
		from CPTransacciones
		where Ecodigo = #session.Ecodigo#
			and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
	</cfquery>

	<cfif isdefined("rsTipoTran") and rsTipoTran.cantidad eq 1>
		<cfquery name="rsDoc" datasource="#session.DSN#">
			select 
				min(he.Cconcepto) as Cconcepto,
				min(he.Edocumento) as Asiento,
                min(he.Eperiodo) as Eperiodo,
                min(he.Emes) as Emes,
				0.00 as impuesto,
				sum(Dtotal) as subtotal, 
				-1 as IDdocumento,
				min(ma.CPTcodigo) as tipo,
				' ' as CPTRcodigo, 
				min(ma.Ddocumento) as Ddocumento, 
				' ' as DRdocumento,
				min(s.SNcodigo) as SNcodigo,  
				min(s.SNnumero) as SNnumero, 
				min(s.SNidentificacion) as SNidentificacion, 
				min(s.SNnombre) as SNnombre, 
				min(ma.Dfecha) as Dfechavenc, 
				sum(Dtotal) as EDsaldo,
				min(ma.Dfecha) as Dfecha , 
				min(ma.Dvencimiento) as Dvencimiento, 
				min(s.Mcodigo) as Mcodigo , 
				sum(ma.Dtotal) as Monto , 
				0.00 as Dsaldo, 
				min(o.Oficodigo) as Oficodigo,
				min(ma.Ccuenta) as Ccuenta , 
				min(m.Miso4217) as moneda,
                min(ma.Dtipocambio) as Tcambio, min(ma.Dfecha) as FTcambio,
                min( case
						when ee.Edocumento is not null then 'Poliza sin aplicar'
						when he.Edocumento is not null then 'Poliza aplicada'
						else 'IDcontable'
				end) as TipoAsiento
                
			from BMovimientosCxP ma
		            left outer join EContables ee
						on ee.IDcontable = ma.IDcontable
					left outer join HEContables he
						on he.IDcontable = ma.IDcontable
					inner join SNegocios s
						on s.SNcodigo = ma.SNcodigo
						and s.Ecodigo = ma.Ecodigo
					inner join Monedas m
						on m.Mcodigo = ma.Mcodigo
					inner join Oficinas o
						on o.Ecodigo = ma.Ecodigo
						and o.Ocodigo = ma.Ocodigo
			where ma.Ecodigo = #session.Ecodigo#
			  and ma.CPTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			  and ma.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
			  and ma.SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		</cfquery>
	
	<cfelse>
		<cfquery name="rsDoc" datasource="#session.DSN#">
				select 	
					coalesce (ee.Cconcepto, he.Cconcepto) 						as Cconcepto,  
					coalesce (ee.Edocumento, he.Edocumento, ma.IDcontable ) 	as Asiento,
                    
                     
                    coalesce (ee.Eperiodo, he.Eperiodo, ma.BMperiodo) 			as Eperiodo, 
                    coalesce (ee.Emes, he.Emes, ma.BMmes) 						as Emes,
                    
					case
						when ee.Edocumento is not null then 'Poliza sin aplicar'
						when he.Edocumento is not null then 'Poliza aplicada'
						else 'IDcontable'
					end															as TipoAsiento,
					(
						select round(sum (dos.DDtotallin),2)
						from #LvarTablaUsarD# dos
						where dos.IDdocumento = d.IDdocumento
					) as subtotal,
					d.Dtotal - coalesce((
						select round(sum (dos.DDtotallin),2)
						from #LvarTablaUsarD# dos
						where dos.IDdocumento = d.IDdocumento), 0.00) as impuesto,
					d.IDdocumento as IDdocumento, 
					d.CPTcodigo as tipo, 
					ma.CPTRcodigo, 
					d.Ddocumento, 
					ma.DRdocumento,
					s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
					Dfechavenc, EDsaldo,
					d.Dfecha , d.Dfechavenc  , s.Mcodigo , d.Dtotal as Monto , 0.00 as Dsaldo, o.Oficodigo,
					ma.Ccuenta , m.Miso4217 as moneda,d.EDtipocambioVal as Tcambio, d.EDtipocambioFecha as FTcambio
		
				from #LvarTablaUsar# d
	
					inner join SNegocios s
							on s.SNcodigo = d.SNcodigo
							and s.Ecodigo = d.Ecodigo
	
					inner join CPTransacciones t
							on t.CPTcodigo = d.CPTcodigo
							and t.Ecodigo  = d.Ecodigo
	
					left outer join BMovimientosCxP ma
	
									<!---
										Referencia al asiento solo buscaba en HEcontables, ahora tanto en aplicados como no aplicados
									--->
									left outer join EContables ee
										on ee.IDcontable = ma.IDcontable
									left outer join HEContables he
										on he.IDcontable = ma.IDcontable
	
							 on ma.SNcodigo = d.SNcodigo
							and ma.Ecodigo = d.Ecodigo
							and ma.CPTcodigo = d.CPTcodigo
							and ma.Ddocumento = d.Ddocumento
							and ma.CPTRcodigo = d.CPTcodigo
							and ma.DRdocumento = d.Ddocumento
	
					left outer join Oficinas o
							  on o.Ecodigo = d.Ecodigo
							 and o.Ocodigo = d.Ocodigo	
	
					left outer join Monedas m
							  on m.Mcodigo = d.Mcodigo
							  
			where d.SNcodigo = #form.SNcodigo#
				and d.Ddocumento = '#form.Ddocumento#'
				and d.CPTcodigo = '#form.tipo#'
				and d.Ecodigo = #session.Ecodigo#
		</cfquery>
	</cfif>
    
    
	<cfquery name="rsDetDoc" datasource="#session.DSN#">
	  	select hdd.DDlinea,hdd.DDcantidad as cantidad, hdd.DDpreciou as preciou, hdd.DDtotallin as total,
          case when  hdd.DDtipo = 'A' then 'Articulo'  else 'Servicio' end  as tipo, 
          <cf_dbfunction name="sPart" args="hdd.DDdescalterna,1,20"> as descItem,
          cc.Cformato as Cuenta, m.Miso4217 as Moneda,
          (select max(bm.Dfecha) from BMovimientosCxP bm
            where bm.Ecodigo = #session.Ecodigo#
              and bm.CPTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.tipo#">
              and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Ddocumento#">
              and bm.SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.SNcodigo#">
           ) as ultFechaPago
           
		from #LvarTablaUsar# hd
			inner join #LvarTablaUsarD# hdd
  			  on hd.IDdocumento = hdd.IDdocumento
            inner join Monedas m
                      on m.Mcodigo = hd.Mcodigo and hd.Ecodigo=m.Ecodigo
            inner join CContables cc
            	on hdd.Ccuenta= cc.Ccuenta and hdd.Ecodigo=cc.Ecodigo
                
		Where hd.Ecodigo = #Session.Ecodigo#
		   and hd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
        order by 1
	</cfquery> 
    
    <cfquery name="rsDocAmortizado" datasource="#session.DSN#">
	  	select Ccuenta,EDmesesAmort from Amort_DetalleCuenta
        Where Ecodigo = #Session.Ecodigo# and IdDocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#"> 
	</cfquery>
    
	<cfquery name="rsSaldoDocumento" datasource="#session.DSN#">
		select EDsaldo
		from EDocumentosCP
		where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
	</cfquery>

	<cfset LvarSaldoActual = 0.00>
	<cfif isdefined('rsSaldoDocumento') and rsSaldoDocumento.recordcount GT 0>
		<cfset LvarSaldoActual = rsSaldoDocumento.EDsaldo>
	</cfif>

<cfif not isdefined("url.pop")>
	<cf_templateheader title="SIF - Cuentas por Pagar">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle del Documento">
		<cfflush interval="32">
		<form name="form1" method="url" action="amortizacion-sql.cfm">
			<table width="100%" cellpadding="2" cellspacing="0" align="center">
				<tr>
					<td valign="top" width="50%">
						<cfset regresar = "amortizacionForm.cfm"> 
						<cfinclude template="../../sif/portlets/pNavegacionCP.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td>&nbsp;</td>
								<td colspan="8" align="right">
									<cfset params = ''>
									<cfset params = "&SNcodigo=#form.SNcodigo#&FechaIni=#form.FechaIni#&FechaFin=#form.FechaFin#&Ddocumento=#form.Ddocumento#">
									
									<cfif isdefined("form.CPTcodigo")>
										<cfset params = params & '&CPTcodigo=#form.CPTcodigo#'>
									</cfif>
	
									<cf_rhimprime datos="/sif/cp/consultas/RFacturasCP2-DetalleDoc.cfm" paramsuri="#params#">
									<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
								</td>
							</tr>		
							<tr><td colspan="4" class="tituloListas"><strong>&nbsp;Datos del Documento</strong></td></tr>
							<tr><td colspan="4"  bgcolor="CCCCCC"><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDoc.Ddocumento#</cfoutput></span></td></tr>
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
                                                
												<td align="right"><strong>Subtotal:&nbsp;</strong></td>
												<td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
                                                
											</tr>
											<tr>
												<td align="right"><strong>#rsDoc.TipoAsiento#:&nbsp;</strong></td>
												<td>#rsDoc.Cconcepto# - #rsDoc.Asiento#</td>
												<td align="right"><strong>Impuesto:&nbsp;</strong></td>
												<td>#LScurrencyFormat(rsDoc.impuesto,"none")#</td>
											</tr>
											<tr>
												<td align="right"><cfif len(trim(rsDoc.Eperiodo)) and (rsDoc.TipoAsiento eq 'Poliza aplicada' or rsDoc.TipoAsiento eq 'IDcontable')><strong>Periodo Contable:&nbsp;</strong><cfelse>&nbsp;</cfif></td>
                                                <td><cfif len(trim(rsDoc.Eperiodo)) and (rsDoc.TipoAsiento eq 'Poliza aplicada' or rsDoc.TipoAsiento eq 'IDcontable')>#rsDoc.Eperiodo#/#rsDoc.Emes#<cfelse>&nbsp;</cfif></td>
												<td align="right"><strong>Monto:&nbsp;</strong></td>
												<td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
											</tr>
											<tr>
												<td align="right"><strong>Tipo Cambio:&nbsp;</strong></td>
                                                <td>#rsDoc.Tcambio#</td>
												<td align="right"><strong>Saldo:&nbsp;</strong></td>
												<td>#LScurrencyFormat(LvarSaldoActual,"none")#</td>
											</tr>	
                                            <tr>
                                            	<td align="right"><strong>Fecha Tipo Cambio:&nbsp;</strong></td>
                                                <td>#LSDateformat(rsDoc.FTcambio,"dd/mm/yyyy")#</td>
                                            </tr>										
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr><td colspan="4">&nbsp;</td></tr>
										</table>
										<cfset saldo = rsDoc.EDsaldo>
										<cfset listaSNnumero = ListtoArray(form.SNnumero)>
										<cfset listaSNcodigo = ListtoArray(form.SNcodigo)> 
                                        <cfset TCambio = "#rsDoc.Tcambio#">                                       
										<cfif ArrayLen(listaSNnumero) GT 1>
                                            <input name="SNnumero" 	type="hidden" value="#listaSNnumero[1]#">
                                            <input name="SNcodigo" 	type="hidden" value="#listaSNcodigo[1]#">
										</cfif>
									</cfoutput>
								</td>
							</tr>
						</table>
						<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td class="tituloListas" style="border-bottom: 1px solid black;" colspan="7" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td>
							</tr>
                            
							<tr>
                            	<td nowrap align="center"><strong>Línea</strong></td>
                            	<td nowrap><strong>Descripci&oacute;n</strong></td>
                                <td nowrap align="center"><strong>Cuenta Financiera</strong></td>
                                <td nowrap align="center"><strong>&nbsp;Fecha Pago</strong></td>
                                <td nowrap align="center"><strong>Moneda</strong></td>
                                <td nowrap align="right"><strong>Precio Unitario</strong></td>
                                <td nowrap align="right"><strong>Total Linea</strong></td>
                        	</tr>
                            <cfset linea = 1>
							<cfoutput query="rsDetDoc">
                                <tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
                                    <td align="center">#linea#</td>
                                    <td>#rsDetDoc.descItem#</td>
                                    <td>#rsDetDoc.Cuenta#</td>
                                    <td align="center">#LSDateformat(rsDetDoc.ultFechaPago,"dd/mm/yyyy")#</td>
                                    <td align="center">#rsDetDoc.Moneda#</td>
                                    <td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDetDoc.preciou)#&nbsp;&nbsp;</td>
                                    <td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
                                </tr>
                                <cfset linea = linea + 1>
                           	</cfoutput>
                        </table>
					</td>	
				</tr>
                <tr><td>&nbsp;</td></tr>
                
                <tr>
                    <td>
                        <table width="100%" cellspacing="0" cellpadding="0">
                            <cfoutput>
                            <cfif rsDetDoc.recordcount GT 0>
                                <tr>
                                    <td align="rigth"><b>Meses por Amortizar :&nbsp;</b></td>
                                    <td><input name="meses" type="text" maxlength="2" size="3" 
									<cfif rsDocAmortizado.recordcount GT 0> value = "#rsDocAmortizado.EDmesesAmort#"</cfif>
                                    <cfif rsDocAmortizado.recordcount GT 0> readonly="readonly" </cfif>></td>
                                </tr>
                                <tr>
                                    <td align="rigth"><b>Cuenta Contable por Amortizar :&nbsp;</b></td>
                                    <td>
                                    <cfif rsDocAmortizado.recordcount GT 0>
                                        <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta" CFcuenta="CFcuenta" query="#rsDocAmortizado#" tabindex="2">
                                    <cfelse>
                                        <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1" ccuenta="Ccuenta" CFcuenta="CFcuenta" tabindex="2">
                                    </cfif>
                                    </td>                    
                                </tr>
                            </cfif>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
                                <td align="center"><input type="submit"  value="&lt;&lt; Regresar" name="btnConsultar" 
                                                    onclick="javascript:document.form1.action='amortizacionForm.cfm' "></td>
                                <cfif rsDetDoc.recordcount GT 0 and rsDocAmortizado.recordcount eq 0>                    
                                	<td align="center"><input type="submit"  value="Aplicar" name="btnAplicar" /></td>
                                </cfif>
                            </tr>                                
                            </cfoutput>
                        </table>
                    </td>
                </tr>
                
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>	
			
				<cfoutput>
				<input type="hidden" name="CPTcodigo" 	value="<cfif isdefined('form.CPTcodigo')>#form.CPTcodigo#</cfif>" />
				<input type="hidden" name="Documento" 	value="<cfif isdefined('form.Ddocumento')>#form.Ddocumento#</cfif>" />
                <input type="hidden" name="IDdocumento" 	value="<cfif isdefined('form.IDdocumento')>#form.IDdocumento#</cfif>" />
				<input type="hidden" name="FechaFin" 	value="<cfif isdefined('form.FechaFin')>#form.FechaFin#</cfif>" />
				<input type="hidden" name="FechaIni" 	value="<cfif isdefined('form.FechaIni')>#form.FechaIni#</cfif>" />
				<input type="hidden" name="fSNcodigo" 	value="<cfif isdefined('form.SNcodigo')>#form.SNcodigo#</cfif>" />
				<input type="hidden" name="fSNnumero" 	value="<cfif isdefined('form.SNnumero')>#form.SNnumero#</cfif>" />
                <input type="hidden" name="fSTipo" 		value="<cfif isdefined('form.tipo')>#form.tipo#</cfif>" />
                <input type="hidden" name= "TCambio" 	value="#TCambio#"/>
				<input type="hidden" name="btnConsultar" value="Consultar" />
                <input type="hidden" name="tlbUsar" value= "#LvarTablaUsar#" />
                <input type="hidden" name="tlbUsarD" value= "#LvarTablaUsarD#" />
				</cfoutput>
	
			</form>
			<cf_web_portlet_end>
		<cf_templatefooter>
<cfelse>
	<title>Detalle del Documento</title>
	<cf_templatecss>
	<fieldset><legend>Detalle del Documento</legend>
		<table width="100%" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td valign="top" width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="4" class="tituloListas"><strong>&nbsp;Datos del Documento</strong></td></tr>
						<tr><td colspan="4"  bgcolor="CCCCCC"><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDoc.Ddocumento#</cfoutput></span></td></tr>
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
											<td align="right"><strong>Subtotal:&nbsp;</strong></td>
											<td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td align="right"><strong>Asiento:&nbsp;</strong></td>
											<td>#rsDoc.Cconcepto# - #rsDoc.Asiento#</td>
											<td align="right"><strong>Impuesto:&nbsp;</strong></td>
											<td>#LScurrencyFormat(rsDoc.impuesto,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td align="right"><strong>Monto:&nbsp;</strong></td>
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
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Historial de Pagos/Aplicaciones</strong></td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
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
											<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsDetDoc.preciou)# &nbsp;&nbsp;</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
										</tr>
									</cfoutput>
									<td colspan="4" nowrap align="center">***** Fin de Detalle *****</td>
							  </table>
							</td>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
									  	<td nowrap><strong>&nbsp;Fecha Pago</strong></td>
										<td nowrap><strong>Tipo</strong></td>
										<td nowrap ><strong>Num. Pago</strong></td>
										<td nowrap align="right"><strong>Monto</strong></td>
										<td nowrap align="right"><strong>Saldo</strong></td>
									</tr>
									<cfset nuevoSaldo = saldo> 
									<cfset nuevoSaldo = rsDoc.Monto>
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#LSDateformat(rsHistorialPagos.Fecha,"dd/mm/yyyy")#</td>
											<td  nowrap>#rsHistorialPagos.CPTcodigo#</td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")# </td>
											<td  nowrap align="right">#LScurrencyFormat(abs(nuevoSaldo - abs(rsHistorialPagos.Aplicado)),"none")#
											<cfset nuevoSaldo = abs(nuevoSaldo - abs(rsHistorialPagos.Aplicado))>
											</td>
										</tr>
									</cfoutput>
									<tr><td colspan="5" nowrap align="center">***** Fin de Historial *****</td></tr>
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

