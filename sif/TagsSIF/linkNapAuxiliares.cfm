<!----------------------------------------------------------------------->
<!--- recibe el NAP y genera un LINK al módulo auxiliar que lo generó. --->
<!----------------------------------------------------------------------->

<!--- parametro --->
<cfparam name="Attributes.NAP" type="integer">
<cfparam name="Attributes.Texto" type="string">

<!---<cfparam name="Attributes.Texto" type="string">
<cfparam name="Attributes."--->

<!--- Obtenemos datos del NAP --->
<cfquery name="rsNAP" datasource="#session.dsn#">
	select 
		n.IDTablaOrigen,
		n.NombreTablaOrigen,
		n.CPNAPfechaOri,
		n.CPNAPmoduloOri
	from CPNAP n
	where n.CPNAPnum = #Attributes.NAP#
	order by n.IDTablaOrigen desc
</cfquery>

<!--- script para levantar el popup --->
<script type="text/javascript">
	var popUpDocumentoAuxiliar = 0;
	
	//Abre la ruta que recibe como parámetro, como un PopUp
	function abrirDocumentoPopUp(URLStr)
	{
		var left = 160;
		var top = 200;
		var width = 1000;
		var height = 500;

		if(popUpDocumentoAuxiliar)
		{
			if(!popUpDocumentoAuxiliar.closed) popUpDocumentoAuxiliar.close();
		}
		popUpDocumentoAuxiliar = open(URLStr, 'popUpDocumentoAuxiliar', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
</script>

<cfoutput>
	<!--- definimos las variables a utilizar --->
	<cfset ruta = ""/> <!--- si al finalizar el archivo y la ruta aun esta vacia NO mostramos el link --->
	<cfset enPopUp = true> <!--- si no es en popup, lo mostramos en una pestaña nueva --->
	
	<cfif rsNAP.recordCount GT 0 and isDefined("rsNAP.IDTablaOrigen") and Len(rsNAP.IDTablaOrigen) and isDefined("rsNAP.NombreTablaOrigen") and Len(rsNAP.NombreTablaOrigen) > <!--- Solo entramos si encontramos el NAP --->
		<cfswitch expression="#rsNAP.NombreTablaOrigen#">
<!--- 
 * Proceso: CMOC: Orden de compra 
 * Disparador: Se dispara cuando se aplica una orden de compra.
 * Fecha: 04/10/2013
 * Creado por: jceciliano
 * Ultima modificacion: jceciliano
 * Descripción: Aplicación y Cancelación de ordenes de compra
 --->
		 
		<cfcase value="EOrdenCM">
		   <cfset ruta = "/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?Ecodigo=#session.Ecodigo#&EOidorden=#rsNAP.IDTablaOrigen#" >
		</cfcase>

<!--- 
 * Proceso: CMSC: Solicitud de Compra 
 * Disparador: Se dispara cuando se aplica una solicitud de compra.
 * Fecha: 08/10/2013
 * Creado por: mmora
 * Ultima modificacion: mmora
 * Descripción: Aplicación y Cancelación de Solicitudes de Compra
  --->

		<cfcase value="ESolicitudCompraCM">
			<cfquery name="rs" datasource="#session.dsn#">
				Select ESestado
				From ESolicitudCompraCM
				Where ESidsolicitud = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfif rs.ESestado EQ 60>
				<cfset ruta = "/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?DSobservacion1=&DSdescalterna1=&botonSel=btnCancelaciones&btnCancelaciones=Cancelaciones&ESidsolicitud=#rsNAP.IDTablaOrigen#&ESestado=60&linkNAP=1">
			<cfelse>
				<cfset ruta = "/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?ESidsolicitud=#rsNAP.IDTablaOrigen#&ESestado=0">
			</cfif>
		</cfcase> 
	
<!---	
* Proceso: PRCO :  Presupuesto Control 
 * Disparador: Se dispara cuando se aplica un traslado de presupuesto.
 * Fecha: 09/10/2013
 * Creado por: mmora
 * Ultima modificacion: mmora
 * Descripción: Aprobación de Traslados de presupuesto(T)
                Provisión Presupuestaria (RE)
 --->
  
		<cfcase value="CPDocumentoE">
			<cfquery name="rs" datasource="#session.dsn#">
				Select CPDEtipoDocumento as Tipo, CPPid, CPDAEid, CFidOrigen, CFidDestino
				From CPDocumentoE
				Where CPDEid = #rsNAP.IDTablaOrigen#
			</cfquery>
			
			<!--- Liberación Presupuestaria --->
			<cfif rs.Tipo EQ 'L'>
				<cfset tipo = "LB">
				<cfset ruta = "/cfmx/sif/presupuesto/reportes/rptDocsPRES-imprimir.cfm?CPDEid=#rsNAP.IDTablaOrigen#&CPPid=#rs.CPPid#&CPTpoRep=#tipo#&linkNAP=1">
			</cfif>
			
			<!--- Provisión Presupuestaria --->
			<cfif rs.Tipo EQ "R">
				<cfset tipo = "RE">
				<cfset ruta = "/cfmx/sif/presupuesto/reportes/rptDocsPRES-imprimir.cfm?CPDEid=#rsNAP.IDTablaOrigen#&CPPid=#rs.CPPid#&CPTpoRep=#tipo#&linkNAP=1">
			</cfif>
			
			<!--- Traslado --->
			<cfif rs.Tipo EQ "E">
				<cfquery name="rsAE" datasource="#session.dsn#">
					Select CPDAEcodigo
					From CPDocumentoAE 
					Where CPDAEid = #rs.CPDAEid#
				</cfquery>
					
				<!---<cfset tipo = "T1">
				<cfset ruta = "/cfmx/sif/presupuesto/reportes/rptDocsPRES-imprimir.cfm?CPDEid=#rsNAP.IDTablaOrigen#&CPPid=#rs.CPPid#&CPTpoRep=#tipo#&linkNAP=1">--->
				<cfset ruta= "/cfmx/sif/presupuesto/reportes/rptDocsAED-imprimir-SUTEL.cfm?CPDEid=#rsNAP.IDTablaOrigen#CPPid=#rs.CPPid#&CPDAEcodigo=#rsAE.CPDAEcodigo#&CFidOrigen=#rs.CFidOrigen#&CFidDestino=#rs.CFidDestino#&linkNAP=1">


				<!--- Se carga el formato de impresion en caso de que este definido --->
				<cfquery name="rsParametro" datasource="#Session.DSN#">
			        select Pvalor
			        from Parametros
			        where Ecodigo = #session.Ecodigo#
			          and Pcodigo = 15714
				</cfquery>
				<cfif rsParametro.RecordCount and LEN(TRIM(rsParametro.Pvalor))>
				    <cfquery datasource="#session.dsn#" name="fuente">
				        select FMT01cfccfm
				        from FMT001
				        where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(rsParametro.Pvalor)#">
				    </cfquery>
					<cfif fuente.RecordCount and LEN(TRIM(fuente.FMT01cfccfm))>
				    	<cfset ruta ='/cfmx'& fuente.FMT01cfccfm&'?CPDEid=#trim(rsNAP.IDTablaOrigen)#&CPPid=#trim(rs.CPPid)#&CPDAEcodigo=#trim(rsAE.CPDAEcodigo)#&CFidOrigen=#trim(rs.CFidOrigen)#&CFidDestino=#trim(rs.CFidDestino)#&linkNAP=1'>
				    </cfif>
				</cfif>
			</cfif>
			
			<!--- Traslado --->
			<cfif rs.Tipo EQ "T">
				<cfset tipo = "TE">
				<cfset ruta = "/cfmx/sif/presupuesto/reportes/rptDocsPRES-imprimir.cfm?CPDEid=#rsNAP.IDTablaOrigen#&CPPid=#rs.CPPid#&CPTpoRep=#tipo#&linkNAP=1">
			</cfif>
			
			
		</cfcase> 

<!---	
* Proceso: TESP :   Tesorería Solicitudes de Pago
* Disparador: Se dispara cuando se aprueba una solicitud de pago.
* Fecha: 12/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Aprobación de Solicitudes de Pago
 ---> 
		<cfcase value="TESsolicitudPago">
			<cfset ruta = "/cfmx/sif/tesoreria/Solicitudes/imprSolicitPago.cfm?TESSPid=#rsNAP.IDTablaOrigen#&moduloOri=#rsNAP.CPNAPmoduloOri#">
		</cfcase> 


<!---	
* Proceso: TEOP :  Tesorería Emisión Orden de Pago
* Disparador: Se dispara cuando se emite una orden de pago.
* Fecha: 14/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Emision de Orden de Pago
 ---> 
		<cfcase value="TESordenPago">
			<cfset ruta = "/cfmx/sif/tesoreria/Pagos/imprOrdenPago.cfm?TESOPid=#rsNAP.IDTablaOrigen#">
		</cfcase> 		


<!---	
* Proceso: TEAE:  Aprobación de Anticipos de caja chica
* Disparador: Se dispara cuando se aprueba un anticpo de caja chica.
* Fecha: 14/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Aprobación de Anticipos de caja chica
 ---> 
		<cfcase value="GEanticipo">

			<!--- Se busca el formato que se utilizara para el anticipo --->
			
			
			
			<cfquery name="rs" datasource="#Session.DSN#">
			    select Pvalor
			    from Parametros
			    where Ecodigo = #session.Ecodigo#
			      and Pcodigo = 15716
			</cfquery>

			<cfif rs.RecordCount and LEN(TRIM(rs.Pvalor))>
		        <cfquery datasource="#session.dsn#" name="fuente">
		            select FMT01cfccfm
		             from FMT001
		             where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(rs.Pvalor)#">
		        </cfquery>
				<cfif fuente.RecordCount and LEN(TRIM(fuente.FMT01cfccfm))>
		            <cfset LvarFuente = fuente.FMT01cfccfm>
		        </cfif>
			</cfif>

			<cfif NOT isdefined('LvarFuente')>
				<cfset LvarFuente = "/cfmx/sif/tesoreria/GestionEmpleados/ReimpresionAnt_form.cfm">
		  		
		  	</cfif>
			<cfset ruta = LvarFuente&"?id=#rsNAP.IDTablaOrigen#&url=ReimpresionAnt">


		</cfcase> 

<!---	
* Proceso: TEGE:  Liquidacion de Anticipos de caja chica
* Disparador: Se dispara cuando se liquida un anticpo de caja chica.
* Fecha: 14/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Liquidacion de Anticipos de caja chica
 ---> 
		<cfcase value="GEliquidacion">
			<cfset ruta = "/cfmx/sif/tesoreria/GestionEmpleados/LiquidacionImpresion_form_SUTEL.cfm?GELid=#rsNAP.IDTablaOrigen#&url=ReimpresionLiq">
		</cfcase> 

<!---	
* Proceso: CCH:  Reintegro de caja chica
* Disparador: Se dispara cuando se aplica un reintegro a caja chica.
* Fecha: 15/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Reintegro a caja chica
 ---> 
		<cfcase value="STransaccionesProceso">
			<cfset ruta = "/cfmx/sif/tesoreria/GestionEmpleados/RepReintegros.cfm?CCHTid=#rsNAP.IDTablaOrigen#">
		</cfcase> 
		
<!---	
* Proceso: MBMV: Movimiento Bancario
* Disparador: Se dispara cuando se aplica un movimiento bancario.
* Fecha: 18/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Movimiento en Bancos
 ---> 
		<cfcase value="MLibros">
			<cfquery datasource="#session.dsn#" name="rs">
				Select MLperiodo, MLmes, CBid
				From MLibros
				Where MLid = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfset ruta = "/cfmx/sif/mb/consultas/SaldosPeriodoMes.cfm?MLid=#rsNAP.IDTablaOrigen#&MLperiodo=#rs.MLperiodo#&MLmes=#rs.MLmes#&CBid=#rs.CBid#">
		</cfcase> 

<!---	
* Proceso: CPFC - Documentos de Cuentas x Pagar
* Disparador: Aplicar facturas o pagos en Cuentas x Pagar
* Fecha: 20/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Documentos de Cuentas x Pagar
 ---> 
		<cfcase value="HEDocumentosCP">
			<cfquery datasource="#session.dsn#" name="rs">
				Select NAP, CPTcodigo, Ddocumento, SNcodigo
				From HEDocumentosCP
				Where IDdocumento = #rsNAP.IDTablaOrigen#
			</cfquery>
			
			<cfset ruta = "/cfmx/sif/cp/consultas/RFacturasCP2-DetalleDoc.cfm?fSNnumero=&fSNcodigo=&SNcodigo=#rs.SNcodigo#&fechaIni=&fechaFin=&CPTcodigo=&Documento=&Ddocumento=#rs.Ddocumento#&CPNAPnum=#rs.NAP#&Cmayor=&CtaFinal=&botonSel=btnConsultar&btnConsultar=Consultar&tipo=#rs.CPTcodigo#&link=1">
			
			<!---
			<cfset ruta = "/cfmx/sif/cp/consultas/RFacturasCP2-reporte.cfm?fSNnumero=&fSNcodigo=&fechaIni=&fechaFin=&CPTcodigo=&Documento=&CPNAPnum=#rs.NAP#&Cmayor=&CtaFinal=&botonSel=btnConsultar&btnConsultar=Consultar&link=1">
			--->
		</cfcase> 
		
		cfmx/sif/cp/consultas/RFacturasCP2-DetalleDoc.cfm

		
<!---	
* Proceso: CPRE - Pagos de Cuentas x Pagar
* Disparador: Aplicar Pagos de Cuentas x Pagar
* Fecha: 20/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Pagos de Cuentas x Pagar
 ---> 
		<cfcase value="BMovimientosCxP">
			<cfquery datasource="#session.dsn#" name="rs">
				Select SNcodigo,DFecha
				From BMovimientosCxP
				Where IDdocumento = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfset ruta="/cfmx/sif/cp/consultas/PagoRealizado_sql.cfm?SNcodigo=#rs.SNcodigo#&IDdocumento=#rsNAP.IDTablaOrigen#&FechaI=#rs.DFecha#&FechaF=#rs.DFecha#&formatos=1&LvarRecibo=&link=1">
		</cfcase> 
		
<!---	
* Proceso: CCFC - Documentos de Cuentas x Cobrar
* Disparador: Aplicar facturas de Cuentas x Cobrar
* Fecha: 20/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Documentos de Cuentas x Cobrar
 ---> 
		<cfcase value="HDocumentos">
			<cfquery datasource="#session.dsn#" name="rs">
				Select hd.Ddocumento, hd.SNcodigo, sn.SNnumero
				From HDocumentos hd
    				inner join SNegocios sn on hd.SNcodigo = sn.SNcodigo
				Where HDid = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfset ruta="/cfmx/sif/cc/consultas/RFacturasCC2-DetalleDoc.cfm?SNnumero=#rs.SNnumero#&SNcodigo=#rs.SNcodigo#&FechaIni=&FechaFin=&Documento=#rs.Ddocumento#&HDid=#rsNAP.IDTablaOrigen#&btnConsultar=Consultar&FechaVenIni=&FechaVenFin=&&CCTcodigo=&CFid=&DDtipo=T&link=1">
			
			<!---
			
			<cfset ruta = "/cfmx/sif/cc/consultas/RFacturasCC2-reporte.cfm?SNnumero=&SNcodigo=&fechaIni=&fechaFin=&fechaVenIni=&fechaVenFin=&CCTcodigo=&Documento=#rs.Ddocumento#&CFid=&CFcodigo=&CFdescripcion=&TipoItem=T&botonSel=btnConsultar&btnConsultar=Consultar&link=1"> 
			
			--->
		</cfcase> 
		


		
<!---	
* Proceso: CCRE - Pagos de Cuentas x Cobrar
* Disparador: Aplicar Pagos Cuentas x Cobrar
* Fecha: 21/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Pagos de Cuentas x Cobrar
 ---> 
		<cfcase value="HPagos">
			<cfquery datasource="#session.dsn#" name="rs">
				Select SNcodigo,Pfecha, Pcodigo
				From HPagos
				Where HPid = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfset ruta = "/cfmx/sif/cc/consultas/PagoRealizado_sqlCC.cfm?SNcodigo=#rs.SNcodigo#&fechaI=#rs.Pfecha#&fechaF=#rs.Pfecha#&CCTcodigo=&HDid=#rsNAP.IDTablaOrigen#&CCTcodigo=&formatos=1&LvarRecibo=#rs.Pcodigo#&link=1">
		</cfcase> 
		


<!---	
* Proceso: RHPN - Recursos Humanos
* Fecha: 21/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Se aplica el pago de Nómina
 ---> 
		<cfcase value="HRCalculoNomina">
			<cfquery datasource="#session.dsn#" name="rs">
				Select Tcodigo, RCDescripcion
				From HRCalculoNomina
				Where RCNid = #rsNAP.IDTablaOrigen#
			</cfquery>
			
			<cfif rs.RecordCount GT 0>
				<cfset ruta = "/cfmx/rh/nomina/consultas/PConsultaRCalculoHist.cfm?radRep=1&Tcodigo=#rs.Tcodigo#&Tdescripcion=Nómina+Quincenal+Regulación&CPid=#rsNAP.IDTablaOrigen#&CPcodigo=&CPdescripcion=#rs.RCDescripcion#&chkAgrupar=on&TDcodigo=&TDid=&negativo=1&CIid=&CIcodigo=&CIdescripcion=&negativo1=1&CIid1=&CIcodigo1=&CIdescripcion1=&Submit=Consultar&ECid=&Historico=H&linkNAP=1">
			<cfelse>
				<cfquery datasource="#session.dsn#" name="rs">
				Select Tcodigo, RCDescripcion, RCdesde, RChasta
				From RCalculoNomina
				Where RCNid = #rsNAP.IDTablaOrigen#
			</cfquery>
			<cfset ruta = "/cfmx/rh/nomina/consultas/NominaPlanilla.cfm?Filtro_FechaDesde=#rs.RCdesde#&Filtro_FechaHasta=#rs.RChasta#&Tcodigo10=#rs.Tcodigo#&Tdescripcion10=#rs.RCDescripcion#&Tcodigo1=&Tdescripcion1=&CPid1=&CPcodigo1=&CPdescripcion1=&Tcodigo2=QESP&Tdescripcion2=Nómina+Quincenal+Espectro&CPid2=#rsNAP.IDTablaOrigen#&CPcodigo2=&CFcodigo=&CFdescripcion=&CFid=&NTIcodigo=-1&DEid=&DEidentificacion=&NombreEmp=&botonSel=btnVer&btnVer=Ver&linkNAP=1">
			</cfif>
			
		</cfcase>
			
			
			

<!---	
* Proceso: MBMV: Movimiento Bancario
* Disparador: Se dispara cuando se aplica un movimiento bancario.
* Fecha: 18/11/2013
* Creado por: mmora
* Ultima modificacion: mmora
* Descripción: Movimiento en Bancos
 ---> 
		<cfcase value="HEContables">
			<cfset ruta = "/cfmx/sif/cg/consultas/SQLPolizaConta.cfm?intercomp=0&IDcontable=#rsNAP.IDTablaOrigen#">
		</cfcase> 



<!---
	<cfcase value="otra tabla">
		<cfset ruta="/alsdjfl/lasjdfl/jfjfjf.cfm">
		<cfset enPopUp = false> <!--- lo muestra en una nueva pestaña --->
	</cfcase>
--->



<!-------------------------------------------------------------------------------------------------------
---------------------------------     TERMINAMOS, MOSTRAMOS EL LINK    -----------------------------------
--------------------------------------------------------------------------------------------------------->
		</cfswitch>
	</cfif>

	<cfif Len(ruta)> <!--- solo mostramos el link si la ruta contiene algo, es decir, Esta programada la lógica para el módulo --->
		
		<!--- solo mostramos el texto si viene como parámetro --->
		<cfif isDefined("Attributes.Texto") and Len(Attributes.Texto)>
			<a style="text-decoration:underline; color:blue;cursor:pointer" onclick="javascript:abrirDocumentoPopUp('#ruta#');"><cfoutput>#Attributes.Texto#</cfoutput></a>			
		</cfif>
		
		 &nbsp;&nbsp;<img src="/cfmx/sif/imagenes/find.small.png" style="cursor:pointer; position: relative; bottom: -4px; left: -4px;"   onclick="javascript:abrirDocumentoPopUp('#ruta#');"/> 
	<cfelse>
	<cfif isDefined("Attributes.Texto") and Len(Attributes.Texto)>
		#Attributes.Texto#
	</cfif>
	</cfif>
	
</cfoutput>