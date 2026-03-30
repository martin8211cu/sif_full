
<cfif IsDefined("form.CambioObra")>
	<cftransaction>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBobra"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="OBOid"
				type1="numeric"
				value1="#form.OBOid#"
		>
	

		<cfquery datasource="#session.dsn#">
			update OBobra
			
			set 
			  OBOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOcodigo#" null="#Len(form.OBOcodigo) Is 0#">
			
			, PCDcatidObr 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatidObr#" null="#Len(form.PCDcatidObr) Is 0#">
			, PCEcatidOG	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#fnPCEcatidOG()#">
			, OBOdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOdescripcion#" null="#Len(form.OBOdescripcion) Is 0#">
			, OBOtexto = <cfif isdefined("form.OBOtexto") and Len(Trim(form.OBOtexto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOtexto#"><cfelse>null</cfif>
			
			, OBOfechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#form.OBOfechaInicio#" null="#Len(form.OBOfechaInicio) Is 0#">
			, OBOfechaFinal = <cfqueryparam cfsqltype="cf_sql_date" value="#form.OBOfechaFinal#" null="#Len(form.OBOfechaFinal) Is 0#">
			, OBOresponsable = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOresponsable#" null="#Len(form.OBOresponsable) Is 0#">
			, CFformatoObr = <cfqueryparam cfsqltype="cf_sql_char" value="#replace(form.CFformatoObr,",","-","ALL")#" null="#Len(form.CFformatoObr) Is 0#">
			, OBOavance = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBOavance#">
			
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
			where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
		</cfquery>
	</cftransaction>

	<cflocation url="OBobra.cfm?OBOid=#URLEncodedFormat(form.OBOid)#">

<cfelseif IsDefined("form.BajaObra")>

	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from OBobraLiquidacion
			where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			delete from OBobra
			where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#" null="#Len(form.OBOid) Is 0#">
		</cfquery>
	</cftransaction>
	
	<cflocation url="OBobra.cfm">
<cfelseif IsDefined("form.AltaObra")>	

	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into OBobra (
				
				Ecodigo,
				OBPid,
				OBOcodigo,
				
				PCDcatidObr,
				PCEcatidOG,
				OBOdescripcion,
				OBOtexto,
				
				OBOfechaInicio,
				OBOfechaFinal,
				OBOresponsable,
				CFformatoObr,
				
				OBOfechaInclusion,
				UsucodigoInclusion,
				OBOavance,
				
				BMUsucodigo)
			values (
				
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOcodigo#" null="#Len(form.OBOcodigo) Is 0#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatidObr#" null="#Len(form.PCDcatidObr) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#fnPCEcatidOG()#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOdescripcion#" null="#Len(form.OBOdescripcion) Is 0#">,
				<cfif isdefined("form.OBOtexto") and Len(Trim(form.OBOtexto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOtexto#"><cfelse>null</cfif>,
				
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.OBOfechaInicio#" null="#Len(form.OBOfechaInicio) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.OBOfechaFinal#" null="#Len(form.OBOfechaFinal) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOresponsable#" null="#Len(form.OBOresponsable) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(replace(form.CFformatoObr,",","-","ALL"))#" null="#Len(form.CFformatoObr) Is 0#">,
				
				
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBOavance#">,
	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			<cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnVariable="LvarOBOid">
		<cfset form.OBOid = LvarOBOid>
		<cfset form.OBOLid = "">
	</cftransaction>

	<cflocation url="OBobra.cfm?OBOid=#URLEncodedFormat(LvarOBOid)#">
<cfelseif IsDefined("form.NuevoObra")>
	<cflocation url="OBobra.cfm?NuevoObra">
<cfelseif IsDefined("form.btnAgregarCAT")>
	<cfoutput>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from PCDCatalogo 
		 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidObr#">
		   and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalorObr#">
		 <cfif form.PCEempresa EQ '1'>
		 	<cfset LvarEmpresa = " en la empresa">
		   and Ecodigo = #session.Ecodigo#
		 <cfelse>
		 	<cfset LvarEmpresa = "">
		 </cfif>
	</cfquery>
	<cfif rsSQL.cantidad NEQ 0>
		<script language="javascript">
			alert("El valor '#form.PCDvalorObr#' para el catalogo de Proyectos ya existe#LvarEmpresa#");
			history.back();
		</script>
		<cfabort>
	</cfif>

	<!--- Agregar Valor Catalogo Proyecto referenciando Catalogo anterior --->
	<cfquery datasource="#session.dsn#">
		insert into PCDCatalogo 
			(
				PCEcatid,
				PCEcatidref,
				Ecodigo,
				PCDactivo,
				PCDvalor,
				PCDdescripcion,
				Usucodigo,
				Ulocalizacion
			)
		values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidObr#">,
				null,
			<cfif form.PCEempresa EQ '1'>
				#session.Ecodigo#,
			<cfelse>
				null,
			</cfif>
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDvalorObr#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCDdescripcionObr#">,
				#session.Usucodigo#,
				'00'
			)
	</cfquery>
	
	<cflocation url="OBobra.cfm?NuevoObra">
	</cfoutput>
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBobra.cfm">
</cfif>



<cffunction name="sbLiquidacion" access="private">
	<cfif form.OBOLid EQ "">
    	<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsLiquidacion" datasource="#session.dsn#">
			insert into OBobraLiquidacion (
				OBOid,
				Ecodigo,
				CFidActivo,
				CFformatoLiquidacion,
				CFcuentaActivo,
				OBOLporcentaje,
				OBOLactivo,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFidActivo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformatoLiquidacion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaActivo#">,
				1, 'Activo ' #_Cat# <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBOdescripcion#" null="#Len(form.OBOdescripcion) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
			<cf_dbidentity1 name="rsLiquidacion" datasource="#session.dsn#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 name="rsLiquidacion" datasource="#session.dsn#" returnVariable="LvarOBOLid" verificar_transaccion="no">
		<cfset form.OBOLid = LvarOBOLid>
	</cfif>
	<cfquery datasource="#session.dsn#">
		update OBobra
		   set OBOLidDefault = #form.OBOLid#
		 where OBOid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBOid#">
	</cfquery>
</cffunction>

<cffunction name="fnPCEcatidOG" access="private">
	<cfquery datasource="#session.dsn#" name="rsOBP">
		select 	tp.Cmayor, tp.PCEMid, tp.OBTPnivelProyecto, tp.OBTPnivelObra, tp.OBTPnivelObjeto, tp.PCEcatidPry
			 ,	p.PCDcatidPry, p.PCEcatidObr
		  from OBproyecto p
			inner join OBtipoProyecto tp
			   on tp.OBTPid = p.OBTPid
		 where p.OBPid = #session.obras.OBPid#
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNdep, PCEcatid
		  from PCNivelMascara
		 where PCEMid 	= #rsOBP.PCEMid#
		   and PCNid	= #rsOBP.OBTPnivelObjeto#
	</cfquery>
	
	<!--- El nivel de Objeto de Gasto es independiente --->
	<cfif rsSQL.PCNdep EQ "">
		<cfreturn rsSQL.PCEcatid>
	</cfif>

	
	<!--- El nivel de Objeto de Gasto depende de Proyecto --->
	<cfif rsSQL.PCNdep EQ rsOBP.OBTPnivelProyecto>
		<cfset LvarPCEcatid = rsOBP.PCEcatidPry>
		<cfset LvarPCDcatid = rsOBP.PCDcatidPry>
	<!--- El nivel de Objeto de Gasto depende de Obra --->
	<cfelseif rsSQL.PCNdep NEQ rsOBP.OBTPnivelObra>
		<cfset LvarPCEcatid = rsOBP.PCEcatidObr>
		<cfset LvarPCDcatid = form.PCDcatidObr>
	<cfelse>
		<cf_errorCode	code = "50416" msg = "El Objeto de Gasto depende de un nivel diferente a Proyecto y a Obra">
	</cfif>				

	<!--- 
		Determina el Catalogo referenciado por el Valor Padre (Proyecto u Obra),
		tomando en cuenta que el Valor Padre sea por Empresa o no, y 
		tomando en cuenta si la referencia es por Mayor o no
	--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 
				case when e.PCEreferenciarMayor = 1 
					then coalesce(rm.PCEcatidref, d.PCEcatidref)
					else d.PCEcatidref
				end as PCEcatidref
		  from PCDCatalogo d
		  	inner join PCECatalogo e
			   on e.PCEcatid = d.PCEcatid
		  	 left join PCDCatalogoRefMayor rm 
			   on rm.PCDcatid	= d.PCDcatid
			  and rm.Ecodigo	= #session.Ecodigo#
			  and rm.Cmayor		= '#rsOBP.Cmayor#' 
			inner join PCECatalogo h 
			   on h.PCEcatid = 
			   			case when e.PCEreferenciarMayor = 1 
							then coalesce(rm.PCEcatidref, d.PCEcatidref)
							else d.PCEcatidref
						end
		 where d.PCDcatid	= #LvarPCDcatid# 
		   and d.Ecodigo 	= 
						case when e.PCEempresa = 1 
							then #session.Ecodigo#
							else null
						end
	</cfquery>

	<cfreturn rsSQL.PCEcatidref>
</cffunction>


