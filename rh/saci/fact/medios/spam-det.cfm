<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="311" returnvariable="popServer"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="312" returnvariable="popUsername"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="313" returnvariable="popPassword"/>

<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#" name="este" action="getall" messagenumber="#url.messagenumber#"/>
<cfoutput>
<table width="900" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="142" align="right" valign="top"><strong>Asunto:</strong></td>
    <td width="15" valign="top">&nbsp;</td>
    <td width="731" valign="top"><strong>#HTMLEditFormat(este.subject)#</strong></td>
  </tr>
  
  <tr>
    <td align="right" valign="top"><strong>De:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(este.from)#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Fecha:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(este.Date)#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Para:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(este.to)#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>UID Mensaje:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(este.uid)#</td>
  </tr>
  <tr>
    <td align="right" valign="top"><strong>Encabezados Internet:</strong></td>
    <td valign="top">&nbsp;</td>
    <td valign="top">#HTMLEditFormat(este.header)#</td>
  </tr>
  <tr>
    <td colspan="3">
	<cfif Len(este.textBody)>
		# Replace( este.textBody, Chr(13), '<br />', 'all' )#
	<cfelseif Len(este.htmlBody )>
		#HTMLEditFormat(este.htmlBody )#
	<cfelse>
		- mensaje vacío -
	</cfif>	</td>
  </tr>
  <tr>
    <td colspan="3"><form action="spam-delete.cfm" method="post">
	<input type="hidden" name="filtro_From" value="# HTMLEditFormat( url.filtro_From )#">
	<input type="hidden" name="filtro_To" value="# HTMLEditFormat( url.filtro_To )#">
	<input type="hidden" name="filtro_Subject" value="# HTMLEditFormat( url.filtro_Subject )#">
	<input type="hidden" name="filtro_Date" value="# HTMLEditFormat( url.filtro_Date )#">
	<input type="hidden" name="PageNum_lista" value="# HTMLEditFormat( url.PageNum_lista )#">
	<input type="hidden" name="messagenumber" value="# HTMLEditFormat( url.messagenumber )#">
	<input type="submit" name="Borrar" value="Borrar Permanentemente"></form></td>
  </tr>
</table>
</cfoutput>