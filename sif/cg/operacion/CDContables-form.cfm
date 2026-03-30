<!---
	Modificado por: Gustavo Fonseca H. / Mauricio Esquivel.
		Fecha: 3-3-2006.
		Motivo: Se modifica la invocación de los querys para utilizar el cf_jdbcquery, con el fin de que no se
		pegue cualquier servidor por un volumen de datos grande.
 --->

<cfsetting requesttimeout="3600">

<cfset params = '' >
<cfif isdefined("form.IDcontable") and len(trim(form.IDcontable)) >
	<cfset params = params & "&IDcontable=#form.IDcontable#">
</cfif>
<cfif isdefined("form.Inter") and len(trim(form.Inter)) >
	<cfset params = params & "&Inter=#form.Inter#">
</cfif>
<cfif isdefined("form.LvarDLinea") and len(trim(form.LvarDLinea)) >
	<cfset params = params & "&LvarDLinea=#form.LvarDLinea#">
</cfif>
 <cfif isdefined("form.lote") and len(trim(form.lote)) >
	<cfset params = params & "&lote=#form.lote#">
</cfif>
<cfif isdefined("poliza") and len(trim(form.poliza)) >
	<cfset params = params & "&poliza=#form.poliza#">
</cfif>
<cfif isdefined("form.descripcion") >
	<cfset params = params & "&descripcion=#form.descripcion#">
</cfif>
<cfif isdefined("form.fecha") >
	<cfset params = params & "&fecha=#form.fecha#">
</cfif>
<cfif isdefined("form.periodo") >
	<cfset params = params & "&periodo=#form.periodo#">
</cfif>
<cfif isdefined("form.mes")>
	<cfset params = params & "&mes=#form.mes#">
</cfif>
<cfif isdefined("form.ECusuario")>
	<cfset params = params & "&ECusuario=#form.ECusuario#">
</cfif>
<cfif isdefined("form.fechaGen") >
	<cfset params = params & "&fechaGen=#form.fechaGen#">
</cfif>
<cfif isdefined("form.ver")>
	<cfset params = params & "&ver=#form.ver#">
</cfif>
<cfif isdefined("form.origen")>
	<cfset params = params & "&origen=#form.origen#">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaErr = t.Translate('PolizaErr','Error! La p&oacute;liza indicada no Existe!. Por favor revise sus datos.')>

