<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionVale" default ="Impresion del Vale" returnvariable="LB_ImpresionVale" xmlfile = "vale_imprimir_Liq.xml">

<cf_htmlReportsHeaders 
	title="#LB_ImpresionVale#" 
	filename="SolicitudPago.xls"
	irA="TransaccionCustodiaP.cfm?regresar=1"
	download="no"
	preview="no"
>

<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
 
<cfif isdefined('form.id') and form.id NEQ ''>
	<cfquery name="rsCEE" datasource="#session.dsn#">
		select em.CCHEMnumero
		  from GEliquidacion le
		  	inner join CCHica ch
				on ch.CCHid = le.CCHid
			inner join CCHespecialMovs em
				on em.GELid = le.GELid
		 where le.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
		   and CCHtipo = 2
	</cfquery>
	<cfset LvarEsVale = (rsCEE.CCHEMnumero EQ "")>

	<cfquery datasource="#session.dsn#" name="rsReporteTotal">
		Select 
		<cfif LvarEsVale>
			sa.CCHVnumero,            
		<cfelse>
			'#rsCEE.CCHEMnumero#' as CCHVnumero,
		</cfif>
			sa.CCHVestado,             
			sa.GELid,  
			sa.CCHVusucodigoGenera,           
			sa.CCHVfecha,                    
			sa.BMUsucodigo,                
			sa.CCHVmontonOrig,             
			sa.CCHVmontoAplicado,            
			sa.CCHVusucodigoAplica,        
			sa.CCHVfechaAplica,
			e.Edescripcion,
			cfn.CFdescripcion,
			c.GELdescripcion,
			tb.TESBeneficiario,
			
			( select CCHcodigo from CCHica x
				inner join GEliquidacion p
				on p.CCHid = x.CCHid
					inner join CCHVales sa
					on p.GELid = sa.GELid
					and p. GELid = #form.id#
			) as CCHcodigo,
			
			(select Mo.Mnombre
					from Monedas Mo
					where c.Mcodigo=Mo.Mcodigo
			)as Moneda,
			
			<cf_dbfunction name="date_format"  args="sa.CCHVfechaAplica,DD/MM/YYYY"> as fecha, 
			<cf_dbfunction name="to_chartime"  args="sa.CCHVfechaAplica"> as hora,    
			
			(
				select  min(us.Usulogin)
					from STransaccionesProceso a
						inner join Usuario us
							on a.BMUsucodigo=us.Usucodigo
					where a.CCHTrelacionada= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#" >
					and a.CCHTestado='POR CONFIRMAR'
					and a.CCHTtipo='GASTO'
			) as usuario,
			{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor
		from CCHVales sa
			inner join GEliquidacion c
			on c.GELid = sa.GELid
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
		where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			and sa.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">	
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


<cfif rsReporteTotal.recordcount gt 0>
	<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
	<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="25%">&nbsp;</td>
			<td width="55%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>		
		<tr>
		<cfif LvarEsVale>
			<td colspan="4" align="center"><span class="style1"><cf_translate key = LB_ValeCajaChica xmlfile = "vale_imprimir_Liq.xml">VALE DE CAJA CHICA</cf_translate></span></td>
		<cfelse>
			<td colspan="4" align="center"><span class="style1"><cf_translate key = LB_ComprobanteRecepcionCajaEfectivo xmlfile = "vale_imprimir_Liq.xml">COMPROBANTE DE ENTREGA DE CAJA DE EFECTIVO</cf_translate></span></td>
		</cfif>
		</tr>
		<tr>
			<td colspan="4" align="center"><strong>(#rsReporteTotal.CCHVestado#)</strong></td>
		</tr>
	<cfif rsReporteTotal.CCHVestado EQ "0">
		<tr>
			<td colspan="4" align="center"><strong>*** <cf_translate key = LB_ImpresionPreliminarNoOficial xmlfile = "vale_imprimir_Liq.xml">IMPRESI&Oacute;N PRELIMINAR NO OFICIAL</cf_translate> ***</strong></td>
		</tr>
	</cfif>
		<tr>
		<cfif LvarEsVale>
			<td nowrap><strong><cf_translate key = LB_CajaAsignada xmlfile = "vale_imprimir_Liq.xml">CAJA   ASIGNADA</cf_translate>:&nbsp;</strong></td>
			<td><span class="style4">#rsReporteTotal.CCHcodigo#</span></td>
			<td nowrap align="right"><strong><cf_translate key = LB_NumVale xmlfile = "vale_imprimir_Liq.xml">NUM.VALE</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="center">#rsReporteTotal.CCHVnumero#</td>
		<cfelse>
			<td nowrap><strong><cf_translate key = LB_CajaEfectivo xmlfile = "vale_imprimir_Liq.xml">CAJA DE EFECTIVO</cf_translate>:&nbsp;</strong></td>
			<td><span class="style4">#rsReporteTotal.CCHcodigo#</span></td>
			<td nowrap align="right"><strong><cf_translate key = LB_Comprobante xmlfile = "vale_imprimir_Liq.xml">COMPROBANTE</cf_translate>:&nbsp;</strong></td>
			<td nowrap align="center">#rsReporteTotal.CCHVnumero#</td>
		</cfif>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key = LB_NombreCompania xmlfile = "vale_imprimir_Liq.xml">NOMBRE DE LA COMPA&Ntilde;IA</cf_translate>:&nbsp;</strong></td>
			<td>
				<table width="100%"><tr>
					<td>
						<span class="style4">#rsReporteTotal.Edescripcion#</span>
					<td>
					<td style="text-align:right">
						<strong><cf_translate key = LB_CentroFuncional xmlfile = "vale_imprimir_Liq.xml">C.F</cf_translate>:</strong>&nbsp;<span class="style4">#rsReporteTotal.CFdescripcion#</span></td>
						<td>&nbsp;</td>
				</tr></table></td>
			<td nowrap align="right"><strong><cf_translate key = LB_FechaVale xmlfile = "vale_imprimir_Liq.xml">FECHA VALE</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="left"><span class="style4">#rsReporteTotal.fecha#</span></td>
		  </tr>
		  <tr>
			<td></td>
			<td><span class="style4"></td>
		  </tr>
		  
		  <tr>
			<td><strong><cf_translate key = LB_ValorEnLetras xmlfile = "vale_imprimir_Liq.xml">VALOR EN LETRAS</cf_translate>:</strong></td>
			<td colspan="4">#LvarObj.fnMontoEnLetras(rsReporteTotal.CCHVmontoAplicado)# <strong>#rsReporteTotal.Moneda#</strong></td>
		  </tr>
		  <tr>
		    <td><strong><cf_translate key = LB_PorConceptoDe xmlfile = "vale_imprimir_Liq.xml">POR CONCEPTO DE</cf_translate> :</strong></td>
			<td colspan="2" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">#rsReporteTotal.GELdescripcion#</td>
		  </tr>
		  
		  <tr>
		    <td><strong><cf_translate key = LB_AFavorDe xmlfile = "vale_imprimir_Liq.xml">A FAVOR DE</cf_translate> :</strong></td>
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
						<td align="right"><strong><cf_translate key = LB_Emitido xmlfile = "vale_imprimir_Liq.xml">EMITIDO</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.confeccionadoPor#</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key = LB_Fecha xmlfile = "vale_imprimir_Liq.xml">FECHA</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td><span class="style4">#rsReporteTotal.fecha#</span></td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key = LB_Hora xmlfile = "vale_imprimir_Liq.xml">HORA</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.hora#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>			  
	</table>
	<table width="100%"  border="1" cellspacing="0" cellpadding="0" class="caja">
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key = LB_Fecha xmlfile = "vale_imprimir_Liq.xml">FECHA</cf_translate></span></td>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key = LB_DetalleVale xmlfile = "vale_imprimir_Liq.xml">DETALLE DEL VALE</cf_translate></span></td>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key = LB_Monto xmlfile = "vale_imprimir_Liq.xml">MONTO</cf_translate></span></td>
		
					<cfif rsReporteTotal.recordCount LT 19>
						<td width="161" valign="top" rowspan="19" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					<cfelse>
						<td width="161" valign="top" rowspan="#rsReporteTotal.recordCount + 3#" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					</cfif>
					
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="2%" nowrap>&nbsp;</td>
						<td width="98%" nowrap><strong><cf_translate key = LB_CustodioFondoCajaChica xmlfile = "vale_imprimir_Liq.xml">Custodio Fondo Caja Chica</cf_translate>: </strong></td>
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
						<td><strong><cf_translate key = LB_AutorizadoPor xmlfile = "vale_imprimir_Liq.xml">Autorizado por</cf_translate>: </strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					    <td>#rsReporteTotal.usuario#</td>
					  </tr>								  
					  <tr>
					    <td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
						<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
					  </tr>	  
					  <tr>
					    <td>&nbsp;</td>
						<td><strong><cf_translate key = LB_ReciboConforme xmlfile = "vale_imprimir_Liq.xml">Recibido Conforme</cf_translate>: </strong></td>
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
					  <cfset LvarListaNon = (CurrentRow MOD 2)>
					  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSDateFormat(rsReporteTotal.CCHVfechaAplica,'dd/mm/yyyy')#</span></td>
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.GELdescripcion#</span></td>
						<cfif rsReporteTotal.CCHVmontoAplicado GT 0>
							<td nowrap align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(rsReporteTotal.CCHVmontoAplicado,',9.00')#</span>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="right" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#LSNumberFormat(Abs(rsReporteTotal.CCHVmontoAplicado),',9.00')#</span>&nbsp;&nbsp;</td>
						</cfif>
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
	</cfoutput>		  	
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from CCHVales v
		 where v.GELid=#form.id#
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
			<cfif rsSQL.cantidad EQ 0>
				<td align="center"><strong><cf_translate key = MSG_NoSeEncontroElComprobanteSeleccionadoFavorIntenteloDeNuevo xmlfile = "vale_imprimir_Liq.xml">No se encontr&oacute; el vale seleccionada, favor int&eacute;ntelo de nuevo</cf_translate> </strong></td>
			<cfelse>
				<td align="center"><strong><cf_translate key = MSG_ElComprobanteEstaVacioFavorIntenteloDeNuevo xmlfile = "vale_imprimir_Liq.xml">El vale esta vacio, favor int&eacute;ntelo de nuevo</cf_translate> </strong></td>
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

