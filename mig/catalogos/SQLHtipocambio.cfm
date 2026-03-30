<cfif isdefined('form.Pfecha') and trim(form.Pfecha) EQ "">
<cfset form.Pfecha = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>
<!---Genera el Periodo en Base a la Periodicidad de la Métrica--->
<cf_dbtemp name="MIGMPeriodoV1" returnvariable="MIGMPeriodoV1" datasource="#session.DSN#">
	 <cf_dbtempcol name="Fecha"   type="date" mandatory="yes">
</cf_dbtemp>
<cfquery name="ERR" datasource="#session.DSN#">
	Insert into #MIGMPeriodoV1#
	values (<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.Pfecha)#">)
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
		#preserveSingleQuotes(YYYY)#+ #preserveSingleQuotes(PART_M)# as Periodo 
	from #MIGMPeriodoV1# a
	where 1=1 
</cfquery>
<cfset LvarMes=mid(form.Pfecha,4,2)*1>
<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsins" datasource="#Session.DSN#">
					select 1
					from MIGFactorconversion
					where Ecodigo = #Session.Ecodigo#
					and Mcodigo = #Form.Mcodigo#
					and Periodo = #rsPeriodo.Periodo#
					and Mes 	= #LvarMes#
			</cfquery>

			<cfif rsins.RecordCount GT 0>
				 <cfthrow type="toUser" message="El Periodo y el Mes que esta registrando para ese moneda ya existe. Verifique el Periodo y el Mes">
			<cfelse>
				<cftransaction>
					<cfquery datasource="#Session.DSN#">
						insert INTO MIGFactorconversion (Ecodigo,CEcodigo, Mcodigo, FechaAlta, CodFuente,Periodo,Mes,Factor,BMusucodigo,Pfecha)
						values(
							<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
							#session.CEcodigo#,
							<cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
							#now()#,
							1,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMes#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.Factor#">,
							#session.Usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_date"    value="#LSparseDateTime(form.Pfecha)#">)
					</cfquery>
				</cftransaction>
			</cfif>
		<cfelseif isdefined("Form.Baja")>
		<!--- Busca Relaciones De Mcodigo con La tabla de F_datos --->
			<cfquery name="rsRelacion" datasource="#Session.dsn#">
				select Periodo,id_datos, id_moneda_origen 
				from F_Datos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and id_moneda_origen=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#">
			</cfquery>
			<cfif rsRelacion.recordcount GT 0>
				<cfthrow type="toUser" message="No Puede Eliminar ese registro ya que tiene relacion con Datos Variables.">
			<cfelse>						
				<cftransaction>
					<cfquery datasource="#Session.DSN#">
						delete from MIGFactorconversion
						where MIGFCid=#form.MIGFCid#
						and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cftransaction>
			</cfif>
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="F_Datos" datasource="#session.dsn#">
				select Periodo,id_datos, id_moneda_origen 
				from F_Datos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and id_moneda_origen=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				and Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#"> 
			</cfquery>
			<cfif F_Datos.recordcount GT 0>
				<cfthrow type="toUser" message="No Puede Actualizar ese registro ya que tiene relacion con Datos Variables.">
			<cfelse>
				<cfquery name="rsins" datasource="#Session.DSN#">
					select MIGFCid
					from MIGFactorconversion
					where Ecodigo = #Session.Ecodigo#
					and Mcodigo = #Form.Mcodigo#
					and Periodo = #rsPeriodo.Periodo#
					and Mes 	= #LvarMes#
				</cfquery>
				<cfif rsins.MIGFCid EQ "" or rsins.MIGFCid EQ form.MIGFCid>
					<cfquery datasource="#Session.DSN#">
						update MIGFactorconversion set
							Factor=<cfqueryparam cfsqltype="cf_sql_float" value="#form.Factor#">,
							Pfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(form.Pfecha)#">,
							Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#"> 
						where MIGFCid=#form.MIGFCid#
						and Ecodigo = #session.Ecodigo#
					</cfquery>
				<cfelse>
					<cfthrow type="toUser" message="El Periodo y el Mes que esta registrando para ese moneda ya existe. Verifique el Periodo y el Mes">
				</cfif>
			</cfif>
		</cfif>
		<cfcatch type="any">
			<cfinclude template="../../sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cflocation url="Htipocambio.cfm">



