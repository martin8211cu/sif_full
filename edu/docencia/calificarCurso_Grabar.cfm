<cftransaction>
<cftry>
<cfoutput>
  <cfparam name="form.chkCerrarCurso" default="0">
  <cfparam name="form.hdnCerrarCursoAnt" default="0">
  <cfif form.chkCerrarCurso eq "0" and form.hdnCerrarCursoAnt eq "1">
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_ref"
	 returnvariable="qryCorreos">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="referencias" value="st.Splaza"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
		<cfinvokeargument name="addCols" value="pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail, cu.Cnombre as Curso"/>
		<cfinvokeargument name="addTables" value="Curso cu, Staff st, PersonaEducativo pe"/>
		<cfinvokeargument name="addWhere" value="cu.Ccodigo  = #form.cboCurso#
                                             and cu.CEcodigo = #Session.Edu.CEcodigo#
		                                     and st.Splaza = cu.Splaza
											 and st.CEcodigo = cu.CEcodigo
		                                     and st.persona = pe.persona"/>
	</cfinvoke>

	<!---
    <cfquery datasource="#Session.Edu.DSN#" name="qryCorreos">
      set nocount on
      select convert(varchar(18), s.Usucodigo) as Usucodigo, 
	         s.Ulocalizacion, 
			 Pnombre+' '+Papellido1+' '+Papellido2 as NombreDestino,
			 Pemail1 as Email,
	         c.Cnombre as Curso
        from Staff s, Curso c, PersonaEducativo p
       where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
         and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
         and s.Splaza   = c.Splaza
         and s.CEcodigo = c.CEcodigo
		 and s.persona = p.persona
      set nocount off
    </cfquery>
	--->
    <cfset LvarAsunto = "Notificacion Automatica por apertura de Curso Cerrado">
    <cfset LvarMsg = "Por este medio se le comunica que la evaluación final del curso #qryCorreos.Curso#, la cual se encontraba cerrada, ha sido abierta por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#') por medio de la opción de Abrir Curso en la pantalla de Evaluar Curso Final">
	<cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos,true)>
	
  </cfif>
  <cfloop from="1" to=#form.txtRows# index="LvarLin">
      <cfquery datasource="#Session.Edu.DSN#">
	    <cfif not isdefined("form.txtEVTcodigoM")>
          <cfset LvarGanado = Evaluate("form.txtGanado#LvarLin#")>
          <cfset LvarAjuste   = Evaluate("form.txtAjuste#LvarLin#")>
          <cfset LvarProgreso = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarGanadoValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
		<cfelse>
          <cfset LvarAjuste = Evaluate("form.cboAjuste#LvarLin#")>
          <cfset LvarAjusteValor = fnObtenerCodigoDeTabla(GvarTablaMateria, LvarAjuste)>

          <cfset LvarGanadoValor = Evaluate("form.txtGanado#LvarLin#")>
          <cfset LvarProgresoValor = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarGanado = fnObtenerValorDeTabla(GvarTablaMateria, LvarGanadoValor)>
          <cfset LvarProgreso = fnObtenerValorDeTabla(GvarTablaMateria, LvarProgresoValor)>
		</cfif>
 		<cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
		<cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
 		<cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
		    set nocount on
            update AlumnoCalificacionCurso
               set ACCnota           = #LvarGanado#
                 , ACCnotacalculada  = #LvarAjuste#
                 , ACCnotaprog       = #LvarProgreso#
                 , ACCvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
                 , ACCvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACCvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACCcerrado        = '#form.chkCerrarCurso#'
             where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
               and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		    set nocount off
	  </cfquery>

      <!---  Actualiza la nota final del Curso Complementario --->
      <cfif qryComplementaria.Curso neq "">
        <cfquery datasource="#Session.Edu.DSN#" name="qryComplementos">
	      set nocount on
          select round(avg (ACCnota),2)           as Ganado,
                 round(avg (ACCnotacalculada),2)  as Ajuste,
                 round(avg (ACCnotaprog),2)       as Progreso
            from AlumnoCalificacionCurso n, 
                 Curso c, MateriaElectiva ME, Materia MRc, Curso CRc
           where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
             and n.Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
             and n.Ccodigo  = CRc.Ccodigo
             and ME.Melectiva     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Materia#">
             and ME.Mconsecutivo  = MRc.Mconsecutivo
             and MRc.Melectiva    = 'R'
             and CRc.Mconsecutivo = MRc.Mconsecutivo
             and CRc.CEcodigo     = c.CEcodigo
             and CRc.PEcodigo     = c.PEcodigo
             and CRc.SPEcodigo    = c.SPEcodigo
             and CRc.GRcodigo     = c.GRcodigo
	      set nocount off
        </cfquery>
        <cfif qryComplementaria.Tabla eq "">
          <cfset LvarGanado = qryComplementos.Ganado>
          <cfset LvarAjuste   = qryComplementos.Ajuste>
          <cfset LvarProgreso = qryComplementos.Progreso>
          <cfset LvarGanadoValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
        <cfelse>
          <cfset LvarGanado = qryComplementos.Ganado>
          <cfset LvarAjuste   = qryComplementos.Ajuste>
          <cfset LvarProgreso = qryComplementos.Progreso>

          <cfset LvarGanadoValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarGanado)>
          <cfset LvarAjusteValor   = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarAjuste)>
          <cfset LvarProgresoValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarProgreso)>
        </cfif>
        <cfquery datasource="#Session.Edu.DSN#">
	      set nocount on
        <cfif LvarGanado eq "" and LvarAjuste eq "" and LvarProgreso eq "">
		<!---
          delete AlumnoCalificacionCurso
           where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
             and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
		--->
          if exists(select 1 from AlumnoCalificacionCurso
                     where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
                       and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
                       and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
                    )
            update AlumnoCalificacionCurso
               set ACCnota           = null
                 , ACCnotacalculada  = null
                 , ACCnotaprog       = null
                 , ACCvalor          = null
                 , ACCvalorcalculado = null
                 , ACCvalorprog      = null
                 , ACCcerrado        = '#form.chkCerrarCurso#'
             where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
               and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
          else   
            insert into AlumnoCalificacionCurso (Ecodigo, CEcodigo, Ccodigo, ACCcerrado)
            values (#Evaluate("form.txtEcodigo#LvarLin#")#, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">, 
                    '#form.chkCerrarCurso#')
        <cfelse>
          <cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
          <cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
          <cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
          if exists(select 1 from AlumnoCalificacionCurso
                     where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
                       and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
                       and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
                    )
            update AlumnoCalificacionCurso
               set ACCnota           = #LvarGanado#
                 , ACCnotacalculada  = #LvarAjuste#
                 , ACCnotaprog       = #LvarProgreso#
                 , ACCvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
                 , ACCvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACCvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACCcerrado        = '#form.chkCerrarCurso#'
             where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
               and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
          else   
            insert into AlumnoCalificacionCurso
                   (Ecodigo, CEcodigo, Ccodigo, 
                    ACCnota, ACCnotacalculada, ACCnotaprog, 
                    ACCvalor, ACCvalorcalculado, ACCvalorprog, 
                    ACCcerrado)
            values (#Evaluate("form.txtEcodigo#LvarLin#")#, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">, 
                    #LvarGanado#,  
                    #LvarAjuste#, 
                    #LvarProgreso#,
                    <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>,
                    <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
                    <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
                    '#form.chkCerrarCurso#')
	      set nocount off
        </cfif>
        </cfquery>
      </cfif>
  </cfloop>
</cfoutput>
<cfcatch>
    <cfset LvarURL = "../errorPages/BDerror.cfm?errType=0&errMsg=" & urlencodedformat(cfcatch.Detail) 
	               & "&errDet=" & urlencodedformat(cfcatch.Message)>
	<cflocation addtoken="no" url=#LvarURL#>
</cfcatch>
</cftry>
</cftransaction>
