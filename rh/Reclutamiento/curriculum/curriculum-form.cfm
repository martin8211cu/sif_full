<style type="text/css">
	.otroIdioma select[name=RHOLengOral5] { margin-left: -41px; }
	.otroIdioma select[name=RHOLengEscr5] { margin-left: 28px; }
	.otroIdioma select[name=RHOLengLect5] { margin-left: 28px; }
</style>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Lugar" Default="Lugar" xmlFile="/rh/generales.xml" returnvariable="LB_Lugar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default="Tipo" xmlFile="/rh/generales.xml" returnvariable="LB_Tipo"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pertenece_A" Default="Pertenece a" xmlFile="/rh/generales.xml" returnvariable="LB_Pertenece_A"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivos" Default="Datos Adjuntos" xmlFile="/rh/generales.xml" returnvariable="LB_DatosAdjuntos"/>	


<cf_translatedata name="get" tabla="NTipoIdentificacion" col="NTIdescripcion" returnvariable="LvarNTIdescripcion"/>
<cfquery name="rsTipoIdent" datasource="#session.DSN#">
	select NTIcodigo, #LvarNTIdescripcion# as NTIdescripcion
	from NTipoIdentificacion
	where Ecodigo = #Session.Ecodigo#
	order by NTIdescripcion
</cfquery>
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsMonedaPRT" datasource="#session.DSN#">
	select Miso4217,Miso4217 as Mnombre  from Moneda
</cfquery>


<cf_dbfunction name="op_concat" returnvariable="_cat">
<cf_dbfunction name="sPart"		args="RHIAnombre,1,40" returnvariable="Lvar_RHIAnombre" >

