<cfsetting requesttimeout="3600">

<cfif not len(trim(url.CFid))>
	<cflocation url="evaluacion-cf-filtro.cfm">
</cfif>

<cfquery name="rsCFuncional" datasource="#session.DSN#">
	select CFpath
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
</cfquery>
<cfset vRuta = rsCFuncional.CFpath >

<cfquery name="data" datasource="#session.DSN#">
	select RHEEdescripcion, RHEEfdesde as inicio, RHEEfhasta as fin
	from RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
</cfquery>

<cfquery name="rs" datasource="#session.DSN#" >
	select
			e.DEidentificacion, 
			b.RHPcodigo as Puesto, 
			e.DEnombre,
			e.DEapellido1,
			e.DEapellido2,
			p.RHPdescpuesto as DescripcionPuesto,
			coalesce(p.RHPcodigoext,p.RHPcodigo) as CodigoPuesto,
			a.RHHid as Habilidad,
			h.RHHdescripcion as DescHabilidad,
			cf.CFcodigo,
			cf.CFdescripcion, 
			avg(a.RHNEDnotajefe) as Jefe, 
			avg(a.RHNEDnotaauto) as Auto, 
			avg(a.RHNEDpromotros) as Otros,
			avg(a.RHNEDpromJCS) as JCS
	
	
	
	,
			coalesce(sum(a.RHNEDnotajefe) ,0)
	
				* 
	
			coalesce((
			select min(hp.RHHpeso) 
			from RHHabilidadesPuesto hp
			where hp.RHHid     = a.RHHid
			  and hp.RHPcodigo = b.RHPcodigo
			  and hp.Ecodigo   = b.Ecodigo), 0)

				/ 
	
			coalesce((
			select coalesce(sum(hpt.RHHpeso) ,0)
			from RHHabilidadesPuesto hpt
			where hpt.RHPcodigo = b.RHPcodigo
			  and hpt.Ecodigo   = b.Ecodigo), 1)
	
			as NotaJefe
	,
			coalesce(sum(a.RHNEDnotaauto),0)
	
				* 
	
			coalesce((
			select coalesce(min(hp2.RHHpeso) ,0)
			from RHHabilidadesPuesto hp2
			where hp2.RHHid     = a.RHHid
			  and hp2.RHPcodigo = b.RHPcodigo
			  and hp2.Ecodigo   = b.Ecodigo), 0)
	
				/ 
	
			coalesce((
			select sum(hpt2.RHHpeso) 
			from RHHabilidadesPuesto hpt2
			where hpt2.RHPcodigo = b.RHPcodigo
			  and hpt2.Ecodigo   = b.Ecodigo), 1)
	
			as NotaAuto
	,
			coalesce(sum(a.RHNEDpromJCS),0)
	
				* 
	
			coalesce((
			select coalesce(min(hp3.RHHpeso) ,0)
			from RHHabilidadesPuesto hp3
			where hp3.RHHid     = a.RHHid
			  and hp3.RHPcodigo = b.RHPcodigo
			  and hp3.Ecodigo   = b.Ecodigo), 0)
	
				/ 
	
			coalesce((
			select coalesce(sum(hpt3.RHHpeso) ,0)
			from RHHabilidadesPuesto hpt3
			where hpt3.RHPcodigo = b.RHPcodigo
			  and hpt3.Ecodigo   = b.Ecodigo), 1)
	
			as NotaJCS
	
	from 
		RHListaEvalDes      b, 
		DatosEmpleado       e,
		RHNotasEvalDes      a,
		RHPuestos           p,
		RHHabilidades       h,
		LineaTiempo         lt,
		RHPlazas			pl,
		CFuncional          cf
	
	where b.RHEEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">

	<cfif isdefined("url.dependencias")	>
		and ( upper(cf.CFpath) like '#ucase(vRuta)#/%' or pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">)
	<cfelse>
		and pl.CFid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfif>

	  and b.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  
	  and e.DEid       = b.DEid
	  and a.RHEEid     = b.RHEEid
	  and a.DEid       = b.DEid
	  and a.RHHid is not null
	  and p.RHPcodigo  = b.RHPcodigo 
	  and p.Ecodigo    = b.Ecodigo
	  and h.RHHid      = a.RHHid
	  and lt.Ecodigo   = b.Ecodigo
	  and lt.DEid      = b.DEid
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta  
	  and pl.RHPid     = lt.RHPid
	  and pl.Ecodigo   = lt.Ecodigo
	  and cf.CFid      = pl.CFid
	  and cf.Ecodigo   = pl.Ecodigo
	 
	group by b.Ecodigo,b.RHPcodigo, e.DEnombre, e.DEapellido1, e.DEapellido2, e.DEidentificacion, a.RHHid, h.RHHdescripcion, p.RHPdescpuesto, coalesce(p.RHPcodigoext,p.RHPcodigo), cf.CFcodigo, cf.CFdescripcion
	order by cf.CFdescripcion,e.DEidentificacion
</cfquery>

<cfquery name="datos" dbtype="query">
	select DEidentificacion, 
	 	   Puesto, 
	       DEnombre,
		   DEapellido1,
		   DEapellido2,	
	 	   DescripcionPuesto,
	 	   CodigoPuesto,
		   CFcodigo,
		   CFdescripcion,
	 	   sum(NotaJefe) as notajefe,
	 	   sum(NotaAuto) as autoevaluacion,
	 	   sum(NotaJCS) as notaotros
	from rs
	group by DEidentificacion, Puesto, DEnombre, DEapellido1, DEapellido2, DescripcionPuesto, CodigoPuesto, CFcodigo, CFdescripcion
	order by CFcodigo,CFdescripcion
</cfquery>

<cfif rs.recordcount gt 0 >
	<cfreport format="#url.formato#" template="evaluacion-cf.cfr" query="datos">
		<cfreportparam name="empresa" value="#session.Enombre#">
		<cfreportparam name="RHEEdescripcion" value="#data.RHEEdescripcion#">
		<cfreportparam name="inicio" value="#LSDateFormat(data.inicio,'dd/mm/yyyy')#">
		<cfreportparam name="fin" value="#LSDateFormat(data.fin,'dd/mm/yyyy')#">
	</cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1"><cf_translate key="LB_EvaluacionDelDesempenoPorCentroFuncional">Evaluaci&oacute;n del Desempe&ntilde;o por Centro Funcional</cf_translate></font></td></tr>
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