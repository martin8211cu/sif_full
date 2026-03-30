<cfif isdefined("url.placa") and Len(Trim(url.placa)) GT 0><!--- Viene el parámetro de placa --->
	<cfquery name="rsPlaca" datasource="#Session.DSN#">
		select Aid, Aplaca, Adescripcion, Astatus
		from Activos
		where Ecodigo =  #Session.Ecodigo# 		
		and rtrim(ltrim(Aplaca)) = <cfqueryparam value="#Trim(url.placa)#" cfsqltype="cf_sql_char">
	</cfquery>
	<script language="JavaScript">
		<!--//
		window.parent.document.form1.Aid.value = "";
		window.parent.document.form1.Aplaca.value = "";
		window.parent.document.form1.Adescripcion.value = "";
		if (window.parent.funcGATmonto) window.parent.funcGATmonto();
		<cfif rsPlaca.recordcount gt 0><!--- Encontró una placa --->
			window.parent.document.form1.GATplaca.value="";
			<cfif rsPlaca.Astatus eq 0>
				alert("Error. El Activo ya Existe, digite otra placa.");
			<cfelseif rsPlaca.Astatus eq 60>
				alert("Error. El Activo Fué Retirado, digite otra placa.");
			</cfif>
			window.parent.document.form1.GATplaca.focus();
		</cfif><!--- Fin Encontró una placa --->
		//-->
	</script>
