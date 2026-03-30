<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif #Form.modo# EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfif modo NEQ "ALTA">
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsIncidenciasTipo">
		select convert(varchar,ITid) as ITid, ITcodigo,  ITdescripcion, ITmonto 
		from IncidenciasTipo 
		<cfif isdefined("Form.ITid") and len(trim("Form.ITid")) NEQ 0>
			where ITid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ITid#">
		</cfif>	
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayDFactura">
		select 1 from DFactura 
		where ITid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ITid#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayIncidencias">
		select 1 from Incidencias 
		where ITid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ITid#">
	</cfquery>

</cfif>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function validaForm(f) {
		f.obj.ITmonto.value = qf(f.obj.ITmonto.value);
		return true;
	}

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

function qf(Obj){
	var VALOR=""
	var HILERA=""
	var CARACTER=""
	if(Obj.name)
	  VALOR=Obj.value
	else
	  VALOR=Obj
	
	for (var i=0; i<VALOR.length; i++) {	
	
		CARACTER =VALOR.substring(i,i+1);
		if (CARACTER=="," || CARACTER==" ") {
			CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
		}  
		HILERA+=CARACTER;
	}
	return HILERA
}
</script>

 
<form action="../facturacion/SQLIncidencias.cfm" method="post" name="form1" onSubmit="javascript: return validaForm(this);">
	<input type="hidden" name="ITid" id="ITid" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.ITid#</cfoutput></cfif>">
	<!---
   <table width="63%" height="11%" align="center">
    <tr>
    <td>&nbsp;</td>
      <td align="right"><a href="#"> <img src="../../Imagenes/Help01_T.gif" alt="Ayuda de Niveles" name="imagen" width="18" height="18" border="0" align="absmiddle" onClick="javascript:doConlis1();"> 
        </a> 
	</td>
  </tr>
  </table>
  --->


  <table width="100%" align="center">
    <tr> 
      <td class="tituloMantenimiento" colspan="2" align="center"><font size="3"> 
        <cfif modo eq "ALTA">
          Nuevo 
          <cfelse>
          Modificar 
        </cfif>
         Tipo de Incidencia</font></td>
    </tr>
    <tr valign="baseline"> 
      <td align="right" valign="middle" nowrap>C&oacute;digo</td>
      <td><input name="ITcodigo" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidenciasTipo.ITcodigo#</cfoutput></cfif>" size="8" maxlength="5" style="text-align: right;" alt="El código del Concepto"  onFocus="javascript: this.select();" ></td>
    <tr valign="baseline"> 
      <td width="291" align="right" valign="middle" nowrap>Descripción</td>
      <td width="361"><input name="ITdescripcion" onfocus="javascript:this.select();"  type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidenciasTipo.ITdescripcion#</cfoutput></cfif>" size="50" maxlength="100" alt="La descripci&oacute;n del Concepto"> 
      </td>
    <tr valign="baseline"> 
      <td nowrap align="right">Monto</td>
      <td><input name="ITmonto" align="left" type="text" id="ITmonto" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsIncidenciasTipo.ITmonto,'none')#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,2);"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" > 
      </td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="center" nowrap><cfinclude template="../../portlets/pBotones.cfm"> 
        <!---   <cfif isdefined("form.modulo") and form.modulo neq "" >
          <cfif (#form.modulo# EQ 1) >
            <input name="Regresar" type="button" value="Grados" onClick="javascript:Grado();">
            <cfelseif #form.modulo# EQ 2>
            <input name="Regresar" type="button" value="Per&iacute;odo de Evaluaci&oacute;n" onClick="javascript:PeriodoEvaluacion();">
          </cfif>
        </cfif> 
		<cfif modo NEQ "ALTA"><input type="hidden" name="ITcodigo" value="<cfoutput>#rsIncidenciasTipo.ITcodigo#</cfoutput>"></cfif>
      <cfif isdefined("form.modulo")>
        <input type="hidden" name="modulo" value="<cfoutput>#form.modulo#</cfoutput>">
      </cfif> --->
        <cfif modo NEQ "ALTA">
          <input type="hidden" name="HayIncidencias" value="<cfoutput>#rsHayIncidencias.recordCount#</cfoutput>">
		  <input type="hidden" name="HayDFactura" value="<cfoutput>#rsHayDFactura.recordCount#</cfoutput>">
        </cfif> </td>
      <!--- <input type="hidden" name="ITmonto" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidenciasTipo.ITmonto#</cfoutput></cfif>"> --->
    </tr>
  </table>

 
</form>


<script language="JavaScript">
	function habilitarValidacion() {
		objForm.ITdescripcion.required = true;
		objForm.ITcodigo.required = true;
	}

	function deshabilitarValidacion() {
		objForm.ITdescripcion.required = false;
		objForm.ITcodigo.required = false;
	}

	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
			if (btnSelected("Baja", this.obj.form)) {
				// Valida que el Concepto no tenga dependencias con otros.
				var msg = "";

				if (new Number(this.obj.form.HayIncidencias.value) > 0) {
					msg = msg + "Incidencias"
				}
				if (new Number(this.obj.form.HayDFactura.value) > 0) {
					msg = msg + "Facturas"
				}				
			
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el tipo de incidencia " + this.obj.form.ITdescripcion.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.ITdescripcion.focus();
				}
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.ITdescripcion.required = true;
		objForm.ITdescripcion.description = "Descripción";
		objForm.ITmonto.required = true;
		objForm.ITmonto.description = "Monto";
		objForm.ITcodigo.required = true;
		objForm.ITcodigo.description = "Código";
	<cfelseif modo EQ "CAMBIO">
		objForm.ITdescripcion.required = true;
		objForm.ITdescripcion.description = "Descripción";
		objForm.ITmonto.required = true;
		objForm.ITmonto.description = "Monto";
		objForm.ITcodigo.required = true;
		objForm.ITcodigo.description = "Código";
		objForm.ITdescripcion.validateTieneDependencias();
		// Agregar validacion de dependencias
	</cfif>
	
</script>