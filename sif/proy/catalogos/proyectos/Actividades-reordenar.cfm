<cfinclude template="../../../Utiles/sifConcat.cfm">

	<cfif session.dsinfo.type neq 'sybase'>
		<cf_errorCode	code = "50556"
						msg  = "No soportado en @errorDat_1@"
						errorDat_1="#session.dsinfo.type#"
		>
	</cfif>
	<cfquery datasource="#session.dsn#" name="porpadre">
		select PRJAidPadre, PRJAid
		from PRJActividad
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		order by PRJAidPadre, PRJAorden
	</cfquery>
	
	<cfoutput query="porpadre" group="PRJAidPadre">
		<cfset orden = 0>
		<cfoutput>
			<cfset orden = orden + 10>
			<cfquery datasource="#session.dsn#">
				update PRJActividad
				set PRJAorden = #orden#
				where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
				  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#porpadre.PRJAid#">
			</cfquery>
		</cfoutput>
	</cfoutput>
	

	<cfquery datasource="#session.dsn#">
		update PRJActividad
		set PRJApath =  right ('000000' #_Cat# convert (varchar, PRJAorden), 7),
		    PRJAnivel = case when PRJAidPadre is null then 0 else -1 end
		where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
		
		declare @nivel int select @nivel = 0
		
		while (@nivel < 0100) begin
			update PRJActividad
			set PRJApath = p.PRJApath #_Cat# '/' #_Cat# right ('000000' #_Cat# convert (varchar, h.PRJAorden), 7),
			    PRJAnivel = @nivel + 1
			from PRJActividad h, PRJActividad p
			where h.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
			  and p.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
			  and h.PRJAidPadre = p.PRJAid
			  and p.PRJAnivel = @nivel
			  and h.PRJAnivel = -1
			if @@rowcount = 0 break
			select @nivel = @nivel + 1
		end
	</cfquery>
	

