<cfif isdefined('url.IDoperacion') and LEN(TRIM(url.IDoperacion))> 
	<cfset form.IDoperacion = url.IDoperacion>
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Limpia los valores para cuando el registro es nuevo. --->
<cfif isDefined("form.btnNuevo")>
	<cfif form.btnNuevo EQ "Nuevo">
    	<cfset form.IDoperacion  = "">
        <cfset form.Transaccion  = "">
        <cfset form.OrigenCont   = "">
        <cfset form.Descripcion  = "">
	</cfif>
</cfif>

<cfif isdefined("form.IDoperacion") and len(trim(form.IDoperacion))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

 
<cfquery name="rsDetEvento" datasource="#Session.DSN#">


</cfquery>


<!---   
<cfif (isdefined('Form.CodEvento') and LEN(trim(Form.CodEvento)) and modo EQ 'ALTA')>
	<cfquery datasource="#session.dsn#" name="direcciones">
		select 
			b.id_direccion, 
		 	<cf_dbfunction name="concat" args="c.direccion1,' / ',c.direccion2"> as texto_direccion
			,case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select rtrim(CFformato)
						from CFinanciera
						where Ccuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFformato
			, case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(CFdescripcion)
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select CFdescripcion
						from CFinanciera
						where Ccuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFdescripcion
			, case when b.SNDCFcuentaProveedor is null
				then
					a.SNcuentacxp
				else
					b.SNDCFcuentaProveedor
				end 
			as Ccuenta
		
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = #Session.Ecodigo# 
		<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
			and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
		</cfif>
		<cfif isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))>
			and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
		</cfif>
		  and b.SNDfacturacion = 1
	
	</cfquery>
<cfelse>

</cfif>
--->
	
<!---<cfif isdefined("rsSociosN") and rsSociosN.recordcount EQ 1 and rsSociosN.SNcuentacxp EQ ''>
	<cf_errorCode	code = "50183" msg = "La cuenta para el Socio de Negocios debe ser definida.">
</cfif>
--->
<!---Formulado por en parametros generales--->
<!---<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->
---> 
  <!---Variables para hacer visibles o no los campos cuando esta definido el plan de compras--->
<!---	  <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom> 
			<cfset LvarPlanDeCompras=true>
			<cfset LvarPlanDeCompras2="yes">
	  <cfelse>
			<cfset LvarPlanDeCompras=false>
			<cfset LvarPlanDeCompras2="no">
	  </cfif>

<cfset LvarItemReadonly = false>
--->

<cfif modo NEQ "ALTA">
<!---	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select Aid, Bdescripcion 
		from Almacen 
		where Ecodigo = #Session.Ecodigo#
		order by Bdescripcion                                                                   
	</cfquery>

	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = #Session.Ecodigo#
		order by Ddescripcion
	</cfquery>
--->
	<cfquery name="rsEventoDet" datasource="#Session.DSN#">
<!---		select 	IDdocumento, 
				d.CPTcodigo, TESRPTCid,
				EDdocumento, SNcodigo, 
				Mcodigo, 
				EDtipocambio, Icodigo, EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, EDfecha,
				Ocodigo, Ccuenta, id_direccion, Rcodigo, EDdocref, EDfechaarribo, 
                coalesce(
                    (
                        select sum(DDtotallinea)
                          from DDocumentosCxP
                         where IDdocumento = d.IDdocumento
                    )
                ,0) as Subtotal,
				d.ts_rversion,
				folio,
                d.EDvencimiento,
                d.EDAdquirir,
				d.EDexterno
		from EDocumentosCxP d
		where d.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
--->	
	</cfquery>
	
</cfif>

<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>

