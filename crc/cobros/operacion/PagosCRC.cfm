<cf_importLibs>	

<cfif isDefined('URL.LiquidacionCajero')>
	<cfset Form.LiquidacionCajero = 'LiquidacionCajero'>
	<cfset Form.FALIid = URL.FALIid>
</cfif>


<!--- Parámetros requeridos --->
<cfif isDefined("Url.FCid")>
	<cfset Form.FCid = Url.FCid>
</cfif>
<cfif isDefined("Url.ETnumero")>
	<cfset Form.ETnumero = Url.ETnumero>
</cfif>
<cfif isDefined("Url.CCTcodigo")>
	<cfset Form.CCTcodigo = Url.CCTcodigo>
</cfif>
<cfif isDefined("Url.Pcodigo")>
	<cfset Form.Pcodigo = Url.Pcodigo>
</cfif>
<cfif isDefined("Url.CC")>
	<cfset Form.CC = Url.CC>
</cfif>
<cfif isDefined("Url.SNcodigo")>
	<cfset Form.SNcodigo = Url.SNcodigo>
</cfif>
<cfif isDefined("Url.Mcodigo")>
	<cfset Form.Mcodigo = Url.Mcodigo>
</cfif>
<cfif isDefined("Url.PTC")>
	<cfset Form.PTC = Url.PTC>
</cfif>
<cfif isDefined("Url.TC")>
	<cfset Form.TC = Url.TC>
</cfif>

<!--- Modo--->
<cfif isdefined("Form.btnEditar")  or ( isdefined("form.FPlinea") and len(trim(form.FPlinea)) gt 0 )>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<!--- Consultas --->
<!---Codigo 15836: Maneja Egresos--->
<cfquery name="rsManejaEgresos" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo =  #Session.Ecodigo# 
        and Pcodigo = 15836
</cfquery>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<!---- Definicion de variable para control de pantalla ---->
<cfif  isdefined('form.CC')>
   <cfset LvarPantallaCobros = 1>
<cfelse>
   <cfset LvarPantallaCobros = 0>
</cfif>

<!--- 1. Consulta de la transacción --->
<cfif not isdefined('form.CC')>
    <cfquery name="rsETransaccion" datasource="#Session.DSN#">
        select FCid, ETnumero, ETdocumento, ETserie, SNcodigo, ETtotal, a.Mcodigo, ETtc,m.Mnombre, ((coalesce(r.Rporcentaje,0)/100) * a.ETtotal) as retencion,
        (select coalesce(sum(ProntoPagoCliente),0) from DTransacciones dt where dt.FCid = a.FCid and dt.ETnumero=a.ETnumero and ProntoPagoClienteCheck = 1) as Comision,
        isnull(a.ETcomision,0) ETcomision
        from ETransacciones a 
		 left outer JOIN Retenciones r
		    on a.Rcodigo = r.Rcodigo 
			and a.Ecodigo = r.Ecodigo
        inner join Monedas m
          on a.Mcodigo = m.Mcodigo
        where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
        and ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
    </cfquery>
  
    
