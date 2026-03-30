<cfparam name="form.PRJid" type="numeric">

<cfscript>
function qf(s){
	return Replace(s,',','','all');
}
function Ajustar(valor,longitud){
	if (Len(valor) ge longitud) return valor;
	return RepeatString('0', longitud-len(valor))&valor;
}
</cfscript>

		
	<cfquery datasource="#session.dsn#" name="q_proyecto">
		select
			c.PCElongitud, p.PCEcatidActividad, p.PRJcodigo, p.Cmayor
		from PRJproyecto p
			join PCECatalogo c
				on c.PCEcatid = p.PCEcatidActividad
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and p.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	</cfquery>


	<cffunction name="armar_cuenta" returntype="query">
		<cfargument name="PRJRid" type="numeric">
		
		<cfquery datasource="#session.dsn#" name="rec">
			select PRJRcodigo from PRJRecurso
			where PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PRJRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfset CtaMayor= q_proyecto.Cmayor>
		<cfset Detalle= q_proyecto.PRJcodigo & '-' & form.PRJAcodigo & '-' & rec.PRJRcodigo>

		<cfinvoke 
					component="sif.Componentes.PC_GeneraCuentaFinanciera "
					method="fnGeneraCuentaFinanciera"
					returnvariable="MSG">
			<cfinvokeargument name="Lprm_Cmayor" value="#CtaMayor#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#Detalle#"/>
			<cfinvokeargument name="Lprm_fecha" value="#Now()#"/>
			<cfinvokeargument name="Lprm_Ocodigo" value="#form.Ocodigo#"/>
			<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
			<cfinvokeargument name="Lprm_debug" value="false"/>
		</cfinvoke>
		<cfif MSG NEQ "NEW" AND MSG NEQ "OLD">
			<cf_errorCode	code = "50557"
							msg  = "Error(1): @errorDat_1@ para recurso @errorDat_2@"
							errorDat_1="#MSG#"
							errorDat_2="#rec.PRJRcodigo#"
			>
		</cfif>
		<cfinvoke 
				component="sif.Componentes.PC_GeneraCuentaFinanciera "
				method="fnGeneraCuentaFinanciera"
				returnvariable="MSG">
			<cfinvokeargument name="Lprm_Cmayor" value="#CtaMayor#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#Detalle#"/>
			<cfinvokeargument name="Lprm_fecha" value="#Now()#"/>
			<cfinvokeargument name="Lprm_Ocodigo" value="#form.Ocodigo#"/>
			<cfinvokeargument name="Lprm_CrearPresupuesto" value="false"/>
			<cfinvokeargument name="Lprm_debug" value="false"/>
		</cfinvoke>
		<cfif MSG NEQ "NEW" AND MSG NEQ "OLD">
			<cf_errorCode	code = "50558"
							msg  = "Error(2): @errorDat_1@ para recurso @errorDat_2@"
							errorDat_1="#MSG#"
							errorDat_2="#rec.PRJRcodigo#"
			>
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="regresar">
			select CFcuenta, CPcuenta
			from CFinanciera
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CtaMayor#-#Detalle#">
		</cfquery>
		
		<cfif regresar.RecordCount is 0>
			<cf_errorCode	code = "50559" msg = "No se pudo crear la cuenta financiera">
		</cfif>
		
		<cfreturn regresar>

	</cffunction>

	<cffunction name="control_presupuesto" output="yes">
		<cfargument name="PRJRid" type="numeric">
		
		<cfquery name="rsCostos" datasource="#session.dsn#">
			select pr.PRJPRcostoUnitEstimado*ar.PRJARcantidadEstimada as CostoPresupuestado
				,  pr.PRJPRcostoUnitModificado*ar.PRJARcantidadModificada as CostoModificado
				,  p.Mcodigo
			from PRJProyectoRecurso pr, PRJActividadRecurso ar, PRJproyecto p
			where p.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
			  and pr.PRJid = p.PRJid
			  and pr.PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PRJRid#">
			  and ar.PRJid = p.PRJid
			  and ar.PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
			  and ar.PRJRid = pr.PRJRid
		</cfquery>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(*) as cantidad
			from CPresupuestoControl
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CPCano = #datepart("yyyy",now())#
			  and CPCmes = #datepart("m",now())#
			  and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.CPcuenta#">
			  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfquery datasource="#session.dsn#">
				update CPresupuestoControl
				   set CPCpresupuestado = #rsCostos.CostoPresupuestado#
					 , CPCmodificado = #rsCostos.CostoModificado-rsCostos.CostoPresupuestado#
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and CPCano = #datepart("yyyy",now())#
				  and CPCmes = #datepart("m",now())#
				  and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.CPcuenta#">
				  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			  </cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsSQL">
				select CPPid
				from CPresupuestoPeriodo
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and #now()# between CPPfechaDesde and CPPfechaHasta
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "50560" msg = "No existe período de presupuesto">
			</cfif>
			
			<cfquery datasource="#session.dsn#">
				insert into CPresupuestoControl
					(Ecodigo, CPPid, CPCano, CPCmes,CPcuenta, Ocodigo, 
					 CPCpresupuestado, CPCmodificado, CPCvariacion, CPCtrasladado, 
					 CPCreservado_Anterior, CPCcomprometido_Anterior, 
					 CPCreservado_Presupuesto, 
					 CPCreservado, CPCcomprometido,
					 CPCejecutado)
				values (
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, #rsSQL.CPPid#
					, #datePart("yyyy",now())#
					, #datePart("m",now())#
					, #rsCuentas.CPcuenta#
					, #form.Ocodigo#
					, #rsCostos.CostoPresupuestado#
					, #rsCostos.CostoModificado - rsCostos.CostoPresupuestado#
					,0,0,0,0,0,0,0,0
				)
			  </cfquery>
		</cfif>
	</cffunction>
		

	
