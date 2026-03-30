<cfsetting requesttimeout="3600">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!-------- preparacion de datos-------------->
<cfset empresas="0">
<cfif IsJSON(form.jtreeJsonFormat) and form.jtreejsonformat neq 0 >
    <cfset arrayCorporativo = DeserializeJSON(form.jtreeJsonFormat)>
    <cfif isArray(arrayCorporativo) and arrayLen(arrayCorporativo)> 
        <cfset arrayCorporativo = arrayCorporativo[1]['values']>
        <cfloop array="#arrayCorporativo#" index="i">
            <cfset empresas = listAppend(empresas,i.key)>   
        </cfloop>
     </cfif>
     <cfset form.jtreeJsonFormat = empresas>  
</cfif>
<cfif not len(trim(form.jtreeJsonFormat))>
    <cfset form.jtreeJsonFormat = 0 >
</cfif>

<cfif isdefined("form.CFid")>
	<cfif isDefined("form.incluirdependencias") and len(trim(form.CFid)) and listlen(form.CFid) eq 1>
		<cfquery datasource="#session.dsn#" name="rsPath">
			select CFpath from CFuncional where CFid = #form.CFid#
		</cfquery>
		<cfquery datasource="#session.dsn#" name="rsQueryCFid">
			select CFid,CFpath from CFuncional
			where CFpath like '#rsPath.CFpath#%'
			and Ecodigo in (
								<cfif not isDefined("form.esCorporativo")>
									 #session.Ecodigo#
								<cfelse>	
										<cfif form.jtreeJsonFormat neq 0>
											#form.jtreeJsonFormat#
										<cfelse>
												select e.Ecodigo
												from Empresas e
												where  cliente_empresarial=#session.CEcodigo#
										</cfif>
								</cfif>
						)
		</cfquery>
		<cfset form.CFid = valueList(rsQueryCFid.CFid)>
	</cfif>
</cfif>	



<cfinvoke key="LB_CentroFuncional" default="Centro Funcional" returnvariable="CentroFuncional" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>

<cfinvoke key="LB_Activa" default="Activa" returnvariable="LB_Activa" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Inactiva" default="Inactiva" returnvariable="LB_Inactiva" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Estado" default="Estado" returnvariable="LB_Estado" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>


<cfinvoke key="LB_ConsultaPlazas" default="Consulta de Plazas" returnvariable="LB_ConsultaPlazas" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConsultaPlazasxCF" default="Consulta de Plazas por Centro Funcional" returnvariable="LB_ConsultaPlazasxCF" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>

<cfinvoke key="LB_Identificacion" default="Identificación" returnvariable="LB_Identificacion" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Cedula" default="Cédula" returnvariable="LB_Cedula" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Puesto" default="Puesto" returnvariable="LB_Puesto" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Fechas" default="Fechas" returnvariable="LB_Fechas" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Plazas" default="Plazas" returnvariable="LB_Plazas" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Plaza" default="Plaza" returnvariable="LB_Plaza" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_PorcentajeDeOcupacion" default="Porcentaje de Ocupación" returnvariable="LB_PorcentajeDeOcupacion" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Porcentaje"  			default="Porcentaje" returnvariable="LB_Porcentaje" xmlFile="/rh/generales.xml" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="Plaza" default="Plaza" returnvariable="Plaza" component="sif.Componentes.Translate"  method="Translate"/> 
<cfinvoke key="LB_Empresa" default="Empresa" returnvariable="LB_Empresa" component="sif.Componentes.Translate"  method="Translate"  xmlFile="/rh/generales.xml"/> 

<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="consultaPlazas.cfm"
		FileName="consultaPlazas.xls">

<cfif isDefined("form.agruparPorCF") >
	<cfset LvCols = 7>
	<cfset LvarTitulo = #LB_ConsultaPlazasxCF#>
<cfelse>
	<cfset LvCols = 9>
	<cfset LvarTitulo = #LB_ConsultaPlazas#>
</cfif>

<cfset filtro2 = ''>
<cfif isDefined("form.RHPcodigo") and len(form.RHPcodigo)>
	<cfset filtro2 = Plaza&':  #form.RHPcodigo#'>
</cfif>
	
<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinvoke key="CentroFuncional" default="<b>Centro Funcional</b>" returnvariable="CentroFuncional" component="sif.Componentes.Translate"  method="Translate"/>
				<cfinvoke key="Plaza" default="<b>Plaza</b>" returnvariable="Plaza" component="sif.Componentes.Translate"  method="Translate"/>
				<cfset filtro1 = CentroFuncional&': #form.CFdescripcion#'>
				<cfset filtro2 = Plaza&':  #form.RHPcodigo#'>
					<cf_EncReporte
					Titulo="#LvarTitulo#"
					Color="##E3EDEF"
					filtro1="#filtro1#"
					filtro2="#filtro2#"
					Cols= "#LvCols#">
			</td>
		</tr>
	</table>
