<!---  Consultas para llenar los combos  --->
<cfif isdefined("Session.RolActual") and Session.RolActual EQ 11>
	<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
		set nocount on
		select
			(convert(varchar, g.Ncodigo)+'$'+convert(varchar, gr.GRcodigo)) as Codigo
			, gr.GRnombre as Nombre
			, n.Norden
			, g.Gorden
		from Nivel n, Grado g, Grupo gr, PeriodoVigente pv
		where n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and n.Ncodigo = g.Ncodigo
			and g.Gcodigo = gr.Gcodigo
			and gr.PEcodigo = pv.PEcodigo
			and gr.SPEcodigo = pv.SPEcodigo
		union
		select 
			(convert(varchar, m.Ncodigo)+'$0') as Codigo
			, ('Cursos Electivos del Nivel: ' + Ndescripcion) as Nombre
			, 0
			, 0
		from Curso c, Materia m, Nivel n, PeriodoVigente pvEle
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'S'
			and m.Ncodigo = n.Ncodigo
			and c.PEcodigo = pvEle.PEcodigo
			and c.SPEcodigo = pvEle.SPEcodigo
		order by 3, 4, 2
		set nocount off
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
		set nocount on
		select 	(convert(varchar,m.Ncodigo)+'$'+convert(varchar,c.Ccodigo)) as codCurso
				, (convert(varchar,g.GRcodigo)+'$'+Mnombre) as nombCurso
		from Curso c, Materia m, Grupo g, PeriodoVigente v
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'R'
			and c.GRcodigo = g.GRcodigo
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
		union
		select 	(convert(varchar,m.Ncodigo)+'$'+convert(varchar,c.Ccodigo)) as codCurso
				, ('0'+'$'+Cnombre) as nombCurso
		from Curso c, Materia m, PeriodoVigente v
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'S'
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
		order by 2
		set nocount off
	</cfquery>

<cfelse>
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_cod"
	 returnvariable="usr">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
	</cfinvoke>

	<cfquery datasource="#Session.Edu.DSN#" name="rsGrupos">
		set nocount on
		select
			(convert(varchar, g.Ncodigo)+'$'+convert(varchar, gr.GRcodigo)) as Codigo
			, gr.GRnombre as Nombre
			, n.Norden
			, g.Gorden
		from Grupo gr, Nivel n, Grado g, PeriodoVigente pv, Curso c, Materia d, Staff s
		where n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and gr.Gcodigo = g.Gcodigo
			and gr.PEcodigo = pv.PEcodigo
			and gr.SPEcodigo = pv.SPEcodigo
			and g.Ncodigo = n.Ncodigo
			and c.PEcodigo = gr.PEcodigo
			and c.SPEcodigo = gr.SPEcodigo
			and d.Mconsecutivo = c.Mconsecutivo
			and d.Ncodigo = gr.Ncodigo
			and d.Gcodigo = gr.Gcodigo
			and d.Melectiva = 'R'
			and c.Splaza = s.Splaza
		union
		select 
			(convert(varchar, m.Ncodigo)+'$0') as Codigo
			, ('Cursos Electivos del Nivel: ' + Ndescripcion) as Nombre
			, 0
			, 0
		from Curso c, Materia m, Nivel n, PeriodoVigente pvEle, Staff s
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
		and c.Mconsecutivo = m.Mconsecutivo
		and m.Melectiva = 'S'
		and m.Ncodigo = n.Ncodigo
		and c.PEcodigo = pvEle.PEcodigo
		and c.SPEcodigo = pvEle.SPEcodigo
		and c.Splaza = s.Splaza
		order by 3, 4, 2
		set nocount off
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsCursos">
		set nocount on
		select 	(convert(varchar,m.Ncodigo)+'$'+convert(varchar,c.Ccodigo)) as codCurso
				, (convert(varchar,g.GRcodigo)+'$'+Mnombre) as nombCurso
		from Curso c, Materia m, Grupo g, PeriodoVigente v, Staff s
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'R'
			and c.GRcodigo = g.GRcodigo
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
			and c.Splaza = s.Splaza
		union
		select 	(convert(varchar,m.Ncodigo)+'$'+convert(varchar,c.Ccodigo)) as codCurso
				, ('0'+'$'+Cnombre) as nombCurso
		from Curso c, Materia m, PeriodoVigente v, Staff s
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and c.Mconsecutivo = m.Mconsecutivo
			and m.Melectiva = 'S'
			and m.Ncodigo = v.Ncodigo
			and c.PEcodigo = v.PEcodigo
			and c.SPEcodigo = v.SPEcodigo
			and c.Splaza = s.Splaza
		order by 2
		set nocount off
	</cfquery>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodos">
	select c.PEcodigo, (convert(varchar, c.Ncodigo)+'$'+c.PEdescripcion) as PEdescripcion
	from PeriodoEvaluacion c
	order by c.Ncodigo, c.PEorden
