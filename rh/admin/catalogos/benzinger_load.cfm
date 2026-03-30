<cfsetting enablecfoutputonly="yes">

	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	RHTPid, 
				coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigo, 
				a.RHPdescpuesto, 
				a.FRval, a.FLval, a.BRval, a.BLval,
				a.FRtol, a.FLtol, a.BRtol, a.BLtol,
				a.extravertido, a.introvertido, a.balanceado, a.ubicacionMuneco
		from RHPuestos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and coalesce(a.RHPcodigoext, a.RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
	</cfquery>
	
	<cfloop list="FR,FL,BR,BL" index="ubica">
		<cfquery name="hab#ubica#" datasource="#session.DSN#">
			select c.RHHdescripcion
			from RHHabilidadesPuesto a, RHPuestos b, RHHabilidades c 
			where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and coalesce(b.RHPcodigoext, b.RHPcodigo)=<cfqueryparam cfsqltype="cf_sql_char" value="#session.RHPcodigo#">
			  and a.RHHid=c.RHHid
			  and a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
			  and a.ubicacionB = '#ubica#'
		 </cfquery>
	 </cfloop>

<cfif rsForm.RecordCount Is 0>
	<cfoutput>titulo=#URLEncodedFormat('El puesto especificado no existe')#</cfoutput>
</cfif>

<cfoutput>ok=#1
#&titulo=#URLEncodedFormat(rsForm.RHPdescpuesto)
#&escalaFR=#URLEncodedFormat(rsForm.FRval)
#&escalaFL=#URLEncodedFormat(rsForm.FLval)
#&escalaBR=#URLEncodedFormat(rsForm.BRval)
#&escalaBL=#URLEncodedFormat(rsForm.BLval)
#&toleraFR=#URLEncodedFormat(rsForm.FRtol)
#&toleraFL=#URLEncodedFormat(rsForm.FLtol)
#&toleraBR=#URLEncodedFormat(rsForm.BRtol)
#&toleraBL=#URLEncodedFormat(rsForm.BLtol)
#&listaFR=#URLEncodedFormat(ValueList(habFR.RHHdescripcion,Chr(10)))
#&listaFL=#URLEncodedFormat(ValueList(habFL.RHHdescripcion,Chr(10)))
#&listaBR=#URLEncodedFormat(ValueList(habBR.RHHdescripcion,Chr(10)))
#&listaBL=#URLEncodedFormat(ValueList(habBL.RHHdescripcion,Chr(10)))
#&esIntrov=#URLEncodedFormat(rsForm.introvertido)
#&esExtrov=#URLEncodedFormat(rsForm.extravertido)
#&esBalance=#URLEncodedFormat(rsForm.balanceado)
#&meneco=#URLEncodedFormat(rsForm.ubicacionMuneco)
#</cfoutput>