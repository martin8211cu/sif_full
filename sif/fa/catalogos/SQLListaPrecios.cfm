<cfparam name="action" default="listaLPrecios.cfm">
					
<cfif not isdefined("form.btnNuevoD")>
	<cftry>
		

			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("form.btnAgregarE")>
	<cftransaction>
			<cfquery name="ABC_insLPrecios" datasource="#session.DSN#">
				insert EListaPrecios ( Ecodigo, LPdescripcion ,LPdefault , Pais, moneda, meses_financiamiento , BMUsucodigo, BMfechamod)
							 values ( <cfqueryparam value="#session.Ecodigo#" 	 cfsqltype="cf_sql_integer">,
									  <cfqueryparam value="#form.LPdescripcion#" cfsqltype="cf_sql_varchar">,
									  0,
									  <cfqueryparam value="#form.Pais#" cfsqltype="cf_sql_char">,
									  <cfqueryparam value="#form.moneda#" cfsqltype="cf_sql_char">,
									  <cfqueryparam value="#form.meses_financiamiento#" cfsqltype="cf_sql_integer">,
									  <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
									)
				<cf_dbidentity1 datasource="#session.DSN#">				
			</cfquery>
			<cfset modo="CAMBIO">
			<cfset action = "ListaPrecios.cfm">
		<cf_dbidentity2 name="ABC_insLPrecios">
		<cfset ABC_insLPrecios_id = ABC_insLPrecios.identity>
