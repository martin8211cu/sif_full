<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaAnotacionNoPuedeEstarVacia"
	Default="La anotaci&oacute;n no puede estar vac&iacute;a"	
	returnvariable="MSG_AnotacionVacia"/>		
	
<cfif isdefined("form.btnAnotar")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfloop list="#form.chk#" index="i">
			<cfquery name="rsDatos" datasource="#session.DSN#">
				select a.DEid, a.CMBfecha, a.Anotacion,
						case b.RHASnegativo when 0 then 1 else 2 end as RHAtipo
				from RHCMBitacoraAccionesSeguir a
					inner join RHAccionesSeguir b
						on a.RHASid = b.RHASid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.CMBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			
			<cfif rsDatos.RecordCount NEQ 0 and len(trim(rsDatos.Anotacion))>
				<!---Inserta anotaciones--->
				<cfquery datasource="#session.DSN#">
					insert into RHAnotaciones(DEid, EFid, RHAfecha, 
											RHAfsistema, RHAdescripcion, Usucodigo,
											Ulocalizacion, RHAtipo, BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.CMBfecha#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(rsDatos.Anotacion,1,255)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.RHAtipo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
				</cfquery>
				<!---Actualiza estado de la bitacora de acciones a seguir---->
				<cfquery datasource="#session.DSN#">
					update RHCMBitacoraAccionesSeguir
						set CMBestado = 'C'
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and CMBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
			<cfelse>
				<cf_throw message="#MSG_AnotacionVacia#" errorcode="4050">
			</cfif>
		</cfloop>
	</cfif>
<cfelseif isdefined("form.btnCerrar")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfloop list="#form.chk#" index="i">
			<!---Actualiza estado de la bitacora de acciones a seguir---->
			<cfquery datasource="#session.DSN#">
				update RHCMBitacoraAccionesSeguir
					set CMBestado = 'C'
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CMBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		</cfloop>
	</cfif>		
</cfif>
<cflocation url="SeguimientoAcciones.cfm">
