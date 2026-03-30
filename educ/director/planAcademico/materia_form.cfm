<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif (form.modo EQ "CAMBIO" OR form.modo EQ "MPcambio" OR form.modo EQ "MPcambioE") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,Mcodigo) as Mcodigo
			, convert(varchar,CILcodigo) as CILcodigo
			, Mtipo
			, Mcodificacion
			, Mnombre
			, Mactivo
			, Mexterna
			, Mcreditos
			, MhorasTeorica
			, MhorasEstudio
			, MhorasPractica
			, convert(varchar,EScodigo) as EScodigo
			, convert(varchar,GAcodigo) as GAcodigo
			, Mrequisitos
			, MotrasCarreras
			, McualquierCarrera
			, McursoLibre
			, ts_rversion
		from Materia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery> 	
	<cfquery datasource="#Session.DSN#" name="rsEsRequisito">
		select count(*) as cant from MateriaRequisito where McodigoRequisito  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfquery datasource="#Session.DSN#" name="rsEsElegible">
		select count(*) as cant from MateriaElegible where McodigoElegible  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayMateriaPlan">
		select count(*) as cant from MateriaPlan where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayCurso">
		select count(*) as cant from Curso where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayDocenteMateria">
		select count(*) as cant from DocenteMateria where Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfquery name="rsPlanEval" datasource="#session.DSN#">
	Select convert(varchar,PEVcodigo) as PEVcodigo
		, convert(varchar(30),PEVnombre) + case when datalength(PEVnombre) > 30 then '...' end as PEVnombre
	from PlanEvaluacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by PEVnombre
</cfquery>

<cfquery name="qryCodificacion" datasource="#Session.DSN#">
	Select Mcodificacion
	from Materia
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
	order by Mcodificacion
</cfquery>

<cfquery name="qryGradoAcad" datasource="#Session.DSN#">
	Select convert(varchar, GAcodigo) as GAcodigo,GAnombre 
	from GradoAcademico
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
	order by GAorden, GAnombre
</cfquery>

<cfquery name="qryCicloLect" datasource="#Session.DSN#">
	Select 
		(convert(varchar,isnull(TRcodigo,-1)) + '~' +
		convert(varchar,isnull(PEVcodigo,-1)) + '~' +
		CILtipoCalificacion + '~' +
		convert(varchar,isnull(CILpuntosMax,-1)) + '~' +
		convert(varchar,isnull(CILunidadMin,-1)) + '~' +
		isnull(convert(varchar, CILredondeo), '-1') + '~' +
		convert(varchar,isnull(TEcodigo,-1)) + '~' +
		convert(varchar,CILcodigo)) as CILcodigo
		, CILnombre
	from CicloLectivo
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by CILnombre
</cfquery>

<cfinclude template="/educ/queries/qryEscuela.cfm">

