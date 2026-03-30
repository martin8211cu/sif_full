
<!--- VARIABLES DE TRADUCCION --->
<cfset translates= CreateObject("sif.Componentes.Translate")>
<cfset LB_EducacionDelOferente= translates.translate('LB_EducacionDelOferente',"Educación del Oferente","/rh/generales.xml")>
<cfset LB_EducacionDelEmpleado= translates.translate('LB_EducacionDelEmpleado',"Educación del Empleado","/rh/generales.xml")>
<cfset LB_EducacionRequerida= translates.translate('LB_EducacionRequerida',"Educaci&oacute;n Requerida","/rh/generales.xml")>
<cfset LB_Oferente= translates.translate('LB_Oferente',"Oferente","/rh/generales.xml")>
<cfset LB_Empleado= translates.translate('LB_Empleado',"Empleado","/rh/generales.xml")>
<cfset LB_Actualmente= translates.translate('LB_Actualmente',"Actualmente","/rh/generales.xml")>
<cfset LB_EstudiosRealizados= translates.translate('LB_EstudiosRealizados',"Estudios Realizados","/rh/generales.xml")>
<cfset LB_Deseable= translates.translate('LB_Deseable',"Deseable","/rh/generales.xml")>
<cfset LB_Intercambiable= translates.translate('LB_Intercambiable',"Intercambiable","/rh/generales.xml")>
<cfset LB_Requerido= translates.translate('LB_Requerido',"Requerido","/rh/generales.xml")>
<cfset LB_Educacion= translates.translate('LB_Educacion',"Educación","/rh/generales.xml")>
<cfset LB_SinTitulo= translates.translate('LB_SinTitulo',"Sin título","/rh/generales.xml")>
<cfset LB_SinInstitucion= translates.translate('LB_SinInstitucion',"Sin institución","/rh/generales.xml")>
<cfset LB_NoFormal= translates.translate('LB_NoFormal',"Educaci&oacute;n no formal","/rh/generales.xml")>
<cfset LB_Formal= translates.translate('LB_Formal',"Educ. Formal","/rh/generales.xml")>
<cfset LB_TipoEducacion= translates.translate('LB_TipoEducacion',"Tipo Educaci&oacute;n","/rh/generales.xml")>
<cfset BTN_Filtrar= translates.translate('BTN_Filtrar',"Filtrar","/rh/generales.xml")>
<cfset LB_CalificacionDeLaEducacion= translates.translate('LB_CalificacionDeLaEducacion',"Calificaci&oacute;n de la Educaci&oacute;n","/rh/generales.xml")>
<!--- FIN VARIABLES DE TRADUCCION --->
<table width="99%" align="center">
	<tr>
		<td>
			<cfset vstitulo =LB_Educacion>
			<cfset vstitulo =''>
			<cfif isdefined("form.DEid")><!---and not isdefined("form.DEid")>---->
				<cfset vstitulo = LB_Empleado>
			<cfelseif isdefined("form.RHOid")><!---- and not isdefined("form.RHOid")>---->
				<cfset vstitulo = LB_Oferente>
			</cfif>
			
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
				titulo='<cfoutput>#vstitulo#</cfoutput>'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
						<cfset form.DEid = url.DEid>
					</cfif>
					<cfif isdefined("url.RHOid") and not isdefined("form.RHOid")>
						<cfset form.RHOid = url.RHOid>
					</cfif>
					<tr> 
						<td valign="top"  width="40%" nowrap="nowrap"> 
						
						<cf_dbfunction name="date_format" args="RHEfechafin,DD/MM/YYYY" returnvariable ="cCadena">
						<cf_dbfunction name="op_concat" returnvariable ="concat">
						<cf_dbfunction name="length" args="a.RHEtitulo" returnvariable ="LvarLength">
						<cf_dbfunction name="length" args="a.RHEotrains" returnvariable ="LvarLengthInstitu">

						

							<cfif isdefined("form.DEid") and len(trim(form.DEid))>			
								<cfif isdefined('Lvar_EducAuto')>
									<cfset ira = "autogestion.cfm">
								<cfelse>
									<cfset ira = "expediente.cfm">
								</cfif>		
							<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
								<cfset ira = "OferenteExterno.cfm">
							</cfif>	
							
						
												<cfset filtro = "" >
												<form style="margin:0" name="filtro" method="post">
													<table width="40%" cellpadding="2" cellspacing="0" class="areaFiltro">
														
														<tr>
														<td>
																<select id="lb_Educacion" name="lb_Educacion">
																	<option value="0">Ambas</option>
																	<option value="1">Formal</option>
 																	<option value="2">No Formal</option>
																</select>
															</td>
															<td align="center" nowrap>
																<input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>">	
															</td>
															
														</tr>
													</table>
												</form>
							
								<cfif isdefined("form.DEid")>
									<cfset navegacion = "titulo=1&DEid=#form.DEid#&tab=#url.tab#">
									<cfset ira = ira &"?DEid=#form.DEid#&tab=#url.tab#">
								</cfif>	
								<cfif isdefined("form.RHOid")>
									<cfset navegacion = "titulo=1&RHOid=#form.RHOid#d&tab=#url.tab#">
									<cfset ira = ira &"?RHOid=#form.RHOid#d&tab=#url.tab#">
								</cfif>
							
								<cfquery name="rsLista" datasource="#session.DSN#">
								select  a.RHEElinea, 
								case when #LvarLength# > 0 then a.RHEtitulo else '#LB_SinTitulo#' end #concat#' - '#concat# case  when #LvarLengthInstitu# = 0 then coalesce(b.RHIAnombre,'#LB_SinInstitucion#') else coalesce(a.RHEotrains,'##LB_SinInstitucion##') end #concat#' - '#concat# #cCadena# as descripcion,	
										a.RHEfechaini, 
										a.RHEfechafin
											,3 as o, 1 as sel
										<cfif isdefined("form.DEid") and len(trim(form.DEid))>
											,'#form.DEid#' as DEid
											<cfif isdefined('Lvar_EducAuto')>
											, '6' as tab	
											<cfelse>
											, '4' as tab	
											</cfif>	
										<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>	
											,'#form.RHOid#' as RHOid	
										</cfif>
										,a.RHEestado,CASE   
												      WHEN a.RHEnf = 0 THEN 
													  '<img border=''0'' tittle=''Editar''  src=''/cfmx/rh/imagenes/unchecked.gif''>'
												      ELSE 
														'<img border=''0'' tittle=''Editar''  src=''/cfmx/rh/imagenes/checked.gif''>'
												 	END    as RHEnf
								from RHEducacionEmpleado a
									left outer join RHInstitucionesA b
										on a.RHIAid= b.RHIAid
										and a.Ecodigo = b.Ecodigo
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									<cfif isdefined("form.DEid") and len(trim(form.DEid))>
										and  a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
									<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
										and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">	
									</cfif>	
									<cfif isdefined("form.lb_Educacion")>
										<cfif form.lb_Educacion EQ 2>
											and a.RHEnf= 1
										<cfelseif form.lb_Educacion EQ 1>
											and a.RHEnf=0
										</cfif>

									</cfif>
								order by a.RHEfechafin desc
							</cfquery>
												
					
							<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="descripcion, RHEnf"/>
								<cfinvokeargument name="etiquetas" value="#LB_EstudiosRealizados#, #LB_Formal#"/>
								<cfinvokeargument name="formatos" value="V, V"/>
								<cfinvokeargument name="align" value="left, center"/>
								<cfinvokeargument name="ajustar" value="S, S"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="keys" value="RHEElinea,RHEnf"/>
								<cfinvokeargument name="irA" value="#ira#"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="filtro" value="#filtro#"/>
								<cfinvokeargument name="debug" value="S"/>
								<cfinvokeargument name="formName" value="formEducacionLista"/>
							</cfinvoke>
						</td>
						<td width="60%">
							<cfinclude template="educacion-form.cfm">
						</td>
					</tr>
					
				</table>
			<cf_web_portlet_end>
		</td>
	</tr>
	<cfif isdefined("form.DEid") and not isdefined('Lvar_EducAuto') and isdefined('otrosdatos.RHPcodigo')>
	<tr>
		<td>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
				titulo='<cfoutput>#LB_EducacionRequerida#</cfoutput>'>

				<cfquery name="rsvalores" datasource="#session.dsn#">
					select	b.RHECGid, b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGid, c.RHDCGcodigo, c.RHDCGdescripcion,RHVPtipo,
						case RHVPtipo 
							when 10 then '#LB_Deseable#'
							when 20 then '#LB_Intercambiable#'
							when 20 then '#LB_Requerido#'
								else '' end as RHVPtipoDesc
						from RHValoresPuesto a, RHECatalogosGenerales b, RHDCatalogosGenerales c, RHPuestos d
							where coalesce(d.RHPcodigoext,d.RHPcodigo)= <cfqueryparam cfsqltype="cf_sql_char" value="#otrosdatos.RHPcodigo#">
								and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.RHECGid = b.RHECGid
								and a.RHDCGid = c.RHDCGid
								and b.RHECGid = c.RHECGid
								and a.Ecodigo = d.Ecodigo
								and a.RHPcodigo = d.RHPcodigo
					order by b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGcodigo, c.RHDCGdescripcion
				</cfquery>
				
				<table width="75%" cellpadding="3" cellspacing="0" align="center">
					<tr><td>&nbsp;</td></tr>
					<cfoutput query="rsvalores" group="RHECGid">
						<tr><td class="tituloListas">#RHECGdescripcion#</td></tr>
						<cfoutput>
							<tr><td <cfif rsvalores.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RHDCGdescripcion#&nbsp;&nbsp;<cfif LEN(TRIM(RHVPtipo))>(#RHVPtipoDesc#)</cfif></td></tr>
						</cfoutput>
					</cfoutput>
					<tr><td>&nbsp;</td></tr>
				</table>
				<cf_web_portlet_end>
		</td>
	</tr>
	<tr>
		<td>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
				titulo='<cfoutput>#LB_CalificacionDeLaEducacion#</cfoutput>'>
					<cfinclude template="CalificaEducacion.cfm">
			<cf_web_portlet_end>
		</td>
	</tr>
	</cfif>
</table>
