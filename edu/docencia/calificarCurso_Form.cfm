<cfinclude template="commonDocencia.cfm">

<cfscript>
  sbInitFromSession("cboProfesor", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboCurso", "-999",isDefined("form.btnGrabar"));
  sbInitFromSession("cboPeriodo", "-999",isDefined("form.btnGrabar"));
  sbInitFromSessionChks("chkPromedioXPeriodo","1",isDefined("form.btnGrabar"));
</cfscript>
 <!-- Asegurarse que los alumnos esten activos, Aretirado = 0
Rodolfo Jimenez Jara, SOIN, CentroAmerica, 01/09/2003 -->
<cfquery datasource="#Session.Edu.DSN#" name="qryPeriodos">
  select convert(varchar,p.PEcodigo) as Codigo, p.PEdescripcion as Descripcion, 
  convert(varchar,PEevaluacion) as Actual,
    (select isnull(max(ACPEcerrado),'0') from AlumnoCalificacionPerEval ac , Alumnos a
      where ac.CEcodigo = c.CEcodigo
     and ac.Ccodigo  = c.Ccodigo
     and ac.PEcodigo = p.PEcodigo
	  and a.CEcodigo = ac.CEcodigo
     and a.Ecodigo = ac.Ecodigo
     and a.Aretirado  = 0
	 ) as Cerrado
    from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v
   where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
     and c.Mconsecutivo = m.Mconsecutivo
     and m.Ncodigo      = p.Ncodigo
     and v.Ncodigo   = m.Ncodigo
     and v.PEcodigo  = c.PEcodigo
     and v.SPEcodigo = c.SPEcodigo
	
  order by p.PEorden
</cfquery>
<cfinclude template="/edu/docencia/qrysProfesorCursoPeriodo.cfm">

<cfquery datasource="#Session.Edu.DSN#" name="qryComplementaria">
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
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="qryMateria">
    select convert(varchar,EVTcodigo) as EVTcodigo,
	convert(varchar,m.Mconsecutivo) as Mconsecutivo, m.Melectiva as Tipo
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and c.Mconsecutivo = m.Mconsecutivo
       and c.GRcodigo = g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
</cfquery>
<cfset GvarTablaMateria = qryMateria.EVTcodigo>
<cfif GvarTablaMateria neq "">
  <cfquery datasource="#Session.Edu.DSN#" name="qryValoresTabla">
    select convert(varchar,EVTcodigo) as Tabla, EVvalor as Codigo, EVdescripcion as Descripcion, 
           EVequivalencia as Equivalente, EVminimo as Minimo, EVmaximo as Maximo
      from EvaluacionValores
     where EVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarTablaMateria#">
	 order by EVorden
  </cfquery>
</cfif>

<cfif isDefined("form.btnGrabar")>
  <cfinclude template="/edu/docencia/calificarCurso_Grabar.cfm">
</cfif>
<!-- Asegurarse que los alumnos esten activos, Aretirado = 0
Rodolfo Jimenez Jara, SOIN, CentroAmerica, 01/09/2003 -->
<cfquery datasource="#Session.Edu.DSN#" name="qryCursoCerrado">
  select isnull(max(ACCcerrado),'0') as Cerrado from AlumnoCalificacionCurso acc, Alumnos alu
   where acc.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	 and acc.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
	 and alu.CEcodigo = acc.CEcodigo
	 and alu.Ecodigo = acc.Ecodigo
	 and alu.Aretirado  = 0
</cfquery>
<!-- Asegurarse que los alumnos esten activos, Aretirado = 0
Rodolfo Jimenez Jara, SOIN, CentroAmerica, 01/09/2003 -->
<cfquery datasource="#Session.Edu.DSN#" name="qryEstudiantes">
  select distinct convert(varchar,a.Ecodigo) as Codigo, 
  	     p.Papellido1+' '+p.Papellido2+' '+p.Pnombre as Nombre, 
         str(a.ACCnotacalculada,6,2) as Ajuste, 
         str(a.ACCnota,6,2) as Ganado, 
         str(a.ACCnotaprog,6,2) as Progreso, 
         a.ACCvalorcalculado as AjusteValor, 
         a.ACCvalor as GanadoValor, 
         a.ACCvalorprog as ProgresoValor, 
        (select isnull(max(ACPEcerrado),'0') from AlumnoCalificacionPerEval ac1, Alumnos alu
         where ac1.Ecodigo     = a.Ecodigo
           and ac1.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
           and ac1.Ccodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		    and alu.CEcodigo = a.CEcodigo
			 and alu.Ecodigo = a.Ecodigo
			 and alu.Aretirado  = 0
		   ) as Cerrado 
    from AlumnoCalificacionCurso a,
         Estudiante e, 
         PersonaEducativo p,
		 Alumnos alu
   where a.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
     and a.Ecodigo      = e.Ecodigo
     and e.persona      = p.persona
	 and a.Ecodigo      = alu.Ecodigo
	 and alu.Aretirado  = 0
  order by p.Papellido1, p.Papellido2, p.Pnombre
</cfquery>
<!-- Asegurarse que los alumnos esten acasftivos, Aretirado = 0
Rodolfo Jimenez Jara, SOIN, CentroAmerica, 01/09/2003 -->
<cfquery datasource="#Session.Edu.DSN#" name="qryNotas">
  select convert(varchar,c.CEcodigo) as Estudiante, 
         str(isnull(n.ACPEnotacalculada,n.ACPEnota),6,2) as NotaAsignada, 
		 str(isnull(n.ACPEnota,-999),6,2) as Ganado, 
		 str(isnull(n.ACPEnotacalculada,-999),6,2) as Ajuste, 
		 str(isnull(n.ACPEnotaprog,-999),6,2) as Progreso,
         isnull(n.ACPEvalorcalculado,n.ACPEvalor) as Valor,
        (select isnull(max(n2.ACPEcerrado),'0')
		    from AlumnoCalificacionPerEval n2, Alumnos alu
           where n2.PEcodigo     = pe.PEcodigo
             and n2.CEcodigo     = a.CEcodigo
             and n2.Ccodigo      = a.Ccodigo
			  and alu.CEcodigo = n2.CEcodigo
			 and alu.Ecodigo = n2.Ecodigo
			 and alu.Aretirado  = 0
		 ) as Cerrado
    from Curso c,                          -- Curso
         AlumnoCalificacionCurso a,        -- Alumnos de un Curso
		 Estudiante e,                     -- Join entre Alumno y Persona
		 PersonaEducativo p,               -- Catalogos de Personas
         AlumnoCalificacionPerEval n,      -- Calificaciones Alumno por Periodo
		 PeriodoEvaluacion pe,             -- Periodos de Evaluacion
		 Materia m,
		 Alumnos alu
   where c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">

     and a.Ecodigo      = e.Ecodigo
	 and a.Ecodigo      = alu.Ecodigo
	 and alu.Aretirado  = 0
     and a.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and a.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">

     and e.persona      = p.persona

     and pe.PEcodigo      *= n.PEcodigo
     and a.Ecodigo        *= n.Ecodigo
     and a.CEcodigo       *= n.CEcodigo
     and a.Ccodigo        *= n.Ccodigo

     and m.Mconsecutivo = c.Mconsecutivo
     and m.Ncodigo      = pe.Ncodigo
  order by p.Papellido1, p.Papellido2, p.Pnombre, pe.PEorden
</cfquery>

<cfset LvarBorder = "border: 1px solid ##CCCCCC;">
<style type="text/css">
    <!--
      .tdInvisible {
        border: 0px;
        height:15px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        background-color:#FF33CC;
        display:none;
      }
      .txtPar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
        border:0;
      }
      .txtImpar {
        line-height: normal;
        width: 50px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
        text-align: right;
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
      }
      .linImpar {
        background-color:#D8E5F2; border: solid 1px #D8E5F2; 
		height: 21px;
        font:  10px Verdana, Arial, Helvetica, sans-serif;
      }
    -->
    </style>
