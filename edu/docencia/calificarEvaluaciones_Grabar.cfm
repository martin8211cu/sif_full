<cftransaction>
<cftry>

<cfoutput>
  <cfparam name="form.chkCerrarPeriodo" default="0">
  <cfif form.chkCerrarPeriodo eq "0" and form.hdnCerrarPeriodoAnt eq "1">
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_ref"
	 returnvariable="qryCorreos">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="referencias" value="st.Splaza"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
		<cfinvokeargument name="addCols" value="pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail, cu.Cnombre as Curso, PE.PEdescripcion as Periodo"/>
		<cfinvokeargument name="addTables" value="Curso cu, Staff st, PersonaEducativo pe, PeriodoEvaluacion PE"/>
		<cfinvokeargument name="addWhere" value="cu.Ccodigo  = #form.cboCurso#
                                             and cu.CEcodigo = #Session.Edu.CEcodigo#
		                                     and st.Splaza = cu.Splaza
											 and st.CEcodigo = cu.CEcodigo
		                                     and st.persona = pe.persona
											 and PE.PEcodigo = #cboPeriodo#"/>
	</cfinvoke>

	<!---
    <cfquery datasource="#Session.Edu.DSN#" name="qryCorreos">
      set nocount on
      select convert(varchar(18), s.Usucodigo) as Usucodigo, 
	         s.Ulocalizacion, 
			 Pnombre+' '+Papellido1+' '+Papellido2 as NombreDestino,
			 Pemail1 as Email,
	         c.Cnombre as Curso,
			 PE.PEdescripcion as Periodo
        from Staff s, Curso c, PersonaEducativo p, PeriodoEvaluacion PE
       where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
         and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
         and s.Splaza   = c.Splaza
         and s.Splaza   = c.CEcodigo
		 and s.persona = p.persona
		 and PE.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboPeriodo#">
      set nocount off
    </cfquery>
	--->
    <cfset LvarAsunto = "Notificacion Automatica por apertura de Periodo de Evaluacion Cerrado">
    <cfset LvarMsg = "Por este medio se le comunica que las evaluaciones del periodo #qryCorreos.Periodo#, del curso #qryCorreos.Curso#, las cuales se encontraban cerradas, han sido abiertas por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#'), por medio de la opción de Abrir Periodo en la pantalla de Evaluar Periodo">
	<cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos, true)>
  </cfif>

  <cfloop from="1" to="#form.txtCols#" index="LvarCol">
    <cfparam name="form.chkCerrar#LvarCol#" default="#form.chkCerrarPeriodo#">
	<cfif isdefined("form.txtEVTcodigo#LvarCol#")>
	  <cfset LvarTabla = Evaluate("form.txtEVTcodigo#LvarCol#")>
    <cfelse>
      <cfset LvarTabla = "">
    </cfif>
	<cfif Evaluate("form.chkCerrar#LvarCol#") eq "0" and Evaluate("form.hdnCerrar#LvarCol#Ant") eq "1">
		<cfset comp = Evaluate("form.txtECcomponente#LvarCol#")>
		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="get_usuario_by_ref"
		 returnvariable="qryCorreos">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="referencias" value="st.Splaza"/>
			<cfinvokeargument name="roles" value="edu.docente"/>
			<cfinvokeargument name="addCols" value="pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail, cu.Cnombre as Curso, PE.PEdescripcion as Periodo, cce.ECnombre + ' que compone al concepto ' + ce.ECnombre as Evaluacion"/>
			<cfinvokeargument name="addTables" value="Curso cu, 
			                                          Staff st, 
													  PersonaEducativo pe, 
													  PeriodoEvaluacion PE, 
													  EvaluacionCurso cce, 
													  EvaluacionConcepto ce"/>
			<cfinvokeargument name="addWhere" value="cu.Ccodigo  = #form.cboCurso#
												 and cu.CEcodigo = #Session.Edu.CEcodigo#
												 and st.Splaza = cu.Splaza
												 and st.CEcodigo = cu.CEcodigo
												 and st.persona = pe.persona
												 and PE.PEcodigo = #cboPeriodo#
												 and cce.ECcomponente = #comp#
												 and cce.ECcodigo = ce.ECcodigo"/>
		</cfinvoke>

	  <!---
      <cfquery datasource="#Session.Edu.DSN#" name="qryCorreos">
	     set nocount on
		 select <cfqueryparam cfsqltype="cf_sql_varchar" value="#usr.Usucodigo#"> as Usucodigo, 
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#usr.Ulocalizacion#"> as Ulocalizacion, 
			    Pnombre+' '+Papellido1+' '+Papellido2 as NombreDestino,
   		        Pemail1 as Email,
	            c.Cnombre as Curso,
			    PEdescripcion Periodo,
				cce.ECnombre + ' que compone al concepto ' + ce.ECnombre as Evaluacion
           from Staff s, Curso c, PersonaEducativo p, PeriodoEvaluacion PE,
		        EvaluacionCurso cce, EvaluacionConcepto ce
          where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
            and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
            and s.Splaza   = c.Splaza
			and s.CEcodigo = c.CEcodigo
		    and s.persona = p.persona
		    and PE.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cboPeriodo#">
			and cce.ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
			and cce.ECcodigo = ce.ECcodigo
	      set nocount off
      </cfquery>
	  --->
      <cfset LvarAsunto = "Notificacion Automatica por apertura de Componente de Evaluacion Cerrado">
      <cfset LvarMsg = "Por este medio se le comunica que las evaluaciones #qryCorreos.Evaluacion#, correspondientes al Periodo #qryCorreos.Periodo# del curso #qryCorreos.Curso#, las cuales se encontraban cerradas, han sido abiertas por el usuario '#qryUsuActual.Nombre#' (Login='#qryUsuActual.Login#'), por medio de la opción de Abrir Evaluación en la pantalla de Evaluar Periodo">
      <cfset fnNotificarCorreoBuzon ("","","","",LvarAsunto,LvarMSG,'Mensaje automático', LvarAsunto, qryCorreos, true)>
	</cfif>
    <cfloop from="1" to="#form.txtRows#" index="LvarLin">
	  <cfif LvarTabla eq "">
	    <cfset LvarNota = Evaluate("form.txtNota#LvarLin#_#LvarCol#")>
	    <cfset LvarValor = "">
      <cfelse>
	    <cfset LvarNota = Evaluate("form.cboValor#LvarLin#_#LvarCol#")>
        <cfset LvarValor = fnObtenerCodigoDeTabla(LvarTabla, LvarNota)>
      </cfif>
      <cfquery datasource="#Session.Edu.DSN#">
	    set nocount on
	    <cfif LvarNota eq "">
          delete AlumnoCalificacion
           where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		     and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			 and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			 and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
		<cfelse>
		  if exists(select * from AlumnoCalificacion
                     where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		               and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			           and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
					   and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
					)
            update AlumnoCalificacion
                   set ACnota       = #LvarNota#
					 , ACvalor      = <cfif LvarValor eq "">null<cfelse>'#LvarValor#'</cfif>
					 , ACcerrado    = '#Evaluate("form.chkCerrar#LvarCol#")#'
             where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
	  	       and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			   and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			   and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
		  else
            insert into AlumnoCalificacion
                   (Ecodigo, CEcodigo, Ccodigo, ECcomponente, ACnota, ACvalor, ACcerrado)
            values (#Evaluate("form.txtEcodigo#LvarLin#")#, 
		            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
		            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">, 
		            #Evaluate("form.txtECcomponente#LvarCol#")#, 
		            #LvarNota#, 
 				    <cfif LvarValor eq "">null<cfelse>'#LvarValor#'</cfif>,
				    '#Evaluate("form.chkCerrar#LvarCol#")#')
		</cfif>
	    set nocount off
	  </cfquery>
    </cfloop>
  </cfloop>

  <cfloop from="1" to=#form.txtRows# index="LvarLin">
      <cfquery datasource="#Session.Edu.DSN#">
	    set nocount on
	    <cfif not isdefined("form.txtEVTcodigoM")>
          <cfset LvarAjuste   = Evaluate("form.txtAjuste#LvarLin#")>
          <cfset LvarProgreso = Evaluate("form.txtProgreso#LvarLin#")>
            <cfset LvarGanado = Evaluate("form.txtGanado#LvarLin#")>
          <cfset LvarGanadoValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
		<cfelse>
          <cfset LvarAjuste = Evaluate("form.cboAjuste#LvarLin#")>
          <cfset LvarAjusteValor = fnObtenerCodigoDeTabla(form.txtEVTcodigoM, LvarAjuste)>

          <cfset LvarProgresoValor = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarProgreso = fnObtenerValorDeTabla(form.txtEVTcodigoM, LvarProgresoValor)>
            <cfset LvarGanadoValor = Evaluate("form.txtGanado#LvarLin#")>
            <cfset LvarGanado = fnObtenerValorDeTabla(form.txtEVTcodigoM, LvarGanadoValor)>
		</cfif>
		
        <cfif LvarGanado eq "" and LvarAjuste eq "" and LvarProgreso eq "">
          delete AlumnoCalificacionPerEval 
           where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
             and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
             and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
        <cfelse>
 		<cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
		<cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
 		<cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
		  if exists(select * from AlumnoCalificacionPerEval
                     where PEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
                       and Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		               and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			           and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
					)
			begin
				update AlumnoCalificacionPerEval 
				   set ACPEnota           = #LvarGanado#
					 , ACPEnotacalculada  = #LvarAjuste#
					 , ACPEnotaprog       = #LvarProgreso#
					 , ACPEvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
					 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
					 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
					 , ACPEcerrado        = '#form.chkCerrarPeriodo#'
				 where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
				   and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
				   and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				   and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">
			end
          else
		  begin   
            insert into AlumnoCalificacionPerEval 
                   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
				    ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
				    ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
					ACPEcerrado)
            values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">, 
		            #Evaluate("form.txtEcodigo#LvarLin#")#, 
		            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
		            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso#">, 
		            #LvarGanado#,  
		            #LvarAjuste#, 
					#LvarProgreso#,
					<cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>,
					<cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
					<cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
				    '#form.chkCerrarPeriodo#')
		  end
        </cfif>
    	set nocount off
	  </cfquery>
		
      <!---  Actualiza el período del Curso Complementario --->
      <cfif qryComplementaria.Curso neq "">
        <cfquery datasource="#Session.Edu.DSN#" name="qryComplementos">
	      set nocount on
          select round(avg (ACPEnota),2)           as Ganado,
                 round(avg (ACPEnotacalculada),2)  as Ajuste,
                 round(avg (ACPEnotaprog),2)       as Progreso
            from AlumnoCalificacionPerEval n, 
                 Curso c, MateriaElectiva ME, Materia MRc, Curso CRc
           where c.Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
             and n.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
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
          delete AlumnoCalificacionPerEval 
           where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
             and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
             and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
        <cfelse>
          <cfif LvarGanado eq ""><cfset LvarGanado = "null"><cfelse><cfset LvarGanado = Replace(LvarGanado, "%", "")></cfif>
          <cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
          <cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
          if exists(select * from AlumnoCalificacionPerEval
                     where PEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
                       and Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
                       and CEcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
                       and Ccodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
                    )
            update AlumnoCalificacionPerEval 
               set ACPEnota           = #LvarGanado#
                 , ACPEnotacalculada  = #LvarAjuste#
                 , ACPEnotaprog       = #LvarProgreso#
                 , ACPEvalor          = <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>
                 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACPEcerrado        = '#form.chkCerrarPeriodo#'
             where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">
               and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
               and Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">
          else   
            insert into AlumnoCalificacionPerEval 
                   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
                    ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
                    ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
                    ACPEcerrado)
            values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo#">, 
                    #Evaluate("form.txtEcodigo#LvarLin#")#, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#qryComplementaria.Curso#">, 
                    #LvarGanado#,  
                    #LvarAjuste#, 
                    #LvarProgreso#,
                    <cfif LvarGanadoValor eq "">null<cfelse>'#LvarGanadoValor#'</cfif>,
                    <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
                    <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
                    '#form.chkCerrarPeriodo#')
        </cfif>
	    set nocount off
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
