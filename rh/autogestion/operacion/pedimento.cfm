<cf_templateheader title="Solicitud de Personal"> 

 <cf_web_portlet_start border="true" titulo="Solicitud de Personal" skin="#Session.Preferences.Skin#">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
 	
<cfif isdefined ('url.RHPid') and len(trim(url.RHPid)) gt 0 and not isdefined('form.RHPid')>
	<cfset form.RHPid=url.RHPid>
</cfif>	

<cfquery name="rsMot" datasource="#session.dsn#">
	select RHMcodigo,RHMid,RHMdescripcion from RHMotivos where Ecodigo=#session.Ecodigo#						
</cfquery>

<cfquery name="rsAse" datasource="#session.dsn#">
	select ta.Usucodigo,dp.Pid,de.DEid, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre
	from RHAsesor ta
		inner join Usuario u
		on u.Usucodigo=ta.Usucodigo
			inner join DatosPersonales dp
			on dp.datos_personales =u.datos_personales
		inner join UsuarioReferencia r
				inner join DatosEmpleado de
					on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
					and r.STabla='DatosEmpleado'
			on r.Usucodigo=ta.Usucodigo			
	where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
</cfquery>

<table width="100%">
	<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0 or isdefined ('form.btnNuevo') or isdefined ('url.btnNuevo')>
		<tr>
			<td width="50%" valign="top">
				<cfinclude template="pedimento-form.cfm">
			</td>
		</tr>
	<cfelse>
		<form name="asigna" method="post" action="">
		<cfoutput>
		<tr>
			<td><strong>Fecha:</strong></td>
			<cfif isdefined ('form.fecha') and len(trim(form.fecha)) gt 0>
				<cfset LvarFecha=#form.fecha#>
				<td><cf_sifcalendario name="fecha" form="asigna" value="#LvarFecha#"></td>
			<cfelse>
				<td><cf_sifcalendario name="fecha" form="asigna"></td>
			</cfif>			
			<td>&nbsp;</td>
			<td><strong>Puesto:</strong></td>
			<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
				<cfquery name="rsPuesto" datasource="#session.dsn#">
					select RHPcodigo,RHPdescpuesto,RHPcodigoext  from RHPuestos where RHPcodigo='#form.RHPcodigo#'
					and Ecodigo=#session.Ecodigo#
				</cfquery>
				<td><cf_rhpuesto form="asigna" query="#rsPuesto#"></td>
			<cfelse>
				<td><cf_rhpuesto form="asigna"></td>
			</cfif>
		</tr>
		<tr>
			<td><strong>Motivo:</strong></td>
			<td>
				<select name="rsMotivo">
					<option value="-1"> </option>											
					<cfloop query="rsMot">
						<option value="#rsMot.RHMid#"
						<cfif isdefined('form.rsMotivo') and len(trim(form.rsMotivo)) gt 0 and form.rsMotivo gt 0 and form.rsMotivo eq rsMot.RHMid>selected="selected"</cfif>>#rsMot.RHMcodigo#-#rsMot.RHMdescripcion#</option>
					</cfloop>						
				</select>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type="submit" name="Filtrar" value="Filtrar" /></td>	
		</tr>
		</cfoutput>
		</form>
		<tr>
			<td  valign="top" colspan="6">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select  a.RHPid,
					a.RHPfecha,
					a.RHPporc,
					a.RHPcodigo,
					a.RHMid,
					a.RHPjustificacion,
					a.RHPfunciones,
					'En Proceso' as RHPestado,
					p.RHPdescpuesto,
					m.RHMdescripcion,
					RHPasesor
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
							
						where 
							a.Ecodigo=#session.Ecodigo#
							and a.RHPestado in (10)
					<cfif isdefined ('form.fecha') and len(trim(form.fecha)) gt 0>
							and a.RHPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					</cfif>
					<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
							and a.RHPcodigo='#form.RHPcodigo#'
					</cfif>
					<cfif isdefined('form.rsMotivo') and len(trim(form.rsMotivo)) gt 0 and form.rsMotivo gt 0 and form.rsMotivo>
							and a.RHMid=#form.rsMotivo#
					</cfif>
					and a.Usucodigo=#session.Usucodigo#
				</cfquery>

				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="RHPid,RHPfecha,RHPporc,RHPcodigo,RHTid,RHMid,RHPjustificacion,RHPfunciones,RHPestado,RHPdescpuesto,RHMdescripcion"
					desplegar="RHPfecha,RHPdescpuesto,RHMdescripcion"
					etiquetas="Fecha,Puesto Solicitado,Motivo"
					formatos="D,S,S"
					align="left,left,left"
					ira="pedimento.cfm"
					showEmptyListMsg="yes"
					keys="RHPid"	
					MaxRows="20"
					botones="Nuevo"/>
					<!---filtrar_automatico="true"
					filtrar_por="RHPfecha,RHPdescpuesto,RHMdescripcion,Nombre"
					mostrar_filtro="true"--->
			</td>
		</tr>
	</cfif>
</table>

<!---<!---<cf_web_portlet_end>
<cf_templatefooter>
	
 	<cfif isdefined ('url.RHPid') and len(trim(url.RHPid)) gt 0 and not isdefined('form.RHPid')>
		<cfset form.RHPid=url.RHPid>
	</cfif>
	<table width="100%">
		<tr>

			<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0 or isdefined ('form.btnNuevo') or isdefined ('url.btnNuevo')>
				<td width="50%" valign="top">
					<cfinclude template="pedimento-form.cfm">
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
							m.RHMdescripcion
					from RHPedimentos  a
						inner join RHPuestos p
							on p.RHPcodigo=a.RHPcodigo
							and p.Ecodigo=a.Ecodigo
						inner join RHMotivos m
						on m.RHMid=a.RHMid
					where 
					a.Ecodigo=#session.Ecodigo#
					and a.RHPestado=10
					</cfquery>
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#rsSQL#"
							columnas="RHPid,RHPfecha,RHPporc,RHPcodigo,RHTid,RHMid,RHPjustificacion,RHPfunciones,RHPestado,RHPdescpuesto,RHMdescripcion"
							desplegar="RHPfecha,RHPdescpuesto,RHMdescripcion"
							etiquetas="Fecha,Puesto Solicitado,Motivo"
							formatos="D,S,S"
							align="left,left,left"
							ira="pedimento.cfm"
							showEmptyListMsg="yes"
							keys="RHPid"	
							MaxRows="2"
							botones="Nuevo"
						/>		
				</td>
			</cfif>
		</tr>
	</table>
	
  <cf_web_portlet_end>
<cf_templatefooter>--->--->
	