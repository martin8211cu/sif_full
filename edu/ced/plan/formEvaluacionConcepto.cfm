<!-- Establecimiento del modo -->
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
<cfif isdefined("url.ECcodigo") and len(trim("url.ECcodigo")) NEQ 0 and url.ECcodigo gt 0>
    <cfset form.ECcodigo = url.ECcodigo>
	<cfset modo="CAMBIO">
</cfif>
<!--- ==================== --->
<!---       Consultas      --->
<!--- ==================== --->
<!--- 1. Form --->
<cfquery name="rsForm" datasource="#Session.Edu.DSN#">
	select ECcodigo, ECnombre, ECorden
	from EvaluacionConcepto
	<cfif isdefined("form.ECcodigo") and form.ECcodigo neq "">
		where ECcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECcodigo#">
	</cfif>	  
</cfquery>

<cfif modo NEQ "ALTA" and isdefined("Form.ECcodigo") and len(trim("Form.ECcodigo")) GT 0>
	<!--- 3. Validaciones de dependencias--->
	<!---  Rodolfo JImenez Jara, SOIN, 03/12/2002 --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionConceptoMateria">
		select 1 from EvaluacionConceptoMateria
		where ECcodigo  = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionPlanConcepto">
		select 1 from EvaluacionPlanConcepto
		where ECcodigo  = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionConceptoCurso">
		select 1 from EvaluacionConceptoCurso
		where ECcodigo  = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>


