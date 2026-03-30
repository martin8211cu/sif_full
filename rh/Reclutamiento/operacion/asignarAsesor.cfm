<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Default="Asignar Asesor" Key="LB_Asignar_Asesor"  returnvariable="LB_Asignar_Asesor"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Default="Asignar Asesor a Solicitud de Personal" Key="LB_Asignar_Asesor_a_Solicitud_de_Personal"  returnvariable="LB_Asignar_Asesor_a_Solicitud_de_Personal"/> 
	
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Default="Filtrar" Key="LB_Filtrar"  returnvariable="LB_Filtrar"/> 
	
<cf_templateheader title="Asignar Asesor">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
 	
<cfif isdefined ('url.RHPid') and len(trim(url.RHPid)) gt 0 and not isdefined('form.RHPid')>
	<cfset form.RHPid=url.RHPid>
</cfif>	
<cf_translatedata name="get" tabla="RHMotivos" col="RHMdescripcion" returnvariable="LvarRHMdescripcion">
<cfquery name="rsMot" datasource="#session.dsn#">
	select RHMcodigo,RHMid,#LvarRHMdescripcion# as RHMdescripcion from RHMotivos where Ecodigo=#session.Ecodigo#						
</cfquery>

<!---Si el usuario que entra no esta asignado a la lista de asesores puede verlos todos sino solo las que pertenece a el--->
<cfquery name="rsAseV" datasource="#session.dsn#">
	select ta.Usucodigo,dp.Pid,de.DEid, DEnombre #LvarCNCT# ' ' #LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2 as Nombre
	from RHAsesor ta
		inner join Usuario u
		on u.Usucodigo=ta.Usucodigo
			inner join DatosPersonales dp
			on dp.datos_personales =u.datos_personales
		inner join UsuarioReferencia r
				inner join DatosEmpleado de
					on <cf_dbfunction name="to_char" args="de.DEid"> = r.llave
					and r.STabla='DatosEmpleado'
			on r.Usucodigo=ta.Usucodigo			
	where ta.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and r.Usucodigo=#session.Usucodigo#			
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
	<cfif isdefined('rsAseV') and rsAseV.recordcount gt 0 and len(trim(rsAseV.Usucodigo)) gt 0>
		and ta.Usucodigo=#rsAseV.Usucodigo#
	</cfif>		
</cfquery>

