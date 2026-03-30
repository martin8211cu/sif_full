<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Compromisos
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/iglesias/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/iglesias/donacion.cfm">
	<cfinclude template="pNavegacion.cfm">

	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pLista"
		returnvariable="pLista">
		<cfinvokeargument name="tabla" value="MEDCompromiso a, MEEntidad b, MEDProyecto c"/>
		<cfinvokeargument name="columnas" value="a.MEDcompromiso, b.MEEnombre, c.MEDnombre, a.MEDimporte, a.MEDmoneda, a.MEDultima, a.MEDsiguiente"/>
		<cfinvokeargument name="cortes" value="MEDnombre">
		<cfinvokeargument name="filtro" value="b.Ecodigo = #session.Ecodigo#
													and b.cliente_empresarial = #session.CEcodigo#
													and MEDactivo = 1
													and getdate() between MEDinicio and MEDfinal
													and a.MEEid = b.MEEid
													and a.MEDproyecto = c.MEDproyecto
												order by MEDnombre asc, MEDcompromiso desc"/>
		<cfinvokeargument name="desplegar" value="MEEnombre, MEDimporte, MEDmoneda, MEDultima, MEDsiguiente"/>
		<cfinvokeargument name="etiquetas" value="Donante, Importe, Moneda, F. Última Donación, F. Siguiente Donación"/>
		<cfinvokeargument name="formatos" value="S, M, S, D, D"/>
		<cfinvokeargument name="align" value="left, right, left, center, center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="donacion_compromiso.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="MEDcompromiso"/>
	</cfinvoke>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
