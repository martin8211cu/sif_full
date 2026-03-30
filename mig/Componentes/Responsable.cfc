<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGRcodigo" type="string" required="yes">
		<cfargument name="MIGRenombre" type="string" required="yes">
		<cfargument name="MIGRecorreo" type="string" required="no">
		<cfargument name="MIGRecorreoadicional" type="string" required="no">
		<cfargument name="Dactivas" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGRcodigo) as MIGRcodigo
			from MIGResponsables
			where MIGRcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGRcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGResponsables
					(
						CodFuente,
						MIGRcodigo,
						MIGRenombre,
						Dactivas,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion,--->
						Ecodigo,
						CEcodigo,
						MIGRecorreo,
						MIGRecorreoadicional
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGRcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRenombre#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactivas#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						#session.CEcodigo#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRecorreo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRecorreoadicional#">
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGReid">
			<cfset varReturn=#LvarMIGReid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código del Responsable #rsValida.MIGRcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGRenombre" type="string" required="yes">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGResponsables
				set 
				MIGRenombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRenombre#">,
				MIGRecorreo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRecorreo#">,
				MIGRecorreoadicional=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRecorreoadicional#">,
				BMusucodigo=#session.usucodigo#
			where MIGReid=#arguments.MIGReid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	<cffunction access="public" name="Baja">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfquery name="rsvalida" datasource="#session.dsn#">
			select  count(1) as cantidad
			from MIGResponsables a
				inner join MIGMetricas b
					on a.MIGReid=b.MIGRecodigo
					and a.Ecodigo=b.Ecodigo
			where a.MIGReid=#arguments.MIGReid#
			and a.Ecodigo=#session.Ecodigo#		
		</cfquery>
		<cfquery name="rsvalida2" datasource="#session.dsn#">
			select  count(1) as cantidad
			from MIGResponsables a
				inner join MIGMetricas c
					on a.MIGReid=c.MIGReidFija
					and a.Ecodigo=c.Ecodigo
			where a.MIGReid=#arguments.MIGReid#
			and a.Ecodigo=#session.Ecodigo#			
		</cfquery>
		<cfquery name="rsvalida3" datasource="#session.dsn#">
			select  count(1) as cantidad
			from MIGResponsables a
				inner join MIGMetricas d
					on a.MIGReid=d.MIGReidduenno
					and a.Ecodigo=d.Ecodigo
			where a.MIGReid=#arguments.MIGReid#
			and a.Ecodigo=#session.Ecodigo#		
		</cfquery>
		<cfif rsvalida.cantidad GT 0 or rsvalida2.cantidad GT 0 or rsvalida3.cantidad GT 0>					
			<cfthrow type="toUser" message="El Responsable no puede ser eliminado ya que esta asociado Metricas o Indicadores">
		<cfelse>
			<cfquery datasource="#session.dsn#" name="delete">
				Delete from MIGResponsablesDepto 
				where MIGReid=#arguments.MIGReid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGResponsables
				where MIGReid=#arguments.MIGReid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="AltaDet" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="Dcodigo" type="numeric" required="yes">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfargument name="MIGRespDeptotipo" type="string" required="yes">
		<cfargument name="MIGRDeptoNivel" type="string" required="no">
		<cfargument name="MIGResptipo" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="insert">
				insert into MIGResponsablesDepto
				(
					CodFuente,
					Dcodigo,
					MIGReid,
					MIGRespDeptotipo,
					MIGRDeptoNivel,
					MIGResptipo,
					BMusucodigo,
					FechaAlta,
					Ecodigo,
					CEcodigo
				)
				values(
					1,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRespDeptotipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRDeptoNivel#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGResptipo#">,
					#session.usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					#session.Ecodigo#,
					#session.CEcodigo#
				) 
				<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="MIGRDeptoid">
		<cfset varReturn=#MIGRDeptoid#>	
		<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="CambioDet">
		<cfargument name="Dcodigo" type="numeric" required="yes">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfargument name="MIGRespDeptotipo" type="string" required="yes">
		<cfargument name="MIGRDeptoNivel" type="string" required="no">
		<cfargument name="MIGResptipo" type="string" required="yes">
		<cfargument name="MIGRDeptoid" type="numeric" required="yes">

		<cfquery datasource="#session.dsn#" name="update">
				update MIGResponsablesDepto
				set
					Dcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dcodigo#">
					,MIGReid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReid#">
					,MIGRespDeptotipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRespDeptotipo#">
				<cfif isdefined ('arguments.MIGRDeptoNivel')>
					,MIGRDeptoNivel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRDeptoNivel#">
				</cfif>
					,MIGResptipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGResptipo#">
					,BMusucodigo=#session.usucodigo#
				where MIGRDeptoid=#arguments.MIGRDeptoid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cffunction>
	
	<cffunction access="public" name="BajaDet">
		<cfargument name="MIGRDeptoid" type="numeric" required="yes">
		<cfquery datasource="#session.dsn#" name="delete">
			Delete from MIGResponsablesDepto 
			where MIGRDeptoid=#arguments.MIGRDeptoid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>