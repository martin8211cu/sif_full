<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Listado de Compromisos vrs. Donaciones
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>
<cfset navBarStatusText = ArrayNew(1)>

<cfset ArrayAppend(navBarItems,'Donaciones')>
<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">
<cfinclude template="../pNavegacion.cfm">

</cf_templatearea>
</cf_template>