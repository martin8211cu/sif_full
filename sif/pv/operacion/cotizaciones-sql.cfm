<!---<cfdump var="#form#">
<cfabort> 
 --->
<cfset cambioTotEnc = false>

 <cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FACotizacionesE"
		redirect="cotizaciones.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="NumeroCot"
		type2="integer"
		value2="#form.NumeroCot#">
					
	<cfquery name="update" datasource="#session.DSN#">
		update FACotizacionesE 
			set			
				FAX04CVD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX04CVD#">, 
				Ocodigo=<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,<cfelse>null,</cfif>
				CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">, 
				Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">, 
				<cfif isdefined('form.Vigencia') and len(trim(form.Vigencia))>
					Vigencia=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Vigencia#">, 
				<cfelse>
				 	Vigencia=0,
				</cfif>				
				FechaCot=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
				<cfif isdefined('form.Vigencia') and len(trim(form.Vigencia))>
					FechaVen=<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', form.Vigencia, Now())#">,
				<cfelse>
				 	FechaVen=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				</cfif>				
				TipoTransaccion=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoTransaccion#">, 
				TipoPago=<cfqueryparam cfsqltype="cf_sql_bit" value="#form.TipoPago#">, 
				Estatus=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estatus#">, 
				PorcDescCliente=<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorcDescCliente#">,  
				MonDescuentoF=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MonDescuentoF#">,  
				MonDescuentoL=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MonDescuentoL#">,  
				MonImpuesto=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MonImpuesto#">,  
				MonTotalCot=<cfqueryparam cfsqltype="cf_sql_money" value="#form.MonTotalCot#">,  
				<cfif isdefined('form.TipoTransaccion') and form.TipoTransaccion NEQ '0'>
					NumOrdenCompra=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumOrdenCompra#">, 
				<cfelse>
					NumOrdenCompra=null,
				</cfif>				
				Exento=<cfif isdefined('form.Exento')>1,<cfelse>0,</cfif> 
				Observaciones=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">, 
				<cfif isdefined('form.TipoTransaccion') and form.TipoTransaccion NEQ '0'>
					TipoCambio=<cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
				<cfelse>
					TipoCambio=null,
				</cfif>				
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,		
				Direccion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Direccion#">,	
				Fecha_doc= <cfqueryparam cfsqltype="cf_sql_date" value="#form.Fecha_doc#">			
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">		
	</cfquery> 
	<cfset cambioTotEnc = true>	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from FACotizacionesD
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		delete from FACotizacionesE
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">
	</cfquery>	
<cfelseif IsDefined("form.Alta")>
	<cftransaction>
		<cfquery name="insertEnc" datasource="#session.dsn#">
			insert into FACotizacionesE 
				(Ecodigo, FAX04CVD, Ocodigo, CDCcodigo, Mcodigo, Vigencia, FechaCot, FechaVen, TipoTransaccion, TipoPago, Estatus,
				 PorcDescCliente, PorcDescTotal, MonDescuentoF, MonDescuentoL, MonImpuesto, MonTotalCot, NumOrdenCompra, Exento, 
				 Observaciones, TipoCambio, BMUsucodigo, fechaalta, Direccion, Fecha_doc,vencimiento)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX04CVD#">, 
				<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,<cfelse>null,</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">,  
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfif isdefined('form.Vigencia') and len(trim(form.Vigencia)) and form.TipoTransaccion EQ '0'>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Vigencia#">,
				<cfelse>
				 	0,
				</cfif>
				getDate(),
				<cfif isdefined('form.Vigencia') and len(trim(form.Vigencia))>
					<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', form.Vigencia, Now())#">, 
				<cfelse>
				 	getDate(),
				</cfif>				
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoTransaccion#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoPago#">,  
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Estatus#">,   
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorcDescCliente#">, 
				0, 0, 0, 0, 0, 
				<cfif isdefined('form.TipoTransaccion') and form.TipoTransaccion NEQ '0'>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumOrdenCompra#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.Exento')>1,<cfelse>0,</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
				<cfif isdefined('form.TipoTransaccion') and form.TipoTransaccion NEQ '0'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
				<cfelse>
					0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Direccion#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Fecha_doc,'dd/mm/yyyy')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.vencimiento#">
				)	
		
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertEnc">
	</cftransaction>
	<!---,,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Direccion#">,
				<cfqueryparam cfsqltype="cf_sql_datetime" value="#Now()#">--->
	<!--- SENTENCIAS PARA EL DETALLE --->
