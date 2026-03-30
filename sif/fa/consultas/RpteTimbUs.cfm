<cfinvoke key="MSG_Periodo" 			default="Periodo Inicio"					returnvariable="MSG_Periodo"				component="sif.Componentes.Translate" method="Translate" xmlfile="RpteTimbUs.xml"/>
<cfinvoke key="MSG_Periodo2" 			default="Periodo Fin"					    returnvariable="MSG_Periodo2"				component="sif.Componentes.Translate" method="Translate" xmlfile="RpteTimbUs.xml"/>
<cfinvoke key="BTN_Consultar" 			default="Consultar"							returnvariable="BTN_Consultar"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpiar" 			default="Limpiar"							returnvariable="BTN_Limpiar"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_ReporteTimUS"			default="Reporte de Timbres Usados"			returnvariable="LB_ReporteTimUS"			component="sif.Componentes.Translate" method="Translate" xmlfile="RpteTimbUs.xml"/>
<cfinvoke key="LB_Emp"					default="Empresa"							returnvariable="LB_Emp"						component="sif.Componentes.Translate" method="Translate" xmlfile="RpteTimbUs.xml"/>
<cfinvoke key="LB_TUsd"					default="Timbres Usados"					returnvariable="LB_TUsd"					component="sif.Componentes.Translate" method="Translate" xmlfile="RpteTimbUs.xml"/>

<cfinclude template="Funciones.cfm">
<cfset modo = "ConsultaI">
<cfset Lvartitulo = '#LB_ReporteTimUS#'>
<!--- Variables --->

<cfset Bases = 0>
<cfset fecha1 = "">
<cfset fecha2 = "">
<cfset fechaaux = LSDateFormat(Now(),'dd/mm/yyyy')>


<!--- Consulta de Recibos de Nomina --->
<cftry>
		<cfquery name="rsTimbres2" datasource="#session.DSN#">
			select e.Edescripcion as Empresa ,COUNT(rn.timbre) TimbresUsados from RH_CFDI_RecibosNomina rn
			inner join Empresas e on rn.Ecodigo=e.Ecodigo
			where timbre <>''
			group by e.Edescripcion
		</cfquery>

		<cfif rsTimbres2.recordCount gt 0>
			<cfset Bases = 1>
		</cfif>

	<cfcatch type = "Database">
		<cfset Bases = 0>
	</cfcatch>
</cftry>

<!--- Consulta de Factura --->
<cftry>
	<cfquery name="rsTimbres" datasource="FacturaElectronica">
		select  ce.NombreEmisor as Empresa, COUNT(fe.idEmisor) as TimbresUsados from db_FacturaEmitida fe
		inner join db_ctlogEmisor ce on fe.idEmisor=ce.idEmisor
		where timbre <>''
		group by ce.NombreEmisor
	</cfquery>

	<cfif rsTimbres.recordCount gt 0>
		<cfif Bases eq 1>
			<cfset Bases = 3>
	
		<cfelse>
			<cfset Bases = 2>
		</cfif>
	</cfif>

		<cfcatch type = "Database">

		</cfcatch>
</cftry>




<!--- Consulta de Facturas Emitidas por filto de Fechas --->
<cfif Bases gt 1>
	<cfif isdefined("url.fecha1") and #url.fecha1# neq "" and isdefined("url.fecha2") and #url.fecha2# neq "" and rsTimbres.recordCount gt 0>
		<cfset modo = "ConsultaD">
		<cfset fecha1 = #DateFormat(url.fecha1, 'dd/mm/yyyy')#>
	    <cfset fecha2 = #DateFormat(url.fecha2, 'dd/mm/yyyy')#>

		<cfquery name="rsTimbres" datasource="FacturaElectronica">
			select  ce.NombreEmisor as Empresa, COUNT(fe.idEmisor) as TimbresUsados from db_FacturaEmitida fe
			inner join db_ctlogEmisor ce on fe.idEmisor=ce.idEmisor
			where timbre <>'' and fechaTimbrado between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha1#">
			and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha2#">
			group by ce.NombreEmisor
		</cfquery>

			<!--- Validamos si hay datos --->
			<cfif rsTimbres.recordCount eq 0>
				<cfif Bases eq 3>
					<cfset Bases = 1>
				<cfelse>
					<cfset Bases = 0>
				</cfif>
			</cfif><!--- Fin de la validacion de datos --->

		 <cfset fecha1A = #url.fecha1#>
		 <cfset fecha2A = #url.fecha2#>
	</cfif>
