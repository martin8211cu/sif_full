<cf_templatecss>
<cf_web_portlet_start titulo="Detalle del Anticipo">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<style type="text/css">
	<!--
	.style1 {
		color: #FFFFFF;
		font-weight: bold;
	}
	-->
</style>

<cfif #url.GEAviatico# EQ 0>
	<cfif #url.GELid# NEQ "">
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#session.dsn#" name="listaDAnt">
		select c.CFcuenta,c.
			GEADmonto,
			c.GEADmonto,
			c.GEADmonto - (c.GEADutilizado) as Saldo,
			c.GEADutilizado,
			c.TESDPaprobadopendiente,	
			a.GEAid,
			a.GELAtotal,
			a.GELid,
			a.GEADid,
			f.CFformato,
			b.GECdescripcion,
			d.GEAnumero,
			b.GETid,
			d.GEAdesde,
			d.GEAdescripcion,
			d.GEAhasta,
			d.GEAfechaPagar,
			d.GEAmanual,
			d.GEAfechaSolicitud,
			d.GEAtotalOri,
			m.Miso4217,
	
			( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion
	
								from CFuncional cf 
								where cf.CFid = d.CFid
					) as CentroFuncional,
			(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
	
	
								from DatosEmpleado Em,TESbeneficiario te
								where d.TESBid=te.TESBid and   Em.DEid=te.DEid  
					) as Empleado,
					
			(select Mo.Mnombre
								from Monedas Mo
								where d.Mcodigo=Mo.Mcodigo
							)as Moneda,
							
			(select g.GETdescripcion
								from GEtipoGasto g
								where b.GETid=g.GETid
							)as TipoGasto,
							
	
					( select rtrim(ctf.CFformato) #LvarCNCT# ' ' #LvarCNCT# ctf.CFdescripcion
	
					from CFinanciera ctf
					where ctf.CFcuenta = d.CFcuenta
					)as Cuenta
			
			from 
			GEliquidacionAnts a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
					and c.GEADid=a.GEADid
						inner join CFinanciera f
						on f.CFcuenta = c.CFcuenta
				inner join GEconceptoGasto b
				on  b.GECid=c.GECid	
			inner join GEanticipo d
			on  d.GEAid=a.GEAid
				inner join Monedas m
				on d.Mcodigo= m.Mcodigo
			where a.GELid=#url.GELid#
				and d.GEAid = #url.GEAid#
				
		</cfquery>
	</cfif>
	
	<cfquery name="parametro" datasource="#Session.DSN#"> 
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 1200
	</cfquery>
	
	<cfquery name="ResultCF" datasource="#Session.DSN#">
		select 
			CFcuenta, 
			CFdescripcion, 
			CFformato
		from  CFinanciera 
		where CFcuenta = #parametro.Pvalor#
	</cfquery>
	
	<cfquery  name="rsCajaChica" datasource="#session.dsn#">
			select 
					CCHid,
					CCHdescripcion,
					CCHcodigo
			from CCHica
			where Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<table border="0" align="center" width="95%">
		<tr>
			<td colspan="2">
			<table width="697" border="0" align="center">
			<tr>
				<td width="27%" align="right"><strong> N° Solicitud de Anticipo: &nbsp;</strong></td>
				<td><cfoutput>#URL.GEAnumero#</cfoutput></td>
			</tr>			
			<tr>
				<td width="27%" align="right"><strong> N° Liquidación Asociada: &nbsp;</strong></td>
				<td><cfoutput>#URL.GELid#</cfoutput></td>
			</tr>
			
			<tr>
				<td width="27%" align="right"><strong>Empleado:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.Empleado#</cfoutput></td>
				<td width="19%" align="right"><strong>Centro Funcional:&nbsp;&nbsp;</strong></td>
				<td width="28%"><cfoutput>#listaDAnt.CentroFuncional#</cfoutput></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Moneda:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.Moneda#</cfoutput></td>
				<td width="19%" align="right"><strong>Total de Pago:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#NumberFormat(listaDAnt.GEAtotalOri ,"0.00")#</cfoutput></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Fecha de Pago:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.GEAfechaPagar#</cfoutput></td>
				<td width="19%" align="right"><strong>Cuenta:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#ResultCF.CFformato# - #ResultCF.CFdescripcion#</cfoutput></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Descripción:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.GEAdescripcion#</cfoutput></td>
				<td width="19%" align="right"><strong>Pagado por:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#rsCajaChica.CCHcodigo#-#rsCajaChica.CCHdescripcion#</cfoutput></td>
			</tr>
			<tr>
				<td colspan="7"><hr></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Tipo de Gasto:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.TipoGasto#</cfoutput></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Concepto de Gasto:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#listaDAnt.GECdescripcion#</cfoutput></td>
			</tr>
			<tr>
				<td width="27%" align="right"><strong>Monto Solicitado:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#NumberFormat(listaDAnt.GEADmonto ,"0.00")#</cfoutput></td>
			</tr>
		  </table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="btnclose" class="btnNormal" value="Cerrar" onClick="javascript:window.close()"></td>
	</tr>
	</table>
	
