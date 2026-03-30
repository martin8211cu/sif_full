<style type="text/css">
	.letra {
		font-size: 12px;
		padding:4px;
	}
</style>


<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, -1 as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>

<cfif isdefined("url.CFid") and len(trim(url.CFid)) >
	<cfif isdefined("url.dependencias") >
		<cfset cf = getCentrosFuncionalesDependientes(url.CFid) >
		<cfset cf_lista = valuelist(cf.CFid) >
	<cfelse>
		<cfset cf_lista = url.CFid >
	</cfif>
</cfif>


<cf_dbtemp name="CFCompetencia" returnvariable="CFCompetencia" datasource="#session.DSN#">
	<cf_dbtempcol name="id"     		 type="numeric"		identity="yes">
	<cf_dbtempcol name="tipo"     		 type="char(1)"     mandatory="yes">
	<cf_dbtempcol name="CFid"     		 type="numeric"     mandatory="yes">
	<cf_dbtempcol name="CFcodigo"   	 type="char(10)"    mandatory="yes">
	<cf_dbtempcol name="CFdescripcion"   type="char(60)"    mandatory="yes">
	<cf_dbtempcol name="RHHid"   		 type="numeric"    	mandatory="yes">
	<cf_dbtempcol name="RHHcodigo"   	 type="char(5)"     mandatory="yes">
	<cf_dbtempcol name="RHHdescripcion"  type="char(100)"   mandatory="yes">
	<cf_dbtempcol name="notapuesto"   	 type="integer"     mandatory="no">
	<cf_dbtempcol name="notaempleado"  	 type="integer"     mandatory="no">
	<cf_dbtempkey cols="id">
</cf_dbtemp>

