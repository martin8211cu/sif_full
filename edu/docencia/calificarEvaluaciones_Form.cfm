<cfinclude template="/edu/docencia/commonDocencia.cfm">

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar")); 
  sbInitFromSession("cboOrdenamiento", "0");
  sbInitFromSessionChks("chkPorcentajesXConcepto","1");
  sbInitFromSessionChks("chkPorcentajesXPromedio","1");
  sbInitFromSessionChks("chkPromedioXComponente","1");
  sbInitFromSessionChks("chkCalcular","0");
</cfscript> 
 
<cfinclude template="/edu/docencia/qrysProfesorCursoPeriodo.cfm">

<cfquery datasource="#Session.Edu.DSN#" name="qryMateria">
    set nocount on
    select convert(varchar,EVTcodigo) as EVTcodigo, 
		convert(varchar,m.Mconsecutivo) as Mconsecutivo
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and c.Mconsecutivo = m.Mconsecutivo
       and c.GRcodigo *= g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
    set nocount off
</cfquery>
<cfset GvarTablaMateria = qryMateria.EVTcodigo>

<cfquery datasource="#Session.Edu.DSN#" name="qryComplementaria">
    set nocount on
    select convert(varchar,CC.Ccodigo) as Curso, convert(varchar,MC.Mconsecutivo) as Materia, 
		   convert(varchar,MC.EVTcodigo) as Tabla
      from Curso c, Materia m, MateriaElectiva ME, Curso CC, Materia MC
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and c.Mconsecutivo = m.Mconsecutivo
       and m.Melectiva    = 'R'
       and m.Mconsecutivo = ME.Mconsecutivo
       and ME.Melectiva    = MC.Mconsecutivo
       and MC.Mconsecutivo = CC.Mconsecutivo
       and MC.Melectiva    = 'C'
       and CC.CEcodigo     = c.CEcodigo
       and CC.PEcodigo     = c.PEcodigo
       and CC.SPEcodigo    = c.SPEcodigo
       and CC.GRcodigo     = c.GRcodigo
    set nocount off
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="qryValoresTabla">
  set nocount on
  select convert(varchar,EVTcodigo) as Tabla, EVvalor as Codigo, EVdescripcion as Descripcion, 
  	     EVorden as EVorden, 
         EVequivalencia as Equivalente, EVminimo as Minimo, EVmaximo as Maximo
    from EvaluacionValores vt
   where exists(
           select *
             from Curso c, 
                  EvaluacionConceptoCurso ecc, 
                  EvaluacionConcepto ec, 
                  EvaluacionCurso cec
            where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
              and c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
              and ecc.Ccodigo    = c.Ccodigo
              and ecc.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
              and ec.CEcodigo    = c.CEcodigo
              and ec.ECcodigo    = ecc.ECcodigo
              and cec.ECcodigo   = ec.ECcodigo
              and cec.Ccodigo    = c.Ccodigo
              and cec.PEcodigo   = ecc.PEcodigo
			  and vt.EVTcodigo   = cec.EVTcodigo
		   )
      <cfif GvarTablaMateria neq "">
      or vt.EVTcodigo = #GvarTablaMateria#
	  </cfif>		   
  set nocount off
</cfquery>

<cfif isDefined("form.btnGrabar")>
  <cfinclude template="/edu/docencia/calificarEvaluaciones_Grabar.cfm">
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="qryComponentes">
  set nocount on
  select convert(varchar,ec.ECcodigo) as CodigoEC,       ec.ECnombre as DescripcionEC,   
  	     str(ecc.ECCporcentaje,6,2) as PorcentajeEC, ec.ECorden as OrdenEC,
         convert(varchar,cec.ECcomponente) as CodigoCEC, cec.ECnombre as DescripcionCEC, 
		 str(cec.ECporcentaje,6,2) as PorcentajeCEC, 
		 str(ecc.ECCporcentaje*cec.ECporcentaje/100.0,6,2) as Porcentaje,
		 ecc.ECCporcentaje*cec.ECporcentaje/100.0 as PorcentajeDec,
		 (select isnull(max(n.ACcerrado),'0')
		    from AlumnoCalificacion n
           where n.CEcodigo     = c.CEcodigo
             and n.Ccodigo      = c.Ccodigo
             and n.ECcomponente = cec.ECcomponente
		 ) as Cerrado, 
		 cec.EVTcodigo as EVTcodigo
    from Curso c, 
         EvaluacionConceptoCurso ecc, 
         EvaluacionConcepto ec, 
         EvaluacionCurso cec
   where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
     and ecc.Ccodigo    = c.Ccodigo
     and ecc.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     and ec.CEcodigo    = c.CEcodigo
     and ec.ECcodigo    = ecc.ECcodigo
     and cec.ECcodigo   = ec.ECcodigo
     and cec.Ccodigo    = c.Ccodigo
     and cec.PEcodigo   = ecc.PEcodigo
  <cfif form.cboOrdenamiento eq 0>
  order by isnull(cec.ECreal, cec.ECplaneada), ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 1>
  order by ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
  order by cec.ECcomponente
  </cfif>
  set nocount off
