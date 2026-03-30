<cfsilent>

<cfset modo="ALTA">
<cfif isdefined("Form.AFTFid_dispositivo") and len(trim("Form.AFTFid_dispositivo")) NEQ 0 and Form.AFTFid_dispositivo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<cfinvoke component="sif.af.tomaFisica.componentes.aftfDispositivosMoviles" method="getDispositivoById" 
			returnvariable="rsForm" AFTFid_dispositivo="#Form.AFTFid_dispositivo#"/>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" 
			returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
</cfif>

</cfsilent>
<cfoutput>
<fieldset><legend><cfif modo NEQ "ALTA">Cambio<cfelse>Alta</cfif> de Dispositivos M&oacute;viles</legend>
<form action="aftfDispositivosMoviles-sql.cfm" method="post" name="form1" style="margin:0px">
<cfif modo NEQ "ALTA">
<input type="hidden" id="AFTFid_dispositivo" name="AFTFid_dispositivo" value="#Form.AFTFid_dispositivo#">
<input type="hidden" name="ts_rversion" value="#ts#" >
</cfif>
<input type="hidden" name="Pagina" value="#form.Pagina#">
<input type="hidden" name="MaxRows" value="#form.MaxRows#">
<input type="hidden" name="Filtro_AFTFcodigo_dispositivo" value="#form.Filtro_AFTFcodigo_dispositivo#">
<input type="hidden" name="Filtro_AFTFnombre_dispositivo" value="#form.Filtro_AFTFnombre_dispositivo#">
<input type="hidden" name="Filtro_AFTFestatus_dispositivo" value="#form.Filtro_AFTFestatus_dispositivo#">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="tituloListas">
    <td width="25%" align="right" class="fileLabel">C&oacute;digo&nbsp;:&nbsp;</td>
    <td width="75%">
		<input type="text" <cfif modo NEQ "ALTA">class="cajasinbordeb" readonly value="#HTMLEditFormat(rsForm.AFTFcodigo_dispositivo)#" tabindex="-1"<cfelse>tabindex="1"</cfif>
			id="AFTFcodigo_dispositivo" name="AFTFcodigo_dispositivo" size="20" maxlength="20" 
			onFocus="javascript:this.select();">
	</td>
  </tr>
  <tr>
    <td width="25%" align="right" class="fileLabel">Descripci&oacute;n&nbsp;:&nbsp;</td>
    <td width="75%">
		<input type="text" <cfif modo NEQ "ALTA">value="#HTMLEditFormat(rsForm.AFTFnombre_dispositivo)#"</cfif>
			id="AFTFnombre_dispositivo" name="AFTFnombre_dispositivo" size="60" maxlength="80" 
			onFocus="javascript:this.select();" tabindex="1">
	</td>
  </tr>
  <tr>
    <td width="25%" align="right" class="fileLabel">Serie&nbsp;:&nbsp;</td>
    <td width="75%">
		<input type="text" <cfif modo NEQ "ALTA">value="#HTMLEditFormat(rsForm.AFTFserie_dispositivo)#"</cfif>
			id="AFTFserie_dispositivo" name="AFTFserie_dispositivo" size="60" maxlength="80" 
			onFocus="javascript:this.select();" tabindex="1">
	</td>
  </tr>
  <tr>
    <td width="25%" align="right">&nbsp;</td>
    <td width="75%" class="fileLabel">
		<input type="checkbox" <cfif modo NEQ "ALTA" and rsForm.AFTFestatus_dispositivo eq 1>checked</cfif>
			<cfif modo NEQ "ALTA" and rsForm.AFTFinactivar_permitido eq 0>disabled style="border:none; background-color:inherit;"</cfif>
			id="AFTFestatus_dispositivo" name="AFTFestatus_dispositivo" tabindex="1">
		Activo&nbsp;
	</td>
  </tr>
</table>

<cfset exclude = "">
<cfif modo NEQ "ALTA" and rsForm.AFTFinactivar_permitido eq 0>
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td><p align="center">Este Dispositivo Móvil se encuentra <br />en una hoja de conteo activa.</p></td>
	  </tr>
	</table>
	<cfset exclude = "baja">
</cfif>
<cf_botones modo="#modo#" tabindex="1" exclude="#exclude#">

</form>
</fieldset>
</cfoutput>

<cf_qforms>
	<cf_qformsrequiredfield args="AFTFcodigo_dispositivo,Código">
	<cf_qformsrequiredfield args="AFTFnombre_dispositivo,Descripción">	
	<cf_qformsrequiredfield args="AFTFserie_dispositivo,Serie">	
</cf_qforms>

<script language="javascript" type="text/javascript">
	<!--//
	/*Foco Inicial de la Pantalla*/
	objForm.<cfif modo NEQ "ALTA">AFTFnombre_dispositivo<cfelse>AFTFcodigo_dispositivo</cfif>.obj.focus();
	//-->
</script>