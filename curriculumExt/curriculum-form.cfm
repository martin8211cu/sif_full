<!--- ***************** AREA DE CONSULTAS ***************** --->


<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsMonedaPRT" datasource="#session.DSN#">
	select Miso4217,Miso4217 as Mnombre  from Moneda
</cfquery>

<cfquery name="rsInstituciones" datasource="#session.DSN#">
	select RHIAid, case when len(RHIAnombre) > 40 then {fn concat(substring(RHIAnombre,1,40),'...')}  else RHIAnombre end as RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by RHIAnombre
</cfquery>

<cfquery name="rsGrados" datasource="#session.DSN#">
	select GAcodigo, 
	case when len(GAnombre) > 30 then {fn concat(substring(GAnombre,1,25),'...')}  else GAnombre end as GAnombre 
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedaLOC" datasource="#session.DSN#">
	select Miso4217  from Monedas a
	inner join Empresa b
		on a. Mcodigo = b. Mcodigo
		and a.Ecodigo = b.Ecodigo
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<!--- ***************** verifica si las llaves vienen para hacer los respectivos querys ***************** --->
<!--- llave del educacion --->
<cfif isdefined("url.RHEElinea") and len(trim(url.RHEElinea)) gt 0 and not isdefined("form.RHEElinea")  >
	<cfset form.RHEElinea = url.RHEElinea>
</cfif>
<!--- llave del experiencia --->
<cfif isdefined("url.RHEEid") and len(trim(url.RHEEid)) gt 0 and not isdefined("form.RHEEid")  >
	<cfset form.RHEEid = url.RHEEid>
</cfif>
<!--- ***************** AREA DE CONSULTAS  EN MODO CAMBIO ***************** --->
<cfif isdefined("session.RHOid") and len(trim(session.RHOid))>
	<cfquery datasource="#session.DSN#" name="rsOferente">
		select a.RHOid, a.Ecodigo, a.NTIcodigo, a.RHOidentificacion, a.RHOnombre, a.RHOapellido1, a.RHOapellido2, a.RHOsexo, 
				a.RHOdireccion, a.RHOcivil, a.RHOtelefono1, a.RHOtelefono2, a.RHOemail, a.RHOfechanac, a.RHOobs1, a.RHOobs2, a.RHOobs3,
				a.RHOdato1, a.RHOdato2, a.RHOdato3, a.RHOdato4, a.RHOdato5, a.RHOinfo1, a.RHOinfo2, a.RHOinfo3,
				b.NTIdescripcion, a.ts_rversion, a.Ppais,a.id_direccion,RHORefValida,
				RHOfechaRecep,
				RHOfechaIngr,
				RHOPrenteInf,
				RHOPrenteSup,
				RHOPosViajar,
				RHOPosTralado,
				RHOLengOral1,
				RHOLengOral2,
				RHOLengOral3,
				RHOLengEscr1,
				RHOLengEscr2,
				RHOLengEscr3,
				RHOLengLect1,
				RHOLengLect2,
				RHOLengLect3,
				RHOIdioma1,
				RHOIdioma2,
				RHOIdioma3,
				RHOMonedaPrt,
				RHOEntrevistado,
				RHOfechaEntrevista,
				RHORealizadaPor
		from DatosOferentes a 
		  inner join NTipoIdentificacion b
		    on  a.NTIcodigo = b.NTIcodigo
		where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<cfif isdefined("FORM.RHEEid") and len(trim(FORM.RHEEid))>
		<cfquery name="rsExperiencia" datasource="#session.DSN#">
			select 	RHEEid, RHEEnombreemp, RHEEtelemp, RHOPid, RHEEfechaini, RHEEfecharetiro,
			Actualmente, RHEEfunclogros, ts_rversion, RHEEmotivo,RHEEpuestodes,RHEEAnnosLab
			from RHExperienciaEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
			and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		</cfquery>
		
	</cfif>
	
	<cfif isdefined("FORM.RHEElinea") and len(trim(FORM.RHEElinea))>
		<cfquery name="rsEducacion" datasource="#session.DSN#">		
			select 	RHEElinea, RHIAid, GAcodigo, RHEotrains, RHEtitulo,RHOTid,
					RHEfechaini, RHEfechafin, RHEsinterminar, ts_rversion,RHECapNoFormal
			from RHEducacionEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">	
				and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
		</cfquery>	
	</cfif>
	
	<cfquery name="rsTipoIdent" datasource="#session.DSN#">
		select NTIdescripcion
		from NTipoIdentificacion
		where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOferente.NTIcodigo#">
		order by NTIdescripcion
	</cfquery>
	
</cfif>
<!--- ***************** AREA DE ETIQUETAS ***************** --->
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Datos_Generales"
	Default="Datos Generales"
	returnvariable="LB_Datos_Generales"/>

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Direccion"
	Default="Direcci&oacute;n"
	returnvariable="LB_Direccion"/>	
	
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Otros"
	Default="Otros"
	returnvariable="LB_Otros"/>	

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Experiencia_Laboral"
	Default="Experiencia Laboral"
	returnvariable="LB_Experiencia_Laboral"/>		
	
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Estudios_Realizados"
	Default="Estudios Realizados"
	returnvariable="LB_Estudios_Realizados"/>

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_TituloObtenido"
	Default="T&iacute;tulo obtenido"
	returnvariable="LB_TituloObtenido"/>		

