<cfparam name="URLLista" default="/cfmx/sif/cm/operacion/listaOrdenCM.cfm">
<cfparam name="URLNuevo" default="/cfmx/sif/cm/operacion/ordenCompra.cfm">
<cfif isdefined("url.Ecodigo_f")><cfset lvarFiltroEcodigo = trim(#url.Ecodigo_f#)></cfif>

<cfif not isdefined('lvarFiltroEcodigo') or len(trim(#lvarFiltroEcodigo#)) eq 0 >
  <cfset lvarFiltroEcodigo = #session.Ecodigo#>
</cfif>

<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden))><cfset form.EOidorden = url.EOidorden></cfif>
<cfparam name="modo" default="ALTA">
<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))><cfset modo = "CAMBIO"></cfif>

<!---Permite modificar las ordenes de compra cuando vienen del registro de solicitudes--->
<cfquery name="rsModificaOC" datasource="#Session.DSN#">
    select Pvalor as value
    from Parametros
    where Ecodigo = #lvarFiltroEcodigo#
      and Pcodigo = 4310
</cfquery>

<!---Pasa parámetros del url al form--->
<!---Consultas--->

<cfif (modo EQ "CAMBIO")>
	<cfif isdefined('lvarProvCorp') and lvarProvCorp eq true>
    	<cfquery name="rsEcodigo" datasource="#Session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
        </cfquery>
        <cfif Len(trim(rsEcodigo.Ecodigo))>
    		<cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
        </cfif>
    </cfif>
	<!--- Consulta del encabezado de la Orden --->
	<cfquery name="rsCantDetalles" datasource="#Session.DSN#">
		select 1
		from DOrdenCM
		where Ecodigo = #lvarFiltroEcodigo#
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	<!--- Consulta del encabezado de la Orden --->
	<cfquery name="rsOrden" datasource="#Session.DSN#">
		select  e.EOidorden, e.ts_rversion, <!---Ocultos--->
			e.EOnumero,rtrim(e.CMTOcodigo) as CMTOcodigo,e.SNcodigo, <!---Línea 1--->
			e.EOfecha,e.Mcodigo,e.EOtc, <!---Línea 2--->
			e.EOplazo,
			e.EOhabiles,
			coalesce(e.EOdesc,0.00)as EOdesc,
			e.Rcodigo, <!---Línea 3--->
			e.Observaciones, <!---Línea 5--->
			coalesce(e.Impuesto,0.00) as Impuesto,
			coalesce(e.EOtotal,0.00) as EOtotal,  <!---Cálculados en el SQL--->
			coalesce(e.EOTiEPS,0.00) as EOTiEPS,
			e.Ecodigo, e.CMCid, <!---Están en la session--->
			e.EOrefcot,e.Usucodigo,e.EOfalta,e.Usucodigomod,e.fechamod, <!---Campos de Control --->
			e.NAP,e.EOestado, e.EOporcanticipo, e.CMFPid, e.CMIid,
			e.EOdiasEntrega, e.EOtipotransporte, e.EOlugarentrega, e.CRid,
			CMTOte,CMTOtransportista,CMTOtipotrans,CMTOincoterm,CMTOlugarent,
			tor.CMTOModGeneral
		from EOrdenCM e
			left outer join CMTipoOrden tor
				on tor.Ecodigo=e.Ecodigo
					and tor.CMTOcodigo=e.CMTOcodigo
		where e.Ecodigo = #lvarFiltroEcodigo#
		  and e.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	<cfquery name="rsDSLinea" datasource="#session.dsn#">
	   select distinct(b.CMPid) from DOrdenCM a
	                                 inner join CMLineasProceso b
									 on a.DSlinea = b.DSlinea
	                    where a.Ecodigo = #lvarFiltroEcodigo# and a.EOidorden =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	<cfif rsDSLinea.recordcount gt 0>
		<cfquery name="rsCodigoProceso" datasource="#session.dsn#">
	     Select CMPcodigoProceso from CMProcesoCompra where Ecodigo = 	#Session.Ecodigo# and
		 CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSLinea.CMPid#">
		</cfquery>
	</cfif>

	<cfquery name="rsMontoDesc" datasource="#Session.DSN#">
		Select sum(coalesce(DOmontodesc,0)) as sumaDesc
		from DOrdenCM
		where Ecodigo = #lvarFiltroEcodigo#
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>

	<cfif isdefined('rsOrden') and rsOrden.recordCount GT 0 and rsOrden.Mcodigo NEQ ''>
		<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
			Select Mcodigo,Mnombre
			from Monedas
			where Ecodigo=#lvarFiltroEcodigo#
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.Mcodigo#">
		</cfquery>
	</cfif>

	<!---Totales--->
	<cfset rsTotales = QueryNew("subtotal,impuesto,descuento,total,ieps")>
	<cfset QueryAddRow(rsTotales,1)>
	<cfset QuerySetCell(rsTotales,"subtotal",rsOrden.EOtotal-rsOrden.Impuesto -rsOrden.EOTiEPS +rsOrden.EOdesc)>
	<cfset QuerySetCell(rsTotales,"impuesto",rsOrden.Impuesto)>
	<cfset QuerySetCell(rsTotales,"descuento",rsOrden.EOdesc)>
	<cfset QuerySetCell(rsTotales,"total",rsOrden.EOtotal)>
	<cfset QuerySetCell(rsTotales,"ieps",rsOrden.EOTiEPS)>

	<!---Manejo de Timestamp--->
	<cfif modo neq "ALTA">
		<cfinvoke
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsOrden.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNidentificacion, SNnombre from SNegocios
		where Ecodigo = #lvarFiltroEcodigo#
		  <!----<cfif isdefined("rsOrden.SNcodigo") and rsOrden.SNcodigo NEQ ''>---->
		  	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrden.SNcodigo#">
		  <!---</cfif>---->
	</cfquery>
