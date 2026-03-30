<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- =============================================================== --->
<!---  Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	07/05/2014              	                          --->
<!--- =============================================================== --->
	<cfset modo = "CAMBIO">
 <cfset cambio=''>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="TablaAmortizacion"
returnvariable="LB_Archivo" xmlfile = "formRCuentas.xml"/>

<cfif isdefined("btnExportar")>
	<cfquery name="TablaAmorts" datasource="#session.DSN#">
		select NumPago, FechaInicio, FechaPagoBanco as'Fecha_De_Pago',FechaPagoPMI,FechaCierre,
		DiasPeriodo as 'Dias_del_Periodo', SaldoInsoluto, Capital, Intereses,IntDevengNoPag, PagoMensual, IVA,
		Estado
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #IDFinan#
	</cfquery>

<cf_exportQueryToFile query="#TablaAmorts#" filename="#LB_Archivo##session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="false">
</cfif>


<cfquery name="ConsultEmp" datasource="sifinterfaces">
	 select CodICTS
       from int_ICTS_SOIN
       where Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- mes auxiliar --->
        <cfquery name="mes" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo = 60
        </cfquery>
<!--- periodo auxiliar --->
        <cfquery name="periodo" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo = 50
        </cfquery>
<!---  Valida que el documento no exista  --->
<!---►►Agregar Encabezado◄◄--->

<cfif isdefined("Form.AgregarE") >
 <cfset cambio='1'>
<cfset validaInt = "OK">

  <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and Documento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Documento#">
    </cfquery>

	<cfquery name="rsExisteLC" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and LineaC = <cfqueryparam cfsqltype="cf_sql_numeric"    value="#Form.LineaC#">
    </cfquery>

    <cfif rsExisteEncab.valor NEQ 0>
        <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('El Documento ya Existe, Verifica el Documento');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

	<cfif rsExisteLC.valor NEQ 0>
	   <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('La Linea de Credito ya Existe, Verifica la Linea de Credito');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

     <cfif validaInt eq "OK">
        <cfparam name="Form.LineaC" default="-1">
		<cfset Fecha = #DateFormat(Form.fecha, 'dd/mm/yyyy')#>
        <cftransaction>
            <cfquery name="rsInsertEFinan" datasource="#session.DSN#">
                insert into EncFinanciamiento (Ecodigo, Bid, Documento, LineaC, Mcodigo, TipoCambio, Fecha, Periodo, Mes,
                                            BMUsucodigo,Descripcion,StatusE)
                values  (   #Session.Ecodigo# ,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.bid#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.LineaC#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.Mcodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TipoCambio#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date"    value="#Fecha#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#periodo.pvalor#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#mes.pvalor#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#session.Usucodigo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar"     value="#Form.Descripcion#">,
							0
                        )
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEFinan" returnvariable="IDFinan">
            <cfset modo     = "CAMBIO">
            <cfset modoDet  = "ALTA">
        </cftransaction>
        <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&mododet=#mododet#&urlira=#urlira#&tipocambio=#form.tipocambio#">
    </cfif>
</cfif>
<!---►►Agregar Detalle◄◄--->
<cfparam name="existeDet" default="NO">

<!--- HACEMOS EL UPDATE DEL ENCABEZADO --->
<cfif isdefined("Form.ModificarE") >
<cfset validaInt = "OK">

  <cfquery name="rsExisteEncab2" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and Documento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Documento#">
           and IDFinan <> <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
    </cfquery>

	<cfquery name="rsExisteLC2" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
          where Ecodigo     =  #Session.Ecodigo#
          and LineaC = <cfqueryparam cfsqltype="cf_sql_numeric"    value="#Form.LineaC#">
		  and IDFinan <> <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
    </cfquery>

    <cfif rsExisteEncab2.valor NEQ 0>
        <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('El Documento ya Existe, Verifica el Documento');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

	<cfif rsExisteLC2.valor NEQ 0>
	   <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('La Linea de Credito ya Existe, Verifica la Linea de Credito');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

     <cfif validaInt eq "OK">
		<cftransaction>
	<cfquery name="rsUpd" datasource="#session.DSN#">
                update EncFinanciamiento
				set Documento = <cf_jdbcquery_param cfsqltype="cf_sql_char"     value="#Form.Documento#">,
				LineaC = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.LineaC#">,
				Descripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Form.Descripcion#">
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
            </cfquery>
	</cftransaction>

			<cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
	</cfif>
</cfif>


<cfif isdefined("Form.BorrarE") >
<cfquery name="Validacion2" datasource="#session.DSN#">
                Select *
				from DetFinanciamiento
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
</cfquery>

<cfif Validacion2.recordCount gt 0>
	<cftransaction>
	<cfquery name="rsDele" datasource="#session.DSN#">
                delete from DetFinanciamiento
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
    </cfquery>
	</cftransaction>
</cfif>
<cftransaction>
	<cfquery name="rsDele2" datasource="#session.DSN#">
                delete from EncFinanciamiento
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
    </cfquery>
	</cftransaction>
	<cflocation url="Financiamiento.cfm">
</cfif>


<cfif isdefined("Form.AgregarD") >
    <cfquery name="rsExisteDet" datasource="#Session.DSN#">
        select count(1) as valor
          from DetFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and IDFinan = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.IDFinan#">

    </cfquery>

    <cfif rsExisteDet.valor NEQ 0>
        <cfset existeDet = true> <script>alert("El detalle ya existe");history.back();</script>

    <cfelse>
        <cfquery name="rsExisteDetHistorico" datasource="#Session.DSN#">
            select count(1) as valor
          from DetFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and IDFinan = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.IDFinan#">

        </cfquery>

        <cfif rsExisteDetHistorico.valor NEQ 0>
            <cfset existeDet = true> <script>alert("El detalle ya existe en el historico");</script>
        </cfif>
    </cfif>
    <!---cfquery name="rsFormaPago" datasource="#Session.DSN#">
        select IDFormaPago, FormaPago
            from CatFormaPago
        where FormaPago = '#Form.FormaPago#'
    </cfquery--->
    <cfif not existeDet>
        <cftransaction>
            <cfquery name="rsInsertDFinan" datasource="#session.DSN#">
                insert into DetFinanciamiento (Ecodigo, IDFinan, SaldoInicial, SaldoInsoluto, TasaAnual, IVA, FormaPago, TasaMensual, RentaDiaria,
				 NumPagos, BMUsucodigo,StatusD,StsInstFin)
                values  (   #Session.Ecodigo# ,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDFinan#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Form.SaldoInicial#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInsoluto#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaAnual#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.Iva#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.FormaPago#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaMensual#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Form.NumPagos#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Usucodigo#">,
							0
							<cfif isdefined("Form.StsInstFin")>
				  			 ,<cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="1">
							<cfelse>
							 ,<cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="0">
							</cfif> )

            </cfquery>
            <cfset modo = "CAMBIO">
        </cftransaction>
        <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
    </cfif>
