
<cfif isdefined("url.RHOid") and len(trim(url.RHOid)) gt 0 and not isdefined("form.RHOid")  >
	<cfset form.RHOid = url.RHOid>
</cfif>
<cfset llave='RHOid'>
<cfset llaveValor=form.RHOid>

<cfif isdefined("url.RHOid")  and isdefined("url.bDEid") and len(trim(url.RHOid)) gt 0>
	<cfset form.Deid = url.RHOid>
	<cfset llave='DEid'>
	<cfset llaveValor=form.DEid>
</cfif>
 

<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0 and not isdefined("form.modo")  >
	<cfset form.modo = url.modo>
</cfif>


<cfif not isdefined("url.modo") and not isdefined("form.modo")  >
	<cfset form.modo = 1>
</cfif>

<!--- Información general del oferente  --->
<cfquery name="rsMonedaLOC" datasource="#Session.DSN#">
	select Miso4217  from Monedas a
	inner join Empresa b
		on a. Mcodigo = b. Mcodigo
		and b.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ecodigosdc#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
<cfquery name="rsIdiomas" datasource="#session.DSN#">
	select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
	from RHIdiomas
	order by #LvarRHDescripcion# asc
</cfquery>

<cf_translatedata name="get" tabla="NTipoIdentificacion" col="b.NTIdescripcion" returnvariable="LvarNTIdescripcion">
<cfquery name="rsDatosPersonales" datasource="#session.DSN#">
	select 
	a.RHOnombre,a.RHOapellido1,a.RHOapellido2, 
	a.RHOtelefono1,
	a.RHOtelefono2,
	#LvarNTIdescripcion# as NTIdescripcion,
	a.RHOidentificacion,
	a.RHOemail,
	a.RHOfechanac,
	case coalesce(a.RHORefValida,0) 
		when  1 then '<img src="/cfmx/rh/imagenes/checked.gif" border="0">'
		when  0 then '<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">'
	end RHORefValida,
	case coalesce(a.RHOPosViajar,0) 
		when  1 then '<img src="/cfmx/rh/imagenes/checked.gif" border="0">'
		when  0 then '<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">'
	end RHOPosViajar,
	case coalesce(a.RHOPosTralado,0)  
		when  1 then '<img src="/cfmx/rh/imagenes/checked.gif" border="0">'
		when  0 then '<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">'
	end RHOPosTralado,	
	case coalesce(a.RHOEntrevistado,0)  
		when  1 then '<img src="/cfmx/rh/imagenes/checked.gif" border="0">'
		when  0 then '<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">'
	end RHOEntrevistado,	
	a.RHOPrenteInf,
	a.RHOPrenteSup, 
	coalesce(a.RHOMonedaPrt,'#rsMonedaLOC.Miso4217#') as RHOMonedaPrt,
	case a.RHOcivil 
		when 0 then '<cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate>'
		when 1 then '<cf_translate key="LB_CasadoA">Casado(a)</cf_translate>'
		when 2 then '<cf_translate key="LB_DivorciadoA">Divorciado(a)</cf_translate>'
		when 3 then '<cf_translate key="LB_ViudoA">Viudo(a)</cf_translate>'
		when 4 then '<cf_translate key="LB_UnionLibre">Union Libre</cf_translate>'
		when 5 then '<cf_translate key="LB_SeparadoA">Separado(a)</cf_translate>'
		else '<cf_translate key="LB_Otro">Otro</cf_translate>' 
	end  as RHOcivil,
	case a.RHOsexo 
		when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>'
		when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>'
		else '' 
	end  as RHOsexo,
	a.RHOIdioma1,
	a.RHOIdioma2,
	a.RHOIdioma3,
	a.RHOIdioma4,
	a.RHOLengOral1,
	a.RHOLengOral2,
	a.RHOLengOral3,
	a.RHOLengOral4,
	a.RHOLengEscr1,	
	a.RHOLengEscr2,	
	a.RHOLengEscr3,	
	a.RHOLengEscr4,
	a.RHOLengLect1,
	a.RHOLengLect2,
	a.RHOLengLect3,
	a.RHOLengLect4
	from DatosOferentes a
	inner join NTipoIdentificacion b
		on a.NTIcodigo = b.NTIcodigo
		and b.Ecodigo = #Session.Ecodigo#
	where  a.#llave# =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#">
</cfquery>
<cfif not rsDatosPersonales.recordCount>
	<cf_importlibs>
	<div class="container"> 
	<div class="row" style="padding-top:3em">
		<div class="col-lg-4">
		    <div class="alert alert-dismissable alert-info">
		      <strong><cf_translate key="NoexistendatosdeCurriculumVitae">No existen datos de Curriculum Vitae</cf_translate></strong><br>
		      <cf_translate key="EsteoferentenoposeeDatosdeCurriculumVitaeparamostrar">Este oferente no posee Datos de Curriculum Vitae para mostrar</cf_translate>.
		    </div>
		  </div>
	</div>
	</div>
    <cfabort>
