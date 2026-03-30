<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="excepciones-cf-sql.cfm">
<table width="100%" cellpadding="3" cellspacing="0">
	<tr>
		<td width="500" align="right"><strong>#vCentroFuncional#:</strong></td>
		<td><cf_rhcfuncional id="CFpk" tabindex="1"></td>
	</tr>
	<tr>
		<td align="right"><strong>#vObjeto1#:</strong></td>
		<td>
			<input	type ="text" name="valor1" id="valor1" value=""	tabindex="1" size="40" maxlength="100"
					onfocus		="this.value=qf(this); this.select();"
					onkeypress	="return _CFinputText_onKeyPress(this,event,100,0,false,false);"
					onkeyup		="_CFinputText_onKeyUp(this,event,100,0,false,false);"
					onblur		="if (window.funcvalor1) window.funcvalor1();" >		
		</td>
	</tr>
	<tr>
		<td align="right"><strong>#vObjeto2#:</strong></td>
		<td>
			<input	type ="text" name="valor2" id="valor2" value=""	tabindex="1" size="40" maxlength="100"
					onfocus		="this.value=qf(this); this.select();"
					onkeypress	="return _CFinputText_onKeyPress(this,event,100,0,false,false);"
					onkeyup		="_CFinputText_onKeyUp(this,event,100,0,false,false);"
					onblur		="if (window.funcvalor2) window.funcvalor2();" >		

		</td>
	</tr>
	<tr><td colspan="2" align="center"><cf_botones></td></tr>
</table>
</form>

<cf_qforms>
<script type="text/javascript" language="javascript1.2">
	objForm.CFpk.required = true;
	objForm.CFpk.description = '#vCentroFuncional#';
	objForm.valor1.required = true;
	objForm.valor1.description = '#vObjeto1#';
	objForm.valor2.required = true;
	objForm.valor2.description = '#vObjeto2#';
</script>

</cfoutput>