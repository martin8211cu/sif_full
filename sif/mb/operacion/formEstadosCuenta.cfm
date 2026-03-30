<!---------
	Modificado por Gustavo Fonseca H.
		Fecha: 18-8-2006.
		Motivo: En alta se pone el foco en el Banco y en el cambio se pone el foco en el Tipo de Transaccion.
		
	Modificado por Gustavo Fonseca H.
		Fecha: 27-1-2006.
		Motivo: Se valida que la fecha Hasta no sea mayor que la fecha de actual. (Pedido por Mauricio Esquivel).

	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: Eliminar la validacion del saldo inicial del estado de cuenta, y permitir que sea cero o menor.
			Se agrego el boton nuevo.
	
	Modificado por: Gustavo Fonseca H.
		Fecha: 19-10-2005.
		Motivo: Se modifica para que no pueda cambiar el banco y la cuenta bancaria en "CAMBIO".
		Se alínea el detalle a una solaínea: Tipo transacción, Documento, Fecha, Monto Origen. Se eliminan
		el saldo y las referencias.

	Modificado por: Gustavo Fonseca H.
		Fecha: 12-10-2005.
		Motivo: Se modifica el campo del Saldo Inicial que tiraba un error de javascript en el onblur. 
		También se modifica el combo del detalle para que muestre las transacciones del banco.

	Modificado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Creación de un nuevo proceso de importacion de estados de cuenta. (boton) 
			Se agregó un nuevo proceso de impresión de estados de cuenta en forma masiva. (a nivel de la lista de estados)
			Se agregó un nuevo proceso de impresión de estados de cuenta. 
----------->
<!---<cf_dump var="#Form.ECid#">--->

    <cfset LvarLblSaldoInicial = "Saldo Inicial">
    <cfset LvarLblSaldoFinal = "Saldo Final">
<cfif isdefined("LvarTCEFormStadosCuenta")>
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
	<cfset LvarIrASQLEstadosCuenta="SQLEstadosCuentaTCE.cfm">
	<cfset LvarIrARPRegistroEstadosCuenta="RPRegistroEstadosCtasTCE.cfm">
	<cfset LvarIrAConlisCuentBancarias="ConlisCuentasBancariasTCE.cfm">
	<cfset LvarIrAEstadosCuenta="EstadosCuentaTCE.cfm">
	<cfset LvarIrAListaEstadosCuenta="listaEstadosCuentaTCE.cfm">
    <cfset LvarLblSaldoInicial = "Saldo Anterior">
    <cfset LvarLblSaldoFinal = "Importe a Pagar">
	
	<cfif IsDefined('LvarIrConciliacion')>
		<cfset LvarIrAListaEstadosCuenta="listaEstadosCuentaProcesoTCE.cfm">
		<cfset LvarIrAEstadosCuenta="EstadosCuentaCONCTCE.cfm">
		<cfset LvarIrASQLEstadosCuenta="SQLEstadosCuentaCONCTCE.cfm">
 	</cfif>
	<cfset LvarIrAImportarArchivo="ImportarECarchivoTCE.cfm">
<cfelse>
	<cfset LvarIrASQLEstadosCuenta="SQLEstadosCuenta.cfm">
	<cfset LvarIrARPRegistroEstadosCuenta="RPRegistroEstadosCtas.cfm">
	<cfset LvarIrAConlisCuentBancarias="ConlisCuentasBancarias.cfm">
	<cfset LvarIrAListaEstadosCuenta="listaEstadosCuenta.cfm">
	<cfset LvarIrAEstadosCuenta="EstadosCuenta.cfm">
	<cfset LvarIrAImportarArchivo="ImportarECarchivo.cfm">
	<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>

<!---<cf_dump var="##">--->
<script language="JavaScript" src="../../js/fechas.js"></script> 
<cfif not isDefined("Form.NuevoE")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset ECid = Trim(arreglo[1])>
 		<cfif sizeArreglo EQ 4>
			<cfset Linea = Trim(arreglo[2])>
			<cfset form.Bid = " ">
			<cfset form.Bid = Trim(arreglo[3])>
			<cfset form.BTEcodigo = Trim(arreglo[4])>
			<cfset modoDet = "CAMBIO">
		</cfif>
	<cfelseif isDefined("Form.ModificarEC") and isDefined("Form.opt") and Len(Trim(Form.opt)) GT 0 >
		<cfparam name="Form.ECid" default="#Form.opt#">
		<cfset ECid = Form.ECid>
		<cfset modo = "CAMBIO">
	<cfelseif isDefined("Form.AgregarEC") >
		<cfset modo = "ALTA">										
	<cfelseif isDefined("Form.ModificarEstado") >
		<cfset ECid = Form.ECid>
		<cfset modo = "CAMBIO">																
	<cfelse>
		<cfset ECid = Trim(Form.ECid)>
		<cfif isDefined("Form.Linea") and Len(Trim(Form.Linea)) NEQ 0>
			<cfset Linea = Trim(Form.Linea)>
		</cfif>
	</cfif>
</cfif>

<cfif not isdefined("Session.ImportarECuenta")>
	<cfset Session.ImportarECuenta = StructNew()>
</cfif>
<cfif modo NEQ 'ALTA' and isdefined('Form.ECid')>
<cfset Session.ImportarECuenta.ECid = Form.ECid>
</cfif>

