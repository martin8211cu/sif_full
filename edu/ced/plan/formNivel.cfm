<cfset modo="ALTA">
<cfif isdefined("Form.Ncodigo") and len(trim("Form.Ncodigo")) NEQ 0 and Form.Ncodigo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<cfif isdefined("Form.Ncodigo") and len(trim("Form.Ncodigo")) NEQ 0>
		<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
			select convert(varchar,Ncodigo) as Ncodigo, Ndescripcion, Nnotaminima, Norden from Nivel 
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
			  and Ncodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ncodigo#">
			
		</cfquery>
	</cfif>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayGrado">
		select 1 from Grado 
		where Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayPeriodoEvaluacion">
		select 1 from PeriodoEvaluacion
		where Ncodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayPeriodoEscolar">
		select 1 from PeriodoEscolar
		where Ncodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayDirector">
		select 1 from Director 
		where Ncodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
	</cfquery>
</cfif>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlis1() 
	{
		popUpWindow("../consultas/ConlisAyudaNivel.cfm?form=form1",250,200,600,450);
	}
	function Grado() {
		document.form1.action='Grado.cfm';
		document.form1.submit();
	}
	function PeriodoEvaluacion() {
		document.form1.action='PeriodoEvaluacion.cfm';
		document.form1.submit();
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
<form action="SQLNiveles.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);">
	<input type="hidden" name="Ncodigo" id="Ncodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.Ncodigo#</cfoutput></cfif>">
	<input type="hidden" name="Pagina" value="<cfoutput>#form.Pagina#</cfoutput>">
	<input type="hidden" name="MaxRows" value="<cfoutput>#form.MaxRows#</cfoutput>">
	<input type="hidden" name="Filtro_Ndescripcion" value="<cfoutput>#form.Filtro_Ndescripcion#</cfoutput>">
	<input type="hidden" name="Filtro_Nnotaminima" value="<cfoutput>#form.Filtro_Nnotaminima#</cfoutput>">
	<input type="hidden" name="Filtro_Norden" value="<cfoutput>#form.Filtro_Norden#</cfoutput>">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td class="tituloAlterno" colspan="2" align="center">
        <cfif modo eq "ALTA">
          Nuevo Nivel 
          <cfelse>
          Modificar Nivel 
        </cfif></td>
    </tr>
    <tr valign="baseline"> 
      <td width="291" align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td width="361"><input name="Ndescripcion" onfocus="javascript:this.select();"  type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsNiveles.Ndescripcion#</cfoutput></cfif>" size="50" maxlength="255" alt="La descripci&oacute;n del Nivel">      </td>
    <tr valign="baseline"> 
      <td align="right" nowrap>Porcentaje M&iacute;nimo de Aprovechamiento:&nbsp;</td>
      <td><input name="Nnotaminima" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsNiveles.Nnotaminima#</cfoutput></cfif>" size="8" maxlength="3" style="text-align: right;" alt="La nota mnima del Nivel"  onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
    </tr>
    <tr valign="baseline"> 
      <td align="right" nowrap>Orden:&nbsp;</td>
      <td><input name="Norden" align="left" type="text" id="Norden" size="8" maxlength="8" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#rsNiveles.Norden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >      </td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="center" nowrap><cf_botones modo="#modo#">
		<cfif modo NEQ "ALTA">
			<input type="hidden" name="HayGrado" value="<cfoutput>#rsHayGrado.recordCount#</cfoutput>">
			<input type="hidden" name="HayPeriodoEvaluacion" value="<cfoutput>#rsHayPeriodoEvaluacion.recordCount#</cfoutput>">
			<input type="hidden" name="HayPeriodoEscolar" value="<cfoutput>#rsHayPeriodoEscolar.recordCount#</cfoutput>">
			<input type="hidden" name="HayDirector" value="<cfoutput>#rsHayDirector.recordCount#</cfoutput>">
		</cfif>      </td>
    </tr>
  </table>
</form>
<cf_qforms>
<script language="JavaScript">
	_addValidator("isTieneDependencias", __isTieneDependencias);
	function habilitarValidacion() {
		objForm.Ndescripcion.required = true;
		objForm.Nnotaminima.required = true;
	}
	function deshabilitarValidacion() {
		objForm.Ndescripcion.required = false;
		objForm.Nnotaminima.required = false;
	}
	// Se aplica la descripcion del Nivel 
	function __isTieneDependencias() {
			if (btnSelected("Baja", this.obj.form)) {
				// Valida que el Nivel no tenga dependencias con otros.
				var msg = "";

				if (new Number(this.obj.form.HayGrado.value) > 0) {
					msg = msg + "grados"
				}
				if (new Number(this.obj.form.HayPeriodoEvaluacion.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "periodos de evaluacin"
				}
				if (new Number(this.obj.form.HayPeriodoEscolar.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "periodos escolares"
				}
				if (new Number(this.obj.form.HayDirector.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "directores"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Nivel " + this.obj.form.Ndescripcion.value + " porque ste tiene asociado: " + msg + ".";
					this.obj.form.Ndescripcion.focus();
				}
		}
	}
	function validaForm(f) {
		if (f.Ndescripcion.obj.disabled) {
			f.Ndescripcion.obj.disabled = false;
		}
		return true;
	}
	<cfif modo EQ "ALTA">
		objForm.Ndescripcion.required = true;
		objForm.Ndescripcion.description = "Nivel";
		objForm.Norden.description = "Orden";
		objForm.Nnotaminima.required = true;
		objForm.Nnotaminima.description = "Nota Mnima";
	<cfelseif modo EQ "CAMBIO">
		objForm.Ndescripcion.required = true;
		objForm.Ndescripcion.description = "Grado";
		objForm.Nnotaminima.required = true;
		objForm.Nnotaminima.description = "Nota Mnima";
		objForm.Ndescripcion.validateTieneDependencias();
		// Agregar validacion de dependencias
	</cfif>
</script>