<cfif not isdefined("Form.Nuevo")>
	<cfquery name="dataOrigen" datasource="#Session.DSN#">
		select Otipo
		from Origenes
		where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">
		<cfif isdefined("Form._Oorigen") and Len(Trim(Form._Oorigen))>
		and Oorigen <> <cfqueryparam cfsqltype="cf_sql_char" value="#Form._Oorigen#">
		</cfif>
	</cfquery>

	<cfif isdefined("Form.Alta")>
		<cfif dataOrigen.recordCount EQ 0>
			<cfquery name="Monedas" datasource="#Session.DSN#">
				insert into Origenes (Oorigen, Odescripcion, Otipo)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Odescripcion#">,
					'E'
				)
			</cfquery>
		<cfelseif dataOrigen.Otipo EQ "S">
			<cf_errorCode	code = "50004"
							msg  = "El Código='@errorDat_1@' ya está definido como Módulo Origen en los Sistemas de SOIN"
							errorDat_1="#Form.Oorigen#"
			>
		<cfelse>
			<cf_errorCode	code = "50005"
							msg  = "El Código='@errorDat_1@' ya está definido como Módulo Origen Externo"
							errorDat_1="#Form.Oorigen#"
			>
		</cfif>

	<cfelseif isdefined("Form.Baja")>
		<cfquery name="Monedas" datasource="#Session.DSN#">
			delete from Origenes
			where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form._Oorigen#">
		</cfquery>

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="Origenes" 
			redirect="Origenes.cfm"
			timestamp="#form.ts_rversion#"
			field1="Oorigen,char,#Form._Oorigen#">			
				
		<cfif dataOrigen.recordCount EQ 0>
			<cfquery name="Monedas" datasource="#Session.DSN#">
				update Origenes set 
					Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">,
					Odescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Odescripcion#">
				where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form._Oorigen#">
			</cfquery>
		</cfif>
			  
	</cfif>
</cfif>

<form action="Origenes.cfm" method="post" name="sql">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


