<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden))><cfset form.EOidorden = url.EOidorden></cfif>
<cfparam name="modo" default="ALTA">
<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))><cfset modo = "CAMBIO"></cfif>
<!---Pasa parámetros del url al form--->
<!---Consultas--->
<cfif (modo EQ "CAMBIO")>
	<!--- Consulta del encabezado de la Orden ---> 
	<cfquery name="rsCantDetalles" datasource="#Session.DSN#">
		select 1
		from DOrdenCM
		where Ecodigo = #Session.Ecodigo#
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	<!--- Consulta del encabezado de la Orden ---> 
	<cfquery name="rsOrden" datasource="#Session.DSN#">
		select  e.EOidorden, e.ts_rversion, 						<!---Ocultos--->
			EOnumero,rtrim(e.CMTOcodigo) as CMTOcodigo,SNcodigo, 	<!---Línea 1--->
			EOfecha,e.Mcodigo,EOtc, 									<!---Línea 2--->
			EOplazo,
			coalesce(EOdesc,0.00)as EOdesc,
			Rcodigo, 												<!---Línea 3--->
			Observaciones, 											<!---Línea 5 --->
			coalesce(Impuesto,0.00) as Impuesto,
			coalesce(EOtotal,0.00) as EOtotal,  					<!---Cálculados en el SQL--->
			e.Ecodigo, CMCid, 										<!---Están en la session--->
			EOrefcot,e.Usucodigo,EOfalta,Usucodigomod,fechamod, 	<!---Campos de Control --->
			NAP,EOestado, EOporcanticipo, CMFPid, CMIid,
			EOdiasEntrega, EOtipotransporte, EOlugarentrega, CRid,
			CMTOte,CMTOtransportista,CMTOtipotrans,CMTOincoterm,CMTOlugarent
		from ERemisionesFA e
			left outer join CMTipoOrden tor
				on tor.Ecodigo=e.Ecodigo
					and tor.CMTOcodigo=e.CMTOcodigo
		where e.Ecodigo = #Session.Ecodigo#
		  and e.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	
	<cfquery name="rsMontoDesc" datasource="#Session.DSN#">
		Select sum(coalesce(DOmontodesc,0)) as sumaDesc
		from DRemisionesFA
		where Ecodigo = #Session.Ecodigo#
		  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	
	<cfif isdefined('rsOrden') and rsOrden.recordCount GT 0 and rsOrden.Mcodigo NEQ ''>
		<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
			Select Mcodigo,Mnombre
			from Monedas
			where Ecodigo=#Session.Ecodigo#
				and Mcodigo=#rsOrden.Mcodigo#
		</cfquery>
	</cfif>
		
	<!---Totales--->
	<cfset rsTotales = QueryNew("subtotal,impuesto,descuento,total")>
	<cfset QueryAddRow(rsTotales,1)>
	<cfset QuerySetCell(rsTotales,"subtotal",rsOrden.EOtotal-rsOrden.Impuesto+rsOrden.EOdesc)>
	<cfset QuerySetCell(rsTotales,"impuesto",rsOrden.Impuesto)>
	<cfset QuerySetCell(rsTotales,"descuento",rsOrden.EOdesc)>
	<cfset QuerySetCell(rsTotales,"total",rsOrden.EOtotal)>
	
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
		where Ecodigo = #Session.Ecodigo#
		  	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrden.SNcodigo#">
	</cfquery>
</cfif>	
<!--- Tipos de Orden --->
<cfquery name="rsTipoOrden" datasource="#session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo=#Session.Ecodigo#
	<cfif modo neq 'ALTA'>
		and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsOrden.CMTOcodigo)#">
	</cfif>
</cfquery>
<!--- Retenciones --->
<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion 
	from Retenciones 
	where Ecodigo = #Session.Ecodigo#
		<cfif modo EQ 'CAMBIO' and rsOrden.Rcodigo NEQ '' and rsOrden.Rcodigo NEQ '-1'>
			and Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOrden.Rcodigo#">
		</cfif>
	order by Rdescripcion
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = #Session.Ecodigo#
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
		where a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#"> 		
			and a.Ecodigo = #Session.Ecodigo# 
	</cfquery>
</cfif>				

<!--- Incoterm --->
<cfif isdefined('rsOrden') and rsOrden.CMIid NEQ ''>
	<cfquery name="rsCMIncoterm" datasource="#session.dsn#">
		select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
		from CMIncoterm
		where CMIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.CMIid#">
	</cfquery>
