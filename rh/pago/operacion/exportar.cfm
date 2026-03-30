<html>
<head>
<title><cf_translate  key="LB_ExportarRegistroDePagoDeNomina">Exportar Registro de Pago de N&oacute;mina</cf_translate></title>

<cf_templatecss>
<cf_templatecss>

</head>
<body>

	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor from RHParametros where Pcodigo = 390 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<!--- Se define la variable --historico--- para indicar si se debe buscar infomacion en nominas actuales o historicas --->
	<cfquery name="hist" datasource="#session.DSN#">		
		select 1 as historico from HERNomina where ERNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ERNid#">
	</cfquery>
	<cfif hist.RecordCount eq 0>
		<cfquery name="hist" datasource="#session.DSN#">
			select 0 as historico from ERNomina where ERNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ERNid#">
		</cfquery>
	</cfif> 	
	
	<!--- Se agrega las variables Bid y historico, este ultimo indica si se debe buscar infomacion en nominas actuales o historicas --->
	<cfif hist.historico eq 1>
		<cfquery name="Bid" datasource="#session.DSN#">
			select coalesce(max(Bid), 0) as Bid
			from HERNomina 
			where ERNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ERNid#">
		</cfquery>
	<cfelse>        
		<cfquery name="Bid" datasource="#session.DSN#">
			select coalesce(max(Bid), 0) as Bid
			from ERNomina 
			where ERNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ERNid#">
		</cfquery>
	</cfif>
	
	<cfquery name="Empresa" datasource="#session.DSN#">
		select EcodigoSDC from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	

	<cfif not len(trim(rs.Pvalor))>
		<table border="0" width="100%" cellspacing="0" cellpadding="2" align="center" style="border-color:##000000; border-style:solid; border-width:1px;" >
			<tr>
				<td valign="top" align="center" class="tituloListas"><b><cf_translate  key="LB_ExportacionDeRegistroDePagoDeNomina">Exportaci&oacute;n de Registro de Pago de N&oacute;mina</cf_translate></b></td>
			</tr>
			<tr><td><cf_translate  key="LB_NoSeHaDefinidoElFormatoDeExportacionDePagoDeNomina">No se ha definido el formato de exportaci&oacute;n de Pago de N&oacute;mina</cf_translate></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Cerrar"/>
						
			<input type="button" value="Cerrar" name="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="window.close();"></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cfelse>
		<cfoutput>
		<table border="0" width="100%" cellspacing="0" cellpadding="2" align="center" style="border-color:##000000; border-style:solid; border-width:1px;" >
			<tr>
				<td valign="top" align="center" class="tituloListas"><b><cf_translate  key="LB_ExportacionDeRegistroDePagoDeNomina">Exportaci&oacute;n de Registro de Pago de N&oacute;mina</cf_translate></b></td>
			</tr>
	
			<tr>
				<td valign="top" align="center">
					<cf_sifimportar EIcodigo="#rs.Pvalor#" mode="out">
						<cf_sifimportarparam name="ERNid" value="#url.ERNid#">
					  	<cf_sifimportarparam name="Bid" value="#Bid.Bid#">
					  	<cf_sifimportarparam name="EcodigoASP" value="#Empresa.EcodigoSDC#">
						<cf_sifimportarparam name="historico" value="#hist.historico#">
						<!----<cf_sifimportarparam name="historico" value="#Bid.historico#">---->
					</cf_sifimportar>			
				</td>
			</tr>
		</table>
		</cfoutput>
	
		<script language="javascript1.2" type="text/javascript">
			function cerrar() {
				window.close();
				return false;
			}
		
		</script>		

	</cfif>



</body>
</html>

