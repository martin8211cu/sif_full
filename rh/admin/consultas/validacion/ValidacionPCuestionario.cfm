<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="LB_Simbologia" Default="Simbolog&iacute;a" returnvariable="LB_Simbologia"/>

<cfquery name="rsCH" datasource="#session.DSN#">
	select 	coalesce(b.RHHpeso,0) as PesoHabilidad, 			
			coalesce(
						(select sum(<cf_dbfunction name="to_number" args="d.PPvalor">)
						from PortalCuestionario c
							inner join PortalPregunta d
								on c.PCid = d.PCid
								and c.PCid = b.PCid
						)
			 		,0)as PesoCuest,
			coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo,			
			a.RHPdescpuesto,
			c.RHHcodigo,
			c.RHHdescripcion
	from RHPuestos a
		inner join RHHabilidadesPuesto b
			on a.RHPcodigo = b.RHPcodigo 
			and a.Ecodigo = b.Ecodigo
		inner join RHHabilidades c
			on b.RHHid = c.RHHid
			and b.Ecodigo = c.Ecodigo			
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
	order by a.RHPcodigo					
</cfquery>

<cfquery name="rsCuestionariosHabilidad" dbtype="query">
	select *
	from rsCH
	where PesoHabilidad != PesoCuest
</cfquery>

<div align="left" style=" width:640px; height:380px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="600" border="0" cellspacing="0" cellpadding="0">
		<tr bgcolor="#999999">
			<td width="2%">&nbsp;</td>
			<td width="10%"><b><cf_translate  key="LB_CodigoHabilidad">C&oacute;digo</cf_translate></b></td>
			<td width="80%"><b><cf_translate  key="LB_Habilidad">Habilidad</cf_translate></b></td>
			<td width="1%">&nbsp;</td>
		</tr>	
		<cfif rsCuestionariosHabilidad.RecordCount NEQ 0>
			<cfoutput query="rsCuestionariosHabilidad" group="RHPcodigo">
				<tr bgcolor="##CCCCCC">				
					<td colspan="4">#trim(rsCuestionariosHabilidad.RHPcodigo)# - #trim(rsCuestionariosHabilidad.RHPdescpuesto)#</td>
				</tr>
				<cfoutput>
					<cfset LvarListaNon = (rsCuestionariosHabilidad.CurrentRow MOD 2)>
					<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
					<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
						<td width="2%">&nbsp;</td>
						<td valign="top">#trim(rsCuestionariosHabilidad.RHHcodigo)#</td>
						<td valign="top">#trim(rsCuestionariosHabilidad.RHHdescripcion)#</td>
						<td align="center">					
							<img border="0" src="/cfmx/rh/imagenes/w-close.gif">							
							<!----<cfif rsCuestionariosHabilidad.PesoHabilidad  NEQ rsCuestionariosHabilidad.PesoCuest>
								<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
							<cfelseif  rsCuestionariosHabilidad.PesoHabilidad  EQ rsCuestionariosHabilidad.PesoCuest >
								<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
							</cfif>----->
						</td>					
					</tr>
				</cfoutput>
			</cfoutput>
		<cfelse>
			<tr><td colspan="4" align="center">
				<b>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</b>
			</td></tr>
		</cfif>
	</table>
</div>
<cfoutput>
	<fieldset><legend>#LB_Simbologia#</legend>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<tr>
					<td width="1%">
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo1">Sin definir ( El peso de la habilidad no es igual a los valores del cuestionario )</cf_translate> </font>
					</td>
				</tr>
				<!----
				<tr>						
					<td>
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
					</td>
					<td>
						<font  style="font-size:10px"><cf_translate  key="LB_simbolo4">Dato Correcto  ( El peso de la habilidad es igual a los valores del cuestionario )</cf_translate></font>
					</td>
				</tr>				
				----->
			</table>
	</fieldset>	
</cfoutput>