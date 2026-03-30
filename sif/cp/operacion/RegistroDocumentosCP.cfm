<!---►►Inicializacion de variables◄◄--->
<cf_navegacion name="Fecha">
<cf_navegacion name="datos">
<cf_navegacion name="modo" 			default="ALTA">
<cf_navegacion name="modoDet" 		default="ALTA">
<cf_navegacion name="Transaccion" 	default="">
<cf_navegacion name="Documento" 	default="">
<cf_navegacion name="Usuario" 		default="">
<cf_navegacion name="Moneda" 		default="-1">
<cf_navegacion name="Registros" 	default="20">
<cf_navegacion name="pageNum_lista" default="1">
<cf_navegacion name="IDdocumento"   default="-1">
<cf_navegacion name="Linea"   		default="">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<!---►►Manejo de Modos◄◄--->

<cfif isDefined("Form.NuevoE")>
	<cfset modo    = "ALTA">
    <cfset modoDet = "ALTA">
</cfif>
<cfif isdefined("Form.Nuevo")>
	<cfset modo = "ALTA">
</cfif>
<cfif isdefined("Form.CAMBIO")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif (isDefined("Form.datos") and Form.datos NEQ "")>
	<cfset modo    = "CAMBIO">
    <cfset modoDet = "ALTA">
</cfif>
<cfif modoDet EQ 'ALTA'>
	<cfset form.linea = "">
    <cfset url.linea  = "">
    <cfset linea 	  = "">
</cfif>

<!---►►Paso de Parametros◄◄--->
<cfset params = 'tipo=#LvarTipoMov#'>
<cfif isdefined('form.fecha') 			and len(trim(form.fecha))><cfset params = params & '&fecha=#form.fecha#' ></cfif>
<cfif isdefined('form.transaccion') 	and len(trim(form.transaccion))><cfset params = params & '&transaccion=#form.transaccion#' ></cfif>
<cfif isdefined('form.documento') 		and len(trim(form.documento))><cfset params = params & '&documento=#form.documento#' ></cfif>
<cfif isdefined('form.usuario') 		and len(trim(form.usuario))><cfset params = params & '&usuario=#form.usuario#' ></cfif>
<cfif isdefined('form.moneda') 			and len(trim(form.moneda))><cfset params = params & '&moneda=#form.moneda#' ></cfif>
<cfif isdefined('form.pageNum_lista') 	and len(trim(form.pageNum_lista))><cfset params = params & '&pageNum_lista=#form.pageNum_lista#' ></cfif>
<cfif isdefined('form.registros') 		and len(trim(form.registros))><cfset params = params & '&registros=#form.registros#' ></cfif>

<!---►►Manejo de los ID de Encabezado y Linea, lo nevia ◄◄--->
<cfif not isDefined("Form.NuevoE") and NOT isDefined("Form.btnNuevo") and NOT isdefined('SNNumero')>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
        <cfset arreglo = ListToArray(Form.datos,"|")>
        <cfset IDdocumento = Trim(arreglo[1])>
    <cfelseif IDdocumento EQ -1>
        <cflocation url="#URLira#" addtoken="no">
    </cfif>
</cfif>
<cfif isDefined("Linea") and Len(Trim(Linea)) GT 0 >
	<cfset seleccionado = Linea >
<cfelse>
	<cfset seleccionado = "" >
</cfif>

