<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
<cfset modo="ALTA">
<cfif isdefined("Form.Mconsecutivo") and form.Mconsecutivo NEQ ''>
	<cfset modo="CAMBIO">
</cfif>


<cfquery name="rsPlanesEval" datasource="#Session.Edu.DSN#">
	select distinct convert(varchar, a.EPcodigo) as EPcodigo, substring(a.EPnombre,1,50) as EPnombre
	from EvaluacionPlan a, EvaluacionPlanConcepto b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and a.EPcodigo = b.EPcodigo
    group by a.EPcodigo
	having sum(b.EPCporcentaje) = 100
	order by a.EPnombre
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	select convert(varchar, Ncodigo) as Ncodigo, 
		substring(Ndescripcion ,1,50) as Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	order by Norden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
	select convert(varchar, b.Ncodigo)
	       + '|' + convert(varchar, b.Gcodigo) as Codigo, 
		   substring(b.Gdescripcion ,1,50) as Gdescripcion 
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	  and a.Ncodigo = b.Ncodigo 
	order by a.Norden, b.Gorden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsMateriaTipo">
	select convert(varchar,MTcodigo) as MTcodigo, substring(MTdescripcion,1,50)	as MTdescripcion 
	from MateriaTipo 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	order by MTdescripcion
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsEvaluacionValoresTabla">
	select convert(varchar,EVTcodigo) as EVTcodigo, 
	substring(EVTnombre,1,50) as EVTnombre 
	from EvaluacionValoresTabla
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	order by EVTnombre
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery datasource="#Session.Edu.DSN#" name="rsMateria">
		select convert(varchar, c.Mconsecutivo) as Mconsecutivo, 
		       convert(varchar, c.Gcodigo) as Gcodigo,
		       convert(varchar, c.Ncodigo) as Ncodigo, 
			   convert(varchar, c.MTcodigo) as MTcodigo, 
			   convert(varchar, c.EVTcodigo) as EVTcodigo, 
			   c.Mcodigo, 
			   convert(varchar, EPcodigo) as EPcodigo,
			   c.Mnombre, c.Mobservaciones, c.Mreglamentos, c.Mhoras, c.Mcreditos, c.Mtipoevaluacion, c.Melectiva, c.Morden, c.Manterior
			   , Mactiva 
		from Nivel a, Grado b, Materia c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and c.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		  and a.Ncodigo = c.Ncodigo 
		  and b.Ncodigo =* c.Ncodigo 
		  and b.Gcodigo =* c.Gcodigo 
	</cfquery>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsAsociadas">
		Select count(*) as asociadas from MateriaElectiva 
		where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		or Melectiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayCurso">
		select 1 from Curso
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateriaElectiva">
		select 1 from MateriaElectiva
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<!--- Desde aqui Rodolfo Jiménez Jara, 22/01/2003 --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateriaElectiva2">
		select 1 from MateriaElectiva
		where Melectiva  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayGradoSustitutivas">
		select 1 from GradoSustitutivas
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayEvaluacionConceptoMateria">
		select 1 from EvaluacionConceptoMateria
		where Mconsecutivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
	</cfquery>
</cfif>
<script language="JavaScript" src="../../../sif/js/utilesMonto.js"></script>

<script language="JavaScript" type="text/javascript">

//----------------------------------------------------------------------------------------------------------------------------
// FUNCIONES DE BOTONES

