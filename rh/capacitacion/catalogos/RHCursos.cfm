<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<table width="100%" cellspacing="0" cellpadding="0" v>
	<tr>
		<td valign="top" >
			<cf_web_portlet_start titulo="Cursos" skin="#session.preferences.skin#">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				  <tr>
					<td valign="top" width="50%">
						<cfquery datasource="#session.dsn#" name="lista">
							select c.RHCid, c.RHIAid, c.Mcodigo, 
							{fn concat(m.Msiglas,{fn concat(' - ',m.Mnombre)})} as materia, c.RHCcodigo, c.RHCfdesde as desde, c.RHCfhasta as hasta, rtrim(i.RHIAcodigo) as institucion
							from RHCursos c
							
							inner join RHInstitucionesA i
							on c.RHIAid=i.RHIAid
							and c.Ecodigo=i.Ecodigo
							
							inner join RHMateria m
							on c.Ecodigo=m.Ecodigo
							and c.Mcodigo=m.Mcodigo
							
							where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by 8, 4, 6
						</cfquery>
				
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="RHCcodigo,materia, desde, hasta, institucion"
							etiquetas="C&oacute;digo,Materia, Fecha Inicio, Fecha Final, Instituci&oacute;n "
							formatos="S,S,D,D,S"
							align="left,left,left,left,left"
							ira="RHCursos.cfm"
							form_method="get"
							keys="RHCid"
							showemptylistmsg="true"/>		
				
					</td>
					<td valign="top">
						<cfinclude template="RHCursos-form.cfm">
					</td>
				  </tr>
				</table>
			<cf_web_portlet_end>
		</td>
	</tr>
</table>
<cf_templatefooter>

