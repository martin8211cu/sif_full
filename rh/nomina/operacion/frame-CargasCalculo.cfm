<cfquery name="rsCargasCalculo" datasource="#Session.DSN#">
	select 	a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
	from CargasCalculo a, DCargas b, ECargas c
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.DClinea = b.DClinea
	and b.ECid = c.ECid
</cfquery>
<tr>
	<td colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><cf_translate key="LB_Cargas">Cargas</cf_translate></div></td>
</tr>
<tr>
	<td align="left" class="FileLabel">&nbsp;</td>
	<td align="left" class="FileLabel" colspan="4"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
	<td>&nbsp;</td>
	<td align="right" class="FileLabel"><cf_translate key="LB_MontoPatrono">Monto Patrono</cf_translate></td>
	<td align="right" class="FileLabel"><cf_translate key="LB_MontoEmpleado">Monto Empleado</cf_translate></td>
	<td align="right" class="FileLabel">&nbsp;</td>
</tr>
<cfoutput query="rsCargasCalculo">
	<cfset ProcesarCarga = "ProcesarCarga('#DClinea#')">
	<cfset LvarListaNon = (CurrentRow MOD 2)>
	<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
	<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
		<td align="left" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" >
			&nbsp;</td>
		<td align="left" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" colspan="4">
			#DCdescripcion#</td>
		<td align="left" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" >
			&nbsp;</td>
		<td align="right" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" >
			#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
		<td align="right" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" >
			#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
		<td align="right" style="padding-right: 3px; cursor: pointer;" onclick="javascript: #ProcesarCarga#" >
			&nbsp;</td>
	</tr>
<script language="javascript" type="text/javascript">
	var popUpWinCargas=0;
	var width = 600;
	var height = 650;
	var top = 80;
	var left = 190;
	function ProcesarCarga(DClinea){
		var URLStr="ResultadoCalculoCarga.cfm?RCNid=#form.RCNid#&DEid=#form.DEid#&Tcodigo=#form.Tcodigo#&DClinea="+DClinea;
  		//document.location.href=URLStr;
  		if(popUpWinCargas)
		{
			if(!popUpWinCargas.closed) popUpWin.close();
  		}
  		popUpWinCargas = open(URLStr, 'popUpWinCargas', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=yes, width='+width+', height='+height+', left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
</script>
</cfoutput>