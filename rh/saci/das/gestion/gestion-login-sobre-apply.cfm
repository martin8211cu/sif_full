<cfif isdefined("Form.Snumero") and Len(Trim(Form.Snumero))>									<!--- Asignar el sobre si viene asignado --->

	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="VendedorGenerico"
			Pcodigo="222" />
	<cfquery name="rsAgenteGenerico" datasource="#session.dsn#">
		select a.AGid
		from ISBagente a
		  inner join ISBvendedor b
			on a.AGid = b.AGid
		Where b.Vid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#VendedorGenerico#">
	</cfquery>
	
	<cfset AgenteId = -1>
	<cfif rsAgenteGenerico.RecordCount gt 0>
		<cfset AgenteId = rsAgenteGenerico.AGid>
	</cfif>
	
	<cfset validate = true>
	
	<!---validaciones para Restablecer el sobre asociado al login
		1.Que el sobre se encuentre disponible  (mensCod=17)
			ISBsobre.Sestado = 0
		2.Que se encuentre asignado al agente genérico (RACSA)  (mensCod=19)
			ISBsobre.Sdonde = 1 (Asignado al Agente)
			ISBsobre.AGid = 199 (ver parámetro, Vendedor Genérico para ventas de DSO y
								Registro de Agentes)
		3.El sobre digitado debe contener como mínimo las claves para los servicios asociados al login.  (mensCod=18)
			ISBsobre.Sgenero = A (acceso)
			ISBsobre.Sgenero = C (correo)
			ISBsobre.Sgenero = M (ambos acceso y correo)
	--->
	
	<!---1--->
	<cfquery name="rs" datasource="#session.dsn#">
		select count(1) as r 
			from ISBsobres 
		where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Snumero#">
		and Sestado = '0'
	</cfquery>
	
	<cfif rs.r eq 0>
		<cfset validate = false>
		<cfset ExtraParams = 'mensCod=17'>
	</cfif>
	
	<!---2--->
	<cfif validate>
		<cfquery name="rs" datasource="#session.dsn#">
			select count(1) as r 
				from ISBsobres 
			where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Snumero#">
			and Sdonde = '1'
			and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AgenteId#">
		</cfquery>
		
		<cfif rs.r eq 0>
			<cfset validate = false>
			<cfset ExtraParams = 'mensCod=19'>
		</cfif>
	</cfif>
	
	<!---3--->
	<cfif validate>
	
		<cfset tipo = "X">		
		<cfquery name="rsTipo" datasource="#session.dsn#">
			select b.TStipo from ISBserviciosLogin a
				inner join ISBservicioTipo b
				on a.TScodigo = b.TScodigo
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.logg#">
		</cfquery>
		
		<cfif rsTipo.RecordCount gt 0>			
			<cfif rsTipo.RecordCount eq 1>
				<cfset tipo = "M,#rsTipo.TStipo#">
			<cfelse>
				<cfset tipo = "M">
			</cfif>
		</cfif>
		
		<cfquery name="rs" datasource="#session.dsn#">
			select count(1) as r 
				from ISBsobres 
			where Snumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Snumero#">
			and Sgenero in (<cfqueryparam cfsqltype="cf_sql_char" value="#tipo#" list="yes" separator=",">)
			<!---<cfqueryparam cfsqltype="cf_sql_char" value="#tipo#">--->
		</cfquery>
		
		<cfif rs.r eq 0>
			<cfset validate = false>
			<cfset ExtraParams = 'mensCod=18'>
		</cfif>
	</cfif>
	
	<cfif validate>
		<cftransaction>
			<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
				<cfinvokeargument name="Snumero" value="#form.Snumero#">
				<cfinvokeargument name="LGnumero" value="#form.logg#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBlogin" method="Asignar_Sobre">
				<cfinvokeargument name="LGnumero" value="#form.logg#">
				<cfinvokeargument name="Snumero" value="#form.Snumero#">
			</cfinvoke>
			<cfinvoke component="saci.comp.ISBsobres" method="Activacion" returnvariable="LvarError">	<!--- Activar el sobre --->
				<cfinvokeargument name="Snumero" value="#Form.Snumero#">
			</cfinvoke>
			<cfif LvarError EQ 0>	
				<cfset ExtraParams = 'mensCod=12'>
			<cfelse>	
				<cfset ExtraParams = 'mensCod=13'>		
			</cfif>
		</cftransaction>
	</cfif>
</cfif>

	
<cfinclude template="gestion-redirect.cfm">