	<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 

	<cfif isdefined("url.Grupo") and not isdefined("Form.Grupo")>
		<cfparam name="Form.Grupo" default="#url.Grupo#">
	</cfif>
	
	<cfif isdefined("url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#url.rdCortes#">
	</cfif>
	<cfif isdefined("url.Aretirado") and not isdefined("Form.Aretirado")>
		<cfparam name="Form.Aretirado" default="#url.Aretirado#">
	</cfif>
	<!--- Consultas --->		 
	<cfif isdefined("Form.btnGenerar")>
		
		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_ALUMNOXENCARGADO" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grupo"   value="#Form.Grupo#">
			<cfprocparam cfsqltype="cf_sql_smallint" dbvarname="@Aretirado"   value="#Form.Aretirado#">
		</cfstoredproc>
	<!--- 	<cfif #form.Aretirado# EQ 0>
			<cfquery name="rsFiltroAlumno" dbtype="query">
				 select distinct GRcodigo , Grupo
				 from cons1
				 order by Grupo
			</cfquery>
		</cfif> --->
	</cfif> 
	
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="area"> 
		<td colspan="2">Servicios Digitales al Ciudadano</td>
		<td width="20%">&nbsp;</td>
		<td width="19%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
	</tr>
	<tr class="area"> 
		<td colspan="2">www.migestion.net</td>
		<td>&nbsp;</td>
		<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center">
			<cfif isdefined("form.Aretirado") and form.Aretirado EQ "1">
				Listado de Alumnos y Encargados <br> 
						(Alumnos Retirados)
				
			<cfelseif isdefined("form.Aretirado") and form.Aretirado EQ "0">
				Listado de Alumnos y Encargados <br>
						(Alumnos Activos)
				
			</cfif>
		</td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4">&nbsp;</td>
	</tr>
 </table>

 <cfif isdefined("form.btnGenerar")>
 	<cfif cons1.recordCount GT 0>
		<cfif #form.Aretirado# EQ 0>
			<cfif cons1.recordCount GT 0 >
				<cfoutput> 
						<cfset GrupoCorte = "">
						<cfset AlumnoCorte = "">
						<cfset EncargadoCorte = "">
						<cfloop query="cons1">
							<table width="100%" cellspacing="0">
							<cfif GrupoCorte NEQ cons1.Grupo>
								<cfset GrupoCorte = cons1.Grupo>
								<tr>
									<td colspan="4">
									<cfif #form.rdCortes# EQ 'CxG' and #cons1.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr class="pageEnd">
												<td height="20" colspan="4" valign="top">&nbsp;</td>
											</tr>
											<tr class="area"> 
												<td colspan="2">Servicios Digitales al Ciudadano</td>
												<td width="20%">&nbsp;</td>
												
                          <td width="19%" align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
											</tr>
												<tr class="area"> 
												<td colspan="2">www.migestion.net</td>
												<td>&nbsp;</td>
												
                          <td align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
											</tr>
												<tr> 
													<td colspan="4" class="tituloAlterno" align="center">
														<cfif isdefined("form.Aretirado") and form.Aretirado EQ "1">
															Listado de Alumnos y Encargados <br> 
																	(Alumnos Retirados)
															
														<cfelseif isdefined("form.Aretirado") and form.Aretirado EQ "0">
															Listado de Alumnos y Encargados <br>
																	(Alumnos Activos)
															
														</cfif>
													</td>
												</tr>
											<tr> 
												<td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
											</tr>
											<tr> 
												<td colspan="4">&nbsp;</td>
											</tr>
										</table> 
									</cfif> 
								</td>
							</tr>
							<cfif not isdefined("url.rdCortes")>
								<tr class="subTitulo">
									<td colspan="4" align="left"   class="encabReporte" nowrap ><strong>Grupo: &nbsp; &nbsp; #GrupoCorte# &nbsp; </strong></td>
								</tr>
							<!--- pintar aqui los datos de la materia --->
								<tr class="subTitulo">
									<td align="left"  class="encabReporte"  nowrap ><strong>Nombre del Alumno</strong></td>
									<td  colspan="2" align="left"  class="encabReporte"  nowrap ><strong>Nombre 
										Encargado: </strong></td>
									<td align="left"  class="encabReporte"  nowrap ><strong>Alumnos Familiares y Grupo:</strong></td>
								</tr>
							<cfelse>
								<tr >
									<td colspan="4" align="left"  nowrap ><strong>Grupo: &nbsp; &nbsp; #GrupoCorte# &nbsp; </strong></td>
								</tr>
								<tr >
									<td align="left"  nowrap ><strong>Nombre del Alumno</strong></td>
									<td  colspan="2" align="left"   nowrap ><strong>Nombre 
										Encargado: </strong></td>
									<td align="left"   nowrap ><strong>Alumnos Familiares y Grupo:</strong></td>
								</tr>
							</cfif>							
							
							</cfif>
							<cfif AlumnoCorte NEQ cons1.NombreAlumno>
								<tr <cfif #cons1.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #cons1.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" > 
									<td width="30%" style="border: 1px solid ##000000">
										<cfset AlumnoCorte = cons1.NombreAlumno>
										#AlumnoCorte# &nbsp;
									<!--- <cfelse>
										&nbsp; --->
									</td>
									
									
                  <td width="30%" colspan="2" align="left" style="border: 1px solid ##000000"> 
                    <cfset persona = cons1.personaAlumno>
											<cfquery name="rsEncargado" dbtype="query">
												select distinct NombreEncargado
												from cons1
												where  personaAlumno = <cfqueryparam cfsqltype="cf_sql_char" value="#persona#">
												 <!---  and GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GrupoAlumno#"> --->
												order by  NombreEncargado
											</cfquery>
										
											<cfloop query="rsEncargado">
												<cfif rsEncargado.CurrentRow NEQ 1 >
													<br>&nbsp;
												</cfif>
                      #rsEncargado.NombreEncargado# 
                    </cfloop>
										
										<!--- <cfif EncargadoCorte NEQ cons1.NombreEncargado>
											<cfset EncargadoCorte = cons1.NombreEncargado>
											#cons1.NombreEncargado#
										</cfif> --->		
									</td>
									
                  <td width="40%" align="left" style="border: 1px solid ##000000"> 
                    <cfset persona = cons1.personaAlumno>
										<cfset Encargado = cons1.EEcodigo>
										<cfquery name="rsFamiliar" dbtype="query">
											select distinct NombreAlumno, Grupo
											from cons1
											where  EEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Encargado#">
											  and  personaAlumno != <cfqueryparam cfsqltype="cf_sql_char" value="#persona#">
											order by  NombreAlumno 
										</cfquery>
										<cfif rsFamiliar.RecordCount NEQ 0>
											<cfloop query="rsFamiliar">
												<cfif rsFamiliar.CurrentRow NEQ 1 >
													<br>&nbsp;  
												</cfif>
                        #rsFamiliar.NombreAlumno# &nbsp; - #rsFamiliar.Grupo# 
                      </cfloop>		
										<cfelse>
											&nbsp;
										</cfif>
									</td>
								</tr>
							</cfif>
						</table>
						</cfloop>
				</cfoutput> 
				<table width="100%"  cellspacing="0">
					<tr> 
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
					</tr>
				</table>
			</cfif>
		<cfelse> <!--- Solo Alumnos Retirados --->
			<cfoutput>
				
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <cfif not isdefined("url.rdCortes")>
		  <tr class="subTitulo"> 
            <td align="left"  class="encabReporte"  nowrap ><strong>Nombre del 
              Alumno</strong></td>
            <td  colspan="2" align="left"  class="encabReporte"  nowrap ><strong>Nombre 
              Encargado: </strong></td>
            <td align="left"  class="encabReporte"  nowrap ><strong>Alumnos Familiares 
              y Grupo:</strong></td>
          </tr></tr>
		<cfelse>
		  <tr > 
            <td align="left"   nowrap ><strong>Nombre del 
              Alumno</strong></td>
            <td  colspan="2" align="left"   nowrap ><strong>Nombre 
              Encargado: </strong></td>
            <td align="left"  nowrap ><strong>Alumnos Familiares 
              y Grupo:</strong></td>
          </tr></tr>
		
		</cfif>
		
		  <cfquery name="rsAlumnoConsulta" dbtype="query">
          select distinct NombreAlumno, personaAlumno from cons1 order by NombreAlumno 
          </cfquery>
          <cfloop query="rsAlumnoConsulta">
            <cfset persona = rsAlumnoConsulta.personaAlumno>
            <cfquery name="rsEncargado" dbtype="query">
            select distinct NombreEncargado, EEcodigo from cons1 where personaAlumno 
            = 
            <cfqueryparam cfsqltype="cf_sql_char" value="#persona#">
            order by NombreEncargado 
            </cfquery>
            <cfset NombreAlumno = rsAlumnoConsulta.NombreAlumno>
            <tr <cfif #rsAlumnoConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #rsAlumnoConsulta.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td align="left" >&nbsp; 
                &nbsp; &nbsp; #rsAlumnoConsulta.NombreAlumno# </td>
              <td colspan="2" align="left" > 
                <cfloop query="rsEncargado">
                  <cfif rsEncargado.CurrentRow NEQ 1 >
                    <br>
                  </cfif>
                  #rsEncargado.NombreEncargado# </cfloop> </td>
              <td align="left"> <cfset Encargado = rsEncargado.EEcodigo> <cfquery name="rsFamiliar" dbtype="query">
                select distinct NombreAlumno 
                <!--- , Grupo --->
                from cons1 where EEcodigo = 
                <cfqueryparam cfsqltype="cf_sql_char" value="#Encargado#">
                and personaAlumno != 
                <cfqueryparam cfsqltype="cf_sql_char" value="#persona#">
                order by NombreAlumno </cfquery> <cfloop query="rsFamiliar">
                  <cfif rsFamiliar.CurrentRow NEQ 1 >
                    <br>
                  </cfif>
                  #rsFamiliar.NombreAlumno# &nbsp; </cfloop> </td>
            </tr>
          </cfloop>
          <tr> 
            <td colspan="4">&nbsp;</td>
          </tr>
        </table>
			</cfoutput>	
		</cfif>
	<cfelse>
		<table width="100%" border="1" cellspacing="0"> 			
			<tr> 
			
        <td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El 
          Grupo no tiene Alumnos en el grupo solicitado</td>
			</tr>
			
			<tr> 
			<td colspan="4" align="center"> ------------------ 1 - No existen 
			Alumnos Matriculados, para el grupo solicitado  ------------------ </td>
			</tr>
		</table>
	</cfif>
</cfif>