<!---►►Accion de Aplicar la Factura◄◄--->
<cfif isDefined("Form.btnAplicar")>
    <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
    <cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento))>
        <cfparam name="Form.chk" default="#Form.IDdocumento#">
    </cfif>
	<cfif isDefined("Form.chk")>
        <cfset chequeados = ListToArray(Form.chk)>
        <cfset cuantos = ArrayLen(chequeados)>

		<!---Mismo doc.recurrente en varias facturas --->
        <cfquery name="parametroRec" datasource="#session.DSN#">
            select coalesce(Pvalor, '1') as Pvalor
             from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Pcodigo = 880
        </cfquery>

		<!---►►Se obtienen Periodo/Mes auxiliar--->
        <cfquery name="mes" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo = 60
        </cfquery>
        <cfquery name="periodo" datasource="#session.DSN#">
            select Pvalor
             from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Pcodigo = 50
        </cfquery>
		<cfif len(trim(mes.pvalor)) and len(trim(periodo.pvalor))>
            <cfset fecha = createdate(periodo.pvalor, mes.pvalor , 1) >
            <cfset fechaaplic = createdate( periodo.pvalor, mes.pvalor, DaysInMonth(fecha) ) >
        </cfif>

        <cfloop index="CountVar" from="1" to="#cuantos#">
            <cfset valores = ListToArray(chequeados[CountVar],"|")>
            <!---Valida las garantias, si la factura lo requiere--->
            <cfinvoke component="sif.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion">
                <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
                <cfinvokeargument name="tipo" 	 value="C">
                <cfinvokeargument name="ID"		 value="#valores[1]#">
            </cfinvoke>

			<cfif parametroRec.Pvalor neq 0>
                <cfquery name="recurrente" datasource="#session.DSN#">
                    select IDdocumentorec
                     from EDocumentosCxP
                    where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
                      and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
                </cfquery>
				<cfif len(trim(recurrente.IDdocumentorec))>
                    <cfquery name="rsFechaUltima" datasource="#session.DSN#">
                        select HEDfechaultaplic
                        from HEDocumentosCP
                        where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
                          and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">
                    </cfquery>
					<cfif len(trim(rsFechaUltima.HEDfechaultaplic)) and datecompare(fechaaplic, rsFechaUltima.HEDfechaultaplic) lte 0>
                    	<cfset request.Error.backs = 1 >
<cfset ERR_Docto	= t.Translate('ERR_Docto','El documento no puede ser aplicado, pues ya existe un documento aplicado con el mismo documento recurrente para el mes')>
<cfset ERR_yPer	= t.Translate('ERR_yPer','y período')>
                        <cf_errorCode	code = "50344"
                                        msg  = "#ERR_Docto# @errorDat_1@ #ERR_yPer# @errorDat_2@."
                                        errorDat_1="#month(fechaaplic)#"
                                        errorDat_2="#year(fechaaplic)#"
                        >
                    </cfif>
				</cfif>
			</cfif>
            <cfquery name="rsSQL" datasource="#session.dsn#">
                select
                    a.EDdocumento as Ddocumento,
                    b.DDcantidad,
                    round(b.DDtotallinea * a.EDtipocambio,2)	as TotalLineaUnitLocal,
                    b.DOlinea, a.EDAdquirir
                from EDocumentosCxP a
                    inner join DDocumentosCxP b
                     on b.IDdocumento = a.IDdocumento
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                  and a.IDdocumento = #valores[1]#
                  and b.DDtipo = 'F'
            </cfquery>

			<!---►►Realiza la Aplicación de la factura◄◄>
            <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="PosteoDocumento">
                    <cfinvokeargument name="IDdoc" 		value="#valores[1]#">
                    <cfinvokeargument name="Ecodigo" 	value="#Session.Ecodigo#">
                    <cfinvokeargument name="usuario" 	value="#Session.usuario#">
                    <cfinvokeargument name="debug" 		value="N">
                <cfif LEN(TRIM(rsSQL.EDAdquirir)) and NOT rsSQL.EDAdquirir>
                    <cfinvokeargument name="EntradasEnRecepcion" value="true">
                </cfif>
            </cfinvoke--->

			<!---INTERFAZ --->
            <cfquery name="rsDatos" datasource="#Session.Dsn#">
                select CPTcodigo as CXTcodigo, EDdocumento as Ddocumento, SNcodigo
                from EDocumentosCxP
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
            </cfquery>
            <cfset LobjInterfaz.fnProcesoNuevoSoin(110,"CXTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&SNcodigo=#rsDatos.SNcodigo#&MODULO=CP","R")>

			<!--- modifica la ultima fecha de aplicacion --->
			<cfif parametroRec.Pvalor neq 0 and len(trim(recurrente.IDdocumentorec)) and isdefined("fechaaplic")>
                <cfquery datasource="#session.DSN#">
                    update HEDocumentosCP
                    set HEDfechaultaplic = <cfqueryparam cfsqltype="cf_sql_date" value="#fechaaplic#">
                    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                      and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">
                </cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cflocation addtoken="no" url="#URLira#">
