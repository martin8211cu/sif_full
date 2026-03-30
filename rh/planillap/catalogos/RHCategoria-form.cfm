<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfif isdefined("url.RHCid") and len(trim(url.RHCid))>
	<cfset form.RHCid = url.RHCid>
</cfif>
<cfset modo = "ALTA">
<cfif isdefined("form.RHCid") and len(trim(form.RHCid)) and form.RHCid neq 0 >
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("form.RHCidpadre") and len(trim(form.RHCidpadre))>
	<cfquery name="rsDatosPadre" datasource="#session.DSN#"> 
		select RHCid, RHCcodigo, RHCdescripcion
		from RHCategoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCidpadre#"> 
	</cfquery>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHCid, a.RHCcodigo, a.RHCdescripcion, 
				a.RHCidpadre as RHCidpadre, a.path, a.nivel, a.ts_rversion,
				b.RHCcodigo as RHCcodigopadre, b.RHCdescripcion as RHCdescripcionpadre				
		from  RHCategoria a
			left outer join RHCategoria b
				on a.RHCidpadre = b.RHCid
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#"> 
	</cfquery>	
</cfif>

<cfoutput>
<form action="RHCategoria-sql.cfm"  method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input name="RHCcodigo" size="10"  id="RHCcodigo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHCcodigo)#</cfif>" maxlength="10" onfocus="this.select()" tabindex="1" onKeyPress="return acceptNum(event)">
				<input name="_RHCcodigo" size="10"  id="_RHCcodigo" type="hidden" value="<cfif modo NEQ 'ALTA'>#trim(data.RHCcodigo)#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				 <input name="RHCdescripcion" size="40" id="RHCdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHCdescripcion)#</cfif>" maxlength="80" onfocus="this.select()" tabindex="1">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Categoría Padre:&nbsp;</strong></td>
			<td>
				<!---<cf_rhCategoria form="form1">--->
				<cfset arrValuesCambio = ArrayNew(1)>
				<cfset filtro = "">
				<cfif modo NEQ 'ALTA'>
					<cfif len(trim(data.RHCidpadre))>
						<cfset ArrayAppend(arrValuesCambio, data.RHCidpadre)>
						<cfset ArrayAppend(arrValuesCambio, data.RHCcodigopadre)>
						<cfset ArrayAppend(arrValuesCambio, data.RHCdescripcionpadre)>
					</cfif>
					<cfset filtro = " and RHCid <> " & data.RHCid>
				<cfelseif isdefined("rsDatosPadre") and rsDatosPadre.RecordCount NEQ 0>
					<cfset ArrayAppend(arrValuesCambio, rsDatosPadre.RHCid)>
					<cfset ArrayAppend(arrValuesCambio, rsDatosPadre.RHCcodigo)>
					<cfset ArrayAppend(arrValuesCambio, rsDatosPadre.RHCdescripcion)>						
				</cfif>
				<cf_conlis 
					campos="RHCidpadre,RHCcodigopadre,RHCdescripcionpadre"
					size="0,10,40"
					desplegables="N,S,S"
					modificables="N,S,N"
					valuesArray="#arrValuesCambio#"
					title="Lista de Categor&iacute;as"
					tabla="RHCategoria"
					columnas="RHCid as RHCidpadre, RHCcodigo as RHCcodigopadre, RHCdescripcion as RHCdescripcionpadre"
					filtro="Ecodigo = #Session.Ecodigo##filtro#"
					filtrar_por="RHCcodigo, RHCdescripcion"
					desplegar="RHCcodigopadre, RHCdescripcionpadre"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="RHCidpadre,RHCcodigopadre,RHCdescripcionpadre"
					asignarFormatos="I,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No se encotraron registros --- "/>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();" tabindex="1">
					<input type="reset" name="Limpiar" value="Limpiar" tabindex="1">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();" tabindex="1">
					<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;" tabindex="1">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();" tabindex="1">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHCid" value="#data.RHCid#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHCcodigo.required = true;
	objForm.RHCcodigo.description="Código";				
	objForm.RHCdescripcion.required= true;
	objForm.RHCdescripcion.description="Descripción";	
	
	function habilitarValidacion(){
		objForm.RHCcodigo.required = true;
		objForm.RHCdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHCcodigo.required = false;
		objForm.RHCdescripcion.required = false;
	}
</script>


