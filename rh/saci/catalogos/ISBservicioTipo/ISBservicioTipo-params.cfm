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
<cfif isdefined('url.TScodigo') and not isdefined('form.TScodigo')>
	<cfset form.TScodigo = url.TScodigo>
</cfif>
<cfif isdefined('url.filtro_TScodigo') and not isdefined('form.filtro_TScodigo')>
	<cfset form.filtro_TScodigo = url.filtro_TScodigo>
</cfif>
<cfif isdefined('url.filtro_TSnombre') and not isdefined('form.filtro_TSnombre')>
	<cfset form.filtro_TSnombre = url.filtro_TSnombre>
</cfif>				
<cfif isdefined('url.filtro_TSdescripcion') and not isdefined('form.filtro_TSdescripcion')>
	<cfset form.filtro_TSdescripcion = url.filtro_TSdescripcion>
</cfif>		

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">