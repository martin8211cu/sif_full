<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<cfif isdefined("url.LCid") and len(trim(url.LCid))>
	<cfset form.LCid = url.LCid>
</cfif>
<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>
<cfif isdefined('url.modoLoc') and not isdefined('form.modoLoc')>
	<cfset form.modoLoc = url.modoLoc>
</cfif>			
<cfif isdefined('url.LCidPadre') and not isdefined('form.LCidPadre')>
	<cfset form.LCidPadre = url.LCidPadre>
</cfif>	

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">
<cfparam name="form.modoLoc" default="ALTA">
<cfparam name="form.LCid" default="">