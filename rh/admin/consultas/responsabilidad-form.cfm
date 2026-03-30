<cfquery name="libertad" datasource="sifcontrol">
	select HYLAcodigo, HYLAdescripcion, HYLAdescalterna
	from HYLibertadActuar
	order by HYLAcodigo
</cfquery>

<cfquery name="magnitud" datasource="sifcontrol">
	select HYMgrado, HYMdescripcion 
	from HYMagnitud
</cfquery>

<cfquery name="data_1" datasource="sifcontrol">
	select HYLAcodigo, HYMgrado,
	 	   case when HYMgrado = 0 then  
					(case when HYIcodigo = 'N' then {fn concat('1',HYIcodigo)}
						  when HYIcodigo = 'M' then {fn concat('2',HYIcodigo)}
						  when HYIcodigo = 'I' then {fn concat('3',HYIcodigo)}
						  when HYIcodigo = 'C' then {fn concat('4',HYIcodigo)} end) 
				when HYMgrado != 0 then 
	  				(case when HYIcodigo = 'R' then {fn concat('5',HYIcodigo)}
						  when HYIcodigo = 'C' then {fn concat('6',HYIcodigo)}
						  when HYIcodigo = 'S' then {fn concat('7',HYIcodigo)}
						  when HYIcodigo = 'P' then {fn concat('8',HYIcodigo)} end) end,
			HYTRvalor,
			case when HYMgrado = 0 then  
	  				(case when HYIcodigo = 'N' then '1' 
						  when HYIcodigo = 'M' then '2' 
						  when HYIcodigo = 'I' then '3' 
						  when HYIcodigo = 'C' then '4' end) 
	 			when HYMgrado != 0 then 
	  				(case when HYIcodigo = 'R' then '5' 
						  when HYIcodigo = 'C' then '6' 
						  when HYIcodigo = 'S' then '7' 
						  when HYIcodigo = 'P' then '8' end) end as impacto
	from HYTResponsabilidad 
	where HYTRvalor = (	select min(HYTRvalor) 
						from HYTResponsabilidad a 
						where a.HYMgrado = HYTResponsabilidad.HYMgrado 
						  and a.HYLAcodigo = HYTResponsabilidad.HYLAcodigo 
						  and a.HYIcodigo = HYTResponsabilidad.HYIcodigo)
	order by 1,2,3, 4
</cfquery>

<cfquery name="data_2" datasource="sifcontrol">
	select HYLAcodigo, HYMgrado,
		   case when HYMgrado = 0 then  
	  			(case when HYIcodigo = 'N' then {fn concat('1',HYIcodigo)}
					  when HYIcodigo = 'M' then {fn concat('2',HYIcodigo)}
					  when HYIcodigo = 'I' then {fn concat('3',HYIcodigo)}
					  when HYIcodigo = 'C' then {fn concat('4',HYIcodigo)} end) 
	 			when HYMgrado != 0 then 
	  			(case when HYIcodigo = 'R' then {fn concat('5',HYIcodigo)}
					  when HYIcodigo = 'C' then {fn concat('6',HYIcodigo)}
					  when HYIcodigo = 'S' then {fn concat('7',HYIcodigo)}
					  when HYIcodigo = 'P' then {fn concat('8',HYIcodigo)} end) end,
		HYTRvalor
	from HYTResponsabilidad 
	where HYTRvalor > (select min(HYTRvalor) 
					   from HYTResponsabilidad a 
					   where a.HYMgrado = HYTResponsabilidad.HYMgrado 
					   	 and a.HYLAcodigo = HYTResponsabilidad.HYLAcodigo 
						 and a.HYIcodigo = HYTResponsabilidad.HYIcodigo)
	  and HYTRvalor < (select max(HYTRvalor) 
	  				   from HYTResponsabilidad a 
					   where a.HYMgrado = HYTResponsabilidad.HYMgrado 
					     and a.HYLAcodigo = HYTResponsabilidad.HYLAcodigo 
						 and a.HYIcodigo = HYTResponsabilidad.HYIcodigo)
	order by 1,2,3, 4
</cfquery>

<cfquery name="data_3" datasource="sifcontrol">
	select HYLAcodigo, HYMgrado,
	 	   case when HYMgrado = 0 then  
	  			(case when HYIcodigo = 'N' then {fn concat('1',HYIcodigo)}
					  when HYIcodigo = 'M' then {fn concat('2',HYIcodigo)}
					  when HYIcodigo = 'I' then {fn concat('3',HYIcodigo)}
					  when HYIcodigo = 'C' then {fn concat('4',HYIcodigo)} end) 
	 			when HYMgrado != 0 then 
	  			(case when HYIcodigo = 'R' then {fn concat('5',HYIcodigo)}
					  when HYIcodigo = 'C' then {fn concat('6',HYIcodigo)}
					  when HYIcodigo = 'S' then {fn concat('7',HYIcodigo)}
					  when HYIcodigo = 'P' then {fn concat('8',HYIcodigo)} end) end,
		   HYTRvalor
	from HYTResponsabilidad 
	where HYTRvalor = (select max(HYTRvalor) 
					   from HYTResponsabilidad a 
					   where a.HYMgrado = HYTResponsabilidad.HYMgrado 
					   	 and a.HYLAcodigo = HYTResponsabilidad.HYLAcodigo 
						 and a.HYIcodigo = HYTResponsabilidad.HYIcodigo)
	order by 1,2,3, 4
</cfquery>

