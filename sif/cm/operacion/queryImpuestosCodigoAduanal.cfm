<cfparam name="Url.CAid" default="">
<cfparam name="Url.Pais" default="">
<cfif len(Url.CAid) and isNumeric(Url.CAid) and len(Url.Pais) and len(Url.Pais) lte 2>
	<cfquery name="rs" datasource="#Session.DSN#">
		select coalesce(b.Icodigo,a.Icodigo) as Impuesto, Idescripcion
		from CodigoAduanal a
		left outer join ImpuestosCodigoAduanal b
			on b.CAid = a.CAid
			and b.Ecodigo = a.Ecodigo
			and b.Ppaisori = '#Url.Pais#'
		inner join Impuestos c
			on c.Icodigo = coalesce(b.Icodigo,a.Icodigo)
			and c.Ecodigo = a.Ecodigo
		where a.CAid = #Url.CAid#
		and a.Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfif (rs.recordcount)>
		<cfoutput>
			<script language='javascript' type='text/JavaScript' >
                window.parent.document.form1.Icodigo.value = '#TRIM(rs.Impuesto)#';
				window.parent.document.form1.Idescripcion.value = '#TRIM(rs.Idescripcion)#';
            </script>
		</cfoutput>
	</cfif>
</cfif>