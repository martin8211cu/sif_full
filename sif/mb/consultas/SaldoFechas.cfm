<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo:	Se cambio los dos input de las fechas de inicio y fin por el tag sifcalendario
----------->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloReporte" default="Reporte de Movimientos por rango de Fechas" returnvariable="LB_TituloReporte" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="Banco" returnvariable="LB_Banco" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RangoFechas" default=" Por Rango de Fechas" returnvariable="LB_RangoFechas" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PeriodoMes" default="Por Periodo - Mes" returnvariable="LB_PeriodoMes" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaInicial" default="Fecha Inicial" returnvariable="LB_FechaInicial" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaFinal" default="Fecha Final" returnvariable="LB_FechaFinal" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloHeader" default="Consulta de Saldos por Rango de Fechas" returnvariable="LB_TituloHeader" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_Banco" default="Banco" returnvariable="OBJ_Banco" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_Cuenta" default="Cuenta" returnvariable="OBJ_Cuenta" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_FechaI" default="Fecha Inicial" returnvariable="OBJ_FechaI" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_FechaF" default="Fecha Final" returnvariable="OBJ_FechaF" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" xmlfile="SaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Detallado" default="Detallado" returnvariable="BTN_Detallado" xmlfile="SaldoFechas.xml"/>

<!--- Filtro de Validacion para utilizar el reporte en TCE o en Bancos --->
<cfset LvarTitulo = "#LB_TituloReporte#">
<cfset LvarSQLSaldoFechas = "SQLSaldoFechas.cfm">
<cfset LvarConlisCuentasBancarias = "/cfmx/sif/mb/operacion/ConlisCuentasBancarias.cfm">
<cfset LbelCuenta = "#LB_Cuenta#:">
<cfset LbelTituloHeader= "#LB_TituloHeader#">
<cfset LvarCBesTCE = 0>

<cfif isdefined("LvarSaldosFechasTCE")>
	<cfset LvarCBesTCE = 1>
    <cfset LvarSQLSaldoFechas = "../../tce/consultas/SQLSaldoFechasTCEUsuario.cfm">
    <cfset LvarConlisCuentasBancarias = "/cfmx/sif/tce/operaciones/ConlisCuentasBancariasTCE.cfm">
    <cfset LvarTitulo = "Reporte de Movimientos de TCE">
    <cfset LbelCuenta = "Tarjeta de Cr&eacute;dito:">
    <cfset LbelTituloHeader= "Consulta de Saldos de TCE">
    <cfif isdefined("RepUsuario")>
    	<cfset FiltroxUsuario = 1>
    </cfif>
</cfif>

<cfset modo = 'ALTA'>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="bancos" datasource="#Session.DSN#">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = #Session.Ecodigo#
	order by Bdescripcion
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsEstadoCuenta" datasource="#Session.DSN#">
		select ECid, Bid, ECfecha, CBid,
			ECsaldoini, ECsaldofin, ECdescripcion, ECusuario,
			ECdesde, EChasta, ECdebitos, ECcreditos,
			ECaplicado, EChistorico, ECselect, ts_rversion
		from ECuentaBancaria
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	</cfquery>
	<cfif isdefined("rsEstadoCuenta") and rsEstadoCuenta.recordcount eq 1 and len(trim(rsEstadoCuenta.Bid))>
		<cfset form.Bid = " ">
		<cfset form.Bid = rsEstadoCuenta.Bid>
	</cfif>

	<!--- <cfdump var="#rsEstadoCuenta#"> --->
	<cfquery name="rsDescripciones" datasource="#Session.DSN#">
		select a.CBdescripcion, b.Mnombre, a.Mcodigo, case when a.Mcodigo !=1 then 0.0000 else 1.0000 end as TipoCambio
		<!--- , a.EIid as EIidCB, c.EIid as EIidB--->
		from CuentasBancos a, Monedas b, Bancos c
		where a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
        and a.CBesTCE = <cfqueryparam value="#LvarCBesTCE#" cfsqltype="cf_sql_bit">
		and a.Bid = c.Bid
		and a.Mcodigo = b.Mcodigo
	</cfquery>