<cfset LBl_Documento = t.Translate('LBl_Documento','Documento','CDContablesResumido.xml')>
<cfset LBl_Inter = t.Translate('LBl_Inter','InterCompa&ntilde;&iacute;a','CDContablesResumido.xml')>
<cfset LBl_SinApl = t.Translate('LBl_SinApl','sin aplicar','CDContablesResumido.xml')>
<cfset LBl_RepDocConDet = t.Translate('LBl_RepDocConDet','Reporte Documentos Contables Detallado')>
<cfset LBl_FecDoc = t.Translate('LBl_FecDoc','Fecha Doc.','CDContablesResumido.xml')>
<cfset LB_Concepto = t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Usuario = t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LBl_DocGenAux = t.Translate('LBl_DocGenAux','Documento Generado desde Auxiliar','CDContablesResumido.xml')>
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LBl_Referencia = t.Translate('LBl_Referencia','Referencia','CDContablesResumido.xml')>
<cfset LB_Empresa = t.Translate('LB_Empresa','Empresa','/sif/generales.xml')>
<cfset LBl_CFunc = t.Translate('LBl_CFunc','C. Funcional','CDContablesResumido.xml')>
<cfset LBl_DescDet = t.Translate('LBl_DescDet','Descripci&oacute;n Detalle','CDContablesResumido.xml')>
<cfset LBl_Descrip = t.Translate('LB_DESCRIPCION','Descripci&oacute;n','/sif/generales.xml')>
<cfset LBl_CtaC = t.Translate('LBl_CtaC','Cuenta C.','CDContablesResumido.xml')>
<cfset LBl_CtaFinan = t.Translate('LBl_CtaFinan','Cuenta Financiera','CDContablesResumido.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LBl_Pagina = t.Translate('LBl_Pagina','P&aacute;gina','CDContablesResumido.xml')>
<cfset LBl_Period = t.Translate('LBl_Period','Per&iacute;odo')>
<cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset LBl_Linea = t.Translate('LBl_Linea','L&iacute;nea')>
<cfset LBl_Evento = t.Translate('LBl_Evento','Evento')>
<cfset LBl_Ref = t.Translate('LBl_Ref','Ref')>
<cfset LBl_Doc = t.Translate('LBl_Doc','Doc')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LBl_TC = t.Translate('LBl_TC','T.C.')>
<cfset LBl_Totales = t.Translate('LBl_Totales','Totales')>

<cfif (isdefined('form.Id') and len(trim(form.Id)) GT 0) or isdefined('form.chk')>
    <cf_dbfunction name="string_part" args="a.Ddescripcion,1,100" 	returnvariable="LvarDdescripcion">

    <cfif isdefined("form.btnDownload")>
		<cf_dbfunction name="string_part" args="bb.CFformato,1,51" 		returnvariable="LvarCFformato">
        <cf_dbfunction name="string_part" args="bb.CFdescripcion,1,20" 	returnvariable="LvarCFdescripcion">
        <cf_dbfunction name="string_part" args="b.Cformato,1,51" 		returnvariable="LvarCformato">
    	<cf_dbfunction name="string_part" args="b.Cdescripcion,1,20" 	returnvariable="LvarCdescripcion">
	<cfelse>
	    <cf_dbfunction name="string_part" args="b.Cformato,1,51" 		returnvariable="LvarCformato">
    	<cf_dbfunction name="string_part" args="b.Cdescripcion,1,20" 	returnvariable="LvarCdescripcion">
    </cfif>


	<cfquery name="EncEmpresa" datasource="#Session.DSN#">
		select Edescripcion as Empresa
			from Empresas
				where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfif isdefined('form.chk') and len(trim(form.chk)) gt 0>
			<cfset IDAsientos=#form.chk#>
			<cfset IrA="listaDocumentosContables.cfm">
	<cfelse>
			<cfset IDAsientos=#form.Id#>
			<cfset IrA="DocumentosContables#sufix#.cfm?dummy=1#params#">
	</cfif>

	<cf_htmlreportsheaders
        title="Saldos Diarios"
        filename="SaldosDiarios#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls"
       ira="#IrA#"
	  >
    <cfif not isdefined("form.btnDownload")>
        <cf_templatecss>
    </cfif>

	 <style type="text/css">
            * { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif; white-space: nowrap;}
            .niv1 { font-size: 18px; }
            .niv2 { font-size: 16px; }
            .niv3 { font-size: 11px; font-weight:bold }
            .niv4 { font-size: 9px; }
        </style>

	<cfset Lvarcontador = 0>
	<cfset vLineaspagina = 0>
	<cfset vPagina = 0>
	<!---<cfflush interval="1024">  --->

	<!---Pinta el encabezado --->
	  <table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
		 		 <td colspan="10"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif"><cfoutput>#EncEmpresa.Empresa#</cfoutput></font></strong></div></td>
			</tr>
            <cfoutput>
			<tr>
		  		<td colspan="10">
					<div align="center"><font size="2">#LBl_Documento# <cfif inter eq "S">&nbsp;#LBl_Inter#&nbsp;</cfif>
				#LBl_SinApl#</font></div>
		 	    </td>
			</tr>
			<tr>
				<td colspan="10" style="font-style:oblique;">
					<div align="center"><font size="2">#LBl_RepDocConDet#</font></div>
				</td>
			</tr>
			</cfoutput>
	</table>


  <cfloop index="IDcontable" list="#IDAsientos#">

	<cfif inter eq "S">
		<cfquery name="rsLineas" datasource="#session.DSN#">
                select 	a.Dlinea, a.IDcontable as IDcontable,
                        a.Dmovimiento,
                        #LvarDdescripcion# as Ddescripcion,
                        <cfif isdefined("form.btnDownload")>
                        	#LvarCFformato# as CFformato,
                            #LvarCFdescripcion# as CFdescripcion,
                        </cfif>
                        #LvarCformato# as Cformato,
                        #LvarCdescripcion# as Cdescripcion,
                        c.Mnombre,
                        c.Miso4217,
						c.Mcodigo,
                        case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end as Debitos,
                        case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end as Creditos,
                        d.Oficodigo as Odescripcion,
                        a.Doriginal,
                        a.Dtipocambio,
                        e.Edescripcion,
                        a.Dreferencia,
						coalesce(a.Ddocumento, 'N/A') as Ddocumento,
	                    coalesce(f.CFcodigo,'N/A') as CFcodigo,
						a.Ddescripcion as detalleDescripcion,
                        coalesce(a.NumeroEvento,'') as NumeroEvento
                from DContables a
                	<cfif isdefined("form.btnDownload")>
                        inner join CFinanciera bb
                            on bb.CFcuenta = a.CFcuenta
                    </cfif>
                    inner join CContables b
                        on b.Ccuenta = a.Ccuenta

                    inner join Monedas c
                        on c.Mcodigo = a.Mcodigo
                    inner join Oficinas d
                        on  d.Ecodigo = b.Ecodigo
                        and d.Ocodigo = a.Ocodigo
                    inner join Empresas e
                        on e.Ecodigo = b.Ecodigo
                    left outer join CFuncional f
                		on f.CFid = a.CFid

                where a.IDcontable = #IDcontable#
                order by a.Dlinea
            </cfquery>
	<cfelse>
		<cfquery name="rsLineas" datasource="#session.DSN#">
                select
                	a.Dlinea,
                    a.IDcontable
                    as IDcontable,
                    a.Dmovimiento,
                    #LvarDdescripcion# as Ddescripcion,
                    <cfif isdefined("form.btnDownload")>
                        #LvarCFformato# as CFformato,
                        #LvarCFdescripcion# as CFdescripcion,
                    </cfif>
                    #LvarCformato# as Cformato,
                    #LvarCdescripcion# as Cdescripcion,
                    c.Mnombre,
                    c.Miso4217,
					c.Mcodigo,
                    case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end as Debitos,
                    case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end as Creditos,
                    d.Oficodigo as Odescripcion,
                    a.Doriginal,
                    a.Dtipocambio,
                    a.Dreferencia,
					coalesce(a.Ddocumento, 'N/A') as Ddocumento,
                    coalesce(f.CFcodigo,'N/A') as CFcodigo,
		    coalesce(a.NumeroEvento,'') as NumeroEvento,
					a.Ddescripcion as detalleDescripcion
                from DContables a
                	<cfif isdefined("form.btnDownload")>
                        inner join CFinanciera bb
                            on bb.CFcuenta = a.CFcuenta
                    </cfif>
                    inner join CContables b
                        on b.Ccuenta = a.Ccuenta
                    inner join Monedas c
                        on c.Mcodigo = a.Mcodigo
                    inner join Oficinas d
                        on  d.Ecodigo = a.Ecodigo
                        and d.Ocodigo = a.Ocodigo
				    left outer join CFuncional f
                		on f.CFid = a.CFid
                where a.IDcontable = #IDcontable#
                order by a.Dlinea
            </cfquery>
	</cfif>
	<cfquery name="rsTotalLineas" datasource="#Session.DSN#">
		select
			sum(case a.Dmovimiento when 'D' then a.Dlocal else 0.00 end) as Debitos,
			sum(case a.Dmovimiento when 'C' then a.Dlocal else 0.00 end) as Creditos
		from DContables a
		where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
	</cfquery>

	<cfquery name="rsEnc" datasource="#Session.DSN#">
	 	select a.Ecodigo, c.Edescripcion as Empresa,  a.Cconcepto, b.Cdescripcion, a.Eperiodo, a.Emes, a.Edocumento, a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, a.ECauxiliar, a.ECusuario, a.ECusucodigo, a.ECfechacreacion, a.ECipcrea, a.ECestado, a.BMUsucodigo
		from EContables a, ConceptoContableE b, Empresas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		  and a.Ecodigo = b.Ecodigo
		  and a.Cconcepto = b.Cconcepto
		  and a.Ecodigo = c.Ecodigo
	</cfquery>

	<cfif isdefined("form.regresar")>
		<cfset formAction = form.regresar>
	<cfelse>
		<cfset formAction = "DocumentosContables.cfm">
	</cfif>

	<cfoutput>

        <table width="100%" border="0" cellpadding="1" cellspacing="0">

        <tr>
          <td colspan="3"><font size="2">&nbsp;</font></td>
          <td colspan="2" nowrap><font size="2">&nbsp;</font></td>
          <td colspan="5"><font size="2"><strong>#LBl_FecDoc#:</strong> #LSDateFormat(rsEnc.Efecha, 'dd/mm/yyyy')#</font></td>
        </tr>
        <tr>
          <td colspan="3"><font size="2"><strong>#LB_Concepto#:</strong> #rsEnc.Cdescripcion#</font></td>
          <td colspan="2" nowrap><font size="2"><strong>#LBl_Period#:</strong> #rsEnc.Eperiodo# <strong>#CMB_Mes#:</strong> #rsEnc.Emes#</font></td>
          <td colspan="4"><font size="2"><strong>#LB_Usuario#:</strong>#rsEnc.ECusuario#</font></td>
          <td>&nbsp;</td>
          </tr>
        <tr>
          <td colspan="3"><font size="2"><strong>#PolizaE#:</strong> #rsEnc.Edocumento#</font></td>
          <td colspan="2">&nbsp;</td>
          <td colspan="4" nowrap><cfif rsEnc.ECauxiliar EQ "S">
          <font color="##FF0000">#LBl_DocGenAux#</font>
          </cfif></td>
          <td>&nbsp;</td>
          </tr>
        <tr>
        <tr>
            <td colspan="10" ><font size="2"><strong>#LBl_Descrip#:</strong> #rsEnc.Edescripcion#</font></td>
        </tr>
          <td colspan="3"><font size="2"><strong>#LBl_Referencia#:</strong> #rsEnc.Ereferencia#</font></td>
          <td colspan="2" nowrap><font size="2"><strong>#LBl_Documento#:</strong> #rsEnc.Edocbase#</font></td>
          <td colspan="5" >&nbsp;</td>
          </tr>
        <tr>
          <td colspan="10">&nbsp;</td>
          </tr>
        </table>
        <table style="width:100%" border="0" cellpadding="2" cellspacing="0">
        <tr class="niv3">
          <td bgcolor="##E2E2E2">#LBl_Linea#</td>
          <cfif inter eq "S">
              <td bgcolor="##E2E2E2">#LB_Empresa#</td>
          </cfif>
          <cfif sufix eq 'E'>
          	<td colspan="2" bgcolor="##E2E2E2">#LBl_Evento#</td>
		  <cfelse>
              <td bgcolor="##E2E2E2">#LB_Oficina#</td>
              <td bgcolor="##E2E2E2">#LBl_CFunc#</td>
          </cfif>
          <td bgcolor="##E2E2E2">#LBl_Descrip#</td>
          <td nowrap bgcolor="##E2E2E2">#LBl_CtaC#</td>
          <cfif isdefined("form.btnDownload")>
          	<td nowrap bgcolor="##E2E2E2">#LBl_CtaFinan#</td>
			<td bgcolor="##E2E2E2">#LBl_DescDet#</td>
          </cfif>
          <td nowrap bgcolor="##E2E2E2">#LBl_Ref#</td>
		  <td nowrap bgcolor="##E2E2E2">#LBl_Doc#</td>
          <td align="right" bgcolor="##E2E2E2">#LB_Monto#</td>
          <td bgcolor="##E2E2E2">#LB_Moneda#</td>
          <td align="right" bgcolor="##E2E2E2">#LBl_TC#</td>
          <td bgcolor="##E2E2E2"align="right">
            <cf_translate key="debito">Débitos</cf_translate></td>
          <td bgcolor="##E2E2E2"  align="right">
            <cf_translate key="credito">Créditos</cf_translate></td>
        </tr>


        <!--- ******************************************** --->
        <cfsavecontent variable="vEnc">
            <table width="100%" border="0" cellpadding="1" cellspacing="0">
                <tr>
                  <td colspan="10"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">#rsEnc.Empresa#</font></strong></div></td>
                </tr>
                <tr>
                  <td colspan="10"><div align="center"><font size="2">#LBl_Documento# <cfif inter eq "S">&nbsp;#LBl_Inter#&nbsp;</cfif>
                        #LBl_SinApl#</font></div>
                  </td>
                </tr>
                <tr>
                  <td colspan="3"><font size="2">&nbsp;</font></td>
                  <td colspan="2" nowrap><font size="2">&nbsp;</font></td>
                  <td colspan="5"><font size="2"><strong>#LBl_FecDoc#:</strong> #LSDateFormat(rsEnc.Efecha, 'dd/mm/yyyy')#</font></td>
                </tr>
                <tr>
                  <td colspan="3"><font size="2"><strong>#LB_Concepto#:</strong> #rsEnc.Cdescripcion#</font></td>
                  <td colspan="2" nowrap><font size="2"><strong>#LBl_Period#:</strong> #rsEnc.Eperiodo# <strong>#CMB_Mes#:</strong> #rsEnc.Emes#</font></td>
                  <td colspan="4"><font size="2"><strong>#LB_Usuario#:</strong>#rsEnc.ECusuario#</font></td>
                  <td>&nbsp;</td>
                  </tr>
                <tr>
                  <td colspan="3"><font size="2"><strong>#PolizaE#:</strong> #rsEnc.Edocumento#</font></td>
                  <td colspan="2" nowrap><font size="2"><strong>#LBl_Descrip#:</strong> #rsEnc.Edescripcion#</font></td>
                  <td colspan="4" nowrap><cfif rsEnc.ECauxiliar EQ "S">
                  <font color="##FF0000">#LBl_DocGenAux#</font>
                  </cfif></td>
                  <td>&nbsp;</td>
                  </tr>
                <tr>
                  <td colspan="3"><font size="2"><strong>#LBl_Referencia#:</strong> #rsEnc.Ereferencia#</font></td>
                  <td colspan="2" nowrap><font size="2"><strong>#LBl_Documento#:</strong> #rsEnc.Edocbase#</font></td>
                  <td colspan="5" >&nbsp;</td>
                </tr>
            </table>
        </cfsavecontent>
    <!--- ******************************************** --->
    </cfoutput>

        <cfoutput query="rsLineas">
          <cfset Lvarcontador = Lvarcontador + 1>

          <cfif vLineaspagina GT 122 >
                  <cfset vPagina = vpagina + 1>
                  <tr><td colspan="13" align="right" style="padding:3px;">#LBl_Pagina# #vPagina#</td></tr>


                <tr style="page-break-after:always;"></tr>
                <tr><td colspan="12">#vEnc#</td></tr>
                <tr class="niv3">
                  <td bgcolor="##E2E2E2">#LBl_Linea#</td>
                  <cfif inter eq "S">
                      <td bgcolor="##E2E2E2">#LB_Empresa#</td>
                  </cfif>
				  <cfif sufix eq 'E'>
                    <td colspan="2" bgcolor="##E2E2E2">#LBl_Evento#</td>
                  <cfelse>
                      <td bgcolor="##E2E2E2">#LB_Oficina#</td>
                      <td bgcolor="##E2E2E2">#LBl_CFunc#</td>
                  </cfif>
                  <td bgcolor="##E2E2E2">#LBl_Descrip#</td>
                  <td nowrap bgcolor="##E2E2E2">#LBl_CtaC#</td>
                  <cfif isdefined("form.btnDownload")>
                    <td nowrap bgcolor="##E2E2E2">#LBl_CtaFinan#</td>
					<td bgcolor="##E2E2E2">#LBl_DescDet#</td>
                  </cfif>

                  <td nowrap bgcolor="##E2E2E2">#LBl_Ref#</td>
				  <td nowrap bgcolor="##E2E2E2">#LBl_Doc#</td>
                  <td align="right" bgcolor="##E2E2E2">#LB_Monto#</td>
                  <td bgcolor="##E2E2E2">#LB_Moneda#</td>
                  <td align="right" bgcolor="##E2E2E2">T.C.</td>
                  <td bgcolor="##E2E2E2">
                    <div align="right"<cf_translate key="debito">Débitos</cf_translate></div></td>
                  <td bgcolor="##E2E2E2">
                    <div align="right"><cf_translate key="credito">Créditos</cf_translate></div></td>
                </tr>
                <tr><td>&nbsp;</td></tr>
              <cfset vLineaspagina = 0>
          </cfif>

          <cfset vLineaspagina = vLineaspagina + 1>

          <tr <cfif Lvarcontador MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
            <cfset punto = "">
            <td class="niv4">#Dlinea#</td>
            <cfif inter eq "S">
                <td nowrap class="niv4">#Edescripcion#</td>
            </cfif>
			<cfif sufix eq 'E'>
            	<td colspan="2" nowrap="nowrap" class="niv4">#NumeroEvento#</td>
            <cfelse>
                <td nowrap class="niv4">#Odescripcion#</td>
                <td nowrap="nowrap" class="niv4">#CFcodigo#</td>
            </cfif>
            <td class="niv4">
              <cfif Len(Trim(Ddescripcion)) GT 74>
                    <cfset punto = " ...">
              </cfif>
              <cfif Len(Trim(Ddescripcion)) GT 38>
                  <cfset vLineaspagina = vLineaspagina + 1>
              </cfif>
              #Mid(Cdescripcion,1,74)##punto#</td>
            <td nowrap title="#Cdescripcion#" class="niv4">#trim(Cformato)#</td>
            <cfif isdefined("form.btnDownload")>
                <td nowrap title="#CFdescripcion#" class="niv4">#trim(CFformato)#</td>
				<td nowrap class="niv4">#detalleDescripcion#</td>
            </cfif>

            <td nowrap class="niv4">#Dreferencia#</td>
			<td nowrap class="niv4">#Ddocumento#</td>
            <td align="right" nowrap class="niv4">
				<cfif #Mcodigo# EQ 1>
					#LSCurrencyFormat((Doriginal*Dtipocambio),'none')#
				<cfelse>
					#LSCurrencyFormat(Doriginal,'none')#
				</cfif>
			</td>
            <td nowrap class="niv4">#Miso4217#</a></td>
            <td align="right" class="niv4">
				<cfif #Mcodigo# NEQ 1>
					#LSCurrencyFormat(Dtipocambio,'none')#
				<cfelse>
					1.00
				</cfif>
			</td>
            <td class="niv4" align="right">#LSCurrencyFormat(Debitos,'none')#</td>
            <td class="niv4" align="right">#LSCurrencyFormat(Creditos,'none')#</td>
          </tr>
        </cfoutput>
	<cfoutput>
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
          <td>&nbsp;</td>
		  <td nowrap>&nbsp;</td>
		  <td nowrap>&nbsp;</td>
		  <td align="right">&nbsp;</td>
		  <td>&nbsp;</td>
		  <cfif inter eq "S">
			 <td>&nbsp;</td>
		  </cfif>
		  <td align="right" class="niv3" colspan="2">
			  <cfif rsTotalLineas.RecordCount GT 0 >
				#LBl_Totales#:
			  </cfif>
		  </td>
		  <td nowrap>&nbsp;</td>
		  <td align="right" class="niv3">
			  <cfif rsTotalLineas.RecordCount GT 0 >
				#LSCurrencyFormat(rsTotalLineas.Debitos,'none')#
			  </cfif>
			  </td>
		  <td align="right" class="niv3">
			  <cfif rsTotalLineas.RecordCount GT 0 >
				#LSCurrencyFormat(rsTotalLineas.Creditos,'none')#
			  </cfif>
		  </td>
		</tr>

		<tr>
		  <td colspan="10">&nbsp;</td>
		</tr>
		  <cfset vPagina = vpagina + 1>
		  <tr><td colspan="13" align="right" style="padding:3px;">#LBl_Pagina# #vPagina#</td></tr>
		</table>
	</cfoutput>

	</cfloop>
	<table  width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
          <cfset LBl_FinRep = t.Translate('LBl_FinRep','FIN DEL REPORTE')>
		  <td colspan="10"><cfoutput><div align="center">---------------------------- #LBl_FinRep# ----------------------------</div></cfoutput></td>
		  </tr>
		  <tr>
		  <td colspan="10">&nbsp;</td>
		</tr>
	</table>


<cfelse>
	<cfoutput>#PolizaErr#</cfoutput>
</cfif>