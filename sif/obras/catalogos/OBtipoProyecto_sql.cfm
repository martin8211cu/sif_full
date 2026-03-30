<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="OBtipoProyecto"
			redirect="metadata.code.cfm"
			timestamp="#form.ts_rversion#"
			field1="OBTPid"
			type1="numeric"
			value1="#form.OBTPid#"
	>
	<cftransaction>
		<!--- Actualiza los parametros de Liquidacion --->
		<cfif form.OBTPtipoCtaLiquidacion EQ "1">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				delete from OBTPliquidacionDet
				 where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
			</cfquery>
			<cfloop index="i" from="1" to="10">
				<cfset LvarNivel = form["OBTPLnivel#i#"]>
				<cfset LvarValor = form["OBTPLvalor#i#"]>
				<cfif LvarNivel EQ "0">
					<cfbreak>
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select PCNlongitud
					  from PCNivelMascara
					 where PCEMid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#" null="#Len(form.PCEMid) Is 0#">
					   and PCNid	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarNivel#">
				</cfquery>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into OBTPliquidacionDet
						(OBTPid, OBTPLnivel, OBTPLvalor)
					values (
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarNivel#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#right("0000000000" & LvarValor, rsSQL.PCNlongitud)#">
						)
				</cfquery>
			</cfloop>
		</cfif>
	
		<!--- Actualiza los parametros de Cedula --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			delete from OBTPcedulaObrasDet
			 where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
		</cfquery>
		<cfloop index="i" from="1" to="10">
			<cfset LvarNivel = form["OBTPCnivel#i#"]>
			<cfset LvarEncab = form["OBTPCencabezado#i#"]>
			<cfif LvarNivel EQ "0">
				<cfbreak>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPcedulaObrasDet
					(OBTPid, OBTPCcorte, OBTPCnivel, OBTPCencabezado)
				values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
					, #i#
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarNivel#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEncab#">
					)
			</cfquery>
		</cfloop>
	
		<!--- Actualiza Tipo de Proyecto --->
		<cfquery datasource="#session.dsn#">
			update OBtipoProyecto
			set OBTPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBTPcodigo#" null="#Len(form.OBTPcodigo) Is 0#">
			, OBTPdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.OBTPdescripcion#" null="#Len(form.OBTPdescripcion) Is 0#">
			, Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#Len(form.Cmayor) Is 0#">
			
			, PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#" null="#Len(form.PCEMid) Is 0#">
			, OBTPnivelProyecto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelProyecto#" null="#Len(form.OBTPnivelProyecto) Is 0#">
			, OBTPnivelObra = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObra#" null="#Len(form.OBTPnivelObra) Is 0#">
			, OBTPnivelObjeto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObjeto#" null="#Len(form.OBTPnivelObjeto) Is 0#">
			, PCCEclaidOG = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaidOG#">
			, OBTPtipoCtaLiquidacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPtipoCtaLiquidacion#" null="#Len(form.OBTPtipoCtaLiquidacion) Is 0#">
	
			, PCEcatidPry = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fnPCEcatidPry(form.Cmayor, form.PCEMid, form.OBTPnivelProyecto, form.OBTPnivelObra, form.OBTPnivelObjeto)#">
			
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
			where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
		</cfquery>
	</cftransaction>
	
	<cflocation url="OBtipoProyecto.cfm?OBTPid=#URLEncodedFormat(form.OBTPid)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBtipoProyecto
		 where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
	</cfquery>

	<cflocation url="OBtipoProyecto.cfm">
