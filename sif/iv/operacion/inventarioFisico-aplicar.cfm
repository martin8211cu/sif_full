<!---
Inventario Físico de Artículos por Almacén.
	-Se verifica si la cantidad del Artículo a modificar es Distinto a la existencias Actuales, Únicamente si son Distintas se realiza el Ajuste
	-En caso de ser Necesario el Ajuste se inserta el Encabezado y el detalle del mismo.
	-Se llama al Componente de Ajuste del Inventario IN_AjusteInventario.
	-Se Actualiza el Estado del documento del Estado Físico y en caso de que se realizara Ajuste, se guarda el id del Ajuste (EAid) 
--->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfloop list="#form.chk#" index="i">
	<!--- solo genera ajustes si hay diferencias --->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select count(1) as total
		from DFisico
		where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		  and Ecodigo = #session.Ecodigo#
		  and DFdiferencia <> 0
	</cfquery>		  

	<cftransaction>
		<!--- solo genera ajustes si hay diferencias --->
		<cfif rsdatos.total gt 0>
		<cfquery name="rs_ajuste" datasource="#session.dsn#">
			select 
				 Aid as Aid, 
				 EFfecha as EFfecha, 
				<cf_dbfunction name="to_char" args="EFid" > as EFid,
				'Ajuste generado por: ' #_Cat# EFdescripcion as descripcion
			from EFisico
			where EFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#i#">
			and Ecodigo =  #session.Ecodigo# 		
		</cfquery>
		
			<!--- 1. Genera Encabezado de Ajuste --->
			<cfquery name="ajuste" datasource="#session.DSN#">
				insert into EAjustes
				( 
					Aid, 
					Ecodigo, 
					EAfecha, 
					EAdocumento, 
					EAdescripcion, 
					EAusuario, 
					BMUsucodigo 
				)
					values
				( 
					#rs_ajuste.Aid#, 
					#session.Ecodigo# , 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rs_ajuste.EFfecha#">, 
					'#rs_ajuste.EFid#',
					'#rs_ajuste.descripcion#',
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#session.Usulogin#">, 
					#session.Usucodigo# 
				)
				<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 name="ajuste" datasource="#session.dsn#">
			<cfset vEAid = ajuste.identity >
			
			
			<!--- 2. Genera los detalles del Ajuste --->
			<cfquery name="insertado" datasource="#session.DSN#">
				insert into DAjustes( EAid, Aid, DAcantidad, DAcosto, DAtipo, BMUsucodigo )
				select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#vEAid#">,
					   Aid,
					   case when DFdiferencia > 0 then DFdiferencia else (DFdiferencia * -1) end,
					   case when DFtotal > 0 then DFtotal else (DFtotal * -1) end,
					   case when DFdiferencia > 0 then 0 else 1 end,		<!--- 0: positivo, 1: negativo--->
					    #session.Usucodigo# 
				from DFisico
				where EFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#i#">
				  and Ecodigo =  #session.Ecodigo# 
				  and DFdiferencia <> 0
			</cfquery>
			
	
		<!--- 3. Cambia el estado al documento de Inventario Fisico.
				 Asigna el id de ajuste al Inventario Fisico procesado.
		--->
		
		<cfquery datasource="#session.DSN#">
			update EFisico
			set EFestado = 10,
				EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEAid#">
			where Ecodigo =  #session.Ecodigo# 
			  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>	
	
	</cfif>
	</cftransaction>
	
	<!--- 4. Invoca componente de Aplicacion de Ajustes 
			 Se hace dentro de try para hechar para atras los updates 
			 y los inserta a EAjustes, DAjustes
	--->
	<!--- solo genera ajustes si hay diferencias --->
	<cfif isdefined("vEAid") >
		<cftry>
			<cfinvoke Component="sif.Componentes.IN_AjusteInventario"
				method="IN_AjusteInventario"
				EAid="#vEAid#" 
                Ktipo="I"/>
		<cfcatch type="any">
	
			<!--- devuelve el Inventario Fisico a su estado antes de aplicar  --->
			<cfquery datasource="#session.DSN#">
				update EFisico
				set EFestado = 0,
					EAid = null
				where Ecodigo =  #session.Ecodigo# 
				  and EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			
			<!--- borra detalles del ajuste de Inventario generado --->
			<cfquery datasource="#session.DSN#">
				delete from DAjustes
				where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEAid#">
			</cfquery>
	
			<!--- borra el ajuste de Inventario generado --->
			<cfquery datasource="#session.DSN#">
				delete from EAjustes
				where Ecodigo =  #session.Ecodigo# 
				  and EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vEAid#">
			</cfquery>
			<cfrethrow>
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>


