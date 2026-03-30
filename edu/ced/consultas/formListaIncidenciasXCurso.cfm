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
<!--- 		<cfquery datasource="#Session.Edu.DSN#" name="rsCursProf">
			<cfif isdefined("form.cbProf")  and form.cbProf NEQ "" and form.cbProf NEQ "-1">
				exec sp_EDU_CURPROF 
					@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
					@CProf=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbProf#">
			<cfelse>
				exec sp_EDU_CURPROF 
					@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			</cfif>				
		</cfquery>
		 --->
		 
		 <cfif isdefined('form.Splaza') and form.Splaza NEQ ''>
			 <cfquery datasource="#Session.Edu.DSN#" name="rsProf">		 
				select (Papellido1 + ' ' + Papellido2 + ','+ Pnombre) as nombre 
				from PersonaEducativo a, Staff b 
				where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and Splaza=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">
					and a.persona=b.persona 
					and a.CEcodigo=b.CEcodigo
					and b.retirado = 0 
					and b.autorizado = 1		 
			</cfquery>									
		</cfif>
		 
		 
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
    <td colspan="3" class="tituloAlterno" align="center"><strong>LISTADO DE INCIDENCIAS 
      POR CURSO</strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
  </tr>
  <tr> 
    <td colspan="3">
<table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr class="encabReporte"> 
          <td colspan="3">Curso: </td>
          <td colspan="9">Profesor:  <cfif isdefined('form.Splaza') and form.Splaza NEQ ''><cfoutput>#rsProf.nombre#</cfoutput><cfelse> -- No se puede mostrar --</cfif></td>
        </tr>
        <tr> 
          <td colspan="3" align="center" class="area">Observaciones</td>
          <td colspan="6" align="center" class="area">Asistencia</td>
        </tr>
        <tr align="center"> 
          <td class="area">Reforzamiento</td>
          <td class="area">Llamada de Atensi&oacute;n</td>
          <td class="area">Advertencia</td>
          <td colspan="2" class="area">Ausencias</td>
          <td colspan="2" class="area">Llegada Tard&iacute;a</td>
          <td colspan="2" class="area">Salida Temprano</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td align="center" class="area">Just</td>
          <td align="center" class="area">Injust</td>
          <td align="center" class="area">Just</td>
          <td align="center" class="area">Injust</td>
          <td align="center" class="area">Just</td>
          <td align="center" class="area">Injust</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
	
	</td>
  </tr>  
</table>
