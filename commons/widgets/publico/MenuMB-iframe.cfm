<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Men&uacute; Principal de Bancos" returnvariable="LB_Titulo" xmlfile="MenuMB.xml"/>

<style>
	.smenu1 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #ffffff; background-color: #98B1C4; text-decoration: none; }
	.smenu2, .smenu3 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #293D6B; background-color: #C8D7E3; text-decoration: none; }
	.smenu33 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: bold; color: #293D6B; background-color: #ffffff; text-decoration: none; }
	.smenu4, .smenu5 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: normal; color: #293D6B; background-color: #C8D7E3; text-decoration: none; }
	.smenu55 {padding-top: 3px; padding-bottom: 4px; padding-left: 4px; padding-right: 5px; font-family: Verdana, Arial, sans-serif; font-size: 9px; font-weight: normal; color: #293D6B; background-color: #ffffff; text-decoration: none; }
	.table_border_gray{border:1px solid #ccc;}
</style>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	 <tr>
		<td  valign="top" width="100%" height="50%" style="font-family:Lucida Sans Unicode;font-size:small">
			<cfinclude template="MenuConsulta.cfm">
		</td>
	 </tr>
</table>