</cfif>

<!--- Tipos de Orden --->
<cfquery name="rsTipoOrden" datasource="#session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo=#lvarFiltroEcodigo#
</cfquery>
<!--- Retenciones --->
<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion
	from Retenciones
	where Ecodigo = #lvarFiltroEcodigo#
		<cfif modo EQ 'CAMBIO' and rsOrden.Rcodigo NEQ '' and rsOrden.Rcodigo NEQ '-1'>
			and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOrden.Rcodigo#">
		</cfif>
	order by Rdescripcion
</cfquery>
<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = #lvarFiltroEcodigo#
</cfquery>
<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion
	from Impuestos
	where Ecodigo = #lvarFiltroEcodigo#
	order by Idescripcion
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = #Session.Ecodigo#
		<cfif modo EQ 'CAMBIO' and rsOrden.CMFPid NEQ ''>
			and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.CMFPid#">
		</cfif>
	order by CMFPcodigo
</cfquery>

<!--- Formas de pago por defecto del socio de negocio seleccionado ----->
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsFormaPagoSocio" datasource="#Session.DSN#">
		select b.CMFPid
		from SNegocios a
			left outer join CMFormasPago b
				on a.SNplazocredito = b.CMFPplazo
				and a.Ecodigo = b.Ecodigo
		where a.SNidentificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SNcodigo)#">
			and a.Ecodigo = #lvarFiltroEcodigo#
	</cfquery>
</cfif>


<!--- Incoterm --->
<cfquery name="rsCMIncoterm" datasource="#session.dsn#">
	select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
	from CMIncoterm
	where Ecodigo = #Session.Ecodigo#
	order by CMIcodigo
</cfquery>

<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = #Session.Ecodigo#
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">

	union

	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2
</cfquery>
<!--- Campos Obligatorios --->

<cfquery name="rsObligatorios" datasource="#Session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion, CMTgeneratracking, CMTOte, CMTOtransportista, CMTOtipotrans, CMTOincoterm, CMTOlugarent
	from CMTipoOrden
	where Ecodigo = #lvarFiltroEcodigo#
	order by CMTOcodigo
</cfquery>

<!---►►Campos Modificables◄◄--->
<cfquery name="rsModificables" datasource="#Session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOModDescripcion, CMTOModFechaEntrega, CMTOModFechaRequerida, CMTOModImpuesto,
			CMTOModDescripcionE, CMTOModCodigoEnc
	from CMTipoOrden
	where Ecodigo = #lvarFiltroEcodigo#
    <cfif modo neq 'ALTA'>
		and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsOrden.CMTOcodigo)#">
	</cfif>
    order by CMTOcodigo
</cfquery>
<cfset camposEditables  = "">
<cfset camposEditablesE  = ""> <!--- Encabezado --->
<cfset camposEditables = "Descripcion Alterna, Observaciones">
<cfset camposEditablesE = "">
<cfif rsModificables.CMTOModDescripcion eq '1'>
	<cfset camposEditables 	   = camposEditables& ",Descripción">
</cfif>
<cfif rsModificables.CMTOModFechaEntrega eq '1'>
	<cfset camposEditables = camposEditables & ',Fecha Entrega'>
</cfif>
<cfif rsModificables.CMTOModFechaRequerida eq '1'>
	<cfset camposEditables = camposEditables & ',Fecha Requerida'>
</cfif>
<cfif rsModificables.CMTOModImpuesto eq '1'>
	<cfset camposEditables  = camposEditables & ',Impuesto'>
</cfif>
<cfif rsModificables.CMTOModDescripcionE eq '1'>
	<cfif camposEditablesE eq ""><cfset coma =""><cfelse><cfset coma =","></cfif>
	<cfset camposEditablesE = camposEditablesE&coma& 'Descripci&oacute;n'>
</cfif>
<cfif rsModificables.CMTOModCodigoEnc eq '1'>
	<cfif camposEditablesE eq ""><cfset coma =""><cfelse><cfset coma =","></cfif>
	<cfset camposEditablesE  = camposEditablesE &coma& 'Tipo de Orden Compra'>
</cfif>


<!---Javascript Incial--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>
<script language="javascript" src="/cfmx/sif/js/qForms/qforms.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript
	//incluye qforms en la página
	// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
	qFormAPI.setLibraryPath("../../js/qForms/");
	// Qforms. carga todas las librerías por defecto
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

	var ob = new Object();
	<cfoutput query="rsObligatorios">
		ob['#CMTOcodigo#'] = new Object();
		ob['#CMTOcodigo#']['CMTOte'] = #CMTOte#;
		ob['#CMTOcodigo#']['CMTOtransportista'] = #CMTOtransportista#;
		ob['#CMTOcodigo#']['CMTOtipotrans'] = #CMTOtipotrans#;
		ob['#CMTOcodigo#']['CMTOincoterm'] = #CMTOincoterm#;
		ob['#CMTOcodigo#']['CMTOlugarent'] = #CMTOlugarent#;
	</cfoutput>

	<!--- Codigo 0 equivale a deshabilitar todo --->
	function setRequired(codigo) {
		if (ob[codigo] != null) {
			if (ob[codigo]['CMTOte'] == 1) { objForm.EOdiasEntrega.required = true; } else { objForm.EOdiasEntrega.required = false; }
			if (ob[codigo]['CMTOtransportista'] == 1) { objForm.CRid.required = true; } else { objForm.CRid.required = false; }
			if (ob[codigo]['CMTOtipotrans'] == 1) { objForm.EOtipotransporte.required = true; } else { objForm.EOtipotransporte.required = false; }
			if (ob[codigo]['CMTOincoterm'] == 1) { objForm.CMIid.required = true; } else { objForm.CMIid.required = false; }
			if (ob[codigo]['CMTOlugarent'] == 1) { objForm.EOlugarentrega.required = true; } else { objForm.EOlugarentrega.required = false; }
		} else {
			objForm.CMIid.required = false;
			objForm.CRid.required = false;
			objForm.EOtipotransporte.required = false;
			objForm.EOlugarentrega.required = false;
			objForm.EOdiasEntrega.required = false;
		}
	}

	function funcSNnumero(){
		document.form1.action = 'ordenCompra.cfm'
		document.form1.submit()
	}

