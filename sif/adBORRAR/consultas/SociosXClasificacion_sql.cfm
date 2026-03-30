<cfset LvarParamClasifiacion = ''>
<cfif isdefined('url.DentroFueraCla') and url.DentroFueraCla eq 0>
	<!--- Todos los Socios de Negocios que estan dentro de una Clasificación. --->
	<cfquery name="rsConsulta" datasource="#session.DSN#">
		select 
			e.SNCEcodigo, 
			e.SNCEdescripcion,
			b.SNCDvalor,
			b.SNCDdescripcion,
			s.SNcodigo,
			s.SNnumero,
			s.SNnombre
		from SNegocios s
			inner join SNClasificacionSN a
				on a.SNid = s.SNid
			inner join SNClasificacionD b
				on b.SNCDid = a.SNCDid
			inner join SNClasificacionE e
				on e.SNCEid = b.SNCEid	
		where s.Ecodigo = #session.Ecodigo#
			and e.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			and e.PCCEactivo = 1
		order by 6
	</cfquery>
	<cfset LvarReporte = "AdentroClas.cfr">
<cfelseif isdefined('url.DentroFueraCla') and url.DentroFueraCla eq 1>
	<cfquery name="rsClasificacion"	 datasource="#session.DSN#">
		select 
			SNCEdescripcion,
			SNCEcodigo,
			SNCEalertar, 
			PCCEobligatorio,
			SNCtiposocio
		from SNClasificacionE
		where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
	</cfquery>
	<cfif isdefined('rsClasificacion') and len(trim(rsClasificacion.SNCEdescripcion))>
		<cfset LvarParamClasifiacion = '#trim(rsClasificacion.SNCEcodigo)# -  #rsClasificacion.SNCEdescripcion#'>
	</cfif>


	<!--- Todos los Socios de Negocios que no están en una clasificación --->
	<cfquery name="rsConsulta" datasource="#session.DSN#">
		select 
			s.SNnumero,
			s.SNnombre
		from SNegocios s
		where s.Ecodigo = #session.Ecodigo#
			<cfif rsClasificacion.SNCtiposocio EQ 'P'>
			    and s.SNtiposocio = 'P' 
			</cfif>
			<cfif rsClasificacion.SNCtiposocio EQ 'C'>
			    and s.SNtiposocio = 'C' 
			</cfif>
			and 
				(
					s.SNid not in (
						select sn.SNid
							from SNClasificacionE e
								inner join SNClasificacionD d
									on d.SNCEid = e.SNCEid
								inner join SNClasificacionSN sn
									on sn.SNCDid = d.SNCDid
							where sn.SNid = s.SNid
							and e.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
							and e.PCCEactivo = 1
							)
					)
		order by 1, 2
	</cfquery>
	
	<cfset LvarReporte = "AfueraClas.cfr">
</cfif>

<cfreport format="#url.formato#" template="#LvarReporte#" query="rsConsulta">
	<cfreportparam name="Clasifiacion" value="#LvarParamClasifiacion#">
	
	<cfif isdefined('rsClasificacion') and trim(rsClasificacion.SNCEalertar) eq 1>
		<cfreportparam name="Alertar" value="Si">
	<cfelseif isdefined('rsClasificacion') and trim(rsClasificacion.SNCEalertar) eq 0>
		<cfreportparam name="Alertar" value="No">
	</cfif>

	<cfif isdefined('rsClasificacion') and trim(rsClasificacion.PCCEobligatorio) eq 1>
		<cfreportparam name="Obligatorio" value="Si">
	<cfelseif isdefined('rsClasificacion') and trim(rsClasificacion.PCCEobligatorio) eq 0>
		<cfreportparam name="Obligatorio" value="No">
	</cfif>
	
	<cfif isdefined('rsClasificacion') and trim(rsClasificacion.SNCtiposocio) eq 'P'>
		<cfreportparam name="Aplica" value="Proveedores">
	<cfelseif isdefined('rsClasificacion') and trim(rsClasificacion.SNCtiposocio) eq 'C'>
		<cfreportparam name="Aplica" value="Clientes">
	<cfelseif isdefined('rsClasificacion') and trim(rsClasificacion.SNCtiposocio) eq 'A'>
		<cfreportparam name="Aplica" value="Ambos">
	<cfelse>
		<cfreportparam name="Aplica" value="Ambos">
	</cfif>
</cfreport>