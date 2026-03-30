<cffunction name="fnCursoEscogido" returntype="string">
   <cfargument name="LprmCampo" required="true" type="string">
  <cfif form.cboCurso neq "-1">
    <cfreturn LprmCampo & " = " & form.cboCurso>
  <cfelse>
    <cfreturn "exists (select 1 from Curso c1, Materia m1, PeriodoVigente v1 " &
                       "where " & LprmCampo & " = c1.Ccodigo " &
					   "  and c1.CEcodigo = " & Session.Edu.CEcodigo & 
					   "  and c1.Splaza = " & Form.cboProfesor &
					   "  and m1.Melectiva not in ('E','C')" &
					   "  and c1.Mconsecutivo = m1.Mconsecutivo" &
                       "  and m1.Ncodigo = v1.Ncodigo" &
					   "  and c1.PEcodigo = v1.PEcodigo" &
					   "  and c1.SPEcodigo = v1.SPEcodigo" & ")">
  </cfif>
</cffunction>

<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
  set nocount on
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre
    from Usuario
   where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
     and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
  set nocount off
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
<!--- 
	Por mientras solo se mostraran los niveles con cursos c/ profesor
	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	select distinct convert(varchar, a.Ncodigo) as Ncodigo, a.Ndescripcion 
	from Nivel a
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	<cfif isdefined("session.RolActual") and session.RolActual EQ 12>
		and a.Ncodigo in (#NivelesDir#)
	</cfif>
	order by a.Norden
</cfquery> --->

<cfif Len(Trim(NivelesDir)) NEQ 0>
	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	 select distinct convert(varchar, n.Ncodigo) as Ncodigo, n.Ndescripcion 
		from Staff s, PersonaEducativo pe, Curso c, PeriodoVigente pv, Nivel n
	   where s.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and s.autorizado = 1
		 and s.retirado = 0
		<cfif isdefined("session.RolActual") and session.RolActual EQ 12>
			and n.Ncodigo in (#NivelesDir#)
		</cfif>    
		 and pe.persona = s.persona
		 and c.Splaza   = s.Splaza
		 and c.CEcodigo = s.CEcodigo
		 and c.PEcodigo = pv.PEcodigo
		 and c.SPEcodigo = pv.SPEcodigo
		 and n.Ncodigo = pv.Ncodigo
		order by n.Norden
	</cfquery>

	<cfset LvarSelected="0">
	<cfloop query="rsNiveles">
	  <cfif Form.Ncodigo eq rsNiveles.Ncodigo>
		<cfset LvarSelected="1">
	  </cfif>
	</cfloop>
	<cfif #LvarSelected# eq "0" and form.Ncodigo neq "-1">
	  <cfset form.Ncodigo="-1">
	</cfif>
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryProfesores">
	  set nocount on
	  select distinct convert(varchar,s.Splaza) as Codigo,  
			 Papellido1+' '+Papellido2+' '+Pnombre as Descripcion, 
			 convert(varchar,s.persona) as persona
		from Staff s, PersonaEducativo pe, Curso c, PeriodoVigente pv
	   where s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and s.autorizado = 1
		 and s.retirado = 0
	  <cfif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
		 and pv.Ncodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
	  <cfelseif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
		  and pv.Ncodigo in (#NivelesDir#)
	  </cfif> 
		 and pe.persona = s.persona
		 and c.Splaza   = s.Splaza
		 and c.CEcodigo = s.CEcodigo
		 and c.PEcodigo = pv.PEcodigo
		 and c.SPEcodigo = pv.SPEcodigo
		
	  <cfif isdefined("session.RolActual") and session.RolActual EQ 11> 
	  UNION
		select '0',  '* Cursos sin Profesor'
	  </cfif> 
	  order by  2
	  set nocount off
	</cfquery>
	
	<!--- 
	VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
	--->
	<!--- <cfif form.cboProfesor eq "-999">
		<cfset form.cboProfesor = qryProfesores.Codigo>
	</cfif> --->
	
	<cfif isdefined("Session.RolActual") and Session.RolActual EQ 12 >
		<cfset profesorEncontrado = false>
		<cfloop query="qryProfesores">
			<cfif form.cboProfesor EQ qryProfesores.Codigo>
				<cfset profesorEncontrado = true>
			</cfif>
		</cfloop>
		<cfif NOT profesorEncontrado>
			<cfset form.cboProfesor = "-999">
		</cfif>
	</cfif>
	
	<cfif form.cboProfesor eq "-999" and qryProfesores.RecordCount NEQ 0>
		<cfset form.cboProfesor = qryProfesores.Codigo>
	</cfif> 
	<cfquery datasource="#Session.Edu.DSN#" name="qryProfPersona">
	  set nocount on
	  select distinct convert(varchar,s.persona) as persona
		from Staff s, PersonaEducativo pe, Curso c, PeriodoVigente pv
	   where s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		 and s.autorizado = 1
		 and s.retirado = 0
	  <cfif isdefined("form.cboProfesor") and form.cboProfesor NEQ -999>
		 and s.Splaza =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
	  </cfif> 
		 and pe.persona = s.persona
		 and c.Splaza   = s.Splaza
		 and c.CEcodigo = s.CEcodigo
		 and c.PEcodigo = pv.PEcodigo
		 and c.SPEcodigo = pv.SPEcodigo
	  set nocount off
	</cfquery>
	
	<cfset LvarPersonaDocente = qryProfPersona.persona>
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
	  set nocount on
	  <cfif #form.cboProfesor# neq "0">
		select convert(varchar,Ccodigo) as Codigo, (case when c.GRcodigo is null then Cnombre else m.Mnombre+' '+g.GRnombre end) as Descripcion
		  from Curso c, Materia m, Grupo g, PeriodoVigente v, Nivel n, Grado gra
		 where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	
		   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
		   and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
		   <cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
				and m.Ncodigo in (#NivelesDir#)
		   <cfelseif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
				and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
		   </cfif>
		   and c.Mconsecutivo = m.Mconsecutivo
		   and c.GRcodigo 	*= g.GRcodigo
		   and m.Ncodigo 	= v.Ncodigo
		   and n.Ncodigo 	= v.Ncodigo
		   and c.PEcodigo 	= v.PEcodigo
		   and c.SPEcodigo 	= v.SPEcodigo
		   and m.Gcodigo 	*= gra.Gcodigo
		 order by n.Norden,isnull(gra.Gorden,9999), m.Morden
	  <cfelse>
		select convert(varchar,Ccodigo) as Codigo, Ndescripcion+': '+Cnombre as Descripcion
		  from Curso c, Materia m, PeriodoVigente v, Nivel n, Grado gra
		 where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		   and c.Mconsecutivo = m.Mconsecutivo
				<cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
					and m.Ncodigo in (#NivelesDir#)
			   <cfelseif isdefined("form.Ncodigo")  and form.Ncodigo NEQ -1>
					and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
			   </cfif>
		   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
		   and c.Splaza       is null
		   and m.Ncodigo      = v.Ncodigo
		   and c.PEcodigo     = v.PEcodigo
		   and c.SPEcodigo    = v.SPEcodigo
		   and m.Ncodigo      = n.Ncodigo
		   and m.Gcodigo 	  = gra.Gcodigo
		 order by n.Norden, m.Morden, isnull(gra.Gorden,9999)
	  </cfif>
	  set nocount off
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
		set nocount on
		select distinct convert(varchar,p.PEcodigo) as Codigo,
		<cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
		  p.PEdescripcion  + ' - (' + n.Ndescripcion + ')' as Descripcion, 
		<cfelseif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>  
		  p.PEdescripcion  as Descripcion, 
		</cfif>
		  convert(varchar,PEevaluacion) as Actual
		  from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v, Nivel n
		 where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		   and  #fnCursoEscogido("c.Ccodigo")#
		   <cfif isdefined("form.Ncodigo") and form.Ncodigo EQ -1>
				and p.Ncodigo in (#NivelesDir#)
		   <cfelseif isdefined("form.Ncodigo") and form.Ncodigo NEQ -1>
				and p.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
		   </cfif>
		   and c.Mconsecutivo = m.Mconsecutivo
		   and m.Ncodigo      = p.Ncodigo
		   and v.Ncodigo   = m.Ncodigo
		   and v.PEcodigo  = c.PEcodigo
		   and v.SPEcodigo = c.SPEcodigo
		   and m.Ncodigo  = n.Ncodigo
		order by n.Norden, p.PEorden
		set nocount off
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
