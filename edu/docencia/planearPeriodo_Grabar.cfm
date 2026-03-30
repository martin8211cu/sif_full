<cffunction name="fnRecalcularPesos" returntype="boolean">
           <cfargument name="LprmECcodigo" required="true" type="numeric">
  <cfquery datasource="#Session.Edu.DSN#" name="qryRecalculo">
    begin tran
    set nocount on
	
  <!--- 
        Se asegura que haya por lo menos un Automatico, si no hay convierte en automatico: primero el actual y luego todos
        Se asegura que no sume mas de 100, si suma mas de 100 convierte en automatico: primero el actual y luego todos
        Convierte los Manuales sin Porcentaje a Automaticos
        Actualiza los automaticos con:   (100-TotalManuales) / CantidadAutomaticos
        Ajuste el ultimo automatico con: SuPorcentaje + (100 - TotalTodos)
  !--->
    -- Por lo menos un automatico y la suma de Manuales debe ser menor que 100 
	-- si no: convierte el actual a automatico
    if ( select count(*)
           from EvaluacionCurso e
          where e.ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
            and e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
            and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			and e.ECtipoPorcentaje = 'A'
        ) = 0
	AND
       ( select count(*)
           from EvaluacionCurso e
          where e.ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
            and e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
            and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
        ) > 0
	begin
	  -- raiserror 40000 'ERROR: debe haber por lo menos una Evaluacion Automatica'
	  select msg='Debe haber por lo menos una Evaluacion Automatica'
	  rollback tran
	  return
	end
    if ( select isnull(sum(ECporcentaje),0)
           from EvaluacionCurso e
          where e.ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
            and e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
            and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			and e.ECtipoPorcentaje = 'M' 
        ) >= 100
	begin
	  --raiserror 40000 'ERROR: La suma de las Evaluaciones Manuales debe ser menor que 100'
	  select msg='La suma de las Evaluaciones Manuales debe ser menor que 100'
	  rollback tran
	  return
	end

    -- Convierte a Automaticos los que no tienen porcentaje
    update EvaluacionCurso
       set ECtipoPorcentaje = 'A'
     where ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
       and Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	   and (isnull(ECporcentaje, 0.00) = 0.00
	    or ECtipoPorcentaje != 'M' and ECtipoPorcentaje != 'A')

    -- Calcula: PorcentajeAutomatico = (100-TotalManuales) / CantidadAutomaticos
    update EvaluacionCurso
	   set ECporcentaje = convert(numeric(5,2), 
	                           (100.0 -
                                 ( select isnull(sum(e.ECporcentaje),0)
                                     from EvaluacionCurso e
                                    where e.ECcodigo   = ec.ECcodigo
                                      and e.Ccodigo    = ec.Ccodigo
                                      and e.PEcodigo   = ec.PEcodigo
								      and e.ECtipoPorcentaje = 'M'
                                 )
							   ) 
							   /
                               ( select count(*)
                                   from EvaluacionCurso e
                                  where e.ECcodigo   = ec.ECcodigo
                                    and e.Ccodigo    = ec.Ccodigo
                                    and e.PEcodigo   = ec.PEcodigo
								    and e.ECtipoPorcentaje = 'A'
                               )
						  )
      from EvaluacionCurso ec
     where ec.ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
       and ec.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and ec.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	   and ec.ECtipoPorcentaje = 'A'

    -- Ajusta: PorcentajeDelUltimoAutomatico + (100 - TotalTodos)
    update EvaluacionCurso
	   set ECporcentaje = ec.ECporcentaje +
                          (100.0-( select sum(e.ECporcentaje)
                                   from EvaluacionCurso e
                                  where e.ECcodigo   = ec.ECcodigo
                                    and e.Ccodigo    = ec.Ccodigo
                                    and e.PEcodigo   = ec.PEcodigo
                               )
                           )
      from EvaluacionCurso ec
     where ec.ECcomponente = (select max(e.ECcomponente)
                             from EvaluacionCurso e
                            where e.ECcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LprmECcodigo#">
                              and e.Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
                              and e.PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
							  and e.ECtipoPorcentaje = 'A'
                           )
	select msg='OK'
    set nocount off
  </cfquery>
  <cfif qryRecalculo.msg eq 'OK'>
    <cfreturn true>
  <cfelse>
  	<cftransaction action="rollback">
    <cfset LvarURL = "../errorPages/BDerror.cfm?errType=0&errMsg=">
    <cfset LvarURL = LvarURL & urlencodedformat("#qryRecalculo.msg#") & "&errDet=" & urlencodedformat("Recalculo de Porcentajes Automaticos de un Concepto de Evaluacion")>
	<cflocation addtoken="no" url=#LvarURL#>
    <cfreturn false>
  </cfif>
