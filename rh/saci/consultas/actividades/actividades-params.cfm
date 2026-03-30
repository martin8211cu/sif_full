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
	
<cfif isdefined('url.Consultar') and not isdefined('form.Consultar')>
	<cfset form.Consultar = url.Consultar>
</cfif>
<cfif isdefined('url.fChk_Automatica') and not isdefined('form.fChk_Automatica')>
	<cfset form.fChk_Automatica = url.fChk_Automatica>
</cfif>
<cfif isdefined('url.fdesde') and not isdefined('form.fdesde')>
	<cfset form.fdesde = url.fdesde>
</cfif>
<cfif isdefined('url.fhasta') and not isdefined('form.fhasta')>
	<cfset form.fhasta = url.fhasta>
</cfif>
<cfif isdefined('url.fUsuario') and not isdefined('form.fUsuario')>
	<cfset form.fUsuario = url.fUsuario>
</cfif>
<cfif isdefined('url.F_LGlogin') and not isdefined('form.F_LGlogin')>
	<cfset form.F_LGlogin = url.F_LGlogin>
</cfif>
<cfif isdefined('url.tipo') and not isdefined('form.tipo')>
	<cfset form.tipo = url.tipo>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">