//----------------------------------------------------------------------------------------------------------------------------
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	

	function cambioMod(obj){
		var grado1= document.getElementById("sustit1");
		var grado2= document.getElementById("sustit2");
		
		var plan1= document.getElementById("Elect_o_Comp1");
		var plan2= document.getElementById("Elect_o_Comp2");
		
				
		if(obj.value == 'S'){
			objForm.Gcodigo.required = false;
			grado1.style.display = "none";
			grado2.style.display = "none";
			plan1.style.display = "";
			plan2.style.display = "";
			<!---
			<cfif modo EQ "ALTA">
			objForm.EPcodigo.required = true;
			</cfif>
			--->
			objForm.Gcodigo.required = false;
		}else if (obj.value == 'E' || obj.value == 'C' ){
			objForm.EPcodigo.required = false;
			plan1.style.display = "none";
			plan2.style.display = "none";
			grado1.style.display = "";
			grado2.style.display = "";
			<!---
			<cfif modo EQ "ALTA">
			objForm.EPcodigo.required = false;
			</cfif>
			--->
			objForm.Gcodigo.required = true;
		}else{
			grado1.style.display = "";
			grado2.style.display = "";
			objForm.Gcodigo.required = true;
			plan1.style.display = "";
			plan2.style.display = "";
			<!---
			<cfif modo EQ "ALTA">
			objForm.EPcodigo.required = true;
			</cfif>
			--->
			objForm.Gcodigo.required = true;
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

	function crearNuevaTablaEval(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='tablaEvaluac.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function crearNuevoPlanEvaluacion(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='PlanEvaluacion.cfm?RegresarURL=Materias.cfm';
		}
		else if (c.value == "") {
			c.selectedIndex = 0;
		}
	}

	<cfif modo NEQ "ALTA">
	function funcDetalle() {
		document.form1.action='Materias.cfm';
	}
	</cfif>

	var gradostext = new Array();
	var grados = new Array();
	var niveles = new Array();

    // Esta función únicamente debe ejecutarlo una vez
	function obtenerGrados(f) {
        for(i=0; i<f.Gcodigo.length; i++) {
			var s = f.Gcodigo.options[i].value.split("|");
            // Códigos de los detalles
            niveles[i]= s[0];
			grados[i] = s[1];
			gradostext[i] = f.Gcodigo.options[i].text;
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
				if (vdefault != null && grados[i] == vdefault) {
					ctarget.selectedIndex = i+1;
				}
			}
		}
    }
	
	function MateriaActiva(){
		 if(!document.form1.Mactiva1.checked ) {
			 document.form1.Mactiva.value=0;        	
		 }else{
			 document.form1.Mactiva.value=1;     	
		 }
	 }
	 
	 function validaForm(f) {
		f.Ncodigo.obj.disabled = false;
		return true;
	 }
	
</script>