</cffunction>

<cftransaction>
<cftry>

<cfoutput>
<cfset LvarAjustarEvaluaciones=false>
<cfset LvarResecuenciar=0>
<cfset LvarDuracion=0>
<cfset LvarMSG = "">
<cfparam name="form.hdnECcodigoAnt" default="">
<cfif isDefined("form.btnAgregar")>
  <cfquery datasource="#Session.Edu.DSN#" name="qryInsert">
  set nocount on
  <cfif form.hdnTipoOperacion eq "T">
    <cfset LvarDuracion=Val(form.txtDuracion)>
    insert into CursoPrograma
	      (Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPfecha, CPduracion, CPcubierto, CPorden)
    values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtNombre#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">,
		   '#lsDateFormat(form.txtFecha,"YYYYMMDD")#',
		   <cfif #form.txtDuracion# gt 1>1<cfelse>#form.txtDuracion#</cfif>, 
		   <cfif isdefined('form.chkCubierto')>'S'<cfelse>'N'</cfif>, 
		   #form.txtOrden#)
  <cfelseif form.hdnTipoOperacion eq "E">
    insert into EvaluacionCurso
	      (ECcodigo, Ccodigo, PEcodigo, ECnombre, ECenunciado, ECplaneada, ECduracion, ECevaluado, ECorden,
		  EVTcodigo, 
		  EMcomponente, ECporcentaje, ECtipoPorcentaje)              
    values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboECcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtNombre#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">,
		'#lsDateFormat(form.txtFecha,"YYYYMMDD")#',
	      <cfif #form.txtDuracion# gt 1>1<cfelse>#form.txtDuracion#</cfif>, 
	      <cfif isdefined("form.chkCubierto")>'S'<cfelse>'N'</cfif>, #form.txtOrden#, #form.cboEVTcodigo#, 
		   null,
        <cfif #form.cboTipoPorcentaje# eq 'A'>
		   0, 'A')
		<cfelse>
 		   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.txtPorcentaje#">,'M')
		</cfif>
    <cfset form.hdnECcodigoAnt = form.cboECcodigo>
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
  select convert(varchar,@@identity) as ID
  set nocount off
  </cfquery>

  <cfset form.hdnCodigo=qryInsert.ID>
  <cfset LvarResecuenciar=1>
  <cfset LvarFecha1 = form.txtFecha>
  <cfset form.hdnTipoOperacion = "">
