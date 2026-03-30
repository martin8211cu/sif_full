<cfsetting enablecfoutputonly="yes" requesttimeout="36000" showdebugoutput="no">
<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select 	obo.OBOid, 		obo.IDcontableLiquidacion, 
			obp.OBPcodigo, 	obp.OBPdescripcion,
			obo.OBOcodigo, 	obo.OBOdescripcion,	obo.OBOestado, 
			obo.OBOresponsable, uA.Usulogin as AbiertoPor, uA.Usulogin as LiquidadoPor, 
			ec.IDcontable as SinAplicar, hec.IDcontable as Aplicado
	  from OBobra obo
	  	inner join OBproyecto obp
		   on obp.OBPid = obo.OBPid
	  	 left join Usuario uA
		   on uA.Usucodigo = UsucodigoAbierto
	  	 left join Usuario uL
		   on uL.Usucodigo = UsucodigoLiquidado
	  	 left join EContables ec
		   on ec.IDcontable = obo.IDcontableLiquidacion
	  	 left join HEContables hec
		   on hec.IDcontable = obo.IDcontableLiquidacion
	 where obo.OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
</cfquery>

<cfif rsSQL.OBOid EQ "">
	<cfset PolizaErr = "Obra no existe">
<cfelseif rsSQL.OBOestado NEQ "3">
	<cfset PolizaErr = "Obra no ha sido Liquidada">
<cfelseif rsSQL.IDcontableLiquidacion EQ "">
	<cfset PolizaErr = "La Obra fue liquidada pero no se registró #PolizaE# de Liquidacion">
<cfelseif rsSQL.SinAplicar NEQ "">
	<cfset LvarTabla = "">
<cfelseif rsSQL.Aplicado NEQ "">
	<cfset LvarTabla = "H">
<cfelse>
	<cfset PolizaErr = "ERROR FATAL: #PolizaE# de Liquidación registrada en la Obra no Existe.">
</cfif>

