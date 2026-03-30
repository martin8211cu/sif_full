<cfset modo="ALTA">

<cfif isdefined("url.SNCcodigo") and (url.SNCcodigo gt 0) and not isdefined("form.SNCcodigo")>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>

	<cfif isdefined("form.MPVid")and (form.MPVid) GT 0>
		<cfset modo="CAMBIO">
	</cfif>
<cfif isDefined("session.CEcodigo") and isDefined("Form.SNCcodigo") and len(trim(#Form.SNCcodigo#)) NEQ 0>
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		select CEcodigo, SNCcodigo, SNCidentificacion , SNCnombre, SNCdireccion,  
			case SNCtipo when 'F' then 'Física' when 'J' then 'Jurídica' when 'E' then 'Extranjero' else '???' end as SNCtipo, 
			Ppais, SNCtelefono, 
			SNCFax, SNCemail, LOCidioma, SNCcertificado, SNCactivoportal, coalesce (SNCrlegal,'No se ha definido') as SNCrlegal, 
			SNCfecha, ts_rversion
		from SNegociosCorporativo
		where SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCcodigo#">
	</cfquery>
 	
	<cfif modo NEQ "ALTA">
		<cfquery name="rsMensajesPV" datasource="#Session.DSN#" >
			select  CEcodigo, MPVid, MPVmsg, MPVleido, ts_rversion
			from MensajesPV 
			where MPVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPVid#">
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCcodigo#">
		</cfquery>
	</cfif> 	
</cfif>


<script language="JavaScript" type="text/JavaScript">
<!--
//-->
</script>

<form action="MensajesPV-SQL.cfm" method="post" name="form1">
  <fieldset><legend><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Corporativo</strong></legend>
  <table width="100%" height="75" align="center" cellpadding="3" cellspacing="0" border="0">
    <tr bgcolor="#FFFFFF"> 
      <td width="27%" align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
	<tr bgcolor="#FFFFFF"> 
    	<td width="27%" align="right" valign="baseline" nowrap><strong>Socio:</strong></td>
		<td><cfoutput>#rsConsulta.SNCnombre#&nbsp;</cfoutput></td>
    </tr>
		<tr bgcolor="#FFFFFF"> 
    	<td width="27%" align="right" valign="baseline" nowrap><strong>C&eacute;dula:&nbsp;</strong></td>
		<td><cfoutput>#rsConsulta.SNCidentificacion#&nbsp;&nbsp;<strong>Tipo:</strong> #rsConsulta.SNCtipo#</cfoutput></td>
    </tr>
	
    <tr bgcolor="#FFFFFF"> 
      <td align="right" valign="middle" nowrap><strong>Mensaje&nbsp;a&nbsp;mostrar:&nbsp;</strong></td>
      <td width="80%" valign="middle">
		&nbsp;
	  <!--- <textarea style="width:85%"  name="MPVmsgd" onFocus="javascript: this.select();"><cfif modo NEQ "ALTA"><cfoutput>#rsMensajesPV.MPVmsg#</cfoutput></cfif></textarea> --->
	  </td>
    </tr>
   
      <td align="right" colspan="2" valign="baseline" nowrap>
	  <cfoutput>
	  <cfif modo EQ "CAMBIO">
		<cf_sifeditorhtml name="MPVmsga" value="#Trim(rsMensajesPV.MPVmsg)#">
	  <cfelse>
		<cf_sifeditorhtml name="MPVmsga">
	  </cfif>
	  </cfoutput> 
	  </td>
      <td align="right" valign="baseline" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="8" align="right" valign="baseline" nowrap> <div align="center"> 
          <cf_botones modo =#modo# include='Socios' includevalues='Socios'>
          <!--- <input name="btnSocios" type="button" value="Socios" onClick="javascript:socios();"> --->
        </div></td>
    </tr>
  </table>
  </fieldset>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsMensajesPV.ts_rversion#"/>
	</cfinvoke>
</cfif>  
  <cfoutput>
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
  <input type="hidden" name="SNCcodigo" value="#rsConsulta.SNCcodigo#">
  <cfif modo NEQ "ALTA">
  <input type="hidden" name="MPVid" value="#form.MPVid#">
  </cfif>
  <input type="hidden" name="modo" value="">
  </cfoutput>
</form>

<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">
<!--//
	function funcSocios() {
		document.form1.action='SNcorporativo.cfm';
		document.form1.submit();
	}
	//-->
</SCRIPT>
 
<!--- function deshabilitar(){
		objForm.MPVmsga.required = false;
	}
	
		
	function funcSocios() {
		deshabilitar();
		document.form1.action='SNcorporativo.cfm';
		document.form1.submit();
	
	}
	
	objForm.MPVmsga.required = true;
	objForm.MPVmsga.description="Mensaje"; --->