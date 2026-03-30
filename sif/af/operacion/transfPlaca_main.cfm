<!--- <cfdump var="#form#">
 --->
<cfif isdefined("url.AGTPID") and not isdefined("form.AGTPID")>
	<cfset form.AGTPID = url.AGTPID>
</cfif>

		<cf_web_portlet_start titulo="Cambio de Placas">
			<!--- <form name="form_filtro" method="post" action="transfTipo_main.cfm">--->
				<input type="hidden" name="AGTPid" value="<cfoutput>#form.AGTPID#</cfoutput>">

				<fieldset>
					<legend><strong>Filtro Origen</strong></legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20%">Placa Actual:</td>
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
						</tr>						
					</table>
				</fieldset>
				<fieldset>
					<legend><strong>Datos Destino</strong></legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20%">Nueva Placa:</td>
							<td>
								<input type="text" name="New_Aplaca" maxlength="30" tabindex="7">
							</td>
							<td align="center">
								<input type="submit" name="btnAgregar" value="Agregar" onClick="return funcAgregar()" tabindex="9">
							</td>
							<td width="15%" align="center">&nbsp;</td>
						</tr>
					</table>
				</fieldset>
			<!--- </form> --->
		<cf_web_portlet_end>
		
		<cf_web_portlet_start titulo="Lista de Activos por Aplicar">		
			<cfinclude template="transfPlaca_form.cfm">
		<cf_web_portlet_end>


<script language="javascript1.2" type="text/javascript">
	function funcAgregar() {	
		if (document.fagtproceso.AplacaINI.value == '') {
			alert('Debe seleccionar la placa actual.');
			return false;
		}				
		if (document.fagtproceso.New_Aplaca.value == '') {
			alert('Debe de digitar la nueva placa.');
			return false;
		}				
	}
	function funcImportar() {
		document.form_filtro.submit();
	}
</script>