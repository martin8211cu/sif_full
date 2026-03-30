<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Periodo de Evaluación********************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->

<cfset modo="ALTA">
<cfif isdefined("Form.PEcodigo") and len(trim("Form.PEcodigo")) NEQ 0 and Form.PEcodigo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<cfquery name="rsNivel" datasource="#Session.Edu.DSN#">
	select Ncodigo, substring(Ndescripcion,1,50) as Ndescripcion
	from Nivel 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>

<cfif (modo NEQ 'ALTA')>
	<cfquery name="rsForm" datasource="#Session.Edu.DSN#">
		SELECT PEcodigo, Ncodigo, substring(PEdescripcion,1,50) as PEdescripcion, PEorden, PEacumulativo
		FROM PeriodoEvaluacion
		WHERE PEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionConceptoMateria">
		SELECT 1 
		FROM EvaluacionConceptoMateria
		WHERE PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayAlumnoCalificacion">
		SELECT 1 
		FROM AlumnoCalificacionPerEval
		WHERE CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
		  AND PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateriaPrograma">
		SELECT 1 
		FROM MateriaPrograma
		WHERE PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayCursoPrograma">
		SELECT 1 
		FROM CursoPrograma
		WHERE PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionConceptoCurso">
		SELECT 1 
		FROM EvaluacionConceptoCurso
		WHERE PEcodigo  = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
<!---<cfelse>
	 Mejora de Usabilidad 
	<cfquery name="rsUsability" datasource="#Session.Edu.DSN#">
		SELECT PEcodigo, Ncodigo, substring(PEdescripcion,1,50) as PEdescripcion, PEorden, PEacumulativo
		FROM PeriodoEvaluacion
		WHERE ts_rversion = 
		(
		SELECT max(a.ts_rversion) 
		FROM PeriodoEvaluacion a
			INNER JOIN Nivel b
			ON a.Ncodigo = b.Ncodigo
			AND b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		)
	</cfquery>--->
</cfif>
<form action="SQLPeriodoEvaluacion.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);">
  <input type="hidden" name="Pagina" value="<cfoutput>#form.Pagina#</cfoutput>">
  <input type="hidden" name="Filtro_PEdescripcion" value="<cfoutput>#form.Filtro_PEdescripcion#</cfoutput>">
  <input type="hidden" name="Filtro_PEorden" value="<cfoutput>#form.Filtro_PEorden#</cfoutput>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td class="tituloAlterno" colspan="2" align="center">
        <cfif (modo EQ 'ALTA')>
          Nuevo Per&iacute;odo de Evaluaci&oacute;n 
          <cfelse>
          Modificar Per&iacute;odo de Evaluaci&oacute;n 
        </cfif>
	  </td>
    </tr>
    <tr> 
      <td align="right" valign="baseline">Nivel:&nbsp;</td>
      <td valign="baseline"> 
          <select name="Ncodigo"  onchange="javascript: crearNuevoNivel(this);" id="Ncodigo" <cfif (modo NEQ 'ALTA') and rsHayEvaluacionConceptoMateria.recordCount NEQ 0>disabled</cfif>>
            <cfoutput query="rsNivel"> 
              <option value="#rsNivel.Ncodigo#" 
			  	<cfif (isDefined("rsForm.Ncodigo") AND #rsForm.Ncodigo# EQ #rsNivel.Ncodigo#)>
					selected
				<!--- <cfelseif (modo EQ 'ALTA') AND isDefined("rsUsability.Ncodigo") AND rsUsability.Ncodigo EQ rsNivel.Ncodigo>
					selected --->
				</cfif>>#rsNivel.Ndescripcion# 
              </option>
            </cfoutput> 
         	<option value="">-------------------</option>
          	<option value="0">Crear Nuevo ...</option>
          </select>
	  </td>
    </tr>
    <tr> 
      <td align="right" valign="baseline">Descripci&oacute;n:&nbsp;</td>
      <td valign="baseline"><input name="PEdescripcion" type="text" value="<cfif (modo NEQ 'ALTA')><cfoutput>#rsForm.PEdescripcion#</cfoutput></cfif>" size="50" maxlength="255" alt="El valor de la Descripcin" onfocus="javascript:this.select();"></td>
    </tr>
    <tr> 
      <td align="right" valign="baseline">Orden:&nbsp;</td>
      <td align="left"><input name="PEorden" align="left" type="text" id="PEorden" size="8" maxlength="8" value="<cfif (modo NEQ 'ALTA')><cfoutput>#rsForm.PEorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
    </tr>
    <tr> 
      <td align="center">&nbsp;</td>
      <td align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="2"><cf_botones modo="#modo#"></td>
    </tr>
    <cfif (modo NEQ 'ALTA')>
      <tr> 
        <td colspan="2"> 
          <cfoutput> 
            <input type="hidden" name="PEcodigo"  value="#rsForm.PEcodigo#">
            <input type="hidden" name="HayEvaluacionConceptoMateria"  value="#rsHayEvaluacionConceptoMateria.recordCount#">
            <input type="hidden" name="HayAlumnoCalificacion"  value="#rsHayAlumnoCalificacion.recordCount#">
            <input type="hidden" name="HayMateriaPrograma"  value="#rsHayMateriaPrograma.recordCount#">
            <input type="hidden" name="HayCursoPrograma"  value="#rsHayCursoPrograma.recordCount#">
            <input type="hidden" name="HayEvaluacionConceptoCurso"  value="#rsHayEvaluacionConceptoCurso.recordCount#">
          </cfoutput> </td>
      </tr>
    </cfif>
  </table>
</form>
<cf_qforms>
<script language="JavaScript">
	<!--
	//funciones especiales para agregar al api de qforms
	// Validación Antes de Dar de Baja
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				if (new Number(this.obj.form.HayEvaluacionConceptoMateria.value) > 0) {
					msg = msg + "conceptos de evaluación de materias"
				}
				if (new Number(this.obj.form.HayAlumnoCalificacion.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "calificaciones de alumnos"
				}
				if (new Number(this.obj.form.HayMateriaPrograma.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "programas de materias"
				}
				if (new Number(this.obj.form.HayCursoPrograma.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "programas de cursos"
				}
				if (new Number(this.obj.form.HayEvaluacionConceptoCurso.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "conceptos de evaluación de cursos"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Periodo " + this.value + " porque este tiene asociado: " + msg + ".";
					this.obj.form.PEdescripcion.focus();
				}
		}
	}
	//agrega las funciones al api de qforms
	_addValidator("isTieneDependencias", __isTieneDependencias);
	//descripciones de los campos
	objForm.PEdescripcion.description = "Periodo";
	objForm.Ncodigo.description = "Nivel";
	objForm.PEorden.description = "Orden";
	//validaciones para requeridos
	var requeridos = "PEdescripcion,Ncodigo,PEorden";
	function deshabilitarValidacion() {
		objForm.required(requeridos,false);
	}
	function habilitarValidacion() {
		objForm.required(requeridos);
	}
	<cfif (modo NEQ "ALTA")>
		objForm.PEdescripcion.validateTieneDependencias();
	</cfif>
	//otras funciones		
	function validaForm(f) {
		if (f.Ncodigo.obj.disabled) {
			f.Ncodigo.obj.disabled = false;
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
	function crearNuevoNivel(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Nivel.cfm?RegresarURL=PeriodoEvaluacion.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}	
	-->
</script>