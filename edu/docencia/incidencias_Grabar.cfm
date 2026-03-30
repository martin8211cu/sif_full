<cftransaction>
<cftry>
<cfoutput>

<cfif not isDefined("Form.chkJustificado")>
  <cfset Form.chkJustificado = "N">
  <cfset Form.txtJustifica = "">
</cfif>

<cfif isDefined("form.btnAgregar")>
  <cfif form.hdnTipo eq "C">
<!---
	<cfif form.chkTipoC eq "A" or form.chkTipoC eq "AE">
	  <cfset cols1 = "pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail">
	  <cfset tables1 = "">
	  <cfset where1 = "">
      <cfif form.optTipoC eq "A">
		<cfset tables1 = "">
		<cfset where1 = "">
      <cfelseif form.optTipoC eq "G">
		<cfset tables1 = "">
		<cfset where1 = "">
      <cfelseif form.optTipoC eq "T">
		<cfset tables1 = "">
		<cfset where1 = "">
      </cfif>
	  <!--- Invocacion --->
	</cfif>
	
	<cfif form.chkTipoC eq "E" or form.chkTipoC eq "AE">
	  <cfset cols2 = "pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail">
	  <cfset tables2 = "">
	  <cfset where2 = "">
      <cfif form.optTipoC eq "A">
		<cfset tables2 = "">
		<cfset where2 = "">
      <cfelseif form.optTipoC eq "G">
		<cfset tables2 = "">
		<cfset where2 = "">
      <cfelseif form.optTipoC eq "T">
		<cfset tables2 = "">
		<cfset where2 = "">
      </cfif>
	  <!--- Invocacion --->
	</cfif>
	
	<!--- Unificacion de los querys --->
	<cfquery name="qryCorreos" dbtype="query">
		<cfif form.chkTipoC eq "A" or form.chkTipoC eq "AE">
		select Usucodigo, Ulocalizacion, NombreDestino, eMail from qryCorreo1
		</cfif>
		<cfif form.chkTipoC eq "AE">
		  union
		</cfif>
		<cfif form.chkTipoC eq "E" or form.chkTipoC eq "AE">
		select Usucodigo, Ulocalizacion, NombreDestino, eMail from qryCorreo2
		</cfif>
	</cfquery>
--->

    <cfquery datasource="#Session.Edu.DSN#" name="qryCorreos">
    set nocount on
	<cfif form.chkTipoC eq "A" or form.chkTipoC eq "AE">
      <cfif form.optTipoC eq "A">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, 
		  p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, 
		  p.Pemail1 as eMail
		  from Estudiante e, PersonaEducativo p
		 where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdnEcodigo#">
           and e.persona = p.persona
      <cfelseif form.optTipoC eq "G">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, p.Pemail1 email
          from AlumnoCalificacionCurso a, Estudiante e, PersonaEducativo p
         where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboCurso#">
		   and a.Ecodigo = e.Ecodigo
           and e.persona = p.persona
      <cfelseif form.optTipoC eq "T">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, p.Pemail1 email
          from AlumnoCalificacionCurso a, Estudiante e, PersonaEducativo p
         where exists(
             select 1
               from Curso c, Materia m, Grupo g, PeriodoVigente v
              where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
                and c.Mconsecutivo = m.Mconsecutivo
                and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
                and c.Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboProfesor#">
                and c.GRcodigo = g.GRcodigo
                and m.Ncodigo = v.Ncodigo
                and c.PEcodigo = v.PEcodigo
                and c.SPEcodigo = v.SPEcodigo
                and a.Ccodigo = c.Ccodigo
            )
		   and a.Ecodigo = e.Ecodigo
           and e.persona = p.persona
      </cfif>
	</cfif>
	<cfif form.chkTipoC eq "AE">
	  UNION
	</cfif>
	<cfif form.chkTipoC eq "E" or form.chkTipoC eq "AE">
      <cfif form.optTipoC eq "A">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, p.Pemail1 eMail, convert(varchar,e.EEcodigo) as EEcodigo, '#Session.Edu.Usucodigo#'
		  from Encargado e, EncargadoEstudiante ee, PersonaEducativo p
		 where ee.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdnEcodigo#">
           and ee.EEcodigo = e.EEcodigo
           and e.persona = p.persona
      <cfelseif form.optTipoC eq "G">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, p.Pemail1 email
          from AlumnoCalificacionCurso a,
		       Encargado e, EncargadoEstudiante ee, PersonaEducativo p
         where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboCurso#">
		   and a.Ecodigo = ee.Ecodigo
           and ee.EEcodigo = e.EEcodigo
           and e.persona = p.persona
      <cfelseif form.optTipoC eq "T">
	    select convert(varchar(18), e.Usucodigo) as Usucodigo, e.Ulocalizacion, p.Pnombre+' '+p.Papellido1+' '+p.Papellido2 as NombreDestino, p.Pemail1 email
          from AlumnoCalificacionCurso a,
		       Encargado e, EncargadoEstudiante ee, PersonaEducativo p
         where exists(
             select *
               from Curso c, Materia m, Grupo g, PeriodoVigente v
              where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
                and c.Mconsecutivo = m.Mconsecutivo
                and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
                and c.Splaza = <cfqueryparam cfsqltype="cf_sql_decimal" value="#form.cboProfesor#">
                and c.GRcodigo = g.GRcodigo
                and m.Ncodigo = v.Ncodigo
                and c.PEcodigo = v.PEcodigo
                and c.SPEcodigo = v.SPEcodigo
                and a.Ccodigo = c.Ccodigo
            )
		   and a.Ecodigo = ee.Ecodigo
           and ee.EEcodigo = e.EEcodigo
           and e.persona = p.persona
      </cfif>
	</cfif>
    set nocount off
    </cfquery>

	<cfif isdefined("RolActual") and RolActual EQ 11>
	  <cfset LvarAsunto = "Comunicado de Asistente">
    <cfelse>
	  <cfset LvarAsunto = "Comunicado de Profesor">
	</cfif>	  
	<cfset fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,qryOrigen.Nombre, LvarAsunto, qryCorreos, true)>
  <cfelse>
    <cfquery datasource="#Session.Edu.DSN#">
    set nocount on
    <cfif form.hdnTipo eq "O">
      insert into AlumnoCursoObservacion
          (Ecodigo, CEcodigo, Ccodigo, PEcodigo, 
		   ACOfecha, ACOtipo, ACOobservacion)
      values(#form.hdnEcodigo#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
	  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboCurso#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboPeriodo#">,
	       '#lsDateFormat(Form.txtFechaO,"YYYYMMDD")#', 
		   '#Form.optTipoO#',
		   '#Form.txtObservacion#')
    <cfelseif form.hdnTipo eq "A">
      insert into AlumnoCursoAsistencia 
          (Ecodigo, CEcodigo, Ccodigo, PEcodigo, 
		   ACAfecha, ACAtipo, ACAjustificado, ACAjustificacion, ACAjustificador)
      values(#form.hdnEcodigo#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
	  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboCurso#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cboPeriodo#">,
	       '#lsDateFormat(Form.txtFechaA,"YYYYMMDD")#', 
		   '#Form.optTipoA#',
		   '#Form.chkJustificado#',
		   '#Form.txtJustificacion#',
		   '#Form.txtJustifica#')
    </cfif>
    set nocount off
    </cfquery>
  </cfif>

  <cfset form.hdnTipo = "">
