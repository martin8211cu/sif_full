<!-- Establecimiento del modo -->
<cfset modo="ALTA">
<cfif isdefined('form.Ucodigo') and len(trim(form.Ucodigo)) >
	<cfset modo="CAMBIO">
</cfif>

<cfquery datasource="#session.DSN#" name="rsUnidades">
	select Ucodigo, Udescripcion, Uequivalencia, Utipo, ts_rversion, ClaveSAT
	from Unidades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<cfif isdefined("Form.Ucodigo") and Form.Ucodigo NEQ "">
		and Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Form.Ucodigo#">
	</cfif>
</cfquery>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js" ></script>
<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form action="SQLUnidades.cfm" method="post" name="form1" >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input type="hidden" name="filtro_Ucodigo" value="<cfif isdefined('form.filtro_Ucodigo') and form.filtro_Ucodigo NEQ ''>#form.filtro_Ucodigo#</cfif>">
	<input type="hidden" name="filtro_Udescripcion" value="<cfif isdefined('form.filtro_Udescripcion') and form.filtro_Udescripcion NEQ ''>#form.filtro_Udescripcion#</cfif>">
	<input type="hidden" name="filtro_Uequivalencia" value="<cfif isdefined('form.filtro_Uequivalencia') and form.filtro_Uequivalencia NEQ ''>#form.filtro_Uequivalencia#</cfif>">

	<table align="center">
		<tr><td colspan="2">&nbsp;</td></tr>

		<tr valign="baseline">
      		<td nowrap align="right">C&oacute;digo:&nbsp;</td>
      		<td>
				<input tabindex="1" type="text" name="Ucodigo" size="5" maxlength="5" value="<cfif modo NEQ 'ALTA'>#rsUnidades.Ucodigo#</cfif>" <cfif modo NEQ 'ALTA'>readonly</cfif> alt="El C&oacute;digo de Unidad" onfocus="javascript:this.select();" />
			</td>
    	</tr>

    	<tr valign="baseline">
			<td align="right">Descripci&oacute;n:&nbsp;</td>
		    <td>
				<input tabindex="1" type="text" name="Udescripcion" size="50" maxlength="50" value="<cfif modo NEQ 'ALTA'>#rsUnidades.Udescripcion#</cfif>" alt="La Descripci&oacute;n de la Unidad" onfocus="javascript:this.select();" />
			</td>
		</tr>

    	<tr valign="baseline">
			<td align="right">Equivalencia:&nbsp;</td>
		    <td>
				<input tabindex="1" type="text" name="Uequivalencia" value="<cfif modo NEQ 'ALTA'>#rsUnidades.Uequivalencia#</cfif>"  size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La Equivalencia para la Unidad">
			</td>
		</tr>

    	<tr valign="baseline">
			<td align="right">Para uso en:&nbsp;</td>
		    <td>
				<select name="Utipo" tabindex="1">
					<option value="0" <cfif modo NEQ 'ALTA' and rsUnidades.Utipo EQ 0>selected</cfif> >Art&iacute;culos</option>
					<option value="1" <cfif modo NEQ 'ALTA' and rsUnidades.Utipo EQ 1>selected</cfif> >Servicios</option>
					<option value="2" <cfif modo NEQ 'ALTA' and rsUnidades.Utipo EQ 2>selected</cfif> >Ambos</option>
				</select>
			</td>
		</tr>
		<tr valign="baseline">
			<td align="right">Clave SAT:&nbsp;</td>
		    <td>
			    <cfset valuesArray = ArrayNew(1)>
				<cfif modo eq "CAMBIO" and rsUnidades.RecordCount GT 0 and trim(rsUnidades.ClaveSAT) neq '' >
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select top 1 CSATCodigo, CSATDescripcion
						from CSAT_Unidad
						where CSATCodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUnidades.ClaveSAT#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsConcepto.CSATCodigo)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CSATDescripcion)>
				</cfif>

				<cf_conlis
					campos="CSATCodigo,CSATDescripcion"
					asignar="CSATCodigo,CSATDescripcion"
					size="8,30"
					desplegables="S,S"
					modificables="S,N"
					title="Unidades SAT"
					tabla="CSAT_Unidad a"
					columnas="CSATCodigo,CSATDescripcion"
					filtrar_por="CSATCodigo,CSATDescripcion"
					desplegar="CSATCodigo,CSATDescripcion"
					etiquetas="Clave,Descripcion"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No hay registros --- "
					valuesArray="#valuesArray#"
					alt="ID,Clave,Descripcion"
				/>
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr valign="baseline">
			<td align="center" colspan="2">
				<cf_Botones modo="#modo#" tabindex="1">
			</td>
		</tr>

		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsUnidades.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>
  	</table>

</form>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Ucodigo.required = true;
	objForm.Ucodigo.description="Código";

	objForm.Udescripcion.required = true;
	objForm.Udescripcion.description="Descripción";

	objForm.Uequivalencia.required = true;
	objForm.Uequivalencia.description="Equivalencia";

	function deshabilitarValidacion(){
		objForm.Ucodigo.required = false;
		objForm.Udescripcion.required = false;
		objForm.Uequivalencia.required = false;
	}

	<cfif modo NEQ 'ALTA'>
		fm(document.form1.Uequivalencia , 2);
	</cfif>

	document.form1.Ucodigo.focus();
</script>
