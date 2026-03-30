<!---=========Aplicacion del Documento de Pago============--->
<cfif isdefined("Form.Aplicar") OR isdefined("Form.Ver")>
	<!---<cfdump var="[IDpago:#form.IDpago#]">
	<cfdump var="[usuario:#session.usuario#]">
	<cfdump var="[debug:N]">
	<cfdump var="[pintaAsiento:#isdefined("Form.Ver")#]" >--->
	<cfinvoke component="sif.Componentes.CP_PosteoPagosCxP" method="PosteoPagos">
		<cfinvokeargument name="Ecodigo" 		value="#session.Ecodigo#"/>
		<cfinvokeargument name="IDpago"	 		value="#form.IDpago#"/>
		<cfinvokeargument name="usuario" 		value="#session.usuario#"/>
		<cfinvokeargument name="debug" 	 		value="N"/>
		<cfinvokeargument name="pintaAsiento"	value="#isdefined("Form.Ver")#"/>
	</cfinvoke>

	<cfset params = '?pageNum_rsLista=1' >
	<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))>
		<cfset params = '?pageNum_rsLista=#form.PageNum_rsLista#' >
	</cfif>
	<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >
		<cfset params = params & '&fecha=#form.fecha#' >
	</cfif>
	<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >
		<cfset params =  params & '&transaccion=#form.transaccion#' >
	</cfif>
	<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >
		<cfset params =  params & '&usuario=#form.usuario#' >
	</cfif>
	<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >
		<cfset params =  params & '&moneda=#form.moneda#' >
	</cfif>
	<cflocation url="ListaPagos.cfm#params#" addtoken="no">
</cfif>
<!---========Creación del Encabezado del Pago==================--->
	<cfif isdefined("Form.AgregarE")>
		<cfquery name="chkNotExist" datasource="#Session.DSN#">
			select count(1) as cantidad
			  from BMovimientosCxP
            where Ecodigo    =  #Session.Ecodigo#
              and CPTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
              and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EPdocumento#">
		</cfquery>
		<cfif chkNotExist.cantidad GT 0>
			<cfset existPago = true>
		<cfelse>
			<cfset existPago = false>
		</cfif>
