<cfcomponent output="no">
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---Consultas moneda local de la empresa--->
    <cffunction name="MonedaLocal" output="no"  access="public" returntype="query" hint="Consultas moneda local de la empresa">
    	<cfargument name="Ecodigo"      		type="numeric" required="yes">
       	<cfquery name="rsMonedaLoc" datasource="#session.dsn#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
         	select Mcodigo
				from Empresas
          	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
       	</cfquery>
       <cfreturn rsMonedaLoc>
     </cffunction>

<!----------------------------------------------------------------------------------------------------------->
<!--- Si no contabiliza, solo aplica, entonces, NO ejecuta contabilidad, presupuesto y mucho de los auxiliares --->
<!--- Si contabiliza hace todo lo que no se hizo en el cambio pasado --->
 <cffunction name="AplicarTransaccionPago">
   <cfargument name="ETnumero">
   <cfargument name="FCid">
   <cfargument name="Usuario" 						default="#session.Usucodigo#">
   <cfargument name="InvocarFacturacionElectronica" required="false" default="true"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
   <cfargument name="InvocarInterfaz718" 			required="false" default="true"> <!--- Inserta en la tabla de comisiones --->
   <cfargument name="InvocarInterfaz719" 			required="false" default="true"> <!--- Realiza el calculo de comisiones --->
   <cfargument name="Contabilizar" 					required="false" type="string"  default="todos">
   <cfargument name="TempDiferencial" 				required="no" 	 type="string"  hint="Nombre de la tabla temporal de diferencial">
   <cfargument name="TempPresupuesto" 				required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de presupuesto">
   <cfargument name="TempCostos" 					required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de Costos">
   <cfargument name="TempConta" 					required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de Contabilidad">
   <cfargument name="Ecodigo" 						required="no" 	 type="numeric" hint="Codigo Interno de la empresa">
   <cfargument name="Usucodigo" 					required="no" 	 type="numeric" hint="Codigo Interno del Usuario">
   <cfargument name="Conexion" 						required="no" 	 type="numeric" hint="Nombre del DataSource">
   <cfargument name="PrioridadEnvio"      required="false" type="numeric" default="0">
   <cfargument name="CPNAPmoduloOri"      type="string"  required="false" default="">
   <cfargument name="ModuloOrigen"        type="string"  required="false" default="">
   <cfargument name='generaMovBancario' type='boolean'  required="no"  default=true>
   <cfargument name='Reversar' type='boolean'  required="no"  default=false>

   <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
   		<cfset Arguments.Ecodigo = Session.Ecodigo>
   </cfif>
   <cfif NOT ISDEFINED('Arguments.Usucodigo') and ISDEFINED('Session.Usucodigo')>
   		<cfset Arguments.Ecodigo = Session.Ecodigo>
   </cfif>
   <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.dsn')>
   		<cfset Arguments.Conexion = Session.dsn>
   </cfif>

   <cfif isdefined('arguments.Contabilizar') and arguments.Contabilizar neq 'conta' and arguments.Contabilizar neq 'aplica' and  arguments.Contabilizar neq 'todos'>
        <cf_ErrorCode code="-1" msg="EL argumento Contabilizar no tiene ninguno de los siguientes valores:  conta, aplica, todos. Proceso cancelado.">
   </cfif>

  <cfset C_PARAM_CONTABILIZA_TRANSACCCION    = "30200104">
  <cfset C_ERROR_CONTABILIZA_TRANSACCCION    = "30200104">

  <cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
  <cfset CONTABILIZA_TRANSACCCION = crcParametros.GetParametro(codigo="#C_PARAM_CONTABILIZA_TRANSACCCION#",conexion=#session.DSN#,ecodigo=#session.ecodigo# )>

  <cfif CONTABILIZA_TRANSACCCION eq ''>
    <cfthrow errorcode="#C_ERROR_CONTABILIZA_TRANSACCCION#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Contabilizar transacciones al aplicar pagos]" >
  </cfif>

  <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#"   method="CreaIntarc"          returnvariable="INTARC"  CrearPresupuesto="false"/>
  <cfinvoke component="sif.fa.operacion.CostosAuto"      Conexion="#session.dsn#"   method="CreaCostos"          returnvariable="Tb_Calculo"/>
  <cfinvoke component="sif.Componentes.PRES_Presupuesto" Conexion = "#session.dsn#" method="CreaTablaIntPresupuesto" returnvariable="IntPresup"/>
  <cfset DIFERENCIAL = CreateTempDiferencial()>
	
  <cfquery name="rsVerificaEstado" datasource = "#session.dsn#">
      select a.ETexterna,a.ETestado, a.ETfecha, round(a.ETtotal- (COALESCE(Rporcentaje,1)/100 * a.ETtotal),2) as ETtotal  , a.Mcodigo,ct.CCTvencim, a.CCTcodigo,
	  (select Count(1)
	   	from DTransacciones  dt
        	inner join FADRecuperacion fd
           		on fd.DTlinea   = dt.DTlinea
               and fd.Ecodigo   = dt.Ecodigo
        	inner join FAERecuperacion fe
          		on fe.FAERid    = fd.FAERid
               and fe.Ecodigo   = fd.Ecodigo
		 where a.ETnumero = dt.ETnumero
           and a.FCid     = dt.FCid
           and a.Ecodigo  = dt.Ecodigo) Existe
      from ETransacciones a
      inner join CCTransacciones ct
        on a.CCTcodigo = ct.CCTcodigo
        and a.Ecodigo = ct.Ecodigo
      LEFT outer join Retenciones r
         on a.Rcodigo = r.Rcodigo
        and a.Ecodigo = r.Ecodigo
      where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
        and a.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
  </cfquery>

  <!---  APLICAR APLICAR APLICAR APLICAR --->
	<cfif CONTABILIZA_TRANSACCCION>
    
    <!----- Se le asigna el numero de documento, manteniendo el consecutivo del talonario ------>
    <!----- Buscamos el ID del talonario asignado a la caja --->
    <cfinvoke  method="SigTalonarioDoc" returnvariable="rsRIsig">
      <cfinvokeargument name="FCid"          value="#Arguments.FCid#">
      <cfinvokeargument name="CCTcodigo"     value="#rsVerificaEstado.CCTcodigo#">
    </cfinvoke>

    <cfquery name="rsUpdate" datasource="#session.dsn#">
       update ETransacciones set ETdocumento = #rsRIsig.RIsig#, ETserie = '#rsRIsig.RIserie#'
       where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and (ETdocumento  is null or ETdocumento = 0)
    </cfquery>

    <!--- Validamos que la nueva factura que se aplicara, NO repita con serie y documento con algun otro documento --->
    <cfquery name="_rsTTransaction" datasource="#session.dsn#">
        select ETserie,ETdocumento,Ecodigo from ETransacciones
        where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    </cfquery>
    <cfquery name="rsValidaETserieDocumentoRepetido" datasource="#session.dsn#">
        select * from ETransacciones
        where ETserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_rsTTransaction.ETserie#">
        and ETdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.ETdocumento#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.Ecodigo#">
        and ETestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="C">
    </cfquery>
    <!--- Esto se puede dar o bien, porque se genero una serie que ya existia entonces el ETransacciones NO deberia tener asignado el ETdocumento --->
    <!--- El otro caso posible es que, ya se habia asignado el ETdocumento entonces este ETnumero ya deberia tener el ETdocumento --->
    <cfif rsValidaETserieDocumentoRepetido.recordCount GT 0 and not arguments.Reversar>
      <cf_ErrorCode code="-1" msg="Se genero un numero de serie y documento invalido. ETnumero:#Arguments.ETnumero#. Documento:#_rsTTransaction.ETdocumento# y la serie:#_rsTTransaction.ETserie# </br> Favor Intentar aplicar el documento Nuevamente.">
    </cfif>

		<cfinvoke component="crc.Componentes.pago.CRCPosteoTransaccionPago" method="posteoDocumentosPago" returnvariable="any">
			  <cfinvokeargument name="FCid"           value="#Arguments.FCid#">
			  <cfinvokeargument name="ETnumero"       value="#Arguments.ETnumero#">
			  <cfinvokeargument name="Ecodigo"        value="#Session.Ecodigo#">
			  <cfinvokeargument name="usuario"        value="#Arguments.Usuario#">
			  <cfinvokeargument name="debug"          value="true">
			  <cfinvokeargument name="INTARC"         value="#INTARC#">
			  <cfinvokeargument name="IntPresup"      value="#IntPresup#">
			  <cfinvokeargument name="Tb_Calculo"     value="#Tb_Calculo#">
			  <cfinvokeargument name="DIFERENCIAL"    value="#DIFERENCIAL#">
			  <cfinvokeargument name="FechaDocumento" value="#rsVerificaEstado.ETfecha#">
        <cfinvokeargument name="CPNAPmoduloOri"	value="#Arguments.CPNAPmoduloOri#">
			  <cfif isdefined("form.NCredito")>
				<cfinvokeargument name="NotCredito"  value="S">
			  <cfelse>
				<cfinvokeargument name="NotCredito"  value="N">
			  </cfif>
			  <cfif isdefined("rsVerificaEstado") and rsVerificaEstado.existe  gt 0>
				<cfinvokeargument name="Importacion"  value="true">
        <cfinvokeargument name="InvocarFacturacionElectronica"  value="true">
        <cfinvokeargument name="PrioridadEnvio"  value="0">
			  </cfif>
        <cfinvokeargument name="ModuloOrigen"  value="#arguments.ModuloOrigen#">
        <cfinvokeargument name='generaMovBancario' value="#arguments.generaMovBancario#">
        <cfinvokeargument name='Reversar' value="#arguments.Reversar#">
		</cfinvoke>

      <cfif not arguments.Reversar>
          <cfquery name="rsUpdateContabiliza" datasource="#session.dsn#">
            update ETransacciones
            set ETcontabiliza = 1
              where Ecodigo  = #session.Ecodigo#
                and ETnumero = #Arguments.ETnumero#
                and FCid     = #Arguments.FCid#
          </cfquery>
      </cfif>
    <cfelse>
      <cfthrow errorcode="#C_ERROR_CONTABILIZA_TRANSACCCION#"  type="CRCParametroException" message="No se ha habilitado [Contabilizar transacciones al aplicar pagos]" >
    </cfif>
</cffunction>

<!--- Debe ser invocado conteniendolo en un CFTRANSACTION --->
<!------------------------------------------------------------------------------------------------------------>
<!--- Aplica recibos de dinero (Cobros, o notas de credito), Pagos --->
<cffunction name="AplicarRecibosDinero">
  <cfargument name="CCTcodigo"    type="string"  required="true">
  <cfargument name="Pcodigo"      type="string"  required="true">
  <cfargument name="CC"           type="numeric" required="false" default="">
  <cfargument name="Preferencia"  type="string"  required="false" default="">
  <cfargument name="Contabilizar" type="string"  required="false" default="aplica">
  <cfargument name="Usuario"      type="string"  required="false" default="#session.Usulogin#">
  <cfargument name="CPNAPmoduloOri"      type="string"  required="false" default="">
  <cfoutput>
  <cf_dbfunction name="to_char" args="p.Pfecha"  returnvariable="Pfecha">
  <cf_dbfunction name="to_char" args="d.Dfecha"  returnvariable="Dfecha">
  <cf_dbfunction name="date_format" args="p.Pfecha,dd-mm-yyyy" returnvariable="LvarPfecha">
  <cf_dbfunction name="date_format" args="d.Dfecha,dd-mm-yyyy" returnvariable="LvarDfecha">
  <!--- ABG. Se modifica ya que la comparacion de fechas es erronea --->
  <!--- Se utiliza el dbfunction y el preservesinglequotes porque si habia diferencia en horas, el sistema da diferencia 1 y daba error ----->
  <cfquery name="rsValida" datasource="#session.DSN#" maxrows="1">
    select
      (case when (#preservesinglequotes(LvarPfecha)#) < (select #preservesinglequotes(LvarDfecha)#
                                                          from Documentos d
                                                          where d.Ecodigo = dp.Ecodigo
                                                            and d.CCTcodigo = dp.Doc_CCTcodigo
                                                            and d.Ddocumento = dp.Ddocumento)
                                                            then 1 else 2 end) as diferencia,
      #preservesinglequotes(LvarPfecha)# as fechaPag,
      (select #preservesinglequotes(LvarDfecha)#
        from Documentos d
        where d.Ecodigo = dp.Ecodigo
          and d.CCTcodigo = dp.Doc_CCTcodigo
          and d.Ddocumento = dp.Ddocumento) as FechaDoc
    from Pagos p
    inner join DPagos dp
      on dp.Ecodigo = p.Ecodigo
      and dp.CCTcodigo = p.CCTcodigo
      and dp.Pcodigo  = p.Pcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
    order by 1
  </cfquery>

  <cfquery name="rsSNid" datasource="#session.dsn#">
    select b.SNid
    from Pagos p
    inner join SNegocios  b
      on p.SNcodigo = b.SNcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
  </cfquery>

  <cfquery name="rsDatos" datasource="#session.dsn#">
    select
      Doc_CCTcodigo,
      Ddocumento,Ptipocambio as TC,
      coalesce(p.CBid,-1) as CBid
    from Pagos p
    inner join DPagos dp
      on dp.Ecodigo = p.Ecodigo
      and dp.CCTcodigo = p.CCTcodigo
      and dp.Pcodigo  = p.Pcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
  </cfquery>
  <cfif isdefined('rsDatos') and rsDatos.recordcount gt 0>
    <cfquery name="rsDocumentos" datasource="#session.dsn#">
      select
        d.FCid,
        d.ETnumero
      from Documentos d
      where   d.Ecodigo = #session.Ecodigo#
        and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#rsDatos.Doc_CCTcodigo#" >
        and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"  value="#rsDatos.Ddocumento#" >
    </cfquery>
  </cfif>

  <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
    select e.Mcodigo from Empresas es
    inner join Empresa e
    on es.cliente_empresarial = e.CEcodigo
    where es.Ecodigo = #session.Ecodigo#
  </cfquery>
  <cfset LvarMonedaLocal = rsMonedaLoc.Mcodigo>
  <cfquery  datasource="#session.dsn#">
  update PFPagos
    set FPtc = 1
  where CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
    and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
    and Mcodigo = #LvarMonedaLocal#
    and FPtc <> 1
  </cfquery>


  <!---  A las lineas que tengan vuelto, se les resta al pago el vuelto para hacer los asientos--->
  <cfquery name="upPagosVuelto" datasource="#session.dsn#">
    update PFPagos set FPagoDoc = (FPagoDoc - PFPVuelto)
    where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
      and Tipo = 'E'
      and PFPVuelto <> 0
  </cfquery>


  <cfinvoke component="sif.fa.operacion.CostosAuto"       Conexion="#session.dsn#"  method="CreaCostos"   returnvariable="Tb_Calculo"/>
  <cfinvoke component="sif.Componentes.CG_GeneraAsiento"  Conexion="#session.dsn#"  method="CreaIntarc" CrearPresupuesto="false" returnvariable="INTARC"/>
  <cfinvoke component= "sif.Componentes.PRES_Presupuesto" Conexion ="#session.dsn#" method="CreaTablaIntPresupuesto"  returnvariable="IntPresup"/>


  <cfif isdefined("rsValida") and rsValida.diferencia eq 3> <!--- Esta validacion  tiene un problema se debe de corregir --->
    <cfthrow message="No se puede aplicar un recibo con fecha menor a la del documento! La Fecha de pago es: #rsValida.fechaPag# y la fecha del documento es #rsValida.FechaDoc#">
  </cfif>

  <!--- ejecuta el proc.--->
  <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status">
    <cfinvokeargument name="Ecodigo"  value="#session.Ecodigo#"/>
    <cfinvokeargument name="CCTcodigo"  value="#Arguments.CCTcodigo#"/>
    <cfinvokeargument name="Pcodigo"  value="#Arguments.Pcodigo#"/>
    <cfinvokeargument name="Preferencia"  value="#Arguments.Preferencia#"/>
    <cfinvokeargument name="usuario"  value="#Arguments.Usuario#"/>
    <cfinvokeargument name="SNid" value="#rsSNid.SNid#"/>
    <cfinvokeargument name="Tb_Calculo" value="#Tb_Calculo#"/>
    <cfinvokeargument name="transaccionActiva"  value="true"/>
    <cfinvokeargument name="INTARC" value="#INTARC#"/>
    <cfinvokeargument name="IntPresup"  value="#IntPresup#"/>
    <cfinvokeargument name="debug"  value="false"/>
    <cfinvokeargument name="PintaAsiento" value="#isdefined('Form.Ver')#"/>
    <cfif isdefined('Arguments.CC') and Len(Trim(Arguments.CC))>
      <cfinvokeargument name="CC" value="#Arguments.CC#"/>
    </cfif>
    <cfinvokeargument name="Contabilizar"  value="#Arguments.Contabilizar#"/>
    <cfinvokeargument name="InvocarFacturacionElectronica"  value="false"/>
    <cfinvokeargument name="PrioridadEnvio"  value="0"/>
    <cfinvokeargument name="CPNAPmoduloOri"  value="#Arguments.CPNAPmoduloOri#"/>

  </cfinvoke>
  <cfif Arguments.Contabilizar eq 'todos' or Arguments.Contabilizar eq 'aplica'>
    <!---Codigo 15836: Maneja Egresos--->
    <cfquery name="rsManejaEgresos" datasource="#session.DSN#">
      select Pvalor
      from Parametros
      where Ecodigo =  #Session.Ecodigo#
        and Pcodigo = 15836
    </cfquery>
    <cfif rsManejaEgresos.Pvalor eq 1>
      <cfquery name="para720" datasource="#session.dsn#">
        select
          case when  VolumenGNCheck 			= 1 then 'S' else 'N' end as IndComVol,
          case when  VolumenGLRCheck 			= 1 then 'S' else 'N' end as IndComVolR,
          case when  VolumenGLRECheck 		= 1 then 'S' else 'N' end as IndComVolRE,
          case when  ProntoPagoCheck 			= 1 then 'S' else 'N' end as IndComPP,
          case when  ProntoPagoClienteCheck 	= 1 then 'S' else 'N' end as IndComPPC,
          case when  montoAgenciaCheck 		= 1 then 'S' else 'N' end as IndComAge,
          dp.DRdocumento as Ddocumento,
          dp.CCTRcodigo as CCTcodigo ,
          sn.SNnumero,
          p.Pcodigo  as DdocumentoR,
          p.CCTcodigo as CCTcodigoR,
          coalesce(p.Ecodigo,0) as Ecodigo
        from HPagos p
        inner join BMovimientos dp
          on dp.Ecodigo = p.Ecodigo
          and dp.CCTcodigo = p.CCTcodigo
          and dp.Ddocumento  = coalesce(p.Pserie #_Cat# p.Pdocumento,p.Pcodigo)
        inner join  COMFacturas comf
          on comf.PcodigoE 	= p.Pcodigo
          and   comf.CCTcodigoE	= p.CCTcodigo
          and   comf.CCTcodigoD	= dp.CCTRcodigo
          and   comf.Ddocumento 	= dp.DRdocumento
        inner join Documentos d
          on dp.Ecodigo = d.Ecodigo
          and dp.DRdocumento = d.Ddocumento
          and dp.CCTRcodigo = d.CCTcodigo
        inner join SNegocios sn
          on sn.SNcodigo = d.SNcodigo
          and sn.Ecodigo= d.Ecodigo
        where p.Ecodigo = #Session.Ecodigo#
          and ltrim(rtrim(p.CCTcodigo)) =  <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.CCTcodigo)#" >
          and ltrim(rtrim(p.Pcodigo)) = <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.Pcodigo)#" >
          and (VolumenGNCheck = 1 or VolumenGLRCheck = 1 or VolumenGLRECheck = 1
              or ProntoPagoCheck = 1 or ProntoPagoClienteCheck = 1 or montoAgenciaCheck = 1
          ) and PtipoSN = '4'
      </cfquery>


      <cfif isdefined("para720") and para720.recordcount>
        <!--- Invoca Componente de Procesamiento de Interfaz 720. --->
        <cfinvoke component="interfacesSoin.Componentes.COM_CreaLote" method="process" returnvariable="numLote" query="#para720#" TransActiva="true"/>

          <cfquery datasource="#session.dsn#">
            update COMFacturas
            set loteGenerado = '#numLote#'
            where Ecodigo = #Session.Ecodigo#
              and rtrim(CCTcodigoE)	= <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.CCTcodigo)#" >
              and rtrim(PcodigoE)	= <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.Pcodigo)#" >
          </cfquery>
      </cfif>
      </cfif>
  </cfif>  <!--- Fin del condicional si es conta o todos ----->

  </cfoutput>