</cfoutput>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2114" default="" returnvariable="LvarNota"/>
	
<!------- PROCESO ANTERIOR (AGRUPADO POR CENTRO FUNCIONAL) ---------------->

<cf_translatedata tabla="CFuncional"col="CFdescripcion" 	name="get" returnvariable="LvarCFdescripcion"/>
<cf_translatedata tabla="RHPlazas" 	col="p.RHPdescripcion" 	name="get" returnvariable="LvarRHPdescripcion"/>
<cf_translatedata tabla="RHPuestos" col="pp.RHPdescpuesto" 	name="get" returnvariable="LvarRHPdescpuesto"/>
<cf_translatedata tabla="Empresas" 	col="e.Edescripcion" 	name="get" returnvariable="LvarEdescripcion"/>

<cfif isDefined("form.agruparPorCF")>
	<cfquery name="rsSQLC" datasource="#session.dsn#">
		select c.CFid,c.CFcodigo,#LvarCFdescripcion# as CFdescripcion, #LvarEdescripcion# as Edescripcion,p.Ecodigo
		from Empresas e
			inner join RHPlazas p
				on p.Ecodigo = e.Ecodigo
			left join LineaTiempo l
				on p.RHPid=l.RHPid
					and p.Ecodigo=l.Ecodigo
					and <cf_dbfunction name="today"> between LTdesde and LThasta
    		inner join CFuncional c
				on p.CFid=c.CFid
				and p.Ecodigo=c.Ecodigo
			on p.RHPid=l.RHPid
			and p.Ecodigo=l.Ecodigo
			where #now()# between LTdesde and LThasta
			and l.Ecodigo=p.Ecodigo
			and c.Ecodigo=p.Ecodigo
			and p.Ecodigo=#session.Ecodigo#
         	<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
				and p.RHPid=#form.RHPid#
			</cfif>
			<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
				and p.CFid in( #form.CFid#)
			</cfif>
			<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
				and p.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPpuesto#">
			</cfif>

			<cfif isdefined('form.estado') and len(trim(form.estado)) gt 0>
				and p.RHPactiva = <cfif form.estado eq 1>1<cfelse>0</cfif>
			</cfif>
			group by c.CFid,c.CFcodigo,c.CFdescripcion,#LvarEdescripcion#,p.Ecodigo
				<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
					,c.CFdescripcion_#session.idioma#
				</cfif>
			order by #LvarEdescripcion#,#LvarCFdescripcion#
	</cfquery>

	<table width="100%" align="center" cellpadding="5" cellspacing="5" border="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="3" style="font-size:16px">Lista de Plazas por Centro Funcional</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table> 
	<cf_translatedata tabla="RHPlazas" col="p.RHPdescripcion" name="get" returnvariable="LvarRHPdescripcion"/>
	<cf_translatedata tabla="RHPuestos" col="pp.RHPdescpuesto" name="get" returnvariable="LvarRHPdescpuesto"/>

<cfloop query="rsSQLC">
	<cfflush interval="64">
	<table bordercolor="000000"  align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<cfoutput><td colspan="5" bgcolor="999999"><strong>Centro Funcional:</strong>#rsSQLC.CFcodigo#-#rsSQLC.CFdescripcion#</td></cfoutput>
		</tr>		
		<cfquery name="rsSQLP" datasource="#session.dsn#">
				select p.RHPid,p.RHPcodigo,p.RHPdescripcion,c.CFid,
				c.CFcodigo,c.CFdescripcion,coalesce(p.RHPporcentaje,100) as RHPporcentaje
			from LineaTiempo l
				inner join RHPlazas p
					inner join CFuncional c
					on p.CFid=c.CFid
					and p.Ecodigo=c.Ecodigo
					and p.Ecodigo=#session.Ecodigo#
				on p.RHPid=l.RHPid
				and p.Ecodigo=l.Ecodigo
				where #now()# between LTdesde and LThasta
				and p.Ecodigo=l.Ecodigo
				and p.Ecodigo=c.Ecodigo
				and p.Ecodigo=#session.Ecodigo#
				<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
					and p.RHPid=#form.RHPid#
				</cfif>
				<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
					and p.CFid =#rsSQLC.CFid#
				</cfif>
				group by p.RHPid,p.RHPcodigo,p.RHPdescripcion,c.CFid,
				c.CFcodigo,c.CFdescripcion,RHPporcentaje
		</cfquery>


		<cfloop query="rsSQLP">
		<tr bgcolor="CCCCCC">
			<cfoutput>
			<td bgcolor="CCCCCC"><strong>Plazas:</strong>#rsSQLP.RHPcodigo#-#rsSQLP.RHPdescripcion#</td>
			<td bgcolor="CCCCCC" colspan="5"><strong>Porcentaje:</strong>#rsSQLP.RHPporcentaje#%</td>
			</cfoutput>
		</tr>		
		

			<cfquery name="rsSQL" datasource="#session.dsn#">
					select pp.RHPcodigo as codP,p.RHPcodigo,#LvarRHPdescripcion# as RHPdescripcion,#LvarRHPdescpuesto# as RHPdescpuesto,c.CFid,l.LTdesde,l.LThasta,
						 d.DEidentificacion,d.DEnombre,d.DEapellido1,d.DEapellido2,c.CFcodigo,#LvarCFdescripcion# as CFdescripcion,coalesce(l.LTporcplaza,0) as LTporcplaza ,coalesce(p.RHPporcentaje,100) as RHPporcentaje,
						 coalesce(DEnombre,' ')#LvarCNCT# ' ' #LvarCNCT# coalesce(DEapellido1, ' ')  #LvarCNCT# ' ' #LvarCNCT# coalesce(DEapellido2,' ') as Nombre
						 , Case when coalesce(p.RHPactiva,0) = 0 then '#LB_Inactiva#'
						 	else
						 		'#LB_Activa#'
						 	end as Estado
					from RHPlazas p
						left join LineaTiempo l
							inner join DatosEmpleado d
								on d.DEid=l.DEid
									and d.Ecodigo=l.Ecodigo
							on p.RHPid=l.RHPid
								and p.Ecodigo=l.Ecodigo
								and <cf_dbfunction name="today"> between LTdesde and LThasta
						inner join RHPuestos pp
							on pp.RHPcodigo=p.RHPpuesto
								and pp.Ecodigo=p.Ecodigo
						inner join CFuncional c
						on p.CFid=c.CFid
						and p.Ecodigo=c.Ecodigo
					on p.RHPid=l.RHPid
					and p.Ecodigo=l.Ecodigo
					and p.Ecodigo=#session.Ecodigo#
					and l.RHPid=#rsSQLP.RHPid#
					inner join DatosEmpleado d
					on d.DEid=l.DEid
					and d.Ecodigo=l.Ecodigo
					where #now()# between LTdesde and LThasta
					and p.Ecodigo=l.Ecodigo
					and p.Ecodigo=pp.Ecodigo
					and c.Ecodigo=l.Ecodigo
					and d.Ecodigo=l.Ecodigo
					and p.Ecodigo=#session.Ecodigo#
					<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
						and p.RHPid=#form.RHPid#
					</cfif>
					<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
						and p.CFid  =#rsSQLC.CFid#
					</cfif>
						<cfif isdefined('form.estado') and len(trim(form.estado)) gt 0>
							and p.RHPactiva = <cfif form.estado eq 1>1<cfelse>0</cfif>
						</cfif>
						<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
							and p.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPpuesto#">
						</cfif>
						order by p.RHPcodigo
				</cfquery>
			<tr>
				<td><strong>Cédula</strong></td>
				<td><strong>Nombre</strong></td>	
				<td><strong>Puesto</strong></td>
				<td><strong>Fechas</strong></td>
				<td><strong>Porcentaje de Ocupación</strong></td>
			</tr>
					
			<tr>
				<td colspan="9"><hr /></td>
			</tr>
	
			<cfloop query="rsSQL">
				<tr <cfif CurrentRow MOD 2> class="listaNon"<cfelse>class="listaPar"</cfif>>
					<cfoutput>
							<td>#rsSQLC.Edescripcion#</td>
							<td>#rsSQLC.CFcodigo#-#rsSQLC.CFdescripcion#</td>
							<td>#rsSQLP.RHPcodigo#-#rsSQLP.RHPdescripcion#</td>
							<td>#rsSQL.Estado#</td>
							<td>#rsSQLP.RHPporcentaje#%</td>
					<td>#rsSQL.DEidentificacion#</td>
					<td>#rsSQL.Nombre#</td>				
					<td>#rsSQL.codP#-#rsSQL.RHPdescpuesto#</td>
					<td>#LSDateFormat(rsSQL.LTdesde,'DD/MM/YYYY')#-#LSDateFormat(rsSQL.LThasta,'DD/MM/YYYY')#</td>
					<td  align="right">#rsSQL.LTporcplaza#%</td>
					</cfoutput>
				</tr>				
			</cfloop>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>	
		</cfloop>
		</table>
<cfelse><!--------- proceso no agrupado-------->
	<cfquery name="rsSQLC" datasource="#session.dsn#">
		select #LvarEdescripcion# as Edescripcion,c.CFid,c.CFcodigo,#LvarCFdescripcion# as CFdescripcion,
				p.RHPid,p.RHPcodigo,#LvarRHPdescripcion# as RHPdescripcion,
				coalesce(p.RHPporcentaje,100) as RHPporcentaje,
				pp.RHPcodigo as codP,#LvarRHPdescpuesto# as RHPdescpuesto,
				l.LTdesde, l.LThasta, coalesce(l.LTporcplaza,0) as LTporcplaza,
				d.DEidentificacion,d.DEnombre,d.DEapellido1,d.DEapellido2, coalesce(p.RHPporcentaje,100) as RHPporcentaje
				, Case when coalesce(p.RHPactiva,0) = 0 then '#LB_Inactiva#'
			 	else
			 		'#LB_Activa#'
			 	end as Estado
			 	,d.DEidentificacion
		from RHPlazas p
		left join LineaTiempo l
			inner join DatosEmpleado d
				on l.DEid=d.DEid
			on p.RHPid=l.RHPid
				and <cf_dbfunction name="today"> between l.LTdesde and l.LThasta	

		inner join Empresas e
			on e.Ecodigo = p.Ecodigo
   		inner join CFuncional c
			on p.CFid=c.CFid
		inner join RHPuestos pp
			on pp.RHPcodigo=p.RHPpuesto
				and pp.Ecodigo=p.Ecodigo
				
		where p.Ecodigo in (
								<cfif not isDefined("form.esCorporativo")>
									 #session.Ecodigo#
								<cfelse>	
										<cfif form.jtreeJsonFormat neq 0>
											#form.jtreeJsonFormat#
										<cfelse>
												select e.Ecodigo
												from Empresas e
												where  cliente_empresarial=#session.CEcodigo#
										</cfif>
								</cfif>
						)
						

         	<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
				and ltrim(rtrim(p.RHPcodigo))='#trim(form.RHPcodigo)#'
			</cfif>
			<cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
				and p.CFid in( #form.CFid#)
			</cfif>
 			<cfif isdefined('form.estado') and len(trim(form.estado)) gt 0>
				and p.RHPactiva = <cfif form.estado eq 1>1<cfelse>0</cfif>
			</cfif>
			<cfif isdefined("form.RHPpuesto") and Len(Trim(form.RHPpuesto))>
				and p.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPpuesto#">
			</cfif>

		order by <cfif form.orderby eq 1>
					p.RHPcodigo
				 <cfelseif form.orderby eq 2>
				 	#LvarRHPdescripcion#
				 <cfelseif form.orderby eq 3>
				 	#LvarCFdescripcion#,#LvarEdescripcion#
				 <cfelseif form.orderby eq 4>
				 	#LvarEdescripcion#,#LvarCFdescripcion#
				 </cfif>	
	</cfquery>
 	
 	<cf_templatecss>
 
	<table width="100%" align="center" cellpadding="5" cellspacing="5" border="0" class="reporte">
		<thead>
			<tr>
				<th><cf_translate key="LB_Empresa" xmlFile="/rh/generales.xml">Empresa</cf_translate></th>
				<th><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate></th>
				<th><cf_translate key="LB_Codigo" xmlFile="/rh/generales.xml">Código</cf_translate></th>
				<th><cf_translate key="LB_NombreDePlaza" xmlFile="/rh/generales.xml">Nombre Plaza</cf_translate></th>
				<th><cfoutput><strong>#LB_Estado#</strong></cfoutput></th>
				<th><cfoutput><strong>#LB_Porcentaje#</strong></cfoutput></th>
				<th><cfoutput><strong>#LB_Identificacion#</strong></cfoutput></th>
				<th><cf_translate key="LB_Apellido1" xmlFile="/rh/generales.xml">Prim. Apellido</cf_translate></th>
				<th><cf_translate key="LB_Apellido2" xmlFile="/rh/generales.xml">Seg. Apellido</cf_translate></th>
				<th><cf_translate key="LB_Nombre" xmlFile="/rh/generales.xml">Nombre</cf_translate></th>
				<th><cfoutput><strong>#LB_PorcentajeDeOcupacion#</strong></cfoutput></th>				
				<th><cf_translate key="LB_CodigoPuesto" xmlFile="/rh/generales.xml">Código Puesto</cf_translate></th>
				<th><cf_translate key="LB_DescripcionPuesto" xmlFile="/rh/generales.xml">Descripción del Puesto</cf_translate></th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="rsSQLC">
			<tr>
				<td>#Edescripcion#</td>
				<td>#CFcodigo# - #CFdescripcion#</td>
				<td>#RHPcodigo#</td>
				<td>#RHPdescripcion#</td>
				<td>#Estado#</td>
				<td>#RHPporcentaje#%</td>
				<td>#DEidentificacion#</td>
				<td>#DEapellido1#</td>
				<td>#DEapellido2#</td>
				<td>#DEnombre#</td>
				<td>#LTporcplaza#%</td>
				<td>#codP#</td>
				<td>#RHPdescpuesto#</td>
			</tr>
		</cfoutput>
		</tbody>
	</table> 
</cfif>	

