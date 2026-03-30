<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>

<cfquery name="rsPesoPuesto" datasource="#session.DSN#">
	select 	coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo,
			a.RHPdescpuesto,
		   (select coalesce(sum(b.RHHpeso),0 )
			from RHHabilidadesPuesto b 
			where a.RHPcodigo = b.RHPcodigo 
				and a.Ecodigo = b.Ecodigo) as pesoH,
			(select coalesce(sum(c.RHCpeso)/count(RHCid),0 )
			from RHConocimientosPuesto c 
			where a.RHPcodigo = c.RHPcodigo 
				and a.Ecodigo = c.Ecodigo) as pesoC		
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
			<td  colspan="2" width="10%" align="center" nowrap="nowrap">
				<b><cf_translate  key="LB_Habilidad">Habilidad</cf_translate></b>
			</td>
			<td  colspan="2" width="10%" align="center" nowrap="nowrap">
				<b><cf_translate  key="LB_Conocimiento">Conocimiento</cf_translate></b>
			</td>
		</tr>

		<cfloop query="rsPesoPuesto">
			<cfset LvarListaNon = (rsPesoPuesto.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td>
					#trim(rsPesoPuesto.RHPcodigo)#
			   </td>
				<td>
					#trim(rsPesoPuesto.RHPdescpuesto)#
				</td>
				<td align="right">
					#LSNumberFormat(rsPesoPuesto.pesoH,',.00')#&nbsp;%
				</td>
				<td align="center">
					<cfif rsPesoPuesto.pesoH  eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  rsPesoPuesto.pesoH  eq url.RHEid >
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					<cfelseif  rsPesoPuesto.pesoH  neq url.RHEid >
						<img border="0" src="/cfmx/rh/imagenes/stop.gif">
					</cfif>
				</td>
				<td align="right">
					#LSNumberFormat(rsPesoPuesto.pesoC,',.00')#&nbsp;%
				</td>
				<td align="center">
					<cfif rsPesoPuesto.pesoC  eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  rsPesoPuesto.pesoC  eq url.RHEid >
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					<cfelseif  rsPesoPuesto.pesoC  neq url.RHEid >
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
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo1">Sin definir</cf_translate> </font></td>
				</tr>
				<tr>	
					
					<td>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo3">Inconsistencia</cf_translate></font>
					</td>
				</tr>
				<tr>	
					
					<td>
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo4">Dato Correcto</cf_translate></font>
					</td>
				</tr>
			</table>
	</fieldset>	
</cfoutput>