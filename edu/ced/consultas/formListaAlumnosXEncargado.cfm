	<cfif isdefined("Url.EEpersona") and not isdefined("Form.EEpersona")>
		<cfparam name="Form.EEpersona" default="#Url.EEpersona#">
	</cfif> 
	<cfif isdefined("Url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#Url.rdCortes#">
	</cfif> 			

	<!--- Consultas --->		 
	 <cfquery datasource="#Session.Edu.DSN#" name="rsAlumnos">
		select a.EEcodigo, (e.Papellido1 + ' ' + e.Papellido2 + ' ' + e.Pnombre) as Encargado,(pea.Papellido1 + ' ' + pea.Papellido2 + ' ' + pea.Pnombre) as Alumno, GRnombre
		from EncargadoEstudiante a, Alumnos b, Estudiante c, Encargado d, PersonaEducativo e, PersonaEducativo pea,GrupoAlumno gra, Grupo gr, PeriodoVigente pv
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		<cfif isdefined('form.EEpersona') and form.EEpersona NEQ '-1'>
			and d.persona=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EEpersona#">
		</cfif>
		and Aretirado=0
		<!--- and d.autorizado=1 --->
		and a.CEcodigo=b.CEcodigo 
		and a.Ecodigo=b.Ecodigo 
		and b.Ecodigo=c.Ecodigo 
		and a.EEcodigo=d.EEcodigo 
		and d.persona=e.persona
		and b.persona=pea.persona
		and c.Ecodigo=gra.Ecodigo
		and b.CEcodigo=gra.CEcodigo
		and gra.GRcodigo=gr.GRcodigo
		and gr.Ncodigo=pv.Ncodigo
		and gr.PEcodigo=pv.PEcodigo
		and gr.SPEcodigo=pv.SPEcodigo
		order by Encargado
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
    <td colspan="3" class="tituloAlterno" align="center"><strong>LISTADO DE ALUMNOS 
      POR ENCARGADO</strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
  </tr>
  <tr> 
    <td colspan="3">
		<cfset vEncarg = "">
		<cfset vContEncarg = 0>		
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
        <cfif rsAlumnos.recordCount GT 0>
          <cfoutput> 
            <cfloop query="rsAlumnos">
              <cfif vEncarg NEQ rsAlumnos.EEcodigo>
                <cfset vEncarg ="#rsAlumnos.EEcodigo#">
				<cfif isdefined('form.rdCortes') and form.rdCortes EQ 'PXE' and vContEncarg GT 0>				
					 <tr class="pageEnd">
						<td colspan="3">&nbsp;
											
						</td>
					  </tr>					
				</cfif>				
                <tr> 
                  <td colspan="3" class="subTitulo"> 
                    #rsAlumnos.Encargado# </td>
                </tr>
				<cfset vContEncarg = vContEncarg + 1>				
              </cfif>
              <tr> 
                <td width="6%">&nbsp; </td>
                <td width="41%" class="subrayado"> #rsAlumnos.Alumno# </td>
                <td width="53%" class="subrayado">
					#rsAlumnos.GRnombre#
				</td>
              </tr>
            </cfloop>
          </cfoutput> 
		  <tr> 
			<td colspan="3" align="center">------------------ Fin del Reporte ------------------ </td>
		  </tr>  		  
        </cfif>
      </table>
	</td>
  </tr> 
</table>

