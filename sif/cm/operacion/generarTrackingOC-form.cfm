<cfif isdefined("url.EOnumero") and not isdefined("form.EOnumero") >
	<cfset form.EOnumero = url.EOnumero >
</cfif>
<cfif isdefined("url.Observaciones") and not isdefined("form.Observaciones")>
	<cfset form.Observaciones = url.Observaciones >
</cfif>
<cfif isdefined("url.EOfecha") and not isdefined("form.EOfecha")>
	<cfset form.EOfecha = url.EOfecha >
</cfif>
<cfif isdefined("url.CMTOcodigo") and not isdefined("form.CMTOcodigo")>
	<cfset form.CMTOcodigo = url.CMTOcodigo >
</cfif>

<cfquery name="dataTipos" datasource="#session.DSN#">
	select CMTOcodigo 
	from CMTipoOrden
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMTOcodigo
</cfquery>

<cfquery name="dataLineas" datasource="sifpublica">
	select DOlinea 
	from ETrackingItems
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and cncache=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DSN#">
</cfquery>
<cfset notIn = ValueList(dataLineas.DOLinea)>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLista" datasource="#session.DSN#">
	select distinct a.EOidorden, 
			a.EOnumero, 
			a.CMTOcodigo, 
			b.CMTOdescripcion, 
			a.SNcodigo, 
			d.SNnumero, 
			d.SNnombre, 
			a.Observaciones, 
			a.EOfecha,
			'Proveedor: ' #_Cat# d.SNnumero #_Cat# ' - ' #_Cat#d.SNnombre as Proveedor
	from EOrdenCM a
	
	inner join CMTipoOrden b
	on a.CMTOcodigo=b.CMTOcodigo
	 and a.Ecodigo=b.Ecodigo
	 <!--- and b.CMTgeneratracking=1 --->
	
	inner join DOrdenCM c
	on a.EOidorden=c.EOidorden
	and CMtipo='A'
	
	inner join SNegocios d
	on a.SNcodigo=d.SNcodigo
	and a.Ecodigo=d.Ecodigo
	
	<cfif len(trim(notIn)) >
		and DOlinea not in (#notIn#)
	</cfif>
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.EOestado=10
	  
	  <cfif isdefined("form.EOnumero") and len(trim(form.EOnumero))>
	  	and a.EOnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EOnumero#">
	  </cfif>
	  <cfif isdefined("form.Observaciones") and len(trim(form.Observaciones))>
	  	and upper(a.Observaciones) like '%#Ucase(form.Observaciones)#%'
	  </cfif>
	  <cfif isdefined("form.EOfecha") and len(trim(form.EOfecha))>
	  	and a.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EOfecha)#">
	  </cfif>
	  <cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo))>
	  	and a.CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMTOcodigo#">
	  </cfif>

	order by Proveedor, a.EOnumero, a.EOfecha 
</cfquery>

<table width="98%" align="center" cellpadding="0" cellspacing="0">

	<tr>
		<td>
			<script  language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
			<cfoutput>
			<form name="filtro" action="generarTrackingOC.cfm" style="margin:0;" method="post" >
				<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
						<td align="right"><strong>No. Orden:&nbsp;</strong></td>
						<td><input type="text" name="EOnumero" value="<cfif isdefined("form.EOnumero") and len(trim(form.EOnumero))>#form.EOnumero#</cfif>" tabindex="1" size="7" maxlength="7" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
						<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
						<td ><input type="text" name="Observaciones" onFocus="this.select();" value="<cfif isdefined("form.Observaciones") and len(trim(form.Observaciones))>#form.Observaciones#</cfif>" tabindex="1" size="40" maxlength="255" ></td>
						<td align="right"><strong>Fecha:&nbsp;</strong></td>
						<td>
							<cfset valor = ''>
							<cfif isdefined("form.EOfecha") and len(trim(form.EOfecha))>
								<cfset valor = form.EOfecha >
							</cfif>
							<cf_sifcalendario form="filtro" name="EOfecha" value="#valor#">
						</td>
						<td colspan="2" align="right"><strong>Tipo:&nbsp;</strong></td>
						<td>
							<select name="CMTOcodigo">
								<option value="">- Todos -</option>
								<cfloop query="dataTipos">
									<option value="#dataTipos.CMTOcodigo#" <cfif isdefined("form.CMTOcodigo") and trim(form.CMTOcodigo) eq trim(dataTipos.CMTOcodigo) >selected</cfif> >#dataTipos.CMTOcodigo#</option>
								</cfloop>
							</select>
						</td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
					</tr>
				</table>
			</form>
			</cfoutput>
		</td>
	</tr>

	<tr>
		<td>
			<cfset navegacion = ''>
			<cfif isdefined("form.EOnumero") and len(trim(form.EOnumero))>
				<cfset navegacion = navegacion & '&EOnumero=#form.EOnumero#'>
			</cfif>
			<cfif isdefined("form.Observaciones") and len(trim(form.Observaciones))>
				<cfset navegacion = navegacion & '&Observaciones=#form.Observaciones#'>
			</cfif>
			<cfif isdefined("form.EOfecha") and len(trim(form.EOfecha))>
				<cfset navegacion = navegacion & '&EOfecha=#form.EOfecha#'>
			</cfif>
			<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo))>
				<cfset navegacion = navegacion & '&CMTOcodigo=#form.CMTOcodigo#'>
			</cfif>

			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="EOnumero,Observaciones,EOfecha,CMTOcodigo"/>
				<cfinvokeargument name="etiquetas" value="No. Orden, Descripci&oacute;n, Fecha, Tipo de Orden"/>
				<cfinvokeargument name="formatos" value="I,V,D,V"/>
				<cfinvokeargument name="align" value="left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="maxRows" value="20"/>
				<cfinvokeargument name="irA" value="generarTrackingOC-sql.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="Cortes" value="Proveedor"/>
				<cfinvokeargument name="Botones" value="Aplicar"/>
				<cfinvokeargument name="keys" value="EOidorden"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcAplicar(){
		var continuar = false;
		var ocID = "0";
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = document.lista.chk.checked;
				ocID = document.lista.chk.value;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						ocID = document.lista.chk[k].value;
						break;
					}
				}
			}
			if (!continuar) { alert('Debe seleccionar al menos una Orden de Compra'); }
		}
		else {
			alert('No existen Ordenes de Compra')
		}

		if ( continuar ){
			document.lista.submit();
		}	

		return continuar;
	}
</script>