<cfelseif isDefined("form.btnCambiar")>
  <cfif form.hdnOrden neq "" and val(form.hdnOrden) lt val(form.txtOrden)>
    <cfset form.txtOrden = val(form.txtOrden)+1>
  </cfif>
  <cfquery datasource="#Session.Edu.DSN#">
  <cfif form.hdnTipoOperacion eq "T">
    set nocount on
    update CursoPrograma
	   set CPnombre      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtNombre#">
	     , CPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">
		 , CPfecha       = '#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
		 , CPduracion    = <cfif #form.txtDuracion# gt 1>1<cfelse>#form.txtDuracion#</cfif>
		 , CPcubierto    = <cfif isdefined("form.chkCubierto")>'S'<cfelse>'N'</cfif>
		 , CPorden       = #form.txtOrden#
     where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
  <cfelseif form.hdnTipoOperacion eq "E">
    update EvaluacionCurso
	   set ECnombre    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtNombre#">
	     , ECenunciado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtDescripcion#">
		 , ECplaneada  = '#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
		 , ECduracion  = <cfif #form.txtDuracion# gt 1>1<cfelse>#form.txtDuracion#</cfif>
		 , ECevaluado  = <cfif isdefined("form.chkCubierto")>'S'<cfelse>'N'</cfif>
		 , ECorden     = #form.txtOrden#
		 , EVTcodigo   = #form.cboEVTcodigo#
        <cfif #form.cboTipoPorcentaje# eq 'A'>
 		  , ECporcentaje = 0
 		  , ECtipoPorcentaje = 'A'
		<cfelse>
 		  , ECporcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.txtPorcentaje#" scale="2">
 		  , ECtipoPorcentaje = 'M'
		</cfif>
        <cfif form.hdnECcodigoAnt neq form.cboECcodigo>
 		  , ECcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboECcodigo#">
		</cfif>
     where ECcomponente = #form.hdnCodigo#
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
    set nocount off
  </cfquery>

  <cfset LvarResecuenciar=2>
  <cfset LvarFecha1 = form.hdnFechaAnt>
  <cfset LvarFecha2 = form.txtFecha>
  <cfset form.hdnTipoOperacion = "">
  <cfset LvarDuracion=Val(form.txtDuracion)>
<cfelseif isDefined("form.btnBorrar")>
  <cfquery datasource="#Session.Edu.DSN#">
  set nocount on
  <cfif form.hdnTipoOperacion eq "T">
    delete CursoPrograma
     where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
  <cfelseif form.hdnTipoOperacion eq "E">
    delete EvaluacionCurso
     where ECcomponente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
    <cfset form.hdnECcodigoAnt = form.cboECcodigo>
    <cfset LvarAjustarEvaluaciones=true>
  </cfif>
  set nocount off
  </cfquery>

  <cfset LvarResecuenciar=1>
  <cfset LvarFecha1 = form.txtFecha>
  <cfset form.hdnTipoOperacion = "">
<cfelseif isDefined("form.btnRecalendarizar")>
  <cfif form.cboTipoRecal eq "Correr">
    <cfset LvarResecuenciar=1>
    <cfset LvarFecha1 = form.txtFecha>
    <cfset LvarLecciones = 0>
    <cfset LvarFecha=lsParseDatetime(form.txtFecha)>
    <cfloop condition="LvarLecciones lt form.txtDuracion">
      <cfif fnEsLeccion(LvarFecha, true)>
	    <cfif form.cboTipoCorrer eq "-">
          <cfquery datasource="#Session.Edu.DSN#" name="qryEvento">
		    set nocount on
			select(
	        <cfif isdefined("form.chkTemas")>
              select count(*) 
			    from CursoPrograma
               where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
                 and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
                 and CPfecha  ='#lsDateFormat(LvarFecha,"YYYYMMDD")#'
				 and isnull(CPcubierto,'N') <> 'S'
			<cfelse>
			   0
			</cfif>
			  ) + (
	        <cfif isdefined("form.chkEvaluaciones")>
              select count(*) 
			    from EvaluacionCurso
               where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
                 and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
                 and ECplaneada ='#lsDateFormat(LvarFecha,"YYYYMMDD")#'
				 and isnull(ECevaluado,'N') <> 'S'
			<cfelse>
			   0
			</cfif>
			   ) as Numero
		    set nocount off
          </cfquery>
		  <cfif qryEvento.Numero gt 0>
		    <cfset LvarMSG = "ERROR: Existen eventos en las lecciones a borrar, no se puede recalendarizar">
			<cfbreak>
          </cfif>
        </cfif>
		<cfif qryFeriado.Fecha eq "">
          <cfset LvarLecciones = LvarLecciones +1>
		</cfif>
      </cfif>
      <cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
    </cfloop>

	<cfif LvarMSG eq "">
      <cfif form.cboTipoCorrer eq "+">
	    <cfset LvarFechaOri = lsParseDatetime(form.txtFecha)>
		<cfset LvarFechaDst = LvarFecha>
	  <cfelse>
	    <cfset LvarFechaOri = LvarFecha>
		<cfset LvarFechaDst = lsParseDatetime(form.txtFecha)>
	  </cfif>

      <cfquery datasource="#Session.Edu.DSN#">
      set nocount on
	  <cfset LvarPrimera = true>
      <cfloop condition="LvarFechaOri lte qryLimite.Final"> 
