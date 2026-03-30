<cfif isdefined('url.RHEEid_f') and not isdefined('form.RHEEid_f')>
	<cfset form.RHEEid_f = url.RHEEid_f>
</cfif>
<cfif isdefined('url.RHPcodigo_f') and not isdefined('form.RHPcodigo_f')>
	<cfset form.RHPcodigo_f = url.RHPcodigo_f>
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<cfquery name="rsHabil" datasource="#session.DSN#">
	Select 	RHNEDid,
			coalesce(RHNEDpromedio,0) as RHNEDpromedio,
			coalesce(RHNnotamin,0) as RHNnotamin,
			coalesce(RHNEDnotajefe,0) as RHNEDnotajefe,
			RHHpeso,
			ned.RHHid,
			RHHdescripcion,
			led.DEid,
			{fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as nombreEmpl,
			coalesce(p.RHPcodigoext,p.RHPcodigo) as RHPcodigo,
			RHPdescpuesto,
			ed.RHEEid,
			RHEEdescripcion
	from RHEEvaluacionDes ed
		inner join RHListaEvalDes led
			on led.RHEEid=ed.RHEEid
				and led.Ecodigo=ed.Ecodigo
	
		inner join DatosEmpleado de
			on de.DEid=led.DEid
				and de.Ecodigo=led.Ecodigo
	
		inner join RHPuestos p
			on p.RHPcodigo=led.RHPcodigo
				and p.Ecodigo=led.Ecodigo
	
		inner join RHNotasEvalDes ned
			on ned.RHEEid=ed.RHEEid
				and ned.DEid=de.DEid
				
		inner join RHHabilidades ha
			on ha.RHHid=ned.RHHid
				and ha.Ecodigo=led.Ecodigo
	
		inner join RHHabilidadesPuesto hap
			on hap.RHHid=ha.RHHid
				and hap.RHPcodigo=p.RHPcodigo
				and hap.Ecodigo=ha.Ecodigo
	
	where ed.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ed.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid_f#">
		<cfif isdefined('form.RHPcodigo_f') and form.RHPcodigo_f NEQ ''>
			and led.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo_f#">
		</cfif>
		<cfif isdefined('form.DEid') and form.DEid NEQ ''>
			and led.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif> 
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
-->
</style>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="18%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
    <td width="14%">&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="15%">&nbsp;</td>
    <td width="16%">&nbsp;</td>
  </tr>
  <cfif isdefined('rsHabil') and rsHabil.recordCount GT 0 >
		<cfset varPuesto = "">
		<cfset varEmpl = "">  
		<cfset varHabil = "">  
		<cfset varEnc = 0>
		<cfset varPesoObt = 0>
		<cfset HoraReporte = Now()> 
		<cfset cuRew = 0>
		<cfset numPag = 0>
		<cfset maxLin = 35><!--- Maxima cantidad de lineas por pagina en la impresion --->				  
		<tr>
			<td colspan="6">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr class="areaFiltro">
						<td align="center"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
					</tr>			
					<tr><td>&nbsp;</td></tr>				  
					<tr>
						<td align="center"><span class="style1"><cf_translate key="LB_ConsultaComparativaRelacionDeEvaluacionPuesto">Consulta Comparativa Relaci&oacute;n de Evaluaci&oacute;n/Puesto</cf_translate></span></td>
					</tr>
					<tr>
						<td align="center"><span class="style1"><cfoutput>#rsHabil.RHEEdescripcion#</cfoutput></span></td>
					</tr>		
					<tr>
						<td align="center"><cfoutput><font size="2"><strong><cf_translate key="LB_FechaDeLaConsulta">Fecha de la Consulta</cf_translate>:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong><cf_translate key="LB_Hora">Hora</cf_translate>:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
					</tr>							
				</table>	
			</td>
		</tr>
		<tr><td colspan="6">&nbsp;</td></tr>    		
		<tr bgcolor="#CBDCDE">
			<td style="border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate></strong></td>
			<td style="border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Habilidad" XmlFile="/rh/generales.xml">Habilidad</cf_translate></strong></td>
			<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate></strong></td>
			<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_Peso">Peso</cf_translate></strong></td>
			<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_Nota">Nota Jefe</cf_translate></strong></td>
			<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_PesoObtenido">Peso Obtenido</cf_translate></strong></td>
			
		</tr>
		<tr><td colspan="6">&nbsp;</td></tr>					
		<cfoutput query="rsHabil">
			<cfset cuRew = CurrentRow>
			<cfset LvarListaNon = (cuRew MOD 2)>	  
			
		  	<cfif RHPcodigo NEQ varPuesto>
				<tr bgcolor="##E5E5E5">
					<td colspan="6" style="border-bottom: 1px solid gray;"><strong>#RHPdescpuesto#</strong></td>
				</tr>				
				<cfset varPuesto = RHPcodigo>
			</cfif>
			
		  	<cfif DEid NEQ varEmpl>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
					<td colspan="6">#nombreEmpl#</td>
				</tr>
				<cfset varEmpl = DEid>  
			</cfif>				

			<cfif RHHid NEQ varHabil>					  
				<cfset varPesoObt = 0>
				<cfset varPesoObt = (RHHpeso * RHNEDnotajefe) / 100>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
					<td>&nbsp;</td>
					<td>#trim(RHHdescripcion)#</td>
					<td align="right"><cfif RHNnotamin LT 100>#LSNumberFormat(RHNnotamin*100,"-__________.__")#<cfelse>#LSNumberFormat(RHNnotamin,"-__________.__")#</cfif></td>
					<td align="right">#LSNumberFormat(RHHpeso,"-__________.__")#</td>
					<td align="right">#LSNumberFormat(RHNEDnotajefe,"-__________.__")#</td>
					<td align="right">#LSNumberFormat(varPesoObt,"-__________.__")#</td>
				</tr>			
				<cfset varHabil = RHHid>
			</cfif>							
			
			<cfif isdefined('Url.imprimir') and cuRew mod maxLin EQ 0 and cuRew NEQ 1>
				<cfset numPag = numPag + 1>
				<!--- Numeracion de paginacion --->			
				  <tr>
					<td colspan="6" align="center">&nbsp;</td>
				  </tr>	
				  <tr>
					<td colspan="6" align="right"><strong><cf_translate key="LB_Pagina" XmlFile="/rh/generales.xml">P&aacute;gina</cf_translate>: #numPag#</strong></td>
				  </tr>  
				  <tr><td colspan="6" class="pageEnd" align="center">&nbsp;</td></tr>					
				  <!--- ENCABEZADO --->
					<tr>
						<td colspan="6">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr class="areaFiltro">
									<td align="center"><span class="style3">#Session.Enombre#</span></td>
								  </tr>			
								  <tr><td align="center">&nbsp;</td></tr>				  
								  <tr>
									<td align="center"><span class="style1"><cf_translate key="LB_ConsultaComparativaRelacionDeEvaluacionPuesto">Consulta Comparativa Relaci&oacute;n de Evaluaci&oacute;n/Puesto</cf_translate>
									</span></td>
								  </tr>
								  <tr><td align="center"><span class="style1">#RHEEdescripcion#</span></td></tr>		
								  <tr>
									<td align="center"><font size="2"><strong><cf_translate key="LB_FechaDeLaConsulta">Fecha de la Consulta</cf_translate>:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></td>
								  </tr>							
							</table>	
						</td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>    		
					<tr bgcolor="##CBDCDE">
						<td style="border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate></strong></td>
						<td style="border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Habilidad" XmlFile="/rh/generales.xml">Habilidad</cf_translate></strong></td>
						<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate></strong></td>
						<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_Peso">Peso</cf_translate></strong></td>
						<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_PesoObtenido">Nota Jefe</cf_translate></strong></td>
						<td style="border-bottom: 1px solid gray;" align="right"><strong><cf_translate key="LB_Nota">Peso Obtenido</cf_translate></strong></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>												     
			</cfif>
		</cfoutput>
		
		<cfif isdefined('Url.imprimir')>
			<cfset numPag = numPag + 1>		
			<tr><td colspan="6">&nbsp;</td></tr>		
			<tr><td colspan="6" align="right"><strong><cf_translate key="LB_Pagina" XmlFile="/rh/generales.xml">P&aacute;gina</cf_translate>: <cfoutput>#numPag#</cfoutput></strong></td></tr>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="center"><strong>------------------------ <cf_translate key="LB_UltimaPagina">Ultima P&aacute;gina</cf_translate> ------------------------</strong></td>
			</tr>		
			<tr><td colspan="6">&nbsp;</td></tr>													
		</cfif>
	<cfelse>		
	  <tr><td colspan="6">&nbsp;</td></tr>	
	  <tr>
		<td colspan="6" align="center"><strong>-- <cf_translate key="LB_NoExistenDatosParaElReporte">No existen datos para el reporte</cf_translate> --</strong></td>
	  </tr>	
	  <tr><td colspan="6" align="center">&nbsp;</td></tr>		  
	</cfif>  
</table>
