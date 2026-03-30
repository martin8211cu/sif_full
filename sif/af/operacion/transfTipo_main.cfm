<!--- <cfdump var="#form#">
 --->
<cfif isdefined("url.AGTPID") and not isdefined("form.AGTPID")>
	<cfset form.AGTPID = url.AGTPID>
</cfif>

		<cf_web_portlet_start titulo="Cambio de Tipos">
			<!--- <form name="form_filtro" method="post" action="transfTipo_main.cfm"> --->
				<input type="hidden" name="AGTPid" value="<cfoutput>#form.AGTPID#</cfoutput>">

				<fieldset>
					<legend><strong>Filtro Origen</strong></legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="12%">Placa Inicial:</td>
							<td>
								<cfset ArrayPlacaI=ArrayNew(1)>
								<cf_conlis 
									ValuesArray="#ArrayPlacaI#"
									campos="AplacaINI,AdescripcionINI"
									size="10,30"
									desplegables="S,S"
									modificables="S,N"
									title="Lista de Placas"
									tabla="Activos"
									columnas="Aplaca as AplacaINI,Adescripcion as AdescripcionINI"
									filtro="Ecodigo = #Session.Ecodigo# and Astatus = 0 Order by Aplaca"									
									filtrar_por="Aplaca,Adescripcion"
									desplegar="AplacaINI,AdescripcionINI"
									etiquetas="Placa,Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="AplacaINI,AdescripcionINI"
									asignarFormatos="S,S"
									form="fagtproceso"
									showEmptyListMsg="true"
									tabindex="1"
									EmptyListMsg=" --- No se encontraron registros --- "/>
							</td>
							<td width="12%">Placa Final:</td>
							<td>
								<cfset ArrayPlacaF=ArrayNew(1)>
								<cf_conlis 
									ValuesArray="#ArrayPlacaF#"
									campos="AplacaFIN,AdescripcionFIN"
									size="10,30"
									desplegables="S,S"
									modificables="S,N"
									title="Lista de Placas"
									tabla="Activos"
									columnas="Aplaca as AplacaFIN,Adescripcion as AdescripcionFIN"
									filtro="Ecodigo = #Session.Ecodigo# and Astatus = 0 Order by Aplaca"
									filtrar_por="Aplaca,Adescripcion"
									desplegar="AplacaFIN,AdescripcionFIN"
									etiquetas="Placa,Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="AplacaFIN,AdescripcionFIN"
									asignarFormatos="S,S"
									form="fagtproceso"
									showEmptyListMsg="true"
									tabindex="2"
									EmptyListMsg=" --- No se encontraron registros --- "/>
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap">Categor&iacute;a Inicial:</td>
							<td rowspan="2">
								<cf_sifCatClase
									keyCat="ACcodigo1"
									keyClas="ACid1"
									nameCat="categoria1"
									nameClas="clasificacion1"
									descCat="Categoriadesc1"
									descClas="Clasificaciondesc1"
									tabindexCat="3"
									tabindexClas="5"
									frameCat="frCat1"
									form="fagtproceso">
							</td>
							<td nowrap="nowrap">Categor&iacute;a Final:</td>
							<td rowspan="2">
								<cf_sifCatClase
									keyCat="ACcodigo2"
									keyClas="ACid2"
									nameCat="categoria2"
									nameClas="clasificacion2"
									descCat="Categoriadesc2"
									descClas="Clasificaciondesc2"
									tabindexCat="4"
									tabindexClas="6"
									frameCat="frCat2"
									form="fagtproceso">
							</td>
						</tr>
						<tr>
							<td>Clase Inicial:</td>
							<td>Clase Final:</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</fieldset>
				<fieldset>
					<legend><strong>Datos Destino</strong></legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="12%">Nuevo Tipo:</td>
							<td>
								<cf_siftipoactivo
									form="fagtproceso"
									tabindex="7"></td>
							<td align="center">
								<input type="submit" name="btnAgregar" value="Agregar" onClick="return funcAgregar()" tabindex="9">
								<input type="submit" name="btnImportar" value="Importar"  tabindex="10">
							</td>
							<td width="15%" align="center">&nbsp;</td>
						</tr>
					</table>
				</fieldset>
			<!--- </form> --->
		<cf_web_portlet_end>
		
		<cf_web_portlet_start titulo="Lista de Activos por Aplicar">		
			<cfinclude template="transfTipo_form.cfm">
		<cf_web_portlet_end>


<script language="javascript1.2" type="text/javascript">
	function funcAgregar() {	
		if (document.fagtproceso.AFCcodigo.value == '') {
			alert('Debe de digitar un tipo de activo.');
			return false;
		}				
	}
	function funcImportar() {
		document.form_filtro.submit();
	}
</script>