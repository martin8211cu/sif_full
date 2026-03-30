<cfquery datasource="#session.dsn#" name="lista">
	select 	'CD' as Tipo, 
			a.CDCidentificacion as Identificacion, 
			a.CDCnombre 		as Nombre, 
			a.CDCcodigo 		as ID
	  from ClientesDetallistasCorp a
	 where CEcodigo = #session.CEcodigo#
	<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>
	   and CDCidentificacion like '%#form.Fidentificacion#%'
	</cfif>
	<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>
	   and upper(CDCnombre) like '%#ucase(form.Fnombre)#%'
	</cfif>
       and a.CDCidentificacion <> '0'
	order by Identificacion, Nombre
</cfquery>
<cf_web_portlet_start border="true" titulo="Lista de Clientes Detallistas" skin="#Session.Preferences.Skin#" width="100%">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		desplegar="Identificacion, Nombre"
		etiquetas="Identificación, Nombre"
		formatos="S,S"
		align="left,left"
		ajustar="yes"
		showEmptyListMsg="yes"
		ira="InstruccionesPagos.cfm"
		form_method="get"
		navegacion="#navegacion#"
		keys="ID"
	/>		

	<cf_web_portlet_end>