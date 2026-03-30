<cfset t=createObject("component","sif.Componentes.Translate")>
<cfset LB_Empleado = t.Translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Habilidades = t.Translate('LB_Habilidades','Habilidades','/rh/generales.xml')>
<cfset LB_Conocimientos = t.Translate('LB_Conocimientos','Conocimientos','/rh/generales.xml')>
<cfset LB_Experiencia = t.Translate('LB_Experiencia','Experiencia','/rh/generales.xml')>
<cfset LB_Educacion = t.Translate('LB_Educacion','Educación','/rh/autogestion/autogestion.xml')>
<cfset LB_Publicaciones = t.Translate('LB_Publicaciones','Publicaciones','/rh/generales.xml')>
<cfset LB_Idiomas = t.translate('LB_Idiomas','Idiomas','/curriculumExt/curriculum.xml')>
<cfset LB_DeseaAplicarEstaAccion = t.Translate('LB_DeseaAplicarEstaAccion','¿Desea Aplicar estar acción?','/rh/generales.xml')>
<cfset LB_TodasLasSecciones = t.Translate('LB_TodasLasSecciones','Todas las secciones','/rh/generales.xml')>
<cfset LB_AplicaPara = t.Translate('LB_AplicaPara','Aplica para','registro_evaluacion.xml')>
<cfset LB_TodaLaEmpresa = t.Translate('LB_TodaLaEmpresa','Toda la empresa')>

<cfset LB_PermitirEdicion = t.Translate('LB_PermitirEdicion','Permitir Edición')>
<cfset LB_BloquearEdicion = t.Translate('LB_BloquearEdicion','Bloquear Edición')>

<cf_importlibs>

<style type="text/css">
  .well{ border-style: double; -webkit-box-shadow:none; box-shadow: none; background-color:white; border:none; }
</style>  
  
<cfif isdefined("form.opcion") and form.opcion eq 1>
  <cfset lvarShow = false>
<cfelse>
  <cfset lvarShow = true>  
</cfif>  

<cfif isDefined("form.btnAbrir") or isDefined("form.btnCerrar")>
	<cfinclude template="AperturaCV-sql.cfm">
</cfif>
<div class="bs-docs-section">
<div class="row">
	<div class="well text-center">
		<form name="formApertura" id="formApertura" class="bs-example form-horizontal" action="" method="post" onSubmit="return validarSubmit();">
			<cfoutput>
            <fieldset>
              <div class="form-group">
                <label for="select" class="col-lg-2 control-label col-lg-offset-2">#LB_AplicaPara#:</label>
                <div class="col-lg-3">
                  <select class="form-control" id="opcion" name="opcion" onchange="comboOpcion()">
                    <option value="0" <cfif isdefined("form.opcion") and form.opcion eq 0> selected</cfif> >#LB_Empleado#</option>
                    <option value="1" <cfif isdefined("form.opcion") and form.opcion eq 1> selected</cfif> >#LB_TodaLaEmpresa#</option>
                  </select>
                </div>
              </div>

            <div class="form-group" id="divEmpleado" <cfif not lvarShow> style="display:none"</cfif>>
              <label for="DEidentificacion1" class="col-lg-2 control-label col-lg-offset-2">#LB_Empleado#: </label>
              <div class="col-lg-3">
                <cfif isDefined("form.DEid1") and len(trim(form.DEid1))>
                    <cf_rhempleado index="1" form="formApertura" idempleado="#form.DEid1#">
                <cfelse> 
                    <cf_rhempleado index="1" form="formApertura">
                </cfif>
              </div>
            </div>
                     
              <div class="form-group">
                <label for="select" class="col-lg-2 control-label col-lg-offset-2">#LB_Tipo#:</label>
                <div class="col-lg-3">
                  <select class="form-control" id="tipo" name="tipo">
                    <option value="0" <cfif isdefined("form.tipo") and form.tipo eq 0> selected</cfif> >#LB_TodasLasSecciones#</option>
                    <option value="1" <cfif isdefined("form.tipo") and form.tipo eq 1> selected</cfif> >#LB_Habilidades#</option>
                    <option value="2" <cfif isdefined("form.tipo") and form.tipo eq 2> selected</cfif>>#LB_Conocimientos#</option>
                    <option value="3" <cfif isdefined("form.tipo") and form.tipo eq 3> selected</cfif>>#LB_Experiencia#</option>
                    <option value="4" <cfif isdefined("form.tipo") and form.tipo eq 4> selected</cfif>>#LB_Educacion#</option>
                    <option value="5" <cfif isdefined("form.tipo") and form.tipo eq 5> selected</cfif>>#LB_Publicaciones#</option>
                    <option value="6" <cfif isdefined("form.tipo") and form.tipo eq 6> selected</cfif>>#LB_Idiomas#</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <div class="col-lg-5 col-lg-offset-3 text-center">
                  <input type="submit" onclick="fnValidar();" class="btnAplicar" name="btnAbrir" value="#LB_PermitirEdicion#"> 
                  <input type="submit" onclick="fnValidar();" class="btnEliminar" name="btnCerrar" value="#LB_BloquearEdicion#">
                </div>
              </div>
            </fieldset>
        	</cfoutput>
          </form>
        </div>
</div>
</div>

<cf_qforms form="formApertura">
<script type="text/javascript">
  objForm.DEidentificacion1.required=true;
  objForm.DEidentificacion1.description='<cfoutput>#LB_Empleado#</cfoutput>';
	function fnValidar(){
    if($("#opcion").val()==0){
       objForm.DEidentificacion1.required=true;
    }else{
      objForm.DEidentificacion1.required=false;
    }
	}

  function validarSubmit(){
    if(confirm('<cfoutput>#LB_DeseaAplicarEstaAccion#</cfoutput>')){
      return true;
    }else{
      return false;
    }
  }
  function comboOpcion(){
    if($("#opcion").val()==1){
      $("#divEmpleado").hide();
    }else{
      $("#divEmpleado").show();
    }
  } 
</script>