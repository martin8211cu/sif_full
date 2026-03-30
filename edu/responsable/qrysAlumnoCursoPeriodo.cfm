<cffunction name="fnCursoEscogido" returntype="string">
           <cfargument name="LprmCampo" required="true" type="string">
  <cfif form.cboCurso neq "-1">
    <cfreturn LprmCampo & " = " & form.cboCurso>
  <cfelse>
    <cfreturn "exists (select 1 from Curso c1, Materia m1, Grupo g1, PeriodoVigente v1, AlumnoCalificacionCurso a1 " &
                       "where " & LprmCampo & " = c1.Ccodigo " &
					   "  and c1.CEcodigo = " & Session.Edu.CEcodigo & 
					   "  and c1.Mconsecutivo = m1.Mconsecutivo" &
					   "  and m1.Melectiva not in ('E','C')" &
					   "  and c1.GRcodigo *= g1.GRcodigo " &
                       "  and m1.Ncodigo = v1.Ncodigo" &
					   "  and c1.PEcodigo = v1.PEcodigo" &
					   "  and c1.SPEcodigo = v1.SPEcodigo" &
					   "  and a1.Ecodigo = " & Form.cboAlumno &
					   "  and a1.CEcodigo = " & Session.Edu.CEcodigo &
					   "  and a1.Ccodigo = c1.Ccodigo)">
  </cfif>
</cffunction>

<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
         convert(varchar(18),Usucodigo)        as USUcodigo, 
		 Ulocalizacion                         as USUlocalizacion, 
		 Usulogin                              as Login 
    from Usuario
   where Usucodigo = #Session.Edu.Usucodigo#
</cfquery>

<cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
	<cfset rolAct = "edu.estudiante">
<cfelse>
	<cfset rolAct = "edu.encargado">
</cfif>

<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="#rolAct#"/>
</cfinvoke>

<cfquery datasource="#Session.Edu.DSN#" name="qryAlumnos">
  select distinct convert(varchar,a.Ecodigo) as Codigo, 
    Papellido1+' '+Papellido2+' '+Pnombre as Descripcion,
	convert(varchar,a.persona) as Persona
    from Alumnos a, PersonaEducativo pe, 
	 <cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
	Estudiante e
	<cfelse>
	Encargado e, EncargadoEstudiante ee
	</cfif>
   where a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and pe.persona  = a.persona
	 <cfif isdefined("Session.RolActual") and Session.RolActual EQ 6>
     and a.Ecodigo   = e.Ecodigo
     and e.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	 <cfelse>
     and a.Ecodigo   = ee.Ecodigo
     and ee.EEcodigo = e.EEcodigo
     and e.EEcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	 </cfif>
	 and a.Aretirado = 0
	 and exists( 
	 	select 1 from AlumnoCalificacionCurso acc, Curso c, PeriodoVigente pv
	 	where a.Ecodigo = acc.Ecodigo
		and acc.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and acc.CEcodigo = c.CEcodigo
		and acc.Ccodigo = c.Ccodigo
		and c.PEcodigo = pv.PEcodigo
		and c.SPEcodigo = pv.SPEcodigo
	 )
  order by Descripcion
</cfquery>
<cfif isdefined("Session.RolActual") and Session.RolActual EQ 6 and isdefined("form.cboAlumno")>
	<cfset alumnoEncontrado = false>
	<cfloop query="qryAlumnos">
		<cfif form.cboAlumno EQ qryAlumnos.Codigo>
			<cfset alumnoEncontrado = true>
		</cfif>
	</cfloop>
	<cfif NOT alumnoEncontrado>
		<cfset form.cboAlumno = "-999">
	</cfif>
</cfif>

<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL ALUMNO INDICADO
 --->
<cfif form.cboAlumno neq "-999">
  <cfquery dbtype="query" name="qryPermiso">
    select count(*) as Permiso
	  from qryAlumnos
	 where Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboAlumno#">
  </cfquery>
  <cfif qryPermiso.Permiso eq 0 or qryPermiso.Permiso eq "">
    NO TIENE AUTORIZACION PARA TRABAJAR CON EL ALUMNO INDICADO
	<cfset form.cboAlumno = "-999">
	<cfset Session.Docencia.cboAlumno = "-999">
	<cfabort>
  </cfif>
<cfelseif qryAlumnos.Codigo neq "">
  <cfset form.cboAlumno = qryAlumnos.Codigo>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
    select convert(varchar,c.Ccodigo) as Codigo, (case m.Melectiva when 'R' then m.Mnombre else c.Cnombre end) as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v, AlumnoCalificacionCurso a
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.GRcodigo *= g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
	   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboAlumno#">
	   and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	   and a.Ccodigo = c.Ccodigo
     order by m.Morden, Descripcion
</cfquery>

<cfset LvarSelected="0">
<cfloop query="qryCursos">
  <cfif #form.cboCurso# eq #Codigo#>
    <cfset LvarSelected="1">
  </cfif>
</cfloop>
<cfif #LvarSelected# eq "0" and form.cboCurso neq "-1">
  <cfset form.cboCurso="-1">
</cfif>

<cfif not isdefined("qryPeriodos")>
  <cfquery datasource="#Session.Edu.DSN#" name="qryPeriodos">
    select distinct convert(varchar,p.PEcodigo) as Codigo,
	  p.PEdescripcion as Descripcion, convert(varchar,PEevaluacion) as Actual
      from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v
     where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	   and #fnCursoEscogido("c.Ccodigo")#
       and c.Mconsecutivo = m.Mconsecutivo
       and m.Ncodigo      = p.Ncodigo
       and v.Ncodigo   = m.Ncodigo
       and v.PEcodigo  = c.PEcodigo
       and v.SPEcodigo = c.SPEcodigo
    order by p.PEorden
  </cfquery>
</cfif>
<cfset LvarSelected1 = "">
<cfset LvarSelectedCbo = "">
<cfset LvarSelectedAct = "">
<cfloop query="qryPeriodos">
  <cfif currentRow eq 1>
    <cfset LvarSelected1 = Codigo>
  </cfif>
  <cfif Codigo eq form.cboPeriodo>
    <cfset LvarSelectedCbo = Codigo>
  <cfelseif Codigo eq Actual>
    <cfset LvarSelectedAct = Codigo>
  </cfif>
</cfloop>
<cfif LvarSelectedCbo neq "">
  <cfset form.cboPeriodo = LvarSelectedCbo>
<cfelseif LvarSelectedAct neq "">
  <cfset form.cboPeriodo = LvarSelectedAct>
<cfelseif LvarSelected1 neq "">
  <cfset form.cboPeriodo = LvarSelected1>
</cfif>
