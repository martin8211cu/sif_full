<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloHeader" default = "Facturaci&oacute;n" returnvariable="LB_TituloHeader" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default = "Men&uacute; Principal de Facturaci&oacute;n" returnvariable="LB_Titulo" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RegistroTransacciones" default = "Registro de Transacciones" returnvariable="LB_RegistroTransacciones" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CierreCajaUsuario" default = "Cierre de Caja por Usuario" returnvariable="LB_CierreCajaUsuario" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionFacturas" default = "Impresi&oacute;n de Facturas" returnvariable="LB_ImpresionFacturas" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReimpresionFacturas" default = "Reimpresi&oacute;n de Facturas" returnvariable="LB_ReimpresionFacturas" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PuntoVenta" default = "Punto de Venta" returnvariable="LB_PuntoVenta" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RevisionCredito" default = "Revisi&oacute;n de Cr&eacute;dito" returnvariable="LB_RevisionCredito" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RecibirPago" default = "Recibir Pago" returnvariable="LB_RecibirPago" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RecibirPreFacturas" default = "Registro de Pre-Facturas" returnvariable="LB_RecibirPreFacturas" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ImpresionDocumentos" default = "Impresi&oacute;n de Documentos" returnvariable="LB_ImpresionDocumentos" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CancelacionDocumentos" default = "Cancelaci&oacute;n de Documentos" returnvariable="LB_CancelacionDocumentos" xmlfile="MenuFA.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FacturasImpresas" default = "Facturas Impresas" returnvariable="LB_FacturasImpresas" xmlfile="MenuFA.xml"/>


<cfquery name="rsCierre" datasource="#session.DSN#">
    select Pvalor
     from Parametros 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and Pcodigo = 500
</cfquery>
<cfquery name="rsSupervisor" datasource="#session.DSN#">
    select Pvalor 
     from Parametros 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and Pcodigo = 430
</cfquery>
<style type="text/css">
	.DesOp {
		text-align: justify;
		font-size:11px;}
</style>

