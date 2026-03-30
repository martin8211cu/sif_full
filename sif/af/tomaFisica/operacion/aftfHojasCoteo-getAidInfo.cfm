<cfif isdefined("url.aid") and Len(Trim(url.aid)) GT 0>
	<cfquery name="rsActivo" datasource="#Session.DSN#">
		select a.Aid, a.Ecodigo
			, a.AFMid, a.AFMMid, a.ACcodigo, a.ACid, a.AFCcodigo
			, afr.DEid, afs.CFid
			, a.Aplaca, a.Aserie, a.Adescripcion, a.Astatus, a.Avutil, a.Avalrescate
			, b.AFMcodigo, b.AFMdescripcion
			, c.AFMMcodigo, c.AFMMdescripcion
			, d.ACcodigodesc, d.ACdescripcion
			, e.ACcodigodesc as ACcodigodesc_clas, e.ACdescripcion as ACdescripcion_clas
			, f.AFCcodigoclas, f.AFCdescripcion
			, g.DEidentificacion, {fn concat({fn concat({fn concat({fn concat(g.DEapellido1 , ' ' )}, g.DEapellido2 )}, ' ' )}, g.DEnombre)} as DEnombre
			, i.CFcodigo, i.CFdescripcion
		from Activos a
			inner join AFResponsables afr
				on afr.Ecodigo = a.Ecodigo
				and afr.Aid = a.Aid
				and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin			
			inner join AFSaldos afs
				on afs.Ecodigo = a.Ecodigo
				and afs.Aid = a.Aid
				and afs.AFSperiodo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 50)
				and afs.AFSmes = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo = a.Ecodigo and Pcodigo = 60)
			inner join AFMarcas b
				on b.AFMid = a.AFMid
			inner join AFMModelos c
				on c.AFMMid = a.AFMMid
			inner join ACategoria d
				on d.Ecodigo = a.Ecodigo
				and d.ACcodigo = a.ACcodigo
			inner join AClasificacion e
				on e.Ecodigo = a.Ecodigo
				and e.ACid = a.ACid
				and e.ACcodigo = a.ACcodigo
			inner join AFClasificaciones f
				on f.Ecodigo = a.Ecodigo
				and f.AFCcodigo = a.AFCcodigo
			inner join DatosEmpleado g
				on g.DEid = afr.DEid
			inner join CFuncional i
				on i.CFid = afs.CFid
		where a.Ecodigo =  #Session.Ecodigo# 
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Aid#">
	</cfquery>
	<cfdump var="#rsActivo.recordcount#">
	<cfoutput>
	<script language="JavaScript">
		<!--//
			window.parent.document.formActivo.AFCcodigo.value="#rsActivo.AFCcodigo#";
			window.parent.document.formActivo.AFCcodigoclas.value="#rsActivo.AFCcodigoclas#";
			window.parent.document.formActivo.AFCdescripcion.value="#rsActivo.AFCdescripcion#";

			window.parent.document.formActivo.ACcodigo.value="#rsActivo.ACcodigo#";
			window.parent.document.formActivo.ACcodigodesc.value="#rsActivo.ACcodigodesc#";
			window.parent.document.formActivo.ACdescripcion.value="#rsActivo.ACdescripcion#";

			window.parent.document.formActivo.ACid.value="#rsActivo.ACid#";
			window.parent.document.formActivo.ACcodigodesc_clas.value="#rsActivo.ACcodigodesc_clas#";
			window.parent.document.formActivo.ACdescripcion_clas.value="#rsActivo.ACdescripcion_clas#";

			window.parent.document.formActivo.AFMid.value="#rsActivo.AFMid#";
			window.parent.document.formActivo.AFMcodigo.value="#rsActivo.AFMcodigo#";
			window.parent.document.formActivo.AFMdescripcion.value="#rsActivo.AFMdescripcion#";

			window.parent.document.formActivo.AFMMid.value="#rsActivo.AFMMid#";
			window.parent.document.formActivo.AFMMcodigo.value="#rsActivo.AFMMcodigo#";
			window.parent.document.formActivo.AFMMdescripcion.value="#rsActivo.AFMMdescripcion#";

			window.parent.document.formActivo.Adescripcion.value="#rsActivo.Adescripcion#";
			window.parent.document.formActivo.Aserie.value="#rsActivo.Aserie#";
			
			window.parent.document.formActivo.CFid.value="#rsActivo.CFid#";
			window.parent.document.formActivo.CFcodigo.value="#rsActivo.CFcodigo#";
			window.parent.document.formActivo.CFdescripcion.value="#rsActivo.CFdescripcion#";

			window.parent.document.formActivo.DEid.value="#rsActivo.DEid#";
			window.parent.document.formActivo.DEidentificacion.value="#rsActivo.DEidentificacion#";
			window.parent.document.formActivo.DEnombre.value="#rsActivo.DEnombre#";

			window.parent.document.formActivo.Avutil.value="#rsActivo.Avutil#";
			window.parent.document.formActivo.Avalrescate.value="#rsActivo.Avalrescate#";
		//-->
	</script>
	</cfoutput>
</cfif>