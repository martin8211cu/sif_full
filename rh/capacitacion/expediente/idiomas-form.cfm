<cf_importlibs>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2725" default="0" returnvariable="LvarAprobarIdiomas"/>

<cf_dbfunction name="op_concat" returnvariable="concat">
<cfquery datasource="#session.DSN#" name="rsOferente">
	select a.RHOLengOral1, a.RHOLengOral2, a.RHOLengOral3, a.RHOLengOral4, a.RHOLengOral5, 
			a.RHOLengEscr1, a.RHOLengEscr2, a.RHOLengEscr3, a.RHOLengEscr4, a.RHOLengEscr5,
			a.RHOLengLect1, a.RHOLengLect2, a.RHOLengLect3, a.RHOLengLect4, a.RHOLengLect5,
			a.RHOIdioma1, a.RHOIdioma2, a.RHOIdioma3, a.RHOIdioma4, a.RHOOtroIdioma5,
			coalesce(a.RHOidiomaAprobado,0) as RHOidiomaAprobado
	from DatosOferentes a 
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rsEmpleado">
	select de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as emp
	from DatosEmpleado de
	where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cf_Translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
<cfquery name="rsIdiomas" datasource="#session.DSN#">
	select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
	from RHIdiomas
	order by RHDescripcion asc
</cfquery>


<cfif isdefined ('LvarAutog') and LvarAutog eq 1 ><!----- desde autogestion----->
	<cfset self = "autogestion.cfm?o=9&tab=10" >
	<cfset destino = "operacion/idiomas-sql.cfm" >
<cfelseif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
	<cfset self = "AprobacionCV.cfm" >
	<cfset destino = "AprobacionCV-sql.cfm" >	
<cfelse><!----- desde expediente en capacitacion---->
	<cfset self = "idiomas.cfm" >
	<cfset destino = "idiomas-sql.cfm" >	
</cfif>

<cfset editable=true>
<cfif isdefined("fromAprobacionCV")><!---- si se encuentra en el prceso de aprobacion de idiomas no puede editar---->
	<cfset editable=false>
</cfif>
<cfif isdefined ('LvarAutog') and LvarAutog eq 1 and rsOferente.RHOidiomaAprobado eq 1 and LvarAprobarIdiomas><!---- si está en autogestion y se aprobó no puede editar---->
	<cfset editable=false>
</cfif>

<cfinvoke component="sif.Componentes.Translate"	method="Translate"	key="MSG_SelectPorcentajeDominioIdioma"	default="Debe indicar el porcentaje de dominio oral, escrito y lectura sobre los idiomas seleccionados"	returnvariable="MSG_SelectPorcentajeDominioIdioma"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeLugares" Default="Lista de Lugares" returnvariable="LB_ListaDeLugares"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" xmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Lugar" Default="Lugar" xmlFile="/rh/generales.xml" returnvariable="LB_Lugar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default="Tipo" xmlFile="/rh/generales.xml" returnvariable="LB_Tipo"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pertenece_A" Default="Pertenece a" xmlFile="/rh/generales.xml" returnvariable="LB_Pertenece_A"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Guardar" Default="Guardar" xmlFile="/rh/generales.xml" returnvariable="BTN_Guardar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Regresar" Default="Regresar" xmlFile="/rh/generales.xml" returnvariable="BTN_Regresar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InformacionAprobada" Default="Información aprobada" xmlFile="/rh/generales.xml" returnvariable="LB_InformacionAprobada"/>
<cfinvoke key="LB_Aprobar" default="Aprobar" returnvariable="LB_Aprobar" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazar" default="Rechazar" returnvariable="LB_Rechazar"  xmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
 
