<cfparam name="historico" default="">
<form action="requisiciones<cfoutput>#historico#</cfoutput>_sql.cfm" method="post" name="form1" style="margin:0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:1">
	  <tr>
		<td width="1%" nowrap>Fecha Desde:&nbsp;</td>
		<td width="1%" nowrap><cf_sifcalendario tabindex="1" name="ERfechadesde" value="#form.ERfechadesde#"></td>
		<td width="1%" nowrap>Fecha Hasta:&nbsp;</td>
		<td nowrap><cf_sifcalendario tabindex="1" name="ERfechahasta" value="#form.ERfechahasta#"></td>
		<td width="1%" nowrap>Documento:&nbsp;</td>
		<td nowrap>
			<input type="text" id="ERdocumento" name="ERdocumento" maxlength="20"  tabindex="1"
			<cfif isdefined("form.ERdocumento") and len(trim(form.ERdocumento)) and form.ERdocumento GT 0>
				value="#form.ERdocumento#"
			</cfif>
			 />
		</td>
	    <td nowrap>&nbsp;</td>
	    <td nowrap>&nbsp;</td>
	  </tr>
	  <tr>
		<td width="1%" nowrap>Almac&eacute;n Desde:&nbsp;</td>
		<td nowrap colspan="3">	
			<cfif len(trim(form.Alm_Aiddesde)) and form.Alm_Aiddesde GT 0>
				<cfquery name="rsAlm" datasource="#session.dsn#">
					select Aid as Alm_Aiddesde, Almcodigo as Almcodigodesde, Bdescripcion as Bdescripciondesde
					from Almacen alm where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aiddesde#">
				</cfquery>
				<cfscript> 
					Alm_desde=ArrayNew(1); ArrayAppend(Alm_desde,rsAlm.Alm_Aiddesde); 
					ArrayAppend(Alm_desde,rsAlm.Almcodigodesde); ArrayAppend(Alm_desde,rsAlm.Bdescripciondesde);
				</cfscript>
			<cfelse>
				<cfscript> 
					Alm_desde=ArrayNew(1); ArrayAppend(Alm_desde,DE('')); 
					ArrayAppend(Alm_desde,DE('')); ArrayAppend(Alm_desde,DE(''));
				</cfscript>
			</cfif>
			<cf_conlis tabindex="1" left="100" top="100" width="600" height="400" maxrows="12"
				campos="Alm_Aiddesde, Almcodigodesde, Bdescripciondesde" 
				desplegables="N,S,S" modificables="N,S,N" size="0, 10,40"
				valuesarray="#Alm_desde#" title="Lista de Almacenes"
				columnas="Aid as Alm_Aiddesde, Almcodigo as Almcodigodesde, Bdescripcion as Bdescripciondesde"
				filtrar_por="Almcodigo, Bdescripcion" tabla="Almacen alm" filtro="alm.Ecodigo=#session.ecodigo#"
				desplegar="Almcodigodesde, Bdescripciondesde" etiquetas="Código,Descripción" formatos="S,S"
				align="left,left" asignar="Alm_Aiddesde, Almcodigodesde, Bdescripciondesde" asignarformatos="I,S,S"
				showEmptyListMsg="true" EmptyListMsg="No se encontró ningún Almacén"
				>		</td>
		<td width="1%" nowrap>Almac&eacute;n Hasta:&nbsp;</td>
		<td colspan="3" nowrap>
			<cfif len(trim(form.Alm_Aidhasta)) and form.Alm_Aidhasta GT 0>
				<cfquery name="rsAlm" datasource="#session.dsn#">
					select Aid as Alm_Aidhasta, Almcodigo as Almcodigohasta, Bdescripcion as Bdescripcionhasta
					from Almacen alm where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aidhasta#">
				</cfquery>
				<cfscript> 
					Alm_hasta=ArrayNew(1); ArrayAppend(Alm_hasta,rsAlm.Alm_Aidhasta); 
					ArrayAppend(Alm_hasta,rsAlm.Almcodigohasta); ArrayAppend(Alm_hasta,rsAlm.Bdescripcionhasta);
				</cfscript>
			<cfelse>
				<cfscript> 
					Alm_hasta=ArrayNew(1); ArrayAppend(Alm_hasta,DE('')); 
					ArrayAppend(Alm_hasta,DE('')); ArrayAppend(Alm_hasta,DE(''));
				</cfscript>
			</cfif>
			<cf_conlis tabindex="1" left="100" top="100" width="600" height="400" maxrows="12"
				campos="Alm_Aidhasta, Almcodigohasta, Bdescripcionhasta" 
				desplegables="N,S,S" modificables="N,S,N" size="0, 10,40"
				valuesarray="#Alm_hasta#" title="Lista de Almacenes"
				columnas="Aid as Alm_Aidhasta, Almcodigo as Almcodigohasta, Bdescripcion as Bdescripcionhasta"
				filtrar_por="Almcodigo, Bdescripcion" tabla="Almacen alm" filtro="alm.Ecodigo=#session.ecodigo#"
				desplegar="Almcodigohasta, Bdescripcionhasta" etiquetas="Código,Descripción" formatos="S,S"
				align="left,left" asignar="Alm_Aidhasta, Almcodigohasta, Bdescripcionhasta" asignarformatos="I,S,S"
				showEmptyListMsg="true" EmptyListMsg="No se encontró ningún Almacén"
				>		</td>
	    </tr>
