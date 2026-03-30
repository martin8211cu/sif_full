<cfinvoke  key="BTN_Buscar" default="Buscar" component="sif.Componentes.Translate" method="Translate"
	returnvariable="BTN_Buscar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="linea" default="L&iacute;nea" component="sif.Componentes.Translate" method="Translate"
	returnvariable="linea" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
	returnvariable="descripcion" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="CuentaFinanciera" default="Cuenta Financiera" component="sif.Componentes.Translate" method="Translate"
	returnvariable="CuentaFinanciera" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="Moneda" default="Moneda" component="sif.Componentes.Translate" method="Translate"
	returnvariable="Moneda" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="debito" default="D&eacute;bito" component="sif.Componentes.Translate" method="Translate"
	returnvariable="Debito" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="credito" default="Cr&eacute;dito" component="sif.Componentes.Translate" method="Translate"
	returnvariable="Credito" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Periodo" default="Periodo" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Periodo" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Moneda" default="Moneda" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Moneda" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Mes" default="Mes" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Mes" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Titulo" default="Consulta Poliza" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Titulo" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Lote" default="Lote" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Lote" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="LB_Fecha" default="Fecha" component="sif.Componentes.Translate" method="Translate"
	returnvariable="LB_Fecha" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="MSG_DeseaElimLinea" default="Desea eliminar la línea" component="sif.Componentes.Translate" method="Translate"
	returnvariable="MSG_DeseaElimLinea" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="MSG_DelAsCont" default="del asiento contable ?" component="sif.Componentes.Translate" method="Translate"
	returnvariable="MSG_DelAsCont" xmlfile="ConsultaPolizas.xml"/>
<cfinvoke  key="BTN_Borrar" default="Borrar" component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Borrar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="MSG_ElimLinMarc" default="Desea eliminar las líneas marcadas?" component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_ElimLinMarc"/>
<cfinvoke  key="MSG_NoLinMarc" default="No hay lineas marcadas" component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_NoLinMarc"/>
<cfoutput>


<input id="periodo" type="hidden" value="<cfif isdefined("form.periodo") and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
<input id="mes" 	  type="hidden" value="<cfif isdefined("form.mes") 		   and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
<input id="chk" 	  type="hidden" value="<cfif isdefined("form.chk") and len(trim(form.chk))>#form.chk#</cfif>" tabindex="-1">
<input id="lote"    type="hidden" value="<cfif isdefined("form.lote") and len(trim(form.lote))>#form.lote#</cfif>" tabindex="-1">
<input id="poliza"  type="hidden" value="<cfif isdefined("form.poliza") and len(trim(form.poliza))>#form.poliza#</cfif>" tabindex="-1">
<input id="Moneda"  type="hidden" value="<cfif isdefined("form.Moneda")     and len(trim(form.Moneda))>#form.Moneda#</cfif>" tabindex="-1">
<input id="Documento" type="hidden" value="<cfif isdefined("form.Documento") 		   and len(trim(form.Documento)) >#form.Documento#</cfif>" tabindex="-1">
<input id="Referencia" type="hidden" value="<cfif isdefined("form.Referencia") and len(trim(form.Referencia))>#form.Referencia#</cfif>" tabindex="-1">
<input id="fechaIni" type="hidden" value="<cfif isdefined("form.fechaIni")   and len(trim(form.fechaIni))>#form.fechaIni#</cfif>" tabindex="-1">
<input id="fechaFin" type="hidden" value="<cfif isdefined("form.fechaFin")   and len(trim(form.fechaFin))>#form.fechaFin#</cfif>" tabindex="-1">
</cfoutput>

<cfset navegacion= "">
<cfif isdefined("url.chk") and len(trim(url.chk)) and not isdefined("form.chk")>
    <cfset form.chk = url.chk >
</cfif>
<cfif isdefined("url.tr") and len(trim(url.tr)) and not isdefined("form.tr")>
    <cfset form.tr = url.tr >
</cfif>
<cfif isdefined("form.tr") and len(trim(form.tr)) and not isdefined("url.tr")>
    <cfset form.tr = form.tr >
</cfif>
<cfif isdefined("url.lote") and not isdefined("form.lote")>
    <cfset form.lote = url.lote >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
    <cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes")>
    <cfset form.mes = url.mes >
