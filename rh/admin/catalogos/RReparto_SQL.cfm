<cfif isdefined('form.Alta')>
	<cfquery name="rsDate" datasource="#session.dsn#">
		select max(ERRid) as ERRid from ERegimenReparto where Ecodigo=#session.Ecodigo#		
	</cfquery>
	<!---VALIDACIONES--->
	<cfif len(trim(rsDate.ERRid)) gt 0>
		<cfquery name="rsFin" datasource="#session.dsn#">
			select ERRdesde from ERegimenReparto 
			where ERRid=#rsDate.ERRid#
     	</cfquery>
		<cfif #LSParseDateTime(form.fechad)# lt #LSParseDateTime(rsFin.ERRdesde)#>
			<cfthrow message="Se ha ingresado una fecha invalida">
		</cfif>
	</cfif>	
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into ERegimenReparto
		(ERRdesde,ERRhasta,ERRestado,BMUsucodigo,BMfecha,Ecodigo)
		values
		(
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechad)#">,
		 <cfqueryparam cfsqltype="cf_sql_date" value="01/01/6100">,
		  0,
		  #session.Usucodigo#,
		  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		  #session.Ecodigo#)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsIns">
	</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsIns" returnvariable="LvarERRid">
	
	<cfif len(trim(rsDate.ERRid)) gt 0>
		<cfquery name="rsUp" datasource="#session.dsn#">
			update ERegimenReparto set
			ERRhasta=<cf_dbfunction name="dateadd" args="-1, '#form.fechad#',dd">
			where ERRid=#rsDate.ERRid#
		</cfquery>
	</cfif>
	<cflocation url="RReparto.cfm?ERRid=#LvarERRid#">
</cfif>


<cfif isdefined ('form.Nuevo')>
	<cflocation url="RReparto.cfm">
</cfif>

<cfif isdefined ('form.btnNew')>
	<cflocation url="RReparto.cfm?ERRid=#LvarERRid#">
</cfif>

<cfif isdefined ('form.btnAgregar')>
	<cfif isdefined ('form.montoh') and len(trim(form.montoh)) eq 0>
		<cfthrow message="Se debe definir el monto hasta">
	</cfif>
	<cfif isdefined ('form.porc') and len(trim(form.porc)) eq 0>
		<cfthrow message="Se debe definir el porcentaje">
	</cfif>
	<cfif isdefined ('form.montof') and len(trim(form.montof)) eq 0>
		<cfthrow message="Se debe definir el monto fijo">
	</cfif>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select ERRestado from ERegimenReparto where ERRid=#form.LvarERRid#
	</cfquery>
	<cfif rsSQL.ERRestado eq 1>
		<cfthrow message="No se puede agregar el registro, ya que este pertenece a un Régimen de Reparto que ya fue aplicado">
	<cfelse>
		<cfquery name="rsDet" datasource="#session.dsn#">
			select max (DRRsup) as maxi from DRegimenReparto where ERRid=#form.LvarERRid#
		</cfquery>
		<cfif rsDet.maxi gte form.montoh>
			<cfthrow message="No se puede ingresar un monto inferior al máximo definido en el Monto Desde">
		</cfif>

		<cfif isdefined ('form.LvarDRRid')>
			<cfquery name="rsInsD" datasource="#session.dsn#">
				update DRegimenReparto
				set 
				DRRinf=#form.montod#,
				DRRsup=#form.montoh#,
				DRRporcentaje=#form.porc#,
				DRRmontofijo=#form.montof#
				where DRRid=#form.LvarDRRid#
				and ERRid=#form.LvarERRid#
			</cfquery>
		<cfelse>
				<cfquery name="rsVal" datasource="#session.dsn#">
					select count(1) as cantidad from DRegimenReparto where ERRid=#form.LvarERRid#
				</cfquery>
			<cfif rsVal.cantidad eq 0>
				<cfset LvarCantIni=0>
			<cfelse>
				<cfquery name="rsMax" datasource="#session.dsn#">
					select max(DRRsup) as maxi from DRegimenReparto where ERRid=#form.LvarERRid#
				</cfquery>
				<cfset LvarCantIni=rsMax.maxi+0.01>
			</cfif>
		
			<cfquery name="rsInsD" datasource="#session.dsn#">
				insert into DRegimenReparto
				(ERRid,DRRinf,DRRsup,DRRporcentaje,DRRmontofijo)
				values(
				#form.LvarERRid#,
				<cfqueryparam cfsqltype="cf_sql_money" value="#LvarCantIni#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.montoh#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.porc#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.montof#">)
			<cf_dbidentity1 datasource="#session.DSN#" name="rsInsD">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsD" returnvariable="LvarDRRid">
		</cfif>
		<cflocation url="RReparto.cfm?ERRid=#LvarERRid#">
	</cfif>
</cfif>

