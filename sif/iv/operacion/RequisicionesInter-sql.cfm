<cfparam name="form.pageNum_lista" default="1">

<cfset Request.Debug = False>
<cfif isdefined("form.Nuevo")>
	<cflocation url="RequisicionesInter.cfm">

<cfelseif isdefined("form.btnNuevo")>
	<cflocation url="RequisicionesInter.cfm">

<cfelseif isdefined("form.NuevoDet")>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">

<cfelseif isdefined("form.btnNuevoDet")>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">

<cfelseif isdefined("form.btnAplicar") or isdefined("form.Aplicar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.ERid")>
		<cfset Cambio()>
		<cfset lista = form.ERid>
	</cfif>
	<cfset arreglo = listtoarray(lista)>
	<cfloop from="1" to="#arraylen(arreglo)#" index="idx">
		<cfinvoke Component="sif.Componentes.IN_PosteoRequis"
			method="IN_PosteoRequis"
			ERid="#arreglo[idx]#"
			Debug = "#Request.Debug#"
			RollBack = "#Request.Debug#"/>
	</cfloop>
	<cflocation url="RequisicionesInter-lista.cfm">

<cfelseif isdefined("form.Alta")>
	<!----Obtiene el consecutivo----->
	<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
				method			= "nextVal"
				returnvariable	= "LvarERdocumento"
			
				Ecodigo			= "#session.Ecodigo#"
				ORI				= "INRQ"
				REF				= "ERdocumento"
				datasource		= "#session.dsn#"
	/>
	<cfif isdefined("form.chkDevolucion") and isdefined("form.ERidref") and len(trim(form.ERidref))>
		<cftransaction>
		
		<cfquery name="rs_ERequisicion" datasource="#session.dsn#">
			select 
				Ecodigo, 
				Aid, 
				TRcodigo, 
				Dcodigo, 
				Ocodigo, 
				ERFecha, 
				ERtotal, 
				ERusuario, 
				EReferencia, 
				BMUsucodigo, 
				EcodigoRequi
		 	from HERequisicion
		 	where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#">
	 	</cfquery>

	<cfloop query="rs_ERequisicion">
		<cfquery name="insertr" datasource="#session.dsn#">
			insert INTO ERequisicion(	
				ERdescripcion, 
				Ecodigo, 
				Aid, 
				ERdocumento, 
				TRcodigo, 
				Dcodigo, 
				Ocodigo, 
				ERFecha, 
				ERtotal, 
				ERusuario, 
				EReferencia, 
				BMUsucodigo, 
				EcodigoRequi,
				ERidref
			)
			values
			(
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ERdescripcion#-#LvarERdocumento#">, 
				 #rs_ERequisicion.Ecodigo#, 
				 #rs_ERequisicion.Aid#, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarERdocumento#-#form.ERdocumento#">, 
				 '#rs_ERequisicion.TRcodigo#', 
				 #rs_ERequisicion.Dcodigo#, 
				<cfif isdefined("rs_ERequisicion.Ocodigo") and  rs_ERequisicion.Ocodigo gte 0>
					 #rs_ERequisicion.Ocodigo#, 
				 <cfelse>
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
				 </cfif>
				 '#rs_ERequisicion.ERFecha#', 
				 #rs_ERequisicion.ERtotal#, 
				 '#rs_ERequisicion.ERusuario#', 
				 <cfif isdefined("rs_ERequisicion.EReferencia") and  rs_ERequisicion.EReferencia neq ''>
					 '#rs_ERequisicion.EReferencia#', 
				 <cfelse>
					 <cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
				 </cfif>
				 <cfif isdefined("rs_ERequisicion.BMUsucodigo") and  rs_ERequisicion.BMUsucodigo gte 0>
					 #rs_ERequisicion.BMUsucodigo#, 
				 <cfelse>
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				 </cfif>
				<cfif isdefined("rs_ERequisicion.EcodigoRequi") and  rs_ERequisicion.EcodigoRequi gte 0>
					 #rs_ERequisicion.EcodigoRequi#, 
				 <cfelse>
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
				 </cfif>
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#">
			)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="insertr" datasource="#session.dsn#">
	</cfloop>
		
		<cfquery name="insert" datasource="#session.dsn#">
			insert into DRequisicion(ERid, Aid, DRcantidad, CFid, DRcosto, Kid)
			select #insertr.identity#, Aid, case  when Kunidades < 0 then Kunidades*-1 else Kunidades end, CFid, 0.00 as DRcosto, Kid
			from Kardex
			where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERidref#" >
		</cfquery>	
		</cftransaction>
		<cflocation url="RequisicionesInter.cfm?ERid=#insertr.identity#">
	<cfelse>
		<cftransaction>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into ERequisicion ( Ecodigo, ERdescripcion, Aid, ERdocumento, Ocodigo, TRcodigo, ERFecha, ERtotal, ERusuario, Dcodigo<!--- , PRJAid  --->, EcodigoRequi)
			values ( 
				<cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Form.ERdescripcion#-#LvarERdocumento#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Form.Aid#" 			 cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#LvarERdocumento#-#Form.ERdocumento#"   cfsqltype="cf_sql_char">, 
				<cfqueryparam value="#Form.Ocodigo#"       cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Form.TRcodigo#"      cfsqltype="cf_sql_char">,
				<cfqueryparam value="#LSParsedateTime(form.ERfecha)#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="0"                    cfsqltype="cf_sql_money">,
				<cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Form.Dcodigo#"       cfsqltype="cf_sql_integer"><!--- ,
				<cfif isdefined("form.PRJAid") and len(trim(form.PRJAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#"><cfelse>null</cfif> --->			
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoRequi#">		
			)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="insert" datasource="#session.dsn#">
		</cftransaction>
		<cflocation url="RequisicionesInter.cfm?ERid=#insert.identity#">
	</cfif>		

<cfelseif isdefined("form.Baja")>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from ERequisicion
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and ERid    = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	</cftransaction>
	<cflocation url="RequisicionesInter-lista.cfm">

<cfelseif isdefined("form.Cambio")>
	<cfset Cambio()>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">

<cfelseif isdefined("form.AltaDet")>
	<cfquery datasource="#session.dsn#">
		insert into DRequisicion ( ERid, Aid, DRcantidad, CFid, DRcosto )
		values ( <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#Replace(Form.DRcantidad,',','','all')#" cfsqltype="cf_sql_float">,			
				 <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">,
				 0.00 )
	</cfquery>
	<cfset Cambio()>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">

<cfelseif isdefined("form.CambioDet")>
	<cfquery datasource="#session.dsn#">
		update DRequisicion
		set Aid    = <cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">, 
			DRcantidad = <cfqueryparam value="#Replace(Form.DRcantidad,',','','all')#" cfsqltype="cf_sql_float">,
			CFid = <cfqueryparam value="#Form.CFpk#" cfsqltype="cf_sql_numeric">
		where ERid      = <cfqueryparam value="#Form.ERid#"    cfsqltype="cf_sql_numeric">
		  and DRlinea   = <cfqueryparam value="#Form.DRlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&DRlinea=#form.DRlinea#&pageNum_lista=#form.pageNum_lista#">

<cfelseif isdefined("form.BajaDet")>
	<cfquery datasource="#session.dsn#">
		delete from DRequisicion
		where ERid = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
		  and DRlinea = <cfqueryparam value="#Form.DRlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset Cambio()>
	<cflocation url="RequisicionesInter.cfm?ERid=#form.ERid#&pageNum_lista=#form.pageNum_lista#">
</cfif>

<cffunction access="private" name="Cambio" returntype="boolean">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="ERequisicion"
		redirect="RequisicionesInter.cfm"
		timestamp="#form.ts_rversion#"
		field1="ERid" 
		type1="numeric" 
		value1="#form.ERid#"
		field2="Ecodigo" 
		type2="integer" 
		value2="#session.Ecodigo#">
	<cfquery datasource="#session.dsn#">
		update ERequisicion 
		set ERdescripcion = <cfqueryparam value="#Form.ERdescripcion#" cfsqltype="cf_sql_varchar">,
			Dcodigo       = <cfqueryparam value="#Form.Dcodigo#"       cfsqltype="cf_sql_integer">,
			ERFecha       = <cfqueryparam value="#LSParsedateTime(form.ERfecha)#" cfsqltype="cf_sql_timestamp">,
			Aid           = <cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">,
			TRcodigo      = <cfqueryparam value="#form.TRcodigo#" cfsqltype="cf_sql_char">,
			Ocodigo       = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
			ERdocumento   = <cfqueryparam value="#Form.ERdocumento#" cfsqltype="cf_sql_char">,
			EcodigoRequi  = <cfqueryparam value="#form.EcodigoRequi#" cfsqltype="cf_sql_integer">
			<!--- ,
			PRJAid		  =	<cfif isdefined("form.PRJAid") and len(trim(form.PRJAid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#"><cfelse>null</cfif> --->
		where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and ERid      = <cfqueryparam value="#Form.ERid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfreturn true>
</cffunction>