<cfelseif IsDefined("form.Alta")>	
	<cftransaction>
		<!--- 
			Buscar el primer TipoProyecto de la misma mascara
		--->
		<cfquery name="rsTP_mismaMascara" datasource="#session.dsn#">
			select OBTPid,
				case
					when
						( 
							select count(1) from OBTPliquidacionDet l
							 where l.OBTPid = tp.OBTPid
							   and tp.OBTPtipoCtaLiquidacion = 1
						) > 0
					then 2
					else 0
				end
				+
				case
					when
						( 
							select count(1) from OBTPcedulaObrasDet c
							 where c.OBTPid = tp.OBTPid
						) > 0
					then 1
					else 0
				end as Detalles
			  from OBtipoProyecto tp
			 where tp.PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#" null="#Len(form.PCEMid) Is 0#">
			 order by 2,1
		</cfquery>
		<cfquery name="insert" datasource="#session.dsn#">
			insert into OBtipoProyecto (
				OBTPcodigo,
				OBTPdescripcion,
				Ecodigo,
				Cmayor,
				
				PCEMid,
				OBTPnivelProyecto,
				OBTPnivelObra,
				OBTPnivelObjeto,
				PCCEclaidOG,
				OBTPtipoCtaLiquidacion, 
	
				PCEcatidPry,
				
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBTPcodigo#" null="#Len(form.OBTPcodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.OBTPdescripcion#" null="#Len(form.OBTPdescripcion) Is 0#">,
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#" null="#Len(form.Cmayor) Is 0#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#" null="#Len(form.PCEMid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelProyecto#" null="#Len(form.OBTPnivelProyecto) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObra#" null="#Len(form.OBTPnivelObra) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObjeto#" null="#Len(form.OBTPnivelObjeto) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaidOG#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPtipoCtaLiquidacion#" null="#Len(form.OBTPtipoCtaLiquidacion) Is 0#">,
	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#fnPCEcatidPry(form.Cmayor, form.PCEMid, form.OBTPnivelProyecto, form.OBTPnivelObra, form.OBTPnivelObjeto)#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			<cf_dbidentity1  name="insert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2  name="insert" datasource="#session.dsn#" returnvariable="LvarID">
	
		<!--- 
			Inicializa los parametros de Liquidacion:
				Si es la primera vez que se utiliza la mascara, 
					se incluye automáticamente el nivel de Objeto de Gasto
				si no
					se copia los parametros del primer Tipo de Proyecto con esa mascara
		--->
		<cfif rsTP_mismaMascara.OBTPid EQ "">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPliquidacionDet
					(OBTPid, OBTPLnivel, OBTPLvalor)
				values (#LvarID#
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObjeto#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="OBJ.GASTO">
					)
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPliquidacionDet
					(OBTPid, OBTPLnivel, OBTPLvalor)
				select #LvarID#, OBTPLnivel, OBTPLvalor
				  from OBTPliquidacionDet
				 where OBTPid = #rsTP_mismaMascara.OBTPid#
			</cfquery>
		</cfif>

		<!--- 
			Inicializa los parametros de Cedula:
				Si es la primera vez que se utiliza la mascara, 
					se incluye automáticamente los niveles de Proyecto y Obra
				si no
					se copia los parametros del primer Tipo de Proyecto con esa mascara
		--->
		<cfif rsTP_mismaMascara.OBTPid EQ "">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPcedulaObrasDet
					(OBTPid, OBTPCcorte, OBTPCnivel, OBTPCencabezado)
				values (#LvarID#
					, 1
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelProyecto#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="Proyecto">
					)
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPcedulaObrasDet
					(OBTPid, OBTPCcorte, OBTPCnivel, OBTPCencabezado)
				values (#LvarID#
					, 2
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OBTPnivelObra#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="Obra">
					)
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OBTPcedulaObrasDet
					(OBTPid, OBTPCcorte, OBTPCnivel, OBTPCencabezado)
				select #LvarID#, OBTPCcorte, OBTPCnivel, OBTPCencabezado
				  from OBTPcedulaObrasDet
				 where OBTPid = #rsTP_mismaMascara.OBTPid#
			</cfquery>
		</cfif>
	</cftransaction>
	
	<cflocation url="OBtipoProyecto.cfm?OBTPid=#URLEncodedFormat(LvarID)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBtipoProyecto.cfm?btnNuevo">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBtipoProyecto.cfm">
</cfif>

<cffunction name="fnPCEcatidPry" returntype="numeric">
	<cfargument name="Cmayor"				type="string">
	<cfargument name="PCEMid"				type="numeric">
	<cfargument name="OBTPnivelProyecto"	type="numeric">
	<cfargument name="OBTPnivelObra"		type="numeric">
	<cfargument name="OBTPnivelObjeto"		type="numeric">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCEMid
		  from CPVigencia
		 where Ecodigo 	= #session.Ecodigo#
		   and Cmayor	= '#Arguments.Cmayor#'
		   and #dateFormat(now(),"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cf_errorCode	code = "50419"
						msg  = "La cuenta mayor '@errorDat_1@' no está vigente en este momento"
						errorDat_1="#Arguments.Cmayor#"
		>
	<cfelseif rsSQL.PCEMid NEQ arguments.PCEMid>
		<cf_errorCode	code = "50420" msg = "La máscara no está vigente en este momento">
	</cfif>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select max(PCNid) as maximo
		  from PCNivelMascara
		 where PCEMid 	= #Arguments.PCEMid#
	</cfquery>
	<cfset LvarMaxNivel = rsSQL.maximo>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNdep, PCEcatid
		  from PCNivelMascara
		 where PCEMid 	= #Arguments.PCEMid#
		   and PCNid	= #Arguments.OBTPnivelProyecto#
	</cfquery>
	<cfif Arguments.OBTPnivelProyecto GT LvarMaxNivel>
		<cf_errorCode	code = "50421"
						msg  = "El nivel de Proyecto @errorDat_1@ es mayor al numero de niveles de la mascara"
						errorDat_1="#Arguments.OBTPnivelObra#"
		>
	<cfelseif rsSQL.PCNdep NEQ "">
		<cf_errorCode	code = "50422"
						msg  = "El nivel de Proyecto @errorDat_1@ debe ser un nivel independiente en la Máscara"
						errorDat_1="#Arguments.OBTPnivelProyecto#"
		>
	</cfif>
	<cfset LvarPCEcatidPry = rsSQL.PCEcatid>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNdep, PCEcatid
		  from PCNivelMascara
		 where PCEMid 	= #Arguments.PCEMid#
		   and PCNid	= #Arguments.OBTPnivelObra#
	</cfquery>
	<cfif Arguments.OBTPnivelObra GT LvarMaxNivel>
		<cf_errorCode	code = "50423"
						msg  = "El nivel de Obra @errorDat_1@ es mayor al numero de niveles de la mascara"
						errorDat_1="#Arguments.OBTPnivelObra#"
		>
	<cfelseif rsSQL.PCNdep NEQ Arguments.OBTPnivelProyecto>
		<cf_errorCode	code = "50424"
						msg  = "El nivel de Obra @errorDat_1@ debe depender del nivel de Proyecto @errorDat_2@ en la Máscara"
						errorDat_1="#Arguments.OBTPnivelObra#"
						errorDat_2="#Arguments.OBTPnivelProyecto#"
		>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select PCNdep, PCEcatid
		  from PCNivelMascara
		 where PCEMid 	= #Arguments.PCEMid#
		   and PCNid	= #Arguments.OBTPnivelObjeto#
	</cfquery>
	<cfif Arguments.OBTPnivelObjeto GT LvarMaxNivel>
		<cf_errorCode	code = "50425"
						msg  = "El nivel de Objeto de Gasto @errorDat_1@ es mayor al numero de niveles de la mascara"
						errorDat_1="#Arguments.OBTPnivelObjeto#"
		>
	<cfelseif rsSQL.PCNdep NEQ "" AND rsSQL.PCNdep NEQ Arguments.OBTPnivelProyecto AND rsSQL.PCNdep NEQ Arguments.OBTPnivelObra>
		<cf_errorCode	code = "50426"
						msg  = "El nivel de Objeto de Gasto @errorDat_1@ debe ser un nivel independiente, o depender del nivel de Proyecto @errorDat_2@, o depender del nivel de Obra @errorDat_3@ en la Máscara"
						errorDat_1="#Arguments.OBTPnivelObjeto#"
						errorDat_2="#Arguments.OBTPnivelProyecto#"
						errorDat_3="#Arguments.OBTPnivelProyecto#"
		>
	</cfif>
	<cfreturn LvarPCEcatidPry>
</cffunction>


