<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>

<cfquery name="rsCuestionariosPuesto" datasource="#session.DSN#">
	select 	coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo,
			a.RHPdescpuesto,
			(select coalesce(count(b.PCid),0 )
			from RHHabilidadesPuesto b 
			where a.RHPcodigo = b.RHPcodigo 
				and a.Ecodigo = b.Ecodigo)  as CuestionariosH,

			(select coalesce(count(RHHid),0)
			from RHHabilidadesPuesto b 
			where a.RHPcodigo = b.RHPcodigo 
				and a.Ecodigo = b.Ecodigo) as Habilidades,
	
			(select coalesce(count(coalesce(c.PCid,d.PCid)),0 )
			from RHConocimientosPuesto c  , RHConocimientos d
			where a.RHPcodigo = c.RHPcodigo 
				and c.RHCid  = d.RHCid 
				and a.Ecodigo = c.Ecodigo) as CuestionariosC,
	
			(select coalesce(count(RHCid),0) 
			from RHConocimientosPuesto c  
			where a.RHPcodigo = c.RHPcodigo 
				and a.Ecodigo = c.Ecodigo) as Conocimientos	   

	from RHPuestos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPactivo = 1
		<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
		</cfif>
		and a.RHPcodigo in ( select distinct RHPpuesto from RHPlazas p
							where  a.RHPcodigo = p.RHPpuesto 
								and a.Ecodigo = p.Ecodigo
								and p.RHPactiva = 1
								<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
									and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
								</cfif>
								<cfif isdefined("cf_lista") and len(trim(cf_lista))>
									and p.CFid in (#cf_lista#)
								</cfif>
							)
</cfquery>

<cfoutput>
	<div align="left" style=" width:640px; height:380px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="600" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td  width="10%">
				<b><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></b>
			</td>
			<td   width="50%">
				<b><cf_translate  key="LB_Puesto">Puesto</cf_translate></b>
			</td>
			<td  colspan="1" width="5%" align="center" nowrap="nowrap">
				<b><cf_translate  key="LB_Habilidad">Habilidad</cf_translate></b>
			</td>
			<td  colspan="1" width="5%" align="center" nowrap="nowrap">
				<b><cf_translate  key="LB_Conocimiento">Conocimiento</cf_translate></b>
			</td>
		</tr>

		<cfloop query="rsCuestionariosPuesto">
			<cfset LvarListaNon = (rsCuestionariosPuesto.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td>
					#trim(rsCuestionariosPuesto.RHPcodigo)#
			   </td>
				<td>
					#trim(rsCuestionariosPuesto.RHPdescpuesto)#
				</td>
				<td align="center">
					<cfif rsCuestionariosPuesto.CuestionariosH  eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  rsCuestionariosPuesto.CuestionariosH  eq rsCuestionariosPuesto.Habilidades >
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					<cfelseif  rsCuestionariosPuesto.CuestionariosH  neq rsCuestionariosPuesto.Habilidades>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif">
					</cfif>
				</td>
				<td align="center">
					<cfif rsCuestionariosPuesto.CuestionariosC  eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  rsCuestionariosPuesto.CuestionariosC  eq rsCuestionariosPuesto.Conocimientos >
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					<cfelseif  rsCuestionariosPuesto.CuestionariosC  neq rsCuestionariosPuesto.Conocimientos>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif">
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
	</div>
	<fieldset><legend>#LB_Simbologia#</legend>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<tr >
					<td width="1%">
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo1">Sin definir ( Todas las Habilidad o todas los Conocimiento no tienen asociados un Cuestionario )</cf_translate> </font></td>
				</tr>
				<tr>	
					
					<td>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo3">Inconsistencia  ( No todas las Habilidades y /o  Conocimientos tienen asociados un Cuestionario )</cf_translate></font>
					</td>
				</tr>
				<tr>	
					
					<td>
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo4">Dato Correcto  ( Todas las Habilidades y Todos los Conocimientos tienen asociados un Cuestionario )</cf_translate></font>
					</td>
				</tr>
			</table>
	</fieldset>	
</cfoutput>