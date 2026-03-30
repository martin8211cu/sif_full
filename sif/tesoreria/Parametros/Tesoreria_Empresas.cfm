<cfoutput>
<cf_dbfunction name="to_char" args="e.Ecodigo" returnVariable="LvarEcodigo">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset imgCheck   = "<img border=""0"" src=""/cfmx/sif/imagenes/checked.gif"" 	style=""cursor:pointer;"" onclick=""javascript: sbBajaEcodigo(''' #LvarCNCT# #LvarEcodigo# #LvarCNCT# ''');"">">
<cfset imgUncheck = "<img border=""0"" src=""/cfmx/sif/imagenes/unchecked.gif"" style=""cursor:pointer;"" onclick=""javascript: sbAltaEcodigo(''' #LvarCNCT# #LvarEcodigo# #LvarCNCT# ''');"">">
<cfset imgUncheckMon = "<img border=""0"" src=""/cfmx/sif/imagenes/checked_none.gif"" onclick=""javascript: alert(''La empresa tiene una moneda diferente a la Empresa Administradora'');"">">

<cfquery datasource="#session.dsn#" name="rsEmpresas">
	Select e.Ecodigo,e.Edescripcion,esdc.CEcodigo,te.TESid,me.Miso4217
			, case
				when me.Miso4217 <> '#data.Miso4217#'
					then '#PreserveSingleQuotes(imgUncheckMon)#'
				when te.Ecodigo IS NULL
					then '#PreserveSingleQuotes(imgUncheck)#'
					else '#PreserveSingleQuotes(imgCheck)#'
			  end as OP
	  from Empresas e
		inner join Empresa esdc
			on esdc.Ecodigo=e.EcodigoSDC
		inner join Monedas me
			on me.Mcodigo=e.Mcodigo
		left outer join TESempresas te
			on te.Ecodigo=e.Ecodigo
	 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by Edescripcion
</cfquery>
<cfif isdefined('rsEmpresas') and rsEmpresas.recordCount GT 0>
	<!--- Lista de las empresas --->
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
	
		<tr>
			<td colspan="3" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;"><strong>Lista de Empresas que conforman la Tesorería</strong></td>
		</tr>				
		<tr>
			<td width="15%">&nbsp;</td>
			<td width="85%">&nbsp;</td>
			<td >&nbsp;</td>
		</tr>				
		
		<cfloop query="rsEmpresas">
			<cfif TESid EQ '' OR TESid EQ form.TESid>
				<cfif data.EcodigoAdm EQ session.Ecodigo>
					<tr style="	border-bottom: 1px solid black;	padding-bottom: 5px; ">
						<td>
							#rsEmpresas.OP#
						</td>
					<cfif Ecodigo EQ session.Ecodigo>
						<td><strong>#Edescripcion#</strong></td>
						<td><strong>#Miso4217#</strong></td>
					<cfelse>
						<td>#Edescripcion#</td>
						<td>#Miso4217#</td>
					</cfif>
					</tr>
				<cfelseif TESid EQ form.TESid>
					<tr style="	border-bottom: 1px solid black;	padding-bottom: 5px; ">
						<td>&nbsp;</td>
					<cfif Ecodigo EQ session.Ecodigo>
						<td><strong>#Edescripcion#</strong></td>
						<td><strong>#Miso4217#</strong></td>
					<cfelse>
						<td>#Edescripcion#</td>
						<td>#Miso4217#</td>
					</cfif>
					</tr>
				</cfif>										
			</cfif>
		</cfloop>
	</table>			
</cfif>

<script language="javascript" type="text/javascript">
	function sbAltaEcodigo(Ecodigo)
	{
		location.href = "Tesoreria_sql.cfm?OPaltaE&TESid=#form.TESid#&Ecodigo="+Ecodigo;
	}

	function sbBajaEcodigo(Ecodigo)
	{
		if ( confirm('¿Desea borrar esta empresa ?') ) 
		{
			location.href = "Tesoreria_sql.cfm?OPbajaE&TESid=#form.TESid#&Ecodigo="+Ecodigo;
		}				
	}
</script>
</cfoutput>
