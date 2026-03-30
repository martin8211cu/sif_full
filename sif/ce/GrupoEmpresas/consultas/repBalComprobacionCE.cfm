<cfinvoke key="MSG_BalanceComprobacion" default="Balanza de Comprobaci&oacute;n" returnvariable="MSG_BalanceComprobacion" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_SaldoInicial" default="Saldo Inicial" returnvariable="LB_SaldoInicial" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Debitos" default="D&eacute;bitos" returnvariable="LB_Debitos" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_Creditos" default="Cr&eacute;dito" returnvariable="LB_Creditos" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_SaldoFinal" default="Saldo Final" returnvariable="LB_SaldoFinal" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="LB_PrepararXML" default="Preparar XML" returnvariable="LB_PrepararXML" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>
<cfinvoke key="MSG_CierreAuxiliares" default="Aún no se ha realizado el cierre de Auxiliares del mes a preparar, Desea continuar?" returnvariable="MSG_CierreAuxiliares" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacion-rep_CE.xml"/>

<style type="text/css" >
	.corte {
			font-weight:bold;
		   }
	.Datos {
            white-space:nowrap;
			mso-number-format:"\##\,\##\##0\.00";
		   }
</style>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
	select e.Edescripcion
	from Empresas e
	where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfif isdefined('url.idBalCompSAT') and len(#url.idBalCompSAT#) GT 0
	  and not isdefined ('idBalCompSAT')>
  	<cfset idBalCompSAT = #url.idBalCompSAT#>
</cfif>


<cfquery name="rsValidaEstatus" datasource="#session.DSN#">
	SELECT CEBperiodo,CEBmes
	FROM CEBalanzaSAT
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		AND CEBalanzaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalCompSAT#">
		AND CEBestatus >= 1
</cfquery>

<cfif not isdefined('Mes')>
	<cfset Mes = #rsValidaEstatus.CEBmes#>
</cfif>

<cfif not isdefined('Periodo')>
	<cfset Periodo = #rsValidaEstatus.CEBperiodo#>
</cfif>

<!--- Validaciones para saber si el cierre de auxiliares se realizo de acuerdo al mes a preparar--->
<cfquery name="MesCierreA" datasource="#session.DSN#">
	SELECT Pvalor
	FROM Parametros
	WHERE Pcodigo = 60
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="PeriodoCierreA" datasource="#session.DSN#">
	SELECT Pvalor
	FROM Parametros
	WHERE Pcodigo = 50
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
    	<td align="right" width="50%">
        </td>
        <td align="right" width="50%">
        	<table width="100%">
            	<tr>
                	<td width="33.3%">
                    </td>
                    <td width="33.3%" align="right">
                    <cfoutput>
                    	<form name="formXML" action="SQLBalComprobacionCE.cfm" style="margin:0;" method="post" onsubmit="return Confirmar();">
                          <input type="hidden" name = "idBalCompSAT" id="idBalCompSAT" value="#idBalCompSAT#" />
                          <cfif isdefined('rsValidaEstatus') and rsValidaEstatus.RecordCount EQ 0>
                          <input type="submit" name="btnPrepXML" id="btnPrepXML" value="#LB_PrepararXML#"/>
                          </cfif>
                        </form>
                    </cfoutput>
                </td>
                    <td width="33.3%" align="left">
                    	<cf_htmlReportsHeaders irA="BalComprobacionCE.cfm" FileName="Balance_Comprobacion_SAT.xls" title="#MSG_BalanceComprobacion#" param = "&idBalCompSAT=#idBalCompSAT#">
                    </td>
                </tr>
           	</table>
        </td>
    </tr>
</table>

<!---<cf_templatecss>--->
<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
    	<tr>
        	<td width="100%" align="center">
       	  		<table width="100%"  bgcolor="##99CCFF">
                	<tr>
						<td colspan="17" align="center">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>
					<tr>
        				<td style="font-size:16px" colspan="18" align="center">
							<strong>#rsNombreEmpresa.Edescripcion#</strong>
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" colspan="18" align="center">
							<strong>#MSG_BalanceComprobacion#</strong>
						</td>
					</tr>
					<!---<tr>
						<td style="font-size:16px" align="center" colspan="3">
            				<strong>#MSG_Cifras_en# #rsReporte.Moneda#</strong>
            			</td>
					</tr>--->
					<tr>
						<td style="font-size:16px" colspan="18" nowrap="nowrap" align="center">
							<strong>#LB_Mes#:&nbsp;#Mes# &nbsp;&nbsp; #LB_Periodo#:&nbsp;#Periodo#</strong>
						</td>
				    </tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
                </table>
            </td>
        </tr>
        <!---Inicia las Etiquetas--->
        <tr>
        	<td width="100%" align="center">
            	<table width="100%">
                	<tr>
						<td style="font-size:12px" colspan="3">
                        	<strong>#LB_Cuenta#</strong>
                        </td>
                        <td style="font-size:12px" colspan="3">
							<strong>#LB_Descripcion#</strong>
						</td>
                        <td style="font-size:12px" align="right" colspan="3">
							<strong>#LB_SaldoInicial#</strong>
						</td>
                        <td style="font-size:12px" align="right" colspan="3">
							<strong>#LB_Debitos#</strong>
						</td>
                        <td style="font-size:12px" align="right" colspan="3">
							<strong>#LB_Creditos#</strong>
						</td>
                        <td style="font-size:12px" align="right" colspan="3">
							<strong>#LB_SaldoFinal#</strong>
						</td>
                    </tr>
                    <tr><td colspan="18">&nbsp;</td></tr>
					<cfloop query="rsReporte">
					<tr>
						<td mstyle="font-size:14px;" colspan="3" align="left" nowrap>
                        	<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            &nbsp;#rsReporte.formato#
                           <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>	--->
                        </td>
                        <td style="font-size:14px" colspan="3">
							<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            #rsReporte.descrip#
                            <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>	--->
						</td>
                        <td style="font-size:14px" colspan="3" align="right">
							<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            #NumberFormat(rsReporte.saldoini, ",9.00")#
                            <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>	--->
						</td>
                        <td style="font-size:14px" colspan="3" align="right">
							<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            #NumberFormat(rsReporte.debitos, ",9.00")#
                            <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>	--->
						</td>
                        <td style="font-size:14px" colspan="3" align="right">
							<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            #NumberFormat(rsReporte.creditos, ",9.00")#
                            <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>--->
						</td>
                        <td style="font-size:14px" colspan="3" align="right">
							<!---<cfif rsReporte.nivel EQ 0> <strong> </cfif>--->
                            #NumberFormat(rsReporte.saldofin, ",9.00")#
                           <!--- <cfif rsReporte.nivel EQ 0> </strong> </cfif>--->
						</td>

					</tr>
                    </cfloop>
                </table>
            </td>
        </tr>
	</table>


<script type="text/javascript" language="javascript">
	function Confirmar() {
		<cfif isdefined('MesCierreA') and #MesCierreA.Pvalor# EQ #Mes# and isdefined('PeriodoCierreA') and #PeriodoCierreA.Pvalor# EQ #Periodo#>
    		return confirm('#MSG_CierreAuxiliares#');
		<cfelse>
			return true;
		</cfif>
	}
</script>
</cfoutput>