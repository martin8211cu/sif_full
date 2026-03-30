<cfsavecontent variable="mensajeFaltante">
  <div class="col-lg-12">
    <div class="alert alert-dismissable alert-info text-center">
      <cf_translate key="MSG_NohayItemsParaAprobarRechazar" xmlFile="/rh/generales.xml">No existen Items para aprobar o rechazar</cf_translate>
    </div>
  </div>
</cfsavecontent>
<cfsavecontent variable="mensajeParametro">
  <div class="col-lg-12">
    <div class="alert alert-dismissable alert-info text-center">
      <cf_translate key="MSG_LaAprobacionDeEstaCategoriaDeshabilitada" xmlFile="/rh/generales.xml">La aprobación de esta categoría se encuentra deshabilitada</cf_translate>
    </div>
  </div>
</cfsavecontent>

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2721" default="0" returnvariable="LvarParamTab1"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2722" default="0" returnvariable="LvarParamTab2"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2723" default="0" returnvariable="LvarParamTab3"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2724" default="0" returnvariable="LvarParamTab4"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2692" default="0" returnvariable="LvarParamTab5"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2725" default="0" returnvariable="LvarParamTab6"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2727" default="0" returnvariable="LvarParamTab7"/>

<cfset fromAprobacionCV=true>
<cfoutput>
    <cfif form.tab eq 1><!------- Conocimientos -------->
        <cfif LvarParamTab1 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,1)>
            #mensajeFaltante#
        <cfelse>    
            <cfset tipo='C'>
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionCompetencias-form.cfm">
        </cfif> 
    <cfelseif form.tab eq 2><!------ Habilidades ------->
        <cfif LvarParamTab2 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,2)>
            #mensajeFaltante#
        <cfelse>    
            <cfset tipo='H'>
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionCompetencias-form.cfm">
        </cfif>
    <cfelseif form.tab eq 3><!------ Experiencia ------->
        <cfif LvarParamTab3 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,3)>
            #mensajeFaltante#
        <cfelse>    
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionExperiencia-form.cfm">
        </cfif>
    <cfelseif form.tab eq 4><!------ Estudios realizados---->
        <cfif LvarParamTab4 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,4)>
            #mensajeFaltante#
        <cfelse>    
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionEstudiosR-form.cfm">
        </cfif>
    <cfelseif form.tab eq 5><!------ Publicaciones ---->
        <cfif LvarParamTab5 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,5)>
            #mensajeFaltante#
        <cfelse>
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionPublicaciones-form.cfm">
        </cfif>
    <cfelseif form.tab eq 6><!------ Idiomas ----->
        <cfif LvarParamTab6 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,6)>
            #mensajeFaltante#
        <cfelse>    
            <cfset fromAprobacionCurriculum=true>
            <cfinclude template="/rh/capacitacion/expediente/idiomas-form.cfm">
        </cfif>
    <cfelseif form.tab eq 7><!------ Datos Adjuntos ----->    
        <cfif LvarParamTab7 neq 1>
            #mensajeParametro#
        <cfelseif not listFindNoCase(ListaTabs,7)>
            #mensajeFaltante#
        <cfelse>    
            <cfinclude template="/rh/capacitacion/operacion/ActualizacionDatosAdjuntos-form.cfm">
        </cfif>
    </cfif>
</cfoutput>
<div class="row">
    <div class="col-sm-12 text-center">
        <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Regresar" default="Regresar" xmlFile="/rh/generales.xml" returnvariable="LB_Regresar">
        <input type="button" class="btnAnterior" value="<cfoutput>#LB_Regresar#</cfoutput>" style="display:inline !important" onclick="window.location='AprobacionCV.cfm'">
    </div> 
</div>