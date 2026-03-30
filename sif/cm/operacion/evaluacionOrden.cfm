<cfinclude template="../../Utiles/sifConcat.cfm">
<cfparam name="LvarEncontrado" default="false">
<!---<cfparam name="LvarCumplio" default="false">  se cambia este parametro a solicitud de Alvaro chaves el 23 dic 2010, cambiar cuando
se borre la linea 166--->
<cfparam name="LvarCumplio" default="true">   <!---esta linea se debe de borrar cuando se habilite la linea 4--->

<!--- Inicializacion de Estructura de Ordenes de Compra --->
<cfif not isdefined("Session.Compras.OrdenCompra")>
	<cfset Session.Compras.OrdenCompra = StructNew()>
<cfelse>
	<cfset StructDelete(Session.Compras, "OrdenCompra")>
	<cfset Session.Compras.OrdenCompra = StructNew()>
</cfif>
<cfif isdefined("Form.ECid")>
	<cfset Session.Compras.OrdenCompra.ECid = Form.ECid>
</cfif>
<cfloop collection="#Form#" item="i">
	<cfif FindNoCase("DSconsecutivo_", i) NEQ 0
	   or FindNoCase("DClinea_", i) NEQ 0
	   or FindNoCase("ECnumero", i) NEQ 0
	   or FindNoCase("SNnombre", i) NEQ 0
	   or FindNoCase("Descripcion_", i) NEQ 0
	   or FindNoCase("Mnombre", i) NEQ 0
	   or FindNoCase("DCcantidad_", i) NEQ 0 
	   or FindNoCase("DCcantidadMax_", i) NEQ 0
	   or FindNoCase("ECid", i) NEQ 0
	   or FindNoCase("ECfechacot", i) NEQ 0
	   or FindNoCase("DCpreciou_", i) NEQ 0
	   or FindNoCase("Nota_", i) NEQ 0
	   or FindNoCase("NotaGlobal", i) NEQ 0
	   or FindNoCase("ESnumero", i) NEQ 0
	   or FindNoCase("Ucodigo", i) NEQ 0
	   or FindNoCase("ECtotal", i) NEQ 0
	   >
		<cfset Session.Compras.OrdenCompra[i] = StructFind(Form, i)>
	</cfif>
</cfloop>

<!--- Querys para construir combos --->
<cfquery name="rsTipoOrden" datasource="#Session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CMTOcodigo
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select rtrim(Rcodigo) as Rcodigo, Rdescripcion
	from Retenciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Rcodigo
</cfquery>

<cfquery name="rsUnidades" datasource="#Session.DSN#">
	select rtrim(Ucodigo) as Ucodigo, Udescripcion
	from Unidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Ucodigo
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMFPcodigo
</cfquery>
<!--- Evaluacion por Mejor Cotizacion --->
<cfif isdefined("Session.Compras.OrdenCompra.ECid") and Len(Trim(Session.Compras.OrdenCompra.ECid))>
	<cfquery name="rsCotizacion" datasource="#Session.DSN#">
	select 	
			d.SNid,
			a.CMPid,
			a.ECnumero,
			d.SNnombre,
			c.DSconsecutivo,
			b.DCcantidad,
			b.DSlinea,
			a.ECid,
			m.Mnombre,
			m.Miso4217,	
			a.ECfechacot,
			c.DStipo,
			c.Aid,			
			c.Cid,
			c.ACcodigo,
			c.ACid,
			case c.DStipo 	when 'A' then Adescripcion
							when 'S' then Cdescripcion
							when 'F' then c.DSdescripcion end as Descripcion,
			case a.ECestado when 5 then rtrim(b.Icodigo) else null end as Icodigo,
			b.DCporcimpuesto,
			i.Idescripcion,
			b.Ucodigo,
			b.DCconversion,
			u.Udescripcion,
			a.ECtipocambio,
			a.Mcodigo,
			a.SNcodigo,
			a.CMFPid,
            a.CMIid,
			es.ESnumero,
            case when b.DCpreciou * b.DCcantidad * 1.0 = 0 then 0 else 
			coalesce((b.DCdesclin * 100.0) / (b.DCpreciou * b.DCcantidad * 1.0), 0.00) end as PorcDescuento
			
	from ECotizacionesCM a
		inner join DCotizacionesCM b
			on a.Ecodigo = b.Ecodigo
			and a.ECid = b.ECid
            and b.DCcantidad != 0