<!--- ***************** PINTADO ***************** --->
<cfoutput>
<script language="JavaScript1.2" src="/js/utilesMonto.js"></script>
<link href="/css/soinasp01_azul.css" rel="stylesheet" type="text/css">
<form style="margin:0" name="form1" method="post" action="curriculum-sql.cfm" enctype="multipart/form-data" >
	<input type="hidden" name="RHOid"   			id="RHOid"       		value="<cfif isdefined("session.RHOid") >#session.RHOid#</cfif>">
	<input type="hidden" name="RHEElinea"   		id="RHEElinea"   		value="<cfif isdefined("form.RHEElinea") >#form.RHEElinea#</cfif>">
	<input type="hidden" name="RHEEid"   			id="RHEEid"      		value="<cfif isdefined("form.RHEEid") >#form.RHEEid#</cfif>">
	<input type="hidden" name="AccionAEjecutar"   	id="AccionAEjecutar"    value="">

	<table width="100%" border="0">
		<tr>
			<td valign="top" bgcolor="##59A3F4" colspan="2">
				<cfinclude template="frame-botones.cfm">
			</td>
		</tr>
		<tr>
			<td>
				<fieldset><legend>#LB_Datos_Generales#</legend>
					<table width="100%" border="0" cellpadding="1" cellspacing="1">
						<tr> 
							<cfif isdefined("session.RHOid") and len(trim(session.RHOid))>
								<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;" rowspan="6"> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center">
												<cfinclude template="frame-foto.cfm">
											</td>
										</tr>
									</table>
								</td>
							</cfif>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate>:</font></td>
							<td>
								<input name="RHOnombre" type="text" id="RHOnombre2" size="30" maxlength="100"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOnombre") and len(trim(rsOferente.RHOnombre))>#rsOferente.RHOnombre#</cfif>">
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_PrimerApellido">Primer Apellido</cf_translate>:</font></td>
	
							<td>
								<input name="RHOapellido1" type="text" id="RHOapellido12" size="30" maxlength="80"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOapellido1") and len(trim(rsOferente.RHOapellido1))>#rsOferente.RHOapellido1#</cfif>">
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_SegundoApellido">Segundo Apellido</cf_translate>:</font></td>
							<td>
								<input name="RHOapellido2" type="text" id="RHOapellido22" size="30" maxlength="80"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOapellido2") and len(trim(rsOferente.RHOapellido2))>#rsOferente.RHOapellido2#</cfif>">
							</td>
						</tr>
	
						<tr> 
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_TipoDeIdentificacion">Tipo de Identificaci&oacute;n</cf_translate>:</font></td>
	
							<td>
								<font  style="font-size:10px">#rsTipoIdent.NTIdescripcion#</font>
								<input type="hidden" name="NTIcodigo"  id="NTIcodigo"  value="<cfif isdefined("rsOferente.NTIcodigo") and len(trim(rsOferente.NTIcodigo)) >#rsOferente.NTIcodigo#</cfif>">

								
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</font></td>
							
							<td>
								<font  style="font-size:10px">#rsOferente.RHOidentificacion#</font>
								<input name="RHOidentificacion" type="hidden" id="RHOidentificacion" 
								value="<cfif isdefined("rsOferente.RHOidentificacion") and len(trim(rsOferente.RHOidentificacion))>#rsOferente.RHOidentificacion#</cfif>">
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_RutaDeLaFoto">Ruta de la foto</cf_translate>:</font></td>
							
							<td>
								<input name="rutaFoto" type="file" id="rutaFoto2" style="font-size:10px" tabindex="1">
							</td>
						</tr>	
						<tr> 
						</tr>
						<tr> 
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate>:</font></td>
	
							<td>
								<select name="RHOcivil" id="RHOcivil" style="font-size:10px" tabindex="1">
								<option value="0" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 0> selected </cfif>><cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate></option>
								<option value="1" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 1> selected </cfif>><cf_translate key="CMB_CasadoA">Casado(a)</cf_translate></option>
								<option value="2" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 2> selected </cfif>><cf_translate key="CMB_DivorciadoA">Divorciado(a)</cf_translate></option>
								<option value="3" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 3> selected </cfif>><cf_translate key="CMB_ViudoA">Viudo(a)</cf_translate></option>
								<option value="4" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 4> selected </cfif>><cf_translate key="CMB_UnionLibre">Union Libre</cf_translate></option>
								<option value="5" <cfif isdefined("rsOferente.RHOcivil") and len(trim(rsOferente.RHOcivil)) and rsOferente.RHOcivil eq 5> selected </cfif>><cf_translate key="CMB_SeparadoA">Separado(a)</cf_translate></option>
								</select>
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_FechaDeNacimiento">Fecha de Nacimiento</cf_translate>:</font></td>
							<td> 

								<cfif isdefined("rsOferente.RHOfechanac") and len(trim(rsOferente.RHOfechanac))>
									<cf_CJCcalendario form="form1" value="#LSDateFormat(rsOferente.RHOfechanac,"DD/MM/YYYY")#" name="RHOfechanac" tabindex="1">				   
								<cfelse>
									<cf_CJCcalendario form="form1" value="" name="RHOfechanac" tabindex="1">				   
								</cfif>
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Sexo">Sexo</cf_translate>:</font></td>
							<td>
								<select name="RHOsexo" id="select2" style="font-size:10px" tabindex="1">
								<option value="M" <cfif isdefined("rsOferente.RHOsexo") and len(trim(rsOferente.RHOsexo)) and rsOferente.RHOsexo eq "M"> selected </cfif>><cf_translate key="CMB_Masculino">Masculino</cf_translate></option>
								<option value="F" <cfif isdefined("rsOferente.RHOsexo") and len(trim(rsOferente.RHOsexo)) and rsOferente.RHOsexo eq "F"> selected </cfif>><cf_translate key="CMB_Femenino">Femenino</cf_translate></option>
								</select>
							</td>
						</tr>
						<tr> 
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_TelefonoDeResidencia">Tel&eacute;fono de Residencia</cf_translate>:</font></td>
						
							<td>
								<input name="RHOtelefono1" type="text" id="RHOtelefono1"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOtelefono1") and len(trim(rsOferente.RHOtelefono1))>#rsOferente.RHOtelefono1#</cfif>" 
								size="30" maxlength="30">
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_TelefonoCelular">Tel&eacute;fono Celular</cf_translate>:</font></td>
							
							<td>
								<input name="RHOtelefono2" type="text" id="RHOtelefono2"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOtelefono2") and len(trim(rsOferente.RHOtelefono2))>#rsOferente.RHOtelefono2#</cfif>" 
								size="30" maxlength="30">
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_DireccionElectronica">Direcci&oacute;n electr&oacute;nica</cf_translate>:</font></td>
							
							<td>
								<input name="RHOemail" type="text" id="RHOemail"  style="font-size:10px" tabindex="1"
								onchange="javascript:validaCorreo(this);"
								value="<cfif isdefined("rsOferente.RHOemail") and len(trim(rsOferente.RHOemail))>#rsOferente.RHOemail#</cfif>" 
								size="30" maxlength="120">
							</td>
						</tr>	
						<tr>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_PaisDeNacimiento">Pa&iacute;s de Nacimiento</cf_translate>:</font></td>
	
							<td colspan="4">
								<select name="Ppais" style="font-size:10px" tabindex="1">
									<option value="">(<cf_translate key="CMB_SeleccioneUnPais">Seleccione un Pa&iacute;s</cf_translate>)</option>
									<cfloop query="rsPais">
									<option value="#rsPais.Ppais#" <cfif isdefined("rsOferente.Ppais") and len(trim(rsOferente.Ppais)) and rsOferente.Ppais eq rsPais.Ppais> selected </cfif>>
										#rsPais.Pnombre#</option>
									</cfloop>
								</select>
							</td>
						</tr>																		
					</table>	
				</fieldset>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="50%" valign="top"> 
							<fieldset><legend>#LB_Direccion#</legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<cfif IsDefined('rsOferente.id_direccion') And Len(rsOferente.id_direccion)>
													<cf_direccion action="input" title="" key="#rsOferente.id_direccion#" tamano_letra ="10" negrita ="false" tabindex="1">
											<cfelse>
													<cf_direccion title="" action="input" tamano_letra ="10" negrita ="false" tabindex="1">	
											</cfif>
										</td>
									</tr>	
								</table>
							</fieldset>
						</td>
						<td width="50%" valign="top">
							<fieldset><legend>#LB_Otros#</legend>
								<table width="100%" border="0" cellpadding="1" cellspacing="1">
									<tr>
										<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_AspiracionSalarial">Aspiraci&oacute;n salarial</cf_translate>:</font></td>
										<td class="fileLabel">
											<select name="RHOMonedaPrt" style="font-size:10px" tabindex="1">
												<cfloop query="rsMonedaPRT">
													<option value="#rsMonedaPRT.Miso4217#"
													<cfif  isdefined("rsOferente.RHOMonedaPrt") and len(trim(rsOferente.RHOMonedaPrt)) and rsMonedaPRT.Miso4217 EQ rsOferente.RHOMonedaPrt> selected
													<cfelseif not isdefined("rsOferente.RHOMonedaPrt")  and rsMonedaPRT.Miso4217 EQ rsMonedaLOC.Miso4217 > selected									
													</cfif>
													>#rsMonedaPRT.Mnombre#</option>
												</cfloop>
											</select>
										</td>
										<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Inferior">Inferior</cf_translate>:</font></td>
										<td>
											<input 
												name="RHOPrenteInf" 
												type="text" 
												id="RHOPrenteInf"  
												tabindex="1"
												style="text-align: right;font-size:10px;" 
												onBlur="javascript: fm(this,2);"  
												onFocus="javascript:this.value=qf(this); this.select();"  
												onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
												size="20" maxlength="60"
												value="<cfif isdefined("rsOferente.RHOPrenteInf") and len(trim(rsOferente.RHOPrenteInf))>#LSNumberFormat(rsOferente.RHOPrenteInf,',.00')#<cfelse>0.00</cfif>">
										</td>
										
										<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Superior">Superior</cf_translate>:</font> </td>
										<td>
											<input 
												name="RHOPrenteSup" 
												type="text" 
												tabindex="1"
												id="RHOPrenteSup"  
												style="text-align: right;font-size:10px;" 
												onBlur="javascript: fm(this,2);"  
												onFocus="javascript:this.value=qf(this); this.select();"  
												onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
												size="20" maxlength="60"
												value="<cfif isdefined("rsOferente.RHOPrenteSup") and len(trim(rsOferente.RHOPrenteSup))>#LSNumberFormat(rsOferente.RHOPrenteSup,',.00')#<cfelse>0.00</cfif>">
										</td>
									</tr>	
									<tr>
										<td colspan="6"  height="120">
											<fieldset><legend><cf_translate key="LB_Idiomas">Idiomas</cf_translate></legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
														<td ></td>
														<td colspan="1" ><font  style="font-size:10px"><cf_translate key="LB_Dominio">Dominio</cf_translate> </font></td>
														<td colspan="1" ><font  style="font-size:10px"><cf_translate key="LB_Dominio">Dominio</cf_translate> </font></td>
														<td colspan="1" ><font  style="font-size:10px"><cf_translate key="LB_Dominio">Dominio</cf_translate> </font></td>
													</tr>	
													<tr> 
														<td ><font  style="font-size:10px"><cf_translate key="LB_Lenguaje">Lenguaje</cf_translate> </font></td>
														<td ><font  style="font-size:10px"><cf_translate key="LB_DominioConversacional">Conversacional</cf_translate> </font></td>
														<td ><font  style="font-size:10px"><cf_translate key="LB_DominioEscrito">Escrito</cf_translate> </font></td>
														<td ><font  style="font-size:10px"><cf_translate key="LB_DominioLectura">Lectura</cf_translate> </font></td>
													</tr>
													<tr> 
														<td>
															<select name="RHOIdioma1" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="1" <cfif   isdefined("rsOferente.RHOIdioma1") and 1 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_ALEMAN">ALEMAN</cf_translate></option>
																<option value="2" <cfif   isdefined("rsOferente.RHOIdioma1") and 2 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate></option>
																<option value="3" <cfif   isdefined("rsOferente.RHOIdioma1") and 3 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_FRANCES">FRANCES</cf_translate></option>
																<option value="4" <cfif   isdefined("rsOferente.RHOIdioma1") and 4 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_INGLES">INGLES</cf_translate></option>
																<option value="5" <cfif   isdefined("rsOferente.RHOIdioma1") and 5 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_ITALIANO">ITALIANO</cf_translate></option>
																<option value="6" <cfif   isdefined("rsOferente.RHOIdioma1") and 6 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_JAPONES">JAPONES</cf_translate></option>
																<option value="7" <cfif   isdefined("rsOferente.RHOIdioma1") and 7 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate></option>							
																<option value="8" <cfif   isdefined("rsOferente.RHOIdioma1") and 8 EQ rsOferente.RHOIdioma1>selected</cfif> ><cf_translate key="LB_MANDARIN">MANDARIN</cf_translate></option>							
															</select>
														</td>
														<td> 
															<select name="RHOLengOral1" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral1") and 10 EQ rsOferente.RHOLengOral1>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral1") and 20 EQ rsOferente.RHOLengOral1>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral1") and 30 EQ rsOferente.RHOLengOral1>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral1") and 40 EQ rsOferente.RHOLengOral1>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral1") and 50 EQ rsOferente.RHOLengOral1>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral1") and 60 EQ rsOferente.RHOLengOral1>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral1") and 70 EQ rsOferente.RHOLengOral1>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral1") and 80 EQ rsOferente.RHOLengOral1>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral1") and 90 EQ rsOferente.RHOLengOral1>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengOral1") and 100 EQ rsOferente.RHOLengOral1>selected</cfif>>100%</option>
								
															</select>						
														</td>
														<td>
															<select name="RHOLengEscr1" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 10 EQ rsOferente.RHOLengEscr1>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 20 EQ rsOferente.RHOLengEscr1>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 30 EQ rsOferente.RHOLengEscr1>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 40 EQ rsOferente.RHOLengEscr1>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 50 EQ rsOferente.RHOLengEscr1>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 60 EQ rsOferente.RHOLengEscr1>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 70 EQ rsOferente.RHOLengEscr1>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 80 EQ rsOferente.RHOLengEscr1>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr1") and 90 EQ rsOferente.RHOLengEscr1>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr1") and 100 EQ rsOferente.RHOLengEscr1>selected</cfif>>100%</option>
								
															</select>						
														</td>
														<td>
															<select name="RHOLengLect1" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect1") and 10 EQ rsOferente.RHOLengLect1>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect1") and 20 EQ rsOferente.RHOLengLect1>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect1") and 30 EQ rsOferente.RHOLengLect1>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect1") and 40 EQ rsOferente.RHOLengLect1>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect1") and 50 EQ rsOferente.RHOLengLect1>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect1") and 60 EQ rsOferente.RHOLengLect1>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect1") and 70 EQ rsOferente.RHOLengLect1>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect1") and 80 EQ rsOferente.RHOLengLect1>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect1") and 90 EQ rsOferente.RHOLengLect1>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengLect1") and 100 EQ rsOferente.RHOLengLect1>selected</cfif>>100%</option>
								
															</select>						
														</td>
													</tr>
													<tr> 
														<td>
															<select name="RHOIdioma2" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="1" <cfif   isdefined("rsOferente.RHOIdioma2") and 1 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_ALEMAN">ALEMAN</cf_translate></option>
																<option value="2" <cfif   isdefined("rsOferente.RHOIdioma2") and 2 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate></option>
																<option value="3" <cfif   isdefined("rsOferente.RHOIdioma2") and 3 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_FRANCES">FRANCES</cf_translate></option>
																<option value="4" <cfif   isdefined("rsOferente.RHOIdioma2") and 4 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_INGLES">INGLES</cf_translate></option>
																<option value="5" <cfif   isdefined("rsOferente.RHOIdioma2") and 5 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_ITALIANO">ITALIANO</cf_translate></option>
																<option value="6" <cfif   isdefined("rsOferente.RHOIdioma2") and 6 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_JAPONES">JAPONES</cf_translate></option>
																<option value="7" <cfif   isdefined("rsOferente.RHOIdioma2") and 7 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate></option>							
																<option value="8" <cfif   isdefined("rsOferente.RHOIdioma2") and 8 EQ rsOferente.RHOIdioma2>selected</cfif> ><cf_translate key="LB_MANDARIN">MANDARIN</cf_translate></option>							
																
															</select>
														</td>
														<td> 
															<select name="RHOLengOral2" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral2") and 10 EQ rsOferente.RHOLengOral2>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral2") and 20 EQ rsOferente.RHOLengOral2>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral2") and 30 EQ rsOferente.RHOLengOral2>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral2") and 40 EQ rsOferente.RHOLengOral2>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral2") and 50 EQ rsOferente.RHOLengOral2>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral2") and 60 EQ rsOferente.RHOLengOral2>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral2") and 70 EQ rsOferente.RHOLengOral2>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral2") and 80 EQ rsOferente.RHOLengOral2>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral2") and 90 EQ rsOferente.RHOLengOral2>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengOral2") and 100 EQ rsOferente.RHOLengOral2>selected</cfif>>100%</option>
															</select>						
														</td>
														<td>
															<select name="RHOLengEscr2" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 10 EQ rsOferente.RHOLengEscr2>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 20 EQ rsOferente.RHOLengEscr2>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 30 EQ rsOferente.RHOLengEscr2>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 40 EQ rsOferente.RHOLengEscr2>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 50 EQ rsOferente.RHOLengEscr2>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 60 EQ rsOferente.RHOLengEscr2>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 70 EQ rsOferente.RHOLengEscr2>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 80 EQ rsOferente.RHOLengEscr2>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr2") and 90 EQ rsOferente.RHOLengEscr2>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr2") and 100 EQ rsOferente.RHOLengEscr2>selected</cfif>>100%</option>
															</select>						
														</td>
														<td>
															<select name="RHOLengLect2" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect2") and 10 EQ rsOferente.RHOLengLect2>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect2") and 20 EQ rsOferente.RHOLengLect2>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect2") and 30 EQ rsOferente.RHOLengLect2>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect2") and 40 EQ rsOferente.RHOLengLect2>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect2") and 50 EQ rsOferente.RHOLengLect2>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect2") and 60 EQ rsOferente.RHOLengLect2>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect2") and 70 EQ rsOferente.RHOLengLect2>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect2") and 80 EQ rsOferente.RHOLengLect2>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect2") and 90 EQ rsOferente.RHOLengLect2>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengLect2") and 100 EQ rsOferente.RHOLengLect2>selected</cfif>>100%</option>
															</select>						
														</td>
													</tr>
								
													<tr> 
														<td height="18">
															<select name="RHOIdioma3" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="1" <cfif   isdefined("rsOferente.RHOIdioma3") and 1 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_ALEMAN">ALEMAN</cf_translate></option>
																<option value="2" <cfif   isdefined("rsOferente.RHOIdioma3") and 2 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate></option>
																<option value="3" <cfif   isdefined("rsOferente.RHOIdioma3") and 3 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_FRANCES">FRANCES</cf_translate></option>
																<option value="4" <cfif   isdefined("rsOferente.RHOIdioma3") and 4 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_INGLES">INGLES</cf_translate></option>
																<option value="5" <cfif   isdefined("rsOferente.RHOIdioma3") and 5 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_ITALIANO">ITALIANO</cf_translate></option>
																<option value="6" <cfif   isdefined("rsOferente.RHOIdioma3") and 6 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_JAPONES">JAPONES</cf_translate></option>
																<option value="7" <cfif   isdefined("rsOferente.RHOIdioma3") and 7 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate></option>							
																<option value="8" <cfif   isdefined("rsOferente.RHOIdioma3") and 8 EQ rsOferente.RHOIdioma3>selected</cfif> ><cf_translate key="LB_MANDARIN">MANDARIN</cf_translate></option>							
																
															</select>
													  </td>
														<td> 
															<select name="RHOLengOral3" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>	
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral3") and 10 EQ rsOferente.RHOLengOral3>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral3") and 20 EQ rsOferente.RHOLengOral3>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral3") and 30 EQ rsOferente.RHOLengOral3>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral3") and 40 EQ rsOferente.RHOLengOral3>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral3") and 50 EQ rsOferente.RHOLengOral3>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral3") and 60 EQ rsOferente.RHOLengOral3>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral3") and 70 EQ rsOferente.RHOLengOral3>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral3") and 80 EQ rsOferente.RHOLengOral3>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral3") and 90 EQ rsOferente.RHOLengOral3>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengOral3") and 100 EQ rsOferente.RHOLengOral3>selected</cfif>>100%</option>
								
															</select>						
														</td>
														<td>
															<select name="RHOLengEscr3" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 10 EQ rsOferente.RHOLengEscr3>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 20 EQ rsOferente.RHOLengEscr3>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 30 EQ rsOferente.RHOLengEscr3>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 40 EQ rsOferente.RHOLengEscr3>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 50 EQ rsOferente.RHOLengEscr3>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 60 EQ rsOferente.RHOLengEscr3>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 70 EQ rsOferente.RHOLengEscr3>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 80 EQ rsOferente.RHOLengEscr3>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr3") and 90 EQ rsOferente.RHOLengEscr3>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr3") and 100 EQ rsOferente.RHOLengEscr3>selected</cfif>>100%</option>
															</select>						
														</td>
														<td>
															<select name="RHOLengLect3" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect3") and 10 EQ rsOferente.RHOLengLect3>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect3") and 20 EQ rsOferente.RHOLengLect3>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect3") and 30 EQ rsOferente.RHOLengLect3>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect3") and 40 EQ rsOferente.RHOLengLect3>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect3") and 50 EQ rsOferente.RHOLengLect3>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect3") and 60 EQ rsOferente.RHOLengLect3>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect3") and 70 EQ rsOferente.RHOLengLect3>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect3") and 80 EQ rsOferente.RHOLengLect3>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect3") and 90 EQ rsOferente.RHOLengLect3>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengLect3") and 100 EQ rsOferente.RHOLengLect3>selected</cfif>>100%</option>
															</select>						
														</td>										
													</tr>									
												</table>
											</fieldset>
										</td>
									</tr>	
									<tr>
										<td colspan="2">
											<input <cfif isdefined("rsOferente.RHOPosViajar") and rsOferente.RHOPosViajar EQ 1>checked</cfif> alt="0" style="font-size:10px" tabindex="1" name="RHOPosViajar" type="checkbox" id="RHOPosViajar" value="0" >
											<font  style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></font>
										</td>
										<td colspan="4">
											<input <cfif isdefined("rsOferente.RHOPosTralado") and rsOferente.RHOPosTralado EQ 1>checked</cfif> alt="0" style="font-size:10px" tabindex="1" name="RHOPosTralado" type="checkbox" id="RHOPosTralado" value="0" >
											<font  style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></font>
										</td>
									</tr>									
								</table>	
							</fieldset>
						</td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td  valign="top"  width="50%">
						<fieldset><legend>#LB_Experiencia_Laboral#</legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
										<table width="100%" border="0" cellpadding="0" cellspacing="0"  >
											<tr>
												<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Empresa">Empresa</cf_translate>:</font></td>
												<td>
													<input  
														name="RHEEnombreemp" 
														type="text" 
														id="RHEEnombreemp"  
														tabindex="1"
														style="font-size:10px;" 
														size="30" maxlength="60"
														value="<cfif isdefined("rsExperiencia.RHEEnombreemp") and len(trim(rsExperiencia.RHEEnombreemp))>#rsExperiencia.RHEEnombreemp#</cfif>">
												</td>
												<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate>:</font></td>
												<td>
													<input 
														name="RHEEtelemp" 
														type="text" 
														id="RHEEtelemp"  
														tabindex="1"
														style="font-size:10px;" 
														size="30" maxlength="35"
														value="<cfif isdefined("rsExperiencia.RHEEtelemp") and len(trim(rsExperiencia.RHEEtelemp))>#rsExperiencia.RHEEtelemp#</cfif>">
												</td>
											</tr>	
											<tr>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Profesion">Profesi&oacute;n</cf_translate>:</font></td>
												<td>
													<cfif isdefined("rsExperiencia.RHOPid") and len(trim(rsExperiencia.RHOPid))>
														&nbsp;<font  style="font-size:11px"><b>#rsExperiencia.RHEEpuestodes#</b></font>
														<input type="hidden" name="RHOPid"  		id="RHOPid"  				value="#rsExperiencia.RHOPid#">
														<input type="hidden" name="RHOPDescripcion"  id="RHOPDescripcion"  		value="#rsExperiencia.RHEEpuestodes#">
													<cfelse>
														<input  
															name="RHOPDescripcion" 
															type="text" 
															id="RHOPDescripcion"  
															tabindex="1"
															style="font-size:10px;" 
															size="30" maxlength="60"
															value="">
													</cfif>
													
													

													
												</td>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Annos">A&ntilde;os</cf_translate>:</font></td>
												<td>
													<input 
														name="RHEEAnnosLab" 
														type="text" 
														id="RHEEAnnosLab"  
														tabindex="1"
														style="text-align: right;font-size:10px;" 
														onBlur="javascript: fm(this,2);"  
														onFocus="javascript:this.value=qf(this); this.select();"  
														onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
														value="<cfif isdefined("rsExperiencia.RHEEAnnosLab") and len(trim(rsExperiencia.RHEEAnnosLab))>#rsExperiencia.RHEEAnnosLab#</cfif>">
												</td>
											</tr>
											<tr>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Ingreso">Ingreso</cf_translate>:</font></td>
												<td nowrap>
													<select name="mesIni" id="mesIni" style="font-size:10px;" tabindex="1">
														<option value="">(<cf_translate key="CMB_Mes" XmlFile="generales.xml">Mes</cf_translate>)</option>
														<option value="1" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="generales.xml">Enero</cf_translate></option>
														<option value="2" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="generales.xml">Febrero</cf_translate></option>
														<option value="3" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="generales.xml">Marzo</cf_translate></option>
														<option value="4" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="generales.xml">Abril</cf_translate></option>
														<option value="5" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="generales.xml">Mayo</cf_translate></option>
														<option value="6" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="generales.xml">Junio</cf_translate></option>
														<option value="7" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="generales.xml">Julio</cf_translate></option>
														<option value="8" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="generales.xml">Agosto</cf_translate></option>
														<option value="9" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="generales.xml">Septiembre</cf_translate></option>
														<option value="10" <cfif isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="generales.xml">Octubre</cf_translate></option>
														<option value="11" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="generales.xml">Noviembre</cf_translate></option>
														<option value="12" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="generales.xml">Diciembre</cf_translate></option>
													</select>
													<select name="anoIni" id="anoIni" style="font-size:10px;" tabindex="1">
														<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
														<cfloop from="1965" to="#year(now())#" index="i">
															<option value="#i#" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and year(rsExperiencia.RHEEfechaini) EQ i>selected</cfif>>#i#</option>
														</cfloop>
													</select>
												</td>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Retiro">Retiro</cf_translate>:</font></td>
												<td nowrap>
													<select name="mesFin" id="mesFin" style="font-size:10px;" tabindex="1">
														<option value="">(<cf_translate key="CMB_Mes" XmlFile="generales.xml">Mes</cf_translate>)</option>
														<option value="1" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="generales.xml">Enero</cf_translate></option>
														<option value="2" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="generales.xml">Febrero</cf_translate></option>
														<option value="3" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="generales.xml">Marzo</cf_translate></option>
														<option value="4" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="generales.xml">Abril</cf_translate></option>
														<option value="5" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="generales.xml">Mayo</cf_translate></option>
														<option value="6" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="generales.xml">Junio</cf_translate></option>
														<option value="7" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="generales.xml">Julio</cf_translate></option>
														<option value="8" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="generales.xml">Agosto</cf_translate></option>
														<option value="9" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="generales.xml">Septiembre</cf_translate></option>
														<option value="10" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="generales.xml">Octubre</cf_translate></option>
														<option value="11" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="generales.xml">Noviembre</cf_translate></option>
														<option value="12" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="generales.xml">Diciembre</cf_translate></option>
													</select>
													<select name="anoFin" id="anoFin" style="font-size:10px;" tabindex="1">
														<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
														<cfloop from="1965" to="#year(now())#" index="i">
															<option value="#i#" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and year(rsExperiencia.RHEEfechaini) EQ i>selected</cfif>>#i#</option>
														</cfloop>
													</select>	
												</td>
											</tr>
											<tr>
												<td  colspan="1" align="right" >
													<input style="font-size:10px;" tabindex="1" type="checkbox" name="Actualmente" value="" <cfif  isdefined("rsExperiencia.Actualmente") and rsExperiencia.Actualmente EQ 1>checked=""</cfif>>	
												</td>
												<td  colspan="1">
													<font  style="font-size:10px"><cf_translate key="LB_Trabaja_Actualmente">Trabaja Actualmente</cf_translate></font></td>
												</td>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Motivo">Motivo</cf_translate>:</font></td>
												<td nowrap>
													<select name="RHEEmotivo" id="RHEEmotivo" style="font-size:10px;" tabindex="1">
														<option value=""><cf_translate key="CMB_Ninguno" XmlFile="generales.xml">Ninguno</cf_translate></option>
														<option value="0" <cfif   isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 0>selected</cfif>><cf_translate key="CMB_Renuncia">Renuncia</cf_translate></option>
														<option value="10" <cfif  isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 10>selected</cfif>><cf_translate key="CMB_Despido">Despido</cf_translate></option>
														<option value="20" <cfif  isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 20>selected</cfif>><cf_translate key="CMB_FinDeContrato">Fin de Contrato</cf_translate></option>
														<option value="30" <cfif  isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 30>selected</cfif>><cf_translate key="CMB_FinDeProyecto">Fin de proyecto</cf_translate></option>
														<option value="40" <cfif  isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 40>selected</cfif>><cf_translate key="CMB_CierreOperaciones">Cierre operaciones</cf_translate></option>
														<option value="50" <cfif  isdefined("rsExperiencia.RHEEmotivo") and rsExperiencia.RHEEmotivo EQ 50>selected</cfif>><cf_translate key="CMB_Otros">Otros</cf_translate></option>
													</select>
												</td>
											</tr>
											<tr>
												<td  colspan="4">
													<font  style="font-size:10px"><cf_translate key="LB_funciones_y_Logros">funciones y Logros</cf_translate></font>
												</td>
											</tr>
											<tr>
												<td  colspan="4">
													<cfif  isdefined("rsExperiencia.RHEEfunclogros")>
														<cf_sifeditorhtml name="RHEEfunclogros" width="99%" height="215" tabindex="1" value="#trim(rsExperiencia.RHEEfunclogros)#"> 
													<cfelse>
														<cf_sifeditorhtml name="RHEEfunclogros" width="99%" height="215" tabindex="1">
													</cfif>
												</td>
											</tr>
											<tr>
												<td  colspan="4" align="center">
													<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
														<input type="button" class="btnGuardar" name="AgregarExperiencia" value="Modificar" onClick="javascript: return ADD_Experiencia();" />
														<input type="button" class="btnNuevo"   name="NuevoExperiencia"   value="Nuevo"     onClick="javascript: return NEW_Experiencia();" />
													<cfelse>
														<input type="button" class="btnGuardar" name="AgregarExperiencia" value="Agregar" onClick="javascript: return ADD_Experiencia();" />
													</cfif>	
												</td>
											</tr>
										</table>
									</td>
								</tr>	
							</table>	
						</fieldset>
					</td>
					<td valign="top">
						<fieldset><legend>#LB_Estudios_Realizados#</legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
											<table width="100%" border="0" cellpadding="1" cellspacing="1">
												<tr>
													<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Titulo">Titulo</cf_translate>:</font></td>
													<td colspan="3">
														<cfif isdefined("rsEducacion.RHOTid") and len(trim(rsEducacion.RHOTid))>
															&nbsp;<font  style="font-size:11px"><b>#rsEducacion.RHEtitulo#</b></font>
															<input type="hidden" name="RHOTid"  		id="RHOTid"  				value="#rsEducacion.RHOTid#">
															<input type="hidden" name="RHOTDescripcion"  id="RHOTDescripcion"  		value="#rsEducacion.RHEtitulo#">
														<cfelse>
															<input  
																name="RHOTDescripcion" 
																type="text" 
																id="RHOTDescripcion"  
																tabindex="1"
																style="font-size:10px;" 
																size="50" maxlength="60"
																value="">
														</cfif>
														<!--- <cfset ArrayTIT=ArrayNew(1)>
														<cfif  isdefined("rsEducacion.RHOTid") and len(trim(rsEducacion.RHOTid))>
															<cfset ArrayAppend(ArrayTIT,rsEducacion.RHOTid)>
															<cfset ArrayAppend(ArrayTIT,rsEducacion.RHEtitulo)>
														</cfif>
														<cf_conlisEXT
														Campos="RHOTid,RHOTDescripcion"
														Desplegables="N,S"
														Modificables="N,S"
														Size="0,50"
														tabindex="1"
														tamanoLetra="10"
														valuesArray="#ArrayTIT#" 
														Title="Lista de #LB_TituloObtenido#"
														Tabla="RHOTitulo"
														Columnas="RHOTid,RHOTDescripcion"
														Filtro=" CEcodigo = #Session.CEcodigo#"
														Desplegar="RHOTDescripcion"
														Etiquetas="#LB_TituloObtenido#"
														filtrar_por="RHOTDescripcion"
														Formatos="S"
														Align="left"
														Asignar="RHOTid,RHOTDescripcion"
														Asignarformatos="S,S"/> --->
													</td>
												</tr>
												<tr>
													<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate>:</font></td>
													<td colspan="3">
														<select name="RHIAid" id="RHIAid" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="CMB_Otra">Otra</cf_translate>)</option>
															<cfloop query="rsInstituciones">
																<option value="#rsInstituciones.RHIAid#" <cfif isdefined("rsEducacion.RHIAid")  and rsInstituciones.RHIAid EQ rsEducacion.RHIAid>selected</cfif>>#HTMLEditFormat(rsInstituciones.RHIAnombre)#</option>
															</cfloop>
														</select>
													</td>
												</tr>
												<tr>
													<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Otra_Institucion">Otra Instituci&oacute;n</cf_translate>:</font></td>
													<td colspan="3">
														<input 	type="text" 
																maxlength="60" 
																size="50" 
																name="RHEotrains" <cfif isdefined("rsEducacion.RHOTid") and len(trim(rsEducacion.RHIAid))>disabled</cfif>  
																value="<cfif isdefined("rsEducacion.RHEotrains") and len(trim(rsEducacion.RHEotrains))>#rsEducacion.RHEotrains#</cfif>"
																style="font-size:10px;" tabindex="1">
													</td>
												</tr>
												<tr>
													<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Ingreso">Ingreso</cf_translate>:</font></td>
													<td nowrap>
														<select name="mesIniE" id="mesIniE" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="CMB_Mes" XmlFile="generales.xml">Mes</cf_translate>)</option>
															<option value="1" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini)) and month(rsEducacion.RHEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="generales.xml">Enero</cf_translate></option>
															<option value="2" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="generales.xml">Febrero</cf_translate></option>
															<option value="3" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="generales.xml">Marzo</cf_translate></option>
															<option value="4" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="generales.xml">Abril</cf_translate></option>
															<option value="5" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="generales.xml">Mayo</cf_translate></option>
															<option value="6" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="generales.xml">Junio</cf_translate></option>
															<option value="7" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="generales.xml">Julio</cf_translate></option>
															<option value="8" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="generales.xml">Agosto</cf_translate></option>
															<option value="9" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="generales.xml">Septiembre</cf_translate></option>
															<option value="10" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini)) and month(rsEducacion.RHEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="generales.xml">Octubre</cf_translate></option>
															<option value="11" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="generales.xml">Noviembre</cf_translate></option>
															<option value="12" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="generales.xml">Diciembre</cf_translate></option>
														</select>
														<select name="anoIniE" id="anoIniE" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
															<cfloop from="1965" to="#year(now())#" index="i">
																<option value="#i#" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and year(rsEducacion.RHEfechaini) EQ i>selected</cfif>>#i#</option>
															</cfloop>
														</select>
													</td>
												</tr>
												<tr>	
													<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Finalizacion">Finalizaci&oacute;n</cf_translate>:</font></td>
													<td nowrap>
														<select name="mesFinE" id="mesFinE" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="CMB_Mes" XmlFile="generales.xml">Mes</cf_translate>)</option>
															<option value="1" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin)) and month(rsEducacion.RHEfechafin) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="generales.xml">Enero</cf_translate></option>
															<option value="2" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="generales.xml">Febrero</cf_translate></option>
															<option value="3" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="generales.xml">Marzo</cf_translate></option>
															<option value="4" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="generales.xml">Abril</cf_translate></option>
															<option value="5" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="generales.xml">Mayo</cf_translate></option>
															<option value="6" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="generales.xml">Junio</cf_translate></option>
															<option value="7" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="generales.xml">Julio</cf_translate></option>
															<option value="8" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="generales.xml">Agosto</cf_translate></option>
															<option value="9" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="generales.xml">Septiembre</cf_translate></option>
															<option value="10" <cfif isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin)) and month(rsEducacion.RHEfechafin) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="generales.xml">Octubre</cf_translate></option>
															<option value="11" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="generales.xml">Noviembre</cf_translate></option>
															<option value="12" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="generales.xml">Diciembre</cf_translate></option>
														</select>
														<select name="anoFinE" id="anoFinE" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
															<cfloop from="1965" to="#year(now())#" index="i">
																<option value="#i#" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and year(rsEducacion.RHEfechafin) EQ i>selected</cfif>>#i#</option>
															</cfloop>
														</select>	
													</td>
												</tr>
												<tr>
													<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nivel">Nivel</cf_translate>:</font></td>
													<td nowrap>
														<select name="GAcodigo" id="GAcodigo" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="CMB_SinDefinir">Sin definir</cf_translate>)</option>
															<cfloop query="rsGrados">
															  <option value="#rsGrados.GAcodigo#" <cfif isdefined("rsEducacion.GAcodigo") and rsGrados.GAcodigo EQ rsEducacion.GAcodigo>selected</cfif>>#HTMLEditFormat(rsGrados.GAnombre)#</option>
															</cfloop>
														</select>
													</td>
			
													<td align="right" nowrap="nowrap">	
														<input style="font-size:10px;" tabindex="1" type="checkbox" name="RHEsinterminar" <cfif isdefined("rsEducacion.RHEsinterminar") and rsEducacion.RHEsinterminar EQ 1>checked=""</cfif>>
													</td>
													<td nowrap="nowrap">
														<font  style="font-size:10px"><cf_translate key="LB_Sin_Terminar">Sin Terminar</cf_translate></font>
													</td>									
												</tr>
													<tr>
													<td  colspan="4">
														<font  style="font-size:10px"><cf_translate key="LB_Capacitacion_no_formal">Capacitaci&oacute;n no formal</cf_translate></font>
													</td>
												</tr>
												<tr>
													<td  colspan="4">
														<cfif  isdefined("rsEducacion.RHECapNoFormal") and len(trim(rsEducacion.RHECapNoFormal))>
															<cf_sifeditorhtml name="RHECapNoFormal" width="99%" height="150" tabindex="1" value="#trim(rsEducacion.RHECapNoFormal)#">
														<cfelse>
															<cf_sifeditorhtml name="RHECapNoFormal" width="99%" height="150" tabindex="1">
														</cfif>
													</td>
												</tr>	
												<tr>
													<td  colspan="4" align="center">
														<cfif isdefined("form.RHEElinea") and len(trim(form.RHEElinea))>
															<input type="button" class="btnGuardar" name="AgregarEstudios" value="Modificar" onClick="javascript: return ADD_Estudios();" />
															<input type="button" class="btnNuevo"   name="NuevoEstudios"   value="Nuevo"     onClick="javascript: return NEW_Estudios();" />
														<cfelse>
															<input type="button" class="btnGuardar" name="AgregarEstudios" value="Agregar" onClick="javascript: return ADD_Estudios();" />
														</cfif>	
													</td>
												</tr>
											</table>
									</td>
								</tr>	
							</table>	
						</fieldset>
					</td>
				</tr>
			</table>
		</tr>
		<tr>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<fieldset>
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_ExperienciaLaboral"
							Default="Experiencia laboral"
							returnvariable="LB_ExperienciaLaboral"/>
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_Actualmente"
							Default="Actualmente"
							returnvariable="LB_Actualmente"/>	
							
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_Eliminar_Registro"
							Default="Eliminar Registro"
							returnvariable="LB_Eliminar_Registro"/>	
						
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_Modificar_Registro"
							Default="Modificar Registro"
							returnvariable="LB_Modificar_Registro"/>		
						
						<cf_dbfunctionExt name="to_char" args="a.RHEEid" returnvariable="Lvar_to_char_RHEEid">
						<cfquery name="rsLista3" datasource="#session.DSN#">					
							select 	a.RHEEid,
									{fn concat(a.RHEEnombreemp,{fn concat(' - ',{fn concat(a.RHEEpuestodes,{fn concat(' - ',case <cf_dbfunctionExt name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> when '01/01/6100' then '#LB_Actualmente#'else <cf_dbfunctionExt name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> end)})})})} as descripcion_LAB,
								<cfif Application.dsinfo.type EQ 'sybase'>
									'<a href="javascript: EliminarEXP(''' + #Lvar_to_char_RHEEid# + ''',0);"><img  alt=''#LB_Eliminar_Registro#'' src=''/imagenes/Borrar01_S.gif'' border=''0''></a>'  as Eliminar,
									'<a href="javascript: ModificarEXP(''' + #Lvar_to_char_RHEEid# + ''',0);"><img alt=''#LB_Modificar_Registro#''src=''/imagenes/Template.gif'' border=''0''></a>' as Modificar
								<cfelseif Application.dsinfo.type EQ 'Oracle'>
									'<a href="javascript: EliminarEXP(''' || #Lvar_to_char_RHEEid# || ''',0);"><img  alt=''#LB_Eliminar_Registro#'' src=''/imagenes/Borrar01_S.gif'' border=''0''></a>'  as Eliminar,
									'<a href="javascript: ModificarEXP(''' || #Lvar_to_char_RHEEid# || ''',0);"><img alt=''#LB_Modificar_Registro#''src=''/imagenes/Template.gif'' border=''0''></a>' as Modificar
								</cfif>
								
							from RHExperienciaEmpleado a
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								<cfif isdefined("session.RHOid") and len(trim(session.RHOid))>
									and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
								<cfelse>
									and a.RHOid =  -1
								</cfif>
							Order by a.RHEEfecharetiro desc
						</cfquery>
						
						<cfinvoke 
						component="pListasEXT"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista3#"/>
							<cfinvokeargument name="desplegar" value="descripcion_LAB,Modificar,Eliminar"/>
							<cfinvokeargument name="etiquetas" value="#LB_ExperienciaLaboral#,&nbsp;,&nbsp;"/>
							<cfinvokeargument name="formatos" value="V,V,V"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="ajustar" value="S,S,S"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="RHEEid"/>
							<cfinvokeargument name="irA" value="curriculum-form.cfm"/>
							<cfinvokeargument name="incluyeForm" value="true"/>	
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="PageIndex" value="2"/>
						</cfinvoke>
						</fieldset>
					</td>
					<td valign="top" width="50%">
						<fieldset>
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_EstudiosRealizados"
							Default="Estudios Realizados"
							returnvariable="LB_EstudiosRealizados"/>
							
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_Eliminar_Registro"
							Default="Eliminar Registro"
							returnvariable="LB_Eliminar_Registro"/>	
						
						<cfinvoke component="Translate"
							method="Translate"
							Key="LB_Modificar_Registro"
							Default="Modificar Registro"
							returnvariable="LB_Modificar_Registro"/>	
							
							
						<cf_dbfunctionExt name="to_char" args="a.RHEElinea" returnvariable="Lvar_to_char_RHEElinea">

						<cfquery name="rsListaEDUC" datasource="#session.DSN#">
							select  a.RHEElinea,
									{fn concat(a.RHEtitulo,{fn concat(' - ',{fn concat(case  when a.RHEotrains is null then b.RHIAnombre else a.RHEotrains end,{fn concat(' - ',<cf_dbfunctionExt name="date_format" args="RHEfechafin,dd/mm/yyyy"> )})})})}
									as descripcion_EST,
									<cfif Application.dsinfo.type EQ 'sybase'>
										'<a href="javascript: EliminarEDU(''' + #Lvar_to_char_RHEElinea# + ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/imagenes/Borrar01_S.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEDU(''' + #Lvar_to_char_RHEElinea# + ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/imagenes/Template.gif'' border=''0''></a>' as Modificar
									<cfelseif Application.dsinfo.type EQ 'Oracle'>
										'<a href="javascript: EliminarEDU(''' || #Lvar_to_char_RHEElinea# || ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/imagenes/Borrar01_S.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEDU(''' || #Lvar_to_char_RHEElinea# || ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/imagenes/Template.gif'' border=''0''></a>' as Modificar
									</cfif>

							from RHEducacionEmpleado a
								left outer join RHInstitucionesA b
									on a.RHIAid= b.RHIAid
									and a.Ecodigo = b.Ecodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								<cfif isdefined("session.RHOid") and len(trim(session.RHOid))>
									and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">	
								<cfelse>
									and a.RHOid = -1	
								</cfif>								
							order by a.RHEfechafin desc
						</cfquery>
						<!--- <cfdump var="#rsListaEDUC#"> --->
						<cfinvoke 
							component="pListasEXT"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsListaEDUC#"/>
								<cfinvokeargument name="desplegar" value="descripcion_EST,Modificar,Eliminar"/>
								<cfinvokeargument name="etiquetas" value="#LB_EstudiosRealizados#,&nbsp;,&nbsp;"/>
								<cfinvokeargument name="formatos" value="V,V,V"/>
								<cfinvokeargument name="align" value="left,left,left"/>
								<cfinvokeargument name="ajustar" value="S,S,S"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="keys" value="RHEElinea"/>
								<cfinvokeargument name="irA" value="curriculum-form.cfm"/>
								<cfinvokeargument name="incluyeForm" value="true"/>	
								<cfinvokeargument name="PageIndex" value="3"/>
								<cfinvokeargument name="showLink" value="false"/>
							</cfinvoke>
						</fieldset>	
					</td>
				</tr>
			</table>
		</tr>
	</table>
