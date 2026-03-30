<cfparam name="rsAPagosCxPTotal.TotalAnticipos" default="0">
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.modoDet") and len(trim(form.modoDet)) eq 0>
	<cfset modoDet = "ALTA">
</cfif>

<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>

<cfif isDefined("Form.NuevoE")>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
<cfelseif isDefined("Form.datos") and Form.datos NEQ "">
	<cfset modo = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo, Mnombre 
	from Monedas 
	order by Mcodigo
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo 
	from Empresas
	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<cfset LB_Transf = t.Translate('LB_Transf','Transferencia')>
<cfset LB_Cheque = t.Translate('LB_Cheque','Cheque')>

<cf_dbfunction name="to_char" args="a.BTid"      returnvariable="BTid">
<cf_dbfunction name="op_Concat" returnvariable="_Cat">
<cfoutput>
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select  a.CPTcodigo
			#_Cat# '|' 
			#_Cat#  #preserveSingleQuotes(BTid)# 
			#_Cat#  '|' 
			#_Cat#  rtrim(b.BTdescripcion)
			#_Cat# '|'
			#_Cat# rtrim(a.CPTcktr)
			#_Cat# '|'
			#_Cat# 
			(case a.CPTcktr when 'C' then '#LB_Cheque#' when 'T' then '#LB_Transf#' else ' ' end) as Codigo, 
		   a.CPTcodigo, 
	       a.CPTdescripcion 
	from CPTransacciones a, BTransacciones b
	where a.Ecodigo =  #Session.Ecodigo#  
	and a.CPTtipo = 'D' 
	and coalesce(a.CPTpago,0) = 1
	and a.BTid = b.BTid
	order by a.CPTcodigo 
</cfquery>
</cfoutput>
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas where Ecodigo =  #Session.Ecodigo#  
	order by Ocodigo 
</cfquery>

<cfset IDpago = "">
<cfset IDLinea = "">

<cfif not isDefined("Form.NuevoE")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset IDpago = Trim(arreglo[1])>
 		<cfif sizeArreglo EQ 2>
			<cfset IDLinea = Trim(arreglo[2])>
			<cfset modoDet = "CAMBIO">
		</cfif>
	<cfelseif isdefined("Form.IDpago")>
		<cfset IDpago = Trim(Form.IDpago)>	
		<cfif isDefined("Form.IDLinea") and Len(Trim(Form.IDLinea)) NEQ 0>
			<cfset IDLinea = Trim(Form.IDLinea)>
		</cfif>
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoTotales" returnvariable="rsAPagosCxPTotal">
		<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
		<cfinvokeargument name="IDpago"       	value="#IDpago#">
	</cfinvoke>
	<cfquery name="rsPagos" datasource="#Session.DSN#">
		select a.CPTcodigo, a.EPdocumento, a.EPtipocambio, a.EPselect, a.EPtotal,a.EPtipopago, a.EPbeneficiario, a.Ocodigo, a.SNcodigo,a.ts_rversion,   
		      <cf_dbfunction name="to_char"     args="a.Mcodigo">    as Mcodigo, 
			  <cf_dbfunction name="to_char"     args="a.Ccuenta">    as Ccuenta,
			  <cf_dbfunction name="to_char"     args="a.IDpago">     as IDpago, 
			  <cf_dbfunction name="to_char"     args="a.CBid">       as CBid,
			  <cf_dbfunction name="to_char"     args="a.BTid">       as BTid, 
			  <cf_dbfunction name="to_sdateDMY"	args="a.EPfecha">    as EPfecha
		from EPagosCxP a
		  inner join CuentasBancos b
		     on a.CBid = b.CBid
		  inner join CContables c
		     on b.Ccuenta = c.Ccuenta
		    and b.Ecodigo = c.Ecodigo
		where a.IDpago    = #IDpago# 
          and b.CBesTCE   = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and a.Ecodigo   = #Session.Ecodigo#  
	</cfquery>
	
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsPagos.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNnumero, SNnombre 
		from SNegocios
		where Ecodigo  =  #Session.Ecodigo# 
		  and SNcodigo = #rsPagos.SNcodigo#
	</cfquery>
	<cfset socio = rsNombreSocio.SNnombre>

	<cfquery name="rsLineas" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char"      args="a.IDpago">  as IDpago, 
		       <cf_dbfunction name="to_char"      args="a.IDLinea"> as IDLinea, 
			   <cf_dbfunction name="to_sdateDMY"  args="d.Dfecha">  as Dfecha,
			   c.CPTcodigo, d.Ddocumento,e.Mnombre as Moneda, a.DPmontodoc, a.DPtotal
		from DPagosCxP a
		  inner join EPagosCxP b
		     on a.IDpago  = b.IDpago
			and a.Ecodigo = b.Ecodigo
			
		  inner join EDocumentosCP d
			on a.IDdocumento = d.IDdocumento	
			
		 inner join CPTransacciones c
		       on a.Ecodigo = c.Ecodigo
			  and d.CPTcodigo = c.CPTcodigo
		
		 inner join Monedas e 
		   on d.Mcodigo = e.Mcodigo
		   
		where a.IDpago = #IDpago# 
		and   a.Ecodigo =  #Session.Ecodigo#  
		order by d.Dfecha, d.Mcodigo, a.DPtotal desc, a.IDdocumento
	</cfquery>

	<cfquery name="rstotalcubierto" datasource="#Session.DSN#">
		select round(coalesce(sum(DPtotal),0.00),2) as tl
		from DPagosCxP 
		where Ecodigo =  #Session.Ecodigo# 
		and IDpago = #IDpago# 
        <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
		and IDLinea != <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#"> 
		</cfif>
	</cfquery>
	<cfset tl = rstotalcubierto.tl>

	<cfquery name="rstotaldetalle" datasource="#Session.DSN#">
		select coalesce(sum(DPtotal),0.00) as total
		from DPagosCxP 
		where Ecodigo =  #Session.Ecodigo# 
		and IDpago = #IDpago# 
	</cfquery>
	<cfset totaldetalle = rstotaldetalle.total>

