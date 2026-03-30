<!---
	Creado por: Gustavo Fonseca Hernández
	Fecha: 22 de junio del 2005
	Motivo: Nueva opción para Módulo de Tesorería, Cambio Custodia de Cheques.
--->

<!--- <cf_dump var="#form#"> --->

<!--- <cfquery datasource="#session.dsn#" name="rsLista">
	select    *
	  from TEScontrolFormulariosD cfd
		inner join TEScontrolFormulariosB cfb
			 on cfb.TESid          = cfd.TESid 
			and cfb.CBid           = cfd.CBid
			and cfb.TESMPcodigo    = cfd.TESMPcodigo
			and cfb.TESCFDnumFormulario = cfd.TESCFDnumFormulario
			and cfb.TESCFBultimo = 1
			and cfb.UsucodigoCustodio = #session.Usucodigo#
	where ...
	estado=1
</cfquery> --->
<!--- SQL --->


<cfif IsDefined("form.cambio")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
					update TEScontrolFormulariosB
					   set TESCFBultimo = 0
						 , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 where TESid                   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
					   and CBid                    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESMPcodigo             = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					   and TESCFDnumFormulario     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
					insert into TEScontrolFormulariosB
								(
									TESid, CBid, TESMPcodigo, TESCFDnumFormulario, 
									TESCFBultimo, UsucodigoCustodio,
									TESCFBfecha, TESCFEid, TESCFLUid, TESCFBobservacion, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
								)
					values
								(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
									,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
									,1
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
									,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#">
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFBobservacion#">
									,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								)
		</cfquery>
	</cftransaction>	
</cfif>
<cflocation url="Cambio_Custodia_Cheques.cfm">