//-->
</script>
<!---Pintado del form--->

<cfoutput>

<form action="ordenCompra-sql.cfm" method="post" name="form1" onSubmit="javascript: return _formEnd();">
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap class="subTitulo"><font size="2">Encabezado de Orden de Compra</font></td>
  </tr>
</table>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0" summary="Formulario del Encabezado de Ordenes de Compra (EOrdenCM)">
  <tr>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
  </tr>
  <!---Línea 1--->
	<tr>
    <td nowrap align="right"><strong>N&uacute;mero de Orden:&nbsp;</strong></td>
    <td nowrap>
			<!---Número de Orden: Este campo se llena con un cálculo en el SQL --->
			<input type="text" name="EOnumero" size="18" tabindex="1"
				style="border: 0px none; background-color: ##FFFFFF;" maxlength="10" readonly=""
				value="<cfif (modo EQ "CAMBIO")>#rsOrden.EOnumero#<cfelse>N/D</cfif>"></td>
    <td nowrap align="right"><strong>Tipo de Orden:&nbsp;</strong></td>
    <td nowrap>
			<!---Tipo de Orden--->
			<cfif (modo EQ "CAMBIO") and rsModificables.CMTOModCodigoEnc neq 1>
				<input type="hidden" name="CMTOcodigo" value="#rsOrden.CMTOcodigo#">
				<cfloop query="rsTipoOrden">
					<cfif rsOrden.CMTOcodigo eq rsTipoOrden.CMTOcodigo>
							#rsTipoOrden.CMTOcodigo# - #rsTipoOrden.CMTOdescripcion#
					</cfif>
				</cfloop>
			<cfelse>
				<select name="CMTOcodigo" tabindex="1" onChange="javascript: setRequired(this.value);">
					<cfloop query="rsTipoOrden">
						<option value="#trim(rsTipoOrden.CMTOcodigo)#" <cfif (modo EQ "CAMBIO") and trim(rsTipoOrden.CMTOcodigo) eq trim(rsOrden.CMTOcodigo)>selected<cfelseif modo EQ 'ALTA' and isdefined("form.CMTOcodigo") and trim(rsTipoOrden.CMTOcodigo) eq trim(form.CMTOcodigo)>selected</cfif> >#rsTipoOrden.CMTOdescripcion#</option>
					</cfloop>
				</select>
			</cfif>
		</td>
    <td nowrap align="right"><strong>Provedor:&nbsp;</strong></td>
    <td nowrap>
			<!---Provedor--->
			<cfif (modo EQ "CAMBIO")>
				#rsNombreSocio.SNnombre#
				<input type="hidden" name="SNcodigo" value="#rsOrden.SNcodigo#">
				<input type="hidden" name="SNidentificacion" value="#rsNombreSocio.SNidentificacion#">
			<cfelseif isdefined("form.SNcodigo") and len(trim(form.SNCodigo))>
				  <cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" idquery="#form.SNcodigo#" Ecodigo="#lvarFiltroEcodigo#">
            <cfelse>
				 <cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" Ecodigo="#lvarFiltroEcodigo#">
            </cfif>
	</td>
    <cfif MODO NEQ "ALTA">
        <tr>
			<cf_cboFormaPago TESOPFPtipoId="2" TESOPFPid="#rsOrden.EOidorden#">
        </tr>

	</cfif>
  </tr>
	<!---Línea 2--->
  <tr>
    <td nowrap align="right"><strong>Fecha:&nbsp;</strong></td>
    <td nowrap>
			<!---Fecha--->
			<cfif (modo EQ "CAMBIO")>
				<input type="hidden" name="EOfecha" id="EOfecha" value="<cfif modo EQ 'CAMBIO'>#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#</cfif>">
				#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#
			<cfelse>
				<cf_sifcalendario name="EOfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
			</cfif>
		</td>
    <td nowrap align="right"><strong>Moneda:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
		 <input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsOrden.Mcodigo#">
		 <input type="hidden" name="TC" id="TC" value="#rsOrden.EOtc#">
			#rsMonedaSel.Mnombre#
		<cfelse>
			<cf_sifmonedas onchange="asignaTC();" query="#rsMonedaLocal#"  fechasugtc="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1" Ecodigo="#lvarFiltroEcodigo#">
		</cfif>
 	<!---

				<cf_sifmonedas query="#rsOrden#" valuetc="#rsOrden.EOtc#" onchange="asignaTC();" fechasugtc="#LSDateFormat(rsOrden.EOfecha,'DD/MM/YYYY')#" tabindex="1">
			<cfelse>
				<cf_sifmonedas onchange="asignaTC();" fechasugtc="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
			</cfif>--->
	</td>
    <td nowrap align="right"><strong>Tipo de Cambio:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
			<input type="hidden" name="EOtc" id="EOtc" value="#LSNumberFormat(rsOrden.EOtc,',9.0000')#">
			#LSNumberFormat(rsOrden.EOtc,',9.0000')#
		<cfelse>
			<input 	type="text" name="EOtc" style="text-align:right"size="18" maxlength="18"  tabindex="1"
				onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onChange="javascript: fm(this,4);"
				value="0.00"
				>
		</cfif>
		</td>
  </tr>
	<!---Línea 3--->
  <tr>
    <td nowrap align="right"><strong>Retenci&oacute;n:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
			<input type="hidden" name="Rcodigo" id="Rcodigo" value="<cfif len(trim(rsOrden.Rcodigo))>#rsOrden.Rcodigo#<cfelse>-1</cfif>">
			<cfif modo EQ 'CAMBIO' and Len(Trim(rsOrden.Rcodigo))>
				#rsRetenciones.Rdescripcion#
			<cfelse>
				-- Sin Retenci&oacute;n --
			</cfif>

		<cfelse>
			<select name="Rcodigo" tabindex="1">
				<option value="-1" >-- Sin Retenci&oacute;n --</option>
				<cfloop query="rsRetenciones">
					<option value="#rsRetenciones.Rcodigo#">#rsRetenciones.Rdescripcion#</option>
				</cfloop>
			</select>
		</cfif>
	</td>
    <td nowrap align="right"><strong>Descuento:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
			<input type="hidden" name="EOdesc" id="EOdesc" value="<cfif modo EQ 'CAMBIO'>#LSCurrencyFormat(rsMontoDesc.sumaDesc,'none')#</cfif>">
			#LSCurrencyFormat(rsMontoDesc.sumaDesc,'none')#
		<cfelse>
			<input 	name="EOdesc" readonly="true" type="text" size="18" tabindex="1" maxlength="18" style="text-align:right"
				onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onBlur="javascript: fm(this,2); <cfif modo neq 'ALTA'>calcular_totales();</cfif> "
				value="0.00">
		</cfif>
	</td>
    <td nowrap align="right"><strong>% Anticipo:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
			<input type="hidden" name="EOporcanticipo" id="EOporcanticipo" value="#LSCurrencyFormat(rsOrden.EOporcanticipo,'none')#">
			<!--- #LSNumberFormat(rsOrden.EOtc,',9.0000')# --->
			#rsOrden.EOporcanticipo#
		<cfelse>
			<input 	name="EOporcanticipo" type="text" size="6" tabindex="1" maxlength="6" style="text-align:right"
				onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onChange="javascript: fm(this,2);"
				value="0.00">
		</cfif>
		</td>
  </tr>
	<!---Línea 4--->
  <tr>
    <td nowrap align="right"><strong>Formas de Pago:&nbsp;</strong></td>
    <td nowrap>
		<cfif (modo EQ "CAMBIO")>
			<input type="hidden" name="CMFPid" id="CMFPid" value="#rsCMFormasPago.CMFPid#">
			<!----#rsCMFormasPago.CMFPcodigo# - ----->#rsCMFormasPago.CMFPdescripcion#
		<cfelse>
			<select name="CMFPid" onChange="javascript: getPlazo(this.form.EOplazo, this.value);">
				<cfloop query="rsCMFormasPago">
					<option value="#CMFPid#" <cfif isdefined("rsFormaPagoSocio") and len(trim(rsFormaPagoSocio.CMFPID)) and rsCMFormasPago.CMFPid eq rsFormaPagoSocio.CMFPid> selected</cfif>><!----#CMFPcodigo# - ---->#CMFPdescripcion#</option>
				</cfloop>
			</select>
		</cfif>
	</td>
    <td nowrap align="right"><strong>Plazo de Cr&eacute;dito:&nbsp;</strong></td>
    <td nowrap>
	  <input 	type="text" name="EOplazo" style="text-align:right" tabindex="1"
				onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onChange="javascript:fm(this,0);"
				value="<cfif modo EQ 'CAMBIO' and rsOrden.EOplazo NEQ 0>#rsOrden.EOplazo#<cfelse>0</cfif>" size="5" maxlength="5" readonly>

  d&iacute;as.
   </td>
    <td nowrap align="right"><strong>Incoterm:&nbsp;</strong></td>
    <td nowrap>
		<input type="hidden" name="CMIid" id="CMIid" value="<cfif modo EQ 'CAMBIO'>#rsOrden.CMIid#</cfif>">
		<select name="CMIid_cb"  tabindex="1" onChange="javascript: cambiaInco(this);">
			<option value="">--Ninguno--</option>
			<cfloop query="rsCMIncoterm">
				<option value="#CMIid#" <cfif modo EQ 'CAMBIO' and rsCMIncoterm.CMIid eq rsOrden.CMIid>selected</cfif>>#CMIcodigo# - #CMIdescripcion#</option>
			</cfloop>
		</select>
	</td>
    </tr>
  <tr>
    <td nowrap align="right"><strong>Lugar de Entrega:&nbsp;</strong></td>
    <td nowrap>
		<input
			name="EOlugarentrega"
			type="text"
			<cfif (modo EQ "CAMBIO") and rsOrden.CMTOlugarent EQ 0>
				readonly="true"
			</cfif>
			tabindex="1"
			value="<cfif (modo EQ "CAMBIO")>#rsOrden.EOlugarentrega#</cfif>"
			maxlength="255"
			size="30">
	</td>
    <td nowrap align="right"><strong>Tipo de Transporte:&nbsp;</strong></td>
    <td nowrap>
		<input
			name="EOtipotransporte"
			type="text"
			tabindex="1"
			value="<cfif (modo EQ "CAMBIO")>#rsOrden.EOtipotransporte#</cfif>"
			maxlength="80"
			<cfif (modo EQ "CAMBIO") and rsOrden.CMTOtipotrans EQ 0>
				readonly="true"
			</cfif>
			size="30">
	</td>
    <td nowrap align="right"><strong>Tiempo de Entrega:&nbsp;</strong></td>
    <td nowrap>
      <input type="text" name="EOdiasEntrega" style="text-align:right" tabindex="1"
				onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onChange="javascript:fm(this,0);"
				<cfif (modo EQ "CAMBIO") and rsOrden.CMTOte EQ 0>
					readonly="true"
				</cfif>
				value="<cfif (modo EQ "CAMBIO")>#rsOrden.EOdiasEntrega#<cfelse>0</cfif>" size="5" maxlength="5">
  d&iacute;as.
  <select name="EOhabiles" id="EOhabiles">
		<option value="1" <cfif modo EQ "CAMBIO" and rsOrden.EOhabiles eq 1 >selected</cfif>>H&aacute;biles</option>
		<option value="0" <cfif modo EQ "CAMBIO" and rsOrden.EOhabiles eq 0 >selected</cfif>>Naturales</option>
	  </select>
   </td>
  </tr>
  <tr>
    <td nowrap align="right"><strong>Transportista:&nbsp;</strong></td>
    <td nowrap>
		<input type="hidden" name="CRid" id="CRid" value="<cfif modo EQ 'CAMBIO'>#rsOrden.CRid#</cfif>">
      	<select name="CRid_cb" <cfif modo EQ 'CAMBIO' and rsOrden.CMTOtransportista EQ 0> disabled</cfif> tabindex="1" onChange="javascript: cambiaTrans(this);">
        	<option value="">--- Niguno ---</option>
	        <cfloop query="rsCourier">
    	      <option value="#rsCourier.CRid#" <cfif modo EQ 'CAMBIO' and rsOrden.CRid eq rsCourier.CRid> selected</cfif>>#trim(rsCourier.CRcodigo)# - #trim(rsCourier.CRdescripcion)#</option>
        	</cfloop>
		</select>
    </td>
    <td nowrap align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
    <td nowrap>
		<cfset LvarObserva = "">
		<cfif (modo EQ "CAMBIO")>
	        <cfset LvarObserva = rsOrden.Observaciones>
        	<cfif len(trim(LvarObserva)) eq 0>
				<cfset LvarObserva = '--'>
			</cfif>
		</cfif>
		<cfif rsModificables.CMTOModDescripcionE  neq 1 and modo eq 'CAMBIO'>
			#LvarObserva#
			<input type="hidden" name="Observaciones" id="Observaciones" value="#LvarObserva#">
		<cfelse>
			<input name="Observaciones" id="Observaciones" type="text" tabindex="1" value="<cfif (modo EQ "CAMBIO")>#LvarObserva#</cfif>" maxlength="255" style="width: 95%">
		</cfif>
    </td>
	<cfif isdefined ('rsCodigoProceso') and rsCodigoProceso.recordcount gt 0>
	<td nowrap align="right"><strong>C&oacute;digo del proceso:</strong></td>
	<td nowrap="nowrap">&nbsp;
	<cfoutput>#rsCodigoProceso.CMPcodigoProceso#</cfoutput>
	</td>
	</cfif>
    </tr>
  <tr><td nowrap colspan="6">&nbsp;</td></tr>
