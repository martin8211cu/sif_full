<cfset especializada = ArrayNew(1)>
<cfset especializada[1] = 'A'>
<cfset especializada[2] = 'B'>
<cfset especializada[3] = 'C'>
<cfset especializada[4] = 'D'>
<cfset especializada[5] = 'E'>
<cfset especializada[6] = 'F'>
<cfset especializada[7] = 'G'>
<cfset especializada[8] = 'H'>

<cfset gerencia = ArrayNew(1)>
<cfset gerencia[1] = '0'>
<cfset gerencia[2] = '1'>
<cfset gerencia[3] = '2'>
<cfset gerencia[4] = '3'>
<cfset gerencia[5] = '4'>

<cfset grado = ArrayNew(1)>
<cfset grado[1] = '1'>
<cfset grado[2] = '2'>
<cfset grado[3] = '3'>

<cfset hpuntos = ArrayNew(1)>
<cfset hpuntos[1] = '50'>
<cfset hpuntos[2] = '100'>
<cfset hpuntos[3] = '132'>
<cfset hpuntos[4] = '264'>
<cfset hpuntos[5] = '400'>
<cfset hpuntos[6] = '304'>
<cfset hpuntos[7] = '460'>
<cfset hpuntos[8] = '920'>
<cfset hpuntos[9] = '1216'>
<cfset hpuntos[10] = '87'>
<cfset hpuntos[11] = '66'>
<cfset hpuntos[12] = '115'>
<cfset hpuntos[1] = '528'>
<cfset hpuntos[2] = '608'>
<cfset hpuntos[13] = '1056'>
<cfset hpuntos[14] = '175'>
<cfset hpuntos[15] = '350'>
<cfset hpuntos[16] = '175'>
<cfset hpuntos[17] = '152'>
<cfset hpuntos[18] = '608'>
<cfset hpuntos[19] = '528'>
<cfset hpuntos[20] = '132'>
<cfset hpuntos[21] = '76'>
<cfset hpuntos[22] = '115'>

<cfset problemas = ArrayNew(1)>
<cfset problemas[1] = 'A'>
<cfset problemas[2] = 'B'>
<cfset problemas[3] = 'C'>
<cfset problemas[4] = 'D'>
<cfset problemas[5] = 'E'>
<cfset problemas[6] = 'F'>
<cfset problemas[7] = 'G'>
<cfset problemas[8] = 'H'>

<cfset complejidad = ArrayNew(1)>
<cfset complejidad[1] = '1'>
<cfset complejidad[2] = '2'>
<cfset complejidad[3] = '3'>
<cfset complejidad[4] = '4'>
<cfset complejidad[5] = '5'>

<cfset pctPensamiento = ArrayNew(1)>
<cfset pctPensamiento[1] = '10'>
<cfset pctPensamiento[2] = '12'>
<cfset pctPensamiento[3] = '14'>
<cfset pctPensamiento[4] = '16'>
<cfset pctPensamiento[5] = '19'>
<cfset pctPensamiento[6] = '22'>
<cfset pctPensamiento[7] = '25'>
<cfset pctPensamiento[8] = '29'>
<cfset pctPensamiento[9] = '4'>
<cfset pctPensamiento[10] = '33'>
<cfset pctPensamiento[11] = '38'>
<cfset pctPensamiento[12] = '50'>
<cfset pctPensamiento[13] = '57'>
<cfset pctPensamiento[14] = '57'>
<cfset pctPensamiento[15] = '66'>
<cfset pctPensamiento[16] = '76'>
<cfset pctPensamiento[17] = '87'>
<cfset pctPensamiento[18] = '33'>
<cfset pctPensamiento[19] = '12'>
<cfset pctPensamiento[20] = '38'>

<cfset responsable = ArrayNew(1)>
<cfset responsable[1] = 'A'>
<cfset responsable[2] = 'B'>
<cfset responsable[3] = 'C'>
<cfset responsable[4] = 'D'>
<cfset responsable[5] = 'E'>
<cfset responsable[6] = 'F'>
<cfset responsable[7] = 'G'>
<cfset responsable[8] = 'H'>