</cftransaction>

			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("form.btnBorrarE")>
				<cfquery name="ABC_delLDPrecios" datasource="#session.DSN#">
					delete DListaPrecios
					where LPid = <cfqueryparam value="#form.LPid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery name="ABC_delELPrecios" datasource="#session.DSN#">
					delete EListaPrecios
					where LPid = <cfqueryparam value="#form.LPid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				  <cfset modo="ALTA">	
				  
			<!--- Caso 3: Agregar Detalle de Solicitud y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("form.btnAgregarD")>
				<cfquery name="ABC_insDLPrecios" datasource="#session.DSN#">
					insert DListaPrecios  ( Ecodigo ,LPid ,LPtipo ,Aid ,Cid, Alm_Aid, DLdescripcion, DLprecio,moneda,Icodigo ,
										  DLfechaini ,DLfechafin , precio_contado_vendedor ,precio_contado_supervisor,
										  precio_credito ,precio_credito_vendedor ,precio_credito_supervisor, prima_minima, 
										  comision_minimo, comision_excedente ,plazo_sugerido, plazo_maximo, 
										  interes_corriente , interes_mora  ,BMfechamod  ,BMUsucodigo)
					values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
							 <cfqueryparam value="#form.LPid#" cfsqltype="cf_sql_numeric">, 
							 <cfqueryparam value="#form.LPtipo#" cfsqltype="cf_sql_char">, 
							 <cfif trim(form.LPtipo) eq 'A' ><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
							 <cfif trim(form.LPtipo) eq 'A' >null<cfelse>null</cfif>, 
							 <cfif trim(form.LPtipo) eq 'S' ><cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
							 <cfqueryparam value="#form.DLdescripcion#" cfsqltype="cf_sql_varchar">, 
							 <cfqueryparam value="#form.DLprecio#" cfsqltype="cf_sql_money">,
							 <cfqueryparam value="#form.Dmoneda#" cfsqltype="cf_sql_char">,
							 <cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">,
							 <cfqueryparam value="#LSParsedateTime(form.DLfechaini)#" cfsqltype="cf_sql_timestamp">,
							 <cfqueryparam value="#LSParsedateTime(form.DLfechafin)#" cfsqltype="cf_sql_timestamp">,
							 <cfqueryparam value="#form.precio_contado_vendedor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_contado_vendedor)) is 0#">,
							 <cfqueryparam value="#form.precio_contado_supervisor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_contado_supervisor)) is 0#">,
							 <cfqueryparam value="#form.precio_credito#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito)) is 0#">,
							 <cfqueryparam value="#form.precio_credito_vendedor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito_vendedor)) is 0#">,
							 <cfqueryparam value="#form.precio_credito_supervisor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito_supervisor)) is 0#">,
							 <cfqueryparam value="#form.prima_minima#" cfsqltype="cf_sql_money" null="#Len(Trim(form.prima_minima)) is 0#">,
							 <cfqueryparam value="#form.comision_minimo#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.comision_minimo)) is 0#">, 
							 <cfqueryparam value="#form.comision_excedente#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.comision_excedente)) is 0#">, 
							 <cfqueryparam value="#form.plazo_sugerido#" cfsqltype="cf_sql_integer" null="#Len(Trim(form.plazo_sugerido)) is 0#">, 
							 <cfqueryparam value="#form.plazo_maximo#" cfsqltype="cf_sql_integer" null="#Len(Trim(form.plazo_maximo)) is 0#">, 
							 <cfqueryparam value="#form.interes_corriente#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.interes_corriente)) is 0#">,
							 <cfqueryparam value="#form.interes_mora#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.interes_mora)) is 0#">,
							 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
							 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">
						   )
				</cfquery>
				
				<cf_dbtimestamp datasource="#session.dsn#"
							table="EListaPrecios"
							redirect="ListaPrecios.cfm"
							timestamp="#form.ts_rversion#"
							field1="LPid" 
							type1="numeric" 
							value1="#form.LPid#"
							field2="Ecodigo" 
							type2="integer" 
							value2="#session.Ecodigo#" >
				
				<cfquery name="ABC_updELPrecios" datasource="#session.DSN#">
					<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
					update EListaPrecios
					set LPdescripcion = <cfqueryparam value="#form.LPdescripcion#"  cfsqltype="cf_sql_varchar">,
						Pais = <cfqueryparam value="#form.Pais#" cfsqltype="cf_sql_char">,
						moneda = <cfqueryparam value="#form.moneda#" cfsqltype="cf_sql_char">,
						meses_financiamiento = <cfqueryparam value="#form.meses_financiamiento#" cfsqltype="cf_sql_integer">
					where LPid      = <cfqueryparam value="#form.LPid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset action = "ListaPrecios.cfm">

			<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			

			<cfelseif isdefined("Form.btnCambiarD")>
				<cfquery name="ABC_updDLPrecios" datasource="#session.DSN#">
					update DListaPrecios
					set Aid           = <cfif #form.Aid# neq "" ><cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						Alm_Aid       = <cfif trim(form.LPtipo) eq 'A' >null<cfelse>null</cfif>, 
						Cid           = <cfif trim(form.LPtipo) eq 'S' ><cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
						DLdescripcion = <cfqueryparam value="#form.DLdescripcion#" cfsqltype="cf_sql_varchar">, 
						DLfechaini    = <cfqueryparam value="#LSParsedateTime(form.DLfechaini)#" cfsqltype="cf_sql_timestamp">,
						DLfechafin    = <cfqueryparam value="#LSParsedateTime(form.DLfechafin)#" cfsqltype="cf_sql_timestamp">,
						DLprecio      = <cfqueryparam value="#form.DLprecio#" cfsqltype="cf_sql_money">, 
						moneda        = <cfqueryparam value="#form.Dmoneda#" cfsqltype="cf_sql_char">,
						Icodigo 	  = <cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">,
						precio_contado_vendedor = <cfqueryparam value="#form.precio_contado_vendedor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_contado_vendedor)) Is 0#">,
						precio_contado_supervisor = <cfqueryparam value="#form.precio_contado_supervisor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_contado_supervisor)) Is 0#">,
						precio_credito = <cfqueryparam value="#form.precio_credito#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito)) Is 0#">,
						precio_credito_vendedor = <cfqueryparam value="#form.precio_credito_vendedor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito_vendedor)) Is 0#">,
						precio_credito_supervisor = <cfqueryparam value="#form.precio_credito_supervisor#" cfsqltype="cf_sql_money" null="#Len(Trim(form.precio_credito_supervisor)) Is 0#">,
						prima_minima =	 <cfqueryparam value="#form.prima_minima#" cfsqltype="cf_sql_money" null="#Len(Trim(form.prima_minima)) Is 0#">,
						comision_minimo = <cfqueryparam value="#form.comision_minimo#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.comision_minimo)) Is 0#">, 
						comision_excedente = <cfqueryparam value="#form.comision_excedente#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.comision_excedente)) Is 0#">, 
						plazo_sugerido = <cfqueryparam value="#form.plazo_sugerido#" cfsqltype="cf_sql_integer" null="#Len(Trim(form.plazo_sugerido)) Is 0#">, 
						plazo_maximo = <cfqueryparam value="#form.plazo_maximo#" cfsqltype="cf_sql_integer" null="#Len(Trim(form.plazo_maximo)) Is 0#">, 
						interes_corriente = <cfqueryparam value="#form.interes_corriente#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.interes_corriente)) Is 0#">,
						interes_mora = <cfqueryparam value="#form.interes_mora#" cfsqltype="cf_sql_numeric" scale="2" null="#Len(Trim(form.interes_mora)) Is 0#"> ,
						BMfechamod  = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						BMUsucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where LPlinea = <cfqueryparam value="#form.LPlinea#" cfsqltype="cf_sql_numeric">
					and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					
				</cfquery>
				
				<cfquery name="ABC_updELPrecios" datasource="#session.DSN#">
					update EListaPrecios
					set LPdescripcion = <cfqueryparam value="#form.LPdescripcion#"  cfsqltype="cf_sql_varchar">,
						Pais = <cfqueryparam value="#form.Pais#" cfsqltype="cf_sql_char">,
						moneda = <cfqueryparam value="#form.moneda#" cfsqltype="cf_sql_char">,
						meses_financiamiento = <cfqueryparam value="#form.meses_financiamiento#" cfsqltype="cf_sql_integer">
					where LPid      = <cfqueryparam value="#form.LPid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset action = "ListaPrecios.cfm">
				
			<!--- Caso 5: Borrar detalle de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				<cfquery name="ABC_delPaquetes" datasource="#session.DSN#">
					delete Paquetes	
					where LPlinea = <cfqueryparam value="#form.LPlinea#" cfsqltype="cf_sql_numeric" >
				</cfquery>
				<cfquery name="ABC_delDListaPrecios" datasource="#session.DSN#">	
					delete DListaPrecios
					where LPlinea = <cfqueryparam value="#form.LPlinea#" cfsqltype="cf_sql_numeric" >
					and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset action = "ListaPrecios.cfm">

			</cfif>

				
		
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "ListaPrecios.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>	

<cfif isdefined("form.btnAgregarE")>
	<cfset form.LPid = "#ABC_insLPrecios_id#">
</cfif>

<cfoutput>
<form action="#action#" method="get" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="LPid"   type="hidden" value="<cfif isdefined("form.LPid")>#form.LPid#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>