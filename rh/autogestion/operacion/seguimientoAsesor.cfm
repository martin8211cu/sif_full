<cf_templateheader title="Seguimiento Asesor"> 
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
 <cf_web_portlet_start border="true" titulo="Asignar Asesor a Solicitud de Personal" skin="#Session.Preferences.Skin#">
 	<cfif isdefined ('url.RHPid') and len(trim(url.RHPid)) gt 0 and not isdefined('form.RHPid')>
		<cfset form.RHPid=url.RHPid>
	</cfif>
	<table width="100%">
		<tr>

			<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0 or isdefined ('form.btnNuevo') or isdefined ('url.btnNuevo')>
				<td width="50%" valign="top">
					<cfinclude template="seguimientoAsesor-form.cfm">
				</td>
			<cfelse>
				<td  valign="top">
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select  a.RHPid,
							a.RHPfecha,
							a.RHPporc,
							a.RHPcodigo,
							a.RHTid,
							a.RHMid,
							a.RHPjustificacion,
							a.RHPfunciones,
							'En Proceso' as RHPestado,
							p.RHPdescpuesto,
							m.RHMdescripcion,
							RHPasesor,coalesce(DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2,'-') as Nombre
						from RHPedimentos  a
							inner join RHPuestos p
								on p.RHPcodigo=a.RHPcodigo
								and p.Ecodigo=a.Ecodigo
							inner join RHMotivos m
							on m.RHMid=a.RHMid
							left outer  join Usuario u							
								inner join DatosPersonales dp
								on dp.datos_personales =u.datos_personales
							on u.Usucodigo=a.RHPasesor
							left outer join UsuarioReferencia r
								inner join DatosEmpleado de
									on de.DEid=r.llave
									and r.STabla='DatosEmpleado'
							on r.Usucodigo=a.RHPasesor		
						where 
						a.Ecodigo=#session.Ecodigo#
						and a.RHPestado=30
						and a.RHPasesor=#session.Usucodigo#
					</cfquery>
				 <cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#rsSQL#"
							columnas="RHPid,RHPfecha,RHPporc,RHPcodigo,RHTid,RHMid,RHPjustificacion,RHPfunciones,RHPestado,RHPdescpuesto,RHMdescripcion,Nombre"
							desplegar="RHPfecha,RHPdescpuesto,RHMdescripcion,Nombre"
							etiquetas="Fecha,Puesto Solicitado,Motivo,Asesor"
							formatos="D,S,S,S"
							align="left,left,left,left"
							ira="seguimientoAsesor.cfm"
							showEmptyListMsg="yes"
							keys="RHPid"	
							MaxRows="20"
							<!---filtrar_automatico="true"
							filtrar_por="RHPfecha,RHPdescpuesto,RHMdescripcion,Nombre"
							mostrar_filtro="true"--->
						/>		
				</td>
			</cfif>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>
	