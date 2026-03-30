<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGProLincodigo" type="string" required="yes">
		<cfargument name="MIGProLindescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGProLincodigo) as MIGProLincodigo
			from MIGProLineas
			where MIGProLincodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGProLincodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount eq 0>		
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGProLineas
					(
						CodFuente,
						MIGProLincodigo,
						MIGProLindescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->						
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGProLincodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProLindescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGProLinid">
			<cfset varReturn=#LvarMIGProLinid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código #rsValida.MIGProLincodigo# ya existe en el sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGProLindescripcion" type="string" required="yes">
		<cfargument name="MIGProLinid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGProLineas
				set 
				MIGProLindescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProLindescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGProLinid=#arguments.MIGProLinid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGProLinid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select  count(1) as cantidad
			from  MIGProLineas a
				inner join MIGProductos b
					on a.MIGProLinid=b.MIGProLinid
					and b.Dactiva=1
			where a.MIGProLinid=#arguments.MIGProLinid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsValida2" datasource="#session.dsn#">
			select  count(1) as cantidad
			from  MIGProLineas a
				inner join MIGProductos c
					on a.MIGProLinid=c.MIGProLinid2
					and c.Dactiva=1
			where a.MIGProLinid=#arguments.MIGProLinid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsValida3" datasource="#session.dsn#">
			select count(1) as cantidad
			from  MIGProLineas a
				inner join MIGProductos d
					on a.MIGProLinid=d.MIGProLinid3
					and d.Dactiva=1
			where a.MIGProLinid=#arguments.MIGProLinid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsValida4" datasource="#session.dsn#">
			select count(1) as cantidad
			from  MIGProLineas a
				inner join MIGProductos e
					on a.MIGProLinid=e.MIGProLinid4
					and e.Dactiva=1
			where a.MIGProLinid=#arguments.MIGProLinid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.cantidad GT 0 or rsValida2.cantidad GT 0 or rsValida3.cantidad GT 0 or rsValida4.cantidad GT 0 >	
			<cfthrow type="toUser" message="La Línea no puede ser eliminada ya que está asociada a un producto.">
		<cfelse>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGProLineas
				where MIGProLinid=#arguments.MIGProLinid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>