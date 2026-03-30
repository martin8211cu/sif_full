<cfif IsDefined("form.Cambio")>

	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBgrupoOG"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="OBGid"
				type1="numeric"
				value1="#form.OBGid#"
		>
	
	<cfquery datasource="#session.dsn#">
		update OBgrupoOG
		   set OBGcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGcodigo#" null="#Len(form.OBGcodigo) Is 0#">
		     , OBGdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGdescripcion#" null="#Len(form.OBGdescripcion) Is 0#">
		     , OBGtexto			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGtexto#" null="#Len(form.OBGtexto) Is 0#">
		     , PCEcatidOG		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidOG#" null="#Len(form.PCEcatidOG) Is 0#">
		     , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
	</cfquery>

	<cflocation url="OBgrupoOG.cfm?OBGid=#URLEncodedFormat(form.OBGid)#">
<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBgrupoOGvalores
		where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete from OBgrupoOG
		where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
	</cfquery>

	<cflocation url="OBgrupoOG.cfm">
<cfelseif IsDefined("form.Alta")>	

	<cftransaction>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into OBgrupoOG (
					  Ecodigo
					, OBGcodigo
					, OBGdescripcion
					, OBGtexto
					, PCEcatidOG
					, BMUsucodigo
				)
			values (
					  #session.Ecodigo#
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGcodigo#" null="#Len(form.OBGcodigo) Is 0#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGdescripcion#" null="#Len(form.OBGdescripcion) Is 0#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OBGtexto#" null="#Len(form.OBGtexto) Is 0#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidOG#" null="#Len(form.PCEcatidOG) Is 0#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)				
			<cf_dbidentity1  name="insert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2  name="insert" datasource="#session.dsn#" returnvariable="LvarID">
	</cftransaction>
	
	<cflocation url="OBgrupoOG.cfm?OBGid=#URLEncodedFormat(LvarID)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBgrupoOG.cfm?btnNuevo">
<cfelseif IsDefined("form.BTNMODIFICAR_VALORES")>
	<cfset LvarPCDcatidOGdelete = "">
	<cfparam name="form.chk" default="">
	<cfloop list="#form.PCDcatidOGlist#" index="LvarPCDcatidOG">
		<cfset LvarIdx = listFind(#form.chk#,LvarPCDcatidOG)>
		<cfif LvarIdx EQ 0>
			<cfset LvarPCDcatidOGdelete = listAppend(LvarPCDcatidOGdelete,LvarPCDcatidOG)>
		</cfif>
	</cfloop>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from OBgrupoOGvalores
			where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
			  and <cf_whereInList column="PCDcatidOG" valueList="#LvarPCDcatidOGdelete#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into OBgrupoOGvalores
				(OBGid, PCDcatidOG)
			select 
				  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
				, PCDcatid
			  from PCDCatalogo
			 where <cf_whereInList column="PCDcatid" valueList="#form.Chk#">
			   and not (<cf_whereInList column="PCDcatid" valueList="#form.PCDcatidOGlist#">)
		</cfquery>
	</cftransaction>
	
	<cflocation url="OBgrupoOG.cfm?OBGid=#URLEncodedFormat(form.OBGid)#">
<cfelseif IsDefined("form.btnAgregar_Todos")>
	<cfquery datasource="#session.dsn#">
		insert into OBgrupoOGvalores
			(OBGid, PCDcatidOG)
		select 
			  OBGid
			, PCDcatid
		  from OBgrupoOG g
		  	inner join PCDCatalogo
				on PCEcatid = PCEcatidOG
		 where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
		   and not exists 
		   	(
				select 1 
				  from OBgrupoOGvalores gv
				 where gv.OBGid = g.OBGid
				   and PCDcatidOG = PCDCatalogo.PCDcatid
			)
	</cfquery>

	<cflocation url="OBgrupoOG.cfm?OBGid=#URLEncodedFormat(form.OBGid)#">
<cfelseif IsDefined("form.btnEliminar_Todos")>
	<cfquery datasource="#session.dsn#">
		delete from OBgrupoOGvalores
		where OBGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBGid#" null="#Len(form.OBGid) Is 0#">
	</cfquery>
	<cflocation url="OBgrupoOG.cfm?OBGid=#URLEncodedFormat(form.OBGid)#">
<cfelse>
	<cflocation url="OBgrupoOG.cfm">
</cfif>