<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bid, Bdescripcion from Bancos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Bdescripcion
</cfquery>
	<!--- <cfdump var="#rsBancos#"> --->

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsEstadoCuenta" datasource="#Session.DSN#">
<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1'>
        select a.ECid, 
			a.Bid, 
			a.ECfecha, 
			a.CBid, 
			a.ECsaldoini, 
			a.ECsaldofin, 
			a.ECdescripcion, 
			a.ECusuario, 
			a.ECdesde, 
			a.EChasta, 
			a.ECdebitos, 
			a.ECcreditos, 
			a.ECaplicado, 
			a.EChistorico, 
			a.ECselect, 
			a.ts_rversion,
            c.CBdescripcion, 
			a.ECStatus,
            <!-----Estatus del pago ---->
            coalesce((select case e.CBPTCestatus  
						                        when 10 then'En Digitación'  
						                        when 11 then 'En Proceso' 
												when 12 then 'Emitido' 
												when 13 then 'Anulado' 												 
												end
							 from CBEPagoTCE e inner join CBDPagoTCEdetalle d
						   on e.CBPTCid = d.CBPTCid
						  where
						   d.ECid = a.ECid
						    and not exists (select 1 from CBEPagoTCE g where CBPTCidOri= e.CBPTCid)
                            ), 'Sin pago registrado') as CBPTCestatus 
        from ECuentaBancaria a             
            inner join CuentasBancos c
                on a.CBid = c.CBid
            inner join CBTarjetaCredito t
                on c.CBTCid = t.CBTCid  
         where  a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">   
<cfelse>
     select a.ECid, a.Bid, a.ECfecha, a.CBid, 
			a.ECsaldoini, a.ECsaldofin, a.ECdescripcion, a.ECusuario, 
			a.ECdesde, a.EChasta, a.ECdebitos, a.ECcreditos, 
			a.ECaplicado, a.EChistorico, a.ECselect, a.ts_rversion           	
		from ECuentaBancaria a 	
        where	
        a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">        
</cfif>       
	</cfquery>

