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

<cfif isdefined('url.Pquien_F') and not isdefined('form.Pquien_F')>
	<cfset form.Pquien_F = url.Pquien_F>
</cfif>
<cfif isdefined('url.TJestado_F') and not isdefined('form.TJestado_F')>
	<cfset form.TJestado_F = url.TJestado_F>
</cfif>
<cfif isdefined('url.TJid_F') and not isdefined('form.TJid_F')>
	<cfset form.TJid_F = url.TJid_F>
</cfif>
<cfif isdefined('url.btnFiltrar') and not isdefined('form.btnFiltrar')>
	<cfset form.btnFiltrar = url.btnFiltrar>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">