<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/sif.css">
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formMaterias" method="post" action="materia_SQL.cfm" onSubmit="return validaCodificacion();" style="margin: 0">
	<cfoutput>
		<cfif modo neq 'ALTA'>
			<!--- Parametros del mantenimiento de Materia Plan --->
			<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
				<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
			</cfif>
			<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
				<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
			</cfif>
			<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
				<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
			</cfif>
			<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
				<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
			</cfif>
			<cfif isdefined('form.modo') and form.modo NEQ ''>
				<input name="modo" type="hidden" value="#form.modo#">  
				<input name="nivel" type="hidden" value="2">
			</cfif>
			<input name="TabsPlan" type="hidden" value="3">
			 <!--- ********************************* --->
			<cfset ts = "">	
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsForm.Mcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="EsRequisito"  value="#rsEsRequisito.cant#">						
			<input type="hidden" name="EsElegible"  value="#rsEsElegible.cant#">
			<input type="hidden" name="HayMateriaPlan"  value="#rsHayMateriaPlan.cant#">
			<input type="hidden" name="HayCurso"  value="#rsHayCurso.cant#">
			<input type="hidden" name="HayDocenteMateria"  value="#rsHayDocenteMateria.cant#">
		</cfif>
		<input type="hidden" name="Mrequisitos" value="">
		<input type="hidden" name="TRcodigo" value="">
		<input type="hidden" name="PEVcodigo" value="">				
		<input type="hidden" name="MtipoCalificacion" value="">		
		<input type="hidden" name="MpuntosMax" value="">		
		<input type="hidden" name="MunidadMin" value="">		
		<input type="hidden" name="Mredondeo" value="">		
		<input type="hidden" name="TEcodigo" value="">
		<input type="hidden" name="CILcodigo" value="">						

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">
				<cfif modo EQ "ALTA">
					Nueva 
				<cfelse>
					Modificar 
				</cfif>
				Materia
				<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false"> 			
			</td>
		  </tr>
		  <tr>
			<td width="38%" align="right"><strong>#session.parametros.Escuela#:</strong></td>
			<td width="2%">&nbsp;</td>
			<td width="60%"><select name="EScodigo" id="EScodigo" onChange="javascript: cambioEscuela(this);" tabindex="1">
              <cfloop query="rsEscuela">
                <option value="#rsEscuela.EScodigo#" <cfif modo NEQ 'ALTA' and rsForm.EScodigo EQ rsEscuela.EScodigo> selected</cfif>>#rsEscuela.ESnombre#</option>
              </cfloop>
            </select></td>
		  </tr>
		  <tr>
			<td align="right"><strong>Tipo:</strong></td>
			<td>&nbsp;</td>
			<td><strong>
			  <select name="Mtipo" id="Mtipo" tabindex="2" disabled> <!---  onChange="javascript: cambioTipo(this);" --->
                <option value="M" <cfif isdefined('form.T') and form.T EQ 'M'> selected</cfif>>Regular</option>
                <option value="E" <cfif isdefined('form.T') and form.T EQ 'E'> selected</cfif>>Electiva</option>
              </select>
			</strong></td>
		  </tr>
		  <tr>
			<td align="right"><strong>C&oacute;digo:</strong></td>
			<td>&nbsp;</td>
			<td><input name="Mcodificacion" type="text" id="Mcodificacion" tabindex="3" value="<cfif modo NEQ "ALTA">#rsForm.Mcodificacion#</cfif>" size="15" maxlength="15" alt="El c&oacute;digo de la materia" <cfif modo NEQ "ALTA">readonly</cfif>></td>
		  </tr>		  
		  <tr>
			<td align="right"><strong>Nombre:</strong></td>
			<td>&nbsp;</td>
			<td><input name="Mnombre" type="text" value="<cfif modo NEQ "ALTA">#rsForm.Mnombre#</cfif>" size="50" maxlength="50" tabindex="4" alt="La descripci&oacute;n del Nivel"></td>
		  </tr>
		  <tr>
			<td align="right"><strong>Grado Acad&eacute;mico:</strong></td>
			<td>&nbsp;</td>
			<td><select name="GAcodigo" id="GAcodigo" tabindex="5">
              <option value="-1" >-- Ninguno --</option>
              <cfloop query="qryGradoAcad">
                <option value="#qryGradoAcad.GAcodigo#" <cfif modo NEQ 'ALTA' and rsForm.GAcodigo EQ qryGradoAcad.GAcodigo> selected</cfif>>#qryGradoAcad.GAnombre#</option>
              </cfloop>
            </select></td>
		  </tr>
		  <tr>
			<td align="right"><strong>Tipo de Ciclo Lectivo:</strong></td>
			<td>&nbsp;</td>
			<td><select name="CILcodigo_cb" id="CILcodigo_cb" onChange="javascript: cambiaCicloLec(this);">
              <cfloop query="qryCicloLect">
				<cfif modo NEQ 'ALTA'>
					<cfset ArrayCicloLect = ListToArray(qryCicloLect.CILcodigo,'~')>
				</cfif>

                <option value="#qryCicloLect.CILcodigo#" <cfif modo NEQ 'ALTA' and (ArrayLen(ArrayCicloLect) gt 0) and ArrayCicloLect[8] EQ rsForm.CILcodigo> selected</cfif>>#qryCicloLect.CILnombre#</option>
              </cfloop>
            </select></td>
		  </tr>
		  <tr>
			<td align="right"><strong>#Session.Parametros.Creditos#:</strong></td>
			<td>&nbsp;</td>
			<td><input name="Mcreditos" tabindex="9" style="text-align: right;" type="text" id="Mcreditos" size="5" maxlength="2" value="<cfif modo NEQ "ALTA">#rsForm.Mcreditos#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); poneCero(this);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
		  </tr>		  		  
		  <tr>
			<td align="right"><input title="Directores de otras #session.parametros.Escuela#s pueden incluir la Materia en los Planes de Estudios de sus Carreras" tabindex="7" name="MotrasCarreras" type="checkbox" id="MotrasCarreras2" value="1" <cfif modo NEQ 'ALTA' and rsForm.MotrasCarreras EQ 1> checked</cfif>></td>
			<td>&nbsp;</td>
			<td>		    <strong>Se puede utilizar en Carreras de otras #session.parametros.Escuela#s</strong></td>
		  </tr>
		  <tr>
			<td align="right"><input title="Estudiantes de cualquier Carrera pueden matricular la Materia aunque no esté en sus Planes de Estudio" tabindex="7" name="McualquierCarrera" type="checkbox" id="McualquierCarrera" value="1" <cfif modo NEQ 'ALTA' and rsForm.McualquierCarrera EQ 1> checked</cfif>></td>
			<td>&nbsp;</td>
			<td>		    <strong>Se puede matricular en cualquier carrera</strong></td>
		  </tr>
		  <tr>
			<td align="right"><strong>
			  <input type="checkbox" name="McursoLibre" tabindex="8" title="Cualquier estudiante puede matricular la Materia aunque no esté en sus Planes de Estudio o no esté inscrito en ninguna Carrera" value="1" <cfif modo NEQ 'ALTA' and rsForm.McursoLibre EQ 1> checked</cfif>>
			</strong></td>
			<td>&nbsp;</td>
			<td>			<strong>Curso Libre</strong></td>
		  </tr>
		  <tr>
			<td align="right"><strong>
			  <input name="Mactivo" tabindex="6" type="checkbox" id="Mactivo" value="1" <cfif modo NEQ 'ALTA' and rsForm.Mactivo EQ 1> checked<cfelseif modo EQ 'ALTA'> checked</cfif>>
			</strong></td>
			<td>&nbsp;</td>
			<td><strong>Activa</strong></td>
		  </tr>
		  <tr>
            <td align="right"><strong>
              <input name="Mexterna" tabindex="6" type="checkbox" id="Mexterna" value="1" <cfif modo NEQ 'ALTA' and rsForm.Mexterna EQ 1> checked</cfif>>
            </strong></td>
            <td>&nbsp;</td>
            <td><strong>Externa</strong></td>
	      </tr>
		  <tr id="horas1">
			<td align="right"><strong>Horas del Curso:</strong></td>
			<td>&nbsp;</td>
			<td>
				Te&oacute;ricas:&nbsp;
				<input name="MhorasTeorica" tabindex="11" style="text-align: right;" type="text" id="MhorasTeorica" size="5" maxlength="3" value="<cfif modo NEQ "ALTA">#rsForm.MhorasTeorica#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); poneCero(this);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				&nbsp;&nbsp;
				Pr&aacute;cticas:&nbsp;
               	<input name="MhorasPractica" style="text-align: right;" tabindex="12" type="text" id="MhorasPractica2" size="5" maxlength="3" value="<cfif modo NEQ "ALTA">#rsForm.MhorasPractica#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); poneCero(this);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		  </tr>
		  <tr id="horas2">
			<td align="right"><strong>Horas de Estudio Individual:</strong></td>
			<td>&nbsp;</td>
			<td><input name="MhorasEstudio" tabindex="13" style="text-align: right;" type="text" id="MhorasEstudio2" size="5" maxlength="3" value="<cfif modo NEQ "ALTA">#rsForm.MhorasEstudio#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); poneCero(this);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		  </tr>		  		  		  		  		  		  
		  <tr>
			<td colspan="3" align="center">
				<cfset mensajeDelete = "¿Desea Eliminar esta materia ?">
				<cfinclude template="/educ/portlets/pBotones.cfm"> 
				<input name="btnLista" type="button" id="btnLista2" value="Ir a Lista" onClick="javascript: listaMaterias();"> 			
			</td>
		  </tr>		  		  		  		  		  
		</table>
  </cfoutput>