</cfquery>


<script language="JavaScript" type="text/javascript" src="/cfmx/edu/asistencia/utilitarios/js/copiaTemaEval.js">//</script>
<form name="formCopiaTem" method="post" action="/cfmx/edu/asistencia/utilitarios/SQLcopiaTemaEval.cfm">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" align="center" valign="middle" class="SubTitulo">Copia de:</td>
    </tr>  
    <tr> 
      <td width="26%">Grupo</td>
      <td width="74%">
	  	<select name="GRcodigoD" id="GRcodigoD" onChange="javascript: RellenarComboHijo(this, document.formCopiaTem.CcodigoD, ''); RellenarComboPeriodos(this, document.formCopiaTem.PEcodigo_IN, '');">
          <cfoutput query="rsGrupos"> 
            <option value="#rsGrupos.Codigo#">#rsGrupos.Nombre#</option>
          </cfoutput> 
		</select>
	  </td>
    </tr>
    <tr> 
      <td>Curso</td>
      	<td>
	  		<select name="CcodigoD" id="CcodigoD">
          		<cfoutput query="rsCursos"> 
            		<option value="#rsCursos.codCurso#">#rsCursos.nombCurso#</option>
				</cfoutput> 
			</select>
		</td>
    </tr>

	<script language="JavaScript" type="text/javascript">
		ObtenerCodigosCursos(document.formCopiaTem.CcodigoD);		
		RellenarComboHijo(document.formCopiaTem.GRcodigoD, document.formCopiaTem.CcodigoD, '');
	</script>	
	
    <tr> 
      <td>Per&iacute;odo de Evaluaci&oacute;n</td>
      <td><select name="PEcodigo_IN" id="PEcodigo_IN">
          <cfoutput query="rsPeriodos"> 
            <option value="#rsPeriodos.PEcodigo#">#rsPeriodos.PEdescripcion#</option>
          </cfoutput> </select></td>
    </tr>
	
	<script language="JavaScript" type="text/javascript">
		ObtenerCodigosPeriodos(document.formCopiaTem.PEcodigo_IN);
		RellenarComboPeriodos(document.formCopiaTem.GRcodigoD, document.formCopiaTem.PEcodigo_IN, '');
	</script>		
	
    <tr> 
      <td colspan="2" class="SubTitulo" align="center" valign="middle"> Copia 
        a:</td>
    </tr>
    <tr> 
      <td>Grupo</td>
      <td>
			<select name="GRcodigoDest" id="GRcodigoDest" onChange="RellenarComboHijo(this, document.formCopiaTem.CcodigoDest, ''); RellenarComboPeriodos(this, document.formCopiaTem.PEcodigo_OUT, '');">
				<cfoutput query="rsGrupos"> 
            		<option value="#rsGrupos.Codigo#">#rsGrupos.Nombre#</option>
          		</cfoutput> 
		 	</select>		
		</td>
    </tr>
    <tr> 
      	<td>Curso</td>
      	<td>
			<select name="CcodigoDest" id="CcodigoDest">
				<cfoutput query="rsCursos"> 
            		<option value="#rsCursos.codCurso#">#rsCursos.nombCurso#</option>
	          	</cfoutput> 
			</select>		
		</td>
    </tr>
	
	<script language="JavaScript" type="text/javascript">
		RellenarComboHijo(document.formCopiaTem.GRcodigoDest, document.formCopiaTem.CcodigoDest, '');
	</script>	
	
    <tr> 
      <td>Per&iacute;odo de Evaluaci&oacute;n</td>
      <td>
			<select name="PEcodigo_OUT" id="PEcodigo_OUT">
				<cfoutput query="rsPeriodos"> 
					<option value="#rsPeriodos.PEcodigo#">#rsPeriodos.PEdescripcion#</option>
				</cfoutput> 
			</select>		
		</td>
    </tr>
	
	<script language="JavaScript" type="text/javascript">
		RellenarComboPeriodos(document.formCopiaTem.GRcodigoDest, document.formCopiaTem.PEcodigo_OUT, '');
	</script>	
	
    <tr> 
      <td>Copia Temarios</td>
      <td><input name="temario" type="checkbox" id="temario" value="temario"></td>
    </tr>
    <tr> 
      <td>Copia Evaluaciones</td>
      <td><input name="evaluacion" type="checkbox" id="evaluacion" value="evaluacion"></td>
    </tr>
    <tr> 
      <td colspan="2"><hr></td>
    </tr>	
   <!---  <tr> 
      <td colspan="2" class="area"> Si copia las evaluaciones, &eacute;stas no 
        quedan autom&aacute;ticamente ligadas a los temas asociados. Este proceso 
        debe realizarse manualmente.</td>
    </tr> --->
    <tr> 
      <td colspan="2" align="center" valign="middle">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" valign="middle"><input name="btnCopiar" type="submit" id="btnCopiar" value="Copiar" onClick="javascript: setBtn(this);"></td>
    </tr>
  </table>