<!---
<script language="JavaScript1.2">
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisReferencias() {
		if (document.form1.SNcodigo.value != "" )
			popUpWindow("ConlisReferencias.cfm?form=form1&docref=EDdocref&ref=Referencia&ref1=Referencia1&SNcodigo="+document.form1.SNcodigo.value,250,200,650,350);
		else
			alert("Debe seleccionar un Proveedor");
	}
	
	function limpiarRef() {
		document.form1.EDdocref.value = "";
		document.form1.Referencia.value = "";
		document.form1.Referencia1.value = "";		
	}
	function funcImprimir(){
     	
		var indice =document.form1.indice.value;
			
		window.open('facturaTramite.cfm?lista='+indice, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');
		
	}
	
	function funcImprimirFactura(){
		popUpWindow('ImprimeFactura.cfm?id=<cfoutput>#IDdocumento#</cfoutput>',100,100,700,600);
		
	}
	//FUNCION PARA DEPLEGAR EL POP-UP DE ARTICULOS DE IVENTARIO Y CONCEPTOS DE SERVICIO
	function doConlisItem() {
		if (document.form1.DDtipo.value == "A")
			popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=descripcion&Alm="+document.form1.Almacen.value,250,200,650,350);		
		if (document.form1.DDtipo.value == "S")
			popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=descripcion&depto="+document.form1.Dcodigo.value,250,200,650,350);
	}
	//FUNCION PARA REGRESAR A LA LISTA
	function Lista() {
		var params  = '?pageNum_lista='+document.form1.pageNum_lista.value;
			params += (document.form1.fecha.value != '') ? 			"&fecha="       + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != '') ? 	"&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.documento.value != '') ? 		"&documento="   + document.form1.documento.value : '';			
			params += (document.form1.usuario.value != '') ?   		"&usuario="     + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != '') ?    		"&moneda="      + document.form1.moneda.value : '';
			params += (document.form1.registros.value != '') ? 		"&registros="   + document.form1.registros.value : '';
			params += (document.form1.tipo.value != '') ? 			"&tipo=" 	    + document.form1.tipo.value : '';
			location.href="<cfoutput>#URLira#</cfoutput>"+params;
	}
	//elimina el formato numerico de una hilera, retorna la hilera
	function qf(Obj)
	{
		var VALOR=""
		var HILERA=""
		var CARACTER=""
		if(Obj.name)
		  VALOR=Obj.value
		else
		  VALOR=Obj
		for (var i=0; i<VALOR.length; i++) {	
			CARACTER =VALOR.substring(i,i+1);
			if (CARACTER=="," || CARACTER==" ") {
				CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
			}  
			HILERA+=CARACTER;
		}
		return HILERA
	}

	//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
	function ESNUMERO(aVALOR)
	{
		var NUMEROS="0123456789."
		var CARACTER=""
		var CONT=0
		var PUNTO="."
		var VALOR = aVALOR.toString();
		
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (NUMEROS.indexOf(CARACTER)<0) {
				return false;
				} 
			}
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (PUNTO.indexOf(CARACTER)>-1)
				{CONT=CONT+1;} 
			}
		
		if (CONT>1) {
			return false;
		}
		
		return true;
	}

	function validaNumero(dato) {
		if (dato.length > 0) {
			if (ESNUMERO(dato)) {
				return true;
			}		
			else {
				alert('El monto digitado debe ser numérico.');			
				return false;
			}
		}
		else {
			alert('El monto digitado debe ser numérico.');
			return false;	
		}
	}
	//FUNCION PARA OBTENER EL TIPO DE CAMBIO
	function getTipoCambio(formulario) {
		var frameE = document.getElementById("frameExec");
		frameE.src = "obtenerTipocambioDocumentosCP.cfm?form=" + formulario.name + "&EDfecha=" + formulario.EDfecha.value + "&Mcodigo=" + formulario.Mcodigo.value;
	}

	function setTipoCambio(formulario, valor) {
		formulario.EDtipocambio.value = fm(valor, 4);
	}
	
	function obtenerTC(f) {
		if (f.Mcodigo.value == f.monedalocal.value) { 
			f.EDtipocambio.value = "1.0000";
			f.EDtipocambio.disabled = true;
		} 
		else if (document.form1.haydetalle.value == "NO") { 
			getTipoCambio(f);
			validatc(f);
		}
	}

	function valida() {
		if (!validaE()) 
			return false;
		<cfif modo NEQ "ALTA"> return validaD(); </cfif>
		return true;
	}

	function validaE() {
		document.form1.EDtotal.value = qf(document.form1.EDtotal.value);		
		document.form1.EDdescuento.value = qf(document.form1.EDdescuento.value);		
		document.form1.EDimpuesto.value = qf(document.form1.EDimpuesto.value); 
		if (datediff(document.form1.EDfecha.value, document.form1.EDfechaarribo.value) < 0) 
			{	
				alert ('La fecha de arribo debe ser mayor a la fecha del documento');
				return false;
			} 
		return true;
	}

	function validatc()
	{   	
		document.form1.EDtipocambio.disabled = false;		
		if (document.form1.Mcodigo.value == document.form1.monedalocal.value){						
			document.form1.EDtipocambio.value = "1.0000";
			document.form1.EDtipocambio.disabled = true;          			
		} 
		else{
			<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
			//Verificar si existe en el recordset
			var nRows = rsTCsug.getRowCount();
			if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
					if (rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value 
						&& rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value) {
						document.form1.EDtipocambio.value =fm( rsTCsug.getField(row, "TCventa"),4);
						row = nRows;
					}
					else
						document.form1.EDtipocambio.value = "0.00";					
				}									
			}
			else 
				document.form1.EDtipocambio.value = "0.00";			
		}		
	}
	

	function poneItem() {
		if (document.form1.DDtipo.value == "A"){ 
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById("labelconcepto").style.display = 'none';
		}
		if (document.form1.DDtipo.value == "T"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
		}		
		
		if (document.form1.DDtipo.value == "S"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = '';
		}

		if (document.form1.DDtipo.value == "F"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
		}

	}
	
	function validatcLOAD()
	{                      		  
		  <cfif modo EQ "ALTA">
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)	{
					document.form1.EDtipocambio.value = "1.00";                                
					document.form1.EDtipocambio.disabled = true;
				}  
				else {
					document.form1.Mcodigo.value=document.form1.monedalocal.value;
					document.form1.EDtipocambio.value = "1.00";
					document.form1.EDtipocambio.disabled = true;                    
				} 
		   <cfelse>
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)
					document.form1.EDtipocambio.disabled = true;
				else
					document.form1.EDtipocambio.disabled = false;
		   </cfif>   

	}   
	
	function validatcLOAD(f) {
		if (document.form1.haydetalle.value == "SI") {
			document.form1.EDtipocambio.disabled = true
		} else {
			if (document.form1.Mcodigo != null && document.form1.Mcodigo.value == document.form1.monedalocal.value) {
				document.form1.EDtipocambio.value = "1.0000"
				document.form1.EDtipocambio.disabled = true
			}
		}
		document.form1.EDtipocambio.value = fm(document.form1.EDtipocambio.value, 4);
	}

	function initPage(f) {
		validatcLOAD(f);
		<cfif modo NEQ "CAMBIO">
		obtenerTC(f);
		</cfif>
	}


	function suma()
	{               		
		if (document.form1.DDpreciou.value=="" ) document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
		if (document.form1.DDdesclinea.value=="")document.form1.DDdesclinea.value = "0.00";
		if (document.form1.DDcantidad.value=="" )document.form1.DDcantidad.value = "0.00";
		
		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			document.form1.DDtotallinea.value = "0.00";
		}    		
		
		if (document.form1.DDdesclinea.value=="-"){    
			document.form1.DDdesclinea.value = "0.00" 
			document.form1.DDtotallinea.value = "0.00"
		}		
		/*
		if (document.form1.DDcantidad.value=="-" ){
			document.form1.DDcantidad.value = "0.00"
			document.form1.DDtotallinea.value = "0.00"
		} */ 
				
		var cantidad = new Number(qf(document.form1.DDcantidad.value))
		if(cantidad == 0)
			cantidad = 1;
			
		var precio = new Number(qf(document.form1.DDpreciou.value))
		var descuento = new Number(qf(document.form1.DDdesclinea.value))		
		var seguir = "si"
		
		if(cantidad < 0){
			document.form1.DDcantidad.value="0.00"
			seguir = "no"
		}  
		
		if(precio < 0){
			document.form1.DDpreciou.value="<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			seguir = "no"
		} 
		
		if(descuento < 0){
			document.form1.DDdesclinea.value="0.00"
			seguir = "no"
		}
		
		if(descuento > cantidad*precio){        
			document.form1.DDdesclinea.value="0.00"
			document.form1.DDtotallinea.value = cantidad * precio
		}
		else {        
			document.form1.DDtotallinea.value = redondear((cantidad * precio) - descuento,2)
			document.form1.DDtotallinea.value = fm(document.form1.DDtotallinea.value,2)			
		}                                  
	}
	
	function fnValidarMontos(){
		if (document.form1.DDpreciou.value=="" )
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
		if (document.form1.DDdesclinea.value=="")
			document.form1.DDdesclinea.value = "0.00";
		if (document.form1.DDcantidad.value=="" )
			document.form1.DDcantidad.value = "0.00";
		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			document.form1.DDtotallinea.value = "0.00";
		}    		
		if (document.form1.DDdesclinea.value=="-"){    
			document.form1.DDdesclinea.value = "0.00" 
			document.form1.DDtotallinea.value = "0.00"
		}			
		var cantidad = new Number(qf(document.form1.DDcantidad.value))
		if(cantidad < 1){
			cantidad = 1;
			document.form1.DDcantidad.value = "1.00";
		}
		var precio = new Number(qf(document.form1.DDpreciou.value))
		var descuento = new Number(qf(document.form1.DDdesclinea.value))		
		var seguir = "si";
		
		if(precio < 0){
			document.form1.DDpreciou.value="<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			seguir = "no"
		} 
		
		if(descuento < 0){
			document.form1.DDdesclinea.value="0.00";
			seguir = "no"
		}
		var subtotal = new Number(qf(document.form1.DDtotallinea.value));
		if(cantidad > 0){
			document.form1.DDpreciou.value = fm(redondear((subtotal - descuento) / cantidad,4),4,true,false,'');
		}else{
			document.form1.DDpreciou.value = fm(0,4,true,false,'');
			fm(document.form1.DDtotallinea,4,true,false,'');
		}
	}
	
	function limpiarDetalle() {
		document.form1.OCTid.value="";
		document.form1.OCTtransporte.value="";
		document.form1.OCid.value="";
		document.form1.OCcontrato.value="";
		document.form1.Acodigo.value="";
		document.form1.Adescripcion.value="";
		document.form1.Ccodigo.value="";
		document.form1.Cdescripcion.value="";
		<cfif isdefined("rsModDet.Pvalor") and rsModDet.Pvalor Neq 1>
			document.form1.DDdescalterna.value="";   
			document.form1.DDdescripcion.value="";                       
		</cfif>
		document.form1.Aid.value="";
		document.form1.Cid.value="";			
		if (document.form1.CcuentaD) document.form1.CcuentaD.value = "";
		if (document.form1.CmayorD) 
		{
			document.form1.CmayorD.value = "";
			document.form1.CformatoD.value = "";
			document.form1.CdescripcionD.value = "";
		}
	}
	
	function cambiarDetalle(){	
	
		if(document.form1.DDtipo.value=="T"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = '';
		
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';
		
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			document.getElementById('articuloOD').style.display     = 'none';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articulo').style.display = 'none';


			document.getElementById("AlmacenLabel").style.display 	= '';
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById('articuloT').style.display = '';
			
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';

			document.getElementById("TRCUENTADET").style.display = '';
			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
		if(document.form1.DDtipo.value=="O"){
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = '';
			document.getElementById("ConceptoT").style.display = '';

			
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("AlmacenImput").style.display 	= 'none';
			document.getElementById("AlmacenLabel").style.display 	= "none";
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('articulo').style.display = 'none';
			document.getElementById('articuloT').style.display = 'none';


			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articuloOD').style.display     = '';
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';
			document.getElementById('OrdenLabel').style.display 	= '';
			document.getElementById('OrdenImput').style.display 	= '';
			
			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
		if(document.form1.DDtipo.value=="A"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= 'none';
			document.getElementById('TransporteImput').style.display 	= 'none';
			document.getElementById('OrdenLabel').style.display 		= 'none';
			document.getElementById('OrdenImput').style.display 		= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display 			= 'none';
			document.getElementById("centrofuncional").style.display 	= 'none';
			document.getElementById("labelconcepto").style.display 		= 'none';
			document.getElementById('concepto').style.display 			= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			
			document.getElementById("AlmacenLabel").style.display 	= '';
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articulo').style.display = '';
			document.getElementById('articuloOD').style.display         = 'none';

			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		} 

		if(document.form1.DDtipo.value=="S"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= 'none';
			document.getElementById('TransporteImput').style.display 	= 'none';
			document.getElementById('OrdenLabel').style.display 		= 'none';
			document.getElementById('OrdenImput').style.display 		= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articulo').style.display 			= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			document.getElementById("EspecificaCuentaLabel").style.display = '';
			document.getElementById("EspecificaCuenta").style.display = '';
			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			<cfif LvarComplementoXorigen>
			CcuentaD_disabled(true);
			<cfelse>
			CcuentaD_disabled(!document.form1.chkEspecificarcuenta.checked);
			</cfif>
			
		}   
		if(document.form1.DDtipo.value=="P"){
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= '';
			document.getElementById('TransporteImput').style.display 	= '';
			document.getElementById('OrdenLabel').style.display 		= '';
			document.getElementById('OrdenImput').style.display 		= '';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articulo').style.display 			= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
			CcuentaD_disabled(false);
		}                  
	  
	    if(document.form1.DDtipo.value=="F") {
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById('articuloT').style.display = 'none';
			document.getElementById('TransporteLabel').style.display = 'none';
			document.getElementById('TransporteImput').style.display = 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
			document.getElementById('articulo').style.display = 'none';
			document.getElementById('concepto').style.display = 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.form1.Aid.value="";
			document.form1.Cid.value="";
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			 
			<cfif mododet EQ "ALTA">
			
				if(document.form1.LvarPlanDeCompras.value != "true")
				{
					if (document.form1.CcuentaD)
					{
						document.form1.CFcuentaD.value = "";
						document.form1.CcuentaD.value = "<cfoutput>#rsCuentaActivo.Ccuenta#</cfoutput>";
						document.form1.CdescripcionD.value = "<cfoutput>#rsCuentaActivo.Cdescripcion#</cfoutput>";
					}
					<cfif len(rsCuentaActivo.Cformato) GTE 5>
						if (document.form1.CmayorD) 
						{
							document.form1.CmayorD.value = "<cfoutput>#mid(rsCuentaActivo.Cformato,1,4)#</cfoutput>";
							document.form1.CformatoD.value = "<cfoutput>#trim(mid(rsCuentaActivo.Cformato,6,len(rsCuentaActivo.Cformato)))#</cfoutput>";
						}
					<cfelse>
						if (document.form1.CmayorD) 
						{
							document.form1.CmayorD.value = "<cfoutput>#rsCuentaActivo.Cformato#</cfoutput>";
							document.form1.CformatoD.value = "";
						}
					</cfif>
				}
			</cfif>
			
			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
	}   
	
	function limpiarAxCombo(){   
	   document.form1.Aid.value =""
	   //document.form1.descripcion.value=""
	   document.form1.Aid.value=""
	   document.form1.Acodigo.value=""
	   document.form1.Adescripcion.value=""
	   document.form1.DDdescripcion.value=document.form1.Adescripcion.value
	   
		if (document.form1.CcuentaD)document.form1.CcuentaD.value = '';
		if (document.form1.CmayorD) 
		{
			document.form1.CmayorD.value = '';
			document.form1.CformatoD.value = '';
			document.form1.CdescripcionD.value = '';
		}
	}

	function validaD() {
		if (document.form1.DDtipo.value=="A")
		{
			
			if (document.form1.Almacen.value == "")  { 
				alert ("Debe digitar el Almacen")            
				return false;
			}
			if (document.form1.Aid.value == "")  { 
				alert ("Debe digitar el artículo")            
				return false;
			}
		}
		
		if (document.form1.DDtipo.value=="T")
		{
			
			if (document.form1.Almacen.value == "")  { 
				alert ("Debe digitar el Almacen")            
				return false;
			}
		}
		
		if (document.form1.DDtipo.value=="S")
		{			   
		   	if (document.form1.Cid.value == "")  { 
				alert ("Debe digitar el concepto")            
				return false;
			}
			if (document.form1.CFid.value == ""){
				alert ("Debe digitar el Centro Funcional")            
				return false;
			}	
			   
		}
		if (document.form1.CPTcodigo.value=="--")
		{
				alert ("Debe seleccionar un tipo de Transacción")            
				return false;
		}
		var a  = new Number(qf(document.form1.DDtotallinea.value)) 
			 var b  = new Number(qf(document.form1.DDdesclinea.value))
			 var c  = a + b
			 var porcdesc  = b * 100
			 
			 if(b!=0)
				porcdesc  = porcdesc/c
			 else 
				porcdesc = 0
						 										 
			document.form1.DDporcdesclin.value =  porcdesc																																	 
			document.form1.DDporcdesclin.value = qf(document.form1.DDporcdesclin.value)
			document.form1.DDcantidad.value =  qf(document.form1.DDcantidad.value)	
			document.form1.DDpreciou.value =  qf(document.form1.DDpreciou.value)	
 		 	document.form1.DDdesclinea.value =  qf(document.form1.DDdesclinea.value)	
			document.form1.DDtotallinea.value =  qf(document.form1.DDtotallinea.value)
			document.form1.DDtipo.disabled = false;
			document.form1.Icodigo.disabled = false;
		
		objForm.OC_SNid.required = false;
		objForm.OCid.required = false;
		objForm.OCTtransporte.required = false;
		objForm.OCTid.required = false;

		objForm.Aid.required = false;
		objForm.AidT.required = false;
		objForm.AidOD.required = false;
		
		if (document.form1.DDtipo.value=="T" || document.form1.DDtipo.value=="O"){
			objForm.CcuentaD.required = true;
			if (document.form1.DDtipo.value=="T"){
				objForm.OCTtransporte.required = true;
 				objForm.AidT.required = true; 
			}
			if (document.form1.DDtipo.value=="O"){
				objForm.OCid.required = true;
				objForm.OCTid.required = true;
				objForm.AidOD.required = true;
				objForm.OC_SNid.required = true;
				
				if (document.form1.OCCid.options[document.form1.OCCid.selectedIndex].text.substring(0,2) == "00" &&
					document.form1.OC_SNid.value != "<cfoutput>#LvarSNid#</cfoutput>")
				{
					alert("Cuando el Concepto de Compra es '00-PRODUCTO TRANSITO', la Orden Comercial debe pertenecer al Proveedor");
					return false;
				}
				else if (document.form1.OCCid.options[document.form1.OCCid.selectedIndex].text.substring(0,3) != "00-" && 
						 qf(document.form1.DDcantidad.value) != "0.00")
				{
					alert("No se puede indicar cantidad cuando el Concepto de Compra no es '00-PRODUCTO TRANSITO'");
					return false;
				}
			}
		}
		return true;	
	}

	function AsignarHiddensEncab() {
		var estado = document.form1.EDtipocambio.disabled;
		document.form1._EDfecha.value 		 = document.form1.EDfecha.value;	
		document.form1._EDvencimiento.value  = document.form1.EDvencimiento.value;	
		document.form1._EDfechaarribo.value  = document.form1.EDfechaarribo.value;				
		document.form1._Mcodigo.value		 = document.form1.Mcodigo.value;		
		document.form1.EDtipocambio.disabled = false;		
		document.form1._EDtipocambio.value 	 = document.form1.EDtipocambio.value;
		document.form1.EDtipocambio.disabled = estado;		
		document.form1._Ocodigo.value 		 = document.form1.Ocodigo.value;
		document.form1._Rcodigo.value 		 = document.form1.Rcodigo.value;
		document.form1._EDdescuento.value 	 = document.form1.EDdescuento.value;
		document.form1._Ccuenta.value 		 = document.form1.Ccuenta.value;
		document.form1._EDimpuesto.value 	 = document.form1.EDimpuesto.value;
		document.form1._EDtotal.value 		 = document.form1.EDtotal.value;				
		document.form1._EDdocref.value 		 = document.form1.EDdocref.value;
		document.form1._TESRPTCid.value 	 = document.form1.TESRPTCid.value;
		document.form1._id_direccion.value 	 = document.form1.id_direccion.value;				
	}

	function Postear(){
		if (fnAplicar_TESOPFP) return fnAplicar_TESOPFP();
		if (confirm('¿Desea aplicar este documento?')) {
			document.form1.EDtipocambio.disabled = false;
			return true;
		} 
		else return false; 	
	}

//Formatea como float un valor de un campo
//Recibe como parametro el campo y la cantidad de decimales a mostrar
function fm(campo,ndec) {
   var s = "";
   if (campo.name)
     s=campo.value
   else
     s=campo

   if(s=='' && ndec>0) 
		s='0'

   var nc=""
   var s1=""
   var s2=""
   if (s != '') {
      str = new String("")
      str_temp = new String(s)
      t1 = str_temp.length
      cero_izq=true
      if (t1 > 0) {
         for(i=0;i<t1;i++) {
            c=str_temp.charAt(i)
            if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
               cero_izq=false
               str+=c
            }
         }
      }
      t1 = str.length
      p1 = str.indexOf(".")
      p2 = str.lastIndexOf(".")
      if ((p1 == p2) && t1 > 0) {
         if (p1>0)
            str+="00000000"
         else
            str+=".0000000"
         p1 = str.indexOf(".")
         s1=str.substring(0,p1)
         s2=str.substring(p1+1,p1+1+ndec)
         t1 = s1.length
         n=0
         for(i=t1-1;i>=0;i--) {
             c=s1.charAt(i)
             if (c == ".") {flag=0;nc="."+nc;n=0}
             if (c>="0" && c<="9") {
                if (n < 2) {
                   nc=c+nc
                   n++
                }
                else {
                   n=0
                   nc=c+nc
                   if (i > 0)
                      nc=","+nc
                }
             }
         }
         if (nc != "" && ndec > 0)
            nc+="."+s2
      }
      else {ok=1}
   }
   
   if(campo.name) {
	   if(ndec>0) {
		 campo.value=nc
	   } else {
		 campo.value=qf(nc)
		}
   } else {
     return nc
   }
}	
 //FUNCION PARA REFRESCAR
function funcRefrescar(){
		document.form1.action = '<cfoutput>#URLira#</cfoutput>?modo=Cambio&tipo=' + document.form1.tipo.value;
		document.form1.submit();
	}

function funcSNnumero(){ 
		document.form1.action = '<cfoutput>#URLira#</cfoutput>?tipo=' + document.form1.tipo.value;
		document.form1.submit();
	}


	function CcuentaD_disabled(x)
	{
		if (document.form1.CmayorD)
		{
			document.form1.Ecodigo_CcuentaD.disabled	= x;
			document.form1.CmayorD.disabled				= x;
			document.form1.CformatoD.disabled			= x;
			if (document.getElementById("hhref_CcuentaD"))
			document.getElementById("hhref_CcuentaD").style.visibility = x?"hidden":"visible";
		}
	}
		
	function EspeciCuenta()
	{
		if (document.form1.chkEspecificarcuenta.checked)
		{
			CcuentaD_disabled(false);
		}
		else
		{
			document.getElementById("Ecodigo_CcuentaD").options.selectedIndex = 0;
				
			CcuentaD_disabled(true);
			fnCambioCuenta();
		}
	}
	function funcCFcodigo()
	{
		if (document.form1.chkEspecificarcuenta.checked)
			return;

		fnCambioCuenta();
	}
	function funcCcodigo()
	{
		if (document.form1.chkEspecificarcuenta.checked)
			return;

		fnCambioCuenta();
	}
	
	function funcCFComplemento(){
		if (document.form1.chkEspecificarcuenta.checked)
			return;

		fnCambioCuenta();
	}
	
	function fnCambioCuenta()
	{
		fnSetCuenta("","","","");
		if (document.form1.Cid.value != '' & document.form1.CFcodigo.value != '')
		{
			
		<cfoutput>
			
			//Esto porque cuando es intercompañia cambia el ecodigo entonces para pasarlo al aplicar mascara	
			if (document.form1.Ecodigo_CcuentaD.value !=-1)
			{
				var Ecodigo =document.form1.Ecodigo_CcuentaD.value;
				document.form1.Ecodigo_CcuentaD.disabled=false;
			}
			else{	
				var Ecodigo =#session.Ecodigo#;
			}
		CFComplemento = "";
		if(document.form1.CFComplemento)
			CFComplemento = document.form1.CFComplemento.value;
		     document.getElementById("ifrGenCuenta").src= "SQLRegistroDocumentosCP.cfm?OP=GENCF&tipoItem=S&Cid=" + document.form1.Cid.value + "&SNid=#LvarSNid#&CFid=" + document.form1.CFid.value + "&Ecodigo=" + Ecodigo +"&CFComplemento=" + CFComplemento+"&TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>";
		</cfoutput>
		}
}
function fnSetCuenta(cf,c,f,d)
	{
		document.form1.CcuentaD.value=c;

		if (document.form1.CmayorD)
		{
			document.form1.CFcuentaD.value=cf;
			document.form1.CmayorD.value=f.substr(0,4);
			document.form1.CformatoD.value= f.substr(5);
			document.form1.CdescripcionD.value=d;
		}
		LvarEcodigo_CcuentaD = <cfoutput>#session.Ecodigo#</cfoutput>;
				
	}
</script>--->

<cfflush interval="128">

<form name="form1" id="form1" action="SQLDetalleEvento.cfm" method="post">

<!---	<input name="haydetalle" 		id="haydetalle" 		type="hidden" value="<cfif isdefined("rsLineas") and rsLineas.recordCount GT 0><cfoutput>SI</cfoutput><cfelse><cfoutput>NO</cfoutput></cfif>">
--->    
<!---	<input name="LvarRecurrente" 	id="LvarRecurrente"  	type="hidden" value="0">
	<input name="LvarPlanDeCompras" id="LvarPlanDeCompras"  type="hidden" value="<cfoutput>#LvarPlanDeCompras#</cfoutput>">
    <input name="SNvencompras" 		id="SNvencompras"  		type="hidden" value="<cfoutput>#LvarSNvencompras#</cfoutput>">
    <input name="TipDoc"			id="TipDoc" 			type="hidden" value="<cfoutput>#LvarTipDoc#</cfoutput>">
    <input name="URLira"			id="URLira" 			type="hidden" value="<cfoutput>#URLira#</cfoutput>">
--->
<cfoutput>	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="5" class="tituloAlterno"><div align="center">Encabezado del Documento</div></td>
          </tr>
          <tr>
            <td width="13%"><div align="right"><strong>Código Evento:&nbsp;</strong></div></td>
            <td width="39%">#rsEvento.EVcodigo#</td>
            <td width="10%"><div align="right"><strong>Descripción:&nbsp;</strong></div></td>
            <td width="37%">#rsEvento.EVdescripcion#</td>
          </tr>
    </table>
</cfoutput>        
<!---		<cfif modo NEQ "ALTA">
--->        
		<input name="IDoperacion" type="hidden" value="<cfif isdefined("form.IDoperacion") and len(trim(form.IDoperacion))><cfoutput>#form.IDoperacion#</cfoutput></cfif>">
        
	<table style="width:100%" border="0" cellpadding="1" cellspacing="0">
        <tr>
            <td style="width:100%" colspan="4" class="tituloAlterno"><div align="center">Detalle del Evento</div></td>
        </tr>
		  
<!---          	<cfif modoDet neq 'ALTA'>
              <input type="hidden" name="rsModDet" value="#rsModDet.Pvalor#"/>
              <input type="hidden" name="ModTipo" value="#rsLinea.DDtipo#"/>
              <input type="hidden" name="ModCuenta" value="#rsLinea.CFcuenta#"/>
          
		  	</cfif>
--->                 
		  <tr>
            <td align="right">Id Operacion:&nbsp;</td>
            <td ><strong></strong></td>
          </tr>
          <tr>
          	<td align="right">Origen Contable:&nbsp;</td>
		  <td>
<!---				<select id="DDtipo" name="DDtipo" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA'> disabled="disabled"</cfif> onChange="javascript:limpiarDetalle();cambiarDetalle();" 
							<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 0>disabled</cfif> tabindex="1">
					<cfif rscArticulos.cant GT 0 >
					  <option value="A" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "A">selected</cfif>>A-Artículo de Inventario</option>
					</cfif>
					<cfif rscConceptos.cant GT 0>
					  <option value="S" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "S">selected</cfif>>S-Concepto Servicio o Gasto</option>
					</cfif>
						<option value="T" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "T">selected</cfif>>T-Producto en Tránsito</option>
						<option value="F" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "F">selected</cfif>>F-Activo Fijo</option>
						<option value="O" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "O">selected</cfif>>O-Orden Comercial en Tránsito</option>
			  </select>
--->			
			</td>
            <tr>
          	<td align="right">Transacción:&nbsp;</td>            
            <td>
            
            </td>
            </tr>
        </tr>
        <tr>
            <td  align="right">Descripci&oacute;n:&nbsp;</td>
            <td>
            
<!---              <input name="DDdescripcion" tabindex="1" onFocus="javascript:this.select();" type="text" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA'> disabled="disabled"</cfif>
					value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLeditFormat(rsLinea.DDdescripcion)#</cfoutput></cfif>" size="60" maxlength="255">
--->            
			</td>
		</tr>
		<tr>
            <td colspan="4">
            <div align="center">
            	<input name="Cambiar"   class="btnGuardar" tabindex="1" type="submit" value="Guardar"/>
                <input name="Eliminar"  class="btnElimina" tabindex="1" type="submit" value="Eliminar"/>
                <input name="btnNuevo"  class="btnNuevo"   tabindex="1" type="submit" value="Nuevo" onClick="javascript: fnNoValidar();">
            </div>
            </td>
        </tr>
	</table>
        
        
        
		<script language="JavaScript1.2">
<!---			function TraerCuentaConcepto(concepto,depto) {
			//alert("-"+concepto+"-"+depto+"-");			
				<cfloop query="rsCuentaConcepto">
					if (depto == "<cfoutput>#rsCuentaConcepto.Dcodigo#</cfoutput>" 
					&& concepto == "<cfoutput>#rsCuentaConcepto.Cid#</cfoutput>" ) {
						if (document.form1.CcuentaD){document.form1.CcuentaD.value="<cfoutput>#rsCuentaConcepto.Ccuenta#</cfoutput>"; 
						document.form1.CdescripcionD.disabled = false;
						document.form1.CdescripcionD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cdescripcion)#</cfoutput>";
						document.form1.CdescripcionD.disabled = true;}
						<cfif len(rsCuentaConcepto.Cformato) GTE 5>
							if (document.form1.CmayorD) 
							{
								document.form1.CmayorD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,1,4)))#</cfoutput>";
								document.form1.CformatoD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,5,len(rsCuentaConcepto.Cformato))))#</cfoutput>";
							}
						<cfelse>
							if (document.form1.CmayorD) 
							{
								document.form1.CmayorD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cformato)#</cfoutput>";
								document.form1.CformatoD.value="";
							}
						</cfif>
					}
				</cfloop>			
			}