<cfelseif isDefined("form.btnCambiar")>
  <cfquery datasource="#Session.Edu.DSN#">
  set nocount on
  <cfif form.hdnTipo eq "O">
    update AlumnoCursoObservacion
       set ACOfecha = '#lsDateFormat(Form.txtFechaO,"YYYYMMDD")#'
	     , ACOtipo = '#Form.optTipoO#'
		 , ACOobservacion = '#Form.txtObservacion#'
     where ACOcodigo = #form.hdnCodigo#
  <cfelseif form.hdnTipo eq "A">
    update AlumnoCursoAsistencia
       set ACAfecha = '#lsDateFormat(Form.txtFechaA,"YYYYMMDD")#'
	     , ACAtipo = '#Form.optTipoA#'
		 , ACAjustificado = '#Form.chkJustificado#'
		 , ACAjustificador = '#Form.txtJustifica#'
		 , PEcodigo = #Form.cboPeriodo#
		 , ACAjustificacion = '#Form.txtJustificacion#'
     where ACAcodigo = #form.hdnCodigo#
  </cfif>
  set nocount off
  </cfquery>
  <cfset form.hdnTipo = "">
<cfelseif isDefined("form.btnBorrar")>
  <cfquery datasource="#Session.Edu.DSN#">
  set nocount on
  <cfif form.hdnTipo eq "O">
    delete AlumnoCursoObservacion
     where ACOcodigo = #form.hdnCodigo#
  <cfelseif form.hdnTipo eq "A">
    delete AlumnoCursoAsistencia
     where ACAcodigo = #form.hdnCodigo#
  </cfif>
  set nocount off
  </cfquery>

  <cfset form.hdnTipo = "">
</cfif>

</cfoutput>
<cfcatch>
    <cfset LvarURL = "../errorPages/BDerror.cfm?errType=0&errMsg=">
	<cfif isDefined("form.btnBorrar")>
	  <cfset LvarURL = LvarURL & urlencodedformat("No se puede borrar porque la incidencia esta siendo utilizando:<br><br>")>
	</cfif>
    <cfset LvarURL = LvarURL & urlencodedformat(cfcatch.Detail) 
	               & "&errDet=" & urlencodedformat(cfcatch.Message)>
	<cflocation addtoken="no" url=#LvarURL#>
</cfcatch>
</cftry>
</cftransaction>
