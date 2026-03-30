<cfparam name="EEid" type="numeric">
<cfparam name="ETid" type="numeric">
		
<cfquery datasource="sifpublica" name="hdr">
	select EEid,EEnombre,Ppais
	from EncuestaEmpresa
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
</cfquery>
<cfquery datasource="sifpublica" name="hdr2">
	select EEid,ETid,ETdescripcion
	from EmpresaOrganizacion
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
	  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETid#" >
</cfquery>
<cfquery datasource="sifpublica" name="lista">
	select e.Eid, e.Edescripcion, e.Efecha, count(1) as cant, #EEid# as EEid, #ETid# as ETid
	from Encuesta e
		join EncuestaSalarios es
			on e.Eid = es.Eid
	where es.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
	  and es.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETid#" >
	group by e.Eid, e.Edescripcion, e.Efecha
	order by e.Efecha desc
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
      <td colspan="4">El tipo de organizaci&oacute;n provisto es <cfoutput><strong>#hdr2.ETdescripcion#</strong>.</cfoutput></td>
    </tr>
	<tr>
	  <td colspan="4">De las siguientes encuestas disponibles, seleccione la que desee utilizar en las comparaciones. Normalmente, usted desear&aacute; utilizar la encuesta m&aacute;s reciente.
	</td>
	</tr>
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
				desplegar="Edescripcion,Efecha,cant"
				etiquetas="Encuesta,Fecha,Cantidad de Puestos Encuestados"
				formatos="S,D,S"
				align="left,left,left"
				ira="Encuesta-confirma.cfm"
				form_method="get"
				keys="Eid,ETid,EEid"
			/></td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<cfelse>
	No hay encuestas disponibles
</cfif>
<br>
<br>
<form action="EmpresaOrganizacion.cfm" method="get">
<cfoutput>
<input type="hidden" name="EEid" value="#HTMLEditFormat(EEid)#">
<input type="hidden" name="ETid" value="#HTMLEditFormat(ETid)#">
</cfoutput>
<input type="submit" value="&lt;&lt; Regresar"></form>
<br>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>