<table width="100%">
	<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0 or isdefined ('form.btnNuevo') or isdefined ('url.btnNuevo')>
		<tr>
			<td width="50%" valign="top">
				<cfinclude template="asignarAsesor-form.cfm">
			</td>
		</tr>
	<cfelse>
		<form name="asigna" method="post" action="">
		<cfoutput>
		<tr>
			<td><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong></td>
			<cfif isdefined ('form.fecha') and len(trim(form.fecha)) gt 0>
				<cfset LvarFecha=#form.fecha#>
				<td><cf_sifcalendario name="fecha" form="asigna" value="#LvarFecha#"></td>
			<cfelse>
				<td><cf_sifcalendario name="fecha" form="asigna"></td>
			</cfif>			
			<td>&nbsp;</td>
			<td><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong></td>
			<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
				<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto"/>
				<cfquery name="rsPuesto" datasource="#session.dsn#">
					select RHPcodigo,#LvarRHPdescpuesto# as RHPdescpuesto,RHPcodigoext  from RHPuestos where RHPcodigo='#form.RHPcodigo#'
					and Ecodigo=#session.Ecodigo#
				</cfquery>
				<td><cf_rhpuesto form="asigna" query="#rsPuesto#"></td>
			<cfelse>
				<td><cf_rhpuesto form="asigna"></td>
			</cfif>
		</tr>
		<tr>
			<td><strong><cf_translate key="LB_Motivo">Motivo</cf_translate>:</strong></td>
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
			<td><strong><cf_translate key="LB_Asesor">Asesor</cf_translate>:</strong></td>
			<td>							
				<select name="rsAsesor">	
					<cfif isdefined('rsAseV') and rsAseV.recordcount gt 0 and len(trim(rsAseV.Usucodigo)) gt 0>
					<cfelse>
						<option value="-1"><cf_translate key="LB_Todos">Todos</cf_translate></option>							
					</cfif>
					<cfloop query="rsAse">
						<option value="#rsAse.Usucodigo#" <cfif isdefined('form.rsAsesor') and len(trim(form.rsAsesor)) gt 0 and form.rsAsesor gt 0 and form.rsAsesor eq #rsAse.Usucodigo#>selected="selected"</cfif>>#rsAse.Nombre#</option>
					</cfloop>						
				</select>
			</td>
			<td><input type="submit" name="Filtrar" class="btnFiltrar" value="#LB_Filtrar#" /></td>	
		</tr>
		<tr>
			<td><input type="checkbox" name="chkFinalizadas" id="chkFinalizadas" /><cf_translate key="LB_Incluir_Finalizadas">Incluir Finalizadas</cf_translate></td>
		</tr>
		</cfoutput>		
		</form>
		<tr>
			<td  valign="top" colspan="6">
	            		<cf_translatedata name="get" tabla="RHMotivos" col="m.RHMdescripcion" returnvariable="LvarRHMdescripcion">
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
					#LvarRHMdescripcion# as RHMdescripcion,
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
								on <cf_dbfunction name="to_char" args="de.DEid">=r.llave
								and r.STabla='DatosEmpleado'
							on r.Usucodigo=a.RHPasesor		
						where 
							a.Ecodigo=#session.Ecodigo#
							<cfif isdefined('form.chkFinalizadas') and len(trim(form.chkFinalizadas)) gt 0>
								and a.RHPestado in (20,30,40)
							<cfelse>
								and a.RHPestado in (20,30)
							</cfif>
					<cfif isdefined ('form.fecha') and len(trim(form.fecha)) gt 0>
							and a.RHPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					</cfif>
					<cfif isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
							and a.RHPcodigo='#form.RHPcodigo#'
					</cfif>
					<cfif isdefined('form.rsMotivo') and len(trim(form.rsMotivo)) gt 0 and form.rsMotivo gt 0 and form.rsMotivo>
							and a.RHMid=#form.rsMotivo#
					</cfif>
					<cfif isdefined('form.rsAsesor') and len(trim(form.rsAsesor)) gt 0 and form.rsAsesor gt 0 and form.rsAsesor>
							and RHPasesor=#form.rsAsesor#
					</cfif>
					<cfif isdefined('rsAseV') and rsAseV.recordcount gt 0 and len(trim(rsAseV.Usucodigo)) gt 0>
						and RHPasesor=#rsAseV.Usucodigo#
					</cfif>	
				</cfquery>

			
				<cfinvoke component="sif.Componentes.Translate" method="Translate" 
					Default="Fecha" Key="LB_Fecha"  returnvariable="LB_Fecha"/> 
				<cfinvoke component="sif.Componentes.Translate" method="Translate" 
					Default="Puesto" Key="LB_Puesto_Solicitado"  returnvariable="LB_Puesto_Solicitado"/> 
				<cfinvoke component="sif.Componentes.Translate" method="Translate" 
					Default="Motivo" Key="LB_Motivo"  returnvariable="LB_Motivo"/> 
				<cfinvoke component="sif.Componentes.Translate" method="Translate" 
					Default="Asesor" Key="LB_Asesor"  returnvariable="LB_Asesor"/> 
										
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="RHPid,RHPfecha,RHPporc,RHPcodigo,RHTid,RHMid,RHPjustificacion,RHPfunciones,RHPestado,RHPdescpuesto,RHMdescripcion,Nombre"
					desplegar="RHPfecha,RHPdescpuesto,RHMdescripcion,Nombre"
					etiquetas="#LB_Fecha#,#LB_Puesto_Solicitado#,#LB_Motivo#,#LB_Asesor#"
					formatos="D,S,S,S"
					align="left,left,left,left"
					ira="asignarAsesor.cfm"
					showEmptyListMsg="yes"
					keys="RHPid"	
					MaxRows="20"/>
			</td>
		</tr>
	</cfif>
</table>

<cf_web_portlet_end>
<cf_templatefooter>
	