</cfif>
<!---►►Se obtienen cada una de las lineas de la Factura◄◄--->
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif modo NEQ 'ALTA'>
    <cfquery name="rsLineas" datasource="#Session.DSN#">
        select
        c.EOnumero,
        c.EOidorden,
         a.DOlinea,
        a.IDdocumento as IDdocumento,
        a.Linea as Linea,
        a.Aid as Aid,
        a.Cid as Cid,
        a.DDdescripcion,
        a.DDdescalterna,
        a.DDcantidad,
        #LvarOBJ_PrecioU.enSQL_AS("a.DDpreciou")#,
        a.DDdesclinea,
        a.DDporcdesclin,
        a.DDtotallinea,
        a.DDtipo,
        a.Ccuenta as Ccuenta,
        a.Alm_Aid as Alm_Aid,
        a.Dcodigo,
        a.ts_rversion,
        b.DOconsecutivo,
        a.Icodigo,
        coalesce((select CFdescripcion from CFuncional cf where cf.CFid = a.CFid),'-') as  CFdescripcion,
        coalesce((Select cf.CFformato from CFinanciera cf where cf.CFcuenta = a.CFcuenta),(Select cc.Cformato from CContables cc where cc.Ccuenta = a.Ccuenta)) as cuentalista,
        a.DDMontoIeps
        from DDocumentosCxP a
            left outer join DOrdenCM b
                inner join EOrdenCM c
                    on c.EOidorden = b.EOidorden
                on a.DOlinea = b.DOlinea
                and a.Ecodigo = b.Ecodigo
        where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
        order by Linea
    </cfquery>
    <cfquery name="rsTotalLineas" dbtype="query">
        select sum(DDpreciou) as PrecioUnit, sum(DDtotallinea) as TotalLinea
        from rsLineas
    </cfquery>
</cfif>
<!--- Mostrar Cuenta en Detalle --->
<cfquery name="parametroCta" datasource="#session.DSN#">
    select coalesce(Pvalor,'0') as Pvalor
     from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and Pcodigo = 891
</cfquery>