</cfif>

<cfif isdefined("Form.BorrarD")>
<cfquery name="rsDele" datasource="#session.DSN#">
                delete from DetFinanciamiento
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
</cfquery>
<cfset modo     = "CAMBIO">
<cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
</cfif>

<cfif isdefined("Form.ModificarD")>
	 <cftransaction>
	<cfquery name="rsUpdtD" datasource="#session.DSN#">
                update DetFinanciamiento
				set SaldoInicial = <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Form.SaldoInicial#">,
                SaldoInsoluto = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInsoluto#">,
                TasaAnual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaAnual#">,
                IVA = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.Iva#">,
                FormaPago = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.FormaPago#">,
                TasaMensual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaMensual#">,
                RentaDiaria = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                NumPagos = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Form.NumPagos#">
				<cfif isdefined("Form.StsInstFin")>
				  ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="1">
				<cfelse>
				 ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="0">
				</cfif>
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>
<cfset modo     = "CAMBIO">
<cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
</cfif>


<!--- CONFIRMAR EL PAGO --->
<cfif isdefined("Form.RegistroPago") >
 <cfset aceptaPago ="S">
<cfif Form.Origen eq 'TBS'>
	<!--- Validacion del Pago en Tesoreria --->

	<cfquery name="ConsulTAExt" datasource="tesoreria">
		select *
        from amortizaciones_de_compras
        where linea_credito_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.lineacaux#">
		and compania_prop_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsultEmp.CodICTS#">
	</cfquery>

	<cfquery name="ConsulTAExtD" datasource="tesoreria">
		 select pagado,pago_linea_credito_id,amort_compra_id
         from amortizaciones_de_compras_det
         where amort_compra_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsulTAExt.amort_compra_id#">
		 and amort_compra_det_id = #Form.Estado#
	</cfquery>

	<cfif ConsulTAExtD.pagado neq 1>
		<script>
		alert('El pago no ha sido realizado en la Tesoreria, favor validar.');
		</script>
		<cfset aceptaPago ="N">
	</cfif>

</cfif>

<cfif aceptaPago eq 'S'>

<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor as Mes from Parametros
    where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Pcodigo =60
</cfquery>
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as Periodo from Parametros
    where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Pcodigo =50
</cfquery>

<cfquery name="TablaAmort" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
		and NumPago=#Form.Estado#
</cfquery>
<cfquery name="TablaAmort2" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
		and NumPago=#Form.Estado# + 1
</cfquery>

	<cfset DocNomb1= #Form.Documento#>
	<cfset DocNomb2= #Form.Documento#>

	<cfquery name="ConsulTAExtF1" datasource="tesoreria">
			 select flujo_id
			 from rel_lineas_flujos
			 where linea_credito_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsulTAExtD.pago_linea_credito_id#">
	</cfquery>


<cfif ConsulTAExtF1.recordCount gt 0>

<cfloop query="ConsulTAExtF1">

		<cfquery name="ConsExtFN1" datasource="tesoreria">
				 select flujo_descripcion, concepto_id
				 from flujos
				 where flujo_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsulTAExtF1.flujo_id#">
		</cfquery>

	<cfif ConsExtFN1.concepto_id eq 79>
		<cfset DocNomb1= #ConsExtFN1.flujo_descripcion#>
    </cfif>

	<cfif ConsExtFN1.concepto_id eq 80>
		<cfset DocNomb2= #ConsExtFN1.flujo_descripcion#>
	</cfif>
</cfloop>
</cfif>

<!--- BUSQUEDA DE POLISA CON EL MISMO FLUJO --->
<cfset PolisaBanco = 0>
<cfquery name="rsConDContables1" datasource="#session.dsn#">
          select *
		  from DContables
		  where Ddocumento = <cfqueryparam value="#DocNomb1#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="rsConDContables2" datasource="#session.dsn#">
          select *
		  from HDContables
		  where Ddocumento = <cfqueryparam value="#DocNomb1#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif rsConDContables1.recordCount gt 0 || rsConDContables2.recordCount gt 0>
	<cfset PolisaBanco = 1>
</cfif>



<!--- ***************************************** --->
<cfswitch expression="#Month(TablaAmort.FechaPagoBanco)#">
	<cfcase value="1">
		<cfset NomMes="Enero">
	</cfcase>
	<cfcase value="2">i
		<cfset NomMes="Febrero">
	</cfcase>
	<cfcase value="3">
		<cfset NomMes="Marzo">
	</cfcase>
	<cfcase value="4">
		<cfset NomMes="Abril">
	</cfcase>
	<cfcase value="5">
		<cfset NomMes="Mayo">
	</cfcase>
	<cfcase value="6">
		<cfset NomMes="Junio">
	</cfcase>
	<cfcase value="7">
		<cfset NomMes="Julio">
	</cfcase>
	<cfcase value="8">
		<cfset NomMes="Agosto">
	</cfcase>
	<cfcase value="9">
		<cfset NomMes="Septiembre">
	</cfcase>
	<cfcase value="10">
		<cfset NomMes="Octubre">
	</cfcase>
	<cfcase value="11">
		<cfset NomMes="Noviembre">
	</cfcase>
	<cfcase value="12">
		<cfset NomMes="Diciembre">
	</cfcase>
</cfswitch>

  <cftransaction>
<cfset Periodo ="#rsPeriodo.Periodo#">
<cfset Mes = "#rsMes.Mes#">
<cfinvoke
   component="sif.Componentes.Contabilidad"
   method="Nuevo_Asiento"
   returnvariable="Nuevo_AsientoRet">
    <cfinvokeargument name="Cconcepto" value="0"/>
   <cfinvokeargument name="Oorigen" value=" "/>
   <cfinvokeargument name="Eperiodo" value="#Periodo#"/>
   <cfinvokeargument name="Emes" value="#Mes#"/>
   <cfinvokeargument name="Edocumento" value="0"/>
 </cfinvoke>
