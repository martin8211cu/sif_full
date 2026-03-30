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

<cfif isdefined('url.Iid') and not isdefined('form.Iid')>
	<cfset form.Iid = url.Iid>
</cfif>
<cfif isdefined('url.filtro_Inombre') and not isdefined('form.filtro_Inombre')>
	<cfset form.filtro_Inombre = url.filtro_Inombre>
</cfif>
<cfif isdefined('url.filtro_Idescripcion') and not isdefined('form.filtro_Idescripcion')>
	<cfset form.filtro_Idescripcion = url.filtro_Idescripcion>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">