</cfif>
<cfquery name="rsAnnosExperiencia" datasource="#Session.DSN#">
	select coalesce(sum(RHEEAnnosLab),0)  as RHEEAnnosLab
	from RHExperienciaEmpleado b 
	where b.#llave# =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#">
</cfquery>

<cfquery name="rsExperiencia" datasource="#Session.DSN#">
	select 
		RHEEnombreemp,
		RHEEtelemp,
		RHEEpuestodes,
		RHEEfechaini,
		RHEEfecharetiro,
		Actualmente,
		RHEEfunclogros
	from RHExperienciaEmpleado where #llave# =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by RHEEfechaini desc
</cfquery>

<cfquery name="rsEducFormal" datasource="#Session.DSN#">
	select  coalesce(RHIAnombre,RHEotrains)as institucion,
	a.RHEfechaini,
	coalesce(RHOTDescripcion,RHEOtrotitulo) as titulo,
	coalesce(GAnombre,'<cf_translate key="Sin_defini">Sin definir</cf_translate>') as grado,
	RHEsinterminar 
	from RHEducacionEmpleado a
	left outer join RHInstitucionesA b
		on a.RHIAid = b.RHIAid
		and a.Ecodigo = b.Ecodigo
	left outer join RHOTitulo c
		on a.RHOTid  =  c.RHOTid 
		and c.CEcodigo = #Session.CEcodigo#
	left outer  join GradoAcademico d
		on a.GAcodigo =  d.GAcodigo
		and a.Ecodigo = d.Ecodigo
	where #llave# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and RHECapNoFormal is null
	order by RHEsinterminar  desc,a.RHEfechaini desc
</cfquery>

<cfquery name="rsEducNoFormal" datasource="#Session.DSN#">
	select  coalesce(RHIAnombre,RHEotrains)as institucion,
	a.RHEfechaini,
	RHECapNoFormal as titulo,
	coalesce(GAnombre,'<cf_translate key="Sin_defini">Sin definir</cf_translate>') as grado,
	RHEsinterminar 
	from RHEducacionEmpleado a
	left outer join RHInstitucionesA b
		on a.RHIAid = b.RHIAid
		and a.Ecodigo = b.Ecodigo
	left outer  join GradoAcademico d
		on a.GAcodigo =  d.GAcodigo
		and a.Ecodigo = d.Ecodigo
	where #llave# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and <cf_dbfunction name="length" args="RHECapNoFormal"> > 0
	
	order by RHEsinterminar  desc,a.RHEfechaini desc
</cfquery>

<cfoutput>

<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CurriculumVitae"
		Default="Curriculum Vitae"
		returnvariable="Titulo"/>
		#Titulo#&nbsp;&nbsp;#rsDatosPersonales.RHOnombre#&nbsp;#rsDatosPersonales.RHOapellido1#&nbsp;#rsDatosPersonales.RHOapellido2#
</title>	