--->		
		</script>
	
	<!---</cfif>  --->

	<!--- ======================================================================= --->
	<!--- NAVEGACION --->
	<!--- =======================================================================
	<cfoutput>
    
	<input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
	<input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
	<input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
	<input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
	<input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
	<input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
	<input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
    
	</cfoutput>
	======================================================================= --->
	<!--- ======================================================================= --->
</form>


<script language="JavaScript1.2" type="text/javascript">
<!---	validatcLOAD();	
	AsignarHiddensEncab();
	
	<cfif modo NEQ "ALTA">
		if (document.form1.DDtipo.value != "S")		
			//document.form1.imagen[1].style.visibility = "hidden";
		poneItem();
		window.setTimeout("cambiarDetalle()",1);
		
	<cfelse>
		document.form1.EDdocumento.focus();
	</cfif>
	function CalculaFechaVen(){ 
		if(document.getElementById('EDfecha').value !=''){
			fechaVencimiento = fndateadd(document.getElementById('EDfecha').value,document.getElementById('SNvencompras').value);
			document.getElementById('EDvencimiento').value = fndateformat(fechaVencimiento);
		}
		else
			document.getElementById('EDvencimiento').value ='';
	}
	<!---►►Funcion que suma Dias a un string con formato fecha◄◄--->
	function fndateadd(fecha, dias){
		f = fecha.split('/');
		stringFecha = new Date(f[2],f[1]-1,f[0]);
		return new Date(stringFecha.getTime() + dias * 86400000); //Cantidad de milesegundos en un Dia
	}
	<!---►►Funcion que convierte una fecha a un string de tipo DD/MM/YYYY◄◄--->
	function fndateformat(fecha){
		var dd   = fecha.getDate();
		var mm   = fecha.getMonth()+1;//Enero is 0
		var yyyy = fecha.getFullYear();
		if(dd<10){dd='0'+dd;}
		if(mm<10){mm='0'+mm;}
		return dd+'/'+mm+'/'+yyyy;;
	}
	function check(obj){
		
		document.getElementById("idCheck").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidCheck").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";

		document.getElementById("idFecha").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidFecha").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";

		document.getElementById("idObs").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidObs").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
	}
	
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function NuevaVentana(SNcodigo, IDdocumento,Mcodigo) {
		var params ="";
		
		params = "&form=form"+
		
		popUpWindow("/cfmx/sif/cp/operacion/OrdenCompra.cfm?SNcodigo="+SNcodigo+"&IDdocumento="+IDdocumento+"&Mcodigo="+Mcodigo+params,50,50,900,750);
	}
	function funcGarantias(IDdocumento) {
			popUpWindow("/cfmx/sif/cp/operacion/ReporteGarantias.cfm?Documento="+IDdocumento,50,50,900,750);
	}
	//llama el pop up y le pasa por url los parametros
	function ShowFacturas()
	{
	     var LvarReferencia = document.form1.Referencia.value;
		 var LvarReferencia1 = document.form1.Referencia1.value;
		 var LvarSNcodigo = document.form1.SNcodigo.value;
		 if(LvarReferencia =='' ||LvarReferencia1 =='')
		 {		  
		   alert("No se ha seleccionado ninguna factura de referencia"); 
		   return false;
		 }
		 else
		 {
		 var LvarIdDocumento = document.form1.IDdocumento.value;
		  window.open('NotasCreditoFacturas.cfm?tipo='+LvarReferencia+'&Ddocumento='+LvarReferencia1+'&IdDocumento='+LvarIdDocumento+'&SNcodigo='+LvarSNcodigo,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
		 }
	}

	function funcFactRecurrente(SNcodigo){
		 
		var paramss ="";
		var LvarDdocumento = document.form1.EDdocumento.value;
		var LvarTESRPTCid1 = document.form1.TESRPTCid.value;
		if (LvarDdocumento == "" ){
			alert('El campo Documento es requerido.');
				return false;
		}
		if (LvarTESRPTCid1 == "" ){
			alert('El campo Pagos a terceros es requerido.');
				return false;
		}
		paramss = "&form=form"+
		popUpWindow("/cfmx/sif/cp/operacion/ListaDocumentosRecurrentesCP.cfm?SNcodigo="+SNcodigo+"&EDdocumento="+LvarDdocumento+"&TESRPTCid="+LvarTESRPTCid1+paramss,25,50,1024,750);
	
	}
	


	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
 	<cfif modo NEQ "ALTA">
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			//formatCurrency(document.form1.TC,2);
			document.form1.EDtipocambio.disabled = true;			
		}				
		var estado = document.form1.EDtipocambio.disabled;
		document.form1.EDtipocambio.disabled = false;
		document.form1.EDtipocambio.value = document.form1.TC.value;
		document.form1.EDtipocambio.disabled = estado;

		function obtener_formato(mayor, formato){
			
		}

		function funcAcodigoT(){
		    document.form1.DDdescripcion.value = document.form1.AdescripcionT.value;
 		    document.form1.DDdescalterna.value = document.form1.AdescripcionT.value;
			if (document.form1.CcuentaD)document.form1.CcuentaD.value = document.form1.cuenta_AcodigoT.value;
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_AcodigoT.value;
			document.form1.CformatoD.value =  document.form1.cuentaformato_AcodigoT.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_AcodigoT.value;}
		}

		function funcAcodigo(){
		    document.form1.DDdescripcion.value = document.form1.Adescripcion.value;
 		    document.form1.DDdescalterna.value = document.form1.Adescripcion.value;
			if (document.form1.CcuentaD)document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value;
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value;
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_Acodigo.value;}
		}

		function funcExtraAcodigo(){
			<cfif NOT LvarComplementoXorigen>
			document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value='';
			</cfif>
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value = '';
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value='';
			document.form1.CdescripcionD.value =  document.form1.cuentadesc_Acodigo.value='';}
		}

 	</cfif>
	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	function funcAlmcodigoAntes(){
		limpiarAxCombo();
	}
	
		/*-------------------------*/
	
	function _Field_isRango(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.00, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
	}
	_addValidator("isRango", _Field_isRango);
	
	function _ValidarSNid_CCO_00(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.00, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
	}
	_addValidator("isValidaSNid", _ValidarSNid_CCO_00);

	<cfif modo NEQ "ALTA">
		objForm.OCid.description = "Órden Comercial";
		objForm.OC_SNid.description = "Socio Nocio de la Orden Comercial";

		objForm.OCTtransporte.description 	= "Transporte Transito";
		objForm.OCTid.description 			= "Transporte Orden Comercial";

		objForm.Aid.description		= "Artículo";
		objForm.AidT.description	= "Artículo Tránsito";
		objForm.AidOD.description	= "Artículo Órden Comercial";
	</cfif>

	objForm.EDdocumento.required = true;
	objForm.EDdocumento.description = "Código de Documento";
	objForm.CPTcodigo.required = true;
	objForm.CPTcodigo.description = "Tipo de Transaccion";
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "Cliente";

	objForm.EDfechaarribo.required 	  = true;
	objForm.EDfechaarribo.description = "Fecha Arribo";
	objForm.EDfecha.required		  = true;
	objForm.EDfecha.description 	  = "Fecha Factura";
	objForm.EDvencimiento.required 	  = true;
	objForm.EDvencimiento.description = "Fecha Vencimiento";
	
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description = "Oficina";
	objForm.Rcodigo.required = true;
	objForm.Rcodigo.description = "Retención";
	objForm.Ccuenta.required = true;
	objForm.Ccuenta.description = "Cuenta de Proveedor";
	objForm.TESRPTCid.required = true;
	objForm.TESRPTCid.description = "Pagos a terceros";

	
	objForm.EDtipocambio.required = true;
	objForm.EDtipocambio.description = "Tipo de Cambio";
	objForm.EDtipocambio.validateRango('0.0001','999999999999.9999');
	
	objForm.EDdescuento.description = "Descuento";
	objForm.EDdescuento.validateRango('0.00','999999999999.99');

	<cfif modo NEQ "ALTA">

	if(document.form1.Almacen.style.visibility == "visible"){
		objForm.Almacen.required = true;
		objForm.Almacen.description = "Almacén";
	}

	if(document.form1.LvarPlanDeCompras == false){
	
	objForm.DDdescripcion.required = true;
	objForm.DDdescripcion.description = "Descripción del Detalle";
	if (document.form1.CcuentaD){
	objForm.CcuentaD.required = true;
	objForm.CcuentaD.description = "Cuenta del Detalle";}
	}


	objForm.DDpreciou.required = true;
	objForm.DDpreciou.description = "Precio Unitario";	
	objForm.DDpreciou.validateRango('0.01','999999999999.99');
	
	objForm.DDcantidad.required = true;
	objForm.DDcantidad.description = "Cantidad";	
	objForm.DDcantidad.validateRango('0.00','999999999999.99');
	
	objForm.DDdesclinea.required = true;
	objForm.DDdesclinea.description = "Descuento de Línea";
	objForm.DDdesclinea.validateRango('0.00','999999999999.99');
	
	objForm.DDtotallinea.required = true;
	objForm.DDtotallinea.description = "Total de Línea";
	objForm.DDtotallinea.validateRango('0.01','999999999999.99');
	</cfif>
	

	

	function fnNoValidar() {

		objForm.Aid.required = false;
		objForm.AidT.required = false;
		objForm.AidOD.required = false;
		objForm.Cid.required = false;

		objForm.DDdescripcion.required = false;
		if(document.form1.Almacen.style.visibility == "visible"){
			objForm.Almacen.required = false;
			}
		objForm.Ccuenta.required = false;
		if (document.form1.CcuentaD) objForm.CcuentaD.required = false;
		objForm.DDpreciou.validate = false;
		objForm.DDpreciou.required = false;
		objForm.DDcantidad.required = false;
		objForm.DDdesclinea.required = false;
		objForm.DDtotallinea.required = false;
		objForm.CFdescripcion.required = false;
		objForm.TESRPTCid.required = false;

		_allowSubmitOnError = true;
	}
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
	var LvarArrCcuenta   = new Array();
	var LvarArrCFformato = new Array();
	var LvarArrCFdescripcion = new Array();

