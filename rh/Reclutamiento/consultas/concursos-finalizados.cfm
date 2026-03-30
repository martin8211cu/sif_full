<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConcursosFinalizados"
	Default="Concursos Finalizados"
	returnvariable="LB_ConcursosFinalizados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concurso"
	Default="Concurso"
	returnvariable="LB_Concurso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CentroFuncional"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Motivo"
	Default="Motivo"
	returnvariable="LB_Motivo"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PlazasSolicitadas"
	Default="Plazas Solicitadas"
	returnvariable="LB_PlazasSolicitadas"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeApertura"
	Default="Fecha de apertura"
	returnvariable="LB_FechaDeApertura"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeCierre"
	Default="Fecha de cierre"
	returnvariable="LB_FechaDeCierre"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion"
	Default="Justificaci&oacute;n"
	returnvariable="LB_Justificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NA"
	Default="N/A"
	returnvariable="LB_NA"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concursante"
	Default="Concursante"
	returnvariable="LB_Concursante"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo"
	Default="Tipo"
	returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puntaje"
	Default="Puntaje"
	returnvariable="LB_Puntaje"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PlazaAsignada"
	Default="Plaza Asignada"
	returnvariable="LB_PlazaAsignada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concursantes"
	Default="Concursantes"
	returnvariable="LB_Concursantes"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno" xmlFile="/rh/generales.xml"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo" xmlFile="/rh/generales.xml"
	returnvariable="LB_Externo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Asignado"
	Default="Asignado" xmlFile="/rh/generales.xml"
	returnvariable="LB_Asignado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Adjudicado"
	Default="Adjudicado" xmlFile="/rh/generales.xml"
	returnvariable="LB_Adjudicado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluado"
	Default="Evaluado" xmlFile="/rh/generales.xml"
	returnvariable="LB_Evaluado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descalificado"
	Default="Descalificado" xmlFile="/rh/generales.xml"
	returnvariable="LB_Descalificado"/>

<cf_translatedata name="get" tabla="RHConcursos" col="a.RHCdescripcion"	 returnvariable="LvarRHCdescripcion">
<cf_translatedata name="get" tabla="RHConcursos" col="a.RHCjustificacion"	 returnvariable="LvarRHCjustificacion">	
<cf_translatedata name="get" tabla="CFuncional" col="b.CFdescripcion"	 returnvariable="LvarCFdescripcion">	
<cf_translatedata name="get" tabla="RHPuestos" col="c.RHPdescpuesto"	 returnvariable="LvarRHPdescpuesto">	