<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>
<script language="JavaScript" src="/cfmx/edu/docencia/calificarCurso1_00.js"></script>
<script language="JavaScript" type="text/JavaScript">
    <!--
      var GvarRow1 = 3;
      var GvarRowN = 2;
      var GvarRowAlumno = -1;
      var GvarProIndex = 0;
      var GvarCurIndex = 0;
      var GvarPerIndex = 0;
      var GvarOrdIndex = 0;

      GvarValueAnt = "";
      GvarRowAnt = -1;

      var GvarPeriodosN = <cfoutput>#qryPeriodos.RecordCount#</cfoutput>;

      // Uno por Estudiante
      var GvarPeriodosXEstudiantes = new Array();
      <cfoutput>
        <cfset LvarCols=qryPeriodos.RecordCount>
        <cfset LvarEst = -1> 
        <cfset LvarPer = -1> 
        <cfloop query="qryNotas">
          <cfif CurrentRow mod LvarCols is 1>
		    <cfset LvarEst = LvarEst+1> 
		    <cfset LvarPer = -1> 
	  GvarPeriodosXEstudiantes[#LvarEst#] = new Array();
	      </cfif>
          <cfset LvarPer = LvarPer+1> 
	  GvarPeriodosXEstudiantes[#LvarEst#][#LvarPer#] = new objPXE(<cfif #Cerrado# eq "1">true<cfelse>false</cfif>, <cfif Progreso eq "" or Progreso eq -1>-999<cfelse>#Progreso#</cfif>, <cfif Ganado eq "" or Ganado eq -1>-999<cfelse>#Ganado#</cfif>, #Ajuste#);
        </cfloop>
	  </cfoutput>
      var GvarEstudiantesN = GvarPeriodosXEstudiantes.length;

<cfif GvarTablaMateria neq "">
      var GvarTablaMateria = new Array (
	  <cfoutput query="qryValoresTabla">
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

    -->
</script>
<cfoutput>
<form name="frmNotas" method="POST" action=""
          style="font:10px Verdana, Arial, Helvetica, sans-serif;">
      <br>
<table>
  <tr>
    <td>
      Profesor:
      <select name="cboProfesor" id="cboProfesor"
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
          <cfif isdefined("RolActual") and RolActual EQ 11><option value="-999"></option></cfif>
		<cfset LvarSelected="0">
<!--- 		<cfdump var="#qryProfesores#"><br>
		<cfdump var="#form#">
		<cfdump var="#url#">
 --->        
 		<cfloop query="qryProfesores">
          <option value="#Codigo#"<cfif #form.cboProfesor# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfloop>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboProfesor="-999">
		</cfif>
      </select>
      Curso:
      <select name="cboCurso" id="cboCurso" 
              style="font:10px Verdana, Arial, Helvetica, sans-serif;"
              onChange="fnReLoad();">
          <option value="-999"></option>
		<cfset LvarSelected="0">
        <cfloop query="qryCursos">
          <option value="#Codigo#"<cfif #form.cboCurso# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
        </cfloop>			  
		<cfif #LvarSelected# eq "0">
		  <cfset form.cboCurso="-999">
		</cfif>
      </select>
	</td>
  	<td align="center">
      <cfif #qryEstudiantes.RecordCount# neq 0>
		<a href="javascript:a=window.open('reporteProgreso.cfm?N=3&PR=#trim(form.cboProfesor)#&C=#trim(form.cboCurso)#&E='+document.getElementById('tdCodigoAlumno').value+'&P=-1', 'ReporteProgreso','left=50,top=10,scrollbars=yes,resiable=yes,width=700,height=550,alwaysRaised=yes','Reporte de Progreso');a.focus();"><img src="/cfmx/edu/Imagenes/evaluaciones2.gif" border="0" title="Reporte de Progreso del Curso"></a>&nbsp;&nbsp;
	  </cfif>
	</td>
  </tr>
</table>
<br>
        <input type="hidden" name="txtRows" id="txtRows" value="#qryEstudiantes.recordCount#">
        <input type="hidden" name="txtCols" id="txtCols" value="#qryPeriodos.recordCount#">
  <br>
      <br>

      <cfif #form.cboProfesor# eq "-999" or #form.cboCurso# eq "-999">
        <cfexit>
      <cfelseif #qryEstudiantes.RecordCount# eq 0>
        <table>
          <tr><td bgcolor="A9C6E1">No existen alumnos matriculados en este curso, FAVOR COMUNIQUESE CON LA ADMINISTRACION</td></tr>
        </table>
	  <cfexit>
	  </cfif>
      <table border="0" width="100%">
        <tr>
          <td valign="top">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="150" valign="top">
                  <div style="width:150px; overflow:hidden; border-right: 1px solid FFFFFF">
                    <table id="tblEstudiantes" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="linEnc" style="text-align:left;">Estudiante</td>
                        <td class="linEnc"></td>
                      </tr>
                      <tr>
                        <td class="linEncProm" style="text-align:Left;">Perodo Cerrado</td>
                        <td class="linEncProm"></td>
                      </tr>
                      <tr class="tdInvisible">
                        <td></td>
                        <td></td>
                      </tr>
                      <cfset LvarPar="Impar">
                      <cfloop query="qryEstudiantes">
                        <cfif LvarPar eq "Par">
                          <cfset LvarPar="Impar">
            			<cfelse>
                          <cfset LvarPar="Par">
            			</cfif>
                          <tr>
                            <td class="lin#LvarPar#" nowrap>#Nombre#</td>
                            <td class="lin#LvarPar#"><input type="hidden" name="txtEcodigo#currentRow#" id="txtEcodigo#currentRow#" value="#Codigo#"></td>
                          </tr>
            		  </cfloop>
                      <tr id="trprm1"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
                        <td class="linEncProm" style="text-align:left; font-weight:bold;">Promedio</td>
                      </tr>
                      <tr id="trprm1">
                        <td style="height:20px;">&nbsp;</td>
                      </tr>
                    </table>
                  </div>
                </td>
                
                <td id="divWidth1" valign="top" style="border: 0; padding: 0px; margin: 0px; height:100%;">
<!---                   <DIV id="divWidth2" style="BORDER: 0; border-right=1px solid #FFFFFF;PADDING: 0px; MARGIN: 0px; WIDTH: 255px;  HEIGHT:100%;
                       OVERFLOW:<cfif find("Netscape",CGI.HTTP_USER_AGENT) eq 0>auto<cfelse>hidden</cfif>;">
 --->                      <table id="tblNotas" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <cfloop query="qryPeriodos">
                          <td class="linEnc"><div style="font:9px; font-weight:bold;" title="#Descripcion#"><a href="javascript:fnTrabajarConPeriodo(#Codigo#)">#Descripcion#</a></div></td>
                          </cfloop>        
                        </tr>
                        <tr>
                        <cfloop query="qryPeriodos">
                          <td class="linEncProm"> 
                            <input name="chkCerrar#currentRow#" id="chkCerrar#currentRow#" type="checkbox" 
                                   value="1"
                                   class="linEncProm" style="border:0px"
                                   <cfif Cerrado eq "1">checked</cfif>
                                   disabled>
                          </td>
                        </cfloop>        
                        </tr>
                        <tr class="tdInvisible">
                          <cfloop query="qryPeriodos">
                          <td><input type="text" name="txtPEcodigo#currentRow#" id="txtPEcodigo#currentRow#" class="tdInvisible" value="#Codigo#"></td>
                          </cfloop>        
                        </tr>
                        <cfset LvarLins=qryEstudiantes.RecordCount>
                        <cfset LvarCols=qryPeriodos.RecordCount>
                        <cfset LvarLin=1>
                        <cfset LvarCol=1>
                        <cfset LvarPar="Par">
                        <tr>
                      <cfloop query="qryNotas">
                          <td class="lin#LvarPar#"> 
                          <cfif Ajuste neq "-999">
                            <cfset LvarNotaAsignada = Ajuste>
                          <cfelse>
                            <cfset LvarNotaAsignada = Progreso>
                          </cfif>
                        <cfif GvarTablaMateria eq "">
                            <input type="text" name="txtNota#LvarLin#_#LvarCol#" id="txtNota#LvarLin#_#LvarCol#" maxlength="6"
                                   class="txt#LvarPar#"
                                   Readonly
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   value="<cfif LvarNotaAsignada eq "-999" or LvarNotaAsignada eq "-1"><cfelse>#LvarNotaAsignada#</cfif>">
                        <cfelse>
                            <select name="cboValor#LvarLin#_#LvarCol#" id="cboValor#LvarLin#_#LvarCol#"
                                   class="txt#LvarPar#"
                                   onChange="this.value = GvarValueAnt;"
                                   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPressNum(this, event);">
                              <option value=""<cfif (LvarNotaAsignada eq "" or LvarNotaAsignada eq "-1") and Valor eq ""> selected</cfif>>&nbsp;</option>
                              <cfset LvarNota=LvarNotaAsignada>
                              <cfset LvarValor=Valor>
                              <cfloop query="qryValoresTabla">
                                <option value="#Equivalente#" <cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo)  or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
                              </cfloop>
                            </select>
                        </cfif>
                          </td>
                      <cfif CurrentRow mod LvarCols is 0 and CurrentRow neq recordCount>
                        <cfset LvarLin=LvarLin+1>
                        <cfset LvarCol=0><cfif LvarPar neq "Par"><cfset LvarPar="Par"><cfelse><cfset LvarPar="Impar"></cfif>
                        </tr>
                        <tr>
                      </cfif>
                          <cfset LvarCol=LvarCol+1>
                      </cfloop>

                        </tr>
                        <tr id="trPrm2"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
                        <cfloop from="1" index="i" to="#qryPeriodos.RecordCount#">
                          <td class="linEncProm">0.00</td>
                        </cfloop>
                        </tr>
                      </table>
<!---                   </DIV>
 --->			    </td>

                <td width="102" valign="top">
                  <table id="tblCurso" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="linEnc" width="101">Ganado</td>
                      <td class="linEnc" width="101">Progreso</td>
                      <td class="linEnc" width="101">Ajuste</td>
                    </tr>
                    <tr>
                      <td class="linEncProm" colspan="3" align="center"> Cerrar Curso: 
                        <input name="chkCerrarCurso" id="chkCerrarCurso" type="checkbox"
                               class="linEncProm" style="border:0px"
                               value="1"<cfif qryCursoCerrado.Cerrado eq "1"> checked</cfif>
                               onClick="fnCerrarPeriodo();"> 
                        <input name="hdnCerrarCursoAnt" id="hdnCerrarCursoAnt" type="hidden"
                               value=<cfif qryCursoCerrado.Cerrado eq "1">"1"<cfelse>"0"</cfif>>
					  </td>
                    </tr>
                    <tr class="tdInvisible">
                      <td></td>
                      <td></td>
                      <td>
                         <cfif GvarTablaMateria neq ""><input type="text" name="txtEVTcodigoM" id="txtEVTcodigoM" class="tdInvisible" value="#GvarTablaMateria#"></cfif>
					  </td>
                    </tr>
					
                    <cfset LvarPar="Impar">
                    <cfloop query="qryEstudiantes">
                      <cfif LvarPar neq "Par">
                        <cfset LvarPar="Par">
					  <cfelse>
                        <cfset LvarPar="Impar">
					  </cfif>
                    <tr class="lin#LvarPar#">
                      <td width="101" class="lin#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtGanado#CurrentRow#" id="txtGanado#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align: center;"</cfif>
                                value="#Ganado#">
					  </td>
                      <td width="101" class="lin#LvarPar#">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtProgreso#CurrentRow#" id="txtProgreso#CurrentRow#"
                                readonly<cfif GvarTablaMateria neq ""> style="text-align: center;"</cfif>
                                value="#Progreso#">
					  </td>
                      <td width="101" class="lin#LvarPar#">
                       <cfif GvarTablaMateria eq "">
                         <input type="text" class="txt#LvarPar#" 
						        name="txtAjuste#CurrentRow#" id="txtAjuste#CurrentRow#"
                                <cfif qryCursoCerrado.Cerrado eq "1" or qryMateria.Tipo eq "C">Readonly<cfelse>style="#LvarBorder#;"</cfif>
                                onFocus="return fnFocus(this,event);"
                                onBlur="return fnBlur(this, event);"
                                onKeyDown="return fnKeyDown(this, event);"
                                onKeyPress="return fnKeyPressNum(this, event);"
                                value="#Ajuste#">
                       <cfelse>
                            <select name="cboAjuste#CurrentRow#" id="cboAjuste#CurrentRow#"
                                   class="txt#LvarPar#"
                                   <cfif qryCursoCerrado.Cerrado eq "1" or qryMateria.Tipo eq "C">onChange="this.value = GvarValueAnt;"</cfif>
								   onFocus="return fnFocus(this,event);"
                                   onBlur="return fnBlur(this, event);"
                                   onKeyDown="return fnKeyDown(this, event);"
                                   onKeyPress="return fnKeyPressNum(this, event);">
                                <option value=""<cfif (Ajuste eq "" or Ajuste eq "-1") and AjusteValor eq ""> selected</cfif>>&nbsp;</option>
						<cfset LvarNota=Ajuste>
						<cfset LvarValor=AjusteValor>
                        <cfloop query="qryValoresTabla">
                                <option value="#Equivalente#"
 							  <cfif (LvarNota neq "" and LvarNota gte Minimo and LvarNota lte Maximo) 
							     or (LvarValor neq "" and LvarValor eq Equivalente)> selected</cfif>>#Codigo#</option>
                        </cfloop>
                              </select>
                     </cfif>
 					  </td>
                    </tr>
                    </cfloop>
                    <tr id="trprm3"<cfif form.chkPromedioXPeriodo neq "1"> style="display:none;"</cfif>>
                      <td class="linEncProm" colspan="3" style="text-align:center; font-weight:bold; color:0000FF;">0</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td width="1px">
          </td>
          <td valign="top" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
            <input name="tdCodigoAlumno" id="tdCodigoAlumno" type="hidden" value="-1">
            <table id="tblPeriodos" border="0" cellspacing="0" cellpadding="0">
          <tr class="linEnc"> 
            <td id="tdNombreAlumno" colspan="6" style="border-Bottom: 1px solid FFFFFF; text-align:left; font-size: 14px; ">Estudiante</td>
          </tr>
          <tr class="linEncEva"> 
            <td align="left" style="border-right: 1px solid FFFFFF">Per&iacute;odo</td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Ganado</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Progreso</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Ajuste</b></p></td>
            <td align="center" class="linEncProm"> 
              <p align="center"><b>Progreso Asignado</b></p></td>
          </tr>
          <cfset LvarPar="Impar">
          <cfloop query="qryPeriodos"> 
		    <cfif LvarPar neq "Par">
              <cfset LvarPar="Par">
            <cfelse>
              <cfset LvarPar="Impar">
            </cfif>
            <tr class="lin#LvarPar#"> 
              <td>#Descripcion#</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align:center;"<cfelse>style="text-align:center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align:center;"<cfelse>style="text-align:center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align:center;"<cfelse>style="text-align:center;"</cfif>>0</td>
              <td class="txt#LvarPar#" <cfif GvarTablaMateria neq "">style="text-align:center;"<cfelse>style="text-align:center;"</cfif>>0</td>
            </tr>
          </cfloop> 
          <tr class="linEnc" style="color: 0000FF"> 
            <td align="left">Promedio Final</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>
                title="Ganado Final = promedio(Ganado por Periodo calificado)">0</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>
                title="Progreso Final = promedio(Progreso Asignado por Periodo calificado)">0</td>
            <td <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>
                title="Ajuste Final = Nota digitada por el profesor">0</td>
            <td style="font:12px; font-weight:bold;" <cfif GvarTablaMateria neq "">align="center"<cfelse>align="right"</cfif>
                title="Nota Final Asignada = Si hay Ajuste: Ajuste, si no: Progreso.">0</td>
          </tr>
        <cfif GvarTablaMateria neq "">
          <tr class="linEncProm" style="color: 0000FF"> 
            <td align="left">&nbsp;</td>
            <td align="center" colspan="4">0</td>
          </tr>
		</cfif>
          <!--- TABLA:
          <tr class="linEnc"> 
            <td align="left">&nbsp;</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
		  --->
        </table>
        <table border="0" width="100%" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
          <tr> 
            <td valign="middle"> Visualizar: </td>
          </tr>
          <tr> 
            <td valign="top"> <p> 
                <input type="checkbox" name="chkPromedioXPeriodo" id="chkPromedioXPeriodo" style="margin-left: 26; font:10px Verdana, Arial, Helvetica, sans-serif;"
                      <cfif form.chkPromedioXPeriodo eq "1">checked</cfif>
                       onClick="fnPromedio(this,event);" value="1">
                Promedios por Periodo</p></td>
          </tr>
        </table>
	    <input name="btnGrabar" id="btnGrabar" type="submit" value="Guardar" disabled>
        <input name="chkDesecharCambios" id="chkDesecharCambios" type="checkbox" value="1" checked onClick="document.frmNotas.btnGrabar.disabled=document.frmNotas.chkDesecharCambios.checked;"> Desechar Cambios
		</td>
        </tr>
      </table>
</cfoutput>	  
    <br>
    <br>
    </form>
    <script type="text/javascript">fnProcesoInicial();</script>
