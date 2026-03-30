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

<cfinvoke key="MSG_Periodo" 			default="Periodo"					        returnvariable="MSG_Periodo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" 		default="Descripcion"       returnvariable="LB_Descripcion" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>


<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaErr = t.Translate('PolizaErr','Error! La p&oacute;liza indicada no Existe!. Por favor revise sus datos.')>
<cfset LBl_Documento = t.Translate('LBl_Documento','Documento')>
<cfset LBl_Inter = t.Translate('LBl_Inter','InterCompa&ntilde;&iacute;a')>
<cfset LBl_SinApl = t.Translate('LBl_SinApl','sin aplicar')>
<cfset LBl_RepDocConRes = t.Translate('LBl_RepDocConRes','Reporte Documentos Contables Resumido')>
<cfset LBl_FecDoc = t.Translate('LBl_FecDoc','Fecha Doc.')>
<cfset LB_Concepto = t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Usuario = t.Translate('LB_Usuario','Usuario','/sif/generales.xml')>
<cfset LBl_DocGenAux = t.Translate('LBl_DocGenAux','Documento Generado desde Auxiliar')>
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LBl_Referencia = t.Translate('LBl_Referencia','Referencia')>
<cfset LB_Empresa = t.Translate('LB_Empresa','Empresa','/sif/generales.xml')>
<cfset LBl_CFunc = t.Translate('LBl_CFunc','C. Funcional')>
<cfset LBl_DescDet = t.Translate('LBl_DescDet','Descripci&oacute;n Detalle')>
<cfset LBl_DescCta = t.Translate('LBl_DescCta','Descripci&oacute;n Cuenta')>
<cfset LBl_CtaC = t.Translate('LBl_CtaC','Cuenta C.')>
<cfset LBl_CtaFinan = t.Translate('LBl_CtaFinan','Cuenta Financiera')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LBl_Pagina = t.Translate('LBl_Pagina','P&aacute;gina')>
<cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>


