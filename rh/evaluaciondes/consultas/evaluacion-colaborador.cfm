<!--- Ultima evaluacion del empleado --->
<cfquery datasource="#session.dsn#"  name="Rs_Empleados">
    select DEid from RHListaEvalDes 
    where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
    and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    <cfif isdefined("url.DEid") and len(trim(url.DEid))>
        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
    </cfif>
</cfquery>

<cf_dbtemp name="tmp_reporte2" returnvariable="tmp_reporte" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="peso" 		type="float" 	mandatory="yes">
	<cf_dbtempcol name="notaauto" 	type="float" 	mandatory="no">
	<cf_dbtempcol name="notajefe" 	type="float" 	mandatory="no">
	<cf_dbtempcol name="notaotros"	type="float" 	mandatory="no">
	<cf_dbtempcol name="notajcs" 	type="float" 	mandatory="no">
	<cf_dbtempcol name="pesototal" 	type="float" 	mandatory="no">	
</cf_dbtemp>
<cfset listaempleados = "">
<cfloop query="Rs_Empleados">
	<cfset listaempleados = listaempleados & Rs_Empleados.DEid & ','>
</cfloop>
<cfset listaempleados = listaempleados & '-1'>

<cfquery name="rsUltima"  datasource="#session.DSN#">
    select max(k.RHEEid) as RHEEid ,k.DEid
    from RHListaEvalDes k
    
    inner join RHEEvaluacionDes k1
    on k1.RHEEid=k.RHEEid
    and k1.RHEEfhasta <= (select RHEEfhasta 
                            from RHEEvaluacionDes 
                            where RHEEid = #url.RHEEid#)
    and k1.RHEEestado=3
    
    where k.RHEEid!=#url.RHEEid#
    and k.DEid in (#listaempleados#)
	
	group by k.DEid 
</cfquery>

<cfset vRHEEid_ultima = 0 >
<cfif len(trim(rsUltima.RHEEid))>
	<cfset vRHEEid_ultima = rsUltima.RHEEid >
</cfif>

<cfquery name="insertTemp" datasource="#session.DSN#">
    insert into #tmp_reporte#(DEid, peso, notaauto, notajefe, notaotros, notajcs, pesototal ) 
    select 		a.DEid,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpeso, 0)"> as RHNEDpeso,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDnotaauto, 0)"> as autoevaluacion,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDnotajefe, 0)"> as notajefe, 
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpromotros, 0)"> as notaotros,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpromJCS, 0)"> as notajcs,
                <cf_dbfunction name="to_float" args="(select sum(RHHpeso)
                 from RHHabilidadesPuesto 
                 where RHPcodigo=c.RHPcodigo
                 and Ecodigo = #session.Ecodigo# )"> as suma_pesos

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
    
    where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHEEid_ultima#">
      and a.RHHid is not null
      and a.DEid in (#listaempleados#)
</cfquery>	

<cfquery name="insertTemp" datasource="#session.DSN#">
    insert into #tmp_reporte#(DEid, peso, notaauto, notajefe, notaotros, notajcs, pesototal ) 
    select 		a.DEid,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpeso, 0)"> as RHNEDpeso,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDnotaauto, 0)"> as autoevaluacion,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDnotajefe, 0)"> as notajefe, 
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpromotros, 0)"> as notaotros,
                <cf_dbfunction name="to_float" args="coalesce(a.RHNEDpromJCS, 0)"> as notajcs,
                <cf_dbfunction name="to_float" args="(select sum(RHHpeso)
                 from RHHabilidadesPuesto 
                 where RHPcodigo=c.RHPcodigo
                 and Ecodigo = #session.Ecodigo# )"> as suma_pesos

    from RHNotasEvalDes a
    
    inner join RHListaEvalDes b
    on b.RHEEid=a.RHEEid
    and b.DEid=a.DEid
    and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    
    inner join RHConocimientosPuesto c
    on c.RHPcodigo=b.RHPcodigo
    and c.Ecodigo=b.Ecodigo
    and c.RHCid=a.RHCid
    
    inner join RHConocimientos d
    on d.Ecodigo=c.Ecodigo
    and d.RHCid=c.RHCid
    
    where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHEEid_ultima#">
      and a.RHHid is not null
      and a.DEid in (#listaempleados#)
</cfquery>	

    <cfquery name="rsNotaAnterior" datasource="#session.DSN#">
        select 	DEid,
                sum((notaauto * (peso/pesototal))) as notaauto, 
                sum((notajefe * (peso/pesototal))) as notajefe, 
                sum((notaotros * (peso/pesototal))) as notaotros,
                sum((notajcs * (peso/pesototal))) as notajcs
        from #tmp_reporte#
        group by DEid
    </cfquery>

    <cfquery datasource="#session.DSN#" name="rs" >
        select '#session.Enombre#' as empresa,
                f.RHEEdescripcion,
        
                    f.RHEEfdesde as inicio,
        
                    f.RHEEfhasta as fin,
                    {fn concat(rtrim(g.DEidentificacion),{fn concat(' - ',{fn concat(g.DEnombre,{fn concat(' ',{fn concat(g.DEapellido1,{fn concat(' ',g.DEapellido2)})})})})})} as DEidentificacion,
                    {fn concat(rtrim(coalesce(e.RHPcodigoext,e.RHPcodigo)),{fn concat(' - ',e.RHPdescpuesto)})} as RHPdescpuesto,
                    {fn concat(rtrim(d.RHHcodigo),{fn concat(' - ',d.RHHdescripcion)})}as RHHdescripcion, 
                    h.RHNcodigo, 
                    (c.RHNnotamin*100) as notamin, 
                    c.RHHid,
                    a.RHNEDpeso as RHHpeso, 
                    
                    coalesce(a.RHNEDnotaauto, 0) as autoevaluacion,
                    coalesce(a.RHNEDnotajefe, 0) as notajefe, 
                    coalesce(a.RHNEDpromotros, 0) as notaotros,
                    coalesce(a.RHNEDpromJCS, 0) as notajcs,
                    
                    coalesce(b.RHLEnotaauto, 0) as PromAuto,
                    coalesce(b.RHLEnotajefe, 0) as PromJefe, 
                    coalesce(b.RHLEpromotros, 0) as PromOtros,
                    coalesce(b.RHLEpromJCS, 0) as PromJCS,           
                    
                    <cfif len(trim(rsNotaAnterior.notajefe))>'#rsNotaAnterior.notajefe#'<cfelse>'0'</cfif> as notajefeant,
                    <cfif len(trim(rsNotaAnterior.notaauto))>'#rsNotaAnterior.notaauto#'<cfelse>'0'</cfif> as notaautoant,
                    <cfif len(trim(rsNotaAnterior.notaotros))>'#rsNotaAnterior.notaotros#'<cfelse>'0'</cfif> as promotrosant,
                    <cfif len(trim(rsNotaAnterior.notajcs))>'#rsNotaAnterior.notajcs#'<cfelse>'0'</cfif> as relativo_anterior,
    
    
                    coalesce( round((a.RHNEDnotajefe*c.RHHpeso)/100, 4), 0) as pesoobtenido,
                    coalesce( round((a.RHNEDpromotros*c.RHHpeso)/100, 4) , 0) as puntos_otros,
                    coalesce( round((a.RHNEDpromJCS*c.RHHpeso)/100, 4) , 0) as puntos_jefe_otros,
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
        
        left outer join RHHabilidadesPuesto c
        on c.RHPcodigo=b.RHPcodigo
        and c.Ecodigo=b.Ecodigo
        and c.RHHid=a.RHHid
        
        left outer join RHHabilidades d
        on d.Ecodigo=c.Ecodigo
        and d.RHHid=c.RHHid
		
	<!---	left outer join RHConocimientosPuesto c1
		on c1.RHPcodigo=b.RHPcodigo
		and c1.Ecodigo=b.Ecodigo
		and c1.RHCid=a.RHCid
		
		left outer join RHConocimientos d1
		on d1.Ecodigo=c1.Ecodigo
		and d1.RHCid=c1.RHCid--->
        
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
          and a.DEid in (#listaempleados#)
        order by g.DEidentificacion	, coalesce((a.RHNEDnotajefe+a.RHNEDpromotros)/2,0) desc 
    </cfquery>

<cfif rs.recordcount gt 0 >
	<cfreport format="#url.formato#" template="evaluacion-colaborador.cfr" query="rs"></cfreport>
<cfelse>
	<cfdocument format="#url.formato#" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
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