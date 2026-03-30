<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte Clientes')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_TipoCta 		= t.Translate('LB_TipoCta','Tipos de Cuenta')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>
<cfset crcBoletin = createObject("component","crc.Componentes.boletin.CRCBoletin")>
<form name="form1" action="reporteClientes_sql.cfm?p=0" method="post" id="form1">
<cfoutput>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="80%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td>
						<table  width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td>&nbsp;</td></tr>
							<tr align="left">
								<td>
									<!---<strong>#LB_SNegocio#:&nbsp;</strong>--->
									<cfset tipoSN = "D">
									<strong>Nombre:</strong>
									<input type="text" name="Nombre" value="<cfif isDefined('form.Nombre')>#form.Nombre#<cfelse></cfif>">
								</td>
							</tr>			
							<tr align="left">
								 <td width="10%" nowrap>
									 <strong>Apellido Paterno:</strong>
									 <input type="text" name="Apellido1" value="<cfif isDefined('form.Apellido1')>#form.Apellido1#<cfelse></cfif>">	
								 </td> 
							</tr>
							<tr align="left">
								 <td width="10%" nowrap>
									 <strong>Apellido Materno:</strong>
									 <input type="text" name="Apellido2" value="<cfif isDefined('form.Apellido2')>#form.Apellido2#<cfelse></cfif>">	
								 </td> 
							</tr>
							<tr align="left">
								<td width="10%" nowrap>
									<strong>Sexo:&nbsp;</strong>
									<select name="sexo">
										<option value="">-- Todos --</option>
										<option value="1">Hombre</option>
										<option value="2">Mujer</option>
									</select>
								</td>
							</tr>
							<tr align="left">
								<td>
									<strong>Fecha nacimiento:&nbsp;</strong>
									<cf_sifcalendario form="form1" value="" name="nacimiento" tabindex="1">
								</td>
							</tr>
						</table>
					</td>
					<td >
						<table  width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td>&nbsp;</td></tr>
							<tr align="left">
								<td>
									<!---<strong>#LB_SNegocio#:&nbsp;</strong>--->
									<cfset tipoSN = "D">
									<strong>CURP:</strong>
									<input type="text"  name="curp" value="<cfif isDefined('form.curp')>#trim(form.curp).toUppercase()#<cfelse></cfif>">										
								</td>
							</tr>			
							<tr align="left">
								 <td width="10%" nowrap>
									 <strong>Direcci&oacute;n:</strong>
									 <input type="text" name="direccion" value="<cfif isDefined('form.direccion')>#form.direccion#<cfelse></cfif>" size="50">	
								 </td> 
							</tr>
							<tr align="left">
								 <td width="10%" nowrap>
									 <strong>Codigo Postal:</strong>
									 <input type="text" name="cp" value="<cfif isDefined('form.cp')>#form.cp#<cfelse></cfif>">	
								 </td> 
							</tr>
							<tr align="left">
								<td width="10%" nowrap>
									<strong>Tel&eacute;fono:</strong>
									<input type="text" name="telefono" value="<cfif isDefined('form.telefono')>#form.telefono#<cfelse></cfif>">	
								</td>
							</tr>
							<tr align="left">
								<td width="10%" nowrap>
									<strong>Correo electr&oacute;nico:</strong>
									<input type="text" name="email" value="<cfif isDefined('form.email')>#form.email#<cfelse></cfif>">	
								</td>
							</tr>
						</table>
					</td>
					<td >
						<table  width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr><td>&nbsp;</td></tr>
							<tr align="left">
								<td>
									<!---<strong>#LB_SNegocio#:&nbsp;</strong>--->
									<strong>Estado:</strong>
									<input type="text" name="estado" value="">										
								</td>
							</tr>			
							<tr align="left">
								 <td>
									 <strong>Ciudad:</strong>
									 <input type="text" name="ciudad" value="">	
								 </td> 
							</tr>
							<tr align="left">
								 <td>
									 <strong>Colonia:</strong>
									 <input type="text" name="colonia" value="">	
								 </td> 
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
				<tr align="center">
					<td colspan="3">
						<input type="submit" class="btnGuardar" name="Generar" id="Generar" value="Generar"> 
						<input type="button" class="btnGuardar"  name="Boletin" id="Boletin" value="Consultar Boletin" onclick="enviarFormulario()">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