<!---Qry para verificar si existen lineas de movimientos asociados a ese estado de cuenta--->
<cfquery name="rsVerificaLineas" datasource="#Session.DSN#">
	select ECid, Linea, BTid, BTEcodigo,
		DCfecha, rtrim(Documento) as Documento, rtrim(DCReferencia) as DCReferencia, 
		DCconciliado, DCmontoori, DCmontoloc, DCtipo, DCtipocambio, ts_rversion
	from DCuentaBancaria
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">			
</cfquery>
<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1'>
  <cfset LvarEnMoneda = "">
  <cfif rsEstadoCuenta.recordcount gt 0>
     <cfif isdefined('rsEstadoCuenta.CBid') and len(trim(#rsEstadoCuenta.CBid#)) gt 0> 
       
       <cfquery name="rsEnMoneda" datasource="#session.dsn#">
         select Mcodigo from CuentasBancos where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
       </cfquery>        
       
       <cfquery name="rsMonedaEmpresa" datasource="#session.dsn#">
         select Mcodigo from Empresas where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
       </cfquery>        
	   <cfif rsEnMoneda.recordcount gt 0>
            <cfif  rsEnMoneda.Mcodigo eq rsMonedaEmpresa.Mcodigo>
               <cfset LvarEnMoneda = 'LOC'>
            <cfelse>
               <cfset LvarEnMoneda = 'ORI'> 
            </cfif>                         
       </cfif>       
     </cfif>
        
        <cfquery name="rsDebitos" datasource="#session.dsn#">
          select 
          <cfif LvarEnMoneda eq 'LOC'>
             coalesce(sum(DCmontoloc),0.00) as Debitos
          <cfelse>
             coalesce(sum(DCmontoori),0.00) as Debitos
          </cfif>   
               from DCuentaBancaria
               where ECid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">  
               and DCtipo = 'D'
        </cfquery>
        <cfquery name="rsCreditos" datasource="#session.dsn#">
            select 
              <cfif LvarEnMoneda eq 'LOC'>
                 coalesce((sum(DCmontoloc)*-1),0.00) as Creditos
              <cfelse>
                 coalesce((sum(DCmontoori)*-1),0.00) as Creditos
              </cfif>   
                   from DCuentaBancaria
                   where ECid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">  
                   and DCtipo = 'C'       
        </cfquery>         
  </cfif>    
</cfif>		




    <cfif isdefined("rsEstadoCuenta") and rsEstadoCuenta.recordcount eq 0>
    	<cfthrow detail="El ECid (#ECid#) de la tabla ECuentaBancaria no existe en el sistema">
    </cfif>
    
	<cfif isdefined("rsEstadoCuenta") and rsEstadoCuenta.recordcount eq 1 and len(trim(rsEstadoCuenta.Bid))>
		<cfset form.Bid = " ">		
		<cfset form.Bid = rsEstadoCuenta.Bid>
	</cfif>
	
	
		<!---<cfquery name="rsBancosConlis" datasource="#session.DSN#">
			select 
				Bid as bid2,
				BTEcodigo,
				BTEdescripcion,
				BTEtipo
			from TransaccionesBanco
			where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			<cfif isdefined("form.BTEcodigo")> 
				and rtrim(ltrim(upper(BTEcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(form.BTEcodigo))#">
			</cfif>
             and BTEtce = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBesTCE#">
		</cfquery>--->
<!--- 		<cf_dump var="#rsBancosConlis#"> --->
	
	
	<!--- <cfdump var="#rsEstadoCuenta#"> --->
	<cfquery name="rsDescripciones" datasource="#Session.DSN#">
		select a.CBid, a.CBcodigo, a.CBdescripcion, b.Mnombre, a.Mcodigo, case when a.Mcodigo !=1 then 0.0000 else 1.0000 end as TipoCambio 
		<!--- , a.EIid as EIidCB, c.EIid as EIidB--->
		from CuentasBancos a, Monedas b, Bancos c 
		where a.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoCuenta.CBid#">
        and a.CBesTCE = #LvarCBesTCE# 
		and a.Bid = c.Bid 
		and a.Mcodigo = b.Mcodigo
	</cfquery>
	<cfif isdefined('rsDescripciones.EIidCB')  and LEN(rsDescripciones.EIidCB) GT 0>
		<cfset archivo = rsDescripciones.EIidCB>
	<cfelseif isdefined('rsDescripciones.EIidB')  and LEN(rsDescripciones.EIidB) GT 0>
		<cfset archivo = rsDescripciones.EIidB>
	<cfelse>
		<cfset archivo = 0>
	</cfif>
	<!--- <cfquery name="rsTransacciones" datasource="#Session.DSN#">
		select a.Ecodigo, a.BTEcodigo, a.BTEdescripcion, b.BTdescripcion, b.BTtipo, b.BTid
		from BTransaccionesEq a
			inner join BTransacciones b
				on b.BTid = a.BTid
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		and <cf_dbfunction name="to_char" args="a.BTid" datasource="#session.DSN#"> 
			not in (
				select c.Pvalor
				from Parametros c
				where c.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and c.Pcodigo between 160 and 170
			)
			order by a.BTid
	</cfquery> --->
	
   	<!--- <cfquery name="rsTransacciones" datasource="#Session.DSN#">
    	select BTid, BTdescripcion, BTtipo 
		from BTransacciones 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and <cf_dbfunction name="to_char" args="BTid" datasource="#session.DSN#"> not in (
		  	select Pvalor
			from Parametros 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  	and Pcodigo between 160 and 170
		)
		order by BTid	
	</cfquery> --->
	
	<cfquery name="rsTipo" datasource="#Session.DSN#">
    	select BTid, BTtipo 
		from BTransacciones 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and <cf_dbfunction name="to_char" args="BTid" datasource="#session.DSN#"> not in (
			select Pvalor 
			from Parametros 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  	and Pcodigo between 160 and 170
		)
	</cfquery>
	
	<cfif modoDet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select ECid, Linea, BTid, BTEcodigo,
				DCfecha, rtrim(Documento) as Documento, rtrim(DCReferencia) as DCReferencia, 
				DCconciliado, DCmontoori, DCmontoloc, DCtipo, DCtipocambio, ts_rversion, Bid
            from DCuentaBancaria
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
              and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Linea#">				
		</cfquery>	
 	<!---<cfelse>
		 <cfquery name="rsLinea" datasource="#Session.DSN#">
			select ECid, Linea, BTid, 
				DCfecha, Documento, DCReferencia, 
				DCconciliado, DCmontoori, DCmontoloc, DCtipo, DCtipocambio, ts_rversion
            from DCuentaBancaria
		</cfquery> --->	
	</cfif>	
</cfif>
<cfif modo eq "CAMBIO">
	<cfquery name="rsStatusBorrarDoc" datasource="#session.dsn#">
		Select count(1) as Total
		from CDBancos a
				inner join DCuentaBancaria b
					 on a.ECid = b.ECid
					and a.CDBlinea = b.Linea
		where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		  and a.CDBconciliado =  <cfqueryparam cfsqltype="cf_sql_char" value="S">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
</cfif>
	


<script language="JavaScript1.2">
	
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlis() {
		popUpWindow("<cfoutput>#LvarIrAConlisCuentBancarias#</cfoutput>?form=form1&id=CBid&desc=CBdescripcion&Bid="+document.form1.Bid.value+"&monedaLocal="+document.form1.monedaLocal.value,250,200,650,350);
	}

	function limpiarCuenta() {
		document.form1.CBid.value = "";
		document.form1.Mnombre.value = "";
		document.form1.CBdescripcion.value = "";
		document.form1.Mcodigo.value = "";
		document.form1.ECtipocambio.value = "0.0000";		
		document.getElementById("MonedaLabel").style.visibility = "hidden";			
		<cfif modo NEQ "ALTA"> 
			document.form1.DCtipocambio.value = "0.0000";				
		</cfif>
	}

	function sugerirTipoCambio(){
       	if (document.form1.monedaLocal.value == document.form1.Mcodigo.value) {
            document.form1.DCtipocambio.value = "1.00";
            document.form1.DCtipocambio.disabled = true;            
       	}
       	else
           document.form1.DCtipocambio.disabled = false; 
	}

	function Lista() {
		<!---Redireccion listaEstadosCuenta.cfm o TCElistaEstadosCuenta.cfm--->
		location.href="<cfoutput>#LvarIrAListaEstadosCuenta#</cfoutput>";
	}
	
	function updateEncabezado()
	{
		document.form1.onsubmit="";
		document.form1.updateEnc.value="1";
		document.form1.submit();

	}
		
	function valida() {
		/* Quita el formato antes del post */
		document.form1.ECsaldoini.value = qf(document.form1.ECsaldoini.value);
		document.form1.ECsaldofin.value =  qf(document.form1.ECsaldofin.value);		

		// guarda los totales de créditos y débitos
		document.form1.ECdebitos.value =  qf(document.form1.ECdebitos.value);             
		document.form1.ECcreditos.value =  qf(document.form1.ECcreditos.value);             
		document.form1.ECdescripcion.value = 'Desde: '+document.form1.ECdesde.value+' Hasta: '+document.form1.EChasta.value;
		<cfif modo NEQ "ALTA"> return validaD(); </cfif>
		if(ValidaFechasE() && ValidaFechaHasta()){
			return true;
		}
		else{
			return false;
		}
	}

	function validatc()
	{   	
		//document.form1.ECtipocambio.disabled = false;		
		if (document.form1.Mcodigo.value == document.form1.monedalocal.value){						
			document.form1.ECtipocambio.value = "1.00";
			//document.form1.ECtipocambio.disabled = true;          			
		} 
		else{
		
		}		
	}	

	function validaD() {
		document.form1.DCmontoori.value =  qf(document.form1.DCmontoori.value);            
		// calcula el monto local = monto origen * tipo de cambio
		document.form1.DCmontoloc.value =  qf(document.form1.DCmontoori.value) * qf(document.form1.DCtipocambio.value); 
		document.form1.DCtipocambio.value =  qf(document.form1.DCtipocambio.value); 
		if(ValidaFechasE() && ValidaFechaHasta()){
			return true;
		}
		else{
			return false;
		}
		return ValidaFechas();           
		return true;	
	}

	function AsignarHiddensEncab() {
		document.form1._Bid.value = document.form1.Bid.value;				
		document.form1._CBid.value = document.form1.CBid.value;				
		document.form1._ECdescripcion.value = document.form1.ECdescripcion.value;		
	<cfif isdefined('LvarTCEFormStadosCuenta') and  LvarTCEFormStadosCuenta neq '1'> 	
		document.form1._ECdesde.value = document.form1.ECdesde.value;		
	</cfif>	
		document.form1._EChasta.value = document.form1.EChasta.value;		
		document.form1._ECsaldoini.value = document.form1.ECsaldoini.value;
		document.form1._ECsaldofin.value = document.form1.ECsaldofin.value;		
	}

	function Postear(){
		if (confirm('¿Desea aplicar este documento?')) {
			//document.form1.ECtipocambio.disabled = false;
			return true;
		} 
		else return false; 	
	}
	
	 

	function actualizaSaldoFin() {		
		if (!validaNumero(qf(document.form1.ECsaldoini.value))){
			document.form1.ECsaldoini.select();
			return false;
		}
			
		if (!validaNumero(qf(document.form1.ECdebitos.value))){
			document.form1.ECdebitos.select();
			return false;
		}
	
		if (!validaNumero(qf(document.form1.ECcreditos.value))){
			document.form1.ECcreditos.select();
			return false;
		}
		
		var saldoIni = new Number(qf(document.form1.ECsaldoini.value));
		var debitos = new Number(qf(document.form1.ECdebitos.value));
		var creditos = new Number(qf(document.form1.ECcreditos.value));
		var saldoFin = new Number(qf(document.form1.ECsaldofin.value));
		var temp = saldoIni + debitos - creditos;
		document.form1.ECsaldofin.value = temp;
		fm(document.form1.ECsaldoini,2);
		fm(document.form1.ECdebitos,2);
		fm(document.form1.ECcreditos,2);
		fm(document.form1.ECsaldofin,2);
		return true;
	}
	
	function formatear() {		
		fm(document.form1.DCmontoori,2);
		return true;
	}

	function cargarTipo(dato) {//alert(dato); alert(document.form1.BTEtipo.value); 
		<cfif modo NEQ "ALTA">
			document.form1.DCtipo.value = document.form1.BTEtipo.value;				
		</cfif>				
	}
	function funcBTEcodigo() { 
		<cfif modo NEQ "ALTA">
			document.form1.DCtipo.value = document.form1.BTEtipo.value;				
		</cfif>				
	}
 </script>
 
<!--- 
 		function cargarTipo(dato) {
		<cfif modo NEQ "ALTA">
		<cfloop query="rsTransacciones">
			if (dato == "<cfoutput>#rsTransacciones.BTid#</cfoutput>") 
				document.form1.DCtipo.value = "<cfoutput>#rsTransacciones.BTtipo#</cfoutput>";				
		</cfloop>
		</cfif>				
	}
	 --->
 
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
	
	<style type="text/css">
<!--
.Estilo1 {color: #FF0000}
-->
    </style>
		<!---Redireccion SQLEstadosCuenta.cfm o TCESQLEstadosCuenta.cfm (TCE)--->
	<form style="margin: 0" name="form1" action="<cfoutput>#LvarIrASQLEstadosCuenta#</cfoutput>" method="post" onsubmit="return ValidaFechaHasta();"><!--- onsubmit="return ValidaFechas();" --->
		<cfoutput>
			<input name="LvarHoy" value="#LsDateFormat(now(),'DD/MM/YYYY')#" type="hidden">
		</cfoutput>
		<input type="hidden" value="0" name="updateEnc"/>
		
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr><td colspan="6" class="tituloAlterno"><div align="center">Encabezado del Documento </div></td></tr>
			<tr> 
				<td> <div align="right"><strong>Banco:&nbsp;</strong></div></td>
				<td> 
					<cfif modo NEQ 'ALTA'>
					
							 <cfquery name="RsBdescripcion" dbtype="query">
								select Bdescripcion
									from rsBancos
									where Bid = #rsEstadoCuenta.Bid#
							</cfquery><!--- --->
						
						<cfoutput>&nbsp;#RsBdescripcion.Bdescripcion#</cfoutput>
						<cfoutput>
							<input name="Bid" type="hidden" value="#form.Bid#">
						</cfoutput>
					<cfelse>
						<select name="Bid" tabindex="1" onChange="javascript:limpiarCuenta();">
							<cfoutput query="rsBancos"> 
								<option value="#rsBancos.Bid#" 
									<cfif modo NEQ "ALTA" and rsBancos.Bid EQ rsEstadoCuenta.Bid>selected</cfif>>
									#rsBancos.Bdescripcion#
								</option>
							</cfoutput> 
						</select> 
					</cfif>
				</td>
                
                <cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1' and modo EQ "ALTA">
                   <td nowrap> <div align="right" id="LBlTarjCred"><strong>Tarjeta de Cr&eacute;dito:&nbsp;</strong></div></td>
                    <td nowrap><div id="CMPTarjCred"> 
                      <cf_conlis      
                                campos = "Id,CBcodigo,CBdescripcion"
                                desplegables = "N,S,S"
                                modificables = "N,N,N"
                                size = "10,10"
                                title="Lista de Cuentas Bancarias"
                                tabla="CuentasBancos cb 
                                          inner join Monedas mo
                                                on cb.Mcodigo=mo.Mcodigo
                                          inner join CBTarjetaCredito tj 
                                                on cb.CBTCid = tj.CBTCid
                                          inner join CBStatusTarjetaCredito stj
                                          		on tj.CBSTid = stj.CBSTid      
                                         inner join DatosEmpleado de
                                                on tj.DEid=de.DEid"                                       
                                columnas="cb.CBid as Id,cb.CBcodigo,
                                            cb.CBdescripcion,tj.CBTCDescripcion,    
                                            de.DEnombre,de.DEapellido1,de.DEapellido2,
                                                    mo.Miso4217,cb.CBTCid"               
                                filtro="cb.Ecodigo=#session.Ecodigo# and cb.CBesTCE = 1 and cb.Bid = $Bid,numeric$ and stj.CBSTActiva = 1"                                                           
                                desplegar="CBcodigo,CBdescripcion,CBTCDescripcion, DEnombre,DEapellido1,DEapellido2,Miso4217"
                                etiquetas="Codigo,descripcion,Tarjeta Credito,Nombre, Apellido 1, Apellido 2,Moneda"
                                formatos="S,S,S,S,S,S,S,S"
                                align="left,left,left,left,left,left,left"
                                asignar="Id,CBcodigo,CBdescripcion,CBTCDescripcion,DEnombre,DEapellido1,DEapellido2,Miso4217"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen tarjetas --"
                                tabindex="2"
                                top="100"
                                left="200"
                                width="850"
                                height="600"
                                asignarformatos="S,S,S,S,S,S,S,S">       
                       </div>                       
                    </td>
                <cfelseif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1' and modo NEQ "ALTA">                
                   <td nowrap> <div align="right" id="LBlTarjCred"><strong>Tarjeta de Cr&eacute;dito:&nbsp;</strong></div></td>
                   <td nowrap><cfoutput>&nbsp;#rsEstadoCuenta.CBdescripcion#</cfoutput></td>
                <cfelse>
                    <td nowrap> <div align="right"><strong>Cuenta Bancaria:&nbsp;</strong></div></td>
                    <td nowrap> 
                        <cfif modo NEQ "ALTA">
                            <cfoutput>#rsDescripciones.CBcodigo#&nbsp;-&nbsp;#rsDescripciones.CBdescripcion#</cfoutput>
                            <input name="CBdescripcion" type="hidden" value="<cfoutput>#rsDescripciones.CBdescripcion#</cfoutput>"> 
                        <cfelse>
                            <input name="CBdescripcion" tabindex="2" readonly type="text" size="40" maxlength="80" 
                            value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.CBdescripcion#</cfoutput></cfif>"> 
                            <a href="#" tabindex="-1">
                                <img src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" 
                                    align="absmiddle" onClick="javascript:doConlis();">
                            </a> 
                        </cfif>
                    </td>
				</cfif>
				
				<td> <div align="right" id="MonedaLabel"><strong>Moneda:&nbsp;</strong></div></td>
				<td>
					<input type="text" name="Mnombre" readonly tabindex="-1" class="cajasinborde" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.Mnombre#</cfoutput></cfif>" size="40" maxlength="80">
				</td>
 			</tr>
			<tr> 
            <cfif not isdefined("LvarTCEFormStadosCuenta")>
				<td><div align="right"><strong>Desde:&nbsp;</strong></div></td>
				<td nowrap>
					<cfoutput>
						<cfif modo EQ 'CAMBIO'>
							<cfset fechadesde = "#LSDateFormat(rsEstadoCuenta.ECdesde,'DD/MM/YYYY')#">
						<cfelse>
							<cfset fechadesde = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
						</cfif>
						<cf_sifcalendario tabindex="1" Conexion="#session.DSN#" form="form1" name="ECdesde" value="#fechadesde#">
					</cfoutput>										
				</td>
				<td><div align="right"><strong>Hasta:&nbsp;</strong></div></td>
				<td nowrap>
					<cfoutput>
						<cfif modo EQ 'CAMBIO'>
							<cfset fechahasta = "#LSDateFormat(rsEstadoCuenta.EChasta,'DD/MM/YYYY')#">
						<cfelse>
							<cfset fechahasta = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
						</cfif>
						<cf_sifcalendario tabindex="1" Conexion="#session.DSN#" form="form1" name="EChasta" value="#fechahasta#">
					</cfoutput>										
				</td>
               <cfelse>
               <td nowrap="nowrap"><div align="right"><strong>Fecha Desde:&nbsp;</strong></div></td>
			   <td nowrap>
					<cfoutput>
						<cfif modo EQ 'CAMBIO'>
							<cfset fechadesde = "#LSDateFormat(rsEstadoCuenta.ECdesde,'DD/MM/YYYY')#">
						<cfelse>
							<cfset fechadesde = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
						</cfif>
						<cf_sifcalendario tabindex="1" Conexion="#session.DSN#" form="form1" name="ECdesde" value="#fechadesde#">
					</cfoutput>										
			   </td>
                
               <td nowrap="nowrap"><div align="right"><strong>Fecha de Corte:&nbsp;</strong></div></td>
				<td nowrap>
					<cfoutput>
						<cfif modo EQ 'CAMBIO'>
							<cfset fechahasta = "#LSDateFormat(rsEstadoCuenta.EChasta,'DD/MM/YYYY')#">
						<cfelse>
							<cfset fechahasta = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
						</cfif>
						<cf_sifcalendario tabindex="1" Conexion="#session.DSN#" form="form1" name="EChasta" value="#fechahasta#">
					</cfoutput>										
				</td>
                &nbsp;&nbsp;															
               </cfif> 
				<td>
					<div align="right"> 
						<input name="ECdescripcion" type="hidden" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.ECdescripcion#</cfoutput></cfif>">
						<strong><cfoutput>#LvarLblSaldoInicial#</cfoutput>:&nbsp;</strong> 
					</div>
				</td>
				<td><cfoutput><!--- onChange="javascript:formatear();" --->
					<input type="text" name="ECsaldoini" 
					onblur="javascript:fm(this,2);" 
					onFocus="javascript:this.value = qf(this.value); this.select();"
					value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsEstadoCuenta.ECsaldoini,'none')#<cfelse>0.00</cfif>" 
					tabindex="1" size="18" maxlength="18" style="text-align:right"></cfoutput>
				</td>
			</tr>
			<tr> 
				<cfif modo EQ 'CAMBIO' and  isdefined("LvarTCEFormStadosCuenta")>
                    <td nowrap="nowrap" align="right">                
                                  <div align="right"><strong>Estado de Pago:&nbsp;</strong></div>
                    </td>
                    <td nowrap="nowrap">
                          <cfoutput>#rsEstadoCuenta.CBPTCestatus#</cfoutput>                
                    </td>  
					<!---========Etiqueta Estatus==========--->
 					<td align="right"><strong>Status:&nbsp;</strong></td>
 					<td>
						<cfif IsDefined('rsEstadoCuenta.ECStatus')>
                            <cfif #rsEstadoCuenta.ECStatus# eq 0>						
                                <cfoutput><span class="Estilo1">En Revisi&oacute;n</span></cfoutput>
                            <cfelse>
                                <cfoutput>Revisado</cfoutput>
                            </cfif>
                        </cfif>
					</td>
                <cfelse>
                	<td colspan="4">&nbsp;</td>
  				</cfif>
 				<td nowrap><div align="right"><strong>Total&nbsp;D&eacute;bitos:&nbsp;</strong></div></td>
				<td>
                	<cfif modo neq 'ALTA'>
						<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1'>
                           <cfset LvarValorDebitos = rsDebitos.Debitos>
                        <cfelse>
                          <cfset LvarValorDebitos  = rsEstadoCuenta.ECdebitos> 
                        </cfif> 
                    </cfif>
					<input type="text" name="ECdebitos" onFocus="javascript: this.select();" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(LvarValorDebitos,'none')#</cfoutput>
                    <cfelse>
					<cfoutput>0.00</cfoutput></cfif>" 
					size="18" maxlength="18" style="text-align:right" readonly>
				</td>
			</tr>
			<tr> 
				<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				<td nowrap><div align="right"><strong><strong>Total&nbsp;Cr&eacute;ditos:&nbsp;</strong></strong></div></td>
				<td>
                	<cfif modo neq 'ALTA'>
						<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1'>
                           <cfset LvarValorCreditos = rsCreditos.Creditos>
                        <cfelse>
                          <cfset LvarValorCreditos  = rsEstadoCuenta.ECcreditos> 
                        </cfif>  
                    </cfif>                                      
					<input type="text" name="ECcreditos" onFocus="javascript: this.select();" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(LvarValorCreditos,'none')#</cfoutput>
                    <cfelse><cfoutput>0.00</cfoutput></cfif>" 
					size="18" maxlength="18" style="text-align:right" readonly>
				</td>
			</tr>
			<tr> 
				<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				<td nowrap="nowrap"><div align="right"><strong><cfoutput>#LvarLblSaldoFinal#</cfoutput>:&nbsp;</strong></div></td>
				<td align="left">
                	<cfif modo neq 'ALTA'>
						<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1'>
                           <cfset LvarImporte = rsEstadoCuenta.ECsaldofin>
                        <cfelse>
                          <cfset LvarImporte  = rsEstadoCuenta.ECsaldofin> 
                        </cfif>
                    </cfif>        
					<input type="text" name="ECsaldofin" class="cajasinborde" readonly tabindex="-1"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(LvarImporte,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" 
						size="18" maxlength="18" style="text-align:right">
					<input type="hidden" name="ECid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.ECid#</cfoutput></cfif>"> 
					<input type="hidden" name="CBid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.CBid#</cfoutput></cfif>"> 
					<input type="hidden" name="monedaLocal" value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>"> 
					<input type="hidden" name="ECusuario" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#rsEstadoCuenta.ECusuario#</cfoutput></cfif>"> 
					<cfset tsE = ""> 
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsEstadoCuenta.ts_rversion#" 
						returnvariable="tsE">
						</cfinvoke>
					</cfif>
					<input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>"> 
					<input type="hidden" name="ECfecha" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSDateFormat(rsEstadoCuenta.ECfecha,'DD/MM/YYYY')#</cfoutput></cfif>"> 
					<input type="hidden" name="Mcodigo" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.Mcodigo#</cfoutput></cfif>"> 
					<input type="hidden" name="ECtipocambio" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#rsDescripciones.TipoCambio#</cfoutput></cfif>"> 
					<input type="hidden" name="_Bid" value=""> <input type="hidden" name="_CBid" value="">	
					<input type="hidden" name="_ECdescripcion" value=""> <input type="hidden" name="_ECdesde" value=""> 
					<input type="hidden" name="_EChasta" value=""> <input type="hidden" name="_ECsaldoini" value=""> 
					<input type="hidden" name="_ECsaldofin" value=""> 
				</td>
			</tr>
			<tr> 
				<td colspan="6"> <div align="center"></div>
					<cfif modo EQ "ALTA">
						<div align="center"> 
						<input name="AgregarE" tabindex="1" type="submit" value="Agregar" onClick="javascript: return valida();">
						<input type="button" name="Regresar" tabindex="1" value="Regresar" onClick="javascript: Lista();">
						</div>
					</cfif> 
				</td>
			</tr>
		</table>
		<cfif modo NEQ "ALTA">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr><td colspan="5" class="tituloAlterno"><div align="center">Detalle del Documento</div></td></tr>
				<tr> 
					<td><div align="left"><strong>Tipo de Transacci&oacute;n:</strong></div></td>
					<td><div align="left"><strong>Documento:</strong></div></td>
					<td><div align="left"><strong>Referencia:</strong></div></td>
					<td><div align="left"><strong>Fecha:</strong></div></td>
					<td><div align="left"><strong>Monto</strong></div></td>
				</tr>
				<tr> 
					<td> 
						<cf_sifMBTransaccionesBancos id="bid2" tabindex="2" Banco = #form.Bid# BTEtce=#LvarCBesTCE#>
                        <cfif modoDet NEQ "ALTA">
                        	<script language="JavaScript" type="text/javascript">
								<!---Se usa iframe que que se define en sifMBTransaccionesBancos--->
								TraeMBTransaccionesBancos();
								<cfoutput>
									function TraeMBTransaccionesBancos() {
										var params ="";
										params = "&tipo=BTEtipo&BTEtce=#LvarCBesTCE#&Banco=#rsLinea.Bid#&id=bid2&name=BTEcodigo&desc=BTEdescripcion&conexion=#session.dsn#&empresa=#session.Ecodigo#";
										var fr = document.getElementById("frMBTransaccionesBancos");
										fr.src = "/cfmx/sif/Utiles/sifMBTransaccionesBancosquery.cfm?dato=#rsLinea.BTEcodigo#&form="+"form1"+params;
									}
								</cfoutput>
							</script>
                        </cfif>
					</td>
					<td>
						<input name="Documento" tabindex="2" type="text" onFocus="javascript: this.select();" 
							value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Documento#</cfoutput></cfif>" size="20" maxlength="20">		
					</td>
					<td>
						<input name="DCReferencia" type="text" tabindex="2" onFocus="javascript: this.select();" 
						value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DCReferencia#</cfoutput></cfif>" size="25" maxlength="25">
					</td><!--- --->
					<td nowrap>
						<cfoutput>
							<cfif modoDet EQ 'CAMBIO'>
								<cfset fechadet = "#LSDateFormat(rsLinea.DCfecha,'DD/MM/YYYY')#">
							<cfelse>
								<cfset fechadet = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
							</cfif>
							<cf_sifcalendario tabindex="2" Conexion="#session.DSN#" form="form1" name="DCfecha" value="#fechadet#" onBlur="ValidaFechas();">
						</cfoutput>										
					</td>
					<td>
						<input name="DCmontoori"  tabindex="2" type="text" onBlur="javascript:formatear();" onFocus="javascript: this.select();" 
						style="text-align:right" size="20" maxlength="20" 
						value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DCmontoori,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"> 
					</td>

				</tr>
				<tr> 
					
					
					<td><div align="right"><!--- Tipo de Cambio: ---></div></td>
					<td><!--- <input name="DCtipocambio" type="text" style="text-align:right" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSNumberFormat(rsLinea.DCtipocambio,',9.0000')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="12" maxlength="12"> ---> 
						<input name="DCtipocambio" type="hidden"  
						value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DCtipocambio#</cfoutput><cfelse><cfoutput>1.0000</cfoutput></cfif>">
						<cfset tsD = ""> 
						<cfif modoDet NEQ "ALTA">
							<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsLinea.ts_rversion#" 
								returnvariable="tsD">
							</cfinvoke>
						</cfif> 
						<input type="hidden" name="timestampD" value="<cfoutput>#tsD#</cfoutput>"> 
                        <input type="hidden" name="Linea" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Linea#</cfoutput></cfif>"> 
						<input type="hidden" name="DCmontoloc" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DCmontoloc,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"> 
						<input type="hidden" name="DCtipo" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DCtipo#</cfoutput></cfif>"> 
				</td>
			</tr>
			<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
			<tr> 
				<td colspan="4">
					<div align="center"> 
						<cfif modoDet EQ "ALTA">
						
						<cfif IsDefined('LvarTCEFormStadosCuenta')> 
 							<cfif  #rsEstadoCuenta.ECStatus# eq 0 and #rsEstadoCuenta.CBPTCestatus# EQ "Sin pago registrado">			
									<!---Verificar estado de la bandera revisado--->
								<input name="AgregarD" type="submit" value="Agregar" tabindex="3"  
									onclick="javascript: document.form1.DCtipocambio.disabled = false; if (valida()) {return true;} else {document.form1.DCtipocambio.disabled = true; return false;}">
 							</cfif>
						<cfelse>
								<input name="AgregarD" type="submit" value="Agregar" tabindex="3"  
									onclick="javascript: document.form1.DCtipocambio.disabled = false; if (valida()) {return true;} else {document.form1.DCtipocambio.disabled = true; return false;}">
						</cfif>
													
						<cfelse>
							<input name="CambiarD" type="submit" value="Cambiar" tabindex="3"
							onClick="javascript: document.form1.DCtipocambio.disabled = false; if (valida()) return true; else {document.form1.DCtipocambio.disabled = true; return false;}">
							<input name="BorrarD" type="submit" value="Borrar Linea" tabindex="3"
								onclick="javascript:if (confirm('¿Desea borrar esta línea del documento?')) return true; else return false;">
							<input name="NuevoD" type="submit" value="Nueva Línea" tabindex="3">
 						</cfif>
						
						<cfif not IsDefined('LvarTCEFormStadosCuenta')>							
							<input name="NuevoE" type="submit" value="Nuevo Documento" tabindex="3"
									onclick="javascript: fnNoValidar(); funcNuevo();">
 						 </cfif>
						 
						 <!--- Boton para actualizar encabezado Cambio JCRUZ--->
						<cfif not isdefined("LvarTCEFormStadosCuenta") and not IsDefined('LvarIrConciliacion')>
							<input name="UpdateE" type="button" value="Actualizar Documento" onClick="javascript:updateEncabezado();">
						</cfif>
						<cfif IsDefined('LvarTCEFormStadosCuenta')>
							<cfif #rsEstadoCuenta.ECStatus# eq 0 and #rsEstadoCuenta.CBPTCestatus# EQ "Sin pago registrado">
								 <cfif IsDefined("rsStatusBorrarDoc")> 
									<cfif #rsStatusBorrarDoc.Total# eq 0>
										<input name="BorrarE" type="submit" value="Borrar Documento" tabindex="3"
											onclick="javascript: fnNoValidar();  if (confirm('¿Desea borrar este documento?')) return true; else return false;">
									</cfif>
								</cfif>	
							</cfif>
						<cfelse>
								<input name="BorrarE" type="submit" value="Borrar Documento" tabindex="3"
									onclick="javascript: fnNoValidar();  if (confirm('¿Desea borrar este documento?')) return true; else return false;">
						</cfif>	
						
							<input name="ListaE" type="button" value="Regresar" onClick="javascript:Lista();" tabindex="3">

						<!---====================IMPORTADOR INHABILITADO===============================--->
						
						<cfif not isDefined('LvarTCEFormStadosCuenta')>
								<input name="Importar" type="button" value="Importar" tabindex="3"
								onClick="javascript:ImportarDatos();">
 						 </cfif>
												
						<input name="Imprimir" type="button" value="Imprimir" onClick="javascript:ImprimeReporte();" tabindex="3">
  				  		 
						 <cfif IsDefined('LvarTCEFormStadosCuenta') and #rsEstadoCuenta.ECStatus# neq 1>
						 	<cfif rsVerificaLineas.recordcount  neq 0>
								<!---Boton Cambio de Estatus--->
								<input name="Status" type="submit" value="Revisado" tabindex="3" onclick="javascript: fnNoValidar(); document.form1.Status.Style.visibility = 'false';">
 						 	</cfif>
						 </cfif>
				  </div>
				</td>
			</tr>
		</table>
		
	</cfif>  
</form>

<script language="JavaScript1.2">
// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */



	AsignarHiddensEncab();	
	<cfif modo NEQ "ALTA">
		sugerirTipoCambio();
		document.form1.BTEcodigo.focus();
		//cargarTipo(document.form1.BTid.value);
		funcBTEcodigo();
	<cfelse>
		//document.form1.ECsaldoini.focus();
		document.form1.Bid.focus();
		document.getElementById("MonedaLabel").style.visibility = "hidden";
	</cfif>
	// ============================================================================		
	// Llama a la pantalla del reporte
	function ImprimeReporte(){ 
			//var PARAM  = "../Reportes/RH_infCalificaciones.cfm?DEid=#rsDEid.DEid#&RHCconcurso=#form.RHCconcurso#"; 
			<cfoutput>
			<!---Redireccion RPRegistroEstadosCtas.cfm o RPRegistroEstadosCtasTCE.cfm--->
			var PARAM  = "../Reportes/<cfoutput>#LvarIrARPRegistroEstadosCuenta#</cfoutput>?ECid=<cfif isdefined('ECid')>#ECid#</cfif>"; 
			open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=yes,width=800,height=600');
				return false;
	
			</cfoutput>
		}
	// ============================================================================		
	//Llama a la pantalla de importacion de datos#archivo#
	function ImportarDatos(){
		<!---Redireccion ImportarECarchivo.cfm o ImportarECarchivoTCE.cfm--->
		document.form1.action = '<cfoutput>#LvarIrAImportarArchivo#</cfoutput>';
		document.form1.submit();
	}

	// ============================================================================		
	//Validacion de los campos con qforms
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;


	function _Field_isRango(low, high){
	if (_allowSubmitOnError!=true){
	var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseInt(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
	}}}
	_addValidator("isRango", _Field_isRango);
	
	/*objForm.Bid.required = true;
	objForm.Bid.description = "Banco";*/
	<cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta eq '1' and modo eq 'ALTA'>
	    objForm.Id.required = true;
     	objForm.Id.description = "Tarjeta de Crédito";
	 <cfelseif  isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta neq '1' and modo eq 'ALTA'>
	 	objForm.CBid.required = true;
     	objForm.CBid.description = "Cuenta";
		objForm.ECdesde.required = true;
    	objForm.ECdesde.description = "Fecha desde";
	</cfif>
	
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha hasta";	

	//objForm.ECsaldoini.required = true;
	//objForm.ECsaldoini.description = "Saldo inicial";
	//objForm.ECsaldoini.validateRango('0','999999999999999999.99');

	<cfif modoDet EQ "ALTA">
	/*objForm.BTid.required = true;
	objForm.BTid.description = "Tipo de Transacción";*/
	objForm.BTEtipo.required = true;
	objForm.BTEtipo.description = "Tipo de Transacción del Banco";
	objForm.DCfecha.required = true;
	objForm.DCfecha.description = "Fecha";
	objForm.Documento.required = true;
	objForm.Documento.description = "Documento";

	objForm.DCmontoori.required = true;
	objForm.DCmontoori.description = "Monto orígen";
	objForm.DCmontoori.validateRango('0.00','999999999999999999.99');

	objForm.DCtipocambio.required = true;
	objForm.DCtipocambio.description = "Tipo de Cambio";
	objForm.DCtipocambio.validateRango('0.01','999999999999999999.99');
	</cfif>

	function fnNoValidar() {
		objForm.Bid.required = false;
		objForm.CBid.required = false;
		 <cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta neq '1' and modo eq 'ALTA'>
    		 objForm.ECdesde.required = false;
		 </cfif>
		objForm.EChasta.required = false;
		objForm.ECsaldoini.required = false;
    	objForm.Documento.required = false;
		objForm.BTEtipo.required = false;
		<cfif modo NEQ "ALTA">
		/*objForm.BTid.required = false;*/
		objForm.DCfecha.required = false;	
		objForm.DCmontoori.required = false;
		objForm.DCtipocambio.required = false;
		</cfif>
		document.form1.onsubmit=" ";
	}
	function ValidaFechas(){
		 <cfif isdefined('LvarTCEFormStadosCuenta') and LvarTCEFormStadosCuenta neq '1'>
		if (! (toFecha(document.form1.DCfecha.value) >= toFecha(document.form1.ECdesde.value) && toFecha(document.form1.DCfecha.value) <= toFecha(document.form1.EChasta.value)) )
		{
			alert("La Fecha del detalle debe ser una fecha dentro del rango de fechas del encabezado");
			return false;
		}
		else {
			return true;
		} 
		<cfelse>
		   return true;
		</cfif>
		
	}
	
	function ValidaFechasE(){
	/*alert(ValidaFechaHasta());
	alert(document.form1.LvarHoy.value +'Lvar hoy');
	alert(toFecha(document.form1.EChasta.value) > toFecha(document.form1.LvarHoy.value));*/
	//if (ValidaFechaHasta()){
		if ((toFecha(document.form1.ECdesde.value) > toFecha(document.form1.EChasta.value))){
			alert("La Fecha desde debe ser menor o igual a la fecha hasta");
			return false;
		}
		else {
			return true;
		}
	/*	}
	
	else{
		return false;
	}*/
	}
	function ValidaFechaHasta(){
		if ((toFecha(document.form1.EChasta.value) > toFecha(document.form1.LvarHoy.value))){
			alert("La Fecha Hasta debe ser menor o igual a " + document.form1.LvarHoy.value);
			return false;
		}
		else {
			return true;
		}
	}
	
	function funcNuevo(){
 		<!---Redireccion EstadosCuenta.cfm o TCEEstadosCuenta.cfm (TCE)--->
 		document.form1.action="<cfoutput>#LvarIrAEstadosCuenta#</cfoutput>";
	}
</script>  