<cfelse>
	<cfset GEAid="#url.GEAid#">
	<cfset GELid="#url.GELid#">
	<cfquery name="rsPlantillas" datasource="#session.dsn#">
			select 
				gep.GEPVid,	gep.GEPVdescripcion,gep.Mcodigo,gep.GEPVmonto,
				mon.Mnombre,
							
				gec.GECVid,	gec.GECVcodigo,	gec.GECVdescripcion,
				
				ged.GEADfechaini,ged.GEADfechafin,ged.GEADhoraini,ged.GEADhorafin,ged.GEADmontoviatico,ged.GEADmonto,ged.GEADtipocambio,ged.GECid
				
				from GEanticipoDet ged
				
				inner join GEPlantillaViaticos gep
				on gep.GEPVid= ged.GEPVid
				
				inner join GEClasificacionViaticos gec
				on gep.GECVid=gec.GECVid
				
				inner join Monedas mon
					on mon.Mcodigo = gep.Mcodigo
					and mon.Ecodigo = gep.Ecodigo
					
				
				where ged.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and gep.Ecodigo=#session.ecodigo#
				
				
				UNION
				
			select 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GEPVid, '---' as GEPVdescripcion, ge.Mcodigo,  ged.GEADmonto as GEPVmonto,
				mon.Mnombre, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GECVid, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as GECVcodigo,gecg.GECdescripcion as GECVdescripcion,
				ged.GEADfechaini, ged.GEADfechafin, ged.GEADhoraini, ged.GEADhorafin, ged.GEADmonto as GEADmontoviatico , ged.GEADmonto, ged.GEADtipocambio, ged.GECid
				
				from GEanticipoDet ged
				
				inner join GEconceptoGasto gecg 
				on gecg.GECid= ged.GECid
				
				inner join GEanticipo ge
				on ge.GEAid=ged.GEAid
				
				inner join Monedas mon
					on mon.Mcodigo = ge.Mcodigo
					and mon.Ecodigo = ge.Ecodigo
					
				
				where ged.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and ge.Ecodigo=#session.ecodigo#
				and ged.GEADfechaini is  null
				
				order by GEPVid, GECVdescripcion
	</cfquery>

	
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select ge.GEAdesde, ge.GEAhasta, ge.GEAhoraini, ge.GEAhorafin, ge.GEAtipoviatico, ge.Mcodigo,Mnombre
			from GEanticipo ge
			
			inner join Monedas mon
					on mon.Mcodigo = ge.Mcodigo
					and mon.Ecodigo = ge.Ecodigo
					
			left outer join Htipocambio htc
					on htc.Mcodigo = mon.Mcodigo
					and <cf_dbfunction name="now"> between htc.Hfecha and htc.Hfechah  		
					
			where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
	</cfquery>
	
	<cfquery name="rsLiquidaciones" datasource="#session.dsn#">
		select 
			gep.GEPVid, gep.GEPVdescripcion, gep.Mcodigo, mon.Mnombre, gep.GEPVmonto, gec.GECVid, gec.GECVcodigo, gec.GECVdescripcion, gel.GELVfechaIni, gel.GELVfechaFin, 
			gel.GELVhoraIni, gel.GELVhorafin, gel.GELVmontoOri, gel.GEPVmontoGastMV, gel.GELVtipoCambio, gel.GELVmonto,gel.GECid
	
			from GEliquidacionViaticos gel 
			inner join GEPlantillaViaticos gep 
			on gep.GEPVid= gel.GEPVid 
	
			inner join GEClasificacionViaticos gec 
			on gep.GECVid=gec.GECVid 
	
			inner join Monedas mon 
			on mon.Mcodigo = gep.Mcodigo
			and mon.Ecodigo = gep.Ecodigo 
	
			where gel.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
			<cfif GEAid neq -1><!---si no es liquidacion directa--->
			and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
			</cfif>
			and gep.Ecodigo=#session.ecodigo# 
			
			UNION
	
		select 
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GEPVid, '---' as GEPVdescripcion, ge.Mcodigo,mon.Mnombre, gel.GELVmontoOri as GEPVmonto,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GECVid, 
			'-' as GECVcodigo,gecg.GECdescripcion as GECVdescripcion, 
			gel.GELVfechaIni, gel.GELVfechaFin, gel.GELVhoraIni, gel.GELVhorafin, gel.GELVmontoOri, gel.GEPVmontoGastMV,gel.GELVtipoCambio, gel.GELVmonto ,gel.GECid
			
			from GEliquidacionViaticos gel 
			
			inner join GEconceptoGasto gecg 
				on gecg.GECid= gel.GECid 
			
			inner join GEanticipo ge
				on ge.GEAid=gel.GEAid
			
			inner join Monedas mon 
			on mon.Mcodigo = ge.Mcodigo
			 and mon.Ecodigo = ge.Ecodigo 
			
			where gel.GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
			<cfif GEAid neq -1><!---si no es liquidacion directa--->
			and gel.GEAid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
			</cfif>
			and ge.Ecodigo=#session.ecodigo#  
			and gel.GELVfechaIni is  null

			order by GEPVid, GECVdescripcion
	</cfquery>

	<cfquery name="rsGELobservaciones" datasource="#session.dsn#">
		select GELobservaciones
			from GELiquidacion
			where GELid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GELid#">
	</cfquery>
	
	<cfoutput>	
	<table width="100%" border="0" align="center">
		<tr>
			<td><div align="left"><strong>Moneda: #rsDatos.Mnombre#</strong></div> </td>
			<td><div align="left"><strong>Fecha Inicio:  #LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY') #</strong></div></td>
			<td><div align="left"><strong>Fecha Final: #LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #</strong></div></td>
			<td><div align="left"><strong>Tipo: <cfif #rsDatos.GEAtipoviatico# eq 1> Interior <cfelseif  #rsDatos.GEAtipoviatico# eq 2> Exterior </cfif></strong></div></td>
		 </tr>
		<tr>
			<table width="100%" border="0" align="center">
				 <tr bgcolor="999999">
					<td width="129"><div align="center"><strong>Plantilla</strong></div></td>
					<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
					<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
					<td width="60"><div align="center"><strong>Hora Inicio</strong></div></td>
					<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
					<td width="60"><div align="center"><strong>Hora Final</strong></div></td>
					<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
					<td width="75"><div align="right"><strong>Monto Plantilla</strong></div></td>
					<td width="75"><div align="right"><strong>Tipo de Cambio </strong></div></td>
					<td width="75"><div align="right"><strong>Monto </strong></div></td>
				  </tr>
			</table>

		<cfif rsPlantillas.recordcount gt 0>
			<table width="100%" border="0" align="center">
			 	<cfloop query="rsPlantillas">
			 		<form name="form#GEPVid#">
						 <tr>
							<td width="148"><div align="center"><strong>
							  #GEPVdescripcion#
							</strong></div></td>
							<td width="148"><div align="center">
							 #GECVdescripcion#
							</div></td>
							<td width="80"><div align="center">
								#DateFormat(GEADfechaini,'DD/MM/YYYY')#
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhoraini#GEPVid#" form="form#GEPVid#" value="#GEADhoraini#" image="false" readOnly="true">
							</div></td>
							<td width="80"><div align="center">
							   #DateFormat(GEADfechafin,'DD/MM/YYYY')#
							</div></td>
							<td width="60"><div align="center">
								<cf_hora name="GEADhorafin#GEPVid#" form="form#GEPVid#" value="#GEADhorafin#" image="false" readOnly="true">
							</div></td>
								<td width="75"><div align="center">
								#Mnombre#  
							</div></td>
							<td width="75"><div align="right">
								#LSNumberFormat(GEADmontoviatico, ',9.00')#  
							</div></td>
							<td width="75"><div align="right">
								#LSNumberFormat(GEADtipocambio, ',9.00')#  
							</div></td>
							<td width="75"><div align="right">
								#LSNumberFormat(GEADmonto, ',9.00')#  
							</div></td>
						 </tr>
					</form>
				</cfloop>
			</table>
		</cfif>	
		&nbsp;&nbsp;&nbsp;&nbsp;
	 	<table width="100%" border="0" align="center">
			 <tr bgcolor="0033BB">
				<td colspan="4"><div align="center" class="style1" style="font-size:14px">Datos de la Liquidaci&oacute;n</div></td>
			</tr>
			<!---<tr>
				<td><div align="left"><strong>Moneda: #rsDatos.Mnombre#</strong></div> </td>
				<td><div align="left"><strong>Fecha Inicio:  #LSDateFormat(rsDatos.GEAdesde,'DD/MM/YYYY') #</strong></div></td>
				<td><div align="left"><strong>Fecha Final: #LSDateFormat(rsDatos.GEAhasta,'DD/MM/YYYY')  #</strong></div></td>
				<td><div align="left"><strong>Tipo: <cfif #rsDatos.GEAtipoviatico# eq 1> Interior <cfelseif  #rsDatos.GEAtipoviatico# eq 2> Exterior </cfif></strong></div></td>
			 </tr>--->
		 </table>

			<table width="100%" border="0" align="center" >
				 <tr bgcolor="999999">
						<td width="150"><div align="center"><strong>Plantilla</strong></div></td>
						<td width="159"><div align="center"><strong>Clasificaci&oacute;n</strong></div></td>
						<td width="80"><div align="center"><strong>Fecha Inicio</strong></div></td>
						<td width="65"><div align="center"><strong>Hora Inicio</strong></div></td>
						<td width="80"><div align="center"><strong>Fecha Final</strong></div></td>
						<td width="70"><div align="center"><strong>Hora Final</strong></div></td>
						<td width="75"><div align="center"><strong>Moneda Plantilla</strong></div></td>
						<td width="90"><div align="center"><strong>Monto Plantilla</strong></div></td>
						<td width="90"><div align="center"><strong>Monto Real </strong></div></td>
						<td width="65"><div align="center"><strong>Tipo de Cambio </strong></div></td>
						<td width="90"><div align="center"><strong>Monto </strong></div></td>
				  </tr>
			</table>
		   
	 	<cfif rsLiquidaciones.recordcount gt 0>
			 <form action="LiquidacionAnticiposViaticos_sql.cfm" method="post" name="formDet" id="formDet">
				<table width="100%" border="0" align="center">	 
				 	<cfloop query="rsLiquidaciones">	
						<tr>
							<td width="148"  nowrap="nowrap">
								<div align="center"><strong>
								  #GEPVdescripcion#
								 </strong></div>
							</td>
							<td width="148"  nowrap="nowrap">
								<div align="center">
									#GECVdescripcion#
								</div>
							</td>
							<td width="80"  nowrap="nowrap">
								<div align="center">
									<input type="text" name="FInicio" readonly="true" size="10" value="#DateFormat(GELVfechaIni,'DD/MM/YYYY')#"/>							
								</div>
							</td>
							<td width="60"  nowrap="nowrap">
								<div align="center">
									<cf_hora name="GELVhoraIni" form="formDet" value="#GELVhoraIni#" image="false" readOnly="true">
								</div>
							</td>
							<td width="80"  nowrap="nowrap">
								<div align="center">
									<input type="text" name="FFin" readonly="true" size="10" value="#DateFormat(GELVfechaFin,'DD/MM/YYYY')#"/>
								</div>
							</td>
							<td width="70"  nowrap="nowrap">
								<div align="center">
									<cf_hora name="GELVhorafin" form="formDet" value="#GELVhorafin#" image="false" readOnly="true">
								</div>
							</td>
							<td width="75"  nowrap="nowrap">
								<div align="center">
									#Mnombre#  
								</div>
							</td>
							<td width="90"  nowrap="nowrap">
								<div align="right">
									#LSNumberFormat(GELVmontoOri, ',9.00')#  
								</div>
							</td>
							<td width="90"  nowrap="nowrap">
								<div align="right">
									<cf_inputNumber name="montoReal" size="12" value="#GEPVmontoGastMV#" enteros="12" decimales="2" readonly="true">
								</div>
							</td>
							<td width="60" nowrap="nowrap">
								<div align="right">
									#LSNumberFormat(GELVtipoCambio, ',9.00')#  
								</div>
							</td>
							<td width="90" nowrap="nowrap">
								<div align="right">
								<input type="text" name="GELVmonto" value="#LSNumberFormat(GELVmonto,',9.00')#" readonly="true" size="12" align="left"/>
								</div>
							</td>
							<td width="10">
							</td>
						</tr>
					</cfloop>
				</table>
			</form>
		</cfif>
	<cfif len(trim(#rsGELobservaciones.GELobservaciones#))>	
		<tr>
			<td colspan="1" align="right">
				Observacion de porque el gasto fue mayor al anticipo:
			</td>
			<td colspan="1" align="left">
				<textarea name="obs" readonly="true" rows="2" cols="50">#rsGELobservaciones.GELobservaciones# </textarea>
			</td>
		</tr>	
	</cfif>
	<tr>
		<td colspan="2" align="center"><input type="button" name="btnclose" class="btnNormal" value="Cerrar" onClick="javascript:window.close()"></td>
	</tr>
	</tr>  
</table>	
</cfoutput>	
</cfif>	

<cf_web_portlet_end>
	
	