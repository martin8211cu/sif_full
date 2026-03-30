<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Historia"
	Default="Historia"
	returnvariable="LB_Historia"/>
﻿<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dominio"
	Default="Dominio"
	returnvariable="LB_Dominio"/>
﻿<cfquery name="rsHistoria" datasource="#session.dsn#">
		select RHCEid, RHCEfdesde as RHCEfdesdet,RHCEfhasta as  RHCEfhastat ,RHCEdominio ,RHCEjustificacion 
		from RHCompetenciasEmpleado 
		where idcompetencia =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.idcompetencia#">
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and DEid= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.DEid#"> 
		<cfelse>
			and RHOid= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RHOid#"> 
		</cfif>
		and   tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.tipo#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by  RHCompetenciasEmpleado.RHCEfdesde 
</cfquery>
<cfif url.tipo eq 'H'>
	<cfquery name="rsDescrip" datasource="#session.dsn#">
		select RHHcodigo as codigo,RHHdescripcion as descripcion
		from RHHabilidades 
		where RHHid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.idcompetencia#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
<cfelse>
	<cfquery name="rsDescrip" datasource="#session.dsn#">
		select RHCcodigo as codigo,RHCdescripcion as descripcion 
		from RHConocimientos 
		where RHCid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.idcompetencia#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
</cfif>
<title>
		<cf_translate key="LB_Historial">Historial</cf_translate>
</title>	
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td  align="center" colspan="4">
			<strong><cfif url.tipo eq 'H'><cf_translate key="LB_HistorialDeLaHabilidad">Historial de la habilidad</cf_translate><cfelse><cf_translate key="LB_HistorialDelConocimiento">Historial del conocimiento</cf_translate></cfif></strong>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="4">
			<strong><cfoutput>#rsDescrip.codigo#-#rsDescrip.descripcion#</cfoutput></strong>
		</td>
	</tr>	
	<tr>
		<td  nowrap width="15%" class="tituloListas" align="center"><strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate></strong></td>
		<td  nowrap width="15%" class="tituloListas" align="center"><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate></strong></td>
		<td  nowrap width="15%" class="tituloListas" align="right"><strong><cf_translate key="LB_Dominio">Dominio (%)</cf_translate></strong>&nbsp;&nbsp;</td>
		<td  nowrap width="45%" class="tituloListas" align="left"><strong><cf_translate key="LB_Justificacion">Justificación</cf_translate></strong></td>
	</tr>
	<tr>
		<cfif rsHistoria.recordcount gt 0>
			<cfoutput query="rsHistoria">
				<tr style="cursor:pointer;"
				class="<cfif rsHistoria.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
				onmouseover="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif rsHistoria.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
				>
					<td align="center"><cf_locale name="date" value="#rsHistoria.RHCEfdesdet#"/></td> 
					<td align="center"><cfif LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy") eq '01/01/6100'><cf_translate key="LB_Indefinida">indefinida</cf_translate><cfelse><cf_locale name="date" value="#rsHistoria.RHCEfhastat#"/></cfif></td>
					<td align="right">#LSNumberFormat(rsHistoria.RHCEdominio,'____.__')#</td>
					<td align="left">#rsHistoria.RHCEjustificacion#</td>
				</tr>
			</cfoutput>		
		<cfelse>
			<tr>
				<td  colspan="4" align="center"><strong><cf_translate key="LB_LaCompetenciaNoTieneHistoria">La competencia no tiene historia</cf_translate></strong></td>
			</tr>		
		</cfif>
	</tr>
	<tr>
		<td  align="center" colspan="4">
				<cfchart 
						xAxisTitle="#LB_Historia#"
						yAxisTitle="#LB_Dominio#"
						showborder="no"
						show3d="yes" 
						format="png"
					> 
				
					<cfchartseries 
						type="line" 
						query="rsHistoria" 
						valueColumn="RHCEdominio" 
						itemColumn="RHCEfdesde"
				
					/>
				</cfchart>
		 </td>
	</tr>		
	<tr>
		<td  align="center" colspan="4">
			<strong>-------<cf_translate key="LB_FinDeLaConsulta">Fin de la consulta</cf_translate>-------</strong>
		</td>
	</tr>	
</table>