</form>
<cfif modo NEQ 'ALTA'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr align="center" valign="top">
      <td>
        <table width="90%" border="0" cellspacing="0" cellpadding="0">
          <tr align="center">
            <td>&nbsp;</td>
          </tr>		
          <tr align="center">
            <td bgcolor="#DBDBB7"> 
				<strong>
				<cfif isdefined('form.T') and form.T EQ 'M'>
					Requisitos de la Materia			
				<cfelse>
					Materias Elegibles
				</cfif>
				</strong> </td>
          </tr>
          <tr align="center" id="divReqRegulares">
            <td valign="top">
              <cfinclude template="materiaRequisitos.cfm">
            </td>
          </tr>
          <tr align="center" id="divReqElectivas">
            <td valign="top">
				<cfinclude template="materiaElegibles.cfm">
            </td>
          </tr>
        </table>
      </td>
    </tr>
<!---     <tr align="center">
      <td>&nbsp;</td>
    </tr>	  	
    <tr align="center">
      <td bgcolor="#DBDBB7">	
	  	<strong>Temas por materia</strong>
      </td>
    </tr>	  ---> 
  </table>
</cfif>  

<script language="JavaScript">
//---------------------------------------------------------------------------------------
	<cfif modo EQ "ALTA">
		var EscuelaList = "<cfoutput>#ValueList(rsEscuela.EScodPref_cod,',')#</cfoutput>"
		var EscuelaArray = EscuelaList.split(",");
		var CodEscuelaSel = "";
	</cfif>
