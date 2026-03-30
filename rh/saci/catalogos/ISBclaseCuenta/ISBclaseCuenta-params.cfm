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

<cfif isdefined('url.CCclaseCuenta') and not isdefined('form.CCclaseCuenta')>
	<cfset form.CCclaseCuenta = url.CCclaseCuenta>
</cfif>
<cfif isdefined('url.filtro_CCclaseCuenta') and not isdefined('form.filtro_CCclaseCuenta')>
	<cfset form.filtro_CCclaseCuenta = url.filtro_CCclaseCuenta>
</cfif>
<cfif isdefined('url.filtro_CCnombre') and not isdefined('form.filtro_CCnombre')>
	<cfset form.filtro_CCnombre = url.filtro_CCnombre>
</cfif>				

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">