<cfset resGrado = ArrayNew(1)>
<cfset resGrado[1] = '1'>
<cfset resGrado[2] = '2'>
<cfset resGrado[3] = '3'>
<cfset resGrado[4] = '4'>
<cfset resGrado[5] = '5'>

<cfset impacto = ArrayNew(1)>
<cfset impacto[1] = 'N'>
<cfset impacto[2] = 'M'>
<cfset impacto[3] = 'I'>
<cfset impacto[4] = 'C'>
<cfset impacto[5] = 'R'>
<cfset impacto[6] = 'S'>
<cfset impacto[7] = 'P'>

<cfset pctResponsabilidad = ArrayNew(1)>
<cfset pctResponsabilidad[1] = '8'>
<cfset pctResponsabilidad[2] = '10'>
<cfset pctResponsabilidad[3] = '14'>
<cfset pctResponsabilidad[4] = '16'>
<cfset pctResponsabilidad[5] = '19'>
<cfset pctResponsabilidad[6] = '22'>
<cfset pctResponsabilidad[7] = '25'>
<cfset pctResponsabilidad[8] = '29'>
<cfset pctResponsabilidad[9] = '4'>
<cfset pctResponsabilidad[10] = '33'>
<cfset pctResponsabilidad[11] = '38'>
<cfset pctResponsabilidad[12] = '50'>
<cfset pctResponsabilidad[13] = '350'>
<cfset pctResponsabilidad[14] = '57'>
<cfset pctResponsabilidad[15] = '66'>
<cfset pctResponsabilidad[16] = '76'>
<cfset pctResponsabilidad[17] = '76'>
<cfset pctResponsabilidad[18] = '800'>
<cfset pctResponsabilidad[19] = '12'>
<cfset pctResponsabilidad[20] = '87'>


<cfquery name="puestos" datasource="#session.dsn#">
	select RHPcodigo
	from RHPuestos
	where Ecodigo=1
</cfquery>

<cftry>
<cfquery name="update" datasource="#session.dsn#">
<cfloop query="puestos">
	<cfset i = RandRange(1,8) >
	<cfset j = RandRange(1,3) >
	<cfset l = RandRange(1,5) >
	<cfset k = RandRange(1,22) >
	<cfset m = RandRange(1,8) >
	<cfset n = RandRange(1,5) >
	<cfset o = RandRange(1,20) >
	<cfset p = RandRange(1,8) >
	<cfset q = RandRange(1,5) >
	<cfset r = RandRange(1,7) >
	<cfset s = RandRange(1,20) >

	update RHPuestos
	set HYHEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#especializada[i]#">,
	    HYHGcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#gerencia[l]#">,
		HYIHgrado  = <cfqueryparam cfsqltype="cf_sql_integer" value="#grado[j]#">,
		ptsHabilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#hpuntos[k]#">,
		HYMRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#problemas[m]#">,
		HYCPgrado = <cfqueryparam cfsqltype="cf_sql_char" value="#complejidad[n]#">,
		porcSP     = <cfqueryparam cfsqltype="cf_sql_char" value="#pctPensamiento[o]#">,
		ptsSP      = <cfqueryparam cfsqltype="cf_sql_integer" value="#hpuntos[o]#">,
		HYLAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#responsable[p]#">,
		HYMgrado = <cfqueryparam cfsqltype="cf_sql_integer" value="#resGrado[q]#">,
		HYIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#impacto[r]#">,
		ptsResp = <cfqueryparam cfsqltype="cf_sql_char" value="#pctResponsabilidad[s]#">
	where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(puestos.RHPcodigo)#">
	  and Ecodigo = 1

	update RHPuestos
	set ptsTotal = ptsHabilidad + ptsSP + ptsResp
	where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(puestos.RHPcodigo)#">
	  and Ecodigo = 1

</cfloop>

</cfquery>
<cfcatch type="any">
<cfdump var="#cfcatch#">
</cfcatch>
</cftry>






