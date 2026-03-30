 	<cfif isdefined("Url.PEvalCodigo") and not isdefined("Form.PEvalCodigo")>
		<cfparam name="Form.PEvalCodigo" default="#Url.PEvalCodigo#">
	</cfif> 
	<cfif isdefined("Url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfparam name="Form.PEcodigo" default="#Url.PEcodigo#">
	</cfif> 	
	<cfif isdefined("Url.SPEcodigo") and not isdefined("Form.SPEcodigo")>
		<cfparam name="Form.SPEcodigo" default="#Url.SPEcodigo#">
	</cfif> 
	<cfif isdefined("Url.cbCursos") and not isdefined("Form.cbCursos")>
		<cfparam name="Form.cbCursos" default="#Url.cbCursos#">
	</cfif> 
	<cfif isdefined("Url.Splaza") and not isdefined("Form.Splaza")>
		<cfparam name="Form.Splaza" default="#Url.Splaza#">
	</cfif> 	
	<cfif isdefined("Url.rdFecha") and not isdefined("Form.rdFecha")>
		<cfparam name="Form.rdFecha" default="#Url.rdFecha#">
	</cfif> 
	<cfif isdefined("Url.cbSemana") and not isdefined("Form.cbSemana")>		
		<cfparam name="Form.cbSemana" default="#Url.cbSemana#">
	</cfif>
	<cfif isdefined("Url.rdCorte") and not isdefined("Form.rdCorte")>
		<cfparam name="Form.rdCorte" default="#Url.rdCorte#">
	</cfif>	
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif>		
	<cfif isdefined("Url.cbVer") and not isdefined("Form.cbVer")>
		<cfparam name="Form.cbVer" default="#Url.cbVer#">
	</cfif>
	<cfif isdefined("Url.ckVerDes") and not isdefined("Form.ckVerDes")>
		<cfparam name="Form.ckVerDes" default="#Url.ckVerDes#">
	</cfif>	
	
	<!--- Consultas --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsTemaEval">
		set nocount on
		exec sp_TEMAR_EVAL 
			@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			,@periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">			
			,@subPeriodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">			
			
			<cfif isdefined('form.PEvalCodigo') and len(trim(form.PEvalCodigo)) NEQ 0>
				,@perEval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEvalCodigo#">			
			</cfif>
 			<cfif isdefined('form.Splaza') and form.Splaza NEQ '-1' >
				,@profe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">
			</cfif> 			
			<cfif isdefined('form.cbCursos') and form.cbCursos NEQ '-1'>
				,@curso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbCursos#">
			</cfif>			
			<cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>
				,@semana=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbSemana#">
			</cfif>
		set nocount off
	</cfquery> 	

	 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
		select CEnombre from CentroEducativo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
	</cfquery>
	
	 <cfquery datasource="#Session.Edu.DSN#" name="rsPerEvaluacion">
		select PEdescripcion 
		from PeriodoEvaluacion
		<cfif isdefined('form.PEvalCodigo') and form.PEvalCodigo NEQ ''>
			where PEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEvalCodigo#">
		</cfif>
	</cfquery>	
	
	<cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S' and isdefined('form.ckVerDes') and isdefined('form.PEvalCodigo') and form.PEvalCodigo NEQ ''>
		 <cfquery datasource="#Session.Edu.DSN#" name="rsDescripcionesTemas">
			select  Ccodigo, CPcodigo,CPdescripcion
			from CursoPrograma 
			where  PEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEvalCodigo#">
		</cfquery>
	</cfif>	

<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="area"> 
    <td width="62%"><font size="2">Servicios Digitales al Ciudadano</font></td>
    <td width="17%">&nbsp;</td>
    <td width="21%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
  </tr>
  <tr class="area"> 
    <td><font size="2">www.migestion.net</font></td>
    <td>&nbsp;</td>
    <td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
  </tr>
  <tr class="tituloAlterno"> 
    <td colspan="3" align="center" class="tituloAlterno"><strong>LISTADO DE TEMARIOS 
      Y EVALUACIONES</strong></td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="tituloAlterno"> <strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong> <hr></td>
  </tr>

  <cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
  
  <cfset vCurso ="">
  <cfset vFecha ="">
  <cfset vMes ="">
  <cfset cont = 0>

  <cfif rsTemaEval.recordCount GT 0>
		<cfoutput query="rsTemaEval">
			<cfset cont = #cont# + 1>
			<cfif (vCurso NEQ rsTemaEval.curso) or (vFecha NEQ rsTemaEval.fecha)>
				<cfif isdefined("Temas") and isdefined("Evaluaciones")>
					<cfif isdefined('form.cbVer') and form.cbVer EQ 'TE'>
						<tr>
							<td>#Temas#</td>
							<td colspan="2" valign="top">#Evaluaciones#</td>
						</tr>	
					<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'T'>
						<tr>
							<td colspan="3">#Temas#</td>
						</tr>					
					<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'E'>											
						<tr>
							<td colspan="3" valign="top">#Evaluaciones#</td>
						</tr>					
					</cfif>
				</cfif>

				<cfset Temas = "">
				<cfset Evaluaciones = "">
			</cfif>
			<cfif vCurso NEQ rsTemaEval.curso>
				<cfset vCurso ="#rsTemaEval.curso#">
				<cfset vFecha ="">
				<cfset vMes ="">
				
				<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXC' and cont GT 1 and isdefined('form.imprime')>
					<tr>
						<td colspan="3" align="center">
							------------------ Fin del Reporte ------------------					
						</td>
					</tr>				
					<tr class="pageEnd">
						<td colspan="3">&nbsp;
							
						</td>
					</tr>					
				  <tr class="area"> 
					<td width="62%"><font size="2">Servicios Digitales al Ciudadano</font></td>
					<td width="17%">&nbsp;</td>
					<td width="21%">Fecha: #LSdateFormat(Now(),'dd/MM/YY')# </td>
				  </tr>
				  <tr class="area"> 
					<td><font size="2">www.migestion.net</font></td>
					<td>&nbsp;</td>
					<td>Hora: #TimeFormat(Now(),"hh:mm:ss")#</td>
				  </tr>
				  <tr class="tituloAlterno"> 
					<td colspan="3" align="center" class="tituloAlterno"><strong>LISTADO DE TEMARIOS 
					  Y EVALUACIONES</strong></td>
				  </tr>
				  <tr> 
					<td colspan="3" align="center" class="tituloAlterno"> <strong>#rsCentroEducativo.CEnombre#</strong> <hr></td>
				  </tr>					
				</cfif>				
				<tr class="areaFiltro"> 
					<td><strong>Profesor</strong>: #rsTemaEval.nombreProf#</td>
					<td colspan="2"><strong>Periodo</strong>: #rsTemaEval.PEdescripcion#</td>
				</tr>  
					<tr class="areaFiltro"> 
					<td><strong>Curso</strong>: #rsTemaEval.descrCurso#</td>
					
          <td colspan="2"><strong>Periodo 
            de Evaluaci&oacute;n:</strong> #rsPerEvaluacion.PEdescripcion#</td>
				</tr>		
				<tr> 
					<cfif isdefined('form.cbVer') and form.cbVer EQ 'TE'>
						<td align="center" class="subTitulo">Temas</td>
						<td colspan="2" align="center" class="subTitulo">Evaluaciones</td>
					<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'T'>
						<td colspan="3" align="center" class="subTitulo">Temas</td>					
					<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'E'>						
						<td colspan="3" align="center" class="subTitulo">Evaluaciones</td>										
					</cfif>				
				</tr>	
			</cfif>	
						
			<cfif vFecha NEQ rsTemaEval.fecha>
				<cfset vFecha ="#rsTemaEval.fecha#">
				<tr>
					<td colspan="3" class="subTitulo">	<!--- Corte por fecha --->
						#rsTemaEval.DiaFecha# #LSDateFormat('#rsTemaEval.fecha#', 'dd')# de #ListGetAt(meses, LSDateFormat('#rsTemaEval.fecha#', 'm'), ',')# de #LSDateFormat('#rsTemaEval.fecha#', 'yyyy')#																											
					</td>						
				</tr>
			</cfif>
			<cfif rsTemaEval.tipo EQ 'T'>
				<cfif isdefined('form.rdFecha') and form.rdFecha EQ 'S'>				
 					<cfif isdefined('form.ckVerDes')>
						 <cfquery dbtype="query" name="rsDescTema">
							select  CPdescripcion
							from rsDescripcionesTemas 
							where  Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemaEval.curso#">
								and CPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTemaEval.codigo#">
						</cfquery>					
						<cfset Temas = Temas & "<strong><font color='##0000FF'>" &  rsTemaEval.nombre & "</font></strong> <br> &nbsp;&nbsp;&nbsp;&nbsp;" & rsDescTema.CPdescripcion & "<br>">						
 					<cfelse>
						<cfset Temas = Temas & rsTemaEval.nombre & "<br>">				
					</cfif>					
				<cfelse>
					<cfset Temas = Temas & rsTemaEval.nombre & "<br>">				
				</cfif>			
			</cfif>
			<cfif rsTemaEval.tipo EQ 'E'>
				<cfset Evaluaciones = Evaluaciones & rsTemaEval.nombre & "<br>">
			</cfif>
	</cfoutput>
	<cfif isdefined("Temas") and isdefined("Evaluaciones")>
		<cfoutput>
			<cfif isdefined('form.cbVer') and form.cbVer EQ 'TE'>
				<tr>
					<td>#Temas#</td>
					<td colspan="2" valign="top">#Evaluaciones#</td>
				</tr>	
			<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'T'>
				<tr>
					<td colspan="3">#Temas#</td>
				</tr>					
			<cfelseif isdefined('form.cbVer') and form.cbVer EQ 'E'>						
				<tr>
					<td colspan="3" valign="top">#Evaluaciones#</td>
				</tr>					
			</cfif>
		</cfoutput>
		<tr>
			<td colspan="3" align="center">
				------------------ Fin del Reporte ------------------					
			</td>
		</tr>		
	</cfif>
  <cfelse>
		<table width="100%" border="0" cellspacing="0"> 			
			<tr> 
				<td colspan="3" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El 
				Curso no tiene Temarios en el periodo solicitado</td>
			</tr>
			<tr> 
				<td colspan="3" align="center"> ------------------ No existen 
				temarios, para el grupo y periodo solicitado  ------------------ </td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					------------------ Fin del Reporte ------------------					
				</td>
			</tr>
		</table>
  </cfif>
  
</table>