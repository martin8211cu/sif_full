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
<cfif isdefined('url.MRid') and not isdefined('form.MRid')>
	<cfset form.MRid = url.MRid>
</cfif>
<cfif isdefined('url.filtro_access_server') and not isdefined('form.filtro_access_server')>
	<cfset form.filtro_access_server = url.filtro_access_server>
</cfif>
<cfif isdefined('url.filtro_MRdesde') and not isdefined('form.filtro_MRdesde')>
	<cfset form.filtro_MRdesde = url.filtro_MRdesde>
</cfif>				
<cfif isdefined('url.filtro_MRhasta') and not isdefined('form.filtro_MRhasta')>
	<cfset form.filtro_MRhasta = url.filtro_MRhasta>
</cfif>			

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">