<cfif isdefined("LvarTabla")>
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	<cfsavecontent variable="myquery">
	<cfoutput>
		select 	a.Dlinea, a.IDcontable as IDcontable, a.Dmovimiento,c.Miso4217 as Mnombre, d.Oficodigo as Odescripcion,a.Doriginal,a.Dtipocambio,
				<cf_dbfunction name="sPart"	args="a.Ddescripcion,1,100"> as Ddescripcion,
				<cf_dbfunction name="sPart"	args="b.Cformato,1,25"> 	 as Cformato,
				<cf_dbfunction name="sPart"	args="b.Cdescripcion,1,20"> as Cdescripcion,
				case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end as Debitos, 
				case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end as Creditos, 
				a.Dreferencia #_Cat# '-' #_Cat# a.Ddocumento as ref
		from #LvarTabla#DContables a
			inner join CContables b
				on b.Ccuenta = a.Ccuenta
			inner join Monedas c
				on c.Mcodigo = a.Mcodigo
			inner join Oficinas d
				on  d.Ecodigo = a.Ecodigo
				and d.Ocodigo = a.Ocodigo
		where a.IDcontable = #rsSQL.IDcontableLiquidacion#
		order by a.Dlinea
	</cfoutput>
	</cfsavecontent>

	<cfquery name="rsTotalLineas" datasource="#Session.DSN#">
		select 
			sum(case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end) as Debitos, 
			sum(case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end) as Creditos
		from #LvarTabla#DContables a
		where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.IDcontableLiquidacion#">
	</cfquery>

	<cfquery name="rsEnc" datasource="#Session.DSN#">
	 	select a.Ecodigo, c.Edescripcion as Empresa,  a.Cconcepto, b.Cdescripcion, a.Eperiodo, a.Emes, a.Edocumento, a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, a.ECauxiliar, a.ECusuario, a.ECusucodigo, a.ECfechacreacion, a.ECestado, a.BMUsucodigo
		from #LvarTabla#EContables a
			inner join ConceptoContableE b
				on a.Ecodigo   = b.Ecodigo
		       and a.Cconcepto = b.Cconcepto
			inner join Empresas c	
				on a.Ecodigo   = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.IDcontableLiquidacion#">
	</cfquery>
	
	<cf_htmlReportsHeaders 
		title="Reportes de Documentos de Presupuesto" 
		filename="ObrasLiquidadas.xls"
		irA="liquidadas.cfm" 
		>
	<cfoutput>
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<td colspan="10"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">#rsEnc.Empresa#</font></strong></div></td>
			</tr>
			<tr>
				<td colspan="10" align="center">
					<font size="2">
						<strong>Reporte de Liquidación Contable de Obra</strong>
					</font>
				</td>
			</tr>
			<tr>
				<td colspan="10" align="center">
					<font size="2">
						<strong>#PolizaE# <cfif LvarTabla EQ "">sin Aplicar<cfelse>Aplicada</cfif></strong>
					</font>
				</td>
			</tr>
			<tr>
				<td><font size="2"><strong>Proyecto:</strong></font></td>
				<td nowrap colspan="2"><font size="2"><strong>#rsSQL.OBPcodigo# - #rsSQL.OBPdescripcion#</strong></font></td>
			</tr>
			<tr>
				<td><font size="2"><strong>Obra:</strong></font></td>
				<td nowrap colspan="2"><font size="2"><strong>#rsSQL.OBOcodigo# - #rsSQL.OBOdescripcion#</strong></font></td>
			</tr>
			<tr>
				<td><font size="2"><strong>Responsable:</strong></font></td>
				<td nowrap colspan="2"><font size="2">#rsSQL.OBOresponsable#</font></td>
				<td nowrap colspan="2"><font size="2"><strong>Abierto por:</strong>&nbsp;#rsSQL.AbiertoPor#</font></td>
				<td><font size="2"><strong>Liquidado por:</strong>&nbsp;#rsSQL.LiquidadoPor#</font></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>


			<tr>
				<td colspan="3"><font size="2">&nbsp;</font></td>
				<td colspan="2" nowrap><font size="2">&nbsp;</font></td>
				<td colspan="5"><font size="2"><strong>Fecha Doc.:</strong> #LSDateFormat(rsEnc.Efecha, 'dd/mm/yyyy')#</font></td>
			</tr>
			<tr>
				<td colspan="3"><font size="2"><strong>Concepto:</strong> #rsEnc.Cdescripcion#</font></td>
				<td colspan="2" nowrap><font size="2"><strong>Per&iacute;odo:</strong> #rsEnc.Eperiodo# <strong>Mes:</strong> #rsEnc.Emes#</font></td>
				<td colspan="4"><font size="2"><strong>Usuario:</strong>#rsEnc.ECusuario#</font></td>
			  <td>&nbsp;</td>
			  </tr>
			<tr>
				<td colspan="3"><font size="2"><strong>#PolizaE#:</strong> #rsEnc.Edocumento#</font></td>
				<td colspan="2" nowrap><font size="2"><strong>Descripci&oacute;n:</strong> #rsEnc.Edescripcion#</font></td>
				<td colspan="4" nowrap><cfif rsEnc.ECauxiliar EQ "S">
			  <font color="##FF0000">Documento Generado desde Auxiliar</font>
			  </cfif></td>
			  <td>&nbsp;</td>
			  </tr>
			<tr>
				<td colspan="3"><font size="2"><strong>Referencia:</strong> #rsEnc.Ereferencia#</font></td>
				<td colspan="2" nowrap><font size="2"><strong>Documento:</strong> #rsEnc.Edocbase#</font></td>
				<td colspan="5" >&nbsp;</td>
			  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  </tr>
			</table>
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr> 
				<td bgcolor="##E2E2E2" class="subTitulo">L&iacute;nea</td>
				<td bgcolor="##E2E2E2" class="subTitulo">Oficina</td>
				<td bgcolor="##E2E2E2" class="subTitulo">Descripci&oacute;n</td>
				<td nowrap bgcolor="##E2E2E2" class="subTitulo">Cuenta</td>
				<td nowrap bgcolor="##E2E2E2" class="subTitulo"><!--- Nombre --->&nbsp;</td>
				<td nowrap bgcolor="##E2E2E2" class="subTitulo">Ref-Doc</td>
				<td align="right" bgcolor="##E2E2E2" class="subTitulo">Monto</td>
				<td bgcolor="##E2E2E2" width="1" class="subTitulo">&nbsp;</td>
				<td align="right" bgcolor="##E2E2E2" class="subTitulo">T.C.</td>
				<td bgcolor="##E2E2E2" class="subTitulo"> 
				<div align="right">D&eacute;bitos</div></td>
				<td bgcolor="##E2E2E2" class="subTitulo"> 
				<div align="right">Cr&eacute;ditos</div></td>
			</tr>
			</cfoutput>
			<cftry>
				<cfset Lvarcontador = 0>
				<cfflush interval="512">
				<cf_jdbcquery_open name="rsLineas" datasource="#session.DSN#">
					<cfoutput>#myquery#</cfoutput>
				</cf_jdbcquery_open>
				<cfoutput query="rsLineas"> 
				  <cfset Lvarcontador = Lvarcontador + 1>
				  <tr <cfif Lvarcontador MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
					<cfset punto = "">
					<td>#Dlinea#</td>
					<td nowrap>#Odescripcion#</td>
					<td nowrap> 
					  <cfif Len(Trim(Ddescripcion)) GT 37>
						<cfset punto = " ...">
					  </cfif>
					  #Mid(Ddescripcion,1,35)##punto#</td>
					<td nowrap title="#Cdescripcion#">#Cformato#</td>
					<td nowrap><!--- #Cdescripcion#--->&nbsp;</td>
					<td nowrap>#ref#</td>
					<td align="right" nowrap>#LSCurrencyFormat(Doriginal,'none')#</td>
					<td >#Mnombre#s</a></td>
					<td align="right">#LSCurrencyFormat(Dtipocambio,'none')#</td>
					<td><div align="right"><cfif Dmovimiento EQ "D">#LSCurrencyFormat(Debitos,'none')#</cfif></div></td>
					<td><div align="right"><cfif Dmovimiento EQ "C">#LSCurrencyFormat(Creditos,'none')#</cfif></div></td>
				  </tr>
				</cfoutput> 
			<cfcatch type="any">
				<cf_jdbcquery_close>
				<cfrethrow>
			</cfcatch>
			</cftry>
			<cf_jdbcquery_close>
			<cfoutput>
			<tr> 
			  <td></td>
			  <td>&nbsp;</td>
			  <td></td>
				<td nowrap></td>
				<td nowrap>&nbsp;</td>
				<td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
				<td align="right"><font size="1"><strong> 
				  <cfif rsTotalLineas.RecordCount GT 0 >
					Totales: 
				  </cfif>
				  </strong></font>
			  </td>
				<td nowrap>&nbsp;</td>
			  <td><div align="right"><font size="1"><strong> 
				  <cfif rsTotalLineas.RecordCount GT 0 >
					#LSCurrencyFormat(rsTotalLineas.Debitos,'none')#
				  </cfif>
				  </strong></font></div></td>
			  <td><div align="right"><font size="1"><strong> 
				  <cfif rsTotalLineas.RecordCount GT 0 >
					#LSCurrencyFormat(rsTotalLineas.Creditos,'none')#
				  </cfif>
				  </strong></font></div></td>
			</tr>
			<tr>
				<td colspan="10">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="10"><div align="center"><strong>---------------------------- FIN DEL REPORTE ----------------------------</strong></div></td>
			</tr>
		</table>
	</cfoutput>
<cfelse>
	<cfthrow message="#PolizaErr#">
</cfif>

