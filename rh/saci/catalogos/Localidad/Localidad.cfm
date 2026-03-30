<cf_templateheader title="Mantenimiento de Localidad">
	<cfinclude template="Localidad-params.cfm">

	<cfif (isdefined('form.LCid') and form.LCid NEQ '') or isdefined('form.btnNuevo') and form.btnNuevo NEQ ''>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA --->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
		<!--- PARAMETROS PARA LAS LISTAS INTERNAS --->
		<cfif isdefined('url.filtro_LCcod') and not isdefined('form.filtro_LCcod')>
			<cfset form.filtro_LCcod = url.filtro_LCcod>
		</cfif>
		<cfif isdefined('url.filtro_LCnombre') and not isdefined('form.filtro_LCnombre')>
			<cfset form.filtro_LCnombre = url.filtro_LCnombre>
		</cfif>	
		<cfif isdefined('url.filtro_DPnombre') and not isdefined('form.filtro_DPnombre')>
			<cfset form.filtro_DPnombre = url.filtro_DPnombre>
		</cfif>	
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
			<cfset form.Pagina2 = url.Pagina2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
			<cfset form.Pagina2 = url.PageNum_Lista2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA --->
		<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
			<cfset form.Pagina2 = form.PageNum2>
		</cfif>				
		<cfif isdefined('url.filtro_LCcodb') and not isdefined('form.filtro_LCcodb')>
			<cfset form.filtro_LCcodb = url.filtro_LCcodb>
		</cfif>
		<cfif isdefined('url.filtro_LCnombreb') and not isdefined('form.filtro_LCnombreb')>
			<cfset form.filtro_LCnombreb = url.filtro_LCnombreb>
		</cfif>			

		<cfinclude template="Localidad-edit.cfm">
	<cfelse>					
		<cf_web_portlet_start titulo="Lista de Localidades" tipo="bold" width="100%">
			<cfinclude template="localidad-arbol.cfm">
		<cf_web_portlet_end>			

	</cfif>			
<cf_templatefooter>