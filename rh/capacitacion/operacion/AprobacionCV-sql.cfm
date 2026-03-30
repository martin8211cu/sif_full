<cfset fromAprobacionCV = true>
<cfif form.tab eq 1><!------- Conocimientos -------->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionCompetencias-sql.cfm">
<cfelseif form.tab eq 2><!------ Habilidades ------->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionCompetencias-sql.cfm">
<cfelseif form.tab eq 3><!------ Experiencia ------->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionExperiencia-sql.cfm">
<cfelseif form.tab eq 4><!------ Estudios realizados---->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionEstudiosR-sql.cfm">
<cfelseif form.tab eq 5><!------ Publicaciones ---->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionPublicaciones-sql.cfm">
<cfelseif form.tab eq 6><!------ Idiomas----->
    <cfinclude template="/rh/capacitacion/expediente/idiomas-sql.cfm">
<cfelseif form.tab eq 7><!------ Datos Adjuntos ----->
    <cfinclude template="/rh/capacitacion/operacion/ActualizacionDatosAdjuntos-sql.cfm">    
</cfif>