<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
	<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">
	<cfparam name="Form.modo" default="CAMBIO">
</cfif>

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

<cfquery name="rsPlanesEval" datasource="#Session.DSN#">
	select distinct convert(varchar, a.EPcodigo) as EPcodigo, a.EPnombre
	from EvaluacionPlan a, EvaluacionPlanConcepto b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.EPcodigo = b.EPcodigo
    group by a.EPcodigo
	having sum(b.EPCporcentaje) = 100
	order by a.EPnombre
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsNiveles">
	select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	order by Norden
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsGrado">
	select convert(varchar, b.Ncodigo)
	       + '|' + convert(varchar, b.Gcodigo) as Codigo, 
		   b.Gdescripcion
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	and a.Ncodigo = b.Ncodigo 
	order by a.Norden, b.Gorden
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsMateriaTipo">
	select MTcodigo, MTdescripcion from MateriaTipo 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	order by MTdescripcion
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsEvaluacionValoresTabla">
	select EVTcodigo, EVTnombre from EvaluacionValoresTabla
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	order by EVTnombre
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery datasource="#Session.DSN#" name="rsMateria">
		select convert(varchar, c.Mconsecutivo) as Mconsecutivo, 
		       convert(varchar, c.Gcodigo) as Gcodigo,
		       convert(varchar, c.Ncodigo) as Ncodigo, 
			   convert(varchar, c.MTcodigo) as MTcodigo, 
			   convert(varchar, c.EVTcodigo) as EVTcodigo, 
			   c.Mcodigo, 
			   convert(varchar, EPcodigo) as EPcodigo,
			   c.Mnombre, c.Mobservaciones, c.Mreglamentos, c.Mhoras, c.Mcreditos, c.Mtipoevaluacion, c.Melectiva, c.Morden, c.Manterior 
		from Nivel a, Grado b, Materia c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		  and a.Ncodigo = b.Ncodigo 
		  and b.Ncodigo = c.Ncodigo 
		  and b.Gcodigo = c.Gcodigo 
	</cfquery>
	
	<cfquery datasource="#Session.DSN#" name="rsAsociadas">
		Select count(*) as asociadas from MateriaElectiva 
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		or Melectiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<!--- Validaciones si existen dependencias --->
<!--- 	<cfquery datasource="#Session.DSN#" name="rsHayMateriaElectiva">
		select 1 from MateriaElectiva
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery> --->

	<cfquery datasource="#Session.DSN#" name="rsHayMateriaPrograma">
		select 1 from MateriaPrograma where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayEvaluacionConceptoMateria">
		select 1 from EvaluacionConceptoMateria 
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayCurso">
		select 1 from Curso 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayAlumnoMatriculaElectivas">
		select 1 from AlumnoMatriculaElectivas 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
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
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function genEvaluaciones(EPcodigo) {
		popUpWindow("genMateriaConceptos.cfm?form=form1&id=ConceptosEval&EPcodigo="+EPcodigo,250,200,650,350);
	}

	function OcultaTablaEval(f) {
		if (f.Mtipoevaluacion.value == "0") {      
			f.EVTcodigo.style.visibility = 'hidden';
			f.Label_EVTcodigo.style.visibility = 'hidden';
		} else {    
			f.EVTcodigo.style.visibility = 'visible';
			f.Label_EVTcodigo.style.visibility = 'visible';
		}
	}  
	
	function crearNuevoTipoMateria(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='MateriaTipo.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function crearNuevoNivel(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Nivel.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function crearNuevoGrado(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Grado.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}

	function crearNuevaTabla(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='listaTablaEvaluac.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function crearNuevoPlanEvaluacion(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='listaEvaluacionPlan.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") {
			c.selectedIndex = 0;
		}
		else if (c.value != "") {
			genEvaluaciones(c.value);
		}
	}

	<cfif modo NEQ "ALTA">
	function irADetalle(f) {
		f.action='MateriaDetalle.cfm?Mconsecutivo=' + '<cfoutput>#Form.Mconsecutivo#</cfoutput>';
		f.submit();
	}
	</cfif>

	var gradostext = new Array();
	var grados = new Array();
	var niveles = new Array();

    // Esta función únicamente debe ejecutarlo una vez
	function obtenerGrados(f) {
        for(i=0; i<f.FGcodigo.length; i++) {
			var s = f.FGcodigo.options[i].value.split("|");
            // Códigos de los detalles
            niveles[i]= s[0];
			grados[i] = s[1];
			gradostext[i] = f.FGcodigo.options[i].text;
        }
	}
	
    function cargarGrados(csource, ctarget, vdefault, t){
		// Limpiar Combo
		for (var i=ctarget.length-1; i >=0; i--) {
			ctarget.options[i]=null;
		}
		var k = csource.value;
		var j = 0;
		if (t) {
			var nuevaOpcion = new Option("Todos","-1");
			ctarget.options[j]=nuevaOpcion;
			j++;
		}
		if (k != "-1") {
			for (var i=0; i<grados.length; i++) {
				if (niveles[i] == k) {
					nuevaOpcion = new Option(gradostext[i],grados[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && grados[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;
				}
			}
		} else {
			for (var i=0; i<grados.length; i++) {
				nuevaOpcion = new Option(gradostext[i],grados[i]);
				ctarget.options[i+1]=nuevaOpcion;
			}
		}
		if (!t) {
			var j = ctarget.length;
			nuevaOpcion = new Option("-------------------","");
			ctarget.options[j++]=nuevaOpcion;
			nuevaOpcion = new Option("Crear Nuevo ...","0");
			ctarget.options[j]=nuevaOpcion;
		}
    }
</script>

<form action="SQLMaterias.cfm" method="post" name="form1">
  <table border="0" width="100%" align="center">
    <tr> 
      <td class="tituloMantenimiento" colspan="6" align="center"><font size="3"> 
        <cfif modo eq "ALTA">
          Nueva Materia 
          <cfelse>
          Modificar Materia 
        </cfif>
        </font></td>
    </tr>
    <tr> 
      <td colspan="6" align="right" valign="top" nowrap>&nbsp;</td>
    <tr> 
      <td align="right" valign="middle" nowrap>C&oacute;digo</td>
      <td valign="middle" nowrap> 
        <cfif modo NEQ "ALTA">
          <cfoutput>#rsMateria.Mcodigo#</cfoutput> 
          <cfelse>
          <input name="Mcodigo" type="text" value="" size="10" maxlength="10" tabindex="1" alt="El código de la Materia">
        </cfif>
      </td>
      <td align="right" valign="middle" nowrap>Tipo de Evaluaci&oacute;n</td>
      <td valign="middle" nowrap> 
        <select name="Mtipoevaluacion" tabindex="2" onChange="javascript: OcultaTablaEval(this.form);">
          <option value="0" <cfif (isDefined("rsMateria.Mtipoevaluacion") AND "0" EQ rsMateria.Mtipoevaluacion)>selected</cfif>>Porcentual</option>
          <option value="1" <cfif (isDefined("rsMateria.Mtipoevaluacion") AND "1" EQ rsMateria.Mtipoevaluacion)>selected</cfif>>Tabla 
          de Valores</option>
        </select>
      </td>
      <td align="right" valign="middle" nowrap> 
        <input name="Label_EVTcodigo" style="text-align:right" type="text" class="cajasinborde" tabindex="-1" value="Tabla de Evaluaci&oacute;n:"  size="22" readonly="">
      </td>
      <td valign="middle" nowrap> 
        <select tabindex="2" name="EVTcodigo" id="EVTcodigo" onChange="javascript: crearNuevaTabla(this);">
          <cfoutput query="rsEvaluacionValoresTabla"> 
            <option value="#EVTcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.EVTcodigo EQ rsEvaluacionValoresTabla.EVTcodigo>selected</cfif>>#EVTnombre#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
      </td>
    <tr> 
      <td align="right" valign="middle" nowrap>Nombre</td>
      <td valign="middle" nowrap> 
        <input name="Mnombre" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mnombre#</cfoutput></cfif>" size="30" maxlength="255" tabindex="1" alt="La descripci&oacute;n del Nivel">
      </td>
      <td align="right" valign="middle" nowrap>Modalidad</td>
      <td valign="middle" nowrap> 
        <select name="Melectiva" tabindex="3">
          <option value="R" <cfif modo NEQ "ALTA" AND "R" EQ rsMateria.Melectiva>selected</cfif>>Regular</option>
          <option value="S" <cfif modo NEQ "ALTA" AND "S" EQ rsMateria.Melectiva>selected</cfif>>Sustitutiva</option>
          <option value="E" <cfif modo NEQ "ALTA" AND "E" EQ rsMateria.Melectiva>selected</cfif>>Electiva</option>
          <option value="C" <cfif modo NEQ "ALTA" AND "C" EQ rsMateria.Melectiva>selected</cfif>>Complementaria</option>
        </select>
      </td>
      <td rowspan="3" align="right" valign="top" nowrap>Observaciones</td>
      <td rowspan="3" valign="middle" nowrap> 
        <textarea name="Mobservaciones" rows="4" cols="30" tabindex="4"><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsMateria.Mobservaciones)#</cfoutput></cfif></textarea>
      </td>
    </tr>
    <tr> 
      <td align="right" valign="middle" nowrap>Tipo Materia</td>
      <td valign="middle" nowrap> 
        <select name="MTcodigo" id="MTcodigo" tabindex="1" onChange="javascript: crearNuevoTipoMateria(this);">
          <cfoutput query="rsMateriaTipo"> 
            <option value="#MTcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.MTcodigo EQ rsMateriaTipo.MTcodigo>selected</cfif>>#MTdescripcion#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
      </td>
      <td align="right" valign="middle" nowrap>Horas</td>
      <td valign="middle" nowrap> 
        <input name="Mhoras" type="text" tabindex="3" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mhoras#</cfoutput></cfif>" size="8" maxlength="3" style="text-align: right;" alt="Las Horas de la Materia"  onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
      </td>
    </tr>
    <tr> 
      <td align="right" valign="middle" nowrap>Nivel</td>
      <td valign="middle" nowrap> 
        <select name="Ncodigo" id="Ncodigo" tabindex="1" onchange="javascript: crearNuevoNivel(this); cargarGrados(this, this.form.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Gcodigo#</cfoutput></cfif>', false)">
          <cfoutput query="rsNiveles"> 
            <option value="#Ncodigo#" <cfif modo NEQ "ALTA" AND rsMateria.Ncodigo EQ rsNiveles.Ncodigo>selected</cfif>>#Ndescripcion#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
      </td>
      <td align="right" valign="middle" nowrap>Cr&eacute;ditos</td>
      <td valign="middle" nowrap> 
        <input name="Mcreditos" type="text" tabindex="3" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mcreditos#</cfoutput></cfif>" size="8" maxlength="3" style="text-align: right;" alt="Los créditos de la Materia"  onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
      </td>
      <!--- <cfif modo NEQ "ALTA" and rsHayGrupos.recordCount NEQ 0>disabled</cfif> --->
    </tr>
    <tr> 
      <td align="right" valign="middle" nowrap>Grado</td>
      <td valign="middle" nowrap> 
        <select name="Gcodigo" id="Gcodigo" tabindex="1" onchange="javascript: crearNuevoGrado(this);">
          <cfoutput query="rsGrado"> 
            <option value="#Codigo#">#rsGrado.Gdescripcion#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
      </td>
      <td align="right" valign="middle" nowrap>Orden</td>
      <td valign="middle" nowrap> 
        <input name="Morden" type="text" id="Morden" tabindex="3" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Morden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
      </td>
      <td rowspan="3" align="right" valign="top" nowrap>Reglamentos</td>
      <td rowspan="3" valign="middle" nowrap> 
        <textarea name="Mreglamentos" rows="4" cols="30" tabindex="4"><cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mreglamentos#</cfoutput></cfif></textarea>
      </td>
    </tr>
    <tr> 
      <td colspan="2" align="right" valign="middle" nowrap> 
        <cfif modo NEQ "ALTA">
			<cfoutput>
				<input name="MelectivaAnterior" type="hidden" id="MelectivaAnterior" value="#rsMateria.Melectiva#">
				<input name="NumAsociadas" type="hidden" id="NumAsociadas" value="#rsAsociadas.asociadas#">
				<!--- Campos Hidden para Validaciones si existen dependencias --->
				<input type="hidden" name="HayMateriaPrograma" value="#rsHayMateriaPrograma.recordCount#">
				<input type="hidden" name="HayEvaluacionConceptoMateria" value="#rsHayEvaluacionConceptoMateria.recordCount#">
				<input type="hidden" name="HayCurso" value="#rsHayCurso.recordCount#">
				<input type="hidden" name="HayAlumnoMatriculaElectivas" value="#rsHayAlumnoMatriculaElectivas.recordCount#">				
			</cfoutput>
        </cfif>
		
      </td>
      <td colspan="2" valign="middle" nowrap>&nbsp; </td>
    </tr>
    <tr> 
      <td colspan="2" align="right" valign="middle" nowrap> 
        <input name="ConceptosEval" type="hidden" id="ConceptosEval">
        Plan de Evaluación</td>
      <td colspan="2" valign="middle" nowrap> 
        <select name="EPcodigo" id="EPcodigo" tabindex="4" onChange="javascript: crearNuevoPlanEvaluacion(this);" <cfif modo NEQ "ALTA">disabled</cfif>>
          <option value="">(Seleccione un Plan de Evaluación)</option>
          <cfoutput query="rsPlanesEval"> 
            <option value="#EPcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.EPcodigo EQ rsPlanesEval.EPcodigo>selected</cfif>>#EPnombre#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
      </td>
    </tr>
    <tr> 
      <td colspan="6" align="right" valign="middle" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6" align="center" valign="baseline" nowrap> 
        <cfif modo NEQ "ALTA">
          <input type="hidden" name="Mconsecutivo" value="<cfoutput>#rsMateria.Mconsecutivo#</cfoutput>">
		  <input type="button" name="Detalle" value="Detalle" onClick="javascript: irADetalle(this.form);">
        </cfif>
        <cfinclude template="../../portlets/pBotones.cfm">
      </td>
    </tr>
  </table>
 </form>
 <form action="Materias.cfm" method="post" name="FiltroMaterias">
	<table class="areaFiltro" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>Nivel</td>
			<td>
				<select name="FNcodigo" id="FNcodigo" tabindex="5" onChange="javascript: cargarGrados(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true)">
					<option value="-1">Todos</option>
				  <cfoutput query="rsNiveles"> 
					<option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
				  </cfoutput> 
				</select>
			</td>
			<td>Grado</td>
			<td>
				<select name="FGcodigo" id="FGcodigo" tabindex="5">
				  <cfoutput query="rsGrado"> 
					<option value="#Codigo#">#Gdescripcion#</option>
				  </cfoutput> 
				</select>
			</td>
			
      <td>C&oacute;digo</td>
			<td><input name="FMcodigo" type="text" size="10" maxlength="10" tabindex="5" value="<cfif isdefined("Form.FMcodigo")><cfoutput>#Form.FMcodigo#</cfoutput></cfif>"></td>
			
      <td>Nombre</td>
			<td><input name="FMnombre" type="text" maxlength="255" tabindex="5" value="<cfif isdefined("Form.FMnombre")><cfoutput>#Form.FMnombre#</cfoutput></cfif>"></td>
      <td>Modalidad</td>
			<td>
				<select name="FMelectiva" tabindex="5">
				  <option value="-1">Todas</option>
				  <option value="R" <cfif isDefined("Form.FMelectiva") AND Form.FMelectiva EQ "R">selected</cfif>>Regular</option>
				  <option value="S" <cfif isDefined("Form.FMelectiva") AND Form.FMelectiva EQ "S">selected</cfif>>Sustitutiva</option>
				  <option value="E" <cfif isDefined("Form.FMelectiva") AND Form.FMelectiva EQ "E">selected</cfif>>Electiva</option>
				  <option value="C" <cfif isDefined("Form.FMelectiva") AND Form.FMelectiva EQ "C">selected</cfif>>Complementaria</option>
				</select>
			</td>
			<td>
				<input type="submit" name="Filtrar" tabindex="5" value="Filtrar">
			</td>
		</tr>
	</table>
 </form>
 <cfset filtro = "">
 <cfif isdefined("Form.FNcodigo") and Form.FNcodigo NEQ -1>
 	<cfset filtro = filtro & " and c.Ncodigo = " & Form.FNcodigo>
 </cfif>
 <cfif isdefined("Form.FGcodigo") and Form.FGcodigo NEQ -1>
 	<cfset filtro = filtro & " and c.Gcodigo = " & Form.FGcodigo>
 </cfif>
 <cfif isdefined("Form.FMcodigo")>
 	<cfset filtro = filtro & " and upper(c.Mcodigo) like '%" & #UCase(Form.FMcodigo)# & "%'">
 </cfif>
 <cfif isdefined("Form.FMnombre")>
 	<cfset filtro = filtro & " and upper(c.Mnombre) like '%" & #UCase(Form.FMnombre)# & "%'">
 </cfif>
 <cfif isdefined("Form.FMelectiva") and Form.FMelectiva NEQ "-1">
 	<cfset filtro = filtro & " and c.Melectiva = '" & #UCase(Form.FMelectiva)# & "'">
 </cfif>
<cfinvoke component="edu.Componentes.pListas" method="pListaEdu" returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Nivel a, Grado b, Materia c"/>
	<cfinvokeargument name="columnas" value="convert(varchar, c.Ncodigo) as Ncodigo, convert(varchar, c.Gcodigo), c.Mcodigo as Mcodigo, convert(varchar, c.Mconsecutivo) as Mconsecutivo, substring(c.Mnombre,1,35) as Mnombre, a.Ndescripcion+': '+b.Gdescripcion as Grado, case c.Melectiva when 'R' then 'Regular' when 'S' then 'Sustitutiva' when 'E' then 'Electiva' when 'C' then 'Complementaria' else '' end as Melectiva, c.Morden as Morden"/>
	<cfinvokeargument name="desplegar" value="Mcodigo, Mnombre, Melectiva, Morden"/>
	<cfinvokeargument name="etiquetas" value="Codigo, Materia, Modalidad, Orden"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" a.CEcodigo = #Session.CEcodigo# and a.Ncodigo = b.Ncodigo and b.Ncodigo = c.Ncodigo and b.Gcodigo = c.Gcodigo #filtro# order by a.Norden, b.Gorden, c.Morden, c.Mcodigo, c.Mnombre"/>
	<cfinvokeargument name="align" value="left,left,left,left"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N"/>
	<cfinvokeargument name="irA" value="Materias.cfm"/>
	<cfinvokeargument name="cortes" value="Grado"/>
</cfinvoke>
<br>

<script language="JavaScript" type="text/JavaScript">
	function deshabilitarValidacion() {
		objForm.Mcodigo.required = false;
		objForm.Mnombre.required = false;
		objForm.MTcodigo.required = false;
		objForm.Ncodigo.required = false;
		objForm.Gcodigo.required = false;
		objForm.Mhoras.required = false;
		objForm.Mcreditos.required = false;
		objForm.EVTcodigo.required = false;
		objForm.EPcodigo.required = false;
	}
	
	function __isTieneDependencias() {
		if(btnSelected("Cambio", this.obj.form)) {
				// Valida que la Materia no tenga dependencias con otras.
				var msg = "";
				alert(new Number(this.obj.form.HayMateriaPrograma.value);
				if (new Number(this.obj.form.HayMateriaPrograma.value) > 0) {
					msg = msg + "programas"
				}
				alert(new Number(this.obj.form.HayEvaluacionConceptoMateria.value);
				if (new Number(this.obj.form.HayEvaluacionConceptoMateria.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "conceptos de evaluación"
				}
				alert(new Number(this.obj.form.HayCurso.value);
				if (new Number(this.obj.form.HayCurso.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "cursos"
				}
				alert(new Number(this.obj.form.HayAlumnoMatriculaElectivas.value);
				if (new Number(this.obj.form.HayAlumnoMatriculaElectivas.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "matricula electiva"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar la materia " + this.obj.form.Mcodigo.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.Mcodigo.focus();
				}
		}
	}
	
	OcultaTablaEval(document.form1);
	obtenerGrados(document.FiltroMaterias);
	cargarGrados(document.FiltroMaterias.FNcodigo, document.FiltroMaterias.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
	cargarGrados(document.form1.Ncodigo, document.form1.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Gcodigo#</cfoutput></cfif>', false);

	function __isMateriasAsociadas() {
		if (btnSelected("Cambio", this.obj.form)) {
			if ((this.obj.form.MelectivaAnterior.value=='E' || this.obj.form.MelectivaAnterior.value =='S' || this.obj.form.MelectivaAnterior.value =='C') 
					&& new Number(this.obj.form.NumAsociadas.value) > 0) {
				this.error = "Esta materia no puede cambiar de modalidad porque ya tiene materias asociadas";
				if (this.obj.form.MelectivaAnterior.value == 'C') {
					this.obj.form.Melectiva.selectedIndex = 3;
				} else if (this.obj.form.MelectivaAnterior.value == 'E') {
					this.obj.form.Melectiva.selectedIndex = 2;
				} else if (this.obj.form.MelectivaAnterior.value == 'S') {
					this.obj.form.Melectiva.selectedIndex = 1;
				} else {
					this.obj.form.Melectiva.selectedIndex = 0;
				}
			}
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isMateriasAsociadas", __isMateriasAsociadas);
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.Mcodigo.obj.focus();
		objForm.Mcodigo.required = true;
		objForm.Mcodigo.description = "Código de Materia";
		objForm.Mnombre.required = true;
		objForm.Mnombre.description = "Nombre de Materia";
		objForm.MTcodigo.required = true;
		objForm.MTcodigo.description = "Tipo de Materia";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.Gcodigo.required = true;
		objForm.Gcodigo.description = "Grado";
		objForm.Mhoras.required = true;
		objForm.Mhoras.description = "Horas";
		objForm.Mcreditos.required = true;
		objForm.Mcreditos.description = "Créditos";
		objForm.EVTcodigo.required = true;
		objForm.EVTcodigo.description = "Tabla de Evaluación";
		objForm.EPcodigo.required = true;
		objForm.EPcodigo.description = "Plan de Evaluación";
	<cfelseif modo EQ "CAMBIO">
		objForm.Mnombre.required = true;
		objForm.Mnombre.description = "Nombre de Materia";
		objForm.MTcodigo.required = true;
		objForm.MTcodigo.description = "Tipo de Materia";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.Gcodigo.required = true;
		objForm.Gcodigo.description = "Grado";
		objForm.Melectiva.description = "Modalidad";
		objForm.Melectiva.validateMateriasAsociadas();
		objForm.Mhoras.required = true;
		objForm.Mhoras.description = "Horas";
		objForm.Mcreditos.required = true;
		objForm.Mcreditos.description = "Créditos";
		objForm.EVTcodigo.required = true;
		objForm.EVTcodigo.description = "Tabla de Evaluación";
		objForm.Mcodigo.validateTieneDependencias();
	</cfif>
</script>