<cfif isdefined ('form.Cambio')>
	<cfquery name="rsDate" datasource="#session.dsn#">
		select max(ERRid) as ERRid from ERegimenReparto where Ecodigo=#session.Ecodigo#		
	</cfquery>
	<!---VALIDACIONES--->
	<cfif len(trim(rsDate.ERRid)) gt 0>
		<cfquery name="rsFin" datasource="#session.dsn#">
			select ERRdesde from ERegimenReparto 
			where ERRid=#rsDate.ERRid#
     	</cfquery>
		<cfif #LSParseDateTime(form.fechad)# lt #LSParseDateTime(rsFin.ERRdesde)#>
			<cfthrow message="Se ha ingresado una fecha invalida">
		</cfif>
	</cfif>	
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select min(ERRdesde)  as ERRdesde
			from ERegimenReparto
			where Ecodigo=#session.Ecodigo#
			and ERRestado=1
	</cfquery>
	<cfif #LSParseDateTime(form.fechad)# lt #LSParseDateTime(rsSQL.ERRdesde)#>
		<cfthrow message="No se puede ingresar una fecha de inicio menor a la fecha de inicio de la primera relación aplicada">
	</cfif>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select ERRestado from ERegimenReparto where ERRid=#form.LvarERRid#
	</cfquery>
	<cfif rsSQL.ERRestado eq 1>
		<cfthrow message="No se puede modificar el registro, ya que este pertenece a un Régimen de Reparto que ya fue aplicado">
	<cfelse>
		<cfquery name="upSQL" datasource="#session.dsn#">	
			update ERegimenReparto set 
     		ERRdesde=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechad)#">
			where ERRid=#form.LvarERRid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cfif>
	<cflocation url="RReparto.cfm?ERRid=#form.LvarERRid#">
</cfif>

<cfif isdefined ('form.Baja')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select ERRestado from ERegimenReparto where ERRid=#form.LvarERRid#
	</cfquery>
	<cfif rsSQL.ERRestado eq 1>
		<cfthrow message="No se puede eliminar el registro, ya que este pertenece a un Régimen de Reparto que ya fue aplicado">
	<cfelse>
		<cfquery name="upSQL" datasource="#session.dsn#">	
			delete from DRegimenReparto 
			where ERRid=#form.LvarERRid#
		</cfquery>
		
		<cfquery name="upSQL" datasource="#session.dsn#">	
			delete from ERegimenReparto 
			where ERRid=#form.LvarERRid#
		</cfquery>
	<cflocation url="RReparto.cfm">
	</cfif>
</cfif>

<cfif isdefined ('form.btnAplicar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select min(ERRdesde)  as ERRdesde
			from ERegimenReparto
			where Ecodigo=#session.Ecodigo#
			and ERRestado=1
	</cfquery>
	<cfif isdefined('rsSQL') and rsSQL.recordcount gt 0 and len(trim(rsSQL.ERRdesde)) gt 0 and #LSParseDateTime(form.fechad)# lt #LSParseDateTime(rsSQL.ERRdesde)#>
		<cfthrow message="No se puede ingresar una fecha de inicio menor a la fecha de inicio de la primera relación aplicada">
	<cfelse>
		<cfquery name="rsDate" datasource="#session.dsn#">
			select e.ERRid 
			from ERegimenReparto e
			where e.ERRdesde = (select max(ERRdesde)
								 from ERegimenReparto
								 where Ecodigo=1 
								 and ERRdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechad#">
								 and ERRestado=1
								 )
		</cfquery>
		<cfif rsDate.RecordCount NEQ 0>
			<!--- Caduca el detalle anterior --->
			<cfset Fhasta=DateAdd("d", -1, LSParseDateTime(Form.fechad))>
			<cfquery name="rsUpd2" datasource="#session.dsn#">
				update ERegimenReparto
				set ERRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
				where ERRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDate.ERRid#">
			</cfquery>
		</cfif>
		<cfquery name="upSQL" datasource="#session.dsn#">	
				update ERegimenReparto set 
				ERRestado=1
				where ERRid=#form.LvarERRid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cflocation url="RReparto.cfm?ERRid=#form.LvarERRid#">
	</cfif>
</cfif>

<cfif isdefined ('form.DRRid')>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select ERRestado as estado from ERegimenReparto where ERRid=(select ERRid from DRegimenReparto where DRRid=#form.DRRid# )
	</cfquery>
	<cfif rsSQL.estado eq 1>
		<cfthrow message="No se puede eliminar el registro, ya que este pertenece a un Régimen de Reparto que ya fue aplicado">
	<cfelse>
		<cfquery name="borraDet" datasource="#session.dsn#">
			delete from DRegimenReparto
			where DRRid=#form.DRRid#
		</cfquery>
		<cflocation url="RReparto.cfm?ERRid=#form.LvarERRid#">
	</cfif>
</cfif>

