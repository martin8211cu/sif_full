<cfoutput>
	<form name="form1" method="post" action="parametros-apply.cfm" style="margin: 0;">
		<cfinclude template="parametros-hiddens.cfm">
		<table width="895" border="0" cellspacing="0" cellpadding="0">
		  <!--DWLayoutTable-->
			<tr>
				<td width="12" height="24">&nbsp;</td>
			    <td width="11">&nbsp;</td>
			    <td width="196">&nbsp;</td>
			    <td width="6">&nbsp;</td>
			    <td width="564">&nbsp;</td>
		    </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td colspan="4" valign="top">
				  <input type="checkbox" name="chk_300" id="chk_300" value="1" onChange="javascript: updParam300();" <cfif paramValues['300'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_300" value="#HtmlEditFormat(Trim(paramValues['300']))#">
			      <label for="label">#parametrosDesc['300']#</label></td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['301']#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <input type="text" name="param_301" 
					  	onblur="if(!validateEmail(this))alert('Formato de e-mail incorrecto');" 
					  	maxlength="255" value="#HtmlEditFormat(Trim(paramValues['301']))#" style="width: 100%" tabindex="1">								</td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['302']#:</label></td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td valign="top" nowrap>
			  <input type="text" name="param_302" 
			  	onblur="if(!validateHora24(this))alert('Formato de hora incorrecto');" 
			  	maxlength="255" value="#HtmlEditFormat(Trim(paramValues['302']))#" style="width: 200px" tabindex="1">
			  	(HH:MM:SS)
			  </td>
		  </tr>
			
			
			
			<tr>
				<td height="6" colspan="5"><hr></td>
			</tr>
			
			<tr>
			  <td height="26">&nbsp;</td>
			  <td colspan="4" valign="top">
				  <input type="checkbox" name="chk_310" id="chk_310" value="1" onChange="javascript: updParam310();" <cfif paramValues['310'] EQ '1'> checked</cfif> />
				  <input type="hidden" name="param_310" value="#HtmlEditFormat(Trim(paramValues['310']))#">
			      <label for="label">#parametrosDesc['310']#</label></td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['311']#:</label></td>
					  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					  <td valign="top">
					  <input type="text" name="param_311" 
					  	onblur="if(!validateIP(this))alert('Formato de Dirección IP inválido');" 
					  	maxlength="255" value="#HtmlEditFormat(Trim(paramValues['311']))#" style="width: 100%" tabindex="1">								</td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['312']#:</label></td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td valign="top">
			  <input type="text" name="param_312" maxlength="255" value="#HtmlEditFormat(Trim(paramValues['312']))#" style="width: 100%" tabindex="1">								</td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td align="right" valign="top"><label>#parametrosDesc['313']#:</label></td>
			  <td align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			  <td valign="top">
			  <input type="password" name="param_313" maxlength="255" value="#HtmlEditFormat(Trim(paramValues['313']))#" style="width: 100%" tabindex="1">								</td>
		  </tr>
			<tr>
			  <td height="26">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td valign="top">
				<input type="checkbox" name="chk_314" id="chk_314" value="1" onChange="javascript: updParam314();" <cfif paramValues['314'] EQ '1'> checked</cfif> />
				<input type="hidden" name="param_314" value="#HtmlEditFormat(Trim(paramValues['314']))#">
		        <label for="chk_314">#parametrosDesc['314']#</label>								</td>
	      </tr>
			<tr>
			  <td height="28">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
			
			
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
	
		// validate an email address
		function isValidEmail(e)
		{
			// assume an email address cannot start with an @ or white space, but it
			// must contain the @ character followed by groups of alphanumerics and '-'
			// followed by the dot character '.'
			// It must end with 2 or 3 alphanumerics.
			//
			var alnum="a-zA-Z0-9";
			exp="^[^@\\s]+@(["+alnum+"+\\-]+\\.)+["+alnum+"]["+alnum+"]["+alnum+"]?$";
			emailregexp = new RegExp(exp);
		
			result = e.match(emailregexp);
			if (result != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		function isValidTime(strTime) {
			// Checks if time is in HH:MM:SS format.
			// The seconds are optional.
		
			var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?$/;
			var matchArray = strTime.match(timePat);
			if (matchArray == null) {
				return false;
			}
		
			hour = matchArray[1];
			minute = matchArray[2];
			second = matchArray[4];
		
			if (second=="") { second = null; }
		
			if (hour < 0  || hour > 23) {
				return false;
			}
		
			if (minute<0 || minute > 59) {
				return false;
			}
			if (second != null && (second < 0 || second > 59)) {
				return false;
			}
			return true;
		}
		
		function isValidIP(strIP) {
			// XXX.XXX.XXX.XXX
		
			var IpPat = /^(\d{1,3}).(\d{1,3}).(\d{1,3}).(\d{1,3})$/;
			var matchArray = strIP.match(IpPat);
			if (matchArray == null) {
				return false;
			}
		
			v1 = matchArray[1];
			v2 = matchArray[2];
			v3 = matchArray[3];
			v4 = matchArray[4];
		
			if (v1 < 0  || v1 > 255) {
				return false;
			}
		
			if (v2 < 0  || v2 > 255) {
				return false;
			}
			
			if (v3 < 0  || v3 > 255) {
				return false;
			}
			
			if (v4 < 0  || v4 > 255) {
				return false;
			}
			
			return true;
		}
			
		function updParam300() {
			document.form1.param_300.value = ((document.form1.chk_300.checked)?'1':'0');
		}

		function updParam310() {
			document.form1.param_310.value = ((document.form1.chk_310.checked)?'1':'0');
		}
		
		function updParam314() {
			document.form1.param_314.value = ((document.form1.chk_314.checked)?'1':'0');
		}
		function validateHora24(obj){
			return isValidTime(obj.value);
		}
		
		function validateEmail(obj){
			return isValidEmail(obj.value);
		}
		
		function validateIP(obj){
			return isValidIP(obj.value);
		}
		
		function funcGuardar(){
			var msg = "";
			if(!validateHora24(document.form1.param_302)){
				msg += "- #parametrosDesc['302']#, No cumple el formato indicado.";
			}
			
			if(!validateEmail(document.form1.param_301)){
				msg += "\n- #parametrosDesc['301']#, No corresponde a un formato de e-mail válido.";
			}
			
			if(!validateIP(document.form1.param_311)){
				msg += "\n- #parametrosDesc['311']#, No corresponde a un formato de Direccion IP válida.";
			}
			
			if (msg.length > 0){
				alert(msg);
				return false;
			}
			else
				return true;
		}		
	</script>
	
</cfoutput>