<cfif isdefined('form.curp') and len(trim(form.curp)) gt 0>
	<cfset q_Boletin = crcBoletin.getBoletin(form.curp)>
	<cfif ArrayLen(q_Boletin) gt 0>
		<div style="text-align:center;">
			<hr class="divider">
			<p>Resultados del Boletin para CURP: <strong>#trim(form.curp).toUppercase()#</strong></p>
		</div>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th>CURP</th>
					<th>Nombre Completo</th>
					<th>Distribuidor</th>
					<th>Boletinado</th>
					<th>Estado</th>
					<th>Detalle</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#q_Boletin#" index="boletin">
					<tr>
						<td>#boletin.CURP#</td>
						<td>#boletin.Nombre# #boletin.ApellidoPaterno# #boletin.ApellidoMaterno#</td>
						<td>#boletin.Distribuidor#</td>
						<td>
							<cfif boletin.Boletinado eq 1>
								<span class="label label-danger text-white">Si</span>
							<cfelse>
								<span class="label label-success">No</span>
							</cfif>
						</td>
						<td>
							<cfif boletin.Estado eq 'PENDIENTE'>
								<span class="label label-warning text-white">
									<cfif boletin.BoletinadoSolicitado eq 1>Boletinado <cfelse>Desboletinado </cfif>Pendiente</span>
							<cfelse>
								-
							</cfif>
						</td>
                        <td>
                            <button type="button" class="btn btn-info btn-sm" onclick="verDetalleBoletin('#boletin.id#')" title="Ver Detalle">
                                <i class="fa fa-eye"></i> Ver Detalle
                            </button>
                        </td>
                        <td>
                            <!-- Botón Cancelar Boletín -->
                            <cfif boletin.Estado eq 'PENDIENTE'>
                                <button type="button" class="btn btn-warning btn-sm" onclick="cancelarBoletin('#boletin.id#')">
                                    <i class="fa fa-ban"></i> Cancelar Boletín
                                </button>
                            <cfelseif boletin.Boletinado eq 1>
                                <!-- Botón Desboletinar -->
                                <button type="button" class="btn btn-success btn-sm" onclick="desboletinar('#boletin.id#')">
                                    <i class="fa fa-undo"></i> Desboletinar
                                </button>
                            <cfelse>
                                <!-- Botón Boletinar -->
                                <button type="button" class="btn btn-danger btn-sm" onclick="abrirModalBoletinar('#boletin.CURP#', '#boletin.Nombre#', '#boletin.ApellidoPaterno#', '#boletin.ApellidoMaterno#', '#boletin.id#')">
                                    <i class="fa fa-exclamation-triangle"></i> Boletinar
                                </button>
                            </cfif>							<script type="text/javascript">
							function cancelarBoletin(id) {
								if(confirm('¿Está seguro de cancelar el boletín de este usuario?')) {
									$.ajax({
										url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=cancelarBoletin",
										type: "POST",
										data: { id: id },
										success: function(response) {
											if(response == "OK") {
												alert("Boletín cancelado exitosamente");
												location.reload();
											} else {
												alert("Error al cancelar el boletín");
											}
										},
										error: function(xhr, status, error) {
											alert("Error al cancelar el boletín: " + error);
										}
									});
								}
							}

							function desboletinar(id) {
								$('##modalDesboletinar').modal('show');
								$('##idBoletinDesboletinar').val(id);
							}

							function enviarDesboletinacion() {
								var id = $('##idBoletinDesboletinar').val();
								var observaciones = $('##observacionesDesboletinar').val();

								if (observaciones.trim() === '') {
									alert('Por favor ingrese las observaciones para desboletinar al usuario.');
									return;
								}

								$.ajax({
									url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=desboletinar",
									type: "POST",
									data: { 
										id: id,
										observaciones: observaciones,
										usuarioRegistro: #session.Usucodigo#
									},
									success: function(response) {
										if(response == "OK") {
											alert("Usuario solicitud enviada exitosamente");
											$('##modalDesboletinar').modal('hide');
											location.reload();
										} else {
											alert("Error al desboletinar");
										}
									},
									error: function(xhr, status, error) {
										alert("Error al desboletinar: " + error);
									}
								});
							}
							</script>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<div style="text-align:center;">
			<hr class="divider">
			<h3>No se encontraron resultados</h3>
			<!-- Botón para boletinar usuario -->
			<button type="button" class="btnAgregar" onclick="abrirModalBoletinar('#form.curp#', '#form.Nombre#', '#form.Apellido1#', '#form.Apellido2#', '')">Boletinar Usuario</button>
		</div>
	</cfif>
