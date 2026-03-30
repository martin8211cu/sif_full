<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaErr = t.Translate('PolizaErr','Error! La p&oacute;liza indicada no Existe!. Por favor revise sus datos.')>


<cf_dbfunction name="concat" args="a.Dreferencia + '-' + coalesce(a.Ddocumento, 'N/A')" delimiters="+" returnvariable="LvarRef">
<cf_dbfunction name="string_part" args="a.Ddescripcion,1,100" 	returnvariable="LvarDdescripcion">
<cf_dbfunction name="string_part" args="b.CFformato,1,51" 		returnvariable="LvarCformato">
<cf_dbfunction name="string_part" args="b.CFdescripcion,1,20" 	returnvariable="LvarCdescripcion">
<cfif isdefined('url.ECIid') and len(trim(url.ECIid)) GT 0>
	<cfquery name="rsLineas" datasource="#session.DSN#">
        select 	
            a.DCIconsecutivo as Dlinea, 
            a.ECIid as IDcontable,
            a.Dmovimiento,
            #LvarDdescripcion# as Ddescripcion,
            #LvarCformato# as Cformato,
            c.Mnombre, 
            case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end as Debitos, 
            case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end as Creditos, 
            #LvarCdescripcion# as Cdescripcion,
            d.Oficodigo as Odescripcion,
            a.Doriginal,
            a.Dtipocambio,
            e.Edescripcion,
            #preservesinglequotes(LvarRef)# as ref,
            coalesce(f.CFcodigo,'N/A') as CFcodigo
        from DContablesImportacion a
            left join CFinanciera b
                on b.CFcuenta = a.CFcuenta
            inner join Monedas c
                on c.Mcodigo = a.Mcodigo
            inner join Oficinas d
                on  d.Ecodigo = a.EcodigoRef
                and d.Ocodigo = a.Ocodigo
            inner join Empresas e 
                on e.Ecodigo = a.EcodigoRef
            left outer join CFuncional f
                on f.CFid = a.CFid
        where a.ECIid = #url.ECIid#
        order by a.DCIconsecutivo
	</cfquery>
	<cfquery name="rsTotalLineas" datasource="#Session.DSN#">
		select 
			sum(case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end) as Debitos, 
			sum(case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end) as Creditos
		from DContablesImportacion a
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECIid#">
	</cfquery>

	<cfquery name="rsEnc" datasource="#Session.DSN#">
	 	select 
			a.Ecodigo, 
			c.Edescripcion as Empresa,  
			a.Cconcepto, 
			b.Cdescripcion, 
			a.Eperiodo, 
			a.Emes, 
			a.Efecha, 
			a.Edescripcion, 
			a.Edocbase, 
			a.Ereferencia, 
			u.Usulogin as ECusuario, 
			a.BMUsucodigo
		from EContablesImportacion a
			inner join ConceptoContableE b
				on b.Ecodigo   = a.Ecodigo
			   and b.Cconcepto = a.Cconcepto
			inner join Empresas c	
				on c.Ecodigo = a.Ecodigo
			left outer join Usuario u
				on u.Usucodigo = a.BMUsucodigo
		where a.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECIid#">
	</cfquery>
	
	<cfif isdefined("url.regresar")>
		<cfset formAction = url.regresar>
	<cfelse>
		<cfset formAction = "DocContablesImportacion.cfm">
	</cfif>
<cfoutput>
	<form action="#formAction#" method="post" name="form1" style="margin:0">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
		  <td colspan="10"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">#rsEnc.Empresa#</font></strong></div></td>
		</tr>
		<tr>
		  <td colspan="10"><div align="center"><font size="2">Documento Importado sin aplicar</font></div>
		  </td>
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
		  <td colspan="3"><font size="2"><strong>#PolizaE#:</strong> Sin Asignar</font></td>
		  <td colspan="2" nowrap><font size="2"><strong>Descripci&oacute;n:</strong> #rsEnc.Edescripcion#</font></td>
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
		  <td bgcolor="##E2E2E2" class="subTitulo">Empresa</td>
		  <td bgcolor="##E2E2E2" class="subTitulo">Oficina</td>
          <td bgcolor="##E2E2E2" class="subTitulo">C. Funcional</td>
		  <td bgcolor="##E2E2E2" class="subTitulo">Descripci&oacute;n</td>
		  <td nowrap bgcolor="##E2E2E2" class="subTitulo">Cuenta</td>
		  <td nowrap bgcolor="##E2E2E2" class="subTitulo"><!--- Nombre --->&nbsp;</td>
		  <td nowrap bgcolor="##E2E2E2" class="subTitulo">Ref-Doc</td>
		  <td align="right" bgcolor="##E2E2E2" class="subTitulo">Monto</td>
		  <td bgcolor="##E2E2E2" class="subTitulo">Moneda</td>
		  <td align="right" bgcolor="##E2E2E2" class="subTitulo">T.C.</td>
		  <td bgcolor="##E2E2E2" class="subTitulo"> 
			<div align="right">D&eacute;bitos</div></td>
		  <td bgcolor="##E2E2E2" class="subTitulo"> 
			<div align="right">Cr&eacute;ditos</div></td>
		</tr>
		</cfoutput>

			<cfset Lvarcontador = 0>
			<cfflush interval="16">
			<cfoutput query="rsLineas"> 
			  <cfset Lvarcontador = Lvarcontador + 1>
			  <tr <cfif Lvarcontador MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
				<cfset punto = "">
				<td>#Dlinea#</td>
				<td nowrap>#Edescripcion#</td>
				<td nowrap>#Odescripcion#</td>
                <td nowrap>#CFcodigo#</td>
				<td nowrap> 
				  <cfif Len(Trim(Ddescripcion)) GT 55>
					<cfset punto = " ...">
				  </cfif>
				  #Mid(Ddescripcion,1,55)##punto#</td>
				<td nowrap title="#Cdescripcion#">#Cformato#</td>
				<td nowrap><!--- #Cdescripcion#--->&nbsp;</td>
				<td nowrap>#ref#</td>
				<td align="right" nowrap>#LSCurrencyFormat(Doriginal,'none')#</td>
				<td nowrap>#Mnombre#</a></td>
				<td align="right">#LSCurrencyFormat(Dtipocambio,'none')#</td>
				<td><div align="right">#LSCurrencyFormat(Debitos,'none')#</div></td>
				<td><div align="right">#LSCurrencyFormat(Creditos,'none')#</div></td>
			  </tr>
			</cfoutput> 
		<cfoutput>
		<tr> 
		  <td></td>
		  <td>&nbsp;</td>
		  <td></td>
		  <td nowrap></td>
		  <td nowrap>&nbsp;</td>
		  <td align="right">&nbsp;</td>
		  <td>&nbsp;</td>
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
		  <td colspan="10"><div align="center">---------------------------- FIN DEL REPORTE ----------------------------</div></td>
		  </tr>
		</table>
	</form>
	</cfoutput>
<cfelse>
	<cfoutput>#PolizaErr#</cfoutput>
</cfif>