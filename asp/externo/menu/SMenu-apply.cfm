<cfset resecuenciar = false>
<cfif IsDefined("url.OP") and url.OP EQ "A">
	<cfquery datasource="asp" name="rsSRM">
		select id_root
		  from SRolMenu
		  where SScodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
		    and SRcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
		    and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
	</cfquery>
	<cfif rsSRM.recordcount EQ 0>
		<cfquery datasource="asp">
			insert into SRolMenu
				(SScodigo
				,SRcodigo
				,id_root
				,default_menu
				,BMUsucodigo
				)
			values
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
				,0
				,#session.Usucodigo#
				)
		</cfquery>
	</cfif>
	<cfreturn>
<cfelseif IsDefined("url.OP") and url.OP EQ "B">
	<cfquery datasource="asp">
		delete from SRolMenu
		 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
		   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
		   and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
	</cfquery>
	<cfreturn>
<cfelseif IsDefined("url.OP") and url.OP EQ "AD">
	<cfquery datasource="asp">
		update SRolMenu
		   set default_menu = 1
		 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
		   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
		   and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
	</cfquery>
	<cfquery datasource="asp">
		update SRolMenu
		   set default_menu = 0
		 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
		   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
		   and id_root 	<> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
	</cfquery>
	<cfreturn>
<cfelseif IsDefined("url.OP") and url.OP EQ "BD">
	<cfquery datasource="asp">
		update SRolMenu
		   set default_menu = 0
		 where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SS#" null="#Len(url.SS) Is 0#">
		   and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SR#" null="#Len(url.SR) Is 0#">
		   and id_root 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#" null="#Len(url.id) Is 0#">
	</cfquery>
	<cfreturn>
<cfelseif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="asp"
				table="SMenu"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_menu"
				type1="numeric"
				value1="#form.id_menu#"	
		>
	<cftransaction>
	<cfquery datasource="asp" name="ver_orden">
		select orden_menu
		from SMenu
		where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
	</cfquery>
	<cfif ver_orden.orden_menu neq form.orden_menu>
		<cfset resecuenciar = true>
	</cfif>
	<cfquery datasource="asp">
		update SMenu
		set nombre_menu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_menu#" null="#Len(form.nombre_menu) Is 0#">
		, descripcion_menu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion_menu#" null="#Len(form.descripcion_menu) Is 0#">
		, ocultar_menu = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ocultar_menu')#">
		, orden_menu = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden_menu#" null="#Len(form.orden_menu) Is 0#">
		<cfif Len(Trim(form.logo_menu))>
		, logo_menu = <cf_dbupload filefield="logo_menu" accept="image/*" datasource="asp">
		</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, anonimo_menu = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.anonimo_menu')#">
		, publico_menu = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.publico_menu')#">
		, default_menu = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.default_menu')#">

		where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
	</cfquery>
	<cfif IsDefined('form.publico_menu')>
		<cfquery datasource="asp">
			delete from SRolMenu
			 where id_root 	= 
			 	(
					select id_root 
					  from SMenu 
					 where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
				)
		</cfquery>
	</cfif>
	<cfif IsDefined('form.default_menu')>
		<cfquery datasource="asp">
			update SMenu
			set default_menu = 0
			where id_menu <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
			  and default_menu = 1
		</cfquery>
	</cfif>
	<cfquery datasource="asp">
		update SMenuItem
		set etiqueta_item = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_menu#" null="#Len(form.nombre_menu) Is 0#">
		where id_item = (
			select id_root from SMenu
			where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
		)
	</cfquery>
	</cftransaction>

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from SMenu
		where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>

	<cfset resecuenciar = true>

	<cftransaction >
	
	<cfinvoke component="SMenuItem" method="insertar" 
		etiqueta_item="#form.nombre_menu#"
		estereotipo="root"
		returnvariable="inserted">
	
	<cfset el_orden = Trim(form.orden_menu)>
	<cfif Len(el_orden) is 0>
		<cfquery datasource="asp" name="max_orden">
			select max(orden_menu) as max_orden
			from SMenu
		</cfquery>
		<cfif Len(max_orden.max_orden)>
			<cfset el_orden = max_orden.max_orden + 10>
			<cfset resecuenciar = false>
		<cfelse>
			<cfset el_orden = 10>
		</cfif>
	</cfif>

	<cfquery datasource="asp">
		insert into SMenu (
			id_root,
			nombre_menu,
			descripcion_menu,
			orden_menu,
			ocultar_menu,
			logo_menu,
			
			BMUsucodigo,
			BMfecha

			, anonimo_menu 
			, publico_menu 
			, default_menu 
			)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#inserted#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_menu#" null="#Len(form.nombre_menu) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion_menu#" null="#Len(form.descripcion_menu) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#el_orden#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ocultar_menu')#">,
			<cf_dbupload filefield="logo_menu" accept="image/*" datasource="asp">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">

			, <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.anonimo_menu')#">
			, <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.publico_menu')#">
			, <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.default_menu')#">
		)
	</cfquery>
	
	<cfif IsDefined('form.default_menu')>
		<cfquery datasource="asp">
			update SMenu
			set default_menu = 0
			where id_menu <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_menu#" null="#Len(form.id_menu) Is 0#">
			  and default_menu = 1
		</cfquery>
	</cfif>

	</cftransaction>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfif resecuenciar>
	<cfquery datasource="asp" name="resec">
		select id_menu, orden_menu
		from SMenu
		order by orden_menu, nombre_menu
	</cfquery>
	<cfset nuevo_orden = 0>
	<cfloop query="resec">
		<cfset nuevo_orden = nuevo_orden + 10>
		<cfif resec.orden_menu neq nuevo_orden>
			<cfquery datasource="asp">
				update SMenu
				set orden_menu = <cfqueryparam cfsqltype="cf_sql_integer" value="#nuevo_orden#">
				where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#resec.id_menu#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cfif IsDefined("form.Cambio")>
	<cflocation url="SMenu.cfm?id_menu=#URLEncodedFormat(form.id_menu)#&filtro_nombre_menu=#URLEncodedFormat(form.filtro_nombre_menu)#&filtro_orden_menu=#URLEncodedFormat(form.filtro_orden_menu)#&filtro_ocultar_x=#URLEncodedFormat(form.filtro_ocultar_x)#&PageNum_lista=#URLEncodedFormat(form.PageNum_lista)#">
<cfelse>
	<cflocation url="SMenu.cfm?filtro_nombre_menu=#URLEncodedFormat(form.filtro_nombre_menu)#&filtro_orden_menu=#URLEncodedFormat(form.filtro_orden_menu)#&filtro_ocultar_x=#URLEncodedFormat(form.filtro_ocultar_x)#&PageNum_lista=#URLEncodedFormat(form.PageNum_lista)#">
</cfif>