</cfif>

<cf_web_portlet_end>			

<cf_templatefooter>

<script type="text/javascript">
// Función para enviar el formulario principal
function enviarFormulario() {
    // Obtener el formulario
    var form = document.getElementById('form1');
    
    // Cambiar la acción para enviar a la misma página
    form.action = 'reporteClientes.cfm';
    
    // Enviar el formulario
    form.submit();
}

// Función para abrir el modal de boletinar
function abrirModalBoletinar(curp, nombre, apellidoPaterno, apellidoMaterno, id) {
    // Llenar los campos del formulario con los datos del registro
    document.querySelector('##formBoletinar [name="clienteCurp"]').value = curp;
    document.querySelector('##formBoletinar [name="NombreCliente"]').value = nombre;
    document.querySelector('##formBoletinar [name="ApellidoPaterno"]').value = apellidoPaterno;
    document.querySelector('##formBoletinar [name="ApellidoMaterno"]').value = apellidoMaterno;
    document.querySelector('##formBoletinar [name="id"]').value = id || '';

    // Mostrar el modal
    $('##modalBoletinar').modal('show');
}

// Función para enviar el boletín
function enviarBoletin() {
    var form = document.getElementById('formBoletinar');
    var motivo = document.getElementById('motivoBoletin').value;
    var monto = document.getElementById('montoBoletin').value;
    var distribuidor = document.getElementById('distribuidorBoletin').value;
    var observaciones = document.getElementById('observacionesBoletin').value;
    
    // Validar campos requeridos
    if (motivo === '') {
        alert('Por favor seleccione un motivo para el boletín.');
        return;
    }
    
    if (observaciones.trim() === '') {
        alert('Por favor ingrese observaciones para el boletín.');
        return;
    }

    if (monto === '') {
        alert('Por favor ingrese un monto.');
        return;
    }
    
    // Confirmar antes de enviar
    if (confirm('¿Está seguro de que desea boletinar a este usuario?')) {
        // Preparar los datos para enviar
        var formData = {
            id: document.querySelector('[name="id"]').value,
            CURP: document.querySelector('[name="clienteCurp"]').value,
            Nombre: document.querySelector('[name="NombreCliente"]').value,
            ApellidoPaterno: document.querySelector('[name="ApellidoPaterno"]').value,
            ApellidoMaterno: document.querySelector('[name="ApellidoMaterno"]').value,
            Motivo: motivo,
            Monto: parseFloat(monto),
            Distribuidor: distribuidor,
            Observaciones: observaciones,
            UsuarioRegistro: #session.Usucodigo#,
			Estado: 'PENDIENTE',
			BoletinadoSolicitado: 1
        };

        // Enviar mediante AJAX
        $.ajax({
            url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=insertBoletin",
            type: "POST",
            data: formData,
            success: function(response) {
				if(response == "OK") {
					alert("Usuario boletinado exitosamente");
					$('##modalBoletinar').modal('hide');
					// Recargar la página para mostrar los cambios
					location.reload();
				} else {
					alert("Error al boletinar usuario");}
            },
            error: function(xhr, status, error) {
                alert("Error al boletinar usuario: " + error);
            }
        });
    }
}

