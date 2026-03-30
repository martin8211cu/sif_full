<link href="/css/soinasp01_azul.css" rel="stylesheet" type="text/css">

<cfif IsDefined("Form.Guardar") or IsDefined("Form.Cambiar")>
	<cfinclude template="principalSQL.cfm">
</cfif>
<cfif IsDefined("Form.txtOlvidar") or IsDefined("Form.Enviar") >
	<cfif  IsDefined("Form.Enviar") and IsDefined("Form.Correo") and len(trim(form.Correo))>
		<cfquery name="rsValida" datasource="#session.datasource#">
			select RHPregunta,RHRespuesta 
			from DatosOferentes
			where RHOemail =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
		</cfquery>
		<cfif isDefined("rsValida") and rsValida.recordCount eq 1  and IsDefined("Form.Respuesta")>
			<cfquery name="rsValida2" datasource="#session.datasource#">
				select RHRespuesta 
				from DatosOferentes 
				where RHOemail         =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Correo)#">
				and RHPregunta  	   =  <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(rsValida.RHPregunta)#">
				and Upper(RHRespuesta) =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(Form.Respuesta))#">
			</cfquery>
			<cfif isDefined("rsValida") and rsValida.recordCount eq 1>
				<cfinclude template="EnviaClave.cfm">
			</cfif>
		</cfif>
	</cfif>