<cfset vImpacto = ArrayNew(1)>
<cfset vImpacto[1] = 'N' >
<cfset vImpacto[2] = 'M' >
<cfset vImpacto[3] = 'I' >
<cfset vImpacto[4] = 'C' >
<cfset vImpacto[5] = 'R' >
<cfset vImpacto[6] = 'C' >
<cfset vImpacto[7] = 'S' >
<cfset vImpacto[8] = 'P' >

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nominal"
	Default="Nominal"
	returnvariable="LB_Nominal"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Moderado"
	Default="Moderado"
	returnvariable="LB_Moderado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importante"
	Default="Importante"
	returnvariable="LB_Importante"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Critico"
	Default="Crítico"
	returnvariable="LB_Critico"/>

<cfset vDImpacto = ArrayNew(1)>
<cfset vDImpacto[1] = LB_Nominal >
<cfset vDImpacto[2] = LB_Moderado >
<cfset vDImpacto[3] = LB_Importante >
<cfset vDImpacto[4] = LB_Critico >

<cfquery name="grados_0" dbtype="query">
	select distinct impacto
	from data_1
	where HYMgrado=0 
</cfquery>

<cfquery name="grados_1" dbtype="query">
	select distinct impacto
	from data_1
	where HYMgrado!=0 
</cfquery>

<cfoutput>
<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
<table width="100%" border="0" align="center">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_RESPONSABILIDAD">RESPONSABILIDAD</cf_translate>
			</strong>
		</td>
	</tr>
</table><br>

<table width="100%" border="1" style="border-collapse:collapse; border-bottom-style:solid" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2"></td>
		<cfloop query="magnitud">
			<td valign="top" colspan="#grados_0.RecordCount#" align="center">
				<b>(#magnitud.HYMgrado#) #magnitud.HYMdescripcion#</b>
			</td>
		</cfloop>
	</tr>

	<tr>
		<td colspan="2" align="right"><b>* * * <cf_translate key="LB_Magnitud">Magnitud</cf_translate> ==></b></td>
		<cfloop query="grados_0">
			<td style="writing-mode:tb-rl;" align="center"><b>#vDImpacto[grados_0.impacto]#</b></td>
		</cfloop>
		<cfloop query="magnitud">
			<cfif magnitud.CurrentRow neq 1>
				<td colspan="#grados_1.RecordCount#" align="center"><cf_translate key="LB_De">De</cf_translate>:___ <cf_translate key="LB_A">A</cf_translate>:___</td>
			</cfif>
		</cfloop>
	</tr>

	<tr>
		<td colspan="2" align="right"><b>* * <cf_translate key="LB_Impacto">Impacto</cf_translate> ==></b></td>
		<cfloop query="magnitud">
			<cfif magnitud.HYMgrado eq 0>
				<cfloop query="grados_0">
					<td align="center"><b>#vImpacto[grados_0.impacto]#</b></td>
				</cfloop>
			<cfelse>
				<cfloop query="grados_1">
					<td align="center"><b>#vImpacto[grados_1.impacto]#</b></td>
				</cfloop>
			</cfif>
		</cfloop>
	</tr>	

	<cfloop query="libertad">
		<cfset vLibertad = libertad.HYLAcodigo >
		<cfset vLADescripcion = libertad.HYLAdescripcion >
		<cfset vLADescAlterna = libertad.HYLAdescalterna >
		<cfset titulo = false>

		<tr>
		<cfif libertad.CurrentRow eq 1 and not titulo >
			<td width="1%" valign="middle"  
				style="text-align: center; writing-mode:tb-rl;" 
				rowspan="32"><b>* <cf_translate key="LB_LibertadParaActual">Libertad para Actuar</cf_translate></b>
			</td>
			<cfset  titulo = true >
		</cfif>
		</tr>

		<!--- Primer fila --->
		<cfquery name="data_1_1" dbtype="query">
			select *
			from data_1
			where HYLAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vLibertad#">
		</cfquery>
		<tr>
			<td rowspan="3" width="30%" valign="middle" height="70" style="border-right-width:0px" >
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td><b>#libertad.HYLAcodigo#. #libertad.HYLAdescripcion#</b></td>
					</tr>
					<tr>
						<td>#libertad.HYLAdescalterna#</td>
					</tr>
				</table>
			</td>

			<cfloop query="data_1_1">
				<td align="center" 
					<cfif data_1_1.CurrentRow mod grados_1.RecordCount eq 0>
						style="border-right-width:0px"
					</cfif>  
					>#data_1_1.HYTRvalor#</td>
			</cfloop>
		</tr>	

		<!--- Segunda fila --->
		<cfquery name="data_2_1" dbtype="query">
			select *
			from data_2
			where HYLAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vLibertad#">
		</cfquery>
		<tr>	
		<cfloop query="data_2_1">
			<td align="center" 
				<cfif data_2_1.CurrentRow mod grados_1.RecordCount eq 0>
					style="border-right-width:0px"
				</cfif> 
			>#data_2_1.HYTRvalor#</td>
		</cfloop>
		</tr>	

		<!--- Tercer fila --->
		<cfquery name="data_3_1" dbtype="query">
			select *
			from data_3
			where HYLAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vLibertad#">
		</cfquery>
		<tr>	
		<cfloop query="data_3_1">
			<td align="center" 
				<cfif data_3_1.CurrentRow mod grados_1.RecordCount eq 0>
					style="border-right-width:0px"
				</cfif> >#data_3_1.HYTRvalor#</td>
		</cfloop>
		</tr>
	</cfloop>
</table>
</cfoutput>