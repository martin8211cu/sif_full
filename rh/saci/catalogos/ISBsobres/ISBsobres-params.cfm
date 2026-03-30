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
<cfif isdefined('url.Snumero') and not isdefined('form.Snumero')>
	<cfset form.Snumero = url.Snumero>
</cfif>

<cfif isdefined('url.filtro_Snumero') and not isdefined('form.filtro_Snumero')>
	<cfset form.filtro_Snumero = url.filtro_Snumero>
</cfif>
<cfif isdefined('url.filtro_Sdonde') and not isdefined('form.filtro_Sdonde')>
	<cfset form.filtro_Sdonde = url.filtro_Sdonde>
</cfif>				
<cfif isdefined('url.filtro_LGlogin') and not isdefined('form.filtro_LGlogin')>
	<cfset form.filtro_LGlogin = url.filtro_LGlogin>
</cfif>		
<cfif isdefined('url.filtro_nombreAgente') and not isdefined('form.filtro_nombreAgente')>
	<cfset form.filtro_nombreAgente = url.filtro_nombreAgente>
</cfif>
<cfif isdefined('url.filtro_Sestado') and not isdefined('form.filtro_Sestado')>
	<cfset form.filtro_Sestado = url.filtro_Sestado>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">