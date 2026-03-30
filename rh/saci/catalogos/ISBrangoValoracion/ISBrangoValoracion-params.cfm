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

<cfif isdefined('url.rangoid') and not isdefined('form.rangoid')>
	<cfset form.rangoid = url.rangoid>
</cfif>
<cfif isdefined('url.filtro_rangodes') and not isdefined('form.filtro_rangodes')>
	<cfset form.filtro_rangodes = url.filtro_rangodes>
</cfif>
<cfif isdefined('url.filtro_rangotope') and not isdefined('form.filtro_rangotope')>
	<cfset form.filtro_rangotope = url.filtro_rangotope>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">