<cfif form.modo eq 2>
	 <cfdocument format="pdf" 
		marginbottom="1"
		margintop="2" 
		marginleft="1"
		 marginright="1"
		unit="cm" 
		mimetype ="text/xml"
		backgroundvisible = "yes"
		fontembed ="yes" 
		pagetype="letter">
		<cfdocumentitem type="header"> 
	
	<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
		<tr>
			
			<td style="font-size:25px" valign="top" bgcolor="##CCCCCC">
				#rsDatosPersonales.RHOnombre#&nbsp;#rsDatosPersonales.RHOapellido1#&nbsp;#rsDatosPersonales.RHOapellido2#
				</font>
			</td>
		</cfdocumentitem>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="DatosGenerales">DATOS GENERALES</cf_translate>
			</td>
		</tr>		
		<tr>
			<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<!---<td rowspan="10" width="20%" valign="top">
					<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenOferente" campo="foto" condicion="Ecodigo = #session.Ecodigo# and RHOid = #form.RHOid#" conexion="#Session.DSN#" width="100" height="100">
					<img src="foto_candidato.cfm?RHOid=#URLEncodedFormat(form.RHOid)#" border="0" width="55" height="73" /></td>--->  
					<td style="font-size:12px" width="18%">
						<b><cf_translate key="LB_#rsDatosPersonales.NTIdescripcion#">#rsDatosPersonales.NTIdescripcion#</cf_translate></b>:					</td>
					<td style="font-size:12px" width="20%">
						#rsDatosPersonales.RHOidentificacion#					</td>
					<td style="font-size:12px" width="18%">
						<b><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate></b>:					</td>
					<td style="font-size:12px" width="20%">
						#rsDatosPersonales.RHOcivil#					</td>
				</tr>
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="LB_FechaDeNacimiento">Fecha de Nacimiento</cf_translate></b>:					</td>
					<td style="font-size:12px">
						#LSDateFormat(rsDatosPersonales.RHOfechanac, "dd/mm/yyyy")#					</td>
					<td style="font-size:12px">
						<b><cf_translate key="LB_Sexo">Sexo</cf_translate></b>:					</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOsexo#					</td>									
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b> <cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></b>:</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOtelefono1#					</td>
					<td style="font-size:12px">
						<b> <cf_translate key="LB_Celular">Celular</cf_translate></b>:</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOtelefono2#					</td>
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="LB_CorreoElectronico">Correo Electr&oacute;nico</cf_translate></b>:</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOemail#					</td>
					<td style="font-size:12px">
						<b> <cf_translate key="LB_Aspiracion_Salarial">Aspiraci&oacute;n Salarial</cf_translate></b>:</td>
					<td style="font-size:12px" nowrap="nowrap"> 
						<cfif isdefined("rsDatosPersonales.RHOMonedaPrt") and len(trim(rsDatosPersonales.RHOMonedaPrt))>
							(#rsDatosPersonales.RHOMonedaPrt#)
						<cfelse>
							(#rsMonedaLOC.Miso4217#)
						</cfif>
						&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteInf,"___,.__")#
						<cf_translate key="LB_A">a</cf_translate>
						&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteSup,"___,.__")#					</td>
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="CHK_Entrevistado">Entrevistado</cf_translate>:</b>					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOEntrevistado#					</td>
					<td style="font-size:12px"  nowrap="nowrap">
						<b><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate>:</b>					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHORefValida#					</td>
				</tr>			
				<tr>
					<td style="font-size:12px"> 
						<b><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate>:</b>					</td>
					<td style="font-size:12px">  
						#rsDatosPersonales.RHOPosViajar#					</td>
					<td style="font-size:12px" nowrap="nowrap"> 
						<b><cf_translate key="CHK_Posibilidad_de_trasladarse">Posibilidad de trasladarse</cf_translate>:</b>					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOPosTralado#					</td>					
				</tr>
				<tr>
					<td colspan="4">
						<fieldset><legend><cf_translate key="LB_Idioma">Idioma</cf_translate></legend>
							<table width="100%" border="0" cellpadding="2" cellspacing="2">			
								<tr> 
									<td style="font-size:12px"> <b><cf_translate key="LB_Lenguaje">Lenguaje</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioConversacional">Dominio Conversacional</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioEscrito">Dominio Escrito</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioLectura">Dominio Lectura</cf_translate></b></td>
								</tr>
								<cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1))) or
									  (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2))) or 
									  (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3))) or 
									  (isdefined("rsDatosPersonales.RHOIdioma4") and len(trim(rsDatosPersonales.RHOIdioma4)))>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1)))>
										<tr> 
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma1 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>	
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral1# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr1# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect1# %</td>
										</tr>	
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2)))>
										<tr>	
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma2 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral2# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr2# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect2# %</td>										  
									  	</tr>	
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3)))>
										<tr>	
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma3 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral3# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr3# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect3# %</td>
										</tr>	
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma4") and len(trim(rsDatosPersonales.RHOIdioma4)))>
										<tr>
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma4 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral4# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr4# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect4# %</td>
										</tr>	
									  </cfif>
								<cfelse>
									<tr> 
										<td style="font-size:12px" colspan="4">
											<cf_translate key="LB_No_se_han_definido_lenguajes">No se han definido lenguajes</cf_translate>										</td>
									</tr>
								</cfif>	
							</table>
						</fieldset>					</td>
				</tr>			
			</table>	
			</td>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="EXPERIENCIA_LABORAL">EXPERIENCIA LABORAL</cf_translate>
			</td>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-size:13px; " align="center">
				<cf_translate key="Annos_de_experiencia">A&ntilde;os de experiencia</cf_translate>&nbsp; #rsAnnosExperiencia.RHEEAnnosLab#
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsExperiencia.recordCount GT 0>
						<cfloop query="rsExperiencia">
							<tr>
								<td style="font-size:13px" colspan="3">
									<b>#rsExperiencia.RHEEnombreemp#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="4" >&nbsp;
									
								</td>
								<td style="font-size:12px" width="15%"  nowrap>
									<cf_translate key="LB_Cargo">Cargo</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEpuestodes#
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" nowrap>
									<cf_translate key="LB_Tiempo_Laborado">Tiempo Laborado</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									<cfif isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))> 
										<cfswitch expression="#month(rsExperiencia.RHEEfechaini)#">
											<cfcase value="1">
												<cf_translate key="LB_ENERO">Enero</cf_translate>
											</cfcase>
											<cfcase value="2">
												<cf_translate key="LB_Febrero">Febrero</cf_translate>
											</cfcase>
											<cfcase value="3">
												<cf_translate key="LB_Marzo">Marzo</cf_translate>
											</cfcase>
											<cfcase value="4">
												<cf_translate key="LB_Abril">Abril</cf_translate>
											</cfcase>
											<cfcase value="5">
												<cf_translate key="LB_Mayo">Mayo</cf_translate>
											</cfcase>
											<cfcase value="6">
												<cf_translate key="LB_Junio">Junio</cf_translate>
											</cfcase>
											<cfcase value="7">
												<cf_translate key="LB_Julio">Julio</cf_translate>
											</cfcase>
											<cfcase value="8">
												<cf_translate key="LB_Agosto">Agosto</cf_translate>
											</cfcase>
											<cfcase value="9">
												<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
											</cfcase>
											<cfcase value="10">
												<cf_translate key="LB_Octubre">Octubre</cf_translate>
											</cfcase>
											<cfcase value="11">
		
												<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
											</cfcase>
											<cfcase value="12">
												<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
											</cfcase>
											
										</cfswitch>
										&nbsp; 
											#year(rsExperiencia.RHEEfechaini)#
										&nbsp; 
									</cfif>
									<cfif isdefined("rsExperiencia.RHEEfecharetiro") and len(trim(rsExperiencia.RHEEfecharetiro))> 
										<cfif year(rsExperiencia.RHEEfecharetiro) neq 6100 >
											<cf_translate key="LB_al">al</cf_translate>
											&nbsp;
											<cfswitch expression="#month(rsExperiencia.RHEEfecharetiro)#">
												<cfcase value="1">
													<cf_translate key="LB_ENERO">Enero</cf_translate>
												</cfcase>
												<cfcase value="2">
													<cf_translate key="LB_Febrero">Febrero</cf_translate>
												</cfcase>
												<cfcase value="3">
													<cf_translate key="LB_Marzo">Marzo</cf_translate>
												</cfcase>
												<cfcase value="4">
													<cf_translate key="LB_Abril">Abril</cf_translate>
												</cfcase>
												<cfcase value="5">
													<cf_translate key="LB_Mayo">Mayo</cf_translate>
												</cfcase>
												<cfcase value="6">
													<cf_translate key="LB_Junio">Junio</cf_translate>
												</cfcase>
												<cfcase value="7">
													<cf_translate key="LB_Julio">Julio</cf_translate>
												</cfcase>
												<cfcase value="8">
													<cf_translate key="LB_Agosto">Agosto</cf_translate>
												</cfcase>
												<cfcase value="9">
													<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
												</cfcase>
												<cfcase value="10">
													<cf_translate key="LB_Octubre">Octubre</cf_translate>
												</cfcase>
												<cfcase value="11">
													<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
												</cfcase>
												<cfcase value="12">
													<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
												</cfcase>
												
											</cfswitch>									
											&nbsp; 
											#year(rsExperiencia.RHEEfecharetiro)#
										<cfelse>
											<cf_translate key="LB_Hasta_la_fecha">Hasta la fecha</cf_translate>
										</cfif>
									</cfif>
									
									
	
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" nowrap>
									<cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEtelemp#
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" valign="top" nowrap="nowrap">
									<cf_translate key="LB_Funciones_y_logros">Funciones y logros</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEfunclogros#
								</td>
							</tr>
						</cfloop>				
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_experiencia_laboral">No se ha definido experiencia laboral</cf_translate>
							</td>
						</tr>
		
					</cfif>
				</table>
			</td>
		</tr>	
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="ESTUDIOS_FORMALES">ESTUDIOS FORMALES</cf_translate>
			</td>
		</tr>	
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsEducFormal.recordCount GT 0>
						<cfloop query="rsEducFormal">
							<tr>
								<td style="font-size:13px" colspan="2">
									<b>#rsEducFormal.institucion#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="3">&nbsp;</td>
								<td style="font-size:12px"> 
									<cfif isdefined("rsEducFormal.RHEfechaini") and len(trim(rsEducFormal.RHEfechaini))> 
										<cfswitch expression="#month(rsEducFormal.RHEfechaini)#">
											<cfcase value="1">
												<cf_translate key="LB_ENERO">Enero</cf_translate>
											</cfcase>
											<cfcase value="2">
												<cf_translate key="LB_Febrero">Febrero</cf_translate>
											</cfcase>
											<cfcase value="3">
												<cf_translate key="LB_Marzo">Marzo</cf_translate>
											</cfcase>
											<cfcase value="4">
												<cf_translate key="LB_Abril">Abril</cf_translate>
											</cfcase>
											<cfcase value="5">
												<cf_translate key="LB_Mayo">Mayo</cf_translate>
											</cfcase>
											<cfcase value="6">
												<cf_translate key="LB_Junio">Junio</cf_translate>
											</cfcase>
											<cfcase value="7">
												<cf_translate key="LB_Julio">Julio</cf_translate>
											</cfcase>
											<cfcase value="8">
												<cf_translate key="LB_Agosto">Agosto</cf_translate>
											</cfcase>
											<cfcase value="9">
												<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
											</cfcase>
											<cfcase value="10">
												<cf_translate key="LB_Octubre">Octubre</cf_translate>
											</cfcase>
											<cfcase value="11">
												<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
											</cfcase>
											<cfcase value="12">
												<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
											</cfcase>
										</cfswitch>
										&nbsp; 
										#year(rsEducFormal.RHEfechaini)#	
									</cfif>								
								</td>
							</tr>
							<tr>
								<td style="font-size:12px"> 
									#rsEducFormal.grado#
								</td>
							</tr>						
							<tr>
								<td style="font-size:12px"> 
									#rsEducFormal.titulo#
								</td>
							</tr>
											
						</cfloop>
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_educacacion_formal">No se ha definido educaci&oacute;n formal</cf_translate>
							</td>
						</tr>
					</cfif>	
				</table>	
			</td>
		</tr>	
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="ESTUDIOS_No_FORMALES">ESTUDIOS NO FORMALES</cf_translate>
			</td>
		</tr>	
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsEducNoFormal.recordCount GT 0>
						<cfloop query="rsEducNoFormal">
							<tr>
								<td style="font-size:13px" colspan="2">
									<b>#rsEducNoFormal.institucion#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="3">&nbsp;</td>
								<td style="font-size:12px"> 
									<cfswitch expression="#month(rsEducNoFormal.RHEfechaini)#">
										<cfcase value="1">
											<cf_translate key="LB_ENERO">Enero</cf_translate>
										</cfcase>
										<cfcase value="2">
											<cf_translate key="LB_Febrero">Febrero</cf_translate>
										</cfcase>
										<cfcase value="3">
											<cf_translate key="LB_Marzo">Marzo</cf_translate>
										</cfcase>
										<cfcase value="4">
											<cf_translate key="LB_Abril">Abril</cf_translate>
										</cfcase>
										<cfcase value="5">
											<cf_translate key="LB_Mayo">Mayo</cf_translate>
										</cfcase>
										<cfcase value="6">
											<cf_translate key="LB_Junio">Junio</cf_translate>
										</cfcase>
										<cfcase value="7">
											<cf_translate key="LB_Julio">Julio</cf_translate>
										</cfcase>
										<cfcase value="8">
											<cf_translate key="LB_Agosto">Agosto</cf_translate>
										</cfcase>
										<cfcase value="9">
											<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
										</cfcase>
										<cfcase value="10">
											<cf_translate key="LB_Octubre">Octubre</cf_translate>
										</cfcase>
										<cfcase value="11">
											<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
										</cfcase>
										<cfcase value="12">
											<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
										</cfcase>
									</cfswitch>
									&nbsp; 
									#year(rsEducNoFormal.RHEfechaini)#								
								</td>
							</tr>						
							<tr>
								<td style="font-size:12px"> 
									#rsEducNoFormal.grado#
								</td>
							</tr>					
							<tr>
								<td style="font-size:12px"> 
									#rsEducNoFormal.titulo#
								</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_educacacion_no_formal">No se ha definido educaci&oacute;n no formal</cf_translate>
	
							</td>
						</tr>
					</cfif>	
				</table>	
			</td>
		</tr>		
		<tr>
			<td><hr></td>
		</tr>
	</table>
	</cfdocument>
