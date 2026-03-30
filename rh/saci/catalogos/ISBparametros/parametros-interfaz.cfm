<cfoutput>
	<form name="form1" method="post" action="parametros-apply.cfm" style="margin: 0;">
		<cfinclude template="parametros-hiddens.cfm">
		<table width="895" border="0" cellspacing="2" cellpadding="0">
		  <!--DWLayoutTable-->
			<tr>
				<td width="12" height="24">&nbsp;</td>
			    <td width="11">&nbsp;</td>
			    <td width="196">&nbsp;</td>
			    <td width="6">&nbsp;</td>
			    <td width="564">&nbsp;</td>
		    </tr>
			<tr>
				<td height="6" colspan="5">
					<cf_web_portlet_start tipo="box" width="100%">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					<tr><td width="20">
					<input type="checkbox" name="chk_500" id="chk_500" value="1" onChange="javascript: updParam500();" <cfif paramValues['500'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_500" value="#HtmlEditFormat(Trim(paramValues['500']))#">
				  </td><td>
			      <label for="chk_500">#HTMLEditFormat( parametrosDesc['500'] )#</label></td></tr></table><cf_web_portlet_end>				</td>
			</tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['510']#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <cfset thisValue = Trim(paramValues['510'])>
					  <select name="param_510" id="param_510" style="width:100%">
					  	<option value="ssh" <cfif thisValue is 'ssh'>selected="selected"</cfif>>Remota por ssh</option>
					  	<option value="shell" <cfif thisValue is 'shell'>selected="selected"</cfif>>Local</option>
					  </select></td>
		  </tr>
			<cfloop from="501" to="506" index="parm">
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc[parm]#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <input type="text" name="param_#parm#" maxlength="255" value="#HtmlEditFormat(Trim(paramValues[parm]))#" style="width: 100%" tabindex="1">								</td>
		  </tr></cfloop>
			<tr>
				<td height="6" colspan="5"><hr></td>
			</tr>
			<tr>
				<td height="6" colspan="5">
					<cf_web_portlet_start tipo="box" width="100%">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					<tr><td width="20">
					<input type="checkbox" name="chk_520" id="chk_520" value="1" onChange="javascript: updParam520();" <cfif paramValues['520'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_520" value="#HtmlEditFormat(Trim(paramValues['520']))#">
				  </td><td>
			      <label for="chk_520">#HTMLEditFormat( parametrosDesc['520'] )#</label></td></tr></table><cf_web_portlet_end>				</td>
			</tr><cfloop from="521" to="527" index="parm">
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc[parm]#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					<cfif parm is 526><!--- contraseña, trato especial --->
					  <input type="password" name="param_#parm#" maxlength="255" value="- secreto -" style="width: 100%" tabindex="1">
					<cfelse>
					  <input type="text" name="param_#parm#" maxlength="255" value="#HtmlEditFormat(Trim(paramValues[parm]))#" style="width: 100%" tabindex="1">
					  </cfif>					  </td>
		  </tr></cfloop>
			<tr>
			  <td height="26">&nbsp;</td>
		      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td valign="top">
				  <input type="checkbox" name="chk_528" id="chk_528" value="1" onChange="javascript: updParam528();" <cfif paramValues['528'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_528" value="#HtmlEditFormat(Trim(paramValues['528']))#">
			      <label for="chk_528">#parametrosDesc['528']#</label></td>
		  </tr>
			<tr>
				<td height="6" colspan="5"><hr></td>
			</tr>
			<tr>
				<td height="6" colspan="5">
					<cf_web_portlet_start tipo="box" width="100%">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					<tr><td width="20">
					<input type="checkbox" name="chk_540" id="chk_540" value="1" onChange="javascript: updParam540();" <cfif paramValues['540'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_540" value="#HtmlEditFormat(Trim(paramValues['540']))#">
				  </td><td>
			      <label for="chk_540">#HTMLEditFormat( parametrosDesc['540'] )#</label></td></tr></table><cf_web_portlet_end>				</td>
			</tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['550']#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <cfset thisValue = Trim(paramValues['550'])>
					  <select name="param_550" id="param_550" style="width:100%">
					  	<option value="ssh" <cfif thisValue is 'ssh'>selected="selected"</cfif>>Remota por ssh</option>
					  	<option value="shell" <cfif thisValue is 'shell'>selected="selected"</cfif>>Local</option>
					  </select></td>
		  </tr><cfloop from="541" to="542" index="parm">
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc[parm]#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <input type="text" name="param_#parm#" maxlength="255" value="#HtmlEditFormat(Trim(paramValues[parm]))#" style="width: 100%" tabindex="1">								</td>
		  </tr>
		  </cfloop>
			<tr>
              <td height="6" colspan="5"><hr /></td>
		    </tr>
			<tr>
              <td height="6" colspan="5"><cf_web_portlet_start tipo="box" width="100%">
                  <table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
                    <tr>
                      <td width="20">&nbsp;</td>
                      <td><label>Conexi&oacute;n de las interfaces a la salida JMS de RepConnector</label></td>
                    </tr>
                  </table>
                <cf_web_portlet_end>              </td>
		    </tr>
		  <cfloop from="560" to="565" index="parm">
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc[parm]#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <input type="text" name="param_#parm#" maxlength="255" value="#HtmlEditFormat(Trim(paramValues[parm]))#" style="width: 100%" tabindex="1">								</td>
		  </tr></cfloop>
			<tr>
				<td height="22" colspan="5" align="center">
					<cf_botones names="Guardar" values="Guardar" tabindex="1">				</td>
			</tr>
			<tr>
				<td height="22">&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
		    </tr>
		</table>
	</form>
	<script language="javascript" type="text/javascript">
		function updParam528() {
			document.form1.param_528.value = ((document.form1.chk_528.checked)?'1':'0');
		}
		function updParam500() {
			document.form1.param_500.value = ((document.form1.chk_500.checked)?'1':'0');
		}
		function updParam520() {
			document.form1.param_520.value = ((document.form1.chk_520.checked)?'1':'0');
		}
		function updParam540() {
			document.form1.param_540.value = ((document.form1.chk_540.checked)?'1':'0');
		}
	</script>
</cfoutput>
