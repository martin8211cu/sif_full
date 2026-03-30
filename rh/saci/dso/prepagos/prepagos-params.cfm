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
<cfif isdefined('url.TJid') and not isdefined('form.TJid')>
	<cfset form.TJid = url.TJid>
</cfif>
<cfif isdefined('url.filtro_TJlogin') and not isdefined('form.filtro_TJlogin')>
	<cfset form.filtro_TJlogin = url.filtro_TJlogin>
</cfif>
<cfif isdefined('url.filtro_descTJestado') and not isdefined('form.filtro_descTJestado')>
	<cfset form.filtro_descTJestado = url.filtro_descTJestado>
</cfif>				
<cfif isdefined('url.filtro_nombreAgente') and not isdefined('form.filtro_nombreAgente')>
	<cfset form.filtro_nombreAgente = url.filtro_nombreAgente>
</cfif>		
<cfif isdefined('url.filtro_TJuso') and not isdefined('form.filtro_TJuso')>
	<cfset form.filtro_TJuso = url.filtro_TJuso>
</cfif>	
<cfif isdefined('url.filtro_TJvigencia') and not isdefined('form.filtro_TJvigencia')>
	<cfset form.filtro_TJvigencia = url.filtro_TJvigencia>
</cfif>	

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">