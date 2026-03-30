<cfquery name="rsErr" datasource="#session.DSN#">
	select t.Codigo, count(1) as Cantidad, min(t.Descripcion) as Nombre1, max(t.Descripcion) as Nombre2, 'Duplicada' as Error
	from #table_name# t
	group by t.Codigo
	having count(1) > 1 
</cfquery>

<cfif rsErr.recordcount GT 0>
	<cfreturn>
</cfif>

<cfquery name="rsImportacionOficinas" datasource="#session.DSN#">
	select t.Codigo, t.Descripcion, t.Telefono, t.Responsable, t.NumeroPatronal
	from #table_name# t
	order by t.Codigo
</cfquery>

<cfloop query="rsImportacionOficinas">

	<cfquery name="rsVerifica" datasource="#session.dsn#">
		select min(Ocodigo) as Ocodigo, count(1) as Definida
		from Oficinas o
		where o.Ecodigo = #session.Ecodigo#
		  and o.Oficodigo = '#rsImportacionOficinas.Codigo#'
	</cfquery>
	
	<cfif rsVerifica.Definida GT 0>
		<cfquery datasource="#session.DSN#">
			update Oficinas
			set 
				  Odescripcion    = '#rsImportacionOficinas.Descripcion#'
				, telefono        = '#rsImportacionOficinas.Telefono#'
				, responsable     = '#rsImportacionOficinas.Responsable#'
				, Onumpatronal    = '#rsImportacionOficinas.NumeroPatronal#'
			where Ecodigo = #session.Ecodigo#
			  and Ocodigo = #rsVerifica.Ocodigo#
		</cfquery>
	<cfelse>

		<cftransaction>
			<cfquery name="rsCont" datasource="#Session.DSN#">
				select max(Ocodigo) as Cont
				from Oficinas 
				where Ecodigo = #Session.Ecodigo#				
			</cfquery>

			<cfif len(trim(rsCont.Cont)) EQ 0>
				<cfset LvarNOficina = 1>
			<cfelse>
				<cfset LvarNOficina = rsCont.Cont + 1>
			</cfif>

			<cfquery datasource="#session.dsn#">
				insert into Oficinas (
					Ecodigo, Ocodigo, Oficodigo, Odescripcion,
					telefono, responsable, Onumpatronal)
				values
					(				
						 #session.Ecodigo#, 
						 #LvarNOficina#,
						 '#rsImportacionOficinas.Codigo#',
						 '#rsImportacionOficinas.Descripcion#',
						 '#rsImportacionOficinas.Telefono#', 
						 '#rsImportacionOficinas.Responsable#', 
						 '#rsImportacionOficinas.NumeroPatronal#'
					 )
			</cfquery>
		</cftransaction>

	</cfif>
</cfloop>