</cffunction>
<!---- Web service Nacion: manda a imprimir la factura aplicada ------>
 <cffunction name="PublicaFactAplicada" access="public" returntype="any">
		<cfargument name="ETnumero" type="numeric" required="true">
        <cfargument name="FCid"     type="numeric" required="true">
        <cfargument name="Estado"   type="string"  required="false" default="I">


       <cfquery name="rsRuta" datasource="#session.dsn#">
         select RutaInterfaz as ruta, MetodoInterfaz as metodo from  RutasInterfaces
         where Ecodigo = #session.Ecodigo#
         and NumeroInterfaz = 2
        </cfquery>
        <cfif len(trim(#rsRuta.ruta#)) eq 0>
           <cfthrow message="No se ha logrado obtener la ruta de la interfaz numero 2, de cambio estado facturacion. Favor revisar la tabla de rutas.">
        </cfif>

		<cfquery name="rsDatos" datasource="#session.dsn#">
		  select a.NumDoc, a.CodSistema, a.NumLineaDet,'#arguments.Estado#' as NuevoEstado,
		  c.ETdocumento as NumFactura,c.ETserie as serieFactura, 0 as CambiarEnCajas,
		  1 as CambiarEnSistemaExterno, c.Usulogin
		  from FADRecuperacion a
           inner join DTransacciones b
             on a.DTlinea = b.DTlinea
           inner join ETransacciones c
             on b.ETnumero = c.ETnumero
             and b.FCid =   c.FCid
          where c.ETexterna = 'S'
             and c.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
               and c.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
		</cfquery>

        <cfoutput query="rsDatos">
           <cfsavecontent variable="soapBodyWSC_pub">
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gnin="GNInterfacesWcf" >
               <soapenv:Header/>
               <soapenv:Body>
                  <gnin:SendCambiaEstadoTransaccion>
                     <gnin:_numDocumento>#rsDatos.NumDoc#</gnin:_numDocumento>
                     <gnin:_codSistema>#rsDatos.CodSistema#</gnin:_codSistema>
                     <gnin:_numLineaDetalle>#rsDatos.NumLineaDet#</gnin:_numLineaDetalle>
                     <gnin:_nuevoEstado>#rsDatos.NuevoEstado#</gnin:_nuevoEstado>
                     <gnin:_numFactura>#rsDatos.NumFactura#</gnin:_numFactura>
                     <gnin:_serieFactura>#rsDatos.serieFactura#</gnin:_serieFactura>
                     <gnin:_indCambiarEnCajas>#rsDatos.CambiarEnCajas#</gnin:_indCambiarEnCajas>
                     <gnin:_indCambiarEnSistemaExterno>#rsDatos.CambiarEnSistemaExterno#</gnin:_indCambiarEnSistemaExterno>
                     <gnin:_usuario>#rsDatos.Usulogin#</gnin:_usuario>
                  </gnin:SendCambiaEstadoTransaccion>
               </soapenv:Body>
            </soapenv:Envelope>
            </cfsavecontent>

            <cfinvoke component="sif.Componentes.Generales" method="AgregarBitacoraWS" returnvariable="idBid">
              <cfinvokeargument name="NumeroInterfaz" value="2">
              <cfinvokeargument name="XmlEnviado" value="#trim(soapBodyWSC_pub)#">
            </cfinvoke>

            <cfhttp url="#rsRuta.ruta#" method="post" result="httpResponse2">
                  <cfhttpparam type="header" name="SOAPAction" value="#rsRuta.metodo#"/>
                  <cfhttpparam type="header" name="accept-encoding" value="no-compression"/>
                  <cfhttpparam type="header" name="charset" value="utf-8">
                  <cfhttpparam type="xml" value="#trim(soapBodyWSC_pub)#"/>
            </cfhttp>

            <cfinvoke component="sif.Componentes.Generales" method="ModificarBitacoraWS">
              <cfinvokeargument name="Bid" value="#idBid#">
              <cfinvokeargument name="XmlRecibido" value="#httpResponse2.fileContent#">
            </cfinvoke>

           <cfoutput>

                <cfset _wsRes = "false">
 				<cfif find( "200", httpResponse2.statusCode )>
                    <cfset soapResponsePubFact = xmlParse( httpResponse2.fileContent ) />
                    <cfset _resultado = #soapResponsePubFact.Envelope.Body.SendCambiaEstadoTransaccionResponse.XmlChildren#>
                    <cfset _wsRes = #_resultado[1].XmlText#>

                <cfelse>
                  <!---  <cfoutput>
                        #httpResponse2.statusCode#
                        <cfthrow message="Hubo un error en la invocacion de la interfaz:#httpResponse2.statusCode# - #httpResponse2.filecontent#">
                    </cfoutput> --->
                       #httpResponse2.statusCode#
                        <cfset MensajeError = "Hubo un error en la invocacion de la interfaz: "&httpResponse2.statusCode&"<br/>"&httpResponse2.filecontent&"<br/>">
                        <cfset MensajeError = MensajeError & "  ARGUMENTOS: <br/>">
                        <cfset MensajeError = MensajeError &  "     - ETnumero: "&Arguments.ETnumero&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - FCid: "&Arguments.FCid&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - Estado: "&Arguments.Estado&"<br/>">
                        <cfset MensajeError = MensajeError &  "     -xml: <pre><code>"&(#soapBodyWSC_pub#)&"</code></pre> <br/>">
                        <cfsavecontent variable="_err">
                              <div style="border: 1px solid blue;width: 50%;margin-left: 25%;text-align: center;font-weight: bold;padding: 1em;font-size: 2em;box-shadow: 5px 5px 40px rgb(0, 0, 248);border-radius: 15px;">
                                Error Inesperado en la interfaz de cambio de estado.
                              </div>
                              <br/>
                        </cfsavecontent>
                        <cfset _err &= '</br>' & MensajeError>
                        <cfthrow message="#_err#">

                </cfif>
                <cfif _wsRes EQ 'false'>
						  <cfset MensajeError = "Hubo un error en la invocacion de la interfaz: "&httpResponse2.statusCode&"<br/>"&httpResponse2.filecontent&"<br/>">
                        <cfset MensajeError = MensajeError & "  ARGUMENTOS: <br/>">
                        <cfset MensajeError = MensajeError &  "     - ETnumero: "&Arguments.ETnumero&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - FCid: "&Arguments.FCid&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - Estado: "&Arguments.Estado&"<br/>">
                        <cfset MensajeError = MensajeError &  "     -xml: <pre><code>"&(#soapBodyWSC_pub#)&"</code></pre> <br/>">
                        <cfsavecontent variable="_err">
                              <div style="border: 1px solid blue;width: 50%;margin-left: 25%;text-align: center;font-weight: bold;padding: 1em;font-size: 2em;box-shadow: 5px 5px 40px rgb(0, 0, 248);border-radius: 15px;">
                                Error Inesperado en la interfaz de cambio de estado.
                              </div>
                              <br/>
                        </cfsavecontent>
                        <cfset _err &= '</br>' & MensajeError>
                        <cfthrow message="#_err#">

                </cfif>
  			</cfoutput>

          </cfoutput>

          <cfreturn true>
	</cffunction>

    <cffunction name="ObtieneCuenta" returntype="any">
        <cfargument name="Tipo"           	type="string" required="yes">
        <cfargument name="FPCuenta"  	  	type="numeric" required="yes">
        <cfargument name="FPdocnumero"      type="string" required="yes">

        <cfif arguments.Tipo EQ 'D'>
            <!---Codigo 15833: para determinar si el pago de documentos de CxC cuando el cliente paga por transferencia o depósito debe crear
            el movimiento en Bancos al aplicarse el pago o el sistema debe validar que el pago ya exista en Bancos--->
             <cfset rsValidarExisteBancos = consultaParametro(#session.Ecodigo#, 'CC',15833)>

            <!---Se usa la transitoria xq si esta el parametro activo, tiene que hacer el asiento con la transitoria debido a que ya existe el asiento de bancos--->
             <cfif rsValidarExisteBancos.valor eq 1>
                 <cfquery name="CuentaE" datasource="#Session.DSN#">
                    select a.Ccuenta as valor
                        from CFinanciera a
                        inner join CuentasBancos b
                            on b.CFcuentaTransitoria = a.CFcuenta
                     where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
                 </cfquery>
                 <!---Validamos si esta configurada la cuenta transitoria--->
                 <cfif len(trim(#CuentaE.valor#)) eq 0>
                     <cfquery name="CuentaE" datasource="#Session.DSN#">
                        select a.CBcodigo, a.CBdescripcion, a.CBcc, b.Bdescripcion
                            from CuentasBancos a
                            inner join Bancos b
                                on b.Bid = a.Bid
                         where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
                     </cfquery>
                    <cfthrow message="La cuenta: #CuentaE.CBcc# con codigo: #CuentaE.CBcodigo# y descripcion : #CuentaE.CBdescripcion# del Banco: #CuentaE.Bdescripcion#
                                      NO tiene definida la cuenta transitoria. Favor definirla en el catalogo de cuentas bancarias">
                </cfif>
            <cfelse>
                <cfquery name="CuentaE" datasource="#Session.DSN#">
                    select Ccuenta as valor from CuentasBancos  where CBid = #arguments.FPCuenta# and Ecodigo = #session.Ecodigo#
                 </cfquery>
            </cfif>
        <cfelseif arguments.Tipo EQ 'F'> <!---F: Diferencia--->
            <cfquery name="CuentaE" datasource="#Session.DSN#">
                select  cf.Ccuenta as valor
                    from  DIFEgresos dife
                     inner join CFinanciera cf
                        on cf.CFcuenta = dife.CFcuenta
                 where dife.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and rtrim(dife.DIFEcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(arguments.FPdocnumero)#">
            </cfquery>
        <cfelse>
             <cfset CuentaE = consultaParametro(#session.Ecodigo#, '',650)>
        </cfif>
        <cfreturn #CuentaE#>

    </cffunction>

	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
    <cffunction name="ObtenerDato" returntype="query">
        <cfargument name="pcodigo" type="numeric" required="true">
        <cfquery name="rs" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Session.Ecodigo#
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
        </cfquery>
        <cfreturn rs>
    </cffunction>

	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
    <cffunction name="ObtenerConceptos" returntype="query">
        <cfargument name="Cid" type="numeric" required="true">
        <cfquery name="rs" datasource="#Session.DSN#">
            select Cid, coalesce(Cformato,'') as Cformato, coalesce(cuentac,'') as cuentac , Ccodigo, Cdescripcion

 			from Conceptos
            where Ecodigo = #Session.Ecodigo#
              and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
        </cfquery>
        <cfreturn rs>
    </cffunction>

 <!------------------------------------------------------------------------------------------------------------------------------->
 <!------------------------------------------------------------------------------------------------------------------------------->
 <!---- Web service Nacion: publica en la nube la factura ----->
  <cffunction name="FacturaElectronica" access="public" returntype="any">
	    <cfargument name="ETnumero" type="numeric" required="true">
      <cfargument name="FCid"     type="numeric" required="true">
      <cfargument name="Ecodigo"  type="numeric" required="true">
      <cfargument name="desdeNotaCredito" type="boolean" required="false" default="false"> <!--- Indica si la factura proviene de una Nota de credito --->
      <cfargument name="ENCid" type="numeric" required="false"> <!--- id de la nota de credito --->
      <cfargument name="reversarAplicacionFactAplicada" type="boolean" required="false" default="false">
      <cfargument name="imprimir" type="boolean" required="false" default="true">
      <cfargument name="PrioridadEnvio" type="numeric" required="false" default="0">

      <cfquery name="rsFacturaDigital" datasource="#session.dsn#">
       select Pvalor as usa from Parametros
        where Pcodigo = 16317
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
      </cfquery>

      <cfquery name="rs" datasource="#session.dsn#">
        select ETserie + convert(varchar,ETdocumento) as NumeroDocumento
        from ETransacciones
        where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      </cfquery>
<!--- COMENTADO POR ALVARO CHAVES EN PROYECTO DE AVIACIÓN CIVIL
      ESTO HAY QUE HACER QUE SE PUEDA HABILITAR O NÓ POR PARÁMETRO PUES NO SIEMPRE VA EXISTIR
      LA INTEGRACIÓN CON FACTURACIÓN DIGITAL --->
      <cfif rsFacturaDigital.usa eq 1>
        <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="AgregarRegistroEnBitacora" returnvariable="_idEnvioEle">
            <cfinvokeargument name="Ecodigo"          value="#Arguments.Ecodigo#">
            <cfinvokeargument name="ETnumero"         value="#Arguments.ETnumero#">
            <cfinvokeargument name="FCid"             value="#Arguments.FCid#">
            <cfinvokeargument name="NumeroDocumento"  value="#Trim(rs.NumeroDocumento)#">
            <cfinvokeargument name="PrioridadEnvio"   value="#Arguments.PrioridadEnvio#">
            <cfinvokeargument name="desdeNotaCredito" value="#Arguments.desdeNotaCredito#">
            <cfif isDefined('Arguments.ENCid')>
              <cfinvokeargument name="ENCid"            value="#Arguments.ENCid#">
            </cfif>
            <cfinvokeargument name="imprimir"         value="#Arguments.imprimir#">
        </cfinvoke>

        <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="AgregarFacturaConsolaFE">
            <cfinvokeargument name="ETnumero"           value="#Arguments.ETnumero#">
            <cfinvokeargument name="Legado"             value="0">
            <cfinvokeargument name="Estado"             value="0">
            <cfinvokeargument name="Ecodigo"            value="#session.Ecodigo#">
        </cfinvoke>
      </cfif>
      <!---
--->
	</cffunction>


  <!--- INVOCADO DESDE POSTEO TRANSACCIONES --->
  <cffunction name="_InsertArticuloServicioINTARC">
        <cfargument name="LvarETdocumento">
        <cfargument name="LvarCCTcodigo">
        <cfargument name="LvarMonloc">
        <cfargument name="LvarMonedadoc">
        <cfargument name="Anulacion">
        <cfargument name="AnulacionParcial">
        <cfargument name="LvarCuentaTransitoriaGeneral">
        <cfargument name="TBanulacion">
        <cfargument name="lvarETnumero_sub">
        <cfargument name="FCid">
        <cfargument name="Ecodigo">
        <cfargument name="LineasDetalle">
        <cfargument name="INTARC">
        <cfargument name="LvarPeriodo">
        <cfargument name="LvarMes">

      <!-----3c. Detalle (Articulos o Servicios) --Articulos--->
      <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
        INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        select 'FAFC', 1, '#Arguments.LvarETdocumento#', '#Arguments.LvarCCTcodigo#',
            ((case when #Arguments.LvarMonloc# != #Arguments.LvarMonedadoc# then round((b.DTtotal+coalesce(b.DTdeslinea,0.00)) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end)<cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
            case when c.CCTtipo = 'D' then <cfif Arguments.AnulacionParcial eq true> 'D' else 'C'<cfelse> 'C' else 'D'</cfif> end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
            <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
            then  'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and d.CFACTransitoria = 1 then 'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else coalesce(DTdescripcion, DTdescalterna) end
            end , <cf_dbfunction name="to_char" args="getdate(),112">, a.ETtc,  #LvarPeriodo#, #LvarMes#,
             case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0)!= -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#Arguments.LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0)!= -1  and  d.CFACTransitoria = 1 <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
             THEN <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#Arguments.LvarCuentaTransitoriaGeneral#)</cfif>
             else b.Ccuenta end end,  a.Mcodigo, b.Ocodigo,
             ((b.DTtotal+coalesce(b.DTdeslinea,0.00))<cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>), <cf_dbfunction name="to_char"  args="a.FCid">, <cf_dbfunction name="to_char" args="a.ETnumero">,
            b.DTdescripcion, '#Arguments.LvarETdocumento#',case when a.CDCcodigo is not null then '03'  else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a, DTransacciones b, CCTransacciones c, CFuncional d , SNegocios sn
        <cfif Arguments.AnulacionParcial>
         ,#Arguments.TBanulacion# tb
        </cfif>
        where  a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lvarETnumero_sub#">
          <cfif Arguments.AnulacionParcial>
            and b.DTlinea = tb.DTlinea
          </cfif>
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.FCid = b.FCid and a.ETnumero = b.ETnumero and a.Ecodigo = b.Ecodigo and a.Ecodigo = c.Ecodigo and a.CCTcodigo = c.CCTcodigo
          and a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo and b.CFid = d.CFid  and b.Ecodigo = d.Ecodigo and b.DTtipo = 'A' and (b.DTpreciou * b.DTcant) <> 0 and b.DTborrado = 0
           <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
            and b.DTlinea in (#arguments.LineasDetalle#)
           </cfif>
         </cfquery>

        <!----- 3d. Detalle (Servicios o conceptos) --->
        <cfquery name="rsInsert" datasource="#session.dsn#">
      insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, CFcuenta, Mcodigo, Ocodigo, INTMOE,
        INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        select 'FAFC', 1, '#LvarETdocumento#', '#LvarCCTcodigo#',
            ((case when #LvarMonloc# != #LvarMonedadoc# then round((b.DTtotal+coalesce(b.DTdeslinea,0.00)) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end) <cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
            case when c.CCTtipo = 'D' then <cfif arguments.AnulacionParcial eq true> 'D' else 'C' <cfelse> 'C' else 'D'</cfif>end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then  'Cuenta transitoria: ' #_Cat# substring(coalesce(DTdescripcion, DTdescalterna),1,50)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
            <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
            then 'Cuenta transitoria: ' #_Cat# substring(coalesce(DTdescripcion, DTdescalterna),1,50)
            else substring(coalesce(DTdescripcion, DTdescalterna),1,50) end end,
            <cf_dbfunction name="to_char" args="getdate(),112">, a.ETtc,   #LvarPeriodo#, #LvarMes#,
            case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
           <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif> then <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) </cfif>
            else  b.Ccuenta end end,
			case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
           <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif> then <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) </cfif>
            else  b.CFcuenta end end, a.Mcodigo,  b.Ocodigo,
            ((b.DTtotal+coalesce(b.DTdeslinea,0.00)) <cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>), <cf_dbfunction name="to_char"  args="a.FCid">,  <cf_dbfunction name="to_char"  args="a.ETnumero">,
            b.DTdescripcion, '#LvarETdocumento#', case when a.CDCcodigo is not null then '03' else '01' end,case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
        inner join DTransacciones b on a.FCid = b.FCid  and a.ETnumero = b.ETnumero
        <cfif Arguments.AnulacionParcial>
          left outer join #Arguments.TBanulacion# tb
              on b.DTlinea = tb.DTlinea
        </cfif>
        inner join CCTransacciones c on a.CCTcodigo = c.CCTcodigo   and a.Ecodigo = c.Ecodigo
        inner join CFuncional d on b.CFid = d.CFid  and b.Ecodigo = d.Ecodigo
          inner join SNegocios sn  on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and b.DTtipo = 'S'
          and (b.DTpreciou * b.DTcant) <> 0 and b.DTborrado = 0
          <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
            and b.DTlinea in (#arguments.LineasDetalle#) </cfif>
        </cfquery>

    </cffunction>
    <cffunction name="SigTalonarioDoc" access="public" returntype="query">
     <cfargument name="FCid"       type="numeric">
     <cfargument name="CCTcodigo"  type="string">
     <cfargument name="Tid"        type="numeric">

     <cfif isdefined('Arguments.Tid') and len(trim(Arguments.Tid)) gt 0>
        <cfquery name = "rsTalonario" datasource = "#session.dsn#">
         select #Arguments.Tid# as Tid from dual
        </cfquery>
     <cfelse>
        <cfquery name = "rsTalonario" datasource = "#session.dsn#">
         select Tid from TipoTransaccionCaja where  FCid = #Arguments.FCid# and CCTcodigo = '#Arguments.CCTcodigo#'
        </cfquery>
     </cfif>

      <cfif not rsTalonario.recordCount or rsTalonario.Tid EQ -1>
        <cfset MensajeError = "La Transaccion en aplicacion (#Arguments.CCTcodigo#), no tiene asociado un talonario.">
        <cfset MensajeError &= " para la caja:"&Arguments.FCid>
        <cf_ErrorCode code="-1" msg="#MensajeError#">
      </cfif>

      <cfquery name="rsRIserie" datasource="#session.dsn#">
         select RIserie
         from Talonarios
         where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
           and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">
      </cfquery>

      <cfquery name="rsUpdate" datasource="#session.dsn#">
        declare @SigVal numeric
        update Talonarios set @SigVal = RIsig + 1, RIsig = RIsig + 1
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">

         select   @SigVal as SigVal
      </cfquery>

       <cfquery name="rsRIsig" datasource="#session.dsn#">
         select #rsUpdate.SigVal# as RIsig, '#rsRIserie.RIserie#' as RIserie , #rsTalonario.Tid# as Tid
         from dual
      </cfquery>

      <cfreturn rsRIsig>
    </cffunction>

	<cffunction name="CreateTempDiferencial" returntype="string" output="false">
		 <cf_dbtemp name="FacTempDif_V1" returnvariable="DIFERENCIAL" datasource="#session.dsn#">
			<cf_dbtempcol name="INTLIN"    type="numeric"      identity="yes">
			<cf_dbtempcol name="INTORI"    type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="INTREL"    type="int"          mandatory="yes">
			<cf_dbtempcol name="INTDOC"    type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="INTREF"    type="varchar(25)"  mandatory="yes">

			<cf_dbtempcol name="INTMON"    type="money"        mandatory="yes">
			<cf_dbtempcol name="INTTIP"    type="char(1)"      mandatory="yes">

			<cf_dbtempcol name="INTDES"    type="varchar(80)"  mandatory="yes">

			<cf_dbtempcol name="INTFEC"    type="varchar(8)"   mandatory="yes">
			<cf_dbtempcol name="INTCAM"    type="float"        mandatory="yes">
			<cf_dbtempcol name="Periodo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="Mes"       type="int"          mandatory="yes">
			<cf_dbtempcol name="Ccuenta"   type="numeric"      mandatory="yes">

			<cf_dbtempcol name="CFcuenta"  type="numeric"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"   type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="INTMOE"    type="money"        mandatory="yes">
			<cf_dbtempcol name="TIPO"      type="char(2)"      mandatory="yes">
			<cf_dbtempkey cols="INTLIN">
	  </cf_dbtemp>
	  <cfreturn DIFERENCIAL>
	</cffunction>
</cfcomponent>