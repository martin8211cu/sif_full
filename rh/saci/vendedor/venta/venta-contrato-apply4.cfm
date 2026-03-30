<cfif isdefined("form.Guardar") or isdefined("form.GuardarContinuar") or (isdefined("form.submitMenu") and form.submitMenu EQ 1)>
	<cfif isdefined('form.listaSuf') and form.listaSuf NEQ ''>
		<cfset arrPaq = ListToArray(form.listaSuf,",")>
		<cfset cargaSufijo = "">
		<cfset modo = "CAMBIO">				

		<cfloop index="cont" from = "1" to = "#ArrayLen(arrPaq)#">
			<!--- Se inserta un registro en ISBgarantia por cada uno de los paquetes. El paquete por el que se va  acambiar y los paquetes adicionales --->
			<cfset cargaSufijo = arrPaq[cont]>		
	
			<!--- Modificacion de los datos del deposito de garantia --->
			<cfinclude template="../../utiles/depoGaran-apply.cfm">					
		</cfloop>	
	<cfelse>
		<cfset loginid = "">
		<cfquery name="rsPQ" datasource="#session.DSN#">
			select a.PQcodigo,b.PQnombre, a.Contratoid, b.PQtelefono   
			from ISBproducto a
				inner join ISBpaquete b
					on b.PQcodigo=a.PQcodigo
					and b.Habilitado=1
			where
				a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		</cfquery>
			
		<cfquery name="rsLogPrincipal" datasource="#session.DSN#">
			select  b.LGnumero,b.LGlogin
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid=a.Contratoid
						and b.LGprincipal=1
			where
				a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				<cfif isdefined('rsPQ') and rsPQ.recordCount GT 0>
					and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPQ.PQcodigo#">					
				</cfif>
		</cfquery>	
		<cfif isdefined('rsLogPrincipal') and rsLogPrincipal.recordCount GT 0>
			<cfset loginid = rsLogPrincipal.LGnumero>
		<cfelse>
			<cfthrow message="No existe el login principal para el contrato (#form.Contratoid#) seleccionado.">
		</cfif>
		
		<!--- Insercion de los datos del deposito de garantia --->
		<cfinclude template="../../utiles/depoGaran-apply.cfm">			
	</cfif>	
</cfif>