<cfquery name="rsInstituciones" datasource="#session.DSN#">
	select RHIAid, (case when len(RHIAnombre) > 40 then #PreserveSingleQuotes(Lvar_RHIAnombre)# #_cat# '...'  else RHIAnombre end) as RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by RHIAnombre
</cfquery>

<cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
<cf_dbfunction name="length" args="#LvarGAnombre#" returnvariable="Lvar_GAnombreLen">
<cf_dbfunction name="sPart"		args="#LvarGAnombre#|1|25" returnvariable="Lvar_GAnombre" delimiters="|">
<cfquery name="rsGrados" datasource="#session.DSN#">
	select GAcodigo, 
	(case when #Lvar_GAnombreLen# > 30 then #PreserveSingleQuotes(Lvar_GAnombre)# #_cat# '...'  else #LvarGAnombre# end) as GAnombre 
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

<!--- llave del oferente --->

<cfif isdefined("url.RHOid") and len(trim(url.RHOid)) gt 0 and not isdefined("form.RHOid")  >
	<cfset form.RHOid = url.RHOid>
</cfif>

<!--- llave del educacion --->
<cfif isdefined("url.RHEElinea") and len(trim(url.RHEElinea)) gt 0 and not isdefined("form.RHEElinea")  >
	<cfset form.RHEElinea = url.RHEElinea>
</cfif>


<cfif isdefined("url.RHOElinea") and len(trim(url.RHOElinea)) gt 0 and not isdefined("form.RHOElinea")  >
	<cfset form.RHOElinea = url.RHOElinea>
</cfif> 
<!--- llave del experiencia --->
<cfif isdefined("url.RHEEid") and len(trim(url.RHEEid)) gt 0 and not isdefined("form.RHEEid")  >
	<cfset form.RHEEid = url.RHEEid>
</cfif>

	<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
	<cfquery name="rsIdiomas" datasource="#session.DSN#">
		select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
		from RHIdiomas
		order by #LvarRHDescripcion# asc
	</cfquery>
<!--- ***************** AREA DE CONSULTAS  EN MODO CAMBIO ***************** --->
<cfif isdefined("FORM.RHOid") and len(trim(FORM.RHOid))>
	<cfquery datasource="#session.DSN#" name="rsOferente">
		select a.RHOid, a.Ecodigo, a.NTIcodigo, a.RHOidentificacion, a.RHOnombre, a.RHOapellido1, a.RHOapellido2, a.RHOsexo, 
			a.RHOdireccion, a.RHOcivil, a.RHOtelefono1, a.RHOtelefono2, a.RHOemail, a.RHOfechanac, a.RHOobs1, a.RHOobs2, 
			a.RHOobs3, a.RHOdato1, a.RHOdato2, a.RHOdato3, a.RHOdato4, a.RHOdato5, a.RHOinfo1, a.RHOinfo2, a.RHOinfo3,
			b.NTIdescripcion, a.ts_rversion, a.Ppais, a.id_direccion, a.RHORefValida, a.RHOfechaRecep, a.RHOfechaIngr,
			a.RHOPrenteInf, a.RHOPrenteSup, a.RHOPosViajar, a.RHOPosTralado, a.RHOLengOral1, a.RHOLengOral2, a.RHOLengOral3,
			a.RHOLengOral4, a.RHOLengOral5, a.RHOLengEscr1, a.RHOLengEscr2, a.RHOLengEscr3, a.RHOLengEscr4, a.RHOLengEscr5,
			a.RHOLengLect1, a.RHOLengLect2, a.RHOLengLect3, a.RHOLengLect4, a.RHOLengLect5, a.RHOIdioma1, a.RHOIdioma2, 
			a.RHOIdioma3, a.RHOIdioma4, a.RHOOtroIdioma5, a.RHOMonedaPrt, a.RHOEntrevistado, a.RHOfechaEntrevista, 
			a.RHORealizadaPor
		from DatosOferentes a 
		  inner join NTipoIdentificacion b
		    on  a.NTIcodigo = b.NTIcodigo
			and b.Ecodigo = #Session.Ecodigo#
		where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>

	<cfif isdefined("FORM.RHEEid") and len(trim(FORM.RHEEid))>
		<cfquery name="rsExperiencia" datasource="#session.DSN#">
			select 	RHEEid, RHEEnombreemp, RHEEtelemp, RHOPid, RHEEfechaini, RHEEfecharetiro,
			Actualmente, RHEEfunclogros, ts_rversion, RHEEmotivo,RHEEpuestodes,RHEEAnnosLab
			from RHExperienciaEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		</cfquery>
	</cfif>
	
	<cfif isdefined("FORM.RHEElinea") and len(trim(FORM.RHEElinea))>
		<cfquery name="rsEducacion" datasource="#session.DSN#">		
			select 	RHEElinea, RHIAid, GAcodigo, RHEotrains, RHEtitulo,RHOTid,
					RHEfechaini, RHEfechafin, RHEsinterminar, ts_rversion,RHECapNoFormal,RHOEid
			from RHEducacionEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
				and RHEElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEElinea#">
		</cfquery>	
	</cfif>
	
	<cfif isdefined("FORM.RHOElinea") and len(trim(FORM.RHOElinea))>
		<cfquery name="rsObse" datasource="#session.DSN#">		
			select 	RHOElinea,DEid,RHOid,RHOEfecha,RHOEobservacion
			from RHObservacionesEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
				and RHOElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOElinea#">
		</cfquery>	
	</cfif>
</cfif>




<!--- ***************** AREA DE ETIQUETAS ***************** --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Datos_Generales"
	default="Datos Generales"
	returnvariable="LB_Datos_Generales"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Direccion"
	default="Direcci&oacute;n"
	returnvariable="LB_Direccion"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Otros"
	default="Otros"
	returnvariable="LB_Otros"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Experiencia_Laboral"
	default="Experiencia Laboral"
	returnvariable="LB_Experiencia_Laboral"/>		
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Estudios_Realizados"
	default="Estudios Realizados"
	returnvariable="LB_Estudios_Realizados"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_TituloObtenido"
	default="T&iacute;tulo obtenido"
	returnvariable="LB_TituloObtenido"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Agregar"
	default="Agregar"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Agregar"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nuevo"
	default="Nuevo"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Nuevo"/>	
		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Modificar"
	default="Modificar"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Modificar"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha"
	default="Fecha"
	returnvariable="LB_Fecha"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Observacion"
	default="Observación"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Observacion"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_SelectPorcentajeDominioIdioma"
	default="Debe indicar el porcentaje de dominio oral, escrito y lectura sobre los idiomas seleccionados"
	xmlFile="/rh/generales.xml"
	returnvariable="MSG_SelectPorcentajeDominioIdioma"/>


<!--- ***************** PINTADO ***************** --->
<cfoutput>
<form style="margin:0" name="form1" method="post" action="curriculum-sql.cfm" enctype="multipart/form-data" >
	<input type="hidden" name="RHOid"   			id="RHOid"       		value="<cfif isdefined("form.RHOid") >#form.RHOid#</cfif>">
	<input type="hidden" name="RHEElinea"   		id="RHEElinea"   		value="<cfif isdefined("form.RHEElinea") >#form.RHEElinea#</cfif>">
	<input type="hidden" name="RHOElinea"   		id="RHOElinea"   		value="<cfif isdefined("form.RHOElinea") >#form.RHOElinea#</cfif>">
	<input type="hidden" name="RHEEid"   			id="RHEEid"      		value="<cfif isdefined("form.RHEEid") >#form.RHEEid#</cfif>">
	<input type="hidden" name="AccionAEjecutar"   	id="AccionAEjecutar"    value="">

	<table width="100%" border="0">
		<tr>
			<td valign="top" bgcolor="##A0BAD3" colspan="2">
				<cfinclude template="frame-botones.cfm">
			</td>
		</tr>
		<tr>
			<td>
				<fieldset><legend>#LB_Datos_Generales#</legend>
					<table width="100%" border="0" cellpadding="1" cellspacing="1">
						<tr> 
							<cfif isdefined("FORM.RHOid") and len(trim(FORM.RHOid))>
								<td width="10%" align="center" valign="top" style="padding-left: 10px; padding-right: 10px;" rowspan="6"> 
									<table width="100%" border="1" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center">
											<cfinclude template="/rh/Reclutamiento/catalogos/frame-foto.cfm">
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
								<select name="NTIcodigo" id="select" style="font-size:10px" tabindex="1">
								<cfloop query="rsTipoIdent">
								  <option value="#rsTipoIdent.NTIcodigo#"  <cfif isdefined("rsOferente.NTIcodigo") and len(trim(rsOferente.NTIcodigo)) and rsOferente.NTIcodigo eq rsTipoIdent.NTIcodigo> selected </cfif>>
									#rsTipoIdent.NTIdescripcion#</option>
								</cfloop>
								</select>
							</td>
							<td align="right"><font  style="font-size:10px"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:</font></td>
							
							<td>
								<input name="RHOidentificacion" type="text" id="RHOidentificacion"  style="font-size:10px" tabindex="1"
								value="<cfif isdefined("rsOferente.RHOidentificacion") and len(trim(rsOferente.RHOidentificacion))>#rsOferente.RHOidentificacion#</cfif>" size="30" maxlength="60">
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
									<cf_sifcalendario form="form1" value="#LSDateFormat(rsOferente.RHOfechanac,"DD/MM/YYYY")#" name="RHOfechanac" tabindex="1">				   
								<cfelse>
									<cf_sifcalendario form="form1" value="" name="RHOfechanac" tabindex="1">				   
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
												onblur="javascript: fm(this,2);"  
												onfocus="javascript:this.value=qf(this); this.select();"  
												onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
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
												onblur="javascript: fm(this,2);"  
												onfocus="javascript:this.value=qf(this); this.select();"  
												onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
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
															<select class="sIdioma" name="RHOIdioma1" style="font-size:10px" tabindex="1" onchange="fnChangeIdioma(this)">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<cfloop query="rsIdiomas">
																	<option value="#RHIid#"	<cfif isdefined("rsOferente.RHOIdioma1") and rsOferente.RHOIdioma1 eq RHIid>selected</cfif> >#RHDescripcion#</option>
																</cfloop>					
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengOral1") and 105 EQ rsOferente.RHOLengOral1>selected</cfif>>Lengua materna</option>
								
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr1") and 105 EQ rsOferente.RHOLengEscr1>selected</cfif>>Lengua materna</option>
								
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengLect1") and 105 EQ rsOferente.RHOLengLect1>selected</cfif>>Lengua materna</option>
								
															</select>						
														</td>
													</tr>
													<tr> 
														<td>
															<select class="sIdioma" name="RHOIdioma2" style="font-size:10px" tabindex="1" onchange="fnChangeIdioma(this)">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<cfloop query="rsIdiomas">
																	<option value="#RHIid#"	<cfif isdefined("rsOferente.RHOIdioma2") and rsOferente.RHOIdioma2 eq RHIid>selected</cfif> >#RHDescripcion#</option>
																</cfloop>
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengOral2") and 105 EQ rsOferente.RHOLengOral2>selected</cfif>>Lengua materna</option>

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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr2") and 105 EQ rsOferente.RHOLengEscr2>selected</cfif>>Lengua materna</option>

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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengLect2") and 105 EQ rsOferente.RHOLengLect2>selected</cfif>>Lengua materna</option>

															</select>						
														</td>
													</tr>
								
													<tr> 
														<td height="18">
															<select class="sIdioma" name="RHOIdioma3" style="font-size:10px" tabindex="1" onchange="fnChangeIdioma(this)">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<cfloop query="rsIdiomas">
																	<option value="#RHIid#"	<cfif isdefined("rsOferente.RHOIdioma3") and rsOferente.RHOIdioma3 eq RHIid>selected</cfif> >#RHDescripcion#</option>
																</cfloop>
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengOral3") and 105 EQ rsOferente.RHOLengOral3>selected</cfif>>Lengua materna</option>
								
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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr3") and 105 EQ rsOferente.RHOLengEscr3>selected</cfif>>Lengua materna</option>

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
																<option value="105" <cfif   isdefined("rsOferente.RHOLengLect3") and 105 EQ rsOferente.RHOLengLect3>selected</cfif>>Lengua materna</option>
															</select>						
														</td>										
													</tr>

													<tr>
														<td height="18">
															<select class="sIdioma" name="RHOIdioma4" style="font-size:10px" tabindex="1" onchange="fnChangeIdioma(this)">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<cfloop query="rsIdiomas">
																	<option value="#RHIid#"	<cfif isdefined("rsOferente.RHOIdioma4") and rsOferente.RHOIdioma4 eq RHIid>selected</cfif> >#RHDescripcion#</option>
																</cfloop>
															</select>
														</td>	
														<td> 
															<select name="RHOLengOral4" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>	
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral4") and 10 EQ rsOferente.RHOLengOral4>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral4") and 20 EQ rsOferente.RHOLengOral4>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral4") and 30 EQ rsOferente.RHOLengOral4>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral4") and 40 EQ rsOferente.RHOLengOral4>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral4") and 50 EQ rsOferente.RHOLengOral4>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral4") and 60 EQ rsOferente.RHOLengOral4>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral4") and 70 EQ rsOferente.RHOLengOral4>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral4") and 80 EQ rsOferente.RHOLengOral4>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral4") and 90 EQ rsOferente.RHOLengOral4>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengOral4") and 100 EQ rsOferente.RHOLengOral4>selected</cfif>>100%</option>
																<option value="105" <cfif   isdefined("rsOferente.RHOLengOral4") and 105 EQ rsOferente.RHOLengOral4>selected</cfif>>Lengua materna</option>

															</select>						
														</td>
														<td>
															<select name="RHOLengEscr4" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 10 EQ rsOferente.RHOLengEscr4>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 20 EQ rsOferente.RHOLengEscr4>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 30 EQ rsOferente.RHOLengEscr4>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 40 EQ rsOferente.RHOLengEscr4>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 50 EQ rsOferente.RHOLengEscr4>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 60 EQ rsOferente.RHOLengEscr4>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 70 EQ rsOferente.RHOLengEscr4>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 80 EQ rsOferente.RHOLengEscr4>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr4") and 90 EQ rsOferente.RHOLengEscr4>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr4") and 100 EQ rsOferente.RHOLengEscr4>selected</cfif>>100%</option>
																<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr4") and 105 EQ rsOferente.RHOLengEscr4>selected</cfif>>Lengua materna</option>

															</select>						
														</td>
														<td>
															<select name="RHOLengLect4" style="font-size:10px" tabindex="1">
																<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
																<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect4") and 10 EQ rsOferente.RHOLengLect4>selected</cfif>>10%</option>
																<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect4") and 20 EQ rsOferente.RHOLengLect4>selected</cfif>>20%</option>
																<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect4") and 30 EQ rsOferente.RHOLengLect4>selected</cfif>>30%</option>
																<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect4") and 40 EQ rsOferente.RHOLengLect4>selected</cfif>>40%</option>
																<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect4") and 50 EQ rsOferente.RHOLengLect4>selected</cfif>>50%</option>
																<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect4") and 60 EQ rsOferente.RHOLengLect4>selected</cfif>>60%</option>
																<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect4") and 70 EQ rsOferente.RHOLengLect4>selected</cfif>>70%</option>
																<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect4") and 80 EQ rsOferente.RHOLengLect4>selected</cfif>>80%</option>
																<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect4") and 90 EQ rsOferente.RHOLengLect4>selected</cfif>>90%</option>
																<option value="100" <cfif   isdefined("rsOferente.RHOLengLect4") and 100 EQ rsOferente.RHOLengLect4>selected</cfif>>100%</option>
																<option value="105" <cfif   isdefined("rsOferente.RHOLengLect4") and 105 EQ rsOferente.RHOLengLect4>selected</cfif>>lengua materna</option>
															</select>						
														</td>										
													</tr>									
												</table>
											</fieldset>
										</td>
									</tr>	
									<tr>
										<td colspan="2">
											<input alt="0" style="font-size:10px" tabindex="1" name="RHIOtro" type="checkbox" id="RHIOtro" value="0" onclick="fnShowOtroIdioma()">
											<font style="font-size:10px"><cf_translate key="CHK_Otro">Otro</cf_translate></font>
											<cfset vRHOOtroIdioma5 = "" >
											<cfif isdefined("rsOferente.RHOOtroIdioma5") >
												<cfset vRHOOtroIdioma5 = rsOferente.RHOOtroIdioma5 >
											</cfif> 
											<input class="otroIdioma sIdioma" type="text" name="RHOOtroIdioma5" maxlength="80" size="10" value="#vRHOOtroIdioma5#"<cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>>
										</td>
										<td colspan="4" class="otroIdioma"<cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>>
											<select name="RHOLengOral5" style="font-size:10px" tabindex="1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   isdefined("rsOferente.RHOLengOral5") and 10 EQ rsOferente.RHOLengOral5>selected</cfif>>10%</option>
												<option value="20"  <cfif   isdefined("rsOferente.RHOLengOral5") and 20 EQ rsOferente.RHOLengOral5>selected</cfif>>20%</option>
												<option value="30"  <cfif   isdefined("rsOferente.RHOLengOral5") and 30 EQ rsOferente.RHOLengOral5>selected</cfif>>30%</option>
												<option value="40"  <cfif   isdefined("rsOferente.RHOLengOral5") and 40 EQ rsOferente.RHOLengOral5>selected</cfif>>40%</option>
												<option value="50"  <cfif   isdefined("rsOferente.RHOLengOral5") and 50 EQ rsOferente.RHOLengOral5>selected</cfif>>50%</option>
												<option value="60"  <cfif   isdefined("rsOferente.RHOLengOral5") and 60 EQ rsOferente.RHOLengOral5>selected</cfif>>60%</option>
												<option value="70"  <cfif   isdefined("rsOferente.RHOLengOral5") and 70 EQ rsOferente.RHOLengOral5>selected</cfif>>70%</option>
												<option value="80"  <cfif   isdefined("rsOferente.RHOLengOral5") and 80 EQ rsOferente.RHOLengOral5>selected</cfif>>80%</option>
												<option value="90"  <cfif   isdefined("rsOferente.RHOLengOral5") and 90 EQ rsOferente.RHOLengOral5>selected</cfif>>90%</option>
												<option value="100" <cfif   isdefined("rsOferente.RHOLengOral5") and 100 EQ rsOferente.RHOLengOral5>selected</cfif>>100%</option>
												<option value="105" <cfif   isdefined("rsOferente.RHOLengOral5") and 105 EQ rsOferente.RHOLengOral5>selected</cfif>>Lengua materna</option>

											</select>

											<select name="RHOLengEscr5" style="font-size:10px" tabindex="1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 10 EQ rsOferente.RHOLengEscr5>selected</cfif>>10%</option>
												<option value="20"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 20 EQ rsOferente.RHOLengEscr5>selected</cfif>>20%</option>
												<option value="30"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 30 EQ rsOferente.RHOLengEscr5>selected</cfif>>30%</option>
												<option value="40"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 40 EQ rsOferente.RHOLengEscr5>selected</cfif>>40%</option>
												<option value="50"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 50 EQ rsOferente.RHOLengEscr5>selected</cfif>>50%</option>
												<option value="60"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 60 EQ rsOferente.RHOLengEscr5>selected</cfif>>60%</option>
												<option value="70"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 70 EQ rsOferente.RHOLengEscr5>selected</cfif>>70%</option>
												<option value="80"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 80 EQ rsOferente.RHOLengEscr5>selected</cfif>>80%</option>
												<option value="90"  <cfif   isdefined("rsOferente.RHOLengEscr5") and 90 EQ rsOferente.RHOLengEscr5>selected</cfif>>90%</option>
												<option value="100" <cfif   isdefined("rsOferente.RHOLengEscr5") and 100 EQ rsOferente.RHOLengEscr5>selected</cfif>>100%</option>
												<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr5") and 105 EQ rsOferente.RHOLengEscr5>selected</cfif>>Lengua materna</option>

											</select>

											<select name="RHOLengLect5" style="font-size:10px" tabindex="1">
												<option value=""><cf_translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_translate></option>
												<option value="10"  <cfif   isdefined("rsOferente.RHOLengLect5") and 10 EQ rsOferente.RHOLengLect5>selected</cfif>>10%</option>
												<option value="20"  <cfif   isdefined("rsOferente.RHOLengLect5") and 20 EQ rsOferente.RHOLengLect5>selected</cfif>>20%</option>
												<option value="30"  <cfif   isdefined("rsOferente.RHOLengLect5") and 30 EQ rsOferente.RHOLengLect5>selected</cfif>>30%</option>
												<option value="40"  <cfif   isdefined("rsOferente.RHOLengLect5") and 40 EQ rsOferente.RHOLengLect5>selected</cfif>>40%</option>
												<option value="50"  <cfif   isdefined("rsOferente.RHOLengLect5") and 50 EQ rsOferente.RHOLengLect5>selected</cfif>>50%</option>
												<option value="60"  <cfif   isdefined("rsOferente.RHOLengLect5") and 60 EQ rsOferente.RHOLengLect5>selected</cfif>>60%</option>
												<option value="70"  <cfif   isdefined("rsOferente.RHOLengLect5") and 70 EQ rsOferente.RHOLengLect5>selected</cfif>>70%</option>
												<option value="80"  <cfif   isdefined("rsOferente.RHOLengLect5") and 80 EQ rsOferente.RHOLengLect5>selected</cfif>>80%</option>
												<option value="90"  <cfif   isdefined("rsOferente.RHOLengLect5") and 90 EQ rsOferente.RHOLengLect5>selected</cfif>>90%</option>
												<option value="100" <cfif   isdefined("rsOferente.RHOLengLect5") and 100 EQ rsOferente.RHOLengLect5>selected</cfif>>100%</option>
												<option value="105" <cfif   isdefined("rsOferente.RHOLengLect5") and 105 EQ rsOferente.RHOLengLect5>selected</cfif>>Lengua materna</option>

											</select>
										</td>	
									</tr>
									<tr>
										<td colspan="2" valign="top">
											<input <cfif isdefined("rsOferente.RHOPosViajar") and rsOferente.RHOPosViajar EQ 1>checked</cfif> alt="0" style="font-size:10px" tabindex="1" name="RHOPosViajar" type="checkbox" id="RHOPosViajar" value="0" >
											<font  style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></font>
										</td>
										<td colspan="4">
											<input <cfif isdefined("rsOferente.RHOPosTralado") and rsOferente.RHOPosTralado EQ 1>checked</cfif> alt="0" style="font-size:10px" tabindex="1" name="RHOPosTralado" type="checkbox" id="RHOPosTralado" value="0" >
											<font  style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></font>
										</td>
										<td valign="top"><font  style="font-size:10px"><cf_translate key="LB_ZonasDePreferencia">Zonas de preferencia</cf_translate></font>
										<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="LB_ListaDeLugares"
												Default="Lista de Lugares"
												returnvariable="LB_ListaDeLugares"/>	
											<cfset listaIDs1=''>
											<cfif isdefined("FORM.RHOid") and len(trim(FORM.RHOid))>
												<cfquery datasource="#session.dsn#" name="rsLugares">
													select UGid
													from RHOferentesLugares
													where RHOid  = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#FORM.RHOid#">
														and RHOLtipo = 0
												</cfquery>
												<cfif len(trim(rsLugares.UGid))>
													<cfset listaIDs1=valueList(rsLugares.UGid)>	
												</cfif>
											</cfif>
											<cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="UGdescripcion" returnvariable="LvarUGdescripcion"> 
												<cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="x.UGdescripcion" returnvariable="LvarUGdescripcionX"> 
											<cf_translatedata name="get" tabla="AreaGeografica" conexion="asp" col="b.AGdescripcion" returnvariable="LvarAGdescripcion">
											<cf_dbfunction name="length" args="UGpath" returnvariable="LvarUGpath">
											<cf_conlis
											Campos="UGid,AGdescripcion,pertenece,UGdescripcion"
											Desplegables="N,N,N,S"
											Modificables="N,S,S,S"
											Size="0,25,20,20"
											tabindex="1" 
											Title="#LB_ListaDeLugares#"
											Tabla="UnidadGeografica a
													inner join AreaGeografica b
														on a.AGid=b.AGid
														and b.AGesconsultable = 1"
											Columnas="a.UGid,UGcodigo,#LvarAGdescripcion# as AGdescripcion,a.UGid as UGid2,UGcodigo,#LvarUGdescripcion# as UGdescripcion, (select x.UGdescripcion from UnidadGeografica x where x.UGid = a.UGidpadre) as pertenece"
											Desplegar="AGdescripcion,pertenece,UGdescripcion"
											Etiquetas="#LB_Tipo#,#LB_Pertenece_A#,#LB_Lugar#"
											filtro=" 1=1 order by #LvarUGpath#"
											filtrar_por="#LvarAGdescripcion#|(select #LvarUGdescripcionX# from UnidadGeografica x where x.UGid = a.UGidpadre)|#LvarUGdescripcion#"
											filtrar_por_delimiters="|"
											conexion="asp"
											Formatos="S,S,S,S"
											Align="left,left,left,left"
											Asignar="UGid,UGid,UGid,UGdescripcion"
											agregarEnLista="true" 
											ListaIdDefault="#listaIDs1#"
											Asignarformatos="X,S,S,S"
											/>
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
					<td valign="top"  width="40%">
						<fieldset><legend>#LB_Experiencia_Laboral#</legend>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
										<table width="100%" border="0" cellpadding="1" cellspacing="1"  height="280">
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
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Profesion">Profesi&oacute;n u Oficio</cf_translate>:</font></td>
												<td>
													<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													key="LB_Profesion_u_oficio"
													default="Profesi&oacute;n u oficio"
													returnvariable="LB_Puesto"/>
															<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													key="LB_ListaDePuestos"
													default="Lista de Puestos"
													returnvariable="LB_ListaDePuestos"/>
													<cfset ArrayOFIC=ArrayNew(1)>
													<cfif isdefined("rsExperiencia.RHOPid") and len(trim(rsExperiencia.RHOPid))>
														<cfset ArrayAppend(ArrayOFIC,rsExperiencia.RHOPid)>
														<cfset ArrayAppend(ArrayOFIC,rsExperiencia.RHEEpuestodes)>
													</cfif>
													
													
													<cf_conlis
													Campos="RHOPid,RHOPDescripcion"
													tamanoLetra="10"
													Desplegables="N,S"
													Modificables="N,N"
													Size="0,25"
													tabindex="1"
													form="form1"
													valuesArray="#ArrayOFIC#" 
													Title="#LB_ListaDePuestos#"
													Tabla="RHOPuesto"
													Columnas="RHOPid,RHOPDescripcion"
													Filtro=" CEcodigo = #Session.CEcodigo#"
													Desplegar="RHOPDescripcion"
													Etiquetas="#LB_Puesto#"
													filtrar_por="RHOPDescripcion"
													Formatos="S"
													Align="left"
													Asignar="RHOPid,RHOPDescripcion"
													Asignarformatos="S,S"/>
												</td>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Annos">A&ntilde;os</cf_translate>:</font></td>
												<td>
													<input 
														name="RHEEAnnosLab" 
														type="text" 
														id="RHEEAnnosLab"  
														tabindex="1"
														style="text-align: right;font-size:10px;" 
														onblur="javascript: fm(this,2);"  
														onfocus="javascript:this.value=qf(this); this.select();"  
														onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
														value="<cfif isdefined("rsExperiencia.RHEEAnnosLab") and len(trim(rsExperiencia.RHEEAnnosLab))>#rsExperiencia.RHEEAnnosLab#</cfif>">
												</td>
											</tr>
											<tr>
												<td align="right" nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Ingreso">Ingreso</cf_translate>:</font></td>
												<td nowrap>
													<select name="mesIni" id="mesIni" style="font-size:10px;" tabindex="1">
														<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
														<option value="1" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
														<option value="2" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
														<option value="3" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
														<option value="4" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
														<option value="5" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
														<option value="6" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
														<option value="7" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
														<option value="8" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
														<option value="9" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
														<option value="10" <cfif isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
														<option value="11" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
														<option value="12" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
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
														<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
														<option value="1" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
														<option value="2" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
														<option value="3" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
														<option value="4" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
														<option value="5" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
														<option value="6" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
														<option value="7" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
														<option value="8" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
														<option value="9" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
														<option value="10" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini)) and month(rsExperiencia.RHEEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
														<option value="11" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
														<option value="12" <cfif  isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))and month(rsExperiencia.RHEEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
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
														<option value=""><cf_translate key="CMB_Ninguno" XmlFile="/rh/generales.xml">Ninguno</cf_translate></option>
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
													<cfif  isdefined("rsExperiencia.RHEEfunclogros") and len(trim(rsExperiencia.RHEEfunclogros))>
														<cf_sifeditorhtml name="RHEEfunclogros" width="99%" height="100" tabindex="1" value="#trim(rsExperiencia.RHEEfunclogros)#">
													<cfelse>
														<cf_sifeditorhtml name="RHEEfunclogros" width="99%" height="100" tabindex="1">
													</cfif>
												</td>
											</tr>
											<tr>
												<td  colspan="4" align="center">
													<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
														<input type="button" class="btnGuardar" name="AgregarExperiencia" value="#LB_Modificar#" onclick="javascript: return ADD_Experiencia();" />
														<input type="button" class="btnNuevo"   name="NuevoExperiencia"   value="#LB_Nuevo#"     onclick="javascript: return NEW_Experiencia();" />
													<cfelse>
														<input type="button" class="btnGuardar" name="AgregarExperiencia" value="#LB_Agregar#" onclick="javascript: return ADD_Experiencia();" />
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
														<cfset ArrayTIT=ArrayNew(1)>
														<cfif  isdefined("rsEducacion.RHOTid") and len(trim(rsEducacion.RHOTid))>
															<cfset ArrayAppend(ArrayTIT,rsEducacion.RHOTid)>
															<cfset ArrayAppend(ArrayTIT,rsEducacion.RHEtitulo)>
														</cfif>
                                                        <cfinvoke component="sif.Componentes.Translate"
                                                        method="Translate"
                                                        Key="LB_ListaDeTituloObtenidos"
                                                        Default="Lista de Títulos Obtenidos"
                                                        returnvariable="LB_ListaDeTituloObtenidos"/>
														<cf_conlis
														Campos="RHOTid,RHOTDescripcion"
														Desplegables="N,S"
														Modificables="N,S"
														Size="0,50"
														tabindex="1"
														tamanoLetra="10"
														valuesArray="#ArrayTIT#" 
														Title="#LB_ListaDeTituloObtenidos#"
														Tabla="RHOTitulo"
														Columnas="RHOTid,RHOTDescripcion"
														Filtro=" CEcodigo = #Session.CEcodigo#"
														Desplegar="RHOTDescripcion"
														Etiquetas="#LB_TituloObtenido#"
														filtrar_por="RHOTDescripcion"
														Formatos="S"
														Align="left"
														Asignar="RHOTid,RHOTDescripcion"
														Asignarformatos="S,S"/>
													</td>
												</tr>
												<tr>
													<td align="right" nowrap="nowrap">
														<font  style="font-size:10px"><cf_translate key="LB_Enfasis">Enfasis</cf_translate>:</font>
													</td>
														<cf_translatedata tabla="RHOEnfasis" col="RHOEDescripcion" name="get" returnvariable="LvarRHOEDescripcion"/>
														<cfquery name="rsEnfasis" datasource="#session.dsn#">
															select RHOEid,#LvarRHOEDescripcion# as RHOEDescripcion 
															from RHOEnfasis
															where CEcodigo=#session.CEcodigo#
														</cfquery>
													<td>
														<select name="RHOEid" id="RHOEid" style="font-size:10px;" tabindex="1">
															<option value="">(<cf_translate key="CMB_SinDefinir">Sin definir</cf_translate>)</option>
															<cfloop query="rsEnfasis">
															  <option value="#rsEnfasis.RHOEid#" <cfif isdefined("rsEducacion.RHOEid") and rsEnfasis.RHOEid EQ rsEducacion.RHOEid>selected</cfif>>#HTMLEditFormat(rsEnfasis.RHOEDescripcion)#</option>
															</cfloop>
														</select>
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
															<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
															<option value="1" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini)) and month(rsEducacion.RHEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
															<option value="2" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
															<option value="3" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
															<option value="4" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
															<option value="5" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
															<option value="6" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
															<option value="7" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
															<option value="8" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
															<option value="9" <cfif  isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
															<option value="10" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini)) and month(rsEducacion.RHEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
															<option value="11" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
															<option value="12" <cfif isdefined("rsEducacion.RHEfechaini") and len(trim(rsEducacion.RHEfechaini))and month(rsEducacion.RHEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
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
															<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
															<option value="1" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin)) and month(rsEducacion.RHEfechafin) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
															<option value="2" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
															<option value="3" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
															<option value="4" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
															<option value="5" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
															<option value="6" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
															<option value="7" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
															<option value="8" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
															<option value="9" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
															<option value="10" <cfif isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin)) and month(rsEducacion.RHEfechafin) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
															<option value="11" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
															<option value="12" <cfif  isdefined("rsEducacion.RHEfechafin") and len(trim(rsEducacion.RHEfechafin))and month(rsEducacion.RHEfechafin) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
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
															<cf_sifeditorhtml name="RHECapNoFormal" width="99%" height="100" tabindex="1" value="#trim(rsEducacion.RHECapNoFormal)#">
														<cfelse>
															<cf_sifeditorhtml name="RHECapNoFormal" width="99%" height="100" tabindex="1">
														</cfif>
													</td>
												</tr>	
												<tr>
													<td  colspan="4" align="center">
														<cfif isdefined("form.RHEElinea") and len(trim(form.RHEElinea))>
															<input type="button" class="btnGuardar" name="AgregarEstudios" value="#LB_Modificar#" onclick="javascript: return ADD_Estudios();" />
															<input type="button" class="btnNuevo"   name="NuevoEstudios"   value="#LB_Nuevo#"     onclick="javascript: return NEW_Estudios();" />
														<cfelse>
															<input type="button" class="btnGuardar" name="AgregarEstudios" value="#LB_Agregar#" onclick="javascript: return ADD_Estudios();" />
														</cfif>	
													</td>
												</tr>
												<tr>
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
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_ExperienciaLaboral"
								default="Experiencia laboral"
								returnvariable="LB_ExperienciaLaboral"/>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_Actualmente"
								default="Actualmente"
								returnvariable="LB_Actualmente"/>	
								
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_Eliminar_Registro"
								default="Eliminar Registro"
								returnvariable="LB_Eliminar_Registro"/>	
							
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_Modificar_Registro"
								default="Modificar Registro"
								returnvariable="LB_Modificar_Registro"/>		
						
						<cf_dbfunction name="to_char" args="a.RHEEid" returnvariable="Lvar_to_char_RHEEid">
						
						<cfquery name="rsLista3" datasource="#session.DSN#">					
							select 	a.RHEEid,
									{fn concat(a.RHEEnombreemp,{fn concat(' - ',{fn concat(a.RHEEpuestodes,{fn concat(' - ',case <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> when '01/01/6100' then '#LB_Actualmente#'else <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> end)})})})} as descripcion_LAB,
									<cfif #session.dsinfo.type# EQ 'Oracle'>
										'<a href="javascript: EliminarEXP(''' || #Lvar_to_char_RHEEid# || ''',0);"><img  alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEXP(''' || #Lvar_to_char_RHEEid# || ''',0);"><img alt=''#LB_Modificar_Registro#''src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									<cfelseif #session.dsinfo.type# EQ 'sybase' or #session.dsinfo.type# EQ 'sqlserver'>
										'<a href="javascript: EliminarEXP(''' + #Lvar_to_char_RHEEid# + ''',0);"><img  alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEXP(''' + #Lvar_to_char_RHEEid# + ''',0);"><img alt=''#LB_Modificar_Registro#''src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									</cfif>
							from RHExperienciaEmpleado a
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
									and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
								<cfelse>
									and a.RHOid =  -1
								</cfif>
							Order by a.RHEEfecharetiro desc
						</cfquery>
						
					
							<cfinvoke 
							component="rh.Componentes.pListas"
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
							<cfinvokeargument name="irA" value="curriculum.cfm"/>
							<cfinvokeargument name="incluyeForm" value="false"/>	
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							</cfinvoke>
						</fieldset>
					</td>
					<td valign="top" width="50%">
						<fieldset>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_EstudiosRealizados"
							default="Estudios Realizados"
							returnvariable="LB_EstudiosRealizados"/>
							
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_Eliminar_Registro"
							default="Eliminar Registro"
							returnvariable="LB_Eliminar_Registro"/>	
						
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_Modificar_Registro"
							default="Modificar Registro"
							returnvariable="LB_Modificar_Registro"/>	
							
							
						<cf_dbfunction name="to_char" args="a.RHEElinea" returnvariable="Lvar_to_char_RHEElinea">

						<cfquery name="rsListaEDUC" datasource="#session.DSN#">
							select  a.RHEElinea,
									{fn concat(a.RHEtitulo,{fn concat(' - ',{fn concat(case  when a.RHEotrains is null then b.RHIAnombre else a.RHEotrains end,{fn concat(' - ',<cf_dbfunction name="date_format" args="RHEfechafin,dd/mm/yyyy"> )})})})}
									as descripcion_EST,
									
									<cfif #session.dsinfo.type# EQ 'Oracle'>
										'<a href="javascript: EliminarEDU(''' || #Lvar_to_char_RHEElinea# || ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEDU(''' || #Lvar_to_char_RHEElinea# || ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									<cfelseif #session.dsinfo.type# EQ 'sybase' or #session.dsinfo.type# EQ 'sqlserver'>
										'<a href="javascript: EliminarEDU(''' + #Lvar_to_char_RHEElinea# + ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarEDU(''' + #Lvar_to_char_RHEElinea# + ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									</cfif>
							from RHEducacionEmpleado a
								left outer join RHInstitucionesA b
									on a.RHIAid= b.RHIAid
									and a.Ecodigo = b.Ecodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
									and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
								<cfelse>
									and a.RHOid = -1	
								</cfif>								
							order by a.RHEfechafin desc
						</cfquery>
						<!--- <cfdump var="#rsListaEDUC#"> --->
						<cfinvoke 
							component="rh.Componentes.pListas"
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
								<cfinvokeargument name="irA" value="curriculum.cfm"/>
								<cfinvokeargument name="incluyeForm" value="false"/>	
								<cfinvokeargument name="PageIndex" value="3"/>
								<cfinvokeargument name="showLink" value="false"/>
							</cfinvoke>
						</fieldset>	
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="ListaPar" colspan="2"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate></strong></td>
				</tr>
				<tr>
					<td>#LB_Fecha#:
						<cfif isdefined('rsObse') and len(trim(rsObse.RHOEfecha)) gt 0>
							<cfset fecha=LSDateFormat(rsObse.RHOEfecha,'DD/MM/YYYY')>
						<cfelse>
							<cfset fecha=LSDateFormat(Now(),'DD/MM/YYYY')>
						</cfif>
						<cf_sifcalendario form="form1" value="#fecha#" name="fechaObs" tabindex="1">
					</td>
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						<td>
							<cf_dbfunction name="to_char" args="RHOElinea" returnvariable="Lvar_to_char_RHOElinea">
								<cfquery name="rsObs" datasource="#session.dsn#">
									select RHOEfecha,RHOEobservacion ,RHOElinea,
									<cfif #session.dsinfo.type# EQ 'Oracle'>
										'<a href="javascript: EliminarOBS(''' || #Lvar_to_char_RHOElinea# || ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarOBS(''' || #Lvar_to_char_RHOElinea# || ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									<cfelseif #session.dsinfo.type# EQ 'sybase' or #session.dsinfo.type# EQ 'sqlserver'>
										'<a href="javascript: EliminarOBS(''' + #Lvar_to_char_RHOElinea# + ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/borrar01_s.gif'' border=''0''></a>'  as Eliminar,
										'<a href="javascript: ModificarOBS(''' + #Lvar_to_char_RHOElinea# + ''',0);"><img alt=''#LB_Modificar_Registro#'' src=''/cfmx/rh/imagenes/template.gif'' border=''0''></a>' as Modificar
									</cfif>
									from RHObservacionesEmpleado
									where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
								</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsObs#"/>
										<cfinvokeargument name="desplegar" value="RHOEfecha,RHOEobservacion,Modificar,Eliminar"/>
										<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Observacion#,&nbsp;,&nbsp;"/>
										<cfinvokeargument name="formatos" value="D,S,V,V"/>
										<cfinvokeargument name="align" value="left,left,left,left"/>
										<cfinvokeargument name="ajustar" value="S,S,S,S"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="keys" value="RHOElinea"/>
										<cfinvokeargument name="irA" value="curriculum.cfm"/>
										<cfinvokeargument name="incluyeForm" value="false"/>	
										<cfinvokeargument name="PageIndex" value="4"/>
										<cfinvokeargument name="showLink" value="false"/>
									</cfinvoke>
						</td>			
					</cfif>
				</tr>
				<tr>
					<td><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</td>
				</tr>
				<tr>
					<td colspan="1">
						<cfif isdefined('rsObse') and len(trim(rsObse.RHOEobservacion)) gt 0>
							<input type="text" name="obs" size="50" value="#rsObse.RHOEobservacion#" />
						<cfelse>
							<input type="text" name="obs" size="50" />
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="1" align="center"><input type="button" class="btnGuardar" name="AgregaObs" value="#LB_Agregar#" onclick="javascript: return ADD_Observaciones();"  /></td>
				</tr>	
			</table>
		</tr>
	</table>
	<cfif isDefined('form.RHOid')>
		<div class="col-md-6">
	      <div class="well">
	      	<label>#LB_DatosAdjuntos#</label>
	          <div class="form-group">
	              <cf_jupload tabla="DatosOferentesArchivos" campo="DOAfile" nombre="DOAnombre" pk="DOAid" fk="RHOid" fkvalor="#form.RHOid#" readonly="true">
	          </div>  
	      </div>				  
		</div>
	</cfif>