<cfelse>
	<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
		<tr>
			
			<td style="font-size:25px" valign="top" bgcolor="##CCCCCC">
				#rsDatosPersonales.RHOnombre#&nbsp;#rsDatosPersonales.RHOapellido1#&nbsp;#rsDatosPersonales.RHOapellido2#
				</font>
			</td>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="DatosGenerales">DATOS GENERALES</cf_translate>
			</td>
		</tr>		
		<tr>
			<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="8" width="10%" valign="top">
						 <cfquery datasource="#session.DSN#" name="rs">
							select e.foto
							from RHImagenOferente e
							where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
						 <cfif Len(rs.foto) gt 1>
						   <img src="foto_candidato.cfm?RHOid=#URLEncodedFormat(form.RHOid)#" border="0" width="94" height="118">
						 <cfelse>
							<img src="/cfmx/rh/imagenes/sin_foto.gif" border="0" width="94" height="118">
						</cfif>		
					</td>
					<td style="font-size:12px" width="18%">
						<b><cf_translate key="LB_#rsDatosPersonales.NTIdescripcion#">#rsDatosPersonales.NTIdescripcion#</cf_translate></b>:
					</td>
					<td style="font-size:12px" width="20%">
						#rsDatosPersonales.RHOidentificacion#
					</td>
					<td style="font-size:12px" width="18%">
						<b><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate></b>:
					</td>
					<td style="font-size:12px" width="20%">
						#rsDatosPersonales.RHOcivil#
					</td>
				</tr>
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="LB_FechaDeNacimiento">Fecha de Nacimiento</cf_translate></b>:
					</td>
					<td style="font-size:12px">
						<cf_locale name="date" value="#rsDatosPersonales.RHOfechanac#"/>
					</td>
					<td style="font-size:12px">
						<b><cf_translate key="LB_Sexo">Sexo</cf_translate></b>:
					</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOsexo#
					</td>									
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b> <cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></b>:</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOtelefono1#
					</td>
					<td style="font-size:12px">
						<b> <cf_translate key="LB_Celular">Celular</cf_translate></b>:</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOtelefono2#
					</td>
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="LB_CorreoElectronico">Correo Electr&oacute;nico</cf_translate></b>:</td>
					<td style="font-size:12px">
						#rsDatosPersonales.RHOemail#
					</td>
					<td style="font-size:12px" nowrap="nowrap">
						<b> <cf_translate key="LB_Aspiracion_Salarial">Aspiraci&oacute;n Salarial</cf_translate></b>:</td>
					<td style="font-size:12px"> 
						<cfif isdefined("rsDatosPersonales.RHOMonedaPrt") and len(trim(rsDatosPersonales.RHOMonedaPrt))>
							(#rsDatosPersonales.RHOMonedaPrt#)
						<cfelse>
							(#rsMonedaLOC.Miso4217#)
						</cfif>
						&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteInf,"___,.__")#
						<cf_translate key="LB_A">a</cf_translate>
						&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteSup,"___,.__")#
					</td>
				</tr>	
				<tr>
					<td style="font-size:12px">
						<b><cf_translate key="CHK_Entrevistado">Entrevistado</cf_translate>:</b>
					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOEntrevistado#
					</td>
					<td style="font-size:12px" nowrap="nowrap">
						<b><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate>:</b>
					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHORefValida#
					</td>
				</tr>			
				<tr>
					<td style="font-size:12px"> 
						<b><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate>:</b>
					</td>
					<td style="font-size:12px">  
						#rsDatosPersonales.RHOPosViajar#
					</td>
					<td style="font-size:12px" nowrap="nowrap"> 
						<b><cf_translate key="CHK_Posibilidad_de_trasladarse">Posibilidad de trasladarse</cf_translate>:</b>
					</td>
					<td style="font-size:12px"> 
						#rsDatosPersonales.RHOPosTralado#
					</td>					
				</tr>
 				<cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="ug.UGdescripcion" returnvariable="LvarUGdescripcion"> 
				<cf_dbdatabase table="UnidadGeografica" datasource="asp" returnvariable="lvarUG">
				<cf_dbfunction name="op_concat" returnvariable="concat">
				<cfquery datasource="#session.dsn#" name="rsLugares">
					select distinct ' '#concat##LvarUGdescripcion# as valor
					from RHOferentesLugares ol
						inner join #lvarUG# ug
							on ol.UGid = ug.UGid
					where  ol.RHOid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#llaveValor#"> <!---la tabla solo tiene RHOid --->
						and ol.RHOLtipo = 0 <!---- por el momento el tipo es cero hasta que se encuentre una tipologia aplicable --->
				</cfquery>
				<tr>
					<td style="font-size:12px"> 
						<b><cf_translate key="LB_ZonasDePreferencia ">Zonas de preferencia</cf_translate>:</b>
					</td>
					<td style="font-size:12px"  colspan="3">#valuelist(rsLugares.valor)#</td>		
				</tr>

				<tr>
					<td colspan="4">
						<fieldset><legend><cf_translate key="LB_Idioma">Idioma</cf_translate></legend>
							<table width="100%" border="0" cellpadding="2" cellspacing="2">			
								<tr> 
									<td style="font-size:12px"> <b><cf_translate key="LB_Lenguaje">Lenguaje</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioConversacional">Dominio Conversacional</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioEscrito">Dominio Escrito</cf_translate></b></td>
									<td style="font-size:12px" align="right"><b><cf_translate key="LB_DominioLectura">Dominio Lectura</cf_translate></b></td>
								</tr>
								<cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1))) or
									  (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2))) or 
									  (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3))) or 
									  (isdefined("rsDatosPersonales.RHOIdioma4") and len(trim(rsDatosPersonales.RHOIdioma4)))>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1)))>
										<tr> 
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma1 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>	
											<td  style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral1# %</td>
											<td  style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr1# %</td>
											<td  style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect1# %</td>
									 	</tr>
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2)))>
										<tr>
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma2 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral2# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr2# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect2# %</td>										  
									  	</tr>
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3)))>
										<tr>
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma3 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral3# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr3# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect3# %</td>
										</tr>	
									  </cfif>
									  <cfif (isdefined("rsDatosPersonales.RHOIdioma4") and len(trim(rsDatosPersonales.RHOIdioma4)))>
										<tr>
											<td style="font-size:12px">
												<cfloop query="rsIdiomas">
													<cfif rsDatosPersonales.RHOIdioma4 eq RHIid>#RHDescripcion#</cfif>
												</cfloop>
											</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengOral4# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengEscr4# %</td>
											<td style="font-size:12px" align="right">#rsDatosPersonales.RHOLengLect4# %</td>
										</tr>	
									  </cfif>
								<cfelse>
									<tr> 
										<td style="font-size:12px" colspan="4">
											<cf_translate key="LB_No_se_han_definido_lenguajes">No se han definido lenguajes</cf_translate>
										</td>
									</tr>
								
								</cfif>	
							</table>
						</fieldset>			
					</td>
				</tr>			
			</table>	
			</td>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="EXPERIENCIA_LABORAL">EXPERIENCIA LABORAL</cf_translate>
			</td>
		</tr>
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-size:13px; " align="center">
				<cf_translate key="Annos_de_experiencia">A&ntilde;os de experiencia</cf_translate>&nbsp; #rsAnnosExperiencia.RHEEAnnosLab#
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsExperiencia.recordCount GT 0>
						<cfloop query="rsExperiencia">
							<tr>
								<td style="font-size:13px" colspan="3">
									<b>#rsExperiencia.RHEEnombreemp#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="4" >&nbsp;
									
								</td>
								<td style="font-size:12px" width="10%"  nowrap>
									<cf_translate key="LB_Cargo">Cargo</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEpuestodes#
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" nowrap>
									<cf_translate key="LB_Tiempo_Laborado">Tiempo Laborado</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									<cfif isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))> 
										<cfswitch expression="#month(rsExperiencia.RHEEfechaini)#">
											<cfcase value="1">
												<cf_translate key="LB_ENERO">Enero</cf_translate>
											</cfcase>
											<cfcase value="2">
												<cf_translate key="LB_Febrero">Febrero</cf_translate>
											</cfcase>
											<cfcase value="3">
												<cf_translate key="LB_Marzo">Marzo</cf_translate>
											</cfcase>
											<cfcase value="4">
												<cf_translate key="LB_Abril">Abril</cf_translate>
											</cfcase>
											<cfcase value="5">
												<cf_translate key="LB_Mayo">Mayo</cf_translate>
											</cfcase>
											<cfcase value="6">
												<cf_translate key="LB_Junio">Junio</cf_translate>
											</cfcase>
											<cfcase value="7">
												<cf_translate key="LB_Julio">Julio</cf_translate>
											</cfcase>
											<cfcase value="8">
												<cf_translate key="LB_Agosto">Agosto</cf_translate>
											</cfcase>
											<cfcase value="9">
												<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
											</cfcase>
											<cfcase value="10">
												<cf_translate key="LB_Octubre">Octubre</cf_translate>
											</cfcase>
											<cfcase value="11">
		
												<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
											</cfcase>
											<cfcase value="12">
												<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
											</cfcase>
											
										</cfswitch>
										
										&nbsp; 
											#year(rsExperiencia.RHEEfechaini)#
										&nbsp; 
									</cfif>
									<cfif isdefined("rsExperiencia.RHEEfecharetiro") and len(trim(rsExperiencia.RHEEfecharetiro))> 
										<cfif year(rsExperiencia.RHEEfecharetiro) neq 6100 >
											<cf_translate key="LB_al">al</cf_translate>
											&nbsp;
											<cfswitch expression="#month(rsExperiencia.RHEEfecharetiro)#">
												<cfcase value="1">
													<cf_translate key="LB_ENERO">Enero</cf_translate>
												</cfcase>
												<cfcase value="2">
													<cf_translate key="LB_Febrero">Febrero</cf_translate>
												</cfcase>
												<cfcase value="3">
													<cf_translate key="LB_Marzo">Marzo</cf_translate>
												</cfcase>
												<cfcase value="4">
													<cf_translate key="LB_Abril">Abril</cf_translate>
												</cfcase>
												<cfcase value="5">
													<cf_translate key="LB_Mayo">Mayo</cf_translate>
												</cfcase>
												<cfcase value="6">
													<cf_translate key="LB_Junio">Junio</cf_translate>
												</cfcase>
												<cfcase value="7">
													<cf_translate key="LB_Julio">Julio</cf_translate>
												</cfcase>
												<cfcase value="8">
													<cf_translate key="LB_Agosto">Agosto</cf_translate>
												</cfcase>
												<cfcase value="9">
													<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
												</cfcase>
												<cfcase value="10">
													<cf_translate key="LB_Octubre">Octubre</cf_translate>
												</cfcase>
												<cfcase value="11">
													<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
												</cfcase>
												<cfcase value="12">
													<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
												</cfcase>
												
											</cfswitch>									
											&nbsp; 
											#year(rsExperiencia.RHEEfecharetiro)#
										<cfelse>
											<cf_translate key="LB_Hasta_la_fecha">Hasta la fecha</cf_translate>
										</cfif>
									
									</cfif>
									
									
	
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" nowrap>
									<cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEtelemp#
								</td>
							</tr>
							<tr>	
								<td style="font-size:12px" valign="top" nowrap>
									<cf_translate key="LB_Funciones_y_logros">Funciones y logros</cf_translate>:
								</td>
								<td style="font-size:12px"> 
									#rsExperiencia.RHEEfunclogros#
								</td>
							</tr>
						</cfloop>				
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_experiencia_laboral">No se ha definido experiencia laboral</cf_translate>
							</td>
						</tr>
		
					</cfif>
				</table>
			</td>
		</tr>	
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="ESTUDIOS_FORMALES">ESTUDIOS FORMALES</cf_translate>
			</td>
		</tr>	
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsEducFormal.recordCount GT 0>
						<cfloop query="rsEducFormal">
							<tr>
								<td style="font-size:13px" colspan="2">
									<b>#rsEducFormal.institucion#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="3">&nbsp;</td>
								<td style="font-size:12px"> 
									<cfif isdefined("rsEducFormal.RHEfechaini") and len(trim(rsEducFormal.RHEfechaini))> 
										<cfswitch expression="#month(rsEducFormal.RHEfechaini)#">
											<cfcase value="1">
												<cf_translate key="LB_ENERO">Enero</cf_translate>
											</cfcase>
											<cfcase value="2">
												<cf_translate key="LB_Febrero">Febrero</cf_translate>
											</cfcase>
											<cfcase value="3">
												<cf_translate key="LB_Marzo">Marzo</cf_translate>
											</cfcase>
											<cfcase value="4">
												<cf_translate key="LB_Abril">Abril</cf_translate>
											</cfcase>
											<cfcase value="5">
												<cf_translate key="LB_Mayo">Mayo</cf_translate>
											</cfcase>
											<cfcase value="6">
												<cf_translate key="LB_Junio">Junio</cf_translate>
											</cfcase>
											<cfcase value="7">
												<cf_translate key="LB_Julio">Julio</cf_translate>
											</cfcase>
											<cfcase value="8">
												<cf_translate key="LB_Agosto">Agosto</cf_translate>
											</cfcase>
											<cfcase value="9">
												<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
											</cfcase>
											<cfcase value="10">
												<cf_translate key="LB_Octubre">Octubre</cf_translate>
											</cfcase>
											<cfcase value="11">
												<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
											</cfcase>
											<cfcase value="12">
												<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
											</cfcase>
										</cfswitch>
										&nbsp; 
										#year(rsEducFormal.RHEfechaini)#
								  </cfif>								
								</td>
							</tr>
							<tr>
								<td style="font-size:12px"> 
									#rsEducFormal.grado#
								</td>
							</tr>						
							<tr>
								<td style="font-size:12px"> 
									#rsEducFormal.titulo#
								</td>
							</tr>
											
						</cfloop>
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_educacacion_formal">No se ha definido educaci&oacute;n formal</cf_translate>
							</td>
						</tr>
					</cfif>	
				</table>	
			</td>
		</tr>	
		<tr>
			<td><hr></td>
		</tr>
		<tr>
			<td style="font-style:italic; font-size:15px">
				<cf_translate key="ESTUDIOS_No_FORMALES">ESTUDIOS NO FORMALES</cf_translate>
			</td>
		</tr>	
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="2">
					<cfif rsEducNoFormal.recordCount GT 0>
						<cfloop query="rsEducNoFormal">
							<tr>
								<td style="font-size:13px" colspan="2">
									<b>#rsEducNoFormal.institucion#</b>
								</td>
							</tr>
							<tr>
								<td style="font-size:12px" width="3%" rowspan="3">&nbsp;</td>
								<td style="font-size:12px"> 
									<cfswitch expression="#month(rsEducNoFormal.RHEfechaini)#">
										<cfcase value="1">
											<cf_translate key="LB_ENERO">Enero</cf_translate>
										</cfcase>
										<cfcase value="2">
											<cf_translate key="LB_Febrero">Febrero</cf_translate>
										</cfcase>
										<cfcase value="3">
											<cf_translate key="LB_Marzo">Marzo</cf_translate>
										</cfcase>
										<cfcase value="4">
											<cf_translate key="LB_Abril">Abril</cf_translate>
										</cfcase>
										<cfcase value="5">
											<cf_translate key="LB_Mayo">Mayo</cf_translate>
										</cfcase>
										<cfcase value="6">
											<cf_translate key="LB_Junio">Junio</cf_translate>
										</cfcase>
										<cfcase value="7">
											<cf_translate key="LB_Julio">Julio</cf_translate>
										</cfcase>
										<cfcase value="8">
											<cf_translate key="LB_Agosto">Agosto</cf_translate>
										</cfcase>
										<cfcase value="9">
											<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
										</cfcase>
										<cfcase value="10">
											<cf_translate key="LB_Octubre">Octubre</cf_translate>
										</cfcase>
										<cfcase value="11">
											<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
										</cfcase>
										<cfcase value="12">
											<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
										</cfcase>
									</cfswitch>
									&nbsp; 
									#year(rsEducNoFormal.RHEfechaini)#								
								</td>
							</tr>						
							<tr>
								<td style="font-size:12px"> 
									#rsEducNoFormal.grado#
								</td>
							</tr>					
							<tr>
								<td style="font-size:12px"> 
									#rsEducNoFormal.titulo#
								</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr> 
							<td style="font-size:12px">
								<cf_translate key="LB_No_se_ha_definido_educacacion_no_formal">No se ha definido educaci&oacute;n no formal</cf_translate>
	
							</td>
						</tr>
					</cfif>	
				</table>	
			</td>
		</tr>		
		<tr>
			<td><hr></td>
		</tr>
	</table>
</cfif>

</cfoutput>
