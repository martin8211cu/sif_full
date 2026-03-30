
<cfset _DVElinea = '' >
<cfif isdefined("form.btnGuardar") or isdefined("form.btnAplicar")>
	<cfif isdefined("form.contador") and form.contador gt 0>
		<cfloop from="0" to="#form.contador#" index="i">
			<cfif isdefined("form.chk_#i#")>
				<cfset _DVElinea = listappend(_DVElinea, form['DVElinea_#i#'] ) >
				<cfset _dias = form['dias_#i#'] >
				<cfquery datasource="#session.DSN#">
					update RHVacacionesEmpleado
					set DVEdisfrutados = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(_dias, ',', '', 'all')#">
					where DVElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['DVElinea_#i#']#">
				</cfquery> 
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif isdefined("form.btnEliminar")>
	<cfif isdefined("form.contador") and form.contador gt 0>
		<cfloop from="0" to="#form.contador#" index="i">
			<cfif isdefined("form.chk_#i#")>
				<cfquery datasource="#session.DSN#">
					update RHVacacionesEmpleado
					set RHVEestado = 'R'
					where DVElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['DVElinea_#i#']#">
				</cfquery> 
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif isdefined("form.btnAplicar") >
	<cfif isdefined("form.contador") and form.contador gt 0>
		<cfquery datasource="#session.DSN#">
			insert into DVacacionesEmpleado(  DEid, 
											  Ecodigo,
											  DVEfecha, 
											  DVEdescripcion, 
											  DVEdisfrutados, 
											  DVEcompensados, 
											  DVEenfermedad, 
											  DVEadicionales, 
											  DVEmonto, 
											  Usucodigo, 
											  Ulocalizacion,
											  DVEfalta,
											  BMUsucodigo )
			select DEid, 
				   Ecodigo,
				   DVEfecha, 
				   DVEdescripcion, 
				   DVEdisfrutados, 
				   DVEcompensados, 
				   DVEenfermedad, 
				   DVEadicionales, 
				   DVEmonto, 
				   Usucodigo, 
				   Ulocalizacion,
				   DVEfalta,
				   BMUsucodigo
			from RHVacacionesEmpleado
			where RHVEestado = 'P'
			<cfif len(trim(form.RHVEgrupo))>
				and RHVEgrupo in (#form.RHVEgrupo#)
			</cfif>
			<cfif len(trim(_DVElinea))>
				and DVElinea in (#_DVElinea#)
			</cfif>
		</cfquery>
		
		<!--- marca como procesados los registros --->
		<cfquery datasource="#session.DSN#">
			update RHVacacionesEmpleado
			set RHVEestado = 'A'
			where RHVEestado = 'P'
			<cfif len(trim(_DVElinea))>
				and DVElinea in (#_DVElinea#)
			</cfif>
		</cfquery>

		<cflocation url="ajusteAplicar.cfm?aplicar=ok">
	</cfif>	
</cfif>

<cflocation url="ajusteAplicar.cfm">