<cfif isdefined('form.alta')>
	<cftransaction>

		<cfquery name="rsDetCatalogoActividad" datasource="#Session.DSN#">
			insert into PCDCatalogo(PCEcatid, PCEcatidref, Ecodigo, PCDactivo, PCDvalor, PCDdescripcion, Usucodigo, Ulocalizacion)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#q_proyecto.PCEcatidActividad#">, 
				null,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ajustar(Trim(Form.PRJAcodigo), q_proyecto.PCElongitud)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJAdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				'00')
		</cfquery>

		<cfquery datasource="#session.dsn#" name="padre">
			select PRJApath, PRJAnivel from PRJActividad
			where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
			  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.last_PRJAidPadre#" null="#Len(form.last_PRJAidPadre) is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#" name="ultimo_hermano">
			select coalesce (max(PRJAorden), 0) as PRJAorden from PRJActividad
			where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
			  and PRJAidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.last_PRJAidPadre#" null="#Len(form.last_PRJAidPadre) is 0#">
		</cfquery>
		<cfset PRJAorden = ultimo_hermano.PRJAorden+10>
		<cfquery datasource="#session.dsn#" name="inserta">
			insert into PRJActividad (
				PRJid, PRJAnivel, PRJAorden, PRJAcodigo,
				PRJAdescripcion, PRJAduracion, PRJAunidadTiempo, PRJAfechaInicio,
				PRJAfechaFinal, PRJAporcentajeAvance, PRJAcostoActual, PRJApath,
				PRJAidPadre, Ecodigo, SNcodigo, Ocodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">,
				<cfif Len(padre.PRJAnivel)>#padre.PRJAnivel+1#<cfelse>0</cfif>, <!--- NIVEL --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJAorden#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAcodigo#">,

				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAduracion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAunidadTiempo#">,
				<cfif Len(Trim(form.PRJAfechaInicio)) is 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Trim(form.PRJAfechaInicio))#"></cfif>,

				<cfif Len(Trim(form.PRJAfechaFinal)) is 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Trim(form.PRJAfechaFinal))#"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.PRJAporcentajeAvance)#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#padre.PRJApath#/#NumberFormat(PRJAorden,'0000000')#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.last_PRJAidPadre#" null="#Len(form.last_PRJAidPadre) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#" null="#Len(form.SNcodigo) is 0#">
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name='inserta'>
	</cftransaction>
	<cfset form.PRJAid=inserta.identity>
