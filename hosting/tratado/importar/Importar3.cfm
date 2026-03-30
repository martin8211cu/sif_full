<cfparam name="form.eiid" default="">
<cfset qenc = session.importar_enc>
<cfset qdet = session.importar_det>
<cfset qeis = session.importar_eis>

<cfloop from="1" to="#ListLen(form.eiid)#" index="current">
	<cfset CurrentEIid = ListGetAt(form.EIid,Current)>
	<cfoutput><cf_translate  key="LB_Procesando">Procesando</cf_translate>: #CurrentEIid#<br></cfoutput>

	<cfquery dbtype="query" name="enc">
		select * from qenc
		where EIid = #CurrentEIid#
	</cfquery>
	<cfif enc.RecordCount NEQ 1>
		<cfthrow message="El archivo no contenía uno, sino #enc.RecordCount# registros para #CurrentEIid#">
	</cfif>
	
	<cfquery dbtype="query" name="det">
		select *
		from qdet
		where EIid = #CurrentEIid#
	</cfquery>

	<cfquery dbtype="query" name="eis">
		select *
		from qeis
		where EIid = #CurrentEIid#
	</cfquery>

	<cftransaction>
		<!--- Renombrar anterior --->
		<cfset prefix = Trim(Left(enc.EIcodigo,8))>
		<cfquery datasource="sifcontrol" name="maxcodigo" maxrows="1">
			select EIcodigo
			from EImportador
			where EIcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#prefix#.%">
			order by 1 desc
		</cfquery>
		<cfif Len(maxcodigo.EIcodigo)>
			<cfset maxext = Trim(Mid(maxcodigo.EIcodigo,Len(prefix)+2,3))+1>
		<cfelse>
			<cfset maxext = 1>
		</cfif>
		<cfset renameto = UCase(Trim(Left(enc.EIcodigo,8))) & '.' & NumberFormat(maxext,'000')>
		<cfquery datasource="sifcontrol">
			update EImportador
			set EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renameto#">
			where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#enc.EIcodigo#">
		</cfquery>
		<!--- Encabezado DImportador --->
		<cfquery datasource="sifcontrol" name="inserta">
			insert into EImportador 
				(EIcodigo, EImodulo, Ecodigo, EIdescripcion,
				EIdelimitador, EImod_login, EImod_fecha, EImod_usucodigo,
				EImod_ulocalizacion, EIusatemp, EItambuffer, EIparcial,
				EIverificaant, EIexporta, EIimporta, EIcfimporta, EIcfexporta,EIcfparam)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#UCase(enc.EIcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#enc.EImodulo#">,
				<cfif Len(enc.Ecodigo)><cfqueryparam cfsqltype="cf_sql_numeric"  value="#enc.Ecodigo#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#enc.EIdescripcion#">,

				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#enc.EIdelimitador#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#enc.EImod_login#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#enc.EImod_fecha#">, <!--- 'yyyymmdd' --->
				<cfqueryparam cfsqltype="cf_sql_numeric"  value="#enc.EImod_usucodigo#">,

				<cfqueryparam cfsqltype="cf_sql_varchar" value="#enc.EImod_ulocalizacion#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#enc.EIusatemp#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#enc.EItambuffer#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#enc.EIparcial#">,

				<cfqueryparam cfsqltype="cf_sql_integer"     value="#enc.EIverificaant#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#enc.EIexporta#">,
				<cfqueryparam cfsqltype="cf_sql_bit"     value="#enc.EIimporta#">,
				<cfif IsDefined('enc.EIcfimporta')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#enc.EIcfimporta#">
				<cfelse>
					' '
				</cfif>,
				<cfif IsDefined('enc.EIcfexporta')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#enc.EIcfexporta#">
				<cfelse>
					' '
				</cfif>,
				<cfif IsDefined('enc.EIcfparam')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#enc.EIcfparam#">
				<cfelse>
					' '
				</cfif>
				)
			<cf_dbidentity1 datasource="sifcontrol">
		</cfquery>
		<cf_dbidentity2 datasource="sifcontrol" name="inserta">
		<cfset InsertedEIid = inserta.identity>
		<!--- Detalle DImportador --->
		<cfloop query="det">
			<cfquery datasource="sifcontrol">
				insert into DImportador
					(EIid, DInumero, DInombre,
					DIdescripcion, DItipo, DIlongitud)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#InsertedEIid#">,
					<cfqueryparam cfsqltype="cf_sql_integer"      value="#det.DInumero#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.DInombre#">,

					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.DIdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.DItipo#">,
					<cfqueryparam cfsqltype="cf_sql_integer"      value="#det.DIlongitud#">)
			</cfquery>
		</cfloop>
		<!--- Detalle SQL --->
		<cfloop query="eis">
			<cfquery datasource="sifcontrol">
				insert into EISQL
					(EIid, EIsql, EIsqlexp)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric"     value="#InsertedEIid#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#eis.EIsql#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#eis.EIsqlexp#">)
			</cfquery>
		</cfloop>
	</cftransaction>

	<cfoutput><cf_translate  key="LB_Terminado">Terminado</cf_translate>:  #CurrentEIid#<br></cfoutput>
</cfloop>
<cfif Not IsDefined('form.included')>
	<cflocation url="ListaImportador.cfm">
</cfif>