<cf_template>
<cf_templatearea name="title">SOIN
</cf_templatearea>
<cf_templatearea name="left">
</cf_templatearea>
<cf_templatearea name="body">
	<form method="post">
	<table height="100%" width="100%">
		<tr>
			<td valign="middle" height="100">
				<font color="#FF0000" size="2">
				<cfoutput>#error.message#</cfoutput>
				</font> 
			</td>
		</tr>
		<tr>
			<td align="center" height="1">
				<input type="button" value="Regresar" onClick="javascript:history.go(-1)">
				<!---
				<input name="btnDBmsgAceptar" type="submit" value="Aceptar">
				<cfoutput>
				<cfloop collection="#form#" item="inp">
					<input type="hidden" name="#inp#" value="#StructFind(form, inp)#">
				</cfloop>
				</cfoutput>
				--->
			</td>
		</tr>
	</table>
 	</form> 
</cf_templatearea>
</cf_template>