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
<cfif isdefined('url.MBmotivo') and not isdefined('form.MBmotivo')>
	<cfset form.MBmotivo = url.MBmotivo>
</cfif>
<cfif isdefined('url.filtro_MBdescripcion') and not isdefined('form.filtro_MBdescripcion')>
	<cfset form.filtro_MBdescripcion = url.filtro_MBdescripcion>
</cfif>
<cfif isdefined('url.filtro_HabilitadoDesc') and not isdefined('form.filtro_HabilitadoDesc')>
	<cfset form.filtro_HabilitadoDesc = url.filtro_HabilitadoDesc>
</cfif>				
<cfif isdefined('url.filtro_MBconCompromisoImg') and not isdefined('form.filtro_MBconCompromisoImg')>
	<cfset form.filtro_MBconCompromisoImg = url.filtro_MBconCompromisoImg>
</cfif>		
<cfif isdefined('url.filtro_MBautogestionImg') and not isdefined('form.filtro_MBautogestionImg')>
	<cfset form.filtro_MBautogestionImg = url.filtro_MBautogestionImg>
</cfif>		
<cfif isdefined('url.filtro_MBdesbloqueableImg') and not isdefined('form.filtro_MBdesbloqueableImg')>
	<cfset form.filtro_MBdesbloqueableImg = url.filtro_MBdesbloqueableImg>
</cfif>		

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">