<cf_templateheader title="#LB_TituloHeader#">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="#LB_Titulo#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<!---►Registro de Transaccion◄◄--->
            <tr>
				<td align="left" valign="middle" >
                	<!---<a href="operacion/listaTransaccionesFA.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a>--->
                </td>
                <td>
                	<!---<a href="operacion/listaTransaccionesFA.cfm">
                    	<cfoutput>#LB_RegistroTransacciones#</cfoutput>
                    </a>--->
                </td>
               
                <td width="338" rowspan="22" valign="top">
              <!---►►Catalogos◄◄--->  	
                    <cfinclude template="MenuCatalogosFA2.cfm">
              <!---►►Consultas◄◄--->
                	<!---<cfinclude template="MenuConsultasFA2.cfm">--->
               <!---►Reporte◄◄--->
                	<!---<cfinclude template="MenuRepteFA.cfm">--->
		<!---�Importador��◄--->
                	<!---<cfinclude template="MenuImportFA.cfm">--->
                </td>
                             
			</tr>
			<tr>
            	<td></td>
				<!---<td width="861">
					<blockquote class="DesOp">
                    	<cf_translate key = MSG_RegistroTransacciones>El proceso de registro de Transacciones, comprende en primera instancia, la apertura de la caja del usuario asignado. Un usuario puede tener a su disposici&oacute;n varias cajas, pero solo puede abrir una caja a la vez. El portal presenta un mensaje en caso de que una caja ya est&eacute; siendo trabajada por otro usuario. El usuario debe seleccionar la caja con la cual va a trabajar la facturaci&oacute;n.</cf_translate> 
                    </blockquote>
				</td>--->
			</tr>
        <!---►►Cieere de Caja por Usuario◄◄--->
		<!---<cfif rsCierre.RecordCount gt 0 and rsCierre.Pvalor eq 'S' >
			<tr>
				<td>
                	<a href="operacion/CierreCaja.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16"  border="0"></a>
                </td>
				<td align="left" valign="middle">
                	<a href="operacion/CierreCaja.cfm">#LB_CierreCajaUsuario#</a>
                </td>
			</tr>
			<tr>
            	<td></td>
				<td>
                    <blockquote class="DesOp">
                    <cf_translate key ="MSG_CierreCajaUsuario">
                    Permite que cada usuario ingrese los montos por moneda
                    registrados durante el d&iacute;a. Debe relacionar los siguientes
                    datos: Monto Inicial, tipo de cambio . En los Documentos de contado
                    debe ingresar: en Facturas de contado la suma de los
                    ingresos al contado recibidos y al frente desglosarlo en: Efectivo,
                    Cheques, Vouchers, Dep&oacute;sitos . El portal genera autom&aacute;ticamente un total
                    y muestra la diferencia con respecto al total ingresado
                    en las facturas de contado. En los Documentos de cr&eacute;dito 
                    debe ingresar en Facturas de cr&eacute;dito  la suma de cr&eacute;ditos recibidos
                    y al frente el valor de notas cr&eacute;dito  recibidas. En la parte
                    inferior el portal presenta el movimiento contable con el detalle
                    de facturas de contado y cr&eacute;dito  ajustados a los montos en
                    moneda local. </cf_translate>
                    </blockquote>
				</td>--->
			</tr>								
		 <!---►►Cierre de Caja por Supervisor◄◄--->
		 <!---<cfif trim(rsSupervisor.Pvalor) eq session.Usucodigo>
			<tr>
				<td width="16" align="right" valign="middle"><a href="operacion/CalculoCierreSis.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16"  border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/CalculoCierreSis.cfm">#LB_CierreCajaSupervisor#</a></td>
			</tr>
			<tr>
            	<td></td>
				<td>
					<blockquote class="DesOp">
                    <cf_translate key =  MSG_CierreCajaSupervisor>
                   
                    	Esta opci&oacute;n se restringe para uso solamente del Supervisor, el cual es definido desde el m&oacute;dulo de Administraci&oacute;n del Sistema. El supervisor puede revisar mediante este informe, las diferencias existentes contra lo que el usuario ha ingresado. Para consultar la informaci&oacute;n
					por cada caja, debe ser seleccionada por el combo Caja. El reporte generado despliega el n&uacute;mero de caja, la fecha de cierre, la hora de cierre y el usuario responsable de cerrar dicha caja. Presenta al supervisor las transacciones de contado y cr&eacute;dito y el resumen en moneda local. </cf_translate>
                    </blockquote>
				</td>
			</tr>
		 </cfif>
		</cfif>--->
			<!---►►Impresión de Facturas◄◄--->	
            <tr>
				<td width="16" align="right" valign="middle">
                <!---<a href="operacion/ImpresionFacturasFA.cfm?tipo=I"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a>---></td>
				<td align="left" valign="middle">
				<!---<a href="operacion/ImpresionFacturasFA.cfm?tipo=I"><cfoutput>#LB_ImpresionFacturas#</cfoutput></a>---></td>
			</tr>
			<tr>
				<td></td>
            	<!---<td>
					<blockquote class="DesOp">
						<cf_translate key = MSG_ImpresionFacturas>Permite imprimir las facturas contabilizadas/aplicadas y llevar un control de cu&aacute;les ya fueron impresas. El portal genera la impresi&oacute;n de las facturas en formato PDF, obteniendo una vista previa para el usuario.</cf_translate>
					</blockquote>
				</td>--->
			</tr>
			<tr>
            	<td width="16" align="right" valign="middle">
                	<!---<a href="operacion/ImpresionFacturasFA.cfm?tipo=R"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a>--->
                </td>
            	<td align="left" valign="middle">
                	<!---<a href="operacion/ImpresionFacturasFA.cfm?tipo=R"><cfoutput>#LB_ReimpresionFacturas#</cfoutput></a>--->
                </td>
            </tr>
			<tr>
            	<td></td>
                <!---<td>
					<blockquote class="DesOp">
                    	<cf_translate key = MSG_ReimpresionFacturas>
                    	Permite reimprimir las facturas ya generadas. El portal genera la impresi&oacute;n de las facturas en formato PDF, obteniendo una vista previa para el usuario.</cf_translate>
                    </blockquote>
				</td>--->
			</tr>
			<tr>
            	<td width="16" align="right" valign="middle">
                	<!---<a href="consultas/cons_art/index.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a>--->
                </td>
            	<td align="left" valign="middle">
                	<!---<a href="consultas/cons_art/index.cfm"><cfoutput>#LB_PuntoVenta#</cfoutput></a>--->
                </td>
           	</tr>
			<tr>
            	<td></td>
                <!---<td>
					<blockquote class="DesOp">
                    	<cf_translate key = "MSG_PuntoVenta">
                     	Muestra una consulta interactiva de los art&iacute;culos por categor&iacute;a, y permite realizar comparaciones de las caracter&iacute;sticas de los art&iacute;culos de una misma categor&iacute;a. Una vez que se seleccionen los art&iacute;culos desados, se puede generar una factura.</cf_translate>
                    </blockquote>
				</td>--->
			</tr>
			<!---<tr>
				<td width="16" align="right" valign="middle"><a href="operacion/revisionCredito-lista.cfm?O=M"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/revisionCredito-lista.cfm?O=M"><cfoutput>#LB_RevisionCredito#</cfoutput></a></td>
			</tr>
			<tr>
				<td></td>
            	<td>
					<blockquote class="DesOp">
                    	<cf_translate key = MSG_RevisionCredito>
						Este proceso permite verificar el disponible del cliente en base al estudio de cr&eacute;dito realizado, con el fin de aumentar el cr&eacute;dito para que el cliente pueda llevar la prenda que desea comprar, o donde se rechazar porque no tiene el suficiente cr&eacute;dito para realizar la compra.</cf_translate>
					</blockquote>
				</td>
			</tr>
			<tr>
            	<td width="16" align="right" valign="middle"><a href="operacion/RecibePagosLista.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
                <td align="left" valign="middle"><a href="operacion/RecibePagosLista.cfm"><cfoutput>#LB_RecibirPago#</cfoutput></a></td>
			</tr>
			<tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	<cf_translate key = MSG_RecibirPago>
                    	Muestra una consulta de los pagos pendientes de los clientes, con los siguientes filtros: C&eacute;dula del cliente, nombre, monto pendiente y prima recibida, una vez seleccionado el pago, se detalla los datos del pago y se recibe el monto total o parcial del pago.
                        </cf_translate>
                    </blockquote>
                </td>
			</tr>--->
            <tr>
				<td width="16" align="right" valign="middle"><a href="operacion/FAprefactura.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/FAprefactura.cfm"><cfoutput>#LB_RecibirPreFacturas#</cfoutput></a></td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	<cf_translate key = "MSG_RecibirPreFacturas">
                    	El proceso de Registro de Pre-Facturas, permite capturar las transacciones de venta para las cuales aun no se tiene
                        un documento de cuentas por cobrar definitivo, para su posterior aplicación, permitiendo agrupar más de una pre-factura
                        conformando un único documento de cuentas por cobrar. Así mismo, se permite aplicar las pre-facturas como estimaciones 
                        dentro del modulo de Cuentas por Cobrar.</cf_translate>
                    </blockquote>
               	</td>
              <!---    <td width="338" rowspan="22" valign="top">
              <!---►►Catalogos◄◄--->  	
                  <cfinclude template="MenuCatalogosFA2.cfm">
              <!---►Reporte◄◄--->
                	<cfinclude template="MenuRepteFA.cfm">
                </td> --->
			</tr>
            <!---<tr>
				<td width="16" align="right" valign="middle"><a href="operacion/ProcImprimeDocumento.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/ProcImprimeDocumento.cfm"><cfoutput>#LB_ImpresionDocumentos#</cfoutput></a></td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	<cf_translate key = MSG_ImpresionDocumento>
                    	Permite la impresión de los documentos generados por la aplicación de las pre-facturas, una vez impreso el documento
                        se permite el registro del resultado de la impresión, en caso de una impresión exitosa se crea el documento 
                        correspondiente en el modulo de Cuentas por Cobrar. Se permite la impresión del número de copias deseado, así como la 
                        reimpresión en caso de fallos al imprimir. </cf_translate>
                    </blockquote>
                </td>
			</tr>--->
            <tr>
				<td width="16" align="right" valign="middle"><a href="operacion/ProcImprimeDocumentoMFE.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/ProcImprimeDocumentoMFE.cfm">Generar Factura Electrónica</a></td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	Permite la generación de las facturas electronicas correspondientes a la aplicación de las pre-facturas, 
                        una vez generada la factura electronica, se permite el registro del resultado creando el documento 
                        correspondiente en el modulo de Cuentas por Cobrar.
                    </blockquote>
                </td>
			</tr>
           <!--- <tr>
				<td width="16" align="right" valign="middle"><a href="operacion/ProcCancelaDocumento.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/ProcCancelaDocumento.cfm"><cfoutput>#LB_CancelacionDocumentos#</cfoutput></a></td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	<cf_translate key = MSG_CancelacionDocumentos>
                    	Este proceso permite la cancelación de documentos que hayan sido previamente generados por la aplicación e impresión
                        de pre-facturas desde este modulo. Una vez cancelado el documento, todas las pre-facturas que hayan participado en su
                        generación, son reactivadas y pueden ser vueltas a aplicar desde la opción Registro de Pre-Facturas.</cf_translate>
                    </blockquote>
                </td>
			</tr>
            <tr>
				<td width="16" align="right" valign="middle"><a href="operacion/ProcFacturasImpresas.cfm"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="operacion/ProcFacturasImpresas.cfm"><cfoutput>#LB_FacturasImpresas#</cfoutput></a></td>
			</tr>
            <tr>
            	<td></td>
                <td>
                	<blockquote class="DesOp">
                    	<cf_translate key = MSG_FacturasImpresas>
                    	Este proceso permite la impresión de documentos que hayan sido previamente generados por la aplicación e impresión
                        de documentos desde este modulo.</cf_translate>
                    </blockquote>
                </td>
			</tr>--->
         </table>		
	<cf_web_portlet_end>
<cf_templatefooter>