<!---        <cfloop condition='Find("*" & (datepart("w",LvarFechaOri)) & "*", GvarHorarios) eq 0'> 
--->
        <cfloop condition='not fnEsLeccion(LvarFechaOri, true)'>
          <cfset LvarFechaOri=DateAdd("d", 1, LvarFechaOri)>
        </cfloop>
<!---        <cfloop condition='Find("*" & (datepart("w",LvarFechaDst)) & "*", GvarHorarios) eq 0'>
--->
        <cfloop condition='not fnEsLeccion(LvarFechaDst, true)'>
          <cfset LvarFechaDst=DateAdd("d", 1, LvarFechaDst)>
        </cfloop>
        <cfif isdefined("form.chkTemas")>
	      update CursoPrograma
             set CPfecha ='#lsDateFormat(LvarFechaDst,"YYYYMMDD")#'
	           <cfif form.cboTipoCorrer eq "+">, CPorden = -abs(CPorden)</cfif>
           where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
             and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
             and CPfecha  ='#lsDateFormat(LvarFechaOri,"YYYYMMDD")#'
			 and isnull(CPcubierto,'N') <> 'S'
	         <cfif form.cboTipoCorrer eq "+">and CPorden >= 0</cfif>
             <cfif LvarPrimera>and CPorden >= #form.txtOrden#<cfset LvarFecha1 = LvarFechaDst></cfif>
        </cfif>
        <cfif isdefined("form.chkEvaluaciones")>
          update EvaluacionCurso
             set ECplaneada ='#lsDateFormat(LvarFechaDst,"YYYYMMDD")#'
		       <cfif form.cboTipoCorrer eq "+">, ECorden = -abs(ECorden)</cfif>
           where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
             and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
             and ECplaneada ='#lsDateFormat(LvarFechaOri,"YYYYMMDD")#'
			 and isnull(ECevaluado,'N') <> 'S'
			 <cfif form.cboTipoCorrer eq "+">and ECorden >= 0</cfif>
             <cfif LvarPrimera>and ECorden >= #form.txtOrden#</cfif>
        </cfif>
		<cfif LvarPrimera>
		  <cfset LvarPrimera=false>
		</cfif>
        <cfset LvarFechaOri=DateAdd("d", 1, LvarFechaOri)>
        <cfset LvarFechaDst=DateAdd("d", 1, LvarFechaDst)>
      </cfloop>
      <cfif form.cboTipoCorrer eq "+">
        <cfif isdefined("form.chkTemas")>
	      update CursoPrograma
             set CPorden = -CPorden
           where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
             and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			 and CPorden < 0
        </cfif>
        <cfif isdefined("form.chkEvaluaciones")>
          update EvaluacionCurso
             set ECorden = -ECorden
           where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
             and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
			 and ECorden < 0
        </cfif>
	  </cfif>
      set nocount off
      </cfquery>
	</cfif>
  <cfelse>
    <cfset LvarResecuenciar=1>
	<cfset LvarFecha1 = form.txtAlaFecha>
    <cfquery datasource="#Session.Edu.DSN#">
      set nocount on
      <cfif isdefined("form.chkTemas")>
	    update CursoPrograma
           set CPfecha ='#lsDateFormat(form.txtAlaFecha,"YYYYMMDD")#'
         where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
           and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
           and CPfecha  ='#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
           and CPorden >= #form.txtOrden#
      </cfif>
      <cfif isdefined("form.chkEvaluaciones")>
        update EvaluacionCurso
           set ECplaneada ='#lsDateFormat(form.txtAlaFecha,"YYYYMMDD")#'
         where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
           and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
           and ECplaneada ='#lsDateFormat(form.txtFecha,"YYYYMMDD")#'
           and ECorden >= #form.txtOrden#
      </cfif>
      set nocount off
    </cfquery>
  </cfif>
