<cfquery name="data" datasource="sifcontrol">
	select  HYTPporcentaje, 
			HYTPresp, 
			HYTPcol, 
			HYTPptshab,  
			case HYTPresp 
				when 'R4' then 1 
				when 'R3' then 2 
				when 'R2' then 3 
				when 'R1' then 4 
				when 'NIVELADO' then 5 
				when 'SP1' then 6 
				when 'SP2' then 7 
				when 'SP3' then 8 
				when 'SP4' then 9 end as nivel 
	from HYTPerfiles
	order by HYTPporcentaje desc 
</cfquery>

<cfquery name="porcentaje" dbtype="query">
	select distinct HYTPporcentaje
	from data
	order by 1 desc
</cfquery>

<cfquery name="nivel" dbtype="query">
	select distinct nivel, HYTPresp 
	from data
	order by 1, HYTPresp
</cfquery>

<cfquery name="grados" dbtype="query">
	select distinct HYTPcol
	from data
</cfquery>

<cfquery name="intervalos" datasource="sifcontrol">
	select HYVIvalor 
	from HYValoresIntervalos 
	order by 1 desc
</cfquery>

<cfoutput>
<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
<style type="text/css">
	.prueba{font-size:9px}
</style>


<table width="100%" border="0" align="center">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_PerfilesHayCaracterasticosPorcentajeDeHSPR">Perfiles Hay Caracter&iacute;sticos (Porcentaje de H-SP-R)</cf_translate>
			</strong>
		</td>
	</tr>
</table><br>

<table width="100%" >
	<tr>
		<td width="1%" valign="top" >
			<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse; border-color:##CCCCCC">
				<cfloop query="intervalos">
					<tr><td class="prueba" >#intervalos.HYVIvalor#</td></tr>
				</cfloop>
			</table>
		</td>
		
		<td valign="top">
			<table width="100%" border="1" 
					style="border-collapse:collapse; border-bottom-style: inset; border-bottom-color:##CCCCCC; 
						   border-top-color:##CCCCCC; border-left-color:##CCCCCC; border-right-color:##CCCCCC; 
						   " cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" style="border-right-width:1px;border-bottom-width:0px;  
											  border-right-color:##CCCCCC"><b>%SP/H</b></td>
					<td colspan="#grados.RecordCount*4#"  align="center" 
						style=" border-bottom-width:0px; border-right-width:1px; 
								border-right-color:##CCCCCC">
						<b><cf_translate key="LB_RESPONSABILIDADMayorQueSOLUCIONDEPROBLEMAS">RESPONSABILIDAD mayor que SOLUCION DE PROBLEMAS</cf_translate></b>
					</td>
					<td colspan="#grados.RecordCount#"  align="center" 
						style=" border-bottom-width:0px; border-right-width:1px; border-right-color:##CCCCCC">
							<b><cf_translate key="LB_RSP">R = SP</cf_translate></b></td>
					<td colspan="#grados.RecordCount*4#"  align="center" 
						style=" border-bottom-width:0px; border-right-width:1px; 
								border-right-color:##CCCCCC">
						<b><cf_translate key="LB_RESPONSABILIDADMenorQueSOLUCIONDEPROBLEMAS">RESPONSABILIDAD menor que SOLUCION DE PROBLEMAS</cf_translate></b>
					</td>
				</tr>
				<tr class="listaPar">
					<td style="border-right-width:1px; border-right-color:##CCCCCC"></td>
					<cfloop query="nivel">
						<td colspan="#grados.RecordCount#" align="center" 
							<cfif (trim(nivel.HYTPresp) eq 'R1' or trim(nivel.HYTPresp) eq 'NIVELADO' or trim(nivel.HYTPresp) eq 'SP4') >		
								style="border-right-width:1px; border-right-color:##CCCCCC"</cfif> >
							<b>#nivel.HYTPresp#</b></td>
					</cfloop>
				</tr>
			
				<cfloop query="porcentaje">
					<cfset vPct = porcentaje.HYTPporcentaje >
					<cfset titulo = false>
			
					<!--- Primer fila --->
					<cfquery name="data_1" dbtype="query">
						select *
						from data
						where HYTPporcentaje = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPct#">
						order by nivel, HYTPcol
					</cfquery>
					
					<tr>
						<td align="center" style="border-right-width:1px; border-right-color:##CCCCCC" 
							class="listaPar" ><b>#vPct#%</b></td>
						<cfloop query="data_1">
							<td align="center" 
								<cfif (trim(data_1.HYTPresp) eq 'R1' or trim(data_1.HYTPresp) eq 'NIVELADO' 
										or trim(data_1.HYTPresp) eq 'SP4') and data_1.HYTPcol eq 3>
									style="border-right-width:1px; border-right-color:##CCCCCC"</cfif> >
								#data_1.HYTPptshab#</td>
						</cfloop>
					</tr>
				</cfloop>
			</table>
		</td>		
	</tr>
</table>				
</cfoutput>