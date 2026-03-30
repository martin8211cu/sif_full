<cfif isdefined("Url.MensPara") and not isdefined("Form.MensPara")>
	<cfparam name="Form.MensPara" default="#Url.MensPara#">
</cfif> 
<cfif isdefined("Url.cboDirector") and not isdefined("Form.cboDirector")>
	<cfparam name="Form.cboDirector" default="#Url.cboDirector#">
</cfif> 
<cfif isdefined("Url.cboHijo") and not isdefined("Form.cboHijo")>
	<cfparam name="Form.cboHijo" default="#Url.cboHijo#">
</cfif>
<cfif isdefined("Url.txtAsunto") and not isdefined("Form.txtAsunto")>
	<cfparam name="Form.txtAsunto" default="#Url.txtAsunto#">
</cfif>
<cfif isdefined("Url.txtMSG") and not isdefined("Form.txtMSG")>
	<cfparam name="Form.txtMSG" default="#Url.txtMSG#">
</cfif>
<cfif isdefined("Url.btnEnviar") and not isdefined("Form.btnEnviar")>
	<cfparam name="Form.btnEnviar" default="#Url.btnEnviar#">
</cfif>

<!--- Fuente con todas las consultas necesarias dependiendo del rolActual --->
<cfinclude template="consultasComunicado.cfm">	
<!--- FUENTE QUE CONTIENE LAS FUNCIONES PARA EL ENVIO DEL COMUNICADO --->
<cfinclude template="commonDocencia.cfm">