<!----- fin de querys------->
<form action="<cfoutput>#destino#</cfoutput>" name="formIdioma" id="formIdioma" method="post" onSubmit="return fnValidaIdiomas()"> 
	<cfoutput>
	<input type="hidden" name="DEid" value="#form.DEid#">
	<cfif isdefined("fromExpediente")>
		<input type="hidden" name="fromExpediente" value="1">
	</cfif>
	<cfif isdefined("fromAprobacionCV")>
		<input type="hidden" name="tab" value="6">
	</cfif>
	<fieldset>
		<div class="well" style="background-color:##FFFFFF;">
			<div class="form-horizontal">
				<div class="form-group">
					<label class="col-md-3 control-label hidden-sm hidden-xs">&nbsp;</label>
					<label class="col-md-3 control-label hidden-sm hidden-xs" style="text-align:left"><cf_Translate key="LB_Dominio" xmlFile="/curriculumExt/curriculum.xml">Dominio</cf_Translate></label>
					<label class="col-md-3 control-label hidden-sm hidden-xs" style="text-align:left"><cf_Translate key="LB_Dominio" xmlFile="/curriculumExt/curriculum.xml">Dominio</cf_Translate></label>
					<label class="col-md-3 control-label hidden-sm hidden-xs" style="text-align:left"><cf_Translate key="LB_Dominio" xmlFile="/curriculumExt/curriculum.xml">Dominio</cf_Translate></label>
				</div>	
				<div class="form-group">
					<label class="col-md-3 control-label" style="text-align:left"><i class="fa fa-flag-checkered"></i><cf_Translate key="LB_Lenguaje" xmlFile="/curriculumExt/curriculum.xml">Lenguaje</cf_Translate></label>
					<label class="col-md-3 control-label" style="text-align:left"><i class="fa fa-group"></i><cf_Translate key="LB_DominioConversacional" xmlFile="/curriculumExt/curriculum.xml">Conversacional</cf_Translate></label>
					<label class="col-md-3 control-label" style="text-align:left"><i class="fa fa-pencil fa-fw"></i><cf_Translate key="LB_DominioEscrito" xmlFile="/curriculumExt/curriculum.xml">Escrito</cf_Translate></label>
					<label class="col-md-3 control-label" style="text-align:left"><i class="fa fa-book fa-fw"></i><cf_Translate key="LB_DominioLectura" xmlFile="/curriculumExt/curriculum.xml">Lectura</cf_Translate></label>
				</div>	

				<div class="form-group">
					<div class="col-md-3"><i class="fa fa-flag-checkered"></i>
						<select name="RHOIdioma1" class="sIdioma" tabindex="1" onchange="fnChangeIdioma(this)">
							<option value=""><cf_Translate key="LB_SINDEFINIR">(SIN DEFINIR)</cf_Translate></option>
							<cfloop query="rsIdiomas">
								<option value="#RHIid#"	<cfif rsOferente.RHOIdioma1 eq RHIid>selected</cfif> >#RHDescripcion#</option>
							</cfloop>
						</select>
					</div>
					<div class="col-md-3"><i class="fa fa-group"></i>
						<select name="RHOLengOral1"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengOral1") and 105 EQ rsOferente.RHOLengOral1>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>
					<div class="col-md-3"><i class="fa fa-pencil fa-fw"></i>
						<select name="RHOLengEscr1"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengEscr1") and 105 EQ rsOferente.RHOLengEscr1>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>
					<div class="col-md-3"><i class="fa fa-book fa-fw"></i>
						<select name="RHOLengLect1"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengLect1") and 105 EQ rsOferente.RHOLengLect1>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>						
						</select>						
					</div>	
				</div>	

				<!---- idioma 2 ---->
				<div class="form-group">
					<div class="col-md-3"><i class="fa fa-flag-checkered"></i>
						<select name="RHOIdioma2" class="sIdioma" tabindex="1" onchange="fnChangeIdioma(this)">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
							<cfloop query="rsIdiomas">
								<option value="#RHIid#"	<cfif rsOferente.RHOIdioma2 eq RHIid>selected</cfif> >#RHDescripcion#</option>
							</cfloop>
						</select>
					</div>	
					<div class="col-md-3"><i class="fa fa-group"></i>
						<select name="RHOLengOral2"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengOral2") and 105 EQ rsOferente.RHOLengOral2>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
					<div class="col-md-3"><i class="fa fa-pencil fa-fw"></i>
						<select name="RHOLengEscr2"  tabindex="1">
						<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
						<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr2") and 105 EQ rsOferente.RHOLengEscr2>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
					</select>						
					</div>	
					<div class="col-md-3"><i class="fa fa-book fa-fw"></i>
						<select name="RHOLengLect2"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengLect2") and 105 EQ rsOferente.RHOLengLect2>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
				</div>	

				<!---- idioma 3 ---->
				<div class="form-group">
					<div class="col-md-3"><i class="fa fa-flag-checkered"></i>
						<select name="RHOIdioma3" class="sIdioma" tabindex="1" onchange="fnChangeIdioma(this)">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
							<cfloop query="rsIdiomas">
								<option value="#RHIid#"	<cfif rsOferente.RHOIdioma3 eq RHIid>selected</cfif> >#RHDescripcion#</option>
							</cfloop>
						</select>
					</div>	
					<div class="col-md-3"><i class="fa fa-group"></i>
						<select name="RHOLengOral3"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengOral3") and 105 EQ rsOferente.RHOLengOral3>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
					<div class="col-md-3"><i class="fa fa-pencil fa-fw"></i>
						<select name="RHOLengEscr3"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengEscr3") and 105 EQ rsOferente.RHOLengEscr3>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
					<div class="col-md-3"><i class="fa fa-book fa-fw"></i>
						<select name="RHOLengLect3"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
		                    <option value="105" <cfif   isdefined("rsOferente.RHOLengLect3") and 105 EQ rsOferente.RHOLengLect3>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
				</div>	

				<!---- idioma 4 ---->
				<div class="form-group">
					<div class="col-md-3"><i class="fa fa-flag-checkered"></i>
						<select class="sIdioma" name="RHOIdioma4" tabindex="1" onchange="fnChangeIdioma(this)">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
							<cfloop query="rsIdiomas">
								<option value="#RHIid#"	<cfif rsOferente.RHOIdioma4 eq RHIid>selected</cfif> >#RHDescripcion#</option>
							</cfloop>
						</select>
					</div>	
					<div class="col-md-3"><i class="fa fa-group"></i>
						<select name="RHOLengOral4"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengOral4") and 105 EQ rsOferente.RHOLengOral4>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>						
					</div>	
					<div class="col-md-3"><i class="fa fa-pencil fa-fw"></i>
						<select name="RHOLengEscr4"   tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr4") and 105 EQ rsOferente.RHOLengEscr4>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>					
					</div>	
					<div class="col-md-3"><i class="fa fa-book fa-fw"></i>
						<select name="RHOLengLect4"  tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengLect4") and 105 EQ rsOferente.RHOLengLect4>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>					
					</div>	
				</div>	

				<!---- otro idioma ---->
				<div class="form-group">
					<div class="col-md-3"><i class="fa fa-flag-checkered"></i>
						<input tabindex="1" name="RHIOtro" type="checkbox" id="RHIOtro" value="0" onclick="fnShowOtroIdioma()">
						<font><cf_Translate key="CHK_Otro" xmlFile="/curriculumExt/curriculum.xml">Otro</cf_Translate></font>
						<cfset vRHOOtroIdioma5 = "" >
						<cfif isdefined("rsOferente.RHOOtroIdioma5") >
							<cfset vRHOOtroIdioma5 = rsOferente.RHOOtroIdioma5 >
						</cfif> 
						<input class="otroIdioma sIdioma" type="text" name="RHOOtroIdioma5" maxlength="80" size="17" value="#vRHOOtroIdioma5#"<cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>>
					</div>	
					<div class="col-md-3 otroIdioma"<cfif len(vRHOOtroIdioma5) eq 0> style="display:none;" </cfif> ><i class="fa fa-group"></i>
						<select name="RHOLengOral5" style="font-size:14px" tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengOral5") and 105 EQ rsOferente.RHOLengOral5>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select>
					</div>	
					<div class="col-md-3 otroIdioma" <cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>><i class="fa fa-pencil fa-fw"></i>
						<select name="RHOLengEscr5" style="font-size:14px" tabindex="1">
							<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
							<option value="105" <cfif   isdefined("rsOferente.RHOLengEscr5") and 105 EQ rsOferente.RHOLengEscr5>selected</cfif>><cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
						</select> 
					</div>	
					<div class="col-md-3 otroIdioma" <cfif len(vRHOOtroIdioma5) eq 0>style="display:none;"</cfif>><i class="fa fa-book fa-fw"></i>
							<select name="RHOLengLect5" style="font-size:14px" tabindex="1">
								<option value=""><cf_Translate key="LB_SINDEFINIR" xmlFile="/curriculumExt/curriculum.xml">(SIN DEFINIR)</cf_Translate></option>
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
								<option value="105" <cfif   isdefined("rsOferente.RHOLengLect5") and 105 EQ rsOferente.RHOLengLect5>selected</cfif>><cf_Translate key="LB_lenguamaterna"  xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate></option>
							</select> 
					</div>	
				</div>	
			<legend></legend>
			<cfif isdefined ('LvarAutog') and LvarAutog eq 1>
				<cfif rsOferente.RHOidiomaAprobado eq 1 and LvarAprobarIdiomas>		
					<div class="row">	
						<div class="alert alert-dismissable alert-info text-center">
						 <cf_Translate key="MSG_NoPuedeEditarEstarInformacionAprobacionPrevia" xmlFile="/rh/generales.xml">No puede editar esta información debido a una aprobación previa</cf_Translate>
						</div>
					</div>
				</cfif>
			</cfif>
			<div class="row">	
				<div class="col-sm-12" align="center">
					<cfif not (isdefined ('LvarAutog') and LvarAutog eq 1 and rsOferente.RHOidiomaAprobado eq 1 and LvarAprobarIdiomas)>
						
						<cfif isdefined("fromAprobacionCV")><!---- solo edita si se encueentra en aprobacion de idiomas--->
							<cfif not rsOferente.RHOidiomaAprobado eq 1>
								<input type="submit" class="btnNormal" name="btnAprobar" value="#LB_Aprobar#">
							<cfelse>
								<input type="submit" class="btnNormal" name="btnRechazar" value="#LB_Rechazar#">
							</cfif>
						</cfif>

						<cfif editable>
							<input type="submit" class="btnGuardar" name="btnGuardar" value="#BTN_Guardar#">	
						</cfif>
					</cfif>
				</div>
			</div>
			</div><!--- cierre class form---->
		</div><!---- fin del well---->	
	</fieldset>
	</cfoutput>
