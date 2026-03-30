<!--- 
Creado por Jose Gutierrez 
	27/04/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Evaluar Categor&iacute;a')>
<cfset TIT_EvaluarCategoria 	= t.Translate('TIT_EvaluarCategoria','Evaluar Categor&iacute;a')>

<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_EvaluarCategoria#'>


<cfinclude template="../../../sif/Utiles/sifConcat.cfm">

<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td width="50%" valign="top">
			<cfinclude template="EvaluarCategoria_form.cfm">
		</td>
	</tr>
</table>
<cf_web_portlet_end>			

<cf_templatefooter>

</cfoutput>