</cfquery>

<cfquery dbtype="query" name="qryConceptos">
  select distinct CodigoEC, DescripcionEC, PorcentajeEC
    from qryComponentes
  order by OrdenEC
</cfquery>
<!-- Asegurarse que los alumnos esten activos, Aretirado = 0
Rodolfo Jimenez Jara, SOIN, CentroAmerica, 01/09/2003 -->
<cfquery datasource="#Session.Edu.DSN#" name="qryPeriodoCerrado">
  set nocount on
  select isnull(max(ACPEcerrado),'0') as Cerrado 
    from AlumnoCalificacionPerEval ac, Alumnos a
   where ac.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	 and ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
	 and a.CEcodigo = ac.CEcodigo
     and a.Ecodigo = ac.Ecodigo
     and a.Aretirado  = 0
	 
  set nocount off
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryCursoCerrado">
  set nocount on
  select isnull(max(ACCcerrado),'0') as Cerrado 
    from AlumnoCalificacionCurso ac, Alumnos a
   where ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
	 and a.CEcodigo = ac.CEcodigo
     and a.Ecodigo = ac.Ecodigo
     and a.Aretirado  = 0
  set nocount off
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="qryEstudiantes">
  set nocount on
  select convert(varchar,a.Ecodigo) as Codigo, 
  	     p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre, 
         str(ac.ACPEnotacalculada,6,2) as Ajuste, 
		 ac.ACPEvalorcalculado         as ValorAjuste, 
        (select isnull(max(ACPEcerrado),'0') from AlumnoCalificacionPerEval ac1, Alumnos alu
         where ac1.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
           and ac1.Ecodigo    = ac.Ecodigo
           and ac1.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
           and ac1.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and alu.CEcodigo = ac.CEcodigo
			and alu.Ecodigo = ac.Ecodigo
			and alu.Aretirado  = 0) as Cerrado 
    from AlumnoCalificacionCurso a, AlumnoCalificacionPerEval ac,
         Estudiante e, Alumnos alu,
         PersonaEducativo p
   where a.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona
     and ac.PEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     and ac.Ecodigo     =* e.Ecodigo
	 and ac.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and ac.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
	 and e.Ecodigo		= alu.Ecodigo
	 and alu.Aretirado  = 0
  order by p.Papellido1, p.Papellido2, p.Pnombre
  set nocount off
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="qryNotas">
  set nocount on
  select convert(varchar,c.CEcodigo) as Estudiante, str(n.ACnota,6,2) as Nota, 
  	     n.ACvalor as Valor, convert(varchar,cec.EVTcodigo) as Tabla,
        (select isnull(max(n2.ACcerrado),'0')
		    from AlumnoCalificacion n2, Alumnos alu
           where n2.CEcodigo     = a.CEcodigo
             and n2.Ccodigo      = a.Ccodigo
             and n2.ECcomponente = cec.ECcomponente
			 and alu.CEcodigo = n2.CEcodigo
			 and alu.Ecodigo = n2.Ecodigo
			 and alu.Aretirado  = 0
		 ) as Cerrado, cec.ECreal, cec.ECplaneada, ec.ECorden, cec.ECcomponente
    from Curso c,                          -- Curso
         EvaluacionConceptoCurso ecc,      -- Conceptos de Evaluacin de un Curso
         EvaluacionConcepto ec,            -- Catalogo Conceptos de Evaluaci n
		 EvaluacionCurso cec,              -- Componentes del Concepto de Evaluacin de un Curso
         AlumnoCalificacionCurso a,        -- Alumnos de un Curso
		 PersonaEducativo p,               -- Catalogos de Personas
		 Estudiante e,                     -- Join entre Alumno y Persona
         AlumnoCalificacion n,             -- Calificaciones Alumno por Componente
		 Alumnos alu
   where c.CEcodigo     = a.CEcodigo
     and c.Ccodigo      = a.Ccodigo
     and ecc.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
     and a.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
     and n.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and n.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
	 and alu.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	 and alu.Aretirado  = 0
     and ec.CEcodigo    = c.CEcodigo
     and ecc.Ccodigo    = c.Ccodigo
     and ecc.ECcodigo    = ec.ECcodigo
     and cec.ECcodigo   = ecc.ECcodigo
     and cec.Ccodigo    = ecc.Ccodigo
     and cec.PEcodigo   = ecc.PEcodigo
	 and e.Ecodigo		= alu.Ecodigo

     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona

     and a.Ecodigo        *= n.Ecodigo
     and a.CEcodigo       *= n.CEcodigo
     and a.Ccodigo        *= n.Ccodigo
     and cec.ECcomponente *= n.ECcomponente
  order by p.Papellido1, p.Papellido2, p.Pnombre,
  <cfif form.cboOrdenamiento eq 0>
           isnull(cec.ECreal, cec.ECplaneada), ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 1>
           ec.ECorden, cec.ECcomponente
  <cfelseif form.cboOrdenamiento eq 2>
           cec.ECcomponente
  </cfif>
  set nocount off
