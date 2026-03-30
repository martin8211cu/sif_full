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

<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
         convert(varchar,Usucodigo)        	   as USUcodigo, 
		 Ulocalizacion                         as USUlocalizacion, 
		 Usulogin                              as Login 
    from Usuario
   where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
     and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryProfesores">
  set nocount on
  select distinct convert(varchar,s.Splaza) as Codigo,  
  		 Papellido1+' '+Papellido2+' '+Pnombre as Descripcion
    from Staff s, PersonaEducativo pe, Curso c, PeriodoVigente pv
   where s.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
     and pe.persona = s.persona
     and c.Splaza   = s.Splaza
     and c.CEcodigo = s.CEcodigo
	 and c.PEcodigo = pv.PEcodigo
	 and c.SPEcodigo = pv.SPEcodigo
	 and s.autorizado = 1
	 and sr.retirado = 0
  <cfif isdefined("RolActual") and RolActual EQ 11>
  UNION
    select '0',  '* Cursos sin Profesor'
  <cfelse>
	 and s.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
  </cfif>
  order by  2
  set nocount off
</cfquery>
<cfif isdefined("RolActual") and (RolActual EQ 5) AND (qryProfesores.RecordCount IS 1)>
	<cfset Form.cboProfesor=#qryProfesores.Codigo#>
</cfif>

<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
 --->
<cfif form.cboProfesor neq "-999">
  <cfif qryProfesores.recordCount eq 1>
    <cfset form.cboProfesor = qryProfesores.Codigo>
  </cfif>
  <cfquery dbtype="query" name="qryPermiso">
    select count(*) as Permiso
	  from qryProfesores
	 where Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboProfesor#">
  </cfquery>
  <cfif qryPermiso.Permiso eq 0 or qryPermiso.Permiso eq "">
    NO TIENE AUTORIZACION PARA CALIFICAR LOS CURSOS DEL PROFESOR INDICADO
	<cfabort>
  </cfif>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
  set nocount on
  <cfif form.cboProfesor neq "0">
    select convert(varchar,Ccodigo) as Codigo, (case when c.GRcodigo is null then Cnombre else m.Mnombre+' '+g.GRnombre end) as Descripcion
      from Curso c, Materia m, Grupo g, PeriodoVigente v
     where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
       and c.GRcodigo *= g.GRcodigo
       and m.Ncodigo = v.Ncodigo
       and c.PEcodigo = v.PEcodigo
       and c.SPEcodigo = v.SPEcodigo
     order by c.GRcodigo,Cnombre
  <cfelse>
    select convert(varchar,Ccodigo) as Codigo, Ndescripcion+': '+Cnombre as Descripcion
      from Curso c, Materia m, PeriodoVigente v, Nivel n
     where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Mconsecutivo = m.Mconsecutivo
	   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
       and c.Splaza       is null
       and m.Ncodigo      = v.Ncodigo
       and c.PEcodigo     = v.PEcodigo
       and c.SPEcodigo    = v.SPEcodigo
       and m.Ncodigo      = n.Ncodigo
    order by n.Norden, Cnombre
  </cfif>
  set nocount off
</cfquery>

<cfif not isdefined("qryPeriodos")>
  <cfquery datasource="#Session.Edu.DSN#" name="qryPeriodos">
    set nocount on
    select convert(varchar,p.PEcodigo) as Codigo, p.PEdescripcion as Descripcion, 
		   convert(varchar,PEevaluacion) as Actual
      from Curso c, Materia m, PeriodoEvaluacion p, PeriodoVigente v
     where c.CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
       and c.Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and c.Mconsecutivo = m.Mconsecutivo
       and m.Ncodigo      = p.Ncodigo
       and v.Ncodigo   = m.Ncodigo
       and v.PEcodigo  = c.PEcodigo
       and v.SPEcodigo = c.SPEcodigo
    order by p.PEorden
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
