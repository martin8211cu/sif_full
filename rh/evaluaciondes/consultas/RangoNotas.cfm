<cfsetting requesttimeout="3600">

<!--- valida de la nota inferior sea menor a la nota superior --->
<cfif isdefined("url.n_inferior") and  isdefined("url.n_superior") and len(trim(url.n_inferior)) neq 0 and len(trim(url.n_superior)) neq 0> 
	<cfif url.n_inferior GT url.n_superior>
		<cfset temp = url.n_superior>
		<cfset url.n_superior = url.n_inferior>
		<cfset url.n_inferior = temp>
	</cfif>
</cfif>


<!--- <cfif not len(trim(url.CFid))>
	<cflocation url="evaluacion-cf-filtro.cfm">
</cfif> --->

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
			
			coalesce(avg(a.RHNEDnotajefe),0) as Jefe, 
			coalesce(avg(a.RHNEDnotaauto),0) as Auto, 
			coalesce(avg(a.RHNEDpromotros),0) as Otros,
			coalesce(sum(a.RHNEDnotajefe) 
				* 
			coalesce((
			select min(hp.RHHpeso) 
			from RHHabilidadesPuesto hp
			where hp.RHHid     = a.RHHid
			  and hp.RHPcodigo = b.RHPcodigo
			  and hp.Ecodigo   = b.Ecodigo), 0)
				/ 
			coalesce((
			select sum(hpt.RHHpeso) 
			from RHHabilidadesPuesto hpt
			where hpt.RHPcodigo = b.RHPcodigo
			  and hpt.Ecodigo   = b.Ecodigo), 1),0)
	
			as NotaJefe
	,
			coalesce(sum(a.RHNEDnotaauto)
	
				* 
	
			coalesce((
			select min(hp2.RHHpeso) 
			from RHHabilidadesPuesto hp2
			where hp2.RHHid     = a.RHHid
			  and hp2.RHPcodigo = b.RHPcodigo
			  and hp2.Ecodigo   = b.Ecodigo), 0)
	
				/ 
	
			coalesce((
			select sum(hpt2.RHHpeso) 
			from RHHabilidadesPuesto hpt2
			where hpt2.RHPcodigo = b.RHPcodigo
			  and hpt2.Ecodigo   = b.Ecodigo), 1),0)
	
			as NotaAuto
	,
			coalesce(sum(a.RHNEDpromJCS)
	
				* 
	
			coalesce((
			select min(hp3.RHHpeso) 
			from RHHabilidadesPuesto hp3
			where hp3.RHHid     = a.RHHid
			  and hp3.RHPcodigo = b.RHPcodigo
			  and hp3.Ecodigo   = b.Ecodigo), 0)
	
				/ 
	
			coalesce((
			select sum(hpt3.RHHpeso) 
			from RHHabilidadesPuesto hpt3
			where hpt3.RHPcodigo = b.RHPcodigo
			  and hpt3.Ecodigo   = b.Ecodigo), 1),0)
	
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
	  <!--- and pl.CFid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#"> --->
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
	  
	 <cfif isdefined("url.DEid")and len(trim(url.DEid))neq 0>
		and b.DEid=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	 </cfif> 

	group by e.DEidentificacion,b.RHPcodigo,e.DEnombre,e.DEapellido1,e.DEapellido2,p.RHPdescpuesto,coalesce(p.RHPcodigoext,p.RHPcodigo),a.RHHid,h.RHHdescripcion,cf.CFcodigo,cf.CFdescripcion
	,b.Ecodigo
	order by 2, 3
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

</cfquery>



<cfquery name="notas" dbtype="query">
	select DEidentificacion, 
	 	   Puesto, 
	       DEnombre,
		   DEapellido1,
		   DEapellido2,	
	 	   DescripcionPuesto,
	 	   CodigoPuesto,
		  CFcodigo,
		   CFdescripcion,
	 	   notajefe,
	 	   autoevaluacion,
	 	   notaotros
		   
	from datos
		<cfif isdefined("url.nota") and url.nota EQ 1>
			<cfif isdefined('url.n_inferior') and len(trim(url.n_inferior))neq 0>
				where notajefe >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_inferior#"> <!--- Nota inferior --->
			</cfif>
			<cfif isdefined('url.n_superior') and len(trim(url.n_superior))neq 0>
				and notajefe <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_superior#"><!--- Nota superior --->
			</cfif>	
		</cfif>
		
		<cfif isdefined("url.nota") and url.nota EQ 2>
			<cfif isdefined('url.n_mayor') and len(trim(url.n_mayor))neq 0>
				where notajefe >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_mayor#"><!--- Nota mayor que --->
			</cfif>
		</cfif>
		
		<cfif isdefined("url.nota") and url.nota EQ 3>
			<cfif isdefined('url.n_menor') and len(trim(url.n_menor))neq 0>
				where notajefe <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n_menor#"><!--- Nota menor que --->
			</cfif>
		</cfif>
</cfquery>

<!--- <cfdump  var="#notas#">
<cfabort> --->

<cfif notas.recordcount gt 0 >
	<cfreport format="#url.formato#" template="RangoNotas.cfr" query="notas">
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
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1"><cf_translate key="LB_EvaluacionDelDesempenoPorRangoDeNotas">Evaluaci&oacute;n del Desempe&ntilde;o por Rango de Notas</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros --</cf_translate></td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>