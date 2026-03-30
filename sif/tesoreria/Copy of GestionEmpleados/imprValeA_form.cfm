<cf_htmlReportsHeaders 
	title="Impresion del Vale" 
	filename="SolicitudPago.xls"
	irA="TransaccionCustodiaP.cfm?regresar=1"
	download="no"
	preview="no"
>

<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>

<cfif isdefined('form.id') and form.id NEQ ''>
	<cf_dbfunction name="dateadd" args="da.GEADhoraini,da.GEADfechaini,MI" returnVariable="LvarFechaIni">
	<cf_dbfunction name="date_format" args="#LvarFechaIni#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaIni"	delimiters="°">
	<cf_dbfunction name="dateadd" args="da.GEADhorafin,da.GEADfechafin,MI" returnVariable="LvarFechaFin">
	<cf_dbfunction name="date_format" args="#LvarFechaFin#°DD/MM/YYYY HH:MI" returnVariable="LvarFechaFin"	delimiters="°">
	<cf_dbfunction name="concat" args="#LvarFechaIni#¬' - '¬#LvarFechaFin#" returnVariable="LvarFechas"  		delimiters="¬">
	<cfquery datasource="#session.dsn#" name="rsReporteTotal">
		Select 
			sa.CCHVnumero,            
			sa.CCHVestado,         
			sa.GEAid,  
			sa.CCHVusucodigoGenera,           
			sa.CCHVfecha,                    
			sa.BMUsucodigo,                
			sa.CCHVmontonOrig,             
			sa.CCHVmontoAplicado,            
			sa.CCHVusucodigoAplica,        
			e.Edescripcion,
			cfn.CFdescripcion,
			c.GEAdescripcion,
			c.GEAnumero,
			c.GEAtotalOri,
			tb.TESBeneficiario,
			
			( select CCHcodigo from CCHica x
				inner join GEanticipo p
				on p.CCHid = x.CCHid
				where p.GEAid = sa.GEAid
			) as CCHcodigo,
			
			(select Mo.Mnombre
					from Monedas Mo
					where c.Mcodigo=Mo.Mcodigo
				)as Moneda,
								
				<cf_dbfunction name="date_format"  args="sa.CCHVfechaAplica,DD/MM/YYYY"> as fecha, 
				<cf_dbfunction name="to_chartime"  args="sa.CCHVfechaAplica"> as hora,    

		(
			select  us.Usulogin	
				from STransaccionesProceso a
					inner join Usuario us
						on a.BMUsucodigo=us.Usucodigo
				where a.CCHTrelacionada= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#" >
				and a.CCHTestado='POR CONFIRMAR'
				and a.CCHTtipo='ANTICIPO'
		) as usuario,
			
		{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor
		
		,f.CFformato
		,cg.GECdescripcion
		,gep.GEPVdescripcion
		,gec.GECVdescripcion
		,gec.GECVid_Padre
		,da.GEADmonto
		,#preserveSingleQuotes(LvarFechas)#    as fechas
		
		from CCHVales sa
			inner join GEanticipo c
			on c.GEAid = sa.GEAid
			
				inner join Empresas e
			on e.Ecodigo=c.Ecodigo
			
				left outer join CFuncional cfn
			on cfn.CFid = c.CFid
			
				left outer join TESbeneficiario tb
			on tb.TESBid	= c.TESBid
			
			inner join Usuario u
				inner join DatosPersonales dp
				on dp.datos_personales=u.datos_personales
		on u.Usucodigo=sa.CCHVusucodigoGenera
		
		left join Usuario uR
		inner join DatosPersonales dpR
		on dpR.datos_personales=uR.datos_personales
		on uR.Usucodigo=sa.BMUsucodigo
		
		inner join GEanticipoDet da
			
			inner join GEconceptoGasto cg
			on da.GECid=cg.GECid
			
			inner join CFinanciera f
			on f.CFcuenta = da.CFcuenta
			
		on da.GEAid=c.GEAid
		
		left join GEPlantillaViaticos gep 
			on gep.GEPVid= da.GEPVid
					
		left join GEClasificacionViaticos gec 
			on gep.GECVid=gec.GECVid
			
			
	
		
		where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			and sa.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">	
			
			order by da.GEADfechaini,da.GEADhoraini,gep.GEPVid
	</cfquery>	
	
</cfif>

<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.style4 {font-size: 14px}
.style7 {font-size: 14px; font-weight: bold; }
.style8 {
	font-family: "Courier New", Courier, mono;
	font-size: 14px;
}
.style9 {font-family: Georgia, "Times New Roman", Times, serif}
-->
</style>

<cfoutput>
<cfif rsReporteTotal.recordcount gt 0>
	<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="25%">&nbsp;</td>
			<td width="55%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="4" align="center"><span class="style1">VALE DE CAJA CHICA</span></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><strong>(#rsReporteTotal.CCHVestado#)</strong></td>
		</tr>
	<cfif rsReporteTotal.CCHVestado EQ "0">
		<tr>
			<td colspan="4" align="center"><strong>*** IMPRESI&Oacute;N PRELIMINAR NO OFICIAL ***</strong></td>
		</tr>
	</cfif>
		<tr>
			<td nowrap><strong>CAJA   ASIGNADA:&nbsp;</strong></td>
			<td><span class="style4">#rsReporteTotal.CCHcodigo#</span></td>
			<td nowrap align="right"><strong>NM. VALE:&nbsp;&nbsp;</strong></td>
			<td nowrap align="center">#rsReporteTotal.CCHVnumero#</td>
		</tr>
		<tr>
			<td nowrap><strong>NOMBRE DE LA COMPA&Ntilde;IA:&nbsp;</strong></td>
			<td>
				<table width="100%"><tr>
					<td>
						<span class="style4">#rsReporteTotal.Edescripcion#</span>
					<td>
					<td style="text-align:right">
						<strong>C.F:</strong>&nbsp;<span class="style4">#rsReporteTotal.CFdescripcion#</span></td>
						<td>&nbsp;</td>
				</tr></table></td>
			<td nowrap align="right"><strong>FECHA VALE:&nbsp;&nbsp;</strong></td>
			<td nowrap align="left"><span class="style4">#rsReporteTotal.fecha#</span></td>
		  </tr>
		  <tr>
			<td></td>
			<td></td>
		  </tr>
		  <tr>
			<td><strong>VALOR EN LETRAS :</strong></td>
			<td colspan="4">#LvarObj.fnMontoEnLetras(rsReporteTotal.GEAtotalOri)# <strong>#rsReporteTotal.Moneda#</strong></td>
		  </tr>
		  <tr>
		    <td><strong>POR CONCEPTO DE :</strong></td>
			<td colspan="1" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">
			<!---<cfloop query="rsAnti">--->
						#rsReporteTotal.GEAdescripcion#
			<!---</cfloop>--->
			</td>
			<td nowrap align="right"><strong>Monto:&nbsp;&nbsp;</strong></td>
			<td nowrap align="center">#LSNumberFormat(rsReporteTotal.GEAtotalOri,',9.00')#</td>

	      </tr>
		  <tr>
		    <td><strong>A FAVOR DE :</strong></td>
			<td><span class="style4">#rsReporteTotal.TESBeneficiario#</span></td>
	      </tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="right">
				<table>
					<tr>
						<td align="right"><strong>EMITIDO:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.confeccionadoPor#</td>
					</tr>
					<tr>
						<td align="right"><strong>FECHA:</strong>&nbsp;&nbsp;</td>
						<td><span class="style4">#rsReporteTotal.fecha#</span></td>
					</tr>
					<tr>
						<td align="right"><strong>HORA:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.hora#</td>
					</tr>
				</table>
			</td>
		<tr>
			<td>&nbsp;</td>
		</tr>			  
	</table>
	<table width="100%"  border="1" cellspacing="0" cellpadding="0" class="caja">
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<!---<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">FECHA</span></td>--->
					<td width="580" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">DETALLE DEL VALE</span></td>
					<td width="550" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">FECHAS</span></td>
					<td width="260" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7">MONTO</span></td>


					<cfif rsReporteTotal.recordCount LT 19>
						<td width="10" valign="top" rowspan="19" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					<cfelse>
						<td width="10" valign="top" rowspan="#rsReporteTotal.recordCount + 3#" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="2%" nowrap>&nbsp;</td>
						<td width="98%" nowrap><strong>Vale de Caja Chica: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>					  					  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td><strong>Elaborado por: </strong></td>
					  </tr>
					  <tr>
					    <td width="98%" nowrap align="center">#rsReporteTotal.usuario#</td>
						<td>&nbsp;</td>
					  </tr>								  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>	  
					  <tr>
					    <td>&nbsp;</td>
						<td><strong>Recibido: </strong></td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>					  					  
					  <tr>
					    <td colspan="2" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;<!---#rsReporteTotal.Usulogin#---></td>
					  </tr>
					</table>					
				  <cfloop query="rsReporteTotal">
				  		
					<cfif len(trim(#GECVid_Padre#))>
						<cfquery name="rsGECVid_Padre" datasource="#session.dsn#">
							select GECVdescripcion from GEClasificacionViaticos where GECVid=#GECVid_Padre#
						</cfquery>
					</cfif>	
					  <cfset LvarListaNon = (CurrentRow MOD 2)>
					  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
						<!---<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.fecha#</span></td>--->
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">
							<cfif len(trim(#rsReporteTotal.GECVdescripcion#))>
								<cfif isdefined('rsGECVid_Padre.GECVdescripcion') and len(#rsGECVid_Padre.GECVdescripcion#)>
									#rsGECVid_Padre.GECVdescripcion#-
								</cfif>
								#rsReporteTotal.GECVdescripcion#-#rsReporteTotal.GEPVdescripcion# 
							<cfelse>
								#rsReporteTotal.GECdescripcion# 
							</cfif>
							</span>
						</td>
					<td align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#fechas#</span></td>						
					
						<!---<cfif rsReporteTotal.CCHVmontoAplicado GT 0>--->
							<td nowrap align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(rsReporteTotal.GEADmonto,',9.00')#</span>&nbsp;&nbsp;</td>
						<!---<cfelse>
							<td align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(Abs(rsReporteTotal.CCHVmontoAplicado),',9.00')#</span>&nbsp;&nbsp;</td>
						</cfif>--->
				
					  </tr>				  
				  </cfloop>		  
				  <tr class=<cfif LvarListaNon + 1>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon + 1>listaNon<cfelse>listaPar</cfif>';">
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
				<cfif rsReporteTotal.recordCount LT 19>
					<cfloop index = "LoopCount" from = "1" to = "#20 - rsReporteTotal.recordCount#">
					  <tr>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
						<td style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">&nbsp;</td>
					  </tr>			
					</cfloop>
				</cfif>
				</table>	
			</td>
		  </tr>
	</table>		
		  	
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from CCHVales v
		 where v.GEAid=#form.id#
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
			<cfif rsSQL.cantidad EQ 0>
				<td align="center"><strong>No se encontr&oacute; el vale seleccionadooo, favor int&eacute;ntelo de nuevo </strong></td>
			<cfelse>
				<td align="center"><strong>El vale esta vacio, favor int&eacute;ntelo de nuevo </strong></td>
			</cfif>
		</tr>	  
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td align="center">&nbsp;</td> 
		</tr>				  
	</table>
	</cfif>

</cfoutput>	