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

<cfif isdefined('url.GCcodigo') and not isdefined('form.GCcodigo')>
	<cfset form.GCcodigo = url.GCcodigo>
</cfif>
<cfif isdefined('url.filtro_GCcodigo') and not isdefined('form.filtro_GCcodigo')>
	<cfset form.filtro_GCcodigo = url.filtro_GCcodigo>
</cfif>
<cfif isdefined('url.filtro_GCnombre') and not isdefined('form.filtro_GCnombre')>
	<cfset form.filtro_GCnombre = url.filtro_GCnombre>
</cfif>				

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">