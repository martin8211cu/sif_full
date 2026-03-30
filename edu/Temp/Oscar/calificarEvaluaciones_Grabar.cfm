<cffunction name="fnObtenerCodigoDeTabla">
           <cfargument name="LprmTabla" required="true" type="string">
           <cfargument name="LprmValor" required="true" type="string">
  <cfif LprmValor eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Codigo
         from qryValoresTabla
        where Tabla = #LprmTabla#
          and #LprmValor# between Minimo and Maximo
    </cfquery>
    <cfreturn qryValor.Codigo>
  </cfif>
</cffunction>

<cffunction name="fnObtenerValorDeTabla">
           <cfargument name="LprmTabla" required="true" type="string">
           <cfargument name="LprmCodigo" required="true" type="string">
  <cfif LprmCodigo eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Equivalente
         from qryValoresTabla
        where Tabla = #LprmTabla#
          and Codigo = '#LprmCodigo#'
    </cfquery>
    <cfreturn qryValor.Equivalente>
  </cfif>
</cffunction>

<cftransaction>
<cfoutput>
  <cfparam name="form.chkCerrarPeriodo" default="0">
  <!--- ENVIAR MAIL 
  <cfif Evaluate("form.chkCerrarPeriodo") eq "0">
    <cfquery datasource="Educativo" name="qryMailPeriodoAbierto">
      select * from AlumnoCalificacionPerEval
       where PEcodigo     = #form.cboPeriodo#
         and CEcodigo     = #Session.CENEDCODIGO#
         and Ccodigo      = #form.cboCurso#
         and ACPEcerrado  = '1'
    </cfquery>
  </cfif>
  ENVIAR MAIL ---> 
  <cfloop from="1" to=#form.txtCols# index="LvarCol">
    <cfparam name="form.chkCerrar#LvarCol#" default="#form.chkCerrarPeriodo#">
	<cfif isdefined("form.txtEVTcodigo#LvarCol#")>
	  <cfset LvarTabla = Evaluate("form.txtEVTcodigo#LvarCol#")>
    <cfelse>
      <cfset LvarTabla = "">
    </cfif>
    <!--- ENVIAR MAIL 
	<cfif Evaluate("form.chkCerrar#LvarCol#") eq "0">
      <cfquery datasource="Educativo" name="qryMailConceptosAbiertos">
        select * from AlumnoCalificacion n, EvaluacionCurso ec
         where n.CEcodigo     = #Session.CENEDCODIGO#
           and n.Ccodigo      = #form.cboCurso#
           and n.ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
           and n.ACcerrado    = '1'
		   and ec.ECcomponente = n.ECcomponente
      </cfquery>
	</cfif>
	ENVIAR MAIL --->
    <cfloop from="1" to=#form.txtRows# index="LvarLin">
	  <cfif LvarTabla eq "">
	    <cfset LvarNota = Evaluate("form.txtNota#LvarLin#_#LvarCol#")>
	    <cfset LvarValor = "">
      <cfelse>
	    <cfset LvarNota = Evaluate("form.cboValor#LvarLin#_#LvarCol#")>
        <cfset LvarValor = fnObtenerCodigoDeTabla(LvarTabla, LvarNota)>
      </cfif>
      <cfquery datasource="Educativo">
	    <cfif LvarNota eq "">
          delete AlumnoCalificacion
           where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		     and CEcodigo     = #Session.CENEDCODIGO#
			 and Ccodigo      = #form.cboCurso#
			 and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
		<cfelse>
		  if exists(select * from AlumnoCalificacion
                     where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		               and CEcodigo     = #Session.CENEDCODIGO#
			           and Ccodigo      = #form.cboCurso#
					   and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
					)
            update AlumnoCalificacion
                   set ACnota       = #LvarNota#
					 , ACvalor      = <cfif LvarValor eq "">null<cfelse>'#LvarValor#'</cfif>
					 , ACcerrado    = '#Evaluate("form.chkCerrar#LvarCol#")#'
             where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
	  	       and CEcodigo     = #Session.CENEDCODIGO#
			   and Ccodigo      = #form.cboCurso#
			   and ECcomponente = #Evaluate("form.txtECcomponente#LvarCol#")#
		  else
            insert into AlumnoCalificacion
                   (Ecodigo, CEcodigo, Ccodigo, ECcomponente, ACnota, ACvalor, ACcerrado)
            values (#Evaluate("form.txtEcodigo#LvarLin#")#, 
		            #Session.CENEDCODIGO#, 
		            #form.cboCurso#, 
		            #Evaluate("form.txtECcomponente#LvarCol#")#, 
		            #LvarNota#, 
 				    <cfif LvarValor eq "">null<cfelse>'#LvarValor#'</cfif>,
				    '#Evaluate("form.chkCerrar#LvarCol#")#')
		</cfif>
	  </cfquery>
    </cfloop>
  </cfloop>

  <cfloop from="1" to=#form.txtRows# index="LvarLin">
      <cfquery datasource="Educativo">
	    <cfif not isdefined("form.txtEVTcodigoM")>
          <cfset LvarAjuste   = Evaluate("form.txtAjuste#LvarLin#")>
          <cfset LvarProgreso = Evaluate("form.txtProgreso#LvarLin#")>
          <cfif form.chkCerrarPeriodo eq "1">
            <cfset LvarPromedio = LvarProgreso>
		  <cfelse>
            <cfset LvarPromedio = Evaluate("form.txtPromedio#LvarLin#")>
          </cfif>
          <cfset LvarPromedioValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
		<cfelse>
          <cfset LvarAjuste = Evaluate("form.cboAjuste#LvarLin#")>
          <cfset LvarAjusteValor = fnObtenerCodigoDeTabla(form.txtEVTcodigoM, LvarAjuste)>

          <cfset LvarProgresoValor = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarProgreso = fnObtenerValorDeTabla(form.txtEVTcodigoM, LvarProgresoValor)>
          <cfif form.chkCerrarPeriodo eq "1">
            <cfset LvarPromedioValor = LvarProgresoValor>
            <cfset LvarPromedio = LvarProgreso>
		  <cfelse>
            <cfset LvarPromedioValor = Evaluate("form.txtPromedio#LvarLin#")>
            <cfset LvarPromedio = fnObtenerValorDeTabla(form.txtEVTcodigoM, LvarPromedioValor)>
          </cfif>
		</cfif>
        <cfif LvarPromedio eq "" and LvarAjuste eq "" and LvarProgreso eq "">
          delete AlumnoCalificacionPerEval 
           where PEcodigo = #form.cboPeriodo#
             and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = #Session.CENEDCODIGO#
             and Ccodigo  = #form.cboCurso#
        <cfelse>
 		<cfif LvarPromedio eq ""><cfset LvarPromedio = "null"><cfelse><cfset LvarPromedio = Replace(LvarPromedio, "%", "")></cfif>
		<cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
 		<cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
		  if exists(select * from AlumnoCalificacionPerEval
                     where PEcodigo     = #form.cboPeriodo#
                       and Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
		               and CEcodigo     = #Session.CENEDCODIGO#
			           and Ccodigo      = #form.cboCurso#
					)
            update AlumnoCalificacionPerEval 
               set ACPEnota           = #LvarPromedio#
                 , ACPEnotacalculada  = #LvarAjuste#
                 , ACPEnotaprog       = #LvarProgreso#
                 , ACPEvalor          = <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>
                 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACPEcerrado        = '#form.chkCerrarPeriodo#'
             where PEcodigo = #form.cboPeriodo#
               and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = #Session.CENEDCODIGO#
               and Ccodigo  = #form.cboCurso#
          else   
            insert into AlumnoCalificacionPerEval 
                   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
				    ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
				    ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
					ACPEcerrado)
            values (#form.cboPeriodo#, 
		            #Evaluate("form.txtEcodigo#LvarLin#")#, 
		            #Session.CENEDCODIGO#, 
		            #form.cboCurso#, 
		            #LvarPromedio#,  
		            #LvarAjuste#, 
					#LvarProgreso#,
					<cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>,
					<cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
					<cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
				    '#form.chkCerrarPeriodo#')
        </cfif>
	  </cfquery>

      <!---  Actualiza el período del Curso Complementario --->
      <cfif qryComplementaria.Curso neq "">
        <cfquery datasource="educativo" name="qryComplementos">
          select round(avg (ACPEnota),2)           as Promedio,
                 round(avg (ACPEnotacalculada),2)  as Ajuste,
                 round(avg (ACPEnotaprog),2)       as Progreso
            from AlumnoCalificacionPerEval n, 
                 Curso c, MateriaElectiva ME, Materia MRc, Curso CRc
           where c.Ccodigo  = #qryComplementaria.Curso#
             and n.PEcodigo = #form.cboPeriodo#
             and n.Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and n.CEcodigo = #Session.CENEDCODIGO#
             and n.Ccodigo  = CRc.Ccodigo
             and ME.Melectiva     = #qryComplementaria.Materia#
             and ME.Mconsecutivo  = MRc.Mconsecutivo
             and MRc.Melectiva    = 'R'
             and CRc.Mconsecutivo = MRc.Mconsecutivo
             and CRc.CEcodigo     = c.CEcodigo
             and CRc.PEcodigo     = c.PEcodigo
             and CRc.SPEcodigo    = c.SPEcodigo
             and CRc.GRcodigo     = c.GRcodigo
        </cfquery>
        <cfif qryComplementaria.Tabla eq "">
          <cfset LvarPromedio = qryComplementos.Promedio>
          <cfset LvarAjuste   = qryComplementos.Ajuste>
          <cfset LvarProgreso = qryComplementos.Progreso>
          <cfset LvarPromedioValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
        <cfelse>
          <cfset LvarPromedio = qryComplementos.Promedio>
          <cfset LvarAjuste   = qryComplementos.Ajuste>
          <cfset LvarProgreso = qryComplementos.Progreso>

          <cfset LvarPromedioValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarPromedio)>
          <cfset LvarAjusteValor   = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarAjuste)>
          <cfset LvarProgresoValor = fnObtenerCodigoDeTabla(qryComplementaria.Tabla, LvarProgreso)>
        </cfif>
        <cfquery datasource="educativo">
        <cfif LvarPromedio eq "" and LvarAjuste eq "" and LvarProgreso eq "">
          delete AlumnoCalificacionPerEval 
           where PEcodigo = #form.cboPeriodo#
             and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = #Session.CENEDCODIGO#
             and Ccodigo  = #qryComplementaria.Curso#
        <cfelse>
          <cfif LvarPromedio eq ""><cfset LvarPromedio = "null"><cfelse><cfset LvarPromedio = Replace(LvarPromedio, "%", "")></cfif>
          <cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
          <cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
          if exists(select * from AlumnoCalificacionPerEval
                     where PEcodigo     = #form.cboPeriodo#
                       and Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
                       and CEcodigo     = #Session.CENEDCODIGO#
                       and Ccodigo      = #qryComplementaria.Curso#
                    )
            update AlumnoCalificacionPerEval 
               set ACPEnota           = #LvarPromedio#
                 , ACPEnotacalculada  = #LvarAjuste#
                 , ACPEnotaprog       = #LvarProgreso#
                 , ACPEvalor          = <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>
                 , ACPEvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACPEvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACPEcerrado        = '#form.chkCerrarPeriodo#'
             where PEcodigo = #form.cboPeriodo#
               and Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = #Session.CENEDCODIGO#
               and Ccodigo  = #qryComplementaria.Curso#
          else   
            insert into AlumnoCalificacionPerEval 
                   (PEcodigo, Ecodigo, CEcodigo, Ccodigo, 
                    ACPEnota, ACPEnotacalculada, ACPEnotaprog, 
                    ACPEvalor, ACPEvalorcalculado, ACPEvalorprog, 
                    ACPEcerrado)
            values (#form.cboPeriodo#, 
                    #Evaluate("form.txtEcodigo#LvarLin#")#, 
                    #Session.CENEDCODIGO#, 
                    #qryComplementaria.Curso#, 
                    #LvarPromedio#,  
                    #LvarAjuste#, 
                    #LvarProgreso#,
                    <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>,
                    <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
                    <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
                    '#form.chkCerrarPeriodo#')
        </cfif>
        </cfquery>
      </cfif>
  </cfloop>
</cfoutput>
</cftransaction>
