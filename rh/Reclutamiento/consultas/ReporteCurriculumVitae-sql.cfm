
<cfinclude template="../../expediente/consultas/CurriculumVitae.cfm">

<style type="text/css">	
	.reporte label { font-size: 16px; color: #456aba; }		
</style>
 
<cf_templatecss>


<cfset LvarBack = "ReporteCurriculumVitae.cfm">
<!--- Etiquetas de traducción --->
<cfset LB_ReporteCurriculumVitae = t.translate('LB_ReporteCurriculumVitae','Reporte de Curriculum Vitae')>
<cfset LB_FechaCorte = t.translate('LB_FechaCorte','Fecha Corte','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_Apellido1 = t.translate('LB_Apellido1','Apellido1','/rh/generales.xml')>
<cfset LB_Apellido2 = t.translate('LB_Apellido2','Apellido2','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Instituto = t.translate('LB_Instituto','Instituto','/rh/generales.xml')>
<cfset LB_Titulo = t.translate('LB_Titulo','Titulo')>
<cfset LB_Enfasis = t.translate('LB_Enfasis','Enfasis','/rh/generales.xml')>
<cfset LB_Patron = t.translate('LB_Patron','Patrón','/rh/generales.xml')>
<cfset LB_Detalle = t.translate('LB_Detalle','Detalle','/rh/generales.xml')>
<cfset LB_Educacion = t.translate('LB_Educacion','Educación','/rh/generales.xml')>
<cfset LB_Experiencia = t.translate('LB_Experiencia','Experiencia','/rh/generales.xml')>
<cfset LB_Publicacion = t.translate('LB_Publicacion','Publicación','/rh/generales.xml')>
<cfset LB_FinDelReporte = t.translate('LB_FinDelReporte','Fin del Reporte','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>	
<cfset LB_SinDefinir = t.Translate('LB_SinDefinir','Sin definir','/rh/capacitacion/operacion/ActualizacionEstudiosR.xml')>

<cfif isDefined("form.rCurriculum") and len(trim(form.rCurriculum))>
	<cfset tipoReport = '#form.rCurriculum#' /> 
</cfif>

<cfif isDefined("form.sCurriculum") and len(trim(form.sCurriculum))>
	<cfset infoMostrar = '#form.sCurriculum#' />
</cfif>

<cfif isDefined("form.FechaCorte") and len(trim(form.FechaCorte))>
	<cfset vFecha = form.FechaCorte >
	<cfset filtro1 = '<strong>#LB_FechaCorte#</strong>: #form.FechaCorte#'>
<cfelse>
	<cfset vFecha = LSDateFormat(now(),'dd/mm/yyyy') >	
	<cfset filtro1 = ''>
</cfif>		

<cfif isDefined("form.sEstadEmp") and len(trim(form.sEstadEmp))>
	<cfset vEstadEmp = form.sEstadEmp >
<cfelse>
	<cfset vEstadEmp = 2 >	<!--- Todos --->
</cfif>	


<cfif tipoReport eq 1 >	
	<cfif infoMostrar eq 1 >
		<cfset filtro2 = '<strong>#LB_Educacion#</strong>'>
		<cfset lvarCols = 13 >
	<cfelseif infoMostrar eq 2 >
		<cfset filtro2 = '<strong>#LB_Experiencia#</strong>'>
		<cfset lvarCols = 13 >
	<cfelseif infoMostrar eq 3 >	
		<cfset filtro2 = '<strong>#LB_Competencia#</strong>'>
		<cfset lvarCols = 11 >
	<cfelseif infoMostrar eq 4 >
		<cfset filtro2 = '<strong>#LB_Publicacion#</strong>'>
		<cfset lvarCols = 15 >
	</cfif>		
</cfif>

<cfset empresas = "0">
<cfif IsJSON(form.jtreeJsonFormat) and form.jtreejsonformat neq 0 >
    <cfset arrayCorporativo = DeserializeJSON(form.jtreeJsonFormat)>
    <cfif isArray(arrayCorporativo) and arrayLen(arrayCorporativo)> 
        <cfset arrayCorporativo = arrayCorporativo[1]['values']>
        <cfloop array="#arrayCorporativo#" index="i">
            <cfset empresas = listAppend(empresas,i.key)>   
        </cfloop>
     </cfif>
     <cfset form.jtreeJsonFormat = empresas>  
</cfif>
<cfif not len(trim(form.jtreeJsonFormat))>
    <cfset form.jtreeJsonFormat = 0 >
</cfif>


<cfset vListConocimiento = '' >
<cfset vListHabilidad = '' >
<cfset vListNivelCon = '' >
<cfset vListNivelHab = '' >

<cfif isdefined("form.TcodigoListCmp") and len(trim(form.TcodigoListCmp))>
	<cfloop list="#form.TcodigoListCmp#" index="i">
		<cfset vCodComp = listGetAt(i, 1, '_') >
		<cfset vCodNiv = listGetAt(i, 2, '_') >
		<cfset vTipo = listGetAt(i, 3, '_') >

		<cfif compare(vTipo,'C') eq 0>
			<cfset vListConocimiento = listAppend(vListConocimiento,vCodComp)> 
			<cfset vListNivelCon = listAppend(vListNivelCon,vCodNiv)> 
		<cfelse>
			<cfset vListHabilidad = listAppend(vListHabilidad,vCodComp)>
			<cfset vListNivelHab = listAppend(vListNivelHab,vCodNiv)> 
		</cfif>
	</cfloop> 	
</cfif>


<cfif tipoReport eq 1 > <!--- Reporte Curriculum Masivo (1) --->
	<cfset archivo = "ReporteCurriculumVitae.xls" />
	<cfset rsCUVitae = getQueryMasivo() >	

	<cfif rsCUVitae.recordcount>
		<cfswitch expression="#Form.sFormato#">
			<cfcase value="excel"> 
				<cfcontent type="application/vnd.ms-excel; charset=windows-1252">
				<cfheader name="Content-Disposition" value="attachment; filename=#archivo#" >
				<cf_EncReporte	Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF" filtro1="#filtro1#" filtro2="#filtro2#" cols="#lvarCols#">
				<cfoutput>#getHTMLMasivo(rsCUVitae)#</cfoutput>
			</cfcase>
			<cfcase value="html"> 
				<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#">
				<cf_EncReporte Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF" filtro1="#filtro1#" filtro2="#filtro2#" cols="#lvarCols#">	
				<cfoutput>#getHTMLMasivo(rsCUVitae)#</cfoutput>	
				<div align="center" style="margin: 15px 0 15px 0"><strong>*** <cfoutput>#LB_FinDelReporte#</cfoutput> *** </strong></div>
			</cfcase>		
		</cfswitch>	
	<cfelse>	 
		<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#">
		<cf_EncReporte	Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF" filtro1="#filtro1#" filtro2="#filtro2#">	
		<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>	
	</cfif>
<cfelse> <!--- Reporte Curriculum Individual (2) ---> 
	<cfset archivo = "ReporteCurriculumVitae.doc" />
	<cfset rsCUVitaeDG = getQuery() >  <!--- Datos Generales --->

	<cfif rsCUVitaeDG.recordcount>
		<cfswitch expression="#Form.sFormato#">
			<cfcase value="word"> 
				<cfcontent type="application/msword; charset=windows-1252">
				<cfheader name="Content-Disposition" value="attachment; filename=#archivo#" >
				<cf_EncReporte	Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF">
				<cfoutput>
					<div class="CUVitae">
						<!--- Datos Generales --->
						#getHTML(rsCUVitaeDG)#

						<!--- Datos Academicos --->		
						#getHTML(getQuery(1),1)#		
							
						<!--- Experiencia Laboral --->
						#getHTML(getQuery(2),2)#			
							
						<!--- Competencias --->
						#getHTML(getQuery(3),3)#	
						
						<!--- Publicaciones --->
						#getHTML(getQuery(4),4)#		
					</div>	
				</cfoutput>	
			</cfcase>
			<cfcase value="html"> 
				<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#">
				<cf_EncReporte Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF">	
				<cfoutput>
					<div class="CUVitae">
						<!--- Datos Generales --->
						#getHTML(rsCUVitaeDG)#

						<!--- Datos Academicos --->		
						#getHTML(getQuery(1),1)#		
							
						<!--- Experiencia Laboral --->
						#getHTML(getQuery(2),2)#			
							
						<!--- Competencias --->
						#getHTML(getQuery(3),3)#	
						
						<!--- Publicaciones --->
						#getHTML(getQuery(4),4)#		
					</div>	
				</cfoutput>
			</cfcase>		
		</cfswitch>	
	<cfelse>	 
		<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#">
		<cf_EncReporte Titulo="#LB_ReporteCurriculumVitae#" Color="##E3EDEF">	
		<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>	
	</cfif>		
</cfif>	

<cffunction name="getQueryMasivo" returntype="query"> <!--- Reporte Curriculum Vitae Masivo (1) --->
	<!--- Puesto --->
	<cfif isdefined('form.RHPcodigo_Edu') and len(trim(form.RHPcodigo_Edu)) >
		<cfset FiltroRHPcodigo = form.RHPcodigo_Edu > 	
	<cfelseif isdefined('form.RHPcodigo_Exp') and len(trim(form.RHPcodigo_Exp)) >	
		<cfset FiltroRHPcodigo = form.RHPcodigo_Exp > 
	<cfelseif isdefined('form.RHPcodigo_Cmp') and len(trim(form.RHPcodigo_Cmp)) >
		<cfset FiltroRHPcodigo = form.RHPcodigo_Cmp > 	
	<cfelseif isdefined('form.RHPcodigo_Pub') and len(trim(form.RHPcodigo_Pub)) >	
		<cfset FiltroRHPcodigo = form.RHPcodigo_Pub > 
	<cfelse>
		<cfset FiltroRHPcodigo = '' >	
	</cfif>

	<!--- Tipo de Puesto --->
	<cfif isdefined('form.RHTPcodigo_Edu') and len(trim(form.RHTPcodigo_Edu)) >
		<cfset FiltroRHTPcodigo =  form.RHTPcodigo_Edu > 
	<cfelseif isdefined('form.RHTPcodigo_Exp') and len(trim(form.RHTPcodigo_Exp)) >
		<cfset FiltroRHTPcodigo =  form.RHTPcodigo_Exp > 
	<cfelseif isdefined('form.RHTPcodigo_Cmp') and len(trim(form.RHTPcodigo_Cmp)) >
		<cfset FiltroRHTPcodigo =  form.RHTPcodigo_Cmp > 
	<cfelseif isdefined('form.RHTPcodigo_Pub') and len(trim(form.RHTPcodigo_Pub)) >
		<cfset FiltroRHTPcodigo =  form.RHTPcodigo_Pub >	
	<cfelse>
		<cfset FiltroRHTPcodigo = '' >	
	</cfif>

	<!--- Grado --->
	<cfif isdefined('form.GAnombre_Edu') and len(trim(form.GAnombre_Edu)) >
		<cfset FiltroGAnombre =  form.GAnombre_Edu >
	<cfelse>
		<cfset FiltroGAnombre = '' >	
	</cfif>

	<!--- Titulo Obtenido --->
	<cfif isdefined('form.RHOTid_Edu') and len(trim(form.RHOTid_Edu)) >
		<cfset FiltroRHOTid =  form.RHOTid_Edu >
	<cfelse>
		<cfset FiltroRHOTid = 0 >	
	</cfif>

	<!--- Enfasis --->
	<cfif isdefined('form.RHOEid_Edu') and len(trim(form.RHOEid_Edu)) >
		<cfset FiltroRHOEid =  form.RHOEid_Edu >
	<cfelse>
		<cfset FiltroRHOEid = '' >	
	</cfif>

	<!--- Centro funcional --->
	<cfif isdefined('form.CFcodigo_Edu') and len(trim(form.CFcodigo_Edu)) >
		<cfset FiltroCFcodigo =  form.CFcodigo_Edu >
	<cfelseif isdefined('form.CFcodigo_Exp') and len(trim(form.CFcodigo_Exp)) >	
		<cfset FiltroCFcodigo =  form.CFcodigo_Exp >
	<cfelseif isdefined('form.CFcodigo_Cmp') and len(trim(form.CFcodigo_Cmp)) >	
		<cfset FiltroCFcodigo =  form.CFcodigo_Cmp >	
	<cfelseif isdefined('form.CFcodigo_Pub') and len(trim(form.CFcodigo_Pub)) >	
		<cfset FiltroCFcodigo =  form.CFcodigo_Pub >
	<cfelse>
		<cfset FiltroCFcodigo = '' >		
	</cfif>

	<!--- Tipo de empleado --->
	<cfif isdefined('form.TEcodigo_Edu') and len(trim(form.TEcodigo_Edu)) >
		<cfset FiltroTEcodigo = form.TEcodigo_Edu >     
	<cfelseif isdefined('form.TEcodigo_Exp') and len(trim(form.TEcodigo_Exp)) >
		<cfset FiltroTEcodigo = form.TEcodigo_Exp > 
	<cfelseif isdefined('form.TEcodigo_Cmp') and len(trim(form.TEcodigo_Cmp)) >
		<cfset FiltroTEcodigo = form.TEcodigo_Cmp >	
	<cfelseif isdefined('form.TEcodigo_Pub') and len(trim(form.TEcodigo_Pub)) >
		<cfset FiltroTEcodigo = form.TEcodigo_Pub >	
	<cfelse>
		<cfset FiltroTEcodigo = '' >					
	</cfif>

	<!--- Tipo de publicacion --->
	<cfset FiltroRHPTcodigo = 0 >
	<cfif isdefined('form.RHPTcodigo') and len(trim(form.RHPTcodigo)) >
		<cfset FiltroRHPTcodigo = form.RHPTcodigo > 
	</cfif>	


	<cf_translatedata tabla="Empresas" col="e.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
	<cf_translatedata tabla="RHPuestos" col="rhpt.RHPdescpuesto" name="get" returnvariable="LvarRHPdescpuesto"/>
	<cf_translatedata tabla="RHTPuestos" col="rhtp.RHTPdescripcion" name="get" returnvariable="LvarRHTPdescripcion"/>
	<cf_translatedata tabla="GradoAcademico" col="ga.GAnombre" name="get" returnvariable="LvarGAnombre"/>
	<cf_translatedata tabla="RHOEnfasis" col="rhoe.RHOEDescripcion" name="get" returnvariable="LvarRHOEDescripcion"/>

	<cf_translatedata tabla="RHConocimientos" col="rhc.RHCdescripcion" name="get" returnvariable="LvarRHCdescripcion"/>
	<cf_translatedata tabla="RHHabilidades" col="rhh.RHHdescripcion" name="get" returnvariable="LvarRHHdescripcion"/>
	<cf_translatedata tabla="TiposEmpleado" col="te.TEdescripcion" name="get" returnvariable="LvarTEdescripcion"/>
	<cf_translatedata tabla="CFuncional" col="cf.CFdescripcion" name="get" returnvariable="LvarCFdescripcion"/>
	<cf_translatedata tabla="RHNiveles" col="rhn.RHNdescripcion" name="get" returnvariable="LvarRHNdescripcion"/>
	<cf_translatedata tabla="RHPublicacionTipo" col="RHPubT.RHPTDescripcion" name="get" returnvariable="LvarRHPTDescripcion"/>

	<cfquery name="rsCUVitae" datasource="#session.DSN#">
		select de.Ecodigo, #LvarEdescripcion# as Empresa, de.DEidentificacion, de.DEnombre as Nombre, de.DEapellido1 as Apellido1, de.DEapellido2 as Apellido2, #LvarRHPdescpuesto# as Puesto, #LvarRHTPdescripcion# as Tipo, 

		<cfif infoMostrar eq 1 >  <!--- Educacion (1) --->
			coalesce(rhi.RHIAnombre,rhee.RHEotrains) as Instituto, #LvarGAnombre# as Grado, rhee.RHEtitulo as Titulo, #LvarRHOEDescripcion# as Enfasis, rhee.RHEfechaini as Desde, rhee.RHEfechafin as Hasta, 1 as TipoCompetencia,
		<cfelseif infoMostrar eq 2 >  <!--- Experiencia (2) --->	
			rhee.RHEEnombreemp as Patron, rhee.RHEEpuestodes as Puesto_Desempenado, 
			case rhee.RHEEmotivo
			    When 0 Then '#LB_Renuncia#'
			    When 10 Then '#LB_Despido#'
			    When 20 Then '#LB_FinalizacionDeContrato#'
			    When 30 Then '#LB_FinDeProyecto#'
			    When 40 Then '#LB_CierreDeOperaciones#'
			    else '#LB_Otros#'
			end as Motivo, rhee.RHEEAnnosLab as Annos, rhee.RHEEfechaini as Desde, rhee.RHEEfecharetiro as Hasta, 1 as TipoCompetencia,						
		<cfelseif infoMostrar eq 3 >  <!--- Competencia (3) --->
			rhce.Descripcion, rhce.Nivel, rhce.RHCEdominio as Dominio, rhce.RHCEfdesde as Desde, year(rhce.RHCEfdesde) as YearDesde, rhce.RHCEfhasta as Hasta, rhce.RHCEjustificacion as Justificacion, rhce.tipo as TipoCompetencia,
		<cfelseif infoMostrar eq 4 >  <!--- Publicacion (4) --->
			#LvarRHPTDescripcion# as TipoPublicacion, RHPub.RHPTitulo as TituloPublicacion, RHPub.RHPAnoPub as AnoPublicacion, RHPub.RHPPublicadoEn as PublicadoEn, RHPub.RHPEditorial as Editorial, RHPub.RHPLugar as Lugar, RHPub.RHPEnlaceWebPub as EnlaceWebPub, RHPub.RHPCoautores as Coautores, 1 as TipoCompetencia,
		</cfif>

		#LvarCFdescripcion# as CtroFuncional, #LvarTEdescripcion# as Tipo_Empleado
		from DatosEmpleado de
			inner join Empresas e
			    on de.Ecodigo = e.Ecodigo
			inner join TiposEmpleado te
			    on de.TEid = te.TEid
				<cfif len(FiltroTEcodigo)>
                    and te.TEcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FiltroTEcodigo#%">   
                </cfif>
		
		<cfif infoMostrar eq 1 >  <!--- Educacion (1) --->    
			inner join RHEducacionEmpleado rhee
			    on de.DEid = rhee.DEid 
			    and de.Ecodigo = rhee.Ecodigo 
                <cfif FiltroRHOTid GT 0 >
                    and rhee.RHOTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FiltroRHOTid#">   
                </cfif>
			    left join RHOEnfasis rhoe
			        on rhee.RHOEid = rhoe.RHOEid
                    <cfif FiltroRHOEid GT 0 >
                    	and rhee.RHOEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FiltroRHOEid#">   
                    </cfif>
			    left join RHInstitucionesA rhi    
			        on rhee.RHIAid = rhi.RHIAid
			    left join GradoAcademico ga       
			        on rhee.GAcodigo = ga.GAcodigo
                    <cfif len(FiltroGAnombre)> 
	                    and ga.GAnombre like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FiltroGAnombre#%">   
                    </cfif> 
                    
    	<cfelseif infoMostrar eq 2 >  <!--- Experiencia (2) --->	
	    	inner join RHExperienciaEmpleado rhee 
	    		on de.DEid = rhee.DEid 
                <cfif isdefined('form.Annos') and len(form.Annos) GT 0 >
                    and rhee.RHEEAnnosLab >= <cfqueryparam cfsqltype="cf_sql_float" value="#form.Annos#">   
                </cfif>
                
    	<cfelseif infoMostrar eq 3 > <!--- Competencia (3) --->
			inner join 
			(
				<cfif len(vListConocimiento) or (len(vListConocimiento) eq 0 and len(vListHabilidad) eq 0)>
				    select #LvarRHCdescripcion# as Descripcion, #LvarRHNdescripcion# as Nivel, rhce.RHCEdominio, rhce.RHCEfdesde, 
				    rhce.RHCEfhasta, rhce.RHCEjustificacion, rhce.tipo, rhce.RHNid, rhce.DEid, rhce.Ecodigo
				    from
				        RHCompetenciasEmpleado rhce 
				    inner join RHConocimientos rhc 
				        on rhce.idcompetencia = rhc.RHCid
				        and rhce.Ecodigo = rhc.Ecodigo
				        and rhce.tipo = 'C'    
				    inner join RHNiveles rhn
			    		on rhce.RHNid = rhn.RHNid    
				    where rhce.RHCEfdesde = (select max(RHCEfdesde) from RHCompetenciasEmpleado rhce2 
				    							where rhce.DEid = rhce2.DEid
				    							and rhce.idcompetencia = rhce2.idcompetencia ) 
				    <cfif len(vListConocimiento) gt 0>							  
					   	and(
					    <cfloop index="i" from="1" to="#listLen(vListConocimiento)#">
						    <cfif listGetAt(vListConocimiento,i) gt 0 > <!--- No se selecciono todos conocimientos --->
						    (
						    	rhc.RHCcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListConocimiento,i)#%">

						    	<cfif listGetAt(vListNivelCon,i) gt 0 > <!--- No se selecciono todos niveles conocimientos --->
						    		and rhn.RHNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListNivelCon,i)#%">
						    	</cfif>
						    )
						    <cfelse>  <!--- Se selecciono todos conocimientos --->
						    	<cfif listGetAt(vListNivelCon,i) gt 0 >  <!--- No se selecciono todos niveles conocimientos --->
						    		rhn.RHNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListNivelCon,i)#%">
						    	<cfelse>
						    		1=1	
						    	</cfif>
						    </cfif>
						    <cfif compare(listLast(vListConocimiento), listGetAt(vListConocimiento,i)) neq 0 > or </cfif>
						</cfloop>
						)
					</cfif>	
			    </cfif>	
			    						 
			    <cfif (len(vListConocimiento) and len(vListHabilidad)) or (len(vListConocimiento) eq 0 and len(vListHabilidad) eq 0)> union all 
			    </cfif>

			    <cfif len(vListHabilidad) or (len(vListHabilidad) eq 0 and len(vListConocimiento) eq 0) >
				    select #LvarRHHdescripcion# as Descripcion, #LvarRHNdescripcion# as Nivel, rhce.RHCEdominio, rhce.RHCEfdesde,
				    rhce.RHCEfhasta, rhce.RHCEjustificacion, rhce.tipo, rhce.RHNid, rhce.DEid, rhce.Ecodigo
				    from
				        RHCompetenciasEmpleado rhce    
				    inner join RHHabilidades rhh
				        on rhce.idcompetencia = rhh.RHHid
				        and rhce.Ecodigo = rhh.Ecodigo
				        and rhce.tipo = 'H'
			        inner join RHNiveles rhn
			    		on rhce.RHNid = rhn.RHNid
				    where rhce.RHCEfdesde = (select max(RHCEfdesde) from RHCompetenciasEmpleado rhce2 
				    							where rhce.DEid = rhce2.DEid
				    							and rhce.idcompetencia = rhce2.idcompetencia ) 
				    <cfif len(vListHabilidad) gt 0>
					    and(
					    <cfloop index="i" from="1" to="#listLen(vListHabilidad)#">
						    <cfif listGetAt(vListHabilidad,i) gt 0 > <!--- No se selecciono todas habilidades --->
						    (
						    	rhh.RHHcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListHabilidad,i)#%">

						    	<cfif listGetAt(vListNivelHab,i) gt 0 > <!--- No se selecciono todos niveles habilidades --->
						    		and rhn.RHNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListNivelHab,i)#%">
						    	</cfif>
						    )
						    <cfelse>  <!--- Se selecciono todas habilidades --->
						    	<cfif listGetAt(vListNivelHab,i) gt 0 >  <!--- No se selecciono todos niveles habilidades --->
						    		rhn.RHNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listGetAt(vListNivelHab,i)#%">
						    	<cfelse>
						    		1=1	
						    	</cfif>
						    </cfif>
						    <cfif compare(listLast(vListHabilidad), listGetAt(vListHabilidad,i)) neq 0 > or </cfif>
						</cfloop>
						)	
					</cfif>
			    </cfif>	
			)rhce
				on de.DEid = rhce.DEid
				and de.Ecodigo = rhce.Ecodigo

		<cfelseif infoMostrar eq 4 > <!--- Publicacion (4) --->
			inner join RHPublicaciones RHPub	  
				on de.DEid = RHPub.DEid   
				and RHPub.RHPEstado = 1  
				inner join RHPublicacionTipo RHPubT   
					on RHPub.RHPTid = RHPubT.RHPTid
					<cfif FiltroRHPTcodigo GT 0 >
                        and RHPubT.RHPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#FiltroRHPTcodigo#">   
                    </cfif>		 
		</cfif>

			inner join LineaTiempo lt
			    on de.DEid = lt.DEid     
			    and de.Ecodigo = lt.Ecodigo 
			    inner join RHPlazas rhpz
			        on lt.RHPid = rhpz.RHPid 
			        inner join CFuncional cf
			            on rhpz.CFid = cf.CFid
                        <cfif len(FiltroCFcodigo)>
                            and cf.CFcodigo like <cfqueryparam cfsqltype="cf_sql_char" value="%#FiltroCFcodigo#%">   
                        </cfif>
			    inner join RHPuestos rhpt
			        on rhpz.Ecodigo = rhpt.Ecodigo    
			        and rhpz.RHPpuesto = rhpt.RHPcodigo
                    <cfif len(FiltroRHPcodigo)>
                        and rhpt.RHPcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FiltroRHPcodigo#%">   
                    </cfif>
			        left join RHTPuestos rhtp
			            on rhpt.RHTPid = rhtp.RHTPid
                        <cfif len(FiltroRHTPcodigo)>
                            and rhtp.RHTPcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FiltroRHTPcodigo#%">   
                        </cfif>
                        
		where de.Ecodigo in (<cfif not isDefined("form.esCorporativo")>
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                        <cfelse>    
                            <cfif form.jtreeJsonFormat neq 0 >
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeJsonFormat#" list="true">
                            <cfelse>
                                select Ecodigo from Empresas where
                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
                            </cfif>
                        </cfif>
                    )
		
		<cfif vEstadEmp eq 1 >  <!--- Empleados activos --->
			and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#vFecha#"> between lt.LTdesde and lt.LThasta
		<cfelseif vEstadEmp eq 0 >  <!--- Empleados inactivos --->
			and not exists (select 1 from LineaTiempo t where t.DEid = de.DEid and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#vFecha#"> between t.LTdesde and t.LThasta)
		<cfelse> <!--- Todos Empleados activos/inactivos --->
			and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#vFecha#"> between lt.LTdesde and lt.LThasta
			and exists (select 1 from LineaTiempo t where t.DEid = de.DEid and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#vFecha#"> NOT between t.LTdesde and t.LThasta)	
		</cfif>
	</cfquery>
 
	<cfquery name="rsCUVitae" dbtype="query">
		select distinct *
		from rsCUVitae
		<cfif infoMostrar neq 4>  
			order by 
				<cfif infoMostrar eq 1 or infoMostrar eq 2 > 
					Ecodigo, Apellido1, Apellido2, Nombre, Desde 
				<cfelseif infoMostrar eq 3 >
					Ecodigo, TipoCompetencia asc, Apellido1, Apellido2, Nombre, Desde 
				</cfif> desc		
		<cfelse>		
			order by Ecodigo, Apellido1, Apellido2, Nombre, 7
		</cfif>	
	</cfquery>

	<cfreturn rsCUVitae>
</cffunction>	

<cffunction name="getHTMLMasivo" output="true"> <!--- Reporte Curriculum Vitae Masivo (1) --->
	<cfargument name="rsCUVitae" type="query" required="true">

	<cfif isDefined("form.chk_CUResumido") and LEN(TRIM(form.chk_CUResumido))>
		<cfset detalleReport = 'Resumido' />
	</cfif>	

	<cfif isDefined("form.chk_CUDetallado") and LEN(TRIM(form.chk_CUDetallado))>
		<cfset detalleReport = 'Detallado' />
	</cfif>
 
	<table class="reporte" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<cfoutput query='Arguments.rsCUVitae' group="TipoCompetencia">
			<thead>
				<cfif infoMostrar eq 3 >  <!--- Competencia (3) --->
					<cfif compare("#TipoCompetencia#", "C") eq 0 >
						<tr style="border-style: hidden;"><td colspan="13">&nbsp;</td></tr>
						<cfset lbCompetencia = LB_Conocimientos />
					<cfelse>
						<cfset lbCompetencia = LB_Habilidades />	
					</cfif>	
					<tr><td colspan="13"><label>#lbCompetencia#</label></td></tr>	
				</cfif>
				<tr>
					<th><strong>#LB_Empresa#</strong></th>
					<th><strong>#LB_Identificacion#</strong></th>
		            <th><strong>#LB_Nombre#</strong></th> 
		            <th><strong>#LB_Apellido1#</strong></th>
		            <th><strong>#LB_Apellido2#</strong></th>   
		            <th><strong>#LB_Puesto#</strong></th> 
		            <th><strong>#LB_Tipo#</strong></th> 

		        <cfif infoMostrar eq 1 >  <!--- Educacion (1) --->
					<th><strong>#LB_Instituto#</strong></th> 
					<th><strong>#LB_Grado#</strong></th> 	
					<th><strong>#LB_Titulo#</strong></th> 
					<th><strong>#LB_Enfasis#</strong></th>
				<cfelseif infoMostrar eq 2 >  <!--- Experiencia (2) --->
		        	<th><strong>#LB_Patron#</strong></th>
		        	<th><strong>#LB_PuestoDesempenado#</strong></th>
		        	<th><strong>#LB_MotivoSalida#</strong></th>
		        	<th><strong>#LB_AnosLaborados#</strong></th>
		        <cfelseif infoMostrar eq 3 >  <!--- Competencia (3) --->
		        	<cfif compare("#TipoCompetencia#", "C") eq 0 >
		        		<th><strong>#LB_NombreConocimiento#</strong></th>	
		        	<cfelse>
		        		<th><strong>#LB_NombreHabilidad#</strong></th>	
		        	</cfif>	
		        	<th><strong>#LB_Nivel#</strong></th>
		        	<th><strong>#LB_Dominio#</strong></th>
		        <cfelseif infoMostrar eq 4 >  <!--- Publicacion (4) --->
		        	<th><strong>#LB_TituloPublicacion#</strong></th>	
		        	<th><strong>#LB_TipoPublicacion#</strong></th>
		        	<th><strong>#LB_Ano#</strong></th>	
		        	<th><strong>#LB_PublicadoEn#</strong></th>	
		        	<th><strong>#LB_Editorial#</strong></th>	
		        	<th><strong>#LB_Lugar#</strong></th>	
		        	<th><strong>#LB_EnlaceWebPublicacion#</strong></th>
		        	<th><strong>#LB_PublicadoCooperacion#</strong></th>
		        </cfif>	

				<cfif infoMostrar neq 4 >  <!--- Si NO es Publicacion --->
					<th><strong>#LB_Desde#</strong></th> 
					<cfif infoMostrar neq 3>  <!--- Si NO es Competencia --->
						<th><strong>#LB_Hasta#</strong></th>
					</cfif>
				</cfif>
		        	<th><strong>#LB_CentroFuncional#</strong></th>
					<th><strong>#LB_TipoEmpleado#</strong></th>
				</tr>
			</thead>
			<cfoutput>
				<tbody>	
					<tr>
						<td align='left'>#Empresa#</td>
						<td align='left'>#DEidentificacion#</td>
						<td align='left'>#Nombre#</td>
						<td align='left'>#Apellido1#</td>
						<td align='left'>#Apellido2#</td>
						<td align='left'>#Puesto#</td>
						<td align='left'>#Tipo#</td>

					<cfif infoMostrar eq 1 >  <!--- Educacion (1) --->
						<td align='left'>#Instituto#</td>
						<td align='left'>#Grado#</td>
						<td align='left'>#Titulo#</td>
						<td align='left'>#Enfasis#</td>
					<cfelseif infoMostrar eq 2 >  <!--- Experiencia (2) --->	
						<td align='left'>#Patron#</td>
						<td align='left'>#Puesto_Desempenado#</td>
						<td align='left'>#Motivo#</td>
						<td align='left'>#Annos#</td>
					<cfelseif infoMostrar eq 3 >  <!--- Competencia (3) --->
						<td align='left'>#Descripcion#</td>	
						<td align='left'>#Nivel#</td>
						<td align='right'>#int(Dominio)# %</td>
					<cfelseif infoMostrar eq 4 >  <!--- Publicacion (4) --->	
						<td align='left'>#TituloPublicacion#</td>	
						<td align='left'>#TipoPublicacion#</td>
						<td align='left'>#AnoPublicacion#</td>
						<td align='left'>#PublicadoEn#</td>
						<td align='left'>#Editorial#</td>
						<td align='left'>#Lugar#</td>
						<td align='left'>#EnlaceWebPub#</td>
						<td align='left'>#Coautores#</td>
					</cfif>
					
					<cfif infoMostrar neq 4 >  <!--- Si NO es Publicacion --->
						<td align='left'>
							<cfif infoMostrar eq 3> <!--- Competencia (3) --->
								#YearDesde#
							<cfelse>	
								<cf_locale name="date" value="#Desde#"/>
							</cfif>		
						</td> 
						<cfif infoMostrar neq 3>  <!--- Si NO es Competencia --->
							<td align='left'><cf_locale name="date" value="#Hasta#"/></td>
						</cfif>		
					</cfif>		
						<td align='left'>#CtroFuncional#</td>
						<td align='left'>#Tipo_Empleado#</td>
					</tr>	
				</tbody>
			</cfoutput>
			<cfif infoMostrar eq 3 and compare("#TipoCompetencia#", "C") eq 0 >
				<tr><td colspan="13">&nbsp;</td></tr>	
				<tr style="border-style: hidden;"><td colspan="13">&nbsp;</td></tr>
			</cfif>	
		</cfoutput>	
	</table>
</cffunction>