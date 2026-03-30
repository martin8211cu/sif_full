<cfif not isdefined("session.Tesoreria.CatIni")>
	<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbInicializaCatalogos">
</cfif>

<cfif IsDefined("form.Cambio")>
	<cfif isdefined('form.TEScodigo') and len(trim(form.TEScodigo)) and isdefined('form.TEScodigoOrig') and len(trim(form.TEScodigoOrig))>
		<cfif form.TEScodigo NEQ form.TEScodigoOrig>
			<cfquery name="rsValida" datasource="#session.dsn#">
				select 1
				  from Tesoreria
				 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				   and TEScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TEScodigo#">
			</cfquery>

			<cfif isdefined('rsValida') and rsvalida.recordCount GT 0>
				<cf_errorCode	code = "50782" msg = "El código digitado ya existe para esta cuenta empresarial">
			</cfif>
		</cfif>
		
		<cf_dbtimestamp datasource="#session.dsn#"
				table="Tesoreria"
				redirect="Tesoreria.cfm"
				timestamp="#form.ts_rversion#"
				field1="TESid"
				type1="numeric"
				value1="#form.TESid#"
		>
		<cfquery datasource="#session.dsn#">
			update Tesoreria
			set TESdescripcion = <cfqueryparam cfsqltype="cf_sql_char" 	value="#form.TESdescripcion#" null="#Len(form.TESdescripcion) Is 0#">
			, CEcodigo = 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.CEcodigo#">
			, TEScodigo = 	<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.TEScodigo#">
			, CPNAPnum = 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CPNAPnum#" null="#form.CPNAPnum EQ ''#">
			, EcodigoAdm =	<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">
			where TESid = 	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESid#" null="#Len(form.TESid) Is 0#">
		</cfquery>
		
		<cfif isdefined('form.chk')>
			<cfset llaves = ListToArray(form.chk)>
			<cfloop from="1" to="#ArrayLen(llaves)#" index="i">
				<cfquery datasource="#session.dsn#">
					insert INTO TESempresas 
						(Ecodigo, TESid, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#llaves[i]#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
				</cfquery>
			</cfloop>	
		</cfif>			
	</cfif>
<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from TESempresas
			where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from TEScentrosFuncionales
			where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from TESCFestados
			where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from Tesoreria
			where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#" null="#Len(form.TESid) Is 0#">
		</cfquery>
	</cftransaction>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select 1
		from Tesoreria
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and TEScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TEScodigo#">
	</cfquery>

	<cfif isdefined('rsValida') and rsvalida.recordCount GT 0>
		<cf_errorCode	code = "50782" msg = "El código digitado ya existe para esta cuenta empresarial">
	<cfelse>
		<cftransaction>
			<cfquery name="insert" datasource="#session.dsn#">
				insert into Tesoreria (
					TESdescripcion,
					TEScodigo,			
					CEcodigo,
					EcodigoAdm,
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESdescripcion#" null="#Len(form.TESdescripcion) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.TEScodigo#">,						
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,			
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESid">

			<cfquery datasource="#session.dsn#">
				insert into TESCFestados (TESid, TESCFEcodigo, TESCFEdescripcion, TESCFEimpreso)
				values (#LvarTESid#, 'IMP', 'Impreso', 1)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into TESCFestados (TESid, TESCFEcodigo, TESCFEdescripcion, TESCFEentregado)
				values (#LvarTESid#, 'ENT', 'Entregado', 1)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into TESCFestados (TESid, TESCFEcodigo, TESCFEdescripcion, TESCFEentregado)
				values (#LvarTESid#, 'EN2', 'Devuelto', 1)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into TESCFestados (TESid, TESCFEcodigo, TESCFEdescripcion, TESCFEanulado)
				values (#LvarTESid#, 'ANU', 'Anulado', 1)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into TESCFestados (TESid, TESCFEcodigo, TESCFEdescripcion)
				values (#LvarTESid#, '000', 'Custodia')
			</cfquery>
		</cftransaction>
	</cfif>
<cfelseif IsDefined("url.OPaltaE")>
	<cf_navegacion name="TESid"		navegacion="">
	<cf_navegacion name="Ecodigo"	navegacion="">
	<cfquery datasource="#session.dsn#">
		insert into TESempresas
			( TESid, Ecodigo, BMUsucodigo )
		values (
		 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
		   	,	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
		   	,	#session.Usucodigo#
			)
	</cfquery>
	<cflocation url="Tesoreria.cfm?TESid=#form.TESid#">
<cfelseif IsDefined("url.OPbajaE")>
	<cf_navegacion name="TESid"		navegacion="">
	<cf_navegacion name="Ecodigo"	navegacion="">
	<cfquery datasource="#session.dsn#">
		delete from TESempresas
		 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
		   and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo#">
	</cfquery>
	<cflocation url="Tesoreria.cfm?TESid=#form.TESid#">
<cfelseif IsDefined("url.OPaltaCF")>
	<cf_navegacion name="TESid"		navegacion="">
	<cf_navegacion name="CFid"	navegacion="">
	<cf_navegacion name="CF_Ecodigo" default="-1" session>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select e.Edescripcion, cf.CFcodigo, cf.CFdescripcion
				, m.Miso4217
				, m_adm.Miso4217 as Miso4217ADM
				, tcf.CFid as repetido
				, t.TESdescripcion
		  from CFuncional cf
			inner join Empresas adm
					inner join Monedas m_adm
						on m_adm.Mcodigo = adm.Mcodigo
				on adm.Ecodigo = #session.Ecodigo#
		  	inner join Empresas e
					inner join Monedas m
						on m.Mcodigo = e.Mcodigo
				on e.Ecodigo = cf.Ecodigo
			left join TEScentrosFuncionales tcf
				inner join Tesoreria t
					on t.TESid = tcf.TESid
				on tcf.CFid = cf.CFid
		 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfif rsSQL.Miso4217 NEQ rsSQL.Miso4217ADM>
		<cfoutput>
		<script language="javascript">
			alert ("Centro Funcional '#trim(rsSQL.CFcodigo)# - #trim(rsSQL.CFdescripcion)#' pertenece a la Empresa '#rsSQL.Edescripcion#' cuya moneda local es diferente a la de la Empresa Administradora");
			location.href="Tesoreria.cfm?TESid=#form.TESid#";
		</script>
		</cfoutput>
		<cfabort>
	<cfelseif rsSQL.Repetido NEQ "">
		<cfoutput>
		<script language="javascript">
			alert ("Centro Funcional '#trim(rsSQL.CFcodigo)# - #trim(rsSQL.CFdescripcion)#' ya pertenece a la Tesorería '#rsSQL.TESdescripcion#'");
			location.href="Tesoreria.cfm?TESid=#form.TESid#";
		</script>
		</cfoutput>
		<cfabort>
	</cfif>

	<cfquery datasource="#session.dsn#">
		insert into TEScentrosFuncionales
			( TESid, CFid, Ecodigo, CFcodigo, BMUsucodigo )
		select 
		 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
			,	CFid
		   	,	Ecodigo
			,	CFcodigo
		   	,	#session.Usucodigo#
		  from CFuncional
		 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cflocation url="Tesoreria.cfm?TESid=#form.TESid#">
<cfelseif IsDefined("url.OPbajaCF")>
	<cf_navegacion name="TESid"		navegacion="">
	<cf_navegacion name="CFid"	navegacion="">
	<cf_navegacion name="CF_Ecodigo" default="-1" session>
	<cfquery datasource="#session.dsn#">
		delete from TEScentrosFuncionales
		 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
		   and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cflocation url="Tesoreria.cfm?TESid=#form.TESid#">
</cfif>		

<cfoutput>
<form action="Tesoreria.cfm" method="post" name="sql">
	<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') and isdefined("form.TESid") and len(trim(form.TESid))>
		<input name="TESid" type="hidden" value="#form.TESid#">
	<cfelseif isdefined("form.Alta") and isdefined('insert')>
		<input name="TESid" type="hidden" value="#insert.identity#">
	</cfif>
	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>




