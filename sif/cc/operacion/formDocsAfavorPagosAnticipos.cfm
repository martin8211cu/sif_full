<!--- 
	Modificado por: Ana Villavicencio+
	Fecha: 10 de marzo del 2006
	Motivo: Se agrego la funcionalidad de volver a la pantalla de registro de notas de credito para el caso de que el documento
			vengo desde notas de credito (Aplicar y Relacionar la Nota de Credito).
			Se cambio el conlis de transaccion  por el tag de conlis.

	Modificado por: Ana Villavicencio+
	Fecha: 02 de marzo del 2006
	Motivo: se corrigió la navegacion con tabs en la pantalla de trabajo.
			se cambio el campo de fecha por el tag sif calendario.
			Se agrego la funcionalidad F2 para el conlis de lista de transacciones del encabezado.
	
	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Se cambiaron los botones relacionados con el encabezado, hacia la parte inferior del encabezado.
			cambio en el tamaño del popup de seleccion masiva.
	Modificado por Gustavo Fonseca H.
		Fecha: 7-11-2005.
		Motivo: - Se corrige la pantalla para que en "Saldo en moneda del documento: " se pinte el saldo del documento 
			del detalle en "ALTA" y para que en Monto en "moneda del documento:" se pinte la Cuota.
			- Se Corrigió el query rsDatosConlis que le faltaban parámetros por que no en contraba el archivo seleccionado 
			en CAMBIO.
			- Se corrigió el query rsLinea para que busque el saldo del documento del detalle y no el del 
			encabezado (que era como estaba) en el cambio.
	Modificado por Mauricio Esquivel / Gustavo Fonseca
		Fecha: 1-11-2005.
		Motivo: corregir la validación __isMontoPago que no dejaba cambiar montos del detalle.	
	Modificado por Gustavo Fonseca H.
		Fecha: 31-10-2005.
		Motivo: se corrige el input "DFmontodoc" por que que daba desabilitado en el cambio y daba error el SQL.
	Modificado por Gustavo Fonseca H.
		Fecha: 29-11-2005.
		Motivo: Se corrige para que si la cuota es menor al saldo pinte la cuota y si el saldo es menor a la cuota pinte el saldo.
	 --->

<cfif isdefined("Form.Cambio")>
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
<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>
<cfif isDefined("Form.NuevoE")>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
<cfelseif isDefined("Form.datos") and Form.datos NEQ "">
	<cfset modo = "CAMBIO">
	<cfset modoDet = "ALTA">
</cfif>

<cfset IDpago = "">
<cfset CCTcodigo = "">
<cfset Ddocumento = "">
<cfset CCTRcodigo = "">
<cfset DRdocumento = "">
<cfset GSaldo = 0>	

