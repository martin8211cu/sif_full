<!--- Establecimiento del modoD --->
<cfif isdefined("form.FADsecuencia") and form.FADsecuencia NEQ ''>
	<cfset modoD="CAMBIO"> 
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<cfquery name="rsForm" datasource="#session.DSN#">
	select FACestado
	from FacturaEdu
		where FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
</cfquery>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		Select convert(varchar,FACcodigo) as FACcodigo
			, convert(varchar,FADsecuencia) as FADsecuencia
			, convert(varchar,TTcodigo) as TTcodigo
			, FADdescripcion
			, convert(varchar,FADcantidad) as FADcantidad
			, convert(varchar,FADunitario) as FADunitario
			, convert(varchar,FADmonto) as FADmonto
			, convert(varchar,FADdescuento) as FADdescuento
			, FADexento
		from FacturaEduDetalle
		where FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
			and FADsecuencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FADsecuencia#">
	</cfquery>	
</cfif>

<cfquery name="rsTipoTarifas" datasource="#session.DSN#">
	Select Ecodigo, convert(varchar,TTcodigo) as TTcodigo
		, TTnombre
	from TarifasTipo
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif modoD EQ 'ALTA'>
		and upper(TTnombre) like upper('%otros%')
	</cfif>
</cfquery>