<cfelse>
    <cfquery name="rsETransaccion" datasource="#Session.DSN#">
        select #form.FCid# as FCid, -1 as ETnumero, 'NA' as ETdocumento, -1 as ETserie, #form.SNcodigo# as SNcodigo, Ptotal  as ETtotal, #form.Mcodigo# as Mcodigo, 
        Ptipocambio as ETtc, (select Mnombre from Monedas where Mcodigo = #form.Mcodigo# and Ecodigo = #session.Ecodigo#) as Mnombre,  0 as retencion, 0 as Comision
         from Pagos
         where  FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
         and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
         and Pcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcodigo#">
    </cfquery>     
</cfif>

<cfset lvarPagosEfec = 0>
<cfif not isdefined('form.CC')>
	<!--- 2. Consulta los pagos de la transacción por FCid y ETnumero --->
    <cfquery name="rsFPagos" datasource="#Session.DSN#">
        select FPlinea, FCid, ETnumero, m.Mnombre, f.Mcodigo,m.Msimbolo, f.Mcodigo, m.Miso4217 , FPtc, 
            FPmontoori, FPmontolocal, FPfechapago, Tipo, 
            case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' when 'F' then 'Diferencia' end as Tipodesc,
            case Tipo when 'D' then ' - ' #_Cat# FPdocnumero #_Cat# ' - ' #_Cat#
            (select Bdescripcion from Bancos ban where ban.Bid =  f.FPBanco ) #_Cat# ' - ' #_Cat#
            (select CBdescripcion from CuentasBancos cban where cban.Bid =  f.FPBanco and cban.CBid = f.FPCuenta )
              else '' end as descAdicional,
            FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
            FPtipotarjeta, FPautorizacion,FPagoDoc, FPfactorConv, coalesce(FPVuelto,0) as vuelto
        from FPagos f, Monedas m
        where f.Mcodigo = m.Mcodigo       
        and FCid=#rsETransaccion.FCid#
        and ETnumero=#rsETransaccion.ETnumero#  
        <cfif modo neq "ALTA"> 
		 and f.FPlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
        </cfif>
    </cfquery>

    <cfquery name="rsFPagosEfectivo" dbtype="query">
      SELECT COUNT(*) AS existe
      FROM rsFPagos
      WHERE Tipo = 'E'
    </cfquery>
    
    <cfif isDefined("rsFPagosEfectivo") and rsFPagosEfectivo.RecordCount GT 0 and len(rsFPagosEfectivo.existe) GT 0>
      <cfset lvarPagosEfec = #rsFPagosEfectivo.existe#>
    </cfif>
 <cfelse>
 <!--- 2. Consulta los pagos de la transacción por Pcodigo y CCTcodigo --->
    <cfquery name="rsFPagos" datasource="#Session.DSN#">
        select FPlinea, FCid, CCTcodigo,Pcodigo, f.Mcodigo, m.Mnombre, m.Msimbolo, m.Miso4217 , FPtc, 
            FPmontoori, FPmontolocal, FPfechapago, Tipo, 
            case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' when 'F' then 'Diferencia' end as Tipodesc,
            case Tipo when 'D' then ' - ' #_Cat# FPdocnumero #_Cat# ' - ' #_Cat#
            (select Bdescripcion from Bancos ban where ban.Bid =  f.FPBanco ) #_Cat# ' - ' #_Cat#
            (select CBdescripcion from CuentasBancos cban where cban.Bid =  f.FPBanco and cban.CBid = f.FPCuenta )
              else '' end as descAdicional,
            FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
            FPtipotarjeta, FPautorizacion,FPagoDoc, FPfactorConv , coalesce(PFPVuelto,0) as vuelto
        from PFPagos f, Monedas m
        where f.Mcodigo = m.Mcodigo       
        and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
        and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
        and Pcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcodigo#"> 
         <cfif modo neq "ALTA"> 
		 and f.FPlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
        </cfif>
    </cfquery>
 </cfif>
<!--- 3. Consulta los pagos de la transacción por FPlinea --->
<cfif modo neq "ALTA">
   <cfif not isdefined('form.CC')>
	<cfquery name="rsFPagoLinea" datasource="#Session.DSN#">
		select FPlinea, FCid, ETnumero, Mcodigo, FPtc, 
			FPmontoori, FPmontolocal, FPfechapago, Tipo, 
			FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
			FPtipotarjeta, FPautorizacion, MLid,FPagoDoc, FPfactorConv
		from FPagos
		Where FPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
	</cfquery>
    <cfelse>
    <cfquery name="rsFPagoLinea" datasource="#Session.DSN#">
		select FPlinea, FCid, CCTcodigo,Pcodigo, Mcodigo, FPtc, 
			FPmontoori, FPmontolocal, FPfechapago, Tipo, 
			FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
			FPtipotarjeta, FPautorizacion,FPagoDoc, FPfactorConv
		from PFPagos
		Where FPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
	</cfquery>
    </cfif>
    <cfif rsFPagoLinea.Tipo eq 'A'>
    	<cfquery name="rsDocumento" datasource="#Session.DSN#">
        	select Dsaldo
            from Documentos
            where Ecodigo = #session.Ecodigo#
            and CCTcodigo = '#rsFPagoLinea.FPautorizacion#'
            and Ddocumento = '#rsFPagoLinea.FPdocnumero#'
        </cfquery>
    </cfif>
</cfif>
<!--- 4. Descripción de la caja de la transacción --->
<cfquery name="rsFCajas" datasource="#Session.DSN#">
	Select FCdesc
	from FCajas
    <cfif isdefined('rsETransaccion.FCid') and len(trim(#rsETransaccion.FCid#)) gt 0>
	where FCid=#rsETransaccion.FCid#
    <cfelseif isdefined('url.FCid') and len(trim(#url.FCid#)) gt 0>
     where FCid=#url.FCid#
    </cfif>
</cfquery>
<!--- 5. Nombre del cliente de la transacción --->
<cfquery name="rsSNegocios" datasource="#Session.DSN#">
	Select SNnombre
	from SNegocios
    <cfif isdefined('rsETransaccion.SNcodigo') and len(trim(#rsETransaccion.SNcodigo#)) gt 0>
	Where SNcodigo = #rsETransaccion.SNcodigo#
    and Ecodigo = #session.Ecodigo#
    <cfelseif isdefined('url.SNcodigo') and len(trim(#url.SNcodigo#)) gt 0>
     where SNcodigo=#url.SNcodigo#
      and Ecodigo = #session.Ecodigo#
    </cfif>
</cfquery>
<!--- 6. Nombre de la moneda de la transacción --->
<cfquery name="rsMonedaTran" datasource="#Session.DSN#">
	Select Mnombre,Msimbolo,Miso4217
	from Monedas
    <cfif isdefined('rsETransaccion.Mcodigo') and len(trim(#rsETransaccion.Mcodigo#)) gt 0>
	Where Mcodigo = #rsETransaccion.Mcodigo#
    <cfelseif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0>
    Where Mcodigo = #url.Mcodigo#
    </cfif>
</cfquery>
<!--- 6.1 Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	Select Mnombre,Msimbolo,Miso4217
	from Monedas   
	Where Ecodigo = #session.Ecodigo#    
</cfquery>
<!--- 7. Tipos de pagos --->
<cfquery name="rsTPagos" datasource="#Session.DSN#">
	<!--- Select 
    '-1' as TPid, '-- Seleccione--' as TPdesc, 1 as orden
    Union --->
    Select 'E' as TPid, 'Efectivo' as TPdesc, 2 as orden
	  Union Select 'T' as TPid, 'Tarjeta' as TPdesc, 3 as orden	
	  <!--- Union Select 'D' as TPid, 'Deposito' as TPdesc, 5 as orden
    Union Select 'A' as TPid, 'Documento' as TPdesc, 6 as orden
    Union Select 'C' as TPid, 'Cheque' as TPdesc,4 as orden 
    <cfif rsManejaEgresos.Pvalor eq 1>
    	Union Select 'F' as TPid, 'Diferencia' as TPdesc,7 as orden 
    </cfif>
    --->
	order by orden
</cfquery>
<!--- 8. Tipos de tarjetas --->
<cfquery name="rsTTarjeta" datasource="#Session.DSN#">
    Select FATid,FATdescripcion as TTdesc,isnull(FATporccom,0) FATporccom
     from FATarjetas
     where FATvisible = 1   
      and Ecodigo = #session.Ecodigo#   
     order by FATid   
</cfquery>

<!--- 9. Bancos --->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select convert(varchar, b.Bid) as Bid, b.Bdescripcion  
	from Bancos b 
	where b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	and exists (select 1 from CuentasBancos where Bid = b.Bid and Ecodigo = b.Ecodigo)
	order by upper(b.Bdescripcion)
</cfquery>
<!--- 10. Cuentas Contables --->
<cfquery datasource="#Session.DSN#" name="rsCuenta">
	select convert(varchar, Ccuenta) as Ccuenta, Cdescripcion
	from CContables 
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and Cmovimiento='S' 
	  and Mcodigo=6
	  and Ccuenta not in (select b.Ccuenta from EMovimientos a, CuentasBancos b where a.CBid = b.CBid and b.CBesTCE = 0 and a.Ecodigo = b.Ecodigo)
	order by Cdescripcion
</cfquery>
<!--- 11. Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select convert(varchar,a.Mcodigo) as Mcodigo, m.Msimbolo from Empresas a 
    inner join Monedas m
    on a.Mcodigo = m.Mcodigo
   and a.Ecodigo = m.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>
<!--- 12. Cuentas Bancarias ---> 
<cfquery name="rsCuentasBancos" datasource="#Session.DSN#">
	select convert(varchar,Bid) Bid, convert(varchar,CBid) as CBid, CBdescripcion
	from CuentasBancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
	  <cfif isdefined('rsETransaccion.Mcodigo') and len(trim(#rsETransaccion.Mcodigo#)) gt 0>
	and Mcodigo = #rsETransaccion.Mcodigo#
    <cfelseif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0>
    and Mcodigo = #url.Mcodigo#
    </cfif>
	  <!---and CBid not in (Select c.Bid from ECuentaBancaria d, Bancos e, CuentasBancos c
	  					where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                          and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
						  and d.Bid = e.Bid and d.CBid = c.CBid and d.ECaplicado = 'N' and d.EChistorico = 'N')--->
	order by CBcodigo, CBdescripcion
</cfquery>

<!--- 13. Parametro---> 
  <!---Codigo 15833: para determinar si el pago de documentos de CxC cuando el cliente paga por transferencia o depósito debe crear  
            el movimiento en Bancos al aplicarse el pago o el sistema debe validar que el pago ya exista en Bancos--->
 <cfquery name="rsValidarExisteBancos" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo =  #Session.Ecodigo# 
		and Pcodigo = 15833
 </cfquery> 
<script language="JavaScript" type="text/JavaScript">
<!--
<!--- Funciones de Validación del Form --->

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_validateForm() { //v4.0

	var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
	for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
	if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
		if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
		if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
		} else if (test!='R') { num = parseFloat(qf(val)); 
		if (isNaN(qf(val))) errors+='- '+nm+' debe ser numérico.\n';
		if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			min=test.substring(8,p); max=test.substring(p+1);
			if (num<=min) errors+='- '+nm+' debe ser mayor a ' + min + '.\n';
			if (num>=max) errors+='- '+nm+' debe ser menor a ' + max + '.\n';
	} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	} if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	document.MM_returnValue = (errors == '');
}

// ===========================================================================================
//								Conlis de Cuentas
// ===========================================================================================
var popUpWinDsaldo=null;
function popUpWindowDsaldo(URLStr, left, top, width, height)
{
	if(popUpWinDsaldo)
	{
		if(!popUpWinDsaldo.closed) popUpWinDsaldo.close();
	}
	popUpWinDsaldo = open(URLStr, 'popUpWinDsaldo', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	if (! popUpWinDsaldo && !document.popupblockerwarning) {
		alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
		document.popupblockerwarning = 1;
	}
	else
		if(popUpWinDsaldo.focus) popUpWinDsaldo.focus();
	}
	function doConlisDsaldo()
	{
		 <cfif isdefined('rsETransaccion.SNcodigo') and len(trim(#rsETransaccion.SNcodigo#)) gt 0>
	       <cfset socio = rsETransaccion.SNcodigo>
         <cfelseif isdefined('url.SNcodigo') and len(trim(#url.SNcodigo#)) gt 0>
           <cfset socio = url.SNcodigo>
         </cfif>   
	  <!---	<cfset socio = rsETransaccion.SNcodigo>--->
		<cfoutput>
			popUpWindowDsaldo('popUp-Documentos.cfm?soc=#socio#',250,200,650,550);
		</cfoutput>
	} 
// ===========================================================================================

function cambiarTipo(tipo) {
	
	if (tipo == null) {
		tipo = document.form1.Tipo.value;
	}
		
	<!---Homologacion de los tipos para que concuerden con los divs--->
	var LetraDiv = "";
	if (tipo == "E") { 
		LetraDiv = "A";
	}else if (tipo == "T") {
		LetraDiv = "B";
	}else if (tipo == "C") {
		LetraDiv = "C";
	}else if (tipo == "D") {
		LetraDiv = "D";
	}else if (tipo == "A") {
		LetraDiv = "E";
	}else if (tipo == "F") {
		LetraDiv = "F";
	}
	
	<!---Funcion para recorrer los divs uno por uno por cada letra
	Cuando se agrega o quite un div modificar este arreglo en la segunda dimension
	Los numeros de divs siempre tienen que crearse en orden numerico--->
	divs = [['A', 6], ['B', 8], ['C', 6], ['D', 8],['E', 6], ['F', 4]];  <!--Dimension 1 = Letra,  Dimension 2= Numero de divs por letra //-->
	for(i = 0; i < divs.length; i++){
		for(j = 1; j <= divs[i][1]; j++){
			div = document.getElementById('div'+ divs[i][0] + j);
				if(divs[i][0] == LetraDiv)
					div.style.display = '';
				else
					div.style.display = 'none';

		}
	}
	
	<!---Condiciones especiales--->
	if(tipo == "E"){
    document.getElementById("referenciaEfectivoLbl").style.visibility = "visible";
    document.getElementById('referenciaEfectivo').value = "";
    document.getElementById('referenciaEfectivo').style.visibility = "visible";
    /* document.getElementById('referenciaEfectivoLbl').style.display = 'block';
    document.getElementById('referenciaEfectivo').style.display = 'block'; */
  }
  else{
    document.getElementById("referenciaEfectivoLbl").style.visibility = "collapse";
    document.getElementById('referenciaEfectivo').value = "XX0XX";
    document.getElementById('referenciaEfectivo').style.visibility = "collapse";
    /* document.getElementById('referenciaEfectivoLbl').style.display = 'none';
    document.getElementById('referenciaEfectivo').style.display = 'none'; */
  }
	if (tipo == "D") {
		<!---No se permite modificar ni el monto ni la moneda con este parametro--->
		<cfif rsValidarExisteBancos.Pvalor eq 1>
			document.form1.Mcodigo.disabled = true;
			document.form1.FPmontoori.readOnly = true;
		</cfif>
	}else{
		document.form1.Mcodigo.disabled = false;
		document.form1.FPmontoori.readOnly = false;
	}	

}

function inicio() {
	debug = false; 		
	cambiarTipo();
	cambiarCuentas();
	setTC();
	setMontoLocal();
}

function setMontoLocal() {	
	debug = false; 
    
	if (document.form1.Mcodigo.value == "<cfoutput>#TRIM(rsMonedaLocal.Mcodigo)#</cfoutput>") {
		document.form1.FPmontolocal.value = document.form1.FPmontoori.value;
	}
	else {
		  
	<!---   <cfif session.usulogin eq 'ymena'>
	      alert("set montolocal FPmontoori: " + document.form1.FPmontoori.value );		
		   alert("set montolocal  FPtc:" + document.form1.FPtc.value);
	  </cfif>--->	
		 
		monto = new Number(qf(document.form1.FPmontoori));
		tc = new Number(qf(document.form1.FPtc));
		document.form1.FPmontolocal.value = monto * tc;
	}
	fm(document.form1.FPmontolocal,2);
	fm(document.form1.FPmontoori,2);
	fm(document.form1.FPtc,2);
	if (debug)
		alert(document.form1.FPmontolocal.value)
}

function setTC() {
	//Cuando la moneda seleccionada es igual a la moneda local el tc es 1. Esto lo hace el Tag.
	//Cuando la moneda seleccionada es igual al de la transaccion el tc es el de la transaccion.
	//En ninguno de estos casos el tc se debe modificar.
	debug = false; 		
	var estado  = document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>"
				||document.form1.Mcodigo.value == "<cfif isdefined('rsETransaccion.Mcodigo') and len(trim(#rsETransaccion.Mcodigo#)) gt 0><cfoutput>#trim(rsETransaccion.Mcodigo)#</cfoutput><cfelseif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0><cfoutput>#trim(url.Mcodigo)#</cfoutput></cfif>";
	document.form1.FPtc.disabled = false;
	if (document.form1.Mcodigo.value == "<cfif isdefined('rsETransaccion.Mcodigo') and len(trim(#rsETransaccion.Mcodigo#)) gt 0><cfoutput>#rsETransaccion.Mcodigo#</cfoutput><cfelseif isdefined('url.Mcodigo') and len(trim(#url.Mcodigo#)) gt 0><cfoutput>#url.Mcodigo#</cfoutput> 
    </cfif>")
	document.form1.FPtc.value = "<cfif isdefined('rsETransaccion.ETtc') and len(trim(#rsETransaccion.ETtc#)) gt 0><cfoutput>#rsETransaccion.ETtc#</cfoutput><cfelseif isdefined('url.TC') and len(trim(#url.TC#)) gt 0><cfoutput>#url.TC#</cfoutput></cfif>";
	else
		document.form1.FPtc.value = document.form1.TC.value;
		fm(document.form1.FPtc,2);
		document.form1.FPtc.disabled = estado;
}

function asignaTC() {	
	
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(document.form1.TC,2);
			document.form1.FPtc.disabled = true;			
		}
		else
			document.form1.FPtc.disabled = false;							
		var estado = document.form1.FPtc.disabled;
		document.form1.FPtc.disabled = false;
		document.form1.FPtc.value = fm(document.form1.TC.value,2);
		document.form1.FPtc.disabled = estado;
	
	}
function ValidaForm() {
	Doc();
	setMontoLocal(); 
    setPartePago();
	debug = false; 	
	document.form1.Mcodigo.disabled = false;	
	if (document.form1.modo.value!="BAJA") {
	 if (document.form1.modo.value!="PRECAMBIO") {
		tipo = document.form1.Tipo.value;		
	
		var facturado    = new Number(qf(document.form1.facturado.value)); 	
		var montoPagado  = new Number(qf(document.form1.montoTotal.value)); 		
		var pago         = new Number(qf(document.form1.PagoAlDoc.value)); 		
		var tipo         = document.form1.Tipo.value;
				
		
	 if (document.form1.modo.value!="BAJA") {	
	   if((montoPagado + pago) - facturado > 0.01 )
	       {			
	    	var miVuelto     = facturado - (montoPagado + pago);
		        miVuelto     = Math.abs(miVuelto);
					
		   }
		   else
		    miVuelto     = 0;
		   
	    }
		else
		{
			 miVuelto     = 0; 
		}
		
		  if(document.form1.Tipo.value == "-1")
		  {
			  alert("Seleccione un medio de pago.");
			  return false;
		  }
		  
	    <cfoutput>	
         <cfif  LvarPantallaCobros neq 1 ><!---- Se permite vuelto, unicamente si la pantalla es de facturacion --->
	          			
			 if (tipo != 'D' && tipo != 'C' &&  tipo != 'E' )
			  {	
					
				if((montoPagado + pago) - facturado > 0.01 )
				{
				   alert('El monto a pagar es mayor a lo facturado.');
				   return false;	   
				}
			  }
	     </cfif>
	     <cfif  LvarPantallaCobros eq 1 > <!--- Si se esta registrando un pago desde cobros, no permite excesos----->
		   if((montoPagado + pago) - facturado > 0.01)		  
			{
				   alert('El monto a pagar es mayor a lo facturado.');
				   return false;	   
		    } 
		 </cfif> 
	      <cfif  LvarPantallaCobros neq 1 ><!--- Si el valor no es 1, es xq es de facturacion, si es 1 es porque es de recibos. Asigna el vuelto----->
			  
				if (tipo == 'E' || tipo == 'D' || tipo == 'C' )
				   {					
					  document.form1.vuelto.value =  miVuelto;		
				   }
				    else
				   {
					  document.form1.vuelto.value =  0;
				   }
				   
		   </cfif>
	       <cfif  LvarPantallaCobros eq 1 ><!--- Si aceptara vueltos en efectivo llegaria aqui pero aqui no va a llegar.----->
		     
			       if (tipo == 'E')
				   {
					  document.form1.vuelto.value =  miVuelto;		
				   }
				    else
				   {
					  document.form1.vuelto.value =  0;
				   }
		    </cfif>	
		
		  			
<!---	<cfif session.usulogin eq 'ymena'>
	    alert("vuelto: " + document.form1.vuelto.value );		
	</cfif>	--->			
	   </cfoutput>
	   
		switch (tipo) {//NinRange0:9999999999
		   case 'E':	
			    if(document.form1.FPmontoori.value == '' || document.form1.FPmontoori.value == 0.00)
		        {
			       alert('El monto de pago no puede ir vacío o en cero!');
				   return false;
		     	}
				 if(document.form1.FPtc.value == '' || document.form1.FPtc.value == 0.00)
		        {
			       alert('El tipo de cambio no puede ir vacío o en cero!');
				   return false;
		     	}
				break;
			case 'T':
			    if(document.form1.FPmontoori.value == '' || document.form1.FPmontoori.value == 0.00)
		        {
			       alert('El monto de pago no puede ir vacío ó en cero!');
				   return false;
		     	}	
			    if(document.form1.T_FPautori.value == '')
		        {
			       alert('El numero de Autorizacion  no puede ir en blanco!');
				   return false;
		     	}		   
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'T_FPdocnumero','','','T_FPdocfecha','','R','T_FPtipotarjeta','','R');
				
				break;
			case 'C':	
			    if(document.form1.FPmontoori.value == '' || document.form1.FPmontoori.value == 0.00)
		        {
			       alert('El monto de pago no puede ir vacío ó en cero!');
				   return false;
		     	}
			    if(document.form1.C_FPdocnumero.value == '')
		        {
			       alert('El numero de cheque no puede ir en blanco!');
				   return false;
		     	}
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'C_FPBanco','','R','C_FPdocnumero','','R','C_FPdocfecha','','R');
			
								
				break;
			case 'D':
				if(document.form1.D_FPdocnumero.value == '')
		        {
			       alert('El documento de depósito no puede ir en blanco!');
				   return false;
		     	}		   
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'D_FPBanco','','R','D_FPCuenta','','R','D_FPdocnumero','','R');				
				break;
			case 'A':
				var modo = document.form1.modo.value;
				var monto = document.form1.FPmontoori.value;
				var saldo = document.form1.Dsaldo.value;
				monto = monto.replace(",","");
				
				if(document.form1.FPmontoori.value == '' || document.form1.FPmontoori.value == 0.00)
		        {
			       alert('El monto de pago no puede ir vacío o en cero!');
				   return false;
		     	}
				if(document.form1.Ddocumento.value == '')
		        {
			       alert('Debe elegir un documento!');
				   return false;
		     	}
				
				<cfoutput>
					<cfif modo neq 'ALTA'>
					monto2 = #rsFPagoLinea.FPmontoori#;
					saldo = parseFloat(saldo) + parseFloat(monto2);
					</cfif>
				</cfoutput>
				saldo = parseFloat(saldo);
				monto = parseFloat(monto);
				
				if(monto > saldo && saldo > 0){
					alert ('El monto indicado es mayor al saldo del Documento de Pago');
					return false;
					break;	
				}
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'Ddocumento','','R');
				break;	
			default :
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange-99999999999999:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange-1:9999');
		}
		
		if  (document.MM_returnValue) {
			<!---document.form1.FPtc.disabled = false;--->
			document.form1.FPmontoori.value=qf(document.form1.FPmontoori);
			document.form1.FPmontolocal.value=qf(document.form1.FPmontolocal);
			document.form1.FPtc.value=qf(document.form1.FPtc);
		}
		
		return document.MM_returnValue;
	 }
	 else {
	 	//Se utiliza el modo PRECAMBIO para el momento en que se le da click al icono de cambio de una línea de la lista de pagos,
		//y el momento en que se va, y se cambia a CAMBIO para que se vaya y cuando vuelva lo encuentre como CAMBIO y lo deje así.
		document.form1.modo.value!="CAMBIO"
	 	return true;	
	 }	
	}
	else
		return true;
}

function Doc() {
	var indice = document.form1.Tipo.selectedIndex 
   	var valor = document.form1.Tipo.options[indice].value 
	if(valor == 'A'){
	document.form1.Mcodigo.disabled = false;
	<!---document.form1.FPtc.disabled = false;--->
	}
}

function Editar(FPlinea, tipo,CCTcodigo, Documento) {
  document.getElementById('referenciaEfectivo').value = "XX0XX";
	debug = false; 	
	document.form1.FPlinea.value = FPlinea;
	document.form1.Tipo.value = tipo;
	if(document.form1.CCTcodigo){
	document.form1.CCTcodigo.value = CCTcodigo;
	}
	document.form1.Ddocumento.value = Documento;
	document.form1.modo.value = "BAJA";
		
}
function Editar2(FPlinea, tipo, CCTcodigo, Documento,CC,Mcodigo) {
	debug = false; 
	document.form1.FPlinea.value = FPlinea;
	document.form1.Tipo.value = tipo;
	if(document.form1.CCTcodigo){
	document.form1.CCTcodigo.value = CCTcodigo;
	}
	document.form1.Ddocumento.value = Documento;
	document.form1.CC.value = CC;
	document.form1.Mcodigo.value = Mcodigo;
	document.form1.modo.value = "BAJA";
}
function Modificar(FPlinea,TC,Mcodigo,CCTcodigo){
	debug = false; 
	document.form1.modo.value = "PRECAMBIO"; //PRECAMBIO PARA QUE NO VALIDE ANTES DE IRSE. Lo cambia la funcion de validación del form.
	document.form1.action = "PagosCRC.cfm";
	document.form1.FPlinea.value = FPlinea;
<!---	document.form1.CC.value = 0;--->
    document.form1.TC.value = TC;
	document.form1.Mcodigo.value = Mcodigo;
	document.form1.CCTcodigo.value = CCTcodigo;
	
}
function Modificar2(FPlinea,CC){
	debug = false; 	
	
	document.form1.action = "PagosCRC.cfm";
	document.form1.FPlinea.value = FPlinea;
	document.form1.CC.value = CC;
	document.form1.modo.value = "PRECAMBIO"; //PRECAMBIO PARA QUE NO VALIDE ANTES DE IRSE. Lo cambia la funcion de validación del form.
	
}

function cambiarCuentas(){
	Banco = $('select[name=D_FPBanco]').val();

	if(Banco.length == 0){
		$('select[name=D_FPCuenta]').empty(); 
	}
	else{ 
		document.form1.D_FPCuenta.length = 0;
		i = 0;
		<cfoutput query="rsCuentasBancos">
			if ( #Trim(rsCuentasBancos.Bid)# == Banco ){
				document.form1.D_FPCuenta.length = i+1;
				document.form1.D_FPCuenta.options[i].value = '#rsCuentasBancos.CBid#';
				document.form1.D_FPCuenta.options[i].text  = '#rsCuentasBancos.CBdescripcion#';
				<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D'>
					if ( #rsFPagoLinea.FPCuenta# == #rsCuentasBancos.CBid# ) {
						document.form1.D_FPCuenta.options[i].selected=true;
					}
				</cfif>
				i++;
			};
		</cfoutput>
	}	
}

/*
function prueba(){
	if ( (window.event.clientY < 0 ) || ( window.event.clientX < 0 ) ){
		if ( !window.opener.closed ){
			//window.opener.document.location.reload();
			window.opener.document.form1.FCid.value='<cfoutput>#form.FCid#</cfoutput>';
			window.opener.document.form1.ETnumero.value='<cfoutput>#form.ETnumero#</cfoutput>';
			window.opener.document.form1.Cambio.value='Cambio';
			window.opener.document.form1.action='TransaccionesFA.cfm';
			window.opener.document.form1.submit();
			return;
		}
	}	
}*/

<!---- Factor de conversion pagos en diferentes monedas ----->
function setPartePago()
{
	 var MontoOri = document.form1.FPmontoori.value;
	 var TCdestino = document.form1.tipoCambio.value;
	 var TCOri= document.form1.FPtc.value;
	 var PagoFactorConversion = 1;
	 
	 var MontoOri  = MontoOri.replace(",","");
	 var TCdestino = TCdestino.replace(",","");
	 var TCOri     = TCOri.replace(",",""); 	  
	
	 var MontoOri  = new Number(qf(MontoOri));
	 var TCdestino = new Number(qf(TCdestino));
	 var TCOri     = new Number(qf(TCOri));  
	
<!---<cfif session.usulogin eq 'ymena'>
	    alert("ETmcodigo: " + document.form1.ETmcodigo.value );	
		 alert("Mcodigo: " + document.form1.Mcodigo.value );	
		  alert("TCdestino: " + document.form1.tipoCambio.value );	
		   alert("TCOri: " + document.form1.FPtc.value );		
	</cfif>--->
	 if(document.form1.ETmcodigo.value !=  document.form1.Mcodigo.value)
	 {
		 
         PagoFactorConversion = (TCOri/TCdestino);
	     document.form1.PagoAlDoc.value =  (PagoFactorConversion * MontoOri).toFixed(2);
		
		 document.form1.H_PagoAlDoc.value =  document.form1.PagoAlDoc.value;
		 
   <!--- <cfif session.usulogin eq 'ymena'>
		    alert("PagoFactorConversion: " + PagoFactorConversion );	
		    alert("TCOri: " + TCOri );	
     	    alert("TCdestino: " + TCdestino );	
	        alert("PagoAlDoc: " + document.form1.PagoAlDoc.value );	
		    alert("H_PagoAlDoc: " + document.form1.H_PagoAlDoc.value );	
	</cfif>--->
	
     }
	 if(document.form1.ETmcodigo.value ==  document.form1.Mcodigo.value)
	 {		
		  document.form1.PagoAlDoc.value = document.form1.FPmontoori.value;
		  document.form1.H_PagoAlDoc.value =  document.form1.FPmontoori.value;
		  document.form1.FPtc.value   =  document.form1.tipoCambio.value;
	      document.form1.FPtc.disabled = true; 	
		  
		<!---   <cfif session.usulogin eq 'ymena'>
	    alert("PagoAlDoc2: " + document.form1.PagoAlDoc.value );	
		 alert("H_PagoAlDoc2: " + document.form1.H_PagoAlDoc.value );
		  alert("FPtc2: " + document.form1.FPtc.value );
		 
	</cfif>	   --->
     }
	 document.form1.pagoFC.value =  PagoFactorConversion; 
	 
	 document.form1.PagoAlDoc.value = formato_numero ((qf(document.form1.PagoAlDoc.value)),2,'.',','); 
   

   CalculoComision(document.form1.T_FPtipotarjeta);
	
}

/*
 * Da formato a un número para su visualización
 *
 * numero (Number o String) - Número que se mostrará
 * decimales (Number, opcional) - Nº de decimales (por defecto, auto)
 * separador_decimal (String, opcional) - Separador decimal (por defecto, coma)
 * separador_miles (String, opcional) - Separador de miles (por defecto, ninguno)
 */
function formato_numero(numero, decimales, separador_decimal, separador_miles){ // v2007-08-06
    numero=parseFloat(numero);
    if(isNaN(numero)){
        return "";
    }

    if(decimales!==undefined){
        // Redondeamos
        numero=numero.toFixed(decimales);
    }

    // Convertimos el punto en separador_decimal
    numero=numero.toString().replace(".", separador_decimal!==undefined ? separador_decimal : ",");

    if(separador_miles){
        // Añadimos los separadores de miles
        var miles=new RegExp("(-?[0-9]+)([0-9]{3})");
        while(miles.test(numero)) {
            numero=numero.replace(miles, "$1" + separador_miles + "$2");
        }
    }

    return numero;
}
//-->

function validarPago() {
  var existe = document.getElementById('PagoEfectivo').value;
  var Tipo = document.getElementById('Tipo').value;

  if (Tipo == 'E'){
    if (existe > 0) {
      alert('Ya existe un pago en efectivo. Para modificarlo, debe eliminar el registro existente.');
      return false; 
    }
  }
  return true;
}
</script>

<html>
<head>
<title>Registro de Pagos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<!---<body onUnload="javascript:window.opener.document.location.reload();">--->
<body>
<font size="2"> 
<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>
</font> 
<cf_templatecss>
<font size="2"> 
<script language="JavaScript1.2" type="text/javascript" src="/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="/sif/js/calendar.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("/sif/js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</script>
</font> 
<form action="PagosCRC_sql.cfm" method="post"  name="form1" onSubmit="javascript: return ValidaForm();">
  <cfif isDefined('form.LiquidacionCajero')>
  	<input type="hidden" name="LiquidacionCajero" value="LiquidacionCajero">
  	<input type="hidden" name="FALIid" value="<cfoutput>#form.FALIid#</cfoutput>">
  </cfif>
    <input type="hidden" id="PagoEfectivo" name="PagoEfectivo" value="<cfoutput>#lvarPagosEfec#</cfoutput>">
  <font size="2"> 
  <cfset ncols=6>
  </font> 
  <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
    <cfoutput> 
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;</td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#" align="center" bgcolor="FAFAFA"><font size="2"><b>Registro 
          de Pagos</b></font></td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;</td>
      </tr>
      <tr> 
        <td nowrap align="right"><font size="2"><b>Caja:</b>&nbsp;</font></td>
        <td nowrap><font size="2">#rsFCajas.FCdesc# 
          <input name="FCid" value="<cfoutput>#rsETransaccion.FCid#</cfoutput>" type="hidden">            
          <cfif isdefined('form.CC')> <!---- Se define unicamente para recibos --->
            <input name="CC" value="1" type="hidden"> 
          <cfelse>
            <input name="FA" value="1" type="hidden">  
          </cfif>
          <cfif isdefined('form.CCTcodigo') and len(trim(#form.CCTcodigo#)) gt 0>
           <input name="CCTcodigo" value="<cfoutput>#form.CCTcodigo#</cfoutput>" type="hidden">
          </cfif>
          <cfif isdefined('form.Pcodigo') and len(trim(#form.Pcodigo#)) gt 0>
           <input name="Pcodigo" value="<cfoutput>#form.Pcodigo#</cfoutput>" type="hidden">
          </cfif>  
          <cfif isDefined("form.SNcodigo")>	   
             <input name="SNcodigo" value="<cfoutput>#form.SNcodigo#</cfoutput>" type="hidden">
            </cfif>            
          </font></td>
        <td nowrap align="right"><font size="2"><b>Documento:</b>&nbsp;</font></td>
        <td nowrap><font size="2">
        <cfif not isdefined('form.CC') or form.CC eq 0>
             #rsETransaccion.ETnumero#
        <cfelseif isdefined('form.Pcodigo') and len(trim(#form.Pcodigo#)) gt 0>
            #form.Pcodigo# 
        </cfif>
          <input name="ETnumero" value="#rsETransaccion.ETnumero#" type="hidden"> 
          <input name="ETmcodigo" value="#rsETransaccion.Mcodigo#" type="hidden">         
          </font></td>
        <td nowrap align="right"><font size="2"><b>Transacci&oacute;n:</b>&nbsp;</font></td>
        <td nowrap><font size="2">
        <cfif not isdefined('form.CC') or form.CC eq 0>
             #rsETransaccion.ETnumero#
        <cfelseif isdefined('form.CCTcodigo') and len(trim(#form.CCTcodigo#)) gt 0>
            #form.CCTcodigo#
        </cfif>
          </font></td>
      </tr>
      <tr> 
        <td nowrap align="right"><font size="2"><b>Cliente:</b>&nbsp;</font></td>
        <td nowrap ><font size="2">#rsSNegocios.SNnombre#</font></td>
        <td nowrap align="right"><font size="2"><b>Moneda:</b>&nbsp;</font></td>
        <td nowrap ><font size="2">#rsMonedaTran.Mnombre#</font></td>
        <td nowrap align="right"><font size="2"><b>Total a Pagar:</b>&nbsp;</font></td>
        <td nowrap> <font size="2">#rsMonedaTran.Msimbolo# #LSCurrencyFormat(rsETransaccion.ETtotal + rsETransaccion.ETComision - rsETransaccion.retencion - rsETransaccion.Comision,'none')# (#rsMonedaTran.Miso4217#) </font></td>
        <cfset LvarFacturado = rsETransaccion.ETtotal + rsETransaccion.ETComision - (rsETransaccion.retencion + rsETransaccion.Comision)>
       <input type="hidden" name="facturado" id="facturado" value="#LvarFacturado#"> 
      </tr>
      </tr>
           <tr> 
        <td nowrap align="right"><font size="2">&nbsp;</font></td>
        <td nowrap ><font size="2"></font></td>
        <td nowrap align="right"><font size="2"><b></b>&nbsp;</font></td>
        <td nowrap ><font size="2"></font></td>
        <td nowrap align="right"><font size="2"><b>Tipo Cambio:</b>&nbsp;</font></td>
        <td nowrap> <font size="2">#LSCurrencyFormat(rsETransaccion.ETtc,'none')# </font></td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;
        </td>
      </tr>
    </cfoutput> 
    <tr> 
      <td nowrap colspan="6"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cuadro" align="center">
          <tr> 
            <td nowrap colspan="5">&nbsp;</td>
          </tr>
          <tr> 
            <td nowrap><font size="2">&nbsp;<b>T.Pago</b></font></td>
            <td nowrap><font size="2"><b>Monto</b></font></td>
            <td nowrap><font size="2"><b>Moneda</b></font></td>
            <td nowrap><font size="2"><b>T.Cambio</b></font></td>
            <td nowrap>&nbsp;</td>
          </tr>
          <tr> 
            <td nowrap><font size="2">&nbsp; 
              <select name="Tipo" id="Tipo" onChange="javascript: cambiarTipo(this.value);">
                <cfoutput query="rsTPagos"> 
                  <cfif modo neq "ALTA" and #rsFPagoLinea.Tipo# eq #TPid#>
                    <option value="#TPid#" selected>#TPdesc#</option>
                    <cfelse>
                    <option value="#TPid#">#TPdesc#</option>
                  </cfif>
                </cfoutput> 
              </select>
              </font></td>
            <td nowrap> <font size="2"> 
              <input type="text" name="FPmontoori"   id="FPmontoori" maxlength="20" size="16" style="text-align: right;" 
                onBlur="fm(this,2); setMontoLocal(); setPartePago();" 
                onChange="setMontoLocal(); setPartePago();" 
                onFocus="javascript:this.value=qf(this); this.select(); "  
                onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                value="<cfif modo neq 'ALTA'><cfoutput>#rsFPagoLinea.FPmontoori#</cfoutput></cfif>"
              >
              <input type="hidden" name="FPmontolocal" value="<cfif modo neq 'ALTA'><cfoutput>#rsFPagoLinea.FPmontolocal#</cfoutput></cfif>">
              </font></td>
            <td nowrap> <font size="2">
				  <cfif modo neq 'ALTA'>
                <cf_sifmonedas query="#rsFPagoLinea#" valueTC="#rsFPagoLinea.FPtc#" onChange="javascript: setTC(); setMontoLocal(); setPartePago();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" CrearMoneda='false'> 
                <cfelse>
                <!---<cf_sifmonedas onChange="javascript: setTC(); setMontoLocal();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" CrearMoneda='false'> --->
                 <cf_sifmonedas onChange="asignaTC(); setPartePago();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" CrearMoneda='false' tabindex="1">
              </cfif>
              </font></td>
            <td nowrap> <font size="2">   
              <input name="tipoCa" type="hidden"  value="<cfoutput>#rsETransaccion.ETtc#</cfoutput>" size="8">
			 <!--- <input name="FPtc" type="hidden"  value="<cfoutput>#rsETransaccion.ETtc#</cfoutput>" size="8">--->
			  <input name="tipoCambio" type="hidden"  value="<cfoutput>#rsETransaccion.ETtc#</cfoutput>" size="8">
              <input type="text" name="FPtc" id="FPtc" style="text-align:right"size="18" maxlength="10" 
			onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
			onFocus="javascript:this.select(); "  onBlur="javascript: setPartePago();"
			onChange="javascript: fm(this,4);"
			value="<cfif modo NEQ 'CAMBIO'>1.00<cfelse><cfoutput>#LSNumberFormat(rsFPagoLinea.FPtc,',9.0000')#</cfoutput></cfif>"> 
			 <!---  <input name="tc" type="hidden"  value="<cfoutput>#rsETransaccion.ETtc#</cfoutput>" size="8">
              Obtiene el valor en modo cambio al ejecutarse la función setTC() en la función inicio(),
										con base en valor que se le da en modo cambio en el tag de monedas.
							--->
              </font></td>
            <td nowrap align="right"> <font size="2"> 
              <input name="btnAceptar" type="submit" value="Aceptar"  onclick="return validarPago();">
              <input name="btnNuevo" type="submit" value="Nuevo">
              &nbsp; </font></td>
          </tr>
          <tr>
           <td >&nbsp;</td>
           <td colspan="2"><font size="2"><b>Pago al documento</b></font></td>
           <td colspan="0" id="referenciaEfectivoLbl"><font size="2"><b>Referencia</b></font></td>
           <td colspan="1">&nbsp;</td>
          </tr>
           <tr>
           <td >&nbsp;</td>
           <td colspan="2"><input type="text" style="text-align:right" maxlength="10" size="16" name="PagoAlDoc" value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsFPagoLinea.FPagoDoc,',9.0000')#</cfoutput></cfif>"  disabled>
            <input type="hidden"  name="H_PagoAlDoc" value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsFPagoLinea.FPagoDoc,',9.0000')#</cfoutput></cfif>">
           <input type="hidden"  name="pagoFC" value="<cfif modo EQ 'CAMBIO'><cfoutput>#LSNumberFormat(rsFPagoLinea.FPfactorConv,',9.0000')#</cfoutput></cfif>"></td>
           <td> <input type="text" name="referenciaEfectivo" id="referenciaEfectivo"  class="field"  pattern="[a-zA-Z0-9]+" maxlength="12"/> </td>
           <td colspan="1">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" nowrap> <div id="divA1" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB1" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                &nbsp;No. Tarjeta </b></font></div>
              <div id="divC1" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                &nbsp;Banco </b></font></div>
              <div id="divD1" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                &nbsp;<cfif rsValidarExisteBancos.Pvalor eq 1>Deposito de </cfif>Banco </b></font></div>
              <div id="divE1" style="display: none ;"><font size="2"><b> 
                <!--- Documento --->
                 &nbsp;No. Documento</b></font></div>
              <div id="divF1" style="display: none ;"><font size="2"><b> 
                <!--- Diferencia --->
                 &nbsp;Diferencia</b></font></div>
                 
                 </td>
                
            <td nowrap> <div id="divA2" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB2" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                Fecha Venc. </b></font></div>
              <div id="divC2" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                No. Cheque </b></font></div>
              <div id="divD2" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                Cuenta Bancaria </b></font></div>
              <div id="divE2" style="display: none ;"><font size="2"><b> 
                <!--- Documento --->
                </b></font></div>
              <div id="divF2" style="display: none ;"><font size="2"><b> 
                <!--- Diferencia --->
                </b></font></div></td>
              
            <td nowrap> <div id="divA3" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB3" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                Tipo </b></font> <label id="lblMonto">&nbsp;</label> </div>
              <div id="divC3" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                Fecha </b></font></div>
              <div id="divD3" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                No. Deposito&nbsp; </b></font></div>
              <div id="divE3" style="display: none ;"><font size="2"><b> 
                <!--- Documento --->
                </b></font></div>
              <div id="divF3" style="display: none ;"><font size="2"><b> 
                <!--- Diferencia --->
                </b></font></div></td>
            <td nowrap>
            	<div id="divB7" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                No. Autorizaci&oacute;n</b></font></div>
                <div id="divD7" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                Banco&nbsp; </b></font></div>
            </td>
            <td nowrap></td>
          </tr>
          <tr> 
            <td nowrap colspan="2"> <div id="divA4" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB4" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                &nbsp; 
                <input type="text" name="T_FPdocnumero" maxlength="25" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();">
                </font></div>
              <div id="divC4" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                &nbsp; 
                <select name="C_FPBanco">
                  <cfoutput query="rsBancos"> 
                    <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C' and #rsFPagoLinea.FPBanco# eq #Bid# >
                      <option value="#Bid#" selected>#Bdescripcion#</option>
                      <cfelse>
                      <option value="#Bid#">#Bdescripcion#</option>
                    </cfif>
                  </cfoutput> 
                </select>
                </font>                
                </div>
              <div id="divD4" style="display: none ;">
               <font size="2"> 
                <!--- Deposito --->
                &nbsp; 
                <cfif rsValidarExisteBancos.Pvalor eq 1>
                	<cfif modo neq 'ALTA' and  #rsFPagoLinea.Tipo# eq 'D' and len(trim(#rsFPagoLinea.MLid#)) gt 0>
                        <cfquery name="rsMLibros" datasource="#session.DSN#">
                            select a.MLmonto, a.Mcodigo,a.MLdescripcion, a.MLdocumento, a.CBid ,c.CBdescripcion, a.Bid
                            from MLibros a
                            inner join BTransacciones b
                                on b.BTid = a.BTid
                                and b.Ecodigo = a.Ecodigo
                            inner join  CuentasBancos c
                                on c.CBid =a.CBid
                            where a.Ecodigo = #session.Ecodigo#
                            and MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFPagoLinea.MLid#">
                        </cfquery>
                        
                        <cfoutput>#rsMLibros.MLdocumento# - #rsMLibros.MLdescripcion#</cfoutput>
                    <cfelse>
                	 	<!---<cf_conlis 
						title="Lista de Depositos en Bancos"
						campos = "MLid,MLdocumento,MLdescripcion "
						desplegables = "N,S,S" 
						modificables = "N,S,S"
						size = "10,10,20"
						tabla="MLibros a 
                        		inner join BTransacciones b
                                    on b.BTid = a.BTid
                                    and b.Ecodigo = a.Ecodigo
                                inner join CuentasCxC cc
            						on cc.CBid = a.CBid    
                                inner join Monedas c
                                	on c.Mcodigo = a.Mcodigo
                                inner join Bancos d
                                    on d.Bid= a.Bid 
                                    and d.Ecodigo = a.Ecodigo
                                inner join CuentasBancos e
                                  on e.CBid = a.CBid
                                  and e.Bid = a.Bid
                                  and e.Ecodigo = a.Ecodigo	"
						columnas="a.MLdocumento, a.MLdescripcion, a.MLreferencia, a.MLid,a.MLfecha, a.MLmonto,  c.Miso4217,Bdescripcion , CBdescripcion"
						filtro="a.Ecodigo = #Session.Ecodigo# 
                                and a.MLutilizado = '0'
                                and b.BTformaPago = 1
                                order by MLfecha desc, MLdocumento asc 
								 "
						desplegar="MLfecha,MLdocumento,MLmonto, Miso4217,MLdescripcion,Bdescripcion , CBdescripcion "
						filtrar_por="MLfecha,MLdocumento,MLmonto,  Miso4217,MLdescripcion,Bdescripcion , CBdescripcion"
						etiquetas="Fecha,Documento, Monto,  Moneda,Descripcion,Banco , Cuenta"
						formatos="D,S,M,S,S,S,S"
						align="left,left,right,left,left"
						asignar="MLid,MLdocumento,MLdescripcion,MLreferencia"
						asignarformatos="I,S,S,S"
						left="125"
						top="100"
						width="1100"
                        funcion="llamar()"
						tabindex="1">--->
						<input type="hidden" id="MLid" name="MLid" value="">
                        <input type="text" name="MLdocumento" id="MLdocumento" 		value="" readonly="readonly" />
                        <input type="text" name="MLdescripcion" id="MLdescripcion" 	value="" readonly="readonly"/>
						<img src="../../imagenes/Description.gif" onClick="javascript:Depositos(); return false;"/>
                        
                        <iframe name="ifrFormaPago" id="ifrFormaPago" width="0" height="0" width="100">
                        </iframe>
                        <script language="javascript" type="text/javascript">
                            function llamar()
                                {
                                    var LvarMLid = document.form1.MLid.value;
                                    document.getElementById('ifrFormaPago').src = "PagoDeBancos.cfm?MLid=" + LvarMLid;
                                }
                        </script>
                    	<input type="hidden" name="D_FPBanco" id="D_FPBanco">
                    </cfif>    
                <cfelse>
                    <select name="D_FPBanco" onChange="javascript: cambiarCuentas();">  
                              <option value="">-- Seleccione Banco --</option>
                    <cfoutput query="rsBancos">                 
                        <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D' and #rsFPagoLinea.FPBanco# eq #Bid# >
                             <option value="#Bid#" selected>#Bdescripcion#</option>
                        <cfelse>					    
                             <option value="#Bid#">#Bdescripcion#</option>                     
                        </cfif>
                        </cfoutput> 
                    </select>
                </cfif>    
                </font>
               </div>
              <div id="divE4" style="display:none;" > <font size="2"> 
                <!--- Documento --->
                
                <table width="1%" cellspacing="0" cellpadding="0" border="0" style="border:0px;">
				<tbody><tr>
				<td>
					&nbsp; &nbsp;<input type="hidden" alt="Dsaldo" value="<cfoutput><cfif modo neq 'ALTA' and rsFPagoLinea.Tipo eq 'A' and rsDocumento.recordcount gt 0>#rsDocumento.Dsaldo#</cfif></cfoutput>" name="Dsaldo" id="Dsaldo">
				</td>
				<td>
					<input type="text" title="CCTcodigo" alt="CCTcodigo" tabindex="5" size="7" value="<cfoutput><cfif modo neq 'ALTA' and rsFPagoLinea.Tipo eq 'A'>#rsFPagoLinea.FPautorizacion#</cfif></cfoutput>" name="D_CCTcodigo" id="D_CCTcodigo" style="font-size:-1px;">
				</td>
				<td>
					<input type="text" title="Ddocumento" alt="Ddocumento" readonly tabindex="-1" size="20" value="<cfoutput><cfif modo neq 'ALTA' and rsFPagoLinea.Tipo eq 'A'>#rsFPagoLinea.FPdocnumero#</cfif></cfoutput>" name="Ddocumento" id="Ddocumento" style="font-size:-1px;">
				</td>
				<td>
                    <a id="imgDsaldo" tabindex="-1" href="javascript:doConlisDsaldo();">
                        <img width="18" height="14" border="0" align="absmiddle" name="imagenDsaldo" alt="Lista de Documentos" src="/cfmx/sif/imagenes/Description.gif">
                    </a>		
				</td>
			</tr>
			</tbody></table>
              </font>
              </div >
              <div id="divF4" style="display:none;" > <font size="2"> 
                <!--- Diferencia --->             
            
            <cfquery name="rsDiferencias" datasource="#Session.DSN#">
                select DIFEcodigo, DIFEdescripcion
                from DIFEgresos a
                where Ecodigo =  #Session.Ecodigo# 
                <cfif modo EQ "ALTA"> 
                	and not exists (select 1 from  <cfif not isdefined('form.CC')> FPagos <cfelse> PFPagos </cfif> b 
                                    where a.DIFEcodigo = b.FPdocnumero
                                    <cfif not isdefined('form.CC')>
                                        and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                                        and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                                    <cfelse> 
                                    	and CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                                        and Pcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
                                    </cfif>    
                                        )
				<cfelse>
                	and a.DIFEcodigo = '#rsFPagoLinea.FPdocnumero#'
                </cfif>                                        
                order by DIFEcodigo 
            </cfquery>
            
            <select name="DIFEcodigo" id="DIFEcodigo" tabindex="1" style="width:215px">
            	<cfoutput>
                <cfloop query="rsDiferencias">
                    <option value="#DIFEcodigo#" <cfif modo NEQ "ALTA" and rsFPagoLinea.FPdocnumero EQ rsDiferencias.DIFEcodigo>selected</cfif>>#DIFEdescripcion#</option>
                </cfloop>
                </cfoutput>
            </select>
            
              </font>
              </div >
              </td>               
            <td nowrap> <div id="divA5" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB5" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                <cfoutput> 
                  <input name="T_FPdocfecha" type="text" size="11" maxlength="10" onBlur="javascript: onblurdatetime(this);" 
									value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T'>#LSDateFormat(rsFPagoLinea.FPdocfecha,"dd/mm/yyyy")#<cfelse>#LSDateFormat(now(),"dd/mm/yyyy")#</cfif>"
									onfocus="this.select();">
                </cfoutput> <a href="#" tabindex="-1"> <img src="/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript: showCalendar('document.form1.T_FPdocfecha');"> 
                </a> </font></div>
              <div id="divC5" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                <input type="text" name="C_FPdocnumero" id="C_FPdocnumero" maxlength="10" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();">
                </font></div>
              <div id="divD5" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                <cfif rsValidarExisteBancos.Pvalor eq 1>
                	<input type="hidden" name="D_FPCuenta" id="D_FPCuenta" >
                    <input type="text"   name="D_FPCuentaTexto" id="D_FPCuentaTexto" readonly >
                <cfelse>  
                    <select name="D_FPCuenta" id="D_FPCuenta" >
                      <!--- Este select se llena con la función inicio() o al cambiar el Banco. --->
                    </select>
                </cfif>
                 </font></div>
              <div id="divE5" style="display: none ;"> <font size="2"> 
                <!--- Documento --->
                <input type="hidden" name="A_FPCuenta" id="A_FPCuenta" >
                </font></div></td>
            <td nowrap> <div id="divA6" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB6" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                <select name="T_FPtipotarjeta" id="T_FPtipotarjeta" onchange="CalculoComision(this);">
                	<option value="">-- Seleccione Tipo --</option>
                  <cfoutput query="rsTTarjeta"> 
                    <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T' and #rsFPagoLinea.FPtipotarjeta# eq #FATid#>
                      <option value="#FATid#" selected>#TTdesc# (Com. #FATporccom#%)</option>
                      <cfelse>
                      <option value="#FATid#">#TTdesc# (Com. #FATporccom#%)</option>
                    </cfif>
                  </cfoutput> 
                </select>
                </font></div>
              <div id="divC6" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                <cfoutput> 
                  <input name="C_FPdocfecha" type="text" size="11" maxlength="10" onBlur="javascript: onblurdatetime(this);" 
									value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C'>#LSDateFormat(rsFPagoLinea.FPdocfecha,"dd/mm/yyyy")#<cfelse>#LSDateFormat(now(),"dd/mm/yyyy")#</cfif>"
									onfocus="this.select();">
                </cfoutput> <a href="#" tabindex="-1"> <img src="/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript: showCalendar('document.form1.C_FPdocfecha');"> 
                </a> </font></div>
              <div id="divD6" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                <input type="text" name="D_FPdocnumero" id="D_FPdocnumero" maxlength="10" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();" 
                <cfif rsValidarExisteBancos.Pvalor eq 1>readonly</cfif>>
                </font></div>
              <div id="divE6" style="display: none ;"> <font size="2"> 
                <!--- Documento --->
                </font></div></td>
            <td nowrap>
            	<div id="divB8" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                <cfoutput> 
                  <input name="T_FPautori" type="text" size="11" maxlength="10" 
									value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T'>#rsFPagoLinea.FPautorizacion#</cfif>"
									>
                </cfoutput> 
                </font></div>
                <div id="divD8" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                <input type="text" name="D_FPbancoDes" id="D_FPbancoDes" maxlength="10" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D'><cfoutput></cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();" 
                <cfif rsValidarExisteBancos.Pvalor eq 1>readonly</cfif>>
                </font></div>
            </td>
            <td nowrap></td>
          </tr>
          <tr> 
            <td nowrap colspan="5">&nbsp;</td>
          </tr>
    </table></td>
    </tr>
   <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap colspan="6"> <table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
          <tr bgcolor="FAFAFA"> 
            <td nowrap>&nbsp;</td>
            <td nowrap><font size="2">&nbsp;<b>Tipo de Pago</b></font></td>
            <td nowrap align="right"><font size="2"><b>Monto de Pago</b></font></td>
			<td nowrap align="right"><font size="2"><b>&nbsp;</b></font></td>
			<td nowrap align="left"><font size="2"><b>Moneda</b></font></td>
            <td nowrap align="right"><font size="2"><b>T.Cambio</b></font></td>
            <td nowrap align="right"><font size="2"><b>Monto Pago <!---<cfoutput>(#rsMonedaTran.Miso4217#)</cfoutput>---></b></font></td>
            <td nowrap>&nbsp;</td>
          </tr>
          <cfset MontoTotal = 0>
          <cfset Monto = 0>
          <cfset VueltoTotal = 0>
          <cfset Saldo = rsETransaccion.ETtotal + rsETransaccion.ETcomision - rsETransaccion.retencion>
          <cfset MaxLen = len(LSCurrencyFormat(rsETransaccion.ETtotal,'none'))>
           <cfoutput query="rsFpagos"> 
             <cfset Monto = FPagoDoc>           
             <cfset Saldo = Saldo - Monto>
             <cfset MontoTotal = MontoTotal + Monto - vuelto>           
        
            <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
              <td nowrap> 
                <font size="2"> 
                <cfif modo neq "ALTA" and FPlinea eq rsFPagoLinea.FPlinea>
                  <input name="btnEditar" type="image" alt="Elemento en edición" 
								 		onClick="javascript: return false;" src="../../imagenes/edita.gif" width="16" height="16">
                  <cfelse>
                  &nbsp; 
                </cfif>
                </font></td>
              <td nowrap><font size="2">&nbsp;#Tipodesc# #descAdicional#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(FPmontoori,'none')#</font></td>
			  <td nowrap align="right"><font size="2">&nbsp;</font></td>
			  <td nowrap align="left"><font size="2">#Mnombre#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(FPtc,'none')#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(FPagoDoc,'none')#</font></td>
              <td nowrap> <font size="2">
			  	    
              <cfif not isdefined('form.CC')>
                   <input  name="btnBorrar" type="image" alt="Eliminar elemento" 
								onClick="javascript: Editar('#FPlinea#','#Tipo#','#FPautorizacion#','#FPdocnumero#');" src="/sif/imagenes/Borrar01_T.gif" width="16" height="16">
                                
				<!---No se permite modificar la informacion del deposito, por lo cual solo se puede eliminar--->
                        <!--- <input name="btnEditar" type="image" alt="Editar elemento" 
						onClick="javascript: Modificar('#FPlinea#','0','#FPtc#','#Mcodigo#');" src="/sif/imagenes/edit_o.gif" width="16" height="16"> --->
                   
                <cfelse>
                   <input  name="btnBorrar" type="image" alt="Eliminar elemento" 
					onClick="javascript: Editar2('#FPlinea#','#Tipo#','#Form.CCTcodigo#','#FPdocnumero#','#form.CC#','#Form.Mcodigo#');" src/sif/imagenes/Borrar01_T.gif" width="16" height="16">
					
					
                		<input name="btnEditar" type="image" alt="Editar elemento" 
						onClick="javascript: Modificar('#FPlinea#','#FPtc#','#Form.Mcodigo#','#Form.CCTcodigo#');" src="/sif/imagenes/edit_o.gif" width="16" height="16">
                 
                </cfif>		  
                </font>
                </td>
            </tr>
          </cfoutput> 
		  <cfoutput> 
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5">&nbsp;</td>
              <td nowrap align="right"><font size="2"><b> 
                <cfset CountVar = 0>
                <cfloop condition = "CountVar LESS THAN OR EQUAL TO MaxLen">
                  <cfset CountVar = CountVar + 1>
                  - 
                </cfloop>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Total (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b><!-----#rsMonedaTran.Msimbolo#-----> #LSCurrencyFormat(MontoTotal,'none')#</b></font></td>            <input name="TotalPagadoPF" 		type="hidden" id="TotalPagadoPF"  value="#MontoTotal#"	    >
               <input type="hidden" name="montoTotal" id="montoTotal" value="#MontoTotal#">
               <input type="hidden" name="vuelto" id="vuelto" value="">
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Saldo (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b> 
                <cfif Saldo gt 0>
                  <!-----#rsMonedaTran.Msimbolo#-----> #LSCurrencyFormat(Saldo,'none')# 
                  <cfelse>
                  <!-----#rsMonedaTran.Msimbolo#---> 0.00 
                </cfif>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Cambio (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b> 
                <cfif Saldo lt 0>
                  <!-----#rsMonedaTran.Msimbolo#----> #LSCurrencyFormat(Saldo*-1,'none')#  (#rsMonedaLocal.Msimbolo#  #LSCurrencyFormat((Saldo * rsETransaccion.ETtc)*-1,'none')#)
                  <cfelse>
                  #rsMonedaTran.Msimbolo# 0.00 
                </cfif>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
          </cfoutput> 
        </table></td>
      <td nowrap>&nbsp;</td>
    </tr>
    <cfoutput> 
      <tr> 
        <td nowrap colspan="#ncols#"> <font size="2"> 
          <input type="hidden" name="FPlinea" value="<cfif modo neq 'ALTA'>#rsFPagoLinea.FPlinea#</cfif>">
          <input type="hidden" name="modo" value="#modo#">
          </font></td>
      </tr>
    </cfoutput> 
    <tr>
     <td colspan="6" align="center"> <input type="button" name="cerrar" value="Cerrar" onClick="Cerrar()">
     
     </td>
    </tr>
  </table>
</form>
<font size="2"> 
<script language='JavaScript'>
	var f=document.form1;
	f.Tipo.alt="El tipo de pago";
	f.FPmontoori.alt="El monto";
	f.Mcodigo.alt="El campo moneda";
	f.FPtc.alt="El tipo de cambio";
	f.T_FPdocnumero.alt="El número de tarjeta de crédito";
	f.C_FPBanco.alt="El banco";
	f.D_FPBanco.alt="El banco";
	f.T_FPdocfecha.alt="El campo fecha de vencimiento";
	f.C_FPdocnumero.alt="El número de cheque";
	f.D_FPCuenta.alt="El campo cuenta bancaria";
	f.T_FPtipotarjeta.alt="El tipo de tarjeta";
	f.C_FPdocfecha.alt="El campo fecha";
	f.D_FPdocnumero.alt="El número de depósito";
	f.T_FPautori.alt="El número de autorización";

	//Validaciones con qForms
	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");
	<!---objForm.T_FPdocnumero.validateCreditCard(f.T_FPdocnumero.alt + " es inválido.");--->
	inicio();
	function Cerrar()
	{		
	 
	  window.close();
	}

	<cftry>
		<cfset _ocultarBotonesyEdicion = false>
		<cfif isDefined('form.LiquidacionCajero')>
			<cfif not isdefined('form.CC') or form.CC eq 0> <!---  Factura --->
	             <cfquery name="rs" datasource="#session.dsn#">
	             	select 1 from ETransacciones
	             	where ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
	             	  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	             	  and ETestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="C">
	             </cfquery>
	             <cfif rs.recordcount>
	             	<cfset _ocultarBotonesyEdicion = true>
	             </cfif>
	        <cfelseif isdefined('form.CCTcodigo') and len(trim(#form.CCTcodigo#)) gt 0>
	            <cfquery name="rs" datasource="#session.dsn#">
	            	select 1 from HPagos
	            	where Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcodigo#">
	            	  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
	            </cfquery>
	            <cfif rs.recordcount>
	            	<cfset _ocultarBotonesyEdicion = true>	            		
	            </cfif>
	        </cfif>
	        <cfif _ocultarBotonesyEdicion>
	        	$(document).ready(function(){
	        		$('.cuadro').remove();
	        		$('[name="btnBorrar"]').remove();
	        		$('[name="btnEditar"]').remove();
	        	});
	        </cfif>
		</cfif>
		<cfcatch type="any">
			<cfrethrow>				
		</cfcatch>
	</cftry>


	//captura el evento cuando se va cerrando y refresca el padre.
	window.onbeforeunload  = refreshParent;
    function refreshParent() {
       <cfif isdefined('form.CC')>
       try{ window.opener.document.form1.TotalPagado.value= document.form1.TotalPagadoPF.value;	} catch(e){}
	  </cfif>
	  <cfif isDefined('form.LiquidacionCajero')>
	  	window.opener.location = 'LiquidacionCajero-form.cfm?FALIid=' + <cfoutput>'#form.FALIid#'</cfoutput>	  
	  </cfif>
    }
	
	function Depositos() {
	 window.open("../../cc/operacion/Depositos.cfm?PcodigoE=22&CCTcodigoE=fc&PtipoSN=4&SNcodigo=1234", "genDiferencia", "left=150,top=200,scrollbars=yes,resizable=no,width=1100,height=300");
	}

  function CalculoComision(tj) {
    try {
      var strMonto = document.form1.FPmontoori.value;
      var _monto = strMonto.replace(",", "");
      var _tipoTarjeta = tj.options[tj.selectedIndex].text;
      var _floatValues =  /[+-]?([0-9]*[.])?[0-9]+/;
      var percent = _tipoTarjeta.match(_floatValues).map(Number);
      if (Array.isArray(percent)){
        _percent = percent[0];
      } else  _percent = percent;
      var _comision = _monto * (_percent/100);
      var _total = parseFloat(_monto) + parseFloat(_comision);
      document.getElementById('lblMonto').innerHTML = 'Monto total: $'+ (_total);
    }
    catch(err) {
      document.getElementById('lblMonto').innerHTML = '';
    }

  }
</script>
</font> 
</body>
</html>

