<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar"
xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FormaPago" default="Forma de Pago" returnvariable="LB_FormaPago"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Liquidacion" default="Liquidaci&oacute;n" returnvariable="LB_Liquidacion"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Beneficiario" default="Beneficiario" returnvariable="LB_Beneficiario"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalAnticipo" default="Total Anticipo" returnvariable="LB_TotalAnticipo"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalGastado" default="Total Gastado" returnvariable="LB_TotalGastado"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalReembolso" default="Total Reembolso" returnvariable="LB_TotalReembolso"
xmlfile ="ReporteLiq_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TotalDevoluciones" default="Total Devoluciones" returnvariable="LB_TotalDevoluciones"
xmlfile ="ReporteLiq_form.xml"/>

<cfset mensaje = "">
<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select
		  Edescripcion,
		  Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif isdefined ('form.estadoLid')>
	 <cfif #form.estadoLid# eq 1>
	  	<cfset LvarEstado = "2">
		<cfset LvarEstadoDesc = "Liiquidadas">
	 <cfelseif #form.estadoLid# eq 2>
	 	<cfset LvarEstado = "4,5">
		<cfset LvarEstadoDesc = "Aprobadas No entregadas">
	 <cfelseif #form.estadoLid# eq 3>
	 	<cfset LvarEstado = "2,4,5">
		<cfset LvarEstadoDesc = "Todos">
	 </cfif>
</cfif>


<cfif isdefined ('form.desde')>
   <cfset LvarFechaDesde= #form.desde#>
</cfif>

<cfif isdefined ('form.hasta')>
   <cfset LvarFechaHasta= #form.hasta#>
</cfif>

   <cfquery name="rsValidaFechaMayor" datasource="#session.dsn#">
			select <cf_dbfunction name="datediff" args="#LSParseDateTime(form.desde)#, #LSParseDateTime(form.hasta)#"> as diasDiferencia
				from dual
   </cfquery>
   <cfif #rsValidaFechaMayor.diasDiferencia#  lt 0 >
     <cfset mensaje = "La fecha DESDE no puede ser mayor a la fecha HASTA">
   </cfif>
   <cfoutput>
<script language="javascript1.2">
   <cfif mensaje neq "">
	 alert("<cfoutput>#mensaje#</cfoutput>");
	 history.back(-1);
   </cfif>
</script>
</cfoutput>

 <cfquery datasource="#session.dsn#" name="rsLiquidaciones">
		select
		GELid,
	     case coalesce(a.CCHid,  0)
		 when 0  then 'tesoreria'
		  else d.CCHdescripcion
		end   as FormaPago,
	    a.GELnumero  as Liquidacion,
		a.GELdescripcion,
	    b.TESBeneficiario as Beneficiario,
	    c.Miso4217 as Moneda,
		a.GELfecha,
		a.GELtotalGastos,
		a.GELtotalAnticipos,
		a.GELreembolso,
		coalesce(a.GELtotalDevoluciones,0) as GELtotalDevoluciones,
	    a.TESBid,
	    a.Mcodigo,
	    a.CCHid,
	    a.GELestado
	from GEliquidacion a
	   inner join TESbeneficiario b
	     on a.TESBid = b.TESBid
       inner join Monedas c
	     on a.Mcodigo = c.Mcodigo
	   left outer join  CCHica d
	     on a.CCHid = d.CCHid
	where
	  a.Ecodigo = #session.Ecodigo#
	  and GELestado in (#LvarEstado#)
     <cfif #rsValidaFechaMayor.diasDiferencia# eq 0 >
	   and a.GELfecha = <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDateTime(form.desde)#">
     <cfelseif #rsValidaFechaMayor.diasDiferencia# gt 0 >
	   and a.GELfecha between <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDateTime(form.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDateTime(form.hasta)#">
     </cfif>
	   <cfif isdefined ('form.FormaPago') and #form.FormaPago# neq "ALL">
	    and coalesce(a.CCHid,0) = #form.FormaPago#
	   </cfif>
</cfquery>
     <table align="center">
	   <tr>
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
		</tr>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12"><strong><cf_translate key=LB_SistGastoEmp>Sistema de Gastos de Empleado</cf_translate></strong></td>
		</tr>
		<tr><td align="center" valign="top" colspan="12"><strong><cf_translate key=LB_RpteLiquidaciones>Reporte de Liquidaciones</cf_translate></strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	 </table>

   <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsLiquidaciones#"
	conexion="#session.dsn#"
	desplegar="FormaPago,Liquidacion,GELdescripcion,Beneficiario,Moneda,GELfecha,GELtotalAnticipos,GELtotalGastos,GELreembolso,GELtotalDevoluciones"
	etiquetas="#LB_FormaPago#,#LB_Liquidacion#,#LB_Descripcion#,#LB_Beneficiario#,#LB_Moneda#,#LB_Fecha#,#LB_TotalAnticipo#,#LB_TotalGastado#,#LB_TotalReembolso#, #LB_TotalDevoluciones#"
	formatos="S,S,S,S,S,D,M,M,M,M"
	mostrar_filtro="false"
	align="center,center,center,center,center,center,center,center,center,center"
	checkboxes="N"
	ira="ReportDeLiq.cfm"
	showlink="false"
	usaAjax="true"
	keys="GELid,FormaPago">
</cfinvoke>
<table align="center">
 <tr align="center">
  <td align="center">
   <cfoutput><input name="Regresar" type="button" onclick="Regresar()" value="#BTN_Regresar#" /></cfoutput>
  </td>
 </tr>
 </table>
<cfoutput>
	 <script language="javascript" type="text/javascript">
		function Regresar()
		{
		  history.back(-1);
		}
	</script>
 </cfoutput>








