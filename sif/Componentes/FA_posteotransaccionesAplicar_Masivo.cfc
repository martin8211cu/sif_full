<!--- PENDIENTES 
  * Cuando se realice la insercion de lineas para el posteo de inventario, agrupar por articulo, almacen y Ecodigo.
  * Agregar indice a Kardex.DTlinea
--->

<cfcomponent>
  <cf_dbfunction name="OP_concat" returnvariable="_Cat">
  <cf_dbdatabase table="IE748"  datasource="sifinterfaces" returnvariable="T_IE748">
  <cf_dbdatabase table="IE748E" datasource="sifinterfaces" returnvariable="T_IE748E">
      
  <!------------------------------------------------------------------------------------------------------------------>

  <!--- Crea las tablas temporales que se utilizaran en el proceso de posteo de facturas --->
  <!--- TemporalesProcesoPosteo {
        tempETransacciones: 'nombre table temporal para ETransacciones'
        tempDTransacciones: 'nombre table temporal para DTransacciones'
        tempFPagos: 'nombre table temporal para FPagos'
      }
  --->
  <cffunction name="crearTemporales_posteo_documentosFA" access="public">
    <cfargument name="Conexion" type="string">

    <cfset Arguments.TemporalesProcesoPosteo = structNew()>
    <cfset uid = GetTickCount()>

    <!--- Temporal para Obtencion masiva de consecutivos --->
    <cf_dbtemp name="tempETransaccionesTalonario#uid#" returnvariable="_tempETransaccionesTalonario" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="id"                     type="numeric"      mandatory="yes" identity="yes">
      <cf_dbtempcol name="Ecodigo"                type="numeric"      mandatory="yes">        
      <cf_dbtempcol name="Tid"                    type="numeric"      mandatory="yes">
      <cf_dbtempcol name="ETnumero"               type="numeric"      mandatory="no">        
      <cf_dbtempcol name="FCid"                   type="numeric"      mandatory="no">        
      <cf_dbtempcol name="ETserie"                type="varchar(10)"  mandatory="no">
      <cf_dbtempcol name="ETdocumento"            type="numeric"      mandatory="no">  
      <cf_dbtempcol name="ID_IE748"               type="numeric"      mandatory="no">        
      <cf_dbtempcol name="ConsecutivoTalonario"   type="numeric"      mandatory="no" > <!--- Consecutivo de 1 a n por talonario en orden, para facilitar la asignacion del documento de Talonario en SigTalonario_Masivo--->
        
      <!--- Indices --->
      <cf_dbtempindex cols="id">        
      <cf_dbtempindex cols="ETnumero,FCid,Ecodigo">   
      <cf_dbtempindex cols="Tid,Ecodigo">    
      <cf_dbtempindex cols="ID_IE748">        
    </cf_dbtemp>
    <cfset Arguments.TemporalesProcesoPosteo.tempETransaccionesTalonario = _tempETransaccionesTalonario>

    <!--- ETransacciones --->
    <cf_dbtemp name="tempETransacciones#uid#" returnvariable="_tempETransacciones" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="FCid"                   type="numeric"      mandatory="yes">
      <cf_dbtempcol name="ETnumero"               type="numeric"      mandatory="yes">
      <cf_dbtempcol name="Ecodigo"                type="int"          mandatory="yes">
      <cf_dbtempcol name="Ocodigo"                type="int"          mandatory="yes">
      <cf_dbtempcol name="SNcodigo"               type="int"          mandatory="no" >
      <cf_dbtempcol name="Mcodigo"                type="numeric(8,0)" mandatory="yes">
      <cf_dbtempcol name="ETtc"                   type="float"        mandatory="yes">
      <cf_dbtempcol name="CCTcodigo"              type="char(2)"      mandatory="yes">
      <cf_dbtempcol name="Ccuenta"                type="numeric"      mandatory="yes">
      <cf_dbtempcol name="Tid"                    type="numeric"      mandatory="yes">
      <cf_dbtempcol name="FACid"                  type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETfecha"                type="datetime"     mandatory="yes">
      <cf_dbtempcol name="ETtotal"                type="money"        mandatory="yes">
      <cf_dbtempcol name="ETestado"               type="char(1)"      mandatory="yes">
      <cf_dbtempcol name="Usucodigo"              type="numeric"      mandatory="yes">
      <cf_dbtempcol name="Ulocalizacion"          type="char(2)"      mandatory="yes">
      <cf_dbtempcol name="Usulogin"               type="varchar(30)"  mandatory="yes">
      <cf_dbtempcol name="ETporcdes"              type="float"        mandatory="yes">
      <cf_dbtempcol name="ETmontodes"             type="money"        mandatory="yes">
      <cf_dbtempcol name="ETimpuesto"             type="money"        mandatory="yes">
      <cf_dbtempcol name="ETnumext"               type="varchar(30)"  mandatory="no" >
      <cf_dbtempcol name="ETnombredoc"            type="varchar(255)" mandatory="no" >
      <cf_dbtempcol name="ETobs"                  type="varchar(255)" mandatory="no" >
      <cf_dbtempcol name="ETdocumento"            type="int"          mandatory="no" >
      <cf_dbtempcol name="ETserie"                type="char(10)"     mandatory="no" >
      <cf_dbtempcol name="IDcontable"             type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETimpresa"              type="bit"          mandatory="yes">
      <cf_dbtempcol name="CFid"                   type="numeric"      mandatory="yes">
      <cf_dbtempcol name="ETnotaCredito"          type="bit"          mandatory="yes">
      <cf_dbtempcol name="CDCcodigo"              type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETmes"                  type="int"          mandatory="no" >
      <cf_dbtempcol name="ETnumero_generado"      type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETperiodo"              type="int"          mandatory="no" >
      <cf_dbtempcol name="id_direccion"           type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETobservacion"          type="varchar(200)" mandatory="no" >
      <cf_dbtempcol name="SNcodigo2"              type="int"          mandatory="no" >
      <cf_dbtempcol name="ETlote"                 type="varchar(15)"  mandatory="no" >
      <cf_dbtempcol name="ETexterna"              type="varchar(1)"   mandatory="no" >
      <cf_dbtempcol name="Rcodigo"                type="varchar(2)"   mandatory="no" >
      <cf_dbtempcol name="ETesLiquidacion"        type="bit"          mandatory="yes">
      <cf_dbtempcol name="ETmontoRetencion"       type="money"        mandatory="no" >
      <cf_dbtempcol name="IndReFactura"           type="bit"          mandatory="yes">
      <cf_dbtempcol name="RESNidCobrador"         type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETcontabiliza"          type="numeric"      mandatory="yes">
      <cf_dbtempcol name="ETfechaContabiliza"     type="datetime"     mandatory="no" >
      <cf_dbtempcol name="EnviadaElectronica"     type="bit"          mandatory="yes">
      <cf_dbtempcol name="FechaEnvioElectronica"  type="datetime"     mandatory="no" >
      <cf_dbtempcol name="idEncabezadoInterfaz"   type="numeric"      mandatory="no" >
      <cf_dbtempcol name="NumeroInterfaz"         type="numeric"      mandatory="no" >
      <cf_dbtempcol name="ETgeneraVuelto"         type="bit"          mandatory="yes">
      <cf_dbtempcol name="CodSistemaExt"          type="varchar(15)"  mandatory="no" >
        

      <!--- Indices --->
      <cf_dbtempindex cols="ETnumero,FCid">
      <cf_dbtempindex cols="Ecodigo,ETlote">
      <cf_dbtempindex cols="Ecodigo,ETserie,ETdocumento">
      <cf_dbtempindex cols="Tid,Ecodigo">
      <cf_dbtempindex cols="ETdocumento">
                    
    </cf_dbtemp>
    <cfset Arguments.TemporalesProcesoPosteo.tempETransacciones = _tempETransacciones>

    <!--- DTransacciones --->
    <cf_dbtemp name="tempDTransacciones#uid#" returnvariable="_tempDTransacciones" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="DTlinea"    type="numeric" mandatory="yes">
      <cf_dbtempcol name="FCid"       type="numeric" mandatory="yes">
      <cf_dbtempcol name="ETnumero"   type="numeric" mandatory="yes">
      <cf_dbtempcol name="Ecodigo"    type="int"     mandatory="yes">
      <cf_dbtempcol name="DTtipo"     type="char(1)" mandatory="yes">
      <cf_dbtempcol name="Aid"        type="numeric" mandatory="no">
      <cf_dbtempcol name="Alm_Aid"    type="numeric" mandatory="no">
      <cf_dbtempcol name="Ccuenta"    type="numeric" mandatory="yes">
      <cf_dbtempcol name="Ccuentades" type="numeric" mandatory="no">
      <cf_dbtempcol name="Cid"        type="numeric" mandatory="no">
      <cf_dbtempcol name="FVid"       type="numeric" mandatory="no">
      <cf_dbtempcol name="Dcodigo"    type="int"     mandatory="yes">
      <cf_dbtempcol name="DTfecha"    type="datetime" mandatory="yes">
      <cf_dbtempcol name="DTcant"     type="float"    mandatory="yes">
      <cf_dbtempcol name="DTpreciou"  type="money"    mandatory="yes">
      <cf_dbtempcol name="DTdeslinea" type="money"    mandatory="yes">
      <cf_dbtempcol name="DTtotal"    type="money"    mandatory="yes">
      <cf_dbtempcol name="DTborrado"  type="bit"      mandatory="yes">
      <cf_dbtempcol name="DTdescripcion"  type="varchar(255)"  mandatory="yes">
      <cf_dbtempcol name="DTdescalterna"  type="varchar(255)"  mandatory="no">
      <cf_dbtempcol name="DTlineaext"     type="varchar(30)"   mandatory="no">
      <cf_dbtempcol name="DTcodigoext"    type="varchar(30)"   mandatory="no">
      <cf_dbtempcol name="DTreclinea"     type="money"         mandatory="no">
      <cf_dbtempcol name="CFid"           type="numeric"       mandatory="no">
      <cf_dbtempcol name="Ocodigo"        type="int"           mandatory="no">
      <cf_dbtempcol name="CFcuenta"       type="numeric"       mandatory="no">
      <cf_dbtempcol name="DTimpuesto"     type="money"         mandatory="no">
      <cf_dbtempcol name="Icodigo"        type="char(5)"       mandatory="no">
      <cf_dbtempcol name="DcuentaT"       type="numeric"       mandatory="no">
      <cf_dbtempcol name="DesTransitoria" type="bit"           mandatory="yes">
      <cf_dbtempcol name="NC_DTlinea"     type="numeric"       mandatory="no">
      <cf_dbtempcol name="NC_Ecostou"     type="float"         mandatory="no">
      <cf_dbtempcol name="DTestado"       type="varchar(1)"    mandatory="no">
      <cf_dbtempcol name="DTmotivoAnul"   type="varchar(255)"  mandatory="no">
      <cf_dbtempcol name="DTfechaAnul"    type="datetime"      mandatory="no">
      <cf_dbtempcol name="CFComplemento"  type="varchar(100)"  mandatory="no">
      <cf_dbtempcol name="FPAEid"         type="numeric"       mandatory="no">
      <cf_dbtempcol name="DTExterna"      type="char(1)"       mandatory="no">
      <cf_dbtempcol name="ProntoPagoCliente"      type="money" mandatory="no">
      <cf_dbtempcol name="ProntoPagoClienteCheck" type="bit"   mandatory="yes">
      <cf_dbtempcol name="MontoAnulado"   type="money"         mandatory="no">
      <cf_dbtempcol name="DTIdKardex"     type="numeric"       mandatory="no">
      <cf_dbtempcol name="ETnumeroTemp"   type="numeric"       mandatory="no">
      <cf_dbtempcol name="CodODI"         type="varchar(25)"   mandatory="no">
      <cf_dbtempcol name="idEncabezadoInterfaz"   type="numeric" mandatory="no">
      <cf_dbtempcol name="idDetalleInterfaz"      type="numeric" mandatory="no">
      <cf_dbtempcol name="codProducto"    type="varchar(5)"    mandatory="no">
      <cf_dbtempcol name="codEmpresa"     type="varchar(5)"    mandatory="no">
      <!--- Indices --->
      <cf_dbtempindex cols="DTlinea">
      <cf_dbtempindex cols="ETnumero,FCid">
      <cf_dbtempindex cols="Aid">
      <cf_dbtempindex cols="Alm_Aid">
      <cf_dbtempindex cols="DTtipo">
    </cf_dbtemp>
    <cfset Arguments.TemporalesProcesoPosteo.tempDTransacciones = _tempDTransacciones>

    <!--- FPagos --->
    <cf_dbtemp name="tempFPagos#uid#" returnvariable="_tempFPagos" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="FPlinea"      type="numeric"  mandatory="yes">
      <cf_dbtempcol name="FCid"         type="numeric"  mandatory="yes">
      <cf_dbtempcol name="ETnumero"     type="numeric"  mandatory="yes">
      <cf_dbtempcol name="Mcodigo"      type="numeric(8,0)"  mandatory="yes">
      <cf_dbtempcol name="FPtc"         type="float"    mandatory="yes">
      <cf_dbtempcol name="FPmontoori"   type="money"    mandatory="yes">
      <cf_dbtempcol name="FPmontolocal" type="money"    mandatory="yes">
      <cf_dbtempcol name="FPfechapago"  type="datetime" mandatory="yes">
      <cf_dbtempcol name="Tipo"         type="char(1)"  mandatory="yes">
      <cf_dbtempcol name="FPdocnumero"  type="varchar(50)"  mandatory="no">
      <cf_dbtempcol name="FPdocfecha"   type="datetime" mandatory="no">
      <cf_dbtempcol name="FPBanco"      type="numeric"  mandatory="no">
      <cf_dbtempcol name="FPCuenta"     type="numeric"  mandatory="no">
      <cf_dbtempcol name="FPtipotarjeta"   type="varchar(30)"  mandatory="no">
      <cf_dbtempcol name="FPautorizacion"  type="varchar(50)"  mandatory="no">
      <cf_dbtempcol name="TPid"         type="int"      mandatory="no">
      <cf_dbtempcol name="MLid"         type="numeric"  mandatory="no">
      <cf_dbtempcol name="FPagoDoc"     type="money"    mandatory="no">
      <cf_dbtempcol name="FPfactorConv" type="float"    mandatory="no">
      <cf_dbtempcol name="FPVuelto"     type="money"    mandatory="no">
      <cf_dbtempcol name="ETnumeroTemp" type="numeric"  mandatory="no">
      <cf_dbtempcol name="ERid"         type="numeric"  mandatory="no">
      <cf_dbtempindex cols="FPlinea">
      <cf_dbtempindex cols="ETnumero,FCid">
    </cf_dbtemp>
    <cfset Arguments.TemporalesProcesoPosteo.tempFPagos = _tempFPagos>

    <!--- Pagos, Guarda de forma temporal lo pagos generados --->
    <cf_dbtemp name="tempPagos#uid#" returnvariable="_tempPagos" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="Ecodigo"    type="numeric"     mandatory="yes">
      <cf_dbtempcol name="Pcodigo"    type="varchar(20)" mandatory="yes">
      <cf_dbtempcol name="CCTcodigo"  type="varchar(2)"  mandatory="yes">
      <cf_dbtempcol name="TotalAnticipos"         type="money)" 	       mandatory="false" default="0">
			<cf_dbtempcol name="TotalCubierto"          type="money" 	         mandatory="false" default="0">
			<cf_dbtempcol name="DiferenciaEnc"          type="money" 	         mandatory="false" default="0">
      <cf_dbtempindex cols="Ecodigo,Pcodigo,CCTcodigo">
    </cf_dbtemp>
    <cfset Arguments.TemporalesProcesoPosteo.tempPagos = _tempPagos>

    <!--- tablas de inventario --->
    <!--- Tabla sobre la que se hacen todos los calculos --->
    <cfset Arguments.TemporalesProcesoPosteo.tempInventario  = getInventarioTable(Arguments.Conexion)>
    <!--- tabla  la que se pasan los datos antes de insertar el kardex para garantizar el orden por identity --->
    <cfset Arguments.TemporalesProcesoPosteo.tempInventario2 = getInventarioTable(Arguments.Conexion,false,'_')>
    <!--- ver mas detalles en IN_PosteoLin_Masivo --->

    <cfreturn Arguments.TemporalesProcesoPosteo>
  </cffunction> <!--- fin de: crearTemporales_posteo_documentosFA --->


  <cffunction name="getInventarioTable" access="private" returntype="String">
    <cfargument name="Conexion" type="string" required="true">
    <cfargument name="usaIdentity" type="boolean" required="false" default="true">
    <cfargument name="consecutivo" type="string" required="false" default="">
    <!--- Tabla temporal para Posteo de Inventario --->
    <cf_dbtemp name="tempInventario#uid##Arguments.consecutivo#" returnvariable="_tempInventario" datasource="#Arguments.Conexion#">
      <cf_dbtempcol name="id"                type="numeric"      mandatory="yes" identity="#Arguments.usaIdentity#"><!--- identity --->        
      <cf_dbtempcol name="Aid"               type="numeric"      mandatory="yes"> <!--- id del articulo --->
      <cf_dbtempcol name="Alm_Aid"           type="numeric"      mandatory="yes"> <!--- id del almacen --->
      <cf_dbtempcol name="Tipo_Mov"          type="varchar(1)"   mandatory="yes"> <!--- Tipo de Movimiento (E=Entrada, S=Salida, R=Requisicion, M=Movimiento Interalmacen, I=Inventario Físico, A=Ajuste) --->
      <cf_dbtempcol name="Cantidad"          type="numeric"      mandatory="yes"> <!--- Cantidad de Movimiento --->
      <cf_dbtempcol name="ObtenerCosto"      type="bit"          mandatory="yes"> <!--- Obtener o modificar costo --->
      <cf_dbtempcol name="McodigoOrigen"     type="numeric"      mandatory="yes"> <!--- Moneda Origen --->
      <cf_dbtempcol name="insertarEnKardex"  type="bit"          mandatory="yes" > <!--- default="true"    hint="Insertar en el Kardex = AFECTAR INVENTARIO"  --->
      <cf_dbtempcol name="verificaPositivo"  type="bit"          mandatory="yes" > <!--- default="true"    hint="Verificar existencias y costos positivos"  --->

      <cf_dbtempcol name="CostoOrigen"       type="money"      mandatory="no" > <!--- default="0.00"    hint="Costo Total de la línea del Movimiento en Moneda Origen"--->
      <cf_dbtempcol name="CostoLocal"        type="money"      mandatory="no" > <!--- default="0.00"    hint="Costo Total de la línea del Movimiento en Moneda Local"--->
      <cf_dbtempcol name="tcOrigen"          type="money"      mandatory="no" > <!--- default="-1"      hint="Tipo Cambio Origen" --->
      <cf_dbtempcol name="tcValuacion"       type="money"      mandatory="no" > <!--- default="-1"      hint="Tipo Cambio Valuacion" --->
      <cf_dbtempcol name="Tipo_ES"           type="varchar(1)"   mandatory="no" > <!--- default="E"       hint="Tipo Entrada Salida (E=Entrada, S=Salida)" --->
      <cf_dbtempcol name="CFid"              type="numeric"      mandatory="no" > <!--- default="0"       hint="id del Centro Funcional" --->
      <cf_dbtempcol name="Dcodigo"           type="numeric"      mandatory="no" > <!--- default="0"       hint="id del Departamento" --->
      <cf_dbtempcol name="Ocodigo"           type="numeric"      mandatory="no" > <!--- default="0"       hint="id del Oficina"  --->
      <cf_dbtempcol name="TipoCambio"        type="money"      mandatory="no" > <!--- default="1"       hint="Tipo de Cambio utilizado"  --->
      <cf_dbtempcol name="TipoDoc"           type="varchar(2)"   mandatory="no" > <!--- default=""        hint="Tipo de Transacción CXC"  --->
      <cf_dbtempcol name="Documento"         type="varchar(20)"  mandatory="no" > <!--- default=""        hint="Documento"  --->
      <cf_dbtempcol name="FechaDoc"          type="datetime"     mandatory="no" > <!--- default="#Now()#" hint="Fecha del Documento"  --->
      <cf_dbtempcol name="Referencia"        type="varchar(25)"  mandatory="no" > <!--- default=""        hint="Referencia"  --->
      <cf_dbtempcol name="ERid"              type="numeric"      mandatory="no" > <!--- default="0"       hint="Id del Histórico de Requisiciones"  --->
      <cf_dbtempcol name="Ecodigo"           type="numeric"      mandatory="no" > <!--- default="#session.Ecodigo#"  hint="Empresa" --->
      <cf_dbtempcol name="EcodigoRequi"      type="numeric"      mandatory="no" > <!--- default="#session.Ecodigo#   hint="EmpresaIntercompany" --->
      <cf_dbtempcol name="FPAEid"            type="numeric"      mandatory="no" > <!--- default="-1"      hint="ID de la Actividad empresarial" --->
      <cf_dbtempcol name="CFComplemento"     type="varchar(100)" mandatory="no" > <!--- default=""        hint="Complemento de la Actividad empresarial"--->
      <cf_dbtempcol name="DSlinea"           type="numeric"      mandatory="no" > <!--- default="-1"      hint="Id de la Solicitud de Compra" --->
      <cf_dbtempcol name="CFcuenta"          type="numeric"      mandatory="no" > <!--- default="-1"      hint="Cuenta Finaciera que se afecto en la requisicion" --->
      <cf_dbtempcol name="DDlinea"           type="numeric"      mandatory="no" > <!--- default="-1"      hint="ID del detalle de la Factura de CxP" --->

      <!--- Columnas adicionales para guardar informacion temporal durante el calculo masivo --->
      <cf_dbtempcol name="Local_Mcodigo"     type="numeric"      mandatory="no" > <!--- Mcodigo de la empresa logueada(local) --->
      <cf_dbtempcol name="Local_TC"          type="money"        mandatory="no" > <!--- Tipo de cambio de la empresa logueada(local) --->
      <cf_dbtempcol name="Local_costo"       type="money"        mandatory="no" > <!--- Costo del articulo en moneda local --->
      <cf_dbtempcol name="Valuacion_Mcodigo" type="numeric"      mandatory="no" > <!--- Mcodigo configurado para valuacion en Parametros(Pcodigo=441) --->
      <cf_dbtempcol name="Valuacion_TC"      type="money"        mandatory="no" > <!--- Tipo dde cambio utilizado para realizar la valuacion --->
      <cf_dbtempcol name="Valuacion_costo"   type="money"        mandatory="no" > <!--- Costo del articulo valuacion --->
      <cf_dbtempcol name="DTlinea"           type="numeric"      mandatory="yes"> <!--- DTlinea para obtener de forma masiva el idKarrdex insertado, Si se desea adaptar el proceso para inserciones NO masivas se debe obtener el identity insertado en IN_PosteoLin_Masivo y esta columna no seria requerida.--->
      <cf_dbtempcol name="idKardex"          type="numeric"      mandatory="no" > <!--- id del kardex --->
      
      <!---Indices--->
      <cf_dbtempcol name="LvarCostoLocalSinRedondear" type="money" mandatory="no">        
      <cf_dbtempindex cols="Aid,Alm_Aid,Ecodigo">        
      <cf_dbtempindex cols="CFid,EcodigoRequi">
      <cf_dbtempindex cols="Ocodigo,EcodigoRequi">
      <cf_dbtempindex cols="Dcodigo,EcodigoRequi">
      <cf_dbtempindex cols="TipoCambio">     
      <cf_dbtempindex cols="ERid,Ecodigo">
      <cf_dbtempindex cols="Valuacion_TC">    
      <cf_dbtempindex cols="DTlinea">             
    </cf_dbtemp>
    <cfreturn _tempInventario>
  </cffunction>

  <!------------------------------------------------------------------------------------------------------------------>

  <!--- pasa informacion de las tablas transaccionales a las temporales para poder hacer el posteo.
        puede ser a partir de un numero de lote (ETransacciones.ETlote) o bien se recibe un ETnumero
        y un FCid para cargar unicamente un documento--->
  <cffunction name="llenarTemporales_posteo_documentosFA" access="public">
    <cfargument name="Ecodigo"                  type="numeric" >
    <cfargument name="Conexion"                 type="string"  >
    <cfargument name="TemporalesProcesoPosteo"  type="struct"  >
    <cfargument name="TipoAplicacion"           type="string"  > <!--- Linea, Lote, Bloques --->
    <cfargument name="ETnumero"                 type="numeric" required="false">
    <cfargument name="FCid"                     type="numeric" required="false">
    <cfargument name="NumeroLote"               type="string"  required="false">
    <cfargument name="IDProcesamiento"          type="numeric" required="false">

    <!--- validaciones triviales --->
    <cfswitch expression="#Arguments.TipoAplicacion#">
      <cfcase value="Lineal">
        <cfif not isDefined('Arguments.ETnumero') or not isDefined('Arguments.FCid')>
          <cfthrow message="Se indico un llenado de las temporales para un documento, sin embargo, no se indico el ETnumero y el FCid">
        </cfif>
      </cfcase>
      <cfcase value="Lote">
        <cfif not isDefined('Arguments.NumeroLote') or not Len(Trim(Arguments.NumeroLote))>
          <cfthrow message="Se indico un llenado de tablas masivo por lotes, sin embargo no se indico el NumeroLote (ETlote)">
        </cfif>
      </cfcase>
      <cfcase value="Bloques">
        <cfif not isDefined('Arguments.IDProcesamiento')>
          <cfthrow message="Se indico un llenado de tablas masivo por bloque, pero no se indico el IDProcesamiento">
        </cfif>
      </cfcase>
    </cfswitch>

    <!--- ETransacciones --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      insert into #Arguments.TemporalesProcesoPosteo.tempETransacciones#(
        FCid,ETnumero,Ecodigo,Ocodigo,SNcodigo,Mcodigo,ETtc,CCTcodigo,Ccuenta,Tid,FACid,ETfecha,ETtotal,ETestado,Usucodigo,
        Ulocalizacion,Usulogin,ETporcdes,ETmontodes,ETimpuesto,ETnumext,ETnombredoc,ETobs,ETdocumento,ETserie,
        IDcontable,ETimpresa,CFid,ETnotaCredito,CDCcodigo,ETmes,ETnumero_generado,ETperiodo,
        id_direccion,ETobservacion,SNcodigo2,ETlote,ETexterna,Rcodigo,ETesLiquidacion,ETmontoRetencion,
        IndReFactura,RESNidCobrador,ETcontabiliza,ETfechaContabiliza,EnviadaElectronica,FechaEnvioElectronica,
        idEncabezadoInterfaz,NumeroInterfaz,ETgeneraVuelto,CodSistemaExt)
      select et.FCid,et.ETnumero,et.Ecodigo,et.Ocodigo,et.SNcodigo,et.Mcodigo,et.ETtc,et.CCTcodigo,et.Ccuenta,
             et.Tid,et.FACid,et.ETfecha,et.ETtotal,et.ETestado,et.Usucodigo,et.Ulocalizacion,et.Usulogin,
             et.ETporcdes,et.ETmontodes,et.ETimpuesto,et.ETnumext,et.ETnombredoc,et.ETobs,et.ETdocumento,
             et.ETserie,et.IDcontable,et.ETimpresa,et.CFid,et.ETnotaCredito,et.CDCcodigo,et.ETmes,
             et.ETnumero_generado,et.ETperiodo,et.id_direccion,et.ETobservacion,et.SNcodigo2,et.ETlote,
             et.ETexterna,et.Rcodigo,et.ETesLiquidacion,et.ETmontoRetencion,et.IndReFactura,et.RESNidCobrador,
             et.ETcontabiliza,et.ETfechaContabiliza,et.EnviadaElectronica,et.FechaEnvioElectronica,
             et.idEncabezadoInterfaz,et.NumeroInterfaz,et.ETgeneraVuelto,et.CodSistemaExt
      from ETransacciones et
      <cfswitch expression="#Arguments.TipoAplicacion#">
        <cfcase value="Lineal">
          where et.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
        </cfcase>
        <cfcase value="Lote">
          where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroLote#">
            and et.ETestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="T">
          order by et.Tid,et.Ecodigo <!--- Sumamente importante pues se generan identities que son importantes para obtener el numero de documento del talonario --->
        </cfcase>
        <cfcase value="Bloques">
          where exists( select 1 from #T_IE748# ie
                        inner join #T_IE748E# iee
                          on ie.ID = iee.ID
                        where ie.ID = et.idEncabezadoInterfaz
                          and et.NumeroInterfaz = 748
                          and iee.IDProcesamiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDProcesamiento#">
                          and iee.Estado = 'X')
          order by et.Tid,et.Ecodigo <!--- Sumamente importante pues se generan identities que son importantes para obtener el numero de documento del talonario --->
        </cfcase>
        <cfdefaultcase>
          , <!--- Esto nunca deberia pasar --->
        </cfdefaultcase>
      </cfswitch>
    </cfquery>     
      
    <!--- DTransacciones --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      insert into #Arguments.TemporalesProcesoPosteo.tempDTransacciones#(DTlinea,FCid,ETnumero,Ecodigo,DTtipo,
        Aid,Alm_Aid,Ccuenta,Ccuentades,Cid,FVid,Dcodigo,DTfecha,DTcant,DTpreciou,DTdeslinea,DTtotal,DTborrado,
        DTdescripcion,DTdescalterna,DTlineaext,DTcodigoext,DTreclinea,CFid,Ocodigo,CFcuenta,DTimpuesto,
        Icodigo,DcuentaT,DesTransitoria,NC_DTlinea,NC_Ecostou,DTestado,DTmotivoAnul,DTfechaAnul,CFComplemento,
        FPAEid,DTExterna,ProntoPagoCliente,ProntoPagoClienteCheck,MontoAnulado,DTIdKardex,ETnumeroTemp,CodODI,
        idEncabezadoInterfaz,idDetalleInterfaz,codProducto,codEmpresa)
      select dt.DTlinea,dt.FCid,dt.ETnumero,dt.Ecodigo,dt.DTtipo,dt.Aid,dt.Alm_Aid,dt.Ccuenta,dt.Ccuentades,
      dt.Cid,dt.FVid,dt.Dcodigo,dt.DTfecha,dt.DTcant,dt.DTpreciou,dt.DTdeslinea,dt.DTtotal,dt.DTborrado,
      dt.DTdescripcion,dt.DTdescalterna,dt.DTlineaext,dt.DTcodigoext,dt.DTreclinea,dt.CFid,dt.Ocodigo,
      dt.CFcuenta,dt.DTimpuesto,dt.Icodigo,dt.DcuentaT,dt.DesTransitoria,dt.NC_DTlinea,dt.NC_Ecostou,
      dt.DTestado,dt.DTmotivoAnul,dt.DTfechaAnul,dt.CFComplemento,dt.FPAEid,dt.DTExterna,dt.ProntoPagoCliente,
      dt.ProntoPagoClienteCheck,dt.MontoAnulado,dt.DTIdKardex,dt.ETnumeroTemp,dt.CodODI,dt.idEncabezadoInterfaz,
      dt.idDetalleInterfaz,dt.codProducto,dt.codEmpresa
      from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
      inner join DTransacciones dt
        on et.ETnumero = dt.ETnumero
       and et.FCid  = dt.FCid
       <cfswitch expression="#Arguments.TipoAplicacion#">
         <cfcase value="Lineal">
            where et.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
         </cfcase>
         <cfcase value="Lote">
            where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroLote#">
         </cfcase>
         <cfcase value="Bloques">
           where exists( select 1 from #T_IE748# ie
                        inner join #T_IE748E# iee
                          on ie.ID = iee.ID
                        where ie.ID = et.idEncabezadoInterfaz
                          and et.NumeroInterfaz = 748
                          and iee.IDProcesamiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDProcesamiento#">
                          and iee.Estado = 'X')
         </cfcase>
         <cfdefaultcase>
           , <!--- Esto nunca deberia pasar --->
         </cfdefaultcase>
       </cfswitch>
    </cfquery>

    <!--- FPagos --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      insert into #Arguments.TemporalesProcesoPosteo.tempFPagos#(FPlinea,FCid,ETnumero,Mcodigo,FPtc,
          FPmontoori,FPmontolocal,FPfechapago,Tipo,FPdocnumero,FPdocfecha,FPBanco,FPCuenta,FPtipotarjeta,
          FPautorizacion,TPid,MLid,FPagoDoc,FPfactorConv,FPVuelto,ETnumeroTemp,ERid)
      select fp.FPlinea,fp.FCid,fp.ETnumero,fp.Mcodigo,fp.FPtc,fp.FPmontoori,fp.FPmontolocal,
             fp.FPfechapago,fp.Tipo,fp.FPdocnumero,fp.FPdocfecha,fp.FPBanco,fp.FPCuenta,
             fp.FPtipotarjeta,fp.FPautorizacion,fp.TPid,fp.MLid,fp.FPagoDoc,fp.FPfactorConv,
             fp.FPVuelto,fp.ETnumeroTemp,fp.ERid
      from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
      inner join FPagos fp
        on fp.ETnumero = et.ETnumero
       and fp.FCid = et.FCid
       <cfswitch expression="#Arguments.TipoAplicacion#">
         <cfcase value="Lineal">
            where et.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
         </cfcase>
         <cfcase value="Lote">
            where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroLote#">
         </cfcase>
         <cfcase value="Bloques">
           where exists( select 1 from #T_IE748# ie
                        inner join #T_IE748E# iee
                          on ie.ID = iee.ID
                        where ie.ID = et.idEncabezadoInterfaz
                          and et.NumeroInterfaz = 748
                          and iee.IDProcesamiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDProcesamiento#">
                          and iee.Estado = 'X')
         </cfcase>
         <cfdefaultcase>
           , <!--- Esto nunca deberia pasar --->
         </cfdefaultcase>
       </cfswitch>
    </cfquery>

    <!--- Validar que el lote tenga facturas y todas las facturas tengan almenos un detalle --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      select 1 from #Arguments.TemporalesProcesoPosteo.tempETransacciones#
    </cfquery>
    <cfif not rs.recordCount>
      <cfthrow message="No se encontro ninguna factura para el Lote: #Arguments.NumeroLote#">
    </cfif>
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      select et.ETnumero from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
      where coalesce((select count(1) from #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
             where et.ETnumero = dt.ETnumero and et.FCid = dt.FCid),0) = 0
    </cfquery>
    <cfif rs.recordCount>
      <cfthrow message="Las siguientes facturas no tienen detalles, Proceso cancelado, ETnumero(s):#valueList(rs.ETnumero)#">
    </cfif>

  </cffunction> <!--- fin de: llenarTemporales_posteo_documentosFA --->

  <!------------------------------------------------------------------------------------------------------------------>

  <!--- Funcion masiva que recibe un lote y una estructura con las tablas temporales de
        ETransacciones, DTransacciones y FPagos --->
  <cffunction name="posteo_documentosFA_Masiva" access="public" output="false">
    <cfargument name='Ecodigo'                   type='numeric'  required="true">
    <cfargument name="Usuario"                   type="string"   required="true">
    <cfargument name="Usucodigo"                 type="numeric"  required="true">
    <cfargument name='Conexion'                  type='string'   required="true">
    <cfargument name="PeriodoAuxiliares"         type="numeric"  required="true">
    <cfargument name="MesAuxiliares"             type="numeric"  required="true">
    <cfargument name="TemporalesProcesoPosteo"   type="struct"   required="true">

    <cfinvoke method="posteo_documentosFA_private">
      <cfinvokeargument name="Ecodigo" 	                 value="#Arguments.Ecodigo#">
      <cfinvokeargument name="Usuario"                   value="#Arguments.Usuario#">
      <cfinvokeargument name="Usucodigo"                 value="#Arguments.Usucodigo#">
			<cfinvokeargument name="Conexion" 	               value="#Arguments.Conexion#">
      <cfinvokeargument name="PeriodoAuxiliares"         value="#Arguments.PeriodoAuxiliares#">
      <cfinvokeargument name="MesAuxiliares"             value="#Arguments.MesAuxiliares#">
      <cfinvokeargument name="TemporalesProcesoPosteo"   value="#Arguments.TemporalesProcesoPosteo#">
    </cfinvoke>

  </cffunction><!--- fin de: posteo_documentosFA_Masiva --->

  <!------------------------------------------------------------------------------------------------------------------>

  <!--- funcion privada para la aplicacion de lote (Posteo masivo de facturas) --->
  <cffunction name="posteo_documentosFA_private" access="private" output="false">
    <cfargument name='Ecodigo'                   type='numeric'  required="true">
    <cfargument name="Usuario"                   type="string"   required="true">
    <cfargument name="Usucodigo"                 type="numeric"  required="true">
    <cfargument name='Conexion'                  type='string'   required="true">
    <cfargument name="PeriodoAuxiliares"         type="numeric"  required="true">
    <cfargument name="MesAuxiliares"             type="numeric"  required="true">
    <cfargument name="TemporalesProcesoPosteo"   type="struct"   required="true">

                        <!--- Definicion de variables --->
                        <!------------------------------->

    <!--- Obtiene CCTcodigos segun el tipo de transacciones, los guarda en cache --->
    <cfquery name="rsCCTcodigoDeposito" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(1,0,0,0)#">
      select CCTcodigo from CCTransacciones where Ecodigo = #Arguments.Ecodigo# and CCTcktr = 'T' AND BTid is not null and CCTtipo = 'C'
    </cfquery>
    <cfquery name="rsCCTcodigoCheque" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(1,0,0,0)#">
      select CCTcodigo from CCTransacciones where Ecodigo = #Arguments.Ecodigo# and CCTcktr = 'C' and CCTtipo = 'C'
    </cfquery>
    <cfquery name="rsCCTcodigoTarjeta" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(1,0,0,0)#">
      select CCTcodigo from CCTransacciones where Ecodigo = #Arguments.Ecodigo# and CCTcktr = 'P' and CCTtipo = 'C'
    </cfquery>
    <cfquery name="rsCCTcodigoEfectivo" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(1,0,0,0)#">
      select CCTcodigo from CCTransacciones where Ecodigo = #Arguments.Ecodigo# and CCTcktr = 'E' and CCTtipo = 'C'
    </cfquery>
    <cfquery name="rsCCTcodigoDiferencia" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(1,0,0,0)#">
      select CCTcodigo from CCTransacciones where Ecodigo = #Arguments.Ecodigo# and CCTcktr = 'F' and CCTtipo = 'C'
    </cfquery>
    <!--- Obtiene parametro que determina si se debe validar existencia del documento en bancos --->
    <cfset rsValidarExisteBancos = consultaParametro(Arguments.Ecodigo, 'CC',15833,Arguments.Conexion)>
    <cfset rsParamCuentaDepositosTransito = consultaParametro(Arguments.Ecodigo, '',650,Arguments.Conexion)>

                        <!--- Validaciones preposteo --->
                        <!------------------------------->

    <!--- Transacciones con detalles --->
    <cfquery name="vrsDetalles" datasource="#Arguments.conexion#">
      Select a.ETnumero,
             coalesce(DTlinea, -1) as DTlinea,
             coalesce(SNid, -1) as SNid
      from #Arguments.TemporalesProcesoPosteo.tempETransacciones# a
        inner join #Arguments.TemporalesProcesoPosteo.tempDTransacciones# b
           on a.FCid     = b.FCid
          and a.ETnumero = b.ETnumero
        left join SNegocios s
           on a.Ecodigo  = s.Ecodigo
          and a.SNcodigo = s.SNcodigo
      where b.DTborrado <> 1
    </cfquery>
      
    <!--- Validar que las transacciones tengan detalles --->
    <cfquery name="vrs" dbtype="query">
      Select ETnumero
      from vrsDetalles
      where DTlinea = -1
    </cfquery>
    <cfif vrs.recordcount>
      <cfset mensajeError = "Los documentos " &  ValueList(vrs.ETnumero) & "no tienen detalle. Proceso Cancelado!">
			<cf_errorCode	code="-1" msg="#mensajeError#">
    </cfif>

    <!--- Validar el ID del socio de Negocios --->
    <cfquery name="vrs" dbtype="query">
      Select ETnumero
      from vrsDetalles
      where SNid = -1
    </cfquery>
    <cfif vrs.recordcount>
      <cfset mensajeError = "Los documentos " &  ValueList(vrs.ETnumero) & "no tienen definido un socio de negocio. Proceso Cancelado!">
      <cf_errorCode	code="-1" msg="#mensajeError#">
    </cfif>

    <!--- Validamos cuenta transitoria y para depositos --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
      select cb.CBcodigo, cb.CBdescripcion, cb.CBcc, b.Bdescripcion from #Arguments.TemporalesProcesoPosteo.tempFPagos# fp
      left join CuentasBancos cb
        on cb.CBid = fp.FPCuenta
      left join Bancos b
        on b.Bid = cb.Bid
      left join CFinanciera cf
        on cf.CFcuenta = cb.CFcuentaTransitoria
      where (cf.Ccuenta is null or cf.Ccuenta = 0)
        and fp.Tipo = 'D'
      <cf_isolation nivel="read_committed">
    </cfquery>
    <cfif rs.recordCount>
      <cfloop query="rs">
        <cfset MensajeError = 'No se han definido las siguientes cuentas transitorias. </br>'>
        <cfset MensajeError &= "Cuenta Bancaria: #rs.CBcc# con codigo: #rs.CBcodigo# y descripcion : #rs.CBdescripcion# del Banco: #rs.Bdescripcion# </br>">
      </cfloop>
      <cf_errorCode code="-1" msg="#MensajeError#">
    </cfif>

    <!--- Validar cuenta de descuento y complementeo de la caja y ETmontodes es distinto a 0 --->
    <cfquery name="vrsCuentas" datasource="#Arguments.Conexion#">
       select  distinct coalesce(a.Ccuentadesc,0) as Ccuentadesc,
               coalesce(a.FCcomplemento,'-1') as FCcomplemento,
               a.FCcodigo
       From #Arguments.TemporalesProcesoPosteo.tempETransacciones# e
        left join FCajas a
           on e.Ecodigo = a.Ecodigo
          and e.FCid    = a.FCid
        left join CFinanciera b
           on a.Ccuenta = b.Ccuenta
          and a.Ecodigo = b.Ecodigo
        left join CCTransacciones c
           on e.Ecodigo   = c.Ecodigo
          and e.CCTcodigo = c.CCTcodigo
          and e.ETmontodes <> 0
    </cfquery>
      
    <!--- Valida cuenta de descuento para las cajas --->
    <cfquery name="vrs" dbtype="query">
      Select FCcodigo
      From vrsCuentas
      Where Ccuentadesc = 0 and FCcomplemento = '-1'
    </cfquery>
    <cfif vrs.recordcount>
      <cfset mensajeError = "Error, no se han definido las Cuentas de Descuento para las Cajas (" &  ValueList(vrs.FCcodigo) & " ). Proceso Cancelado!">
      <cf_errorCode code="-1" msg="#mensajeError#">
    </cfif>

    <!--- Cuenta Transitoria Comun--->
    <cfset LvarCuentaTransitoriaGeneral = consultaParametro(Arguments.Ecodigo,'CG',565,Arguments.Conexion)>
    <cfif not len(trim(LvarCuentaTransitoriaGeneral.valor))>
        <cf_errorCode code="-1" msg="No se ha definido la Cuenta Transitoria Comun. En Parametros Adicionales / Facturacion. para la empresa Ecodigo:#Arguments.Ecodigo#!">
    </cfif>

    <!--- Obtener la moneda local --->
    <cfset rsMonedaLoc = MonedaLocal(Arguments.Ecodigo,Arguments.Conexion)>
    <cfset LvarMonloc = rsMonedaLoc.Mcodigo>

    <!--- Insertar en Documentos --->
    <cfquery datasource="#Arguments.Conexion#">
      Insert Documentos (FCid, CFid, ETnumero, Ecodigo, CCTcodigo,Ddocumento,  Ocodigo,  SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dsaldo, Dfecha, Dvencimiento,
            Ccuenta, Dtcultrev, Dusuario, Rcodigo, Dmontoretori, Dtref, Ddocref, DEdiasVencimiento, DEdiasMoratorio, TESDPaprobadoPendiente, EDtipocambioVal, EDtipocambioFecha,
            id_direccionFact, ETnombreDoc,DEobservacion,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen,DEidCobrador,DEidVendedor )

       Select
          a.FCid,      a.CFid,       a.ETnumero,  a.Ecodigo,   <cf_dbfunction name="to_char" args="a.CCTcodigo">,  <cf_dbfunction name="to_char" args="a.ETserie"> #_Cat# <cf_dbfunction name="to_char" args="a.ETdocumento">,
          a.Ocodigo,   a.SNcodigo,   a.Mcodigo,   a.ETtc,      a.ETtotal ,    a.ETtotal,
          case when coalesce(CCTvencim,0) = -1 then #now()# else a.ETfecha end,
          case when coalesce(CCTvencim,0) = -1
               then #now()#
               else coalesce(
                      (Select min(fe.FechaVencimientoPago)
                        From #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
                           inner join FADRecuperacion fd
                              on fd.DTlinea   = dt.DTlinea
                             and fd.Ecodigo   = dt.Ecodigo
                           inner join FAERecuperacion fe
                              on fe.FAERid   = fd.FAERid
                             and fe.Ecodigo  = fd.Ecodigo
                        Where dt.ETnumero = a.ETnumero
                          and dt.FCid     = a.FCid
                          and dt.Ecodigo  = a.Ecodigo
                       ),
                       dateadd(dd, coalesce(sn.SNplazocredito,0), a.ETfecha))
                end,
          case when coalesce(CCTvencim,0) = -1 then cj.Ccuenta else coalesce(sn.SNcuentacxc,a.Ccuenta) end,
          a.ETtc,   <cf_dbfunction name="to_char" args="a.Usucodigo">,
          case when a.Rcodigo <> null or a.Rcodigo <> '-1' then a.Rcodigo else null end,
          a.ETmontoRetencion, null, null, 0, 0, 0, a.ETtc, <cf_dbfunction name="now">, a.id_direccion,
          a.ETnombredoc, a.ETobs, a.CDCcodigo, SNcodigo2, ETlote, ETexterna, 0,
          coalesce(
            (Select min(res.DEid)
                   From #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
                      inner join FADRecuperacion fd
                         on fd.DTlinea   = dt.DTlinea
                        and fd.Ecodigo   = dt.Ecodigo
                      inner join FAERecuperacion fe
                         on fe.FAERid   = fd.FAERid
                        and fe.Ecodigo  = fd.Ecodigo
                      inner join RolEmpleadoSNegocios res
                         on fe.RESNidCobrador = res.RESNid
                   Where dt.ETnumero = a.ETnumero
                     and dt.FCid     = a.FCid
                     and dt.Ecodigo  = a.Ecodigo
              ),
             (select DEid from RolEmpleadoSNegocios resnT where resnT.RESNid = a.RESNidCobrador)),

          coalesce(
            (Select min(res.DEid)
                    From #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
                      inner join FADRecuperacion fd
                         on fd.DTlinea   = dt.DTlinea
                        and fd.Ecodigo   = dt.Ecodigo
                      inner join FAERecuperacion fe
                         on fe.FAERid   = fd.FAERid
                        and fe.Ecodigo  = fd.Ecodigo
                      inner join RolEmpleadoSNegocios res
                         on fe.RESNidVendedor = res.RESNid
                    Where dt.ETnumero = a.ETnumero
                     and dt.FCid     = a.FCid
                     and dt.Ecodigo  = a.Ecodigo
              ),
              coalesce(
                (Select min(res.DEid)
                    From #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
                      inner join RolEmpleadoSNegocios res
                         on dt.FVid = res.RESNid
                    Where dt.ETnumero = a.ETnumero
                      and dt.FCid     = a.FCid
                      and dt.Ecodigo  = a.Ecodigo
                      and dt.FVid is not null
                      and dt.DTborrado <> 1
                 ),null))
        From #Arguments.TemporalesProcesoPosteo.tempETransacciones# a
            inner join CCTransacciones b
               on a.Ecodigo = b.Ecodigo
              and a.CCTcodigo = b.CCTcodigo
            inner join SNegocios sn
               on a.SNcodigo = sn.SNcodigo
              and a.Ecodigo = sn.Ecodigo
            inner join FCajas cj
               on a.Ecodigo = cj.Ecodigo
              and a.FCid    = cj.FCid
            inner join CFinanciera cf
               on cj.Ccuenta = cf.Ccuenta
              and cj.Ecodigo = cf.Ecodigo
     </cfquery>

     <!--- Insercion en DDocumentos --->
     <cfquery datasource="#Arguments.Conexion#">
         Insert DDocumentos (Ecodigo,  CCTcodigo, Ddocumento, CCTRcodigo,  DRdocumento, DDlinea,  DDtotal, DDcodartcon, DDcantidad, DDpreciou, DDcostolin, DDdesclinea, DDtipo,DDescripcion,DDdescalterna,
                            Alm_Aid, Dcodigo, Ccuenta, CFid, Ocodigo,DTlinea, DcuentaT, DesTransitoria,FPAEid, CFComplemento,Icodigo, DDimpuesto)

         Select
           a.Ecodigo,
           a.CCTcodigo,
           a.ETserie #_Cat# <cf_dbfunction name="to_char" args="a.ETdocumento">,
           a.CCTcodigo, a.ETserie #_Cat# <cf_dbfunction name="to_char"  args="a.ETdocumento">,
           b.DTlinea,
           b.DTtotal,
           case when b.Aid is null then b.Cid else b.Aid end,
           b.DTcant,
           b.DTpreciou, 0.00, b.DTdeslinea, b.DTtipo, b.DTdescripcion, b.DTdescalterna, b.Alm_Aid,
           b.Dcodigo, b.Ccuenta, b.CFid, b.Ocodigo, b.DTlinea,
           Case when exists (Select 1
                             from #Arguments.TemporalesProcesoPosteo.tempFPagos# f
                             inner join Monedas m
                                on f.Mcodigo = m.Mcodigo
                             where f.FCid = a.FCid and f.ETnumero = a.ETnumero)
                then null
                else case 
                      when cf.CFACTransitoria = 1 
                      then coalesce(cf.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral.valor#) 
                      else null end
                end,
           Case when exists (Select 1
                             from #Arguments.TemporalesProcesoPosteo.tempFPagos# f
                             inner join Monedas m
                                 on f.Mcodigo = m.Mcodigo
                             where f.FCid = a.FCid and f.ETnumero = a.ETnumero)
                then 0
                else cf.CFACTransitoria end,
            b.FPAEid, b.CFComplemento,b.Icodigo, b.DTimpuesto
        from #Arguments.TemporalesProcesoPosteo.tempETransacciones# a
                inner join #Arguments.TemporalesProcesoPosteo.tempDTransacciones# b
               on a.FCid = b.FCid
              and a.ETnumero = b.ETnumero
              and a.Ecodigo = b.Ecodigo
              and b.DTborrado = 0
            inner join CFuncional cf
               on b.CFid = cf.CFid
     </cfquery>

    <!--- Insercion en HDocumentos. Copia de Documentos --->
    <cfquery datasource="#Arguments.Conexion#">
       insert into HDocumentos
       (  Ecodigo, CCTcodigo, Ddocumento, Ocodigo,SNcodigo, Mcodigo,Dtipocambio, Dtotal, EDdescuento, Dsaldo, Dfecha, Dvencimiento,Ccuenta,
         Dtcultrev, Dusuario,Rcodigo,Dmontoretori,  Dtref, Ddocref, Icodigo,Dreferencia,DEidVendedor,DEidCobrador,  DEdiasVencimiento,
         DEordenCompra,DEnumReclamo,  DEobservacion,DEdiasMoratorio,id_direccionFact, id_direccionEnvio, CFid,EDtipocambioFecha, EDtipocambioVal
         ,TESRPTCid,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc ,EDmes ,EDperiodo ,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen,CodSistemaExt
       )
       Select
         a.Ecodigo,            a.CCTcodigo,             a.Ddocumento,          a.Ocodigo,
         a.SNcodigo,           a.Mcodigo,               a.Dtipocambio,         a.Dtotal,
         b.ETmontodes,         a.Dsaldo,                a.Dfecha,              a.Dvencimiento,
         a.Ccuenta,            a.Dtcultrev,             a.Dusuario,            a.Rcodigo,
         a.Dmontoretori,       a.Dtref,                 a.Ddocref,             a.Icodigo,
         a.Dreferencia,        a.DEidVendedor,          a.DEidCobrador,        a.DEdiasVencimiento,
         a.DEordenCompra,      a.DEnumReclamo,          a.DEobservacion,       a.DEdiasMoratorio,
         a.id_direccionFact,   a.id_direccionEnvio,     a.CFid,                a.EDtipocambioFecha,
         a.EDtipocambioVal,    a.TESRPTCid,             a.TESRPTCietu,         a.FCid,
         a.ETnumero,           a.ETnombreDoc,           #Arguments.MesAuxiliares#, #Arguments.PeriodoAuxiliares#,
         a.CDCcodigo,          a.SNcodigoAgencia,       a.Dlote,               a.Dexterna,
         0.00,                 a.CodSistemaExt
       From Documentos a
         inner join #Arguments.TemporalesProcesoPosteo.tempETransacciones# b
            on a.FCid     = b.FCid
           and a.ETnumero = b.ETnumero
           and a.Ecodigo  = b.Ecodigo
         inner join CCTransacciones c
            on a.CCTcodigo = c.CCTcodigo
           and a.Ecodigo   = c.Ecodigo
      </cfquery>

      <!--- Insercion en HDDocumentos. Copia de DDocumentos --->
      <cfquery datasource="#session.dsn#">
        Insert into HDDocumentos
         (HDid,Ecodigo, CCTcodigo,Ddocumento, CCTRcodigo, DRdocumento, DDlinea, DDtotal, DDcodartcon, DDcantidad, DDpreciou,
          DDcostolin, DDdesclinea,DDtipo, DDescripcion,DDdescalterna, Alm_Aid,Dcodigo,Ccuenta,CFid,Icodigo,OCid, OCTid, OCIid,
          DDid,DocrefIM,CCTcodigoIM,cantdiasmora,ContractNo,DDimpuesto,DDdescdoc,Ocodigo,DcuentaT,DesTransitoria,DTlinea,CFComplemento
        )
        Select
          e.HDid,              d.Ecodigo,      d.CCTcodigo,     d.Ddocumento,       d.CCTRcodigo,
          d.DRdocumento,       d.DDlinea,      d.DDtotal,       d.DDcodartcon,      d.DDcantidad,
          d.DDpreciou,         d.DDcostolin,   d.DDdesclinea,   d.DDtipo,           d.DDescripcion,
          d.DDdescalterna,     d.Alm_Aid,      d.Dcodigo,       d.Ccuenta,          d.CFid,
          d.Icodigo,           d.OCid,         d.OCTid,         d.OCIid,            d.DDid,
          d.DocrefIM,          d.CCTcodigoIM,  d.cantdiasmora,  d.ContractNo,
          coalesce(d.DDimpuesto,0),0.00,
          d.Ocodigo,d.DcuentaT,d.DesTransitoria,d.DTlinea,d.CFComplemento
         From DDocumentos d
          inner join Documentos b
            on b.Ecodigo    = d.Ecodigo
           and b.CCTcodigo  = d.CCTcodigo
           and b.Ddocumento = d.Ddocumento
          inner join #Arguments.TemporalesProcesoPosteo.tempETransacciones# f
             on b.FCid     = f.FCid
            and b.ETnumero = f.ETnumero
            and b.Ecodigo  = f.Ecodigo
          inner join HDocumentos e
             on b.FCid     = e.FCid
            and b.ETnumero = e.ETnumero
            and b.Ecodigo  = e.Ecodigo
        </cfquery>

        <!--- Parametro para determinar si la empresa utiliza control de inventario --->
        <cfquery name="rsParamEmpresaManejaControlInventarios" datasource="#Arguments.Conexion#" cachedwithin="#createTimeSpan(0,1,0,0)#">
          select Pvalor from Parametros
          where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="15835">
          <cf_isolation nivel="read_committed">
        </cfquery>

        <!--- Si se maneja control de inventario, realiza la afectacion correspondiente en el modulo de inventario --->
        <cfif rsParamEmpresaManejaControlInventarios.recordCount and rsParamEmpresaManejaControlInventarios.Pvalor EQ 1>

            <!--- actualizamos el costo del articulo a la hora de la salida --->
            <cfquery datasource="#Arguments.Conexion#">
              update #Arguments.TemporalesProcesoPosteo.tempDTransacciones#
                set NC_Ecostou = (select exi.Ecostou from Existencias exi
                                  where exi.Aid = #Arguments.TemporalesProcesoPosteo.tempDTransacciones#.Aid
                                    and exi.Alm_Aid = #Arguments.TemporalesProcesoPosteo.tempDTransacciones#.Alm_Aid)
              where DTtipo = 'A'
                and DTborrado = 0
            </cfquery>

            <!--- PENDIENTE: POSTEO DE INVENTARIO --->
            <!--- 1. Obtiene un id de kardex por Detalle: <cfset IDKARDEX     = LobjINV.CreaIdKardex(session.dsn)>
                  2. Realiza el posteo de inventario
                  3. Actualizar DTransacciones con el Id de Kardex que le corresponde.
                      update DTransacciones set DTIdKardex =  #IN_PosteoLin_Ret.KARDEX.IDENTITY#
             --->

            <!--- llenamos la tabla temporal con los datos para realizar el posteo de inventario de forma masiva --->
            <cfquery datasource="#Arguments.Conexion#">
               insert into #Arguments.TemporalesProcesoPosteo.tempInventario#(Aid,Alm_Aid,Tipo_Mov,Cantidad,McodigoOrigen,
                            Tipo_ES,Dcodigo,Ocodigo,TipoDoc,Documento,Referencia,FechaDoc,tcValuacion,TipoCambio,tcOrigen,
                            Ecodigo,CostoOrigen,CostoLocal,ObtenerCosto,insertarEnKardex,verificaPositivo,CFid,ERid,EcodigoRequi,
                            FPAEid,CFComplemento,DSlinea,CFcuenta,DDlinea,LvarCostoLocalSinRedondear,DTlinea)
               select dt.Aid,
                      dt.Alm_Aid,
                      'S' as Tipo_Mov,
                      dt.DTcant as Cantidad,
                      et.Mcodigo as McodigoOrigen,
                      'S' as Tipo_ES,
                      dt.Dcodigo,
                      et.Ocodigo,
                      coalesce(et.CCTcodigo,'') as TipoDoc,
                      et.ETserie #_Cat# <cf_dbfunction name="to_char"  args="et.ETdocumento"> as Documento,
                      'FA' as Referencia,
                      et.ETfecha as FechaDoc,
                      et.ETtc/1.00 as tcValuacion,
                      et.ETtc/1.00 as TipoCambio,
                      et.ETtc/1.00 as tcOrigen,
                      #Arguments.Ecodigo# as Ecodigo,
                      0 as CostoOrigen, 
                      0 as CostoLocal, 
                      1 as ObtenerCosto,
                      1 as insertarEnKardex,
                      1 as verificaPositivo,
                      <!--- Columnas NO rerqueridas --->
                      0 as CFid,0 as ERid,#Arguments.Ecodigo# as EcodigoRequi,
                      -1 as FPAEid,'' as CFComplemento,-1 as DSlinea,-1 as CFcuenta,-1 as DDlinea,
                      <!--- Columnas adicionales para el procesamiento --->
                      0 as LvarCostoLocalSinRedondear,
                      dt.DTlinea <!--- DTlinea para guardar en el Kardex --->
                from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et 
                inner join #Arguments.TemporalesProcesoPosteo.tempDTransacciones# dt
                  on et.ETnumero = dt.ETnumero
                 and et.FCid = dt.FCid
                inner join CCTransacciones ct
                  on et.Ecodigo = ct.Ecodigo
                 and et.CCTcodigo = ct.CCTcodigo
               where dt.DTtipo = 'A'
                 and dt.DTborrado = 0
            </cfquery>
      
            <!--- Invocacion del posteo de inventario --->
            <cfinvoke component="IN_PosteoLin_Masivo" method="IN_PosteoLin_Masiva" returnvariable="_tableResultInventario">
              <cfinvokeargument name="Ecodigo"          value="#Arguments.Ecodigo#">
              <cfinvokeargument name="TablaInventario"  value="#Arguments.TemporalesProcesoPosteo.tempInventario#">
              <cfinvokeargument name="TablaInventario2" value="#Arguments.TemporalesProcesoPosteo.tempInventario2#">
              <cfinvokeargument name="Conexion"         value="#Arguments.Conexion#">
              <cfinvokeargument name="Usucodigo"        value="#Arguments.Usucodigo#">            
            </cfinvoke>

            <!--- Actualizamos el id de kardex generado para cada linea en los detalles de la factura --->
            <cfquery datasource="#Arguments.Conexion#">
              update #Arguments.TemporalesProcesoPosteo.tempDTransacciones#
                set DTIdKardex = (select ti.idKardex from #_tableResultInventario# ti
                                  where ti.DTlinea = #Arguments.TemporalesProcesoPosteo.tempDTransacciones#.DTlinea)
            </cfquery>
        </cfif> <!--- fin de rsParamEmpresaManejaControlInventarios --->


       <!--- Se inserta cada forma de pago como un pago asociado a la factura: Encabezado --->
       <!--- D: Deposito
             C: Cheque
             T: Tarjeta
             E: Efectivo
             A: Documento
             F: Diferencia--->
      <cftry>
           <cfquery datasource="#Arguments.Conexion#">
            insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado,
                              Ccuenta, Ptotal, Pfecha,fechaExpedido, Pobservaciones, Ocodigo, SNcodigo,
                                          Pusuario,Preferencia,CBid,FCid,MLid,PfacturaContado,Plote)
             select
                  #Arguments.Ecodigo# as Ecodigo,
                  case fp.Tipo
                      when 'D' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDeposito.CCTcodigo#">
                      when 'C' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoCheque.CCTcodigo#">
                      when 'T' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoTarjeta.CCTcodigo#">
                      when 'E' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoEfectivo.CCTcodigo#">
                      when 'A' then fp.FPautorizacion
                      when 'F' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDiferencia.CCTcodigo#">
                  else NULL end as CCTcodigo,
                  case fp.Tipo
                      when 'D' then fp.FPdocnumero
                      when 'C' then fp.FPdocnumero
                      when 'T' then fp.FPautorizacion#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
                      when 'E' then 'EF:'#_Cat# <cf_dbfunction name="to_char"  args="fp.FPlinea">
                      when 'A' then fp.FPdocnumero
                      when 'F' then fp.FPdocnumero#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
                  else null end as Pcodigo,
                  fp.Mcodigo,
                  et.ETtc/1.00 as Ptipocambio,
                  0 as Seleccionado,
                  case fp.Tipo
                      when 'D' then case #rsValidarExisteBancos.valor#
                                       when 1 then (select att.Ccuenta from CFinanciera att inner join CuentasBancos btt
                                                    on btt.CFcuentaTransitoria = att.CFcuenta
                                                    where btt.CBid = fp.FPCuenta)
                                       else (select ctt.Ccuenta from CuentasBancos ctt
                                             where ctt.CBid = fp.FPCuenta and ctt.Ecodigo = #Arguments.Ecodigo#) end
                      when 'F' then (select  cftt.Ccuenta from  DIFEgresos difett
                                     inner join CFinanciera cftt on cftt.CFcuenta = difett.CFcuenta
                                     where difett.Ecodigo=#Arguments.Ecodigo# and rtrim(difett.DIFEcodigo)=fp.FPdocnumero)
                      else (select ctt.Ccuenta from FCajas ctt where ctt.FCid = et.FCid) end as Ccuenta,
                  fp.FPagoDoc,
                  #Now()# as Pfecha,
                  #Now()# as fechaExpedido,
                  'FA: '#_Cat#<cf_dbfunction name="to_char" args="fp.ETnumero">#_Cat#',CLI:'#_Cat#et.ETnombredoc as Pobservaciones,
                  et.Ocodigo,
                  et.SNcodigo,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Usuario#"> as Pusuario,
                  case fp.Tipo
                     when 'T' then (select FATdescripcion from FATarjetas ftt where ftt.FATid = <cf_dbfunction name="to_number" args="fp.FPtipotarjeta">)
                     else '' end as Preferencia,
                  case fp.Tipo
                      when 'D' then fp.FPCuenta
                      when 'E' then fp.FPCuenta
                      when 'F' then 0
                      else null end as CBid,
                  et.FCid as FCid,
                  case fp.Tipo
                      when 'D' then fp.MLid
                      else null end as MLid,
                  'S' as PfacturaContado,
                  et.ETlote as Plote
             from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
             inner join #Arguments.TemporalesProcesoPosteo.tempFPagos# fp
                on et.ETnumero = fp.ETnumero
               and et.FCid = fp.FCid
           </cfquery>
      <cfcatch type="any">    
        <cfif Find("Attempt to insert duplicate key row in object 'Pagos' with unique index 'Pagos_PK'",cfcatch.detail)>
          <cfthrow message="Se esta intentando insertar un pago con un numero de documento que ya existe en el sistema. 
                            Favor verificar que no se este usando un deposito que ya no esta disponible, se este
                            indicando un numero de documento de pago con tarjeta que ya se utilizo, un numero de autorizacio
                            en caso de tarjetas. Esta condicion tambien se puede dar si se indica un numero de documento o
                            deposito repetido en el lote de transacciones que se esta intentando aplicar (en caso de ser por lote o bloques)">
        </cfif>
        <cfrethrow><!--- si no es lo del Pagos_PK, relanzamos el error --->
        </cfcatch>  
      </cftry>

       <!--- Inserta los detalles de cada Pago, DPagos --->
       <cfquery datasource="#Arguments.Conexion#">
         insert into DPagos(Ecodigo, CCTcodigo, Pcodigo, Doc_CCTcodigo, Ddocumento, Mcodigo,
                    Ccuenta, DPmonto, DPtipocambio, DPmontodoc, DPtotal, DPmontoretdoc, PPnumero)
         select
              #Arguments.Ecodigo# as Ecodigo,
              case fp.Tipo
                  when 'D' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDeposito.CCTcodigo#">
                  when 'C' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoCheque.CCTcodigo#">
                  when 'T' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoTarjeta.CCTcodigo#">
                  when 'E' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoEfectivo.CCTcodigo#">
                  when 'A' then fp.FPautorizacion
                  when 'F' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDiferencia.CCTcodigo#">
              else NULL end as CCTcodigo,
              case fp.Tipo
                  when 'D' then fp.FPdocnumero
                  when 'C' then fp.FPdocnumero
                  when 'T' then fp.FPautorizacion#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
                  when 'E' then 'EF:'#_Cat# <cf_dbfunction name="to_char"  args="fp.FPlinea">
                  when 'A' then fp.FPdocnumero
                  when 'F' then fp.FPdocnumero#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
              else null end as Pcodigo,
              et.CCTcodigo as Doc_CCTcodigo,
              et.ETserie #_Cat# <cf_dbfunction name="to_char"  args="et.ETdocumento"> as Ddocumento,
              fp.Mcodigo,
              case fp.Tipo
                  when 'D' then case #rsValidarExisteBancos.valor#
                                   when 1 then (select att.Ccuenta from CFinanciera att inner join CuentasBancos btt
                                                on btt.CFcuentaTransitoria = att.CFcuenta
                                                where btt.CBid = fp.FPCuenta)
                                   else (select ctt.Ccuenta from CuentasBancos ctt
                                         where ctt.CBid = fp.FPCuenta and ctt.Ecodigo = #Arguments.Ecodigo#) end
                  when 'F' then (select  cftt.Ccuenta from  DIFEgresos difett
                                 inner join CFinanciera cftt on cftt.CFcuenta = difett.CFcuenta
                                 where difett.Ecodigo=#Arguments.Ecodigo# and rtrim(difett.DIFEcodigo)=fp.FPdocnumero)
                  else #rsParamCuentaDepositosTransito.valor# end as Ccuenta,
                  fp.FPmontoori as DPmonto,
                  et.ETtc/1.00 as DPtipocambio,
                  fp.FPagoDoc as DPmontodoc,
                  fp.FPagoDoc as DPtotal,
                  0.00 as DPmontoretdoc,
                  0 as PPnumero
         from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
         inner join #Arguments.TemporalesProcesoPosteo.tempFPagos# fp
            on et.ETnumero = fp.ETnumero
           and et.FCid = fp.FCid
       </cfquery>

       <!--- Insertamos la referencia a los pagos que acabamos de insertar en una temporal para facilitar el proceso
             de posteo de Pagos Masivo --->
      <cfquery datasource="#Arguments.Conexion#">
        insert into #Arguments.TemporalesProcesoPosteo.tempPagos#(Ecodigo,Pcodigo,CCTcodigo)
        select
             #Arguments.Ecodigo# as Ecodigo,
            case fp.Tipo
                when 'D' then fp.FPdocnumero
                when 'C' then fp.FPdocnumero
                when 'T' then fp.FPautorizacion#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
                when 'E' then 'EF:'#_Cat# <cf_dbfunction name="to_char"  args="fp.FPlinea">
                when 'A' then fp.FPdocnumero
                when 'F' then fp.FPdocnumero#_Cat#'-'#_Cat#<cf_dbfunction name="to_char" args="fp.FPlinea">
             else null end as Pcodigo,
            case fp.Tipo
                when 'D' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDeposito.CCTcodigo#">
                when 'C' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoCheque.CCTcodigo#">
                when 'T' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoTarjeta.CCTcodigo#">
                when 'E' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoEfectivo.CCTcodigo#">
                when 'A' then fp.FPautorizacion
                when 'F' then <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="2" value="#rsCCTcodigoDiferencia.CCTcodigo#">
              else NULL end as CCTcodigo
        from #Arguments.TemporalesProcesoPosteo.tempETransacciones# et
         inner join #Arguments.TemporalesProcesoPosteo.tempFPagos# fp
            on et.ETnumero = fp.ETnumero
           and et.FCid = fp.FCid
      </cfquery>


      <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC_Masivo" method="PosteoPagosCxC_Masiva">
          <cfinvokeargument name="Ecodigo"               value="#Arguments.Ecodigo#">
          <cfinvokeargument name="Conexion"              value="#Arguments.Conexion#">
          <cfinvokeargument name="TemporalesPagosIds"    value="#Arguments.TemporalesProcesoPosteo.tempPagos#">
          <cfinvokeargument name="usuario"               value="#Arguments.usuario#">
          <cfinvokeargument name="PeriodoAuxiliares"     value="#Arguments.PeriodoAuxiliares#">
          <cfinvokeargument name="MesAuxiliares"         value="#Arguments.MesAuxiliares#">            
          <cfinvokeargument name="transaccionActiva"     value="true">
      </cfinvoke>

  </cffunction>

  <!------------------------------------------------------------------------------------------------------------------------->

  <!--- Consulta un parametro de la tabla Parametros --->
  <cffunction name="consultaParametro" returntype="query">
    <cfargument name='Ecodigo'   type="numeric"   required="true">         
    <cfargument name='Mcodigo'   type="string"    required="false" default="" >
    <cfargument name='Pcodigo'   type="numeric"   required="true">
    <cfargument name="Conexion"  type="string"    required="true">
               
    <cfquery name="rsValor" datasource="#Arguments.Conexion#">
        select 
              <cf_dbfunction name="to_char"  args="Pvalor"> as valor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
          <cfif len(trim(Arguments.Mcodigo)) gt 0> 
              and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mcodigo#"> 
          </cfif>  
          and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#"> 
        <cf_isolation nivel="read_committed">
    </cfquery>    
    <cfreturn rsValor>        
  </cffunction>   <!--- fin de: consultaParametro --->

  <!------------------------------------------------------------------------------------------------------------------------>

  <!--- Obtiene la moneda local de la empresa --->
  <cffunction name="MonedaLocal" returntype="query"> 
    <cfargument name="Ecodigo"   type="numeric" required="true"> 
    <cfargument name="Conexion"  type="string"  required="true">      
    <cfquery name="rsMonedaLoc" datasource="#Arguments.Conexion#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
      select Mcodigo 
      from Empresas 
      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
    </cfquery> 
    <cfreturn rsMonedaLoc>
  </cffunction>

</cfcomponent>