</cfif>

<cfif isdefined('rsOrden') and rsOrden.CRid NEQ ''>
	<cfquery name="rsCourier" datasource="sifcontrol">
		select CRid, CRcodigo, CRdescripcion
		from Courier
		where  CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.CRid#">
	</cfquery>
</cfif>

<!---Permite modificar las ordenes de compra cuando vienen del registro de solicitudes--->
<cfquery name="rsModificaOC" datasource="#Session.DSN#">
    select Pvalor as value
    from Parametros
    where Ecodigo = #Session.Ecodigo#  
      and Pcodigo = 4310
</cfquery>


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
//-->
</script>

<cfoutput>

<form action="ordenCompra_cambioFP-sql.cfm" method="post" name="form1">
<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0">
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
			style="border: 0px none; background-color: ##FFFFFF;" maxlength="10" readonly="true" 
			value="#rsOrden.EOnumero#">
	</td>
    <td nowrap align="right"><strong>Tipo de Orden:&nbsp;</strong></td>
    <td nowrap>
			<!---Tipo de Orden--->
			#rsTipoOrden.CMTOcodigo# - #rsTipoOrden.CMTOdescripcion#
		</td>
    <td nowrap align="right"><strong>Provedor:&nbsp;</strong></td>
    <td nowrap>
			<!---Provedor--->
			#rsNombreSocio.SNnombre#
		</td>
  </tr>
	<!---Línea 2--->
  <tr>
    <td nowrap align="right"><strong>Fecha:&nbsp;</strong></td>
    <td nowrap>
			<!---Fecha--->
			#LSDateFormat(rsOrden.EOfecha,'dd/mm/yyyy')#
		</td>
    <td nowrap align="right"><strong>Moneda:&nbsp;</strong></td>
    <td nowrap>
		#rsMonedaSel.Mnombre#
	</td>
    <td nowrap align="right"><strong>Tipo de Cambio:&nbsp;</strong></td>
    <td nowrap>
		#LSNumberFormat(rsOrden.EOtc,',9.0000')#
	</td>
  </tr>
	<!---Línea 3--->
  <tr>
    <td nowrap align="right"><strong>Retenci&oacute;n:&nbsp;</strong></td>
    <td nowrap>
		<cfif Len(Trim(rsOrden.Rcodigo))>
			#rsRetenciones.Rdescripcion#
		<cfelse>
			- Sin Retenci&oacute;n -
		</cfif>
	</td>
    <td nowrap align="right"><strong>Descuento:&nbsp;</strong></td>
    <td nowrap>
		#LSCurrencyFormat(rsMontoDesc.sumaDesc,'none')#
	</td>
    <td nowrap align="right"><strong>% Anticipo:&nbsp;</strong></td>
    <td nowrap>
		#rsOrden.EOporcanticipo#
	</td>
  </tr>
	<!---Línea 4--->
  <tr>
    <td nowrap align="right"><strong>Formas de Pago:&nbsp;</strong></td>
    <td nowrap>
		<select name="CMFPid" onChange="javascript: getPlazo(this.form.EOplazo, this.value);">
			<cfloop query="rsCMFormasPago">
				<option value="#CMFPid#" 
					<cfif modo NEQ 'ALTA' and rsOrden.CMFPid NEQ ''>
						<cfif rsCMFormasPago.CMFPid EQ rsOrden.CMFPid> 
							selected
						</cfif>							
					<cfelse>
						<cfif isdefined("rsFormaPagoSocio") 
							and len(trim(rsFormaPagoSocio.CMFPID)) 
							and rsCMFormasPago.CMFPid eq rsFormaPagoSocio.CMFPid> 
							selected
						</cfif>					
					</cfif>
					>#CMFPdescripcion#
				</option>
			</cfloop>
		</select>					
	</td>
    <td nowrap align="right"><strong>Plazo de Cr&eacute;dito:&nbsp;</strong></td>
    <td nowrap>
	  <input 	type="text" name="EOplazo" style="text-align:right" tabindex="1"
				onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:this.select();" 
				onChange="javascript:fm(this,0);" 
				value="<cfif modo EQ 'CAMBIO' and rsOrden.EOplazo NEQ 0>#rsOrden.EOplazo#<cfelse>0</cfif>" size="5" maxlength="5" readonly>

  d&iacute;as. </td>
    <td nowrap align="right"><strong>Incoterm:&nbsp;</strong></td>
    <td nowrap>
		<cfif isdefined('rsCMIncoterm') and rsCMIncoterm.CMIid NEQ ''>
			#trim(rsCMIncoterm.CMIcodigo)# - #trim(rsCMIncoterm.CMIdescripcion)#
		<cfelse>
			- Ninguno -
		</cfif>		
	</td>
    </tr>
  <tr>
    <td nowrap align="right"><strong>Lugar de Entrega:&nbsp;</strong></td>
    <td nowrap>
		#rsOrden.EOlugarentrega#
	</td>
    <td nowrap align="right"><strong>Tipo de Transporte:&nbsp;</strong></td>
    <td nowrap>
		#rsOrden.EOtipotransporte#
	</td>
    <td nowrap align="right"><strong>Tiempo de Entrega:&nbsp;</strong></td>
    <td nowrap>
		#rsOrden.EOdiasEntrega#
	  d&iacute;as. </td>
  </tr>
  <tr>
    <td nowrap align="right"><strong>Transportista:&nbsp;</strong></td>
    <td nowrap>
		<cfif isdefined('rsCourier') and rsCourier.CRid NEQ ''>
			#trim(rsCourier.CRcodigo)# - #trim(rsCourier.CRdescripcion)#
		<cfelse>
			- Ninguno -
		</cfif>
    </td>
    <td nowrap align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
    <td colspan="3" nowrap>
		#rsOrden.Observaciones#
    </td>
    </tr>
  <tr>
  	<td nowrap colspan="6" align="center">&nbsp;</td>
  </tr> 	
  <tr>
  	<td nowrap colspan="6" align="center">
  		<input name="btnCambiar" type="button" onClick="javascript: cambiar();" id="btnCambiar" value="Modificar Orden">
	</td>
  </tr> 	
  <tr>
  	<td nowrap colspan="6" align="center">&nbsp;</td>
  </tr>      
  <tr>
	<td nowrap colspan="6" align="center">
		<cfinclude template="ordenCompraD_cambioFP.cfm">
	</td>
  </tr>  
  <tr>
  	<td nowrap colspan="6" align="center">&nbsp;</td>
  </tr>    
