<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cftry>
			<!---==========NUEVO==============--->		
			<cfif isdefined("Form.Alta")>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						insert into Anexo (AnexoDes, AnexoFec, AnexoUsu, Ecodigo)
						values(
							<cfqueryparam value="#Form.AnexoDes#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#LSDateFormat(Form.AnexoFec,'YYYYMMDD')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.usuario#" cfsqltype="cf_sql_varchar">,
							 #Session.Ecodigo# 
						)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Anexo">
						<cfset llave = ABC_Anexo.identity>
					
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						insert into Anexoim 
						(AnexoId, AnexoDef) values (#llave#, '')
					</cfquery>
					
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						update Anexoim set AnexoDef = '<?xml version="1.0"?>
							<ss:Workbook xmlns:x="urn:schemas-microsoft-com:office:excel"
							 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
							 xmlns:c="urn:schemas-microsoft-com:office:component:spreadsheet">
							 <x:ExcelWorkbook>
							  <x:ProtectStructure>True</x:ProtectStructure>
							  <x:ActiveSheet>0</x:ActiveSheet>
							  <x:HideWorkbookTabs/>
							 </x:ExcelWorkbook>
							 <ss:Styles>
							  <ss:Style ss:ID="Default">
							   <ss:Alignment ss:Horizontal="Automatic" ss:Rotate="0.0" ss:Vertical="Bottom"
								ss:ReadingOrder="Context"/>
							   <ss:Borders>
							   </ss:Borders>
							   <ss:Font ss:FontName="Arial" ss:Size="10" ss:Color="Automatic" ss:Bold="0"
								ss:Italic="0" ss:Underline="None"/>
							   <ss:Interior ss:Color="Automatic" ss:Pattern="None"/>
							   <ss:NumberFormat ss:Format="General"/>
							   <ss:Protection ss:Protected="1"/>
							  </ss:Style>
							 </ss:Styles>
							 <c:ComponentOptions>
							  <c:Label>
							   <c:Caption>Anexos Financieros</c:Caption>
							  </c:Label>
							  <c:MaxHeight>100%</c:MaxHeight>
							  <c:MaxWidth>100%</c:MaxWidth>
							  <c:NextSheetNumber>2</c:NextSheetNumber>
							 </c:ComponentOptions>
							 <x:WorkbookOptions>
							  <c:OWCVersion>10.0.0.2621         </c:OWCVersion>
							  <x:Height>9500</x:Height>
							  <x:Width>22500</x:Width>
							 </x:WorkbookOptions>
							 <ss:Worksheet ss:Name="<cfoutput>#Form.AnexoDes#</cfoutput>">
							  <x:WorksheetOptions>
							   <x:Selected/>
							   <x:ViewableRange>R1:R262144</x:ViewableRange>
							   <x:Selection>R1C1</x:Selection>
							   <x:TopRowVisible>0</x:TopRowVisible>
							   <x:LeftColumnVisible>0</x:LeftColumnVisible>
							   <x:ProtectContents>False</x:ProtectContents>
							  </x:WorksheetOptions>
							  <c:WorksheetOptions>
							  </c:WorksheetOptions>
							  <ss:Table ss:DefaultColumnWidth="48.0" ss:DefaultRowHeight="12.75">
							  </ss:Table>
							 </ss:Worksheet>
							</ss:Workbook>'
						where AnexoId = #llave#
					</cfquery>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						insert into AnexoEm(Ecodigo, AnexoId) 
						values (#Session.Ecodigo#,#llave#)
					</cfquery>
					
					<cfset modo="ALTA">
			<!---==========ELIMINAR==============--->		
			<cfelseif isdefined("Form.Baja")>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						delete from Anexoim 
						where AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">			
						delete from AnexoEm where AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						delete AnexoCelD
						from AnexoCel a 
						where a.AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
						  and a.AnexoCelId = AnexoCelD.AnexoCelId
					</cfquery>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						delete from AnexoCel 
						  where AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						delete from Anexo 
						 where AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfset modo="BAJA">
			<!---==========MODIFICAR==============--->
			 <cfelseif isdefined("Form.Cambio")>
					<cfquery name="ABC_Anexo" datasource="#Session.DSN#">
						update Anexo set
							AnexoDes = <cfqueryparam value="#Form.AnexoDes#" cfsqltype="cf_sql_varchar">,
							AnexoFec = <cfqueryparam value="#Form.AnexoFec#" cfsqltype="cf_sql_varchar">
						where Ecodigo =  #Session.Ecodigo# 
						  and AnexoId = <cfqueryparam value="#Form.AnexoId#" cfsqltype="cf_sql_numeric">
					</cfquery>
					  <cfset modo="CAMBIO">
			</cfif>
		
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>
</cfif>
<cfoutput>
<form action="Anexo.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>