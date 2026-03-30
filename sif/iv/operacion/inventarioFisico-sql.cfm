<!---==========FILTROS DE LA LISTA PRINCIPAL===============--->
<cfset params = '' >
<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
	<cfset params = params & "&pageNum_lista=#form.pageNum_lista#" >
</cfif>
<cfif isdefined("form.fAid") and len(trim(form.fAid))>
	<cfset params = params & "&fAid=#form.fAid#" >
</cfif>
<cfif isdefined("form.fDescripcion") and len(trim(form.fDescripcion))>
	<cfset params = params & "&fDescripcion=#form.fDescripcion#" >
</cfif>
<cfif isdefined("form.fEFfecha") and len(trim(form.fEFfecha))>
	<cfset params = params & "&fEFfecha=#form.fEFfecha#" >
</cfif>
<cfset params2 = '' >
<cfif isdefined("form.pageNum_lista2") and len(trim(form.pageNum_lista2))>
	<cfset params2 = params2 & "&pageNum_lista2=#form.pageNum_lista2#" >
</cfif>
<cfif isdefined("form.fAcodigo") and len(trim(form.fAcodigo))>
	<cfset params2 = params2 & "&fAcodigo=#form.fAcodigo#" >
</cfif>
<cfif isdefined("form.fAdescripcion") and len(trim(form.fAdescripcion))>
	<cfset params2 = params2 & "&fAdescripcion=#form.fAdescripcion#" >
</cfif>
<!---=============NUEVO INVENTARIO FISICO================--->
<cfif isdefined("form.Nuevo") >
	<cflocation url="inventarioFisico.cfm?1=1#params#">
</cfif>
<!---=================AGREGAR ENCABEZADO=================--->
<cfif isdefined("form.ALTA")>
	<cftransaction>
		<cfquery name="insertado" datasource="#session.DSN#">
			insert into EFisico( Aid, Ecodigo, EFdescripcion, EFfecha, EFestado, BMUsucodigo, BMfechaalta )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
					 #session.Ecodigo# ,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EFdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(form.EFfecha)#">,
					 0,
					  #session.Usucodigo# ,
					 <cf_dbfunction name="now"> )
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
			<cf_dbidentity2 name="insertado" datasource="#session.dsn#">
		<cfset params = params & '&EFid=#insertado.identity#' >
	</cftransaction>
<!---=============MODIFICACION DEL ENCABEZADO============--->
<cfelseif isdefined("form.Cambio") or isdefined("form.btnAgregarDet") or isdefined("form.btnModificar") >
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EFisico" 
		redirect="inventarioFisico.cfm"
		timestamp="#form.ts_rversion#"
		field1="EFid,numeric,#form.EFid#">

	<cfquery datasource="#session.DSN#">
		update EFisico
		set Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
		   EFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EFdescripcion#">,
		   EFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(form.EFfecha)#">
		where Ecodigo =  #session.Ecodigo# 
		  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#">
	</cfquery>
	<cfset params = params & '&EFid=#form.EFid#' >
<!---=================ELIMINAR DOCUMENTO==================--->
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.DSN#">
		delete from DFisico
		where Ecodigo =  #session.Ecodigo# 
		  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from EFisico
		where Ecodigo =  #session.Ecodigo# 
		  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#">
	</cfquery>
	<cflocation url="inventarioFisico-lista.cfm?1=1#params#">	
<!---================APLICAR EL DOCUMENTO=================--->
<cfelseif isdefined("form.btnAplicar") or isdefined("form.btnAplicarM")>
	<cfif isdefined("form.btnAplicarM") >
		<cfset form.chk = form.EFid >
	</cfif>
	<cfif isdefined("form.chk")>
		<cfinclude template="inventarioFisico-aplicar.cfm">
	</cfif>
	<cflocation url="inventarioFisico-lista.cfm?1=1#params#">
</cfif>
<!---=================AGREGAR DETALLE=====================--->
<cfif isdefined("form.btnAgregarDet")>
	<cfquery datasource="#session.DSN#">
		insert into DFisico( EFid, Aid, Ecodigo, DFcantidad, DFactual, DFdiferencia, DFcostoactual, DFtotal, BMUsucodigo, BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ArtId#">,
				 #session.Ecodigo# ,
				<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.DFcantidad, ',', '', 'all')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.DFactual, ',', '', 'all')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.DFdiferencia, ',', '', 'all')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.DFcostoactual, ',', '', 'all')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.DFtotal, ',', '', 'all')#">,
				 #session.Usucodigo# ,
				<cf_dbfunction name="now"> )
	</cfquery>
	<cfset params = params & params2 >	
<!---===============MODIFICAR DETALLE==================--->	
 <cfelseif isdefined("form.btnModificar")>
 	<cfquery datasource="#session.DSN#">
		update DFisico
		set Aid = 		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ArtId#">,
		    DFcantidad =  <cfqueryparam cfsqltype="cf_sql_float"   value="#replace(form.DFcantidad, ',', '', 'all')#">,
			DFactual =    <cfqueryparam cfsqltype="cf_sql_float"   value="#replace(form.DFactual, ',', '', 'all')#">,
			DFdiferencia= <cfqueryparam cfsqltype="cf_sql_float"   value="#replace(form.DFdiferencia, ',', '', 'all')#">,
			DFcostoactual=<cfqueryparam cfsqltype="cf_sql_float"   value="#replace(form.DFcostoactual, ',', '', 'all')#">,
			DFtotal =     <cfqueryparam cfsqltype="cf_sql_float"   value="#replace(form.DFtotal, ',', '', 'all')#">
		where Ecodigo =  #session.Ecodigo# 
		  and DFlinea =  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.DFlinea#">
	</cfquery>
	<cfset params = params & params2 >	
<!---=============ELIMINAR DETALLE====================--->	
<cfelseif isdefined("form.btnEliminarDet")>
 	<cfquery datasource="#session.DSN#">
		delete from DFisico
		where Ecodigo =  #session.Ecodigo# 
		  and DFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DFlinea#">
	</cfquery>
	<cfset params = params & "&EFid=#form.EFid#">
</cfif>

<cflocation url="inventarioFisico.cfm?1=1#params#">