<!--- 			and b.DCconversion = 1 --->
	
		inner join DSolicitudCompraCM c
			on b.DSlinea = c.DSlinea
		inner join ESolicitudCompraCM  es 
			on c.ESidsolicitud = es.ESidsolicitud and c.Ecodigo = es.Ecodigo
		inner join SNegocios d
			on a.Ecodigo = d.Ecodigo and a.SNcodigo = d.SNcodigo
		inner join Monedas m
			on a.Mcodigo = m.Mcodigo
		left outer join Articulos f
			on c.Aid = f.Aid
		left outer join Conceptos h
			on c.Cid = h.Cid
		left outer join ACategoria j
			on c.Ecodigo = j.Ecodigo and c.ACcodigo = j.ACcodigo
		left outer join AClasificacion k
			on c.Ecodigo = k.Ecodigo and c.ACcodigo = k.ACcodigo and c.ACid = k.ACid
		left outer join Impuestos i
			on b.Ecodigo = i.Ecodigo and b.Icodigo = i.Icodigo
		left outer join Unidades u
			on b.Ecodigo = u.Ecodigo and b.Ucodigo = u.Ucodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.OrdenCompra.ECid#">
		order by c.DSconsecutivo
	</cfquery>
    <cfquery name="rsTipoSol" datasource="#Session.DSN#">
		select count(1) as cantidad
    	from ECotizacionesCM ec
            inner join DCotizacionesCM dc
                on dc.Ecodigo = ec.Ecodigo and dc.ECid = ec.ECid and dc.DCcantidad != 0
            inner join DSolicitudCompraCM ds
                on ds.DSlinea = dc.DSlinea
            inner join ESolicitudCompraCM  es 
                on ds.ESidsolicitud = es.ESidsolicitud and ds.Ecodigo = es.Ecodigo
            inner join CMTiposSolicitud ts
                on ts.Ecodigo = es.Ecodigo and ts.CMTScodigo = es.CMTScodigo
           	inner join CMProcesoCompra pc
            	on pc.CMPid = ec.CMPid
		where ec.Ecodigo = #Session.Ecodigo#
		  and ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.OrdenCompra.ECid#">
          and ts.CMTSaprobarsolicitante = 1
          and pc.CMPestado >= 10 and pc.CMPestado < 50
	</cfquery>	
	<cfif not len(trim(rsCotizacion.Mcodigo))>
		<cfthrow message="La Cotización no tiene monto asociado!!! Acción Cancelada.">
	</cfif>
	
	<cfquery name="rsCotizacion1" datasource="#session.dsn#"> <!---Verifica si la orden de compra requiere garantia--->
		select a.TGidP 
		from CMProcesoCompra a 
		where CMPid = #rsCotizacion.CMPid#
        and 1=3          <!---solicitado por Alvaro Chaves el 23 dic 2010  RSC, borrar cuando se borre la linea 5--->
	</cfquery>
	

	<!---Moneda Local --->
  <cfquery name="rsLocal" datasource="#session.dsn#">
	  select Mcodigo 
	  from Empresas 
	  where Ecodigo = #session.Ecodigo#
 </cfquery>
	
	<cfif rsCotizacion1.TGidP neq ''>
		<!---Verifica las lineas de detalle de la solicitud  = a las de la garantia---->
		<cfquery name="rsVerificaLineas" datasource="#session.dsn#">
			select count(c.DSlinea) as cantidad, c.CMPid
			 from  ECotizacionesCM a
             inner join  DCotizacionesCM b
                on a.ECid = b.ECid
                and a.Ecodigo = b.Ecodigo
             inner join CMDProceso c
                on  b.DSlinea = c.DSlinea
             inner join CMProceso d
                on c.CMPid = d.CMPid
			 WHERE a.Ecodigo = #session.Ecodigo#
			    and  a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.OrdenCompra.ECid#">
				and b.DCcantidad != 0
				and d.CMPid_CM = a.CMPid
			group by c.CMPid 			
		</cfquery>
		
		<!---Lineas de detalle de la solicitud --->     
		<cfquery name="rsLineasS" datasource="#session.dsn#">   
			select count(*) as cantidad
			 from DCotizacionesCM b
			WHERE b.Ecodigo = #session.Ecodigo#
			and  b.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.OrdenCompra.ECid#">
		</cfquery>
		<cfset LvarCantidadS  = rsLineasS.cantidad>
		<cfset LvarFechaHoy = createdate(year(now()), month(now()), day(now()))>
		
			<cfloop query="rsVerificaLineas">
			
				<cfset LvarCantidad  = rsVerificaLineas.cantidad>
				
				<!--- variable--->
				
				<cfif LvarCantidad eq LvarCantidadS>
				<cfset LvarEncontrado = true>
				
				<!---Verifica que exista garantia asociada a la solicitud --->
					<cfquery name="rsCotizacion2" datasource="#session.dsn#">
                	select g.COEGid, dg.CODGFechaFin , a.Mcodigo as Mcodigo2,g.Mcodigo ,g.COEGFechaRecibe, a.ECtotal, g.COEGMontoTotal as monto
						from ECotizacionesCM a  
                  inner join SNegocios sn
                     on a.SNcodigo =sn.SNcodigo
                     and a.SNcodigo =  sn.SNcodigo 
                  inner join COHEGarantia g
                     on g.SNid = sn.SNid
                  inner join COHDGarantia dg
                     on dg.COEGid = g.COEGid
						WHERE a.Ecodigo = #session.Ecodigo#
						and  a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.OrdenCompra.ECid#">
						and g.COEGTipoGarantia = 1
						and g.COEGVersionActiva = 1
						and g.CMPid = #rsVerificaLineas.CMPid#					
					</cfquery>
					
			
					<cfif rsCotizacion2.recordcount gt 0>
					<cfquery name="rsConsulta" datasource="#session.dsn#"> <!---Verifica si la orden de compra requiere garantia--->
						select a.TGidP ,coalesce(tp.TGporcentaje,0) as TGporcentaje,tp.TGdescripcion,TGmonto,
						TGmanejaMonto,Mcodigo, case when TGmanejaMonto = 1 then 'Monto' else 'Porcentaje ' end as descripcionM
						from CMProcesoCompra a 
						left outer join TiposGarantia tp
							on tp.TGid = a.TGidP								
						where CMPid = #rsCotizacion.CMPid#
					</cfquery>
					
					<!---Verifica que el monto de la garantía este bien - valida con el tipo de cambio--->
						<cfloop query="rsCotizacion2">
							 <cfif rsLocal.Mcodigo eq rsCotizacion2.Mcodigo2>
								<cfset LvarTC = 1.00>
							 <cfelse>
									 <cfif #rsCotizacion2.Mcodigo2# neq ''>
										<cfquery name="rsTC" datasource="#session.DSN#">
											select TCventa, TCcompra
											from Htipocambio
											where Mcodigo = #rsCotizacion2.Mcodigo2#
											  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
											  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
										</cfquery>
										<cfset LvarTC = #rsTC.TCcompra#>
									<cfelse>
										<cfset LvarTC = 0>
									</cfif>
							 </cfif>
							 
							<cfif rsLocal.Mcodigo eq rsCotizacion2.Mcodigo>
								<cfset LvarTCG = 1.00>
							<cfelse>
								 <cfif #rsCotizacion2.Mcodigo# neq '' and #rsConsulta.TGmanejaMonto# eq 0>
									<cfquery name="rsTCG" datasource="#session.DSN#">
										select TCventa, TCcompra
										from Htipocambio
										where Mcodigo = #rsCotizacion2.Mcodigo#
										  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
										  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
									</cfquery>
									<cfset LvarTCG = #rsTCG.TCcompra#>
								<cfelseif #rsCotizacion2.Mcodigo# neq '' and #rsConsulta.TGmanejaMonto# eq 1>
									<cfquery name="rsTCG" datasource="#session.DSN#">
										select TCventa, TCcompra
										from Htipocambio
										where Mcodigo = #rsConsulta.Mcodigo#
										  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
										  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsCotizacion2.COEGFechaRecibe#">
									</cfquery>
									<cfset LvarTCG = #rsTCG.TCcompra#>
								</cfif>
							</cfif>

						  <cfif #rsCotizacion2.ECtotal# neq ''>
							 <cfset LvarM = #rsCotizacion2.ECtotal#>
						  <cfelse>
						  	 <cfset LvarM = 0>
						  </cfif>
						  
						 <cfif #rsCotizacion2.monto# neq ''>
							<cfset LvarM2 = #rsCotizacion2.monto#>
						 <cfelse>
							<cfset LvarM2 = 0>
						 </cfif>	 
						 
							<cfset LvarMonto =  #numberformat(LvarM  * LvarTC, "9.00")#>
							<cfset LvarMontoG = #numberformat(LvarM2 * LvarTCG,  "9.00")#>
								
							<cfif #rsConsulta.TGmanejaMonto# eq 1><!---Por Monto--->
								<cfset LvarMontoGarantia = #numberformat(rsConsulta.TGmonto * LvarTCG,  "9.00")#>
								
								
								 <cfif #LvarMontoGarantia# eq #LvarMontoG#>
									<cfset cumplio = 1>
									<cfset LvarCumplio = true>
									
								 <cfelseif  #LvarMontoG# lt #LvarMontoGarantia#>
									<cfset cumplio = 2>
								 <cfelse>
									<cfset cumplio = 3>
									<cfset LvarCumplio = true>
									
								 </cfif>
							<cfelse><!---Por Porcentaje--->
								 <cfif (#LvarMontoG# * #rsConsulta.TGporcentaje#) eq #LvarMonto#>
									<cfset cumplio = 1> <!---ok---> 
									<cfset LvarCumplio = true>
								 <cfelseif (#LvarMontoG# * #rsConsulta.TGporcentaje#) lt #LvarMonto#>
									<cfset cumplio = 2> <!---Falta--->
								 <cfelse>
									<cfset cumplio = 3> <!---ok--->
									<cfset LvarCumplio = true>
								 </cfif>	
								</cfif> 			
						
							<cfif cumplio eq 1 or cumplio eq 3>
								<cfset LvarCumplio = true>
								<cfset Fecha = rsCotizacion2.CODGFechaFin>
									<cfif Fecha gte LvarFechaHoy>
										<cfset LvarFecha = true>
									<cfelse>
										<cfset LvarFecha = false>
									</cfif>
								<cfelse>
									<cfset LvarFecha = false>
							</cfif>
						</cfloop>
					<cfelse>
						<cfset LvarEncontrado = false>
<!---						<cfset LvarCumplio = false>
--->					</cfif>
				</cfif>
			</cfloop>
<!---<cfif NOT LvarEncontrado>
		<cfthrow message="El Proveedor no ha entregado la Garantía para este proceso!">
	</cfif>
--->		
		</cfif>

	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
		var fp = new Object();
		<cfoutput query="rsCMFormasPago">
			fp['#CMFPid#'] = #CMFPplazo#;
		</cfoutput>
		
		function getPlazo(displayCtl, id) {
			if (fp[id] != null) {
				displayCtl.value = fp[id];
			}
		}

	</script>
	<cfoutput>
	<form name="form1" method="post" action="evaluar-Aplicar.cfm">
		<input type="hidden" name="opt" value="">
		<input type="hidden" name="ECid" value="#rsCotizacion.ECid#">
		<input type="hidden" name="CMPid" value="<cfif isdefined("rsCotizacion") and rsCotizacion.RecordCount NEQ 0>#rsCotizacion.CMPid#<cfelse>#form.CMPid#</cfif>">
		<cfif isdefined("Form.metodo") and Len(Trim(Form.metodo))>
			<input type="hidden" name="metodo" value="#Form.metodo#">
		</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2" bgcolor="##CCCCCC" style="border: 1px solid gray ">
				  <tr>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td align="right" nowrap class="fileLabel">Num.Cotizaci&oacute;n:</td>
								<td nowrap>
									#rsCotizacion.ECnumero#
								</td>
								<td align="right" nowrap class="fileLabel">Proveedor:</td>
								<td nowrap>
									#rsCotizacion.SNnombre#
								</td>
								<td align="right" nowrap class="fileLabel">Fecha Cotizaci&oacute;n:</td>
								<td nowrap>
									#LSDateFormat(rsCotizacion.ECfechacot, 'dd/mm/yyyy')#
								</td>
								<td align="right" nowrap class="fileLabel">Moneda:</td>
								<td nowrap>#rsCotizacion.Miso4217#</td>
								<td class="fileLabel" align="right" nowrap>Tipo Cambio:</td>
								<td>
								<input name="EOtc" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LsNumberFormat(rsCotizacion.ECtipocambio, ',9.00')#">
								</td>
							</tr>
						</table>
					</td>
				  </tr>
				  <tr>
					<td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td class="fileLabel" align="right" nowrap>Tipo Orden Compra:</td>
							<td>
								<select name="CMTOcodigo">
                                	<option value="" selected="selected">Seleccione el Tipo de Orden de Compra</option>
									<cfloop query="rsTipoOrden">
									<option value="#rsTipoOrden.CMTOcodigo#">#rsTipoOrden.CMTOdescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td class="fileLabel" align="right" nowrap>Retenci&oacute;n:</td>
							<td>
								<select name="Rcodigo">
									<option value="">(Ninguna)</option>
									<cfloop query="rsRetenciones">
									<option value="#rsRetenciones.Rcodigo#">#rsRetenciones.Rdescripcion#</option>
									</cfloop>
								</select>
							</td>
							<td class="fileLabel" align="right" nowrap>Forma de Pago:</td>
							<td>
								<select name="CMFPid" onChange="javascript: getPlazo(this.form.EOplazo, this.value);">
									<cfloop query="rsCMFormasPago">
										<option value="#CMFPid#" <cfif Len(Trim(rsCotizacion.CMFPid)) and rsCotizacion.CMFPid EQ CMFPid> selected</cfif>><!----#CMFPcodigo# - ----->#CMFPdescripcion#</option>
									</cfloop>
								</select>
							</td>
						  </tr>
						  <tr>
							<td class="fileLabel" align="right" nowrap>Observaciones:</td>
							<td>
								<input type="text" name="Observaciones" size="40" maxlength="255" value="">
							</td>
							<td class="fileLabel" align="right" nowrap>Plazo Cr&eacute;dito:</td>
							<td>
								<input name="EOplazo" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="" readonly>
							</td>
							<td class="fileLabel" align="right" nowrap>Porcentaje Anticipo:</td>
							<td>
								<input name="EOporcanticipo" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00">
							</td>
						  </tr>
						</table>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		  <tr>
			<td>
				<table border="0" cellpadding="2" cellspacing="0" align="center" width="90%">
				<tr>
					<td align="right" style="padding-right: 10px;" nowrap><strong>Linea Solicitud</strong></td>
					<td style="padding-right: 10px;" nowrap><strong>Item</strong></td>
					<td align="right" style="padding-right: 10px;" nowrap><strong>Cantidad</strong></td>
					<td style="padding-right: 10px;" nowrap><strong>Unidad</strong></td>
					<td style="padding-right: 10px;" nowrap><strong>Impuesto</strong></td>
				    <td style="padding-right: 10px;" nowrap><strong>% Descuento</strong></td>
				</tr>
				<cfloop query="rsCotizacion">
				<tr>	
					<td align="right" style="padding-right: 10px;" nowrap>
						#rsCotizacion.DSconsecutivo#
					</td>
					<td style="padding-right: 10px;" nowrap>
						#HTMLEditFormat(rsCotizacion.Descripcion)#
					</td>
					
					<td style="padding-right: 10px;" align="right" nowrap>
						#LSNumberFormat(Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&rsCotizacion.DSlinea), ',9.00')#
					</td>
					<td nowrap>
						<cfif Len(Trim(rsCotizacion.DCconversion)) NEQ 1.00>
							<select name="Ucodigo_#rsCotizacion.DSlinea#">
								<cfloop query="rsUnidades">
								<option value="#rsUnidades.Ucodigo#"<cfif rsUnidades.Ucodigo EQ rsCotizacion.Ucodigo> selected</cfif>>#rsUnidades.Udescripcion#</option>
								</cfloop>
							</select>
						<cfelse>
							#rsCotizacion.Udescripcion#
						</cfif>
					</td>
					<td nowrap>
						<cfif Len(Trim(rsCotizacion.Icodigo)) EQ 0>
							<cfquery name="rsImpuestos" datasource="#Session.DSN#">
								select rtrim(Icodigo) as Icodigo, Idescripcion #_Cat# ' - ' #_Cat# <cf_dbfunction name="to_char" args="Iporcentaje"> #_Cat# '%' as Idescripcion
								from Impuestos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and Iporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#rsCotizacion.DCporcimpuesto#">
								order by Icodigo
							</cfquery>
							
							<cfif rsImpuestos.recordCount GT 0>
							<select name="Icodigo_#rsCotizacion.DSlinea#">
								<cfloop query="rsImpuestos">
								<option value="#rsImpuestos.Icodigo#">#rsImpuestos.Idescripcion#</option>
								</cfloop>
							</select>
							<cfelse>
							<cfquery name="rsImpuestos" datasource="#Session.DSN#">
								select rtrim(Icodigo) as Icodigo, Idescripcion #_Cat# ' - ' #_Cat# <cf_dbfunction name="to_char" args="Iporcentaje"> #_Cat# '%' as Idescripcion
								from Impuestos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								order by Icodigo
							</cfquery>
							<select name="Icodigo_#rsCotizacion.DSlinea#">
								<option value="">No hay porcentajes de impuesto equivalentes al #rsCotizacion.DCporcimpuesto#%</option>
								<cfloop query="rsImpuestos">
								<option value="#rsImpuestos.Icodigo#">#rsImpuestos.Idescripcion#</option>
								</cfloop>
							</select>
							</cfif>
						<cfelse>
							#rsCotizacion.Idescripcion#
						</cfif>
					</td>
				    <td nowrap>
						#LSNumberFormat(rsCotizacion.PorcDescuento, ',9.00')#
					</td>
				</tr>
				</cfloop>
				<tr>
				  <td colspan="6" align="center" nowrap>
                  	<cfif rsTipoSol.cantidad>
                    	<cf_botones values="<< Anterior, Enviar Aprobación Solicitante,Verificar_Garantia_de_Proveedores" names="Anterior,AprobarS,Verificar_Garantia_de_Proveedores">
                    	<script type="text/javascript">
							function funcAprobarS(){
								objForm.CMFPid.required 		= false;
								objForm.EOplazo.required 		= false;
								objForm.Observaciones.required 	= false;
								objForm.EOtc.required			= false;
								objForm.EOporcanticipo.required = false;
								objForm.CMFPid.required 		= false;
								objForm.CMTOcodigo.required 	= false;
								return confirm("Esta seguro de enviar a aprobación la OC?");
							}
						</script>
                    <cfelse>
                    	<cf_botones values="<< Anterior, Finalizar,Verificar_Garantia_de_Proveedores" names="Anterior,Finalizar,Verificar_Garantia_de_Proveedores">
                    </cfif>
				  </td>
				</tr>
				<tr>
				  <td colspan="6" align="center" nowrap>&nbsp;</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</form>
	</cfoutput>

	<script language="javascript" type="text/javascript">
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		
		objForm.CMFPid.required 	= true;
		objForm.CMFPid.description 	= "Forma de Pago";
		
		objForm.CMTOcodigo.required 	= true;
		objForm.CMTOcodigo.description 	= "Tipo de orden de compra";
		
		objForm.EOplazo.required 	= true;
		objForm.EOplazo.description = "Plazo de Crédito";
		
		objForm.Observaciones.required 		= true;
		objForm.Observaciones.description 	= "Observaciones";
		
		objForm.EOtc.required 	 = true;
		objForm.EOtc.description = "Tipo Cambio";
		
		objForm.EOporcanticipo.required	   = true;
		objForm.EOporcanticipo.description = "Porcentaje Anticipo";
		
		function funcAnterior() {
			objForm.CMFPid.required 		= false;
			objForm.EOplazo.required 		= false;
			objForm.Observaciones.required 	= false;
			objForm.EOtc.required			= false;
			objForm.EOporcanticipo.required = false;
			objForm.CMFPid.required 		= false;
			objForm.CMTOcodigo.required 	= false;
			<cfif not lvarSolicitante>
				document.form1.action = "evaluarCotizaciones.cfm";
			<cfelse>
				document.form1.action = "evaluarCotizacionesSolicitante.cfm";
			</cfif>
			
			document.form1.opt.value = "4";
		}
		
		<cfset LvarFecha = ''>
		function funcFinalizar() 
		{ 
			<cfif rsCotizacion1.TGidP neq '' and NOT LvarEncontrado>   
				alert('El Proveedor no ha entregado la Garantía para este proceso!');
				return false;
			</cfif>
		
		   <cfif LvarFecha eq 'false'>
				alert('La Fecha de la Garantía No está Vigente!');
			   return false;	
			</cfif>
			
		   <cfif LvarCumplio eq 'false'>
				alert('No se puede Finalizar el proceso, el monto de la garantía entregada es menor al monto requerido!');
			   return false;	
			</cfif>

		}		
		
		function funcVerificar_Garantia_de_Proveedores()
		{
			objForm.Observaciones.required = false;
			window.open('GarantiaDetalleP.cfm?CMPid=<cfif isdefined('form.CMPid') and len(trim(#form.CMPid#))><cfoutput>#form.CMPid#</cfoutput></cfif>','popup','width=1200,height=700,left=100,top=50,scrollbars=yes');<!---?CMPid='+LvarCMPid--->
			return false;
		}		
		
		<cfoutput query="rsCotizacion">
			<cfif Len(Trim(rsCotizacion.Icodigo)) EQ 0>
				objForm.Icodigo_#rsCotizacion.DSlinea#.required = true;
				objForm.Icodigo_#rsCotizacion.DSlinea#.description = "Impuesto";
			</cfif>
			getPlazo(document.form1.EOplazo, document.form1.CMFPid.value);
		</cfoutput>
	</script>

<!--- Evaluacion por Mejores Lineas de Cotizacion --->
<cfelse>
 	<cfif NOT ISDEFINED('Form.DClinea') OR NOT LEN(TRIM(Form.DClinea))>
    	<cfthrow message="No hay ninguna linea de cotizacion seleccionada">
    </cfif>
	<cfquery name="rsCotizacionAll" datasource="#Session.DSN#">
	select 	a.CMPid,
			a.ECnumero,
			d.SNnombre,
			c.DSconsecutivo,
			b.DCcantidad,
			b.DSlinea,
			a.ECid,
			m.Mnombre,
			m.Miso4217,
			a.ECfechacot,
			c.DStipo,
			c.Aid,			
			c.Cid,
			c.ACcodigo,
			c.ACid,
			case c.DStipo when 'A' then Adescripcion
			when 'S' then Cdescripcion
			when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion#_Cat#'/'#_Cat# c.DSdescripcion end as Descripcion,
			case a.ECestado when 5 then rtrim(b.Icodigo) else null end as Icodigo,
			b.DCporcimpuesto,
			i.Idescripcion,
			b.Ucodigo,
			b.DCconversion,
			u.Udescripcion,
			a.ECtipocambio,
			a.Mcodigo,
			a.SNcodigo,
			a.CMFPid,
            a.CMIid,
            case when (b.DCpreciou * b.DCcantidad * 1.0) = 0 then 0 else 
			coalesce((b.DCdesclin * 100.0) / (b.DCpreciou * b.DCcantidad * 1.0), 0.00) end as PorcDescuento,
			coalesce(b.DCpreciou,0) as DCpreciou
			
	from ECotizacionesCM a
		inner join DCotizacionesCM b
			on a.Ecodigo = b.Ecodigo
			and a.ECid = b.ECid
            and b.DCcantidad != 0
	
		inner join DSolicitudCompraCM c
			on b.DSlinea = c.DSlinea
			and b.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#" list="yes" separator=",">)
		
		inner join SNegocios d
			on a.Ecodigo = d.Ecodigo
			and a.SNcodigo = d.SNcodigo
			
		inner join Monedas m
			on a.Mcodigo = m.Mcodigo
			
		left outer join Articulos f
			on c.Aid = f.Aid
	
		left outer join Conceptos h
			on c.Cid = h.Cid
	
		left outer join ACategoria j
			on c.Ecodigo = j.Ecodigo
			and c.ACcodigo = j.ACcodigo
	
		left outer join AClasificacion k
			on c.Ecodigo = k.Ecodigo
			and c.ACcodigo = k.ACcodigo
			and c.ACid = k.ACid
			
		left outer join Impuestos i
			on b.Ecodigo = i.Ecodigo
			and b.Icodigo = i.Icodigo
			
		left outer join Unidades u
			on b.Ecodigo = u.Ecodigo
			and b.Ucodigo = u.Ucodigo

		where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by c.DSconsecutivo
		
	</cfquery>
	<cfquery name="rsCotizacionEncabezado" dbtype="query">
		select distinct SNcodigo, SNnombre, Mcodigo, Mnombre, Miso4217, ECtipocambio, CMPid, CMFPid, CMIid
		from rsCotizacionAll
	</cfquery>
   
    
    <cfquery name="rsTipoSol" datasource="#Session.DSN#">
		select count(1) as cantidad
    	from ECotizacionesCM ec
            inner join DCotizacionesCM dc
                on dc.Ecodigo = ec.Ecodigo and dc.ECid = ec.ECid and dc.DCcantidad != 0
            inner join DSolicitudCompraCM ds
                on ds.DSlinea = dc.DSlinea
            inner join ESolicitudCompraCM  es 
                on ds.ESidsolicitud = es.ESidsolicitud and ds.Ecodigo = es.Ecodigo
            inner join CMTiposSolicitud ts
                on ts.Ecodigo = es.Ecodigo and ts.CMTScodigo = es.CMTScodigo
           	inner join CMProcesoCompra pc
            	on pc.CMPid = ec.CMPid
		where ec.Ecodigo = #Session.Ecodigo#
		  and dc.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#" list="yes" separator=",">)
          and ts.CMTSaprobarsolicitante = 1
          and pc.CMPestado >= 10 and pc.CMPestado < 50
	</cfquery>	

	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
		var fp = new Object();
		<cfoutput query="rsCMFormasPago">
			fp['#CMFPid#'] = #CMFPplazo#;
		</cfoutput>
		
		function getPlazo(displayCtl, id) {
			if (fp[id] != null) {
				displayCtl.value = fp[id];
			}
		}

	</script>
	<cfoutput>
	<form name="form1" method="post" action="evaluar-Aplicar.cfm" style="margin: 0; ">
		<input type="hidden" name="opt" value="">
		<input type="hidden" name="CMPid" value="<cfif isdefined("rsCotizacionAll") and rsCotizacionAll.RecordCount NEQ 0>#rsCotizacionEncabezado.CMPid#<cfelse>#form.CMPid#</cfif>">
		<cfif isdefined("Form.metodo") and Len(Trim(Form.metodo))>
			<input type="hidden" name="metodo" value="#Form.metodo#">
		</cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <cfloop query="rsCotizacionEncabezado">
			  <cfset IndexOrden = rsCotizacionEncabezado.currentRow>
			  <!--- Obtener la Forma de Pago Sugerida --->
			  <cfset FormaPago = rsCotizacionEncabezado.CMFPid>
			  <!--- Las líneas se van a distribuir por Proveedor, Moneda, Forma de Pago --->
			  <cfquery name="rsCotizacionLineas" dbtype="query">
				select *
				from rsCotizacionAll
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCotizacionEncabezado.SNcodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.Mcodigo#">
				and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.CMFPid#">
                <cfif len(trim(rsCotizacionEncabezado.CMIid))>
                	and CMIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.CMIid#">
                </cfif>
				order by DSconsecutivo
			  </cfquery>
			  <tr>
				<td>
					<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2" bgcolor="##CCCCCC" style="border: 1px solid gray ">
					  <tr>
						<td>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
							  <tr>
								<td align="right" nowrap class="fileLabel">Proveedor:</td>
								<td nowrap>
									#rsCotizacionEncabezado.SNnombre#
									<input type="hidden" name="SNcodigo_#IndexOrden#" value="#rsCotizacionEncabezado.SNcodigo#">
									<input type="hidden" name="Mcodigo_#IndexOrden#" value="#rsCotizacionEncabezado.Mcodigo#">
                                    <input type="hidden" name="CMIid_#IndexOrden#" value="#rsCotizacionEncabezado.CMIid#">
								</td>
								<td align="right" nowrap class="fileLabel">Moneda:</td>
								<td nowrap>#rsCotizacionEncabezado.Mnombre#</td>
								<td class="fileLabel" align="right" nowrap>Tipo Cambio:</td>
								<td>
									<input name="EOtc_#IndexOrden#" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LsNumberFormat(rsCotizacionEncabezado.ECtipocambio, ',9.00')#">
								</td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap>Tipo Orden Compra:</td>
								<td>
									<select name="CMTOcodigo_#IndexOrden#">
                                    	<option value="" selected="selected">Seleccione el Tipo de Orden de Compra</option>
										<cfloop query="rsTipoOrden">
										<option value="#rsTipoOrden.CMTOcodigo#">#rsTipoOrden.CMTOdescripcion#</option>
										</cfloop>
									</select>
								</td>
								<td class="fileLabel" align="right" nowrap>Retenci&oacute;n:</td>
								<td>
									<select name="Rcodigo_#IndexOrden#">
										<option value="">(Ninguna)</option>
										<cfloop query="rsRetenciones">
										<option value="#rsRetenciones.Rcodigo#">#rsRetenciones.Rdescripcion#</option>
										</cfloop>
									</select>
								</td>
								<td class="fileLabel" align="right" nowrap>Forma de Pago:</td>
								<td>
									<select name="CMFPid_#IndexOrden#" onChange="javascript: getPlazo(this.form.EOplazo_#IndexOrden#, this.value);">
										<cfloop query="rsCMFormasPago">
											<option value="#CMFPid#" <cfif Len(Trim(FormaPago)) and FormaPago EQ CMFPid> selected</cfif>><!----#CMFPcodigo# - ----->#CMFPdescripcion#</option>
										</cfloop>
									</select>
								</td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap>Plazo Cr&eacute;dito:</td>
								<td>
									<input name="EOplazo_#IndexOrden#" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="" readonly>
								</td>
								<td class="fileLabel" align="right" nowrap>% Anticipo:</td>
								<td>
									<input name="EOporcanticipo_#IndexOrden#" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00">
								</td>
								<td class="fileLabel" align="right" nowrap>Observaciones:</td>
								<td>
									<input type="text" name="Observaciones_#IndexOrden#" size="40" maxlength="255" value="">
								</td>
							  </tr>
							</table>
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td>
					<table border="0" cellpadding="2" cellspacing="0" align="center" width="90%">
					<tr>
						<td align="right" style="padding-right: 10px;" nowrap><strong>Linea Solicitud</strong></td>
						<td style="padding-right: 10px;" nowrap><strong>Num. Cotizaci&oacute;n</strong></td>
						<td style="padding-right: 10px;" nowrap><strong>Item</strong></td>
						<td align="right" style="padding-right: 10px;" nowrap><strong>Cantidad</strong></td>
						<td style="padding-right: 10px;" nowrap><strong>Unidad</strong></td>
						<td style="padding-right: 10px;" nowrap><strong>Impuesto</strong></td>
					    <td style="padding-right: 10px;" nowrap><strong>% Descuento</strong></td>
					</tr>
					<cfloop query="rsCotizacionLineas">
					<tr>	
						<td align="right" style="padding-right: 10px;" nowrap>
							<input type="hidden" name="linea_#rsCotizacionLineas.DSlinea#" value="#IndexOrden#">
							<input type="hidden" name="ECid_#rsCotizacionLineas.DSlinea#" value="#rsCotizacionLineas.ECid#">
							#rsCotizacionLineas.DSconsecutivo#
						</td>
						<td style="padding-right: 10px;" nowrap>
							#rsCotizacionLineas.ECnumero#
						</td>
						<td style="padding-right: 10px;" nowrap>
							#HTMLEditFormat(rsCotizacionLineas.Descripcion)#
						</td>
						<td style="padding-right: 10px;" align="right" nowrap>
							#LSNumberFormat(Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&rsCotizacionLineas.DSlinea), ',9.00')#
						</td>
						<td nowrap>
							<cfif Len(Trim(rsCotizacionLineas.DCconversion)) NEQ 1.00>
								<select name="Ucodigo_#rsCotizacionLineas.DSlinea#">
									<cfloop query="rsUnidades">
									<option value="#rsUnidades.Ucodigo#"<cfif rsUnidades.Ucodigo EQ rsCotizacionLineas.Ucodigo> selected</cfif>>#rsUnidades.Udescripcion#</option>
									</cfloop>
								</select>
							<cfelse>
								#rsCotizacionLineas.Udescripcion#
							</cfif>
						</td>
						<td nowrap>
							<cfif Len(Trim(rsCotizacionLineas.Icodigo)) EQ 0>
								<cfquery name="rsImpuestos" datasource="#Session.DSN#">
									select rtrim(Icodigo) as Icodigo, Idescripcion #_Cat# ' - ' #_Cat# <cf_dbfunction name="to_char" args="Iporcentaje"> #_Cat# '%' as Idescripcion
									from Impuestos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and Iporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#rsCotizacionLineas.DCporcimpuesto#">
									order by Icodigo
								</cfquery>
								
								<cfif rsImpuestos.recordCount GT 0>
								<select name="Icodigo_#rsCotizacionLineas.DSlinea#">
									<cfloop query="rsImpuestos">
									<option value="#rsImpuestos.Icodigo#">#rsImpuestos.Idescripcion#</option>
									</cfloop>
								</select>
								<cfelse>
								<cfquery name="rsImpuestos" datasource="#Session.DSN#">
									select rtrim(Icodigo) as Icodigo, Idescripcion #_Cat# ' - ' #_Cat# <cf_dbfunction name="to_char" args="Iporcentaje"> #_Cat# '%' as Idescripcion
									from Impuestos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									order by Icodigo
								</cfquery>
								
								<select name="Icodigo_#rsCotizacionLineas.DSlinea#">
									<option value="">No hay porcentajes de impuesto equivalentes al #rsCotizacionLineas.DCporcimpuesto#%</option>
									<cfloop query="rsImpuestos">
									<option value="#rsImpuestos.Icodigo#">#rsImpuestos.Idescripcion#</option>
									</cfloop>
								</select>
								</cfif>
							<cfelse>
								#rsCotizacionLineas.Idescripcion#
							</cfif>
						</td>
					    <td nowrap>
							<!----/////////////// RE-CALCULO DEL % DESCUENTO///////////---->	
							<cfif rsCotizacionLineas.PorcDescuento NEQ 0>
								<!----
								<cfset vn_Anterior = rsCotizacionLineas.DCcantidad * rsCotizacionLineas.DCpreciou><!---Variable con el precio * cantidad original cotizados---->
								<cfset vn_Actual = Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&rsCotizacionLineas.DSlinea) * rsCotizacionLineas.DCpreciou><!---Variable con el precio * la cantidad q' se va a comprar---->
								<cfset vn_PorcActual = (vn_Actual * 100)/ vn_Anterior><!----Cuanto representa la nueva cantidad del % de descuento cotizado---->
								<cfset vn_porcentaje = (vn_PorcActual * rsCotizacionLineas.PorcDescuento)/100> 
								----->
								<cfset vn_porcentaje = (Evaluate('Session.Compras.OrdenCompra.DCcantidad_'&rsCotizacionLineas.DSlinea) * rsCotizacionLineas.PorcDescuento)/rsCotizacionLineas.DCcantidad> 
								#LSNumberFormat(vn_porcentaje, ',9.00')#	
							<cfelse>
								#LSNumberFormat(rsCotizacionLineas.PorcDescuento, ',9.00')#							
							</cfif>							
						</td>
					</tr>
					</cfloop>
					<tr>
					  <td colspan="7" align="center" nowrap>&nbsp;</td>
					  </tr>
					</table>
				</td>
			  </tr>
		  </cfloop>
		  <tr>
		    <td>
				<cfif rsTipoSol.cantidad>
                    	<cf_botones values="<< Anterior, Enviar Aprobación Solicitante" names="Anterior,AprobarS">
                    	<script type="text/javascript">
							function funcAprobarS(){
								<cfloop query="rsCotizacionEncabezado">
									objForm.Observaciones_#rsCotizacionEncabezado.currentRow#.required = false;
									objForm.CMFPid_#rsCotizacionEncabezado.currentRow#.required = false;
									objForm.EOplazo_#rsCotizacionEncabezado.currentRow#.required = false;
									objForm.EOtc_#rsCotizacionEncabezado.currentRow#.required = false;
									objForm.EOporcanticipo_#rsCotizacionEncabezado.currentRow#.required = false;
									objForm.CMTOcodigo_#rsCotizacionEncabezado.currentRow#.required = false;
									<cfquery name="rsCotizacionLineas" dbtype="query">
										select Icodigo, DSlinea
										from rsCotizacionAll
										where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCotizacionEncabezado.SNcodigo#">
										and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.Mcodigo#">
										and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.CMFPid#">
										order by DSconsecutivo
									</cfquery>
									<cfloop query="rsCotizacionLineas">
										<cfif Len(Trim(rsCotizacionLineas.Icodigo)) EQ 0>
										objForm.Icodigo_#rsCotizacionLineas.DSlinea#.required = false;
										</cfif>
									</cfloop>
								</cfloop>
								return confirm("Esta seguro de enviar a aprobación la OC?");
							}
						</script>
                    <cfelse>
                    	<cf_botones values="<< Anterior, Finalizar" names="Anterior,Finalizar">
                    </cfif>
			</td>
		  </tr>
		<tr>
		  <td colspan="5" align="center" nowrap>&nbsp;</td>
		  </tr>
		</table>
	</form>
	</cfoutput>
	<script language="javascript" type="text/javascript">

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		
		function funcAnterior() {
			<cfoutput query="rsCotizacionEncabezado">
				objForm.Observaciones_#rsCotizacionEncabezado.currentRow#.required = false;
				objForm.CMFPid_#rsCotizacionEncabezado.currentRow#.required = false;
				objForm.EOplazo_#rsCotizacionEncabezado.currentRow#.required = false;
				objForm.EOtc_#rsCotizacionEncabezado.currentRow#.required = false;
				objForm.EOporcanticipo_#rsCotizacionEncabezado.currentRow#.required = false;
				objForm.CMTOcodigo_#rsCotizacionEncabezado.currentRow#.required = false;
				<cfquery name="rsCotizacionLineas" dbtype="query">
					select *
					from rsCotizacionAll
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCotizacionEncabezado.SNcodigo#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.Mcodigo#">
					and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.CMFPid#">
					order by DSconsecutivo
				</cfquery>
				<cfloop query="rsCotizacionLineas">
					<cfif Len(Trim(rsCotizacionLineas.Icodigo)) EQ 0>
					objForm.Icodigo_#rsCotizacionLineas.DSlinea#.required = false;
					</cfif>
				</cfloop>
			</cfoutput>
			<cfif not lvarSolicitante>
				document.form1.action = "evaluarCotizaciones.cfm";
			<cfelse>
				document.form1.action = "evaluarCotizacionesSolicitante.cfm";
			</cfif>
			
			<cfif lvarProcesar>
				document.form1.opt.value = "0";
			<cfelse>
				document.form1.opt.value = "4";
			</cfif>
		}
		
		<cfoutput query="rsCotizacionEncabezado">
			objForm.Observaciones_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.Observaciones_#rsCotizacionEncabezado.currentRow#.description = "Observaciones";
			objForm.CMFPid_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.CMFPid_#rsCotizacionEncabezado.currentRow#.description = "Forma de Pago";
			objForm.EOplazo_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.EOplazo_#rsCotizacionEncabezado.currentRow#.description = "Plazo de Crédito";
			objForm.EOtc_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.EOtc_#rsCotizacionEncabezado.currentRow#.description = "Tipo Cambio";
			objForm.EOporcanticipo_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.EOporcanticipo_#rsCotizacionEncabezado.currentRow#.description = "Porcentaje Anticipo";
			objForm.CMTOcodigo_#rsCotizacionEncabezado.currentRow#.required = true;
			objForm.CMTOcodigo_#rsCotizacionEncabezado.currentRow#.description = "Tipo de orden de compra";
		</cfoutput>
		
		<!--- Validar que el impuesto sea requerido antes de continuar --->
		<cfloop query="rsCotizacionEncabezado">
			<cfquery name="rsCotizacionLineas" dbtype="query">
				select *
				from rsCotizacionAll
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCotizacionEncabezado.SNcodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.Mcodigo#">
				and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizacionEncabezado.CMFPid#">
				order by DSconsecutivo
			</cfquery>
			<cfoutput>
			<cfloop query="rsCotizacionLineas">
				<cfif Len(Trim(rsCotizacionLineas.Icodigo)) EQ 0>
				objForm.Icodigo_#rsCotizacionLineas.DSlinea#.required = true;
				objForm.Icodigo_#rsCotizacionLineas.DSlinea#.description = "Impuesto";
				</cfif>
			</cfloop>
			getPlazo(document.form1.EOplazo_#currentRow#, document.form1.CMFPid_#currentRow#.value);
			</cfoutput>
		</cfloop>
		
	</script>

</cfif>