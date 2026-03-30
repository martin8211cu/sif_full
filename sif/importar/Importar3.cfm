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
		<cf_errorCode	code = "50383"
						msg  = "El archivo no contenía uno, sino @errorDat_1@ registros para @errorDat_2@"
						errorDat_1="#enc.RecordCount#"
						errorDat_2="#CurrentEIid#"
		>
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
			set EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(renameto)#">
			where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(enc.EIcodigo)#">
		</cfquery>
		<!--- Encabezado DImportador --->
		<cfquery datasource="sifcontrol" name="inserta">
			insert into EImportador 
				(EIcodigo, EImodulo, Ecodigo, EIdescripcion,
				EIdelimitador, EImod_login, EImod_fecha, EImod_usucodigo,
				EImod_ulocalizacion, EIusatemp, EItambuffer, EIparcial,
				EIverificaant, EIexporta, EIimporta, EIcfimporta, EIcfexporta,EIcfparam)
			values (
				'#UCase(rtrim(enc.EIcodigo))#',
				'#enc.EImodulo#',
				<cfif Len(enc.Ecodigo)>#enc.Ecodigo#<cfelse>null</cfif>,
				'#enc.EIdescripcion#',

				'#enc.EIdelimitador#',
				'#enc.EImod_login#',
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#enc.EImod_fecha#">, <!--- 'yyyymmdd' --->
				#enc.EImod_usucodigo#,

				'#enc.EImod_ulocalizacion#',
				#enc.EIusatemp#,
				#enc.EItambuffer#,
				#enc.EIparcial#,

				#enc.EIverificaant#,
				#enc.EIexporta#,
				#enc.EIimporta#,
				<cfif IsDefined('enc.EIcfimporta')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					'#enc.EIcfimporta#'
				<cfelse>
					' '
				</cfif>,
				<cfif IsDefined('enc.EIcfexporta')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					'#enc.EIcfexporta#'
				<cfelse>
					' '
				</cfif>,
				<cfif IsDefined('enc.EIcfparam')>
					<!--- podria ser un archivo viejo, sin EIcfimporta --->
					'#enc.EIcfparam#'
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
					(EIid, DItiporeg, DInumero, DInombre,
					DIdescripcion, DItipo, DIlongitud)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#InsertedEIid#">,
                    <cfif IsDefined('det.DItiporeg')>
                    	<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.DItiporeg#">,
                    <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_varchar"  value="-">,
                    </cfif> 
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
                    <cfif isdefined("eis.EIsqlexp") and len(trim(eis.EIsqlexp))>
						<cfqueryparam cfsqltype="cf_sql_clob" value="#eis.EIsql#">,
                    <cfelse>
                    	null,
                    </cfif>
                    <cfif isdefined("eis.EIsqlexp") and len(trim(eis.EIsqlexp))>
						<cfqueryparam cfsqltype="cf_sql_clob" value="#eis.EIsqlexp#">
                    <cfelse>
                    	null
                    </cfif>)
			</cfquery>
		</cfloop>
	</cftransaction>

	<cfoutput><cf_translate  key="LB_Terminado">Terminado</cf_translate>:  #CurrentEIid#<br></cfoutput>
</cfloop>
<cfif Not IsDefined('form.included')>
	<cflocation url="ListaImportador.cfm">
</cfif>

