<cffunction name="fnObtenerCodigoDeTabla">
           <cfargument name="LprmValor" required="true" type="string">
  <cfif LprmValor eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Codigo
         from qryValores
        where #LprmValor# between Minimo and Maximo
    </cfquery>
    <cfreturn qryValor.Codigo>
  </cfif>
</cffunction>

<cffunction name="fnObtenerValorDeTabla">
           <cfargument name="LprmCodigo" required="true" type="string">
  <cfif LprmCodigo eq "">
    <cfreturn "">
  <cfelse>
    <cfquery dbtype="query" name="qryValor">
       select Equivalente
         from qryValores
        where Codigo = '#LprmCodigo#'
    </cfquery>
    <cfreturn qryValor.Equivalente>
  </cfif>
</cffunction>

<cfoutput>
  <cfparam name="form.chkCerrarCurso" default="0">
  <!--- ENVIAR MAIL 
  <cfif Evaluate("form.chkCerrarCurso") eq "0">
    <cfquery datasource="Educativo" name="qryMailPeriodoAbierto">
      select * from AlumnoCalificacionCursoPerEval
       where PEcodigo     = #form.cboPeriodo#
         and CEcodigo     = #Session.CENEDCODIGO#
         and Ccodigo      = #form.cboCurso#
         and ACPEcerrado  = '1'
    </cfquery>
  </cfif>
  ENVIAR MAIL ---> 
  <cfloop from="1" to=#form.txtRows# index="LvarLin">
      <cfquery datasource="Educativo">
	    <cfif not isdefined("form.txtEVTcodigoM")>
          <cfset LvarPromedio = Evaluate("form.txtPromedio#LvarLin#")>
          <cfset LvarAjuste   = Evaluate("form.txtAjuste#LvarLin#")>
          <cfset LvarProgreso = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarPromedioValor = "">
          <cfset LvarAjusteValor   = "">
          <cfset LvarProgresoValor = "">
		<cfelse>
          <cfset LvarAjuste = Evaluate("form.cboAjuste#LvarLin#")>
          <cfset LvarAjusteValor = fnObtenerCodigoDeTabla(LvarAjuste)>

          <cfset LvarPromedioValor = Evaluate("form.txtPromedio#LvarLin#")>
          <cfset LvarProgresoValor = Evaluate("form.txtProgreso#LvarLin#")>
          <cfset LvarPromedio = fnObtenerValorDeTabla(LvarPromedioValor)>
          <cfset LvarProgreso = fnObtenerValorDeTabla(LvarProgresoValor)>
		</cfif>
 		<cfif LvarPromedio eq ""><cfset LvarPromedio = "null"><cfelse><cfset LvarPromedio = Replace(LvarPromedio, "%", "")></cfif>
		<cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
 		<cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
            update AlumnoCalificacionCurso
               set ACCnota           = #LvarPromedio#
                 , ACCnotacalculada  = #LvarAjuste#
                 , ACCnotaprog       = #LvarProgreso#
                 , ACCvalor          = <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>
                 , ACCvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACCvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACCcerrado        = '#form.chkCerrarCurso#'
             where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = #Session.CENEDCODIGO#
               and Ccodigo  = #form.cboCurso#
	  </cfquery>

      <!---  Actualiza la nota final del Curso Complementario --->
      <cfif qryComplementaria.Curso neq "">
        <cfquery datasource="educativo" name="qryComplementos">
          select round(avg (ACCnota),2)           as Promedio,
                 round(avg (ACCnotacalculada),2)  as Ajuste,
                 round(avg (ACCnotaprog),2)       as Progreso
            from AlumnoCalificacionCurso n, 
                 Curso c, MateriaElectiva ME, Materia MRc, Curso CRc
           where c.Ccodigo  = #qryComplementaria.Curso#
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
          delete AlumnoCalificacionCurso
           where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
             and CEcodigo = #Session.CENEDCODIGO#
             and Ccodigo  = #qryComplementaria.Curso#
        <cfelse>
          <cfif LvarPromedio eq ""><cfset LvarPromedio = "null"><cfelse><cfset LvarPromedio = Replace(LvarPromedio, "%", "")></cfif>
          <cfif LvarAjuste eq ""><cfset LvarAjuste = "null"><cfelse><cfset LvarAjuste = Replace(LvarAjuste, "%", "")></cfif>
          <cfif LvarProgreso eq ""><cfset LvarProgreso = "null"><cfelse><cfset LvarProgreso = Replace(LvarProgreso, "%", "")></cfif>
          if exists(select * from AlumnoCalificacionCurso
                     where Ecodigo      = #Evaluate("form.txtEcodigo#LvarLin#")#
                       and CEcodigo     = #Session.CENEDCODIGO#
                       and Ccodigo      = #qryComplementaria.Curso#
                    )
            update AlumnoCalificacionCurso
               set ACCnota           = #LvarPromedio#
                 , ACCnotacalculada  = #LvarAjuste#
                 , ACCnotaprog       = #LvarProgreso#
                 , ACCvalor          = <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>
                 , ACCvalorcalculado = <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>
                 , ACCvalorprog      = <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>
                 , ACCcerrado        = '#form.chkCerrarCurso#'
             where Ecodigo  = #Evaluate("form.txtEcodigo#LvarLin#")#
               and CEcodigo = #Session.CENEDCODIGO#
               and Ccodigo  = #qryComplementaria.Curso#
          else   
            insert into AlumnoCalificacionCurso
                   (Ecodigo, CEcodigo, Ccodigo, 
                    ACCnota, ACCnotacalculada, ACCnotaprog, 
                    ACCvalor, ACCvalorcalculado, ACCvalorprog, 
                    ACCcerrado)
            values (#Evaluate("form.txtEcodigo#LvarLin#")#, 
                    #Session.CENEDCODIGO#, 
                    #qryComplementaria.Curso#, 
                    #LvarPromedio#,  
                    #LvarAjuste#, 
                    #LvarProgreso#,
                    <cfif LvarPromedioValor eq "">null<cfelse>'#LvarPromedioValor#'</cfif>,
                    <cfif LvarAjusteValor eq "">null<cfelse>'#LvarAjusteValor#'</cfif>,
                    <cfif LvarProgresoValor eq "">null<cfelse>'#LvarProgresoValor#'</cfif>,
                    '#form.chkCerrarCurso#')
        </cfif>
        </cfquery>
      </cfif>
  </cfloop>
</cfoutput>