<form action="SQLMaterias.cfm" method="post" name="form1" onSubmit="javascript: return validaForm(this);">
	<cfoutput>
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<input name="Filtro_Mcodigo" type="hidden" value="<cfif isdefined('Form.Filtro_Mcodigo')>#form.Filtro_Mcodigo#</cfif>">
	<input name="Filtro_MTdescripcion" type="hidden" value="<cfif isdefined('Form.Filtro_MTdescripcion')>#form.Filtro_MTdescripcion#</cfif>">
	<input name="Filtro_Melectiva" type="hidden" value="<cfif isdefined('Form.Filtro_Melectiva')>#form.Filtro_Melectiva#</cfif>">
	<input name="Filtro_Mnombre" type="hidden" value="<cfif isdefined('Form.Filtro_Mnombre')>#form.Filtro_Mnombre#</cfif>">
	<input name="FNcodigoC" type="hidden" value="<cfif isdefined('form.FNcodigoC')>#form.FNcodigoC#</cfif>">
	<input name="FGcodigoC" type="hidden" value="<cfif isdefined('form.FGcodigoC')>#form.FGcodigoC#</cfif>">	
	</cfoutput>

	<table border="0" width="100%" align="center" cellpadding="0" cellspacing="0" style="margin:0">
		<tr> 
			<td class="tituloAlterno" colspan="4" align="center">
				<cfif modo eq "ALTA">
					Nueva Materia 
				<cfelse>
					Modificar Materia 
				</cfif>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td valign="middle" nowrap> 
				<cfif modo NEQ "ALTA">
					<cfoutput>#rsMateria.Mcodigo#</cfoutput> 
				<cfelse>
					<input name="Mcodigo" type="text" value="" size="10" maxlength="10" tabindex="1" alt="El código de la Materia">
				</cfif>
			</td>
			<td align="right" valign="middle" nowrap> Nombre:&nbsp;</td>
			<td valign="middle" nowrap> 
				<input name="Mnombre" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mnombre#</cfoutput></cfif>" size="30" maxlength="255" tabindex="1" alt="La descripci&oacute;n del Nivel">
			</td>
			<tr> 
				<td align="right" valign="middle" nowrap> Tipo Materia:&nbsp;</td>
				<td valign="middle" nowrap> 
					<select name="MTcodigo" id="MTcodigo" tabindex="1">
						<cfoutput query="rsMateriaTipo"> 
						<option value="#MTcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.MTcodigo EQ rsMateriaTipo.MTcodigo>selected</cfif>>#MTdescripcion#</option>
						</cfoutput> 
					</select>
				</td>
				<td align="right" valign="middle" nowrap> Modalidad:&nbsp;</td>
				<td valign="middle" nowrap> 
					<select name="Melectiva" tabindex="1" onChange="javascript: cambioMod(this)">
						<option value="R" <cfif modo NEQ "ALTA" AND "R" EQ rsMateria.Melectiva>selected</cfif>>Regular</option>
						<option value="S" <cfif modo NEQ "ALTA" AND "S" EQ rsMateria.Melectiva>selected</cfif>>Sustitutiva</option>
						<option value="E" <cfif modo NEQ "ALTA" AND "E" EQ rsMateria.Melectiva>selected</cfif>>Electiva</option>
						<option value="C" <cfif modo NEQ "ALTA" AND "C" EQ rsMateria.Melectiva>selected</cfif>>Complementaria</option>
					</select>
					<cfif modo NEQ "ALTA">
					<input name="MelectivaAnterior" type="hidden" id="MelectivaAnterior" value="<cfoutput>#rsMateria.Melectiva#</cfoutput>">
					<input name="NumAsociadas" type="hidden" id="NumAsociadas" value="<cfoutput>#rsAsociadas.asociadas#</cfoutput>">
				</cfif>
			</td>
		</tr>
		<tr> 
			<td align="right" valign="middle" nowrap>Tipo de Evaluaci&oacute;n:&nbsp;</td>
			<td valign="middle" nowrap> 
				<select name="Mtipoevaluacion" id="Mtipoevaluacion" tabindex="1">
					<option value="-1" <cfif (isDefined("rsMateria.Mtipoevaluacion") AND "0" EQ rsMateria.Mtipoevaluacion)>selected</cfif>>-- 
					Digitar Nota --</option>
					<cfoutput query="rsEvaluacionValoresTabla"> 
					<option value="#EVTcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.EVTcodigo EQ rsEvaluacionValoresTabla.EVTcodigo>selected</cfif>>Usar 
					Tabla: #EVTnombre#</option>
					</cfoutput> 
				</select>
			</td>
			<td align="right" valign="middle" nowrap> 
				<div id="Elect_o_Comp1">
					<input name="ConceptosEval" type="hidden" id="ConceptosEval2">
					Plan de Evaluación:&nbsp;
				</div>
			</td>
			<td valign="middle" nowrap> 
				<div id="Elect_o_Comp2">
					<select name="EPcodigo" id="select" tabindex="1" <cfif modo NEQ "ALTA">disabled</cfif>>
						<option value="">(Seleccione un Plan de Evaluación)</option>
						<cfoutput query="rsPlanesEval"> 
						<option value="#EPcodigo#" <cfif modo NEQ "ALTA" AND rsMateria.EPcodigo EQ rsPlanesEval.EPcodigo>selected</cfif>>#EPnombre#</option>
						</cfoutput> 
					</select>
				</div>	
			</td>
		</tr>
		<tr> 
			<td align="right" valign="middle" nowrap> Nivel:&nbsp;</td>
			<td valign="middle" nowrap> 
				<select name="Ncodigo" id="Ncodigo" tabindex="1" 
					onchange="javascript: cargarGrados(this, this.form.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Gcodigo#</cfoutput></cfif>', false)" >
					<cfoutput query="rsNiveles"> 
					<option value="#Ncodigo#" <cfif modo NEQ "ALTA" AND rsMateria.Ncodigo EQ rsNiveles.Ncodigo>selected</cfif>>#Ndescripcion#</option>
					</cfoutput> 
				</select>
			</td>
			<td align="right" valign="middle" nowrap><div id="sustit1"> Grado:&nbsp;</div></td>
			<td valign="middle" nowrap>
				<div id="sustit2">
					<select name="Gcodigo" id="Gcodigo" tabindex="1">
						<cfoutput query="rsGrado"> 
						<option value="#Codigo#">#rsGrado.Gdescripcion#</option>
						</cfoutput> 
					</select>
				</div>
			</td>
		</tr>
		<tr> 
			<td align="right" valign="middle" nowrap>Cr&eacute;ditos:&nbsp;</td>
			<td valign="middle" nowrap> 
				<input name="Mcreditos" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mcreditos#</cfoutput></cfif>" size="8" maxlength="3" style="text-align: right;" alt="Los créditos de la Materia"  onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			<td align="right" valign="middle" nowrap>Horas:&nbsp;</td>
			<td valign="middle" nowrap> 
				<input name="Mhoras" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mhoras#</cfoutput></cfif>" size="8" maxlength="3" style="text-align: right;" alt="Las Horas de la Materia"  onBlur="javascript: fm(this,0);" onFocus="javascript: this.value=qf(this); this.select();" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			<!--- <cfif modo NEQ "ALTA" and rsHayGrupos.recordCount NEQ 0>disabled</cfif> --->
		</tr>
		<tr>
			<td align="right" valign="middle" nowrap>Orden:&nbsp;</td>
			<td valign="middle" nowrap> 
				<input name="Morden" type="text" id="Morden" tabindex="1" size="8" maxlength="8"  style="text-align: right;"
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Morden#</cfoutput></cfif>" 
				onfocus="javascript:this.value=qf(this); this.select();" 
				onblur="javascript:fm(this,0);"  
				onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
			<td align="right" nowrap>
				<input type="checkbox" name="Mactiva1" id="Mactiva1"  value="<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mactiva#</cfoutput></cfif>" 
					<cfif modo NEQ "ALTA"><cfif #rsMateria.Mactiva# EQ 1> checked </cfif><cfelseif modo EQ "ALTA">checked</cfif>
					size="32"   onClick="javascript:MateriaActiva();">
			</td>
			<td valign="middle" nowrap><label for="Mactiva1">Activa</label></td>
		</tr>
		<tr> 
			<td align="right" valign="top" nowrap>Observaciones:&nbsp; </td>
			<td valign="top" nowrap> 
				<textarea name="Mobservaciones" cols="37" rows="3" id="Mobservaciones" tabindex="1"><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsMateria.Mobservaciones)#</cfoutput></cfif></textarea>
			</td>
			<td align="right" valign="top" nowrap>Reglamentos:&nbsp; </td>
			<td valign="top" nowrap> 
				<textarea name="Mreglamentos" cols="37" rows="3" id="Mreglamentos" tabindex="1"><cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Mreglamentos#</cfoutput></cfif></textarea>
			</td>
		</tr>
		<tr><td colspan="4" >&nbsp;</td></tr>
		<tr> 
			<td colspan="4" align="center" valign="baseline" nowrap> 
				<!--- LINK PARA REGRESAR A LA LISTA CON LOS DATOS DEL FILTRO, SI SE HA FILTRADO --->
				<cfset Lvar_regresa = "listaMaterias.cfm?Pagina=" & form.Pagina & 
				"&Filtro_Mcodigo=" & form.Filtro_Mcodigo & 
				"&Filtro_Melectiva=" & form.Filtro_Melectiva & 
				"&Filtro_Mnombre=" & form.Filtro_Mnombre & 
				"&Filtro_MTdescripcion=" & form.Filtro_MTdescripcion & 
				"&HFiltro_Mcodigo=" & form.HFiltro_Mcodigo & 
				"&HFiltro_Melectiva=" & form.HFiltro_Melectiva & 
				"&HFiltro_Mnombre=" & form.HFiltro_Mnombre & 
				"&HFiltro_MTdescripcion=" & form.HFiltro_MTdescripcion &
				"&FNcodigoC=" & form.FNcodigoC &
				"&FGcodigoC=" & form.FGcodigoC>
				 <cfif isdefined('form.Mconsecutivo') and LEN(TRIM(form.Mconsecutivo))>
					<cfset Lvar_regresa = Lvar_regresa & "&Mconsecutivo=" & form.Mconsecutivo>
				</cfif>	
				<cfif modo NEQ "ALTA">
					<cfif rsMateria.Melectiva EQ "R" or rsMateria.Melectiva EQ "S">
						<!--- <input type="submit" name="Detalle" value="Detalle" onClick="javascript: irADetalle(this.form);"> --->
						<cf_botones modo="#modo#" include="Detalle" Regresar="#Lvar_regresa#"> 
					<cfelse>
						<cf_botones modo="#modo#" Regresar="#Lvar_regresa#"> 
					</cfif>
					<cfoutput>
					<input type="hidden" name="Mconsecutivo" value="#rsMateria.Mconsecutivo#">
					<input type="hidden" name="HayCurso" value="#rsHayCurso.recordCount#">
					<input type="hidden" name="HayMateriaElectiva" value="#rsHayMateriaElectiva.recordCount#">
					<input type="hidden" name="HayMateriaElectiva2" value="#rsHayMateriaElectiva2.recordCount#">
					<input type="hidden" name="HayGradoSustitutivas" value="#rsHayGradoSustitutivas.recordCount#">
					<input type="hidden" name="HayEvaluacionConceptoMateria" value="#rsHayEvaluacionConceptoMateria.recordCount#">
					
					</cfoutput>
				<cfelse>
					<cf_botones modo="#modo#" Regresar="#Lvar_regresa#"> 
				</cfif>
				<input type="hidden" name="Mactiva" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsMateria.Mactiva#</cfoutput></cfif>">
			</td>
		</tr>
	</table>
 
 </form>
