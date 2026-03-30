<!---
Inclusión de las facturas en la tabla de Recuperación: FAERecuperacion, FADRecuperacion

-------------------------------------------------------------
--------------------- VALIDACIONES  -------------------------
-------------------------------------------------------------
  1.  Ecodigo: Validar que la empresa existe
  2.  Moneda:  Validar que el Miso exista para la empresa
  3.  SNcodigoext: Validar que exista el SNecodigo 
  4.  SNombre y SCedula: Validar dentro de SNegocios
  5.  CodigoAgencia: Validar que exista la agencia
  6.  CedVendedor: Verificar que exista el vendedor
  7.  IndGenFact: (Solo pueden ser D, F o R)
  		Si es D es una Factura Directa (Número Factura = Número de Documento)
		Si es F es una Factura Directa (Generar Factura en el Facturador)
		Si es R es un documento a recuperar en el facturador
  8.  CFcodigo: Verificar que el Centro Funcional exista
  9.  Validar que las fechas sean validas
  10. CedCobrador: Verificar que exista el cobrador
  11. CodigoCaja: Validar que la caja exista
  12. IndSeparada: solo puede ser S o N
        S: Facturar líneas por separado
		N: Debe Facturarse todo el documento junto
  13. IndVence: Solo puede ser 0 ó 1
        0: No vence
		1: Vence
  14. EcodigoOrigen y CfcodigoOrigen: Verificar que sea empresa y centro funcional validos dentro de NACION
  15. CodImpuesto: Validar impuesto
  16. MontoLinea: mayor a cero
  17. codigo_zona: validar que exista
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la interfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">

<!--- Reporta actividad de la interfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Valida que la transacción tenga detalle --->
<cfquery name="readIE748" datasource="sifinterfaces">
	Select a.ID
	from IE748 a
		inner join ID748 b on b.ID = a.ID
	where a.ID = #GvarID#
</cfquery>

<cfif readIE748.recordcount eq 0>
	<cfthrow message=" Existen Datos de Transacciones sin Detalles relacionadas. Proceso Cancelado!">
</cfif>

				<!--- ******************************** --->
				<!---   VALIDACIONES DEL ENCABEZADO    --->
				<!--- ******************************** --->


<!--- Hace un select de todos los campos del encabezado para validar los campos --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado la tabla IE748 (Obtener los Datos de Transacciones) --->
	<cfquery name="E748" datasource="sifinterfaces">
		select *
		from IE748
		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif E748.recordcount eq 0>
		<cfthrow message="Error en Interfaz 748. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>	 
</cftransaction>

<!--- Validar la Caja --->
<cfquery name="rsCajas" datasource="#session.dsn#">
	Select FCid 
	From FCajas 
	where FCcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.FCcodigo#">
<!---	and FCestado = 1--->
</cfquery> 
<cfif isdefined('rsCajas') and rsCajas.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. La caja no existe. Proceso Cancelado!." >
</cfif>


<!--- Validar las llaves del Encabezado: NumDoc y CodSistema --->
<cfif #E748.IndGenFact# EQ 'R'>
	<cfquery name="rsNumDoc" datasource="#session.dsn#">
		Select Count(*) as Cantidad
		From FAERecuperacion
		Where NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.NumDoc#">
			  and CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.CodSistema#">
	</cfquery>
	<cfif rsNumDoc.Cantidad gt 0>
		<cfthrow message="Error en Interfaz 748. El documento '#E748.NumDoc#' ya existe en FAERecuperacion. Proceso Cancelado!.">
	</cfif>
<cfelseif #E748.IndGenFact# EQ 'D'>
	
	<!--- Verificar que el nombre del documento no exista en ETransacciones si es Directa  --->
	<cfquery name="rsNumDoc" datasource="#session.dsn#">
		Select count(*) as cantidad
		From ETransacciones
		Where ETdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.NumeroFactura#"> 
        and ETserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.NumeroSerie#"> 
		<!---and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCajas.FCid#">--->
	</cfquery>
	<cfif rsNumDoc.cantidad gt 0>
		<cfthrow message="Error en Interfaz 748. El documento '#E748.NumDoc#' ya existe en ETransacciones. Proceso Cancelado!.">
	</cfif>
	<!---   --->
</cfif>

<!---Verificar que la Empresa exista --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
  Select Ecodigo
  From Empresas 
  Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#">
</cfquery> 
<cfif rsEmpresa.recordcount eq 0>
  <cfthrow message="Error en Interfaz 748. La empresa no esta en la base de datos. Proceso Cancelado!." >
</cfif>


<!--- Validar la zona --->
<cfquery name="rsZona" datasource="#session.dsn#">
   Select id_zona
   From ZonaVenta 
   where codigo_zona = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.codigo_zona#">
   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#E748.Ecodigo#">
</cfquery> 
<cfif rsZona.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. La Zona no esta en la base de datos. Proceso Cancelado!." >
</cfif>


<!--- Validar Moneda --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
   select Mcodigo from Monedas 
   where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.Miso4217#">
   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#">