<!--- Habilidades --->
<cfif (isdefined("url.tipo") and len(trim(url.tipo)) EQ 0)  OR (isdefined("url.tipo") and len(trim(url.tipo)) and url.tipo EQ 'H')>
	<cfquery name="rsReporte1" datasource="#session.DSN#">
		
		
		
		
		
		insert into #CFCompetencia# 
		(tipo,CFid,CFcodigo,CFdescripcion,RHHid,RHHcodigo,RHHdescripcion,notapuesto,notaempleado)
		select 'H', 
		c.CFid, 
		c.CFcodigo, 
		c.CFdescripcion, 
		f.RHHid, 
		f.RHHcodigo, 
		f.RHHdescripcion, 
		e.RHNnotamin*100 as notamin, 
		coalesce(g.RHCEdominio, 0.00) as RHCEdominio
		from LineaTiempo a
			inner join RHPlazas b
				on b.Ecodigo = a.Ecodigo
				and b.RHPid = a.RHPid

			inner join CFuncional c
				on c.Ecodigo = b.Ecodigo
				and c.CFid = b.CFid
	
			inner join RHPuestos d
				on d.Ecodigo = a.Ecodigo
				and d.RHPcodigo = a.RHPcodigo
		
			inner join RHHabilidadesPuesto e
				on e.Ecodigo = a.Ecodigo
				and e.RHPcodigo = a.RHPcodigo
				
		
			inner join RHHabilidades f
				on f.Ecodigo = e.Ecodigo
				and f.RHHid = e.RHHid
				
		
			inner join DatosEmpleado de
				on de.Ecodigo = a.Ecodigo
				and de.DEid = a.DEid
		
			left outer join RHCompetenciasEmpleado g
				on g.Ecodigo = a.Ecodigo
				and g.DEid = a.DEid
				
				and g.idcompetencia = f.RHHid
				
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.RHNnotamin is not null
		and g.tipo = 'H'
		and g.RHCEfdesde >= (
					select max(x.RHCEfdesde) from RHCompetenciasEmpleado x
					where x.DEid = g.DEid
					and x.Ecodigo = g.Ecodigo 
					and x.tipo = g.tipo
					and x.idcompetencia = g.idcompetencia
				)
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between a.LTdesde and a.LThasta
		<cfif isdefined("cf_lista") and len(trim(cf_lista))>
			and b.CFid in (#cf_lista#)
		</cfif>
		<cfif isdefined("url.RHHid") and len(trim(url.RHHid))>
			and f.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHHid#">
		</cfif>		
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		</cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
</cfif> 

<!--- Conocimientos --->
<cfif isdefined("url.tipo") and ( ( not len(trim(url.tipo)) ) or url.tipo eq 'C' ) >
	<cfquery datasource="#session.DSN#">
		insert into #CFCompetencia# 
		(tipo,CFid,CFcodigo,CFdescripcion,RHHid,RHHcodigo,RHHdescripcion,notapuesto,notaempleado)

		select 'C', 
		c.CFid, 
		c.CFcodigo, 
		c.CFdescripcion, 
		f.RHCid, 
		f.RHCcodigo, 
		f.RHCdescripcion, 
		e.RHCnotamin*100 as notamin, 
		coalesce(g.RHCEdominio, 0.00) as RHCEdominio
		from LineaTiempo a
			inner join RHPlazas b
				on b.Ecodigo = a.Ecodigo
				and b.RHPid = a.RHPid
			
			inner join CFuncional c
				on c.Ecodigo = b.Ecodigo
				and c.CFid = b.CFid
		
			inner join RHPuestos d
				on d.Ecodigo = a.Ecodigo
				and d.RHPcodigo = a.RHPcodigo
		
			inner join RHConocimientosPuesto e
				on e.Ecodigo = a.Ecodigo
				and e.RHPcodigo = a.RHPcodigo
				
		
			inner join RHConocimientos f
				on f.Ecodigo = e.Ecodigo
				and f.RHCid = e.RHCid
				
		
			inner join DatosEmpleado de
				on de.Ecodigo = a.Ecodigo
				and de.DEid = a.DEid
		
			left outer join RHCompetenciasEmpleado g
				on g.Ecodigo = a.Ecodigo
				and g.DEid = a.DEid
				and g.idcompetencia = f.RHCid
				
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.RHCnotamin is not null
		and g.tipo = 'C'
		and g.RHCEfdesde >= (
					select max(x.RHCEfdesde) from RHCompetenciasEmpleado x
					where x.DEid = g.DEid
					and x.Ecodigo = g.Ecodigo 
					and x.tipo = g.tipo
					and x.idcompetencia = g.idcompetencia
				)
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between a.LTdesde and a.LThasta
		<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and b.CFid in (#cf_lista#)
		 </cfif>
		<cfif isdefined("url.RHCid") and len(trim(url.RHCid))>
					and f.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
		</cfif>
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
		</cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
	</cfquery>
</cfif>
<cfquery name="data_h" datasource="#session.DSN#">
	select RHHid, RHHcodigo, RHHdescripcion, CFid, CFcodigo, count(id) as total,
			(select count(id)
			 from #CFCompetencia# a
			 where a.notaempleado < a.notapuesto
			   and a.tipo ='H'
			   and a.RHHcodigo = #CFCompetencia#.RHHcodigo
			 ) as totalGral,
			 tipo
	from #CFCompetencia#
	where notaempleado < notapuesto
	<cfif isdefined("url.Brecha") and len(trim(url.Brecha)) and url.Brecha gt 0 >
		and (notapuesto - notaempleado) >= #url.Brecha#
	</cfif>	
	and tipo ='H'
	group by RHHid, RHHcodigo, RHHdescripcion, CFid, CFcodigo,tipo
	order by totalGral desc, RHHcodigo, CFcodigo  
</cfquery>

<cfquery name="data_c" datasource="#session.DSN#">
	select RHHid, RHHcodigo, RHHdescripcion, CFid, CFcodigo, count(1) as total,
		(select count(1)
		from #CFCompetencia# a
		where a.notaempleado < a.notapuesto
		  and a.tipo ='C'
		  and a.RHHcodigo = #CFCompetencia#.RHHcodigo
		group by a.RHHcodigo
		) as totalGral,tipo
	from #CFCompetencia#
	where notaempleado < notapuesto
	<cfif isdefined("url.Brecha") and len(trim(url.Brecha)) and url.Brecha gt 0 >
		and (notapuesto - notaempleado) >= #url.Brecha#
	</cfif>		
	
	and tipo ='C'
	group by RHHid, RHHcodigo, RHHdescripcion, CFid, CFcodigo,tipo
	order by totalGral desc,RHHcodigo, CFcodigo 
</cfquery>

<cfquery name="data_cf" datasource="#session.DSN#">
	select distinct CFid, CFcodigo, CFdescripcion
	from #CFCompetencia#
	where notaempleado < notapuesto
	order by CFcodigo 
</cfquery>

<cfoutput>
<table width="100%" cellpadding="3" cellspacing="0" >
	<tr><td align="center"><font size="4"><strong>#session.Enombre#</strong></font></td></tr>
	<tr><td align="center" ><font size="4"><strong><cf_translate  key="LB_titulo">Resumen de Necesidades de Capacitaci&oacute;n</cf_translate></strong></font></td></tr>
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfquery name="filtro" datasource="#session.DSN#">
			select CFcodigo, CFdescripcion
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Centro_Funcional">Centro Funcional:</cf_translate> #trim(filtro.CFcodigo)# - #filtro.CFdescripcion#</strong></font></td>
		</tr>
		<cfif isdefined("url.dependencias")>
			<tr>
				<td align="center"><font size="2"><strong><cf_translate  key="LB_Incluye_Dependencias">Incluye Dependencias</cf_translate></strong></font></td>
			</tr>
		</cfif>
	</cfif>

	<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
		<cfquery name="filtro" datasource="#session.DSN#">
			select coalesce(ltrim(rtrim(RHPcodigoext)),ltrim(rtrim(RHPcodigo))) as RHPcodigo, RHPdescpuesto
			from RHPuestos
			where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Puesto">Puesto</cf_translate>: #trim(filtro.RHPcodigo)# - #filtro.RHPdescpuesto#</strong></font></td>
		</tr>
	</cfif>

	<cfif isdefined("url.tipo") and len(trim(url.tipo))>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Tipo">Tipo</cf_translate>: <cfif url.tipo eq 'H'>Habilidades<cfelse>Conocimientos</cfif></strong></font></td>
		</tr>
	</cfif>

	<cfif isdefined("url.RHHid") and len(trim(url.RHHid))>
		<cfquery name="filtro" datasource="#session.DSN#">
			select RHHcodigo, RHHdescripcion
			from RHHabilidades
			where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHHid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Habilidad">Habilidad</cf_translate>: #trim(filtro.RHHcodigo)# - #trim(filtro.RHHdescripcion)#</strong></font></td>
		</tr>
	</cfif>

	<cfif isdefined("url.RHCid") and len(trim(url.RHCid))>
		<cfquery name="filtro" datasource="#session.DSN#">
			select RHCcodigo, RHCdescripcion
			from RHConocimientos
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Conocimiento">Conocimiento</cf_translate>: #trim(filtro.RHCcodigo)# - #trim(filtro.RHCdescripcion)#</strong></font></td>
		</tr>
	</cfif>

	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<cfquery name="filtro" datasource="#session.DSN#">
			select 	{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )}  as nombre
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<tr>
			<td align="center"><font size="2"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>: #trim(filtro.nombre)#</strong></font></td>
		</tr>
	</cfif>
	
	<tr><td align="center"><font size="2"><strong><cf_translate  key="LB_Fecha">Fecha</cf_translate>: <cf_locale name="date" value="#now()#"/></strong></font></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

<!--- border: 1px solid gray; --->
<table width="99%" cellpadding="0" cellspacing="0" align="center">
	<tr><td align="center">
		<table width="100%" align="center" border="1" style="border-style:solid; border-collapse:collapse; border-color:gray; " cellpadding="0" cellspacing="0">
			<!---
			<tr bgcolor="#CCCCCC">
				<td class="letra" style="padding:5px; "><strong>Competencia/Centro Funcional</strong></td>
				<cfoutput query="data_cf">
					<td class="letra" style="cursor:default;" align="center" title="#trim(data_cf.CFcodigo)# - #data_cf.CFdescripcion#"><strong>#data_cf.CFcodigo#</strong></td>
				</cfoutput>
				<td class="letra" align="center" ><strong>Total</strong></td>
			</tr>
			--->
			<cfloop list="data_h,data_c" index="q">
				<cfset data = evaluate(q)>
				<tr bgcolor="#CCCCCC">
					<td class="letra" ><strong><cfif q eq 'data_h'><cf_translate  key="LB_Habilidad">Habilidad</cf_translate><cfelse><cf_translate  key="LB_Conocimiento">Conocimiento</cf_translate></cfif>/<cf_translate  key="LB_Centro_uncional">Centro Funcional</cf_translate></strong></td>
					<cfoutput query="data_cf">
						<td class="letra" style="cursor:default;" align="center" title="#trim(data_cf.CFcodigo)# - #data_cf.CFdescripcion#"><strong>#data_cf.CFcodigo#</strong></td>
					</cfoutput>
					<td class="letra" align="center" ><strong><cf_translate  key="LB_Total">Total</cf_translate></strong></td>
				</tr>
				<cfset i = 0 >
				<cfif data.recordcount gt 0>
					<cfoutput query="data" group="RHHcodigo">
						<cfset _total = 0 >
						<cfset competencia = data.RHHid>
						<tr class="<cfif i mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif i mod 2>listaNon<cfelse>listaPar</cfif>';">
							<td  style="cursor:pointer" class="letra" onclick="javascript:detalle(#data.RHHid#,'#data.tipo#')">#trim(data.RHHcodigo)# - #trim(data.RHHdescripcion)#</td>
							<cfloop query="data_cf">
								<cfquery name="data_total" dbtype="query">
									select total 
									from data
									where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_cf.CFid#">
									  and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#competencia#">
								</cfquery>
								<td align="center" class="letra">
									<cfif len(trim(data_total.total))>
										#data_total.total#
										<cfset _total = _total + data_total.total >
									<cfelse>-
									</cfif>
								</td>
							</cfloop>
							<td align="center" class="letra"><strong>#_total#</strong></td>
						</tr>
						<cfset i = i+1 >
					</cfoutput>
				<cfelse>
					<tr><td colspan="2" align="center" class="letra"><cf_translate  key="LB_Noseencontraronregistros">No se encontraron registros</cf_translate></td></tr>
				</cfif>
			</cfloop>
		</table>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="#data_cf.recordcount+1#" align="center" class="letra" >--- <cf_translate  key="LB_FindelReporte">Fin del Reporte</cf_translate> ---</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
<cfoutput>
	<script language="javascript1.2" type="text/javascript">
	
		function detalle(llave,tipo){
			
			var parametros = ''
			parametros = parametros + '&tipo=' + tipo;
			if ( tipo != 'H' ){
				parametros = parametros + '&RHCid=' + llave;
			}
			else{
				parametros = parametros + '&RHHid='  + llave;
			}
			<cfif isdefined("url.Brecha") and len(trim(url.Brecha))>
				 parametros = parametros + '&Brecha=#url.Brecha#';
			</cfif>
			<cfif isdefined("url.CFid") and len(trim(url.CFid))>
				parametros = parametros + '&CFid=#url.CFid#'; 
			</cfif>
			<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
				 parametros = parametros + '&RHPcodigo=#url.RHPcodigo#';
			</cfif>
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				 parametros = parametros + '&DEid=#url.DEid#'; 
			</cfif>
			<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
				 parametros = parametros + '&dependencias=#url.dependencias#';
			</cfif>
			<cfif isdefined("url.formato") and len(trim(url.formato))>
				 parametros = parametros + '&formato=#url.formato#';
			</cfif>			
			
			location.href="brechas-detalle.cfm?1=1"+parametros;
		}
	</script>
</cfoutput>