<cfoutput query="rsTransacciones"> 
	<cfif isdefined("rsTransacciones.CFformato")>
		/* def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "#rsTransacciones.Ccuenta#";
		LvarArrCFformato["#CPTcodigo#"] = "#rsTransacciones.CFformato#";
		LvarArrCFdescripcion["#CPTcodigo#"] = "#rsTransacciones.CFdescripcion#";
	<cfelse>
		/* no  def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "";
		LvarArrCFformato["#CPTcodigo#"] = "";
		LvarArrCFdescripcion["#CPTcodigo#"] = "";
	</cfif>
	
</cfoutput>
	function sbCPTcodigoOnChange (CPTcodigo)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [CPTcodigo];
	<cfif LvarComplementoXorigen>
		document.getElementById("SNCta").value 		= LvarArrCFformato[CPTcodigo] + ': ' + LvarArrCFdescripcion[CPTcodigo];
	<cfelse>
		var LvarCFformato = LvarArrCFformato[CPTcodigo];
		document.getElementById("Cmayor").value 		= LvarCFformato.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[CPTcodigo];
	</cfif>
	}
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
	var LvarArrCcuentaD   = new Array();
	var LvarArrCFformatoD = new Array();
	var LvarArrCFdescripcionD = new Array();

<cfoutput query="direcciones"> 
	<cfif isdefined("direcciones.CFformato")>
		/* def*/
		LvarArrCcuentaD  ["#id_direccion#"] = "#direcciones.Ccuenta#";
		LvarArrCFformatoD["#id_direccion#"] = "#direcciones.CFformato#";
		LvarArrCFdescripcionD["#id_direccion#"] = "#direcciones.CFdescripcion#";
	<cfelse>
		/* no def*/
		LvarArrCcuentaD  ["#id_direccion#"] = "";
		LvarArrCFformatoD["#id_direccion#"] = "";
		LvarArrCFdescripcionD["#id_direccion#"] = "";
	</cfif>
