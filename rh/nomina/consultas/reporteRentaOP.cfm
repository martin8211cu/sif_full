<!---RVNP--->
<!--- 
	****************************************
	****Consulta de Renta*******************
	****Ultima  modificación: 14/02/2007****
	****Ultima   modificación  realizada****
	****por:   Dorian    Abarca   Gómez.****
	****Descripción:  Se modificó porque****
	****no    tomaba    en  cuenta   los****
	****componentes  que no cargan renta****
	****y  no  obtenía correctamente las****
	****deducciones    de    renta   por****
	****familiares      (hijos/conyuge).****
	****************************************
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="#nav__SPdescripcion#" returnvariable="LB_titulo"/>
<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
		<cfoutput>#pNavegacion#</cfoutput>
			<br/>
			<table width="825" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td width="5">&nbsp;</td>
				<td width="380" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
						<p>
							<cf_translate  key="LB_texto_de_ayuda">
								Detalle del rebajo de impuesto de 
								renta a los empleados para un 
								rango de meses. 
							</cf_translate>
						</p>
					    <cf_web_portlet_end>
				</td>
				<td width="5">&nbsp;</td>
				<td width="400" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_filtros#" tituloalign="left" wifth="300" height="300">
						<cfinclude  template="reporteRenta-formOP.cfm">
					<cf_web_portlet_end>
				</td>
				<td width="5">&nbsp;</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>