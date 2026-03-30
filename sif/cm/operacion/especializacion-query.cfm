<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Seguridad por solicitante --->
<cfquery name="data" datasource="#session.DSN#">
	select a.CMElinea, 
		   f.CMEtipo,
		   f.CMEtipo #_Cat#'-'#_Cat# 
			case when CMEtipo = 'A' 
				then ((
					select min(Cdescripcion) 
					from Clasificaciones b 
					where b.Ccodigo = f.Ccodigo
					  and b.Ecodigo = f.Ecodigo
					))
			when CMEtipo = 'S' 
				then ((
					select min(CCdescripcion) 
					from CConceptos c 
					where c.CCid = f.CCid
					))
			when CMEtipo = 'F' 
				then ((
					select min(ACdescripcion)
					from AClasificacion d
					where d.ACid = f.ACid
					and d.ACcodigo = f.ACcodigo
					and d.Ecodigo = f.Ecodigo
					))
			else
				' '
			end as descripcion
	from CMESolicitantes a
		inner join CMEspecializacionTSCF f
		 on f.CMElinea = a.CMElinea

	where a.CMSid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Compras.solicitante#">
	  and f.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CMTScodigo#">
	  and f.CFid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	order by f.CMEtipo
</cfquery>

<cfif data.RecordCount eq 0>
	<!--- Seguridad por TSCF --->
	<cfquery name="data" datasource="#session.DSN#">
	select a.CMElinea, 
		   a.CMEtipo,
		   a.CMEtipo #_Cat#'-'#_Cat# 
			case when CMEtipo = 'A' 
				then ((
					select min(Cdescripcion) 
					from Clasificaciones b 
					where b.Ccodigo = a.Ccodigo
					  and b.Ecodigo = a.Ecodigo
					))
			when CMEtipo = 'S' 
				then ((
					select min(CCdescripcion) 
					from CConceptos c 
					where c.CCid = a.CCid
					))
			when CMEtipo = 'F' 
				then ((
					select min(ACdescripcion)
					from AClasificacion d
					where d.ACid = a.ACid
					and d.ACcodigo = a.ACcodigo
					and d.Ecodigo = a.Ecodigo
					))
			else
				' '
			end as descripcion

		from CMEspecializacionTSCF a
		where a.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		  and a.CMTScodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CMTScodigo#">
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by a.CMEtipo
	</cfquery>
</cfif>

<cfif data.RecordCount gt 0>
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.CMElinea.length = 0;
		i = 1;
		window.parent.document.form1.CMElinea.length = 1;
		window.parent.document.form1.CMElinea.options[0].value = '';
		window.parent.document.form1.CMElinea.options[0].text  = 'Ninguna';
		<cfoutput query="data">
			window.parent.document.form1.CMElinea.length = i+1;
			window.parent.document.form1.CMElinea.options[i].value = '#data.CMElinea#';
			window.parent.document.form1.CMElinea.options[i].text  = '#data.descripcion#';
			
			if ( window.parent.document.form1._CMElinea.value && ( window.parent.document.form1._CMElinea.value == '#data.CMElinea#' ) ){
				window.parent.document.form1.CMElinea.options[i].selected = true ;
			}
			
			i++;
		</cfoutput>
	</script>
<cfelse>
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.CMElinea.length = 0;
	</script>
</cfif>