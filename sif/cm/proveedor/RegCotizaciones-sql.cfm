<cfif not isdefined("Form.btnNuevo")>
	<cftransaction>
		<cfif isdefined("Form.btnGuardar") and not isdefined("Form.CPid")>
			<!--- Insertar el encabezado de la cotización --->
			<cfquery name="Cotizacion_ABC" datasource="sifpublica">
				insert into CotizacionesProveedor(UsucodigoP, CPnumero, PCPid, CPfechacoti, CPdescripcion, CPobs, CPprocesado, CPsubtotal, CPtotdesc, CPtotimp, CPtotal, Mcodigo, CPtipocambio, CPestado, CMIid, CMFPid, ECfechavalido)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPnumero#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CPfechacoti)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPobs#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPprocesado#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
					<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
					<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
					<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CPtipocambio#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
					<cfif isdefined("form.CMFPid") and len(trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
					<cfif isdefined("form.ECfechavalido") and Len(Trim(form.ECfechavalido))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ECfechavalido)#"><cfelse>null</cfif>
				)
				<cf_dbidentity1 datasource="sifpublica">
			</cfquery>
			<cf_dbidentity2 datasource="sifpublica" name="Cotizacion_ABC">
			<cfset Form.CPid = Cotizacion_ABC.identity>
			
			<!--- Insertar el detalle de la cotización --->
			<cfloop collection="#Form#" item="i">
				<cfif FindNoCase("DCPgarantia_", i) NEQ 0>
					<cfset lineaCompra = Mid(i, 13, Len(i))>
					<cfquery name="CotizacionDetalle_ABC" datasource="sifpublica">
						insert into DCotizacionProveedor(CPid, LPCid, DCPcantidad, DCPpreciou, DCPgarantia, DCPplazocredito, DCPplazoentrega, DCPimpuestos, DCPdesclin, DCPtotimp, DCPtotallin, DCPdescprov, DCPunidadcot, DCPconversion)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaCompra#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPcantidad_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.DCPpreciou_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPgarantia_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPplazocredito_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPplazoentrega_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPimpuestos_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.DCPdesclin_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DCPdescprov_'&lineaCompra)#" null="#Len(Trim(Evaluate('Form.DCPdescprov_'&lineaCompra)))#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DCPunidadcot_'&lineaCompra)#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPconversion_'&lineaCompra)#">
						)
					</cfquery>
				</cfif>
			</cfloop>
			
		<cfelseif (isdefined("Form.btnGuardar") or isdefined("Form.btnAplicar")) and isdefined("Form.CPid") and Len(Trim(Form.CPid))>
			
			<!--- Actualizar el detalle de la cotizacion --->
			<cfloop collection="#Form#" item="i">
				<cfif FindNoCase("DCPgarantia_", i) NEQ 0>
					<cfset lineaCompra = Mid(i, 13, Len(i))>
					<cfquery name="CotizacionDetalle_ABC" datasource="sifpublica">
						update DCotizacionProveedor set
							DCPcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPcantidad_'&lineaCompra)#">,
							DCPpreciou = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.DCPpreciou_'&lineaCompra)#">,
							DCPgarantia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPgarantia_'&lineaCompra)#">,
							DCPplazocredito = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPplazocredito_'&lineaCompra)#">,
							DCPplazoentrega = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCPplazoentrega_'&lineaCompra)#">,
							DCPimpuestos = <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPimpuestos_'&lineaCompra)#">,
							DCPdesclin = <cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate('Form.DCPdesclin_'&lineaCompra)#">,
							DCPdescprov = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DCPdescprov_'&lineaCompra)#" null="#Len(Trim(Evaluate('Form.DCPdescprov_'&lineaCompra)))#">,
							DCPunidadcot = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DCPunidadcot_'&lineaCompra)#">,
							DCPconversion = <cfqueryparam cfsqltype="cf_sql_float" value="#Evaluate('Form.DCPconversion_'&lineaCompra)#">
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
						and LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaCompra#">
					</cfquery>
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfif (isdefined("Form.btnGuardar") or isdefined("Form.btnAplicar")) and isdefined("Form.CPid") and Len(Trim(Form.CPid))>

			<!--- Actualizar los totales de impuestos y total de linea --->
			<cfquery name="CotizacionDetalle_ABC" datasource="sifpublica">
				update DCotizacionProveedor
				set DCPtotimp = (DCPcantidad * DCPpreciou * DCPimpuestos) / 100.00,
					DCPtotallin = (DCPcantidad * DCPpreciou) + ((DCPcantidad * DCPpreciou * DCPimpuestos) / 100.00) - DCPdesclin
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
			</cfquery>

			<!--- Actualizar el encabezado de la cotización --->
			<cfquery name="rsTotalesDetalle" datasource="sifpublica">
				select 
					coalesce(sum(DCPcantidad*DCPpreciou),0) as CPsubtotal,
					coalesce(sum(DCPdesclin),0) as CPtotdesc,
					coalesce(sum(DCPtotimp),0) as CPtotimp,
					coalesce(sum(DCPtotallin),0) as CPtotal
				from DCotizacionProveedor
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
			</cfquery>
			
			<cfquery name="updCotizacion" datasource="sifpublica">
				update CotizacionesProveedor set
					CPnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPnumero#">,
					CPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPdescripcion#">,
					CPfechacoti = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CPfechacoti)#">,
					CPobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPobs#">,
					CPprocesado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPprocesado#">,
					CPsubtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesDetalle.CPsubtotal#">,
					CPtotdesc = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesDetalle.CPtotdesc#">,
					CPtotimp = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesDetalle.CPtotimp#">,
					CPtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesDetalle.CPtotal#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
					CPtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CPtipocambio#">,
					CMIid = <cfif isdefined("form.CMIid") and len(trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
					CMFPid = <cfif isdefined("form.CMFPid") and len(trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
					ECfechavalido = <cfif isdefined("form.ECfechavalido") and Len(Trim(form.ECfechavalido))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ECfechavalido)#"><cfelse>null</cfif>
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				and UsucodigoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			</cfquery>
			
			<cfif isdefined("Form.btnAplicar")>
				<cfquery name="rsAplicar" datasource="sifpublica">
					update CotizacionesProveedor set 
						CPfechaaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						CPestado = 10
					where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				</cfquery>
			</cfif>

		</cfif>
	</cftransaction>

<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfoutput>
	<form action="RegCotizaciones.cfm" method="post" name="sql">
	<cfif isdefined("Form.returnLista") or isdefined("Form.returnLista")>
		<input type="hidden" name="returnLista" value="#Form.returnLista#">
	</cfif>
	<cfif isdefined("Form.btnGuardar") or isdefined("Form.Regresar")>
		<input type="hidden" name="PCPid" value="#Form.PCPid#">
	</cfif>
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