<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>
<form action="facturas_SQL.cfm" method="post" name="formFacturasDet" style="margin: 0">
<cfoutput>
	<cfif modoD neq 'ALTA'>
		<input type="hidden" name="FADsecuencia"  value="<cfif isdefined('form.FADsecuencia') and form.FADsecuencia NEQ ''>#form.FADsecuencia#</cfif>">			
	</cfif>
	<input type="hidden" name="FACcodigo"  value="#form.FACcodigo#">
	<input type="hidden" name="codApersona" value="#form.codApersona#">
  <table width="100%" border="0" cellpadding="1" cellspacing="1">
    <tr> 
      <td class="tituloMantenimiento" colspan="2" align="center"> <font size="3"> 
        <cfif modoD eq "ALTA">
          Nuevo
        <cfelse>
          Modificar 
        </cfif>
			Detalle de Factura
        </font></td>
    </tr>
    <tr> 
      <td width="46%" align="right" valign="baseline" nowrap><strong>Tipo de Tarifa</strong>:</td>
      <td valign="baseline">
			<select name="TTcodigo" id="TTcodigo">
				<cfloop query="rsTipoTarifas">
					<option value="#rsTipoTarifas.TTcodigo#" <cfif modoD NEQ 'ALTA' and rsTipoTarifas.TTcodigo EQ rsFormD.TTcodigo> selected</cfif>>#rsTipoTarifas.TTnombre#</option>
				</cfloop>
			</select>
		</td>
    </tr>	
    <tr> 
      <td width="46%" align="right" valign="baseline"><strong>Descripci&oacute;n</strong>:</td>
      <td valign="baseline">
	  	<input name="FADdescripcion" type="text" id="FADdescripcion" onfocus="javascript:this.select();" value="<cfif modoD neq 'ALTA'>#rsFormD.FADdescripcion#</cfif>" size="40" maxlength="255">
	  </td>
      </tr>
    <tr> 
      	<td align="right"> <strong>Cantidad:</strong></td>
      	<td align="left">
			<input name="FADcantidad" type="text" id="FADcantidad" value="<cfif modoD neq 'ALTA'>#LSCurrencyFormat(rsFormD.FADcantidad,'none')#</cfif>" size="10" maxlength="10" 
				style="text-align: right;"
				onfocus="javascript:this.value=qf(this); this.select();" 
				onblur="javascript:fm(this,2);"
				onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
		</td>
    </tr>	
    <tr> 
      <td align="right" nowrap> <strong>Precio Unitario</strong>: </td>
      <td align="left"><input name="FADunitario" type="text" id="FADunitario" value="<cfif modoD neq 'ALTA'>#LSCurrencyFormat(rsFormD.FADunitario,'none')#</cfif>" size="10" maxlength="10" 
			style="text-align: right;"
			onfocus="javascript:this.value=qf(this); this.select();" 
			onblur="javascript:fm(this,2);"
			onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
    </tr>
  	<cfif modoD NEQ 'ALTA'>
		<tr> 
		  <td align="right"><strong>Monto</strong>:</td>
		  <td>
			#LSCurrencyFormat(rsFormD.FADmonto,'none')#		
		  </td>
		</tr>
	</cfif>	
    <tr> 
      <td align="right"><strong>Descuento</strong>:</td>
      <td>
		<input name="FADdescuento" type="text" id="FADdescuento" value="<cfif modoD neq 'ALTA'>#LSCurrencyFormat(rsFormD.FADdescuento,'none')#</cfif>" size="10" maxlength="10" 
			style="text-align: right;"
			onfocus="javascript:this.value=qf(this); this.select();" 
			onblur="javascript:fm(this,2);"
			onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
	  </td>
    </tr>
    <tr> 
      <td align="right"><strong>Exento</strong>:</td>
      <td>
	  	<input name="FADexento" type="checkbox" id="FADexento" value="1"
  			<cfif modoD neq 'ALTA' and rsFormD.FADexento EQ 1> checked</cfif>>
	  </td>
    </tr>
	
    <tr> 
      <td align="center">&nbsp;</td>
      <td align="center">&nbsp;</td>
    </tr>	
    <tr> 
      <td align="center" colspan="2"> 
	  	<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.FACestado NEQ 2>
			<cfif not isdefined('modoD')>
				<cfset modoD = "ALTA">
			</cfif>
			
			<cfset mensajeDelete = "¿Desea Eliminar este Detalle de Factura?">
			
			<input type="hidden" name="botonSelDet" value="">
			
			<cfif modoD EQ "ALTA">
				<input type="submit" name="AltaD" value="Agregar" onClick="javascript: this.form.botonSelDet.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet();">
				<input type="reset" name="LimpiarD" value="Limpiar" onClick="javascript: this.form.botonSelDet.value = this.name">
			<cfelse>	
				<input type="submit" name="CambioD" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSelDet.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet(); " value="Modificar">
				<input type="submit" name="BajaD" value="Eliminar" onclick="javascript: this.form.botonSelDet.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); return true; }else{ return false;}">
				<input type="submit" name="NuevoD" value="Nuevo" onClick="javascript: this.form.botonSelDet.value = this.name; if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); ">
			</cfif>
		
		</cfif>
	  </td>
    </tr>
  </table>
</cfoutput>  
</form>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionDet() {
		objFormDet.TTcodigo.required = false;
		objFormDet.FADdescripcion.required = false;
		objFormDet.FADcantidad.required = false;
		objFormDet.FADunitario.required = false;
		objFormDet.FADdescuento.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionDet() {
		objFormDet.TTcodigo.required = true;
		objFormDet.FADdescripcion.required = true;
		objFormDet.FADcantidad.required = true;
		objFormDet.FADunitario.required = true;
		objFormDet.FADdescuento.required = true;		
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormDet = new qForm("formFacturasDet");
//---------------------------------------------------------------------------------------
	objFormDet.TTcodigo.required = true;
	objFormDet.TTcodigo.description = "Tipo de Tarifa";
	objFormDet.FADdescripcion.required = true;
	objFormDet.FADdescripcion.description = "Descripción";	
	objFormDet.FADcantidad.required = true;
	objFormDet.FADcantidad.description = "Cantidad";	
	objFormDet.FADunitario.required = true;
	objFormDet.FADunitario.description = "Precio Unitario";
	objFormDet.FADdescuento.required = true;
	objFormDet.FADdescuento.description = "Descuento";	
</script>

