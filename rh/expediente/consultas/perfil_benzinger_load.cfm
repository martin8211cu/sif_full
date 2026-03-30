<cfsetting enablecfoutputonly="yes">
	<cftry>
		<cfquery name="rsForm" datasource="#session.DSN#">
			select 	'Resultado del test' as RHPcodigo,
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
			<!----		
			select 	RHTPid, 
					a.RHPcodigo, 
					a.RHPdescpuesto, 
					a.FRval, a.FLval, a.BRval, a.BLval,
					a.FRtol, a.FLtol, a.BRtol, a.BLtol,
					a.extravertido, a.introvertido, a.balanceado, a.ubicacionMuneco
			from RHPuestos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
			----->
		</cfquery>
		
		<!----
		<cfloop list="FR,FL,BR,BL" index="ubica">
			<cfquery name="hab#ubica#" datasource="#session.DSN#">
				select c.RHHdescripcion
				from RHHabilidadesPuesto a, RHHabilidades c
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
				  and a.RHHid=c.RHHid
				  and a.ubicacionB = '#ubica#'
			 </cfquery>
		 </cfloop>
		 ---->

		<cfif rsForm.RecordCount Is 0>
			<cfoutput>titulo=#URLEncodedFormat('El puesto especificado no existe')#</cfoutput>
		<cfelse>
			titulo = 'Resultado del test'
		</cfif>
		
		<!----
		#&toleraFR=#URLEncodedFormat(rsForm.FRtol)
		#&toleraFL=#URLEncodedFormat(rsForm.FLtol)
		#&toleraBR=#URLEncodedFormat(rsForm.BRtol)
		#&toleraBL=#URLEncodedFormat(rsForm.BLtol)
		#&listaFR=#URLEncodedFormat(ValueList(habFR.RHHdescripcion,Chr(10)))
		#&listaFL=#URLEncodedFormat(ValueList(habFL.RHHdescripcion,Chr(10)))
		#&listaBR=#URLEncodedFormat(ValueList(habBR.RHHdescripcion,Chr(10)))
		#&listaBL=#URLEncodedFormat(ValueList(habBL.RHHdescripcion,Chr(10)))
		#&meneco=#URLEncodedFormat(rsForm.ubicacionMuneco)
		#&titulo=#URLEncodedFormat(rsForm.RHPdescpuesto)
		
		----->
		
		<cfoutput>ok=#1	
		#&titulo=#URLEncodedFormat(rsForm.RHPcodigo)	
		#&escalaFR=#URLEncodedFormat(rsForm.FRval)
		#&escalaFL=#URLEncodedFormat(rsForm.FLval)
		#&escalaBR=#URLEncodedFormat(rsForm.BRval)
		#&escalaBL=#URLEncodedFormat(rsForm.BLval)
		#&esIntrov=#URLEncodedFormat(rsForm.introvertido)
		#&esExtrov=#URLEncodedFormat(rsForm.extravertido)
		#&esBalance=#URLEncodedFormat(rsForm.balanceado)
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