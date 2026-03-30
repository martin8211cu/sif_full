<cfparam name="EEid">
		
<cfquery datasource="sifpublica" name="hdr">
	select EEid,EEnombre,Ppais
	from EncuestaEmpresa
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
</cfquery>
<cfquery datasource="sifpublica" name="lista">
	select EEid,ETid,ETdescripcion
	from EmpresaOrganizacion
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
	order by ETdescripcion
</cfquery>


<cf_template>
<cf_templatearea name="title">
	Selecci&oacute;n de encuestadoras
</cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Seleccionar encuestadora" width="450">

		<cfif lista.RecordCount>

<table width="450" border="0" cellspacing="6" align="center">
	<tr>
	  <td colspan="4">Ha seleccionado utilizar las encuestas provistas por <cfoutput><strong>#hdr.EEnombre#</strong>.</cfoutput></td>
    </tr>
	<tr>
	  <td colspan="4"><cfoutput>#hdr.EEnombre#</cfoutput> ha definido los siguientes tipos de organizaci&oacute;n para la realizaci&oacute;n de estas encuestas.</td>
    </tr>
	<tr>
	  <td colspan="4">Haga clic en el tipo de organizaci&oacute;n con la que quiere equiparar su empresa en las encuestas.
	</td></tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
    <td valign="top">&nbsp;</td>
    <td colspan="2" valign="top">
<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="ETdescripcion"
				etiquetas="Tipo de organización"
				formatos="S"
				align="left"
				ira="Encuesta.cfm"
				form_method="get"
				keys="EEid,ETid"
			/></td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<cfelse>
	No hay más empresas disponibles
</cfif>
<br>
<form action="EncuestaEmpresa.cfm" method="get"><input type="submit" value="&lt;&lt; Regresar"></form>
<br>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>


