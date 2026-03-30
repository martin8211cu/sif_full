<cfsetting enablecfoutputonly="yes">
	<cftry>
		<cfquery name="rsForm" datasource="#session.DSN#">
			select 	RHPcodigo,
					balanceado,
					introvertido,
					extravertido,
					BRval,
					BLval,
					FRval,
					FLval
			from PerfilUsuarioB
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.DEid#">
		</cfquery>
		
		<cfquery name="rsPuesto" datasource="#session.DSN#">
			select 	RHTPid, 
					a.RHPcodigo, 
					a.RHPdescpuesto, 
					a.FRval, a.FLval, a.BRval, a.BLval,
					a.FRtol, a.FLtol, a.BRtol, a.BLtol,
					a.extravertido, a.introvertido, a.balanceado, a.ubicacionMuneco
			from RHPuestos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
		</cfquery>
		
		<cfif rsForm.RecordCount Is 0>
			<cfoutput>titulo=#URLEncodedFormat('El puesto especificado no existe')#</cfoutput>
		</cfif>
		
		<cfoutput>ok=#1
		#&titulo=#URLEncodedFormat(rsPuesto.RHPdescpuesto)
		#&escalaFR=#URLEncodedFormat(rsForm.FRval)
		#&escalaFL=#URLEncodedFormat(rsForm.FLval)
		#&escalaBR=#URLEncodedFormat(rsForm.BRval)
		#&escalaBL=#URLEncodedFormat(rsForm.BLval)
		#&esIntrov=#URLEncodedFormat(rsForm.introvertido)
		#&esExtrov=#URLEncodedFormat(rsForm.extravertido)
		#&esBalance=#URLEncodedFormat(rsForm.balanceado)

		#&escalaFRverde=#URLEncodedFormat(rsPuesto.FRval)
		#&escalaFLverde=#URLEncodedFormat(rsPuesto.FLval)
		#&escalaBRverde=#URLEncodedFormat(rsPuesto.BRval)
		#&escalaBLverde=#URLEncodedFormat(rsPuesto.BLval)
		#&esIntrovverde=#URLEncodedFormat(rsPuesto.introvertido)
		#&esExtrovverde=#URLEncodedFormat(rsPuesto.extravertido)
		#&esBalanceverde=#URLEncodedFormat(rsPuesto.balanceado)
		#</cfoutput>
		
		<cfcatch type="any">
			<cfoutput>ok=0&errormsg=# URLEncodedFormat(cfcatch.Message & ' ' & cfcatch.Detail) #</cfoutput>
			<cflog file="benzinger" text="#cfcatch.Message & ' ' & cfcatch.Detail#">
			<cfset errargs = "">
			<cfloop collection="#form#" item="fld">
				<cfset errargs = ListAppend(errargs,fld & '=' & form[fld] )>
			</cfloop>
			<cflog file="benzinger" text="args: #errargs#">
			<cflog file="benzinger" text=" ">
		</cfcatch>
</cftry>