<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
  <cfset Form.DEid = Url.DEid>
</cfif>

<cfif isDefined("Url.id_centro") and not isDefined("Form.id_centro")>
  <cfset Form.id_centro = Url.id_centro>
</cfif>

<cfif isDefined("Url.fdesde") and not isDefined("Form.fdesde")>
  <cfset Form.fdesde = Url.fdesde>
</cfif>

<cfif isDefined("Url.fhasta") and not isDefined("Form.fhasta")>
  <cfset Form.fhasta = Url.fhasta>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#Session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
		<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Reporte_Control_Pago_de_Horas"  xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Reporte Control Pago de Horas</cf_translate></strong></td>
	</tr>
</table>

<cfinclude template="queryCtrlPagoHoras.cfm">

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="6">&nbsp;</td>
  </tr>
  <tr class="listaCorte">
	<td><strong><cf_translate key="LB_Empleado" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Empleado</cf_translate></strong></td>
	<td><strong><cf_translate key="LB_Centro_Funcional" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Centro Funcional</cf_translate></strong></td>
	<td><strong><cf_translate key="LB_Concepto_de_pago" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Concepto de pago</cf_translate></strong></td>
	<td><strong><cf_translate key="LB_Jornada" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Jornada</cf_translate></strong></td>
	<td><strong><cf_translate key="LB_Autorizado" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Autorizado</cf_translate></strong></td>
	<td><strong><cf_translate key="LB_Cantidad_Horas" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Cantidad Horas</cf_translate></strong></td>
  </tr>  
	<cfif rsProc.RecordCount NEQ 0>
		<cfset IdEmpleado = 0>
		<cfset descCF = "">
		<cfset NumLinea = 1>
		<cfset totHorEmpl = 0>
		<cfset totGenCF = 0>
		
		<cfoutput query="rsProc">
			<cfflush interval="512">		
			<cfset NumLinea = NumLinea + 1>
			<cfif descCF NEQ rsProc.CFdescripcion>
				<cfif totGenCF GT 0>
					  <tr>
						<td colspan="6">&nbsp;</td>
					  </tr>				
					  <tr>
						<td colspan="5" align="right"><strong><cf_translate key="LB_Total_Horas" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Total Horas</cf_translate> #descCF#</strong></td>
						<td align="right" style="border-top-width: 1px; border-top-style: solid;border-top-color: gray;border-bottom-width: 1px; border-bottom-style: solid;border-bottom-color: gray;"><strong>#LSNumberFormat(totGenCF,'9.00')#</strong></td>
					  </tr>			
					  <cfset totGenCF = 0>
				</cfif>			
			  <tr>
				<td colspan="6">&nbsp;</td>
			  </tr>					
			  <tr class="listaCorte">
				<td colspan="6"><font size="2"><strong><cf_translate key="LB_Centro_Funcional" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Centro Funcional</cf_translate>: #rsProc.CFcodigo# #rsProc.CFdescripcion#</strong></font></td>
			  </tr>
			  <tr>
				<td colspan="6">&nbsp;</td>
			  </tr>			  
			  <cfset descCF = rsProc.CFdescripcion>
			</cfif>
			<cfif totHorEmpl GT 0 and IdEmpleado NEQ rsProc.DEid>
				  <tr>
					<td colspan="5" align="right"><strong><cf_translate key="LB_Total_de_Horas" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Total de Horas</cf_translate> </strong></td>
					<td align="right" style="border-top-width: 1px; border-top-style: solid;border-top-color: gray;"><strong>#LSNumberFormat(totHorEmpl,'9.00')#</strong></td>
				  </tr>			
			</cfif>
			  <tr>
			<cfif IdEmpleado NEQ rsProc.DEid>
				<td class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">&nbsp;&nbsp;&nbsp;#rsProc.DEidentificacion#&nbsp;&nbsp;#rsProc.NombreEmpleado#</td>			
			  	<cfset IdEmpleado = rsProc.DEid>
				<cfset totGenCF = totGenCF + totHorEmpl>
				<cfset totHorEmpl = 0>
			 <cfelse>
				<td class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">&nbsp;</td>			 
			</cfif>					  
				<td class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#rsProc.CFcodigo#</td>
				<td class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#rsProc.CIcodigo#&nbsp;&nbsp;&nbsp;#rsProc.CIdescripcion#</td>				
				<cfif rsProc.JornadaPlanif NEQ ''>
					<td align="center" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#rsProc.JornadaPlanif#</td>
				<cfelseif rsProc.JornadaLineaT NEQ ''>
					<td align="center" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#rsProc.JornadaLineaT#</td>
				</cfif>
				<td align="center" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#rsProc.RetenerPago#</td>
				<td align="right" class="<cfif NumLinea MOD 2>listaPar<cfelse>listaNon</cfif>">#LSNumberFormat(rsProc.sumaHorasAutor,'9.00')#</td>
			  </tr>
			  <cfif rsProc.sumaHorasAutor NEQ '' and rsProc.sumaHorasAutor GTE 0>
				<cfset totHorEmpl = totHorEmpl + rsProc.sumaHorasAutor>  
			  </cfif>
		  </cfoutput>
		<cfif totHorEmpl GT 0>
			<cfset totGenCF = totGenCF + totHorEmpl>
			  <tr>
				<td colspan="5" align="right"><strong><cf_translate key="LB_Total_de_Horas" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Total de Horas </cf_translate></strong></td>
				<td align="right" style="border-top-width: 1px; border-top-style: solid;border-top-color: gray;"><strong><cfoutput>#LSNumberFormat(totHorEmpl,'9.00')#</cfoutput></strong></td>
			  </tr>			
		</cfif>		  
		<cfif totGenCF GT 0>
			  <tr>
				<td colspan="6">&nbsp;</td>
			  </tr>		
			<cfoutput>
			  <tr>
				<td colspan="5" align="right"><strong><cf_translate key="LB_Total_Horas" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Total Horas</cf_translate> #descCF#</strong></td>
				<td align="right" style="border-top-width: 1px; border-top-style: solid;border-top-color: gray; border-bottom-width: 1px; border-bottom-style: solid;border-bottom-color: gray;"><strong>#LSNumberFormat(totGenCF,'9.00')#</strong></td>
			  </tr>			
			  <cfset totGenCF = 0>
			</cfoutput>
		</cfif>				
		  <tr>
			<td colspan="6">&nbsp;</td>
		  </tr>			  
		  <tr>
			<td colspan="6" align="center">
				<strong>
					------------------------------ <cf_translate key="LB_Fin_del_Reporte" xmlfile="/rh/marcas/consultas/ctrlPagoHoras-form.xml">Fin del Reporte</cf_translate>--------------------------------------
				</strong>
			</td>
		  </tr>				  
	</cfif>
  
</table>
