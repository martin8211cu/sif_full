<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-style: italic;
	font-weight: bold;
}
-->
</style>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Consulta de Feligreses
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
	<cfset filtro = "">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td rowspan="8">&nbsp;</td>
		<td><cfinclude template="../pNavegacion.cfm"></td>
		<td rowspan="8">&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td><span class="style1">Seleccione Un Feligres.</span></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td><cfinclude template="personas_filtro.cfm"><!--- Carga la variable filtro ---></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="MEPersona a"/>
				<cfinvokeargument name="columnas" value="MEpersona, Pnombre = Papellido1+' '+Papellido2+' '+Pnombre, Pcasa"/>
				<cfinvokeargument name="desplegar" value="Pnombre, Pcasa"/>
				<cfinvokeargument name="etiquetas" value="Nombre, Teléfono"/>
				<cfinvokeargument name="formatos" value="S, S"/>
				<cfinvokeargument name="filtro" value="activo=1
														and cliente_empresarial = #Session.CEcodigo# 
														and Ecodigo = #Session.Ecodigo# 
														#filtro#
														order by Pnombre"/> <!--- cliente_empresarial = #Session.CEcodigo# and Ecodigo = #Session.Ecodigo# --->
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="personas_consulta.cfm"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	  </tr>
  	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
</cf_templatearea>
</cf_template>