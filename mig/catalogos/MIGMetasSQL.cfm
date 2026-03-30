<cfif isdefined('form.Pfecha') and trim(form.Pfecha) EQ "">
<cfset form.Pfecha = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="MIGMetas.cfm?Nuevo=Nuevo">
</cfif>

<cfif not isdefined ('form.Lista')>
	<!---Genera el Periodo en Base a la Periodicidad de la Métrica--->
	<cf_dbtemp name="MIGMPeriodo" returnvariable="MIGMPeriodo" datasource="#session.DSN#">
		 <cf_dbtempcol name="Fecha"   type="date" mandatory="yes">
	</cf_dbtemp>
	<cfquery name="ERR" datasource="#session.DSN#">
		Insert into #MIGMPeriodo#
		values (<cfqueryparam cfsqltype="cf_sql_date"    value="#LSparseDateTime(form.Pfecha)#">)
	</cfquery>

	<!--- Saca el Periodo de la Meta segun la metrica--->
	<cf_dbfunction2 name="date_part"   args="YYYY,a.Fecha"     datasource="#session.dsn#" returnVariable="YYYY">
	<cfset YYYY &= "* 1000">
	<cf_dbfunction2 name="date_format" args="a.Fecha,YYYY"   datasource="#session.dsn#" returnVariable="PART_A">
	<cf_dbfunction2 name="date_part" args="DY,a.Fecha" datasource="#session.dsn#" returnVariable="PART_D">
	<cf_dbfunction2 name="date_part" args="WK,a.Fecha" datasource="#session.dsn#" returnVariable="PART_W">
	<cf_dbfunction2 name="date_part" args="MM,a.Fecha" datasource="#session.dsn#" returnVariable="PART_M">
	<cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_T">
	<cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_Q">
	<cfquery  name="rsPeriodo" datasource="#session.dsn#">
		select a.Fecha,
			#preserveSingleQuotes(YYYY)#+
			case b.MIGMperiodicidad
						when 'D' then #preserveSingleQuotes(PART_D)#
						when 'W' then #preserveSingleQuotes(PART_W)#
						when 'M' then #preserveSingleQuotes(PART_M)#
						when 'T' then #preserveSingleQuotes(PART_T)#
						when 'A' then 1
						when 'S' then
									case when #preserveSingleQuotes(PART_Q)# <= 2 then
												1
									else
												2
									end
			end as Periodo,
			b.MIGMperiodicidad as Periodo_Tipo
		from #MIGMPeriodo# a, MIGMetricas b
		where b.MIGMid=#form.MIGMid#
		and b.Ecodigo = #session.Ecodigo#
		and b.MIGMesmetrica='I'
	</cfquery>
</cfif>
<cfif isdefined ('form.Lista')>
	<cflocation url="MIGMetas.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select MIGMetaid
		from MIGMetas
		where MIGMid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MIGMid#">
		and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#">
		and Ecodigo=#session.Ecodigo#
		and Periodo_Tipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPeriodo.Periodo_Tipo#">
	</cfquery>
	<cfif rsValida.recordCount EQ 0>
		<cftransaction>
			<cfinvoke component="mig.Componentes.MIGMetas" method="Alta" returnvariable="MIGMetaid">
				<cfinvokeargument name="MIGMid" 				value="#form.MIGMid#"/>
				<cfinvokeargument name="Pfecha" 				value="#form.Pfecha#"/>
				<cfinvokeargument name="Meta" 					value="#form.Meta#"/>
			<cfif isdefined('form.Metaadicional') and len(trim(form.Metaadicional)) GT 0>
				<cfinvokeargument name="Metaadicional" 			value="#form.Metaadicional#"/>
			<cfelse>
				<cfinvokeargument name="Metaadicional" 			value="0"/>
			</cfif>
				<cfinvokeargument name="Periodo" 				value="#rsPeriodo.Periodo#"/>
				<cfinvokeargument name="Periodo_Tipo" 			value="#rsPeriodo.Periodo_Tipo#"/>
			<cfif isdefined('form.Peso') and len(trim(form.Peso)) gt 0>
				<cfinvokeargument name="Peso" 				value="#form.Peso#"/>
			<cfelse>
				<cfinvokeargument name="Peso" 				value="0"/>
			</cfif>
				<cfinvokeargument name="Dactiva" 				value="#form.Dactiva#"/>
				<cfinvokeargument name="CodFuente" 				value="1"/>
			</cfinvoke>
		</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="La Meta que esta intentando ingresar ya existe en Sistema para esa Periodicidad.">
	</cfif>
	<cfset modo='CAMBIO'>
	<cflocation url="MIGMetas.cfm?MIGMetaid=#MIGMetaid#&modo=#modo#">
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select MIGMetaid,Periodo
		from MIGMetas
		where MIGMetaid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MIGMetaid#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif trim(rsValida.Periodo) EQ trim(rsPeriodo.Periodo)>
		<cftransaction>
			<cfinvoke component="mig.Componentes.MIGMetas" method="Cambio">
				<cfinvokeargument name="MIGMetaid" 				value="#form.MIGMetaid#"/>
				<cfinvokeargument name="Pfecha" 				value="#form.Pfecha#"/>
				<cfinvokeargument name="Meta" 					value="#form.Meta#"/>
			<cfif isdefined('form.Metaadicional') and len(trim(form.Metaadicional)) GT 0>
				<cfinvokeargument name="Metaadicional" 			value="#form.Metaadicional#"/>
			<cfelse>
				<cfinvokeargument name="Metaadicional" 			value="0"/>
			</cfif>
			<cfif isdefined('form.Peso') and len(trim(form.Peso)) gt 0>
				<cfinvokeargument name="Peso" 				value="#form.Peso#"/>
			<cfelse>
				<cfinvokeargument name="Peso" 				value="0"/>
			</cfif>
				<cfinvokeargument name="Dactiva" 				value="#form.Dactiva#"/>
			</cfinvoke>
		</cftransaction>
	<cfelse>
		<cfthrow type="toUser" message="Dicha Meta no se puede actualizar ya que la Periodicidad esta incorrecta.">
	</cfif>
<cfset modo='CAMBIO'>
<cflocation url="MIGMetas.cfm?MIGMetaid=#form.MIGMetaid#&modo=#modo#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.MIGMetas" method="Baja" >
			<cfinvokeargument name="MIGMetaid" 		value="#form.MIGMetaid#"/>
		</cfinvoke>
	</cftransaction>
<cflocation url="MIGMetas.cfm">
</cfif>