</form>

<script type="text/javascript">

	$( document ).ready(function() {
		<cfif len(vRHOOtroIdioma5) gt 0 >
			$('#RHIOtro').attr('checked',true);
		</cfif>	
	});

	function fnShowOtroIdioma(){
		if($('#RHIOtro').is(":checked"))
			$('.otroIdioma').delay(200).fadeIn(400);	
		else
			$('.otroIdioma').delay(200).fadeOut(400);
	}


	function fnValidaIdiomas(){
		var result = false;
		var elements = $('.sIdioma');

		for(i=0; i<elements.length; i++){
			if(i == elements.length-1)
				if(!document.form1.RHIOtro.checked){
					$('input[name='+elements[i].name+']').val('');
					$('input[name='+elements[i].name+']').parent().siblings().children().val('');
					result = true;
					break;
				}

			result = fnValidarElement(elements[i].name,i+1,'<cfoutput>#MSG_SelectPorcentajeDominioIdioma#</cfoutput>');	

			if(!result)
				break;
		}
		return result;
	}

	function fnChangeIdioma(e){
		if($('select[name='+e.name+']').val() == '')
			$('select[name='+e.name+']').parent().siblings().children().val('');
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


	function fnRegresar(){
		window.location="idiomas.cfm";
	}
	<cfif not editable>
		$("#formIdioma input[type=checkbox], #formIdioma input[type=text],#formIdioma select").attr("readonly","true");
		$("#formIdioma select option:not(:selected)").remove();
		$("#RHIOtro").hide();
	</cfif>


</script>