</cfif>
<cf_templateheader title="#LbelTituloHeader#">
	<cfinclude  template="../../portlets/pNavegacionMB.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>
					<script language="JavaScript1.2" type="text/javascript" src="../../js/calendar.js"></script>						<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
					<script language="JavaScript" type="text/JavaScript">
						<!--
						function MM_preloadImages() { //v3.0
						  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
							var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
							if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
						}

						function MM_swapImage() { //v3.0
						  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
						   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
						}
						//-->
					</script>

					<script language="JavaScript1.2" type="text/javascript">
						// ==================================================================================================
						// 								Usadas para conlis de fecha
						// ==================================================================================================
						function MM_findObj(n, d) { //v4.01
						  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
							d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
						  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
						  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
						  if(!x && d.getElementById) x=d.getElementById(n); return x;
						}

						function MM_swapImgRestore() { //v3.0
						  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
						}

						// ==================================================================================================
						// ==================================================================================================

					</script>
                    <!---  En Bancos »»SQLSaldoFechas.cfm ««en TCE  »»SQLSaldoFechasTCE.cfm««--->
		  			<form action="<cfoutput>#LvarSQLSaldoFechas#</cfoutput>" name="form1" method="post">
						<input type="hidden" name="ECid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.ECid#</cfoutput></cfif>">
						<input type="hidden" name="CBid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.CBid#</cfoutput></cfif>">
						<input type="hidden" name="monedaLocal" value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>">
						<input type="hidden" name="Mcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.Mcodigo#</cfoutput></cfif>">
						<input type="hidden" name="Mnombre" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.Mnombre#</cfoutput></cfif>">
						<input type="hidden" name="ECtipocambio" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.ECtipocambio#</cfoutput></cfif>">
						<table border="0" cellpadding="2" cellspacing="0" width="69%" align="center">
							<tr><td colspan="5">&nbsp;</td></tr>
							<tr>
								<td align="right" rowspan><strong><cfoutput>#LB_Banco#</cfoutput>:&nbsp;</strong></td>
								<td align="left" rowspan colspan="4">
									<select name="Bid" onchange="return limpiarCuenta();">
										<cfoutput query="bancos">
											<option value="#bancos.Bid#">#bancos.Bdescripcion#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr>
								<td align="right" rowspan><strong><cfoutput>#LbelCuenta#</cfoutput>&nbsp;</strong></td>
								<td align="left" rowspan colspan="4">
									<cfif modo NEQ "ALTA">
										<cfoutput>&nbsp;#rsDescripciones.CBdescripcion#</cfoutput>
										<input name="CBdescripcion" type="hidden" value="<cfoutput>#rsDescripciones.CBdescripcion#</cfoutput>">
									<cfelse>
										<input name="CBdescripcion" readonly type="text" size="40" maxlength="80"
										value="<!--- <cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.CBdescripcion#</cfoutput></cfif> --->">
										<a href="#">
											<img src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0"
												align="absmiddle" onClick="javascript:doConlis();">
										</a>
									</cfif>
								</td>
							</tr>
                            <cfif isdefined("LvarSaldosFechasTCE") and LvarCBesTCE eq 1>
                                <tr>
                                    <td colspan="5" align="center">
                                        <input type="radio" id="TipoRango1" name="TipoRango" checked="checked" onclick="javascript:CambioRango();"/>
                                         <cfoutput>#LB_RangoFechas#</cfoutput>
                                        <input type="radio" id="TipoRango2" name="TipoRango" onclick="javascript:CambioRango();"/>
                                         <cfoutput>#LB_PeriodoMes#</cfoutput>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
                                            <tr id="RFecha" style="display:true;">
                                                <td align="right" nowrap><strong><cfoutput>#LB_FechaInicial#</cfoutput></strong>&nbsp;</td>
                                                <td width="20%">
                                                    <cf_sifcalendario name="fechai" form= "form1">
                                                </td>
                                                <td align="left" nowrap width="15%"><strong><cfoutput>#LB_FechaFinal#</cfoutput>:</strong>&nbsp;</td>
                                                <td>
                                                    <cf_sifcalendario name="fechaf" form="form1">
                                                </td>
                                                <input type="hidden" name="RangoF" value="RangoF" />
                                            </tr>

                                            <tr id="RPeriodo" style="display:none;">
                                                <td align="right" colspan="2"><strong><cfoutput>#LB_Periodo#</cfoutput>:</strong>
                                                	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
                                                        select distinct Speriodo
                                                        from CGPeriodosProcesados
                                                        where Ecodigo = #session.Ecodigo#
                                                        order by Speriodo desc
                                                    </cfquery>

                                                    <select name="Periodo" id="Periodo">
                                                    <cfloop query = "rsPeriodos">
                                                        <option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>
                                                    </cfloop>
                                                    </select>
                                                </td>
                                                <td align="left" colspan="2"><strong><cfoutput>#LB_Mes#</cfoutput>:</strong>
                                                    <select name="Mes" id="Mes">
                                                        <option value="1">Enero</option>
                                                        <option value="2">Febrero</option>
                                                        <option value="3">Marzo</option>
                                                        <option value="4">Abril</option>
                                                        <option value="5">Mayo</option>
                                                        <option value="6">Junio</option>
                                                        <option value="7">Julio</option>
                                                        <option value="8">Agosto</option>
                                                        <option value="9">Septiembre</option>
                                                        <option value="10">Octubre</option>
                                                        <option value="11">Noviembre</option>
                                                        <option value="12">Diciembre</option>
                                                    </select>
                                                </td>
                                                <input type="hidden" name="RangoP" value="" />
                                            </tr>
                                        </table>
                                    </td>
                                </tr>

                                <tr><td colspan="5">&nbsp;</td></tr>
                                <tr>
                                    <td width="43%" colspan="5" align="center">
                                        <input type="submit" name="btnConsultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
                                    </td>
                                </tr>
                            <cfelse>
                            	<tr>
                                    <td width="25%" align="right" nowrap><strong><cfoutput>#LB_FechaInicial#</cfoutput>:</strong>&nbsp;</td>
                                    <td width="5%">
                                        <cf_sifcalendario name="fechai" form= "form1">
                                    </td>
                                    <td width="22%" align="right" nowrap><strong><cfoutput>#LB_FechaFinal#</cfoutput>:</strong>&nbsp;</td>
                                    <td width="5%">
                                        <cf_sifcalendario name="fechaf" form="form1">
                                    </td>
                                    <td width="43%" colspan="4" align="center">
                                        <input type="submit" name="btnConsultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
                                    </td>
                                </tr>
                            </cfif>

							<tr>
								<cfoutput>
									<td align="right"><strong>#BTN_Detallado#:&nbsp;</strong></td>
									<td colspan="4">
										<input type="checkbox" name="chkDetallado" value="1" tabindex="5">
									</td>
								</cfoutput>
							</tr>

							<tr><td colspan="5">&nbsp;</td></tr>
						</table>
					</form>
		            <cf_web_portlet_end>
	<cf_templatefooter>
