<cfquery datasource="#session.dsn#" name="Periodo">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 30
</cfquery>
<cfquery datasource="#session.dsn#" name="Mes">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 40
</cfquery>
<cfquery datasource="#session.dsn#" name="Origen">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 40
</cfquery>
<cfif Len(enc.IDcontable) is 0>
	<cfquery datasource="#session.dsn#" name="Concepto" maxrows="1">
		select Oorigen, Cconcepto
		from ConceptoContable
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif Concepto.RecordCount is 0><cf_errorCode	code = "50340" msg = "No hay ConceptoContable definidos"></cfif>
	<cfinvoke component="sif.Componentes.Contabilidad" method="Nuevo_Asiento" returnvariable="Edocumento">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
		<cfinvokeargument name="Cconcepto" value="#Concepto.Cconcepto#">
		<cfinvokeargument name="Oorigen" value="#Concepto.Oorigen#">
		<cfinvokeargument name="Eperiodo" value="#Periodo.Pvalor#">
		<cfinvokeargument name="Emes" value="#Mes.Pvalor#">
	</cfinvoke>
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="newid">
			insert into EContables 
			(Ecodigo, Cconcepto, Eperiodo, Emes,
			Edocumento, Efecha, Edescripcion, ECusuario, Edocbase, ECauxiliar)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Concepto.Cconcepto#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo.Pvalor#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes.Pvalor#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Edocumento#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			'Asiento de prueba volumen  #DateFormat(Now(),'dd-mm-yyyy')# #TimeFormat(Now(), 'hh:mm:ss')#',
			'00', ' ', 'N')
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="newid">
	</cftransaction>
	<cfsavecontent variable="xx"><cfset dump_asiento()></cfsavecontent>

	<cfoutput>Encabezado insertado, <a href="javascript:location.reload()">click</a> para continuar</cfoutput>
</cfif>
<!---<cftransaction>--->
<cfquery datasource="#session.dsn#" name="cta4000">
	select CFcuenta
	from CFinanciera
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Cmayor = '4000'
	  and Cformato = '4000'
</cfquery>

<cfquery datasource="#session.dsn#" name="lineas" maxrows="1000">
    select a.CFcuenta, a.Ccuenta
	from PCDCatalogoCuentaF x, CFinanciera a
	where x.CFcuentaniv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cta4000.CFcuenta#">
	  and a.CFcuenta = x.CFcuenta
</cfquery>
<cfquery datasource="#session.dsn#" name="maxlinea">
	select coalesce (max(Dlinea), 0) as Dlinea
	from DContables
	where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#enc.IDcontable#">
</cfquery>
voy...
<cfloop query="lineas">
	<cfif lineas.CurrentRow mod 10 is 0><cfoutput>#lineas.CurrentRow + maxlinea.Dlinea#</cfoutput></cfif>
	<cfquery datasource="#session.dsn#">
		insert into DContables (
			Dlinea, IDcontable, Ecodigo, Cconcepto, Eperiodo, Emes,
			Edocumento, Ocodigo, Ddescripcion,
			Ddocumento, Dreferencia, Dmovimiento, 
			Ccuenta, CFcuenta,
			Doriginal, Dlocal, Mcodigo, Dtipocambio)
		values (
			#lineas.CurrentRow + maxlinea.Dlinea#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#enc.IDcontable#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#enc.Cconcepto#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo.Pvalor#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes.Pvalor#">,

			<cfqueryparam cfsqltype="cf_sql_numeric" value="#enc.Edocumento#">,
			1, 'Linea num #lineas.CurrentRow#',
			
			'0', '0', '<cfif lineas.CurrentRow mod 2>D<cfelse>C</cfif>',
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#lineas.Ccuenta#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#lineas.CFcuenta#">,
			
			500, 500, 1, 1)
	</cfquery>
</cfloop>

<!---</cftransaction>--->


