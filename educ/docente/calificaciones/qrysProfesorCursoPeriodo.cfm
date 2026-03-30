<cfquery datasource="#Session.DSN#" name="qryUsuActual">
  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
         convert(varchar,Usucodigo)        	   as USUcodigo, 
		 Usulogin                              as Login 
    from PersonaDatos
   where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryProfesores">
  set nocount on
  select distinct convert(varchar,DOpersona) as Codigo,  
  		 Papellido1+' '+Papellido2+' '+Pnombre as Descripcion
    from Docente
   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
     and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
  order by  2
  set nocount off
</cfquery>
<cfset Form.cboProfesor=#qryProfesores.Codigo#>

<!--- 
VERIFICAR QUE EL USUARIO TENGA DERECHO A UTILIZAR EL PROFESOR INDICADO
 --->
<cfif form.cboProfesor neq "-999">
  <cfif qryProfesores.recordCount eq 1>
    <cfset form.cboProfesor = qryProfesores.Codigo>
  <cfelseif qryProfesores.recordCount eq 0>
    NO TIENE AUTORIZACION PARA CALIFICAR, REQUIERE SER DOCENTE
	<cfabort>
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

<cfquery datasource="#Session.DSN#" name="qryCursos">
  set nocount on
    select convert(varchar,Ccodigo) as Codigo, Mcodificacion + ' ' + c.Cnombre as Descripcion
      from Curso c, Materia m
     where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	   and c.Mcodigo = m.Mcodigo
       and 	(c.DOpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
	   		OR
			exists (select * from CursoDocente cd
					where cd.Ccodigo = c.Ccodigo
					  and cd.DOpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
					)
			)
     order by Cnombre
  set nocount off
</cfquery>

<cfif not isdefined("qryPeriodos")>
	<cfquery name="qryPeriodos" datasource="#Session.DSN#">
		select convert(varchar,pe.PEcodigo) as Codigo, pl.PLnombre + ': ' + pe.PEnombre as Descripcion
		from PeriodoEvaluacion pe, PeriodoLectivo pl, CursoPeriodo cp
		where pe.PLcodigo = pl.PLcodigo
		  and cp.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		  and cp.PEcodigo = pe.PEcodigo
		order by pl.PLinicio, pe.PEinicio
	</cfquery>
</cfif>
<cfset LvarSelected1 = "">
<cfset LvarSelectedCbo = "">
<cfloop query="qryPeriodos">
  <cfif currentRow eq 1>
    <cfset LvarSelected1 = Codigo>
  </cfif>
  <cfif Codigo eq form.cboPeriodo>
    <cfset LvarSelectedCbo = Codigo>
  </cfif>
</cfloop>
<cfif LvarSelectedCbo neq "">
  <cfset form.cboPeriodo = LvarSelectedCbo>
<cfelseif LvarSelected1 neq "">
  <cfset form.cboPeriodo = LvarSelected1>
</cfif>
