<cfquery datasource="#session.tramites.dsn#" name="RSTramite">
	select nombre_tramite  from  TPTramite
	where id_tramite   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">                
</cfquery>


<cfquery datasource="#session.tramites.dsn#" name="total_header">
	select nombre_requisito  from  TPRequisito
	where id_requisito   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">                
</cfquery>

<!---
<cfquery datasource="#session.tramites.dsn#" name="para_iniciar">
	select id_tramite, codigo_tramite, nombre_tramite
	from  TPTramite
	where id_requisito_generado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">                
</cfquery>
--->
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<table width="100%" border="0">
  <tr>
    <td colspan="2" bgcolor="#ECE9D8" style="font-size:20px; padding:3px; ">
		<cfoutput> <strong>#RSTramite.nombre_tramite#</strong></cfoutput></td>
  </tr>
  <tr>
    <td colspan="2" bgcolor="#ECE9D8" style="font-size:18px; padding:3px; ">
		<cfoutput> <strong>#total_header.nombre_requisito#</strong></cfoutput></td>
  </tr>
  <tr>
    <td colspan="2"><cfinclude template="hdr_persona.cfm"></td>
  </tr>
  <tr>
    <td width="50%" valign="top"><cfinclude template="hdr_tramite.cfm"></td>
    <td width="50%" valign="top"><cfinclude template="hdr_requisito.cfm">
    </td>
  </tr>
  <tr>
    <td colspan="2" bgcolor="#ECE9D8" style="padding:3px;"><strong>Para cumplir con este requisito</strong></td>
  </tr>
  <tr>
    <td colspan="2">El requisito no aparece en el expediente del usuario. </td>
  </tr>
  <tr>
    <td colspan="2">Si desea iniciar un nuevo tr&aacute;mite para cumplir con el requisito, selecci&oacute;nelo de la siguiente lista. </td>
  </tr>
  <tr>
    <td colspan="2">
<!---
	<cfif para_iniciar.RecordCount EQ 0>
		Actualmente no hay ning&uacute;n tr&aacute;mite que se pueda realizar para obtener este requisito.  Por favor consulte de nuevo m&aacute;s tarde.
		<cfelse>
	<form action="javascript:void(0)" name="form1" id="form1">
	<table border="0" width="100%">
	<cfoutput query="para_iniciar">
        <tr>
          <td><input type="radio" name="nvotramite" id="nvotramite_#id_tramite#" value="#id_tramite#"></td>
          <td><label  for="nvotramite_#id_tramite#" >#HTMLEditFormat(codigo_tramite)#</label></td>
          <td><label  for="nvotramite_#id_tramite#" >#HTMLEditFormat(nombre_tramite)#</label></td>
          <td>&nbsp;            </td>
        </tr>
		</cfoutput>
      </table>
	  </form>
	</cfif>
</td>
  </tr>
  --->

  <tr>
    <td colspan="2" align="center"> 
		<!---
		<cfif para_iniciar.RecordCount NEQ 0>
			 <input type="button"  onClick="javascript:solicitud();" value="Solicitud" class="boton">			
		</cfif>
		--->
		<input type="button"  onClick="javascript:cancelar();" value="Cancelar" class="boton">	
    </td>
  </tr>
</table>

<script type="text/javascript">
<!--
	<cfoutput>
	function cancelar(){
		location.href='gestion-form.cfm' +
			'?id_tramite=#url.id_tramite#' +
			'&id_tipoident=#data_persona.id_tipoident#' +
			'&identificacion_persona=#data_persona.identificacion_persona#';
	}
	function solicitud(){
		location.href='gestion-form.cfm' +
			'?id_tramite=' + escape(document.form1.nvotramite.value) +
			'&id_tipoident=#data_persona.id_tipoident#' +
			'&identificacion_persona=#data_persona.identificacion_persona#';
	}
	</cfoutput>
//-->
</script>