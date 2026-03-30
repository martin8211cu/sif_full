
<style type="text/css">
	.well { padding: 25px 10px 25px 10px; margin-top: 10px; margin-bottom: 15px; }
	.rpMasivo { margin-left: 170px; }
	.rpIndividual { margin-left: 42px; }
    .CUMasivo, .CUIndividual, .curriculum, .filters, .lbCoorp, .formato, .btnsReport, .alert, .addCmp, .detailCompet, 
    .detailNivel { display: none; }
    .filters { margin-left: 175px; margin-top: 15px; }
    .detailCompet, .detailNivel { margin-left: 222px; }
    .filters .fechCorte { float: left; margin-right: 60px; }
    .selectCompetenc select, .selectNiveles select { margin-right: 10px; }
    .lbel { float: left; margin-left: 75px; margin-right: 5px; width: 140px; }
    .lbel label { float: right; }
    .curriculum select { margin-left: 38%; }
    .curriculum, .educacion, .experiencia, .competencia, .publicacion, .tipoReport { margin-bottom: 5px;}
    .empleado { margin-left: 250px; }
    .empleado label { float: left; margin-right: 5px; }
	.CUResumido, .CUDetallado { width: 120px; float: left; }
	.CUResumido { margin-left: 36%; }
	.CUDetallado { margin-left: 10px; }
    .lbCoorp { margin-left: 175px; }
    .divArbol { margin-left: 170px; display:none; margin-top: -15px;}
    .divArbol .listTree { width: 60% } 
    .encabezado, .detListCompet { margin-left: -2px; width: 67%; }
    .encabezado div { background-color: #B0C8D3; padding-top: 4px; height: 28px; margin-bottom: 0; }
    .encabezado div label { margin-left: -10px; }
    .detListCompet { max-height: 16em; overflow-y: auto; overflow-x: hidden; margin-top: -20px; }
    .detListCompet .row, .detListCompet .row div { height: 35px; margin-bottom: 0; }
    .detListCompet div { padding-top: 3px; padding-bottom: 3px; font-weight: normal; } 
    .detListCompet .row .btn { margin-left: 10px; }
	.formato { clear: both; }
	.fmtReport { margin-left: 38%; }
	.buttons { margin-left: 38%; margin-top: 5px; }
	.buttons a { margin-right: 4px; }
	.alert { position: fixed; top: 40%; right: 38%; width: 330px !important; }
	input[type=radio], input[type=checkbox] { margin-right: 2px; }
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_ReporteCurriculumMasivo = t.translate('LB_ReporteCurriculumMasivo','Reporte Curriculum Masivo')>
<cfset LB_ReporteCurriculumIndividual = t.translate('LB_ReporteCurriculumIndividual','Reporte Curriculum Individual')>
<cfset LB_SelectOpcion = t.translate('LB_SelectOpcion','Seleccione una opción','/rh/generales.xml')>
<cfset LB_Educacion = t.translate('LB_Educacion','Educación','/rh/generales.xml')>
<cfset LB_Experiencia = t.translate('LB_Experiencia','Experiencia','/rh/generales.xml')>
<cfset LB_Competencia = t.translate('LB_Competencia','Competencia','/rh/generales.xml')>
<cfset LB_Publicacion = t.translate('LB_Publicacion','Publicación','/rh/generales.xml')>
<cfset LB_FechaCorte = t.translate('LB_FechaCorte','Fecha Corte','/rh/generales.xml')>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_Resumido = t.translate('LB_Resumido','Resumido','/rh/generales.xml')>
<cfset LB_Detallado = t.translate('LB_Detallado','Detallado','/rh/generales.xml')>
<cfset LB_Formato = t.translate('LB_Formato','Formato','/rh/generales.xml')>
<cfset LB_HTML = t.translate('LB_HTML','HTML','/rh/generales.xml')>
<cfset LB_Excel = t.translate('LB_Excel','Excel','/rh/generales.xml')>
<cfset LB_Word = t.translate('LB_Word','Word','/rh/generales.xml')>
<cfset LB_EsCorporativo = t.translate('LB_EsCorporativo','Es Corporativo','/rh/generales.xml')>
<cfset LB_EstadoDeEmpleado  = t.translate('LB_EstadoDeEmpleado','Estado de Empleado','/rh/generales.xml')>
<cfset LB_Todos  = t.translate('LB_Todos','Todos','/rh/generales.xml')>
<cfset LB_Activo  = t.translate('LB_Activo','Activo','/rh/generales.xml')>
<cfset LB_Inactivo  = t.translate('LB_Inactivo','Inactivo','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>

<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion  = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Nivel = t.translate('LB_Nivel','Nivel','/rh/generales.xml')>
<cfset LB_SeleccioneTipo = t.translate('LB_SeleccioneTipo','Seleccione tipo')>
<cfset LB_Conocimiento = t.translate('LB_Conocimiento','Conocimiento','/rh/generales.xml')>
<cfset LB_Habilidad = t.translate('LB_Habilidad','Habilidad','/rh/generales.xml')>
<cfset LB_SeleccioneCompetencia = t.translate('LB_SeleccioneCompetencia','Seleccione competencia')>
<cfset LB_SeleccioneNivel = t.translate('LB_SeleccioneNivel','Seleccione nivel')>
<cfset LB_Puesto = t.translate('LB_Puesto','Puesto','/rh/generales.xml')>
<cfset LB_ListaDePuestos = t.translate('LB_ListaDePuestos','Lista de Puestos','/rh/generales.xml')>
<cfset LB_TipoDePuesto = t.translate('LB_TipoDePuesto','Tipo de puesto','/rh/generales.xml')>
<cfset LB_ListaDeTiposDePuesto = t.translate('LB_ListaDeTiposDePuesto','Lista de Tipo de puesto','/rh/generales.xml')>


<cfset LB_TipoPublicacion = t.translate('LB_TipoPublicacion','Tipo de Publicación','/rh/generales.xml')>
<cfset LB_ListaDeTiposDePublicacion = t.translate('LB_ListaDeTiposDePublicacion','Lista de Tipos de publicación','/rh/generales.xml')>

<cfset LB_Grado = t.translate('LB_Grado','Grado','/rh/generales.xml')>
<cfset LB_ListaDeGrado = t.translate('LB_ListaDeGrado','Lista de Grado','/rh/generales.xml')>

<cfset LB_TituloObtenido = t.translate('LB_TituloObtenido','Titulo Obtenido','/rh/generales.xml')>
<cfset LB_ListaTitulosObtenidos = t.translate('LB_ListaTitulosObtenidos','Lista de Titulos Obtenido','/rh/generales.xml')>

<cfset LB_Enfasis = t.translate('LB_Enfasis','Enfasis','/rh/generales.xml')>
<cfset LB_ListaEnfasis = t.translate('LB_ListaEnfasis','Lista de Enfasis','/rh/generales.xml')>

<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_ListaDeCentroFuncional = t.translate('LB_ListaDeCentroFuncional','Lista de Centros Funcionales','/rh/generales.xml')>
<cfset LB_Oficina = t.translate('LB_Oficina','Oficina','/rh/generales.xml')>
<cfset LB_Departamento = t.translate('LB_Departamento','Departamento','/rh/generales.xml')>

<cfset LB_TipoEmpleado = t.translate('LB_TipoEmpleado','Tipo Empleado','/rh/generales.xml')>
<cfset LB_ListaDeTipoEmpleado = t.translate('LB_ListaDeTipoEmpleado','Lista de Tipo Empleado','/rh/generales.xml')>

<cfset LB_AnnosExperiencia = t.translate('LB_AnnosExperiencia','Años de Experiencia','/rh/generales.xml')>


<cfset MSG_Consultar = t.translate('MSG_Consultar','Consulta los datos del tipo de curriculum seleccionado')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_Empleado = t.translate('MSG_Empleado','Debe seleccionar un empleado para realizar la consulta')>
<cfset MSG_InfoCurriculum = t.translate('MSG_InfoCurriculum','Debe seleccionar el tipo de información que desea consultar')>
<cfset MSG_TipoCurriculum = t.translate('MSG_TipoCurriculum','Debe seleccionar el tipo de curriculum que desea consultar')>
<cfset MSG_AddCompetenciaNivel = t.translate('MSG_AddCompetenciaNivel','Agrega la competencia y el nivel seleccionado')>
<cfset MSG_Competencia = t.translate('MSG_Competencia','Debe seleccionar una competencia para agregar a la consulta')>
<cfset MSG_Nivel = t.translate('MSG_Nivel','Debe seleccionar un nivel para agregar a la consulta')>
<cfset MSG_InfoCurriculum = t.translate('MSG_InfoCurriculum','Debe seleccionar el tipo de información que desea consultar')>


<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfquery name="rsPmtConsCorp" datasource="#Session.DSN#">
    select Pvalor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2715
</cfquery>

<cfif rsPmtConsCorp.recordCount gt 0 and rsPmtConsCorp.Pvalor eq '1'>
    <cfset lvPmtConsCorp = 1 >
<cfelse>
    <cfset lvPmtConsCorp = 0 >  
</cfif>

 
<div class="well">
	<form action="ReporteCurriculumVitae-sql.cfm" method="post" name="form1">
		<cfoutput>
            <!--- Seleccion del Tipo de Reporte: Masivo/Individual --->
            <div class="form-group row">
                <div class="col-sm-6">
                    <div class="rpMasivo radio">
                        <label>
                          <input type="radio" name="rCurriculum" value="1" onClick="fnChanceSelect(this)"/> <b/>#LB_ReporteCurriculumMasivo# 
                        </label>
                    </div>
                </div>  
                <div class="col-sm-6">
                    <div class="rpIndividual radio">
                        <label>
                          <input type="radio" name="rCurriculum" value="2" onClick="fnChanceSelect(this)"/> <b/>#LB_ReporteCurriculumIndividual#
                        </label>
                    </div>
                </div>  
            </div>  

            <!--- Seleccion del Tipo de Informacion a mostrar para Reporte Masivo --->
            <div class="form-group row curriculum">
                <div class="col-sm-12">
                    <select name="sCurriculum" id="sCurriculum">
                        <option value="">#LB_SelectOpcion#</option>
                        <option value="1">#LB_Educacion#</option>
                        <option value="2">#LB_Experiencia#</option>
                        <option value="3">#LB_Competencia#</option>
                        <option value="4">#LB_Publicacion#</option>
                    </select>   
                </div>
            </div> 

            <!--- Seleccion de la Fecha de Corte y del tipo de estado de los empleados --->
            <div class="form-group row filters">
                <div class="col-sm-12">
                    <div class="fechCorte">
                        <span><strong>#LB_FechaCorte#:</strong></span>
                        <cf_sifcalendario form="form1" tabindex="1" name="FechaCorte" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    </div>       
                    <div class="estadEmp">
                        <label><strong>#LB_EstadoDeEmpleado#:</strong></label>
                        <select name="sEstadEmp">
                            <option value="">#LB_Todos#</option> 
                            <option value="1">#LB_Activo#</option> 
                            <option value="0">#LB_Inactivo#</option> 
                        </select>       
                    </div> 
                </div>
            </div>      

            <!--- Valida si esta habilitado las consultas corporativas --->
            <cfif lvPmtConsCorp eq 1>
                <!--- Check de consulta corporativa --->
                <div class="form-group row lbCoorp">
                    <div class="col-sm-12">
                        <label>
                            <input type="checkbox" name="esCorporativo" id="esCorporativo" onClick="fnShowTree()"> <strong>#LB_EsCorporativo#?</strong>
                        </label>
                    </div>  
                </div>
            </cfif>

            <!--- Lista de empresas que pertenecen a una coorporacion --->
            <div class="form-group row">
                <div class="col-sm-12 divArbol">
                    <cfquery datasource="#session.dsn#" name="datosArbol" maxrows="50">
                        select e.Edescripcion, e.Ecodigo
                        from Empresas e
                        where cliente_empresarial = #session.CEcodigo#
                        order by e.Edescripcion
                    </cfquery>

                    <cfsavecontent variable="data">
                    {
                        "key":"0",
                        "label":"<cf_translate key="LB_TodasLasEmpresas" xmlFile="/rh/generales.xml">Todas las Empresas</cf_translate>",
                        "values":[
                                    <cfloop query="datosArbol">
                                    {
                                        "key": "#trim(Ecodigo)#",
                                        "label": "#trim(Edescripcion)#"
                                    }
                                    <cfif currentrow neq recordcount>,</cfif>
                                    </cfloop>
                                ]
                    }
                    </cfsavecontent>
                    <cf_jtree data="#data#">
                </div>      
            </div>

            <!--- Filtros y Selecciones del Reporte Curiculum Vitae Masivo para la consulta --->
            <div class="CUMasivo">
                <!--- Filtros que se muestran si se selecciona la opcion Educacion para la consulta del reporte --->
                <div class="educacion">
                    <!--- Filtro de Seleccion de Puesto --->
                    #getDivPuesto('Edu')#

                    <!--- Filtro de Seleccion del Tipo de Puesto ---> 
                    #getDivTipoPuesto('Edu')#
   
                    <!--- Filtro de Seleccion del Grado Academico ---> 
                    #getDivGradAcadem('Edu')#   
                    
                    <!--- Filtro de Seleccion del Titulo Obtenido ---> 
                    #getDivTitulObtenido('Edu')#
                
                    <!--- Filtro de Seleccion de Enfasis --->
                    #getDivEnfasis('Edu')#
                     
                    <!--- Filtro de Seleccion del Centro Funcional --->
                    #getDivCntFuncional('Edu')#
                         
                    <!--- Filtro de Seleccion del Tipo Empleado --->
                    #getDivTipoEmpleado('Edu')#   
                </div>    

                <!--- Filtros que se muestran si se selecciona la opcion Experiencia para la consulta del reporte --->
                <div class="experiencia">      
                    <!--- Filtro de Seleccion de Puesto --->
                    #getDivPuesto('Exp')#

                    <!--- Filtro de Seleccion del Tipo de Puesto ---> 
                    #getDivTipoPuesto('Exp')#

                    <!--- Filtro de Seleccion de Años de Experiencia ---> 
                    <div class="form-group row">
                        <div class="col-sm-12 yearExperienc">
                            <div class="lbel"><label><strong>#LB_AnnosExperiencia#:</strong></label></div>
                            <cf_inputNumber name="Annos" value="0" enteros="5" decimales="2" negativos="false" comas="yes">
                        </div>
                    </div>     

                    <!--- Filtro de Seleccion del Centro Funcional --->
                    #getDivCntFuncional('Exp')#
                         
                    <!--- Filtro de Seleccion del Tipo Empleado --->
                    #getDivTipoEmpleado('Exp')#    
                </div>  

                <!--- Filtros que se muestran si se selecciona la opcion Competencias para la consulta del reporte --->
                <div class="competencia">  
                    <!--- Seleccion de Competencias --->
                    <div class="form-group row">    
                        <div class="col-sm-12 selectCompetenc">
                            <div class="lbel"><label><strong>#LB_Tipo#:</strong></label></div> 
                            <select name="sTipoComp" id="sTipoComp">
                                <option value="">#LB_SeleccioneTipo#</option> 
                                <option value="C">#LB_Conocimiento#</option> 
                                <option value="H">#LB_Habilidad#</option> 
                            </select>  
                            <input type="hidden" name="tpComp" id="tpComp">

                            <select name="sCompetn" id="sCompetn" disabled>
                                <option value="">#LB_SeleccioneCompetencia#</option>  
                            </select>

                            <select name="sNiveles" id="sNiveles" disabled>
                                <option value="">#LB_SeleccioneNivel#</option>
                            </select>  

                            <a onclick="fnAddSelect()" onmouseover="fnShowTooltip('addCmp')" class="btn btn-primary btn-xs addCmp" data-toggle="tooltip" data-placement="top" title="#MSG_AddCompetenciaNivel#"><i class="fa fa-plus fa-xs"></i></a>
                        </div>  
                    </div>

                    <!--- Detalle de las competencias seleccionadas --->
                    <div class="form-group row">
                        <div class="col-sm-12 detailCompet">
                            <div class="row encabezado">
                                <div class="col-xs-7"><label><strong>#LB_Competencia#</strong></label></div>
                                <div class="col-xs-2"><label><strong>#LB_Nivel#</strong></label></div>
                                <div class="col-xs-1"><label><strong>#LB_Tipo#</strong></label></div>
                                <div class="col-xs-1"></div>
                            </div>  
                            <div class="detListCompet">
                            </div>  
                        </div>
                    </div> 

                    <!--- Filtro de Seleccion de Puesto --->
                    #getDivPuesto('Cmp')#

                    <!--- Filtro de Seleccion del Tipo de Puesto ---> 
                    #getDivTipoPuesto('Cmp')#

                    <!--- Filtro de Seleccion del Centro Funcional --->
                    #getDivCntFuncional('Cmp')#
                         
                    <!--- Filtro de Seleccion del Tipo Empleado --->
                    #getDivTipoEmpleado('Cmp')#
                </div>    

                <!--- Filtros que se muestran si se selecciona la opcion Publicaciones para la consulta del reporte --->
                <div class="publicacion">
                    <!--- Filtro de Seleccion de Puesto --->
                    #getDivPuesto('Pub')#

                    <!--- Filtro de Seleccion del Tipo de Puesto ---> 
                    #getDivTipoPuesto('Pub')#

                    <!--- Filtro de Seleccion del Tipo de Publicacion ---> 
                    <div class="form-group row">
                        <div class="col-sm-12 tpPublicacion">
                            <cf_translatedata name="get" tabla="RHPublicacionTipo" col="RHPTDescripcion" returnvariable="LvarRHPTDescripcion">
                            <div class="lbel"><label><strong>#LB_TipoPublicacion#:</strong></label></div>
                            <cf_conlis 
                                campos="RHPTcodigo, RHPTDescripcion"
                                asignar="RHPTcodigo, RHPTDescripcion"
                                size="0,50"
                                desplegables="S,S"
                                modificables="S,N"                        
                                title="#LB_ListaDeTiposDePublicacion#"
                                tabla="RHPublicacionTipo"
                                columnas="RHPTcodigo, #LvarRHPTDescripcion# as RHPTDescripcion"
                                filtro="1=1 order by RHPTcodigo, #LvarRHPTDescripcion#"
                                filtrar_por="RHPTcodigo, RHPTDescripcion"
                                desplegar="RHPTcodigo, RHPTDescripcion"
                                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                                formatos="S,S"
                                align="left,left"                               
                                asignarFormatos="S,S"
                                form="form1"
                                top="50"
                                left="200"
                                showEmptyListMsg="true"
                                tabindex="8"
                                pageindex="8"
                                />
                        </div>
                    </div>   

                    <!--- Filtro de Seleccion del Centro Funcional --->
                    #getDivCntFuncional('Pub')#
                         
                    <!--- Filtro de Seleccion del Tipo Empleado --->
                    #getDivTipoEmpleado('Pub')#     
                </div>   
            </div>      
 
            <!--- Selecciones del Reporte Curiculum Vitae Individual para la consulta --->
            <div class="CUIndividual">
                <!--- Seleccion del Empleado a mostrar para la consulta del reporte --->
                <div class="form-group row">
					<div class="col-sm-12 empleado">
                        <label><strong>#LB_Empleado#:</strong></label>
						<cf_rhempleado tabindex="16" form="form1">
					</div>		
                </div>    

                <!--- Seleccion del Tipo de Reporte(Resumido/Detallado) que se desea consultar--->
                <div class="form-group row">
					<div class="col-sm-12 tipoReport">	
						<div class="CUResumido">	
							<input name="chk_CUResumido" id="chk_CUResumido" type="checkbox" tabindex="1" onclick="fnTipoReport(this)">
							<label for="cuResumido"><b>#LB_Resumido#</b></label> 
 						</div>
 						<div class="CUDetallado">
							<input name="chk_CUDetallado" id="chk_CUDetallado" type="checkbox" tabindex="2" onclick="fnTipoReport(this)">
							<label for="cuDetallado"><b>#LB_Detallado#</b></label>
						</div>	
					</div>	
                </div>
            </div>        

			<!--- Seleccion del Formato de salida: HTML/Excel/Word --->
            <div class="form-group row">     
                <div class="col-sm-12 formato">	
		        	<div class="fmtReport">
						<label for="formato"> #LB_Formato# </label>
						<cfparam name="Form.sFormato" default="html">
						<select name="sFormato">
							<option value="html"> #LB_HTML# </option>
							<option value="excel"> #LB_Excel# </option>
							<option value="word"> #LB_Word# </option>
						</select>
					</div>	
		    	</div>
            </div>    

            <!--- Botones de consulta del reporte --->
            <div class="form-group row">
		    	<div class="col-sm-12 btnsReport">
		    		<div class="buttons">
			        	<input type="button" id="btnConsultar" onclick="fnValidarConsult()" class="btnConsultar" title="#MSG_Consultar#" value="#LB_Consultar#">	

			        	<input type="button" id="btnLimpiar" onclick="fnLimpiar()"  class="btnLimpiar" title="#MSG_Limpiar#" value="#LB_Limpiar#">
		        	</div>
		        </div>
			</div>	
		</cfoutput>	
        <input type="hidden" name="listEmp" id="listEmp" value="">
	</form>
	<div class="alert alert-danger alert-dismissable msjInfoDel">
		<a onclick="fnHideMessage()" class="close" aria-hidden="true">&times;</a>
	    <span></span>
	</div>
</div>	

<!--- Funcion que devuelve el div para la seleccion del Puesto --->
<cffunction name="getDivPuesto" output="true"> 
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
    <div class="form-group row">
        <div class="col-sm-12 puesto">
            <div class="lbel"><label><strong>#LB_Puesto#:</strong></label></div>
            <cf_conlis 
                campos="RHPcodigo_#tipo#, RHPdescpuesto_#tipo#"
                asignar="RHPcodigo_#tipo#, RHPdescpuesto_#tipo#"
                size="0,50"
                desplegables="S,S"
                modificables="S,N"                      
                title="#LB_ListaDePuestos#"
                tabla="RHPuestos"
                columnas="distinct RHPcodigo as RHPcodigo_#tipo#, #LvarRHPdescpuesto# as RHPdescpuesto_#tipo#"
                filtro=" Ecodigo in (#Session.Ecodigo#)
                        order by RHPcodigo, #LvarRHPdescpuesto#"
                filtrar_por="RHPcodigo, RHPdescpuesto"
                desplegar="RHPcodigo_#tipo#, RHPdescpuesto_#tipo#"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"                               
                asignarFormatos="S,S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="1"
                pageindex="1"
                />
        </div>
    </div> 
</cffunction>

<!--- Funcion que devuelve el div para la seleccion del Tipo de Puesto --->
<cffunction name="getDivTipoPuesto" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="RHTPuestos" col="RHTPdescripcion" returnvariable="LvarRHTPdescripcion">
    <div class="form-group row">
        <div class="col-sm-12 tpPuesto">
            <div class="lbel"><label><strong>#LB_TipoDePuesto#:</strong></label></div> 
            <cf_conlis 
                campos="RHTPcodigo_#tipo#, RHTPdescripcion_#tipo#"
                asignar="RHTPcodigo_#tipo#, RHTPdescripcion_#tipo#"
                size="0,50"
                desplegables="S,S"
                modificables="S,N"                      
                title="#LB_ListaDeTiposDePuesto#"
                tabla="RHTPuestos"
                columnas="distinct RHTPcodigo as RHTPcodigo_#tipo#, #LvarRHTPdescripcion# as RHTPdescripcion_#tipo#"
                filtro=" Ecodigo in (#Session.Ecodigo#)
                        order by RHTPcodigo, #LvarRHTPdescripcion#"
                filtrar_por="RHTPcodigo, RHTPdescripcion"
                desplegar="RHTPcodigo_#tipo#, RHTPdescripcion_#tipo#"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"                               
                asignarFormatos="S,S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="2"
                pageindex="2"
                />
        </div>
    </div>  
</cffunction>    

<!--- Funcion que devuelve el div para la seleccion del Grado de Academico --->
<cffunction name="getDivGradAcadem" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="GradoAcademico" col="GAnombre" returnvariable="LvarGAnombre">
    <div class="form-group row">
        <div class="col-sm-12 grdAcadem">
            <div class="lbel"><label><strong>#LB_Grado#:</strong></label></div>
            <cf_conlis
                campos="GAnombre_#tipo#"
                asignar="GAnombre_#tipo#"
                size="55"
                desplegables="S"
                modificables="N"
                title="#LB_ListaDeGrado#"
                tabla="GradoAcademico"
                columnas="distinct #LvarGAnombre# as GAnombre_#tipo#"
                filtro=" Ecodigo in (#Session.Ecodigo#)
                        order by #LvarGAnombre#"
                filtrar_por="GAnombre"
                desplegar="GAnombre_#tipo#"
                etiquetas="#LB_Descripcion#"
                formatos="S"
                align="left"                               
                asignarFormatos="S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="3"
                pageindex="3"
                />
        </div>
    </div>                 
</cffunction> 

<!--- Funcion que devuelve el div para la seleccion del Titulo Obtenido --->
<cffunction name="getDivTitulObtenido" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="RHOTitulo" col="RHOTDescripcion" returnvariable="LvarRHOTDescripcion">
    <div class="form-group row">
        <div class="col-sm-12 titObtenido">
            <div class="lbel"><label><strong>#LB_TituloObtenido#:</strong></label></div> 
            <cf_conlis
                campos="RHOTid_#tipo#, RHOTDescripcion_#tipo#"
                asignar="RHOTid_#tipo#, RHOTDescripcion_#tipo#"
                size="0,55"
                desplegables="N,S"
                modificables="N,N"                      
                title="#LB_ListaTitulosObtenidos#"
                tabla="RHOTitulo"
                columnas="RHOTid as RHOTid_#tipo#, CEcodigo as CEcodigo_#tipo#, #LvarRHOTDescripcion# as RHOTDescripcion_#tipo#"
                filtro=" CEcodigo = #Session.CEcodigo# 
                        order by #LvarRHOTDescripcion#"
                filtrar_por="CEcodigo, RHOTDescripcion"
                desplegar="RHOTDescripcion_#tipo#"
                etiquetas="#LB_Descripcion#"
                formatos="S,S"
                align="left"                                
                asignarFormatos="S,S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="4"
                pageindex="4"
                />
        </div>
    </div>  
</cffunction>   

<!--- Funcion que devuelve el div para la seleccion del Enfasis --->
<cffunction name="getDivEnfasis" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="RHOEnfasis" col="RHOEDescripcion" returnvariable="LvarRHOEDescripcion">
    <div class="form-group row">
        <div class="col-sm-12 enfasis">
            <div class="lbel"><label><strong>#LB_Enfasis#:</strong></label></div> 
            <cf_conlis
                Campos="RHOEid_#tipo#, RHOEDescripcion_#tipo#"
                Asignar="RHOEid_#tipo#, RHOEDescripcion_#tipo#"
                Desplegables="N,S"
                Modificables="S,N"
                Size="0,55"
                form="form1"
                Title="#LB_ListaEnfasis#"
                Tabla="RHOEnfasis"
                Columnas="RHOEid as RHOEid_#tipo#, #LvarRHOEDescripcion# as RHOEDescripcion_#tipo#"
                Filtro=" CEcodigo = #Session.CEcodigo# 
                        order by #LvarRHOEDescripcion#"
                Desplegar="RHOEDescripcion_#tipo#"
                Etiquetas="#LB_Enfasis#"
                filtrar_por="RHOEDescripcion"
                Formatos="S,S"
                Align="left,left"
                showEmptyListMsg="true"
                Asignarformatos="S,S"
                tabindex="5"
                pageindex="5"
                />
        </div>
    </div>   
</cffunction> 

<!--- Funcion que devuelve el div para la seleccion del Centro Funcional --->
<cffunction name="getDivCntFuncional" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="Lvar_CFdescripcion">
    <div class="form-group row"> 
        <div class="col-sm-12 cntFuncional">
            <div class="lbel"><label><strong>#LB_CentroFuncional#:</strong></label></div> 
            <cf_conlis
                campos="CFcodigo_#tipo#, CFdescripcion_#tipo#" 
                asignar="CFcodigo_#tipo#, CFdescripcion_#tipo#"
                size="0,50"
                desplegables="S,S"
                modificables="S,N"                      
                title="#LB_ListaDeCentroFuncional#"
                tabla="CFuncional"
                columnas="distinct CFcodigo as CFcodigo_#tipo#, #Lvar_CFdescripcion# as CFdescripcion_#tipo#"
                filtro=" Ecodigo in (#Session.Ecodigo#) 
                        order by #Lvar_CFdescripcion#"
                filtrar_por="CFcodigo, CFdescripcion"
                desplegar="CFcodigo_#tipo#, CFdescripcion_#tipo#"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"                               
                asignarFormatos="S,S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="6"
                pageindex="6"
                MaxRowsQuery="9999"
                />
        </div>
    </div>
</cffunction> 

<!--- Funcion que devuelve el div para la seleccion del Tipo Empleado --->
<cffunction name="getDivTipoEmpleado" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cf_translatedata name="get" tabla="TiposEmpleado" col="TEdescripcion" returnvariable="LvarTEdescripcion">
    <div class="form-group row">
        <div class="col-sm-12 tpEmpleado">
            <div class="lbel"><label><strong>#LB_TipoEmpleado#:</strong></label></div> 
            <cf_conlis
                campos="TEcodigo_#tipo#, TEdescripcion_#tipo#"
                asignar="TEcodigo_#tipo#, TEdescripcion_#tipo#"
                size="0,50"
                desplegables="S,S"
                modificables="S,N"                      
                title="#LB_ListaDeTipoEmpleado#"
                tabla="TiposEmpleado"
                columnas="distinct TEcodigo as TEcodigo_#tipo#, #LvarTEdescripcion# as TEdescripcion_#tipo#"
                filtro=" Ecodigo in (#Session.Ecodigo#) 
                        order by #LvarTEdescripcion#"
                filtrar_por="TEcodigo, TEdescripcion"
                desplegar="TEcodigo_#tipo#, TEdescripcion_#tipo#"
                etiquetas="#LB_Codigo#, #LB_Descripcion#"
                formatos="S,S"
                align="left,left"                               
                asignarFormatos="S,S,S"
                form="form1"
                top="50"
                left="200"
                showEmptyListMsg="true"
                tabindex="7"
                pageindex="7"
                />
        </div>
    </div>  
</cffunction> 


<script type="text/javascript">
    $(document).on('click', '.listTree input[type=checkbox]', function(e) {
        fnCargarListCompetencias();
        fnCargarListNiveles();
        fnActSelectEmpresas();
    }); 

    $('#sCurriculum').change(function(){
            fnChanceSelectTipo($(this).val());
        }
    );

    $('#sTipoComp').change(function(){
            fnCargarListCompetencias();
            fnCargarListNiveles();
        }
    );

    function fnValidarConsult(){
        if(fnValidar()){
            $('#jtreeJsonFormat').val(JSON.stringify($('.listTree').data('listTree').selected));
            $('form[name=form1]').submit();
        }    
    }

    function fnValidar(){
        var result = true;
        var mensaje = '';

        if(document.form1.rCurriculum[0].checked){  // Reporte Masivo
            if($('#sCurriculum').val() == ""){ 
                mensaje += '<cfoutput>#MSG_InfoCurriculum#</cfoutput>';
                result = false;
            } 
        }
        else{   // Reporte Individual
            if($('#DEidentificacion').val().trim() == ''){
                mensaje += '<cfoutput>#MSG_Empleado#</cfoutput>';
                result = false;
            }

            if(result){
                if(document.getElementById("chk_CUResumido").checked == false && document.getElementById("chk_CUDetallado").checked == false){
                    mensaje += '<cfoutput>#MSG_TipoCurriculum#</cfoutput>';
                    result = false;
                }
            } 
        }

        if(!result){
            $('.alert span').html(mensaje);
            fnShowMessage();
        }
            
        return result;
    }

    function fnChanceSelect(e){        
        if(e.value == "1"){      // Reporte Masivo
            // Pone por defecto la opcion de formato de salida del reporte de tipo HTML
            $('select[name=sFormato] option[value="html"]').attr('selected',true);
            $('select[name=sCurriculum] option[value=""]').attr('selected',true);

            if($('.CUIndividual').is(':visible')){  
                $('.CUIndividual, .formato, .btnsReport').delay(100).fadeOut(400);
                $('.curriculum, .formato, .btnsReport').delay(500).fadeIn(400);
            }   
            else
                $('.curriculum, .formato, .btnsReport').delay(200).fadeIn(400);

            // Activa formato de salida de tipo Excel y deshabilita el de Word
            $('select[name=sFormato] option[value="excel"]').removeAttr('disabled');
            $('select[name=sFormato] option[value="excel"]').css('display','');
            $('select[name=sFormato] option[value="word"]').attr('disabled','disabled');
            $('select[name=sFormato] option[value="word"]').css('display','none');
        }     
        else{     // Reporte Individual
            // Pone los valores por defecto para los parametros de salida del reporte
            $('select[name=sFormato] option[value="html"]').attr('selected',true);
            $('#chk_CUResumido').attr('checked',false);
            $('#chk_CUDetallado').attr('checked',false);
            $('#DEidentificacion').val('');
            $('#NombreEmp').val('');

            if($('.CUMasivo').is(':visible')){
                $(".filters, .CUMasivo, .curriculum, .lbCoorp, .divArbol").delay(100).fadeOut(400);    
                $('.listTree').listTree('deselectAll');
                $(".detListCompet").empty();
                $('#esCorporativo').prop('checked', false);
                $('.CUIndividual, .formato, .btnsReport').delay(500).fadeIn(400);
            }   
            else 
                $('.CUIndividual, .formato, .btnsReport').delay(200).fadeIn(400);
            
            // Activa formato de salida de tipo Word y deshabilita el de Excel
            $('select[name=sFormato] option[value="word"]').removeAttr('disabled');
            $('select[name=sFormato] option[value="word"]').css('display','');
            $('select[name=sFormato] option[value="excel"]').attr('disabled','disabled');
            $('select[name=sFormato] option[value="excel"]').css('display','none');
        }

        fnHideMessage();
    }

	function fnChanceSelectTipo(e){ 
		switch (e){
			case '1':  // Seleccion de Educacion
				$('.filters, .experiencia, .competencia, .publicacion, .lbCoorp, .divArbol').delay(200).fadeOut(400);
                $('.listTree').listTree('deselectAll');
                $('#esCorporativo').prop('checked', false);
                fnChanceSelectTipoInit('Edu');
				$('.filters, .CUMasivo, .educacion, .lbCoorp').delay(600).fadeIn(400);
				break;
			case '2':  // Seleccion de Experiencia
				$('.filters, .competencia, .educacion, .publicacion, .lbCoorp, .divArbol').delay(200).fadeOut(400);
                $('.listTree').listTree('deselectAll');
                $('#esCorporativo').prop('checked', false);
                fnChanceSelectTipoInit('Exp');
				$('.filters, .CUMasivo, .experiencia, .lbCoorp').delay(600).fadeIn(400);
				break;
			case '3':  // Seleccion de Competencia
				$('.filters, .educacion, .experiencia, .publicacion, .lbCoorp, .divArbol').delay(200).fadeOut(400);
                $('.listTree').listTree('deselectAll');
                $('#esCorporativo').prop('checked', false);
                fnChanceSelectTipoInit('Cmp');
                $('#sTipoComp').val('').change();
				$('.filters, .CUMasivo, .competencia, .lbCoorp').delay(600).fadeIn(400);	
				break;
            case '4':  // Seleccion de Publicacion  
                $('.filters, .educacion, .experiencia, .competencia, .lbCoorp, .divArbol').delay(200).fadeOut(400);
                $('.listTree').listTree('deselectAll');
                $('#esCorporativo').prop('checked', false);
                fnChanceSelectTipoInit('Pub');
                $('.filters, .CUMasivo, .publicacion, .lbCoorp').delay(600).fadeIn(400);
                break;
			default:
				$('.filters, .educacion, .experiencia, .competencia, .publicacion, .lbCoorp, .divArbol').delay(200).fadeOut(400);
                $('.listTree').listTree('deselectAll');
                $('#esCorporativo').prop('checked', false);
		} 
 	}
	
	function fnChanceSelectTipoInit(tipo){			
		$('#RHPcodigo_'+tipo).val(''); 
		$('#RHPdescpuesto_'+tipo).val('');

		$('#RHTPcodigo_'+tipo).val('');
	    $('#RHTPdescripcion_'+tipo).val('');

		$('#GAnombre_Edu').val('');

		$('#RHOTid_Edu').val('');
		$('#RHOTDescripcion_Edu').val('');

		$('#RHOEid_Edu').val('');
		$('#RHOEDescripcion_Edu').val('');

        $('#CFcodigo_'+tipo).val('');
		$('#CFdescripcion_'+tipo).val('');

        $('#TEcodigo_'+tipo).val('');
		$('#TEdescripcion_'+tipo).val('');  

        $('#RHPTcodigo').val('');    
        $('#RHPTDescripcion').val('');  
	}

    function fnActSelectEmpresas(){
        var vCoorporativo = false;

        if($('#esCorporativo').length != 0)
            vCoorporativo = $('#esCorporativo').prop('checked');

        vJtreeJsonFormat = JSON.stringify($('.listTree').data('listTree').selected);

        $.ajax({
            url: "ReporteCurriculumVitae-lista.cfm",
            type: "post",
            dataType: "html",
            async: false,
            data: { GetListEmp:true, esCorporativo:vCoorporativo, jtreeJsonFormat:vJtreeJsonFormat },  
            success: function(data) {
                $('#listEmp').val(data);
            }
        });
    }

    function fnCargarListCompetencias(){
        var elementHTML = "", vRHCcodigo = -1, vRHCdescripcion = "", vCodRHC = "", vCoorporativo = false, vTipoCmp = "";

        if($('#esCorporativo').length != 0)
            vCoorporativo = $('#esCorporativo').prop('checked');

        vJtreeJsonFormat = JSON.stringify($('.listTree').data('listTree').selected);
        vTipoCmp = $('#sTipoComp').val();
        $('#sCompetn option').remove();
        
        if(vTipoCmp != ''){
            elementHTML = '<option value="-1"><cfoutput>#LB_Todos#</cfoutput></option>';
            $('#sCompetn').append(elementHTML);

            $.ajax({
                url: "ReporteCurriculumVitae-lista.cfm",
                type: "post",
                dataType: "json",
                async: false,
                data: { GetListCmp:true, esCorporativo:vCoorporativo, jtreeJsonFormat:vJtreeJsonFormat, tipoCmp:vTipoCmp },  
                success: function(data) {
                    $.each(data.DATA, function(key, val){
                        vRHCcodigo = "";
                        vRHCdescripcion = "";
                        $.each(val, function(key, val){
                            if(key == 0)
                                vRHCcodigo = val;
                            else if(key == 1)
                                vRHCdescripcion = val;
                        });
                        if(vRHCcodigo != -1){ 
                            if(vCoorporativo)
                                vCodRHC = vRHCcodigo +' - ';
                            else 
                                vCodRHC = '';

                            elementHTML = '<option value="'+vRHCcodigo+'">'+vCodRHC+vRHCdescripcion+'</option>';
                            $('#sCompetn').append(elementHTML);
                        }
                    });     
               }
            });
            $('#sCompetn').prop('disabled',false);
            $('.addCmp').show();
        }
        else{
            elementHTML = '<option value=""><cfoutput>#LB_SeleccioneCompetencia#</cfoutput></option>';
            $('#sCompetn').append(elementHTML);
            $('#sCompetn').prop('disabled',true);
            $('.addCmp').hide();
        }
        $('#sTipoComp').val(vTipoCmp);
    }

    function fnCargarListNiveles(){
        var elementHTML = "", vRHNcodigo = -1, vRHNdescripcion = "", vCodRHN = "", vCoorporativo = false, vTipoCmp = "";

        if($('#esCorporativo').length != 0)
            vCoorporativo = $('#esCorporativo').prop('checked');

        vJtreeJsonFormat = JSON.stringify($('.listTree').data('listTree').selected);
        vTipoCmp = $('#sTipoComp').val();
        $('#sNiveles option').remove();

        if(vTipoCmp != ''){
            elementHTML = '<option value="-1"><cfoutput>#LB_Todos#</cfoutput></option>';
            $('#sNiveles').append(elementHTML);

            $.ajax({
                url: "ReporteCurriculumVitae-lista.cfm",
                type: "post",
                dataType: "json",
                async: false,
                data: { GetListNiv:true, esCorporativo:vCoorporativo, jtreeJsonFormat:vJtreeJsonFormat, tipoCmp:vTipoCmp },  
                success: function(data) {
                    $.each(data.DATA, function(key, val){
                        vRHNcodigo = "";
                        vRHNdescripcion = "";
                        $.each(val, function(key, val){
                            if(key == 0)
                                vRHNcodigo = val;
                            else if(key == 1)
                                vRHNdescripcion = val;
                        });
                        if(vRHNcodigo != -1){ 
                            if(vCoorporativo)
                                vCodRHN = vRHNcodigo +' - ';
                            else 
                                vCodRHN = '';

                            elementHTML = '<option value="'+vRHNcodigo+'">'+vCodRHN+vRHNdescripcion+'</option>';
                            $('#sNiveles').append(elementHTML);
                        }
                    });     
               }
            });
            $('#sNiveles').prop('disabled',false);
        }
        else{
            elementHTML = '<option value=""><cfoutput>#LB_SeleccioneNivel#</cfoutput></option>';
            $('#sNiveles').append(elementHTML);
            $('#sNiveles').prop('disabled',true);
        }
    }

    function fnAddSelect(){
        var result = true;
        var mensaje = '';

        var lvarSelect = "", lvarMsg = "";

        // Competencias(1)
        if($('#sCompetn').val().trim() == ''){
            mensaje += '<cfoutput>#MSG_Competencia#</cfoutput>';
            result = false;
        }
        
        if(result){
            if($('#sNiveles').val().trim() == ''){  // Niveles(2)
                mensaje += '<cfoutput>#MSG_Nivel#</cfoutput>';
                result = false;
            }
        }    

        if(result)
            fnAddElement();
        else{
            $('.alert span').html(mensaje);
            fnShowMessage();
        }
    }

    function fnValidarElement(e,showMsg){
        var mensaje = '';
        var result = true;

        if($('#'+e).val().trim() == ''){
            result = false;
            mensaje += showMsg;
            $('.alert span').html(mensaje);
            fnShowMessage();
        }
        return result;
    }

    function fnAddElement(){ 
        var elementHTML = "", vCodComp = "", vDesCmp = "", vCodNiv = "", vDescNiv = "", vCodigo = "", vTipo = "", vClass = "";

        vCodComp = $('#sCompetn').val();
        vDesCmp = $('#sCompetn :selected').text();
        vCodNiv = $('#sNiveles').val();
        vDescNiv = $('#sNiveles :selected').text();
        vTipo = $('#sTipoComp').val();
        vCodigo = vCodComp+'_'+vCodNiv+'_'+vTipo;
        vClass = 'tp'+vTipo;

        if(vCodComp == '-1')
            $('.'+vClass).remove();
         
        if($('#'+vCodigo).length == 0){
            elementHTML = '<div class="row '+vClass+'" id="'+vCodigo+'"><div class="col-xs-7">'+vDesCmp+'</div><div class="col-xs-2">'+vDescNiv+'</div><div class="col-xs-1">'+vTipo+'</div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListCmp" value="'+vCodigo+'"/></div>';
            $('.detListCompet').append(elementHTML);

            if(!$('.detailCompet').is(':visible'))
                $('.detailCompet').delay(200).fadeIn(800);
        }    
    }

    function fnDelElement(e){
        $(e).parent().parent().remove();

        if(!$('.detailCompet .detListCompet div').length){
            $('.detailCompet').hide();       
            $(".detListCompet").empty();        
        }    
    }

	function fnTipoReport(e){
		if($(e).attr('id') == "chk_CUResumido")
			$('#chk_CUDetallado').prop('checked',false);
		else
			$('#chk_CUResumido').prop('checked',false);
	}

    function fnShowTree(){
        if (document.getElementById("esCorporativo").checked == true)
            $('.divArbol').delay(200).fadeIn(500);
        else{
            $('.listTree').listTree('deselectAll');
            $('.divArbol').delay(200).fadeOut(500);
        } 

        fnCargarListCompetencias();
        fnCargarListNiveles();
    }

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
        $(".detListCompet").empty();
        $('.listTree').listTree('deselectAll');
		$(".curriculum, .filters, .lbCoorp, .divArbol, .CUMasivo, .CUIndividual, .detailCompet, .detailNivel, .formato, .btnsReport").delay(200).fadeOut(600);
        fnCargarListCompetencias();
        fnCargarListNiveles();
	}

	function fnShowTooltip(e){
		$('#'+e).tooltip('show');
	}

	function fnShowMessage(){	
		if($('.alert').is(':visible'))
			$('.alert').delay(200).fadeOut(500); 
		$('.alert').delay(200).fadeIn(200); 
	}

	function fnHideMessage(){
		$('.alert').delay(200).fadeOut(500);  	
	}
</script>