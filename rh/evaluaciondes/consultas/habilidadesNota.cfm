<!--- valida de la nota inferior sea menor a la nota superior --->
<cfif isdefined("url.n_inferior") and  isdefined("url.n_superior") and len(trim(url.n_inferior)) neq 0 and len(trim(url.n_superior)) neq 0> 
	<cfif url.n_inferior GT url.n_superior>
		<cfset temp = url.n_superior>
		<cfset url.n_superior = url.n_inferior>
		<cfset url.n_inferior = temp>
	</cfif>
</cfif>


<cfquery name="rs" datasource="#session.DSN#">
	select '#session.Enombre#' as empresa,
			f.RHEEdescripcion,
				a.RHHid,
				f.RHEEfdesde as inicio,
				0 as notaautoant,
				0 as promotrosant,
				0 as relativo_anterior,
				0 as PromAuto,
				0 as PromJefe,
				0 as PromOtros,
				0 as PromJCS, 
				f.RHEEfhasta as fin,
				{fn concat(rtrim(g.DEidentificacion),{fn concat(' - ',{fn concat(g.DEnombre,{fn concat(' ',{fn concat(g.DEapellido1,{fn concat(' ',g.DEapellido2)})})})})})} as DEidentificacion,
				{fn concat(rtrim(coalesce(e.RHPcodigoext,e.RHPcodigo)), {fn concat(' - ',e.RHPdescpuesto)})} as RHPdescpuesto,
				{fn concat(rtrim(d.RHHcodigo),{fn concat(' - ',d.RHHdescripcion)})} as RHHdescripcion,
				h.RHNcodigo, 
				(c.RHNnotamin*100) as notamin, 
				c.RHHpeso, 
				coalesce(a.RHNEDnotaauto, 0) as autoevaluacion,
				coalesce(a.RHNEDnotajefe, 0) as notajefe, 
				coalesce(a.RHNEDpromotros, 0) as notaotros,
				coalesce(a.RHNEDpromJCS,0) as notajcs,
				 coalesce(( select z.RHLEnotajefe 
							from RHEEvaluacionDes x, RHListaEvalDes z 
							where x.RHEEid = z.RHEEid 
							  and z.DEid = b.DEid 
							  and x.RHEEfdesde = (select max(j.RHEEfdesde) from RHEEvaluacionDes j where j.RHEEid != b.RHEEid and j.RHEEestado = 3)
							  and x.RHEEid = (select max(k.RHEEid) from RHEEvaluacionDes k where k.RHEEid != b.RHEEid and k.RHEEestado = 3)
							),0.00) as notajefeant,
				coalesce((a.RHNEDnotajefe*c.RHHpeso)/100, 0) as pesoobtenido,
				coalesce((a.RHNEDpromotros*c.RHHpeso)/100, 0) as puntos_otros,
				coalesce(a.RHNEDpromJCS, 0)  as puntos_jefe_otros,
				case when a.RHNEDpromJCS < (c.RHNnotamin*100) then '*' else '' end as paso,
				(select sum(RHHpeso)
				 from RHHabilidadesPuesto 
				 where RHPcodigo=c.RHPcodigo
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> ) as suma_pesos

	from RHNotasEvalDes a
	
	inner join RHListaEvalDes b
	on b.RHEEid=a.RHEEid
	and b.DEid=a.DEid
	and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	
	inner join RHHabilidadesPuesto c
	on c.RHPcodigo=b.RHPcodigo
	and c.Ecodigo=b.Ecodigo
	and c.RHHid=a.RHHid
	
	inner join RHHabilidades d
	on d.Ecodigo=c.Ecodigo
	and d.RHHid=c.RHHid
	
	inner join RHPuestos e
	on e.Ecodigo=c.Ecodigo
	and e.RHPcodigo=c.RHPcodigo
	
	inner join RHEEvaluacionDes f
	on f.RHEEid=b.RHEEid
	and f.Ecodigo=b.Ecodigo
	and f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	
	inner join DatosEmpleado g
	on g.DEid=b.DEid
	and g.Ecodigo=b.Ecodigo
	
	left outer join RHNiveles h
	on h.RHNid=c.RHNid
	and h.Ecodigo=c.Ecodigo
	
	where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
	  and a.RHHid is not null
	  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	  	
		<cfif isdefined("url.nota") and url.nota EQ 1>
			<cfif isdefined('url.n_inferior') and len(trim(url.n_inferior))neq 0>
				and coalesce(a.RHNEDnotajefe, 0) >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_inferior#"><!--- Nota inferior --->
			</cfif>
			<cfif isdefined('url.n_superior') and len(trim(url.n_superior))neq 0>
				and coalesce(a.RHNEDnotajefe, 0) <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_superior#"><!--- Nota superior --->
			</cfif>	
		</cfif>
		
		<cfif isdefined("url.nota") and url.nota EQ 2>
			<cfif isdefined('url.n_mayor') and len(trim(url.n_mayor))neq 0>
				and coalesce(a.RHNEDnotajefe, 0) >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_mayor#"><!--- Nota mayor que --->
			</cfif>
		</cfif>
		
		<cfif isdefined("url.nota") and url.nota EQ 3>
			<cfif isdefined('url.n_menor') and len(trim(url.n_menor))neq 0>
				and coalesce(a.RHNEDnotajefe, 0) <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_menor#"><!--- Nota menor que --->
			</cfif>
		</cfif>
		
	order by g.DEidentificacion	  
</cfquery>

<cfif rs.recordcount gt 0 >
	<cfreport format="#url.formato#" template="evaluacion-colaborador.cfr" query="rs"></cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1"><cf_translate key="LB_EvaluacionDelDesempenoPorColaborador">Evaluaci&oacute;n del Desempe&ntilde;o por Colaborador</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>