</cfif>


<!--- Consulta por fechas de Recibos de Nomina --->
<cfif Bases gt 2 || Bases eq 1>
	<cfif isdefined("url.fecha1") and #url.fecha1# neq "" and isdefined("url.fecha2") and #url.fecha2# neq "" and rsTimbres2.recordCount gt 0>
		<cfset modo = "ConsultaD">
		<cfset fecha1 = #DateFormat(url.fecha1, 'dd/mm/yyyy')#>
	    <cfset fecha2 = #DateFormat(url.fecha2, 'dd/mm/yyyy')#>

		<cfquery name="rsTimbres2" datasource="#session.DSN#">
			select e.Edescripcion as Empresa ,COUNT(rn.timbre) TimbresUsados from RH_CFDI_RecibosNomina rn
			inner join Empresas e on rn.Ecodigo=e.Ecodigo
			where timbre <>'' and fechaTimbrado between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha1#">
			and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha2#">
			group by e.Edescripcion
		</cfquery>

			 <cfif rsTimbres2.recordCount eq 0>
				<cfif Bases eq 3>
				   <cfset Bases = 2>
				<cfelse>
				   <cfset Bases = 0>
				</cfif>
			 </cfif>

		 <cfset fecha1A = #url.fecha1#>
		 <cfset fecha2A = #url.fecha2#>

	</cfif>
</cfif>

<!--- Exportacion de la Tabla en Excel --->
<!--- Exportacion Facturacion E. --->
<cfif Bases gt 1>
	<cfif isdefined("url.btnexportar")>
		<cfquery name="rsTimbresT" datasource="FacturaElectronica">
		   <cfset fecha1A = #DateFormat(url.fecha1, 'yyyy-mm-dd')#>
		   <cfset fecha2A = #DateFormat(url.fecha2, 'yyyy-mm-dd')#>

			select  ce.NombreEmisor as Empresa, COUNT(fe.idEmisor) as TimbresUsados from db_FacturaEmitida fe
			inner join db_ctlogEmisor ce on fe.idEmisor=ce.idEmisor
			where timbre <>''
			<cfif isdefined("url.fecha1") and #url.fecha1# neq "" and isdefined("url.fecha2") and #url.fecha2# neq "">
				and fechaTimbrado between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha1A#">
				and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha2A#">
			</cfif>
			group by ce.NombreEmisor
		</cfquery>

		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Tabla Timbrados Consumidos"
		returnvariable="LB_Archivo" xmlfile = "RpteTimbUs.xml"/>
		<cf_exportQueryToFile query="#rsTimbresT#" filename="#LB_Archivo##session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
	</cfif>
</cfif>

<!--- Exportacion Recibos de Nomina --->
<cfif Bases gt 2 || Bases eq 1>
	<cfif isdefined("url.btnexportar")>
		<cfquery name="rsTimbresT2" datasource="#session.DSN#">
			<cfset fecha1A = #DateFormat(url.fecha1, 'yyyy-mm-dd')#>
			<cfset fecha2A = #DateFormat(url.fecha2, 'yyyy-mm-dd')#>

			select e.Edescripcion as Empresa ,COUNT(rn.timbre) TimbresUsados from RH_CFDI_RecibosNomina rn
			inner join Empresas e on rn.Ecodigo=e.Ecodigo
			where timbre <>''
			<cfif isdefined("url.fecha1") and #url.fecha1# neq "" and isdefined("url.fecha2") and #url.fecha2# neq "">
				and fechaTimbrado between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha1A#">
				and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#fecha2A#">
			</cfif>
			group by e.Edescripcion
		</cfquery>

		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Tabla Timbrados Consumidos"
		returnvariable="LB_Archivo" xmlfile = "RpteTimbUs.xml"/>
		<cf_exportQueryToFile query="#rsTimbresT2#" filename="#LB_Archivo##session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
	</cfif>
</cfif>