</cfif>
<cfif isdefined("url.Moneda") and not isdefined("form.Moneda")>
    <cfset form.Moneda = url.Moneda >
</cfif>

<cfif isDefined("form.chk")>
    <cfset navegacion= "chk=#form.chk#">
</cfif>
<cfif isDefined("form.tr")>
    <cfset navegacion= navegacion &"&tr=#form.tr#">
</cfif>
<cfif isDefined("form.lote")>
    <cfset navegacion= navegacion &"&lote=#form.lote#">
</cfif>
<cfif isDefined("form.periodo")>
    <cfset navegacion= navegacion &"&periodo=#form.periodo#">
</cfif>
<cfif isDefined("form.mes")>
    <cfset navegacion= navegacion &"&mes=#form.mes#">
</cfif>
<cfif isDefined("form.Moneda")>
    <cfset navegacion= navegacion &"&Moneda=#form.Moneda#">
</cfif>
<cfif isDefined("form.Documento")>
    <cfset navegacion= navegacion &"&Documento=#form.Documento#">
</cfif>

<cfif isDefined("navegacion") AND len(trim(navegacion))>
    <cfset navegacion= navegacion &"&hdFiltrar=filtrar">
</cfif>

<!--- <cf_dump var="#form#"> --->



<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset LvarXML  = 'SQLGenerarXMLPolizas'>
<!--- <cfdump var = "#form#"> --->
	<cfquery name="rsListaLineas" datasource="#session.DSN#">
        SELECT a.IDcontable,a.Dlinea, substring (a.Ddescripcion, 1, 50) AS Ddescripcion, b.CFformato,
                c.Mnombre, E.Edocumento, CASE WHEN a.Dmovimiento = 'D' THEN a.Dlocal
                                         ELSE 0 END AS Debitos,
                CASE WHEN a.Dmovimiento = 'C' THEN a.Dlocal
                ELSE 0 END AS Creditos,
                CASE WHEN cer.IdContable IS NOT NULL AND cer.linea IS NOT NULL
                THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' style=''cursor:pointer'' alt=''Mostrar CFDI'' onclick=''InfCFDI('+ cast(a.IDcontable as varchar) + ',' + cast(a.Dlinea as varchar) + ',' + cast(cer.IdRep as varchar) + ');''>'
                ELSE
					CASE WHEN (cei.IDcontable IS NULL AND cei.Dlinea IS NULL) and (a.Ccuenta in (select SNcuentacxc FROM SNegocios AS b) or a.Ccuenta in (select b.SNcuentacxp FROM SNegocios AS b) or a.Ccuenta in (select b.Ccuenta FROM CECuentasCFDI AS b))
                	 THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Add.gif'' style=''cursor:pointer'' alt=''Agregar Info CFDI'' onclick=''AddCFDI('+ cast(a.IDcontable as varchar) + ',' + cast(a.Dlinea as varchar) + ');''>'
                     END
                END AS CFDI,
                CASE WHEN cei.IDcontable IS NOT NULL AND cei.Dlinea IS NOT NULL
                THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Money.gif'' alt=''Mostrar Info Bancaria'' style=''cursor:pointer'' onclick=''InfBancaria('+ cast(a.IDcontable as varchar) + ',' + cast(a.Dlinea as varchar) + ');''>'
                ELSE CASE WHEN cb.Ccuenta = b.Ccuenta THEN'<img border=''0'' src=''/cfmx/sif/imagenes/Add.gif'' style=''cursor:pointer'' alt=''Agregar Info Bancaria'' onclick=''InfBancaria('+ cast(a.IDcontable as varchar) + ',' + cast(a.Dlinea as varchar) + ');''>'
		 			 END
                END AS Banco, a.Dreferencia AS Dreferencia , a.Ddocumento AS Ddocumento,
                E.ECauxiliar
        FROM HEContables E
                INNER JOIN HDContables a on a.IDcontable = E.IDcontable
                INNER JOIN CFinanciera b on b.CFcuenta = a.CFcuenta
                    and a.Ecodigo = b.Ecodigo
                INNER JOIN Monedas c on c.Mcodigo = a.Mcodigo
                    and a.Ecodigo = c.Ecodigo
                INNER JOIN CtasMayor ct ON ct.Cmayor = b.Cmayor
                    and b.Ecodigo = ct.Ecodigo
                LEFT JOIN (select distinct IDcontable, Dlinea from CEInfoBancariaSAT) cei ON cei.IDcontable = a.IDcontable and cei.Dlinea = a.Dlinea
                LEFT JOIN (select Ccuenta,Ecodigo from CuentasBancos group by Ccuenta,Ecodigo) cb ON cb.Ccuenta = b.Ccuenta
                    and a.Ecodigo = cb.Ecodigo
                LEFT JOIN (select IdContable,linea, count(IdRep) cantidad,
							case when count(IdRep) >1 then -1
								else min(IdRep)
							end IdRep
						from CERepositorio
						group by IdContable,linea
				) cer ON cer.IdContable = a.IDcontable and cer.linea = a.Dlinea
        WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        <cfif isdefined("form.chk") and len(trim(form.chk))>
        		AND a.IDcontable in (#form.chk#)
            <cfif isdefined("form.fDescripcion") and Len(Trim(form.fDescripcion))>
                AND UPPER(a.Ddescripcion) like '%#UCASE(Trim(form.fDescripcion))#%'
            </cfif>
            <cfif isdefined("form.fCformato") and Len(Trim(form.fCformato))>
                AND UPPER(b.CFformato) like '%#UCASE(Trim(form.fCformato))#%'
            </cfif>
            <cfif isdefined("form.fref") and Len(Trim(form.fref))>
                AND UPPER(a.Dreferencia) like '%#UCASE(Trim(form.fref))#%'
            </cfif>
            <cfif isdefined("form.flinea") and len(trim(form.flinea)) gt 0>
                AND a.Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.flinea)#">
            </cfif>
            <cfif isdefined("form.fdoc") and Len(Trim(form.fdoc))>
                AND UPPER(a.Ddocumento) LIKE UPPER('%#Trim(form.fdoc)#%')
            </cfif>
        <cfelse>
            <cfif isdefined("form.lote") and Len(Trim(form.lote)) and trim(form.lote) NEQ -1>
                AND E.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.lote)#">
            </cfif>
            <cfif isdefined("form.poliza") and Len(Trim(form.poliza)) and trim(form.poliza) NEQ -1>
                AND E.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.poliza)#">
            </cfif>
            <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
                AND a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Moneda)#">
            </cfif>
            <cfif isdefined("form.periodo") and Len(Trim(form.periodo)) and trim(form.periodo) NEQ -1>
                AND a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.Periodo)#">
            </cfif>
            <cfif isdefined("form.mes") and Len(Trim(form.mes)) and Trim(form.mes) NEQ -1>
                AND a.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.Mes)#">
            </cfif>
            <cfif isdefined("form.Documento") and Len(Trim(form.Documento))>
                AND UPPER(E.Edocbase) LIKE UPPER('%#form.Documento#%')
            </cfif>
            <cfif isdefined("form.Referencia") and Len(Trim(form.Referencia))>
                AND UPPER(E.Ereferencia) like '%#UCASE(form.Referencia)#%'
            </cfif>
            <cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) GT 0 and LSisdate(listgetat(form.fechaIni, 1))>
                AND <cf_dbfunction name="to_date00" args="E.ECfechacreacion"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
            </cfif>
            <cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) GT 0 and LSisdate(listgetat(form.fechaFin, 1))>
                AND <cf_dbfunction name="to_date00" args="E.ECfechacreacion"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
            </cfif>
        </cfif>
        ORDER BY a.IDcontable,E.Edocumento, a.Dlinea
    </cfquery>

    <cf_templateheader title="#LB_Titulo#">
    <table width="100%" cellpadding="2" cellspacing="0" >
         <tr>
            <td valign="top">
                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
                <cfoutput>
                    <!--- inicio encabezado --->
                    <table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;" align="center">
                        <tr>
                            <td width="50%">
                                <table border="0" cellspacing="1" cellpadding="1" width="100%">
                                    <tr>
                                        <td align="right" width="50%">
                                            <b>
                                                #LB_Lote#
                                            </b>
                                        </td>
                                        <td>

											<cfif isdefined('form.lote')>
									    	<cfset form.lote = #form.lote#>
									    	<cfelseif isdefined('url.lote')>
										    	<cfset form.lote = #url.lote#>
										    <cfelse>
										    	<cfset form.lote = "">
										    </cfif>
		                                	<cfif isdefined('form.periodo')>
										    	<cfset form.periodo = #form.periodo#>
									    	<cfelseif isdefined('url.periodo')>
										    	<cfset form.periodo = #url.periodo#>
										    <cfelse>
										    	<cfset form.periodo = "">
										    </cfif>
		                                    <cfif isdefined('form.mes')>
										    	<cfset form.mes = #form.mes#>
									    	<cfelseif isdefined('url.mes')>
										    	<cfset form.mes = #url.mes#>
										    <cfelse>
										    	<cfset form.mes = "">
										    </cfif>
		                                    <cfif isdefined('form.moneda')>
										    	<cfset form.moneda = #form.moneda#>
									    	<cfelseif isdefined('url.moneda')>
										    	<cfset form.moneda = #url.moneda#>
										    <cfelse>
										    	<cfset form.moneda = "">
											</cfif>
		                                    <cfif isdefined('form.chk')>
										    	<cfset form.chk = #form.chk#>
									    	<cfelseif isdefined('url.chk')>
										    	<cfset form.chk = #url.chk#>
										    <cfelse>
										    	<cfset form.chk = "">
										    </cfif>
                                            <cfif isdefined("form.lote") and len(form.lote) GT 0>
                                                <cfquery name="rsLotes" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
                                                    select uc.Cconcepto, e.Cdescripcion
                                                    from UsuarioConceptoContableE uc
                                                        inner join ConceptoContableE e
                                                         on e.Ecodigo = uc.Ecodigo
                                                        and e.Cconcepto = uc.Cconcepto
                                                    where uc.Ecodigo = #session.Ecodigo#
                                                      and uc.Usucodigo = #Session.Usucodigo#
                                                      and uc.Cconcepto = #form.lote#
                                                    union all
                                                    select e.Cconcepto, e.Cdescripcion
                                                    from ConceptoContableE e
                                                    where e.Ecodigo = #session.Ecodigo#
                                                      and
                                                        (
                                                            select count(1)
                                                            from UsuarioConceptoContableE uc
                                                            where uc.Ecodigo = e.Ecodigo
                                                              and uc.Cconcepto = e.Cconcepto
                                                        ) = 0
                                                        and e.Cconcepto = #form.lote#
                                                </cfquery>
                                            </cfif>

                                            <input type="text" name="lote" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.lote') and len(form.lote) GT 0 and #form.lote# NEQ -1>#rsLotes.Cdescripcion#<cfelse>Todos</cfif>" size = "35">
                                            <!--- <select name="lote">
                                                <option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
                                                <cfloop query="rsLotes">
                                                <option value="#Cconcepto#"<cfif isdefined("form.lote") and form.lote eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
                                                </cfloop>
                                                </select> --->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <b>
                                                #LB_Moneda#
                                            </b>
                                        </td>
                                        <td>
                                        	<cfif isdefined("form.Moneda") and len(form.Moneda) GT 0>
												<cfquery name="rsMoneda" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,1,0)#">
                                                    select Mcodigo,Mnombre from Monedas
                                                    where Ecodigo = #session.Ecodigo#
                                                    and Mcodigo = #form.Moneda#
                                                    order by Mcodigo
												</cfquery>
											</cfif>
                                            <input type="text" name="Moneda" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.Moneda') and len(form.Moneda) gt 0>#rsMoneda.Mnombre#<cfelse>Todas</cfif>">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <b>
                                                #LB_Periodo#
                                            </b>
                                        </td>
                                        <td>
                                            <input type="text" name="periodo" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.periodo') and form.periodo GT 0>#form.periodo#<cfelse>Todos</cfif>">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <b>
                                                #LB_Mes#
                                            </b>
                                        </td>
                                        <td>
                                            <input type="text" name="mes" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.mes') and form.mes gt 0>#form.mes#<cfelse>Todos</cfif>">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top">
                                <table border="0" cellspacing="1" cellpadding="1" width="100%">
                                    <cfif isdefined('form.fechaIni') and len(fechaIni) gt 0>
                                        <tr>
                                            <td align="right">
                                                <b>
                                                    #LB_Fecha# Inicial
                                                </b>
                                            </td>
                                            <td>
                                                <input name="fechaIni" type="text" size="25" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.fechaIni')>#form.fechaIni#</cfif>">
                                            </td>
                                        </tr>
                                    </cfif>
                                    <cfif isdefined('form.fechaFin') and len(fechaFin) gt 0>
                                        <tr>
                                            <td align="right">
                                                <b>
                                                    #LB_Fecha# Final
                                                </b>
                                            </td>
                                            <td>
                                                <input name="fechaFin" type="text" size="25" readonly="true" class="cajasinbordeb" value="<cfif isdefined('form.fechaFin')>#form.fechaFin#</cfif>">
                                            </td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
		    </table>
                    <!--- fin encabezado --->
                </cfoutput>
		<cfoutput>
                	<form name="filtroDetalle" method="post" action="#GetFileFromPath(GetTemplatePath())#" enctype="multipart/form-data">
                		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
                    			<tr>
						<td align="center">
							<cf_sifIncluirSelloDigital nombre="selloDig">
						</td>
					</tr>
                    			<tr>
                        			<td class="fileLabel" align="center" class="fileLabel">
                        				<cfif isdefined('form.periodo') and #form.periodo# NEQ -1 and isdefined('form.mes') and #form.mes# NEQ -1>
                            					<input type="button" class="btnAplicar" value="Preparar" onClick="javascript:Preparar('#LvarXML#')" />
                            				</cfif>
                            				<input type="button" class="btnAnterior" value="Regresar" onClick="location.href='listaConsultaPolizas.cfm?#navegacion#'"/>
                        			</td>
                    			</tr>
					<!--- form --->
                    			<tr>
                        			<td>
                        			</td>
                    			</tr>
                    			<!--- lista --->
                    			<tr>
                        			<td>
                            			<!---  --->
                            			<!--- Filtros para el Detalle del Documento Contable de Importación --->

									<cfif isdefined('form.lote')>
								    	<cfset form.lote = #form.lote#>
							    	<cfelseif isdefined('url.lote')>
								    	<cfset form.lote = #url.lote#>
								    <cfelse>
								    	<cfset form.lote = "">
								    </cfif>
                                	<input type="hidden" name="lote" 	value="#form.lote#">

									<cfif isdefined('form.periodo')>
								    	<cfset form.periodo = #form.periodo#>
							    	<cfelseif isdefined('url.periodo')>
								    	<cfset form.periodo = #url.periodo#>
								    <cfelse>
								    	<cfset form.periodo = "">
								    </cfif>
                                    <input type="hidden" name="periodo" value="#form.periodo#">
									<INPUT type="hidden" name="tr" value="<cfif isdefined('form.tr')>#form.tr#</cfif>">

									<cfif isdefined('form.mes')>
								    	<cfset form.mes = #form.mes#>
							    	<cfelseif isdefined('url.mes')>
								    	<cfset form.mes = #url.mes#>
								    <cfelse>
								    	<cfset form.mes = "">
								    </cfif>
                                    <input type="hidden" name="mes" 	value="#form.mes#">
									<cfif isdefined('form.moneda')>
								    	<cfset form.moneda = #form.moneda#>
							    	<cfelseif isdefined('url.moneda')>
								    	<cfset form.moneda = #url.moneda#>
								    <cfelse>
								    	<cfset form.moneda = "">
									</cfif>
                                    <input type="hidden" name="Moneda" 	value="#form.moneda#">
									<cfif isdefined('form.chk')>
								    	<cfset form.chk = #form.chk#>
							    	<cfelseif isdefined('url.chk')>
								    	<cfset form.chk = #url.chk#>
								    <cfelse>
								    	<cfset form.chk = "">
								    </cfif>
                                    <cfif isdefined('form.chk') and len(trim(form.chk))>
                                    <input type="hidden" name="chk" 	value="#form.chk#">
									</cfif>
                                    <cfif isdefined("rsListaLineas") and
									rsListaLineas.recordcount GT 0 or isdefined("form.fCformato")>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                                            <tr>
                                                <td class="fileLabel">
                                                    <cf_translate key='linea'>
                                                        L&iacute;nea
                                                    </cf_translate>
                                                </td>
                                                <td class="fileLabel">
                                                    <cf_translate key='descripcion'>
                                                        Descripci&oacute;n
                                                    </cf_translate>
                                                </td>
                                                <td class="fileLabel">
                                                    <cf_translate key='cuenta_contable'>
                                                        Cuenta Financiera
                                                    </cf_translate>
                                                </td>
                                                <td class="fileLabel">
                                                    <cf_translate key='cuenta_ref'>
                                                        Ref.
                                                    </cf_translate>
                                                </td>
                                                <td class="fileLabel">
                                                    <cf_translate key='cuenta_doc'>
                                                        Doc.
                                                    </cf_translate>
                                                </td>
                                                <td class="fileLabel">
                                                    <cf_translate key='cuenta_doc'>
                                                        Tipo XML:
                                                    </cf_translate>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="text" name="flinea" size="13" tabindex="3" value="<cfif isdefined("Form.fDescripcion") and len(trim(Form.flinea))>#Form.flinea#</cfif>">
                                                </td>
                                                <td>
                                                    <input type="text" name="fDescripcion" size="30" tabindex="3" value="<cfif isdefined("Form.fDescripcion")>
                                                    #Form.fDescripcion#
                                    </cfif>
                                    ">
                                                </td>
                                                <td>
                                                    <input type="text" name="fCformato" size="30" tabindex="3" value="<cfif isdefined("Form.fCformato")>#Form.fCformato#</cfif>">
                                                </td>
                                                <td>
                                                    <input type="text" name="fref" size="12" tabindex="3" value="<cfif isdefined("Form.fref")>#Form.fref#</cfif>">
                                                </td>
                                                <td> <input type="text" name="fdoc" size="12" tabindex="3" value="<cfif isdefined("Form.fdoc")>#Form.fdoc#</cfif>">
                                                </td>
                                                <td class="fileLabel">
                                                    <cfif isDefined("form.tr")>
                                                        <cfif #form.tr# EQ "1">
                                                            Polizas
                                                        </cfif>
                                                        <cfif #form.tr# EQ "2">
                                                            Auxiliar de folios
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <!---<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo))> <cfset ofic = ListToArray(Form.fOcodigo, '|')> </cfif>
                                                    <select name="fOcodigo" tabindex="3">
                                                        <option value="">(<cf_translate key=todas>Todas</cf_translate>)</option>
                                                        <cfif modo EQ "CAMBIO">
                                                            <cfloop query="rsOficinasDetalle">
                                                                <option value="#rsOficinasDetalle.Ecodigo#|#rsOficinasDetalle.Ocodigo#"<cfif isdefined("Form.fOcodigo") and Len(Trim(Form.fOcodigo)) and rsOficinasDetalle.Ecodigo EQ ofic[1] and rsOficinasDetalle.Ocodigo EQ ofic[2]> selected</cfif>>#rsOficinasDetalle.Odescripcion#</option>
                                                            </cfloop>
                                                        </cfif>
                                                    </select> --->
                                                </td>
                                                <td align="center" colspan="9">
                                                    <input type="submit" name="btnBuscar" class="btnFiltrar" value="#BTN_Buscar#" tabindex="3">
                                                    <INPUT type="hidden" id="tipoSol">
                                                    <INPUT type="hidden" id="NumSol">
                                                    <INPUT type="hidden" id="NumTram">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                    <cfinvoke
                                                        component="sif.Componentes.pListas"
                                                        method="pListaQuery"
                                                        returnvariable="pListaRet">
                                                    <cfinvokeargument name="query" value="#rsListaLineas#"/>
                                                    <!--- <cfinvokeargument name="desplegar" value="DCIconsecutivo, Ddescripcion, CFformato, Odescripcion, Mnombre, Debitos, Creditos, IMGborrar"/> --->
                                                    <cfinvokeargument name="desplegar" value="Edocumento,Dlinea, Ddescripcion, CFformato, Dreferencia, Ddocumento, Mnombre, Debitos, Creditos,CFDI,Banco"/>
                                                    <cfinvokeargument name="etiquetas" value="Poliza,#linea#, #Descripcion#, #CuentaFinanciera#, Ref , Doc, #Moneda#, #Debito#, #Credito#,CFDI,Banco"/>
                                                    <cfinvokeargument name="formatos" value="S, S, S, S, S, S, S, M, M, S,S,S"/> <cfinvokeargument name="align" value="left, left, left, left, left, left, left, right, right,center,center"/>
                                                    <cfinvokeargument name="ajustar" value="N"/>
                                                    <cfinvokeargument name="totales" value="Debitos,Creditos"/>
                                                    <!---<cfinvokeargument name="pasarTotales" value="#rsTotalLineas.Debitos#,#rsTotalLineas.Creditos#"/>--->
                                                    <cfinvokeargument name="Incluyeform" value="false">
                                                    <cfinvokeargument name="formname" value="filtroDetalle">
                                                    <cfinvokeargument name="keys" value="IDcontable, Dlinea">
                                                    <cfinvokeargument name="irA" value="DocumentosContables.cfm"/>
                                                    <cfinvokeargument name="navegacion" value="lote=#form.lote#&periodo=#form.periodo#&mes=#form.mes#&chk=#form.chk#&moneda=#form.Moneda#&tr=#form.tr#">
                                                    <cfinvokeargument name="showLink" value="false"/>
                                                    <cfinvokeargument name="showEmptyListMsg" value="true"/>
                                                    <cfinvokeargument name="MaxRows" value="30">
													<cfinvokeargument name="MaxRowsQuery" 		value="500"/>
                                                    <cfinvokeargument name="checkBoxes" value="N">
                                                    <cfinvokeargument name="PageIndex" value="2">
                                                    </cfinvoke>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="5"><hr>
                                                </td>
                                            </tr>
                                        </table>
                                    </cfif>

                        </td>
                    </tr>
                </table>
				</form>
              </cfoutput>
                <cf_web_portlet_end>
            </td>
        </tr>
    </table>
    <cf_templatefooter>


