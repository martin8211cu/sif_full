<cfquery name="rsDetalle" datasource="#session.DSN#">
	select a.Aid as ArtId, a.DFcantidad, a.DFactual, a.DFdiferencia, a.DFcostoactual, a.DFtotal
	from  DFisico a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.DFlinea = <cfif modoDet neq 'ALTA'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DFlinea#"><cfelse>0</cfif>
</cfquery>

<cfset vArticulo = 0 >
<cfif len(trim(rsDetalle.ArtId))>
	<cfset vArticulo = rsDetalle.ArtId >
</cfif>
<cfquery name="rsArticulo" datasource="#session.DSN#">
	select a.Aid as ArtId, a.Acodigo, a.Adescripcion
	from Articulos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vArticulo#">
</cfquery>

<cfset vDFcantidad = 0.00 >
<cfif len(trim(rsDetalle.DFcantidad))>
	<cfset vDFcantidad = rsDetalle.DFcantidad >
</cfif>

<cfoutput>
<table width="98%" align="center" cellpadding="1" cellspacing="0">
	<tr>
		<td><strong>Art&iacute;culo:&nbsp;</strong></td>
		<td><strong>Unidades F&iacute;sicas:&nbsp;</strong></td>
		<td><strong>Inventario Actual:&nbsp;</strong></td>
		<td><strong>Diferencias:&nbsp;</strong></td>
		<td><strong>Costo:&nbsp;</strong></td>
		<td><strong>Total:&nbsp;</strong></td>
	</tr>
	<tr>
		<td>
			<cf_sifarticulos  tabindex="1" id="ArtId" query="#rsArticulo#" Almacen="Aid">
			<input type="hidden" name="antArtId" value="#vArticulo#" />
		</td>
		<td><cf_monto name="DFcantidad" size="15"  tabindex="1" value="#vDFcantidad#" onBlur="funcAcodigo" ></td>
		<td>
			<input type="text" name="verDFactual" disabled="disabled" id="verDFactual"  tabindex="1" value="<cfif len(trim(rsDetalle.DFactual))>#LSNumberFormat(rsDetalle.DFactual, ',9.00')#<cfelse>0.00</cfif>" onfocus="this.value=qf(this); this.select();" size="15" maxlength="15" style="text-align: right;"	>
			<input type="hidden" name="DFactual" id="DFactual"  tabindex="-1" value="<cfif len(trim(rsDetalle.DFactual))>#rsDetalle.DFactual#<cfelse>0.00</cfif>">			
		</td>
		<td>
			<input type="text" name="verDFdiferencia" disabled="disabled" id="verDFdiferencia"  tabindex="1" value="<cfif len(trim(rsDetalle.DFdiferencia))>#LSNumberFormat(rsDetalle.DFdiferencia, ',9.00')#<cfelse>0.00</cfif>" onfocus="this.value=qf(this); this.select();" size="15" maxlength="15" style="text-align: right;"	>
			<input type="hidden" name="DFdiferencia" id="DFdiferencia"  tabindex="-1" value="<cfif len(trim(rsDetalle.DFdiferencia))>#rsDetalle.DFdiferencia#<cfelse>0.00</cfif>">
		</td>

		<td>
			<input type="text" name="verDFcostoactual" disabled="disabled" id="verDFcostoactual"  tabindex="1" value="<cfif len(trim(rsDetalle.DFcostoactual))>#LSNumberFormat(rsDetalle.DFcostoactual, ',9.00')#<cfelse>0.00</cfif>" onfocus="this.value=qf(this); this.select();" size="18" maxlength="18" style="text-align: right;"	>
			<input type="hidden" name="DFcostoactual" id="DFcostoactual"  tabindex="-1" value="<cfif len(trim(rsDetalle.DFcostoactual))>#rsDetalle.DFcostoactual#<cfelse>0.00</cfif>" >
		</td>
		<td>
			<input type="text" name="verDFtotal" disabled="disabled" id="verDFtotal" value="<cfif len(trim(rsDetalle.DFtotal))>#LSNumberFormat(rsDetalle.DFtotal, ',9.00')#<cfelse>0.00</cfif>" tabindex="1" onfocus="this.value=qf(this); this.select();" size="18" maxlength="18" style="text-align: right;"	>
			<input type="hidden" name="DFtotal"  id="DFtotal" value="<cfif len(trim(rsDetalle.DFtotal))>#rsDetalle.DFtotal#<cfelse>0.00</cfif>" tabindex="-1" >			
		</td>
	</tr>
</table>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function funcAcodigo(){
		if( document.form1.antArtId.value != document.form1.ArtId.value ){
			document.form1.DFcantidad.value = '0.00';
			document.form1.verDFactual.value = '0.00';
			document.form1.DFactual.value = '0.00';		
			document.form1.verDFdiferencia.value = '0.00';		
			document.form1.DFdiferencia.value = '0.00';		
			document.form1.verDFcostoactual.value = '0.00';		
			document.form1.DFcostoactual.value = '0.00';		
			document.form1.verDFtotal.value = '0.00';
			document.form1.DFtotal.value = '0.00';
		}
	}
	function funcExtraAcodigo(){
		funcAcodigo();
	}

	function funcDFcantidad(){
		document.getElementById('existencias').src = 'inventarioFisico-existencias.cfm?Aid='+document.form1.Aid.value + '&ArtId='+document.form1.ArtId.value;
	}
	
</script>
<iframe name="existencias" id="existencias" frameborder="1" width="0" height="0" style="display:none;" src=""></iframe>