<cfset LB_linea = t.Translate('LB_linea','Línea')>
<cfset LB_descripcion = t.Translate('LB_DESCRIPCION','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_Item = t.Translate('LB_Item','Item')>
<cfset LB_CenFunc = t.Translate('LB_CenFunc','Centro Funcional')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_cantidad = t.Translate('LB_cantidad','Cantidad')>
<cfset LB_Precio = t.Translate('LB_Precio','Precio')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal')>
<cfset LB_OrdenCMLin = t.Translate('LB_OrdenCMLin','OrdenCM-Lin.')>
<cfset LB_Imp = t.Translate('LB_Imp','Imp.')>
<cfset LB_Descuento = t.Translate('LB_Descuento','Descuento')>
<cfset MSG_Borrar = t.Translate('MSG_Borrar','¿Desea borrar esta línea del documento?')>

<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<!---►►Encabezado◄◄--->
            <tr>
            	<td>
                	<cfinclude template="formRegistroDocumentosCP.cfm">
                </td>
            </tr>
            <!---►►Detalle◄◄--->
            <tr>
				<td class="subTitulo">
			      <cfif modo NEQ 'ALTA'>
                    <cfquery name="rsTieneRemision" datasource="#session.dsn#">
                        select count(*) as totalRemisiones from EDocumentosCxP e
                            inner join DDocumentosCxP d
                            on e.IDdocumento = d.IDdocumento
                            left outer join DDocumentosCPR dcpr
                            on dcpr.DFacturalinea = d.Linea
                            where dcpr.DFacturalinea is not null
                            and e.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
                            and e.Ecodigo = #Session.Ecodigo#;
                    </cfquery>

					<form action="<cfoutput>#URLira#</cfoutput>" method="post" name="form2">
                        	<input type="hidden" name="nosubmit" 	id="nosubmit" 		value="false"/>
                        	<input type="hidden" name="datos"  		id="datos" 			value="">
                            <input type="hidden" name="IDdocumento" id="IDdocumento" 	value="">
                            <input type="hidden" name="Linea"  		id="Linea" 			value="">
                            <input type="hidden" name="BorrarD" 	id="BorrarD" 		value="BorrarD">
                            <input type="hidden" name="TipDoc" 		id="TipDoc" 	    value="<cfoutput>#LvarTipDoc#</cfoutput>">
                            <input type="hidden" name="URLira" 		id="URLira" 		value="<cfoutput>#URLira#</cfoutput>">
                            <input type="hidden" name="tipo"    	id="tipo" 			value="<cfoutput>#LvarTipoMov#</cfoutput>">
                        <cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
                            <input name="SNnumero" type="hidden" value="<cfoutput>#form.SNnumero#</cfoutput>">
                        </cfif>
                        <cfif isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))>
                            <input name="SNidentificacion" type="hidden" value="<cfoutput>#form.SNidentificacion#</cfoutput>">
                        </cfif>
                        <cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento))>
                            <input name="IDdocumento" type="hidden" value="<cfoutput>#form.IDdocumento#</cfoutput>">
                        </cfif>

                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        	<cfoutput>
                            <tr bgcolor="E2E2E2" class="subTitulo">
                                <td width="1%">&nbsp;</td>
                                <td width="4%" valign="bottom"><strong>&nbsp;#LB_linea#</strong></td>
                                <td width="4%" valign="bottom"><strong>&nbsp;#LB_Item#</strong></td>
                                <td width="40%" valign="bottom"><strong>&nbsp;#LB_descripcion#</strong></td>
                                <td width="40%" valign="bottom"><strong>&nbsp;#LB_CenFunc#</strong></td>
                                <cfif parametroCta.recordcount GT 0 AND parametroCta.Pvalor NEQ 0>
                                <td width="25%" valign="bottom">#LB_Cuenta#</td>
                                </cfif>
                                <td width="4%" align="center" nowrap><strong>&nbsp;#LB_OrdenCMLin#</strong></td>
                                <td width="4%" align="center" nowrap><strong>&nbsp;#LB_Imp#</strong></td>
                                <td width="13%" valign="bottom"> <div align="right"><strong>#LB_cantidad#</strong></div></td>
                                <td width="13%" valign="bottom"> <div align="right"><strong>#LB_Precio#</strong></div></td>
                                <td width="13%" valign="bottom"><div align="right"><strong>#LB_Descuento#</strong></div></td>
                                <td width="13%" valign="bottom"> <div align="right"><strong>&nbsp;&nbsp;&nbsp;#LB_Subtotal#</strong></div></td>
                                <td width="13%" valign="bottom"> <div align="right"><strong>&nbsp;&nbsp;&nbsp;#LB_IEPS#</strong></div></td>
                                <td width="3%" valign="bottom">&nbsp;</td>
                            </tr>
							</cfoutput>
							<cfoutput query="rsLineas">
                                <tr onClick="<cfif rsTieneRemision.totalRemisiones EQ 0>javascript:Editar('#rsLineas.IDdocumento#|#rsLineas.Linea#');</cfif>"
                                    style="cursor: pointer;"
                                    onMouseOver="javascript: style.color = 'red';"
                                    onMouseOut="javascript: style.color = 'black';"
                                    title="Cuenta: #rsLineas.cuentalista#"

                                    <cfif rsLineas.CurrentRow MOD 2>
                                        class="listaNon"
                                    <cfelse>
                                        class="listaPar"
                                    </cfif>>

                                    <td>&nbsp;
                                        <cfif modoDet NEQ 'ALTA' and rsLineas.Linea EQ seleccionado>
                                            <img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="12" border="0">
                                        </cfif>
                                    </td>

                                    <td align="center">#CurrentRow#</td>
                                    <td align="center">#rsLineas.DDtipo#</td>
                                    <td>#rsLineas.DDdescripcion#</td>
                                    <td>#rsLineas.CFdescripcion#</td>
                                    <cfif parametroCta.recordcount GT 0 AND parametroCta.Pvalor NEQ 0>
                                    <td width="25%" valign="bottom">#rsLineas.cuentalista#</td>
                                    </cfif>
                                    <td align="center"><cfif rsLineas.DOlinea NEQ "">#rsLineas.EOnumero#-#rsLineas.DOconsecutivo#</cfif></td>
                                    <td align="left" nowrap="nowrap">#rsLineas.Icodigo#</td>
                                    <td align="right">#LSCurrencyFormat(rsLineas.DDcantidad,'none')#</td>
                                    <td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsLineas.DDpreciou)#</td>
                                    <td align="right">#LSCurrencyFormat(rsLineas.DDdesclinea,'none')#</td>
                                    <td align="right">#LSCurrencyFormat(rsLineas.DDtotallinea,'none')#</td>
                                    <td align="right">#LSCurrencyFormat(rsLineas.DDMontoIeps,'none')#</td>
                                    <td align="right" width="3%">
                                    <!---►►Se pueden Eliminar las lineas siempre que no venga de un modulo externo 
                                       y no se este en la pantalla de aplicacion de facturas, y que la factura no sea re remisiones--->
                                    <cfif NOT rsDocumento.EDexterno and LvarTipDoc NEQ 'AF' and rsTieneRemision.totalRemisiones EQ 0>
                                        <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"
                                         alt="Eliminar Detalle" onclick="document.form2.nosubmit.value = 'true';borrar('#rsLineas.IDdocumento#','#rsLineas.Linea#'); ">
                                    </cfif>
                                    </td>
                                </tr>
                            </cfoutput>

							<cfif rsLineas.Recordcount GT 0>
                                <tr>
                                    <td colspan="9">&nbsp;</td>
                                    <td><div align="right"><font size="1"><strong><cfoutput>#LB_Subtotal#:</cfoutput></strong></font></div></td>
                                    <td>
                                        <div align="right">
                                            <font size="1">
                                                <strong>
                                                <cfoutput>
                                                    &nbsp;&nbsp;#LSCurrencyFormat(rsTotalLineas.TotalLinea,'none')#
                                                </cfoutput>
                                                </strong>
                                            </font>
                                        </div>
                                    </td>
                                    <td width="3%">&nbsp;</td>
                                </tr>
                            </cfif>
						</table>
						<!--- NAVEGACION --->
                        <cfoutput>
                        <input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
                        <input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
                        <input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
                        <input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
                        <input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
                        <input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
                        <input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
                        </cfoutput>
					</form>
                  </cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">
	function Editar(data) {
		if (data!="" && document.form2.nosubmit.value == "false") {
			document.form2.action=<cfoutput>'#URLira#'</cfoutput>;
			document.form2.datos.value=data;
			document.form2.submit();
		}
		return false;
	}
	//FUNCION PARA BORRAR UN REGISTRO
    <cfoutput>
	function borrar(documento, linea){
		if ( confirm('#MSG_Borrar#') ) {
			document.form2.action 			 = "SQLRegistroDocumentosCP.cfm";
			document.form2.IDdocumento.value = documento;
			document.form2.Linea.value	 	 = linea;
			document.form2.nosubmit.value 	 = 'true';
			document.form2.submit();
		}else
		document.form2.nosubmit.value = 'false';
	}
    </cfoutput>
</script>