// Función para cerrar el modal y limpiar el formulario
function limpiarModalBoletinar() {
    document.getElementById('formBoletinar').reset();
}

// Event listener para limpiar el modal cuando se cierre
$(document).ready(function() {
    $('##modalBoletinar').on('hidden.bs.modal', function () {
        limpiarModalBoletinar();
    });
});

// Función para ver detalle del boletín
async function verDetalleBoletin(id) {
    console.log("Iniciando carga de detalle para ID:", id);
    
    // Mostrar el modal inmediatamente con indicadores de carga
    $('##modalDetalleBoletin').modal('show');
    $('##historialBody').html('<tr><td colspan="6" class="text-center"><i class="fa fa-spinner fa-spin"></i> Cargando datos...</td></tr>');
    
    // Limpiar los campos del detalle e indicar carga
    const campos = ['detalleCurp', 'detalleNombre', 'detalleDistribuidor', 'detalleEstado', 'detalleMonto', 'detalleMotivo', 'detalleObservaciones'];
    campos.forEach(campo => {
        $('##' + campo).html('<i class="fa fa-spinner fa-spin"></i>');
    });

    try {
        // Obtener datos del boletín
        const boletinData = await new Promise((resolve, reject) => {
            $.ajax({
                url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=getBoletinById",
                type: "GET",
                data: { id: id },
                success: response => resolve(JSON.parse(response)),
                error: (xhr, status, error) => reject(error)
            });
        });

        console.log("Datos del boletín recibidos:", boletinData);
        
        if (boletinData && Object.keys(boletinData).length > 0) {
            // Actualizar información del cliente
            $('##detalleCurp').text(boletinData.CURP || '-');
            $('##detalleNombre').text([boletinData.Nombre, boletinData.ApellidoPaterno, boletinData.ApellidoMaterno].filter(Boolean).join(' ') || '-');
            $('##detalleDistribuidor').text(boletinData.Distribuidor || '-');
            $('##detalleMonto').text(boletinData.Monto ? '$ ' + parseFloat(boletinData.Monto).toLocaleString('es-MX') : '-');
            
            // Actualizar estado
            let estadoLabel = 'aaa';
            if (boletinData.Estado === 'PENDIENTE') {
                estadoLabel = '<span class="label label-warning">Pendiente</span>';
            } else if (boletinData.Boletinado == 1) {
                estadoLabel = '<span class="label label-danger">Boletinado</span>';
            } else {
                estadoLabel = '<span class="label label-success">No Boletinado</span>';
            }
            $('##detalleEstado').html(estadoLabel);

            // Actualizar el resto de la información
            $('##detalleMotivo').text(boletinData.Motivo || '-');
            $('##detalleObservaciones').text(boletinData.Observaciones || '-');
        } else {
            throw new Error('No se encontraron datos del boletín');
        }

        // Obtener historial
        const historialData = await new Promise((resolve, reject) => {
            $.ajax({
                url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=getBoletinHistorico",
                type: "GET",
                data: { id: id },
                success: response => resolve(JSON.parse(response)),
                error: (xhr, status, error) => reject(error)
            });
        });

        console.log("Datos del historial recibidos:", historialData);
        
        const historialBody = $('##historialBody');
        if (historialData && Array.isArray(historialData) && historialData.length > 0) {
            historialBody.empty();
            historialData.forEach(registro => {
                const row = '<tr>' +
                    '<td>' + (registro.FechaRegistro || '-') + '</td>' +
                    '<td>' + (registro.EstadoAnterior || '-') + '</td>' +
                    '<td>' + (registro.EstadoNuevo || '-') + '</td>' +
                    '<td>' + (registro.Motivo || '-') + '</td>' +
                    '<td>' + (registro.Distribuidor || '-') + '</td>' +
                    '<td>' + (registro.Observaciones || '-') + '</td>' +
                    '<td>' + (registro.UsuarioRegistro || '-') + '</td>' +
                    '</tr>';
                historialBody.append(row);
            });
        } else {
            historialBody.html('<tr><td colspan="7" class="text-center"><i class="fa fa-info-circle"></i> No hay registros en el historial</td></tr>');
        }

    } catch (error) {
        console.error('Error en la carga de datos:', error);
        $('##historialBody').html('<tr><td colspan="7" class="text-center text-danger"><i class="fa fa-exclamation-triangle"></i> Error al cargar los datos</td></tr>');
        campos.forEach(campo => {
            $('##' + campo).text('-');
        });
        alert('Error al cargar los datos: ' + error.message);
    }

    // Obtener historial
    $.ajax({
        url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=getBoletinHistorico",
        type: "GET",
        data: { id: id },
        success: function(response) {
            try {
                // La respuesta ahora es un array de objetos
                var historial = JSON.parse(response);
                var historialBody = $('##historialBody');
                                
                if (historial && Array.isArray(historial)) {
                    if (historial.length > 0) {
                        // Tomamos el primer registro para mostrar la información actual
                        var registro = historial[0];
                        
                        // Limpiar y llenar la tabla de historial
                        historialBody.empty();
                
                        // Iterar sobre todo el historial
                        historial.forEach(function(registro) {
                            var row = '<tr>' +
                                '<td>' + registro.FechaRegistro + '</td>' +
                                '<td>' + (registro.EstadoAnterior || '-') + '</td>' +
                                '<td>' + registro.EstadoNuevo + '</td>' +
                                '<td>' + (registro.Motivo || '-') + '</td>' +
                                '<td>' + (registro.Distribuidor || '-') + '</td>' +
                                '<td>' + (registro.Observaciones || '-') + '</td>' +
                                '<td>' + (registro.UsuarioRegistro || '-') + '</td>' +
                                '</tr>';
                            historialBody.append(row);
                        });
                    } else {
                        historialBody.html('<tr><td colspan="6" class="text-center"><i class="fa fa-info-circle"></i> No hay registros en el historial de este boletín</td></tr>');
                    }
                } else {
                    // Si la respuesta no es un array válido
                    historialBody.html('<tr><td colspan="6" class="text-center"><i class="fa fa-exclamation-triangle"></i> Error: Formato de respuesta inválido</td></tr>');
                    console.error('La respuesta no es un array válido:', response);
                }
                
                // Mostrar el modal
                $('##modalDetalleBoletin').modal('show');
            } catch (error) {
                console.error('Error procesando la respuesta:', error);
                alert('Error al procesar los datos del boletín');
            }
        },
        error: function(xhr, status, error) {
            alert('Error al cargar los detalles del boletín: ' + error);
        }
    });
}
</script>

