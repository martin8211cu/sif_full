<cfparam name="EEid" type="numeric">
<cfparam name="ETid" type="numeric">
<cfparam name="Eid"  type="numeric">
		
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
<cfquery datasource="sifpublica" name="hdr3">
	select e.Eid, e.Edescripcion, e.Efecha
	from Encuesta e
	where e.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EEid#" >
	  and e.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Eid#" >
</cfquery>



<cf_template>
<cf_templatearea name="title">
	Selecci&oacute;n de encuestadoras
</cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Seleccionar encuestadora" width="450">

<table width="450" border="0" cellspacing="6" align="center">
	<tr>
	  <td colspan="4">Por favor confirme la siguiente informaci&oacute;n para seleccionar su empresa encuestadora. Esta selecci&oacute;n se podr&aacute; alterar en cualquier momento que lo desee.</td>
    </tr>
	<tr>
	  <td>&nbsp;</td>
      <td>Encuestadora:</td>
      <td><cfoutput><strong>#hdr.EEnombre#</strong></cfoutput></td>
      <td>&nbsp;</td>
	</tr>
	<tr>
      <td>&nbsp;</td>
      <td>Tipo de Organizaci&oacute;n </td>
      <td><cfoutput><strong>#hdr2.ETdescripcion#</strong></cfoutput></td>
      <td>&nbsp;</td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
      <td>Encuesta</td>
      <td><cfoutput><strong>#hdr3.Edescripcion#</strong></cfoutput></td>
      <td>&nbsp;</td>
	</tr>
	</tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top" align="right"><cfoutput><form action="Encuesta.cfm" method="get">
        
          <input type="hidden" name="EEid" value="#HTMLEditFormat(EEid)#">
          <input type="hidden" name="ETid" value="#HTMLEditFormat(ETid)#">
        
        <input type="submit" value="&lt;&lt; Regresar">
      </form></cfoutput></td>
      <td valign="top" align="left">
<cfoutput>
	  <form action="Encuesta-apply.cfm" method="post">
<input type="hidden" name="EEid" value="#HTMLEditFormat(EEid)#">
<input type="hidden" name="ETid" value="#HTMLEditFormat(ETid)#">
<input type="hidden" name="Eid" value="#HTMLEditFormat(Eid)#">
	  <input type="submit" value="Aceptar">
	  </form>
</cfoutput>
	  </td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
    <td valign="top">&nbsp;</td>
    <td colspan="2" valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>

<cf_web_portlet_end> </cf_templatearea> </cf_template> 