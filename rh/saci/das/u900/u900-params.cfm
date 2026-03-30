<cfparam name="CurrentPage" default="#GetFileFromPath(GetTemplatePath())#">
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
<cfif isdefined("url.paso") and Len(Trim(url.paso))>
	<cfset form.paso = url.paso>
</cfif>
<cfif isdefined("url.MDref") and Len(Trim(url.MDref))>
	<cfset form.MDref = url.MDref>
</cfif>
<cfif isdefined("url.Filtro_MDref") and Len(Trim(url.Filtro_MDref))>
	<cfset form.Filtro_MDref = url.Filtro_MDref>
</cfif>
<cfif isdefined("url.Filtro_Limite") and Len(Trim(url.Filtro_Limite))>
	<cfset form.Filtro_Limite = url.Filtro_Limite>
</cfif>
<cfif isdefined("url.Filtro_Saldo") and Len(Trim(url.Filtro_Saldo))>
	<cfset form.Filtro_Saldo = url.Filtro_Saldo>
</cfif>
<cfif isdefined("url.Filtro_Uso") and Len(Trim(url.Filtro_Uso))>
	<cfset form.Filtro_Uso = url.Filtro_Uso>
</cfif>

<cfparam name="form.paso" default="1">

