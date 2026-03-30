<cf_templateheader title="Notificación de Agente">
<cf_web_portlet_start titulo="Notificación de Agente">


<cfparam name="form.AMid" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBagenteEmail 
	where AMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AMid#" null="#Len(form.AMid) Is 0#">
</cfquery>

<form name="form1" method="post"  style="margin: 0;">
	<cfoutput>
	<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />	
	<cfinclude template="agente-hiddens.cfm">


<table width="950" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="80" align="right" valign="top"><strong>Asunto:</strong></td>
    <td width="3" valign="top">&nbsp;</td>
    <td width="358" valign="top"><strong>#HTMLEditFormat(data.AMEsubject)#</strong></td>
  </tr>
  
  <tr>
    <td align="right" valign="top"><strong>De:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(data.AMEfrom)#</td>
    <td align="right" valign="top"><strong>Tipo de Notificaci&oacute;n:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><cfif data.AMtipo is 'H'>
      Habilitaci&oacute;n
      <cfelseif data.AMtipo is 'P'>
      Preventiva
      <cfelseif data.AMtipo is 'I'>
      Inhabilitaci&oacute;n
      <cfelse>
      #data.AMtipo#
    </cfif></td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Fecha:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#DateFormat(data.AMErecibido,'dd/mm/yyyy')# #TimeFormat(data.AMErecibido,'HH:mm:ss')#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Para:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(data.AMEto)#</td>
  </tr>
  
  <tr>
    <td colspan="6" align="left" valign="top">&nbsp;</td>
    </tr>
  
  <tr>
    <td colspan="3" valign="top">
	<cfif Len(data.AMEbody)><div style="border:1px solid black;padding:10px;width:95%;height:200px;overflow:scroll;">
		<strong>Texto del mensaje:<br /></strong> <cfset bodyStart = FindNoCase('<body', data.AMEbody)>
		<cfset bodyEnd = FindNoCase('</body>', data.AMEbody)>
		<cfif bodyStart And bodyEnd and bodyStart LT bodyEnd>
			<cfset bodyStart = FindNoCase('>', data.AMEbody, bodyStart)>
			# Mid(data.AMEbody, bodyStart+1, bodyEnd - bodyStart -1 )#
		<cfelse>
			#HTMLEditFormat(data.AMEbody)#
		</cfif>
	<cfelse>-mensaje vacío-</cfif></div></td>
	
	</tr>		
</table>
</cfoutput>
</form>

<cfoutput>	
<form action="Javascript:void(0)">
	<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: location.href='agente.cfm?tab=#form.tab#' + '&paso=1' + '&AGid=' + '#form.AGid#';">     
</form>
</cfoutput>

<cf_web_portlet_end> 
<cf_templatefooter>