<cfelseif isDefined("form.btnGrabarConceptos")>
  <cfquery datasource="#Session.Edu.DSN#">
    set nocount on
    <cfloop from="1" to="#form.txtCantidad#" index="LvarRow">
	  <cfif evaluate("form.txtECprc#LvarRow#") eq "">
	    delete EvaluacionConceptoCurso 
		 where ECcodigo = #evaluate("form.txtECcod#LvarRow#")#
		   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
	  <cfelse>
	    if exists (select * from EvaluacionConceptoCurso
                    where ECcodigo = #evaluate("form.txtECcod#LvarRow#")#
                      and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
                      and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">)
		  update EvaluacionConceptoCurso 
		     set ECCporcentaje = #evaluate("form.txtECprc#LvarRow#")#
           where ECcodigo = #evaluate("form.txtECcod#LvarRow#")#
		     and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		     and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
		else
		  insert into EvaluacionConceptoCurso (ECcodigo, Ccodigo, PEcodigo, ECCporcentaje) 
		  values (#evaluate("form.txtECcod#LvarRow#")#, #form.cboCurso#, #form.cboPeriodo#, #evaluate("form.txtECprc#LvarRow#")#)
	  </cfif>
	</cfloop>
    set nocount off
  </cfquery>
</cfif>

<cfparam name="form.txtFecha" default="">
<cfif form.txtFecha neq "">
  <cfset LvarFecha = lsParseDatetime(form.txtFecha)>
</cfif>
<cfif LvarDuracion gt 1>
  <cfset LvarFechaFinal=DateAdd("d", 30, qryLimitePeriodo.Final)>
  <cfset LvarDuracion = LvarDuracion - 1>
  <cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
  <cfloop condition="LvarDuracion gt 0">
    <cfif fnEsLeccion(LvarFecha, true)>
      <cfquery datasource="#Session.Edu.DSN#">
	    set nocount on
        insert into CursoPrograma
    	      (Ccodigo, PEcodigo, CPnombre, CPdescripcion, CPfecha, CPduracion, CPcubierto, CPorden)
        select Ccodigo, PEcodigo, CPnombre, CPdescripcion, #LvarFecha#, <cfif LvarDuracion gt 1>1<cfelse>#LvarDuracion#</cfif>, 'N', CPorden+100
          from CursoPrograma
		 where Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
		   and CPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.hdnCodigo#">
	    set nocount off
      </cfquery>
	  <cfset LvarDuracion = LvarDuracion -1>
	</cfif>

    <cfset LvarFecha=DateAdd("d", 1, LvarFecha)>
    <cfif LvarFecha gt LvarFechaFinal>
	  <cfset LvarDuracion = -1>
    </cfif>

  </cfloop>
</cfif>

<cfif LvarResecuenciar neq 0>
  <cfquery datasource="#Session.Edu.DSN#">
  set nocount on
  <cfif form.hdnCodigo neq "">
    update CursoPrograma 
       set CPorden = isnull(CPorden,0)+1
      from CursoPrograma p
     where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and (CPfecha  ='#lsDateFormat(LvarFecha1,"YYYYMMDD")#'<cfif LvarResecuenciar eq 2> or CPfecha ='#lsDateFormat(LvarFecha2,"YYYYMMDD")#'</cfif>)
       and CPorden >= #form.txtOrden#
	   and CPcodigo <> #form.hdnCodigo#

    update EvaluacionCurso
       set ECorden = isnull(ECorden, 0)+1
     where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and (ECplaneada  ='#lsDateFormat(LvarFecha1,"YYYYMMDD")#'<cfif LvarResecuenciar eq 2> or ECplaneada ='#lsDateFormat(LvarFecha2,"YYYYMMDD")#'</cfif>)
       and ECorden   >= #form.txtOrden#
	   and ECcomponente <> #form.hdnCodigo#
  </cfif>

    update CursoPrograma 
       set CPorden =
                 (select count(*)
                    from CursoPrograma c
                   where c.Ccodigo =p.Ccodigo
                     and c.PEcodigo=p.PEcodigo
                     and c.CPfecha =p.CPfecha
                     and (c.CPorden < p.CPorden
                      or (c.CPorden = p.CPorden and c.CPcodigo <= p.CPcodigo))
                 ) +
                 (select count(*)
                    from EvaluacionCurso c
                   where c.Ccodigo =p.Ccodigo
                     and c.PEcodigo=p.PEcodigo
                     and c.ECplaneada =p.CPfecha
                     and (c.ECorden < p.CPorden
                      or (c.ECorden = p.CPorden and c.ECcomponente <= p.CPcodigo))
                 )
      from CursoPrograma p
     where Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and (CPfecha  ='#lsDateFormat(LvarFecha1,"YYYYMMDD")#'<cfif LvarResecuenciar eq 2> or CPfecha ='#lsDateFormat(LvarFecha2,"YYYYMMDD")#'</cfif>)

    update EvaluacionCurso
       set ECorden =
                 (select count(*)
                    from CursoPrograma c
                   where c.Ccodigo =p.Ccodigo
                     and c.PEcodigo=p.PEcodigo
                     and c.CPfecha =p.ECplaneada
                     and (c.CPorden < p.ECorden
                      or (c.CPorden = p.ECorden and c.CPcodigo <= p.ECcomponente))
                 ) +
                 (select count(*)
                    from EvaluacionCurso c
                   where c.Ccodigo =p.Ccodigo
                     and c.PEcodigo=p.PEcodigo
                     and c.ECplaneada =p.ECplaneada
                     and (c.ECorden < p.ECorden
                      or (c.ECorden = p.ECorden and c.ECcomponente <= p.ECcomponente))
                 )
      from EvaluacionCurso p
     where Ccodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
       and PEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
       and (ECplaneada ='#lsDateFormat(LvarFecha1,"YYYYMMDD")#'<cfif LvarResecuenciar eq 2> or ECplaneada ='#lsDateFormat(LvarFecha2,"YYYYMMDD")#'</cfif>)
  set nocount off
  </cfquery>
</cfif>

<cfif LvarAjustarEvaluaciones> 
  <cfif fnRecalcularPesos(form.cboECcodigo) and form.hdnECcodigoAnt neq form.cboECcodigo>
    <cfset fnRecalcularPesos(form.hdnECcodigoAnt)>
  </cfif>
</cfif>
</cfoutput>

<cfquery datasource="#Session.Edu.DSN#" name="qryRecalculo">while @@trancount>0 commit tran</cfquery>

<cfcatch>
    <cfset LvarURL = "../errorPages/BDerror.cfm?errType=0&errMsg=">
	<cfif isDefined("form.btnBorrar")>
	  <cfset LvarURL = LvarURL & urlencodedformat("No se puede borrar porque el evento esta siendo utilizando:<br><br>")>
	</cfif>
    <cfset LvarURL = LvarURL & urlencodedformat(cfcatch.Detail) 
	               & "&errDet=" & urlencodedformat(cfcatch.Message)>
	<cflocation addtoken="no" url=#LvarURL#>
</cfcatch>
</cftry>
</cftransaction>
<!--- 

<form action="planearPeriodo.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cfabort>

 --->