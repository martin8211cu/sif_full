<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Titulo"
		Default="Evaluaci&oacute;n"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>	


<table width="75%" align="center" cellpadding="0" cellspacing="0">
	<tr><td><cfinclude template="evaluar_des-form.cfm"></td></tr>
	<tr><td align="center">------ <cf_translate key="LB_Fin_del_reporte">Fin del reporte</cf_translate>------</td></tr>
</table>