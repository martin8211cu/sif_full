<cfif IsDefined("form.insertarCF")>
	<cf_dbfunction name='OP_concat' returnvariable='concat'>
	<cfquery name="rsCentros" datasource="#session.DSN#" >
		select distinct 
		a.CFid as CFpk,
		a.CFcodigo,
		a.CFdescripcion,  
		<cf_dbfunction name="to_char" args="a.Ocodigo"> #concat# '-' #concat# b.Odescripcion as Oficina,  
		<cf_dbfunction name="to_char" args="a.Dcodigo"> #concat# '-' #concat# c.Ddescripcion as Depto,
		a.CFid as primero,
		a.CFpath,
		a.CFnivel
		from  CFuncional a
					
		inner join Oficinas b
			on  b.Ocodigo=a.Ocodigo
			and b.Ecodigo=a.Ecodigo
					
		inner join	Departamentos c
			on c.Dcodigo=a.Dcodigo
			and  c.Ecodigo=a.Ecodigo
						
		where a.Ecodigo = #session.Ecodigo#
          and a.CFestado = 1 <!---Solo Activos--->
		and a.CFid not in 
			( 
			select  a.CFid 
				from CMTSolicitudCF a 
					inner join CFuncional b 
						on b.Ecodigo = a.Ecodigo
						and b.CFid = a.CFid
					inner join Monedas c 
						on c.Ecodigo = a.Ecodigo
						and c.Mcodigo = a.Mcodigo
				where a.Ecodigo = #session.Ecodigo#
				and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
			)
		order by a.CFpath, a.CFcodigo, a.CFnivel
	</cfquery>

	<cfloop query="rsCentros" >
		<cfquery name="insertd"  datasource="#session.dsn#">
			insert into CMTSolicitudCF( CFid, Ecodigo, CMTScodigo, Mcodigo, CMTSmontomax, Usucodigo, CMTSfecha, Usucodigomod, fechamod)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentros.CFpk#">,
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.moneda#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.CMTSmonto#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
		</cfquery>
	</cfloop>						
						
</cfif>
<cfif not isdefined("form.Nuevo")>
	<!--- Validación del Código--->
	<cfif isdefined("form.Alta") or isdefined("form.AltaEsp")>
		<cfquery name="rsValidaCFid" datasource="#session.dsn#">
			select 1
			from CMTSolicitudCF
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTScodigo = <cfqueryparam value="#form.CMTScodigo#" cfsqltype="cf_sql_char">
				and CFid = <cfqueryparam value="#form.CFpk#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rsValidaCFid.RecordCount>
			<cf_errorCode	code = "50252" msg = "El centro funcional que está intentando agregar ya existe, Proceso Cancelado!">
		</cfif>
	</cfif>
	
	<cfif isdefined("form.Alta") or isdefined("form.AltaEsp")>
		<cfquery name="insertd"  datasource="#session.dsn#">
			insert into CMTSolicitudCF( CFid, Ecodigo, CMTScodigo, Mcodigo, CMTSmontomax, Usucodigo, CMTSfecha, Usucodigomod, fechamod)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTScodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.moneda#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.CMTSmonto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
		</cfquery>
	<cfelseif isdefined("form.Cambio") or isdefined("form.CambioEsp")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CMTSolicitudCF"
			redirect="compraConfig.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#session.Ecodigo#"
			field2="CMTScodigo"
			type2="char"
			value2="#form.CMTScodigo#"
			field3="CFid"
			type3="numeric"
			value3="#form.CFpk#"
		>
		<cfquery name="updated"  datasource="#session.dsn#">
			update CMTSolicitudCF
				set CMTSmontomax = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CMTSmonto#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.moneda#">,
					Usucodigomod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					fechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTScodigo#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
		</cfquery>
	<cfelseif isdefined("form.Baja")>
		<cfquery name="deleted" datasource="#session.dsn#">
			delete from CMTSolicitudCF
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTScodigo#">
		</cfquery>
	</cfif>
</cfif><!---form.Nuevo--->
<cfif isdefined("form.AltaEsp") or isdefined("form.CambioEsp")><cfset Session.Compras.Configuracion.Pantalla = Session.Compras.Configuracion.Pantalla + 1><cfset Session.Compras.Configuracion.CFpk = Form.CFpk></cfif>
<cfif isdefined("form.Baja") or isdefined("form.Nuevo")><cfset Session.Compras.Configuracion.CFpk = ""></cfif>
<cflocation url="compraConfig.cfm">

