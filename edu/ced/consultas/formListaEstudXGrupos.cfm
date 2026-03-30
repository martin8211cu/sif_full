	<cfif isdefined("Url.cbGrupos") and not isdefined("Form.cbGrupos")>
		<cfparam name="Form.cbGrupos" default="#Url.cbGrupos#">
	</cfif> 
	<cfif isdefined("Url.rdCorte") and not isdefined("Form.rdCorte")>
		<cfparam name="Form.rdCorte" default="#Url.rdCorte#">
	</cfif> 	
	<cfif isdefined("Url.imprime") and not isdefined("Form.imprime")>
		<cfparam name="Form.imprime" default="#Url.imprime#">
	</cfif> 	

	<!--- Consultas --->		 
	<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_ALUMNOGRUPO" returncode="yes">
		<cfprocresult name="rsEstudXGrupo">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
		<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Grupo" value="#Form.cbGrupos#">
	</cfstoredproc>	
	
	<cfquery name="rsGrupos" dbtype="query">
		Select distinct GRcodigo, GRnombre, Ncodigo, Ndescripcion, Gcodigo, NombGrado
		from rsEstudXGrupo
		order by Norden,Gorden,GRnombre
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
    <td colspan="3" class="tituloAlterno" align="center"><strong>
		<cfif isdefined('form.cbGrupos') and form.cbGrupos EQ '-1' and isdefined('form.rdCorte') and form.rdCorte EQ 'AA'>
        	LISTADO DE ALUMNOS ORDENADOS ALFAB&Eacute;TICAMENTE 
        <cfelse>
			LISTADO DE ALUMNOS POR GRUPO
		</cfif>
	</strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
  </tr>
  <tr class="encabReporte"> 
    <td colspan="3">&nbsp;</td>
  </tr>
 
  <cfif rsEstudXGrupo.recordCount GT 0>
	<!--- Listado de Estudiantes alfabéticamnete --->
	<cfif isdefined('form.cbGrupos') and form.cbGrupos EQ '-1' and isdefined('form.rdCorte') and form.rdCorte EQ 'AA'>
	  <tr>
		<td colspan="3">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<cfoutput>
					<cfloop query="rsEstudXGrupo" >
						<cfset cont = #cont# + 1>
						  <tr> 
							<td <cfif #rsEstudXGrupo.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#cont#</td>
							<td <cfif #rsEstudXGrupo.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsEstudXGrupo.Nombre#</td>						  
						  </tr>			
					</cfloop>
				</cfoutput>						  
			</table>
		</td>
	  </tr>
	<cfelse>
		<!--- Listado de Estudiantes por Grupo --->	
		<cfif rsGrupos.recordCount GT 0>
			<cfoutput>
			<cfloop query="rsGrupos" >
				<cfset cont = #cont# + 1>
				<cfset Grupo = #rsGrupos.GRcodigo#>
				<cfset Nivel = #rsGrupos.Ncodigo#>
				<cfset Grado = #rsGrupos.Gcodigo#>
					
				<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXG' and cont GT 1 and isdefined('form.imprime')>
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
					<td colspan="3" class="tituloAlterno" align="center"><strong>LISTADO 
					  DE ALUMNOS POR GRUPO</strong></td>
				  </tr>
				  <tr> 
					<td colspan="3" class="tituloAlterno" align="center"><strong><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></strong></td>
				  </tr>
				  <tr class="encabReporte"> 
					<td colspan="3">&nbsp;</td>
				  </tr>		
				</cfif>
				
				<tr class="subTitulo"> 
				  <td height="20" colspan="3" valign="top" class="subTitulo">#rsGrupos.Ndescripcion#: #rsGrupos.NombGrado#: #rsGrupos.GRnombre#</td>
				</tr>
				<cfquery name="rsAlumnos" dbtype="query">
					Select Nombre 
					from rsEstudXGrupo 
					<cfif Grupo NEQ ''>
						where rsEstudXGrupo.GRcodigo='#Grupo#' 			
						and rsEstudXGrupo.Ncodigo='#Nivel#' 
						and rsEstudXGrupo.Gcodigo='#Grado#' 
					<cfelse>
						where rsEstudXGrupo.GRcodigo = ''
						and rsEstudXGrupo.Ncodigo='#Nivel#' 
						and rsEstudXGrupo.Gcodigo='#Grado#' 
					</cfif>
					order by Nombre 
				</cfquery>
				
				<cfset contAlumnos = 0>
				 <cfif rsAlumnos.recordCount GT 0>
				  <tr> 
					<td colspan="3"> 
					  <table width="100%" border="0">
						<cfloop query="rsAlumnos" >
						  <cfset contAlumnos = #contAlumnos# + 1>				
						  <cfoutput> 
							<tr> 
							  <td width="12%">#contAlumnos#</td>
							  <td width="88%" <cfif #rsAlumnos.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#rsAlumnos.Nombre#</td>
							</tr>
						  </cfoutput> 
						</cfloop>
						<tr> 
						  <td width="12%" class="subTitulo">Total</td>
						  <td width="88%"  align="right" class="subTitulo">#contAlumnos#</td>
						</tr>				
					  </table></td>
				  </tr>
				</cfif>
			   
				<cfif isdefined('form.rdCorte') and form.rdCorte EQ 'PXG' and cont LT rsGrupos.recordCount>	
					<cfif isdefined('form.imprime')>
						<tr> 
							<td height="20" colspan="3" valign="top" align="center">------------------ Fin del Reporte ------------------ </td>
						</tr> 			
					</cfif>				
					<tr class="pageEnd">
						<td height="20" colspan="3" valign="top">&nbsp;</td>
					</tr> 			
				</cfif>
			</cfloop>
		 </cfoutput> 
		</cfif>
	</cfif>	
  </cfif>
	<tr> 
		<td height="20" colspan="3" valign="top" align="center">------------------ Fin del Reporte ------------------ </td>
	</tr>   
</table>
