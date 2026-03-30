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

<cfif isdefined('url.interfaz') and not isdefined('form.interfaz')>
	<cfset form.interfaz = url.interfaz>
</cfif>
<cfif isdefined('url.filtro_interfaz') and not isdefined('form.filtro_interfaz')>
	<cfset form.filtro_interfaz = url.filtro_interfaz>
</cfif>
<cfif isdefined('url.filtro_S02ACC') and not isdefined('form.filtro_S02ACC')>
	<cfset form.filtro_S02ACC = url.filtro_S02ACC>
</cfif>
<cfif isdefined('url.filtro_nombreInterfaz') and not isdefined('form.filtro_nombreInterfaz')>
	<cfset form.filtro_nombreInterfaz = url.filtro_nombreInterfaz>
</cfif>
<cfif isdefined('url.filtro_componente') and not isdefined('form.filtro_componente')>
	<cfset form.filtro_componente = url.filtro_componente>
</cfif>
<cfif isdefined('url.filtro_metodo') and not isdefined('form.filtro_metodo')>
	<cfset form.filtro_metodo = url.filtro_metodo>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">