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

<cfif isdefined('url.SOid') and not isdefined('form.SOid')>
	<cfset form.SOid = url.SOid>
</cfif>
<cfif isdefined('url.filtro_SOfechasol') and not isdefined('form.filtro_SOfechasol')>
	<cfset form.filtro_SOfechasol = url.filtro_SOfechasol>
</cfif>
<cfif isdefined('url.filtro_SOtipo') and not isdefined('form.filtro_SOtipo')>
	<cfset form.filtro_SOtipo = url.filtro_SOtipo>
</cfif>				
<cfif isdefined('url.filtro_SOestado') and not isdefined('form.filtro_SOestado')>
	<cfset form.filtro_SOestado = url.filtro_SOestado>
</cfif>		
<cfif isdefined('url.filtro_SOtipoSobre') and not isdefined('form.filtro_SOtipoSobre')>
	<cfset form.filtro_SOtipoSobre = url.filtro_SOtipoSobre>
</cfif>	
<cfif isdefined('url.filtro_SOcantidad') and not isdefined('form.filtro_SOcantidad')>
	<cfset form.filtro_SOcantidad = url.filtro_SOcantidad>
</cfif>	

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">