<cfelseif IsDefined("form.AltaDet")>
	<cfquery name="proxLinea" datasource="#session.dsn#">
		select (coalesce(max(Linea),0) + 1) as Linea
		from FACotizacionesD
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and NumeroCot = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
	</cfquery>

	<cfquery name="insertDet" datasource="#session.dsn#">
		insert INTO FACotizacionesD 
			(Ecodigo, Linea, NumeroCot, Cantidad, TipoLinea, Aid, Alm_Aid, Cid, Icodigo, Descripcion, 
				PrecioUnitario, PorDescuento, MonDescuento, TotalLinea, BMUsucodigo, fechaalta, periodo)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#proxLinea.Linea#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Cantidad#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoLinea#">,
				<cfif isdefined('form.TipoLinea') and Len(Trim(form.TipoLinea)) and form.TipoLinea EQ 'A'>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">,					
					null,
				<cfelse>
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#" null="#Len(Trim(Form.Descripcion)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.PrecioUnitario#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorDescuento#">,  
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.MonDescuento#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.TotalLinea#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 				
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mm/yyyy')#">
)		
	</cfquery>
	
	<cfset cambioTotEnc = true>
<cfelseif IsDefined("form.CambioDet")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FACotizacionesD"
		redirect="cotizaciones.cfm"
		timestamp="#form.ts_rversionDet#"
		field1="Linea"
		type1="numeric"
		value1="#form.Linea#">
		
	<cfquery name="insertEnc" datasource="#session.dsn#">
		update FACotizacionesD set
			Cantidad = <cfqueryparam cfsqltype="cf_sql_money" value="#form.Cantidad#">
			, TipoLinea = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoLinea#">
			<cfif isdefined('form.TipoLinea') and Len(Trim(form.TipoLinea)) and form.TipoLinea EQ 'A'>
				, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
				, Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">
				, Cid = null
			<cfelse>
				, Aid = null
				, Alm_Aid = null
				, Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
			</cfif>
			, Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
			, Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#" null="#Len(Trim(Form.Descripcion)) EQ 0#">
			, PrecioUnitario = <cfqueryparam cfsqltype="cf_sql_money" value="#form.PrecioUnitario#">
			, PorDescuento = <cfqueryparam cfsqltype="cf_sql_float" value="#form.PorDescuento#">
			, MonDescuento = <cfqueryparam cfsqltype="cf_sql_money" value="#form.MonDescuento#">
			, TotalLinea = <cfqueryparam cfsqltype="cf_sql_money" value="#form.TotalLinea#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			, periodo = <cfqueryparam cfsqltype="cf_sql_date" value="#form.periodo#">
		where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Linea#">
	</cfquery>
	
	<cfset cambioTotEnc = true>	
<cfelseif IsDefined("form.BajaDet")>
	<cfquery datasource="#session.dsn#">
		delete from FACotizacionesD
		where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Linea#">
	</cfquery>
	
	<cfset cambioTotEnc = true>	
	