//---------------------------------------------------------------------------------------				
	function cambioEscuela(obj){
		<cfif modo EQ "ALTA">	
			var codigosArray = null;
			for (var i=0; i<EscuelaArray.length; i++) {
				codigosArray = EscuelaArray[i].split("~");
				
				if(codigosArray[1] == obj.value){
					CodEscuelaSel = codigosArray[0];
					document.formMaterias.Mcodificacion.value=CodEscuelaSel;
					break;
				}
			}	
		</cfif>		
	}
//---------------------------------------------------------------------------------------			
	function cambiaCicloLec(obj){
		var codigos = obj.value.split('~');

		if(codigos.length > 0){
			document.formMaterias.TRcodigo.value = codigos[0];
			document.formMaterias.PEVcodigo.value = codigos[1];
			document.formMaterias.MtipoCalificacion.value = codigos[2];
			document.formMaterias.MpuntosMax.value = codigos[3];
			document.formMaterias.MunidadMin.value = codigos[4];
			document.formMaterias.Mredondeo.value = codigos[5];
			document.formMaterias.TEcodigo.value = codigos[6];
			document.formMaterias.CILcodigo.value = codigos[7];		
		}else{
			document.formMaterias.TRcodigo.value = '';
			document.formMaterias.PEVcodigo.value = '';
			document.formMaterias.MtipoCalificacion.value = '';
			document.formMaterias.MpuntosMax.value = '';
			document.formMaterias.MunidadMin.value = '';
			document.formMaterias.Mredondeo.value = '';
			document.formMaterias.TEcodigo.value = '';
			document.formMaterias.CILcodigo.value = '';
		}
	}
//---------------------------------------------------------------------------------------		
	function listaMaterias(){
	<cfif isdefined("form.PEScodigo") and form.PEScodigo NEQ ''>
		document.formMaterias.modo.value='CAMBIO';
		document.formMaterias.action='CarrerasPlanes.cfm';
		document.formMaterias.submit();
	<cfelse>
		location.href='materia.cfm?T=<cfif isdefined('form.T') and form.T EQ 'M'>M<cfelse>E</cfif>';
	</cfif>
	}
