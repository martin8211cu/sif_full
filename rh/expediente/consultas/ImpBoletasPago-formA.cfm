<cfsetting requestTimeOut="8600">
<cfparam name="formato" default="Flashpaper">
<cfparam name="CPid" default="">
<cfparam name="CFidI" default="">
<!---<cfparam name="CFidF" default="">--->
<cfparam name="nomail" default="0">

<!----
<cfset vs_filtro = ''>
<cfif isdefined("url.ctrofuncional") and len(trim(url.ctrofuncional))>
	<cfset vs_filtro = 'order by d.CFcodigo'>
<cfelseif isdefined("url.apellidonombre") and len(trim(url.apellidonombre))>
	<cfset vs_filtro = 'order by e.DEapellido1,e.DEnombre'>
<cfelseif isdefined("url.nombreapellido") and len(trim(url.nombreapellido))>
	<cfset vs_filtro = 'order by e.DEnombre,e.DEapellido1'>
</cfif>--->

<!---<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>&nbsp;</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>---->

<!---Obtener cual formato de boleta se esta usando----->
<cfquery name="rsParametro" datasource="#session.DSN#">
	select coalesce(Pvalor,'10') as Pvalor
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 720
</cfquery>

<cfinvoke component="sif.Componentes.Translate" key="LB_Boleta_Pago" Default="Boleta de Pago" returnvariable="LB_Boleta" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<cfinvoke component="sif.Componentes.Translate" key="LB_SalarioBruto" Default="Salario Bruto" returnvariable="LB_SalarioBruto" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml"/> 
<cfinvoke component="sif.Componentes.Translate" key="LB_Retroactivos" Default="RETROACTIVOS" returnvariable="LB_Retroactivos" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml"/> 
<cfinvoke component="sif.Componentes.Translate" key="LB_Renta" Default="IMPUESTO RENTA EMPLEADOS" returnvariable="LB_Renta" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml"/> 
<cfinvoke key="LB_GenerarArchivoTexto" default="Generar archivo de texto" returnvariable="LB_GenerarArchivoTexto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<!---
<!---============== DATOS DE LA NOMINA ==============---->
<cfquery name="rsNomina" datasource="#Session.DSN#">
	select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	and a.Ecodigo = b.Ecodigo
</cfquery>

--->

<!---Componente que trae llena el la tabla temporal con los datos que necesitamos--->
<cfinvoke component="rh.Componentes.RH_BoletaPagoDatos" method="getConceptosPago" returnvariable="TMPConceptos">
	<cfinvokeargument name="CPid" value="#CPid#">
	<cfinvokeargument name="DEidList" value="#form.chk#">
	<cfinvokeargument name="Historico" value="no">
</cfinvoke>

<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
	select Mensaje from MensajeBoleta 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
</cfquery>

<cfquery name="ConceptosPago" datasource="#session.DSN#">
	select *
	from #TMPConceptos#
	<!----where devengado != 0----->
	where (	devengado != 0 or 
			deducido != 0 or
			neto != 0)
	order by orden,DEid,linea
</cfquery>

<cfset vb_pagebreak = true><!---Indicar que haga corte---->
<cfif isdefined("formato") and formato EQ "FlashPaper">
	<cfset vb_flashpaper = true><!---Indicar que es flashpaper---->
</cfif>

<cfinclude template="FormatoBoletaPagoDosTercios.cfm">

<!---===========================================================================---> 
<!----========================= PINTADO DEL REPORTE ===========================---->
<!---===========================================================================---> 
<cfif isdefined("formato") and formato EQ "Html">	
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select coalesce(Pvalor,'10') as formato
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 720
	</cfquery>
	
	<cfset params = "">
	<cfset params = params & '?formato=#formato#'>
	<cfif len(trim(CFidI))>
		<cfset params = params & '&CFidI=#CFidI#'>
	</cfif>
	<!---
	<cfif len(trim(CFidF))>
		<cfset params = params & '?&CFidF=#CFidF#'>
	</cfif>
	---->
	<cfif len(trim(CPid))>
		<cfset params = params & '&CPid=#CPid#'>
	</cfif>
	<cfif len(trim(nomail))>
		<cfset params = params & '&nomail=#nomail#'>
	</cfif>
	<cfif isdefined("url.ctrofuncional") and len(trim(url.ctrofuncional))>
		<cfset params = params & '&ctrofuncional=#url.ctrofuncional#'>
	</cfif>
	<cfif isdefined("url.apellidonombre") and len(trim(url.apellidonombre))>
		<cfset params = params & '&apellidonombre=#url.apellidonombre#'>
	</cfif>
	<cfif isdefined("url.nombreapellido") and len(trim(url.nombreapellido))>
		<cfset params = params & '&nombreapellido=#url.nombreapellido#'>
	</cfif>
	
	<table width="950" cellpadding="0" cellspacing="0" align="center" style="top:auto">
		<tr>
			<td>
				<!---<cf_rhimprime datos="../rh/expediente/consultas/ImpBoletasPago-form.cfm" paramsuri="#params#" >--->
				<cf_htmlreportsheaders
					title="" 
					download="false"
					filename="impboletaspagomasivo#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
					ira="ImpBoletasPago-filtroA.cfm"
					back="true">
			</td>
			<cfif rsFormato.formato EQ 30>				
				<cfoutput>
				<cfset params = params & '&chk=#form.chk#'>
				<form name="form1" method="post" action="TXT-FormatoBoletaPagoMediaPag.cfm">				
					<input type="hidden" name="chk" value="#form.chk#" />
					<input type="hidden" name="CFidI" value="<cfif isdefined("CFidI") and len(trim(CFidI))>#CFidI#</cfif>" />
					<input type="hidden" name="CPid" value="<cfif isdefined("CPid") and len(trim(CPid))>#CPid#</cfif>" />
					<input type="hidden" name="nomail" value="<cfif isdefined("nomail") and len(trim(nomail))>#nomail#</cfif>" />
					<cfif isdefined("url.ctrofuncional") and len(trim(url.ctrofuncional))>
						<input type="hidden" name="ctrofuncional" value="#url.ctrofuncional#"/>					
					</cfif>
					<cfif isdefined("url.nombreapellido") and len(trim(url.nombreapellido))>
						<input type="hidden" name="apellidonombre" value="#url.nombreapellido#"/>					
					</cfif>
					<cfif isdefined("url.nombreapellido") and len(trim(url.nombreapellido))>
						<input type="hidden" name="nombreapellido" value="#url.nombreapellido#"/>					
					</cfif>
					<td>
						<a href="javascript: funcTxt();" title="#LB_GenerarArchivoTexto#"><img src="/cfmx/rh/imagenes/iindex.gif" border="0"/></a>
					</td>
				</form>
				</cfoutput>
			</cfif>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td valign="top">
			<cfoutput>#DETALLE#</cfoutput>
		</td></tr>
	</table>
<cfelse>	
	<cfdocument format="#formato#"  marginleft ="0.5" marginright = "0.5" unit="cm" pagetype="letter" margintop="0" marginbottom="0">
		<table style="page:auto; ">
			<tr><td valign="top"><cfoutput>#DETALLE#</cfoutput></td></tr>
		</table>		
	</cfdocument>
</cfif>	
<!---
</body>
</html>---->
<script type="text/javascript">
	function funcTxt(){
		document.form1.submit();
	}
</script>