<cfif isdefined('form.curp') and len(trim(form.curp)) gt 0>
	<!--- Modal para Boletinar Usuario --->
	<div id="modalBoletinar" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalBoletinarLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h5 class="modal-title" id="modalBoletinarLabel">Boletinar Usuario</h5>
				</div>
				<div class="modal-body" style="padding: 20px;">
					<form id="formBoletinar" name="formBoletinar" method="post" action="boletinarUsuario.cfm">					
						<!-- Información del Cliente (Solo lectura) -->
						<div class="panel panel-default" >
							<div class="panel-heading" style="background-color: ##f5f5f5;">
								<h5 class="panel-title" style="margin: 0; color: ##333;">
									<i class="fa fa-user" style="margin-right: 8px;"></i>Información del Cliente
								</h5>
							</div>
							<div class="panel-body">
								<div class="row">
									<!-- Columna izquierda - Información personal básica -->
									<div class="col-sm-6" style="padding: 0 10px;">
										<input type="hidden" name="id">
										<!-- CURP -->
										<div class="form-group">
											<label class="control-label"><strong>CURP:</strong></label>
											<input type="text" name="clienteCurp" style="text-transform: uppercase;" class="form-control upper">
										</div>
									</div>
									<!-- Nombre -->
									<div class="col-sm-6 pa">
										<div class="form-group">
											<label class="control-label"><strong>Nombre:</strong></label>
											<input type="text" name="NombreCliente" class="form-control">
										</div>
									</div>
								</div>
								<div class="row">
									<!-- Columna izquierda - Información personal básica -->
									<div class="col-sm-6" style="padding: 0 10px;">
										<!-- Apellido Paterno -->
										<div class="form-group">
											<label class="control-label"><strong>Apellido Paterno:</strong></label>
											<input type="text" name="ApellidoPaterno" class="form-control upper">
										</div>
									</div>
									<!-- Apellido Materno -->
									<div class="col-sm-6 pa">
										<div class="form-group">
											<label class="control-label"><strong>Apellido Materno:</strong></label>
											<input type="text" name="ApellidoMaterno" class="form-control">
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<!-- Campos editables para el boletín -->
						<div class="panel panel-primary">
							<div class="panel-heading">
								<h5 class="panel-title" style="margin: 0;">
									<i class="fa fa-exclamation-triangle" style="margin-right: 8px;"></i>Datos del Boletín
								</h5>
							</div>
							<div class="panel-body" style="padding: 20px;">
								<div class="row">
									<div class="col-sm-6" style="padding: 0 10px;">
										<div class="form-group">
											<label for="motivoBoletin" class="control-label">
												<i class="fa fa-list-alt" style="margin-right: 5px; color: ##337ab7;"></i>Motivo del Boletín:
											</label>
											<select name="motivo" id="motivoBoletin" class="form-control" required>
												<option value="">-- Seleccione un motivo --</option>
												<option value="Falta de pago">💰 Falta de pago</option>
												<option value="Mora Reincidente">📄 Mora Reincidente</option>
												<option value="Información falsa">⚠️ Información falsa</option>
												<option value="Mora con 2 o más DV">💰 Mora con 2 o más DV</option>
												<option value="Negativa de Pago">💰 Negativa de Pago</option>
											</select>
										</div>
									</div>
									<div class="col-sm-6" style="padding: 0 10px;">
										<div class="form-group">
											<label for="montoBoletin" class="control-label">
												<i class="fa fa-dollar" style="margin-right: 5px; color: ##337ab7;"></i>Monto:
											</label>
											<input type="number" name="monto" id="montoBoletin" class="form-control" min="0" step="0.01" 
												placeholder="Ingrese el monto relacionado (si aplica)"
											>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6" style="padding: 0 10px;">
										<div class="form-group">
											<label for="distribuidorBoletin" class="control-label">
												<i class="fa fa-building" style="margin-right: 5px; color: ##337ab7;"></i>Distribuidor:
											</label>
											<input type="text" name="distribuidor" id="distribuidorBoletin" class="form-control" 
												placeholder="Ingrese el distribuidor (opcional)"
											>
										</div>
									</div>
									<div class="col-sm-6" style="padding: 0 10px;">
										&nbsp;
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12 px-4">
										<div class="form-group">
											<label for="observacionesBoletin" class="control-label">
												<i class="fa fa-comment" style="margin-right: 5px; color: ##337ab7;"></i>Observaciones:
											</label>
											<textarea name="observaciones" id="observacionesBoletin" class="form-control" rows="4" 
												placeholder="Ingrese observaciones detalladas sobre el motivo del boletín..." 
												required style="resize: vertical;"></textarea>
											<span class="help-block">
												<i class="fa fa-info-circle"></i> Proporcione detalles específicos que justifiquen la acción.
											</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer" style="padding: 15px 20px; border-top: 1px solid ##e5e5e5; background-color: ##f5f5f5;">
					<button type="button" class="btn btn-default" data-dismiss="modal" style="margin-right: 10px;">
						<i class="fa fa-times" style="margin-right: 5px;"></i>Cancelar
					</button>
					<button type="button" class="btn btn-danger" onclick="enviarBoletin()">
						<i class="fa fa-exclamation-triangle" style="margin-right: 5px;"></i>Boletinar Cliente
					</button>
				</div>
			</div>
		</div>
	</div>

	<cfif ArrayLen(q_Boletin) gt 0>
		<!--- Modal para Ver Detalle del Boletín --->
		<div id="modalDetalleBoletin" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDetalleBoletinLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h5 class="modal-title" id="modalDetalleBoletinLabel">Detalle del Boletín</h5>
					</div>
					<div class="modal-body" style="padding: 20px;">
						<!-- Información del Cliente -->
						<div class="panel panel-info">
							<div class="panel-heading">
								<h3 class="panel-title"><i class="fa fa-user"></i> Información del Cliente</h3>
							</div>
							<div class="panel-body">
								<div class="row">
									<div class="col-md-6">
										<p><strong>CURP:</strong> <span id="detalleCurp"></span></p>
										<p><strong>Nombre:</strong> <span id="detalleNombre"></span></p>
										<p><strong>Distribuidor:</strong> <span id="detalleDistribuidor"></span></p>
									</div>
									<div class="col-md-6">
										<p><strong>Estado:</strong> <span id="detalleEstado"></span></p>
										<p><strong>Monto:</strong> <span id="detalleMonto"></span></p>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<p><strong>Motivo:</strong> <span id="detalleMotivo"></span></p>
										<p><strong>Observaciones:</strong> <span id="detalleObservaciones"></span></p>
									</div>
								</div>
							</div>
						</div>

						<!-- Historial de Cambios -->
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title"><i class="fa fa-history"></i> Historial de Cambios</h3>
							</div>
							<div class="panel-body">
								<div class="table-responsive">
									<table class="table table-striped table-hover" id="tablaHistorial">
										<thead>
											<tr>
												<th>Fecha</th>
												<th>Estado Anterior</th>
												<th>Estado Actual</th>
												<th>Motivo</th>
												<th>Distribuidor</th>
												<th>Observaciones</th>
												<th>Usuario</th>
											</tr>
										</thead>
										<tbody id="historialBody">
											<tr>
												<td colspan="7" class="text-center">Cargando datos...</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							<i class="fa fa-times"></i> Cerrar
						</button>
					</div>
				</div>
			</div>
		</div>

		<!--- Modal para Desboletinar Usuario --->
		<div id="modalDesboletinar" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDesboletinarLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h5 class="modal-title" id="modalDesboletinarLabel">Desboletinar Usuario</h5>
					</div>
					<div class="modal-body" style="padding: 20px;">
						<form id="formDesboletinar">
							<input type="hidden" id="idBoletinDesboletinar">
							<div class="form-group">
								<label for="observacionesDesboletinar" class="control-label">
									<i class="fa fa-comment" style="margin-right: 5px;"></i>Observaciones:
								</label>
								<textarea id="observacionesDesboletinar" class="form-control" rows="4" 
									placeholder="Ingrese el motivo por el cual se desboletina al usuario..." 
									required style="resize: vertical;"></textarea>
								<span class="help-block">
									<i class="fa fa-info-circle"></i> Proporcione los motivos por los cuales se está desboletinando al usuario.
								</span>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							<i class="fa fa-times"></i> Cancelar
						</button>
						<button type="button" class="btn btn-success" onclick="enviarDesboletinacion()">
							<i class="fa fa-check"></i> Solicitar Desboletinación
						</button>
					</div>
				</div>
			</div>
		</div>
	</cfif>
</cfif>
 </cfoutput>