<cfoutput>
  <cfif isdefined("form.btnEnviar")>
	<form name="frmMail" method="post" action="comunicados.cfm" class="area">  
		<table border="0" width="100%">  
			<tr>  
				<td>
					<cfif Session.RolActual eq 4>		<!--- Centro Educativo --->
						  <cfset LvarAsunto = "Comunicado del Centro Educativo">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Centro Educativo)">								
					<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
						  <cfset LvarAsunto = "Comunicado de Docente">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Docente)">								
					<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
						  <cfset LvarAsunto = "Comunicado de Alumno">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Alumno)">								
					<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
						  <cfset LvarAsunto = "Comunicado de Encargado">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Encargado)">			
					<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
						  <cfset LvarAsunto = "Comunicado de Asistente">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Asistente)">								
					<cfelseif Session.RolActual eq 12>	<!--- Director --->
						  <cfset LvarAsunto = "Comunicado de Director">
						  <cfset LvarOrigen = qryUsuActual.Nombre & " (Director)">								
					</cfif>					
		
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
						<td>Asunto: </td>
						<td>#form.txtAsunto#</td>
					  </tr>
					  <tr> 
						<td>De: </td>
						<td>#LvarOrigen#</td>
					  </tr>
					  <tr> 
						  <td valign="top">Para </td>
						<td>
						<cfif Session.RolActual eq 12>	<!--- Director --->	
							<cfif isdefined('qryCorreos')>
								<cfif qryCorreos.recordCount GT 1>
									** Todos
										<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
											los Docentes
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
											los padres o encargados
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
											los alumnos (as)
										</cfif> ** <br>
								<cfelseif qryCorreos.recordCount EQ 1>
									#qryCorreos.NombreDestino# <br>
								<cfelse>
									No se encontro la persona <br>									
								</cfif>
							</cfif>
							
							<cfif isdefined('qryCorreos2')>
								<cfif qryCorreos2.recordCount GT 1>
									** Todos
										<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
											los Docentes
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
											los padres o encargados
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
											los alumnos (as)
										</cfif> ** <br>
								<cfelseif qryCorreos2.recordCount EQ 1>
									#qryCorreos2.NombreDestino# <br>
								<cfelse>
									No se encontro la persona <br>									
								</cfif>
							</cfif>
							
							<cfif isdefined('qryCorreos3')>
								<cfif qryCorreos3.recordCount GT 1>
									** Todos
										<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
											los Docentes
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
											los padres o encargados
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
											los alumnos (as)
										</cfif> ** <br>
								<cfelseif qryCorreos3.recordCount EQ 1>
									#qryCorreos3.NombreDestino# <br>
								<cfelse>
									No se encontro la persona <br>									
								</cfif>
							</cfif>														
							
							<cfif isdefined('qryCorreos4')>
								<cfif qryCorreos4.recordCount GT 1>
									** Todos
										<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
											los Docentes
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
											los padres o encargados
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
											los alumnos (as)
										</cfif> ** <br>
								<cfelseif qryCorreos4.recordCount EQ 1>
									#qryCorreos4.NombreDestino# <br>
								<cfelse>
									No se encontro la persona <br>									
								</cfif>
							</cfif>

							<cfif isdefined('qryCorreos5')>
								<cfif qryCorreos5.recordCount GT 1>
									** Todos
										<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
											los Docentes
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
											los padres o encargados
										<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
											los alumnos (as)
										</cfif> ** <br>
								<cfelseif qryCorreos5.recordCount EQ 1>
									#qryCorreos5.NombreDestino# <br>
								<cfelse>
									No se encontro la persona <br>									
								</cfif>
							</cfif>														
						<cfelse>	<!--- Todos los roles de usuario menos el de director --->
							<cfif isdefined('qryCorreos') and qryCorreos.recordCount GT 1>
								** Todos 
									<cfif Session.RolActual eq 4>		<!--- Centro Educativo --->
											<cfif isdefined('form.MensPara') and form.MensPara EQ 3> 
												los docentes
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
												los padres o encargados
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5>
												los alumnos (as)										
											</cfif>								
									<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
												los docentes
									<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
											<cfif isdefined('form.MensPara') and form.MensPara EQ 1> 
												los Directores
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4> 
												los padres o encargados
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 6>
												los compañeros (as)
											</cfif>								
									<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
											<cfif isdefined('form.MensPara') and form.MensPara EQ 1> 
												los directores
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 2>
												los hijos (as)
											<cfelseif isdefined('form.MensPara') and form.MensPara EQ 3>
												los docentes
											</cfif>
									<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
											--  Pendiente  --
									</cfif> **							
							<cfelseif isdefined('qryCorreos')>
								#qryCorreos.NombreDestino#
							<cfelse>
								No se encontro la persona
							</cfif>							
						</cfif>
						</td>
					  </tr>					  				  
					  <tr> 
						<td colspan="2">Mensaje: </td>
					  </tr>
					  <tr> 
						<td width="20%">&nbsp;</td>
						<td width="80%">
							<textarea rows="10" cols="45" style="font:10px Verdana, Arial, Helvetica, sans-serif;" name="txtMSGDespl" readonly><cfif isdefined('form.txtMSG') and form.txtMSG NEQ "">#form.txtMSG#</cfif></textarea>
						</td>
					  </tr>
					</table>
				</td>		
			</tr>  
			<tr>  
				<td>&nbsp;</td>		
			</tr>  			
			<tr>  
				<td>&nbsp;</td>		
			</tr>  			
			<tr>  
				<td align="center"><input type="submit" value="Nuevo Comunicado" name="btnNuevoComunicado" class="boxNormal"></td>		
			</tr>  
			<cfset LvarError = "">
			
			<cfif Session.RolActual NEQ 12 and isdefined('qryCorreos')>	<!--- ENVIO DEL MENSAJE --->   
				<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos, false)>
				<tr>  
					<td>&nbsp;</td>		
				</tr>  			
				<tr>  
					<td>&nbsp;</td>		
				</tr>  			
				<tr>  				
				<td align="center" class=""> 
					<cfif LvarError eq "">
						<font color="##000000" size="2"> <strong>Mensaje <cfoutput>#qryCorreos.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 
					<cfelse>
						<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
					</cfif> 
				</td>		
			</tr>  
			<cfelseif session.RolActual EQ 12> <!--- Para el rol de DirectoR --->   
				<cfif isdefined('qryCorreos')>			
					<cfset LvarError = "">
					<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos, false)>					
					<cfif LvarError eq "">
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  										
						<tr>  
							<td>
								<font color="##000000" size="2"> <strong>Mensaje para <cfoutput>#qryCorreos.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 							
							</td>		
						</tr>  					
					<cfelse>
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  					
						<tr>  
							<td align="center">
							<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
							</td>		
						</tr>  					
					</cfif> 
				</cfif> 				

				
				<cfif isdefined('qryCorreos2')>
					<cfset LvarError = "">
					<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos2, false)>					
					<cfif LvarError eq "">
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  										
						<tr>  
							<td>
								<font color="##000000" size="2"> <strong>Mensaje para <cfoutput>#qryCorreos2.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 							
							</td>		
						</tr>  					
					<cfelse>
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  					
						<tr>  
							<td align="center">
							<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
							</td>		
						</tr>  					
					</cfif> 						
				</cfif>
				
				<cfif isdefined('qryCorreos3')>					
					<cfset LvarError = "">				
					<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos3, false)>					
					<cfif LvarError eq "">
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  										
						<tr>  
							<td>
								<font color="##000000" size="2"> <strong>Mensaje para <cfoutput>#qryCorreos3.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 							
							</td>		
						</tr>  					
					<cfelse>
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  					
						<tr>  
							<td align="center">
							<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
							</td>		
						</tr>  					
					</cfif> 						
				</cfif>
				
				<cfif isdefined('qryCorreos4')>					
					<cfset LvarError = "">				
					<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos4, false)>					
					<cfif LvarError eq "">
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  										
						<tr>  
							<td>
								<font color="##000000" size="2"> <strong>Mensaje para <cfoutput>#qryCorreos4.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 							
							</td>		
						</tr>  					
					<cfelse>
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  					
						<tr>  
							<td align="center">
							<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
							</td>		
						</tr>  					
					</cfif> 						
				</cfif>

				<cfif isdefined('qryCorreos5')>					
					<cfset LvarError = "">				
					<cfset LvarError = fnNotificarCorreoBuzon ("","","","",form.txtAsunto,form.txtMSG,LvarOrigen, LvarAsunto, qryCorreos5, false)>					
					<cfif LvarError eq "">
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  										
						<tr>  
							<td>
								<font color="##000000" size="2"> <strong>Mensaje para <cfoutput>#qryCorreos5.NombreDestino#</cfoutput> enviado con éxito</strong> </font> 							
							</td>		
						</tr>  					
					<cfelse>
						<tr>  
							<td>&nbsp;</td>		
						</tr>  			
						<tr>  
							<td>&nbsp;</td>		
						</tr>  					
						<tr>  
							<td align="center">
							<font color="##FF0000" size="2"> <strong> #LvarError# </strong> </font> 
							</td>		
						</tr>  					
					</cfif> 						
				</cfif>													
			</cfif>												
		</table>
		 </form>	
  <cfelse> 
	  <form name="frmMail" method="post" action="comunicados.cfm" onSubmit="return fnVerificarDatos(this);">
	  	<input name="nombreOrigen" type="hidden" value="#qryUsuActual.Nombre#">
	  	<input name="UsucodigoDest" type="hidden" value="">		
	  	<input name="UlocalizacionDest" type="hidden" value="">		
	  	<input name="MailDest" type="hidden" value="">				
		
      <table border="0" width="100%">
        <tr> 
          <td width="68">De:</td>
          <td>#qryUsuActual.Nombre#</td>
        </tr>
        <tr> 
          <td width="68">Para:</td>
          <td> <cfif Session.RolActual eq 4>
              <!--- Centro Educativo --->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="35%"> <input name="MensPara" type="radio" class="area" onClick="javascript: verPara(this)" checked value="3">
                    Docentes</td>
                  <td width="33%">) </td>
                  <td width="32%"><input type="radio" class="area" name="MensPara" value="5" onClick="javascript: verPara(this)">
                    Alumnos (as) </td>
                </tr>
              </table>
              <cfelseif Session.RolActual eq 5>
				<input type="radio" class="area" name="MensPara" value="4" onClick="javascript: verPara(this)">	<!--- Encargado --->
                    Encargados (as)           
				<input type="radio" class="area" name="MensPara" value="3" onClick="javascript: verPara(this)">	<!--- Docente --->
              		Otros docentes 
              <cfelseif Session.RolActual eq 6>
              <!--- Alumno --->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="35%"> <input name="MensPara" type="radio" class="area" onClick="javascript: verPara(this)" checked value="1">
                    Director (es)</td>
                  <td width="33%"> <input type="radio" class="area" name="MensPara" value="4" onClick="javascript: verPara(this)">
                    Encargados (as) </td>
                  <td width="32%"><input type="radio" class="area" name="MensPara" value="6" onClick="javascript: verPara(this)">
                    Compa&ntilde;eros (as) </td>
                </tr>
              </table>
              <cfelseif Session.RolActual eq 7>
              <!--- Padre o Encargado --->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="30%"><input name="MensPara" type="radio" class="area" onClick="javascript: verPara(this)" checked value="1">
                    Director (as)</td>
                  <td width="30%"><input type="radio" class="area" name="MensPara" value="2" onClick="javascript: verPara(this)">
                    Hijos (as)</td>
                  <td width="40%"><input type="radio" class="area" name="MensPara" value="3" onClick="javascript: verPara(this)">
                    Docentes</td>
                </tr>
              </table>
              <cfelseif Session.RolActual eq 11>
              <!--- Asistente --->
              ** Por definir ** 
              <cfelseif Session.RolActual eq 12>
              <!--- Director --->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="35%"> <input name="MensPara" type="radio" class="area" onClick="javascript: verPara(this)" checked value="3">
                    Docentes</td>
                  <td width="33%"> <input type="radio" class="area" name="MensPara" value="4" onClick="javascript: verPara(this)">
                    Encargados (as) </td>
                  <td width="32%"><input type="radio" class="area" name="MensPara" value="5" onClick="javascript: verPara(this)">
                    Alumnos (as) </td>
                </tr>
              </table>
            </cfif> </td>
        </tr>
        <tr> 
          <td width="68">&nbsp;</td>
          <td> <cfif Session.RolActual eq 4>      <!--- Centro Educativo --->
              <div style="display: ;" id="ver_MateDoc"> Materia : 
                <select size="1" name="cboMateDocTemp" onChange="javascript: cambioMate(this);">
                  <option value="-999~* * TODOS LOS PROFESORES (AS) * *">* * TODAS LAS MATERIAS * *</option>
                  <cfloop query="qryMateXDoc">
                    <option value="#Mconsecutivo#">#Mnombre#</option>
                  </cfloop>
                </select>
                <input type="hidden" name="cboDocenteTemp" value="">
              </div>
              <div style="display: ;" id="ver_Encargados"> 
                <select size="1" name="cboEncargadoTemp">
                  <option value="-999">* * TODOS LOS ENCARGADOS * *</option>
                  <cfloop query="qryEncargados">
                    <option value="#persona#">#nombreEncar#</option>
                  </cfloop>
                </select>
              </div>
              <div style="display: ;" id="ver_Alumnos"> 
                <select size="1" name="cboAlumnoTemp"> 
                  <option value="-999">* * TODOS LOS ALUMNOS * *</option>
                  <cfloop query="qryAlumnos">
                    <option value="#persona#">#nombreAlumno#</option>
                  </cfloop>
                </select>
              </div>
              <cfelseif Session.RolActual eq 5>       <!--- Docente --->
				Materia : 
					<select size="1" name="cboMateDocTemp" onChange="javascript: cambioMate(this);">
					  <option value="-999~* * TODOS LOS PROFESORES (AS) * *">* * TODAS LAS MATERIAS * *</option>
					  <cfloop query="qryMateXDoc">
						<option value="#Mconsecutivo#">#Mnombre#</option>
					  </cfloop>
					</select>
					<input type="hidden" name="cboDocenteTemp" value="">
              <cfelseif Session.RolActual eq 6>      <!--- Alumno --->
              <div style="display: ;" id="ver_Directores"> Director (a): 
                <select size="1" name="cboDirectorTemp" onChange="javascript: cambioDirector(this);">
                  <option value="-999">* * TODOS LOS DIRECTORES (AS) * *</option>
                  <cfloop query="qryDirectDistinc">
                    <option value="#persona#">#NombreDir#</option>
                  </cfloop>
                </select>
             </div>				  
             <div style="display: ;" id="ver_Encargados"> 
                <select size="1" name="cboEncargadoTemp">
                  <option value="-999">* * TODOS LOS ENCARGADOS * *</option>
                  <cfloop query="qryEncargados">
                    <option value="#persona#">#nombreEncar#</option>
                  </cfloop>
                </select>
              </div>
              <div style="display: ;" id="ver_Compas"> 
                <select size="1" name="cboSustitTemp" onChange="javascript: cambioCompa(this);">
                  <option value="-999~** TODOS LOS COMPAÑEROS **">** TODOS LOS COMPAÑEROS **</option>
                  <option value="-998~De grupo">De grupo</option>				  
				  
                  <cfloop query="qrySustitutivas">
                    <option value="#Ccodigo#">De sustitutiva - #Mnombre#</option>
                  </cfloop>
                </select>
			  <input type="hidden" name="cboCompasTemp" value="">
              </div>
              <cfelseif Session.RolActual eq 7>   <!--- Padre o Encargado --->
              <div style="display: ;" id="ver_Directores"> Director (a): 
                <select size="1" name="cboDirectorTemp" onChange="javascript: cambioDirector(this);">
                  <option value="-999">* * TODOS LOS DIRECTORES (AS) * *</option>
                  <cfloop query="qryDirectDistinc">
                    <option value="#persona#">#NombreDir#</option>
                  </cfloop>
                </select>
              </div>					
					  
              <div style="display: ;" id="ver_Hijos"> 
                <select size="1" name="cboHijoTemp">
                  <option value="-999">* * TODOS LOS HIJOS * *</option>
                  <cfloop query="qryHijos">
                    <option value="#persona#">#nombreAl#</option>
                  </cfloop>
                </select>
              </div>

              <div style="display: ;" id="ver_MateDoc"> Materia : 
                <select size="1" name="cboMateDocTemp" onChange="javascript: cambioMate(this);">
                  <option value="-999~* * TODOS LOS PROFESORES (AS) * *">* * TODAS LAS MATERIAS * *</option>
                  <cfloop query="qryMateXDoc">
                    <option value="#Mconsecutivo#">#Mnombre#</option>
                  </cfloop>
                </select>
                <input type="hidden" name="cboDocenteTemp" value="">
              </div>
              <cfelseif Session.RolActual eq 11>       <!--- Asistente --->
              <cfelseif Session.RolActual eq 12>       <!--- Director --->
				  <div style="display: ;" id="ver_MateDoc"> 
						
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td width="43%"><input type="radio" name="rdTipoDoc" checked value="1" onClick="javascript: rdNivel();">
                      Nivel</td>
                    <td width="57%" colspan="2"><input type="radio" name="rdTipoDoc" value="2" onClick="javascript: rdTipoMateria();">
                      Tipo de Materia</td>
                  </tr>
                  <tr> 
                    <td class="subTitulo"> <div style="display: ;" id="ver_Niveles"> 
                        Niveles: 
                        <select size="1" name="cboNivelesTemp" onChange="javascript: cambioCombos(this,1);">
                          <option value="-1">** SELECCIONE EL NIVEL **</option>
                          <option value="-999">** TODOS LOS NIVELES **</option>						  
                          <cfloop query="qryNiveles">
                            <option value="#Ncodigo#">#Ndescripcion#</option>
                          </cfloop>
                        </select>
                      </div>
                      <div style="display: ;" id="ver_TiposMat"> Tipos de materias: 
                        <select size="1" name="cboTiposMatTemp" onChange="javascript: cambioCombos(this,1);">
                          <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>
						  <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>
                          <cfloop query="qryTiposMat">
                            <option value="#MTcodigo#">#MTdescripcion#</option>
                          </cfloop>
                        </select>
                      </div></td>
                    <td class="subTitulo">Docente: 
                      <input name="txtDocente" type="text" id="txtDocente" size="35" maxlength="180" readonly="true"> 
					  <input type="hidden" name="cboDocenteTemp" value="">					  
                      </td>
                    <td class="subTitulo"><a href="javascript: doConlisDocen(1);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></td>
                  </tr>

                  <tr> 
                    <td class="subTitulo"> 
						<div style="display: ;" id="ver_Niveles2">
                        Niveles: 
                        <select size="1" name="cboNivelesTemp2" onChange="javascript: cambioCombos(this,2);">
                          <option value="-1">** SELECCIONE EL NIVEL **</option>
                          <option value="-999">** TODOS LOS NIVELES **</option>						  
                          <cfloop query="qryNiveles">
                            <option value="#Ncodigo#">#Ndescripcion#</option>
                          </cfloop>
                        </select>
                      </div>
                      <div style="display: ;" id="ver_TiposMat2"> Tipos de materias: 
                        <select size="1" name="cboTiposMatTemp2" onChange="javascript: cambioCombos(this,2);">
                          <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>						
                          <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>
                          <cfloop query="qryTiposMat">
                            <option value="#MTcodigo#">#MTdescripcion#</option>
                          </cfloop>
                        </select>
                      </div></td>
                    <td class="subTitulo">Docente: 
                      <input name="txtDocente2" type="text" id="txtDocente2" size="35" maxlength="180" readonly="true"> 
					  <input type="hidden" name="cboDocenteTemp2" value="">					  
                      </td>
                    <td class="subTitulo"><a href="javascript: doConlisDocen(2);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></td>
                  </tr>
				  
                  <tr> 
                    <td class="subTitulo"> 
						<div style="display: ;" id="ver_Niveles3">
                        Niveles: 
                        <select size="1" name="cboNivelesTemp3" onChange="javascript: cambioCombos(this,3);">
                          <option value="-1">** SELECCIONE EL NIVEL **</option>
						  <option value="-999">** TODOS LOS NIVELES **</option>
                          <cfloop query="qryNiveles">
                            <option value="#Ncodigo#">#Ndescripcion#</option>
                          </cfloop>
                        </select>
                      </div>
                      <div style="display: ;" id="ver_TiposMat3"> Tipos de materias: 
                        <select size="1" name="cboTiposMatTemp3" onChange="javascript: cambioCombos(this,3);">
                          <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>
                          <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>						  
                          <cfloop query="qryTiposMat">
                            <option value="#MTcodigo#">#MTdescripcion#</option>
                          </cfloop>
                        </select>
                      </div></td>
                    <td class="subTitulo">Docente: 
                      <input name="txtDocente3" type="text" id="txtDocente3" size="35" maxlength="180" readonly="true"> 
					  <input type="hidden" name="cboDocenteTemp3" value="">					  
                      </td>
                    <td class="subTitulo"><a href="javascript: doConlisDocen(3);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></td>
                  </tr>				  

                  <tr> 
                    <td class="subTitulo"> 
						<div style="display: ;" id="ver_Niveles4">
                        Niveles: 
                        <select size="1" name="cboNivelesTemp4" onChange="javascript: cambioCombos(this,4);">
                          <option value="-1">** SELECCIONE EL NIVEL **</option>
                          <option value="-999">** TODOS LOS NIVELES **</option>
                          <cfloop query="qryNiveles">
                            <option value="#Ncodigo#">#Ndescripcion#</option>
                          </cfloop>
                        </select>
                      </div>
                      <div style="display: ;" id="ver_TiposMat4"> Tipos de materias: 
                        <select size="1" name="cboTiposMatTemp4" onChange="javascript: cambioCombos(this,4);">
                          <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>
                          <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>						  
                          <cfloop query="qryTiposMat">
                            <option value="#MTcodigo#">#MTdescripcion#</option>
                          </cfloop>
                        </select>
                      </div></td>
                    <td class="subTitulo">Docente: 
                      <input name="txtDocente4" type="text" id="txtDocente4" size="35" maxlength="180" readonly="true"> 
					  <input type="hidden" name="cboDocenteTemp4" value="">					  
                      </td>
                    <td class="subTitulo"><a href="javascript: doConlisDocen(4);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></td>
                  </tr>

                <tr> 
                    <td class="subTitulo"> 
						<div style="display: ;" id="ver_Niveles5">
                        Niveles: 
                        <select size="1" name="cboNivelesTemp5" onChange="javascript: cambioCombos(this,5);">
                          <option value="-1">** SELECCIONE EL NIVEL **</option>
                          <option value="-999">** TODOS LOS NIVELES **</option>						  
                          <cfloop query="qryNiveles">
                            <option value="#Ncodigo#">#Ndescripcion#</option>
                          </cfloop>
                        </select>
                      </div>
                      <div style="display: ;" id="ver_TiposMat5"> Tipos de materias: 
                        <select size="1" name="cboTiposMatTemp5" onChange="javascript: cambioCombos(this,5);">
                          <option value="-1">** SELECCIONE EL TIPO DE MATERIA **</option>
                          <option value="-999">** TODOS LOS TIPOS DE MATERIA **</option>						  
                          <cfloop query="qryTiposMat">
                            <option value="#MTcodigo#">#MTdescripcion#</option>
                          </cfloop>
                        </select>
                      </div></td>
                    <td class="subTitulo">Docente: 
                      <input name="txtDocente5" type="text" id="txtDocente5" size="35" maxlength="180" readonly="true"> 
					  <input type="hidden" name="cboDocenteTemp5" value="">					  
                      </td>
                    <td class="subTitulo"><a href="javascript: doConlisDocen(5);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></td>
                  </tr>  			  				  
                </table>
				  </div>			  
				  <div style="display: ;" id="ver_Encargados"> 
					<select size="1" name="cboEncargadoTemp">
					  <option value="-999">* * TODOS LOS ENCARGADOS * *</option>					  
					  <cfloop query="qryEncargados">
						<option value="#persona#">#nombreEncar#</option>
					  </cfloop>
					</select>
				  </div>
				  <div style="display: ;" id="ver_Alumnos"> 
					<select size="1" name="cboAlumnoTemp">
					  <option value="-999">* * TODOS LOS ALUMNOS * *</option>
					  <cfloop query="qryAlumnos">
						<option value="#persona#">#nombreAlumno#</option>
					  </cfloop>
					</select>
				  </div>
            </cfif> 
		  </td>
        </tr>
        <tr> 
          <td width="68">&nbsp;</td>
          <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>
	 			  <label style="display: ;" id="paraProf">Profesor (a): </label> 
                  <label style="display: ;" id="paraDir">Nivel asociado: </label>	
                  <label style="display: ;" id="paraCompa">Compa&ntilde;eros (as): 
                  </label> </td>
                <td> <input class="inputLabel" type="text" size="40" name="txtEtiqueta" readonly="true" value=""> 
				</td>
                <td><div style="display: ;" id="ver_conlis"><a href="javascript: doConlisCompas(this);"><img src="../Imagenes/Description.gif" width="14" border="0" height="14"></a></div></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td width="68">Asunto:</td>
          <td> <input type="text" size="60" name="txtAsunto" value=""> </td>
        </tr>
        <tr> 
          <td width="68">Mensaje:</td>
          <td><textarea rows="10" cols="45" style="font:10px Verdana, Arial, Helvetica, sans-serif;" name="txtMSG"></textarea></td>
        </tr>
        <tr> 
          <td colspan="2" align="center"><input type="submit" value="Enviar" name="btnEnviar" class="boxNormal"></td>
        </tr>
      </table> 
	  </form>
	</cfif>
