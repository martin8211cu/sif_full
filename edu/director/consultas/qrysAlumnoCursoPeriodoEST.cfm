<cffunction name="fnCursoEscogido" returntype="string">
           <cfargument name="LprmCampo" required="true" type="string">
  <cfif form.cboCurso neq "-1">
    <cfreturn LprmCampo & " = " & form.cboCurso>
  <cfelseif form.cboGrupo NEQ "-1">
    <cfreturn "exists (select 1 from Curso c1, Materia m1, Grupo g1, PeriodoVigente v1, AlumnoCalificacionCurso a1 " &
                       "where " & LprmCampo & " = c1.Ccodigo " &
					   "  and c1.CEcodigo = " & Session.Edu.CEcodigo & 
					   "  and c1.GRcodigo = " & Form.cboGrupo &
					   "  and a1.Ecodigo = " & Form.cboAlumno &
					   "  and a1.CEcodigo = " & Session.Edu.CEcodigo &
					   "  and m1.Melectiva not in ('E','C')" &
					   "  and c1.GRcodigo *= g1.GRcodigo " &
                       "  and m1.Ncodigo = v1.Ncodigo" &
					   "  and c1.PEcodigo = v1.PEcodigo" &
					   "  and c1.SPEcodigo = v1.SPEcodigo" &
					   "  and c1.Mconsecutivo = m1.Mconsecutivo" &
					   "  and a1.Ccodigo = c1.Ccodigo)">
  <cfelse>
    <cfreturn "exists (select 1 from Curso c1, Materia m1, Grupo g1, PeriodoVigente v1, AlumnoCalificacionCurso a1 " &
                       "where " & LprmCampo & " = c1.Ccodigo " &
					   "  and c1.CEcodigo = " & Session.Edu.CEcodigo & 
					   "  and a1.Ecodigo = " & Form.cboAlumno &
					   "  and a1.CEcodigo = " & Session.Edu.CEcodigo &
					   "  and m1.Melectiva not in ('E','C')" &
					   "  and c1.GRcodigo *= g1.GRcodigo " &
                       "  and m1.Ncodigo = v1.Ncodigo" &
					   "  and c1.PEcodigo = v1.PEcodigo" &
					   "  and c1.SPEcodigo = v1.SPEcodigo" &
					   "  and c1.Mconsecutivo = m1.Mconsecutivo" &
					   "  and a1.Ccodigo = c1.Ccodigo)">
  </cfif>
</cffunction>

<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre
    from Usuario
   where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
     and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
</cfquery>

<cfif isdefined("session.RolActual") and session.RolActual EQ 12>
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_cod"
	 returnvariable="usr">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
		<cfinvokeargument name="roles" value="edu.director"/>
	</cfinvoke>
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryNivelDirector">
		select convert(varchar,DN.Ncodigo) as Ncodigo
		 from Director D, DirectorNivel DN, Nivel n
		where D.Dcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
		  and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and DN.Ncodigo = n.Ncodigo
		  and D.Dcodigo = DN.Dcodigo
	</cfquery>
	
</cfif>
<cfset NivelesDir = ValueList(qryNivelDirector.Ncodigo,',')>

<cfif Len(Trim(NivelesDir)) NEQ 0>
	<cfquery datasource="#Session.Edu.DSN#" name="qryGrupos">
		Select distinct convert(varchar,b.GRcodigo) as GRcodigo , GRnombre
		from 	Alumnos a
				, GrupoAlumno b
				, Grupo c
				, Nivel d
				, Grado e
		where 	a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and Aretirado=0
				and c.Ncodigo in (#NivelesDir#)
				and c.SPEcodigo in (
					select SPEcodigo
					   from PeriodoVigente
					)
				and a.CEcodigo = b.CEcodigo
				and a.Ecodigo  = b.Ecodigo
				and b.GRcodigo = c.GRcodigo
				and c.Ncodigo  = d.Ncodigo
				and c.Gcodigo=e.Gcodigo
		order by Norden, Gorden, GRnombre
	</cfquery>
	
	<cfset GruposDir = ValueList(qryGrupos.GRcodigo,',')>
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 12 and isdefined("form.cboGrupo")>
		<cfset grupoEncontrado = false>
		<cfloop query="qryGrupos">
			<cfif form.cboGrupo EQ qryGrupos.GRcodigo>
				<cfset grupoEncontrado = true>
			</cfif>
		</cfloop>
		<cfif NOT grupoEncontrado>
			<cfset form.cboGrupo = "-1">
		</cfif>
	</cfif>
	
	<!--- <cfif form.cboGrupo eq "-1" and qryGrupos.RecordCount NEQ 0>
		<cfset form.cboGrupo = qryGrupos.GRcodigo>
	</cfif>  --->
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryAlumnos">
	  select distinct convert(varchar,a.Ecodigo) as Codigo, 
		Papellido1+' '+Papellido2+' '+Pnombre as Descripcion,
		convert(varchar,a.persona) as Persona
		from Alumnos a, PersonaEducativo pe, 
		Estudiante e, GrupoAlumno ga
	   where a.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and a.Aretirado = 0
		<cfif isdefined("form.cboGrupo") and form.cboGrupo NEQ -1>
			and ga.GRcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboGrupo#">
		<cfelseif isdefined("form.cboGrupo") and form.cboGrupo EQ -1>
			and ga.GRcodigo in (#GruposDir#)
		</cfif> 
		 and exists( 
			select 1 from AlumnoCalificacionCurso acc, Curso c, PeriodoVigente pv
			where acc.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.Ecodigo = acc.Ecodigo
			and acc.CEcodigo = c.CEcodigo
			and acc.Ccodigo = c.Ccodigo
			and c.PEcodigo = pv.PEcodigo
			and c.SPEcodigo = pv.SPEcodigo
		 )
		 and pe.persona  = a.persona
		 and a.Ecodigo   = e.Ecodigo
		 and a.Ecodigo = ga.Ecodigo
	
	  order by Descripcion
	</cfquery>
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 12 and isdefined("form.cboAlumno")>
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
	
	<cfif form.cboAlumno eq "-999" and qryAlumnos.RecordCount NEQ 0>
		<cfset form.cboAlumno = qryAlumnos.Codigo>
	</cfif> 
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
		select convert(varchar,c.Ccodigo) as Codigo, (case m.Melectiva when 'R' then m.Mnombre else c.Cnombre end) as Descripcion
		  from Curso c, Materia m, Grupo g, PeriodoVigente v, AlumnoCalificacionCurso a, Nivel n, Grado gra
		 where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboAlumno#">
		   and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">	 
		   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
		   and c.Mconsecutivo = m.Mconsecutivo
		   and c.GRcodigo *= g.GRcodigo 
		   and m.Gcodigo  *= gra.Gcodigo
		   and m.Ncodigo = v.Ncodigo
		   and c.PEcodigo = v.PEcodigo
		   and c.SPEcodigo = v.SPEcodigo
		   and a.Ccodigo = c.Ccodigo
		   and n.Ncodigo 	= v.Ncodigo
		 order by n.Norden, isnull(gra.Gorden,9999), m.Morden	   
		
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
</cfif>