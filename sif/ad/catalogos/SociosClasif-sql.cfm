<!---
	Modificado por: Ana Villavicencio
	Fecha: 03 de marzo del 2006
	Motivo: Se corrigio error en la consulta de las clasificaciones por direccion,
			esta consulta trabajaba sobre el detalle de la clasificacion y no por el
			encabezado para verificar la existencia de las clasificaciones por direccion.
 --->
<cfinclude template="SociosModalidad.cfm">
<cfparam name="form.clax" default="">

<cftransaction>
		<cfquery datasource="#session.dsn#" name="rsdiotO">
			select DIOTopcodigo
			from SNDIOTOper
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsdiotT">
			select DIOTcodigo
			from SNDIOTClas
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>

	<!---Actualizacion de operaciones diot --->
	<cfif isdefined("form.TipoOD")>
		<cfif form.TipoOD eq '00'>
			<cfif rsdiotO.recordcount gt 0>
				<cfquery datasource="#session.dsn#" name="rsdiotO">
					delete SNDIOTOper
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<cfelse>
			<cfif rsdiotO.recordcount gt 0>
				<cfquery datasource="#session.dsn#" name="InsdiotO">
					update SNDIOTOper
						set DIOTopcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoOD#">
							,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#" name="InsdiotO">
					insert into SNDIOTOper (Ecodigo,SNcodigo,DIOTopcodigo,BMUsucodigo)
						values(<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
							   <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoOD#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							   )
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	<!---Actualizacion de Tipo de tercero diot --->
	<cfif isdefined("form.TipoTD")>
		<cfif form.TipoTD eq '00'>
			<cfif rsdiotT.recordcount gt 0>
				<cfquery datasource="#session.dsn#" name="delSdiotT">
					delete SNDIOTClas
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<cfelse>
			<cfif rsdiotT.recordcount gt 0>
				<cfquery datasource="#session.dsn#" name="InsdiotO">
					update SNDIOTClas
						set DIOTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoTD#">
							,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#" name="InsdiotO">
					insert into SNDIOTClas (Ecodigo,SNcodigo,DIOTcodigo,BMUsucodigo)
						values(<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,
							   <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoTD#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							   )
				</cfquery>
			</cfif>
		</cfif>
	</cfif>

	<cfquery datasource="#session.dsn#">
		delete from SNClasificacionSN
		where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
		<cfif session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>
		  and SNCDid in (
						select SNCDid
						from SNClasificacionE e
							inner join SNClasificacionD d
								on e.SNCEid = d.SNCEid
						where e.SNCEcorporativo = 0 )
		</cfif>
	</cfquery>

	<cfloop list="#form.clax#" index="i">
		<cfif Len(i) and session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>
			<cfquery datasource="#session.dsn#" name="corp">
			  select SNCEcorporativo
			  from SNClasificacionE e
				join SNClasificacionD d
					on e.SNCEid = d.SNCEid
				where d.SNCDid = #i#
			</cfquery>
			<cfif corp.SNCEcorporativo EQ 1>
				<cfset i = ''>
			</cfif>
		</cfif>

		<cfif Len(i)>
			<cfquery datasource="#session.dsn#">
				insert into SNClasificacionSN (SNid, SNCDid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
					#i#)
			</cfquery>
			<cfquery name="rsExiste" datasource="#session.dsn#">
				select 1
				 from SNClasificacionSND snd
				inner join SNClasificacionD cd
				   on cd.SNCDid = snd.SNCDid
				where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
				 and cd.SNCEid = (select ce.SNCEid
				                   from SNClasificacionD cd
				                     inner join SNClasificacionE ce
				                       on cd.SNCEid = ce.SNCEid
				                  where cd.SNCDid = #i#)
			</cfquery>
			<cfif isdefined("rsExiste") and rsExiste.recordcount eq 0>
				<cfquery datasource="#session.dsn#">
					insert into SNClasificacionSND (id_direccion, SNid, SNCDid, BMUsucodigo)
						select
							id_direccion,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.SNid#"> as SNid,
						#i# as SNCDid,
						0 as BMUsucodigo
						from SNDirecciones
						where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cftransaction>


<cfif session.Ecodigo eq session.Ecodigocorp and Len(form.clax)>
	<!--- replicar los valores corporativos --->
	<cfquery datasource="#session.dsn#" name="datos_actuales">
		<!--- obtener mi propia información --->
		select SNid, SNidCorporativo
		from SNegocios
		where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		<!--- eliminar las clasificaciones corporativas de mis relacionados (excepto yo) --->
		delete from SNClasificacionSN
		where SNid in (
			select SNid
			from SNegocios
			where SNidCorporativo = #datos_actuales.SNid#
			<cfif Len(datos_actuales.SNidCorporativo)>
			   or SNid = #datos_actuales.SNidCorporativo#
			   or SNidCorporativo = #datos_actuales.SNidCorporativo#
			</cfif>)
		  and SNid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">

		  and SNCDid in (
				  	select SNCDid
					from SNClasificacionE e
						join SNClasificacionD d
							on e.SNCEid = d.SNCEid
					where e.SNCEcorporativo = 1 )
	</cfquery>

	<cfquery datasource="#session.dsn#">
		<!--- reinsertar- las clasificaciones corporativas a mis relacionados (excepto yo) --->
		insert into SNClasificacionSN (SNid, SNCDid)
		select s.SNid, c.SNCDid
		from SNegocios s, SNClasificacionSN c
		where (s.SNidCorporativo = #datos_actuales.SNid#
		<cfif Len(datos_actuales.SNidCorporativo)>
		   or s.SNid = #datos_actuales.SNidCorporativo#
		   or s.SNidCorporativo = #datos_actuales.SNidCorporativo#
		</cfif>)
		  and s.SNid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
		  and c.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">
		  and c.SNCDid in (
				  	select SNCDid
					from SNClasificacionE e
						join SNClasificacionD d
							on e.SNCEid = d.SNCEid
					where e.SNCEcorporativo = 1 )
	</cfquery>
</cfif>
<cfif isDefined('form.moduloCred') and form.moduloCred eq 1>
	<cflocation url="/cfmx/crc/administracion/catalogos/Socios.cfm?SNcodigo=#form.SNcodigo#&tab=10">
<cfelse>
	<cflocation url="Socios.cfm?SNcodigo=#form.SNcodigo#&tab=7">
</cfif>