<cfif (isdefined('form.Id') and len(trim(form.Id)) GT 0) or isdefined('form.chk')>
	<cf_dbfunction name="concat" args="a.Dreferencia + '-' + coalesce(a.Ddocumento, 'N/A')" delimiters="+" returnvariable="LvarRef">

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
			<cfset IrA="listaDocumentosContables#sufix#.cfm">
	<cfelse>
			<cfset IDAsientos=#form.Id#>
			<cfset IrA="DocumentosContables#sufix#.cfm?dummy=1#params#"> 
	</cfif> 
	
	   <cf_htmlreportsheaders
        title="Saldos Diarios" 
        filename="SaldosDiarios#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
        ira="#IrA#">
    <cfif not isdefined("form.btnDownload")>
        <cf_templatecss>
    </cfif>	
	  <style type="text/css">
            * { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
            .niv1 { font-size: 18px; }
            .niv2 { font-size: 16px; }
            .niv3 { font-size: 11px; font-weight:bold }
            .niv4 { font-size: 9px; }
        </style>			
	
	<cfset Lvarcontador = 0>
    <cfset vLineaspagina = 0>
    <cfset vPagina = 0>
    <cfflush interval="1024">	
	
	<!---Pinta el encabezado --->
	  <table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
		 		 <td colspan="10"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif"><cfoutput>#EncEmpresa.Empresa#</cfoutput></font></strong></div></td>
			</tr>
			<tr>
            <cfoutput>
		  		<td colspan="10">
					<div align="center"><font size="2">#LBl_Documento# <cfif inter eq "S">&nbsp;#LBl_Inter#&nbsp;</cfif>
				#LBl_SinApl#</font></div>
		 	    </td>
			</tr>
			<tr>
				<td colspan="10" style="font-style:oblique;">
					<div align="center"><font size="2">#LBl_RepDocConRes#</font></div>
				</td>
			</tr>
            </cfoutput>								
	</table>
<cfloop index="IDcontable" list="#IDAsientos#">	


    <cfquery name="rsLineas" datasource="#session.DSN#">
                select 	
                <cfif inter eq "S">e.Edescripcion, </cfif>                                    
                a.Dmovimiento,
                c.Mnombre, 
                c.Miso4217,
				<cfif isdefined("form.btnDownload")>
                        	#LvarCFformato# as CFformato,
                            #LvarCFdescripcion# as CFdescripcion,
							a.Ddescripcion,
                </cfif>
                case a.Dmovimiento when 'D' then sum(a.Dlocal) else 0.00 end as Debitos, 
                case a.Dmovimiento when 'C' then sum(a.Dlocal) else 0.00 end as Creditos, 
                d.Oficodigo as Odescripcion,
                sum(a.Doriginal),
                b.Cdescripcion,
                coalesce(f.CFcodigo,'N/A') as CFcodigo,
                b.Cformato
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
            		on  d.Ecodigo = <cfif inter eq "S">b.Ecodigo<cfelse>a.Ecodigo</cfif>
            		and d.Ocodigo = a.Ocodigo
				<cfif inter eq "S">   
                    inner join Empresas e 
                    on e.Ecodigo = b.Ecodigo
                </cfif> 
            	left outer join CFuncional f
            		on f.CFid = a.CFid
            
            where a.IDcontable =  #IDcontable# 
           		 group by  a.Dmovimiento,
                c.Mnombre, 
                c.Miso4217,
                d.Oficodigo,                        
                b.Cdescripcion,
                coalesce(f.CFcodigo,'N/A'),
				
				<cfif isdefined("form.btnDownload")>
					a.Ddescripcion,
                   bb.CFformato,
                   bb.CFdescripcion,
                </cfif>
                b.Cformato
                <cfif inter eq "S">
                 	,e.Edescripcion
                </cfif>				
     </cfquery>   
     
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
                      <td colspan="2" nowrap><font size="2"><strong>#MSG_Periodo#:</strong> #rsEnc.Eperiodo# <strong>#CMB_Mes#:</strong> #rsEnc.Emes#</font></td>
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
                        <td colspan="10" ><font size="2"><strong>#LB_Descripcion#:</strong> #rsEnc.Edescripcion#</font></td>
                    </tr>
                      <td colspan="3"><font size="2"><strong>#LBl_Referencia#:</strong> #rsEnc.Ereferencia#</font></td>
                      <td colspan="2" nowrap><font size="2"><strong>#LBl_Documento#:</strong> #rsEnc.Edocbase#</font></td>
                      </tr>
                      <tr><td>&nbsp;</td></tr>
                </table>
            <table style="width:100%" border="0" cellpadding="2" cellspacing="0">
            <tr class="niv3"> 
              <cfif inter eq "S">
                  <td bgcolor="##E2E2E2">#LB_Empresa#</td>
              </cfif>	
              <td bgcolor="##E2E2E2">#LB_Oficina#</td>
              <td bgcolor="##E2E2E2">#LBl_CFunc#</td>
			<cfif isdefined("form.btnDownload")>
              <td bgcolor="##E2E2E2">#LBl_DescDet#</td>
			</cfif>
			  <td bgcolor="##E2E2E2">#LBl_DescCta#</td>
              <td nowrap bgcolor="##E2E2E2">#LBl_CtaC#</td>
              <cfif isdefined("form.btnDownload")>
                <td nowrap bgcolor="##E2E2E2">#LBl_CtaFinan#</td>
              </cfif>
              <!--- <td align="right" bgcolor="##E2E2E2">Monto</td> --->
              <td bgcolor="##E2E2E2">#LB_Moneda#</td>
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
                      <td colspan="2" nowrap><font size="2"><strong>#MSG_Periodo#:</strong> #rsEnc.Eperiodo# <strong>Mes:</strong> #rsEnc.Emes#</font></td>
                      <td colspan="4"><font size="2"><strong>#LB_Usuario#:</strong>#rsEnc.ECusuario#</font></td>
                      <td>&nbsp;</td>
                      </tr>
                    <tr>
                      <td colspan="3"><font size="2"><strong>#PolizaE#:</strong> #rsEnc.Edocumento#</font></td>
                      <td colspan="2" nowrap><font size="2"><strong>#LB_Descripcion#:</strong> #rsEnc.Edescripcion#</font></td>
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
          
          <cfif vLineaspagina GT 74 >
                  <cfset vPagina = vpagina + 1>
                  <tr><td colspan="12" align="right" style="padding:3px;">#LBl_Pagina# #vPagina#</td></tr>
                  
                  
                <tr style="page-break-after:always;"></tr>
                <tr><td colspan="12">#vEnc#</td></tr>
                <tr class="niv3"> 
                  <cfif inter eq "S">
                      <td bgcolor="##E2E2E2">#LB_Empresa#</td>
                  </cfif>	
                  <td bgcolor="##E2E2E2">#LB_Oficina#</td>
                  <td bgcolor="##E2E2E2">#LBl_CFunc#</td>
				<cfif isdefined("form.btnDownload")>
                  <td bgcolor="##E2E2E2">#LBl_DescDet#</td>
				</cfif>
				  <td bgcolor="##E2E2E2">#LBl_DescCta#</td>
                  <td nowrap bgcolor="##E2E2E2">#LBl_CtaC#</td>
                  <cfif isdefined("form.btnDownload")>
                    <td nowrap bgcolor="##E2E2E2">Cuenta Financiera</td>
                  </cfif>
                  <!--- <td align="right" bgcolor="##E2E2E2">Monto</td> --->
                  <td bgcolor="##E2E2E2">#LB_Moneda#</td>
                  <td bgcolor="##E2E2E2"> 
                    <div align="right"><cf_translate key="debito">Débitos</cf_translate></div></td>
                  <td bgcolor="##E2E2E2"> 
                    <div align="right"><cf_translate key="credito">Créditos</cf_translate></div></td>
                </tr>
                <tr><td>&nbsp;</td></tr>
              <cfset vLineaspagina = 0>
          </cfif>
    
          <cfset vLineaspagina = vLineaspagina + 1>
          
          <tr <cfif Lvarcontador MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
            <cfset punto = "">
            <cfif inter eq "S">
                <td nowrap class="niv4">#Edescripcion#</td>
            </cfif>
            <td nowrap class="niv4">#Odescripcion#</td>
            <td nowrap="nowrap" class="niv4">#CFcodigo#</td>
            <td class="niv4"> 
              <cfif Len(Trim(Cdescripcion)) GT 74>
                    <cfset punto = " ...">
              </cfif>
              <cfif Len(Trim(Cdescripcion)) GT 38>
                  <cfset vLineaspagina = vLineaspagina + 1>
              </cfif>
              #Mid(Cdescripcion,1,74)##punto#</td>
			<cfif isdefined("form.btnDownload")>
				<td nowrap title="#Ddescripcion#" class="niv4">#trim(Ddescripcion)#</td>
			</cfif>
			<td nowrap title="#Cdescripcion#" class="niv4">#trim(Cformato)#</td>
            <cfif isdefined("form.btnDownload")>
              <td nowrap title="#CFdescripcion#" class="niv4">#trim(CFformato)#</td> 
            </cfif>
            <!--- <td align="right" nowrap class="niv4">&nbsp;</td> --->
            <td nowrap class="niv4">#Miso4217#</a></td>
            <td class="niv4" align="right">#LSCurrencyFormat(Debitos,'none')#</td>
            <td class="niv4" align="right">#LSCurrencyFormat(Creditos,'none')#</td>
          </tr>
        </cfoutput> 
	<cfoutput>
		
		<tr> 
		  <td>&nbsp;</td>
		  <td align="right">&nbsp;</td>
		  <td>&nbsp;</td>
		  <cfif inter eq "S">
			 <td>&nbsp;</td>
		  </cfif>
		  <td align="right" class="niv3">
			  <cfif rsTotalLineas.RecordCount GT 0 >
				Totales: 
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
		  <tr><td colspan="8" align="right" style="padding:3px;">#LBl_Pagina# #vPagina#</td></tr>		  
		</table>
	</cfoutput>	
</cfloop>	
	<table  width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
        	<cfset LBl_FinRepRes = t.Translate('LBl_FinRepRes','FIN DEL REPORTE RESUMIDO')>
		 	 <td colspan="10"><cfoutput><div align="center">---------------------------- #LBl_FinRepRes# ----------------------------</div></cfoutput></td>
		</tr>		  
		<tr>
	  	     <td colspan="10">&nbsp;</td>
		</tr>
	</table>	
<cfelse>
	<cfoutput>#PolizaErr#</cfoutput>
</cfif>
<script  language="javascript1.2" >
	function verResumido()
	{
		<cfoutput> 
		document.reporteForm.resumido.value=1;                                      
		document.reporteForm.submit();
		</cfoutput>
	}
</script>