</table>


<!---Area de campos ocultos del encabezado--->
<input type="hidden" name="EOidorden" value="#form.EOidorden#">
<input type="hidden" name="ts_rversion" value="#ts#">

<!--- Las Ordenes Generadas por Solicitud de Compra Directa o cuyos items provienen de un contrato no se puede eliminar ni modificar --->
<cfif modo EQ "CAMBIO" and (rsOrden.EOestado EQ 5 or rsOrden.EOestado EQ 7 or rsOrden.EOestado EQ 8)>
	<cfif rsOrden.EOestado EQ 7 and rsModificaOC.value EQ 0>
		<p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra fue generada por solicitud de compra directa.</p>
	<cfelseif rsOrden.EOestado EQ 8 and rsModificaOC.value EQ 0>
		<p align="center" style="color: ##FF0000; font-weight: bold;">La orden de compra fue generada por solicitud de compra con itemes que pertenecen a un contrato.</p>
	</cfif>
</cfif>
</form>

<cfif (modo EQ "CAMBIO")>
	<cfinclude template="ordenCompraL_cambioFP.cfm">
</cfif>

</cfoutput>

<!---Javascript Final--->
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript 
	//define el color de los campos en caso de error
	qFormAPI.errorColor = "#FFFFCC";
	//inicializa qforms en la página

	objForm = new qForm("form1");
	
	<cfoutput>
		//Define nombres de los campos
		objForm.EOplazo.description = "#JSStringFormat('Plazo de Crédito')#";
	</cfoutput>
	
	//Habilita validaciones de campos segun las reglas
	function habilitarValidacion(){
		objForm.EOplazo.required = true;
	}
	//Deshabilita todas las validaciones de campos
	function deshabilitarValidacion(){
		objForm.EOplazo.required = false;
	}
	
	habilitarValidacion();

	<cfif modo EQ 'ALTA'>
		getPlazo(document.form1.EOplazo, document.form1.CMFPid.value);
	<cfelse>
		<cfoutput>#qformsFocusOnDetalle#</cfoutput>		
	</cfif>
	
	function cambiar(){
		if(confirm('Realmente desea cambiar la forma de pago y el plazo de crédito de la Orden de Compra ?')){
			document.form1.submit();
		}
	}
//-->
</script>