<cfif not isDefined("Form.NuevoE")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset IDpago = Trim(arreglo[1])>
		<cfset CCTcodigo = Trim(arreglo[2])>
		<cfset Ddocumento = Trim(arreglo[3])>

 		<cfif sizeArreglo EQ 5>
			<cfset CCTRcodigo = Trim(arreglo[4])>
			<cfset DRdocumento = Trim(arreglo[5])>

			<cfset modoDet = "CAMBIO">
		</cfif>		
	<cfelseif isdefined("Form.CCTcodigo") and isdefined("Form.Ddocumento")>
		<cfset CCTcodigo =  Trim(Form.CCTcodigo)>
		<cfset Ddocumento =  Trim(Form.Ddocumento)>
		<cfif isDefined("Form.CCTRcodigo") and Len(Trim(Form.CCTRcodigo)) NEQ 0>
			<cfset CCTRcodigo = Trim(Form.CCTRcodigo)>
		</cfif>
		<cfif isDefined("Form.DRdocumento") and Len(Trim(Form.DRdocumento)) NEQ 0>
			<cfset DRdocumento = Trim(Form.DRdocumento)>
		</cfif>
	</cfif>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
		from Empresas 
	where Ecodigo = #Session.Ecodigo# 
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select 
        	a.Ecodigo,
            a.CCTcodigo,
            a.Ddocumento,
            a.SNcodigo,			
			b.SNnumero,
			b.SNnombre,
            a.Mcodigo,
			c.Mnombre,
            a.EFtipocambio,
            a.EFtotal,
            a.EFselect,
            a.EFfecha,
            a.Ccuenta,
            a.ts_rversion
            from EFavor a
			  inner join SNegocios b
				 on a.Ecodigo  = b.Ecodigo 
		  	    and a.SNcodigo = b.SNcodigo 
			  inner join Monedas c
				on a.Mcodigo   = c.Mcodigo
			   and a.Ecodigo   = c.Ecodigo
            where a.Ecodigo 		         = #Session.Ecodigo#
              and a.CCTcodigo 		         = <cfqueryparam cfsqltype="cf_sql_char"    value="#CCTcodigo#">
              and rtrim(ltrim(a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char"    value="#TRIM(Ddocumento)#">
 	 </cfquery>
	 <cfif rsDocumento.RecordCount EQ 0>
		<cfset MSG_RecDoctoFavor = t.Translate('MSG_RecDoctoFavor','No se pudo recuperar el Documento a Favor.')>
	 	<cfthrow message="#MSG_RecDoctoFavor#">
	 </cfif>
	<cfquery name="rsCalculaSaldo" datasource="#Session.DSN#"> 
		select 
        	a.Dsaldo as Dsaldo
            from Documentos a
				inner join CCTransacciones b
					on a.CCTcodigo = b.CCTcodigo 
				   and a.Ecodigo   = b.Ecodigo  
				inner join CContables d
					on a.Ccuenta   = d.Ccuenta 
            WHERE a.Ecodigo 				 = #Session.Ecodigo#
              and a.CCTcodigo				 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDocumento.CCTcodigo#">
              and rtrim(ltrim(a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(rsDocumento.Ddocumento)#">
              and b.CCTtipo					 = 'C' 
			  and coalesce(b.CCTpago,0)     != 1 
              and a.SNcodigo				 = #rsDocumento.SNcodigo#
	</cfquery>    
	
	<cfif rsCalculaSaldo.recordcount EQ 0>
		<cfset GSaldo = 0>					
	<cfelse>					
		<cfset GSaldo = 1>	
	</cfif>    
	
	<cfquery name="rsTieneLineas" datasource="#Session.DSN#">
		select 1 as Cantidad from DFavor  a
		where a.Ecodigo = #Session.Ecodigo#
  		  <cfif isDefined("Form.IDpago") and Len(Trim(Form.IDpago)) NEQ 0 >
		  	and rtrim(ltrim(a.CCTcodigo+a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#IDpago#">
		  </cfif>
	</cfquery>
	<cfif Len(Trim(CCTcodigo)) NEQ 0>
		<cfquery name="rsLinea" datasource="#Session.DSN#">
		select 
			b.Dsaldo 
        from DFavor a, Documentos b
    	where a.Ecodigo = #Session.Ecodigo#
		  <cfif isDefined("CCTRcodigo") and Len(Trim(CCTRcodigo)) NEQ 0 >
		  	and a.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CCTRcodigo#">
		  </cfif>	
		  <cfif isDefined("DRdocumento") and Len(Trim(DRdocumento)) NEQ 0 >
		  	and rtrim(ltrim(a.DRdocumento)) = rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#DRdocumento#">)
		  </cfif>
		  	and a.CCTRcodigo =  b.CCTcodigo
		  	and rtrim(a.DRdocumento) = rtrim(b.Ddocumento)
		  
		</cfquery>
	</cfif>
	<cfquery name="rsSocio" datasource="#Session.DSN#">
		select SNcodigo, SNnombre 
		from SNegocios where Ecodigo = #Session.Ecodigo# 
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.SNcodigo#">
	</cfquery> 

	<cfquery name="rsAplicado" datasource="#Session.DSN#">
		select coalesce(sum(DFmonto),0.00) as DFmonto from DFavor 
		where Ecodigo = #Session.Ecodigo#
		  and CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#CCTcodigo#">
		  and rtrim(Ddocumento) = rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Ddocumento#">)
		<cfif modoDet NEQ "ALTA">
			
		</cfif>
	</cfquery>

	 <cfif modoDet NEQ "ALTA">
		<cfquery name="rsDdocumento" datasource="#Session.DSN#">
			select 
				a.Ecodigo,
				a.CCTcodigo, 
				rtrim(a.Ddocumento) as Ddocumento,
				a.CCTRcodigo,
				rtrim(a.DRdocumento) as DRdocumento ,
				a.SNcodigo,
				a.DFmonto,
				a.Ccuenta,
				a.DFtipocambio,
				a.Mcodigo,
				a.DFmontodoc,
				a.DFtotal,
				a.ts_rversion,
				<cf_dbfunction name="concat" args="rtrim(a.CCTRcodigo),'-',rtrim(a.DRdocumento),'-',rtrim(c.Mnombre)"> as DocRef
			from DFavor a, Documentos b, Monedas c 
			where a.Ecodigo = #Session.Ecodigo#
			  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CCTcodigo#">
			  and rtrim(a.Ddocumento) = rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Ddocumento#">)
			  and a.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CCTRcodigo#">
			  and rtrim(a.DRdocumento) = rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#DRdocumento#">)
			  and a.Ecodigo = b.Ecodigo
			  and a.CCTRcodigo = b.CCTcodigo
			  and rtrim(a.DRdocumento) = rtrim(b.Ddocumento)
			  and b.Mcodigo = c.Mcodigo
		</cfquery> 
		
<cfquery name="rsDatosConlis" datasource="#session.DSN#">
	select distinct 
		b.Ddocumento,
		b.CCTcodigo,
		<cf_dbfunction name="concat" args="b.CCTRcodigo,'-',rtrim(b.DRdocumento),'-',c.Mnombre"> as DTM,
		rtrim(b.DRdocumento) as Documento,
		a.SNcodigo as SNcodigo2,
		b.CCTRcodigo as CCTcodigoConlis
	from EFavor a
		inner join DFavor b
			on a.Ecodigo = b.Ecodigo
			and a.CCTcodigo = b.CCTcodigo
			and a.Ddocumento = b.Ddocumento
		inner join Monedas c
			on c.Mcodigo = b.Mcodigo
			and a.Ecodigo = b.Ecodigo
	where b.Ecodigo = #Session.Ecodigo#
		and b.DRdocumento =   rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#DRdocumento#">)
		and b.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CCTRcodigo#">
		 and b.Ddocumento =   rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Ddocumento#">)
		and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CCTcodigo#">
</cfquery>

		<cfquery name="rsMontolinea" datasource="#Session.DSN#">	
		 	select DFmonto from DFavor 
 		  	where Ecodigo 		= #Session.Ecodigo#
              and CCTcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#CCTcodigo#">
              and rtrim(Ddocumento)	= rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Ddocumento#">)
              and CCTRcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#CCTRcodigo#">
              and rtrim(DRdocumento)	= rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#DRdocumento#">)
		</cfquery> 

	</cfif>

</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_SeleCliente = t.Translate('MSG_SeleCliente','Por favor debe seleccionar un cliente')>
<cfset LB_descripcion = t.Translate('LB_descripcion','descripcion')>
<cfset LB_USUARIO = t.Translate('LB_Usuario','usuario','/sif/generales.xml')>
<cfset LB_EncabezadoDoc = t.Translate('LB_EncabezadoDoc','Encabezado del Documento')>
<cfset LB_CLIENTE 		= t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_ListaDoc		= t.Translate('LB_ListaDoc','Lista de Documentos')>
<cfset LB_Monto 		= t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo 		= t.Translate('LB_Saldo','Saldo')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset LB_Disponible	= t.Translate('LB_Disponible','Disponible')>
<cfset BTN_Agregar	= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset BTN_Regresar	= t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset BTN_Cambiar	= t.Translate('BTN_Cambiar','Cambiar','/sif/generales.xml')>
<cfset BTN_SelMasiva = t.Translate('BTN_SelMasiva','Selección Masiva')>
<cfset BTN_NvoDocto	= t.Translate('BTN_Nuevo_Documento','Nuevo Documento','/sif/generales.xml')>
<cfset BTN_Eliminar_Documento	= t.Translate('BTN_Eliminar_Documento','Borrar Documento','/sif/generales.xml')>
<cfset BTN_Aplicar	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')> 
<cfset MSG_ConfirmBorra = t.Translate('MSG_ConfirmBorra','Realmente desea borrar este documento')>
<cfset BTN_Regresar	= t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')> 

<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	botonActual = "";
	
	function setBtn(boton) {
		botonActual = boton.name;
	}
	
	function btnSelected(name) {
		return (botonActual == name)
	}

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  window.onfocus=closePopUp; 
	}
	
	function closePopUp() {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin = 0;
	  }
	  if (document.form1.F5.value == "F5")
		document.form1.CambiarE.click();
	}
	
//-----------------------------------------------------------------------------------------------------------
	
	function doConlis1() 
	{
		doLimpiarE();
		popUpWindow("../consultas/ConlisProvDocsAfavorCC.cfm?form=form1&id=SNcodigo&desc=SNnombre",250,200,450,350);
	}	

	//funcion para habilitar el F2
		function conlis_keyup(e) {
			var keycode = e.keyCode ? e.keyCode : e.which;
			if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
				doConlisTran();
			}
		}
	 function doConlisDocs() {
	  if (document.form1.SNcodigo.value != "" )
	  {
			//Se envía el codigo del Socio como parámetro para que filtre el donlis
			popUpWindow("../consultas/ConlisDocsAfavorSocioCC.cfm?form=form1&desc=DTM&SNcodigo=" + document.form1.SNcodigo.value,100,100,900,500);
		}
		else
		{
		 alert("#MSG_SeleCliente#"); 
		}	
	}

	function doConlisTran() {
	  if (document.form1.SNcodigo.value != "" ) {
		//Se envía el codigo del Socio como parámetro para que filtre el donlis
		popUpWindow("../consultas/ConlisDocsCC.cfm?form=form1&id=CCTcodigo&desc=Ddocumento&nombre=Mnombre&tipocambio=EFtipocambio&saldo=SaldoEncabezado&Moneda=McodigoE&Ccuenta=CcuentaE&Socio=" + document.form1.SNcodigo.value,150,200,775,400);
	  } else {
		alert("#MSG_SeleCliente#");
	  }	
	}

	function Lista() {
		var params   = '?pageNum_rsDocumentos='+document.form1.pageNum_rsDocumentos.value;
			params += (document.form1.fecha.value != -1) ? "&#LB_Fecha#=" + document.form1.fecha.value : '';
			params += (document.form1.descripcion.value != -1) ? "&#LB_descripcion#=" + document.form1.descripcion.value : '';
			params += (document.form1.transaccion.value != -1) ? "&#LB_Transaccion#=" + document.form1.transaccion.value : '';
			params += (document.form1.usuario.value != -1) ? "&#LB_USUARIO#=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != -1) ? "&##LB_Moneda##=" + document.form1.moneda.value : '';

		<cfif isdefined('form.AplicaRel')>
		location.href="RegistroNotasCredito.cfm?" + '<cfoutput>#regresa#</cfoutput>';
		<cfelse>
			location.href="listaDocsAfavorPagosAnticipos.cfm" + params;
		</cfif>
	}

	function validaForm(f) {
		if (btnSelected("AgregarD") || btnSelected("CambiarD")) {
			f.EFtipocambio.obj.disabled = false;
			f.EFtipocambio.obj.value = qf(f.EFtipocambio.obj.value);
			f.DFmontodoc.obj.disabled = false;
			f.DFmontodoc.obj.value = qf(f.DFmontodoc.obj.value);
			f.DFmonto.obj.value = qf(f.DFmonto.obj.value);
		}
		return true;
	}

	function validaSaldo(f) { 
		if (f.FC.value == "encabezado") { //alert(parseFloat(qf(f.DFmonto.value)) + ' DFMonto'); alert(parseFloat(qf(f.EFtipocambio.value)) + ' Tipo de cambio');
			f.DFmontodoc.value = parseFloat(qf(f.DFmonto.value)) * parseFloat(qf(f.EFtipocambio.value));
			//f.DFmontodoc.value = redondear(parseFloat(fm(f.DFmonto.value, 2))) * redondear(parseFloat(fm(f.EFtipocambio.value, 2)));
			fm (f.DFmontodoc.value, 2);
			//alert(fm (f.DFmontodoc.value, 2));
		} else if (f.FC.value == "iguales") {
			f.DFmontodoc.value = f.DFmonto.value;
		}
		
	}

	
	function funcDocumento(){ 
		obtieneValores(document.form1,document.form1.CodSNcodigo2.value);
	}

	function obtieneValores(f, valor) 
	{		
		f.DFmonto.disabled = false;
		if (valor != "") {
			var p = valor.split("|");
			f.McodigoD.value = p[0];
			f.CCTRcodigo.value = p[1];
			f.DRdocumento.value = p[2];
			f.CcuentaD.value = p[3];
			f.DFtipocambio.value = fm(p[4], 4);
			f.DsaldoD.disabled = true;
			f.DsaldoD.value = fm(p[9],2);
			//f.DFmontodoc.value="0.00";
			if(parseFloat(qf(p[9],2)) < parseFloat(qf(p[5],2))){//si (9)saldo < (5)cuota pinte saldo si no pinte cuota.
				f.DFmontodoc.value = fm(p[9],2); 
				}
			else {
				f.DFmontodoc.value = fm(p[5],2); 
				}
			f.DFmonto.value = "0.00";

			if (f.McodigoD.value == f.McodigoE.value) {
				// LA MONEDA DEL DOCUMENTO ES IGUAL A LA DEL ENCABEZADO
				f.DFmontodoc.disabled = true;
				f.FC.value = "iguales";
			} else {
				if (f.monedalocal.value != f.McodigoD.value) {
					// LA MONEDA LOCAL ES DIFERENTE A LA DEL DOCUMENTO
					f.DFmontodoc.disabled = false;
					f.FC.value = "calculado";
				} else {
					// LA MONEDA LOCAL ES IGUAL A LA DEL DOCUMENTO
					f.DFmontodoc.disabled = true;
					f.FC.value = "encabezado";                                
				}
			}
			sugerirMonto(f);
		}


	}

	
 
	function sugerirMonto(f) {
		//f.DFmontodoc.value = fm(f.DsaldoD.value, 2);
		if (f.FC.value == "encabezado") {
			if ((new Number(qf(f.disponible.value)) * new Number(qf(f.EFtipocambio.value))) <= new Number(qf(f.DsaldoD.value))) {
				f.DFmonto.value = fm(f.disponible.value,2);
			} else { 
				f.DFmonto.value = fm(new Number(qf(f.DsaldoD.value)) / new Number(qf(f.EFtipocambio.value)), 2);
			}
		} else if (f.FC.value == "iguales") {
			if (new Number(qf(f.disponible.value)) <= new Number(qf(f.DsaldoD.value))) {
				f.DFmonto.value = fm(f.disponible.value, 2); 
				//f.DFmonto.value = fm(f.DFmontodoc.value, 2);
			} else {
				//f.DFmonto.value = fm(f.DsaldoD.value, 2);alert('iguales2');
				f.DFmonto.value = fm(f.DFmontodoc.value, 2);
			}
		} 
		validaSaldo(f);
	}
	
	function validatcLOAD(f) { 
		if (f.McodigoE != null && f.McodigoE.value == f.monedalocal.value) {
			f.EFtipocambio.value = "1.0000"
			f.EFtipocambio.disabled = true
		}
		f.EFtipocambio.value = fm(f.EFtipocambio.value, 4);
	}   

	

	function doLimpiarE() {
		document.form1.CCTcodigo.value="";
		document.form1.Ddocumento.value="";
		document.form1.CcuentaE.value="";
		document.form1.EFtipocambio.value="";
		document.form1.Mnombre.value="";
		document.form1.SaldoEncabezado.value="";
		document.form1.McodigoE.value="";
		document.form1.ECselect.value="";
		document.form1.Aplicado.value="";
	}
	
	//Llamado al popup de seleccion masiva
	function funcPantallaSeleccion(){
		var params ='';
		params = "?SNcodigo="+document.form1.SNcodigo.value+"&pn_disponible="+document.form1.disponible.value+"&Mcodigo="+	document.form1.McodigoE.value+"&Ddocumento="+document.form1.Ddocumento.value+"&CCTcodigo="+document.form1.CCTcodigo.value+"&mantieneFiltro=no";
		popUpWindow("/cfmx/sif/cc/operacion/SeleccionMasiva.cfm"+params,100,125,850,500);
	}
	
</script>

<form action="SQLDocsAfavorPagosAnticipos.cfm" method="post" name="form1" onsubmit="javascript:return validaForm(this);">
	<cfoutput>
	<input type="hidden" name="SeleccionMasiva" value="">
	<cfif isdefined('form.datos') and LEN(TRIM(form.datos))>
		<input name="datos" type="hidden" value="#form.datos#">
	</cfif>
	<cfif isdefined('form.AplicaRel')>
	<input name="AplicaRel" type="hidden" value="#form.AplicaRel#">
	<input name="regresa" type="hidden" value="#regresa#">
	</cfif>
	</cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	
	<cfif modo NEQ "ALTA" and GSaldo EQ 0>	
			<tr><td><font color="#FF0000"><center><strong>Este Documento No se puede Aplicar porque tiene Saldo en Ceros</strong></center></font></td></tr>	
	</cfif>		
		
		<tr> 
			<td> 
          		<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr><td colspan="6" class="tituloAlterno"><strong><cfoutput>#LB_EncabezadoDoc#</cfoutput></strong></td></tr>
				<tr><td>&nbsp;</td></tr>
            	<tr> 
              	<td nowrap align="right"><strong><cfoutput>#LB_CLIENTE#:&nbsp;</cfoutput></strong></td>
              	<td nowrap>
					<input type="hidden" name="monedalocal" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedalocal.Mcodigo#</cfoutput></cfif>" > 
					<cfif modo neq 'ALTA'>
						<cfoutput>
							<input name="SNcodigo" type="hidden" value="#rsDocumento.SNcodigo#">
							<input name="SNnombre" type="hidden" value="#rsDocumento.SNnombre#">
							<input name="SNnumero" type="hidden" value="#rsDocumento.SNnumero#">
							<strong>#rsDocumento.SNnumero# &nbsp;&nbsp;#rsDocumento.SNnombre#</strong>
						</cfoutput>
					<cfelse>
						<cf_sifsociosnegociosFA tabindex="1">
					</cfif>
              	</td>
                <cfoutput>
              	<td width="14%" nowrap align="right"> 
                	<input type="hidden" name="CcuentaE" value="">
					<strong>#LB_Transaccion#:&nbsp;</strong>
				</td>
              	<td width="26%" nowrap>
					<cfif modo EQ "ALTA">
					<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined('form.CCTcodigo')>
						<cfset ArrayAppend(valuesArray, Form.CCTcodigo)>
						<cfset ArrayAppend(valuesArray, Form.Ddocumento)>
					</cfif>
						<cf_conlis 
						title="#LB_ListaDoc#"
						campos = "CCTcodigo,Ddocumento"
						desplegables = "S,S" 
						modificables = "N,S"
						size = "5,25"
						valuesarray="#valuesArray#" 
						tabla="Documentos a, CCTransacciones b, Monedas c, CContables d"
						columnas="a.CCTcodigo, a.Ddocumento, a.Mcodigo as McodigoE, a.Ccuenta as CcuentaE, c.Mnombre, d.Cdescripcion, a.Dsaldo, b.CCTdescripcion,
								  a.Ddocumento , coalesce(a.Dtcultrev, a.Dtipocambio) as EFtipocambio, a.Dtotal, a.Dsaldo as SaldoEncabezado, Dfecha"
						filtro="a.Ecodigo = #Session.Ecodigo# 
								  and a.SNcodigo =  $SNcodigo,numeric$
								  and a.Dsaldo > 0 
								  and b.Ecodigo   = a.Ecodigo 
								  and b.CCTcodigo = a.CCTcodigo 
								  and b.CCTtipo = 'C' 
								  and ((coalesce(b.CCTpago,0)=1 and coalesce(b.CCTanticipo,0)=0) or (coalesce(b.CCTpago,0)= 0 and coalesce(b.CCTanticipo,0)=1))
								  and c.Mcodigo = a.Mcodigo 
								  and d.Ccuenta = a.Ccuenta 
								  and d.Ecodigo = a.Ecodigo
								  and not exists(
												select 1 from EFavor z
												where z.Ecodigo = a.Ecodigo
												  and z.CCTcodigo = a.CCTcodigo
												  and z.Ddocumento = a.Ddocumento
												) "
						desplegar="CCTcodigo,Ddocumento,Dfecha,Mnombre,Dtotal,Dsaldo"
						filtrar_por="a.CCTcodigo,Ddocumento,Dfecha,c.Mnombre,Dtotal,Dsaldo"
						etiquetas="#LB_Transaccion#,#LB_Documento#,#LB_Fecha#,#LB_Moneda#,#LB_Monto#,#LB_Saldo#"
						formatos="S,S,D,S,M,M"
						align="left,left,left,left,right,right"
						asignar="CCTcodigo,Ddocumento,Mnombre,EFtipocambio,SaldoEncabezado,McodigoE,CcuentaE"
						asignarformatos="S,S,S,F,M,S,S"
						left="125"
						top="100"
						width="750"
						tabindex="1">
					<cfelse>
						<input name="CCTcodigo" type="hidden" value="#rsDocumento.CCTcodigo#">
						<input name="Ddocumento" type="hidden" value="#rsDocumento.Ddocumento#">
						<strong>#rsDocumento.CCTcodigo# - #rsDocumento.Ddocumento#</strong>
					</cfif>
				</td>
              	<td width="5%" nowrap align="right"><strong>#LB_Fecha#:&nbsp;</strong></td>
              	<td width="18%" nowrap>
					<cfif modo NEQ "ALTA">
						<cfset fecha = rsDocumento.EFfecha>
					<cfelse>
						<cfset fecha = Now()>
					</cfif>
					<cf_sifcalendario name="EFfecha" value="#DateFormat(fecha,'dd/mm/yyyy')#" tabindex="1">
					<input type="hidden" name="_EFfecha" value="<cfif modo NEQ "ALTA">#DateFormat(rsDocumento.EFfecha,'dd/mm/yyyy')#</cfif>">
				</td>
                </cfoutput>
            </tr>

            <tr> 
              <td nowrap align="right"><strong><cfoutput>#LB_Moneda#:&nbsp;</cfoutput></strong></td>
              <td nowrap><input name="Mnombre" tabindex="-1"  value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Mnombre#</cfoutput></cfif>"  style="text-align:left" type="text" class="cajasinborde" size="15" readonly=""> 
              </td>
              <td nowrap align="right"><strong><cfoutput>#LB_Tipo_de_Cambio#:&nbsp;</cfoutput></strong></td>
              <td nowrap><input name="EFtipocambio" tabindex="1" style="text-align:right" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EFtipocambio#</cfoutput></cfif>" <cfif modo NEQ "ALTA">disabled</cfif> size="20" maxlength="20" onfocus="this.value=qf(this); this.select();" onblur="fm(this,4);"  onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" > 
              </td>
              <td nowrap align="right"><strong><cfoutput>#LB_Saldo#:&nbsp;</cfoutput></strong></td>
			  
<cfif GSaldo GT 0>			  
              <td nowrap><input name="SaldoEncabezado" tabindex="-1"  value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsCalculaSaldo.Dsaldo,'none')#</cfoutput></cfif>"  style="text-align: right" type="text" class="cajasinborde" size="20"  maxlength="18"  onfocus="this.value=qf(this); this.select();" onblur="fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" readonly> 
              </td>
<cfelse>			  	
              <td nowrap><input name="SaldoEncabezado" tabindex="-1"  value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(GSaldo,'none')#</cfoutput></cfif>"  style="text-align: right" type="text" class="cajasinborde" size="20"  maxlength="18"  onfocus="this.value=qf(this); this.select();" onblur="fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" readonly> 
              </td>
</cfif>			  

            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp; </td>
              <td nowrap> <cfset tsE = ""> 
              <cfif modo NEQ "ALTA">
                  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE">
                  </cfinvoke>
              </cfif></td>
              <td nowrap> 
				<input type="hidden" name="McodigoE" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Mcodigo#</cfoutput></cfif>"> 
                <input type="hidden" name="ECselect" value="0"> <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>"> 
                <input type="hidden" name="Aplicado" value="<cfif modo NEQ "ALTA"><cfoutput>#rsAplicado.DFmonto#</cfoutput></cfif>"> 
            <td nowrap align="right"><strong><cfoutput>#LB_Disponible#:&nbsp;</cfoutput></strong></td>
			<cfparam name="sdisponible" default="0.00">
			<cfif modo NEQ "ALTA">
				<cfquery name="rsDisponible" datasource="#Session.DSN#">
					select  a.CCTcodigo , rtrim(a.Ddocumento) as Ddocumento, sum(b.DFmonto) as MontoDet , round(c.Dsaldo - sum(b.DFmonto),2) as disponible
					from EFavor a, DFavor b, Documentos c
					where a.Ecodigo    					= #Session.Ecodigo# 
					  and rtrim(ltrim(a.CCTcodigo)) 	= <cfqueryparam cfsqltype="cf_sql_char" value="#CCTcodigo#"> 
					  and rtrim(ltrim(a.Ddocumento)) 	= rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Ddocumento#">)
					  and a.Ecodigo 					= b.Ecodigo
					  and a.CCTcodigo  					= b.CCTcodigo
					  and rtrim(a.Ddocumento) 			= rtrim(b.Ddocumento)
				  	  and a.Ecodigo 					= c.Ecodigo
					  and a.CCTcodigo 					= c.CCTcodigo
					  and rtrim(a.Ddocumento) 			= rtrim(c.Ddocumento)
					group by a.CCTcodigo, a.Ddocumento, c.Ecodigo, c.CCTcodigo, c.Ddocumento, c.Dsaldo
				</cfquery>	
			</cfif>			
			<cfif isdefined("rsDisponible") and rsDisponible.recordcount neq 0>
				<cfset sdisponible = #LSCurrencyFormat(rsDisponible.disponible,'none')#>
			</cfif>
			<cfoutput>
              <td nowrap>
				<input type="text" name="disponible" value="#sdisponible#" class="cajasinborde" style="text-align: right" readonly size="20" maxlength="18">
				<cfif isdefined("rsDisponible") and rsDisponible.recordcount eq 0>
					<script language="JavaScript">
						document.form1.disponible.value = document.form1.SaldoEncabezado.value;
					</script>
				</cfif>
			  </td>
			 </cfoutput>
            </tr>
          <tr><td>&nbsp;</td></tr>
		  <tr align="center">
            <cfoutput>
            <td colspan="6"> 
              <cfif modo EQ "ALTA">
                 <font size="2"> 
                    <input name="AgregarE" 		type="submit" value="#BTN_Agregar#"  		   tabindex="1"  class="btnGuardar"  onclick="javascript:setBtn(this);">
                    <input name="Regresar" 		type="button" value="#BTN_Regresar#" 		   tabindex="1"  class="btnAnterior" onclick="javascript:Lista();">
                 </font> 		
				 <cfelse>		 
                    <input name="CambiarE" 		type="submit" value="#BTN_Cambiar#"  		   tabindex="1"  class="btnGuardar"  onclick="javascript:setBtn(this);deshabilitarValidacion(this.name);" style="display:none;">
                    <input name="F5" 			type="hidden" value="0">
				 <cfif (modo NEQ "ALTA" and rsDisponible.disponible GT 0) or (rsDisponible.RecordCount EQ 0)>
					<input name="btn_selMasiva" type="button" value="#BTN_SelMasiva#" tabindex="1"  class="btnNormal"   onClick="javascript: funcPantallaSeleccion();">
				</cfif>
	                <input name="NuevoE"  		type="submit" value="#BTN_NvoDocto#"  tabindex="1"  class="btnNuevo"    onclick="javascript: setBtn(this); deshabilitarValidacion(this.name); funcNuevoE();">
					<input name="BorrarE" 		type="submit" value="#BTN_Eliminar_Documento#" tabindex="1"  class="btnEliminar" onclick="javascript: setBtn(this); deshabilitarValidacion(this.name); return confirm('¿#MSG_ConfirmBorra#?')">
				<cfif rsLineas.RecordCount GT 0 >
					<cfif GSaldo EQ 1>
					<input name="Aplicar" 		type="submit" value="#BTN_Aplicar#" 		   tabindex="1"  class="btnAplicar"  onclick="javascript:setBtn(this); deshabilitarValidacion(this.name); return Postear();">
					</cfif>
				</cfif>
					<input name="ListaE"  		type="button" value="#BTN_Regresar#"         tabindex="1"  class="btnAnterior" onclick="javascript:Lista();">

			  </cfif>
            </td>
          </cfoutput>
          </tr>
		  <tr><td>&nbsp;</td></tr>
			<cfif modo neq "ALTA">
            <tr> 
            <cfoutput>
            <cfset LB_TituloAlterno = t.Translate('LB_TituloAlterno','Detalle del Documento')>
              <td colspan="6" class="tituloAlterno"><strong>#LB_TituloAlterno#</strong></td>
            </cfoutput>
            </tr>
			</cfif>
          </table>
        </td>
    </tr>
    <cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
      <tr> 
      	<cfoutput>
        <td> 
          <table width="100%" border="0" cellpadding="0" cellspacing="0" >
            <tr> 
              <td width="25%" align="right" nowrap><strong>#LB_Documento#:&nbsp;</strong></td>
              <td width="25%" nowrap> 
				<cfif modoDet NEQ "ALTA">
					<cf_sifDocsPagoCxC query="#rsDatosConlis#" form="form1" tabindex="1">
				<cfelse>
					<cf_sifDocsPagoCxC form="form1" tabindex="1">
				</cfif>
              <td width="25%" align="right" nowrap> 
               <cfset LB_MontoMonedaDoc = t.Translate('LB_MontoMonedaDoc','Monto en moneda del documento')>
                <p> <strong>#LB_MontoMonedaDoc#:&nbsp;</strong> </p>
              </td>
              <td width="25%" nowrap> 
                <input name="DFmontodoc"  tabindex="1"  onblur="javascript: redondear(parseFloat(fm(this,2))); validaSaldo(this.form); " 
				style="text-align:right" 
				type="text"  
				onchange="javascript: validaSaldo(this.form);" 
				alt="#LB_MontoMonedaDoc#" 
				value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#LSCurrencyFormat(rsDdocumento.DFmontodoc,'none')#</cfif>"  
				size="20"  
				maxlength="18" 
				onfocus="this.value=qf(this); this.select();" 
				onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and (rsDdocumento.DFtipocambio EQ 1 or rsDdocumento.DFtipocambio EQ rsDocumento.EFtipocambio)>disabled<cfelseif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
              </td>
            </tr>
            <tr> 
               <cfset LB_SaldoMonedaDoc = t.Translate('LB_SaldoMonedaDoc','Saldo en moneda del documento')>
              <td align="right" nowrap><strong>#LB_SaldoMonedaDoc#:&nbsp;</strong></td>
              <td nowrap > 
                <p> 
                  <input name="DsaldoD" tabindex="-1"  value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.Dsaldo,'none')#</cfif>"  style="text-align:left" type="text" class="cajasinborde" size="20"  maxlength="18"  readonly="">
                </p>
              </td>
              <td align="right" nowrap><strong>#LB_MontoMoneda#:&nbsp;</strong></td>
              <td nowrap> 
                <input name="DFmonto" type="text"  tabindex="1"  
					onblur="javascript: fm(this,2); validaSaldo(this.form);" 
					onchange="javascript: validaSaldo(this.form);" 
					style="text-align:right" 
					alt="el monto de la moneda del pago" 
					value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsDdocumento.DFmonto,'none')#</cfif>" 
					size="20"  
					maxlength="18" 
					onfocus="this.value=qf(this); this.select();" 
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
              </td>
            </cfoutput>  
            </tr>
            <tr align="right"> 
              <td colspan="4" nowrap> 
                <cfset tsD = "">
                <cfif modoDet NEQ "ALTA">
                  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsDdocumento.ts_rversion#" returnvariable="tsD">
                  </cfinvoke>
                </cfif>
                <input type="hidden" name="CCTRcodigo" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.CCTRcodigo#</cfoutput></cfif>">
                <input type="hidden" name="DRdocumento" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.DRdocumento#</cfoutput></cfif>">
                <input type="hidden" name="CcuentaD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.Ccuenta#</cfoutput></cfif>">
                <input type="hidden" name="DFtipocambio" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.DFtipocambio#</cfoutput></cfif>">
                <input type="hidden" name="DFtotal" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.DFtotal#</cfoutput></cfif>">
                <input type="hidden" name="SNcodigoD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.SNcodigo#</cfoutput></cfif>">
                <input type="hidden" name="McodigoD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.Mcodigo#</cfoutput></cfif>">
                <input type="hidden" name="timestampD" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#tsD#</cfoutput></cfif>">
                <input name="FC" type="hidden" id="FC" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsDdocumento.DFtipocambio EQ 1><cfoutput>iguales</cfoutput><cfelseif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsDdocumento.DFtipocambio EQ rsDocumento.EFtipocambio><cfoutput>encabezado</cfoutput><cfelse><cfoutput>calculado</cfoutput></cfif>">
                <input type="hidden" name="DFmontoAnteriorDetalle" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsDdocumento.DFmonto#</cfoutput></cfif>">
              </td>
            </tr>
			<tr><td>&nbsp;</td></tr>
            <tr align="center"> 
            <cfoutput>
              <td colspan="4"> 
               <cfset BTN_BorrarDet = t.Translate('BTN_BorrarDet','Borrar Detalles')>
               <cfset MSG_BorrarDet = t.Translate('MSG_BorrarDet','Realmente desea borrar todos los detalles del Documento')>
               <cfset BTN_BorrarLinea = t.Translate('BTN_BorrarLinea','Borrar Linea')>
               <cfset MSG_BorrarLinea = t.Translate('MSG_BorrarLinea','Realmente desea borrar esta línea del documento')>
               
                <cfif modoDet EQ "ALTA">
                  <input name="AgregarD"   type="submit"  value="#BTN_Agregar#" 	      class="btnGuardar"  tabindex="1" onclick="javascript:setBtn(this);">
				  <input name="BorrarDD"   type="submit"  value="#BTN_BorrarDet#" class="btnEliminar" tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('¿#MSG_BorrarDet#?')">
                  <input name="Montolinea" type="hidden"  value="0">
                  <cfelse>
                  <input name="Montolinea" type="hidden" value="#rsMontolinea.DFmonto#">
                  <input name="CambiarD"   type="submit" value="#BTN_Cambiar#" 	 	  class="btnGuardar"   tabindex="1" onclick="javascript: setBtn(this);">
                  <input name="BorrarD"    type="submit" value="#BTN_BorrarLinea#" 	   class="btnEliminar" tabindex="1" onclick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('¿#MSG_BorrarLinea#?')">
                </cfif>
              </td>
           	</cfoutput>   
            </tr>
			<tr><td>&nbsp;</td></tr>
          </table>
          </td>
      </tr>
    </cfif>
  </table>

	<!--- Navegacion para la lista de Pagos (principal) --->
	<cfoutput>
	<input type="hidden" name="pageNum_rsDocumentos" value="<cfif isdefined('form.pageNum_rsDocumentos') and len(trim(form.pageNum_rsDocumentos))>#form.pageNum_rsDocumentos#<cfelse>1</cfif>" />
	<input type="hidden" name="descripcion" 			value="<cfif isdefined('form.descripcion') and len(trim(form.descripcion))>#form.descripcion#</cfif>" />
	<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
	<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />	
	<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />	
	<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />	
	</cfoutput>


  </form>

