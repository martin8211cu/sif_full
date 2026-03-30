	<cfif isdefined("Url.cbProf") and not isdefined("Form.cbProf")>
		<cfparam name="Form.cbProf" default="#Url.cbProf#">
	</cfif> 
	<cfif isdefined("Url.rdCorte") and not isdefined("Form.rdCorte")>
		<cfparam name="Form.rdCorte" default="#Url.rdCorte#">
	</cfif> 	
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 	

	<!--- Consultas --->		 
		<cfquery datasource="#Session.Edu.DSN#" name="rsCursProf">
			<cfif isdefined("form.cbProf")  and form.cbProf NEQ "" and form.cbProf NEQ "-1">
				exec sp_EDU_CURPROF 
					@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
					@CProf=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbProf#">
			<cfelse>
				exec sp_EDU_CURPROF 
					@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			</cfif>				
		</cfquery>
		 
		<cfquery name="rsProfes" dbtype="query">
			Select distinct persona, nombre
			from rsCursProf
			order by nombre
		</cfquery>
		
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>				
  
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<cfset cont = 0>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr class="area"> 
    <td width="53%"><font size="2">Servicios Digitales al Ciudadano</font></td>
    <td width="18%">&nbsp;</td>
    <td width="29%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
  </tr>
  <tr class="area"> 
    <td><font size="2">www.migestion.net</font></td>
    <td>&nbsp;</td>
    <td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><strong>LISTADO DE CURSOS 
      POR PROFESOR </strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
  </tr>
  <tr class="encabReporte"> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <cfif rsProfes.recordCount GT 0>
    <cfloop query="rsProfes" >
		<cfset cont = #cont# + 1>
      <cfoutput> 
        <cfset Prof = #rsProfes.persona#>
		
		<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXP' and cont GT 1 and isdefined('form.imprime')>
		  <tr class="area"> 
			<td width="53%"><font size="2">Servicios Digitales al Ciudadano</font></td>
			<td width="18%">&nbsp;</td>
			<td width="29%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
		  </tr>
		  <tr class="area"> 
			<td><font size="2">www.migestion.net</font></td>
			<td>&nbsp;</td>
			<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
		  </tr>
		  <tr> 
			<td colspan="3" class="tituloAlterno" align="center"><strong>LISTADO DE CURSOS 
			  POR PROFESOR </strong></td>
		  </tr>
		  <tr> 
			<td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
		  </tr>
		  <tr class="encabReporte"> 
			<td colspan="3">&nbsp;</td>
		  </tr>		
		</cfif>
		
        <tr class="subTitulo"> 
          <td height="20" colspan="3" valign="top" class="subTitulo">#rsProfes.nombre#</td>
        </tr>
        <cfquery name="rsCursos" dbtype="query">
	        Select Mnombre from rsCursProf where rsCursProf.persona='#Prof#' order by Mnombre 
        </cfquery>
		
        <cfif rsCursos.recordCount GT 0>
          <tr> 
            <td colspan="3"> 
              <table width="100%" border="0">
                <cfloop query="rsCursos" >
                  <cfoutput> 
                    <tr> 
                      <td>&nbsp;</td>
                      <td <cfif #rsCursos.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsCursos.Mnombre#</td>
                    </tr>
                  </cfoutput> 
                </cfloop>
              </table></td>
          </tr>
        </cfif>
      </cfoutput> 

	  	<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXP' and cont LT rsProfes.recordCount>	
			<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXP' and isdefined('form.imprime')>
				<tr> 
					<td height="20" colspan="3" align="center">------------------ Fin del Reporte ------------------</td>
				</tr> 
			</cfif>
			
			 <tr class="pageEnd">
			  	<td height="20" colspan="3" valign="top">&nbsp;</td>
			</tr> 		
		</cfif>
    </cfloop>
  </cfif>

	<tr> 
		<td height="20" colspan="3" align="center">------------------ Fin del Reporte ------------------</td>
	</tr> 
</table>