<cf_qforms> 
<script language="JavaScript" type="text/JavaScript">
	obtenerGrados(document.form1);
	cargarGrados(document.form1.Ncodigo, document.form1.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsMateria.Gcodigo#</cfoutput></cfif>', false);

	function habilitarValidacion() {
		<cfif modo EQ "ALTA">
			objForm.Mcodigo.required = true;
			objForm.Mnombre.required = true;
			objForm.MTcodigo.required = true;
			objForm.Ncodigo.required = true;
			objForm.Gcodigo.required = true;
			objForm.Mhoras.required = true;
			objForm.Mcreditos.required = true;
			objForm.Mtipoevaluacion.required = true;
			objForm.EPcodigo.required = true;
		<cfelseif modo EQ "CAMBIO">
			objForm.Mnombre.required = true;
			objForm.MTcodigo.required = true;
			objForm.Ncodigo.required = true;
			objForm.Gcodigo.required = true;
			objForm.Mhoras.required = true;
			objForm.Mcreditos.required = true;
			objForm.Mtipoevaluacion.required = true;
		</cfif>
	}

	function deshabilitarValidacion() {
		<cfif modo EQ "ALTA">
			objForm.Mcodigo.required = false;
			objForm.Mnombre.required = false;
			objForm.MTcodigo.required = false;
			objForm.Ncodigo.required = false;
			objForm.Gcodigo.required = false;
			objForm.Mhoras.required = false;
			objForm.Mcreditos.required = false;
			objForm.Mtipoevaluacion.required = false;
			objForm.EPcodigo.required = false;
		<cfelseif modo EQ "CAMBIO">
			objForm.Mnombre.required = false;
			objForm.MTcodigo.required = false;
			objForm.Ncodigo.required = false;
			objForm.Gcodigo.required = false;
			objForm.Mhoras.required = false;
			objForm.Mcreditos.required = false;
			objForm.Mtipoevaluacion.required = false;
		</cfif>
	}

    // Se aplica la descripcion del Grado 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				//alert(new Number(this.obj.form.HayCurso.value));
				if (new Number(this.obj.form.HayCurso.value) > 0) {
					msg = msg + "curso"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar la Materia " + this.obj.form.Mnombre.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.Mnombre.focus();
				}
		}
	}

	function __isMateriasAsociadas() {
		if (btnSelected("Cambio", this.obj.form)) {
			if ((this.obj.form.MelectivaAnterior.value=='E' || this.obj.form.MelectivaAnterior.value =='S' || this.obj.form.MelectivaAnterior.value =='C') 
					&& (new Number(this.obj.form.NumAsociadas.value) > 0) && (this.obj.form.MelectivaAnterior.value != this.obj.form.Melectiva.value)) {
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
	
	_addValidator("isMateriasAsociadas", __isMateriasAsociadas);
	_addValidator("isTieneDependencias", __isTieneDependencias);

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
		objForm.Mtipoevaluacion.required = true;
		objForm.Mtipoevaluacion.description = "Tipo de Evaluación";
		objForm.EPcodigo.required = true;
		objForm.EPcodigo.description = "Plan de Evaluación";
	<cfelseif modo EQ "CAMBIO">
		objForm.Mnombre.required = true;
		objForm.Mnombre.description = "Nombre de Materia";
		objForm.Mnombre.validateTieneDependencias();
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
		objForm.Mtipoevaluacion.required = true;
		objForm.Mtipoevaluacion.description = "Tipo de Evaluación";
		objForm.EPcodigo.description = "Plan de Evaluación";
	</cfif>

	cambioMod(document.form1.Melectiva);
	MateriaActiva(document.form1.Mactiva1);
	<cfif modo NEQ "ALTA">
		document.form1.Ncodigo.disabled = true;
	</cfif>
</script>
