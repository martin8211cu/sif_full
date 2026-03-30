<cfset navegacion = "&btnFiltrar=Filtrar" >
<cfset filtro = "EEid=#form.EEid# and exists (select 1 from EncuestaSalarios m where m.Eid = Encuesta.Eid)" >
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fEdescripcion.value = '';
		document.filtro.fEfecha.value		 = '';
		<cfset navegacion = '' >
	}
</script>
			  
<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
<cfset fEdescripcion = "">
<cfset fEfecha = "">
<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") >
	<cfset form.btnFiltrar = url.btnFiltrar >
</cfif>
<cfif isdefined("url.fEdescripcion") and not isdefined("form.fEdescripcion") >
	<cfset form.fEdescripcion = url.fEdescripcion >
</cfif>
<cfif isdefined("url.fEfecha") and not isdefined("form.fEfecha") >
	<cfset form.fEfecha = url.fEfecha >
</cfif>
<cfif isdefined("form.fEdescripcion") AND Len(Trim(form.fEdescripcion)) GT 0>
	<cfset filtro = filtro & " and upper(Edescripcion) like upper('%" & Trim(form.fEdescripcion) & "%')" >
	<cfset fEdescripcion = Trim(form.fEdescripcion)>
	<cfset navegacion = navegacion & "&fEdescripcion=#form.fEdescripcion#" >
</cfif>
<cfif isdefined("form.fEfecha") AND Len(Trim(form.fEfecha)) GT 0>
	<cfset filtro = filtro & " and Efecha >= "& #LSPARSEDATETIME(LSDateFormat(Form.fEfecha,"DD/MM/YYY"))# &"" >
	<cfset fEfecha = Trim(form.fEfecha)>
	<cfset navegacion = navegacion & "&fECfecha=#form.fEfecha#" >
</cfif>

<cfset navegacion = navegacion & "&tab=4&EEid=#form.EEid#" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin: 0; " name="filtro" method="post" action="TEncuestadoras.cfm">
				<cfoutput> 			
					<input type="hidden" name="tab" value="4">
					<input type="hidden" name="EEid" value="#form.EEid#">
					<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
						<tr> 
							<td align="right" width="11%">Descripci&oacute;n:&nbsp;</td>
							<td width="24%">
								<input type="text" name="fEdescripcion" value="#fEdescripcion#" 
									   size="35" maxlength="35" onFocus="this.select();">
							</td>
							<td width="10%" align="right">Fecha:&nbsp;</td>
							<td width="14%"><cf_sifcalendario form="filtro" name="fEfecha" value="#fEfecha#"></td>
							<td width="41%"><div align="right"> 
									<input type="submit" name="btnFiltrar" value="Filtrar">
									<input type="button" name="btnLimpiar" value="Limpiar"
										   onClick="javascript:limpiar()">
								</div>
							</td>
						</tr>
					</table>
				</cfoutput> 					
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Encuesta"/>
				<cfinvokeargument name="columnas" value="Eid, EEid, Edescripcion, Efecha, Efechaanterior, 1 as Paso, 4 as tab"/>
				<cfinvokeargument name="desplegar" value="Edescripcion, Efecha, Efechaanterior"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha, Fecha de Encuesta anterior"/>
				<cfinvokeargument name="formatos" value="V,D,D"/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="TEncuestadoras.cfm"/>
				<cfinvokeargument name="keys" value="Eid"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="conexion" value="sifpublica"/>
				<cfinvokeargument name="botones" value="Nueva"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	function funcNueva(){
		document.lista.PASO.value = 1;
		document.lista.TAB.value = 4;
		document.lista.EEID.value = '<cfoutput>#form.EEid#</cfoutput>';
		document.lista.submit();
	}
</script>