</cfif><!--- Fin Viene el parámetro de placa --->
<cfif isdefined("url.aid") and Len(Trim(url.aid)) GT 0>
<cf_dbfunction name="concat" args="e.DEapellido1,' ',e.DEapellido2,' ',e.DEnombre" returnvariable="DEnombrecompleto">
	<cfquery name="rsActivo" datasource="#Session.DSN#">
		select a.Aid, a.Aplaca, a.Adescripcion, a.Aserie, a.Afechainidep, a.Afechainirev
			,c.CFid , c.CFcodigo, c.CFdescripcion
			,e.DEid, e.DEidentificacion, #PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto
			,f.CRTDid, f.CRTDcodigo, f.CRTDdescripcion
			,g.ACcodigo, g.ACcodigodesc, g.ACdescripcion, g.ACmascara
			,h.ACid, h.ACcodigodesc as ACcodigodesc_clas, h.ACdescripcion as ACdescripcion_clas
			,i.AFMid, i.AFMcodigo, i.AFMdescripcion
			,j.AFMMid, j.AFMMcodigo, j.AFMMdescripcion
			,k.AFCcodigo, k.AFCcodigoclas, k.AFCdescripcion
			,l.CRCCid,l.CRCCcodigo,l.CRCCdescripcion
			<!--- Cuando la Vida Util es cero se debe mejorar en mas de una unidad si no si puede no mejorarse. --->
			,case when b.AFSsaldovutiladq > 0 then 0 else coalesce(h.ACvutil,g.ACvutil) end as VidaUtilSugerida
		from Activos a
			inner join AFSaldos b
				on b.Ecodigo = a.Ecodigo
				and b.Aid = a.Aid
				and b.AFSperiodo = (select min(<cf_dbfunction name="to_integer"	args="Pvalor">) from Parametros where Pcodigo = 50 and Ecodigo =  #Session.Ecodigo# )
				and b.AFSmes     = (select min(<cf_dbfunction name="to_integer"	args="Pvalor">) from Parametros where Pcodigo = 60 and Ecodigo =  #Session.Ecodigo# )
			inner join CFuncional c
				on c.CFid = b.CFid
			inner join AFResponsables d
				on d.Ecodigo = a.Ecodigo
				and d.Aid = a.Aid
				and <cf_dbfunction name="now"> between d.AFRfini and d.AFRffin
			left outer join DatosEmpleado e
				on e.DEid = d.DEid
			left outer join CRTipoDocumento f
				on f.CRTDid = d.CRTDid
			inner join ACategoria g
				on g.Ecodigo = a.Ecodigo
				and g.ACcodigo = a.ACcodigo
			inner join AClasificacion h
				on h.Ecodigo = a.Ecodigo
				and h.ACcodigo = a.ACcodigo
				and h.ACid = a.ACid
			inner join AFMarcas i
				on i.AFMid = a.AFMid
			inner join AFMModelos j
				on j.AFMMid = a.AFMMid
			inner join AFClasificaciones k
				on k.Ecodigo = a.Ecodigo
				and k.AFCcodigo = a.AFCcodigo
			left outer join CRCentroCustodia l
				on l.CRCCid= d.CRCCid
		where a.Ecodigo =  #Session.Ecodigo# 
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Aid#">
	</cfquery>
	<cfoutput>
	<script language="JavaScript">
		<!--//
			window.parent.document.form1.CRCCid.value="#rsActivo.CRCCid#";
			window.parent.document.form1.CRCCcodigo.value="#rsActivo.CRCCcodigo#";
			window.parent.document.form1.CRCCdescripcion.value="#rsActivo.CRCCdescripcion#";
			window.parent.document.form1.CFid.value="#rsActivo.CFid#";
			window.parent.document.form1.CFcodigo.value="#rsActivo.CFcodigo#";
			window.parent.document.form1.CFdescripcion.value="#rsActivo.CFdescripcion#";
			window.parent.document.form1.DEid.value="#rsActivo.DEid#";
			window.parent.document.form1.DEidentificacion.value="#rsActivo.DEidentificacion#";
			window.parent.document.form1.DEnombrecompleto.value="#rsActivo.DEnombrecompleto#";
			window.parent.document.form1.CRTDid.value="#rsActivo.CRTDid#";
			window.parent.document.form1.CRTDcodigo.value="#rsActivo.CRTDcodigo#";
			window.parent.document.form1.CRTDdescripcion.value="#rsActivo.CRTDdescripcion#";
			window.parent.document.form1.ACcodigo.value="#rsActivo.ACcodigo#";
			window.parent.document.form1.ACcodigodesc.value="#rsActivo.ACcodigodesc#";
			window.parent.document.form1.ACdescripcion.value="#rsActivo.ACdescripcion#";
			window.parent.document.form1.ACmascara.value="#rsActivo.ACmascara#";
			if (window.parent.CambiarMascara) window.parent.CambiarMascara();
			window.parent.document.form1.GATplaca.value="#rsActivo.Aplaca#";
			window.parent.document.form1.GATdescripcion.value="#rsActivo.Adescripcion#";
			window.parent.document.form1.ACid.value="#rsActivo.ACid#";
			window.parent.document.form1.ACcodigodesc_clas.value="#rsActivo.ACcodigodesc_clas#";
			window.parent.document.form1.ACdescripcion_clas.value="#rsActivo.ACdescripcion_clas#";
			window.parent.document.form1.AFMid.value="#rsActivo.AFMid#";
			window.parent.document.form1.AFMcodigo.value="#rsActivo.AFMcodigo#";
			window.parent.document.form1.AFMdescripcion.value="#rsActivo.AFMdescripcion#";
			window.parent.document.form1.AFMMid.value="#rsActivo.AFMMid#";
			window.parent.document.form1.AFMMcodigo.value="#rsActivo.AFMMcodigo#";
			window.parent.document.form1.AFMMdescripcion.value="#rsActivo.AFMMdescripcion#";
			window.parent.document.form1.AFCcodigo.value="#rsActivo.AFCcodigo#";
			window.parent.document.form1.AFCcodigoclas.value="#rsActivo.AFCcodigoclas#";
			window.parent.document.form1.AFCdescripcion.value="#rsActivo.AFCdescripcion#";
			window.parent.document.form1.GATserie.value="#rsActivo.Aserie#";
			window.parent.document.form1.GATfechainidep.value="#LSDateFormat(rsActivo.Afechainidep,'dd/mm/yyyy')#";
			window.parent.document.form1.GATfechainirev.value="#LSDateFormat(rsActivo.Afechainirev,'dd/mm/yyyy')#";
			window.parent.document.form1.GATvutil.value="#rsActivo.VidaUtilSugerida#";
			if (window.parent.funcGATmonto) window.parent.funcGATmonto();
		//-->
	</script>
	</cfoutput>
</cfif> 