</cfquery> 
<cfif rsMoneda.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. La moneda no esta en la base de datos. Proceso Cancelado!." >
</cfif>

<!--- Validar Socio de Negocio --->
<cfquery name="rsSNid" datasource="#session.dsn#">
 	Select SNid, SNcodigo 
	From SNegocios 
  	Where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
  	and SNcodigoext =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.SNcodigoext#">
</cfquery>
<cfif rsSNid.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. El Socio de Negocio no existe. Proceso Cancelado!." >
</cfif>

<!--- Validar SNnombre y SNidentificacion --->
<cfquery name="rsSocioIdentificacion" datasource="#session.dsn#">
   Select SNnombre
   From SNegocios 
   where SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.SNidentificacion#">
</cfquery>
<cfif rsSocioIdentificacion.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. El Socio de Negocio no existe. Proceso Cancelado!." >
</cfif>

<!--- Validar dirección --->
<cfquery name="rsDireccion" datasource="#session.dsn#">
   	Select sd.id_direccion
	From SNDirecciones sd
    	inner join SNegocios sn on sn.SNid = sd.SNid
	Where sd.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.SNcodigoext#">
</cfquery>
<cfif rsDireccion.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. La Dirección del Socio de Negocio no existe. Proceso Cancelado!." >
</cfif>

<!--- Verificar que el centro funcional exista --->
<cfquery name="rsCF" datasource="#session.dsn#">
	Select CFid 
	From CFuncional 
	Where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.CFcodigo#"> 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
</cfquery>
<cfif rsCF.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. El centro funcional es incorrecto. Proceso Cancelado!." >
</cfif>

<!--- Validar Indicador Genera Factura --->
<cfif #E748.IndGenFact# EQ "D">
    <cfif #E748.tipoCambio# EQ "">
		<cfthrow message="Error en Interfaz 748. El tipo de cambio es requerido. Proceso Cancelado!." >
	</cfif>
<cfelseif #E748.IndGenFact# EQ "F">
	 <cfif #E748.tipoCambio# EQ "">
		<cfthrow message="Error en Interfaz 748. El tipo de cambio es requerido. Proceso Cancelado!." >
	</cfif>
<cfelseif #E748.IndGenFact# EQ "R">
	<cfset var = "R">
<cfelse>
	<cfthrow message="Error en Interfaz 748. El Indicador de Generar Factura es incorrecto. Proceso Cancelado!." >
</cfif>

<!--- Validar Indicador de Contado o Credito --->
<cfif #E748.IndContadoCredito# EQ "CO">
	<cfset var = "CO">
<cfelseif #E748.IndContadoCredito# EQ "CR">
	<cfset var = "CR">
<cfelse>
	<cfthrow message="Error en Interfaz 748. El Indicador de Contado Credito es incorrecto. Proceso Cancelado!." >
</cfif>

<!--- Validar Tipo de Transacción --->
<cfquery name="rsTipoTransaccion" datasource="#session.dsn#">
	Select CCTcodigo 
	From CCTransacciones 
	Where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.CCTcodigo#"> 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#E748.Ecodigo#"> 
</cfquery>
<cfif rsTipoTransaccion.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. El Tipo de Transaccion no existe. Proceso Cancelado!." >
</cfif>

