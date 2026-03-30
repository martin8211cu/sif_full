<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
		Mensaje de Error
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
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
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->