//---------------------------------------------------------------------------------------		
	function validaCodificacion(){
		if(btnSelected('Alta',document.formMaterias) || btnSelected('Cambio',document.formMaterias)){
			if(document.formMaterias.Mcodificacion.value != '') {
				var existeMcodific = false;

				var ordenList = "<cfoutput>#ValueList(qryCodificacion.Mcodificacion,'~')#</cfoutput>"
				var ordenArray = ordenList.split("~");
				for (var i=0; i<ordenArray.length; i++) {
					<cfif modo NEQ "ALTA">
						if ((ordenArray[i] == document.formMaterias.Mcodificacion.value) && (ordenArray[i] != '<cfoutput>#rsForm.Mcodificacion#</cfoutput>')) {
					<cfelse>
						if (ordenArray[i] == document.formMaterias.Mcodificacion.value) {
					</cfif>
						existeMcodific = true;
						break;
					}
				}
				if (existeMcodific){
					alert('Error, el código de la materia ya existe, favor digitar uno diferente');
					document.formMaterias.Mcodificacion.focus();
					return false;
				}
			}else{
				if(btnSelected("Cambio",document.formMaterias)){
					document.formMaterias.Mcodificacion.value = "<cfif isdefined('rsForm')><cfoutput>#rsForm.Mcodificacion#</cfoutput></cfif>";
				}
			}
		}
		
		document.formMaterias.Mtipo.disabled = false;
		
		return true;
	}
//---------------------------------------------------------------------------------------		
	function cambioTipo(obj){
		var divHoras1 	= document.getElementById('horas1');		
		var divHoras2 	= document.getElementById('horas2');		
						
		<cfif modo NEQ 'ALTA'>	
			var divReqElect = document.getElementById('divReqElectivas');
			var divReqRegul  = document.getElementById('divReqRegulares');
			
			if (obj.value == 'M') {//	Requisitos para materia Regular
				divReqRegul.style.display = '';
				divReqElect.style.display  = 'none';			
			}else{
				if(obj.value == 'E'){//	Requisitos para materia Electiva
					divReqRegul.style.display = 'none';
					divReqElect.style.display  = '';				
				}
			}				
		</cfif>
		
		if (obj.value == 'M') {//	Requisitos para materia Regular
			divHoras1.style.display = '';
			divHoras2.style.display = '';		
		}else{
			if(obj.value == 'E'){//	Requisitos para materia Electiva
				divHoras1.style.display = 'none';
				divHoras2.style.display = 'none';						
			}
		}		
	}
//---------------------------------------------------------------------------------------		
	function poneCero(obj){
		if(obj.value == '')
			obj.value = 0;
	}
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacion() {
		objForm.Mnombre.required = false;
		objForm.Mcodificacion.required = false;
		objForm.Mtipo.required = false;
		objForm.CILcodigo_cb.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Mnombre.required = true;
		objForm.Mcodificacion.required = true;
		objForm.Mtipo.required = true;		
		objForm.CILcodigo_cb.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion de la materia 
	function __isValidaCodigo() {
		if(btnSelected("Alta", this.obj.form)) {
			if(this.value == CodEscuelaSel){
				this.error = "El campo del Código no debe ser igual que el prefijo de la <cfoutput>#session.parametros.Escuela#</cfoutput>";
				this.obj.focus();				
			}
		}
	}	
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion de la materia 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que la materia no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.EsRequisito.value) > 0) {
				msg = msg + " es requisito de otras materias"
			}
			if (new Number(this.obj.form.EsElegible.value) > 0) {
				if(msg != ''){
					msg = msg + ", ademas que es elegible por otras materias";
				}else{
					msg = msg + " es elegible por otras materias"				
				}
			}	
			if (new Number(this.obj.form.HayMateriaPlan.value) > 0) {
				if(msg != ''){
					msg = msg + ", ademas que ya pertenece a un plan";
				}else{
					msg = msg + " ya pertenece a un plan"				
				}
			}					
			if (new Number(this.obj.form.HayCurso.value) > 0) {
				if(msg != ''){
					msg = msg + ", ademas que ya pertenece a un curso";
				}else{
					msg = msg + " ya pertenece a un curso"				
				}
			}			
			if (new Number(this.obj.form.HayDocenteMateria.value) > 0) {
				if(msg != ''){
					msg = msg + ", ademas que ya esta asociada a un docente";
				}else{
					msg = msg + " ya esta asociada a un docente"				
				}
			}			
			if (new Number(this.obj.form.HayDocenteMateria.value) > 0) {
				if(msg != ''){
					msg = msg + ", ademas que ya esta asociada a un docente";
				}else{
					msg = msg + " ya esta asociada a un docente"				
				}
			}			
			if (msg != ""){
				this.error = "Usted no puede eliminar el Concepto de evaluación '" + this.obj.form.Mnombre.value + "' porque esta materia " + msg + ".";
				this.obj.form.Mnombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);	
	_addValidator("isValidaCodigo", __isValidaCodigo);		
	objForm = new qForm("formMaterias");
//---------------------------------------------------------------------------------------

	objForm.Mnombre.required = true;
	objForm.Mnombre.description = "Nombre";
	objForm.Mcodificacion.required = true;
	objForm.Mcodificacion.description = "Codificación";	
	objForm.Mtipo.required = true;
	objForm.Mtipo.description = "Tipo";	
	objForm.EScodigo.required = true;
	objForm.EScodigo.description = "<cfoutput>#session.parametros.Escuela#</cfoutput>";	
	objForm.Mnombre.validateTieneDependencias();		
	objForm.CILcodigo_cb.required = true;
	objForm.CILcodigo_cb.description = "Tipo de Ciclo Lectivo";	
		
	cambioTipo(document.formMaterias.Mtipo);
	<cfif modo EQ "ALTA">
		cambioEscuela(document.formMaterias.EScodigo);
	</cfif>
	objForm.Mcodificacion.validateValidaCodigo();
	cambiaCicloLec(document.formMaterias.CILcodigo_cb);
</script>