<cfset referencia="Financiamiento#Periodo##Mes#">
<!--- ****************** PAGO AL BANCO ****************** --->
<!--- INSERCION DEL ENCABEZADO  --->
<cfif PolisaBanco eq 0> <!--- Hace la validacion si ya existe la polisa, en caso de ser 0, se puede crear la polisa --->
		 <cfquery name="insertarE" datasource="#session.dsn#">
            	insert into EContables (Ecodigo,Cconcepto,Eperiodo,Emes,Edocumento,Efecha,
            	Edescripcion,Edocbase,Ereferencia,ECauxiliar,ECusuario,ECtipo,ECfechacreacion,
            	ECestado,ECreversible,BMUsucodigo,ECrecursivo,ECrecordarForm)
                values
                (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.FechaPagoBanco#" cfsqltype="CF_SQL_DATE">,
                 <cfqueryparam value="P#Form.Estado# #Form.documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#Form.descripcion# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="S" cfsqltype="cf_sql_char">,
                 '#session.usulogin#',
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">,   <!--- Puede cambiar la variable --->
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 #session.usucodigo#,0,0)
				<cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>

	<!--- Obtenemos el Id de EContables --->
	<cf_dbidentity2 datasource="#session.DSN#" name="insertarE">
	<cfset IdContable = #insertarE.identity#>
<cfelse>
</cfif><!--- Fin del If de la poliza existente --->
<!--- Insertamos DContables PagoBanco --->
 <cfset montLoc=TablaAmort.Capital * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


<cfif PolisaBanco eq 0><!--- Hace la validacion si ya existe la poliza, en caso de ser 0, se puede crear la polisa (2)--->
          <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 1,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="CXP al banco" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#DocNomb1#" cfsqltype="cf_sql_varchar">,
	   			 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.cuentapbanco#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_cuentapbanco#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.Capital#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>

<!--- Insertamos DContables Interes --->
<cfif isdefined("Form.InstrumentoF") and Form.InstrumentoF eq 1>
	<cfset GastInst = #Form.gastinsf.replace(",","")#>
    <cfset Interes= TablaAmort.Intereses - GastInst>
<cfelse>
	<cfset Interes= TablaAmort.Intereses>
</cfif>

<cfset montLoc=Interes * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


			 <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 2,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Intereses pagados" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#DocNomb2#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.cuentainteres#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_cuentainteres#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Interes#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>

 <cfif isdefined("Form.InstrumentoF") and Form.InstrumentoF eq 1>
<!--- Insertamos DContables Gasto --->

<cfset montLoc=GastInst * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


			<cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 3,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Gasto por instrumentos financieros" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#DocNomb2#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.cuentagasto#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_cuentagasto#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#GastInst#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>
</cfif>


<!--- Insertamos DContables Banco --->

<cfset montLoc=TablaAmort.PagoMensual * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


			<cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 4,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Banco" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#DocNomb1#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'C',
                 <cfqueryparam value="#Form.cuentabanco#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_cuentabanco#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.PagoMensual#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>
</cfif> <!--- Fin del If2 de Poliza existente --->
<!--- ****************** PAGO MTM Principal ****************** --->
<!--- Inicio If Instrumento Financiero --->
<cfif isdefined("Form.InstrumentoF") and Form.InstrumentoF eq 1>
	<cfinvoke
   component="sif.Componentes.Contabilidad"
   method="Nuevo_Asiento"
   returnvariable="Nuevo_AsientoRet">
    <cfinvokeargument name="Cconcepto" value="0"/>
   <cfinvokeargument name="Oorigen" value=" "/>
   <cfinvokeargument name="Eperiodo" value="#Periodo#"/>
   <cfinvokeargument name="Emes" value="#Mes#"/>
   <cfinvokeargument name="Edocumento" value="0"/>
 </cfinvoke>
<cfset referencia="MTM #Periodo##Mes#">
<!--- INSERCION DEL ENCABEZADO  --->
		<cfquery name="insertarE" datasource="#session.dsn#">
            	insert into EContables (Ecodigo,Cconcepto,Eperiodo,Emes,Edocumento,Efecha,
            	Edescripcion,Edocbase,Ereferencia,ECauxiliar,ECusuario,ECtipo,ECfechacreacion,
            	ECestado,ECreversible,BMUsucodigo,ECrecursivo,ECrecordarForm)
                values
                (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.FechaPagoBanco#" cfsqltype="CF_SQL_DATE">,
                 <cfqueryparam value="MTM #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="MTM #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="S" cfsqltype="cf_sql_char">,
                 '#session.usulogin#',
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">,   <!--- Puede cambiar la variable --->
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value=1 cfsqltype="cf_sql_integer">,
                 #session.usucodigo#,0,0)
           <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>

	<!--- Obtenemos el Id de EContables --->
	<cf_dbidentity2 datasource="#session.DSN#" name="insertarE">
	<cfset IdContable = #insertarE.identity#>
<!--- Insertamos DContables Pago Instrumento Derivado (MTMPrin) --->
<cfset MTMPrin = #Form.MTMPrin.replace(",","")#>
 <cfset montLoc= MTMPrin * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>

<!---  <cf_dump var = #montLoc#> --->
           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 1,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="MTM #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="MTM #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.efectevalinst#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_efectevalinst#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#MTMPrin#" cfsqltype="cf_sql_float">,
                 #montLoc#,
				#Form.Mcodigo#,
				#Form.tipocambio#,
				#session.usucodigo#)
            </cfquery>

<!--- Insertamos DContables Pago Instrumento por pagar (MTMPrin) --->
           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 2,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="MTM #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="MTM #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'C',
                 <cfqueryparam value="#Form.instfd#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_instfd#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#MTMPrin#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>
<!--- Fin del If del instrumento Financiero --->
</cfif>
<!---- Póliza de Intereses cuando  no  traen  Instrumento  financiero --->
<cfif isdefined("Form.InstrumentoF") and  Form.InstrumentoF EQ 1>
<cfelse>
     <cfset Interes= TablaAmort.Intereses>
     <cfset montLoc=Interes * Form.tipocambio>
	 <cfset montLoc=#numberformat(montLoc, "9.00")#>
	|<cfinvoke component="sif.Componentes.Contabilidad"   method="Nuevo_Asiento"    returnvariable="Nuevo_AsientoRet">
       <cfinvokeargument name="Cconcepto" value="0"/>
       <cfinvokeargument name="Oorigen" value=" "/>
       <cfinvokeargument name="Eperiodo" value="#Periodo#"/>
       <cfinvokeargument name="Emes" value="#Mes#"/>
       <cfinvokeargument name="Edocumento" value="0"/>
     </cfinvoke>
     <cfset referencia="IntDev #Periodo##Mes#">
     <cfquery name="insertarE" datasource="#session.dsn#">
            	insert into EContables (Ecodigo,Cconcepto,Eperiodo,Emes,Edocumento,Efecha,
            	Edescripcion,Edocbase,Ereferencia,ECauxiliar,ECusuario,ECtipo,ECfechacreacion,
            	ECestado,ECreversible,BMUsucodigo,ECrecursivo,ECrecordarForm)
                values
     			(<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.FechaPagoBanco#" cfsqltype="CF_SQL_DATE">,
                 <cfqueryparam value="IntDev #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="S" cfsqltype="cf_sql_char">,
                 '#session.usulogin#',
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">,   <!--- Puede cambiar la variable --->
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 0,#session.usucodigo#,0,0)
           <cf_dbidentity1 datasource="#session.DSN#">
     </cfquery>
     <!--- Obtenemos el Id de EContables --->
	<cf_dbidentity2 datasource="#session.DSN#" name="insertarE">
	<cfset IdContable = #insertarE.identity#>
    <cfquery name="InsDeb" datasource="#session.dsn#">
        insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
        Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
        values
        (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
         1,
         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
         <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value="Intereses Devengados #Form.Documento#" cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="IntDev #NomMes#" cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
         'D',
         <cfqueryparam value="#Form.IntPPD#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value="#Form.cfcuenta_intppd#" cfsqltype="cf_sql_integer">,
         <cfqueryparam value="#Interes#" cfsqltype="cf_sql_float">,
         #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
    </cfquery>
     <cfquery name="InsCred" datasource="#session.dsn#">
          insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
          Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
          values
          (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
           2,
           <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
           <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value="Interes No Devengados #Form.Documento#" cfsqltype="cf_sql_varchar">,
           <cfqueryparam value="IntNoDev #NomMes#" cfsqltype="cf_sql_varchar">,
           <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
           'C',
           <cfqueryparam value="#Form.intppc#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value="#Form.cfcuenta_intppc#" cfsqltype="cf_sql_integer">,
           <cfqueryparam value="#Interes#" cfsqltype="cf_sql_float">,
           #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
      </cfquery>
</cfif>
<!--- ****************** POLIZA DEL INTERES DEVENGADO NO PAGADO (SWAP) ****************** --->
<cfif isdefined("Form.InteresDNoC")>
<cfinvoke
   component="sif.Componentes.Contabilidad"
   method="Nuevo_Asiento"
   returnvariable="Nuevo_AsientoRet">
    <cfinvokeargument name="Cconcepto" value="0"/>
   <cfinvokeargument name="Oorigen" value=" "/>
   <cfinvokeargument name="Eperiodo" value="#Periodo#"/>
   <cfinvokeargument name="Emes" value="#Mes#"/>
   <cfinvokeargument name="Edocumento" value="0"/>
 </cfinvoke>
<cfset referencia="IntDevNP #Periodo##Mes#">
<!--- INSERCION DEL ENCABEZADO  --->
		<cfquery name="insertarE" datasource="#session.dsn#">
            	insert into EContables (Ecodigo,Cconcepto,Eperiodo,Emes,Edocumento,Efecha,
            	Edescripcion,Edocbase,Ereferencia,ECauxiliar,ECusuario,ECtipo,ECfechacreacion,
            	ECestado,ECreversible,BMUsucodigo,ECrecursivo,ECrecordarForm)
                values
                (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#TablaAmort.FechaPagoBanco#" cfsqltype="CF_SQL_DATE">,
                 <cfqueryparam value="IntDevNP #Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#Form.Documento# #mid(NomMes,1,3)#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="S" cfsqltype="cf_sql_char">,
                 '#session.usulogin#',
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">,   <!--- Puede cambiar la variable --->
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 1,#session.usucodigo#,0,0)
           <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>

	<!--- Obtenemos el Id de EContables --->
	<cf_dbidentity2 datasource="#session.DSN#" name="insertarE">
	<cfset IdContable = #insertarE.identity#>

<!--- Insertamos DContables Interes por Prestamos --->
<cfset IntDVN =#Form.InteresDNoC.replace(",","")#>
<cfset IntDevN =IntDVN>
<cfif isdefined("Form.InstrumentoF") and  Form.InstrumentoF eq 1>
	<cfset Swap = #Form.swap.replace(",","")#>
	<cfset IntDevN=IntDVN - Swap>
</cfif>

<cfset montLoc= IntDevN * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 1,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Interes por Prestamos" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="IntDevNP #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.IntPPD#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_intppd#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#IntDevN#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>


<!--- Insertamos DContables  Gasto por int financieros (Swap) --->
<cfif isdefined("Form.InstrumentoF") and  Form.InstrumentoF eq 1>
<cfset montLoc= Swap * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 2,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Gasto por Int Financiero" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="IntDevNP #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#Form.ccswapd#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_ccswapd#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Swap#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>

<!--- Insertamos DContables  Gasto por int financieros (Swap) Credito --->
<cfset montLoc= Swap * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>


           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 4,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Gasto por Int Financiero" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="IntDevNP #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'C',
                 <cfqueryparam value="#Form.ccswapc#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_ccswapc#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Swap#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>
</cfif>
<!--- Insertamos DContables Interes por Prestamos Credito--->
<cfset montLoc= IntDevN * Form.tipocambio>
<cfset montLoc=#numberformat(montLoc, "9.00")#>

           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 3,
		 		 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="Interes por Prestamos" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="IntDevNP #NomMes#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'C',
                 <cfqueryparam value="#Form.intppc#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Form.cfcuenta_intppc#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#IntDevN#" cfsqltype="cf_sql_float">,
                 #montLoc#,#Form.Mcodigo#,#Form.tipocambio#,#session.usucodigo#)
            </cfquery>



</cfif>
<!--- ************************************************************************ --->

	<cfquery name="PagoTabla" datasource="#session.DSN#">
                update TablaAmortFinanciamiento
				set Estado =1,
				    CPBanco=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.cuentapbanco#">,
				    CIntP=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.cuentainteres#">,
			 	<cfif isdefined("Form.InteresDNoC")>
				    IntDevengNoPag=<cf_jdbcquery_param cfsqltype ="cf_sql_money"  value ="#Form.InteresDNoC#">,
				    CIntDNCD=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IntPPD#">,
					CIntDNCC=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.intppc#">,
				</cfif>
				<cfif isdefined("Form.InstrumentoF") and  Form.InstrumentoF eq 1>
					MontoMTM=<cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#Form.GastInsF#">,
					Swap = <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#Form.Swap#">,
				    MTMPrin=<cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#Form.MTMPrin#">,
				    CGastP=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.cuentagasto#">,
				    CMTMPrinD=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.efectevalinst#">,
				    CMTMPrinC=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.instfd#">,
					CSwapD=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.ccswapd#">,
					CSwapC=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.ccswapc#">,
				</cfif>
				    CBanco=<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.cuentabanco#">
				where IDFinan = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">
				and Ecodigo = <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
				and NumPago = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.Estado#">
	</cfquery>
	 </cftransaction>
<cfset EstadoS = #Form.Estado# + 1>

	<cfquery name="BuscaNuevoSI" datasource="#session.DSN#">
	select SaldoInsoluto
	from TablaAmortFinanciamiento
	where IDFinan = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">
	and Ecodigo = <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
	and NumPago = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#EstadoS#">
</cfquery>

<cfif BuscaNuevoSI.recordCount neq 0>
	<cftransaction>
	<cfquery name="Status1" datasource="#session.DSN#">
                update DetFinanciamiento set
				SaldoInsoluto = <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#BuscaNuevoSI.SaldoInsoluto#">
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDFinan#">
	</cfquery>
	 </cftransaction>
	 <cfset modo = "CAMBIO">
	  <script>
		 <cfoutput>
		  var #toScript(PolisaBanco,"PolisaBanc")#;
		   var #toScript(DocNomb1,"Flujo")#;
		 </cfoutput>

		  alert('Pago Registrado');
	  	if(PolisaBanc == 1){
	  		alert('La Póliza del  Movimiento  Bancario con el  Documento '+Flujo+' ya existe.');
	  	}
		</script>
<cfelse>
<!--- Pago final --->
<cftransaction>
	<cfquery name="StatusFin" datasource="#session.DSN#">
                update EncFinanciamiento
				set	StatusE =1
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.IDFinan#">
	</cfquery>
	 </cftransaction>

<script>alert("Se han registrado todos los Pagos");</script>
<cfset modo = 'INICIO'>
<!--- Fin del pago final --->
</cfif>



</cfif>

</cfif>



<!--- ACEPTAR TABLA --->
<cfif isdefined("Form.AgregarT") >

  <cftransaction>
	<cfquery name="Status2" datasource="#session.DSN#">
                update DetFinanciamiento
				set StatusD =2
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>
	    <cfset modo = "CAMBIO">
   <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
</cfif>


<!--- BOTON RECHAZAR TABLA --->

<cfif isdefined("Form.BorrarT") >
	<cfset vacio=1>
	<cfloop condition= "vacio eq 1">
		<cfquery name="conse" datasource="#session.DSN#">
			delete from TablaAmortFinanciamiento
            where IDFinan = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">
			and Ecodigo = <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
		</cfquery>

		<cfquery name="cons" datasource="#session.DSN#">
			select * from TablaAmortFinanciamiento
		</cfquery>

		<cfif cons.recordcount eq 0>
			<cfset vacio=2>
		</cfif>
	</cfloop>

	<cfquery name="LlenaTablaA" datasource="#session.DSN#">
		delete from TablaAmortFinanciamiento
		where IDFinan = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">
		and Ecodigo = <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
	</cfquery>

	<cftransaction>


	<cfquery name="StatusConsult1" datasource="#session.DSN#">
                select *
				from DetFinanciamiento
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>

	<cfquery name="Status1" datasource="#session.DSN#">
                update DetFinanciamiento
				set StatusD =0,
				SaldoInsoluto = <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#StatusConsult1.SaldoInicial#">
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>
	    <cfset modo = "CAMBIO">
   <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
</cfif>

<!--- INICIO DEL IF DE FORM IMPORTAR ************************************************--->
<cfif isdefined("Form.Importar")>
<cfset validaInt = "OK">

	<cfquery name="rsExisteEncab2" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
         where Ecodigo     =  #Session.Ecodigo#
           and Documento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Documento#">
           and IDFinan <> <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
    </cfquery>

	<cfquery name="rsExisteLC2" datasource="#Session.DSN#">
        select count(1) as valor
          from EncFinanciamiento
          where Ecodigo     =  #Session.Ecodigo#
          and LineaC = <cfqueryparam cfsqltype="cf_sql_numeric"    value="#Form.LineaC#">
		  and IDFinan <> <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
    </cfquery>

    <cfif rsExisteEncab2.valor NEQ 0>
        <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('El Documento ya Existe, Verifica el Documento');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

	<cfif rsExisteLC2.valor NEQ 0>
	   <cfset existe = true>
		<script language="JavaScript1.2" type="text/javascript">
		alert('La Linea de Credito ya Existe, Verifica la Linea de Credito');
		</script>
		<cfset validaInt = "NOK">
	</cfif>

     <cfif validaInt eq "OK">
<cfquery name="rsUpd" datasource="#session.DSN#">
                update EncFinanciamiento
				set
				LineaC = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.LineaC#">
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.idfinan#">
</cfquery>

	 <cftransaction>
	<cfquery name="rsUpdtD" datasource="#session.DSN#">
                update DetFinanciamiento
				set SaldoInicial = <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Form.SaldoInicial#">,
                SaldoInsoluto = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInsoluto#">,
                TasaAnual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaAnual#">,
                IVA = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.Iva#">,
                FormaPago = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.FormaPago#">,
                TasaMensual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaMensual#">,
                RentaDiaria = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                NumPagos = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Form.NumPagos#">
				<cfif isdefined("Form.StsInstFin")>
				  ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="1">
				<cfelse>
				 ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="0">
				</cfif>
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>

	<cfquery name="ConsulTAExt" datasource="tesoreria">
		select *
        from amortizaciones_de_compras
        where linea_credito_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.lineac#">
		and compania_prop_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsultEmp.CodICTS#">
	</cfquery>

	<cfif ConsulTAExt.recordcount eq 0>
	<script>
		alert('La Linea de Credito ingresada, no se encuentra en el TBS, favor de verificar el Numero.');
	</script>

	<cfelse>
		<cfquery name="ConsulTAExtD" datasource="tesoreria">
		 select *
         from amortizaciones_de_compras_det
         where amort_compra_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsulTAExt.amort_compra_id#">
	    </cfquery>

	    <cfquery name="ConsultAExtPag" datasource="tesoreria">
		 select count(pagado) as NoIDD
         from amortizaciones_de_compras_det
         where amort_compra_id = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#ConsulTAExt.amort_compra_id#">
	    </cfquery>


<!--- VALIDACION DE LOS CAMPOS DEL DETALLE --->
<cfset SaldoI = #form.SaldoInicial.replace(",","")# >
<cfset TasaA = #form.TasaAnual#>
<cfset TasaA = TasaA / 100>

<cfset erroT = ''>

  <cfif ConsulTAExt.monto_capital neq SaldoI && erroT eq ''>
  	<script> alert('El Saldo inicial no es igual al de la Tesoreria, favor de verificarlo.');</script>
<cfset erroT = '1'>
  </cfif>

  <cfif TasaA neq ConsulTAExt.tasa_con_banco && erroT eq ''>
  	<script> alert('La Tasa Anual no es igual al de la Tesoreria, favor de verificarlo.');</script>
<cfset erroT = '1'>
  </cfif>

  <cfif ConsulTAExt.udm_plazo neq Form.FormaPago && erroT eq ''>
	<script> alert('La Forma de Pago no es igual al de la Tesoreria, favor de verificarlo.');</script>
	<cfset erroT = '1'>
  </cfif>

  <cfif ConsulTAExt.plazo neq Form.NumPagos && erroT eq ''>
	<script> alert('El Numero de Pagos no es igual al de la Tesoreria, favor de verificarlo.');</script>
	<cfset erroT = '1'>
  </cfif>
<!--- ***************************************************************************************--->

<cfif ConsulTAExtD.recordcount eq 0 && erroT eq ''>
   	<script> alert('No Existe actualmente la Tabla de Tesoreria, pruebe mas tarde.');</script>
<cfelseif ConsulTAExtD.fecha_planeada_pago eq '' && erroT eq ''>
<script> alert('La Tabla de Tesoreria no esta disponible, porque no tiene Fechas.');</script>
<cfelse>
<!--- LLENAMOS LA TABLA DE LA TESORERIA --->
<cfif erroT eq ''>
<cfloop query="ConsulTAExtD">
<!--- Fecha corte 2 --->
	 <cfset valfecha = 1>

	<cfloop condition = "valfecha LESS THAN 2">
		<cfif Month(ConsulTAExtD.fin_periodo) eq 1 || Month(ConsulTAExtD.fin_periodo) eq 3 ||Month(ConsulTAExtD.fin_periodo) eq 5 ||Month(ConsulTAExtD.fin_periodo) eq 7 ||
		Month(ConsulTAExtD.fin_periodo) eq 8 ||Month(ConsulTAExtD.fin_periodo) eq 10 ||Month(ConsulTAExtD.fin_periodo) eq 12>
			<cfset FechaCorte2 = DateAdd("d",(31 - (Day(ConsulTAExtD.fin_periodo))),ConsulTAExtD.fin_periodo)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(ConsulTAExtD.fin_periodo) eq 4 ||Month(ConsulTAExtD.fin_periodo) eq 6 ||Month(ConsulTAExtD.fin_periodo) eq 9 ||	Month(ConsulTAExtD.fin_periodo) eq 11>
			<cfset FechaCorte2 = DateAdd("d",(30 - (Day(ConsulTAExtD.fin_periodo))),ConsulTAExtD.fin_periodo)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(ConsulTAExtD.fin_periodo) eq 2>
		  <cfset FechaCorte2 = DateAdd("d",(29 - (Day(ConsulTAExtD.fin_periodo))),ConsulTAExtD.fin_periodo)>
			<cfif Month(FechaCorte2) neq 2>
				<cfset FechaCorte2 = DateAdd("d",-1,FechaCorte2)>
			</cfif>
		 <cfset valfecha = 3>
		</cfif>

	 </cfloop>
<!--- obtenemos la fecha del corte --->
	<cfset valfecha = 1>

	<cfloop condition = "valfecha LESS THAN 2">
		<cfif Month(ConsulTAExtD.inicio_periodo) eq 1 || Month(ConsulTAExtD.inicio_periodo) eq 3 ||Month(ConsulTAExtD.inicio_periodo) eq 5 ||Month(ConsulTAExtD.inicio_periodo) eq 7 ||
		Month(ConsulTAExtD.inicio_periodo) eq 8 ||Month(ConsulTAExtD.inicio_periodo) eq 10 ||Month(ConsulTAExtD.inicio_periodo) eq 12>
			<cfset FechaCorte = DateAdd("d",(31 - (Day(ConsulTAExtD.inicio_periodo))),ConsulTAExtD.inicio_periodo)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(ConsulTAExtD.inicio_periodo) eq 4 ||Month(ConsulTAExtD.inicio_periodo) eq 6 ||Month(ConsulTAExtD.inicio_periodo) eq 9 ||	Month(ConsulTAExtD.inicio_periodo) eq 11>
			<cfset FechaCorte = DateAdd("d",(30 - (Day(ConsulTAExtD.inicio_periodo))),ConsulTAExtD.inicio_periodo)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(ConsulTAExtD.inicio_periodo) eq 2>
		  <cfset FechaCorte = DateAdd("d",(29 - (Day(ConsulTAExtD.inicio_periodo))),ConsulTAExtD.inicio_periodo)>
			<cfif Month(FechaCorte) neq 2>
				<cfset FechaCorte = DateAdd("d",-1,FechaCorte)>
			</cfif>
		 <cfset valfecha = 3>
		</cfif>

	 </cfloop>

<!--- Fin de la Fecha de Corte --->

<cfset DiasPer= DateDiff("d",ConsulTAExtD.inicio_periodo,ConsulTAExtD.fecha_planeada_pago)>
<cfset MontMen= #ConsulTAExtD.monto_pago_capital# + #ConsulTAExtD.monto_pago_intereses#>
<cfset IvaD=#Form.IVA# * #MontMen#>
<cfset interesDNP = (ConsulTAExtD.monto_pago_intereses/DiasPer) * (DateDiff("d",ConsulTAExtD.inicio_periodo,FechaCorte))>
<cfset OrigenT= "TBS">
 <cftransaction>
	<cfquery name="LlenaTablaA" datasource="#session.DSN#">
		 insert into TablaAmortFinanciamiento
		 (IDFinan,Ecodigo,NumPago,FechaInicio,FechaPagoBanco,FechaPagoPMI,DiasPeriodo,SaldoInsoluto,Capital,Intereses,
		 PagoMensual,IVA,Estado,BMUsucodigo,FechaCierre,IntDevengNoPag,Origen)
		 values (<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value = "#ConsulTAExtD.amort_compra_det_id#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#ConsulTAExtD.inicio_periodo#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#ConsulTAExtD.fin_periodo#">,
		 <cf_jdbcquery_param cfsqltype ="cf_sql_date" value = "#ConsulTAExtD.fecha_planeada_pago#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value = "#DiasPer#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#ConsulTAExtD.bal_amort_compra_capital#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#ConsulTAExtD.monto_pago_capital#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#ConsulTAExtD.monto_pago_intereses#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value="#MontMen#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#IvaD#">,
		 '#ConsulTAExtD.pagado#',
		 <cf_jdbcquery_param cfsqltype = "cf_sql_numeric" value = "#Session.usucodigo#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#FechaCorte2#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#interesDNP#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_varchar" value = "#OrigenT#">)
	</cfquery>
 </cftransaction>

</cfloop>

<!--- CAMBIAMOS EL STATUS DEL DETALLE --->
<cfset EstadoS = #ConsultAExtPag.NoIDD# + 1>

<cfquery name="LlenaTablaSaldo" datasource="#session.DSN#">
	select SaldoInsoluto
	from TablaAmortFinanciamiento
	where Ecodigo=<cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
	and NumPago = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#EstadoS#">
</cfquery>

	<cftransaction>
	<cfquery name="Status1" datasource="#session.DSN#">
                update DetFinanciamiento
				set StatusD = 1,
			<cfif LlenaTablaSaldo.recordCount gt 0>
				SaldoInsoluto = <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#LlenaTablaSaldo.SaldoInsoluto#">
			<cfelse>
				SaldoInsoluto = 0
			</cfif>
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>

<!--- INTERES DEVENGADO NO PAGADO MODIFICACION --->
<cfquery name="TablaAmort5" datasource="#session.DSN#">
		select count(1) contabilizado
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
</cfquery>

<cfloop index="a" from="1" to ="#TablaAmort5.contabilizado#">

	<cfquery name="TablaAmortAux1" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
		and NumPago = #a# +1
	</cfquery>

		<cfif TablaAmortAux1.RecordCount gt 0>
			<cfquery name="ModificaInteresDNC" datasource="#session.DSN#">
				update TablaAmortFinanciamiento
				set IntDevengNoPag = #TablaAmortAux1.IntDevengNoPag#
		        where Ecodigo = #Session.Ecodigo#
				and IDFinan = #Form.IDFinan#
				and NumPago = #a#
		    </cfquery>
		<cfelse>
		      <cfquery name="ModificaInteresDNC" datasource="#session.DSN#">
				update TablaAmortFinanciamiento
				set IntDevengNoPag = 0
		        where Ecodigo = #Session.Ecodigo#
				and IDFinan = #Form.IDFinan#
				and NumPago = #a#
		    </cfquery>
		</cfif>

</cfloop>

   <cfset modo = "CAMBIO">
   <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">
  </cfif>
</cfif>
  </cfif>  </cfif>
</cfif>



<!---Funcion completa para el calculo --->

<cfif isdefined("CalcularT")>

	 <cftransaction>
	<cfquery name="rsUpdtD" datasource="#session.DSN#">
                update DetFinanciamiento
				set SaldoInicial = <cf_jdbcquery_param cfsqltype="cf_sql_money"   value="#Form.SaldoInicial#">,
                SaldoInsoluto = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.SaldoInsoluto#">,
                TasaAnual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaAnual#">,
                IVA = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.Iva#">,
                FormaPago = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.FormaPago#">,
                TasaMensual = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.TasaMensual#">,
                RentaDiaria = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.RentaDiariaNoIva#">,
                NumPagos = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#Form.NumPagos#">
				<cfif isdefined("Form.StsInstFin")>
				  ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="1">
				<cfelse>
				 ,StsInstFin = <cf_jdbcquery_param cfsqltype="cf_sql_integer"    value="0">
				</cfif>
				where Ecodigo = #Session.Ecodigo#
				and IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.idfinan#">
	</cfquery>
	 </cftransaction>



<cfset SaldoIn = #Form.saldoinsoluto.replace(",","")#>
<cfset TasaMensual = #Form.tasamensual# / 100>
<cfset tasmod = TasaMensual + 1>
<cfset NumeroPag = #Form.numpagos# * -1>
<cfset tasmodExp = tasmod ^ NumeroPag>
<cfset tasmodFinal = 1-tasmodExp>
<cfset FechaIni = #DateFormat(Form.fecha, 'dd/mm/yyyy')#>
<cfset FechaFin = DateAdd("d",30,FechaIni)>
<cfset FechaFinE = DateAdd("d",30,FechaIni)>

<cfif DayofWeek(FechaFin) eq 1>
	<cfset FechaFin = DateAdd("d",1,FechaFin)>
<cfelse>
  <cfif DayofWeek(FechaFin) eq 7>
    <cfset FechaFin = DateAdd("d",2,FechaFin)>
  </cfif>
</cfif>

<cfif DayofWeek(FechaFinE) eq 1>
	<cfset FechaFin = DateAdd("d",-2,FechaFinE)>
<cfelse>
  <cfif DayofWeek(FechaFinE) eq 7>
    <cfset FechaFin = DateAdd("d",-1,FechaFinE)>
  </cfif>
</cfif>

<cfset IVaT= #Form.IVA# / 100>
<cfset InteresM = Round((SaldoIn * TasaMensual)*100)/100 >
<cfset MontMens = Round((InteresM / tasmodFinal )*100)/100>
<cfset IVAM = Round((IVaT * MontMens)*100)/100>
<!---Inicio del loop del calculo--->

<cfloop from="1" to="#Form.numpagos#" index="incr">
<!--- OBTENER FECHA DE CORTE2 --->
<cfset valfecha = 1>

	<cfloop condition = "valfecha LESS THAN 2">
		<cfif Month(FechaFin) eq 1 || Month(FechaFin) eq 3 ||Month(FechaFin) eq 5 ||Month(FechaFin) eq 7 ||
		Month(FechaFin) eq 8 ||Month(FechaFin) eq 10 ||Month(FechaFin) eq 12>
			<cfset FechaCorte2 = DateAdd("d",(31 - (Day(FechaFin))),FechaFin)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(FechaFin) eq 4 ||Month(FechaFin) eq 6 ||Month(FechaFin) eq 9 ||	Month(FechaFin) eq 11>
			<cfset FechaCorte2 = DateAdd("d",(30 - (Day(FechaFin))),FechaFin)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(FechaFin) eq 2>
		  <cfset FechaCorte2 = DateAdd("d",(29 - (Day(FechaFin))),FechaFin)>
			<cfif Month(FechaCorte2) neq 2>
				<cfset FechaCorte2 = DateAdd("d",-1,FechaCorte2)>
			</cfif>
		 <cfset valfecha = 3>
		</cfif>

</cfloop>


<!--- OBTENER FECHA DE CORTE --->
<cfset valfecha = 1>

	<cfloop condition = "valfecha LESS THAN 2">
		<cfif Month(FechaIni) eq 1 || Month(FechaIni) eq 3 ||Month(FechaIni) eq 5 ||Month(FechaIni) eq 7 ||
		Month(FechaIni) eq 8 ||Month(FechaIni) eq 10 ||Month(FechaIni) eq 12>
			<cfset FechaCorte = DateAdd("d",(31 - (Day(FechaIni))),FechaIni)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(FechaIni) eq 4 ||Month(FechaIni) eq 6 ||Month(FechaIni) eq 9 ||	Month(FechaIni) eq 11>
			<cfset FechaCorte = DateAdd("d",(30 - (Day(FechaIni))),FechaIni)>
			<cfset valfecha = 3>
		</cfif>

		<cfif Month(FechaIni) eq 2>
		  <cfset FechaCorte = DateAdd("d",(29 - (Day(FechaIni))),FechaIni)>
			<cfif Month(FechaCorte) neq 2>
				<cfset FechaCorte = DateAdd("d",-1,FechaCorte)>
			</cfif>
		 <cfset valfecha = 3>
		</cfif>

</cfloop>

<!------------------------------------->

<cfset numPagoV = "#incr#">
<cfset InteresM = Round((SaldoIn * TasaMensual)*100)/100 >
<cfset CapitalM = MontMens - InteresM>
<cfset IVAM = Round((IVaT * InteresM)*100)/100>
<cfset difdias = DateDiff("d",FechaIni,FechaFinE)>
<cfset interesDNP = (InteresM/difdias) * (DateDiff("d",FechaIni,FechaCorte))>
<cfset OrigenT= 'TCalc'>


<cftransaction>
	<cfquery name="LlenaTablaA" datasource="#session.DSN#">
		 insert into TablaAmortFinanciamiento
		 (IDFinan,Ecodigo,NumPago,FechaInicio,FechaPagoBanco,FechaPagoPMI,DiasPeriodo,SaldoInsoluto,Capital,Intereses,
		 PagoMensual,IVA,BMUsucodigo,FechaCierre,IntDevengNoPag,Origen)
		 values (<cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#Form.IDFinan#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value = "#numPagoV#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#FechaIni#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#FechaFin#">,
		 <cf_jdbcquery_param cfsqltype ="cf_sql_date" value = "#FechaFinE#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_integer" value = #difdias#>,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#SaldoIn#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#CapitalM#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#InteresM#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value="#MontMens#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#IVAM#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_numeric" value = "#Session.usucodigo#">,
		 <cf_jdbcquery_param cfsqltype="cf_sql_date" value = "#FechaCorte2#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_money" value = "#interesDNP#">,
		 <cf_jdbcquery_param cfsqltype = "cf_sql_varchar" value = "#OrigenT#">)
	</cfquery>
 </cftransaction>

<cfset SaldoIn = SaldoIn - CapitalM>
<cfset FechaIni = FechaFin>


<cfset FechaFin = DateAdd("d",30,FechaIni)>
<cfset FechaFinE = DateAdd("d",30,FechaIni)>

<cfif DayofWeek(FechaFin) eq 1>
	<cfset FechaFin = DateAdd("d",1,FechaFin)>
<cfelse>
  <cfif DayofWeek(FechaFin) eq 7>
    <cfset FechaFin = DateAdd("d",2,FechaFin)>
  </cfif>
</cfif>

<cfif DayofWeek(FechaFinE) eq 1>
	<cfset FechaFin = DateAdd("d",-2,FechaFinE)>
<cfelse>
  <cfif DayofWeek(FechaFinE) eq 7>
    <cfset FechaFin = DateAdd("d",-1,FechaFinE)>
  </cfif>
</cfif>

</cfloop>

<!--- INTERES DEVENGADO NO PAGADO MODIFICACION --->
<cfquery name="TablaAmort5" datasource="#session.DSN#">
		select count(1) contabilizado
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
</cfquery>

<cfloop index="a" from="1" to ="#TablaAmort5.contabilizado#">

	<cfquery name="TablaAmortAux1" datasource="#session.DSN#">
		select *
        from TablaAmortFinanciamiento
        where Ecodigo = #Session.Ecodigo#
		and IDFinan = #Form.IDFinan#
		and NumPago = #a# +1
	</cfquery>

		<cfif TablaAmortAux1.RecordCount gt 0>
			<cfquery name="ModificaInteresDNC" datasource="#session.DSN#">
				update TablaAmortFinanciamiento
				set IntDevengNoPag = #TablaAmortAux1.IntDevengNoPag#
		        where Ecodigo = #Session.Ecodigo#
				and IDFinan = #Form.IDFinan#
				and NumPago = #a#
		    </cfquery>
		<cfelse>
		      <cfquery name="ModificaInteresDNC" datasource="#session.DSN#">
				update TablaAmortFinanciamiento
				set IntDevengNoPag = 0
		        where Ecodigo = #Session.Ecodigo#
				and IDFinan = #Form.IDFinan#
				and NumPago = #a#
		    </cfquery>
		</cfif>

</cfloop>


<cfset modo = "CAMBIO">
   <cflocation url="Financiamiento.cfm?&idfinan=#idfinan#&modo=#modo#&urlira=#urlira#&tipocambio=#form.tipocambio#">

</cfif>





<!---►►Borrar◄◄--->


<form action="Financiamiento.cfm" method="post" name="sql">

</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">
<cfoutput>
var #toScript(cambio,"cambio")#;
<cfif cambio eq ''>
var #toScript(idfinan,"idfinan")#;
var #toScript(urlira,"urlira")#;
var #toScript(modo,"modo")#;
</cfif>
</cfoutput>


if(cambio == '1'){window.history.back();
 } else{
		if(modo == 'INICIO'){
			document.forms[0].action="Financiamiento.cfm";
			document.forms[0].submit();

							}else{
								  document.forms[0].action="Financiamiento.cfm?idfinan="+idfinan+"&modo="+modo+"&urlira="+urlira;
					       		  document.forms[0].submit();
								 }
	  }

		</script>
	</body>
</html>