<script type="text/javascript" language="javascript">

	function InfBancaria(IDContable,Dlinea) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEInfoBancaria.cfm?IDContable=" + IDContable + "&Dlinea=" + Dlinea + params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.6,window.screen.height*0.5);
	}


	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = window.open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcRefrescar(){
   		document.filtroDetalle.action = 'ConsultaPolizas.cfm';
   		document.filtroDetalle.submit();
  	}

	function InfCFDI(IDContable,Dlinea,IdRep) {
		var left = 110;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 50;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEInfoCFDI.cfm?IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep, left+'px', top+'px', window.screen.width*0.6+'px', window.screen.height*0.75+'px');
	}

	function AddCFDI(IDContable,Dlinea,IdRep) {
		var left = 10;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 10;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/operacion/formComprobanteFiscalPoliza.cfm?IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep, left+'px', top+'px', window.screen.width*0.6+'px', window.screen.height*0.75+'px');
	}

	function Preparar(LvarXML){
		var left = 430;
		var top = 250;
        var url = "";
		var width=400;
		var height=270;
		var navegacion = "";
		var periodo = document.getElementById("periodo").value;
		if(periodo != '') {
			navegacion = navegacion + "&periodo=" + periodo ;
		}

		var mes = document.getElementById("mes").value;
		if(mes != '') {
			navegacion = navegacion + "&mes=" + mes;
		}

		var chk = document.getElementById("chk").value;
		if(chk != '') {
			navegacion = navegacion + "&chk=" + chk;
		}

		var lote = document.getElementById("lote").value;
		if(lote != '') {
			navegacion = navegacion + "&lote=" + lote;
		}

		var poliza = document.getElementById("poliza").value;
		if(poliza != '') {
			navegacion = navegacion + "&poliza=" + poliza;
		}

		var moneda = document.getElementById("Moneda").value;
		if(moneda != '') {
			navegacion = navegacion + "&moneda=" + moneda;
		}

		var documento = document.getElementById("Documento").value;
		if(documento != '') {
			navegacion = navegacion + "&documento=" + documento;
		}

		var Referencia = document.getElementById("Referencia").value;
		if(Referencia != '') {
			navegacion = navegacion + "&Referencia=" + Referencia;
		}

		var fechaGenIni = document.getElementById("fechaIni").value;
		if(fechaGenIni != '') {
			navegacion = navegacion + "&fechaGenIni=" + fechaGenIni ;
		}

		var fechaGenFin = document.getElementById("fechaFin").value;
		if(fechaGenFin != '') {
			navegacion = navegacion + "&fechaGenFin=" + fechaGenFin;
		}
		var valid = false;
        var varsellodig = document.getElementById("chk_selloDig");
        var sellodig = false;
        if(varsellodig){
            sellodig = varsellodig.checked;
        }
		if(sellodig){
		    	if(document.getElementById('psw_selloDig').value != '' &&
				document.getElementById('key_selloDig').value != '' &&
				document.getElementById('cer_selloDig').value != ''){
					valid = true;}
					else{
						var key_incSelloDigital = document.getElementById("key_selloDig").value;
						var cer_incSelloDigital = document.getElementById("cer_selloDig").value;
						var psw_incSelloDigital = document.getElementById("psw_selloDig");

						if(key_incSelloDigital == ""){
							alert("Favor de seleccionar el archivo llave.");
						} else if((key_incSelloDigital.substring(key_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".key"){
							alert("Favor de seleccionar un archivo llave valido.");
						} else if(cer_incSelloDigital == ""){
							alert("Favor de seleccionar el certificado.");
						} else if((cer_incSelloDigital.substring(cer_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".cer"){
							alert("Favor de seleccionar un certificado valido.");
						} else if(psw_incSelloDigital.value == ""){
							alert("Favor de ingresar la clave.");
							psw_incSelloDigital.focus();
						}}
		}else{
        	valid = true;
        }
        if(valid){
            var pagURL = "";
            <cfoutput>
            <cfif isDefined("form.tr") AND #form.tr# EQ "1">
                pagURL = "SQLGenerarXMLPolizas";
            </cfif>
            <cfif isDefined("form.tr") AND #form.tr# EQ "2">
                pagURL = "SQLGenerarXMLPolizasAuxiliar";
            </cfif>
            </cfoutput>
             if(pagURL != ""){
                url = pagURL + ".cfm?" + navegacion;
                abrirDatosAdicionales(url,"popupAuxFolios.cfm");
            }
        }
	}

	function funcRefrescar(){
		document.location.reload(true);
	}


    //creamos una variable de tipo array para pasar y recuperar los datos


    function abrirDatosAdicionales(varUrl, varPagina){
        var tipoSolicitud = "";
        var numOrden = "";
        var numTramite = "";
        var url = "";
		var datos=new Array();

        datos[0]=document.getElementById("tipoSol").value;
        datos[1]=document.getElementById("NumSol").value;
        datos[2]=document.getElementById("NumTram").value;
        //aqui paso los datos a la ventana hija
        datos=showModalDialog(varPagina,datos,'status:no;resizable:yes;dialogTop:250px;dialogLeft:430px;dialogWidth:400px;dialogHeight:270px;scroll:yes');
        //datos=showModalDialog('popupInfoAdicional.cfm',datos,'unadorned:yes;resizable:1;dialogHeight:270px;dialogwidth:400px;dialogTop:250px;dialogLeft:430px;scroll:no;status=no');
        //aqui recuepero datos de la ventana hija
        document.getElementById("tipoSol").value=datos[0];
        document.getElementById("NumSol").value=datos[1];
        document.getElementById("NumTram").value=datos[2];
        tipoSolicitud = document.getElementById("tipoSol").value;
        numOrden = document.getElementById("NumSol").value;
        numTramite = document.getElementById("NumTram").value;
        // Validacion de datos recuperados
        url = varUrl+"&tipoSolicitud="+tipoSolicitud+"&numOrden="+numOrden+"&numTramite="+numTramite;
        prepararXML(url);
    }
    function prepararXML(varUrl){
        document.filtroDetalle.action = varUrl
        document.filtroDetalle.submit();
    }
</script>