</cfif>	
<cfif IsDefined("Form.txtRegistrar")>
	<cfquery name="rsTipoIdent" datasource="#session.datasource#">
		select NTIcodigo, NTIdescripcion
		from NTipoIdentificacion
		order by NTIdescripcion
	</cfquery>
	<!--- Generate a couple of random numbers --->
	<cfset randNums1 = #RandRange(0,9)#>
	<cfset randNums2 = #RandRange(0,9)#>
	<!--- List of Alphas we will use --->
	<cfset alphas = "A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,U,V,W,X,Y,Z">
	<!--- Generate random numbers for different list element positions --->
	<cfset randChar1 = #RandRange(13,24)#>
	<cfset randChar2 = #RandRange(1,12)#>
	<!--- Now we will store the random Alphas in vars --->
	<cfset randAlpha1 = ListGetAt(alphas,randChar1,',')>
	<cfset randAlpha2 = ListGetAt(alphas,randChar2,',')>
	<!--- Create a string with your rand numbers and rand Alphas --->
	<!--- <cfset finalVerify = "#randNums1##randAlpha1##randAlpha2##randNums2#"> --->
	<cfset session.finalVerify = "#randAlpha1##randChar1##randAlpha2##randChar2#">
	
	<!--- Invoke image.cfc component --->
	<cfif REFind("Window", #server.OS.NAME#)>
		<cfset imageCFC = createObject("component","image") />
	<cfelse>
		<cfset imageCFC = createObject("component","imageNW") />
	</cfif>
	<!--- This struct is necessary to add the text to the image, make sure the correct path to the fontfile is used otherwise it won't work --->
	<cfset fontDetails = StructNew()>
	<cfset fontDetails.fontfile = "#ExpandPath(".")#/fonts/ARLRDBD.TTF">
	<cfset fontDetails.color = "##FF0000">
	<cfset fontDetails.size = 45>
	<!--- 
	1st arg is for passing an image object, which we are not doing here
	2nd arg is to pass the image and location to the CFC
	3rd arg is the new image with the text placed on top of it 
	4th arg is the position of the text on the image from left to right
	5th arg is the position from the top
	6th arg is the fontDetails struct from above
	7th arg is the text to add 
	--->
	
	<cfset imgAddText = imageCFC.addtext("", "#ExpandPath(".")#/Images/logo.jpg",  "#ExpandPath(".")#/Images/bgdigits2.jpg", 1, 0, fontDetails, "#session.finalVerify#")>
</cfif>
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
</style>
 <cfoutput>
	 <!---<cfdump var="#Form#"> ---> 
	<form style="margin:0" name="form1" method="post" onSubmit="return validar();">
		<cfif IsDefined("Form.txtRegistrar")>
			<cfif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 6>
				<cfset form.Correo = "">
			<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 7>
				<cfset form.Cedula = "">
			<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 8>
				<cfset form.Cedula = "">
				<cfset form.Correo = "">
			</cfif>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td  colspan="3">&nbsp;
					
				</td>
			</tr>	
			<tr>
				<td width="25%">&nbsp;</td>
				<td width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr >
							<td bgcolor="##A0BAD3" colspan="3" class="Completoline">
								<font  style="font-size:16px; color:black"><p>* <cf_translate  key="LB_CamposRequeridos"><cf_translate  key="LB_CamposRequeridos">Campos Requeridos</cf_translate></cf_translate></p></font>
							</td>
						</tr>
						<tr >
							<td colspan="3" >&nbsp;
								
							</td>
						</tr>
						<tr>
							<td colspan="3" bgcolor="##A0BAD3" class="RLTtopline"><font  style="font-size:16px; color:blue">
							  <p><cf_translate  key="LB_Registro_en_sistema">Registro en sistema</cf_translate></p></font>
						  </td>
						</tr>
						<tr>
							<td width="2%" class="topline">
								<font  style="font-size:13px"><p>*</p></font>
						  </td>
							<td width="28%" class="topline">
								<font  style="font-size:13px"> 
								<p><cf_translate  key="LB_Correo_electronico">Correo electr&oacute;nico</cf_translate>: </p>
							  </font>
						  </td>
						  
							<td width="70%" class="topline">
								<input style="font-size:13px" TYPE="text" NAME="Correo" SIZE=33 MAXLENGTH=33 
								 value="<cfif IsDefined("Form.Correo") and len(trim(form.Correo))>#form.Correo#</cfif>" 
								alt="Correo electr&oacute;nico">
						  </td>
						</tr>
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>
							</td>
							<td>
								<font  style="font-size:13px"><p><cf_translate  key="LB_Contrasena">Contrase&ntilde;a</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="password" NAME="clave" SIZE=33 MAXLENGTH=33 alt="clave">
							</td>
						</tr>
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>
							</td>
							<td>
								<font  style="font-size:13px"><p><cf_translate  key="LB_RedigitelaContrasena">Redigite la contrase&ntilde;a</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="password" NAME="clave2" SIZE=33 MAXLENGTH=33 alt="clave2">
							</td>
						</tr>
						<tr>
							<td colspan="3" align="center">
								<img  id="img1" name="img1" src="images/bgdigits2.jpg">
							</td>
						</tr>
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>
							</td>
							<td>
								<font  style="font-size:13px"><p>C&oacute;digo de verificaci&oacute;n</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="finalVerify" SIZE=33 MAXLENGTH=33 alt="C&oacute;digo de verificaci&oacute;n">
							</td>
						</tr>
						<tr>
							<td colspan="3" align="left">
								<font  style="font-size:13px; color:red"><p><cf_translate  key="LB_Digite_las_letras">Digite las letras (en may&uacute;sculas) de la im&aacute;gen</cf_translate></p></font>
							</td>
						</tr>
						
						
						
						<tr>
							<td colspan="3" bgcolor="##A0BAD3" class="Completoline">
								<font  style="font-size:16px;color:blue"><p><cf_translate  key="LB_Ayuda1">Si usted olvida su password nuestro sistema lo identificar&aacute; con la siguiente informaci&oacute;n</cf_translate></p></font>
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px">
							  <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate  key="LB_Pregunta_de_seguridad">Pregunta de seguridad</cf_translate>:</p></font>
							</td>
							<td>
								<select name="Pregunta" id="Pregunta" tyle="font-size:13px">
									<option value="1" <cfif IsDefined("Form.Pregunta") and len(trim(form.Pregunta)) and form.Pregunta eq 1 >selected</cfif>>&iquest;Cu&aacute;l es su color preferido?</option>
									<option value="2" <cfif IsDefined("Form.Pregunta") and len(trim(form.Pregunta)) and form.Pregunta eq 2 >selected</cfif>>&iquest;Cu&aacute;l es el nombre de su mascota?</option>
									<option value="3" <cfif IsDefined("Form.Pregunta") and len(trim(form.Pregunta)) and form.Pregunta eq 3 >selected</cfif>>&iquest;Cu&aacute;l es su deporte favorito?</option>
									<option value="4" <cfif IsDefined("Form.Pregunta") and len(trim(form.Pregunta)) and form.Pregunta eq 4 >selected</cfif>>&iquest;Cu&aacute;l es su pel&iacute;cula preferida?</option>
									<option value="5" <cfif IsDefined("Form.Pregunta") and len(trim(form.Pregunta)) and form.Pregunta eq 5 >selected</cfif>>&iquest;Cu&aacute;l es su fruta preferida?</option>
								</select>						
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px">
							  <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p>Digite su respuesta:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="Respuesta" SIZE=33 MAXLENGTH=33 
								value="<cfif IsDefined("Form.Respuesta") and len(trim(form.Respuesta))>#form.Respuesta#</cfif>" 
								alt="Digite su respuesta">
							</td>
						</tr>
						<tr>
							<td colspan="3" bgcolor="##A0BAD3" class="Completoline">
								<font  style="font-size:16px;color:blue"><p>Informaci&oacute;n adicional</p></font>
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px">
							  <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_Nombre">Nombre</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="Nombre" SIZE=33 MAXLENGTH=33 
								value="<cfif IsDefined("Form.Nombre") and len(trim(form.Nombre))>#form.Nombre#</cfif>" 
								alt="Nombre">
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px">
							  <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_PrimerApellido">Primer Apellido</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="Apellido1" SIZE=33 MAXLENGTH=33 
								value="<cfif IsDefined("Form.Apellido1") and len(trim(form.Apellido1))>#form.Apellido1#</cfif>" 
								alt="Primer apellido">
							</td>
						</tr>
						<tr>
							<td width="2%">&nbsp;</td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_SegundoApellido">Segundo Apellido</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="Apellido2" SIZE=33 MAXLENGTH=33 
								value="<cfif IsDefined("Form.Apellido2") and len(trim(form.Apellido2))>#form.Apellido2#</cfif>" 
								alt="Segundo apellido">
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px"> <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_TipoDeIdentificacion">Tipo de Identificaci&oacute;n</cf_translate>:</p></font>
							</td>
							<td>
									<select name="NTIcodigo" id="select" style="font-size:13px" tabindex="1">
									<cfloop query="rsTipoIdent">
									  <option value="#rsTipoIdent.NTIcodigo#" <cfif IsDefined("Form.NTIcodigo") and len(trim(form.NTIcodigo)) and form.NTIcodigo eq rsTipoIdent.NTIcodigo >selected</cfif>>#rsTipoIdent.NTIdescripcion#</option>
									</cfloop>
									</select>
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px"> <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</p></font>
							</td>
							<td>
								<input style="font-size:13px" TYPE="text" NAME="Cedula" SIZE=33 MAXLENGTH=33 
								value="<cfif IsDefined("Form.Cedula") and len(trim(form.Cedula))>#form.Cedula#</cfif>" 
								alt="Identificaci&oacute;n">
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px"> <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate>:</p></font>
							</td>
							<td>
								<select name="RHOcivil" id="RHOcivil" style="font-size:13px" tabindex="1">
								<option value="0" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 0 >selected</cfif>><cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate></option>
								<option value="1" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 1 >selected</cfif>><cf_translate key="CMB_CasadoA">Casado(a)</cf_translate></option>
								<option value="2" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 2 >selected</cfif>><cf_translate key="CMB_DivorciadoA">Divorciado(a)</cf_translate></option>
								<option value="3" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 3 >selected</cfif>><cf_translate key="CMB_ViudoA">Viudo(a)</cf_translate></option>
								<option value="4" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 4 >selected</cfif>><cf_translate key="CMB_UnionLibre">Union Libre</cf_translate></option>
								<option value="5" <cfif IsDefined("Form.RHOcivil") and len(trim(form.RHOcivil)) and form.RHOcivil eq 5 >selected</cfif>><cf_translate key="CMB_SeparadoA">Separado(a)</cf_translate></option>
								</select>							
							</td>
						</tr>
						<tr>
							<td width="2%">
								<font  style="font-size:13px"> <p>*</p></font>
						  </td>
							<td>
								<font  style="font-size:13px"><p><cf_translate key="LB_Sexo">Sexo</cf_translate>:</p></font>
							</td>
							<td>
								<select name="RHOsexo" id="select2" style="font-size:13px" tabindex="1">
								<option value="M" <cfif IsDefined("Form.RHOsexo") and len(trim(form.RHOsexo)) and form.RHOsexo eq "M" >selected</cfif>><cf_translate key="CMB_Masculino">Masculino</cf_translate></option>
								<option value="F" <cfif IsDefined("Form.RHOsexo") and len(trim(form.RHOsexo)) and form.RHOsexo eq "F" >selected</cfif>><cf_translate key="CMB_Femenino">Femenino</cf_translate></option>
								</select>							
							</td>
						</tr>
						<tr>
							<td align="center" nowrap="nowrap" colspan="3" bgcolor="##A0BAD3" class="Completoline">
								<input  class="btnNuevo" style="font-size:11px" type="submit" NAME="Guardar"  value="Guardar"  SIZE=32 MAXLENGTH=32 alt="Guardar">
								<input  class="btnAnterior" style="font-size:11px" type="button" NAME="Regresar"  onclick="javascript:regresar();"  value="Regresar"   alt="Regresar">

							</td>
						</tr>
						<cfif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 6>
							<tr>
								<td colspan="3" >&nbsp;
									
								</td>
							</tr>
							<tr>
								<td>
									<font  style="font-size:13px"> <p>*</p></font>
							    </td>
								<td colspan="2" >
									<font  style="font-size:16px;color:red"><p>El correo electrónico proporcionado ya está registrado en nuestra base de datos</p></font>
								</td>
							</tr>						
						<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 7>
							<tr>
								<td colspan="3" >&nbsp;
									
								</td>
							</tr>
							<tr>
								<td>
									<font  style="font-size:13px"> <p>*</p></font>
							    </td>
								<td colspan="2" >
									<font  style="font-size:16px;color:red"><p>La identificación proporsionada  ya está registrada en nuestra base de datos</p></font>
								</td>
							</tr>								
						<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 8>
							<tr>
								<td colspan="3" >&nbsp;
									
								</td>
							</tr>
							<tr>
								<td>
									<font  style="font-size:13px"> <p>*</p></font>
							    </td>
								<td colspan="2" >
									<font  style="font-size:16px;color:red"><p>La identificaci&oacute;n proporsionada  ya est&aacute; registrada en nuestra base de datos</p></font>
								</td>
							</tr>
							<tr>
								<td colspan="3" >&nbsp;
									
								</td>
							</tr>
							<tr>
								<td>
									<font  style="font-size:13px"> <p>*</p></font>
							    </td>
								<td colspan="2" >
									<font  style="font-size:16px;color:red"><p>El correo electr&oacute;nico proporcionado ya est&aacute; registrado en nuestra base de datos</p></font>
								</td>
							</tr>	
						</cfif>
					</table>
				</td>
				<td width="25%">&nbsp;
					
				</td>
			</tr>
			</table>
			<cfset session.Estado = "0">	
		<cfelseif IsDefined("Form.txtOlvidar") or IsDefined("Form.Enviar") >
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td  colspan="3">&nbsp;
					
				</td>
			</tr>	
			<tr>
				<td width="25%">&nbsp;</td>
				<td width="50%">
					<table width="100%" border="0" cellspacing="2" cellpadding="2">
						<tr >
							<td bgcolor="##A0BAD3" colspan="3" class="Completoline">
								<font  style="font-size:16px; color:black"><p>* <cf_translate  key="LB_CamposRequeridos">Campos Requeridos</cf_translate></p></font>
							</td>
						</tr>
						<tr >
						  <td height="27" colspan="3" >&nbsp;</td>
						</tr>
						<tr >
							<td  colspan="3"  align="center">
								<font  style="font-size:20px; color:blue">
									<p>
										Por motivos de seguridad se crear&aacute; una nueva contrase&ntilde;a para el correo indicado.
									</p>
								</font>
							</td>
						</tr>
						<tr >
						  <td height="27" colspan="3" >&nbsp;</td>
						</tr>
						<tr>
							<td width="2%" class="topline">
								<font  style="font-size:13px"><p>*</p></font>
						  </td>
							<td width="28%" class="topline">
								<font  style="font-size:13px"> 
								<p>Correo electr&oacute;nico: </p>
							  </font>
						  </td>
							<td width="70%" class="topline">
								<cfif isDefined("rsValida") and rsValida.recordCount eq 1>
									<input  TYPE="hidden" NAME="Correo" value="#Form.Correo#">
									#Form.Correo#
								<CFELSE>
									<input style="font-size:13px" TYPE="text" NAME="Correo" SIZE=33 MAXLENGTH=33 alt="Correo electr&oacute;nico"
									 value="">
								</cfif>

						  </td>
						</tr>
						<cfif  IsDefined("Form.Enviar") and IsDefined("rsValida") and rsValida.recordCount eq 1>
							<tr>
								<td width="2%">
									<font  style="font-size:13px">
								  <p>*</p></font>
							  </td>
								<td>
									<font  style="font-size:13px"><p>Pregunta de seguridad:</p></font>
								</td>
								<td>
									<cfswitch expression="#rsValida.RHPregunta#">
										<cfcase value="1">
											&iquest;Cu&aacute;l es su color preferido?
										</cfcase>
										<cfcase value="2">
											&iquest;Cu&aacute;l es el nombre de su mascota?
										</cfcase>
										<cfcase value="3">
											&iquest;Cu&aacute;l es su deporte favorito?
										</cfcase>
										<cfcase value="4">
											&iquest;Cu&aacute;l es su pel&iacute;cula preferida?
										</cfcase>
										<cfcase value="5">
											&iquest;Cu&aacute;l es su fruta preferida?
										</cfcase>
									</cfswitch>
									<input  TYPE="hidden" NAME="Pregunta"  value="#rsValida.RHPregunta#">
								</td>
							</tr>
							<tr>
								<td width="2%">
									<font  style="font-size:13px">
								  <p>*</p></font>
							  </td>
								<td>
									<font  style="font-size:13px"><p>Digite su respuesta:</p></font>
								</td>
								<td>
									<input style="font-size:13px" TYPE="text" NAME="Respuesta" SIZE=33 MAXLENGTH=33 alt="Digite su respuesta">
								</td>
							</tr>
						</cfif>
						<tr>
							<td align="center" nowrap="nowrap" colspan="3" bgcolor="##A0BAD3" class="Completoline">
								<input  class="btnNuevo" style="font-size:11px" type="submit" NAME="Enviar"  value="Enviar"  SIZE=32 MAXLENGTH=32 alt="Enviar">
								<input  class="btnAnterior" style="font-size:11px" type="button" NAME="Regresar"  onclick="javascript:regresar();"   value="Regresar"   alt="Regresar">

							</td>
						</tr>
						<cfif IsDefined("rsValida") and rsValida.recordCount neq 1>
							<tr >
								<td  colspan="3"  align="center">
									<font  style="font-size:20px; color:red">
										<p>
											*** El correo digitado no existe en nuestra base de datos ***
										</p>
									</font>
								</td>
							</tr>
						</cfif>
						<cfif IsDefined("rsValida2") and rsValida2.recordCount neq 1>
							<tr >
								<td  colspan="3"  align="center">
									<font  style="font-size:20px; color:red">
										<p>
											*** Respuesta Incorrecta ***
										</p>
									</font>
								</td>
							</tr>
						</cfif>

						
					</table>
				</td>
				<td width="25%">&nbsp;
					
				</td>
			</tr>
			</table>	
		<cfelseif IsDefined("Form.txtCambio")>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td width="25%">&nbsp;</td>
				<td width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr >
							<td bgcolor="##A0BAD3" colspan="3" class="Completoline">
								<font  style="font-size:16px; color:black"><p>* <cf_translate  key="LB_CamposRequeridos">Campos Requeridos</cf_translate></p></font>							</td>
						</tr>
						<tr>
							<td width="2%" class="topline">
								<font  style="font-size:13px"><p>*</p></font>						  </td>
							<td width="28%" class="topline">
								<font  style="font-size:13px"> 
								<p>Correo electr&oacute;nico: </p>
							  </font>						  </td>
							<td width="70%" class="topline">
								<input style="font-size:13px" TYPE="text" NAME="Correo" SIZE=33 MAXLENGTH=33 alt="Correo electr&oacute;nico">						  </td>
						</tr>					
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>							</td>
							<td>
								<font  style="font-size:13px"><p>Actual contrase&ntilde;a:</p></font>							</td>
							<td><input style="font-size:13px" type="password" name="clave1" size=33 maxlength=33 alt="clave" /></td>
						</tr>
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>							</td>
							<td>
								<font  style="font-size:13px"><p>Nueva contrase&ntilde;a:</p></font>							</td>
							<td>
								<input style="font-size:13px" TYPE="password" NAME="clave2" SIZE=33 MAXLENGTH=33 alt="clave">							</td>
						</tr>
						<tr>
							<td>
								<font  style="font-size:13px"><p>*</p></font>							</td>
							<td nowrap="nowrap">
								<font  style="font-size:13px">
								<p>Redigite la nueva contrase&ntilde;a:</p>
								</font>							</td>
							<td>
								<input style="font-size:13px" TYPE="password" NAME="clave3" SIZE=33 MAXLENGTH=33 alt="clave2">							</td>
						</tr>
	
	
						<tr>
							<td align="center" nowrap="nowrap" colspan="3" bgcolor="##A0BAD3" class="Completoline">
								<input  class="btnNuevo"  style="font-size:11px" type="submit" NAME="Cambiar"  value="Cambiar"   alt="Cambiar">
								<input s class="btnAnterior" tyle="font-size:11px" type="button" NAME="Regresar"  onclick="javascript:regresar();"  value="Regresar"   alt="Regresar">							</td>
						</tr>
					</table>				
				</td>
				<td width="25%">&nbsp;				</td>
			</tr>
			</table>	
		</cfif>
		<input type="hidden" name="RHOid"   			id="RHOid"       		value="<cfif isdefined("form.RHOid") >#form.RHOid#</cfif>">
	</form>
	<script language="JavaScript" type="text/JavaScript">
		function regresar() {
			location.href="index.cfm";
		}
	
		function trim(dato) {
			return dato.replace(/^\s*|\s*$/g,"");
		}
		
		function validarEmail(valor) {
			if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(valor)){
				return (true)
			} 
			else {
				return (false);
			}
		}

		function  validar(){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			<cfif IsDefined("Form.txtRegistrar")>
				if ( trim(document.form1.Correo.value) == '' ){
					error = true;
					mensaje = mensaje + " - El correo electrónico es requerido.\n";
				}
				
				if ( trim(document.form1.Correo.value) != '' ){
					if (validarEmail(document.form1.Correo.value) == false){
						error = true;
						mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
					
					}
				}
				
				if ( trim(document.form1.clave.value) == '' ){
					error = true;
					mensaje = mensaje + " - la contraseña es requerida.\n";
				}
				
				if ( trim(document.form1.clave2.value) == '' ){
					error = true;
					mensaje = mensaje + " - Redigite la contraseña es requerida.\n";
				}
				
				if ( trim(document.form1.clave.value) != '' && trim(document.form1.clave2.value) != ''){
					if ( trim(document.form1.clave.value) != trim(document.form1.clave2.value) ){
						error = true;
						mensaje = mensaje + " - Las contraseñas no son iguales.\n";
					}
				}
				if ( trim(document.form1.finalVerify.value) == '' ){
					error = true;
					mensaje = mensaje + " - El código de verificación es requerido.\n";
				}
				if ( trim(document.form1.Respuesta.value) == '' ){
					error = true;
					mensaje = mensaje + " - La respuesta es requerida.\n";
				}
				if ( trim(document.form1.Nombre.value) == '' ){
					error = true;
					mensaje = mensaje + " - El nombre es requerido.\n";
				}
				if ( trim(document.form1.Apellido1.value) == '' ){
					error = true;
					mensaje = mensaje + " - El primer apellido es requerido.\n";
				}
				if ( trim(document.form1.Cedula.value) == '' ){
					error = true;
					mensaje = mensaje + " - La identificación es requerida.\n";
				}
			<cfelseif IsDefined("Form.txtOlvidar")  or IsDefined("Form.Enviar")>
				if ( trim(document.form1.Correo.value) == '' ){
					error = true;
					mensaje = mensaje + " - El correo electrónico es requerido.\n";
				}
				
				if ( trim(document.form1.Correo.value) != '' ){
					if (validarEmail(document.form1.Correo.value) == false){
						error = true;
						mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
					
					}
				}
				<cfif  IsDefined("Form.Enviar")>
					if ( trim(document.form1.Pregunta.value) == '' ){
						error = true;
						mensaje = mensaje + " - La pregunta es requerida.\n";
					}
					if ( trim(document.form1.Respuesta.value) == '' ){
						error = true;
						mensaje = mensaje + " - La respuesta es requerida.\n";
					}
				</cfif>
			<cfelseif IsDefined("Form.txtCambio")>
				if ( trim(document.form1.Correo.value) == '' ){
					error = true;
					mensaje = mensaje + " - El correo electrónico es requerido.\n";
				}
				
				if ( trim(document.form1.Correo.value) != '' ){
					if (validarEmail(document.form1.Correo.value) == false){
						error = true;
						mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
					
					}
				}				
				
				if ( trim(document.form1.clave1.value) == '' ){
					error = true;
					mensaje = mensaje + " - La contraseña actual es requerida.\n";
				}
				
				
				if ( trim(document.form1.clave2.value) == '' ){
					error = true;
					mensaje = mensaje + " - la nueva contraseña es requerida.\n";
				}
				
				if ( trim(document.form1.clave3.value) == '' ){
					error = true;
					mensaje = mensaje + " - Redigite la nueva contraseña es requerida.\n";
				}
				
				if ( trim(document.form1.clave2.value) != '' && trim(document.form1.clave3.value) != ''){
					if ( trim(document.form1.clave2.value) != trim(document.form1.clave3.value) ){
						error = true;
						mensaje = mensaje + " - Las nuevas contraseñas no son iguales.\n";
					}
				}				

			</cfif>
			if (error){
				alert(mensaje);
				return false;
			}
			return true;	
		}	
</script>
		
	</cfoutput> 