</table>

<cfif (modo EQ "CAMBIO")>
	<cfinclude template="ordenCompraD.cfm">
</cfif>

<!---Area de campos ocultos del encabezado--->
<input type="hidden" name="EOidorden" value="<cfif (modo EQ "CAMBIO")>#form.EOidorden#</cfif>">
<input type="hidden" name="ts_rversion" value="<cfif (modo EQ "CAMBIO")>#ts#</cfif>">
<input type="hidden" name="Ecodigo_f" value="<cfoutput>#lvarFiltroEcodigo#</cfoutput>">
<input type="hidden" name="EncabezadoCambiado">
<cfset exclude="">
<cfset include="Aplicar">
<cfif (modo eq "CAMBIO") and (rsCantDetalles.RecordCount)>
	<cfset includevalues="Aplicar">
	<cfset include="btnAplicar">
<cfelse>
	<cfset includevalues="">
	<cfset include="">
</cfif>
<cfif isdefined("Request.OCRechazada.ModoRechazo") and Request.OCRechazada.ModoRechazo>
	<input type="hidden" name="Action" value="#Request.OCRechazada.Action#">
	<cfset exclude=exclude&iif(len(exclude),DE(','),DE(''))&"Nuevo,Baja">
	<cfset includevalues=includevalues&iif(len(includevalues),DE(','),DE(''))&"Regresar">
	<cfset include=include&iif(len(include),DE(','),DE(''))&"Regresar">
