<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>		
<cfif isdefined('url.filtro_Acodigo') and not isdefined('form.filtro_Acodigo')>
	<cfset form.filtro_Acodigo = url.filtro_Acodigo>
</cfif>
<cfif isdefined('url.filtro_Acodalterno') and not isdefined('form.filtro_Acodalterno')>
	<cfset form.filtro_Acodalterno = url.filtro_Acodalterno>
</cfif>			
<cfif isdefined('url.filtro_Adescripcion') and not isdefined('form.filtro_Adescripcion')>
	<cfset form.filtro_Adescripcion = url.filtro_Adescripcion>
</cfif>				
<cfif isdefined("url.Aid") and len(trim(url.Aid)) and not isdefined("form.Aid")>
	<cfset form.Aid = url.Aid >
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">	