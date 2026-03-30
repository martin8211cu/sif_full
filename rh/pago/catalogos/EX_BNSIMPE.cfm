
<!--- Ultima Actualización FC-08-11-2011
Estructura del archivo de Envío de las Empresas afiliadas al Servicio de Transferencias del DCD del Banco Popular 
--->

<cfparam name="url.Bid" 		default="0" >
<cfparam name="url.ERNid" 	 	default="0" >


<cfset pre=''>
<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "h">
 	<cfset pre='H'>
</cfif>

<cf_dbfunction name="OP_concat" returnvariable="concat">
<cf_dbfunction name="now" returnvariable="fechaAhora">
<cf_dbfunction name="date_format" args="#fechaAhora#,ddmmyyyy" returnvariable="laFecha">
<cf_dbfunction name="to_number" args="coalesce((a.#pre#DRNliquido*100),0)" returnvariable="miSalario"><!---- salario liquido  del registro de crédito--->


<cf_dbtemp name="data_tmp_BN" returnvariable="data_tmp_BN" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="salida" 		 	type="char(250)"  	mandatory="no">
</cf_dbtemp>


<cfquery name="rsPatrono" datasource="#session.DSN#">
	select Bcodigocli  as patrono	
    from Bancos 
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Bid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">         
</cfquery>
<cfset Errs1 = ''>

<cfif rsPatrono.RecordCount GT 0 and len(trim(rsPatrono.patrono)) gt 0>	
	<cfif len(trim(rsPatrono.patrono)) NEQ 15>
		<cfset Errs1 =  Errs1 & 'El C&oacute;digo de Patrono <b>"'&rsPatrono.patrono&'"</b> debe tener 15 digitos <br>'>
	</cfif>
	<cfif REFind("[^0-9]",trim(rsPatrono.patrono)) neq 0>
		<cfset Errs1 =  Errs1 & 'El C&oacute;digo de Patrono <b>"'&rsPatrono.patrono&'"</b>  debe contener &uacute;nicamente n&uacute;meros <br>'>
	</cfif>
<cfelse>
		<cfset Errs1 =  Errs1 & 'No se ha definido el <b>C&oacute;digo de Patrono.</b> <br>'>
</cfif>

<cfif Errs1 NEQ ''>
		<cfset Errs1 =  'Errores C&oacute;digo de Patrono<br><br>'& Errs1 & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos  y modifique los inconvenientes en el campo [C&oacute;digo de cliente]. <br><br><br>'>		
</cfif>




<cfquery name="rsEmpresas" datasource="asp">
	select Eidentificacion 	
    from Empresa
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">     
</cfquery>

<cfset Errs2 = ''>
<cfif rsEmpresas.RecordCount GT 0 and len(trim(rsEmpresas.Eidentificacion)) gt 0>	
			<cfif len(trim(rsEmpresas.EIdentificacion)) NEQ 15>
				<cfset Errs2 =  Errs2 & 'La Identificaci&oacute;n del cliente <b>"'&rsEmpresas.EIdentificacion&'"</b> debe tener 15 d&iacute;gitos <br>'>
			</cfif>
	
			<cfif REFind("[^0-9]",trim(rsEmpresas.EIdentificacion)) neq 0  >
				<cfset Errs2 =  Errs2 & 'La Identificaci&oacute;n del cliente <b>"'&rsEmpresas.EIdentificacion&'"</b>  debe contener &uacute;nicamente n&uacute;meros <br>'>
			</cfif>
<cfelse>
	<cfset Errs2= Errs2 & 'La cédula jurídica de esta Empresa  no esta definida<br>'>	
</cfif>
<cfif Errs2 NEQ ''>
		<cfset Errs2 = Errs2 & 'Ingrese a la Informaci&oacute;n de la Empresa (Administraci&oacute;n del Portal) y modifique la Identificaci&oacute;n<br><br><br>'>	
</cfif>