<cf_templateheader title="#Lvartitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">

		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<form name="form1" method="get" action="RpteTimbUs.cfm" style="margin:0; " onsubmit="return ValidaFechas();">



			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			 <tr>

			  <td nowrap><div align="right"><cfoutput>#MSG_Periodo#</cfoutput>:&nbsp;</div></td>
			  <td>
				  <cf_sifcalendario name="Fecha1" value="#fecha1#" tabindex="3">
			  </td>

 			  <td nowrap><div align="right"><cfoutput>#MSG_Periodo2#</cfoutput>:&nbsp;</div></td>
			  <td>

				 <cf_sifcalendario name="Fecha2" value="#fecha2#" tabindex="3">
			  </td>
			</tr>

			<tr>
			  <td align="right" nowrap>&nbsp;</td>
			  <td nowrap>&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="5">
				<div align="center">
				<cfoutput>
				  <input type="submit" name="Consultar"  value="#BTN_Consultar#" tabindex="16" class="btnNormal">&nbsp;
				  <input name="btnExportar" class="btnNuevo"  tabindex="1" type="submit" value="Exportar" onsubmit="return ValidaFechas();">
				</cfoutput>
				</div>
			  </td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			</table>

<!--- Tabla 1 --->
<cfif Bases gt 1 and rsTimbres.recordCount gt 0>
	<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">
    	  <tr>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="20%"></div><cfoutput>
			    <div align="center"><strong>#LB_TUsd# por Facturacion Electronica&nbsp;<cfif modo eq "ConsultaD"> del &nbsp;#fecha1#&nbsp; al &nbsp;#fecha2#<cfelse>al #fechaaux# </cfif></strong></div>
            </cfoutput>
			</td>

	</table>


	<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">
    	  <tr>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="20%"></div><cfoutput>
			      <div align="center"><strong>#LB_Emp#</strong></div>
            </cfoutput></td>

            <td class="tituloListas cfmenu_submenu" align="center" width="9%"></div><cfoutput>
			      <div align="center"><strong>#LB_TUsd#</strong></div>
            </cfoutput></td>
          </tr>
	</table>

	<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">

	<cfset colores = "1">

    <cfloop query="rsTimbres">
		<tr class="trh">
			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif>  width="20%" align="left"><cfoutput>
			      <div align="left">#rsTimbres.Empresa#</div>
            </cfoutput></td>
            <td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="9%" align="center"><cfoutput>
			      <div align="center">#rsTimbres.TimbresUsados#</div>
            </cfoutput></td>

	<cfif colores eq "1">
	  <cfset colores = "2">
	<cfelse>
		<cfset colores = "1">
	</cfif>
	</tr></cfloop>


		
	</table>
</cfif>

<!--- Tabla 2 --->
<cfif Bases gt 2 || Bases eq 1 and rsTimbres2.recordCount gt 0>

<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">
    	  <tr>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="20%"></div><cfoutput>
			      <div align="center"><strong>#LB_TUsd# por Recibos de Nomina&nbsp;<cfif modo eq "ConsultaD">&nbsp; del &nbsp;#fecha1#&nbsp; al &nbsp;#fecha2#<cfelse>al #fechaaux# </cfif></strong></div>
            </cfoutput></td>

	</table>

	<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">
    	  <tr>

			<td class="tituloListas cfmenu_submenu" valign="bottom" align="left" width="20%"></div><cfoutput>
			      <div align="center"><strong>#LB_Emp#</strong></div>
            </cfoutput></td>

            <td class="tituloListas cfmenu_submenu" align="center" width="9%"></div><cfoutput>
			      <div align="center"><strong>#LB_TUsd#</strong></div>
            </cfoutput></td>
          </tr>
	</table>

	<table width="80%" border="0" align="center" cellspacing="0" cellpadding="0">

	<cfset colores = "1">

    <cfloop query="rsTimbres2">
		<tr class="trh">
			<td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif>  width="20%" align="left"><cfoutput>
			      <div align="left">#rsTimbres2.Empresa#</div>
            </cfoutput></td>
            <td <cfif colores eq "1">class="listaNon"<cfelse>class="listaPar"</cfif> width="9%" align="center"><cfoutput>
			      <div align="center">#rsTimbres2.TimbresUsados#</div>
            </cfoutput></td>

	<cfif colores eq "1">
	  <cfset colores = "2">
	<cfelse>
		<cfset colores = "1">
	</cfif>
	</tr></cfloop>


		
	</table>
</cfif>

<cfif Bases eq 0>
	 <div align="center">
	<script>
	alert("No hay datos para el Reporte");
	</script>
		 <strong>No hay datos para el Reporte</strong>
	</div>
</cfif>

		</form>

		<script language="javascript1.2" type="text/javascript">
function ValidaFechas(){

if(document.form1.Fecha1.value > document.form1.Fecha2.value){

	alert("El Periodo Fin debe ser Mayor al Periodo Inicio");
	return false;
}


}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>
