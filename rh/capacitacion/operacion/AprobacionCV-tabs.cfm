
<!--- Valida si el empleado a consultar se encuentra en tabla DatosOferentes --->
<cfquery name="rsValidaEmpleado" datasource="#session.dsn#">
    select RHOid
    from DatosOferentes 
    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfif rsValidaEmpleado.recordcount and len(trim(rsValidaEmpleado.RHOid))>
    <cfset fk = 'RHOid'>
    <cfset fkvalor = rsValidaEmpleado.RHOid>
<cfelse>
    <cfset fk = 'DEid'>
    <cfset fkvalor = form.DEid> 
</cfif>

<!----- si se define el empleado se muestra la session del tab------>
<cfquery datasource="#session.dsn#" name="rsTab">
    select distinct 1 as tab from RHCompetenciasEmpleado rhe where rhe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> and tipo ='C'
    union
    select distinct 2 as tab from RHCompetenciasEmpleado rhe where rhe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> and tipo ='H'
    union
    select distinct 3 as tab from RHExperienciaEmpleado rhe where rhe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    union
    select distinct 4 as tab from RHEducacionEmpleado ee where ee.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    union
    select distinct 5 as tab from RHPublicaciones p where p.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    union
    select distinct 6 as tab from DatosOferentes do where do.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    union
    select distinct 7 as tab from DatosOferentesArchivos where <cfoutput>#fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fkvalor#">
</cfquery>
 
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Conocimientos = t.Translate('LB_Conocimientos','Conocimientos','/rh/generales.xml')>
<cfset LB_Habilidades = t.Translate('LB_Habilidades','Habilidades','/rh/generales.xml')>
<cfset LB_Experiencia = t.Translate('LB_Experiencia','Experiencia','/rh/generales.xml')>
<cfset LB_Educacion = t.Translate('LB_Educacion','Educación','/rh/generales.xml')>
<cfset LB_Publicaciones = t.Translate('LB_Publicaciones','Publicaciones','/rh/generales.xml')>
<cfset LB_Idiomas = t.translate('LB_Idiomas','Idiomas','/curriculumExt/curriculum.xml')>
<cfset LB_DatosAdjuntos = t.translate('LB_DatosAdjuntos','Datos Adjuntos','/rh/generales.xml')>

<cfset ListaTabs =valuelist(rsTab.tab)>
<cf_navegacion name="tab" default="1">
<cf_navegacion name="DEid">

 
<div class="col-sm-12" style="margin-bottom: 2em;">
    <cfset consulta=true><!----- esta opcion quita los datos de consulta y solo deja el encabezado---->
    <cfset consulta2=true>
    <cfinclude template="/rh/capacitacion/expediente/info-empleado.cfm">
</div>


<cfset names= ArrayNew(1)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Conocimientos#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Habilidades#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Experiencia#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Educacion#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Publicaciones#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_Idiomas#">
    <cfset arrayAppend(names, x)>
    <cfset x=structNew()>
    <cfset x.title="#LB_DatosAdjuntos#">
    <cfset arrayAppend(names, x)>

<cf_tabs width="99%">
    <cfloop from="1" to="#arraylen(names)#" index="i">
        <cf_tab text="#names[i].title#" selected="#form.tab eq i#">
            <cfif form.tab eq i> 
                <cfinclude template="AprobacionCV-form.cfm">
            </cfif> 
        </cf_tab>
    </cfloop>
</cf_tabs>

<script type="text/javascript"> 
    function tab_set_current (n){
        location.href='AprobacionCV.cfm?DEid=<cfoutput>#JSStringFormat(form.DEid)#</cfoutput>&tab='+escape(n);
    }
</script>