<cfquery datasource="#session.dsn#" name="SumatoriaMonto">
select   <cf_dbfunction name="to_number" args="coalesce(sum(a.#pre#DRNliquido)*100,0)"> as monto
from #pre#DRNomina a
		 inner join #pre#ERNomina b
		 on b.ERNid=a.ERNid 
		inner join DatosEmpleado de
			on de.DEid=a.DEid
		inner join Monedas m
			on m.Mcodigo=a.Mcodigo
where  a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
and  de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
</cfquery>				
<cfset cantidadCeros = RepeatString('0', (16 - len(SumatoriaMonto.monto)) )>
	
<cfset Errs3=''>
<!---Número de línea---->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="210" default="" returnvariable="ConsecutivoEmpresa"/>
<cfif len(ConsecutivoEmpresa) NEQ 5>	
		<cfset Errs3 =  Errs3 & 'Vuelva a la Exportaci&oacute;n de Archivos de  N&oacute;mina y en el campo <b>Consecutivo del archivo</b> defina un consecutivo de tama&ntilde;o 5<br><br><br>'>
</cfif>


<!---Número de CUENTA---->
<cfquery name="rsCuentasBancos" datasource="#session.DSN#">
select CBcc as NumeroCuenta
     from CuentasBancos
     where Bid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
</cfquery>
<cfset Errs4 =''>

<cfif rsCuentasBancos.RecordCount GT 0 and len(trim(rsCuentasBancos.NumeroCuenta)) gt 0>	
	<cfif len(trim(rsCuentasBancos.NumeroCuenta)) NEQ 17>
		<cfset Errs4 =  Errs4 & 'El n&uacute;mero de cuenta del Banco debe tener 17 caracteres num&eacute;ricos<br><br><br>'>
	</cfif>	
	
	<cfif REFind("[^0-9]",trim(rsCuentasBancos.NumeroCuenta)) neq 0>
		<cfset Errs4 =  Errs4 & 'El n&uacute;mero de cuenta del Banco debe ser &uacute;nicamente n&uacute;merico<br><br><br>'>
	</cfif>

	<cfif len(trim(rsCuentasBancos.NumeroCuenta)) EQ 0>
		<cfset Errs4 =  Errs4 & 'No se ha definido el N&uacute;mero de cuenta  del Banco. <br><br><br>'>
	</cfif>
<cfelse>
		<cfset Errs4 =  Errs4 & 'No se ha definido el N&uacute;mero de cuenta  del Banco. <br><br><br>'>
</cfif>

