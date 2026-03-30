<cfoutput>
	<cfif isdefined("tabChoice") and tabChoice EQ 1>
		<form name="doForm" action="#GetFileFromPath(GetTemplatePath())#" method="post" style="margin: 0">
			<table border="0" cellspacing="0" cellpadding="2" align="right">
			  <tr align="center">
				<td style="padding-right: 20px;"><a href="javascript: if (window.deleteMsg) deleteMsg();" onMouseOver="javascript: window.status='Eliminar todos los mensajes seleccionados'; return true;" onMouseOut="javascript: window.status=''; return true;" ><img border="0" src="../Imagenes/email/totrash.gif" width="25" height="26"></a></td>
			  </tr>
			  <tr align="center">
				<td style="padding-right: 20px;"><a href="javascript: if (window.deleteMsg) deleteMsg();" onMouseOver="javascript: window.status='Eliminar todos los mensajes seleccionados'; return true;" onMouseOut="javascript: window.status=''; return true;" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Eliminar</strong></font></a></td>
			  </tr>
			</table>
		</form>
	<cfelseif isdefined("tabChoice") and tabChoice EQ 3 and isdefined("Form.Bcodigo") and Len(Trim(Form.Bcodigo)) NEQ 0>
		<form name="doForm" action="#GetFileFromPath(GetTemplatePath())#" method="post" style="margin: 0">
			<table border="0" cellspacing="0" cellpadding="2" align="right">
			  <tr align="center">
				<td style="padding-right: 20px;"><a href="javascript: if (window.replyMsg) replyMsg();" onMouseOver="javascript: window.status='Responder a este mensaje'; return true;" onMouseOut="javascript: window.status=''; return true;" ><img border="0" src="../Imagenes/email/reply.gif" width="25" height="26"></a></td>
				<!--- <td style="padding-right: 20px;"><img border="0" src="../Imagenes/email/forward.gif" width="25" height="26"></td> --->
				<td style="padding-right: 20px;"><a href="javascript: if (window.deleteMsg) deleteMsg();" onMouseOver="javascript: window.status='Eliminar este mensaje'; return true;" onMouseOut="javascript: window.status=''; return true;" ><img border="0" src="../Imagenes/email/totrash.gif" width="25" height="26"></a></td>
			  </tr>
			  <tr align="center">
				<td style="padding-right: 20px;"><a href="javascript: if (window.replyMsg) replyMsg();" onMouseOver="javascript: window.status='Responder a este mensaje'; return true;" onMouseOut="javascript: window.status=''; return true;" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Responder</strong></font></a></td>
				<!--- <td style="padding-right: 20px;"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Reenviar</strong></font></td> --->
				<td style="padding-right: 20px;"><a href="javascript: if (window.deleteMsg) deleteMsg();" onMouseOver="javascript: window.status='Eliminar este mensaje'; return true;" onMouseOut="javascript: window.status=''; return true;" ><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Eliminar</strong></font></a></td>
			  </tr>
			</table>
		</form>
	</cfif>
</cfoutput>