<!---========Se Valida que no exista ya el pago en libros. Se Busca por MLibros_AK01  MLdocumento, BTid, CBid========--->
		<cfquery name="ExisteEnBancos" datasource="#Session.DSN#">
			select count(1) cantidad
				from MLibros
			where MLdocumento = <cfqueryparam cfsqltype="cf_sql_char" 		value="#Form.EPdocumento#">
			  and BTid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.BTid#">
			  and CBid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.CBid#">
		</cfquery>
		<cfif ExisteEnBancos.cantidad GT 0>
			<cfthrow message="El Pago que desea ingresar ya existe en bancos (MLibros).">
		</cfif>

		<cfif not existPago>
		<cftransaction>
			<cfquery name="ABC_Pago" datasource="#Session.DSN#">
				insert into EPagosCxP(Ecodigo, CPTcodigo, EPdocumento, Mcodigo, EPtipocambio, EPselect,
                    			 Ccuenta, EPtotal, EPfecha, EPtipopago, EPbeneficiario, Ocodigo, SNcodigo,
								 EPusuario, CBid, BTid)
                values (
					 #Session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Form.CPTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Form.EPdocumento#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_float" 		value="#Form.EPtipocambio#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.Ccuenta#">,
					<cfqueryparam cfsqltype="cf_sql_money"   	value="#Form.EPtotal#">,
					<CF_jdbcquery_param cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.EPfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_char"    	value="#Form.EPtipopago#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.EPbeneficiario#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Session.Usuario#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.CBid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.BTid#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Pago">
			<cfset ABC_Pago_IDpago = ABC_Pago.identity>
		</cftransaction>
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
		<cfelse>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('El Registro de Pago ya existe en la Base de Datos!')#" addtoken="no">
		</cfif>
<!---==========Eliminacion de todas las facturas del detalle, todos los anticipos y luego el Pago=======--->
	<cfelseif isdefined("Form.BorrarE")>
		<cfquery datasource="#Session.DSN#">
			delete from APagosCxP
			where IDpago  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from DPagosCxP
			where IDpago  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			  and Ecodigo =  #Session.Ecodigo#
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from EPagosCxP
			where IDpago  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			  and Ecodigo =  #Session.Ecodigo#
		</cfquery>
		<cfset modo="ALTA">
		<cfset modoDet="ALTA">
<!---========Eliminacion de una linea de Detalle del pago=================--->
	<cfelseif isdefined("Form.BorrarD")>
		<cfquery name="ABC_Pago" datasource="#Session.DSN#">
			delete from DPagosCxP
			where IDpago  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			  and IDLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDLinea#">
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset ABC_Pago_IDpago = #Form.IDpago#>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
<!---===========Agrega una nueva linea a los detalles del Pago=========--->
	<cfelseif isdefined("Form.AgregarD") or isdefined("Form.CambiarD") or isdefined('form.CambiarE')>
		<cf_dbtimestamp datasource="#session.dsn#" table="EPagosCxP" redirect="PagosCxP.cfm" timestamp="#Form.timestampE#"
		   field1="Ecodigo,integer,#session.Ecodigo#"
		   field2="IDpago,numeric,#Form.IDpago#">

		<cfquery name="ABC_PagoUpd" datasource="#Session.DSN#">
			update EPagosCxP
			set EPtotal 	   = <cfqueryparam cfsqltype="cf_sql_money"   value="#Form.EPtotal#">
			  , EPfecha 	   = <cfqueryparam cfsqltype="cf_sql_date"    value="#lsparsedatetime(Form.EPfecha)#">
			  , Ccuenta 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			  , Ocodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
			  , Mcodigo 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
			  , EPtipopago 	   = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.EPtipopago#">
			  , EPbeneficiario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPbeneficiario#">
			  , EPtipocambio   = <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.EPtipocambio#">
			  , EPusuario 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
			  , CBid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
			  , BTid 		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
			where IDpago 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			and Ecodigo 	   =  #Session.Ecodigo#
		</cfquery>

		<cfif len(trim(form.IDdocumento)) gt 0>

			<!--- Verificar que la suma de detalles no supere el monto del documento --->
			<cfquery name="rstotaldisponible" datasource="#Session.DSN#">
				select EPtotal-
				 (select coalesce(sum(Anti.NC_total),0.00) from APagosCxP Anti where Anti.IDpago = a.IDpago) as ta
				from EPagosCxP a
				where a.Ecodigo =  #Session.Ecodigo#
				  and a.IDpago  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
			</cfquery>
			<cfset ta = rstotaldisponible.ta>

			<cfquery name="rstotalcubierto" datasource="#Session.DSN#">
				select coalesce(sum(DPtotal),0.00) as tl
				from DPagosCxP
				where Ecodigo =  #Session.Ecodigo#
				and IDpago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
				<cfif isdefined("Form.CambiarD")>
				and IDLinea != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDLinea#">
				</cfif>
			</cfquery>
			<cfset tl = rstotalcubierto.tl>
			<cfif Round(Form.DPtotal + tl) GT Round(ta)>
				<cfset amount_overflow = true>
			<cfelse>
				<cfset amount_overflow = false>
			</cfif>
			<!--- Verificar que el documento del pago a insertar no fue ya usado en otro recibo de pago --->
			<cfquery name="chkNotExist2" datasource="#Session.DSN#">
				select count(1) as cantidad
				  from DPagosCxP
				where Ecodigo =  #Session.Ecodigo#
				and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			</cfquery>
			<cfif chkNotExist2.cantidad GT 0>
				<cfset existDoc = true>
			<cfelse>
				<cfset existDoc = false>
			</cfif>

			<!--- Calcular el tipo de cambio --->
			<cfif Form.FC EQ "calculado">
				<cfset tipocambio = Val(Form.DPmontodoc) / Val(Form.DPtotal)>
			<cfelseif Form.FC EQ "iguales">
				<cfset tipocambio = 1.0>
			<cfelseif Form.FC EQ "encabezado">
				<cfset tipocambio = Val(Form.EPtipocambio)>
			</cfif>

			<cfif isdefined("AgregarD") and not amount_overflow and not existDoc>
				<cfquery name="ABC_Pago" datasource="#Session.DSN#">
					insert into DPagosCxP(Ecodigo, IDpago, IDdocumento, Ccuenta, DPmonto, DPtipocambio, DPmontodoc, DPtotal, DPmontoretdoc, Dcodigo)
					values (
						 #Session.Ecodigo# ,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentad#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.DPtotal#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#tipocambio#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.DPmontodoc#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.DPtotal#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.montoret#">,
						null )
				</cfquery>
				<cfset ABC_Pago_IDpago = #Form.IDpago#>
			<cfelseif isdefined("CambiarD")>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="DPagosCxP"
					redirect="PagosCxP.cfm"
					timestamp="#Form.timestampd#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="IDpago,numeric,#Form.IDpago#"
					field3="IDLinea,numeric,#Form.IDLinea#">

				<cfquery name="ABC_Pago" datasource="#Session.DSN#">
					update DPagosCxP
					set DPmonto 	 	= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DPtotal#">
					  , DPtipocambio 	= <cfqueryparam cfsqltype="cf_sql_float" value="#tipocambio#">
					  , DPmontodoc	 	= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DPmontodoc#">
					  , DPtotal 		= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DPtotal#">
					  , DPmontoretdoc 	= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DPmontoretdoc#">
					where Ecodigo =  #Session.Ecodigo#
					and IDpago 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDpago#">
					and IDLinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDLinea#">
				</cfquery>
				<cfset ABC_Pago_IDpago = #Form.IDpago#>
			</cfif>
		</cfif>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">

	<cfelse>
		<cfset modo="ALTA">
		<cfset modoDet="ALTA">
	</cfif>
<form action="PagosCxP.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('Form.Anticipo') and not isdefined('Form.BorrarE')>
			<input name="Anticipo" type="hidden" value="#form.Anticipo#">
			<cfset modo ="CAMBIO">
		</cfif>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">
		<cfif modo NEQ "ALTA">
			<input name="IDpago" type="hidden"
			value="<cfif isdefined("ABC_Pago_IDpago")>#ABC_Pago_IDpago#<cfelseif isdefined("Form.IDpago") and not isDefined("Form.BorrarE")>#Form.IDpago#</cfif>">
		</cfif>

		<input type="hidden" name="pageNum_rsLista" value="<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))>#form.PageNum_rsLista#<cfelse>1</cfif>" />
		<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
		<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />
		<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />
		<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />

	</cfoutput>
</form>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>