</cfoutput>
	function sbid_direccionOnChange (id_direccion)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuentaD  [id_direccion];
	<cfif LvarComplementoXorigen>
		document.getElementById("SNCta").value 		= LvarArrCFformatoD[id_direccion] + ': ' + LvarArrCFdescripcionD[id_direccion];
	<cfelse>
		var LvarCFformatoD = LvarArrCFformatoD[id_direccion];
		document.getElementById("Cmayor").value 		= LvarCFformatoD.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformatoD.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcionD[id_direccion];
	</cfif>
	}

	<cfoutput>
		<cfif isdefined("rsTransacciones.CFformato")>
		sbCPTcodigoOnChange ("#form.CPTcodigo#");	
		</cfif>
		<cfif not isdefined("form.modo") and modo eq 'ALTA'>
			if (document.form1.EDdocumento.value.length > 0){
				document.form1.EDfechaarribo.focus();
			}
		</cfif>
		 <cfif isdefined("modo") and modo neq 'ALTA'and  modoDet EQ "ALTA">
			document.form1.DDtipo.focus();
		</cfif>
	</cfoutput>
	function doConlisTransporte() {
		var DDtipo = document.form1.DDtipo.value;
		var OCid = document.form1.OCid.value;
		var OCTtipo = document.form1.OCTtipo.value;
		var PARAM  = "ConlisTransporte.cfm?OCTtipo="+ OCTtipo + "&DDtipo="+DDtipo ;
		if (DDtipo == 'O'){
			if ( OCid != "" ){
				var PARAM  = PARAM + "&OCid="+ OCid;
				open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
			}
			else {
				alert('Tiene que seleccionar una orden comercial');			
			}
		}
		else{
			open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
		}
	}
	
	function validaTransporte() {
		var DDtipo		 	= document.form1.DDtipo.value;
		var OCid 			= document.form1.OCid.value;
		var OCTtipo 		= document.form1.OCTtipo.value;
		var OCTtransporte 	= document.form1.OCTtransporte.value;
		
		if(OCTtransporte != "") {
			var PARAM = "?OCTtransporte="+OCTtransporte+"&OCTtipo="+OCTtipo+"&DDtipo="+DDtipo;

			if (DDtipo == 'O'){
				if ( OCid != "" ){
					var PARAM  = PARAM + "&OCid="+ OCid;
					var frame  = document.getElementById("FRAMETRANSPORTE");
					frame.src 	= "validaTransporte.cfm" + PARAM;
				}
				else {
					alert('Tiene que seleccionar una orden comercial');			
				}
			}
			else{
				var frame  = document.getElementById("FRAMETRANSPORTE");
				frame.src 	= "validaTransporte.cfm" + PARAM;
			}
		}
	}
	
	var GvarOCobtieneCFcuenta = false;
	function fnOCobtieneCFcuenta() {
		var PARAM = "?tipo=TR";
		PARAM = PARAM + "&OCid=" + document.form1.OCid.value;
		PARAM = PARAM + "&Aid="  + document.form1.AidOD.value;
		PARAM = PARAM + "&SNid=" + document.form1.SNid.value;
		PARAM = PARAM + "&OCCid=" + document.form1.OCCid.value;
		var frame  = document.getElementById("FRAMETRANSPORTE");
		frame.src 	= "/cfmx/sif/Utiles/OC_CFcuenta.cfm" + PARAM;
		GvarOCobtieneCFcuenta = true;
	}

	function fnOCobtieneCFcuenta_Asignar(pCFcuenta,pCcuenta,pCFformato,pCFdescripcion)
	{
		document.form1.CFcuentaD.value	= pCFcuenta;
		document.form1.CcuentaD.value			= pCcuenta;
		document.form1.CmayorD.value			= pCFformato.substring(0,4);
		document.form1.CformatoD.value			= pCFformato.substring(5);
		document.form1.CdescripcionD.value		= pCFdescripcion;
	}
	function PlanCompras()
	{
     IDdocumento = document.form1.IDdocumento.value;
	 LvarfechaFactura=document.form1.EDfecha.value;				
     window.open('planComprasFactura.cfm?documento='+IDdocumento+'&fechaFactura='+LvarfechaFactura,'popup','width=1200,height=700,left=100,top=50,scrollbars=yes');
		
	}
	function  fnVerOC()
	{  
	   IDdocumento = document.form1.IDdocumento.value;			
       window.open('OrdenesFacturadas.cfm?documento='+IDdocumento,'popup','width=1100,height=350,left=200,top=150,scrollbars=yes');
	}
	function fnAnular(){
		return confirm('Esta seguro que desea Anular el Documento?');
	}
---></script>