<cf_qforms>
<script type="text/javascript" language="javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		<!---  En Bancos  »»ConlisCuentasBancarias.cfm«« en TCE »»ConlisCuentasBancarias.cfm««--->
		<cfoutput>
			var filtro = 0;
			<cfif isdefined("FiltroxUsuario")>
				filtro = 1;
			</cfif>
			popUpWindow("#LvarConlisCuentasBancarias#?form=form1&id=CBid&desc=CBdescripcion&Bid="+document.form1.Bid.value+"&monedaLocal="+document.form1.monedaLocal.value+"&filtro="+filtro+"&excluye=false",250,200,600,400);
		</cfoutput>
	}

	function limpiarCuenta() {
		document.form1.CBid.value = "";
		document.form1.Mnombre.value = "";
		document.form1.CBdescripcion.value = "";
		document.form1.Mcodigo.value = "";
		document.form1.ECtipocambio.value = "0.0000";
		return true;
		//document.getElementById("MonedaLabel").style.visibility = "hidden";
	}
<cfoutput>
		objForm.Bid.required = true;
		objForm.Bid.description = "#OBJ_Banco#";
		objForm.CBdescripcion.required = true;
		objForm.CBdescripcion.description = "#OBJ_Cuenta#";
		objForm.fechai.required = true;
		objForm.fechai.description = "#OBJ_FechaI#";
		objForm.fechaf.required = true;
		objForm.fechaf.description = "#OBJ_FechaF#";

		objForm.Mes.description = "#LB_Mes#";
		objForm.Periodo.description = "#LB_Periodo#";
</cfoutput>
	function CambioRango(){
		if(document.getElementById('TipoRango1').checked){
			document.getElementById('RFecha').style.display='';
			document.getElementById('RPeriodo').style.display='none';
			document.form1.RangoF.value = "RangoF";
			document.form1.RangoP.value = "";
			objForm.fechai.required = true;
			objForm.fechaf.required = true;
			objForm.Mes.required = false;
			objForm.Periodo.required = false;
		}
		else {
			document.getElementById('RPeriodo').style.display='';
			document.getElementById('RFecha').style.display='none';
			document.form1.RangoF.value = "";
			document.form1.RangoP.value = "RangoP"
			objForm.Mes.required = true;
			objForm.Periodo.required = true;
			objForm.fechai.required = false;
			objForm.fechaf.required = false;
		}
	}
</script>