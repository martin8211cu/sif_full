<cfif isdefined("url.Aid") and len(trim(url.Aid)) and isdefined("url.ArtId") and len(trim(url.ArtId))>
	
	<!--- query de existencias --->
	<cfquery name="rsExistencia" datasource="#session.DSN#">
		select coalesce(Eexistencia, 0) as Eexistencia, coalesce(Ecostou, 0) as Ecostou
		from Existencias a
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Alm_Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
		and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ArtId#">
	</cfquery>
	<cfif rsExistencia.recordcount gt 0 >
		<cfoutput>
		<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
		
		<script type="text/javascript" language="javascript1.2">
			var cantidad = new Number( qf(window.parent.document.form1.DFcantidad.value) )
			var actual = new Number( "#rsExistencia.Eexistencia#");
			var costo = new Number( "#rsExistencia.Ecostou#");
			var dif = new Number( cantidad-actual );
			var total = new Number( dif*costo );
			
			// campos de visualizacion
			window.parent.document.form1.verDFactual.value = fm(actual,2);
			window.parent.document.form1.verDFcostoactual.value = fm(costo,4);
			window.parent.document.form1.verDFdiferencia.value = fm(dif,2);
			window.parent.document.form1.verDFtotal.value = fm( total ,4);

			// campos que van a la bd, para mantener todos los decimales
			window.parent.document.form1.DFactual.value = actual;
			window.parent.document.form1.DFcostoactual.value = costo;
			window.parent.document.form1.DFdiferencia.value = dif;
			window.parent.document.form1.DFtotal.value = total;
		</script>
		</cfoutput>	
	</cfif>
</cfif>