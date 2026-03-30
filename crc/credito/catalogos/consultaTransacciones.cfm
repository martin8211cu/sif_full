<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 					= t.Translate('LB_TituloH','Consulta de Transacciones')>
<cfset TIT_ConsultaTransacciones 	= t.Translate('TIT_ConsultaTransacciones','Consulta de Transacciones')>
<cfset LB_FiltrosConsulta 			= t.Translate('LB_FiltrosConsulta','Filtros de la Consulta')>
<cfset LB_Folio 					= t.Translate('LB_Folio','Folio')>
<cfset LB_FechaDesde				= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta				= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_NumTarjeta				= t.Translate('LB_NumTarjeta','N&uacute;mero de Tarjeta')>
<cfset LB_Cuenta 					= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_Consultar 				= t.Translate('LB_Consultar', 'Consultar')>
<cfset LB_Numero 					= t.Translate('LB_Numero', 'N&uacute;mero')>
<cfset LB_Nombre 					= t.Translate('LB_Nombre', 'Nombre')>
<cfset LB_Tipo 						= t.Translate('LB_Tipo', 'Tipo')>
<cfset LB_Referencias  				= t.Translate('LB_Referencias', 'Referencias(Ticket)')>
<cfset LB_Seleccione  				= t.Translate('LB_Seleccione', 'Seleccione')>


<cfset LB_SocioNegocio 				= t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ConsultaTransacciones#'>

<cfquery name="rsCorteActual" datasource="#session.DSN#">
	select top 1 * from CRCCortes 
		where Cerrado != 1
</cfquery>


<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="consultaTransacciones_sql.cfm" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_FiltrosConsulta#</b>
			</fieldset>
			<table  cellpadding="2" cellspacing="0" border="0">
				<tr><td >&nbsp;</td></tr>
				<tr align="left">
					<td>
						<strong>#LB_Cuenta#:&nbsp;</strong>
						<cf_conlis
							Campos="Numero, SNnombre, Tipo"
							Desplegables="S,S,S"
							Modificables="S,N,S"
							Size="10,30,20"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="SNid,Numero,SNnombre, Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
									end"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo#
									order by SNnombre"
							Desplegar="Numero, SNnombre, Tipo"
							Etiquetas="#LB_Numero#, #LB_Nombre#, #LB_Tipo#"
							filtrar_por="Numero, SNnombre, Tipo"
							Formatos="S,S,S"
							Align="left, left, left"
							Asignar="SNid,Numero,SNnombre, Tipo"
							Asignarformatos="S,S,S,S"
							funcion = "validaTipo()"/>

						<!---<input type="text" name="cuenta" id="cuenta">--->
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_Referencias#:&nbsp;</strong>
						<input type="text" name="referencias" id="referencias">
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1" nameFechaInicio="nameFechaInicio">
						<input type="hidden" name="nameFechaIni" value="#rsCorteActual.FechaInicio#">
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1" nameFechaFin="nameFechFin">
						<input type="hidden" name="nameFechFin" value="#rsCorteActual.FechaFin#">
					</td>
				</tr>
				<tr>
					<td>
						<select name="buscarPor" id="buscarPor">
							
						 		<option value="0">#LB_Seleccione#</option>
							  	<option value="1">#LB_Folio#</option>
							  	<option value="2">#LB_NumTarjeta#</option>
						  </select>
						  <input type="text" name="folio_NumTar" id="folio_NumTar">
					</td>
				</tr>
				<tr>
					<td>
						<label><input type="radio" id="procTipo" name="procTipo" value="D"><cf_translate key="LB_Vales" XmlFile="/crc/generales.xml">Vales</cf_translate></label>
						<label><input type="radio" id="procTipo" name="procTipo" value="TC"><cf_translate key="LB_TC" XmlFile="/crc/generales.xml">Tarjeta de Credito</cf_translate></label>
						<label><input type="radio" id="procTipo" name="procTipo" value="TM"><cf_translate key="LB_TM" XmlFile="/crc/generales.xml">Tarjeta Mayorista</cf_translate></label>
					</td>
				</tr>

				<!---<tr align="left" id="filaFolio">
					<td>
					    <input type="radio" id="numfolio" name="transaccion" value="Folio" onclick="seleccionado(this.form)">
						<strong>#LB_Folio#:&nbsp;</strong>
						<input type="text" name="folio" id="folio" onchange="validaTipoTransac()">
					</td>
				</tr>
				<tr align="left" id="filaTarjeta">
					<td>
						<input type="radio" id="Tarjeta" name="transaccion" value="Tarjeta" onclick="seleccionado(this.form)">
						<strong>#LB_NumTarjeta#:&nbsp;</strong>
						<input type="text" name="numTarjeta" id="numTarjeta" onchange="validaTipoTransac()">
					</td>
				</tr>--->
				<tr>
					<td >&nbsp;</td>
				</tr>
				<tr>
					<td>
						<label id="msj"></label>
					</td>
				</tr>
				<tr align="center">
					<td>
					<input type="submit" class="btnGuardar" name="consultar" id="consultar" value="#LB_Consultar#"> 
					<input type="button" name="limpiar" class="btnLimpiar" value="Limpiar" onclick="javascript:location.href='consultaTransacciones.cfm';" tabindex="2">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
<cf_web_portlet_end>			

<cf_templatefooter>

<script type="text/javascript">

	document.ready = document.getElementById("Tipo").style.display = 'none';


	function validaTipoTransac(){


		var tipoT = document.getElementById('numTarjeta').value;
		var tipoVC = document.getElementById('folio').value;

		if (tipoT != '') {
			document.getElementById('filaFolio').style.display = 'none';
		}else{
			document.getElementById('filaFolio').style.display = '';
		}

		if (tipoVC != ''){
			document.getElementById('filaTarjeta').style.display = 'none';

		}else{
			document.getElementById('filaTarjeta').style.display = '';
		}

		muestraMsj();

	}

	function muestraMsj(){
		if (document.getElementById('filaTarjeta').style.display == 'none' || document.getElementById('filaFolio').style.display == 'none') {
			document.getElementById('msj').style.color="##000000";
			document.getElementById('msj').innerHTML = "No se puede buscar por Folio y N&uacute;mero de Tarjeta a la vez";
		}else{
			document.getElementById('msj').style.color="##000000";
			document.getElementById('msj').innerHTML = "";
		}
	}

	function validaTipo(){

		var tipoSeleccionado = document.getElementById('Tipo').value;

		if(tipoSeleccionado == 'Distribuidor'){
			
			document.forms["form1"]["buscarPor"].value = "1";
			document.form1.buscarPor.disabled=true;

		}else if(tipoSeleccionado == 'Tarjeta de Credito' || tipoSeleccionado == 'Tarjeta Mayorista'){
			document.forms["form1"]["buscarPor"].value = "2";
			document.form1.buscarPor.disabled=true;
		}else {
			document.forms["form1"]["buscarPor"].value = "0";
			document.form1.buscarPor.disabled=false;
		}
	}

</script>
 </cfoutput>


