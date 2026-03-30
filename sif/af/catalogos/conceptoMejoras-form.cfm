
<cfsilent>

<cfset modo="ALTA">
<cfif isdefined("Form.AFCMid") and len("Form.AFCMid") NEQ 0 and Form.AFCMid gt 0>
    <cfset modo="CAMBIO">
    <cfquery name="rsSelect" datasource="#session.dsn#">
    	select * 
        from AFConceptoMejoras 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and AFCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFCMid#">
    </cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" 
			returnvariable="ts" artimestamp="#rsSelect.ts_rversion#"/>
</cfif>

</cfsilent>
<cfoutput>
<fieldset><legend>Mantenimiento de Conceptos de Mejoras</legend>
<form action="conceptoMejoras-sql.cfm" method="post" name="form1" style="margin:0px">
<cfif modo NEQ "ALTA">
<input type="hidden" name="ts_rversion" value="#ts#" >
<input type="hidden" name="AFCMid" value="#rsSelect.AFCMid#">
</cfif>
<input type="hidden" name="Pagina" value="#form.Pagina#">
<input type="hidden" name="MaxRows" value="#form.MaxRows#">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="fileLabel">
    <td width="25%" align="right" class="fileLabel">C&oacute;digo&nbsp;:&nbsp;</td>
    <td width="75%">
		<input type="text" <cfif modo NEQ "ALTA">class="cajasinbordeb" readonly value="#HTMLEditFormat(rsSelect.AFCMcodigo)#" tabindex="-1"<cfelse>tabindex="1"</cfif>
			id="AFCMcodigo" name="AFCMcodigo" size="20" maxlength="20" 
			onFocus="javascript:this.select();">
	</td>
  </tr>
  <tr>
    <td width="25%" align="right" class="fileLabel">Descripci&oacute;n&nbsp;:&nbsp;</td>
    <td width="75%">
		<input type="text" <cfif modo NEQ "ALTA">value="#HTMLEditFormat(rsSelect.AFCMdescripcion)#"</cfif>
			id="AFCMdescripcion" name="AFCMdescripcion" size="60" maxlength="80" 
			onFocus="javascript:this.select();" tabindex="1">
	</td>
  </tr>
</table>

<cf_botones modo="#modo#" tabindex="1" >

</form>
</fieldset>
</cfoutput>

<cf_qforms>
	<cf_qformsrequiredfield args="AFCMcodigo,Código">
	<cf_qformsrequiredfield args="AFCMdescripcion,Descripción">	
</cf_qforms>

<script language="javascript" type="text/javascript">
	<!--//
	/*Foco Inicial de la Pantalla*/
	objForm.<cfif modo NEQ "ALTA">AFCMdescripcion<cfelse>AFCMcodigo</cfif>.obj.focus();
	//-->
</script>