<cfquery name="concursos" datasource="#session.DSN#" maxrows="105">
	select 	a.RHCconcurso, 
			a.RHCcodigo,
			#LvarRHCdescripcion# as RHCdescripcion,
			a.RHCfecha,
			c.RHPcodigo,
			coalesce(RHPcodigoext,c.RHPcodigo) as RHPcodigoext,
			a.RHCcantplazas,
			a.RHCfapertura,
			a.RHCfcierre,
			#LvarRHCjustificacion# as RHCjustificacion,
			b.CFcodigo, 
			#LvarCFdescripcion# as CFdescripcion,
			a.RHPcodigo,
			#LvarRHPdescpuesto# as RHPdescpuesto
	from RHConcursos a
	
	inner join CFuncional b
	on b.Ecodigo=a.Ecodigo
	and b.CFid=a.CFid
	
	inner join RHPuestos c
	on c.Ecodigo=a.Ecodigo
	and c.RHPcodigo=a.RHPcodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCestado=70

	  <cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
		  and a.RHCconcurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
	  </cfif>
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
				<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1">#LB_ConcursosFinalizados#</font></td></tr>
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
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_CentroFuncional#:&nbsp;#concursos.CFcodigo# - #concursos.CFdescripcion#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_Puesto#:&nbsp;#concursos.RHPcodigoext# - #concursos.RHPdescpuesto#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_Motivo#:&nbsp; #LB_NA#</td>
							</tr>
							<tr>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_PlazasSolicitadas#:&nbsp;#concursos.RHCcantplazas#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_FechaDeApertura#:&nbsp; #LSDateFormat(concursos.RHCfapertura,'dd/mm/yyyy')#</td>
								<td style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_FechaDeCierre#:&nbsp; #LSDateFormat(concursos.RHCfcierre,'dd/mm/yyyy')#</td>
							</tr>
							<tr><td colspan="3" style=" font-family:Helvetica; font-style:italic; font-size:8; padding:6px;">#LB_Justificacion#:&nbsp; <cfif len(trim(concursos.RHCjustificacion))>#concursos.RHCjustificacion#<cfelse>N/A</cfif></td></tr>
						</table>
					</td></tr>
					
					<!--- 1. PLAZAS ASOCIADAS AL CONCURSO --->		
					<cf_translatedata name="get" tabla="RHPlazas" col="b.RHPdescripcion" returnvariable="LvarRHPdescripcion">	
					<cfquery name="plazas" datasource="#session.DSN#">
						select a.RHPCid, a.RHPid, b.RHPcodigo, #LvarRHPdescripcion# as RHPdescripcion
						from RHPlazasConcurso a
						
						inner join RHPlazas b
						on b.Ecodigo=a.Ecodigo
						and b.RHPid=a.RHPid
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCconcurso#">
					</cfquery>
					<tr>
						<td width="3%">&nbsp;</td>
						<td colspan="6" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##E3EDEF">#LB_PlazasSolicitadas#</td>
					</tr>
					<tr>
						<td width="3%">&nbsp;</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Codigo#</td>
						<td colspan="5" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Descripcion#</td>
					</tr>

					<cfloop query="plazas">
						<tr>
							<td width="3%">&nbsp;</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#plazas.RHPcodigo#</td>
							<td colspan="5" style=" font-family:Helvetica; font-size:8; padding:8px;" >#plazas.RHPdescripcion#</td>
						</tr>
					</cfloop>

					<!--- 2. CONCURSANTES --->		
					<cf_translatedata name="get" tabla="RHPlazas" col="e.RHPdescripcion" returnvariable="LvarRHPdescripcion">	
					<cfquery name="concursantes" datasource="#session.DSN#">
						select 	case a.RHCPtipo when 'I' then '#LB_Interno#' else '#LB_Externo#' end as tipo,
								a.RHCPpromedio,
								a.RHCdescalifica,
								coalesce(b.DEidentificacion, c.RHOidentificacion) as identificacion,
								coalesce(b.DEnombre, c.RHOnombre) as nombre,
								coalesce(b.DEapellido1, c.RHOapellido1) as apellido1,
								coalesce(b.DEapellido2, c.RHOapellido2) as apellido2,
								d.RHPid,
								case d.RHAestado when 10 then '#LB_Asignado#' when 20 then '#LB_Adjudicado#' else '#LB_Evaluado#' end as estado,
								e.RHPcodigo,
								#LvarRHPdescripcion# as RHPdescripcion
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
						
						left outer join RHPlazas e
						on e.Ecodigo=d.Ecodigo
						and e.RHPid=d.RHPid
						
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCconcurso#">
						order by  d.RHAestado desc, identificacion
					</cfquery>
					<tr>
						<td width="3%">&nbsp;</td>
						<td colspan="6" style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##E3EDEF">#LB_Concursantes#</td>
					</tr>
					<tr>
						<td width="3%">&nbsp;</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Identificacion#</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Concursante#</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Tipo#</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Puntaje#</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_Estado#</td>
						<td style=" font-family:Helvetica; font-size:8; padding:6px;" bgcolor="##FAFAFA">#LB_PlazaAsignada#</td>
					</tr>

					<cfloop query="concursantes">
						<tr>
							<td width="3%">&nbsp;</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.identificacion#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.nombre# #concursantes.apellido1# #concursantes.apellido2#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.tipo#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.RHCPpromedio#</td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" ><cfif concursantes.RHCdescalifica eq 1 >#LB_Descalificado#<cfelse>#concursantes.estado#</cfif></td>
							<td style=" font-family:Helvetica; font-size:8; padding:8px;" >#concursantes.RHPcodigo# - #concursantes.RHPdescripcion#</td>
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