<cfparam name="ocultarFiltroCFuncionales" default="false">
<cfif not ocultarFiltroCFuncionales>
	  <tr>
		<td width="1%" nowrap>Centro Funcional Desde:&nbsp;</td>
		<td nowrap colspan="3">
			<cfif len(trim(form.CFiddesde)) and form.CFiddesde GT 0>
				<cfquery name="rsCF" datasource="#session.dsn#">
					select CFid as CFiddesde, CFcodigo as CFcodigodesde, CFdescripcion as CFdescripciondesde
					from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFiddesde#">
				</cfquery>
			<cfelse>
				<cfset rsCF = QueryNew('CFcodigo')>		
			</cfif>
			<cf_rhcfuncional tabindex="1" name="CFcodigodesde" desc="CFdescripciondesde" id="CFiddesde" query="#rsCF#">		</td>
		<td width="1%" nowrap>Centro Funcional Hasta:&nbsp;</td>
		<td colspan="3" nowrap>
			<cfif len(trim(form.CFidhasta)) and form.CFidhasta GT 0>
				<cfquery name="rsCF" datasource="#session.dsn#">
					select CFid as CFidhasta, CFcodigo as CFcodigohasta, CFdescripcion as CFdescripcionhasta
					from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidhasta#">
				</cfquery>
			<cfelse>
				<cfset rsCF = QueryNew('CFcodigo')>		
			</cfif>
			<cf_rhcfuncional tabindex="1" name="CFcodigohasta" desc="CFdescripcionhasta" id="CFidhasta" query="#rsCF#">		</td>
	    </tr>
</cfif>
	  <tr>
		<td width="1%" nowrap>Tipo de Requisici&oacute;n:&nbsp;</td>
		<td width="1%" nowrap>
			<cfquery datasource="#session.DSN#" name="rsTRequisicion">
				select TRcodigo, TRdescripcion
				from TRequisicion 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >  
				order by TRcodigo
			</cfquery>
			<select tabindex="1" name="TRcodigo">
				<option value=""> -- Todos -- </option>
				<cfloop query="rsTRequisicion">
					<option value="#trim(rsTRequisicion.TRcodigo)#"
					<cfif trim(form.TRcodigo) eq trim(rsTRequisicion.TRcodigo)>selected</cfif>> 
						#rsTRequisicion.TRdescripcion#					</option>
				</cfloop>
			</select>		</td>
	    <td width="1%" nowrap>&nbsp;</td>
	    <td nowrap>&nbsp;</td>
		<td width="1%" nowrap>Formato:&nbsp;</td>
		<td nowrap>
			<select tabindex="1" name="Formato">
				<option value="html" <cfif form.Formato eq 'html'>selected</cfif>> HTML </option>
				<option value="bightml" <cfif form.Formato eq 'bightml'>selected</cfif>> Descarga HTML </option>
			</select>		</td>
		<td nowrap>Tipo de Reporte:&nbsp;</td>
		<td nowrap><select tabindex="1" name="Tipo">
          <option value="resumido" <cfif form.Tipo eq 'resumido'>selected</cfif>> Resumido </option>
          <option value="detallado" <cfif form.Tipo eq 'detallado'>selected</cfif>> Detallado </option>
        </select></td>
	  </tr>
	</table>
	<input type="hidden" name="rptpaso" id="rptpaso" value="2"/>
	<cf_botones values="Consultar, Limpiar, Download" tabindex="2">
</cfoutput>
</td>
</tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	<!--
	document.form1.ERfechadesde.focus();
	function funcLimpiar() {
		document.form1.ERfechadesde.focus();
	}
	-->
</script>