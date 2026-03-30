
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteResumenFirmasDePlanilla"
	Default="Reporte para Firmas de Planilla"
	returnvariable="LB_ReporteResumenFirmasDePlanilla"/>


<cfset t = createObject("component","sif.Componentes.Translate")> 
<cfset LB_Cuenta= t.translate('LB_Cuenta','Cuenta','/rh/generales.xml')/> 

<cfset LvarFileName = "ReporteFirmasPlanilla_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
 
<cf_htmlReportsHeaders title="#LB_ReporteResumenFirmasDePlanilla#" filename="#LvarFileName#" irA="ReporteFirmasPlanilla.cfm">
<cf_templatecss/>
 
<cf_HeadReport 
	Titulo="#LB_ReporteResumenFirmasDePlanilla#" 
    addTitulo1="#LB_Corp#"
	filtro1 = "#filtro1#"
    filtro2 = "#filtro2#"
    showEmpresa="false" 
	showline="false">
 
	<table>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <cfoutput>
	  <tr>
	  	<td nowrap="nowrap"  align="right">#rsReporte.concuenta#</td>
	  	<td><cf_translate key="LB_DEPOSITOSENCUENTAAHORROBNCR">DEPOSITOS EN CUENTA AHORRO BNCR</cf_translate></td>
	    <td align="right"><cf_locale name="number" value ="#rsReporte.concuentamonto#"/></td>
	    <td></td>
      </tr>

	  <tr>
	  	<td nowrap="nowrap"  align="right">#rsReporte.sincuenta#</td>
	  	<td><cf_translate key="LB_DEPOSITOSENCUENTACORRIENTEBNCR">DEPOSITOS EN CUENTA CORRIENTE BNCR</cf_translate></td>
	    <td align="right"><cf_locale name="number" value ="#rsReporte.sincuentamonto#"/></td>
	    <td></td>
      </tr>
      <cfset subtotal=rsReporte.concuentamonto+rsReporte.sincuentamonto>
	 
	  <cfset totaltranf=subtotal>
      <tr>
	  	<td nowrap="nowrap"></td>
	  	<td><cf_translate key="LB_TOTALDELATRANSFERENCIA">TOTAL DE LA TRANSFERENCIA</cf_translate></td>
	    <td></td>
	    <td align="right"><cf_locale name="number" value ="#totaltranf#"/></td>
      </tr>

	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>

	  <tr>
	  	<td  align="right" nowrap="nowrap">#rsReporte.totalcheque#</td>
	  	<td><cf_translate key="LB_PAGOSPORCHEQUESBNCR">PAGOS POR CHEQUES BNCR</cf_translate></td>
	    <td align="right"><cf_locale name="number" value ="#rsReporte.chequemonto#"/></td>
	    <td></td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <cfset totalRetenciones=0>
      <cfloop query="rsDeducciones">
      	<cfset totalRetenciones+=monto>
      	<tr>
		  	<td></td>
		  	<td>#TDcodigo# - #TDdescripcion#</td>
		    <td align="right" nowrap="nowrap"><cf_locale name="number" value ="#monto#"/></td>
		    <td></td>
	    </tr>
      </cfloop>

	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
 	
	  <tr>
	  	<td></td>
	  	<td><cf_translate key="LB_RETENCIONESAPAGAR_CUENTACOLONES">RETENCIONES A PAGAR (CUENTA COLONES)</cf_translate></td>
	    <td></td>
	    <td align="right"><cf_locale name="number" value ="#totalRetenciones#"/></td>
      </tr>

	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>

	  <tr>
	  	<td></td>
	  	<td><cf_translate key="LB_TOTALPLANILLAAPAGAR">TOTAL PLANILLA A PAGAR</cf_translate></td>
	    <td></td>
	    <td align="right"><cf_locale name="number" value ="#totaltranf+totalRetenciones#"/></td>
      </tr>
     </table>
     <table>
      <!--------- firmas---------->
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td nowrap="nowrap"><cf_translate key="LB_Elaboradopor">Elaborado por</cf_translate>:</td>
	  	<td>___________________________________</td>
        <td nowrap="nowrap">&nbsp;&nbsp;<cf_translate key="LB_PorDivisionGestTalHuman">Por la División Gestión Talento Humano</cf_translate>: </td>
	    <td>___________________________________</td>
	  </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td nowrap="nowrap"><cf_translate key="LB_Revisadopor">Revisado por</cf_translate>:</td>
	  	<td>___________________________________</td>
	    <td nowrap="nowrap">&nbsp;&nbsp;<cf_translate key="LB_PorDivisionGestFinanc">Por la División Gestión Financiera</cf_translate>: </td>
	    <td>___________________________________</td>
      </tr> 
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td><cf_translate key="LB_Tesoreria">Tesorería</cf_translate>:</td>
	  	<td>___________________________________</td>
	    <td>&nbsp;&nbsp;<cf_translate key="LB_PorSecretariadeServCorp">Por la Secretaría de Servicios Corporativos</cf_translate>: </td>
	    <td>___________________________________</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
      <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td colspan="4">&nbsp;</td>
      </tr>
	  <tr>
	  	<td nowrap="nowrap">&nbsp;</td>
	  	<td>&nbsp;</td>
	    <td nowrap="nowrap">&nbsp;&nbsp;<cf_translate key="LB_PorRepresentante">Por Representante</cf_translate>: </td>
	    <td>___________________________________</td>
      </tr> 
      </cfoutput>
  </table>
 
