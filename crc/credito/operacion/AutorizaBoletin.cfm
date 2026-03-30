<!--- 
Creado por Jose Gutierrez 
	17/04/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Autorizar Boletin')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>


<cfset crcBoletin = createObject("component","crc.Componentes.boletin.CRCBoletin")>

<cfoutput> 
<cfset q_BoletinesPendientes = crcBoletin.getBoletinesPendientes()>

<cfif q_BoletinesPendientes.RecordCount gt 0>
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>CURP</th>
                <th>Nombre Completo</th>
                <th>Distribuidor</th>
                <th>Boletinado</th>
                <th>Estado</th>
                <th>Motivo</th>
                <th>Observaciones</th>
                <th>Solicitado por</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="q_BoletinesPendientes">
                <tr>
                    <td>#CURP#</td>
                    <td>#Nombre# #ApellidoPaterno# #ApellidoMaterno#</td>
                    <td>#Distribuidor#</td>
                    <td>
                        <cfif Boletinado eq 1>
                            <span class="label label-danger text-white">Si</span>
                        <cfelse>
                            <span class="label label-success">No</span>
                        </cfif>
                    </td>
                    <td>
                        <cfif Estado eq 'PENDIENTE'>
                            <span class="label label-warning text-white">
                                <cfif BoletinadoSolicitado eq 1>Boletinado <cfelse>Desboletinado </cfif>Pendiente</span>
                        <cfelse>
                            -
                        </cfif>
                    </td>
                    <td>
                        #Motivo#
                    </td>
                    <td>
                        #Observaciones#
                    </td>
                    <td>
                        #UsuarioSolicita#
                    </td>
                    <td>
                        <!-- Botón Cancelar Boletín -->
                        <button type="button" class="btn btn-success btn-sm" onclick="aprobarBoletin('#id#')">
                            <i class="fa fa-check"></i> Aprobar
                        </button>
                        <button type="button" class="btn btn-danger btn-sm" onclick="rechazarBoletin('#id#')">
                            <i class="fa fa-ban"></i> Rechazar
                        </button>

                        <script type="text/javascript">
                        function rechazarBoletin(id) {
                            if(confirm('¿Está seguro de rechazar el boletín?')) {
                                $.ajax({
                                    url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=rechazarBoletin",
                                    type: "POST",
                                    data: { id: id },
                                    success: function(response) {
                                        if(response == "OK") {
                                            alert("Boletín rechazdo exitosamente");
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
                        
                        function aprobarBoletin(id) {
                            if(confirm('¿Está seguro de aprobar el boletín?')) {
                                $.ajax({
                                    url: "/cfmx/crc/Componentes/boletin/CRCBoletin.cfc?method=aprobarBoletin",
                                    type: "POST",
                                    data: { id: id },
                                    success: function(response) {
                                        if(response == "OK") {
                                            alert("Boletín aprobado exitosamente");
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
                        </script>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
<cfelse>
    <div style="text-align:center;">
        <hr class="divider">
        <p>No hay registros pendientes</p>
    </div>
</cfif>

<cf_web_portlet_end>			

<cf_templatefooter>

</cfoutput>


