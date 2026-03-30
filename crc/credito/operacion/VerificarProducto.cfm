<!--- 
Creado por Jose Gutierrez 
	13/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Verificar Productos')>
<cfset TIT_VerificarProductos 	= t.Translate('TIT_VerificarProductos','Verificar Productos')>
<cfset LB_TituloTabla			= t.Translate('LB_TituloTabla','Resultados Verificaci&oacute;n')>
<cfset LB_TipoTransaccion		= t.Translate('LB_TipoTransaccion','Tipo de Transacci&oacute;n')>
<cfset LB_NumTarjeta 			= t.Translate('LB_NumTarjeta','N&uacute;mero de Tarjeta')>
<cfset LB_NumFolio				= t.Translate('LB_NumFolio','N&uacute;mero de Folio')>
<cfset LB_CodTienda				= t.Translate('LB_CodTienda','C&oacute;digo de Tienda')>
<cfset LB_CodExtDistribuidor	= t.Translate('LB_CodExtDistribuidor','C&oacute;digo Ext. Distribuidor')>
<cfset LB_Monto 				= t.Translate('LB_Monto', 'Monto')>
<cfset LB_MsjErrorTar 			= t.Translate('LB_MsjError1', 'Para este tipo de transacci&oacute;n el n&uacute;mero de tarjeta es requerido')>
<cfset LB_MsjErrorVal 			= t.Translate('LB_MsjErrorVal', 'Para este tipo de transacci&oacute;n el n&uacute;mero de folio y C&oacute;digo de tienda son requeridos')>

<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_VerificarProductos#'>

<cfset crcBoletin = createObject("component","crc.Componentes.boletin.CRCBoletin")>
<cfinclude template="../../../sif/Utiles/sifConcat.cfm">

<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<form name="form1" action="VerificarProducto.cfm" method="post">
			<td width="50%" valign="top">
				<cfinclude template="VerificarProducto_form.cfm">
			</td>
		</form>
		<td width="50%" valign="top">
			<cfinclude template="VerificarProducto_sql.cfm">
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center" style="padding-top: 20px;">
			<form id="formBoletinCurp">
				<fieldset style="width:70%; margin:auto; padding: 15px; border: 1px solid ##ddd; border-radius: 6px;">
					<legend style="font-size: 20px; font-weight: bold; color: ##333; border-bottom: 2px solid ##007bff; padding-bottom: 3px; margin-bottom: 15px; width: auto;">
						<i class="fa fa-search"></i> Consultar Bolet&iacute;n por CURP
					</legend>
					<div style="display: flex; align-items: center; gap: 8px; justify-content: center;">
						<label for="curp" style="font-size: 14px; font-weight: bold; color: ##555;">CURP:</label>
						<input type="text" name="curp" id="curp" maxlength="18" required 
							style="text-transform: uppercase; font-size: 14px; padding: 6px; border: 1px solid ##ccc; border-radius: 4px; width: 200px;">
						<button type="button" class="btn btn-primary" onclick="consultarBoletinAjax()" style="margin-left: 8px;">
							<i class="fa fa-search"></i> Consultar
						</button>
						<button type="button" class="btn btn-default" onclick="limpiarFormulario()">
							<i class="fa fa-eraser"></i> Limpiar
						</button>
					</div>
				</fieldset>
			</form>
			<div id="resultadoBoletin" style="margin-top: 20px;"></div>
		</td>
	</tr>
</table>

<script type="text/javascript">
function limpiarFormulario() {
    document.getElementById('curp').value = '';
    document.getElementById('resultadoBoletin').innerHTML = '';
}

function consultarBoletinAjax() {
    var curp = document.getElementById('curp').value.trim().toUpperCase();
    
    if (!curp) {
        alert('Por favor ingrese un CURP');
        return;
    }

    // Mostrar indicador de carga
    document.getElementById('resultadoBoletin').innerHTML = '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Cargando...</div>';

    // Realizar la consulta AJAX
    $.ajax({
        url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=getBoletin",
        type: "GET",
        data: { curp: curp },
        success: function(response) {
            try {
                var boletin = JSON.parse(response);
                var html = '';
                
                if (boletin && boletin.length > 0) {
                    html = '<table class="table table-bordered table-striped">' +
                           '<thead><tr>' +
                           '<th>CURP</th>' +
                           '<th>Nombre Completo</th>' +
                           '<th>Distribuidor</th>' +
                           '<th>Boletinado</th>' +
                           '<th>Estado</th>' +
                           '</tr></thead><tbody>';
                    
                    boletin.forEach(function(item) {
                        html += '<tr>' +
                            '<td>' + item.CURP + '</td>' +
                            '<td>' + item.Nombre + ' ' + item.ApellidoPaterno + ' ' + item.ApellidoMaterno + '</td>' +
                            '<td>' + (item.Distribuidor || '-') + '</td>' +
                            '<td>' + (item.Boletinado == 1 ? 
                                '<span class="label label-danger text-white">Si</span>' : 
                                '<span class="label label-success">No</span>') + '</td>' +
                            '<td>' + (item.Estado == 'PENDIENTE' ? 
                                '<span class="label label-warning text-white">' + 
                                (item.BoletinadoSolicitado == 1 ? 'Boletinado' : 'Desboletinado') + ' Pendiente</span>' : 
                                '-') + '</td>' +
                            '</tr>';
                    });
                    
                    html += '</tbody></table>';
                } else {
                    html = '<div class="text-center"><h3>No se encontraron resultados</h3></div>';
                }
                
                document.getElementById('resultadoBoletin').innerHTML = html;
            } catch (error) {
                console.error('Error procesando la respuesta:', error);
                document.getElementById('resultadoBoletin').innerHTML = 
                    '<div class="alert alert-danger">Error al procesar los datos del boletín</div>';
            }
        },
        error: function(xhr, status, error) {
            document.getElementById('resultadoBoletin').innerHTML = 
                '<div class="alert alert-danger">Error al consultar el boletín: ' + error + '</div>';
        }
    });
}
</script>

<cf_web_portlet_end>			

<cf_templatefooter>

</cfoutput>


