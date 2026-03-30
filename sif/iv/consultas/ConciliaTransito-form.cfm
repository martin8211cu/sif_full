<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cf_sifHTML2Word Titulo="Artículos">
	<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 10px;
			padding-bottom: 10px;
		}
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
			border-top-color: #CCCCCC;
		}
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
			border-bottom-color: #CCCCCC;
		}
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
	}
	</style>
	<cfif isdefined("url.ckPend")>
		<cfset form.ckPend = url.ckPend>
	</cfif>
	<cfif isdefined('Url.ETid') and ltrim(rtrim(Url.ETid)) NEQ 0 and not isdefined("form.ETid")>
		<cfset form.ETid = Url.ETid>
	</cfif>
	<script language="javascript" type="text/javascript">
		<!--//
		function showDetail(aid) {
			document.form1.Aid.value = aid;
			document.form1.submit();
		}
		//-->
	</script>
	<form name="form1" method="post" action="ConciliaArticuloDetail.cfm">
	  <input type="hidden" name="ETid" value="<cfoutput>#Form.ETid#</cfoutput>">
	  <input type="hidden" name="Aid" value="">
	  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
		<tr> 
		  <td colspan="20" class="tituloAlterno" align="center"><font size="2"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></td>
		</tr>
		<tr> 
		  <td colspan="20">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="20" align="center"><font size="3"><b>Conciliaci&oacute;n de Art&iacute;culos</b></font></td>
		</tr>
		<cfoutput> 
			<tr>
				<td colspan="20" align="center"><font size="2"><b>Fecha de la Conciliaci&oacute;n:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</font></td>
			</tr>
			<cfif isdefined('form.ckPend')>
				<tr>
					<td colspan="20" align="center"><font size="2"><b>S&oacute;lo art&iacute;culos con diferencias</b></font></td>
				</tr>
			</cfif>
			
			</cfoutput>
				<cfinvoke 
					 Component="sif.Componentes.IN_TransformacionProducto" 
					 method="IN_TransformacionProducto"
					 Modo="R"
					 returnvariable="rsRango">
					 <cfinvokeargument name="ETid" value="#Form.ETid#"/>
				</cfinvoke> 
				<cfoutput> 
				<cfset codigoArt = "">
				<cfset cantIniPMI = 0.00>
				<cfset cantIniSHELL = 0.00>
				<cfset cantIniDif = 0.00>
				<cfset cantPMI = 0.00>
				<cfset cantSHELL = 0.00>
				<cfset cantEmbProp = 0.00>
				<cfset cantEmbProd = 0.00>
				<cfset cantDifEmb = 0.00>		
				<cfset cantdif = 0.00>
				<cfset cantConsumo = 0.00>
				<cfset ConsumoPropio = 0.00>
				<cfset PerdGan = 0.00>
				<cfset InvFin = 0.00>
				<cfloop query="rsRango">
					<cfif rsRango.Currentrow EQ 1>
						<tr> 
							<td colspan="25" >&nbsp;</td>
						</tr>
						<tr>
							<td nowrap bgcolor="##00CCFF" align="center" ><font size="1"><strong>C&oacute;digo:</strong></font></td>
							<td nowrap bgcolor="##00CCFF" align="center" ><font size="1"><strong>Descripci&oacute;n:</strong></font></td>
							<td colspan="3" nowrap bgcolor="##00CCFF" align="center"><font size="1"><strong>Inventario Inicial:</strong></font></td>
							<td colspan="3" bgcolor="##00CCFF" align="center"><font size="1"><strong>Cantidad Recibida:</strong></font></td>
							<td colspan="3" nowrap bgcolor="##00CCFF" align="center"><font size="1"><strong>Cantidad del Embarque:</strong></font></td>
							<td colspan="2" nowrap bgcolor="##00CCFF"></td>
							<td align="center" bgcolor="##00CCFF" ><font size="1"><strong>P&eacute;rdida/</strong></font></td>
							<td align="center" bgcolor="##33CCFF" ><font size="1"><strong>Inventario</strong></font></td>
						</tr>
						<tr align="center" bgcolor="##33CCFF">
							<td align="center"></td>
							<td align="center"></td>
							<td nowrap align="center"><font size="1"><strong>PMI-NASA</strong></font></td>
							<td ><font size="1"><strong>Shell</strong></font></td>
							<td align="center"><font size="1"><strong>Diferencia</strong></font></td>
							<td nowrap  align="center"><font size="1"><strong>PMI-NASA</strong></font></td>
							<td align="center"><font size="1"><strong>Shell</strong></font></td>
							<td align="center"><font size="1"><strong>Diferencia</strong></font></td>
							<td nowrap align="center"><font size="1"><strong>PMI-NASA</strong></font></td>
							<td align="center"><font size="1"><strong>Shell</strong></font></td>
							<td align="center"><font size="1"><strong>Diferencia</strong></font></td>
							<td nowrap align="center"><font size="1"><strong>Producci&oacute;n</strong></font></td>
							<td ><font size="1"><strong>Consumo</strong></font></td>
							<td ><div align="center"><font size="1"><strong>Ganancia</strong></font></td>
							<td ><font size="1"><strong>Final</strong></font></td>
						</tr>
					</cfif>
					<tr align="right" onClick="javascript: showDetail('#rsRango.IDArticulo#');" onMouseOver="javascript: this.style.cursor = 'pointer';">
					  <td nowrap bgcolor="##FFFFFF" ><div align="right"><strong>#rsRango.CodArticulo#</strong></div>
					  </td>
					  <td align="left" nowrap bgcolor="##FFFFFF" ><div align="left">#rsRango.Articulo#</div></td>
						<td nowrap bgcolor="##CCCCCC" ><cfset cantIniPMI =  cantIniPMI + rsRango.InicialPropio>
						<div align="right">#LSCurrencyFormat(rsRango.InicialPropio,"none")# </div></td>
						<td nowrap bgcolor="##FFFFFF" ><cfset cantIniSHELL =  cantIniSHELL + rsRango.IncialProduccion>
						<div align="right">#LSCurrencyFormat(rsRango.IncialProduccion,"none")# </div></td>
						<!--- <td nowrap><div align="center">#rsArticulo.Adescripcion#</div></td> --->
					  <td nowrap bgcolor="##FFFFFF" >
					  <cfset cantIniDif =  cantIniDif + rsRango.DiferenciaInicial>
					  <div align="right">#LSCurrencyFormat(rsRango.DiferenciaInicial,"none")# </div></td>
						<td nowrap bgcolor="##CCCCCC" ><cfset cantPMI =  cantPMI + rsRango.RecepPropio>
					  <div align="right">#LSCurrencyFormat(rsRango.RecepPropio,"none")#</div></td>
						<td nowrap bgcolor="##FFFFFF" ><cfset cantSHELL = cantSHELL + rsRango.RecepProduccion>
							<div align="right">#LSCurrencyFormat(rsRango.RecepProduccion,"none")#</div>
					  </td>
						<td nowrap bgcolor="##FFFFFF" ><cfset cantdif = cantdif + rsRango.DiferenciaRecepcion> 
							<div align="right">#LSCurrencyFormat(rsRango.DiferenciaRecepcion,"none")#</div>
					  </td>
					  <td nowrap bgcolor="##CCCCCC"><cfset cantEmbProp =  cantEmbProp + rsRango.EmbarquePropio> <div align="right">#LSCurrencyFormat(rsRango.EmbarquePropio,"none")#</div></td>
						<td nowrap bgcolor="##FFFFFF"><cfset cantEmbProd =  cantEmbProd + rsRango.EmbarqueProduccion><div align="right">#LSCurrencyFormat(rsRango.EmbarqueProduccion,"none")#</div>
					  </td>
						<td nowrap bgcolor="##FFFFFF"><cfset cantDifEmb =  cantDifEmb + rsRango.DiferenciaEmbarque>#LSCurrencyFormat(rsRango.DiferenciaEmbarque,"none")#</td>
						<td nowrap bgcolor="##FFFFFF"><cfset cantConsumo =  cantConsumo + rsRango.ProduccionConsumo><div align="right">#LSCurrencyFormat(rsRango.ProduccionConsumo,"none")#</div></td>
						<td nowrap bgcolor="##FFFFFF"><cfset ConsumoPropio =  ConsumoPropio + rsRango.ConsumoPropio><div align="right">#LSCurrencyFormat(rsRango.ConsumoPropio,"none")#</div>
					  </td>
						<td nowrap bgcolor="##FFFFFF"><cfset PerdGan =  PerdGan + rsRango.PerdidaGanancia><div align="right">#LSCurrencyFormat(rsRango.PerdidaGanancia,"none")#</div>
					  </td>
						<td nowrap bgcolor="##FFFFFF"><cfset InvFin =  InvFin + rsRango.InventarioFinal><div align="right">#LSCurrencyFormat(rsRango.InventarioFinal,"none")#</div>
					  </td>
					</tr>
					  
			  </cfloop>
			  <cfset difSHELL = 0>
			  <cfset difPMI = 0>
			<tr>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td height="22" bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##CCCCCC" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##CCCCCC" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##CCCCCC" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
			</tr>
			<tr>
				<td bgcolor="##FFFFFF" ><strong>Totales:</strong></td>
				<td bgcolor="##FFFFFF" >&nbsp;</td>
				<td bgcolor="##CCCCCC" ><div align="right">#LSCurrencyFormat(cantIniPMI,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantIniSHELL,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantIniDif,"none")#</div></td>
				<td bgcolor="##CCCCCC" ><div align="right">#LSCurrencyFormat(cantPMI,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantSHELL,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantdif,"none")#</div> </td>
				<td bgcolor="##CCCCCC" ><div align="right">#LSCurrencyFormat(cantEmbProp,"none")#</div> </td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantEmbProd,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantDifEmb,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(cantConsumo,"none")#</div></td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(ConsumoPropio,"none")#</div> </td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(PerdGan,"none")#</div> </td>
				<td bgcolor="##FFFFFF" ><div align="right">#LSCurrencyFormat(InvFin,"none")#</div></td>
			</tr>
			<tr>
				<td colspan="25" >&nbsp;</td>
			</tr>
			<cfif rsRango.Recordcount NEQ 0>
				<tr>
					<td colspan="20" align="center">------------------ Fin del Reporte ------------------</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="20" align="center">------------------ No existen Diferencias para la fecha solicitada ------------------</td>
				</tr>
			</cfif>
		</cfoutput>
	  </table>
	</form>
</cf_sifHTML2Word>