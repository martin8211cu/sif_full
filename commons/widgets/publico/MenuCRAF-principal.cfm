<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_InsertarPlaca = t.Translate('LB_InsertarPlaca','Introduzca una placa para ver su responsable','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_placa = t.Translate('LB_placa','Placa','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_buscar = t.Translate('LB_buscar','Buscar','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_Responsable = t.Translate('LB_Responsable','Responsable','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_CentroFuncional = t.Translate('LB_CentroFuncional','Centro Funcional','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_CentroCustodia = t.Translate('LB_CentroCustodia','Centro de Custodia','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_DocActivoDuplicado = t.Translate('LB_DocActivoDuplicado','El Documento del Activo Est&aacute; Duplicado','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_DocInactivoDuplicado = t.Translate('LB_DocInactivoDuplicado','El Documento del Activo Est&aacute; Inactivo','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_ActInconsistente = t.Translate('LB_ActInconsistente','Activo inconsistente','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_ActDuplicado = t.Translate('LB_ActDuplicado','El Activo Est&aacute; Duplicado','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_ActRetirado = t.Translate('LB_ActRetirado','El Activo Est&aacute; Retirado','/commons/widgets/publico/MenuCRAF.xml')>
<cfset LB_ActNoExiste = t.Translate('LB_ActNoExiste','El Activo No Existe','/commons/widgets/publico/MenuCRAF.xml')>

<!--- Formulario de Consulta de Saldos de Activos Fijos --->
<cfif isdefined("url.form_format") and len(trim(url.form_format)) and ListFindNoCase('html,flash',url.form_format)>
	<cfset session.menucraf.form_format = url.form_format>
</cfif>
<cfparam name="session.menucraf.form_format" default="html"><!--- Para hacerlo para flash falta ver como pintar la tabla con los resultados --->
<cfparam name="form.placa" default="">
<cfform height="350" width="350" id="form1" name="form1" method="post" action="MenuCRAF.cfm" format="#session.menucraf.form_format#" timeout="60" >
	<cf_web_portlet_start titulo="#LB_InsertarPlaca#">
	<cfformgroup type="panel" label="#LB_InsertarPlaca#">

		<table>
			<tr><td><label for="placa"><cfoutput>#LB_placa#</cfoutput></label></td><td>
				<cfinput label="Placa" name="#LB_placa#" type="text" id="placa" value="#form.placa#" size="20" />
			</td><td>
				<cfinput type="submit" name="Submit" value="#LB_buscar#" class="btnSiguiente" />
			</td></tr>
		</table>
		<cfif len(trim(form.placa))>
			<cfquery name="rsAFSaldos" datasource="#session.dsn#">
				select a.Aid
				  from Activos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				  and a.Astatus = 0
			</cfquery>
			<cfquery name="rsAFResponsables" datasource="#session.dsn#">
				<cfif rsAFSaldos.recordcount eq 1>
					select a.AFRid, a.CRDRdescripcion, a.Monto, 
						d.DEidentificacion, 
						<cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre"> as DEnombrecompleto, 
						e.CFcodigo, e.CFdescripcion,
						f.CRCCcodigo, f.CRCCdescripcion
					  from AFResponsables a
					    left outer join DatosEmpleado d 
						   on a.DEid = d.DEid
					    left outer join CFuncional e 
					 	   on a.CFid = e.CFid
					    left outer join CRCentroCustodia f 
						  on a.CRCCid = f.CRCCid
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.Aid = #rsAFSaldos.Aid#
					  and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
					
					union all
				</cfif>
					select crdr.AFRid, crdr.CRDRdescripcion, crdr.Monto, 
						d2.DEidentificacion, 
						<cf_dbfunction name="concat" args="d2.DEapellido1,' ',d2.DEapellido2,' ',d2.DEnombre"> as DEnombrecompleto, 
						e2.CFcodigo, e2.CFdescripcion,
						f2.CRCCcodigo, f2.CRCCdescripcion
					 from CRDocumentoResponsabilidad crdr
					   left outer join DatosEmpleado d2 
					     on crdr.DEid = d2.DEid
					   left outer join CFuncional e2 
					     on crdr.CFid = e2.CFid
					   left outer join CRCentroCustodia f2 
					     on crdr.CRCCid = f2.CRCCid
					where crdr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and crdr.CRDRplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
			</cfquery>
				<cfif rsAFResponsables.recordcount eq 1>
					<cfoutput>
					<table align="center" width="295">
					  <tr>
						<td colspan="2"><strong>#rsAFResponsables.CRDRdescripcion#</strong></td>
					  </tr>
					  <tr>
					  	<td>#LB_Responsable#</td>
						<td>#rsAFResponsables.DEidentificacion# - #rsAFResponsables.DEnombrecompleto#</td>
					  </tr>
					  <tr>
					  	<td>#LB_CentroFuncional#</td>
						<td>#rsAFResponsables.CFcodigo# - #rsAFResponsables.CFdescripcion#</td>
					  </tr>
					  <tr>
					  	<td>#LB_CentroCustodia#</td>
						<td>#rsAFResponsables.CRCCcodigo# - #rsAFResponsables.CRCCdescripcion#</td>
					  </tr>
					</table>
					</cfoutput>
				<cfelse>
					<cfif rsAFSaldos.recordcount eq 1>
					<cfquery name="rsAFResponsablesDuplicados" datasource="#session.dsn#">
						select 1
						from AFResponsables a
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.Aid = #rsAFSaldos.Aid#
						and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
					</cfquery>
					<cfquery name="rsAFResponsablesInactivos" datasource="#session.dsn#">
						select 1
						from AFResponsables a
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAFSaldos.Aid#">
					</cfquery>
					<table>
					  <tr>
						<td>
						<cfif rsAFResponsablesDuplicados.recordcount gt 1>
							#LB_DocActivoDuplicado#
						<cfelseif rsAFResponsablesInactivos.recordcount and  rsAFResponsablesDuplicados.recordcount eq 0>
							#LB_DocInactivoDuplicado#
						<cfelseif rsAFResponsables.recordcount GT 1>
							#LB_ActInconsistente#
						</cfif>
						</td>
					  </tr>
					</table>
					</cfif>
				</cfif>				
			<cfif (rsAFSaldos.recordcount neq 1) and (rsAFResponsables.recordcount eq 0)>
			<cfquery name="rsAFSaldosDuplicados" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				and a.Astatus = 0
			</cfquery>
			<cfquery name="rsAFSaldosRetirados" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				and a.Astatus = 60
			</cfquery>
			<table>
			  <tr>
				<td><cfif rsAFSaldosDuplicados.recordcount gt 1>#LB_ActDuplicado#<cfelseif rsAFSaldosRetirados.recordcount>#LB_ActRetirado#<cfelse>#LB_ActNoExiste#</cfif></td>
			  </tr>
			</table>
			</cfif>
		</cfif>
	</cfformgroup>
	<cf_web_portlet_end>
</cfform>