<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 13-06-2013.
	Reporte Estado del Ejercicio del Presupuesto de Egresos por Capítulos del Gasto
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Consultar = t.Translate('BTN_Consultar','Consultar','/sif/generales.xml')>
<cfset BTN_Limpiar = t.Translate('BTN_Limpiar','Limpiar','/sif/generales.xml')>

<cfinvoke key="MSG_Saldos_Finales_Cero"	default="Mostrar movimientos en cero"	returnvariable="MSG_Saldos_Finales_Cero"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="Lvartitulo"	default="Estado del Ejercicio del Presupuesto de Egresos por Capítulos del Gasto"	returnvariable="Lvartitulo"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_PeríodoPresupuestario"	default='Periodo Presupuestario' 	returnvariable="LB_PeríodoPresupuestario"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml" />
<cfinvoke key="LBMesdepresupuesto"	default='Mes de presupuesto' 				returnvariable="LBMesdepresupuesto"			component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_MensualAcumulado"	default='Mensual Acumulado' 				returnvariable="LB_MensualAcumulado"		component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Formato"		default='Formato' 				returnvariable="LB_Formato"			component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Presentacion"	default='Presentaci&oacute;n' 	returnvariable="LB_Presentacion"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Mensual"		default='Mensual' 	returnvariable="LB_Mensual"		component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Acumulado"	default='Acumulado' returnvariable="LB_Acumulado"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Unidades"	default='Unidades' 		returnvariable="LB_Unidades"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Miles"	default='Miles' 		returnvariable="LB_Miles"		component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Millones"	default='Millones' 		returnvariable="LB_Millones"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>
<cfinvoke key="LB_Detallado"	default='Detallado' returnvariable="LB_Detallado"	component="sif.Componentes.Translate" method="Translate" XmlFile="EAnalIngrRT.xml"/>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfinclude template="../../cg/consultas/Funciones.cfm">

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
    select CPPid
    from CPresupuestoPeriodo p
    where p.Ecodigo = #Session.Ecodigo#
      and p.CPPestado <> 0
    order by CPPid DESC
</cfquery>

<cfparam name="form.CPPid"	default="#rsPeriodos.CPPid#">
<cfset session.CPPid = form.CPPid>

<cfquery name="rsMeses" datasource="#session.dsn#">
    select a.CPCano, a.CPCmes,
            <cf_dbfunction name="to_char" datasource="sifControl" args="a.CPCano"> #_Cat# ' - ' #_Cat#
            case a.CPCmes
                when 1 then 'Enero'
                when 2 then 'Febrero'
                when 3 then 'Marzo'
                when 4 then 'Abril'
                when 5 then 'Mayo'
                when 6 then 'Junio'
                when 7 then 'Julio'
                when 8 then 'Agosto'
                when 9 then 'Septiembre'
                when 10 then 'Octubre'
                when 11 then 'Noviembre'
                when 12 then 'Diciembre'
            end as descripcion
      from CPmeses a
     where a.Ecodigo = #session.ecodigo#
       and a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
     order by a.CPCano, a.CPCmes
</cfquery>

<cf_templateheader title="#Lvartitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<form name="form1" method="post" action="EEPrEgrTCapGst-SQL.cfm" style="margin:0; " onsubmit="return sinbotones()">
        
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td nowrap align="right">
                    <cfoutput>#LB_PeríodoPresupuestario#:&nbsp;</cfoutput>
                </td>
                <td colspan="3">
                <cf_cboCPPid value="#session.CPPid#" onChange="this.form.action='';this.form.submit();" CPPestado="1,2">
                </td>
                <td nowrap align="right">
                    <cfoutput>#LBMesdepresupuesto#:&nbsp;</cfoutput>
                </td>
                <td>
                    <cfparam name="form.CPCanoMes" default="0">
                    <select name="CPCanoMes">
                        <cfoutput query="rsMeses">
                            <option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif form.CPCanoMes mod 100 EQ rsMeses.CPCmes>selected</cfif>>#rsMeses.descripcion#</option>
                        </cfoutput>
                    </select>
                </td>
			    <td nowrap><div align="right"><cfoutput>#LB_MensualAcumulado#:&nbsp;</cfoutput></div></td>
			    <td> 
                	<cfoutput>
                    <select name="mensAcum" size="1" tabindex="4">
                      <option value="1">#LB_Mensual#</option>
                      <option value="2">#LB_Acumulado#</option>
                    </select>
                    </cfoutput>
			    </td>
            </tr>
			<tr> 
              <td align="right" nowrap><div align="right"><cfoutput>#LB_Formato#:&nbsp;</cfoutput></div></td>
			  <td>
				<select name="formato" tabindex="9">
					<!---<option value="FlashPaper">FlashPaper</option>--->
					<option value="HTML">HTML</option>
					<option value="PDF">PDF</option>
				  </select>
			  </td>
              <td align="right" nowrap><cfoutput> #MSG_Saldos_Finales_Cero#</cfoutput></td>
			  <td nowrap>
              	<div align="left">
					<input type="checkbox" name="chkCeros" value="1" tabindex="10">
			  	</div>
              </td>
              <td align="right" nowrap><div align="right"><cfoutput>#LB_Presentacion#</cfoutput>:&nbsp;</div></td>
			  <td>
              	<cfoutput>
				<select name="Unidad" tabindex="15">
					<option value="1">#LB_Unidades#</option>
					<option value="2">#LB_Miles#</option>
					<option value="3">#LB_Millones#</option>
				 </select>
                 </cfoutput> 
			  </td>
<!---              <td align="right" nowrap><cfoutput>#LB_Detallado#</cfoutput>:&nbsp;</td>
			  <td nowrap>
              	<div align="left">
					<input type="checkbox" name="chkDetalle" value="1" tabindex="10">
			  	</div>
              </td>
--->			
			<tr> 
			  <td colspan="6"> 
				<div align="center">
                	<cfif isdefined('url.rsMensaje')> 
                    	<strong><cfoutput>#url.rsMensaje#</cfoutput></strong>                    
                    <cfelse>
				  		<input type="submit" name="Submit" value="Consultar" tabindex="16">&nbsp;
                        <input type="Reset" name="Limpiar" value="Limpiar" tabindex="17">                    
                    </cfif>
				</div>
			  </td>
			</tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
