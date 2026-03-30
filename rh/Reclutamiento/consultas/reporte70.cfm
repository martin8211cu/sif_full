<cfset form.RHCconcurso = 441 >
<cfquery name="concursos" datasource="#session.DSN#" maxrows="105">
	select 	a.RHCconcurso, 
			a.RHCcodigo,
			a.RHCdescripcion,
			a.RHCfecha,
			a.RHPcodigo,
			coalesce(c.RHPcodigoext,c.RHPcodigo) as RHPcodigoext,
			a.RHCcantplazas,
			a.RHCfapertura,
			a.RHCfcierre,
			a.RHCjustificacion,
			b.CFcodigo, 
			b.CFdescripcion,
			a.RHPcodigo,
			c.RHPdescpuesto
	from RHConcursos a
	
	inner join CFuncional b
	on b.Ecodigo=a.Ecodigo
	and b.CFid=a.CFid
	
	inner join RHPuestos c
	on c.Ecodigo=a.Ecodigo
	and c.RHPcodigo=a.RHPcodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCestado>=70
	  <!---and a.RHCconcurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">--->
	order by a.RHCconcurso
</cfquery>

<!---<cfsavecontent  variable="x">--->
<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
<cf_templatecss>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
	<tr>
		<td>
			<table width="100%" cellpadding="3px" cellspacing="0">
				<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
				<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1">Concursos Finalizados</font></td></tr>
			</table>
		</td>
	</tr>

	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<cfloop query="concursos">
					<cfset LvarRHCconcurso = concursos.RHCconcurso >
					<tr><td colspan="7" style=" border-bottom-width:thin; border-bottom-style:solid; border-bottom-color:##CCCCCC; font-family:Helvetica; font-size:10; padding:6px; color:##6089A5">#trim(concursos.RHCcodigo)# - #trim(concursos.RHCdescripcion)#</td></tr>
					<tr><td>&nbsp;</td>
						<td colspan="6">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Centro Funcional:&nbsp;#concursos.CFcodigo# - #concursos.CFdescripcion#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Puesto:&nbsp;#concursos.RHPcodigoext# - #concursos.RHPdescpuesto#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Motivo:&nbsp; N/A</td>
							</tr>
							<tr>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Plazas Solicitadas:&nbsp;#concursos.RHCcantplazas#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Fecha de apertura:&nbsp; #LSDateFormat(concursos.RHCfapertura,'dd/mm/yyyy')#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Fecha de cierre:&nbsp; #LSDateFormat(concursos.RHCfcierre,'dd/mm/yyyy')#</td>
							</tr>
							<tr><td colspan="3" style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">Justificaci&oacute;n:&nbsp; <cfif len(trim(concursos.RHCjustificacion))>#concursos.RHCjustificacion#<cfelse>N/A</cfif></td></tr>
						</table>
					</td></tr>
					
					<!--- 1. PLAZAS ASOCIADAS AL CONCURSO --->					
					<cfquery name="plazas" datasource="#session.DSN#">
						select a.RHPCid, a.RHPid, b.RHPcodigo, b.RHPdescripcion
						from RHPlazasConcurso a
						
						inner join RHPlazas b
						on b.Ecodigo=a.Ecodigo
						and b.RHPid=a.RHPid
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCconcurso#">
					</cfquery>
					<tr>
						<td width="3%">&nbsp;</td>
						<td colspan="6" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##E3EDEF">Plazas Solicitadas</td>
					</tr>
					<tr>
						<td width="3%">&nbsp;</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">C&oacute;digo</td>
						<td colspan="5" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Descripci&oacute;n</td>
					</tr>

					<cfloop query="plazas">
						<tr>
							<td width="3%">&nbsp;</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#plazas.RHPcodigo#</td>
							<td colspan="5" style=" font-family:Helvetica; font-size:8; padding:8px;" >#plazas.RHPdescripcion#</td>
						</tr>
					</cfloop>

					<!--- 2. CONCURSANTES --->					
					<cfquery name="concursantes" datasource="#session.DSN#">
						select 	case a.RHCPtipo when 'I' then 'Interno' else 'Externo' end as tipo,
								a.RHCPpromedio,
								a.RHCdescalifica,
								coalesce(b.DEidentificacion, c.RHOidentificacion) as identificacion,
								coalesce(b.DEnombre, c.RHOnombre) as nombre,
								coalesce(b.DEapellido1, c.RHOapellido1) as apellido1,
								coalesce(b.DEapellido2, c.RHOapellido2) as apellido2,
								d.RHPid,
								case d.RHAestado when 10 then 'Asignado' when 20 then 'Adjudicado' else 'Evaluado' end as estado
						from RHConcursantes a
						
						left outer join DatosEmpleado b
						on b.DEid=a.DEid
						and b.Ecodigo=a.Ecodigo
						
						left outer join DatosOferentes c
						on c.RHOid=a.RHOid
						and c.Ecodigo=a.Ecodigo
						
						left outer join RHAdjudicacion d
						on d.Ecodigo=a.Ecodigo
						and d.RHCPid=a.RHCPid
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCconcurso#">
						order by  d.RHAestado desc, identificacion
					</cfquery>
					<tr>
						<td width="3%">&nbsp;</td>
						<td colspan="6" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##E3EDEF">Concursantes</td>
					</tr>
					<tr>
						<td width="3%">&nbsp;</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Identificaci&oacute;n</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Concursante</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Tipo</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Puntaje</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Estado</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">Plaza Asignada</td>
					</tr>

					<cfloop query="concursantes">
						<tr>
							<td width="3%">&nbsp;</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.identificacion#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.nombre# #concursantes.apellido1# #concursantes.apellido2#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.tipo#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.RHCPpromedio#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" ><cfif concursantes.RHCdescalifica eq 1 >Descalificado<cfelse>#concursantes.estado#</cfif></td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.RHPid#</td>
						</tr>
					</cfloop>




					
					<tr><td>&nbsp;</td></tr>
				</cfloop>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
</cfdocument>
<!---</cfsavecontent>--->

<!---
<cfoutput>
<cfdocument format="flashpaper">#x#</cfdocument>
</cfoutput>
--->



