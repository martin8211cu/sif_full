<cfquery datasource="#session.dsn#" name="RHEncuestadora">
	select EEid
	from RHEncuestadora
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfif RHEncuestadora.RecordCount Is 0>
	<cflocation url="EncuestaEmpresa.cfm">
</cfif>
<cfquery datasource="#session.dsn#" name="RHEdefault" maxrows="1">
	select EEid
	from RHEncuestadora
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and RHEdefault = 1
</cfquery>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
}
-->
</style>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Seleccionar encuestadora" width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td valign="top">&nbsp;	</td>
		  </tr>
		  <tr>
			<td valign="top" align="center"><span class="style1">Esta es la lista de las empresas que realizan encuestas salariales y los ponen a disposici&oacute;n de su empresa. </span></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>				
		  <tr>
			<td valign="top">
						
				<cfif Len(RHEdefault.EEid)>
					<cfset RHEdefault_EEid = RHEdefault.EEid>
				<cfelse>
					<cfset RHEdefault_EEid = -1>
				</cfif>
				<cfquery datasource="sifpublica" name="lista">
					select EEid,EEnombre,Ppais, case when EEid = #RHEdefault_EEid# then 'Sí' else 'No' end as es_default
					from EncuestaEmpresa
					where EEid in ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHEncuestadora.EEid#" list="yes"> )
				</cfquery>
				
		
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="EEnombre,Ppais,es_default"
					etiquetas="Empresa Encuestadora,País,Preferida"
					formatos="S,S,S"
					align="left,left,left"
					ira="RHEncuestadoraEdit.cfm"
					form_method="get"
					keys="EEid"
				/>
		
			</td>
		  </tr>
		  <tr>
			<td valign="top">&nbsp;</td>
		  </tr>
		  <tr>
			<td valign="top" align="center">
				<form action="EncuestaEmpresa.cfm" method="get">
					<input type="submit" value="Agregar &gt;&gt;">
				</form></td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


