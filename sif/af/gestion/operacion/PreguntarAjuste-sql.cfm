<!--- Se arma la nueva lista de concecutivos a aplicar, con los consecutivos base 
	  que no requieren ajuste y los seleccionados --->
<cfloop list="#form.chksel#" index="llave">

	<cfif form.chkbase eq "">
		<cfset form.chkbase = llave>
	<cfelse>
		<cfset form.chkbase = form.chkbase & "," & llave>
	</cfif>

</cfloop>
<cfset form.chk = form.chkbase>

<form name="Frmapli" action="Conciliacion-sql.cfm" method="post">
	<cfoutput>
	<input type="hidden" name="GATperiodo" value="#form.GATPERIODO#">
	<input type="hidden" name="GATmes" value="#form.GATMES#">
	<input type="hidden" name="Fieldnames" value="#form.FIELDNAMES#">
	<input type="hidden" name="Edocumento" value="#form.EDOCUMENTO#">
	<input type="hidden" name="chk" value="#form.CHK#">
	<input type="hidden" name="Cconcepto" value="#form.CCONCEPTO#">
	<input type="hidden" name="btnAplicar" value="#form.BTNAPLICAR#">
	<input type="hidden" name="botonsel" value="#form.BOTONSEL#">	
	<input type="hidden" name="NOLOCATION" value="S">	
	<input type="hidden" name="NoRev" value="true">	
	</cfoutput>	
</form>
<center><strong>Iniciando la aplicacion de documentos...<br>Espere un momento por favor</strong></center>
<script>
document.Frmapli.submit();
</script>