</form>
</cfoutput>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Nombre"
	default="Nombre"
	returnvariable="LB_Nombre"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_TipoDeIdentificacion"
	default="Tipo de Identificación"
	returnvariable="LB_TipoDeIdentificacion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Identificacion"
	default="Identificación"
	returnvariable="LB_Identificacion"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha_de_Nacimiento"
	default="Fecha de Nacimiento"
	returnvariable="LB_Fecha_de_Nacimiento"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Correo_Electronico"
	default="Correo Electrónico"
	returnvariable="LB_Correo_Electronico"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_PorFavorReviseLosSiguienteDatos"
	default="Por favor revise los siguiente datos"	
	returnvariable="MSG_PorFavorReviseLosSiguienteDatos"/>	
<!--- *********************************************************** --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_En_el_area_de_Experiencia_laboral"
	default="En el área de Experiencia laboral :"	
	returnvariable="MSG_En_el_area_de_Experiencia_laboral"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Telefono_de_la_Empresa"
	default="Teléfono de la Empresa"	
	returnvariable="MSG_Telefono_de_la_Empresa"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Mes_de_incio"
	default="Mes de inicio"	
	returnvariable="MSG_Mes_de_incio"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_anno_de_incio"
	default="Año de inicio"	
	returnvariable="MSG_anno_de_incio"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Mes_de_finalizacion"
	default="Mes de finalización"	
	returnvariable="MSG_Mes_de_finalizacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_anno_de_finalizacion"
	default="Año de finalización"	
	returnvariable="MSG_anno_de_finalizacion"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Nombre_de_la_empresa"
	default="Nombre de la empresa"	
	returnvariable="MSG_Nombre_de_la_empresa"/>			
		
