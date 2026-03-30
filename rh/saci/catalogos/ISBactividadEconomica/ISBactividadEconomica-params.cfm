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

<cfif isdefined('url.AEactividad') and not isdefined('form.AEactividad')>
	<cfset form.AEactividad = url.AEactividad>
</cfif>
<cfif isdefined('url.filtro_AEactividad') and not isdefined('form.filtro_AEactividad')>
	<cfset form.filtro_AEactividad = url.filtro_AEactividad>
</cfif>
<cfif isdefined('url.filtro_AEnombre') and not isdefined('form.filtro_AEnombre')>
	<cfset form.filtro_AEnombre = url.filtro_AEnombre>
</cfif>				

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">