<!--- Cambio del Estatus de las pre-facturas a terminadas --->
<cfelseif (isdefined("Form.btnAplicar"))>
	<cfif (isdefined("Form.chk"))><!--- Viene de la lista --->
		<cfset datos = ListToArray(Form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfquery datasource="#session.DSN#">
				update FACotizacionesE 
					set	Estatus=1
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and NumeroCot = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_numeric">		
					and Estatus = 0 
			</cfquery> 
		</cfloop>
		<cfset cambioTotEnc = false>			
	</cfif>
</cfif>

<!--- Actualizacion de los campos de totales en el encabezado --->
<cfif cambioTotEnc>
	<!--- Se actualiza el campo de PorcDescCliente antes de realizar los clculos de los totales --->
	<cfquery datasource="#session.DSN#">
		update FACotizacionesE 
			set			
				PorcDescCliente=<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorcDescCliente#">
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">		
	</cfquery> 
	<cfquery name="rsTotales" datasource="#session.DSN#">
		Select 
		<cfif form.tipoCalculos EQ 1>
			sum(MonDescuento) as sumDesDet,
			sum((Cantidad * PrecioUnitario) * (PorDescuento/100)) as sumDescuento,
			sum(Cantidad * PrecioUnitario) as sumSubTotal, 
			sum(	((Cantidad * PrecioUnitario) 
					- ((Cantidad * PrecioUnitario) * (PorDescuento / 100)))
					* 
					<cfif isdefined('form.Exento') and form.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0				
					</cfif>						
					) as sumImpuesto,
			sum(
					((Cantidad * PrecioUnitario) 
						- ((Cantidad * PrecioUnitario) * (PorDescuento/100))
						+ (	((Cantidad * PrecioUnitario) 
							- ((Cantidad * PrecioUnitario) * (PorDescuento / 100)))
							* 
								<cfif isdefined('form.Exento') and form.Exento NEQ 1>
									(Iporcentaje / 100)
								<cfelse>
									0				
								</cfif>						
							))
					* (PorcDescCliente/100)
				) as sumDescFactura
		<cfelseif form.tipoCalculos EQ 2>
			sum(MonDescuento) as sumDesDet,
			sum(Cantidad * PrecioUnitario) as sumSubTotal, 
			sum((Cantidad * PrecioUnitario) * 
					<cfif isdefined('form.Exento') and form.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0				
					</cfif>	
				) as sumImpuesto,
			sum(((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif isdefined('form.Exento') and form.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0				
					</cfif>				
				)) * (PorDescuento / 100)) as sumDescuento,
			sum(((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif isdefined('form.Exento') and form.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0				
					</cfif>					
				) - (((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif isdefined('form.Exento') and form.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0				
					</cfif>		
				)) * (PorDescuento / 100))) * (PorcDescCliente/100)) as sumDescFactura				
		</cfif>

		from FACotizacionesD cd
			inner join FACotizacionesE ce
				on ce.NumeroCot=cd.NumeroCot
					and ce.Ecodigo=cd.Ecodigo
		
			inner join Impuestos i
				on i.Icodigo=cd.Icodigo
					and i.Ecodigo=ce.Ecodigo
		
		where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cd.NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">		
	</cfquery>

	<cfif isdefined('rsTotales') 
		and rsTotales.recordCount GT 0 
		and rsTotales.sumSubTotal NEQ ''
		and rsTotales.sumImpuesto NEQ ''
		and rsTotales.sumDescuento NEQ ''
		and rsTotales.sumDescFactura NEQ ''>
			<cfset TotalCot = 0>
			<cfset porDescTotalCot = 0>			
		
			<cfset TotalCot = rsTotales.sumSubTotal + rsTotales.sumImpuesto - rsTotales.sumDescuento - rsTotales.sumDescFactura>
			<cfif rsTotales.sumDesDet GT 0>
				<cfset porDescTotalCot = TotalCot / rsTotales.sumDesDet>
			</cfif>
			
							
			<cfquery name="update" datasource="#session.DSN#">
				update FACotizacionesE 
					set			
						PorcDescTotal=<cfqueryparam cfsqltype="cf_sql_float" value="#porDescTotalCot#">,				
						PorcDescCliente=<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorcDescCliente#">,  
						MonDescuentoL=<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumDescuento#">,  
						MonDescuentoF=<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumDescFactura#">,  
						MonImpuesto=<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumImpuesto#">,  
						MonTotalCot=<cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#">
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">		
			</cfquery> 
	<cfelse>
						
		<cfquery name="update" datasource="#session.DSN#">
			update FACotizacionesE 
				set			
					PorcDescTotal=0,				
					PorcDescCliente=<cfqueryparam cfsqltype="cf_sql_float" value="#form.PorcDescCliente#">,  
					MonDescuentoF=0,  
					MonDescuentoL=0,  
					MonImpuesto=0,  
					MonTotalCot=0
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and NumeroCot = <cfqueryparam value="#form.NumeroCot#" cfsqltype="cf_sql_numeric">		
		</cfquery> 	
	</cfif>
</cfif>

<form action="cotizaciones.cfm" method="post" name="sql">
	<cfoutput>
		<input name="tipoCoti" type="hidden" value="#form.tipoCoti#">
		<cfif isdefined('form.Alta')>
			<input name="NumeroCot" type="hidden" value="#insertEnc.identity#">
		<cfelseif isdefined('form.Nuevo') or isdefined('form.Baja')>
			<input name="btnNuevo" type="hidden" value="btnNuevo">
		<cfelse>
			<cfif IsDefined("form.CambioDet")>
				<input name="Linea" type="hidden" value="#form.Linea#">
			</cfif>
			<cfif not isdefined('form.btnAplicar')>
				<input name="NumeroCot" type="hidden" value="#form.NumeroCot#">
			</cfif>			
			
		</cfif>			
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>