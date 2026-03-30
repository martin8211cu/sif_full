<!---<cfinclude template="ventanilla_sql.cfm">--->
<cfset ir = '/cfmx/home/tramites/Operacion/portlet/abrir-ventanilla.cfm' >
<cfif isdefined("url.trabajar_otro")>
	<cfset ir = '/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm' >
<cfelseif isdefined("url.noexiste") and isdefined("url.tramite")>
	<cfset ir = '/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm?noexiste=true&tramite=#url.tramite#' >
<cfelseif isdefined("url.completo") and isdefined("url.tramite") >
	<cfset ir = '/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm?completo=true&tramite=#url.tramite#' >
<cfelseif isdefined("url.id_tramite") and isdefined("url.id_tipoident") and isdefined("url.identificacion_persona") and isdefined("url.noexistepersona") >
	<cfset ir = '/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm?id_tramite=#HTMLEditFormat(url.id_tramite)#&id_tipoident=#HTMLEditFormat(url.id_tipoident)#&identificacion_persona=#HTMLEditFormat(url.identificacion_persona)#&noexistepersona=1' >
</cfif>

<cfoutput>
<iframe src="#ir#" id="iframe_gestion" 
	width="770" height="1030" frameborder="0" vspace="0" hspace="0" style="border:0px solid red;margin:0;padding:0;width:770px">
</iframe>
</cfoutput>

<!---

<cfif IsDefined("form.loc") and form.loc is 'ventanilla_cerrar'>
	<cfset session.tramites.id_funcionario = "">
	<cfset session.tramites.id_ventanilla = "">
	<cflocation url="?">
<!---<cfelseif IsDefined("form.id_ventanilla") and IsDefined("form.password")>--->
<cfelseif IsDefined("form.id_ventanilla") >
	<cfinclude template="ventanilla_sql.cfm">
	<cflocation url="?">
</cfif>

<cfparam name="url.loc" default="">

<cfif (NOT IsDefined("session.tramites.id_funcionario")) OR
      (NOT IsDefined("session.tramites.id_ventanilla")) OR
	  (NOT Len(session.tramites.id_funcionario)) OR
	  (NOT Len(session.tramites.id_ventanilla))>
	  <cfinclude template="ventanilla_out.cfm">
<cfelseif url.loc eq 'gestion'>
	<cfinclude template="/home/tramites/Operacion/gestion/gestion-form.cfm">
<cfelseif url.loc eq 'edit'>
	<cfinclude template="/home/tramites/Operacion/gestion/edit_tramite.cfm">
<cfelseif url.loc eq 'hist'>
	<cfinclude template="/home/tramites/Operacion/gestion/historia de tramites realizados.cfm">
<cfelseif url.loc eq 'pago'>
	<cfinclude template="/home/tramites/Operacion/gestion/payment.cfm">
<cfelseif url.loc eq 'pago2'>
	<cfinclude template="/home/tramites/Operacion/gestion/payment2-form.cfm">
<cfelseif url.loc eq 'pagofin'>
	<cfinclude template="/home/tramites/Operacion/gestion/payment_thanks-form.cfm">
<cfelse>
	<cfinclude template="/home/tramites/Operacion/gestion/gestion-form.cfm">
    <!---<cfinclude template="ventanilla_in.cfm">--->
</cfif>


--->