<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA --->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>

<cfif isdefined('url.codMensaje') and not isdefined('form.codMensaje')>
	<cfset form.codMensaje = url.codMensaje>
</cfif>
<cfif isdefined('url.filtro_codMensaje') and not isdefined('form.filtro_codMensaje')>
	<cfset form.filtro_codMensaje = url.filtro_codMensaje>
</cfif>
<cfif isdefined('url.filtro_mensaje') and not isdefined('form.filtro_mensaje')>
	<cfset form.filtro_mensaje = url.filtro_mensaje>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">