<cfelseif isdefined('form.cambio')>
	<cf_dbtimestamp
        datasource="#session.dsn#"
     table="PRJActividad"
     redirect="Actividades.cfm"
     timestamp="#form.ts_rversion#"
     field1="PRJAid" type1="numeric" value1="#form.PRJAid#"
     field2="PRJid" type2="numeric" value2="#form.PRJid#">

	<cfif form.PRJAcodigo_ant neq PRJAcodigo>
	</cfif>
		<cfquery name="rsDetCatalogoActividad" datasource="#Session.DSN#">
			update PCDCatalogo
			   set PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ajustar(Trim(Form.PRJAcodigo), q_proyecto.PCElongitud)#">,
				   PCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJAdescripcion#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_proyecto.PCEcatidActividad#">
			and PCDvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.PRJAcodigo_ant)#">
			if @@rowcount = 0
			insert into PCDCatalogo(PCEcatid, PCEcatidref, Ecodigo, PCDactivo, PCDvalor, PCDdescripcion, Usucodigo, Ulocalizacion)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#q_proyecto.PCEcatidActividad#">, 
				null,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ajustar(Trim(Form.PRJAcodigo), q_proyecto.PCElongitud)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PRJAdescripcion#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				'00')
		</cfquery>

	<cfquery datasource="#session.dsn#">
		update PRJActividad
		set PRJAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAcodigo#">,
			PRJAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAdescripcion#">,
			PRJAduracion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAduracion#">,
			PRJAunidadTiempo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRJAunidadTiempo#">,
			PRJAfechaInicio = <cfif Len(Trim(form.PRJAfechaInicio)) is 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Trim(form.PRJAfechaInicio))#"></cfif>,
			PRJAfechaFinal = <cfif Len(Trim(form.PRJAfechaFinal)) is 0>null<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Trim(form.PRJAfechaFinal))#"></cfif>,
			PRJAporcentajeAvance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.PRJAporcentajeAvance)#">,
			SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#" null="#Len(form.SNcodigo) is 0#">,
			Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		where PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
		  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	</cfquery>
<cfelseif isdefined('form.baja')>
	<cfquery datasource="#session.dsn#">
		delete PRJActividad
		where PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
		  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete PRJActividadRecurso
		where PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
		  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	</cfquery>
</cfif>


<cfif isdefined('form.cambio') or isdefined('form.alta')>
	<cfif Len(form.PRJRid)>
		<cfset rsCuentas = armar_cuenta(form.PRJRid)>
		<cfquery datasource="#session.dsn#">
			insert PRJActividadRecurso (
				PRJid, PRJAid, PRJRid, CFcuenta, PRJARcantidadEstimada, PRJARcantidadModificada, PRJARcantidadReal, PRJARcostoReal
			) values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.CFcuenta#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.cant_0)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.cant_0)#">,
				0,0)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update PRJProyectoRecurso
			set PRJPRcostoUnitModificado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.cost_0)#">
			where PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">
			  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
			if @@rowcount = 0 
			    insert into PRJProyectoRecurso (
					PRJRid, PRJid, Ecodigo, PRJPRcostoUnitEstimado, PRJPRcostoUnitModificado)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJRid#">,
			  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">,
			  		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.cost_0)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form.cost_0)#">)
		</cfquery>
		<cfset control_presupuesto(form.PRJRid)>
	</cfif>
	<cfif IsDefined('form.PRJRAid')>
		<cfloop list="#form.PRJRAid#" index="PRJRAid">
			<cfquery datasource="#session.dsn#" name="activ_recurs">
				select PRJRid
				from PRJActividadRecurso
				where PRJActividadRecurso.PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
				  and PRJActividadRecurso.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
				  and PRJActividadRecurso.PRJRAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJRAid#">
			</cfquery>
			<cfset rsCuentas = armar_cuenta(activ_recurs.PRJRid)>
			<cfquery datasource="#session.dsn#">
				update PRJActividadRecurso
				set PRJARcantidadModificada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form['cant_'&PRJRAid])#">
				, CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentas.CFcuenta#">
				where PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
				  and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
				  and PRJRAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJRAid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update PRJProyectoRecurso
				set PRJPRcostoUnitModificado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qf(form['cost_'&PRJRAid])#">
				from PRJProyectoRecurso
				where PRJProyectoRecurso.PRJRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#activ_recurs.PRJRid#">
				  and PRJProyectoRecurso.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
			</cfquery>
			<cfset control_presupuesto(activ_recurs.PRJRid)>
		</cfloop>
	</cfif>
</cfif>


<cflocation url="Actividades.cfm?PRJid=#URLEncodedFormat(form.PRJid)#&PRJAid=#URLEncodedFormat(form.PRJAid)#" addtoken="no">
<cfoutput>
<a href="Actividades.cfm?PRJid=#URLEncodedFormat(form.PRJid)#&PRJAid=#URLEncodedFormat(form.PRJAid)#">seguir</a>
</cfoutput>