<cfquery name="rsMonedaEmpresa" datasource="#session.DSN#">
select coalesce(
                (select case  ltrim(rtrim(Miso4217))
                        when 'CRC' then   '01'
                         when  'USD'then  '02'
                         when 'EUR' then '03'
                        end 
                         
                from Monedas m 
                    inner join Empresas e 
                        on m.Mcodigo=e.Mcodigo 
                where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
,'99') as moneda 
from dual
</cfquery>


<cfquery name="rsDescripcionNomina" datasource="#session.DSN#">
select  #pre#ERNdescripcion as nombre
from #pre#ERNomina
where  ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>
<cfset cerosDescripcionNomina = RepeatString(' ', (45 - len(rsDescripcionNomina.nombre)) )>



<cfquery name="rsValidaCBccEmppleados" datasource="#session.DSN#">
		select de.CBcc, de.DEidentificacion, de.DEapellido1#concat#' '#concat#de.DEapellido2#concat#' '#concat#de.DEnombre as empleado
		from #pre#DRNomina a
				 inner join #pre#ERNomina b
				 on b.ERNid=a.ERNid 
				inner join DatosEmpleado de
					on de.DEid=a.DEid
				inner join Monedas m
					on m.Mcodigo=a.Mcodigo
		where  a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and  de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">  
</cfquery>
<cfset Errs5 = ''>

<cfloop query="rsValidaCBccEmppleados">
		<cfif len(trim(rsValidaCBccEmppleados.CBcc)) NEQ 17>
			<cfset Errs5 =  Errs5& 'La [Cuenta  Cliente]: #rsValidaCBccEmppleados.CBcc# <br>  del empleado <b>#rsValidaCBccEmppleados.DEidentificacion#</b> - #rsValidaCBccEmppleados.empleado#, no cumple con la cantidad de digitos deseados (17). <br>'>
		</cfif>
		<cfif REFind("[^0-9]",trim(rsValidaCBccEmppleados.CBcc)) neq 0>
			<cfset Errs5 =  Errs5 & 'La [Cuenta  Cliente] #rsValidaCBccEmppleados.CBcc# <br>  del empleado <b>#rsValidaCBccEmppleados.DEidentificacion#</b> - #rsValidaCBccEmppleados.empleado# debe contener &uacute;nicamente n&uacute;meros <br>'>
		</cfif>
</cfloop>
<cfif Errs5 NEQ ''>
	<cfset Errs5 =  Errs5 & '<u>Corriga los inconvenientes en el Cat&aacute;logo de Empleados, en el campo [Cuenta Cliente]</u> <br><br><br><br>'>
</cfif>
	
<cfset Errs=Errs1&Errs2&Errs3&Errs4&Errs5>

<cfset Errs = left(Errs, 1800)><!--- si sobre pasa 2000 caracteres se presenta error de uri muy largo (maximo 2048)--->

<cfif len(trim(Errs))>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
	<cfabort>
</cfif>

<cfset totalCorrelativos=Mid(rsCuentasBancos.NumeroCuenta, 11, 6)>
<cfloop query="rsValidaCBccEmppleados">
	<cfset totalCorrelativos = totalCorrelativos + Mid(rsValidaCBccEmppleados.CBcc, 11, 6)>
</cfloop>

<cfset cantidadCerosCorrelativos=''>
<cfif len(totalCorrelativos) lt 10>
	<cfset cantidadCerosCorrelativos = RepeatString('0', (10 - len(totalCorrelativos)) )>
</cfif>

<cfquery datasource="#session.dsn#" name="Encabezados">
select '1' <!----Tipo de registro (1)---->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#rsPatrono.patrono#">,15)<!----Identificación única del cliente según canal.---->
		#concat#'2' <!-----Tipo identificación del cliente--->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresas.EIdentificacion#">,15)<!----Identificación única del cliente según canal.---->
		#concat# #preservesinglequotes(laFecha)#<!---Fecha de procesamiento--->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 5)#"><!----Número de transferencia---->
		#concat#'1'<!----Tipo de transacción (modo de procesamiento)---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 4)#"><!----Código de error SFB---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 4)#"><!----Código de error Sinpe-Canales---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 16)#"><!----Monto total aplicado en SFB---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 16)#"><!----Monto total aplicado en Sinpe---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 7)#"> <!----Tipo cambio de compra---->
		#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 7)#"> <!----Tipo de cambio venta---->
		#concat#right(<cfqueryparam cfsqltype="cf_sql_char" value="#cantidadCeros&(SumatoriaMonto.monto*2)#">,16) <!----Sumatoria de montos----><!--- aqui se multiplica por 4 debido a que este monto representa la suma de los creditos, que a su vez es igual a la suma de debitos,  y se necesita que la "sumatoria de montos" sea (creditos + debitos) x 2, o sea (sum(creditos)) x 2--->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#cantidadCerosCorrelativos&totalCorrelativos#">,10) as datos<!----Sumatoria de correlativos---->

from dual
</cfquery>
<!------------------------------------------------        Registro de débito    ----------------------------------------------------->
<cfquery datasource="#session.dsn#" name="Debito">
select '2'<!---- Tipo de registro (2)---->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#ConsecutivoEmpresa#">,5) <!----Número de línea---->
		#concat#'1' <!-----Tipo de cuenta (SFB o CC)--->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#rsCuentasBancos.NumeroCuenta#">,17)<!---- Número de cuenta (SFB o CC)---->
		#concat#'00000001'<!----Número de comprobante----->
		#concat#right(<cfqueryparam cfsqltype="cf_sql_char" value="#cantidadCeros&SumatoriaMonto.monto#">,15) <!----Sumatoria de montos---->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#rsMonedaEmpresa.moneda#">,2) <!----Moneda del monto---->
		#concat#left(<cfqueryparam cfsqltype="cf_sql_char" value="#rsDescripcionNomina.nombre&cerosDescripcionNomina#">,45) <!----Concepto---->
		#concat#'00' as datos<!---- Estado del registro---->
from dual
</cfquery>
<cfquery datasource="#session.dsn#" name="Credito">
<!------------------------------------------------        Registro de crédito	 ----------------------------------------------------->
select '3'<!---- Tipo de registro (3)---->
		#concat#
		right('00000'
		#concat#(select <cf_dbfunction name="to_char" args="count(*) +2">
		 from #pre#DRNomina aa
			 inner join #pre#ERNomina bb
		 		 on bb.ERNid=aa.ERNid 
			inner join DatosEmpleado dea
				on dea.DEid=aa.DEid
		 where aa.ERNid=a.ERNid
		 and dea.Bid=de.Bid
		 and aa.DRNlinea < a.DRNlinea),5)<!---- Número de línea----->
		 
		#concat#'2' <!-----Tipo de cuenta (SFB o CC)----->
		#concat#left(de.CBcc,17)<!-----Número de cuenta (SFB o CC)----->
		
		#concat#
		right('00000000'
		#concat#(select <cf_dbfunction name="to_char" args="count(*) +2">
		 from #pre#DRNomina aa
			 inner join #pre#ERNomina bb
		 		 on bb.ERNid=aa.ERNid 
			inner join DatosEmpleado dea
				on dea.DEid=aa.DEid
		 where aa.ERNid=a.ERNid
		 and dea.Bid=de.Bid
		 and aa.DRNlinea < a.DRNlinea),8)<!-----Número de comprobante   ----->
		 
		 #concat#right(<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString('0', 15)#">#concat#<cf_dbfunction name="to_char" args="#miSalario#">,15)<!---Monto incluido decimales---->
		 
		 
		 #concat# left(	(select case  ltrim(rtrim(m.Miso4217))
							when 'CRC' then   '01'
							 when  'USD'then  '02'
							 when 'EUR' then '03'
							 else '99'
							end 		 
						from Monedas m
						where m.Mcodigo=a.Mcodigo )  ,2)  <!----Moneda del monto---->
							
		#concat# left (#pre#DRNnombre#concat#' '#concat##pre#DRNapellido1#concat#' '#concat##pre#DRNapellido2#concat#<cfqueryparam cfsqltype="cf_sql_char" value="#RepeatString(' ', 45)#">,  45)<!---Concepto---->		
		
		#concat#'00' <!----Estado del registro---->
		
		#concat#'1' as datos, <!----Estado del registro---->
		 
		left (DEidentificacion,  15) as DEidentificacion,<!---Tipo ID del beneficiario---->		
		
		
		left (#pre#ERNdescripcion,  20) as nomina<!---Detalle especial---->		
		
		 
		from #pre#DRNomina a
				 inner join #pre#ERNomina b
				 on b.ERNid=a.ERNid 
				inner join DatosEmpleado de
					on de.DEid=a.DEid
				inner join Monedas m
					on m.Mcodigo=a.Mcodigo
		where  a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and  de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		order by 1
</cfquery>

<cfloop query="Credito"><!--- Actualiza campos de la identificacion, agregando unicamente numeros y rellenando con '0' a la izquierda--->
	<cfset Nueva =Credito.DEidentificacion>
	<cfset Nueva = REReplaceNoCase(Nueva,"[^0-9]","","ALL") >
	<cfset Nueva =RepeatString('0', (15-len(trim(Credito.DEidentificacion)))) & trim(Credito.DEidentificacion)>
    <cfset Temp = QuerySetCell(Credito, "DEidentificacion", Nueva,Credito.currentRow)>
	<cfset nuevoDatos = Credito.datos&Credito.DEidentificacion&Credito.nomina>
	<cfset Temp = QuerySetCell(Credito, "datos", nuevoDatos,Credito.currentRow)>
</cfloop>

<cfquery dbtype="query" name="ERR">
select datos from Encabezados
union all
select datos from Debito
union all
select datos from Credito
</cfquery>