</cfquery>

<cfset LvarBorder = "border=1px solid ##CCCCCC;">
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        background-color: #FF0000;
        WIDTH: 20px;
        HEIGHT:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
        display: none;
      }
      .txtPar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        border:0;
      }
      .txtImpar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        wrap:  none;
        background-color:#D8E5F2;
        border:0;
      }
      .linEnc {
        background-color:#A9C6E1;
        height:38px; width:51px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncPrc {
        background-color:#A9C6E1;
        height:40px; width:51px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : center;
        vertical-align : middle;
      }
      .linEncProm {
        background-color:#A9C6E1;
        height:19px;
        font:  normal 10px Verdana, Arial, Helvetica, sans-serif;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        border-right:1px solid #FFFFFF;
        text-align : right;
      }
      .linEncEva {
        background-color:#A9C6E1;
        width:100%;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        font-weight: bold;
        BORDER: 0; PADDING: 0px; MARGIN: 0px; overflow:hidden;
        text-align : center;
        vertical-align : middle;
      }
      .linPar {
		border: solid 1px #D8E5F2;
		height: 21px;
		font:  10px Verdana, Arial, Helvetica, sans-serif;
		wrap:  none;
      }
      .linImpar {
        background-color:#D8E5F2; 
		border: solid 1px #D8E5F2; 
		height: 21px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        wrap:  none;
      }
    -->
    </style>
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>
<script language="JavaScript" src="/cfmx/edu/docencia/calificarEvaluaciones1_00.js"></script>
<script language="JavaScript" type="text/JavaScript">
    <!--
	
      var GvarRow1 = 5;
      var GvarRowN = 2;
      var GvarRowAlumno = -1;
      var GvarProIndex = 0;
      var GvarCurIndex = 0;
      var GvarPerIndex = 0;
      var GvarOrdIndex = 0;

      GvarValueAnt = "";
      GvarRowAnt = -1;

      // Uno por Concepto
      var GvarConceptos = new Array();
      <cfset LvarCount=0>
      <cfoutput query="qryConceptos">
        <cfset LvarCount=LvarCount+1>
        GvarConceptos["C#CodigoEC#"] = #PorcentajeEC#;
      </cfoutput>
      var GvarConceptosN = <cfoutput>#LvarCount#</cfoutput>;

      // Uno por Estudiante
      var GvarConceptosXEstudiantes = new Array();
      var GvarEstudiantesN = <cfoutput>#qryEstudiantes.RecordCount#</cfoutput>;

      // Uno por Calficacion
      var GvarComponentes = new Array(
      <cfset LvarTotPlaneado=0>
      <cfoutput query="qryComponentes">
        <cfset LvarTotPlaneado=LvarTotPlaneado + PorcentajeDec>
        <cfif currentRow eq 1>
            new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        <cfelse>
          , new objCalificacion("C#CodigoEC#",#PorcentajeCEC#,#Porcentaje#)
        </cfif>
      </cfoutput>
        );
      var GvarComponentesN = GvarComponentes.length;
      var GvarPlaneado = <cfif round(LvarTotPlaneado*100)/100.0 eq 100.0><cfset GvarPlaneado=true>true<cfelse><cfset GvarPlaneado=false>false</cfif>;
	  
<cfif GvarTablaMateria neq "">
      <cfquery dbtype="query" name="qryValoresMateria">
       select Codigo, Equivalente, Minimo, Maximo, Descripcion
         from qryValoresTabla
        where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarTablaMateria#">
        order by EVorden
      </cfquery>
      var GvarTablaMateria = new Array (
	  <cfoutput query="qryValoresMateria">
        <cfif currentRow eq 1>
            new objTabla("#Codigo#",#Equivalente#,#Minimo#,#Maximo#,"#Descripcion#")
        <cfelse>
          , new objTabla("#Codigo#",#Equivalente#,#Minimo#,#Maximo#,"#Descripcion#")
        </cfif>
      </cfoutput>
        );
      function objTabla(Codigo, Valor, Min, Max, Descripcion)
      {
          this.Codigo = Codigo;
          this.Valor  = Valor;
          this.Min    = Min;
          this.Max    = Max;
		  this.Descripcion = Descripcion;
      }
<cfelse>
      var GvarTablaMateria = "";
</cfif>
      function fnInicializarCalculos(LvarEst)
	  {
        GvarConceptosXEstudiantes[LvarEst] = new objConceptoXEstudiante (new Array(), 0);
        <cfoutput query="qryConceptos">
        GvarConceptosXEstudiantes[LvarEst].Evaluaciones["C#CodigoEC#"] = new objCXE(0,0,0);
        </cfoutput>
	  }
    -->
    </script>
<form name="frmNotas" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
		
<table>
  <tr>
    <td>
      Profesor: 
      <select name="cboProfesor" id="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='javascript: if (this.value != "-999") fnReLoad();'>
          <cfif isdefined("RolActual") and RolActual EQ 11><option value="-999"></option></cfif>
		<cfset LvarSelected="0">
        <cfoutput query="qryProfesores">
          <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboProfesor="-999">
		</cfif>
      </select>
      Curso:
      <select name="cboCurso" id="cboCurso" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange='javascript: if (this.value != "-999") fnReLoad();'>
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfoutput query="qryCursos">
          <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfoutput>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboCurso="-999">
		</cfif>
      </select><BR><BR>

      <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
	  <cfelse>
		  Per&iacute;odo:
		  <select name="cboPeriodo" id="cboPeriodo" 
				  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
				  onChange='javascript: if (this.value == "-999") 
							  fnLoadcalificarCurso();
							else
							  fnReLoad();'>
			<cfoutput query="qryPeriodos">
			  <option value="#Codigo#"<cfif (#form.cboPeriodo# eq #Codigo#) > selected</cfif>>#Descripcion#</option>
			</cfoutput>			  
		  </select>
		  
		  Ordenamiento Componentes: 
		  <select name="cboOrdenamiento" id="cboOrdenamiento" size="1" 
				  style="font:10px Verdana, Arial, Helvetica, sans-serif;"
				  onChange="javascript: fnReLoad();">
			<option value="0"<cfif form.cboOrdenamiento eq "0"> selected</cfif>>Cronolgico</option>
			<option value="1"<cfif form.cboOrdenamiento eq "1"> selected</cfif>>Por Concepto</option>
		  </select>
		  <cfoutput>
			<input type="hidden" name="txtRows" id="txtRows" value="#qryEstudiantes.recordCount#">
			<input type="hidden" name="txtCols" id="txtCols" value="#qryComponentes.recordCount#">
		  </cfoutput>
	  </cfif>
	</td>
	<td align="center">
	<cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
	<cfelse>
		<cfif #qryEstudiantes.RecordCount# neq 0>
		  <cfoutput>
			<a href="javascript:a=window.open('reporteProgreso.cfm?N=1&PR=#trim(form.cboProfesor)#&C=#trim(form.cboCurso)#&E='+document.getElementById('tdCodigoAlumno').value+'&P=#trim(form.cboPeriodo)#', 'ReporteProgreso','left=50,top=10,scrollbars=yes,resiable=yes,width=700,height=550,alwaysRaised=yes','Reporte de Progreso');a.focus();"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Reporte de Progreso del Curso"></a>&nbsp;&nbsp;
		  </cfoutput>
		</cfif>
	</cfif>
	</td>
  </tr>
</table>
<cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
	<cfexit>
</cfif>
      <br>
      <br>

    <cfif #qryEstudiantes.RecordCount# eq 0>
      <table>
          <tr><td bgcolor="#A9C6E1">No existen alumnos matriculados en este curso, FAVOR COMUNIQUESE CON LA ADMINISTRACION</td></tr>
      </table>
	  <cfexit>
    <cfelseif #qryConceptos.RecordCount# eq 0>
      <table>
          <tr><td bgcolor="#A9C6E1">El curso no ha sido planeado para el per odo indicado</td></tr>
      </table>
    <cfelseif not GvarPlaneado>
      <table>
        <tr><td bgcolor="#A9C6E1">El curso no se ha terminado de planear para el perodo indicado</td></tr>
      </table>
	</cfif>

<table border="0" width="100%">
<tr>
<td valign="top">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="150" valign="top">
		<div style="width:150px; overflow:hidden; border-right:1px solid #FFFFFF">
		<table id="tblEstudiantes" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="linEnc" style="text-align:left;">Estudiante</td>
			<td class="linEnc"></td>
		</tr>
		<tr id="trPrcC1" <cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
			<td class="linEncPrc" style="text-align:left;">Porcentajes por Concepto</td>
			<td class="linEncPrc"></td>
		</tr>
		<tr id="trPrcP1" <cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
			<td class="linEncProm" style="text-align:Left;">Contribuci n al Promedio</td>
			<td class="linEncProm"></td>
		</tr>
		<tr>
			<td class="linEncProm" style="text-align:Left;">Cerrar Evaluaci&oacute;n</td>
			<td class="linEncProm"></td>
		</tr>
		<tr class="tdInvisible">
			<td></td>
			<td></td>
		</tr>
		<cfset LvarPar="Impar">
	<cfoutput query="qryEstudiantes">
		<cfif LvarPar eq "Impar"><cfset LvarPar="Par"><cfelse><cfset LvarPar="Impar"></cfif>
		<tr>
			<td class="lin#LvarPar#" nowrap>#Nombre#</td>
			<td><input type="hidden" name="txtEcodigo#currentRow#" id="txtEcodigo#currentRow#" value="#Codigo#"></td>
		</tr>
	</cfoutput>
		<tr id="trprm1"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
			<td class="linEncProm" style="text-align:Left; font-weight:bold;" onDblClick="return fnVerPrms();">Promedio</td>
		</tr>
		<tr id="trprm1">
			<td style="height:20px;">&nbsp;</td>
		</tr>
		</table>
		</div>
		</td>
		<td id="divWidth1" valign="top" style="border: 0; padding: 0px; margin: 0px; ">
		<cfset GvarDiv = find("MSIE",CGI.HTTP_USER_AGENT) gt 0 and find("Windows",CGI.HTTP_USER_AGENT) gt 0>
		<cfset tam = 0>
		<cfif qryComponentes.recordCount GT 3>
			<cfset tam = 204>
		<cfelse>
			<cfset tam = qryComponentes.recordCount * 51>
		</cfif>
		<!--- <cfif GvarDiv> --->
		<cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
 		<DIV id="divWidth2" style="BORDER: 0; border-right: solid #FFFFFF 1px;PADDING: 0px; MARGIN: 0px; WIDTH: <cfoutput>#tam#</cfoutput>px; OVERFLOW:auto;">
		</cfif>
		<table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<cfoutput query="qryComponentes">
			<td class="linEnc"><div onDblClick="alert(this.title);" class="linEnc" style="border-right:0px;font:9px; font-weight:bold;overflow:hidden;" 
			    title=
"Concepto: #DescripcionEC# (#PorcentajeEC#%), 
Evaluacion: #DescripcionCEC# (#PorcentajeCEC#%)">
				#DescripcionCEC#</div></td>
		</cfoutput>			  
		</tr>
		<tr id="trPrcC2" class="linEncPrc"<cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
		<cfoutput query="qryComponentes">
			<td class="linEncPrc">#PorcentajeCEC#%<BR>de<BR>#PorcentajeEC#%</td>
		</cfoutput>			  
		</tr>
		<tr id="trPrcP2" class="linEncProm"<cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
		<cfoutput query="qryComponentes">
			<td class="linEncProm">#Porcentaje#%</td>
		</cfoutput>			  
		</tr>
		<tr class="linEncProm">
		<cfoutput query="qryComponentes">
			<td class="linEncProm"> 
				<input name="chkCerrar#currentRow#" id="chkCerrar#currentRow#" type="checkbox" 
					value="1"
					class="linEncProm" style="border:0px"
					<cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">checked</cfif>
					<cfif qryPeriodoCerrado.Cerrado eq "1">disabled</cfif>
					onClick="fnCerrarComponente(this,event);"> 
				<input name="hdnCerrar#currentRow#Ant" id="hdnCerrar#currentRow#Ant" type="hidden" 
					value=<cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">"1"<cfelse>"0"</cfif>>
			</td>
		</cfoutput>			  
		</tr>
		<tr class="tdInvisible">
		<cfoutput query="qryComponentes">
			<td class="tdInvisible" style="width:101; height:15px";>
				<input type="text" name="txtECcomponente#currentRow#" id="txtECcomponente#currentRow#" value="#CodigoCEC#" class="tdInvisible">
					<cfif EVTcodigo neq ""><input type="text" name="txtEVTcodigo#currentRow#" id="txtEVTcodigo#currentRow#" class="tdInvisible" value="#EVTcodigo#"></cfif>
			</td>
		</cfoutput>			  
		</tr>
		<cfset LvarLins=qryEstudiantes.RecordCount>
		<cfset LvarCols=qryComponentes.RecordCount>
		<cfset LvarLin=1>
		<cfset LvarCol=1>
		<cfset LvarPar="Par">
		<tr>
			<cfoutput>
			<cfloop query="qryNotas">
			<td class="lin#LvarPar#"> 
			<cfif Tabla eq "">
			<input type="text" name="txtNota#LvarLin#_#LvarCol#" id="txtNota#LvarLin#_#LvarCol#" maxlength="6"
				class="txt#LvarPar#"
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);"
				<cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">Readonly<cfelse>style="#LvarBorder#;"</cfif>
				value="<cfif Nota eq "-1"><cfelse>#Nota#</cfif>">
			<cfelse>
			<select name="cboValor#LvarLin#_#LvarCol#" id="cboValor#LvarLin#_#LvarCol#"
				class="txt#LvarPar#"
				<cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">onChange="javascript: this.value = GvarValueAnt;"</cfif>
				onFocus="return fnFocus(this,event);"
				onBlur="return fnBlur(this, event);"
				onKeyDown="return fnKeyDown(this, event);"
				onKeyPress="return fnKeyPressNum(this, event);">
				<option value=""<cfif (Nota eq "" or Nota eq "-1") and Valor eq ""> selected</cfif>>&nbsp;</option>
				<cfset LvarNota=Nota>
				<cfset LvarValor=Valor>
				<cfquery dbtype="query" name="qryValores">
					select Codigo, Equivalente, Minimo, Maximo
					  from qryValoresTabla
					 where Tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tabla#">
					 order by EVorden
				</cfquery>
				<cfloop query="qryValores">
				<option value="#Equivalente#"
				<cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
					or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
				</cfloop>
			</select>
			</cfif>
			</td>
			<cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
			<cfset LvarLin=LvarLin+1>
			<cfset LvarCol=0>
			<cfif LvarPar neq "Par">
				<cfset LvarPar="Par">
			<cfelse>
				<cfset LvarPar="Impar">
			</cfif>
		</tr>
<tr>
</cfif>
<cfset LvarCol=LvarCol+1>
                        </cfloop>
						</cfoutput>
                        </tr>
                        <tr id="trPrm2"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
						  <cfloop from="1" index="i" to="#qryComponentes.RecordCount#">
                          <td class="linEncProm">0.00</td>
						  </cfloop>
                        </tr>
                      </table>
		<!--- <cfif GvarDiv> --->
		<cfif find("Mac",CGI.HTTP_USER_AGENT) eq 0>
           </DIV>
		</cfif>
                </td>
                <td width="102" valign="top">
                  <table id="tblPromedios" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="linEnc" width="101">Ganado</td>
                      <td class="linEnc" width="101">Progreso</td>
                      <td class="linEnc" width="101">Ajuste</td>
                    </tr>
                    <tr id="trPrcC3"<cfif form.chkPorcentajesXConcepto neq "1"> style="display:none;"</cfif>>
                      <td class="linEncPrc" width="101">&nbsp;</td>
                      <td class="linEncPrc" width="101">&nbsp;</td>
                      <td class="linEncPrc" width="101">&nbsp;</td>
                    <tr id="trPrcP3"<cfif form.chkPorcentajesXPromedio neq "1"> style="display:none;"</cfif>>
                      <td class="linEncProm" width="101">&nbsp;</td>
                      <td class="linEncProm" width="101">&nbsp;</td>
                      <td class="linEncProm" width="101">&nbsp;</td>
                    </tr>
                    <tr>
                      <td class="linEncProm" colspan="3" align="center" nowrap> Cerrar Per&iacute;odo: 
                        <input name="chkCerrarPeriodo" id="chkCerrarPeriodo" type="checkbox"
                               class="linEncProm" style="border:0px"
                               value="1"<cfif qryPeriodoCerrado.Cerrado eq "1"> checked</cfif>
                               onClick="fnCerrarPeriodo();"> 
                        <input name="hdnCerrarPeriodoAnt" id="hdnCerrarPeriodoAnt" type="hidden"
                               value="<cfoutput>#qryPeriodoCerrado.Cerrado#</cfoutput>">
                        <input name="hdnCursoCerrado" id="hdnCursoCerrado" type="hidden"
                               value="<cfoutput>#qryCursoCerrado.Cerrado#</cfoutput>">
					  </td>
                    </tr>
                    <tr class="tdInvisible">
                      <td></td>
                      <td></td>
                      <td>
                         <cfif GvarTablaMateria neq ""><input type="text" name="txtEVTcodigoM" id="txtEVTcodigoM" class="tdInvisible" value="<cfoutput>#GvarTablaMateria#</cfoutput>"></cfif>
					  </td>
                    </tr>
					
                  <cfset LvarPar="Impar">
                  <cfoutput query="qryEstudiantes">
                    <cfif LvarPar eq "Par">
                      <cfset LvarPar="Impar">
                    <cfelse>
                      <cfset LvarPar="Par">
                    </cfif>
                    <tr class="lin#LvarPar#">
                      <td width="101" class="lin#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtGanado#CurrentRow#" id="txtGanado#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="0">
					  </td>
                      <td width="101" class="lin#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtProgreso#CurrentRow#" id="txtProgreso#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align=center;"</cfif>
                                value="0">
					  </td>
                    <cfif GvarTablaMateria eq "">
                      <td width="101" class="lin#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtAjuste#CurrentRow#" id="txtAjuste#CurrentRow#"
                                <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">Readonly<cfelse>Style="#LvarBorder#"</cfif>
                                onFocus="document.frmNotas.chkXAlumno.selectedIndex=0; return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="#Ajuste#">
 					  </td>
                    <cfelse>
                      <td width="101" class="lin#LvarPar#">
                         <select name="cboAjuste#CurrentRow#" id="cboAjuste#CurrentRow#"
                                 <cfif Cerrado eq "1" or qryPeriodoCerrado.Cerrado eq "1">OnChange="javascript: this.value = GvarValueAnt;"</cfif>
                                 class="txt#LvarPar#"
                                 onFocus="return fnFocus(this,event);"
                                 onBlur="return fnBlur(this, event);"
                                 onKeyDown="return fnKeyDown(this, event);"
                                 onKeyPress="return fnKeyPressNum(this, event);">
								<cfset LvarNota=Ajuste>
								<cfset LvarValor=ValorAjuste>
                             <option value=""<cfif (LvarNota eq "" or LvarNota eq "-1") and LvarValor eq ""> selected</cfif>>&nbsp;</option>
                                <cfloop query="qryValoresMateria">
                             <option value="#Equivalente#"
								<cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
								   or (LvarValor neq "" and LvarValor eq Equivalente)>selected</cfif>>#Codigo#</option>
                                </cfloop>
                         </select>
 					  </td>
                    </cfif>
                    </tr>
                  </cfoutput>
                    <tr id="trprm3"<cfif form.chkPromedioXComponente neq "1"> style="display:none;"</cfif>>
                      <td class="linEncProm" colspan="3" style="text-align=center; font-weight:bold; color:#0000FF;">0</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td></td>
          <td valign="top"><input name="tdCodigoAlumno" id="tdCodigoAlumno" type="hidden" value="-1">
        <table id="tblConceptos" border="0" cellspacing="0" cellpadding="0" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" width="350" colspan="6" style="border-Bottom: 1px solid #FFFFFF; text-align:left; font-size: 14px; ">Estudiante</td>
          </tr>
        <cfif #qryConceptos.RecordCount# neq 0>
          <tr class="linEncEva"> 
            <td align="center" style="border-right: 1px solid #FFFFFF"> <p align="left">
			  <b>Concepto de Evaluacion</b></p></td>
            <td align="center" colspan="4" class="linEncProm"> <p align="center">
			  <b>Contribucion al Progreso</b> </td>
            <td align="center" class="linEncProm" rowspan="2"> <p align="center">
			<b>Progreso</b></p></td>
          </tr>
          <tr class="linEncEva">
            <td align="center" style="border-right: 1px solid #FFFFFF">&nbsp;</td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;"
			    title="Ganado = Sumatoria por Concepto(Nota X Peso de la Evaluacion)"> 
			  <b>Ganado&nbsp;</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;"
			    title="Evaluado = Sumatoria por Concepto(Peso de la Evaluacion con nota)"> 
              <b>Evaluado</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;" 
			    title="Contribucion = Ganado / Evaluado"> 
              <b>Contribuc.</b></td>
            <td class="linEncProm" style="border-top: 1px solid #FFFFFF; text-align=center;" 
			    title="%Concepto = Porcentaje asignado al Concepto de Evaluacion (en negrita aparecen los que fueron evaluados)"> 
              <b>%Concepto</b></td>
          </tr>
          <cfset LvarPar="1">
          <cfoutput query="qryConceptos">
            <cfif LvarPar neq "linPar">
              <cfset LvarPar="linPar">
			<cfelse>
              <cfset LvarPar="linImpar">
			</cfif>
			  <tr class="#LvarPar#"> 
				<td rowspan="2">#DescripcionEC#&nbsp;</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">0.00%</td>
				<td class="txtPar" align="right">#PorcentajeEC#</td>
				<td class="txtPar" align="right">&nbsp;</td>
			  </tr>
			  <tr class="#LvarPar#"> 
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
				<td class="txtPar" align="right" style="font-weight: bold">&nbsp;</td>
			  </tr>
		  </cfoutput>
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Obtenido</td>
            <td align="right" 
title="Total Ganado = Sumatoria(Ganado X %Concepto), 
es decir, es la contribucion ponderada de Calificaciones Ganadas de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total Evaluado = Sumatoria(Evaluado X %Concepto), 
es decir, es la contribucion ponderada de Calificaciones Evaluadas de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total Contribucion = Sumatoria(Contribucion X %Concepto), 
es decir, es la contribucion ponderada de cada Concepto de Evaluacion" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Total %Conceptos Evaluados = Sumatoria(%Concepto con Evaluaciones)" style="font-weight: bold">&nbsp;</td>
            <td align="right" 
title="Progreso Periodo = Total Contribucion / Total %Conceptos Evaluados, 
es decir, es el promedio ponderado de Progresos de cada Concepto de Evaluacion" style="color: #0000FF">&nbsp;</td>
          </tr>
          <cfif GvarTablaMateria neq "">
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Equivalente</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="center" style="color: #0000FF; font-weight: bold;">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="center" style="color: #0000FF; font-weight: bold;">&nbsp;</td>
          </tr>
          </cfif>		   
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Ajuste</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          <cfif GvarTablaMateria neq "">
            <td align="center" style="color: #0000FF; font-weight: bold;" title="Ajuste digitado por el profesor al final del periodo.">&nbsp;</td>
		  <cfelse>
            <td align="center" style="color: #0000FF;" title="Ajuste digitado por el profesor al final del periodo.">&nbsp;</td>
		  </cfif>
          </tr>
          <tr class="linEncProm" style="font-weight: bold;"> 
            <td align="left">Asignado</td>
            <td align="center" colspan="4" nowrap width=202 style="color: #0000FF; font-weight: bold; overflow:hidden;">&nbsp;</td>
            <td align="center" style="font-weight:bold; color: #0000FF; font-weight: bold;"
			    title="Progreso Asignado = Si hay ajuste: Ajuste, si no: Progreso.">&nbsp;</td>
          </tr>
	    </cfif>
        <tr>
          <td valign="middle" colspan="3">
            Visualizar:
          </td>
            <td valign="middle" colspan="4">
            Digitar por:
          </td>
        </tr>
        <tr>
            <td valign="top" colspan="3"> <p> 
				<input type="hidden" name="hdnChkPorcentajesXConcepto" value="">
                <input type="checkbox" name="chkPorcentajesXConcepto" id="chkPorcentajesXConcepto" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPorcentajesXConcepto eq "1">checked</cfif>
                      onClick="fnPorcentajes(this,event,'C');" value="1">
                Porcentajes por Concepto<br>
				<input type="hidden" name="hdnChkPorcentajesXPromedio" value="">
                <input type="checkbox" name="chkPorcentajesXPromedio" id="chkPorcentajesXPromedio" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPorcentajesXPromedio eq "1">checked</cfif>
                       onClick="fnPorcentajes(this,event,'P');" value="1">
                Contribuci&oacute;n al Promedio <br>
				<input type="hidden" name="hdnChkPromedioXComponente" value="">
                <input type="checkbox" name="chkPromedioXComponente" id="chkPromedioXComponente" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPromedioXComponente eq "1">checked</cfif>
                       onClick="fnPromedio(this,event);" value="1">
                Promedios por Componente<br>
				<input type="hidden" name="hdnChkCalcular" value="">
                <input type="checkbox" name="chkCalcular" id="chkCalcular" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkCalcular eq "1">checked</cfif>
                      onClick="fnChkCalcular();" value="1">
                Calcular en Lnea </p>
              </td>
            <td valign="top" colspan="4">
            <select name="chkXAlumno" id="chkXAlumno" size="1" 
			        style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;">
              <option value="false" selected>Calificacion</option>
              <option value="true">Alumno</option>
            </select>
          </td>
        </tr>
      </table>
	    <input name="btnGrabar" id="btnGrabar" type="submit" value="Guardar" disabled onClick="javascript: if (!document.getElementById('chkCalcular').checked) fnProcesoInicial();">
        <input name="chkDesecharCambios" id="chkDesecharCambios" type="checkbox" value="1" checked onClick="document.frmNotas.btnGrabar.disabled=document.frmNotas.chkDesecharCambios.checked;"> Desechar Cambios
		</td>
        </tr>
      </table>
    <br>
    <br>
    </form>
    <script type="text/javascript">fnProcesoInicial();</script>