<!--- Validar que el indicador de Separación de la transaccion sea S o N --->
<cfif (Trim(#E748.IndSeparada#) EQ "S") or (Trim(#E748.IndSeparada#) EQ "N")>
	<cfset IndSeparada = Trim(#E748.IndSeparada#)>
<cfelse>
	<cfthrow message="Error en Interfaz 748. El Indicador de Separaci&oacute;n #E748.IndSeparada# es incorrecto. Proceso Cancelado!." >
</cfif>

<!--- Validar que el indicador de Vencimiento de la transaccion sea S o N --->
<cfif (Trim(#E748.IndVence#) NEQ "0") or (Trim(#E748.IndVence#) NEQ "1")>
	<cfset IndVence = Trim(#E748.IndVence#)>
<cfelse>
	<cfthrow message="Error en Interfaz 748. El Indicador de Vendimiento de la Transaccion es incorrecto. Proceso Cancelado!." >
</cfif>


<!--- Validar código de Agencia --->
<cfif isdefined('E748.SNcodigoextAgencia') and Len(Trim(#E748.SNcodigoextAgencia#))>
    <cfquery name="rsAgencia" datasource="#session.dsn#">
        Select rsn.RESNid, sn.SNid ,sn.SNcodigo 
        From SNegocios sn
            inner join RolEmpleadoSNegocios rsn on rsn.SNcodigo = sn.SNcodigo and rsn.Ecodigo = sn.Ecodigo and rsn.RESNtipoRol = 4
        Where sn.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.SNcodigoextAgencia#"> 
            and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#E748.Ecodigo#"> 
    </cfquery> 
    <cfif rsAgencia.recordcount eq 0>
        <cfthrow message="Error en Interfaz 748. La Agencia no existe. Proceso Cancelado!." >
    </cfif>
</cfif>

<!--- Validar el vendedor --->
<cfif isdefined('E748.SNidentificacionVendedor') and Len(Trim(#E748.SNidentificacionVendedor#))>
    <cfquery name="rsVendedor" datasource="#session.dsn#">
        Select de.DEid, ren.RESNid as RESNidVendedor
        From DatosEmpleado de
            inner join RolEmpleadoSNegocios ren on ren.DEid = de.DEid and ren.RESNtipoRol = 2
        Where de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.SNidentificacionVendedor#"> 
            and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#E748.Ecodigo#"> 
    </cfquery> 
    <cfif rsVendedor.recordcount eq 0>
        <cfthrow message="Error en Interfaz 748. El vendedor no existe. Proceso Cancelado!." >
    </cfif>
 </cfif>

<!--- Validar el cobrador --->
<cfif isdefined('E748.SNidentificacionCobrador') and Len(Trim(#E748.SNidentificacionCobrador#))>
    <cfquery name="rsCobrador" datasource="#session.dsn#">
        Select de.DEid, ren.RESNid as RESNidCobrador
        From DatosEmpleado de
            inner join RolEmpleadoSNegocios ren on ren.DEid = de.DEid and ren.RESNtipoRol = 3
        Where de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#E748.SNidentificacionCobrador#"> 
            and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#E748.Ecodigo#"> 
    </cfquery> 
    <cfif rsCobrador.recordcount eq 0>
        <cfthrow message="Error en Interfaz 748. El cobrador no existe. Proceso Cancelado!." >
    </cfif>
 </cfif>


<!--- Validar FechaDocumento, FechaVencimiento y FechaVencimientoTransaccion --->
<cftry>
	<cfset FechaDocumento = 				#LSDateFormat(E748.FechaDocumento,'DDMMYYYY')#>
	<cfset FechaVencimientoPago = 			#LSDateFormat(E748.FechaVencimientoPago,'DDMMYYYY')#>
	<cfset FechaVencimientoTransaccion = 	#LSDateFormat(E748.FechaVencimientoTransaccion,'DDMMYYYY')#>
	
	<cfcatch type= "expression">   
		<cfthrow message="#cfcatch.message#. Proceso Cancelado!." >
	</cfcatch>	
</cftry>


				<!--- ******************************** --->
				<!---    VALIDACIONES DEL DETALLE      --->
				<!--- ******************************** --->

<!--- Hace un select de todos los campos del encabezado para validar los campos --->
<!--- Lee encabezado la tabla ID748 (Obtener los Datos de Transacciones) --->
<cfquery name="D748" datasource="sifinterfaces">
	Select * 
	From ID748 b
	where b.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<!--- Valida que vengan datos --->
<cfif D748.recordcount eq 0>
	<cfthrow message="Error en Interfaz 748. No existen datos de Detalle para el ID='#GvarID#'. Proceso Cancelado!.">
</cfif>	 

<!--- Validar que los detalles correspondan al mismo número de documento del encabezado --->
<cfloop query="D748">
	<cfif Trim(#D748.NumDoc#) NEQ Trim(#E748.NumDoc#)>
		<cfthrow message="Error en Interfaz 748. El Numero de documento es diferente al del encabezado. Proceso Cancelado!.">
	</cfif>
</cfloop>

<cfloop query="D748">
	<!--- Validar las llaves del Encabezado: NumDoc y CodSistema --->
	<cfif #E748.IndGenFact# EQ "R">
		<cfloop query="D748">
				<cfquery name="rsNumDoc" datasource="#session.dsn#">
					Select Count(*) as Cantidad
					From FADRecuperacion
					Where NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#D748.NumDoc#">
						  and CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#D748.CodSistema#">
						  and NumLineaDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#D748.NumLineaDet#">
				</cfquery>
					<cfif rsNumDoc.Cantidad gt 0>
						<cfthrow message="Error en Interfaz 748. El Numero de Línea #D748.NumLineaDet# del documento '#D748.NumDoc#' ya existe en FADRecuperacion. Proceso Cancelado!.">
					</cfif>
			</cfloop>
			<cfif rsNumDoc.Cantidad gt 0>
				<cfthrow message="Error en Interfaz 748. El documento '#E748.NumDoc#' ya existe en FAERecuperacion. Proceso Cancelado!.">
			</cfif>
	</cfif>
</cfloop>

<!--- Tabla temporal para mantener la información del Encabezado --->
<cf_dbtemp name="INTERFAZE748" 		returnvariable="tabla_interfazE748" 	 	datasource="#session.dsn#">
	<cf_dbtempcol name="ID"		 						type="numeric(18)"     	mandatory="yes">
	<cf_dbtempcol name="NumDoc"		 					type="varchar(25)"     	mandatory="yes">
	<cf_dbtempcol name="CodSistema"						type="varchar(10)" 		mandatory="yes">
	<cf_dbtempcol name="id_zona"						type="numeric(18)"		mandatory="yes">
	<cf_dbtempcol name="codigo_zona"					type="char(10)"  		mandatory="yes">
	<cf_dbtempcol name="Ecodigo" 						type="integer"	    	mandatory="yes">
	<cf_dbtempcol name="Mcodigo"						type="numeric(8)"  		mandatory="yes">
	<cf_dbtempcol name="Miso4217" 						type="char(3)"      	mandatory="yes">
	<cf_dbtempcol name="SNid" 							type="numeric(18)"      mandatory="yes">
	<cf_dbtempcol name="SNcodigoext" 					type="varchar(25)"      mandatory="yes">
	<cf_dbtempcol name="SNnombre" 						type="varchar(255)"     mandatory="yes">
	<cf_dbtempcol name="SNidentificacion" 				type="varchar(30)"   	mandatory="yes">
	<cf_dbtempcol name="id_direccion" 					type="numeric(18)"    	mandatory="yes"> 
	<cf_dbtempcol name="CodDireccionExt" 				type="varchar(30)"    	mandatory="yes">
	<cf_dbtempcol name="SNcodigoextAgencia" 			type="integer"	    	mandatory="no">
	<cf_dbtempcol name="RESNidVendedor" 				type="numeric(18)"    	mandatory="no">
	<cf_dbtempcol name="SNidentificacionVendedor" 		type="char(30)"    		mandatory="no">
	<cf_dbtempcol name="NumLote" 						type="varchar(15)"    	mandatory="no">
	<cf_dbtempcol name="IndGenFact" 					type="char(1)"    		mandatory="yes">
	<cf_dbtempcol name="Usuario" 						type="varchar(50)"    	mandatory="yes">
	<cf_dbtempcol name="IndContadoCredito" 				type="char(2)"    		mandatory="yes">
	<cf_dbtempcol name="CCTcodigo" 						type="char(2)"    		mandatory="yes">
	<cf_dbtempcol name="CFid" 							type="numeric(18)"    	mandatory="yes">
	<cf_dbtempcol name="CFcodigo" 						type="char(10)"    		mandatory="yes">
	<cf_dbtempcol name="FechaDocumento" 				type="date"    			mandatory="yes">
	<cf_dbtempcol name="FechaVencimientoPago" 			type="date"    	   		mandatory="yes">
	<cf_dbtempcol name="FechaVencimientoTransaccion" 	type="date"    			mandatory="yes">
	<cf_dbtempcol name="Observacion" 					type="varchar(255)"    	mandatory="yes">
	<cf_dbtempcol name="RESNidCobrador" 				type="numeric(18)"    	mandatory="no">
	<cf_dbtempcol name="FCid" 							type="numeric(18)"    	mandatory="yes">
	<cf_dbtempcol name="SNidentificacionCobrador" 		type="char(30)"    		mandatory="no">
	<cf_dbtempcol name="FCcodigo" 						type="char(15)"    		mandatory="yes">
	<cf_dbtempcol name="IndSeparada" 					type="char(1)"    		mandatory="yes">
	<cf_dbtempcol name="IndVence" 						type="bit"    			mandatory="yes">
	<cf_dbtempcol name="tipoCambio" 					type="money"    		mandatory="no">
	<cf_dbtempcol name="NumOrdenCompra"					type="numeric"			mandatory="no">
	<cf_dbtempcol name="NumeroFactura"					type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="NumeroSerie"					type="varchar(10)"		mandatory="no">	
	<cf_dbtempcol name="PorcentajeMontoDescuento"		type="char(1)"			mandatory="no">	
	<cf_dbtempcol name="Descuento"						type="numeric"			mandatory="no">		
</cf_dbtemp>

<cf_dbdatabase table="IE748" 				datasource="sifinterfaces" 		returnvariable="IE748">
<cfquery datasource="#session.dsn#">
	Insert Into #tabla_interfazE748#(
			ID, 						NumDoc, 				CodSistema, 					id_zona, 			codigo_zona, 				Ecodigo, 			
			Mcodigo, 					Miso4217, 				SNid,  							SNcodigoext, 		SNnombre,					SNidentificacion,
			id_direccion,		  		CodDireccionExt,  		SNcodigoextAgencia,				RESNidVendedor, 	SNidentificacionVendedor,	NumLote,		
			IndGenFact,					Usuario,				IndContadoCredito,				CCTcodigo,			CFid,						CFcodigo,	
			FechaDocumento,				FechaVencimientoPago, 	FechaVencimientoTransaccion,	Observacion,		RESNidCobrador, 			FCid,
			SNidentificacionCobrador, 	FCcodigo,		  		IndSeparada,					IndVence,			tipoCambio,					NumOrdenCompra,
			NumeroFactura,				NumeroSerie,			PorcentajeMontoDescuento,		Descuento				
		)
	Select 
		e.ID,
		e.NumDoc,
		e.CodSistema,
		#rsZona.id_zona#,
		e.codigo_zona,
		e.Ecodigo,
		#rsMoneda.Mcodigo#,
		e.Miso4217,    				
		#rsSNid.SNid#,
		e.SNcodigoext,
		e.SNnombre,
		e.SNidentificacion,
		#rsDireccion.id_direccion#,
		e.CodDireccionExt,
        <cfif isdefined('E748.SNcodigoextAgencia') and Len(Trim(#E748.SNcodigoextAgencia#))>
        		#rsAgencia.SNcodigo#,
        <cfelse>
        	null,
        </cfif>
        <cfif isdefined('rsVendedor.RESNidVendedor') and Len(Trim(#rsVendedor.RESNidVendedor#))>
			#rsVendedor.RESNidVendedor#,
        <cfelse>
        	null,
        </cfif>
		e.SNidentificacionVendedor,
		e.NumLote,
		e.IndGenFact,
		e.Usuario,
		e.IndContadoCredito,
		e.CCTcodigo,
		#rsCF.CFid#,
		e.CFcodigo,
		e.FechaDocumento,
		e.FechaVencimientoPago,
		e.FechaVencimientoTransaccion,
		e.Observacion,
        <cfif isdefined('rsCobrador.RESNidCobrador') and Len(Trim(#rsCobrador.RESNidCobrador#))>
			#rsCobrador.RESNidCobrador#,
        <cfelse>
          	null,
        </cfif>
		#rsCajas.FCid#,
		e.SNidentificacionCobrador,
		e.FCcodigo,	
		e.IndSeparada,	
		e.IndVence,
		coalesce(e.tipoCambio,null) as tipoCambio,
		e.NumOrdenCompra,
		e.NumeroFactura,
		e.NumeroSerie,	
		e.PorcentajeMontoDescuento,
		e.Descuento
	From #IE748# e
	Where e.ID = #GvarID#
</cfquery>

<!--- Tabla temporal para mantener la información del detalle de las Transacciones --->
<cf_dbtemp name="INTERFAZD748" 			returnvariable="tabla_interfazD748" 	 	datasource="#session.dsn#">
	<cf_dbtempcol name="ID"		 					type="numeric(18)"     	mandatory="yes">
	<cf_dbtempcol name="Ecodigo"					type="integer" 			mandatory="yes">
	<cf_dbtempcol name="NumDoc"						type="varchar(25)"		mandatory="yes">
	<cf_dbtempcol name="CodSistema"					type="varchar(10)"  	mandatory="yes">
	<cf_dbtempcol name="NumLineaDet" 				type="numeric(18)"	    mandatory="yes">
	<cf_dbtempcol name="CodODI"						type="varchar(25)"  	mandatory="yes">
	<cf_dbtempcol name="Descripcion" 				type="varchar(255)"     mandatory="yes">
	<cf_dbtempcol name="DescAlterna" 				type="varchar(255)"     mandatory="no">
	<cf_dbtempcol name="CFid" 						type="numeric(18)"      mandatory="yes">
	<cf_dbtempcol name="CFcodigo" 					type="char(10)"    		mandatory="yes">
	<cf_dbtempcol name="TipoVenta" 					type="char(1)"   		mandatory="yes">
	<cf_dbtempcol name="TipoTransaccion"			type="char(5)"			mandatory="yes">
	<cf_dbtempcol name="CodArticulo" 				type="char(15)"	    	mandatory="no"> 
	<cf_dbtempcol name="CodAlmacen" 				type="char(20)"    		mandatory="no"> 
	<cf_dbtempcol name="CodServicio" 				type="char(10)"    		mandatory="no"> 
	<cf_dbtempcol name="FPAEid" 					type="numeric(18)"    	mandatory="yes">
	<cf_dbtempcol name="FPAECodigo" 				type="varchar(20)"    	mandatory="yes">
	<cf_dbtempcol name="ComplementoActividad" 		type="varchar(100)"    	mandatory="yes">
	<cf_dbtempcol name="Cantidad" 					type="float(8)"    		mandatory="yes">
	<cf_dbtempcol name="MontoUnitario" 				type="money"    		mandatory="yes">
	<cf_dbtempcol name="ECodigoOrigen" 				type="numeric(18)" 		mandatory="yes">
	<cf_dbtempcol name="CFidOrigen" 				type="numeric(18)"    	mandatory="yes">
	<cf_dbtempcol name="CFcodigoOrigen" 			type="char(10)"    		mandatory="yes">
	<cf_dbtempcol name="CodEmpresa" 				type="varchar(5)"    	mandatory="yes">
	<cf_dbtempcol name="CodProducto" 				type="varchar(5)"    	mandatory="yes">
	<cf_dbtempcol name="CodSeccion" 				type="varchar(5)"    	mandatory="yes">
	<cf_dbtempcol name="Icodigo" 					type="char(5)"    		mandatory="yes">
	<cf_dbtempcol name="MontoImpuesto" 				type="money"   	   		mandatory="yes">
	<cf_dbtempcol name="MontoLinea" 				type="money"    		mandatory="yes">
	<cf_dbtempcol name="MontoDescuento"				type="money"			mandatory="no">
	<cf_dbtempcol name="NumSecuencia"				type="numeric"			mandatory="yes">
</cf_dbtemp>

<cf_dbdatabase table="ID748" 		datasource="sifinterfaces" 		returnvariable="ID748">

<cfloop query="D748">
	<!--- Verificar que el centro funcional exista --->
	<cfquery name="rsCFid" datasource="#session.dsn#">
		Select CFid 
		From CFuncional 
		Where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#D748.CFcodigo#">  
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
	</cfquery>
	<cfif rsCFid.recordcount eq 0>
		<cfthrow message="Error en Interfaz 748. El centro funcional es incorrecto. Proceso Cancelado!." >
	</cfif>

	<!--- Verificiar que el tipo de transaccion exista --->
	<cfif #D748.TipoTransaccion# EQ "">
		<cfthrow message="Error en Interfaz 748. El tipo de transacción no puede ser nula. Proceso Cancelado!." >	
	<cfelse>
		<!--- Verificar que no sea un char mayor a 5 caracteres --->
		<cfif Len(Trim(#D748.TipoTransaccion#)) gt 5>
			<cfthrow message="Error en Interfaz 748. El largo del tipo de transacción no puede ser mayor a cinco caracteres. Proceso Cancelado!." >	
		<cfelse>
			<!--- Se obtienen los datos del tipo de transacción --->
			<cfquery name="rsTTransaccion" datasource="#Session.dsn#">
				Select e.TTcodigo, e.TTEdescripcion, e.TTtipo, d.*
				From ETipoTransaccion e
    				inner join DTipoTransaccion d on d.TTEid = e.TTEid
				Where e.TTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#D748.TipoTransaccion#">
			</cfquery>
			
			<cfif rsTTransaccion.RecordCount eq 0>
				<cfthrow message="Error en Interfaz 748. El tipo de transacción no tiene ninguna Actividad Empresarial asociada. Proceso Cancelado!." >
			<cfelse>
				<cfloop query="rsTTransaccion">
					<!--- Validar que exista la Actividad Empresarial --->
					<cfquery name="rsActividad" datasource="#Session.dsn#">
						Select Count(1) as Cantidad
						From FPActividadE
						Where FPAECodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTTransaccion.FPAEcodigo#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTTransaccion.Ecodigo#"> 
					</cfquery>
					<cfif rsActividad.Cantidad eq 0>
						<cfthrow message="Error en Interfaz 748. La Actividad Empresarial no existe. Proceso Cancelado!." >
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
		
	<!--- Validar El tipo de venta --->
	<cfif #D748.TipoVenta# EQ "A"> 
		
		<!--- Validar Articulo --->
		<cfquery name="rsArticulos" datasource="#session.dsn#">
			Select Count(1) as Cantidad
			From Articulos 
			Where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#D748.CodArticulo#">   
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
		</cfquery>
		<cfif rsArticulos.Cantidad eq 0>
			<cfthrow message="Error en Interfaz 748. El Articulo no existe en la base de datos. Proceso Cancelado!." >
		</cfif>
		
		<!--- Validar Almacen --->
		<cfquery name="rsAlmacen" datasource="#session.dsn#">
			Select Count(1) as Cantidad
			From Almacen 
			Where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#D748.CodAlmacen#"> 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
		</cfquery>
		<cfif rsAlmacen.Cantidad eq 0>
			<cfthrow message="Error en Interfaz 748. El Almacen no existe en la base de datos. Proceso Cancelado!." >
		</cfif>
		
	<cfelseif #D748.TipoVenta# EQ "S"> 
		
		<!--- Por cada línea que tenga la transacción configuradas en el catalogo se obtiene el codigo del servicio --->
		<cfloop query="rsTTransaccion">
			<!--- validar Concepto --->
			<cfquery name="rsConcepto" datasource="#session.dsn#">
				Select Count(*) as Cantidad
				From Conceptos 
				Where Cid =	<cfqueryparam 	cfsqltype="cf_sql_numeric" 		value="#rsTTransaccion.Cid#">
			</cfquery>
			<cfif rsConcepto.Cantidad eq 0>
				<cfthrow message="Error en Interfaz 748. El Concepto no existe en la base de datos. Proceso Cancelado!." >
			</cfif>
		</cfloop>
			
	<cfelse>
		<cfthrow message="Error en Interfaz 748. El Tipo de Venta es incorrecto. Proceso Cancelado!." >
	</cfif>

	<!--- Validar cantidad y Monto Unitario --->
	<cfif #D748.Cantidad# LT 0>
		<cfthrow message="Error en Interfaz 748. La cantidad debe ser mayor a 0. Proceso Cancelado!." >
	</cfif>

	<cfif #D748.MontoUnitario# EQ 0>
		<cfthrow message="Error en Interfaz 748. El Monto Unitario no puede ser 0. Proceso Cancelado!." >
	</cfif>

	<!--- Validar impuestos --->
	<cfquery name="rsImpuestos" datasource="#session.dsn#">
		Select Count(1) as Cantidad
		From Impuestos
		Where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#D748.Icodigo#">  
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
	</cfquery>
	<cfif rsImpuestos.Cantidad eq 0>
		<cfthrow message="Error en Interfaz 748. Impuesto no registrado para la empresa. Proceso Cancelado!." >
	</cfif>

	<!--- validar Monto de Impuesto y Monto de Linea --->
	<cfif #D748.MontoImpuesto# LT 0>
		<cfthrow message="Error en Interfaz 748. El monto de impuesto no puede ser negativo. Proceso Cancelado!." >
	</cfif>

	<cfif #D748.MontoLinea# EQ 0>
		<cfthrow message="Error en Interfaz 748. El Monto de Linea debe ser diferente de 0. Proceso Cancelado!." >
	</cfif>

	<!--- Validar centro funcional de Origen --->
	<cfquery name="rsCFOrigen" datasource="#session.dsn#">
		Select CFid as CFidOrigen 
		From CFuncional 
		Where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#D748.CFcodigoOrigen#">  
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#E748.Ecodigo#"> 
	</cfquery>
	<cfif rsCFOrigen.recordcount eq 0>
		<cfthrow message="Error en Interfaz 748. El centro funcional es incorrecto. Proceso Cancelado!." >
	</cfif>
	
	<!--- Validar el monto de descuento --->
	<cfif isdefined('D748.MontoDescuento') and Len(Trim(#D748.MontoDescuento#))>
		<cfif #D748.MontoDescuento# GT #D748.MontoLinea# and #D748.MontoDescuento# NEQ 0  >
			<cfthrow message="Error en Interfaz 748. El descuento no puede ser mayor al monto de la línea. Proceso Cancelado!." >
		</cfif>
	</cfif>
	
	<!--- Por cada línea de la Factura --->
	<cfloop query="rsTTransaccion">
		
		<cfset monto = CmontoLinea(#rsTTransaccion.TTporcentaje#, #D748.MontoLinea#)>
		
		<!--- Obtener el FPAEid --->
		<cfquery name="rsActividad" datasource="#Session.dsn#">
			Select FPAEid, FPAECodigo
			From FPActividadE
			Where FPAECodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTTransaccion.FPAEcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTTransaccion.Ecodigo#"> 
		</cfquery>
					
		<cfquery datasource="#session.dsn#">
			Insert Into #tabla_interfazD748#(
					ID,						Ecodigo,        		NumDoc,             CodSistema, 			
					NumLineaDet,			CodODI,         		Descripcion,        DescAlterna,
					CFid, 					CFcodigo,       		TipoVenta,          TipoTransaccion,
					CodArticulo,			CodAlmacen,				CodServicio,		FPAEid,
					FPAECodigo, 			ComplementoActividad,	Cantidad,			MontoUnitario,
					ECodigoOrigen,			CFidOrigen, 			CFcodigoOrigen, 	CodEmpresa,   
					CodProducto,			CodSeccion, 			Icodigo,			MontoImpuesto,
					MontoLinea,				MontoDescuento,			NumSecuencia
				)
			Values
			(
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#D748.ID#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#E748.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.NumDoc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.CodSistema#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#D748.NumLineaDet#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.CodODI#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.Descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.DescAlterna#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#rsCFid.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_char" 			value="#D748.CFcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char"  			value="#D748.TipoVenta#">,
				<cfqueryparam cfsqltype="cf_sql_char"  			value="#D748.TipoTransaccion#">,
				<cfif isdefined('D748.CodArticulo') and Len(Trim(#D748.CodArticulo#))>
					<cfqueryparam cfsqltype="cf_sql_char"  		value="#D748.CodArticulo#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('D748.CodAlmacen') and Len(Trim(#D748.CodAlmacen#))>
					<cfqueryparam cfsqltype="cf_sql_char"  		value="#D748.CodAlmacen#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('rsTTransaccion.Ccodigo') and Len(Trim(#rsTTransaccion.Ccodigo#))>
					<cfset Ccodigo = replace(#rsTTransaccion.Ccodigo#," ", "", "All")>
					<cfqueryparam cfsqltype="cf_sql_char"  		value="#Ccodigo#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#rsActividad.FPAEid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#rsActividad.FPAEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#rsTTransaccion.ComplementoActividad#">,
				<cfqueryparam cfsqltype="cf_sql_float" 	 		value="#D748.Cantidad#">,
				<cfqueryparam cfsqltype="cf_sql_money"  		value="#D748.MontoUnitario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#D748.ECodigoOrigen#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#rsCFOrigen.CFidOrigen#">,
				<cfqueryparam cfsqltype="cf_sql_char"  			value="#D748.CFcodigoOrigen#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.CodEmpresa#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.CodProducto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"  		value="#D748.CodSeccion#">,
				<cfqueryparam cfsqltype="cf_sql_char"  			value="#D748.Icodigo#">,
				<cfqueryparam cfsqltype="cf_sql_money"  		value="#D748.MontoImpuesto#">,
				<cfqueryparam cfsqltype="cf_sql_money"  		value="#monto#">,
                <cfif isdefined('D748.MontoDescuento') and Len(Trim(#D748.MontoDescuento#))>
 					<cfqueryparam cfsqltype="cf_sql_money"  		value="#D748.MontoDescuento#">,	
                 <cfelse>
					null,
				</cfif>   
				<cfqueryparam cfsqltype="cf_sql_numeric"  		value="#D748.NumSecuencia#">
			)
		</cfquery>
	</cfloop>
</cfloop>

						<!--- ***************************************************** --->
						<!--- Proceso para aplicar facturas o enviar a recuperacion --->
						<!--- ***************************************************** --->
						
<cfif #E748.IndGenFact# EQ "R"> <!---R: documento a recuperar en el facturador" --->
	<cfinvoke component="sif.Componentes.FA_RecuperacionFacturas" method="insertRecuperacion" returnvariable="FAERid">
		<cfinvokeargument name="TablaE" 		value="#tabla_interfazE748#">
		<cfinvokeargument name="TablaD" 		value="#tabla_interfazD748#">
	</cfinvoke>
<cfelse> <!---"D o F: Factura directa --->

	<cfset realizarPago = 'false'>
	
	<cfif #E748.IndContadoCredito# EQ 'CO'>
	
		<cfset realizarPago = 'true'>
		
		<!--- Validar que exista un pago --->	
		<cfquery name="P748" datasource="sifinterfaces">
			Select * 
			From IS748
			where NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.NumDoc#">
				and CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.CodSistema#">
		</cfquery>
	
		<cfif P748.recordCount eq 0>
				<cfthrow message="Error en Interfaz 748. No existe un pago para el documento #E748.NumDoc#. Proceso Cancelado!." >
		<cfelse>
		<!----                        ------>
			
			<!--- Obtener en el Detalle de la Transacción la suma del monto por línea --->
			<cfquery name="rsLineasAPagar" datasource="sifinterfaces">
				Select 	Sum(MontoLinea + MontoImpuesto) as montoPagado
				From 	ID748 
				where 	ID = #E748.ID# and
						NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.NumDoc#"> and
						CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.CodSistema#">
			</cfquery> 
			
			<!--- Obtener el total de los pagos para una determinada transacción --->
			<cfquery name="rsLineasPago" datasource="sifinterfaces">
				Select 	Sum(MontoPago) as montoPago
				From 	IS748 
				where 	ID = #E748.ID# and
						NumDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.NumDoc#"> and
						CodSistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#E748.CodSistema#">
			</cfquery> 
			
			<cfif rsLineasPago.MontoPago neq rsLineasAPagar.montoPagado>
				<cfthrow message="Existe una diferencia entre el total del encabezado y el total pagado para el documento #E748.ID#. Proceso cancelado!">
			</cfif>
			 <!---                        ------>
			 
			<cfif P748.TipoPago EQ 'CK'>
				<cfif P748.NumDocPago EQ ''>
					<cfthrow message="Error en la Interfaz 748. El Numero de Documento de Pago no esta definido, Tipo de Pago Cheque. Proceso cancelado!">
				</cfif>
			</cfif>
			
		</cfif>
	</cfif>
	 	
	<!--- Hacer inserción en ETransaccion y DTransaccion --->
	<cfinvoke component="sif.Componentes.FA_RecuperacionFacturas" method="RecuperarLineasFactura" returnvariable="ETnumeroRes">
		<cfinvokeargument name="TablaE"     				value="#tabla_interfazE748#">
		<cfinvokeargument name="TablaD"     				value="#tabla_interfazD748#">
		<cfinvokeargument name="FCid"      					value="#rsCajas.FCid#">
		<cfinvokeargument name="EcodigoEncabezado"   		value="#E748.Ecodigo#"> 
		<cfinvokeargument name="NumDocEncabezado"   		value="#E748.NumDoc#"> 
		<cfinvokeargument name="CodSistemaEncabezado"  		value="#E748.CodSistema#"> 
		<cfinvokeargument name="MetodoFiltro"   			value="IdEncabezado">
		<cfinvokeargument name="IdEncabezado"   			value="#GvarID#">
		<cfinvokeargument name="RealizarPago"   			value="#realizarPago#">   	<!--- Cambio --->
		<cfinvokeargument name="Estado"   					value="U">   				<!--- Estado Utilizado para mantener en historial --->
	</cfinvoke>
</cfif>

<cffunction name="CmontoLinea" returntype="numeric">
	<cfargument name="Porcentaje" type="numeric">
	<cfargument name="Monto" type="numeric">
	
	<cfset porcentaje = #Arguments.Porcentaje# / 100>
	<cfset montoFinal = #Arguments.Monto# * #porcentaje#>
	
	<cfreturn montoFinal>
</cffunction>