</form>

<script language="JavaScript" src="/cfmx/edu/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/edu/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script> 


<script language="JavaScript" type="text/javascript" >						
	function __isTemario() {
		if (btnSelected("btnCopiar")) {
			if (!(  ((this.obj.form.temario != null)&& (this.obj.form.temario.checked)) || ((this.obj.form.evaluacion != null) && (this.obj.form.evaluacion.checked)))) {
				this.error = "Debe seleccionar una o ambas opciones de copia, ya sea Temarios o Evaluaciones";
				this.obj.form.temario.focus();				
			}
		}
	}	
//------------------------------------------------------------------------------------------
	function __isCopiado() {
			if (btnSelected("btnCopiar")) {
			if ( (this.obj.value ==  this.obj.form.CcodigoDest.value) &&  (this.obj.form.PEcodigo_IN.value ==  this.obj.form.PEcodigo_OUT.value))
				this.error ="No puede copiar temarios o evaluaciones sobre el mismo Curso en el mismo Periodo.";
		}
	}	
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isCopiado", __isCopiado);
	_addValidator("isTemario", __isTemario);	
	objForm = new qForm("formCopiaTem");	
//------------------------------------------------------------------------------------------					
	objForm.GRcodigoD.required = true;
	objForm.GRcodigoD.description = "del Grupo";
	objForm.CcodigoD.required = true;
	objForm.CcodigoD.description = "del Curso";	
	objForm.PEcodigo_IN.required = true;
	objForm.PEcodigo_IN.description = "del Período de Evaluación";	
	objForm.GRcodigoDest.required = true;
	objForm.GRcodigoDest.description = "al Grupo";		
	objForm.CcodigoDest.required = true;
	objForm.CcodigoDest.description = "al Curso";		
	objForm.PEcodigo_OUT.required = true;
	objForm.PEcodigo_OUT.description = "al Período de Evaluación";		
	objForm.CcodigoD.validateCopiado();
	objForm.PEcodigo_IN.validateTemario();	
</script>