</cfif>

<!--- Las Ordenes Generadas por Solicitud de Compra Directa o cuyos items provienen de un contrato no se puede eliminar ni modificar --->
<cfif modo EQ "CAMBIO" and (rsOrden.EOestado EQ 5 or rsOrden.EOestado EQ 7 or rsOrden.EOestado EQ 8)>
	<cfif rsOrden.EOestado EQ 7 and rsModificaOC.value EQ 0>
		<p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra fue generada por solicitud de compra directa. No se puede modificar ni eliminar.</p>
	<cfelseif rsOrden.EOestado EQ 8 and rsModificaOC.value EQ 0>
		<p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra fue generada por solicitud de compra con itemes que pertenecen a un contrato. No se puede modificar ni eliminar.</p>
	</cfif>
	<cfif ListContainsNoCase(exclude,'AltaDet',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "AltaDet">
	</cfif>
	<cfif ListContainsNoCase(exclude,'Baja',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "Baja">
	</cfif>
	<!---
	<cfif ListContainsNoCase(exclude,'Cambio',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "Cambio">
	</cfif>
	--->
	<cfif ListContainsNoCase(exclude,'BajaDet',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "BajaDet">
	</cfif>
	<cfif ListContainsNoCase(exclude,'CambioDet',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "CambioDet">
	</cfif>
	<cfif ListContainsNoCase(exclude,'NuevoDet',',') EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "NuevoDet">
	</cfif>
</cfif>
<!----/-*/-*/-*/-*////////////////////////////////---->
<cfif isdefined("rsUsuario_autorizado") and rsUsuario_autorizado.RecordCount NEQ 0>
	<cfquery name="rsEsComprador" datasource="#session.DSN#">
		select Usucodigo
		from CMCompradores
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfif rsEsComprador.RecordCount EQ 0>
		<cfset exclude = exclude & Iif(len(exclude),DE(','),DE('')) & "Nuevo">
	</cfif>
</cfif>
<!----/*/-*/-*/-*/-*//////////////////////////////---->
<cfparam name="mododet" default="CAMBIO">
<br>
<!---►►Ordes de Compra Enviada a Aprobar◄◄--->
<cfif (modo EQ "CAMBIO") and rsOrden.EOestado eq -7 >
   <p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra está en espera de ser aprobada por un encargado.</p>
<!---►►Ordes de Compra Rechazadas◄◄--->
<cfelseif (modo EQ "CAMBIO") and rsOrden.EOestado eq -8 >
	<cfset exclude=exclude&iif(len(exclude),DE(','),DE(''))&"Nuevo">
<!--- <cfdump var="#include#-----hola------#includevalues#"> --->
	 <cf_botones modo="#modo#" mododet="#mododet#" nameenc="Orden" generoenc="F" tabindex="5" include="" includevalues="" exclude="#exclude#">
    <div align="center">
		<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea)) and rsOrden.CMTOModGeneral  EQ 1>
			<input name="CambioDet" type="submit"   value="Modificar Línea" class="btnGuardar"/>
		<cfelseif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
            <input name="CambioDetM" type="submit"  value="Modificar Campos Editables(*)" class="btnGuardar"/>
        </cfif>
       		<input name="NuevoDet" 	 type="submit"  value="Nueva Linea" onclick="return funcNuevoDet()" class="btnNuevo"/>
        	<input name="btnReiniciar" type="submit" value="Enviar a Aprobación" class="btnAplicar" />
	</div>
    <input name="botonSel" type="hidden" />
    <p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra fue Rechazada.</p>
	<p align="center" style="color: ##FF0000;">
	<cfif camposEditablesE neq "">
		(*)Campos editables del Encabezado: #camposEditablesE#<br />
	</cfif>
		(*)Campos Editables del Detalle: #camposEditables#</p>
<!---►►Ordes de Compra Autorizada por jefe de Compras◄--->
<cfelseif (modo EQ "CAMBIO") and rsOrden.EOestado eq 9>
 	<div align="center">
		<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
            <input name="CambioDetM" type="submit"  value="Modificar Campos Editables(*)" class="btnGuardar"/>
        </cfif>
            <input name="btnAplicar" type="submit" value="Aplicar" class="btnAplicar"/>
            <input name="botonSel"   type="hidden" />
            <p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra sólo puede ser aplicada. No permite modificaciones.</p>
			<p align="center" style="color: ##FF0000;">
			<cfif camposEditablesE neq "">
				(*)Campos editables del Encabezado: #camposEditablesE#<br />
			</cfif>
				(*)Campos Editables del Detalle: #camposEditables#</p>
	</div>
<!---►►Ordenes Pendientes de aplicar, provenientes de un proceso de Publicacion◄◄--->
<cfelseif modo EQ "CAMBIO" and rsOrden.EOestado EQ 5>
	<div align="center">
				<input name="btnAplicar" type="submit" value="Aplicar" class="btnAplicar"/>
		<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
        	<cfif LEN(TRiM(rsLinea.DClinea))>
            	<input name="CambioDetM" type="submit"  value="Modificar Campos Editables(*)" class="btnGuardar"/>
            <cfelse>
            	<input name="CambioDet" type="submit"   value="Modificar Línea" class="btnGuardar"/>


            </cfif>
            	<input name="NuevoDet" 	 type="submit"  value="Nueva Linea" onclick="return funcNuevoDet()" class="btnNuevo"/>
        <cfelse>
        		<input name="AltaDet" 	 type="submit" value="Guardar Linea" class="btnGuardar"/>
        </cfif>

                <input name="botonSel"   type="hidden"/>
                <input name="Nuevo"  	 type="button" value="Nueva Orden" onclick="return funcNuevo()" class="btnNuevo"/>
                <input name="Regresar"   type="button" value="Regresar" onclick="return funcRegresar()" class="btnAnterior"/>

             <p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra proviene de un proceso de publicación.</p>
			 <p align="center" style="color: ##FF0000;">
			<cfif camposEditablesE neq "">
				(*)Campos editables del Encabezado: #camposEditablesE#<br />
			</cfif>
				(*)Campos Editables del Detalle: #camposEditables#</p>
	</div>
<cfelseif (modo EQ "CAMBIO") and (rsOrden.EOestado EQ 7 or rsOrden.EOestado EQ 8) and rsModificaOC.value EQ 0>
	 <cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
		<cfset include = include &",CambioDetM">
        <cfset includevalues = includevalues &",Modificar Campos Editables(*)">
    </cfif>

     <cf_botones modo="#modo#" mododet="#mododet#" nameenc="Orden" generoenc="F" tabindex="5" include="#include#" includevalues="#includevalues#" exclude="#exclude#"><br>
	<p align="center" style="color: ##FF0000;">
	<cfif camposEditablesE neq "">
		(*)Campos editables del Encabezado: #camposEditablesE#<br />
	</cfif>
		(*)Campos Editables del Detalle: #camposEditables#</p>
<cfelseif (modo EQ "CAMBIO") and  (rsOrden.EOestado EQ 5 or rsOrden.EOestado EQ 7 or rsOrden.EOestado EQ 8) and rsModificaOC.value NEQ 0>
	<cf_botones modo="#modo#" mododet="#mododet#" nameenc="Orden" generoenc="F" tabindex="5" include="#include#" includevalues="#includevalues#" exclude="AltaDet"><br>
<cfelse>
<table align="center">
<td>
<cf_botones modo="#modo#" mododet="#mododet#" nameenc="Orden" generoenc="F" tabindex="5" include="#include#" includevalues="#includevalues#" exclude="#exclude#">
</td>
<cfif modo EQ "CAMBIO">
<td>
<input type="button" class="btnNormal"  tabindex="1" name="Suficiencia" value="Suficiencia" onClick="javascript:VentanaSuficiencia(<cfoutput><cfif isdefined('form.EOidorden') and len(trim(#form.EOidorden#))>#form.EOidorden#</cfif></cfoutput>);">
</td>
<td>
<input type="button" class="btnNormal"  tabindex="1" name="SolicitudCompra" value="Solicitud de Compra" onClick="javascript:VentanaSolicitudCompra(<cfoutput><cfif isdefined('form.EOidorden') and len(trim(#form.EOidorden#))>#form.EOidorden#</cfif></cfoutput>);">
</td>
<td>
<input type="button" class="btnNormal"  tabindex="1" name="Contrato" value="Contrato" onClick="javascript:VentanaContrato(<cfoutput><cfif isdefined('form.EOidorden') and len(trim(#form.EOidorden#))>#form.EOidorden#</cfif></cfoutput>);">
</td>
</cfif>
</table>
</cfif>
<cfif (modo EQ "CAMBIO")>
	<cfinclude template="ordenCompraL.cfm">
</cfif>
</form>
</cfoutput>

<!---Javascript Final--->
<cfparam name="qformsNombresCamposDetalle" 			default="">
<cfparam name="qformsHabilitarValidacionDetalle" 	default="">
<cfparam name="qformsDesHabilitarValidacionDetalle" default="">
<cfparam name="qformsFinalizarValidacionDetalle" 	default="">
<cfparam name="qformsFocusOnDetalle" 				default="">
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript
	//define el color de los campos en caso de error
	qFormAPI.errorColor = "#FFFFCC";
	//inicializa qforms en la página

	function  cambiaTrans(obj){
		obj.form.CRid.value = obj.value;
	}

	function  cambiaInco(obj){
		obj.form.CMIid.value = obj.value;
	}

	function isRango() {
		if ( objForm.EOporcanticipo.value > 100 ) {
			//this.obj.focus();
			this.error = "El campo " + this.description + " debe estar en el rango 0-100!";
		}
	}

	objForm = new qForm("form1");

	function __isPositiveFloat(){
		if (!objForm.allowsubmitonerror){
			// check to make sure the current value is greater then zero
			if( parseFloat(this.value) < 0.01 ){
				// here's the error message to display
				this.error = "El campo " + this.description + " debe";
				this.error += " contenter un número mayor a 0.00.";
			}
		}
	}
	_addValidator("isPositiveFloat", __isPositiveFloat);

	function __isPositiveFloat4(){
		if (!objForm.allowsubmitonerror){
			// check to make sure the current value is greater then zero
			if( parseFloat(this.value) < 0.0001 ){
				// here's the error message to display
				this.error = "El campo " + this.description + " debe";
				this.error += " contenter un número mayor a 0.0000.";
			}
		}
	}
	_addValidator("isPositiveFloat4", __isPositiveFloat4);


	//Llama el conlis
	function VentanaSuficiencia(EOidorden) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/cm/operacion/popUp-suficiencia.cfm?EOidorden="+EOidorden+params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
	}

	//Llama el conlis
	function VentanaSolicitudCompra(EOidorden) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/cm/operacion/popUp-solicitudCompra.cfm?EOidorden="+EOidorden+"&Ecodigo="+<cfoutput>#lvarFiltroEcodigo#</cfoutput>+params,50,50,window.screen.width/2+290 ,window.screen.height/2);
	}

	//Llama el conlis
	function VentanaContrato(EOidorden) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/cm/operacion/popUp-contrato.cfm?EOidorden="+EOidorden+"&Ecodigo="+<cfoutput>#lvarFiltroEcodigo#</cfoutput>+params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
	}

	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}



	<cfoutput>

	//Define nombres de los campos
	objForm.EOnumero.description = "#JSStringFormat('Número de Orden')#";
	objForm.CMTOcodigo.description = "#JSStringFormat('Tipo de Orden')#";
	objForm.SNcodigo.description = "#JSStringFormat('Provedor')#";
	objForm.EOfecha.description = "#JSStringFormat('Fecha')#";
	objForm.Mcodigo.description = "#JSStringFormat('Moneda')#";
	objForm.EOtc.description = "#JSStringFormat('Tipo de Cambio')#";
	objForm.EOplazo.description = "#JSStringFormat('Plazo de Crédito')#";
	objForm.Rcodigo.description = "#JSStringFormat('Retenciones')#";
	objForm.EOdesc.description = "#JSStringFormat('Descuento')#";
	objForm.Observaciones.description = "#JSStringFormat('Descripcion')#";
	objForm.EOporcanticipo.description = "#JSStringFormat('% Anticipo')#";
	objForm.CMFPid.description = "#JSStringFormat('Forma de Pago')#";

	objForm.CMIid.description = "#JSStringFormat('Incoterm')#";
	objForm.CRid.description = "#JSStringFormat('Transportista')#";
	objForm.EOtipotransporte.description = "#JSStringFormat('Tipo de Transporte')#";
	objForm.EOlugarentrega.description = "#JSStringFormat('Lugar de Entrega')#";
	objForm.EOdiasEntrega.description = "#JSStringFormat('Tiempo de Entrega')#";

	#qformsNombresCamposDetalle#

	//Habilita validaciones de campos segun las reglas
	function habilitarValidacion(){
		//objForm.EOnumero.required = true;
		objForm.CMTOcodigo.required = true;
		objForm.SNcodigo.required = true;
		objForm.EOfecha.required = true;
		objForm.Mcodigo.required = true;
		objForm.EOtc.required = true;
		objForm.EOplazo.required = true;
		objForm.Rcodigo.required = true;
		objForm.EOdesc.required = true;
		objForm.Observaciones.required = true;
		objForm.EOporcanticipo.required = true;
		objForm.allowsubmitonerror=false;
		setRequired(document.form1.CMTOcodigo.value);
		#qformsHabilitarValidacionDetalle#
		if(window.habilitar_TESOPFP) habilitar_TESOPFP();
	}
	//Deshabilita todas las validaciones de campos
	function deshabilitarValidacion(){
		//objForm.EOnumero.required = false;
		objForm.CMTOcodigo.required = false;
		objForm.SNcodigo.required = false;
		objForm.EOfecha.required = false;
		objForm.Mcodigo.required = false;
		objForm.EOtc.required = false;
		objForm.EOplazo.required = false;
		objForm.Rcodigo.required = false;
		objForm.EOdesc.required = false;
		objForm.Observaciones.required = false;
		objForm.EOporcanticipo.required = false;
		objForm.allowsubmitonerror=true;
		setRequired(0);
		#qformsDesHabilitarValidacionDetalle#
		if(window.deshabilitar_TESOPFP) deshabilitar_TESOPFP();
	}
	//function para iniciar el form1
	function _formIni(){
		habilitarValidacion();
		<cfif (modo EQ "ALTA")>
			objForm.CMTOcodigo.obj.focus();
		<cfelse>
			#qformsFocusOnDetalle#
		</cfif>
	}
	//function para finalizar el form1
	function _formEnd(){
		//Define si se cambió el encabezado *** también se podría hacer enuna línea con objForm.hasChanged(),...
		//...pero se fija en todo el form y como tenemos el encabezado y los detalles en el mismo form no se puede. ***

		<cfif (modo EQ "CAMBIO")>
			if(document.form1.cambioDescuentos.value == 0){
				if (
					objForm.CMTOcodigo.lastValue==objForm.CMTOcodigo.getValue() &&
					objForm.SNcodigo.lastValue==objForm.SNcodigo.getValue() &&
					objForm.EOfecha.lastValue==objForm.EOfecha.getValue() &&
					objForm.Mcodigo.lastValue==objForm.Mcodigo.getValue() &&
					objForm.EOtc.lastValue==objForm.EOtc.getValue() &&
					objForm.EOplazo.lastValue==objForm.EOplazo.getValue() &&
					objForm.Rcodigo.lastValue==objForm.Rcodigo.getValue() &&
					objForm.EOdesc.lastValue ==  objForm.EOdesc.getValue() &&
					objForm.Observaciones.lastValue==objForm.Observaciones.getValue() &&
					objForm.EOporcanticipo.lastValue==objForm.EOporcanticipo.getValue()
				)
					objForm.EncabezadoCambiado.obj.value = 0;
				else
					objForm.EncabezadoCambiado.obj.value = 1;
			}else{
				objForm.EncabezadoCambiado.obj.value = 1;
			}
		<cfelse>
			objForm.EncabezadoCambiado.obj.value = 0;
		</cfif>

		//finaliza campos para que lleguen bien al Sql
		objForm.EOtc.obj.disabled = false;
		objForm.EOtc.obj.value = qf(objForm.EOtc.obj.value);
		objForm.EOdesc.obj.value = qf(objForm.EOdesc.obj.value);
		objForm.EOporcanticipo.obj.value = qf(objForm.EOporcanticipo.obj.value);
		#qformsFinalizarValidacionDetalle#

		return true;
	}
	</cfoutput>
	//inicia el form1
	_formIni();
	/* **************************************************** Inician funciones del form **************************************************** */
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {
		var f = document.form1;
		<cfif modo EQ "ALTA">
			if (f.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
				formatCurrency(f.TC,2);
				f.EOtc.disabled = true;
			}
			else
				f.EOtc.disabled = false;

			var estado = f.EOtc.disabled;
			f.EOtc.disabled = false;
			f.EOtc.value = f.TC.value;
			f.EOtc.disabled = estado;
		<cfelse>
			if (f.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				formatCurrency(f.TC,2);

			f.EOtc.value = f.TC.value;
		</cfif>
	}
	function validatcLOAD()	{
	  var f = document.form1;
	  <cfif modo EQ "ALTA">
			if (f.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")	{
				f.EOtc.value = "1.0000";
				f.EOtc.disabled = true;
			}
			else {
				f.Mcodigo.value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>";
				f.EOtc.value = "1.0000";
				f.EOtc.disabled = true;
			}
	   <cfelse>
			if (f.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				f.EOtc.disabled = true;
			else
				f.EOtc.disabled = false;
	   </cfif>
	}
	validatcLOAD();
	function asignatcLOAD(){
		var f = document.form1;
		<cfif modo NEQ "ALTA">
			asignaTC();
		<cfelse>
			var estado = f.EOtc.disabled;
			f.EOtc.disabled = false;
			f.EOtc.value = f.TC.value;
			f.EOtc.disabled = estado;
		</cfif>
	}
	asignatcLOAD();
	<cfif modo EQ 'ALTA'>
		getPlazo(document.form1.EOplazo, document.form1.CMFPid.value);
	</cfif>
	setRequired(document.form1.CMTOcodigo.value);
	cambiaTrans(document.form1.CRid_cb);
	cambiaInco(document.form1.CMIid);


	function funcbtnAplicar (){
		if (fnAplicar_TESOPFP) return fnAplicar_TESOPFP();
	}
	//FUNCION PARA REGRESAR AL LISTADO
	function funcRegresar(){
		deshabilitarValidacion();
		window.location = '<cfoutput>#URLLista#</cfoutput>';
	}

	function funcRefrescar(){
		document.form1.action = '<cfoutput>ordenCompra.cfm</cfoutput>';
		document.form1.submit();
	}

	//FUNCION PARA IR A CREAR NUEVA ORDEN DE COMPRA
	function funcNuevo(){
		deshabilitarValidacion();
		window.location = '<cfoutput>#URLNuevo#</cfoutput>';
	}
	//FUNCION PARA IR A CREAR UNA NUEVA LINEA DE LA ORDEN DE COMPRA
	function funcNuevoDet(){
		deshabilitarValidacion();
		return true;
	}
</script>