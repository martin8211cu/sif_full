<cftransaction>
<cfoutput>
<cfset LvarAjustarEvaluaciones=false>
<cfif isDefined("form.btnAgregar")>
  <cfquery datasource="educativo">
  <cfif form.hdnTipoOperacion eq "T">
    insert into CursoPrograma
	      (Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPfecha, CPduracion, 
		   CPcubierto, CPorden, 
		   MPcodigo, CPusucodigo)
    values(#form.cboCurso#, #form.cboPeriodo#, '#form.txtNombre#', '#form.txtDescripcion#', '#lsDateFormat(form.txtFecha,"YYYYMMDD")#', #form.txtDuracion#, 
	       <cfif isdefined("form.chkCubierto")>'S'<cfelse>'N'</cfif>, #form.txtOrden#, 
		   null, null)
  <cfelseif form.hdnTipoOperacion eq "E">
    insert into EvaluacionCurso
	      (ECcodigo, Ccodigo, PEcodigo, ECnombre, ECenunciado, ECplaneada, ECduracion, 
		  ECreal, EVTcodigo, 
		  EMcomponente, ECporcentaje)              
    values(#form.cboECcodigo#, #form.cboCurso#, #form.cboPeriodo#, '#form.txtNombre#', '#form.txtDescripcion#', '#lsDateFormat(form.txtFecha,"YYYYMMDD")#', #form.txtDuracion#, 
	       <cfif form.txtFechaReal neq "">'#lsDateFormat(form.txtFechaReal,"YYYYMMDD")#'<cfelse>null</cfif>, #form.cboEVTcodigo#, 
		   null, 0)
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
  </cfquery>

  <cfset form.hdnTipoOperacion = "">
<cfelseif isDefined("form.btnCambiar")>
  <cfquery datasource="educativo">
  <cfif form.hdnTipoOperacion eq "T">
    update CursoPrograma
	   set CPnombre      = '#form.txtNombre#'
	     , CPdescripcion = '#form.txtDescripcion#'
		 , CPfecha       = '#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
		 , CPduracion    = #form.txtDuracion#
		 , CPcubierto    = <cfif isdefined("form.chkCubierto")>'S'<cfelse>'N'</cfif>
		 , CPorden       = #form.txtOrden#
     where Ccodigo = #form.cboCurso#
       and CPcodigo = #form.hdnCodigo#
  <cfelseif form.hdnTipoOperacion eq "E">
    update EvaluacionCurso
	   set ECnombre    = '#form.txtNombre#'
	     , ECenunciado = '#form.txtDescripcion#'
		 , ECplaneada  = '#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
		 , ECduracion  = #form.txtDuracion#
		 , ECreal      = <cfif form.txtFechaReal neq "">'#lsDateFormat(form.txtFechaReal,"YYYYMMDD")#'<cfelse>null</cfif>
		 , EVTcodigo   = #form.cboEVTcodigo#
     where ECcomponente = #form.hdnCodigo#
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
  </cfquery>

  <cfset form.hdnTipoOperacion = "">
<cfelseif isDefined("form.btnBorrar")>
  <cfquery datasource="educativo">
  <cfif form.hdnTipoOperacion eq "T">
    delete CursoPrograma
     where Ccodigo = #form.cboCurso#
       and CPcodigo = #form.hdnCodigo#
  <cfelseif form.hdnTipoOperacion eq "E">
    delete EvaluacionCurso
     where ECcomponente = #form.hdnCodigo#
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
  </cfquery>

  <cfset form.hdnTipoOperacion = "">
</cfif>

<cfif LvarAjustarEvaluaciones>
  <cfquery datasource="educativo">
    update EvaluacionCurso
	   set ECporcentaje = 100/ ( select count(*)
                                   from EvaluacionCurso e
                                  where e.ECcodigo   = #form.cboECcodigo#
                                    and e.Ccodigo    = #form.cboCurso#
                                    and e.PEcodigo   = #form.cboPeriodo#
                               )
     where ECcodigo   = #form.cboECcodigo#
       and Ccodigo    = #form.cboCurso#
       and PEcodigo   = #form.cboPeriodo#
    update EvaluacionCurso
	   set ECporcentaje = ECporcentaje +
                          (100-( select sum(ECporcentaje)
                                   from EvaluacionCurso e
                                  where e.ECcodigo   = #form.cboECcodigo#
                                    and e.Ccodigo    = #form.cboCurso#
                                    and e.PEcodigo   = #form.cboPeriodo#
                               )
                           )
     where ECcomponente = (select max(ECcomponente)
                             from EvaluacionCurso e
                            where e.ECcodigo   = #form.cboECcodigo#
                              and e.Ccodigo    = #form.cboCurso#
                              and e.PEcodigo   = #form.cboPeriodo#
                           )
  </cfquery>
</cfif>
</cfoutput>
</cftransaction>
