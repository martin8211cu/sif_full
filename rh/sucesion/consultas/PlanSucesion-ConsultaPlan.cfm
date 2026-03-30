<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsPuesto" datasource="#session.DSN#">
		select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,a.RHPcodigo,RHPdescpuesto , b.PSporcreq
			from RHPuestos  a
			left outer join RHPlanSucesion b   
					on a.Ecodigo = b.Ecodigo
					and a.RHPcodigo = b.RHPcodigo
		where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RHPcodigo#">
</cfquery>

<cfquery name="rsHabilidades" datasource="#session.DSN#">
	select
		coalesce(case when c.RHHid	 is null then null else Mnombre end,'No tiene cursos')  as Mnombre ,
		RHHcodigo ,b.RHHdescripcion ,RHNnotamin * 100 as RHNnotamin,RHHpeso
	from RHHabilidadesPuesto  a
	inner join RHHabilidades  b
		on a.RHHid  = b.RHHid	
		and  a.Ecodigo = b.Ecodigo	
	left outer join RHHabilidadesMaterias  c
		on b.RHHid  = c.RHHid	
		and  b.Ecodigo = c.Ecodigo	
	left outer join Materia  d
		on d.Mcodigo = c.Mcodigo 
	where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RHPcodigo#">
	order by b.RHHcodigo	
</cfquery>

<cfquery name="rsConocimientos" datasource="#session.DSN#">
	select
		coalesce(case when  c.RHCid is null then null else Mnombre end,'No tiene cursos')  as Mnombre ,
		b.RHCcodigo,b.RHCdescripcion, a.RHCnotamin * 100 as RHCnotamin,a.RHCpeso   
	from RHConocimientosPuesto a
	inner join RHConocimientos  b
		on a.RHCid = b.RHCid
		and  a.Ecodigo = b.Ecodigo
	left outer join RHConocimientosMaterias  c
		on b.RHCid = c.RHCid
		and  b.Ecodigo = c.Ecodigo	
	left outer  join Materia  d
		on d.Mcodigo = c.Mcodigo 
	where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RHPcodigo#">
	order by b.RHCcodigo
</cfquery>



	
<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Titulo"
		Default="Habilidades del Puesto"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</title>	

<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	
	
<table  width="100%"  align="center"border="0">
	<tr>
		<td  align="center" colspan="2"><font size="2"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></font></td>
	</tr>
	<tr>
		<td  align="center" colspan="2"><font size="2"><strong><cf_translate key="LB_PlanDeSucesion">Plan de Sucesi&oacute;n</cf_translate></strong></font></td>
	</tr>
	<tr>
		<td  align="center" colspan="2"><font size="2"><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></font></td>
	</tr>
	
		<tr>
			<td width="20%" align="left" ><cf_translate key="LB_CodigoPuesto">C&oacute;d. Puesto</cf_translate>:</td>
			<td width="80%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left"><cf_translate key="LB_PorcentajeRequerido">Porcentaje Requerido</cf_translate>:</td>
			<td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
		</tr>	
		<tr>
			<td align="left"><cf_translate key="LB_Requisitos">Requisitos</cf_translate></td>
		</tr>				
</table>
<table  width="100%"  align="center"border="0">
	<tr>
		<td align="left" width="50%"><strong><cf_translate key="LB_HabilidadesConductuales">Habilidades Conductuales</cf_translate> </strong></td>
		<td align="right" width="25%"><strong><cf_translate key="LB_NotaMinimaRequerida">Nota M&iacute;nima Requerida</cf_translate></strong></td>
		<td align="right" width="25%"><strong><cf_translate key="LB_PesoMinimoRequerido">Peso M&iacute;nimo Requerido</cf_translate></strong></td>
	</tr>
	<tr>
	
	<td  colspan="4" style="border-style:solid">
		<cfoutput>
		<table  width="100%"  align="center"border="0">
			<cfif rsHabilidades.recordcount gt 0>
			   <cfset CORTE = "">
				<cfloop query="rsHabilidades">
					<cfif trim(rsHabilidades.RHHcodigo) neq trim(CORTE)>
						<cfset CORTE = #trim(rsHabilidades.RHHcodigo)#>
						<tr>  
							<td width="50%"><em><strong>#rsHabilidades.RHHcodigo#-#rsHabilidades.RHHdescripcion#</strong></em></td>
							<td  align="right" width="25%">#LSNumberFormat(rsHabilidades.RHNnotamin,'____.__')#</td>
							<td  align="right" width="25%">#LSNumberFormat(rsHabilidades.RHHpeso,'____.__')#</td>
						</tr>
						<tr>
							<td  colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Cursos">Cursos</cf_translate></strong></td>
						</tr>						
					</cfif>
					<tr>
						<td  colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsHabilidades.Mnombre#</td>
					</tr>
				</cfloop>
			<cfelse>	
				<tr>
					<td  colspan="4" align="center" ><strong><cf_translate key="MSG_EstePuestoNoTieneHabilidades">Este puesto no tiene habilidades</cf_translate></strong></td>
				</tr>
			</cfif>
		</table>
		</cfoutput>
	</td>
	</tr>
</table>
<table  width="100%"  align="center"border="0">
	<tr>
		<td align="left" width="50%"><strong><cf_translate key="LB_ConocimientosTecnicos">Conocimientos T&eacute;cnicos</cf_translate> </strong></td>
		<td align="right" width="25%"><strong><cf_translate key="LB_NotaMinimaRequerida">Nota M&iacute;nima Requerida</cf_translate></strong></td>
		<td align="right" width="25%"><strong><cf_translate key="LB_PesoMinimoRequerido">Peso M&iacute;nimo Requerido</cf_translate></strong></td>
	</tr>
	<tr>
	<td  colspan="4" style="border-style:solid">
		<cfoutput>
		<table  width="100%"  align="center"border="0">
			<cfif rsConocimientos.recordcount gt 0>
			   <cfset CORTE2 = "">
				<cfloop query="rsConocimientos">
					<cfif trim(rsConocimientos.RHCcodigo) neq trim(CORTE2)>
						<cfset CORTE2 = #trim(rsConocimientos.RHCcodigo)#>
						<tr>  
							<td width="50%"><em><strong>#rsConocimientos.RHCcodigo#-#rsConocimientos.RHCdescripcion#</strong></em></td>
							<td  align="right" width="25%">#LSNumberFormat(rsConocimientos.RHCnotamin,'____.__')#</td>
							<td  align="right" width="25%">#LSNumberFormat(rsConocimientos.RHCpeso,'____.__')#</td>
						</tr>
						<tr>
							<td  colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Cursos">Cursos</cf_translate></strong></td>
						</tr>						
					</cfif>
					<cfif len(trim(rsConocimientos.recordcount)) gt 0>
					<tr>
						<td  colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsConocimientos.Mnombre#</td>
					</tr>		
					</cfif>
				</cfloop>
			<cfelse>	
				<tr>
					<td  colspan="4" align="center" ><strong><cf_translate key="MGS_EstePuestoNoTieneConocimientos">Este puesto no tiene conocimientos</cf_translate></strong></td>
				</tr>
			</cfif>
		</table>
		</cfoutput>
	</td>
	</tr>
</table>
<table  width="100%"  align="center"border="0">
	<tr>
		<td align="center" width="100%"><strong><cf_translate key="MGS_FinDelReporte" XmlFile="/rh/generales.xml">Fin del reporte</cf_translate></strong></td>
	</tr>
</table>	


	
	