<script language="JavaScript" type="text/JavaScript">
	
	botonActual = "";
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	function validaForm(f) {
		if (f.ECnombre.obj.disabled) {
			f.ECnombre.obj.disabled = false;
		}
		return true;
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


<form action="SQLEvaluacionConcepto.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);">
  <!--- <table width="85%" height="56%" align="center">
	<tr>
	<a href="EvaluacionConcepto.cfm?Ayuda=<cfif Session.Ayuda EQ 0>1<cfelse>0</cfif>" ><img src="../../Imagenes/Help01_T.gif" alt="Ayuda del Portal"  border="0" align="baseline"> </a>
	<cfif Session.Ayuda EQ 0> 
	 		  La clasificacin de los perodos de evaluacin dependern de las polticas de cada institucin, estas 
			  pueden ser: bimestrales, trimestrales y semestrales o la combinacin de varios rubros.<br>
		<cfif modo eq "ALTA">
			<td width="100%" height="50%" valign="top">
			  <p><strong><font size="2">Agregar</font></strong>:<font size="1">Al 
			  realizar un click sobre la opci&oacute;n de Agregar, grabar los datos 
			  del ingresados por usted; tales como: &nbsp;&nbsp;<strong>&nbsp;Descripci&oacute;n 
			  del Periodo de Evaluacin </strong> (Nombre del Periodo), <strong>Nivel:&nbsp;</strong>(definidos 
			  por usted seg&uacute;n las politicas del Centro Educativo) &nbsp; y el <strong>Orden</strong> 
			  (Posici&oacute;n en que se mostrar&aacute; en el portal,en  m&uacute;ltiplos 
			  de 10), si deja este campo vaco, el sistema le asignar un valor automaticamente 
			  (el ltimo orden definido por el usuario mas 10) . </font><font size="2">&nbsp;</font> </p>
			  <p><font size="2"><strong>Limpiar:</strong> <font size="1">Al &nbsp; 
				realizar un click sobre la opci&oacute;n de <strong>Limpiar</strong> 
				desaparecern de la pantalla, todos aquellos datos digitados por usted en ese nuevo registro ,
				sin alterar la informacin del Portal.</font> </font></p>
				<p>
				<cfif rsNivel.RecordCount eq 0>
					<font size="2"><strong>Agregar Nuevo Nivel:</strong><font size="1"> Esta opcin aparece solo cuando no hay niveles 
					definidos para ese Centro Educativo, por lo que al realizar un click sobre esta opcin, sta lo llevar al 
					Mantenimiento de Niveles para que defina por lo menos un nivel, y hac pueda continuar el mantenimiento del Portal.
					As mismo en la pantalla de Mantenimiento de Niveles, aparecer un botn que lo regresar al mantenimiento de Periodos 
					de Evaluacin cuando pulse click sobre l.
					</font> </font>
				</cfif>
				</p>
				</td>
		<cfelse>
			<td width="100%" height="50%" valign="top"> 
			  <p><strong><font size="2">Nuevo</font></strong>:<font size="1">Al
			  realizar un click sobre la opci&oacute;n de Nuevo, usted podr&aacute; 
			  ingresar los datos del del Periodo de Evaluacin como:&nbsp;&nbsp;<strong>&nbsp;Descripci&oacute;n 
			  del Periodo</strong> (Nombre del Periodo), <strong>Nivel:&nbsp;</strong>(definidos 
			  por usted seg&uacute;n las politicas del Centro Educativo) &nbsp; y el <strong>Orden</strong> (Posici&oacute;n 
			  en que se mostrar&aacute; en el portal, m&uacute;ltiplos de 10) . </font><font size="2">&nbsp;</font> </p>
			  <p><font size="2"><strong>Modificar:</strong> <font size="1">Al realizar 
				  un click sobre la opci&oacute;n de <strong>Modificar</strong> usted 
				  podr&aacute; modificar los siguientes datos : <strong>Descripci&oacute;n</strong> 
				  (Nombre del Periodo),<strong> Nivel</strong>  (Si esta opcin esta deshabilitada, no podr realizar modificaciones al Periodo de Evaluacin, ya que hay grupos dependientes de este Periodo, si no esta deshabilitada, el Portal le permite cambiar el nivel de este Periodo.) y <strong>el 
				  Orden</strong> (Posici&oacute;n en que se mostrar&aacute; en el portal, 
				  m&uacute;ltiplos de 10), si deja este campo vaco, el sistema le asignar un valor automaticamente (el ltimo orden definido por el usuario mas 10).</font> </font></p>
				<p><font size="2"><strong>Eliminar</strong></font><font size="1">; Escoja 
				  el Periodo que desee eliminar y realice un click sobre la opci&oacute;n 
				  Borrar, el portal refrescar&aacute; la vista sin mostrar el &iacute;tem 
				  que se indic&oacute; anteriormente.</font></p></td>
				
		</cfif>
	</cfif> 
			  
    </tr>
  </table>		 --->
  <table width="100%" border="0" cellpadding="1" cellspacing="1">
		<input type="hidden" name="Pagina" value="<cfoutput>#form.Pagina#</cfoutput>">
		<input type="hidden" name="MaxRows" value="<cfoutput>#form.MaxRows#</cfoutput>">
		<input type="hidden" name="Filtro_ECnombre" value="<cfoutput>#form.Filtro_ECnombre#</cfoutput>">
		<input type="hidden" name="Filtro_ECorden" value="<cfoutput>#form.Filtro_ECorden#</cfoutput>">
    <tr>
      <td class="tituloAlterno" colspan="2" align="center"><font size="3">
        <cfif modo eq "ALTA">
          Nuevo Concepto De Evaluaci&oacute;n
          <cfelse>
          Modificar Concepto De Evaluaci&oacute;n
        </cfif>
        </font></td>
    </tr>
    <tr> 
      <td align="right" valign="baseline">Descripci&oacute;n:&nbsp;</td>
      <td valign="baseline"><input name="ECnombre" type="text" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.ECnombre#</cfoutput></cfif>" size="50" maxlength="80" alt="El valor de la Descripción" onfocus="javascript:this.select();"></td>
    </tr>
    <tr> 
      <td align="right"> 
        Orden: </td>
      <td align="left"><input name="ECorden" align="left" type="text" id="ECorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ECorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
    </tr>
    <tr> 
      <td align="center">&nbsp;</td>
      <td align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="2"> <cf_botones modo="#modo#"></td>
    </tr>
	
    <cfif modo neq 'ALTA'>
	<cfoutput>
      <tr> 
        <td colspan="2">
			<input type="hidden" name="ECcodigo"  value="#rsForm.ECcodigo#">
			<input type="hidden" name="HayEvaluacionConceptoMateria"  value="#rsHayEvaluacionConceptoMateria.recordCount#">
			<input type="hidden" name="HayEvaluacionPlanConcepto"  value="#rsHayEvaluacionPlanConcepto.recordCount#">
			<input type="hidden" name="HayEvaluacionConceptoCurso"  value="#rsHayEvaluacionConceptoCurso.recordCount#">
		</td>
      </tr>
	</cfoutput>
    </cfif>
  </table>

</form>
<cf_qforms>
<script language="JavaScript">
	_addValidator("isTieneDependencias", __isTieneDependencias);
	function deshabilitarValidacion() {
		objForm.ECnombre.required = false;
	}
	
	function habilitarValidacion() {
		objForm.ECnombre.required = true;
	}
		
	// Se aplica la descripcion del Grado 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				//alert(new Number(this.obj.form.HayEvaluacionConceptoMateria.value)); 
				if (new Number(this.obj.form.HayEvaluacionConceptoMateria.value) > 0) {
					msg = msg + "conceptos de evaluación de materias"
				}
				//alert(new Number(this.obj.form.HayEvaluacionPlanConcepto.value));
				if (new Number(this.obj.form.HayEvaluacionPlanConcepto.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "conceptos de planes de evaluación"
				}
				//alert(new Number(this.obj.form.HayEvaluacionConceptoCurso.value));
				if (new Number(this.obj.form.HayEvaluacionConceptoCurso.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "conceptos de evaluación de cursos"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Concepto de evaluación '" + this.obj.form.ECnombre.value + "' porque ste tiene asociado: " + msg + ".";
					this.obj.form.ECnombre.focus();
				}
		}
	}

	<cfif modo EQ "ALTA">
		objForm.ECnombre.required = true;
		objForm.ECnombre.description = "Descripción";
		objForm.ECorden.description = "Orden";
	<cfelseif modo EQ "CAMBIO">
		objForm.ECnombre.required = true;
		objForm.ECnombre.description = "Descripción";
		objForm.ECnombre.validateTieneDependencias();
	</cfif>
</script>
