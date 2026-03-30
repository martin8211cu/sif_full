<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA"> 
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("Url.FACcodigo") and not isdefined("form.FACcodigo")>
	<cfset Form.FACcodigo = Url.FACcodigo>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,FACcodigo) as FACcodigo
			, convert(varchar,FACfecha,103) as FACfecha
			, FACnombre
			, convert(varchar,FACmonto) as FACmonto
			, FACestado
			, FACtipo
			, FACobservaciones
			, FACimpuesto
			, FACdescuento
		from FacturaEdu
			where FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsHayFacDet">
		Select *
		from FacturaEduDetalle
		where FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
	</cfquery>	
</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>
<form action="facturas_SQL.cfm" method="post" name="formFacturas" style="margin: 0">
<cfoutput>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="FACcodigo"  value="<cfif isdefined('rsForm') and rsForm.recordCount GT 0>#rsForm.FACcodigo#</cfif>">			
		<input type="hidden" name="rsHayFacDet"  value="<cfif isdefined('rsHayFacDet') and rsHayFacDet.recordCount GT 0>#rsHayFacDet.recordCount#<cfelse>0</cfif>">			
	</cfif>
	<input type="hidden" name="codApersona" value="#form.codApersona#">
  <table width="100%" border="0" cellpadding="1" cellspacing="1">
    <tr> 
      <td class="tituloMantenimiento" colspan="3" align="center"> <font size="3"> 
        <cfif modo eq "ALTA">
          Nueva 
          <cfelse>
          Modificar 
        </cfif>
			Factura
        </font></td>
    </tr>
    <tr> 
      <td width="46%" align="right" valign="baseline"><strong>Nombre</strong>:</td>
      <td width="50%" valign="baseline"><input name="FACnombre" type="text" id="FACnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.FACnombre#<cfelse>#rsAlumno.Anombre#</cfif>" size="60" maxlength="255"></td>
      <td width="4%" align="right" valign="middle">
	  	<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
	  </td>
    </tr>
    <tr> 
      <td width="46%" align="right" valign="baseline"><strong>Tipo</strong>:</td>
      <td colspan="2" valign="baseline">
		  <select name="FACtipo" id="FACtipo">
		    <option value="1" <cfif modo NEQ 'ALTA' and rsForm.FACtipo EQ 1> selected</cfif>>Contado</option>
		    <option value="2" <cfif modo NEQ 'ALTA' and rsForm.FACtipo EQ 2> selected</cfif>>Cr&eacute;dito</option>
		  </select>
	  </td>
      </tr>	
    <tr> 
      <td align="right"> <strong>Fecha</strong>: </td>
      <td colspan="2" align="left">
		<cfif modo eq "ALTA">
			<cfset varFACfecha = LSdateformat(Now(),"dd/mm/yyyy")>
		<cfelse>	  
			<cfset varFACfecha = rsForm.FACfecha>
		</cfif>	  
		
	  <cf_sifcalendario name="FACfecha" value="#varFACfecha#" form="formFacturas">	  </td>
    </tr>	
    <tr> 
      <td align="right"> <strong>Estado</strong>: </td>
      <td colspan="2" align="left"><select name="FACestado" id="FACestado" <cfif modo NEQ 'ALTA' and rsForm.FACestado EQ 2> disabled</cfif>>
        <option value="1" <cfif modo NEQ 'ALTA' and rsForm.FACestado EQ 1> selected</cfif>>Por Cobrar</option>
        <option value="2" <cfif modo NEQ 'ALTA' and rsForm.FACestado EQ 2> selected</cfif>>Pagado</option>
        <option value="3" <cfif modo NEQ 'ALTA' and rsForm.FACestado EQ 3> selected</cfif>>Anulado</option>
      </select> 
      </td>
    </tr>
	<cfif modo NEQ 'ALTA'>
		<tr> 
		  <td align="right"><strong>Monto</strong>:</td>
		  <td colspan="2">
			<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FACmonto,'none')#<cfelse>0,00</cfif>
		  </td>
		</tr>
		<tr> 
		  <td align="right"><strong>Descuento</strong>:</td>
		  <td colspan="2">
			<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FACdescuento,'none')#<cfelse>0,00</cfif>
		  </td>
		</tr>		
		<tr> 
		  <td align="right"><strong>Impuesto</strong>:</td>
		  <td colspan="2">
			<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FACimpuesto,'none')#<cfelse>0,00</cfif>
		  </td>
		</tr>
		<tr> 
		  <td align="right"><strong>Monto Total</strong>:</td>
		  <td colspan="2">
			<cfif modo neq 'ALTA'>
				<cfset MontoTot = (rsForm.FACmonto + rsForm.FACimpuesto) - rsForm.FACdescuento>			
				
				#LSCurrencyFormat(MontoTot,'none')#
			<cfelse>
				0,00
			</cfif>
		  </td>
		</tr>				
	</cfif>
	<tr> 
	  <td width="46%" align="right" valign="top"><strong>Observaciones</strong>:</td>
	  <td colspan="2" valign="baseline"><textarea name="FACobservaciones" cols="20" rows="3" id="FACobservaciones"><cfif modo neq 'ALTA'>#rsForm.FACobservaciones#</cfif></textarea></td>
	  </tr>	
	<tr> 
    <tr> 
      <td align="center">&nbsp;</td>
      <td colspan="2" align="center">&nbsp;</td>
    </tr>	
    <tr> 
      <td align="center" colspan="3"> <cfset mensajeDelete = "¿Desea Eliminar esta Factura?"> 
        <cfinclude template="../../portlets/pBotones.cfm">
		<input type="button" name="btnLista"  tabindex="1" value="Lista de Facturas" onClick="javascript: irALista();">
	  </td>
    </tr>
  </table>
</cfoutput>  
</form>	  

<cfif modo NEQ 'ALTA'>
	<cfinclude template="Factura_tabs.cfm">
</cfif>

<script language="JavaScript">
	function irALista() {
		location.href = "facturas.cfm?codApersona=" + document.formFacturas.codApersona.value;
	}	
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.FACnombre.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.FACnombre.required = true;
	}
//---------------------------------------------------------------------------------------	
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que el tipo de Tarifa no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.rsHayFacDet.value) > 0) {
				msg = msg + " Detalles ";
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar el la Factura '" + this.obj.form.FACnombre.value + "' porque ésta tiene asociado: " + msg + ".";
				this.obj.form.FACnombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------	
	function __isValidaTipo() {
		objForm.FACestado.obj.disabled = false;
	}		
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);	
	objForm = new qForm("formFacturas");
//---------------------------------------------------------------------------------------
	objForm.FACnombre.required = true;
	objForm.FACnombre.description = "Nombre";
	
	<cfif modo NEQ "ALTA">
		objForm.FACnombre.validateTieneDependencias();
	</cfif>
	
	objForm.onValidate = __isValidaTipo;
</script>
