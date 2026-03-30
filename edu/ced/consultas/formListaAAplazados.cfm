 	<cfif isdefined("Url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#Url.Grupo#">
	</cfif> 
	<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
		<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
	</cfif> 
	<cfif isdefined("Url.TituloRep") and not isdefined("Form.TituloRep")>
		<cfparam name="Form.TituloRep" default="#Url.TituloRep#">
	</cfif> 	
	<cfif isdefined("Url.FechaRep") and not isdefined("Form.FechaRep")>
		<cfparam name="Form.FechaRep" default="#Url.FechaRep#">
	</cfif> 
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 	
	<cfif isdefined("Url.Ncodigo") and not isdefined("Form.Ncodigo")>
		<cfparam name="Form.Ncodigo" default="#Url.Ncodigo#">
	</cfif> 

	<!--- Consultas --->
   	<cfquery datasource="#Session.Edu.DSN#" name="rsNotasFinalesTemp">
		exec sp_NOTASFINALES1 
			@CCentro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			,@grupo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">			
			<cfif isdefined('form.Ncodigo') and form.Ncodigo NEQ '' >
				,@nivel=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">			
			</cfif>				
			<cfif isdefined('form.Ecodigo') and form.Ecodigo NEQ '-1'>
				,@alumno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">			
			</cfif>
	</cfquery>
	
	<cfquery name="rsNotasFinales" dbtype="query">
		select distinct Ecodigo, nombreAl, GRnombre, Mnombre, Cal_PerFin, NotaMinima, PEchkaplaz
		from rsNotasFinalesTemp
		order by nombreAl
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfquery>

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="area"> 
    <td width="62%"><font size="2">Servicios Digitales al Ciudadano</font></td>
    <td width="17%">&nbsp;</td>
    <td width="21%">Fecha de Entrega: <cfoutput><cfif isdefined('form.FechaRep') and form.FechaRep NEQ ''>#form.FechaRep#<cfelse>#LSdateFormat(Now(),'dd/MM/YY')#</cfif></cfoutput> </td>
  </tr>
  <tr class="area"> 
    <td><font size="2">www.migestion.net</font></td>
    <td>&nbsp;</td>
    <td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class="tituloAlterno">
		<strong>
			<cfif isdefined('form.TituloRep') and form.TituloRep NEQ ''>
				<cfoutput>#form.TituloRep#</cfoutput>
			<cfelse>
        REPORTE DE ALUMNOS APLAZADOS POR ASIGNATURA 
      </cfif></strong>
	</td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class=>
      <strong>GRUPO: <cfoutput>#rsNotasFinales.GRnombre#</cfoutput></strong>
	</td>
  </tr>  
  <tr> 
    <td colspan="3" align="center" class="tituloAlterno">
		<strong>
			<cfoutput>#rsCentroEducativo.CEnombre#</cfoutput>
		</strong> 
		<hr>
	</td>
  </tr>
  
  <cfset vAlumno = "">
  <cfset NombreAlumno = "">
  <cfset vMateria = "">   
  <cfset vContAlumnos = 0>   

  <tr>
   <td colspan="3">
		<cfif rsNotasFinales.recordCount GT 0>
			
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
          <tr class="EncabListaCorte"> 
            <td width="40%">ALUMNO</td>
            <td width="30%" align="center">ASIGNATURA</td>
            <td width="30%" align="right">PROMEDIO GANADO</td>
          </tr>
          <cfoutput> 
            <cfloop query="rsNotasFinales">
				<cfif vAlumno NEQ rsNotasFinales.Ecodigo and rsNotasFinales.Cal_PerFin NEQ '' and Val(rsNotasFinales.Cal_PerFin) LT Val(rsNotasFinales.NotaMinima)>
					<cfset vAlumno = rsNotasFinales.Ecodigo>
					<cfset NombreAlumno = rsNotasFinales.nombreAl>
				<cfelse>
					<cfset NombreAlumno = "">
				</cfif>
				<cfif (rsNotasFinales.Cal_PerFin NEQ '' and Val(rsNotasFinales.Cal_PerFin) LT Val(rsNotasFinales.NotaMinima))
				      or (rsNotasFinales.PEchkaplaz EQ 1 and rsNotasFinales.Cal_Per NEQ '' and Val(rsNotasFinales.Cal_Per) LT Val(rsNotasFinales.NotaMinima))>
					<tr> 
						<td <cfif NombreAlumno NEQ "">class="subrayado"</cfif>>
							<cfif NombreAlumno NEQ "">#NombreAlumno#<cfelse>&nbsp;</cfif>
						</td>
						<td class="subrayado">
							#rsNotasFinales.Mnombre#
						</td>
						<td class="subrayado" align="right">
						  <font color="##FF0000">
						  	#rsNotasFinales.Cal_PerFin#
						  	<cfif (rsNotasFinales.PEchkaplaz EQ 1 and rsNotasFinales.Cal_Per NEQ '' and Val(rsNotasFinales.Cal_Per) LT Val(rsNotasFinales.NotaMinima))>
								(#rsNotasFinales.Cal_Per# / Aplazado por Periodo)
							</cfif>
						  </font> 
						</td>
					</tr>
				</cfif>
            </cfloop>
          </cfoutput>
        </table>
		</cfif>
   </td>
  </tr>
 </table>
 
<!--- Area de Firmas--->
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td align="center">------------------ Fin del Reporte ------------------</td>
  </tr>
</table> 