<cfset MSG_AplicarDocto = t.Translate('MSG_AplicarDocto','Desea aplicar este documento')>
<cfset MSG_ElCampo = t.Translate('MSG_ElCampo','El campo')>
<cfset MSG_NoPuedeSer0 = t.Translate('MSG_NoPuedeSer0','no puede ser cero')>
<cfset MSG_MontoDig = t.Translate('MSG_MontoDig','El monto digitado supera el saldo del documento, debe ser inferior o igual a')>
<cfset MSG_MontoLin = t.Translate('MSG_MontoLin','El monto de las líneas de detalle supera el saldo del documento')>

<script language="JavaScript">
	<cfif modo NEQ "ALTA" and modoDet EQ "ALTA">
		validatcLOAD(document.form1);
	</cfif>
	
	
	<cfoutput>
	function Postear(){
		if (confirm('¿#MSG_AplicarDocto#?')) {
			document.form1.CCTcodigo.value = "#CCTcodigo#";
			document.form1.Ddocumento.value = "#Ddocumento#";			
			document.form1.action="AplicaDocsAfavorPagosAnticipos.cfm";
			return true;
		} 
		else return false; 	
	}
	</cfoutput>
	function funcNuevoE(){
		document.form1.CCTcodigo.value = '';
		document.form1.Ddocumento.value = '';
		document.form1.action="AplicaDocsAfavorPagosAnticipos.cfm";
		return true;
	}

	function deshabilitarValidacion(boton) {
		objForm.EFfecha.required = false;
		<cfif modoDet EQ "ALTA">
			objForm.DTM.required = false;
		</cfif>
		objForm.DFmonto.required = false;
		objForm.DFmontodoc.required = false;
	}
	<cfoutput>
	function __isNotCero() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.disabled) && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.obj.focus();
			this.error = "#MSG_ElCampo# " + this.description + " #MSG_NoPuedeSer0#!";
		}
	}
	// Se aplica sobre el monto del documento
	function __isMontoDoc() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida Monto de Documento contra saldo del documento
			if ((new Number(qf(this.obj.form.DFmontodoc.value))) > (new Number(qf(this.obj.form.DsaldoD.value)))) {
				if (!this.obj.form.DFmontodoc.disabled) this.obj.form.DFmontodoc.focus();
				else this.obj.form.DFmonto.focus();
				this.error = "#MSG_MontoDig# " + this.obj.form.DsaldoD.value;
			}
		}
	}
	// Se aplica sobre el monto del documento
	function __isMontoPago() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			var LvarMontoAnterior = 0.00;
			if (btnSelected("CambiarD")) {
				LvarMontoAnterior = document.form1.DFmontoAnteriorDetalle.value;
			}
			// Valida que el Pago sea menor al disponible en el documento de pago
			//if (redondear(parseFloat(qf(this.obj.form.DAmonto.value))+parseFloat(qf(this.obj.form.Aplicado.value)),2) > new Number(qf(this.obj.form.SaldoEncabezado.value))) {
			if (redondear(parseFloat(qf(this.obj.form.DFmonto.value))+parseFloat(qf(this.obj.form.Aplicado.value)) - parseFloat(LvarMontoAnterior),2) > new Number(qf(this.obj.form.SaldoEncabezado.value))) {
				this.obj.form.DFmonto.focus();
				this.error = "#MSG_MontoLin#!";
			}
		}
	}
	</cfoutput>
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isMontoDoc", __isMontoDoc);
	_addValidator("isMontoPago", __isMontoPago);
	objForm = new qForm("form1");
	<cfoutput>
	<cfif modo EQ "ALTA">
		objForm.SNcodigo.required = true;
		objForm.SNcodigo.description = "#LB_CLIENTE#";
		objForm.CCTcodigo.required = true;
		objForm.CCTcodigo.description = "#LB_Transaccion#";
		objForm.EFfecha.required = true;
		objForm.EFfecha.description = "#LB_Fecha#";
	<cfelseif modo EQ "CAMBIO">
		objForm.EFfecha.required = true;
		objForm.EFfecha.description = "#LB_Fecha#";

		<cfif modoDet EQ "ALTA">
			objForm.DTM.required = true;
			objForm.DTM.description = "#LB_Documento#";
		</cfif>

		objForm.DFmonto.required = true;
		objForm.DFmonto.description = "#LB_MontoMoneda#";
		objForm.DFmonto.validateNotCero();
		//objForm.DFmonto.validateMontoPago();
		objForm.DFmontodoc.required = (!objForm.DFmontodoc.obj.disabled);
		objForm.DFmontodoc.description = "#LB_MontoMonedaDoc#";
		objForm.DFmontodoc.validateNotCero();
		objForm.DFmontodoc.validateMontoDoc();
	</cfif>
	</cfoutput>
	<cfif modo EQ 'CAMBIO' and modoDet EQ 'ALTA'>
		document.form1.CCTcodigoConlis.focus();
	<cfelseif modo EQ 'ALTA'>
		document.form1.SNnumero.focus();
	<cfelseif modo NEQ 'ALTA' and modoDet NEQ 'ALTA'>
		document.form1.CCTcodigoConlis.focus();
	</cfif>
</script>
