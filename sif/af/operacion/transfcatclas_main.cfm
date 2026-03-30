<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<!--- <cfif isdefined("btnImportar")>
	<cflocation url="agtProceso_Importa.cfm?number=1&IDtrans=6">
</cfif> --->


 <!--- <form name="form_filtro" method="post" action="transfcatclas_main.cfm"> ---><fieldset>
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
					tabla="Activos a"
					columnas="a.Aplaca as AplacaINI,a.Adescripcion as AdescripcionINI"
					filtro="  a.Ecodigo = #Session.Ecodigo# 
						  and a.Astatus = 0 													  
						  and not exists (
									select 1
									from ADTProceso xyz
									where xyz.Ecodigo = a.Ecodigo
									  and xyz.Aid = a.Aid
									  and xyz.IDtrans = 2)						
						  and not exists (
									select 1
									from ADTProceso xyz
									where xyz.Ecodigo = a.Ecodigo
									  and xyz.Aid = a.Aid
									  and xyz.IDtrans = 3)									  
						  and not exists (
									select 1
									from ADTProceso xyz
									where xyz.Ecodigo = a.Ecodigo
									  and xyz.Aid = a.Aid
									  and xyz.IDtrans = 4)									  
						  and not exists (
									select 1
									from ADTProceso xyz
									where xyz.Ecodigo = a.Ecodigo
									  and xyz.Aid = a.Aid
									  and xyz.IDtrans = 5)
						  and not exists (
									select 1
									from ADTProceso xyz
									where xyz.Ecodigo = a.Ecodigo
									  and xyz.Aid = a.Aid
									  and xyz.IDtrans = 8)
							Order by a.Aplaca"									
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
					tabla="Activos a"
					columnas="a.Aplaca as AplacaFIN,a.Adescripcion as AdescripcionFIN"
					filtro="	  a.Ecodigo = #Session.Ecodigo# 
							  and a.Astatus = 0 								
							  and not exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = a.Ecodigo
										  and xyz.Aid = a.Aid
										  and xyz.IDtrans = 2)						
							  and not exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = a.Ecodigo
										  and xyz.Aid = a.Aid
										  and xyz.IDtrans = 3)									  
							  and not exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = a.Ecodigo
										  and xyz.Aid = a.Aid
										  and xyz.IDtrans = 4)									  
							  and not exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = a.Ecodigo
										  and xyz.Aid = a.Aid
										  and xyz.IDtrans = 5)
							  and not exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = a.Ecodigo
										  and xyz.Aid = a.Aid
										  and xyz.IDtrans = 8)										  
							Order by a.Aplaca"
					filtrar_por="Aplaca,Adescripcion"
					desplegar="AplacaFIN,AdescripcionFIN"
					etiquetas="Placa,Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="AplacaFIN,AdescripcionFIN"
					asignarFormatos="S,S"
					form="fagtproceso"
					showEmptyListMsg="true"
					tabindex="1"
					EmptyListMsg=" --- No se encontraron registros --- "/>
			</td>
		</tr>
		<tr>
			<td>Categor&iacute;a Inicial:</td>
			<td rowspan="2">
				<cf_sifCatClase
					keyCat="ACcodigo1"
					keyClas="ACid1"
					nameCat="categoria1"
					nameClas="clasificacion1"
					descCat="Categoriadesc1"
					descClas="Clasificaciondesc1"
					tabindexCat="1"
					tabindexClas="1"
					frameCat="frCat"
					form="fagtproceso">
			</td>
			<td>Categor&iacute;a Final:</td>
			<td rowspan="2">
				<cf_sifCatClase
					keyCat="ACcodigo2"
					keyClas="ACid2"
					nameCat="categoria2"
					nameClas="clasificacion2"
					descCat="Categoriadesc2"
					descClas="Clasificaciondesc2"
					tabindexCat="1"
					tabindexClas="1"
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
			<tr>
				<td width="12%">Categor&iacute;a:</td>
				<td rowspan="2">
					<cf_sifCatClase
						keyCat="ACcodigoN"
						keyClas="ACidN"
						nameCat="categoriaN"
						nameClas="clasificacionN"
						descCat="CategoriadescN"
						descClas="ClasificaciondescN"
						tabindexCat="1"
						tabindexClas="1"
						orientacion="V"
						frameCat="frCat3"
						form="fagtproceso">
				</td>
			</tr>
			<td width="12%">Clase:</td>
			<td width="60%" align="center">
				<cf_botones values="Agregar" tabindex="1">
				<!--- <cf_botones values="Importar,Agregar" tabindex="1"> --->
			</td>							
		</tr>
	</table>
</fieldset>
<!---  </form>  --->
<cf_web_portlet_start titulo="Lista de Cambio Categoría Clase">		
	<cfinclude template="transfcatclas_form.cfm">
<cf_web_portlet_end>
<table border="0" cellpadding="1" cellspacing="0" align="center" width="100%" class="ayuda">
	<tr>
		<td width="100%">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" align="center">
			<cf_botones values="Aplicar,Regresar" names="btnAplicarForm,btnRegresar" tabindex="1">
		</td>
	</tr>

	<tr>
		<td  width="100%" align="center">
			El botón "Aplicar" aplica la relación completa,<br>
			no solamente las que se muestran en la lista.<br>
			En el caso de haber filtrado o que la lista<br>
			contenga mas de 25 registros.
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcAgregar() {	
		
		if(document.fagtproceso.ACcodigo1.value == '' && document.fagtproceso.ACcodigo2.value == '' && document.fagtproceso.ACid1.value == '' && document.fagtproceso.ACid2.value == '' && document.fagtproceso.AplacaINI.value == '' && document.fagtproceso.AplacaFIN.value == '' ){
			alert('Debe de digitar un rango de (Placas, Categorías y Clases) origen.');
			return false;
		}
	
	
		if (document.fagtproceso.ACcodigoN.value == '') {
			alert('Debe de digitar una Categoria de activo (Destino).');
			return false;
			}
			
			
		else{
					if (document.fagtproceso.ACidN.value == '') {
						alert('Debe de digitar una Clase de activo (Destino).');
						return false;
					}				
					else{
						document.fagtproceso.action = 'agtProceso_sql_CAMCATCLAS.cfm';
						return true;
					}
			} 
	}
	
	function funcbtnRegresar(){
		document.fagtproceso.action = 'agtProceso_CAMCATCLAS.cfm';
		document.fagtproceso.submit();
	}
	
	function funcbtnAplicarForm() {
		if (confirm('¿Está seguro que desea Aplicar esta relación?')){
		}else{
			return false;
		}
	}
	
</script>
<!--- function funcImportar() {
		document.form_filtro.submit();
	} --->