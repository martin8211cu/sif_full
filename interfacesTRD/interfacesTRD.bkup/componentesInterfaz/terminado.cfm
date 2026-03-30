
<cf_templateheader title="Proceso de Interfaz Terminado">
<cf_web_portlet_start titulo="Proceso de Interfaz Terminado">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
<tr><td valign="top" width="50%">

<cfif not IsDefined("url.Regresa")>
	<cfabort showerror="Error No se Definio que Interfaz se ejecuto">
</cfif>

<cfset VarRegreso = "#url.Regresa#?botonsel=btnRegresar">
<cfoutput>
<form action="#VarRegreso#" method="post">
<center>
<br /><br /><br /><br /><br />Proceso Terminado
<br /><br /><input type="submit" value="Aceptar" />
<br /><br /><br /><br /><br /></center></form>
</cfoutput>
</td></tr></table>
<cf_web_portlet_end>
<cf_templatefooter>
