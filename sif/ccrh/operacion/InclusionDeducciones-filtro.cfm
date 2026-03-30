<!--- CAMPOS POR EL(OS) CUAL(ES) SE REALIZARÁ EL FILTRO--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("Url.RHIDid") and not isdefined("Form.RHIDid")>
	<cfparam name="Form.RHIDid" default="#Url.RHIDid#">
</cfif>

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<cfif isdefined("Url.TDid") and not isdefined("Form.TDid")>
	<cfparam name="Form.TDid" default="#Url.TDid#">
</cfif>

<cfif isdefined("Url.referenciaFiltro") and not isdefined("Form.referenciaFiltro")>
	<cfparam name="Form.referenciaFiltro" default="#Url.referenciaFiltro#">
</cfif>

<cfif isdefined("Url.fcreacionFiltro") and not isdefined("Form.fcreacionFiltro")>
	<cfparam name="Form.fcreacionFiltro" default="#Url.fcreacionFiltro#">
</cfif>

<cfif isdefined("Url.fdocumentoFiltro") and not isdefined("Form.fdocumentoFiltro")>
	<cfparam name="Form.fdocumentoFiltro" default="#Url.fdocumentoFiltro#">
</cfif>

<cfif isdefined("Url.usuarioFiltro") and not isdefined("Form.usuarioFiltro")>
	<cfparam name="Form.usuarioFiltro" default="#Url.usuarioFiltro#">
</cfif>

<cfif isdefined("Url.numRegistrosFiltro") and not isdefined("Form.numRegistrosFiltro")>
	<cfparam name="Form.numRegistrosFiltro" default="#Url.numRegistrosFiltro#">
</cfif>

<cfoutput>
<form style="margin: 0" action="InclusionDeducciones.cfm" name="form1" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
    <tr>
      
	  <td align="right"><strong>Empleado<strong></strong></strong></td>
      <td align="left" colspan="3">
        <cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
          <cf_rhempleado nombre="DEidFiltro" tabindex="1" size = "30" idempleado="#Form.DEid#">
          <cfelse>
          <cf_rhempleado nombre="DEidFiltro" tabindex="1" size = "30">
        </cfif>
      </td>
      
	  <td align="right"> <strong>Referencia<strong> </strong></strong></td>
      <td align="left" colspan="2"><input type="text" name="referenciaFiltro" size="30" maxlength="20" value="<cfif isdefined('form.referenciaFiltro')>#form.referenciaFiltro#</cfif>"></td>
      
	  <td  align="right"> <strong>Fecha del Documento<strong> </strong></strong></td>
      <td  align="left" colspan="3">
        <cfif isdefined("form.fdocumentoFiltro")>
          <cfset fecha = form.fdocumentoFiltro>
          <cfelse>
          <cfset fecha = ''>
        </cfif>
        <cf_sifcalendario form="form1" name="fdocumentoFiltro" value="#fecha#"> </td>
	</tr>
	<tr>
      
	  <td align="right"><strong>Tipo Deducción<strong></strong></strong></td>
      <td align="left">
	     <cfif isdefined("form.TDid") and Len(Trim(form.TDid)) NEQ 0>
          <cfquery name="dataTDeduccion" datasource="#session.DSN#">
				select distinct TDid, TDcodigo, TDdescripcion 
				from TDeduccion 
				where Ecodigo =  #session.Ecodigo# 
				and TDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TDid#">
		  </cfquery>
          <cf_rhtipodeduccion  size="30" validate="1" financiada="1" tabindex="1" query="#dataTDeduccion#">
          <cfelse>
          <cf_rhtipodeduccion  size="30" validate="1" financiada="1" tabindex="1">
        </cfif>
      </td>
      
	  <td align="right"><strong>Usuario</strong></td>
      <td align="left">
        <cfquery name="rsUsuario" datasource="#session.DSN#">
			  select distinct a.BMUsucodigo, c.Pnombre #_Cat# ' ' #_Cat# c.Papellido1 #_Cat# ' ' #_Cat# c.Papellido2 as nombre 
			  from RHInclusionDeducciones a 
			  		
					inner join Usuario b 
					on b.Usucodigo= a.BMUsucodigo 
					
					inner join DatosPersonales c on c.datos_personales = b.datos_personales 
			  where a.Ecodigo =   #session.Ecodigo# 
			  
			  <cfif isdefined("Form.usuarioFiltro") and Len(Trim(form.usuarioFiltro)) NEQ 0>
				and a.BMUsucodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.usuarioFiltro#">
			  </cfif>
			  
        </cfquery>
        <select name="usuarioFiltro">
          <option value=""></option>
          <cfloop query="rsUsuario">
            <option value="#rsUsuario.BMUsucodigo#" <cfif isdefined('form.usuarioFiltro') and form.usuarioFiltro eq rsUsuario.BMUsucodigo>selected</cfif>>#rsUsuario.nombre#</option>
          </cfloop>
        </select>
      </td>
	  <td align="right"> <strong>Fecha de Creación</strong></td>
      <td align="left">
        <cfif isdefined("form.fcreacionFiltro")>
          <cfset fecha = #form.fcreacionFiltro#>
          <cfelse>
          <cfset fecha = ''>
        </cfif>
        <cf_sifcalendario form="form1" name="fcreacionFiltro" value="#fecha#"> </td>
      	
		<td align="right"> <strong>Registros<strong> </strong></strong></td>
     	<td align="left"><input type="text" name="numRegistrosFiltro" size="3" maxlength="2" value="<cfif isdefined('form.numRegistrosFiltro')>#form.numRegistrosFiltro#</cfif>"></td>
    </tr>

	<tr>
		 <td colspan="10"  align="right"><input type="submit" name="btnFiltro"  value="Filtrar ">
          <input  type="submit"  name="btnNuevo"  value="Nuevo" onClick="javascript: return funcNuevo();">
          <input name="button"   type="button" onClick="javascript: return funcImprime();"  value="Imprimir"  naume="btnImprimir">
          <input name="button"   type="button" onClick="javascript: return funcImportar();"  value="Importar"  naume="btnImportar">
          <input name="button"   type="button" onClick="javascript: return funcLimpiar();"  value="Limpiar"  naume="btnLimpiar">
         </td>
	</tr>
	
  </table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcNuevo(){
		location.href='registroDeducciones.cfm';
		return false;
	}
	function funcImprime(){
		location.href='InclusionDeduccionesReport.cfm';
		return false;
	}
	
	function funcImportar(){
		location.href='importar-InclusionDeducciones.cfm';
		return false;
	}
	function funcLimpiar(){
		
		document.form1.DEidFiltro.value = '';
		document.form1.TDid.value = '';
		document.form1.numRegistrosFiltro.value = '';
		document.form1.referenciaFiltro.value = '';
		document.form1.usuarioFiltro.value = '';	
		document.form1.fcreacionFiltro.value = '';
		document.form1.fdocumentoFiltro.value = '';
	}
	
	var f = document.form1;
	f.btnFiltro.focus();

</script>