<!--- *********************************************************** --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_En_el_area_de_estudios_realizados"
	default="En el área de estudios realizados :"	
	returnvariable="MSG_En_el_area_de_Educacion"/>	
		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_debe_indicar_algun_tipo_de_instucion"
	default="Deba indicar algún tipo de institución"	
	returnvariable="MSG_debe_indicar_algun_tipo_de_instucion"/>	
		
		
<script language="javascript" type="text/javascript">
	$( document ).ready(function() {
		<cfif len(vRHOOtroIdioma5) gt 0 >
			$('#RHIOtro').attr('checked',true);
		</cfif>	
	});

	function fnShowOtroIdioma(){
		if(document.form1.RHIOtro.checked)
			$('.otroIdioma').delay(200).fadeIn(400);	
		else
			$('.otroIdioma').delay(200).fadeOut(400);
	}
	
	function ModificarEXP(valor){
		document.form1.RHEEid.value = valor;
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum.cfm';
		document.form1.submit();
	}	
	
	function NEW_Experiencia(){
		document.form1.RHEEid.value = "";
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum.cfm';
		document.form1.submit();
	}

	function ModificarEDU(valor){
		document.form1.RHEElinea.value = valor;
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum.cfm';
		document.form1.submit();
	}
	
	function ModificarOBS(valor){
		document.form1.RHOElinea.value = valor;
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum.cfm';
		document.form1.submit();
	}
	
	function NEW_Estudios(){
		document.form1.RHEElinea.value = "";
		document.form1.AccionAEjecutar.value="";
		document.form1.action='curriculum.cfm';
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
	function funcValidaOBS(){
		var error_msg = '';
		/*if(document.form1.calen2.value == ''){
			 error_msg += "\n -Fecha.";
		}*/		
		if(document.form1.obs.value == ''){
			 error_msg += "\n - <cf_translate key="LB_Observaciones">Observaciones</cf_translate>.";
		}
	

		if (error_msg.length > 0) {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;
	}
		<!--- ************************************************************************* --->

	function fnValidaIdiomas(){
		var result = false;
		var elements = $('.sIdioma');

		for(i=0; i<elements.length; i++){
			result = fnValidarElement(elements[i].name,i+1,'#MSG_SelectPorcentajeDominioIdioma#');
			if(!result)
				break;
		}
		return result;
	}	

	<!--- ************************************************************************* --->
	</cfoutput>
	function funcGuardar(){
		if(funcValidaGeneral()){
			if(fnValidaIdiomas()){
				document.form1.AccionAEjecutar.value='ADD-MOD';
				document.form1.submit();
			}
		}
	}

	function fnValidarElement(e,val,showMsg){  
		var selector = '';
		if(val != 5)
			selector = 'select'; 
		else
			selector = 'input'; 
			
		if($(selector+'[name='+e+']').val().trim() != ''){ 
			if($('select[name=RHOLengOral'+val+']').val() == '' || $('select[name=RHOLengEscr'+val+']').val() == '' || $('select[name=RHOLengLect'+val+']').val() == ''){
				alert(showMsg);
				return false;
			}	
		}		
		else
			$(selector+'[name='+e+']').parent().siblings().children().val('');

		return true;
	}

	function fnChangeIdioma(e){
		if($('select[name='+e.name+']').val() == '')
			$('select[name='+e.name+']').parent().siblings().children().val('');
	}
	
	function funcContrasena(){
		if(funcValidaGeneral()){
			document.form1.AccionAEjecutar.value='ADD-CON';
			document.form1.submit();
		}
	}	
	function funcHabilitar(){
		document.form1.AccionAEjecutar.value='ADD-HAB';
		document.form1.submit();
	}
	function funcDeshabilitar(){
		document.form1.AccionAEjecutar.value='ADD-DES';
		document.form1.submit();
	}	
	
	function funcAddListaNegra(){
		document.form1.AccionAEjecutar.value='ADD-LIST';
		document.form1.submit();
	}
	function funcDelListaNegra(){
		document.form1.AccionAEjecutar.value='DEL-LIST';
		document.form1.submit();
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
	
	function ADD_Observaciones(){
		if(funcValidaOBS()){
			document.form1.AccionAEjecutar.value='ADD-MOD';
			document.form1.submit();
		}
	}
	function EliminarEDU(llave){
		document.form1.AccionAEjecutar.value='DEL-EDUC';
		document.form1.RHEElinea.value=llave;
		document.form1.submit();
	}
	
	function EliminarOBS(llave){
		document.form1.AccionAEjecutar.value='DEL-OBS';
		document.form1.RHOElinea.value=llave;
		document.form1.submit();
	}
	
	function EliminarEXP(llave){
		document.form1.AccionAEjecutar.value='DEL-EXP';
		document.form1.RHEEid.value=llave;
		document.form1.submit();
	}
	
</script>
