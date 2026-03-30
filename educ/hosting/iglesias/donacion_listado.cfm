<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Donaciones
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
		<cfinvokeargument name="tabla" value="MEDDonacion a, MEDProyecto b, MEEntidad c"/>
		<cfinvokeargument name="columnas" value="a.MEDdonacion, a.MEDfecha, a.MEDimporte, a.MEDmoneda, coalesce(c.MEEnombre, 'Anónimo') as MEEnombre,
													a.MEDforma_pago, a.MEDdescripcion, b.MEDnombre"/>
		<cfinvokeargument name="cortes" value="MEDnombre">
		<cfinvokeargument name="filtro" value="b.Ecodigo = #session.Ecodigo#
												  and a.MEDproyecto = b.MEDproyecto
												  and (a.MEDforma_pago = 'S' or a.MEDimporte != 0)
												  and c.MEEid =* a.MEEid
												order by MEDnombre asc, MEDfecha desc"/>
		<cfinvokeargument name="desplegar" value="MEEnombre, MEDfecha, MEDimporte, MEDmoneda"/>
		<cfinvokeargument name="etiquetas" value="Donante, Fecha, Importe, Moneda"/>
		<cfinvokeargument name="formatos" value="S, D, M, S"/>
		<cfinvokeargument name="align" value="left, center, right, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="donacion_registro.cfm"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="keys" value="MEDdonacion"/>
	</cfinvoke>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