</cfoutput>

<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	<cfif Session.RolActual eq 6 or Session.RolActual eq 7>
		arrNivXDirect = new Array();	
		
		<cfloop query="qryNivelXDirec">
			arrNivXDirect[arrNivXDirect.length] = '<cfoutput>#qryNivelXDirec.Ncodigo#</cfoutput>' + '~' + '<cfoutput>#qryNivelXDirec.persona#</cfoutput>' + '~' + '<cfoutput>#qryNivelXDirec.Ndescripcion#</cfoutput>'; 
		</cfloop>
	</cfif>
	
	function cambioCompa(obj){
		var temp = obj.value.split('~');
		
		obj.form.cboCompasTemp.value = temp[0];
		obj.form.txtEtiqueta.value = temp[1];
	}

	function cambioMate(obj){
		var temp = obj.value.split('~');
		
		obj.form.cboDocenteTemp.value = temp[0];
		obj.form.txtEtiqueta.value = temp[1];
	}
	
	function cambioDirector(obj){
		var temp = "";
		var temp2 = "";		
		if(obj.value == '-999'){
			temp = "** TODOS LOS DIRECTORES (AS) **";
		}else{
			for(var i=0;i<arrNivXDirect.length;i++){
				temp2 = arrNivXDirect[i].split('~');
				
				if(temp2[1] == obj.value){
					temp = temp + (temp2[2] + ',');
				}
			}
		}
		
		obj.form.txtEtiqueta.value = temp;
	}	
	
	function fnVerificarDatos(form){
	  if (form.txtAsunto.value == "") {
		alert("ERROR: Digite el asunto del Comunicado");
		form.txtAsunto.focus();
		return false;
	  }
	  if (form.txtMSG.value == ""){
		alert("ERROR: Digite el mensaje del Comunicado");
		form.txtMSG.focus();
		return false;
	  }
	  <cfif not isdefined('form.btnEnviar')>
		  <cfif Session.RolActual eq 4>			// Centro educativo
		  
		  <cfelseif Session.RolActual eq 5>		// Docente
		  
		  <cfelseif Session.RolActual eq 6>		// Alumno
		  
		  <cfelseif Session.RolActual eq 7>		// Padre o Encargado
			  if(form.MensPara[0].checked){	//Directores
				  if (form.cboDirectorTemp.value == "-999"){
					if (!confirm("¿Esta seguro que desea enviar el comunicado a TODOS lo directores del alumno?"))
					  return false;
				  }
			  }else{
				  if(form.MensPara[1].checked){	//Hijos
					  if (form.cboHijoTemp.value == "-999"){	//hijos
						if (!confirm("¿Esta seguro que desea enviar el comunicado a TODOS sus hijos ?"))
						  return false;	  
					  }
				  }else{
					  if (form.cboDocenteTemp.value == "-999"){
						if (!confirm("¿Esta seguro que desea enviar el comunicado a TODOS lo profesores del alumno?"))
						  return false;
					  }				  
				  }	
			  }
		  <cfelseif Session.RolActual eq 11>	// Asistente
		  <cfelseif Session.RolActual eq 12>	// Director
				if(document.frmMail.MensPara[0].checked){	//solo valida cuando el mensaje es para el docente
					if(	((document.frmMail.cboDocenteTemp.value == "-1") || (document.frmMail.cboDocenteTemp.value == "")) &&
						((document.frmMail.cboDocenteTemp2.value == "-1") || (document.frmMail.cboDocenteTemp2.value == "")) &&
						((document.frmMail.cboDocenteTemp3.value == "-1") || (document.frmMail.cboDocenteTemp3.value == "")) &&
						((document.frmMail.cboDocenteTemp4.value == "-1") || (document.frmMail.cboDocenteTemp4.value == "")) &&
						((document.frmMail.cboDocenteTemp5.value == "-1") || (document.frmMail.cboDocenteTemp5.value == ""))){
						   
						   
						alert('debe elegir al menos un docente para el envio del comunicado');
						return false;
					}else{
						if(document.frmMail.cboDocenteTemp.value == ""){
							alert('debe elegir el primer docente');
							return false;				
						}
						if (document.frmMail.cboDocenteTemp2.value == ""){
							alert('Debe elegir el segundo docente');
							return false;					
						}
						if (document.frmMail.cboDocenteTemp3.value == ""){
							alert('debe elegir el tercer docente');
							return false;				
						}
						if (document.frmMail.cboDocenteTemp4.value == ""){
							alert('debe elegir el cuarto docente');
							return false;				
						}
						if (document.frmMail.cboDocenteTemp5.value == ""){
							alert('debe elegir el quinto docente');
							return false;				
						}				
					}
				}					
		  </cfif>
	   </cfif>
	  
	  return true;
	}
	
	<!--- Para ejecutar la funcion de inicio que apaga o prende combos dependiendo del rol actual --->
	<cfif Session.RolActual eq 4 or Session.RolActual eq 12>		<!--- Centro Educativo y Director respectivamente --->
		function doConlisDocen(opc) {
			var tipoLista = 0;
						
			if(document.frmMail.rdTipoDoc[0].checked){
				tipoLista = 1;
			}else{
				tipoLista = 2;			
			}
			
			switch(opc){	//bloques (filas) de nivel o tipo de materia con el campo para el nombre del docente
				case 1:{ 	//Fila 1
					if(document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
						if(document.frmMail.cboNivelesTemp.value == "-1"){
							alert('Por favor elija un nivel');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente"						
										+"&cboDocenteTemp=cboDocenteTemp"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp.value,250,200,650,350);						
						}
					}else{	// Para el tipo de materia
						if(document.frmMail.cboTiposMatTemp.value == "-1"){
							alert('Por favor elija un tipo de materia');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente"						
										+"&cboDocenteTemp=cboDocenteTemp"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp.value,250,200,650,350);						
						}					
					}	
				}
				break;
				case 2:{	//Fila 2
					if(document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
						if(document.frmMail.cboNivelesTemp2.value == "-1"){
							alert('Por favor elija un nivel');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente2"						
										+"&cboDocenteTemp=cboDocenteTemp2"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp2.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp2.value,250,200,650,350);						
						}
					}else{	// Para el tipo de materia
						if(document.frmMail.cboTiposMatTemp2.value == "-1"){
							alert('Por favor elija un tipo de materia');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente2"						
										+"&cboDocenteTemp=cboDocenteTemp2"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp2.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp2.value,250,200,650,350);						
						}					
					}				
				}
				break;
				case 3:{	//Fila 3
					if(document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
						if(document.frmMail.cboNivelesTemp3.value == "-1"){
							alert('Por favor elija un nivel');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente3"						
										+"&cboDocenteTemp=cboDocenteTemp3"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp3.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp3.value,250,200,650,350);						
						}
					}else{	// Para el tipo de materia
						if(document.frmMail.cboTiposMatTemp3.value == "-1"){
							alert('Por favor elija un tipo de materia');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente3"						
										+"&cboDocenteTemp=cboDocenteTemp3"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp3.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp3.value,250,200,650,350);						
						}					
					}
				}
				break;
				case 4:{	//Fila 4
					if(document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
						if(document.frmMail.cboNivelesTemp4.value == "-1"){
							alert('Por favor elija un nivel');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente4"						
										+"&cboDocenteTemp=cboDocenteTemp4"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp4.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp4.value,250,200,650,350);						
						}
					}else{	// Para el tipo de materia
						if(document.frmMail.cboTiposMatTemp4.value == "-1"){
							alert('Por favor elija un tipo de materia');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente4"						
										+"&cboDocenteTemp=cboDocenteTemp4"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp4.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp4.value,250,200,650,350);						
						}					
					}			
				}
				break;
				case 5:{	//Fila 5
					if(document.frmMail.rdTipoDoc[0].checked){	// para el Nivel
						if(document.frmMail.cboNivelesTemp5.value == "-1"){
							alert('Por favor elija un nivel');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente5"						
										+"&cboDocenteTemp=cboDocenteTemp5"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp5.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp5.value,250,200,650,350);						
						}
					}else{	// Para el tipo de materia
						if(document.frmMail.cboTiposMatTemp5.value == "-1"){
							alert('Por favor elija un tipo de materia');
						}else{
							popUpWindow("conlisDocentes.cfm?forma=frmMail"
										+"&txtEtiqueta=txtEtiqueta"
										+"&txtDocente=txtDocente5"						
										+"&cboDocenteTemp=cboDocenteTemp5"
										+"&rdTipoDoc=" + tipoLista 
										+"&cboNivelesTemp=" + document.frmMail.cboNivelesTemp5.value
										+"&cboTiposMatTemp=" + document.frmMail.cboTiposMatTemp5.value,250,200,650,350);						
						}					
					}									
				}
				break;																				
			}
		}	
		
		function cambioCombos(obj,opc){
			switch(opc){
				case 1:{	//Fila 1
					if(obj.value == "-999" || obj.value == "-1"){
						obj.form.cboDocenteTemp.value = obj.value;						
					}else{
						obj.form.cboDocenteTemp.value = "";					
					}
					
					obj.form.txtDocente.value = "";					
				}
				break;
				case 2:{	//Fila 2
					if(obj.value == "-999" || obj.value == "-1"){
						obj.form.cboDocenteTemp2.value = obj.value;						
					}else{
						obj.form.cboDocenteTemp2.value = "";					
					}
								
					obj.form.txtDocente2.value = "";
				}
				break;				
				case 3:{	//Fila 3
					if(obj.value == "-999" || obj.value == "-1"){
						obj.form.cboDocenteTemp3.value = obj.value;						
					}else{
						obj.form.cboDocenteTemp3.value = "";				
					}
									
					obj.form.txtDocente3.value = "";
				}
				break;
				case 4:{	//Fila 4
					if(obj.value == "-999" || obj.value == "-1"){
						obj.form.cboDocenteTemp4.value = obj.value;						
					}else{
						obj.form.cboDocenteTemp4.value = "";				
					}
									
					obj.form.txtDocente4.value = "";
				}
				break;
				case 5:{	//Fila 5
					if(obj.value == "-999" || obj.value == "-1"){
						obj.form.cboDocenteTemp5.value = obj.value;						
					}else{
						obj.form.cboDocenteTemp5.value = "";				
					}

					obj.form.txtDocente5.value = "";
				}
				break;								
			}			
		}
		
		function rdTipoMateria(){
			var connVer_TiposMat	= document.getElementById("ver_TiposMat");		
			var connVer_Niveles		= document.getElementById("ver_Niveles");		
			var connVer_TiposMat2	= document.getElementById("ver_TiposMat2");		
			var connVer_Niveles2	= document.getElementById("ver_Niveles2");
			var connVer_TiposMat3	= document.getElementById("ver_TiposMat3");		
			var connVer_Niveles3	= document.getElementById("ver_Niveles3");						
			var connVer_TiposMat4	= document.getElementById("ver_TiposMat4");		
			var connVer_Niveles4	= document.getElementById("ver_Niveles4");												
			var connVer_TiposMat5	= document.getElementById("ver_TiposMat5");		
			var connVer_Niveles5	= document.getElementById("ver_Niveles5");			
			
			connVer_TiposMat.style.display = "";
			connVer_Niveles.style.display = "none";
			document.frmMail.txtDocente.value = "";
			document.frmMail.cboDocenteTemp.value = "-999";
			
			connVer_TiposMat2.style.display = "";
			connVer_Niveles2.style.display = "none";
			document.frmMail.txtDocente2.value = "";
			document.frmMail.cboDocenteTemp2.value = "-999";
			
			connVer_TiposMat3.style.display = "";
			connVer_Niveles3.style.display = "none";
			document.frmMail.txtDocente3.value = "";
			document.frmMail.cboDocenteTemp3.value = "-999";									
			
			connVer_TiposMat4.style.display = "";
			connVer_Niveles4.style.display = "none";
			document.frmMail.txtDocente4.value = "";
			document.frmMail.cboDocenteTemp4.value = "-999";												
			
			connVer_TiposMat5.style.display = "";
			connVer_Niveles5.style.display = "none";
			document.frmMail.txtDocente5.value = "";
			document.frmMail.cboDocenteTemp5.value = "-999";															
			
			document.frmMail.txtEtiqueta.value = "";
			
			cambioCombos(document.frmMail.cboNivelesTemp,1);
			cambioCombos(document.frmMail.cboNivelesTemp2,2);				
			cambioCombos(document.frmMail.cboNivelesTemp3,3);				
			cambioCombos(document.frmMail.cboNivelesTemp4,4);				
			cambioCombos(document.frmMail.cboNivelesTemp5,5);			
		}
		
		function rdNivel(){
			var connVer_TiposMat	= document.getElementById("ver_TiposMat");
			var connVer_Niveles		= document.getElementById("ver_Niveles");
			var connVer_TiposMat2	= document.getElementById("ver_TiposMat2");		
			var connVer_Niveles2	= document.getElementById("ver_Niveles2");								
			var connVer_TiposMat3	= document.getElementById("ver_TiposMat3");		
			var connVer_Niveles3	= document.getElementById("ver_Niveles3");											
			var connVer_TiposMat4	= document.getElementById("ver_TiposMat4");		
			var connVer_Niveles4	= document.getElementById("ver_Niveles4");																
			var connVer_TiposMat5	= document.getElementById("ver_TiposMat5");		
			var connVer_Niveles5	= document.getElementById("ver_Niveles5");			
			
			connVer_TiposMat.style.display = "none";
			connVer_Niveles.style.display = "";
			document.frmMail.txtDocente.value = "";
			document.frmMail.cboDocenteTemp.value = "-999";			
			
			connVer_TiposMat2.style.display = "none";
			connVer_Niveles2.style.display = "";
			document.frmMail.txtDocente2.value = "";
			document.frmMail.cboDocenteTemp2.value = "-999";

			connVer_TiposMat3.style.display = "none";
			connVer_Niveles3.style.display = "";
			document.frmMail.txtDocente3.value = "";
			document.frmMail.cboDocenteTemp3.value = "-999";									
			
			connVer_TiposMat4.style.display = "none";
			connVer_Niveles4.style.display = "";
			document.frmMail.txtDocente4.value = "";
			document.frmMail.cboDocenteTemp4.value = "-999";			
			
			connVer_TiposMat5.style.display = "none";
			connVer_Niveles5.style.display = "";
			document.frmMail.txtDocente5.value = "";
			document.frmMail.cboDocenteTemp5.value = "-999";			
					
			document.frmMail.txtEtiqueta.value = "";
			
			cambioCombos(document.frmMail.cboNivelesTemp,1);
			cambioCombos(document.frmMail.cboNivelesTemp2,2);				
			cambioCombos(document.frmMail.cboNivelesTemp3,3);				
			cambioCombos(document.frmMail.cboNivelesTemp4,4);				
			cambioCombos(document.frmMail.cboNivelesTemp5,5);			
		}
		
		function verParaInicio(obj){
			var connVer_Encargados	= document.getElementById("ver_Encargados");
			var connVer_Alumnos		= document.getElementById("ver_Alumnos");			
			var connVer_MateDoc		= document.getElementById("ver_MateDoc");
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir		= document.getElementById("paraDir");
			var connVer_paraCompa	= document.getElementById("paraCompa");
			var connVer_conlis		= document.getElementById("ver_conlis");
				
			if(obj.checked && obj.value == 3){	//Docentes
				connVer_Encargados.style.display = "none";			
				connVer_Alumnos.style.display = "none";
				connVer_MateDoc.style.display = "";						
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "none";
				connVer_paraCompa.style.display = "none";				
				connVer_conlis.style.display = "none";																																
				rdNivel();
			}else{
				if(obj.checked && obj.value == 4){	//Encargados
					connVer_Encargados.style.display = "";			
					connVer_Alumnos.style.display = "none";
					connVer_MateDoc.style.display = "none";
					connVer_paraProf.style.display = "none";						
					connVer_paraDir.style.display = "none";										
					connVer_paraCompa.style.display = "none";				
					connVer_conlis.style.display = "none";					
					obj.form.txtEtiqueta.value = "";
				}else{
					if(obj.checked && obj.value == 5){	//Alumnos
						connVer_Encargados.style.display = "none";			
						connVer_Alumnos.style.display = "";
						connVer_MateDoc.style.display = "none";
						connVer_paraProf.style.display = "none";						
						connVer_paraDir.style.display = "none";										
						connVer_paraCompa.style.display = "none";				
						connVer_conlis.style.display = "none";					
						obj.form.txtEtiqueta.value = "";
					}				
				}
			}
		}	
		function verPara(obj){
			var connVer_Encargados	= document.getElementById("ver_Encargados");
			var connVer_Alumnos		= document.getElementById("ver_Alumnos");	
			var connVer_MateDoc		= document.getElementById("ver_MateDoc");
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir		= document.getElementById("paraDir");		
			var connVer_paraCompa	= document.getElementById("paraCompa");						
			var connVer_conlis		= document.getElementById("ver_conlis");			
			
			if(obj.value == 3){	//Docentes
				connVer_Encargados.style.display = "none";			
				connVer_Alumnos.style.display = "none";
				connVer_MateDoc.style.display = "";						
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "none";
				connVer_paraCompa.style.display = "none";				
				connVer_conlis.style.display = "none";					
//				obj.form.rdTipoDoc[0].checked = true;
				rdNivel();
			}else{
				if(obj.value == 4){	//Encargados
					connVer_Encargados.style.display = "";			
					connVer_Alumnos.style.display = "none";
					connVer_MateDoc.style.display = "none";
					connVer_paraProf.style.display = "none";						
					connVer_paraDir.style.display = "none";
					connVer_paraCompa.style.display = "none";				
					connVer_conlis.style.display = "none";					
					obj.form.txtEtiqueta.value = "";				
				}else{
					if(obj.value == 5){	//Alumnos
						connVer_Encargados.style.display = "none";			
						connVer_Alumnos.style.display = "";
						connVer_MateDoc.style.display = "none";
						connVer_paraProf.style.display = "none";						
						connVer_paraDir.style.display = "none";					
						connVer_paraCompa.style.display = "none";				
						connVer_conlis.style.display = "none";					
						obj.form.txtEtiqueta.value = "";
					}				
				}
			}
		}		
		<cfif not isdefined('form.btnEnviar')>
			verParaInicio(document.frmMail.MensPara[0]);
		</cfif>
	<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
		var connVer_paraProf	= document.getElementById("paraProf");			
		var connVer_paraDir	= document.getElementById("paraDir");
			
		connVer_paraProf.style.display = "";						
		connVer_paraDir.style.display = "none";										
		cambioMate(document.frmMail.cboMateDocTemp);			
	<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
		function doConlisCompas() {
			cambioCompa(document.frmMail.cboSustitTemp);
			popUpWindow("conlisCompas.cfm?forma=frmMail"
						+"&txtEtiqueta=txtEtiqueta"
						+"&cboCompasTemp=cboCompasTemp"
						+"&cboCompasTempVAL=" + document.frmMail.cboCompasTemp.value,250,200,650,350);
		}
		
		function verParaInicio(obj){
			var connVer_Directores	= document.getElementById("ver_Directores");
			var connVer_Encargados	= document.getElementById("ver_Encargados");
			var connVer_Compas		= document.getElementById("ver_Compas");			
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir		= document.getElementById("paraDir");		
			var connVer_paraCompa	= document.getElementById("paraCompa");						
			var connVer_conlis		= document.getElementById("ver_conlis");
				
			if(obj.checked && obj.value == 1){	//Directores
				connVer_Directores.style.display = "";
				connVer_Encargados.style.display = "none";		
				connVer_Compas.style.display = "none";						
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "";
				connVer_paraCompa.style.display = "none";				
				connVer_conlis.style.display = "none";				
				cambioDirector(document.frmMail.cboDirectorTemp);
			}else{
				if(obj.checked && obj.value == 4){	//Encargados
					connVer_Directores.style.display = "none";
					connVer_Encargados.style.display = "";		
					connVer_Compas.style.display = "none";						
					connVer_paraProf.style.display = "none";						
					connVer_paraDir.style.display = "none";
					connVer_paraCompa.style.display = "none";
					connVer_conlis.style.display = "none";
					obj.form.txtEtiqueta.value = "";
				}else{
					if(obj.checked && obj.value == 6){	//Companeros
						connVer_Directores.style.display = "none";
						connVer_Encargados.style.display = "none";		
						connVer_Compas.style.display = "";													
						connVer_paraProf.style.display = "none";						
						connVer_paraDir.style.display = "none";					
						connVer_paraCompa.style.display = "";
						connVer_conlis.style.display = "";
						if(document.frmMail.cboSustitTemp.value == '-999'){
							obj.form.txtEtiqueta.value = "** TODOS LOS COMPAÑEROS **";
						}else{
							if(document.frmMail.cboSustitTemp.value == '-998'){
								obj.form.txtEtiqueta.value = "** TODOS LOS COMPAÑEROS DE GRUPO **";						
							}else{
								obj.form.txtEtiqueta.value = "";
							}
						}
						cambioCompa(document.frmMail.cboSustitTemp);
					}				
				}
			}
		}	
		function verPara(obj){
			var connVer_Directores	= document.getElementById("ver_Directores");
			var connVer_Encargados	= document.getElementById("ver_Encargados");
			var connVer_Compas		= document.getElementById("ver_Compas");			
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir		= document.getElementById("paraDir");
			var connVer_paraCompa	= document.getElementById("paraCompa");
			var connVer_conlis		= document.getElementById("ver_conlis");
			
			if(obj.value == 1){	//Directores
				connVer_Directores.style.display = "";
				connVer_Encargados.style.display = "none";		
				connVer_Compas.style.display = "none";						
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "";
				connVer_paraCompa.style.display = "none";
				connVer_conlis.style.display = "none";
				cambioDirector(document.frmMail.cboDirectorTemp);
			}else{
				if(obj.value == 4){	//Encargados
					connVer_Directores.style.display = "none";
					connVer_Encargados.style.display = "";		
					connVer_Compas.style.display = "none";						
					connVer_paraProf.style.display = "none";						
					connVer_paraDir.style.display = "none";
					connVer_paraCompa.style.display = "none";
					connVer_conlis.style.display = "none";
					obj.form.txtEtiqueta.value = "";
				}else{
					if(obj.value == 6){	//Companeros
						connVer_Directores.style.display = "none";
						connVer_Encargados.style.display = "none";		
						connVer_Compas.style.display = "";						
						connVer_paraProf.style.display = "none";						
						connVer_paraDir.style.display = "none";
						connVer_paraCompa.style.display = "";
						connVer_conlis.style.display = "";
						if(document.frmMail.cboSustitTemp.value == '-999'){
							obj.form.txtEtiqueta.value = "** TODOS LOS COMPAÑEROS **";
						}else{
							if(document.frmMail.cboSustitTemp.value == '-998'){
								obj.form.txtEtiqueta.value = "** TODOS LOS COMPAÑEROS DE GRUPO **";						
							}else{
								obj.form.txtEtiqueta.value = "";
							}
						}
						cambioCompa(document.frmMail.cboSustitTemp);
					}				
				}
			}
		}
		<cfif not isdefined('form.btnEnviar')>		
			verParaInicio(document.frmMail.MensPara[0]);
		</cfif>	
	<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
		function verParaInicio(obj){
			var connVer_Directores	= document.getElementById("ver_Directores");
			var connVer_Hijos	= document.getElementById("ver_Hijos");	
			var connVer_MateDoc	= document.getElementById("ver_MateDoc");
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir	= document.getElementById("paraDir");
			var connVer_paraCompa	= document.getElementById("paraCompa");						
			var connVer_conlis		= document.getElementById("ver_conlis");			
			
			if(obj.checked && obj.value == 1){	//Directores
				connVer_Directores.style.display = "";
				connVer_Hijos.style.display = "none";
				connVer_MateDoc.style.display = "none";
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "";
				connVer_paraCompa.style.display = "none";				
				connVer_conlis.style.display = "none";				
				cambioDirector(document.frmMail.cboDirectorTemp);
			}else{	
				if(obj.checked && obj.value == 2){	//Hijos
					connVer_Directores.style.display = "none";
					connVer_Hijos.style.display = "";			
					connVer_Docentes.style.display = "none";
					connVer_MateDoc.style.display = "none";
					connVer_paraCompa.style.display = "none";				
					connVer_conlis.style.display = "none";					
					obj.form.txtEtiqueta.value = "";
				}else{	
					if(obj.checked && obj.value == 3){	// Docentes
						connVer_Directores.style.display = "none";
						connVer_Hijos.style.display = "none";			
						connVer_Docentes.style.display = "";
						connVer_MateDoc.style.display = "";						
						connVer_paraProf.style.display = "";						
						connVer_paraDir.style.display = "none";										
						connVer_paraCompa.style.display = "none";				
						connVer_conlis.style.display = "none";						
						cambioMate(document.frmMail.cboMateDocTemp);
					}
				}
			}
		}	
		function verPara(obj){
			var connVer_Directores	= document.getElementById("ver_Directores");
			var connVer_Hijos	= document.getElementById("ver_Hijos");	
			var connVer_MateDoc	= document.getElementById("ver_MateDoc");
			var connVer_paraProf	= document.getElementById("paraProf");			
			var connVer_paraDir	= document.getElementById("paraDir");
			var connVer_paraCompa	= document.getElementById("paraCompa");						
			var connVer_conlis		= document.getElementById("ver_conlis");						
			
			if(obj.value == 1){	//Directores
				connVer_Directores.style.display = "";
				connVer_Hijos.style.display = "none";
				connVer_MateDoc.style.display = "none";						
				connVer_paraProf.style.display = "none";						
				connVer_paraDir.style.display = "";
				connVer_paraCompa.style.display = "none";				
				connVer_conlis.style.display = "none";				
				cambioDirector(document.frmMail.cboDirectorTemp);				
			}else{	
				if(obj.value == 2){	//Hijos
					connVer_Directores.style.display = "none";
					connVer_Hijos.style.display = "";			
					connVer_MateDoc.style.display = "none";											
					connVer_paraProf.style.display = "none";						
					connVer_paraDir.style.display = "none";					
					connVer_paraCompa.style.display = "none";				
					connVer_conlis.style.display = "none";					
					obj.form.txtEtiqueta.value = "";
				}else{	
					if(obj.value == 3){	// Docentes
						connVer_Directores.style.display = "none";
						connVer_Hijos.style.display = "none";			
						connVer_MateDoc.style.display = "";
						connVer_paraProf.style.display = "";						
						connVer_paraDir.style.display = "none";
						connVer_paraCompa.style.display = "none";				
						connVer_conlis.style.display = "none";																								
						cambioMate(document.frmMail.cboMateDocTemp);
					}
				}
			}
		}
		<cfif not isdefined('form.btnEnviar')>		
			verParaInicio(document.frmMail.MensPara[0]);
		</cfif>
	<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
	
	</cfif>	
</script>