</cfif>

<cf_dbfunction name="to_char"     args="a.CBid" 	returnvariable="CBid">   
<cf_dbfunction name="to_char"     args="b.Ccuenta" 	returnvariable="Ccuenta">   
<cf_dbfunction name="to_char"     args="c.Ocodigo"  returnvariable="Ocodigo">   
<cf_dbfunction name="to_char"     args="d.Mcodigo"  returnvariable="Mcodigo">      
<cfquery name="rsCuentasBancos" datasource="#Session.DSN#">
	select #preserveSingleQuotes(CBid)# 
		#_Cat# '|'
		#_Cat# #preserveSingleQuotes(Ccuenta)# 
		#_Cat# '|' 
		#_Cat# rtrim(b.Cformato)
		#_Cat# '|'
		#_Cat# rtrim(b.Cdescripcion) 
		#_Cat# '|'
		#_Cat# #preserveSingleQuotes(Ocodigo)# 
		#_Cat# '|' 
		#_Cat# rtrim(c.Odescripcion) 
		#_Cat# '|' 
		#_Cat# #preserveSingleQuotes(Mcodigo)# 
		#_Cat# '|'
		#_Cat# rtrim(d.Mnombre) as CuentaBanco,
		   <cf_dbfunction name="to_char"     args="a.CBid"> as CBid, a.CBcodigo
	from CuentasBancos a
	  inner join CContables b
	    on a.Ecodigo = b.Ecodigo
	   and a.Ccuenta = b.Ccuenta
	inner join Oficinas c
	   on a.Ecodigo = c.Ecodigo
	  and a.Ocodigo = c.Ocodigo
	inner join Monedas d 
	   on a.Mcodigo = d.Mcodigo
	  and a.Ecodigo = d.Ecodigo
	where a.Ecodigo =  #Session.Ecodigo# 
    and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> 
	<cfif modo NEQ "ALTA" and isdefined("rsPagos") and isdefined("rsLineas") and rsLineas.recordCount GT 0>
	  and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagos.Mcodigo#"> 
	</cfif>
</cfquery>

<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
	<cfquery name="rsDetalle" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="IDLinea">     as IDLinea, 
		       <cf_dbfunction name="to_char" args="IDdocumento"> as IDdocumento, 
			   <cf_dbfunction name="to_char"     args="Ccuenta"> as Ccuenta, 
		       'nada', 'nada', 'nada', DPtipocambio,DPtotal, DPmontodoc, DPmontoretdoc, ts_rversion 
		from DPagosCxP 
		where IDpago = #IDpago# 
		and Ecodigo =  #Session.Ecodigo# 
		and IDLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#"> 
	</cfquery>

	<cfset ts2 = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDetalle.ts_rversion#" returnvariable="ts2">
	</cfinvoke>

	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select <cf_dbfunction name="concat" args="rtrim(a.CPTcodigo),'-',rtrim(a.Ddocumento),'-',b.Mnombre"> as doc,
		       a.EDsaldo, a.Mcodigo, a.Rcodigo
		from EDocumentosCP a
		   inner join Monedas b
			  on a.Mcodigo = b.Mcodigo 
		where a.Ecodigo =  #Session.Ecodigo#  
		and a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.IDdocumento#"> 
	</cfquery>
	<cfset documento = rsDocumento.doc>
	<cfset saldo = rsDocumento.EDsaldo>
	<cfset monedaDoc = rsDocumento.Mcodigo>
	
	<cfquery name="rsCuenta" datasource="#Session.DSN#">
		select <cf_dbfunction name="sPart" args="Cdescripcion,1,40"> as Cdescripcion 
		from CContables 
		where Ecodigo =  #Session.Ecodigo# 
		and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.Ccuenta#"> 
	</cfquery>
	<cfset cuenta = rsCuenta.Cdescripcion>
	
</cfif>

