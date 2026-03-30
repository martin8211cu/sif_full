<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Archivo" default="ReimpresionVales" returnvariable="LB_Archivo" 
xmlfile ="ReimpresionVales_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Impresión de Vales al Empleado" returnvariable="LB_Titulo" xmlfile ="ReimpresionVales_form.xml"/>

<cf_htmlReportsHeaders 
	title="#LB_Titulo#" 
	filename="#LB_Archivo#.xls"
	irA="ReimpresionVales#LvarCFM#.cfm?regresar=1"
	download="no"
	preview="no"
>

<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
 <cfquery name="rsSQL" datasource="#session.dsn#">
 	select GEAid from CCHVales where CCHVid=#form.CCHVid#
 </cfquery>
 
 <cfset form.id=rsSQL.GEAid>
 
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
			tb.TESBeneficiario,
			
			( select CCHcodigo from CCHica x
				inner join GEanticipo p
				on p.CCHid = x.CCHid
				and p. GEAid = #form.id#
					inner join CCHVales sa
					on p.GEAid = sa.GEAid
					and sa.CCHVid=#form.CCHVid#
			) as CCHcodigo,
			
			(select Mo.Mnombre
					from Monedas Mo
					where c.Mcodigo=Mo.Mcodigo
				)as Moneda,
								
				<cf_dbfunction name="date_format"  args="sa.CCHVfechaAplica,DD/MM/YYYY"> as fecha, 
				<cf_dbfunction name="to_chartime"  args="sa.CCHVfechaAplica"> as hora,    

		(
			select us.Usulogin
			from Usuario us
			where us.Usucodigo=c.UsucodigoSolicitud
		) as usuario,
			
		{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as confeccionadoPor
		
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
		
		where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 			and sa.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">	
			and sa.CCHVid=#form.CCHVid#
	</cfquery>

	<cfquery name="rsAnti" datasource="#session.dsn#">
		select b.GECdescripcion,f.CFformato
			from GEconceptoGasto b	
				inner join GEanticipoDet c
					inner join CFinanciera f
					on f.CFcuenta = c.CFcuenta
				on  b.GECid=c.GECid	
				inner join GEanticipo ant 
				on c.GEAid=ant.GEAid	
				where ant.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#" >
	</cfquery>
	


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
			<td colspan="4" align="center"><span class="style1"><cf_translate key=LB_ValeCajaChica>VALE DE CAJA CHICA</cf_translate></span></td>
		</tr>
		<tr>
			<td colspan="4" align="center" ><span class="style1"><cf_translate key=LB_Reimpresion>REIMPRESION DE VALE-COPIA NO NEGOCIABLE</cf_translate></span></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><strong>(#rsReporteTotal.CCHVestado#)</strong></td>
		</tr>
	<cfif rsReporteTotal.CCHVestado EQ "0">
		<tr>
			<td colspan="4" align="center"><strong>*** <cf_translate key=LB_Impresion>IMPRESI&Oacute;N PRELIMINAR NO OFICIAL<cf_translate> ***</strong></td>
		</tr>
	</cfif>
		<tr>
			<td nowrap><strong><cf_translate key=LB_CajaAsignada>CAJA   ASIGNADA</cf_translate>:&nbsp;</strong></td>
			<td><span class="style4">#rsReporteTotal.CCHcodigo#</span></td>
			<td nowrap align="right"><strong><cf_translate key=LB_NumVale>NM. VALE</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="center">#rsReporteTotal.CCHVnumero#</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key=LB_Empresa>NOMBRE DE LA COMPA&Ntilde;IA</cf_translate>:&nbsp;</strong></td>
			<td>
				<table width="100%"><tr>
					<td>
						<span class="style4">#rsReporteTotal.Edescripcion#</span>
					<td>
					<td style="text-align:right">
						<strong><cf_translate key=LB_CF>C.F</cf_translate>:</strong>&nbsp;<span class="style4">#rsReporteTotal.CFdescripcion#</span></td>
						<td>&nbsp;</td>
				</tr></table></td>
			<td nowrap align="right"><strong><cf_translate key=LB_FechaVale>FECHA VALE</cf_translate>:&nbsp;&nbsp;</strong></td>
			<td nowrap align="left"><span class="style4">#rsReporteTotal.fecha#</span></td>
		  </tr>
		  <tr>
			<td></td>
			<td><span class="style4"></td>
		  </tr>
		  <tr>
			<td><strong><cf_translate key=LB_ValorLetras>VALOR EN LETRAS</cf_translate> :</strong></td>
			<td colspan="4">#LvarObj.fnMontoEnLetras(rsReporteTotal.CCHVmontoAplicado)# <strong>#rsReporteTotal.Moneda#</strong></td>
		  </tr>
		  <tr>
		    <td><strong><cf_translate key=LB_PorConcepto>POR CONCEPTO DE</cf_translate> :</strong></td>
			<td colspan="2" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">
			<cfloop query="rsAnti">
						#rsAnti.GECdescripcion#
			</cfloop>
			</td>
	      </tr>
		  <tr>
		    <td><strong><cf_translate key=LB_aFavor>A FAVOR DE</cf_translate> :</strong></td>
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
						<td align="right"><strong><cf_translate key=LB_Emitido>EMITIDO</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.confeccionadoPor#</td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key=LB_Fecha>FECHA</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td><span class="style4">#rsReporteTotal.fecha#</span></td>
					</tr>
					<tr>
						<td align="right"><strong><cf_translate key=LB_Hora>HORA</cf_translate>:</strong>&nbsp;&nbsp;</td>
						<td>#rsReporteTotal.hora#</td>
					</tr>
				</table>
			</td>
		<tr>
			<td>&nbsp;</td>
		</tr>			  
	</table>
	<table width="100%"  border="1" cellspacing="1" cellpadding="1" class="caja">
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Fecha>FECHA</cf_translate></span></td>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_DetalleVale>DETALLE DEL VALE</cf_translate></span></td>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_CuentaConcepto>CUENTA-CONCEPTO</cf_translate></span></td>
					<td width="300" bgcolor="##E4E4E4" align="center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style7"><cf_translate key=LB_Monto>MONTO</cf_translate></span></td>


					<cfif rsReporteTotal.recordCount LT 19>
						<td width="161" valign="top" rowspan="19" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					<cfelse>
						<td width="161" valign="top" rowspan="#rsReporteTotal.recordCount + 3#" align="center" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;">
					</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="2%" nowrap>&nbsp;</td>
						<td width="98%" nowrap><strong><cf_translate key=LB_CustodioFondoCajaChica>Custodio Fondo Caja Chica</cf_translate>:</strong></td>
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
						<td><strong><cf_translate key=LB_AutorizadoPor>Autorizado por</cf_translate>: </strong></td>
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
						<td><strong><cf_translate key=LB_RecibidoConforme>Recibido Conforme</cf_translate>: </strong></td>
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
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.fecha#</span></td>
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">#rsReporteTotal.GEAdescripcion#</span></td>						
						<td align="left" style="border-right-width: 1px; border-right-style: solid; border-right-color: gray;"><span class="style8">
						<cfloop query="rsAnti">
						#rsAnti.CFformato#-#rsAnti.GECdescripcion#</span>
						</cfloop>
						</td>
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

