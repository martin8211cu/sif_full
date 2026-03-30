<cfif isdefined("url.id") and len(trim(url.id))>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Seleccionar"
		Default="seleccionar"
		returnvariable="seleccionar"/>

	<cfquery name="rs_formatos" datasource="#session.DSN#">
		select EFEid, EFEdescripcion 
		from EFormatosExpediente
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		order by EFEdescripcion
	</cfquery>

		<!---ljimenez se cambio el nombre por que no hacia referencia al combo en la pantalla
		.tipoFormato;--->
	<script type="text/javascript" language="javascript1.2">
		var combo = window.parent.document.form1.EFEid;
		combo.length = 0;

		combo.length++;
		combo.options[combo.length-1].value = '';
		combo.options[combo.length-1].text = '-<cfoutput>#seleccionar#</cfoutput>-';

		<cfoutput query="rs_formatos">
			combo.length++;
			combo.options[combo.length-1].value = '#rs_formatos.EFEid#';
			combo.options[combo.length-1].text = '#rs_formatos.EFEdescripcion#';
			<cfif isdefined('url.id_selected') and rs_formatos.EFEid EQ url.id_selected>
			combo.options[combo.length-1].selected = true;
			</cfif>
		</cfoutput>
	</script>
<cfelse>
	<script type="text/javascript" language="javascript1.2">
		var combo = window.parent.document.form1.tipoFormato;
		combo.length = 0;
	</script>
</cfif>