<cf_templatecss>
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" src="PagosCxP.js"></script>
<script language="JavaScript" type="text/javascript">

 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisProveedores() {
		popUpWindow("ConlisProveedores.cfm?form=form1&id=SNcodigo&desc=SNnombre&sug=EPbeneficiario",250,200,650,350);
	}

	function doConlisDocsPago(SNcodigo) {
		popUpWindow("ConlisDocsPago.cfm?form=form1&desc=DTM&SNcodigo="+SNcodigo,250,200,650,400);
	}

	function Lista() {
		var params   = '?pageNum_rsLista='+document.form1.pageNum_rsLista.value;
			params += (document.form1.fecha.value != -1) ? "&fecha=" + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != -1) ? "&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.usuario.value != -1) ? "&usuario=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != -1) ? "&moneda=" + document.form1.moneda.value : '';
		location.href="ListaPagos.cfm" + params;
	}
	
	function NuevoPago() {
		var params   = '?pageNum_rsLista='+document.form1.pageNum_rsLista.value;
			params += (document.form1.fecha.value != -1) ? "&fecha=" + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != -1) ? "&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.usuario.value != -1) ? "&usuario=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != -1) ? "&moneda=" + document.form1.moneda.value : '';
		location.href="PagosCxP.cfm"+params;
	}

	function Editar(data) {
		if (data!="") {
			document.form1.action='PagosCxP.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}

	function initPage(f) {
		obtenerTransacciones(f);
		cambioCuenta(f);
		validatcLOAD(f);
		obtenerTC(f);
	}
	
</script>
<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
</style>

<cfset LB_EncPago 	= t.Translate('LB_EncPago','Encabezado de Pago')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Total 	= t.Translate('LB_Total','Total','Anticipo.xml')>
<cfset LB_Proveedor = t.Translate('LB_Proveedor','Proveedor','/sif/generales.xml')>
<cfset LB_TipoPago 	= t.Translate('LB_TipoPago','Tipo de Pago')>
<cfset LB_Anticipo 	= t.Translate('LB_Anticipo','Anticipo')>
<cfset LB_CtaBanc 	= t.Translate('LB_CtaBanc','Cuenta Bancaria')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset MSG_Detalle 	= t.Translate('MSG_Detalle','Detalle','/sif/generales.xml')>
<cfset LB_CtaCont 	= t.Translate('LB_CtaCont','Cuenta Contable')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Disponible 	= t.Translate('LB_Disponible','Disponible')>
<cfset LB_Beneficiario 	= t.Translate('LB_Beneficiario','Beneficiario')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_TpoCambio	= t.Translate('LB_TpoCambio','Tipo de Cambio')>

<cfset LB_DetPago 	= t.Translate('LB_DetPago','Detalle  de Pago')>
<cfset LB_MontDoct	= t.Translate('LB_MontDoct','Monto en Moneda del Documento')>
<cfset LB_Saldo 	= t.Translate('LB_Saldo','Saldo')>
<cfset LB_RetMonD 	= t.Translate('LB_RetMonD','Retenci&oacute;n en Moneda del Documento')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_MontMonD 	= t.Translate('LB_MontMonD','Monto en Moneda del Pago')>
<cfset LB_MonDocto	= t.Translate('LB_MontDoct','Moneda del Documento')>
<cfset LB_FecDocto	= t.Translate('LB_FecDocto','Fecha del Documento')>
<cfset LB_MontoDoc	= t.Translate('LB_MontoDoc','Monto del Documento')>
<cfset LB_MontoPag	= t.Translate('LB_MontoPag','Monto del Pago')>
<cfset MSG_LinDet 	= t.Translate('MSG_LinDet','El documento no tiene l&iacute;neas de detalle')>
<cfset LB_NoTiene	= t.Translate('LB_NoTiene','No tiene')>
<cfset LB_LstPago 	= t.Translate('LB_LstPago','Lista de Pagos')>
<cfset MSG_BorrarLin 	= t.Translate('MSG_BorrarLin','¿Realmente desea borrar esta línea de pago?')>
<cfset MSG_BorrarPgo 	= t.Translate('MSG_BorrarPgo','¿Realmente desea borrar este pago?')>
<cfset LB_LstDoc 	= t.Translate('LB_LstDoc','Lista de Documentos')>
<cfset LB_GenAnt 	= t.Translate('LB_GenAnt','Generar Anticipo')>
<cfset LB_ModEnc 	= t.Translate('LB_ModEnc','Modificar Encabezado')>

<cfset BTN_Agregar 	= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset BTN_Cambiar 	= t.Translate('BTN_Cambiar','Cambiar','/sif/generales.xml')>
<cfset BTN_BorrarLin 	= t.Translate('BTN_BorrarLin','Borrar Linea')>
<cfset BTN_BorrarPag 	= t.Translate('BTN_BorrarPag','Borrar Pago')>
<cfset BTN_Aplicar 	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset BTN_Nuevo 	= t.Translate('BTN_Nuevo','Nuevo','/sif/generales.xml')>
<cfset BTN_Ver 	= t.Translate('BTN_Ver','Ver')>

<iframe id="frameExec" width="0" height="0" frameborder="0">&nbsp;</iframe>
<cfflush interval="128">
<form method="post" name="form1" action="SQLPagosCxP.cfm" onSubmit="return validaForm(this);">
  <table width="100%" border="0">
    <tr> 
      <td>
        <input name="haydetalle" 	type="hidden" id="haydetalle" 	 value="<cfif isdefined("rsLineas") and rsLineas.recordCount GT 0><cfoutput>SI</cfoutput><cfelse><cfoutput>NO</cfoutput></cfif>">
	  	<input name="IDpago"    	type="hidden" id="IDpago" 		 value="<cfif modo NEQ "ALTA"><cfoutput>#IDpago#</cfoutput></cfif>">
        <input name="monedalocal" 	type="hidden" id="monedalocal" 	 value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>">
        <input name="EPselect" 		type="hidden" id="EPselect" 	 value="<cfif modo NEQ "ALTA"><cfoutput>#rsPagos.EPselect#</cfoutput></cfif>">
        <input name="timestampE"    type="hidden" id="timestampE" 	 value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
		<input name="Anticipo" 		type="hidden" id="Anticipo" 	 value="0">
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr> 
            <td colspan="6" valign="top" class="tituloAlterno"><cfoutput>#LB_EncPago#</cfoutput></td>
          </tr>
          <tr> 
            <td align="right" nowrap><cfoutput>#LB_Documento#:</cfoutput></td>
            <td nowrap> 
              <cfif modo NEQ "ALTA">
                <input type="hidden" id="EPdocumento" name="EPdocumento" value="<cfoutput>#Trim(rsPagos.EPdocumento)#</cfoutput>">
                <cfoutput>#Trim(rsPagos.EPdocumento)#</cfoutput> 
                <cfelse>
                <input name="EPdocumento" type="text" id="EPdocumento" size="20" maxlength="20" value="" tabindex="1">
              </cfif>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Transaccion#:</cfoutput></td>
            <td nowrap> 
              <input name="CPTcodigo" type="hidden" id="CPTcodigo">
              <select name="Transaccion" id="Transaccion" tabindex="1" onChange="javascript: obtenerTransacciones(this.form);" <cfif modo NEQ "ALTA">disabled</cfif>>
                <cfoutput query="rsTransacciones"> 
                  <option value="#Codigo#" <cfif modo NEQ "ALTA" and rsPagos.CPTcodigo EQ rsTransacciones.CPTcodigo>selected</cfif>>#CPTdescripcion#</option>
                </cfoutput> 
              </select>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Total#:</cfoutput></td>
            <td nowrap> 
			  <input name="EPtotal_anterior" type="hidden" id="EPtotal_anterior" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsPagos.EPtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>">
              <input name="EPtotal" type="text" id="EPtotal" style="text-align: right" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsPagos.EPtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
</td>
          </tr>
          <tr> 
            <td align="right" nowrap><cfoutput>#LB_Proveedor#:</cfoutput></td>
            <td nowrap> 
			<cfif modo neq 'ALTA'>
				<cf_sifsociosnegociosfa query="#rsNombreSocio#" tabindex="1">
			<cfelse>
				<cf_sifsociosnegociosfa tabindex="1">
			</cfif>		

            </td>
            <td align="right" nowrap><cfoutput>#LB_TipoPago#:</cfoutput></td>
            <td nowrap> 
              <input name="EPtipopago" type="hidden" id="EPtipopago" value="">
              <input name="BTid" type="hidden" id="BTid" value="">
              <input name="EPtipopagoLabel" type="text" id="EPtipopagoLabel" size="25" class="cajasinborde" tabindex="-1" readonly>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Anticipo#:</cfoutput></td>
            <td nowrap>
              <input name="AnticipoLabel" type="text" id="AnticipoLabel" style="text-align: right" value="<cfif modo NEQ "ALTA" and rsAPagosCxPTotal.TotalAnticipos NEQ 0><cfoutput>#LSCurrencyFormat(rsAPagosCxPTotal.TotalAnticipos,'none')#</cfoutput><cfelse><cfoutput>#LB_NoTiene#</cfoutput></cfif>" size="20" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
          <tr> 
            <td align="right" nowrap><cfoutput>#LB_CtaBanc#:</cfoutput></td>
            <td nowrap> 
              <input name="CBid" type="hidden" id="CBid">
              <select name="CuentaBanco" id="CuentaBanco" onChange="javascript: cambioCuenta(this.form); obtenerTC(this.form);" tabindex="1">
                <cfoutput query="rsCuentasBancos"> 
                  <option value="#CuentaBanco#" <cfif modo NEQ "ALTA" and rsPagos.CBid EQ rsCuentasBancos.CBid>selected</cfif>>#CBcodigo#</option>
                </cfoutput> 
              </select>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Oficina#:</cfoutput></td>
            <td nowrap> 
              <input name="Ocodigo" type="hidden" id="Ocodigo">
              <input name="OcodigoLabel" type="text" id="OcodigoLabel" tabindex="-1" size="30" maxlength="60" class="cajasinborde" readonly>
            </td>
            <td align="right" nowrap><cfoutput>#MSG_Detalle#:</cfoutput></td>
            <td nowrap>
              <input name="DetalleLabel" type="text" id="DetalleLabel" style="text-align: right" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(totaldetalle,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="20" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
          <tr> 
            <td align="right" nowrap><cfoutput>#LB_CtaCont#:</cfoutput></td>
            <td nowrap> 
              <input type="hidden" name="Ccuenta" id="Ccuenta" value="">
              <input name="Cformato" type="text" id="Cformato" value="" size="10" maxlength="10" tabindex="1" readonly>
              <input name="Cdescripcion" type="text" id="Cdescripcion" value="" size="35" maxlength="80" tabindex="-1" readonly>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Moneda#:</cfoutput></td>
            <td nowrap> 
                <input type="hidden" id="Mcodigo" name="Mcodigo">
              	<input name="McodigoLabel" type="text" id="McodigoLabel" tabindex="-1" size="30" class="cajasinborde" readonly>
            </td>
            <td align="right" nowrap><cfoutput>#LB_Disponible#:</cfoutput></td>
            <td nowrap>
              <input name="DisponibleLabel" type="text" id="DisponibleLabel" style="text-align: right" 
			  value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsAPagosCxPTotal.DisponibleAnticipos,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="20" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
          <tr> 
            <td align="right" nowrap><cfoutput>#LB_Beneficiario#:</cfoutput></td>
            <td nowrap> 
              <input name="EPbeneficiario" type="text" id="EPbeneficiario" size="40" maxlength="255" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPagos.EPbeneficiario#</cfoutput></cfif>">
            </td>
            <td align="right" nowrap><cfoutput>#LB_Fecha#:</cfoutput></td>
            <td nowrap> 
              <input name="EPfecha" type="text" id="EPfecha" tabindex="1" onBlur="javascript: onblurdatetime(this); obtenerTC(this.form);" value="<cfif modo NEQ "ALTA"><cfoutput>#rsPagos.EPfecha#</cfoutput><cfelse><cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput></cfif>" size="15" maxlength="10">
              <a href="javascript:showCalendar('document.form1.EPfecha')" tabindex="-1"><img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0"></a> 
            </td>
            <td align="right" nowrap><cfoutput>#LB_TpoCambio#:</cfoutput></td>
            <td nowrap> 
              <input name="EPtipocambio" type="text" id="EPtipocambio" style="text-align: right" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);"  onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" size="20" maxlength="20" value="<cfif modo NEQ "ALTA"><cfoutput>#LSNumberFormat(rsPagos.EPtipocambio,'9.0000')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" onChange="javascript:validatc(this.form); if (this.form.DPmontodoc != null) validaSaldo(this.form);" <cfif modo NEQ "ALTA" and rsLineas.recordCount GT 0>disabled</cfif>>
            </td>
          </tr>
          <tr> 
            <td colspan="6" align="center" nowrap> 
            	<cfoutput>
              <cfif modo EQ "ALTA">
                <br/>
                <font size="2"> 
                <input name="AgregarE" type="submit" value="#BTN_Agregar#"  class="btnGuardar" tabindex="1" onClick="javascript:setBtn(this);">
                <input type="button" name="Regresar" value="#LB_LstPago#" class="btnAnterior" tabindex="1" onClick="javascript:Lista();">
                </font> 
                <cfelse>
                <input name="CambiarE" type="submit" value="#LB_ModEnc#" class="btnGuardar" tabindex="1" onClick="javascript: setBtn(this); fnCambioE();">
              </cfif>
              	</cfoutput>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
	<tr>
		<td> 
          <input name="IDdocumento" type="hidden" id="IDdocumento"value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#rsDetalle.IDdocumento#</cfoutput></cfif>">
          <input name="IDLinea" 	type="hidden" id="IDLinea"    value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#rsDetalle.IDLinea#</cfoutput></cfif>">
          <input name="Mcodigod" 	type="hidden" id="Mcodigod"   value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#monedaDoc#</cfoutput></cfif>">
          <input name="Ccuentad" 	type="hidden" id="Ccuentad"   value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#rsDetalle.Ccuenta#</cfoutput></cfif>">
          <input name="montoret" 	type="hidden" id="montoret"   value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#rsDetalle.DPmontoretdoc#</cfoutput></cfif>">
          <input name="timestampd" 	type="hidden" id="timestampd" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#ts2#</cfoutput></cfif>">
          <input name="FC" 			type="hidden" id="FC" 		  value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsDetalle.DPtipocambio EQ 1><cfoutput>iguales</cfoutput><cfelseif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsDetalle.DPtipocambio EQ rsPagos.EPtipocambio><cfoutput>encabezado</cfoutput><cfelse><cfoutput>calculado</cfoutput></cfif>">
          <input name="ta" 			type="hidden" id="ta"         value="<cfif isdefined("rsAPagosCxPTotal")><cfoutput>#rsAPagosCxPTotal.TotalAnticipos#</cfoutput></cfif>">
          <input name="tl" 			type="hidden" id="tl"         value="<cfif isdefined("rstotalcubierto")><cfoutput>#tl#</cfoutput></cfif>">
          <input name="datos" 		type="hidden" id="datos">
          <table border="0" width="100%" cellpadding="2" cellspacing="0">
            <td colspan="4" class="tituloAlterno" nowrap><cfoutput>#LB_DetPago#</cfoutput></td>
            <tr> 
              <td width="20%" align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_Documento#:</cfoutput></td>
              <td width="30%" nowrap> 
				<input name="DTM" id="DTM" type="text" size="40" tabindex="-1" 
					style="text-align: right" 
					<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">value="<cfoutput>#documento#</cfoutput>" class="cajasinborde"</cfif> 
					readonly>
                <cfif modoDet EQ "ALTA">
                	<cfoutput>
                  	<a href="javascript:doConlisDocsPago('<cfoutput>#rsPagos.SNcodigo#</cfoutput>');" tabindex="-1">
				  		<img src="../../imagenes/Description.gif" alt="#LB_LstDoc#" name="imagen" width="18" height="14" 
							 border="0" align="absmiddle">
					</a> 
                  	</cfoutput>  
                </cfif>
              </td>
              <td width="25%" align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_MontDoct#:</cfoutput></td>
              <td width="25%" nowrap> 
                <input name="DPmontodoc" type="text" id="DPmontodoc" size="20" maxlength="18" tabindex="2" style="text-align: right"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); validaSaldo(this.form);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onChange="javascript:validaSaldo(this.form);" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDetalle.DPmontodoc,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and (rsDetalle.DPtipocambio EQ 1 or rsDetalle.DPtipocambio EQ rsPagos.EPtipocambio)>disabled<cfelseif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
              </td>
            <tr> 
              <td align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_Saldo#:</cfoutput> 
                <input name="Dsaldo" type="hidden" id="Dsaldo" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(saldo,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>">
              </td>
              <td nowrap> 
                <input class="cajasinborde" name="DsaldoLabel" type="text" id="DsaldoLabel" size="40" maxlength="18" tabindex="-1" style="text-align: right"  onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(saldo,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" readonly>
              </td>
              <td align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_RetMonD#: </cfoutput></td>
              <td nowrap> 
                <input name="DPmontoretdoc" type="text" id="DPmontoretdoc" size="20" maxlength="18" tabindex="2" style="text-align: right"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); validaSaldo(this.form);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							onChange="javascript:validaSaldo(this.form);" 
						<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
							<cfif rsDocumento.Rcodigo EQ "">
								value="0.00"
								disabled
							<cfelse>
								value="<cfoutput>#LSCurrencyFormat(rsDetalle.DPmontoretdoc,'none')#</cfoutput>" 
							</cfif>
						<cfelseif modo EQ "ALTA" or modoDet EQ "ALTA">
							value="0.00"
							disabled
						</cfif>
				>
              </td>
            <tr> 
              <td align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_Cuenta#:</cfoutput></td>
              <td nowrap> 
                <input class="cajasinborde" name="CcuentadLabel" type="text" id="CcuentadLabel" size="40" maxlength="40" tabindex="-1" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#Mid(Trim(cuenta),1,30)#</cfoutput><cfif Len(Trim(cuenta)) GT 30><cfoutput>...</cfoutput></cfif></cfif>" style="text-align: right" readonly>
              </td>
              <td align="right" style="padding-right: 10px" nowrap><cfoutput>#LB_MontMonD#:</cfoutput></td>
              <td nowrap> 
                <input name="DPtotal" type="text" id="DPtotal" size="20" maxlength="18" tabindex="2" 
					style="text-align: right"  onFocus="this.value=qf(this); this.select();" 
					onBlur="javascript: fm(this,2); validaSaldo(this.form);"  
					onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					onChange="javascript:validaSaldo(this.form);" 
					value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDetalle.DPtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" <cfif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
              </td>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
            <tr> 
              <td colspan="4" align="center" nowrap> <br/>
              <cfoutput>
                <cfif modoDet EQ "ALTA">
                  <input name="AgregarD" type="submit" value="#BTN_Agregar#" 			class="btnGuardar"    	tabindex="2"  onClick="javascript:setBtn(this);">
                  <cfelse>
                  <input name="CambiarD" type="submit" value="#BTN_Cambiar#" 			class="btnGuardar"    	tabindex="2"  onClick="javascript: setBtn(this);">
                  <input name="BorrarD"  type="submit" value="#BTN_BorrarLin#" 	class="btnEliminar"   	tabindex="2"  onClick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('#MSG_BorrarLin#)">
                </cfif>
                  <input name="BorrarE"  type="submit" value="#BTN_BorrarPag#"  	class="btnEliminar"    	tabindex="2" onClick="javascript: setBtn(this); deshabilitarValidacion(this.name); return confirm('#MSG_BorrarPgo#')">
                  <input name="Generar"  type="submit" value="#LB_GenAnt#" class="btnNormal" 		tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
                <cfif rsLineas.RecordCount GT 0 or (isdefined('form.Anticipo') and form.Anticipo EQ 1) or (modo NEQ "ALTA" and rsAPagosCxPTotal.TotalAnticipos NEQ 0 )>
                  <input name="Aplicar"  type="submit" value="#BTN_Aplicar#" 			class="btnAplicar" 		tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
                  <input name="Ver"  type="submit" value="#BTN_Ver#" 					class="btnAplicar" 		tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
                </cfif>
                  <input name="ListaE"   type="button" value="#LB_LstPago#"   class="btnAnterior" 	tabindex="2" onClick="javascript: Lista();">
                  <input name="Nuevo"    type="button" value="#BTN_Nuevo#" 			class="btnNuevo" 		tabindex="2" onClick="javascript: NuevoPago();">
              </td>
              </cfoutput>
          </table>
		</td>
	</tr>
	</cfif>
  </table>

	<!--- Navegacion para la lista de Pagos (principal) --->
	<cfoutput>
	<input type="hidden" name="pageNum_rsLista" value="<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))>#form.PageNum_rsLista#<cfelse>1</cfif>" />
	<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
	<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />	
	<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />	
	<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />	
	</cfoutput>
</form>
<cfif Len(Trim(IDpago)) NEQ 0>
	<cfif rsLineas.recordCount GT 0>

	<!--- registro seleccionado --->
	<cfif isDefined("IDlinea") and Len(Trim(IDlinea)) GT 0 ><cfset seleccionado = IDlinea ><cfelse><cfset seleccionado = "" ></cfif>
		
    <table border="0" width="100%">
         
    	<tr bgcolor="#E2E2E2" class="subTitulo">
        <cfoutput>
            <td width="3%" align="center" nowrap>&nbsp;</td> 
            <td width="10%" align="center" nowrap><strong>#LB_Transaccion#</strong></td>
            <td width="30%" nowrap><strong>#LB_Documento#</strong></td>
            <td align="center" width="15%" nowrap><strong>#LB_MonDocto# </strong></td>
            <td align="center" width="15%" nowrap><strong>#LB_FecDocto# </strong></td>
            <td align="right" width="15%" nowrap><strong>#LB_MontoDoc# </strong></td>
            <td align="right" width="15%" nowrap><strong>#LB_MontoPag# </strong></td>
        </cfoutput>    
		</tr>
      	 
     <cfoutput query="rsLineas"> 
        <tr style="cursor: pointer;"
			onMouseOver="style.backgroundColor='##E4E8F3';" 
			onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
			onClick="javascript:Editar('#IDpago#|#IDLinea#');" 
			class="<cfif rsLineas.CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" >
          <td align="center" nowrap><cfif modoDet NEQ 'ALTA' and rsLineas.IDlinea EQ seleccionado><img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="12" border="0"></cfif></td> 
          <td align="center" nowrap>#CPTcodigo#</td>
          <td nowrap>#Ddocumento#</td>
          <td align="center" nowrap>#Moneda#</td>
          <td align="center" nowrap>#Dfecha#</td>
          <td align="right" nowrap>#LSCurrencyFormat(DPmontodoc,'none')#</td>
          <td align="right" nowrap>#LSCurrencyFormat(DPtotal,'none')#</td>
        </tr>
      </cfoutput> 
      <cfif isdefined("totaldetalle")>
        <tr>
        <cfoutput> 
          <td class="topline" colspan="7" align="right"> 
            <b>#LB_Total#: </b> #LSCurrencyFormat(totaldetalle, 'none')#
          </td>
        </cfoutput>  
        </tr>
      </cfif>
    </table>
	<cfelse>
		<p align="center" class="listaCorte"><cfoutput>#MSG_LinDet#</cfoutput></p>
	</cfif>
</cfif>

<cfset MSG_ElCampo 	= t.Translate('MSG_ElCampo','El campo')>
<cfset MSG_NoCero 	= t.Translate('MSG_NoCero','no puede ser cero!')>
<cfset MSG_MontoDig	= t.Translate('MSG_MontoDig','El monto digitado supera el disponible')>
<cfset MSG_MontoRet	= t.Translate('MSG_MontoRet','El monto de retención no puede superar el monto del documento!')>
<cfset MSG_MontmasRet	= t.Translate('MSG_MontmasRet','El monto de la moneda del documento mas retenciones en moneda del documento supera el monto del saldo del documento')>
<cfset MSG_MontSup	= t.Translate('MSG_MontSup','El monto del documento + retenciones supera el saldo del documento, debe ser inferior o igual a')>
<cfset MSG_MontDigSup	= t.Translate('MSG_MontDigSup','El monto digitado supera el saldo del documento, debe ser inferior o igual a')>
<cfset MSG_MontLinDet	= t.Translate('MSG_MontLinDet','El monto de las líneas de detalle supera el monto total del documento de pago!')>
<cfset MSG_DocDetPgo 	= t.Translate('MSG_DocDetPgo','Documento del Detalle de Pago')>
<cfset MSG_RetMonPgo 	= t.Translate('MSG_RetMonPgo','Retención en Moneda del Pago')>

<script language="JavaScript" type="text/javascript">
	initPage(document.form1);

	function deshabilitarValidacion(boton){
		objForm.EPfecha.required = false;
		objForm.CuentaBanco.required = false;
		objForm.EPtotal.required = false;
		objForm.EPtotal.validate = false;
		<cfif modoDet EQ "ALTA" >
			objForm.DTM.required = false;
		</cfif>
		objForm.DPtotal.required = false;
		objForm.DPmontodoc.required = false;
		objForm.DPmontoretdoc.required = false;
	}
    <cfoutput> 
	function __isNotCero() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.disabled) && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			//this.obj.focus();
			this.error = "#MSG_ElCampo# " + this.description + " #MSG_NoCero#";
		}
	}
	function __isDisponible() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida Monto de Documento contra saldo del documento
			if ((new Number(qf(this.obj.form.DPmontodoc.value))) > (new Number(qf(this.obj.form.DisponibleLabel.value)))) {
				if (!this.obj.form.DPmontodoc.disabled) this.obj.form.DPmontodoc.focus();
				else this.obj.form.DPtotal.focus();
				this.error = "#MSG_MontoDig#";
			}
		}
	}
	
	// Se aplica sobre el monto del documento
	function __isRetenciones() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.form.DPmontoretdoc.disabled)) {
			// averiguar factor de conversion
			var fc = 1.0;
			var retencionori = new Number(qf(this.obj.form.DPmontoretdoc.value));
			if (this.obj.form.FC.value == "calculado") {
				fc = new Number(qf(this.obj.form.DPmontodoc.value)) / new Number(qf(this.obj.form.DPtotal.value));
			} else if (this.obj.form.FC.value == "encabezado") {
				fc = new Number(qf(this.obj.form.EPtipocambio.value));
			}
			var retenciones = new Number(qf(this.obj.form.DPmontoretdoc.value)) * fc; 
			if (retencionori > new Number(qf(this.obj.form.DPmontodoc.value))) {
				//this.obj.form.DPmontoretdoc.focus();
				this.error = "#MSG_MontoRet#";
			}
			if ((retencionori + new Number(qf(this.obj.form.DPmontodoc.value))) > (new Number(qf(this.obj.form.Dsaldo.value)))) {
				//this.obj.form.DPmontoretdoc.focus();
				this.error = "#MSG_MontmasRet#";
			}
			if (!this.obj.form.DPmontodoc.disabled) { /*alert((retenciones + new Number(qf(this.obj.form.DPmontodoc.value))));alert((new Number(qf(this.obj.form.Dsaldo.value))));*/
				// Valida Monto de Documento + retenciones contra el saldo del documento
				if ((retenciones + new Number(qf(this.obj.form.DPmontodoc.value))) > (new Number(qf(this.obj.form.Dsaldo.value)))) {
					//this.obj.form.DPmontoretdoc.focus();
					this.error = "#MSG_MontSup# " + this.obj.form.Dsaldo.value;
				}
			}
		}
	}

	// Se aplica sobre el monto del documento
	function __isMontoDoc() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida Monto de Documento contra saldo del documento
			if ((new Number(qf(this.obj.form.DPmontodoc.value))) > (new Number(qf(this.obj.form.Dsaldo.value)))) {
				if (!this.obj.form.DPmontodoc.disabled) this.obj.form.DPmontodoc.focus();
				else this.obj.form.DPtotal.focus();
				this.error = "#MSG_MontDigSup# " + this.obj.form.Dsaldo.value;
			}
		}
	}

	// Se aplica sobre el monto del documento
	function __isMontoPago() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida que el Pago sea menor al disponible en el documento de pago
			
			var dptotal 	 = new Number( qf(this.obj.form.DPtotal.value) )*100;
			var totaldetalle = new Number( this.obj.form.tl.value)*100;
			var anticipo     = new Number(this.obj.form.ta.value)*100;
			var total1  = (dptotal+totaldetalle+anticipo)/100;
			var totalDocumento = new Number( qf(this.obj.form.EPtotal.value))*100 ;
			if ( redondear(total1, 2) > redondear(totalDocumento/100,2) ) {			
				this.error = "#MSG_MontLinDet#";
			}
		}
	}
    </cfoutput> 
	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isRetenciones", __isRetenciones);
	_addValidator("isMontoDoc", __isMontoDoc);
	_addValidator("isDisponible", __isDisponible);
	_addValidator("isMontoPago", __isMontoPago);
	objForm = new qForm("form1");
	
    <cfoutput> 
	<cfif modo EQ "ALTA">
		objForm.EPdocumento.obj.focus();
		objForm.EPdocumento.required = true;
		objForm.EPdocumento.description = "#LB_Documento#";
		objForm.Transaccion.required = true;
		objForm.Transaccion.description = "#LB_Transaccion#";
		objForm.SNnombre.required = true;
		objForm.SNnombre.description = "#LB_Proveedor#";
		objForm.CuentaBanco.required = true;
		objForm.CuentaBanco.description = "#LB_CtaBanc#";
		objForm.EPtipocambio.required = true;
		objForm.EPtipocambio.description = "#LB_TpoCambio#";
		objForm.EPtipocambio.validateNotCero();
		objForm.EPtotal.required = true;
		objForm.EPtotal.description = "#LB_Total#";
		objForm.EPtotal.validateNotCero();
		objForm.EPfecha.required = true;
		objForm.EPfecha.description = "#LB_Fecha#";
	<cfelseif modo EQ "CAMBIO"> 
		objForm.Ccuenta.required = true;
		objForm.Ccuenta.description = "#LB_Cuenta#";
		objForm.CuentaBanco.required = true;
		objForm.CuentaBanco.description = "#LB_CtaBanc#";
		objForm.EPtotal.required = true;
		objForm.EPtotal.description = "#LB_Total#";
		objForm.EPtotal.validateNotCero();
		objForm.EPfecha.required = true;
		objForm.EPfecha.description = "#LB_Fecha#";
		<cfif modoDet EQ "ALTA">
			objForm.DTM.required = true;
			objForm.DTM.description = "#MSG_DocDetPgo#";
		</cfif>
		objForm.DPtotal.required = true;
		objForm.DPtotal.description = "#LB_MontMonD#";
		objForm.DPtotal.validateNotCero();
		objForm.DPtotal.validateMontoPago();
		objForm.DPmontodoc.required = (!objForm.DPmontodoc.obj.disabled);
		objForm.DPmontodoc.description = "#LB_MontDoct#";
		objForm.DPmontodoc.validateNotCero();
		objForm.DPmontodoc.validateMontoDoc();
		objForm.DPmontoretdoc.required = (!objForm.DPmontoretdoc.obj.disabled);
		objForm.DPmontoretdoc.description = "#MSG_RetMonPgo#";
		objForm.DPmontoretdoc.validateNotCero();
		objForm.DPmontoretdoc.validateRetenciones();
	</cfif>
    </cfoutput> 
	
	function fnCambioE(){objForm.DTM.required = false;document.form1.EPtipocambio.disabled = false;}
</script>