</form>

<iframe 
	id="validor" 
	name="validor" 
	marginheight="0" 
	marginwidth="0" 
	frameborder="0" 
	height="0" 
	width="0" src="" 
	style="visibility:hidden">
</iframe>


</cfoutput>

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
	
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_TipoDeIdentificacion"
	Default="Tipo de Identificación"
	returnvariable="LB_TipoDeIdentificacion"/>
	
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	returnvariable="LB_Identificacion"/>	

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Fecha_de_Nacimiento"
	Default="Fecha de Nacimiento"
	returnvariable="LB_Fecha_de_Nacimiento"/>	

<cfinvoke component="Translate"
	method="Translate"
	Key="LB_Correo_Electronico"
	Default="Correo Electrónico"
	returnvariable="LB_Correo_Electronico"/>	
	
<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_PorFavorReviseLosSiguienteDatos"
	Default="Por favor revise los siguiente datos"	
	returnvariable="MSG_PorFavorReviseLosSiguienteDatos"/>	
<!--- *********************************************************** --->	
<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_En_el_area_de_Experiencia_laboral"
	Default="En el área de Experiencia laboral :"	
	returnvariable="MSG_En_el_area_de_Experiencia_laboral"/>	
	
<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_Telefono_de_la_Empresa"
	Default="Teléfono de la Empresa"	
	returnvariable="MSG_Telefono_de_la_Empresa"/>	

<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_Mes_de_incio"
	Default="Mes de inicio"	
	returnvariable="MSG_Mes_de_incio"/>

<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_anno_de_incio"
	Default="Año de inicio"	
	returnvariable="MSG_anno_de_incio"/>

<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_Mes_de_finalizacion"
	Default="Mes de finalización"	
	returnvariable="MSG_Mes_de_finalizacion"/>

<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_anno_de_finalizacion"
	Default="Año de finalización"	
	returnvariable="MSG_anno_de_finalizacion"/>	

<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_Nombre_de_la_empresa"
	Default="Nombre de la empresa"	
	returnvariable="MSG_Nombre_de_la_empresa"/>			
		
<!--- *********************************************************** --->	
<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_En_el_area_de_estudios_realizados"
	Default="En el área de estudios realizados :"	
	returnvariable="MSG_En_el_area_de_Educacion"/>	
		
<cfinvoke component="Translate"
	method="Translate"
	Key="MSG_debe_indicar_algun_tipo_de_instucion"
	Default="Deba indicar algún tipo de institución"	
	returnvariable="MSG_debe_indicar_algun_tipo_de_instucion"/>	
		
		
<script language="javascript" type="text/javascript">
	function validaCorreo(obj) {
		var RHOid		= document.form1.RHOid.value;
		var RHOemail	= obj.value;
		params = "?RHOid="+RHOid+"&RHOemail="+RHOemail;
		var frame = document.getElementById("validor");
		frame.src = "valida.cfm"+params;
	}
	function validaCedula(obj) {
		var RHOid				= document.form1.RHOid.value;
		var NTIcodigo			= document.form1.NTIcodigo.value;
		var RHOidentificacion	= obj.value;
		params = "?RHOid="+RHOid+"&RHOidentificacion="+RHOidentificacion+"&NTIcodigo="+NTIcodigo;
		var frame = document.getElementById("validor");
		frame.src = "valida.cfm"+params;
	}

	
	
	function ModificarEXP(valor){
		document.form1.RHEEid.value = valor;
		document.form1.AccionAEjecutar.value="ADD-MOD";
		document.form1.action='curriculum-form.cfm';
		document.form1.submit();
	}	
	
	function NEW_Experiencia(){
		document.form1.RHEEid.value = "";
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum-form.cfm';
		document.form1.submit();
	}

	function ModificarEDU(valor){
		document.form1.RHEElinea.value = valor;
		document.form1.AccionAEjecutar.value="ADD-MOD";
		document.form1.action='curriculum-form.cfm';
		document.form1.submit();
	}
	
	function NEW_Estudios(){
		document.form1.RHEElinea.value = "";
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum-form.cfm';
		document.form1.submit();
	}	
		
	<cfoutput>
	<!--- ************************************************************************* --->
	function funcValidaGeneral(){
		var error_msg = '';
		if(document.form1.RHOnombre .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Nombre#</cfoutput>.";
		}		
		if(document.form1.NTIcodigo.value == ''){
			 error_msg += "\n - <cfoutput>#LB_TipoDeIdentificacion#</cfoutput>.";
		}
		if(document.form1.RHOidentificacion .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Identificacion#</cfoutput>.";
		}
		if(document.form1.RHOfechanac.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Fecha_de_Nacimiento#</cfoutput>.";
		}
		if(document.form1.RHOemail.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Correo_Electronico#</cfoutput>.";
		}
		if(document.form1.RHEEnombreemp.value != ''){
			var addlinea = true;		
			
			if(document.form1.RHEEtelemp.value == ''){
				 if (addlinea){
				 	error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				 	addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_Telefono_de_la_Empresa#</cfoutput>.";
			}
			
			if(document.form1.mesIni.value == ''){
				 if (addlinea){
				 	error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				 	addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_Mes_de_incio#</cfoutput>.";
			}
			
			if(document.form1.anoIni.value == ''){
				 if (addlinea){
				 	error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				 	addlinea = false;
				 }		
				 error_msg += "\n - <cfoutput>#MSG_anno_de_incio#</cfoutput>.";
			}
			
			if (!document.form1.Actualmente.checked){
				if(document.form1.mesFin.value == ''){
					 if (addlinea){
						error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
						addlinea = false;
					 }	
					 error_msg += "\n - <cfoutput>#MSG_Mes_de_finalizacion#</cfoutput>.";
				}
				
				if(document.form1.anoFin.value == ''){
					 if (addlinea){
						error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
						addlinea = false;
					 }	
					 error_msg += "\n - <cfoutput>#MSG_anno_de_finalizacion#</cfoutput>.";
				}
			}
		
		}
		if(document.form1.RHIAid.value != '' || document.form1.RHEotrains.value != '' ){
			var addlinea = true;

			if(document.form1.mesIniE.value == ''){
				 if (addlinea){
				 	error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
				 	addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_Mes_de_incio#</cfoutput>.";
			}
			
			if(document.form1.anoIniE.value == ''){
				 if (addlinea){
				 	error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
				 	addlinea = false;
				 }		
				 error_msg += "\n - <cfoutput>#MSG_anno_de_incio#</cfoutput>.";
			}
			
			if (!document.form1.RHEsinterminar.checked){
				if(document.form1.mesFinE.value == ''){
					 if (addlinea){
						error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
						addlinea = false;
					 }	
					 error_msg += "\n - <cfoutput>#MSG_Mes_de_finalizacion#</cfoutput>.";
				}
				
				if(document.form1.anoFinE.value == ''){
					 if (addlinea){
						error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
						addlinea = false;
					 }	
					 error_msg += "\n - <cfoutput>#MSG_anno_de_finalizacion#</cfoutput>.";
				}
			}
		} 
		
		if (error_msg.length > 0) {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;
	
	}	
	<!--- ************************************************************************* --->
	function funcValidaEXp(){
	
			var error_msg = '';
		if(document.form1.RHOnombre .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Nombre#</cfoutput>.";
		}		
		if(document.form1.NTIcodigo.value == ''){
			 error_msg += "\n - <cfoutput>#LB_TipoDeIdentificacion#</cfoutput>.";
		}
		if(document.form1.RHOidentificacion .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Identificacion#</cfoutput>.";
		}
		if(document.form1.RHOfechanac.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Fecha_de_Nacimiento#</cfoutput>.";
		}
		if(document.form1.RHOemail.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Correo_Electronico#</cfoutput>.";
		}
		var addlinea = true;
		if(document.form1.RHEEnombreemp.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				addlinea = false;
			 }	
			 error_msg += "\n - <cfoutput>#MSG_Nombre_de_la_empresa#</cfoutput>.";
		}
					
		if(document.form1.RHEEtelemp.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				addlinea = false;
			 }	
			 error_msg += "\n - <cfoutput>#MSG_Telefono_de_la_Empresa#</cfoutput>.";
		}
		
		if(document.form1.mesIni.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				addlinea = false;
			 }	
			 error_msg += "\n - <cfoutput>#MSG_Mes_de_incio#</cfoutput>.";
		}
		
		if(document.form1.anoIni.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
				addlinea = false;
			 }		
			 error_msg += "\n - <cfoutput>#MSG_anno_de_incio#</cfoutput>.";
		}
		
		if (!document.form1.Actualmente.checked){
			if(document.form1.mesFin.value == ''){
				 if (addlinea){
					error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
					addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_Mes_de_finalizacion#</cfoutput>.";
			}
			
			if(document.form1.anoFin.value == ''){
				 if (addlinea){
					error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Experiencia_laboral#</cfoutput>";
					addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_anno_de_finalizacion#</cfoutput>.";
			}
		
		}
		
		if (error_msg.length > 0) {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;
	}	
	<!--- ************************************************************************* --->
	function funcValidaEDuc(){
		var error_msg = '';
		if(document.form1.RHOnombre .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Nombre#</cfoutput>.";
		}		
		if(document.form1.NTIcodigo.value == ''){
			 error_msg += "\n - <cfoutput>#LB_TipoDeIdentificacion#</cfoutput>.";
		}
		if(document.form1.RHOidentificacion .value == ''){
			 error_msg += "\n - <cfoutput>#LB_Identificacion#</cfoutput>.";
		}
		if(document.form1.RHOfechanac.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Fecha_de_Nacimiento#</cfoutput>.";
		}
		if(document.form1.RHOemail.value == ''){
			 error_msg += "\n - <cfoutput>#LB_Correo_Electronico#</cfoutput>.";
		}
		
		var addlinea = true;
		if(document.form1.RHIAid.value == '' && document.form1.RHEotrains.value == '' ){
			if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
				addlinea = false;
			 }	
			 error_msg += "\n - <cfoutput>#MSG_debe_indicar_algun_tipo_de_instucion#</cfoutput>.";
		}
		if(document.form1.mesIniE.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
				addlinea = false;
			 }	
			 error_msg += "\n - <cfoutput>#MSG_Mes_de_incio#</cfoutput>.";
		}
		
		if(document.form1.anoIniE.value == ''){
			 if (addlinea){
				error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
				addlinea = false;
			 }		
			 error_msg += "\n - <cfoutput>#MSG_anno_de_incio#</cfoutput>.";
		}
		
		if (!document.form1.RHEsinterminar.checked){
			if(document.form1.mesFinE.value == ''){
				 if (addlinea){
					error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
					addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_Mes_de_finalizacion#</cfoutput>.";
			}
			
			if(document.form1.anoFinE.value == ''){
				 if (addlinea){
					error_msg += "\n  <cfoutput>#MSG_En_el_area_de_Educacion#</cfoutput>";
					addlinea = false;
				 }	
				 error_msg += "\n - <cfoutput>#MSG_anno_de_finalizacion#</cfoutput>.";
			}
		}

		if (error_msg.length > 0) {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;
	}
	<!--- ************************************************************************* --->
	</cfoutput>
	function funcGuardar(){
		if(funcValidaGeneral()){
			document.form1.AccionAEjecutar.value='ADD-MOD';
			document.form1.submit();
		}
	}	
	function ADD_Experiencia(){
		if(funcValidaEXp()){
			document.form1.AccionAEjecutar.value='ADD-MOD';
			document.form1.submit();
		}
	}	
	function ADD_Estudios(){
		if(funcValidaEDuc()){
			document.form1.AccionAEjecutar.value='ADD-MOD';
			document.form1.submit();
		}
	}
	function EliminarEDU(llave){
		document.form1.AccionAEjecutar.value='DEL-EDUC';
		document.form1.RHEElinea.value=llave;
		document.form1.submit();
	}
	function EliminarEXP(llave){
		document.form1.AccionAEjecutar.value='DEL-EXP';
		document.form1.RHEEid.value=llave;
		document.form1.submit();
	}
	
</script>
