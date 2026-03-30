	function fnEnterToDefault (objEvent,objForm)
	{
		var LvarKey = (objEvent.keyCode) ? objEvent.keyCode : objEvent.which;
		var objButton;
		<cfif modo EQ "ALTA">
			objButton = objForm.AltaNueva;
		<cfelse>	
			<cfif mododet EQ "ALTA">
			objButton = objForm.Altadet;
			<cfelse>			
			objButton = objForm.Cambiodet;
			</cfif>
		</cfif>
		if (LvarKey == 13) {
			if (objButton) objButton.click();
			return false;
		} else 
			return true;
	}
	function validar(){
		objform1.CJX20FEF.required 	= true;
		objform1.DEPCOD.required 	= true;
		objform1.CP9COD.required 	= true;
		//objform1.PROCED.required 	= true;
		objform1.EMPCED.required 	= true;
		objform1.EMPCOD.required 	= true;
		//objform1.CJX20NUF.required 	= true;
	
		//Detalle
		validardet();
	}

	function validardet(){
		objform1.CJX21DSC.required 	= true;
		objform1.CGM1CD.required = true;
		objform1.CJM16COD.required = true;
	}
	
	function novalidar(){
		objform1.CJX20FEF.required 	= false;
		objform1.DEPCOD.required 	= false;
		objform1.CP9COD.required 	= false;
		objform1.PROCED.required 	= false;
		objform1.EMPCED.required 	= false;
		objform1.EMPCOD.required 	= false;
		objform1.CJX20NUF.required 	= false;
		objform1.PR1COD.required 	= false;
		objform1.PRT7IDE.required 	= false;
	
		//Detalle
		novalidardet();
	}

	function novalidardet(){
		objform1.CJX21DSC.required 	= false;
		objform1.CGM1CD.required = false;
		objform1.CJM16COD.required = false;

	}
	
	function finalizar(){
		document.form1.CJX20NUM.disabled = false;
		document.form1.CJX20TOT.disabled = false;
		document.form1.NETO.disabled 	 = false;
		document.form1.CJX20IMP.disabled = false;	
		document.form1.CJX20MNT.disabled = false;
		/////
		document.form1.NOMBRE.disabled = false;
		document.form1.DEPDES.disabled = false;
		document.form1.CP9DES.disabled = false;
		/////
		document.form1.CJX20TOT.value = qf(document.form1.CJX20TOT)
		document.form1.CJX20MUL.value = qf(document.form1.CJX20MUL)
		document.form1.CJX20DES.value = qf(document.form1.CJX20DES)
		document.form1.CJX20RET.value = qf(document.form1.CJX20RET)
		document.form1.CJX20IMP.value = qf(document.form1.CJX20IMP)
		document.form1.CJX20MNT.value = qf(document.form1.CJX20MNT)
		if (finalizardet())
		{
		  return true;
		}
		else
		{
			document.form1.CJX20NUM.disabled = true;
			document.form1.CJX20TOT.disabled = true;
			document.form1.NETO.disabled 	 = true;
			document.form1.CJX20IMP.disabled = true;	
			document.form1.CJX20MNT.disabled = true;
			/////
			document.form1.NOMBRE.disabled = true;
			document.form1.DEPDES.disabled = true;
			document.form1.CP9DES.disabled = true;
			return false;
		}
	}
	function validaREL(){
		<!---********************************************* --->
		<!--- se invoca el mismo cfm por medio de submit() --->
		<!--- para refrescar la lista segun la relacion    --->
		<!--- que se selecciona en el combo                --->
		<!---********************************************* --->
		top.frames['workspace'].location.href = "../operacion/cjc_PrincipalGasto.cfm?modo=ALTA&CJX19REL="+document.form1.CJX19REL.value
		/*
		doc = document.form1 ;
		doc.action = "";
		doc.submit();
		*/
	}
	
	function validaProv (){
		if (document.form1.CJX20TIP.value == "V"){
			document.form1.CJX20FEF.focus()
		}
	}
	
	function validaFac (){
		if (document.form1.CJX20TIP.value == "V"){
			document.form1.CJX20MUL.focus()
		}
	}
	
	function Cantidad_valida(){
		var Cantidad = new Number(this.value)	
		if ( Cantidad <= 0){
			this.error = "La cantidad debe ser mayor a cero";
		}		
	}
	
	function finalizardet() {
		document.form1.CJX19REL.disabled 	= false;
		document.form1.CJX20NUM.disabled 	= false;	
		document.form1.CJX21LIN.disabled 	= false;
		document.form1.CJX21MDU.value = qf(document.form1.CJX21MDU)
		document.form1.CJX21CAN.value = qf(document.form1.CJX21CAN)
		/*
		if (document.form1.CJX21CAN.value == '' || document.form1.CJX21CAN.value <= 0)
			return false;*/

		if (!objform1.CGM1CD.required)
		  return true;
		else if (document.form1.errorFlag.value == '0') // Se empieza la ejecución
		{
			document.form1.errorFlag.value = '1';  // La ejecución está en proceso
			validacampos();
			if (document.form1.errorFlag.value == '3')   // Hubo Error
			{
				document.form1.errorFlag.value = '0';
				alert(document.form1.error.value);
			}
		}
		else if (document.form1.errorFlag.value == '2') // La validación es correcta
		{
			document.form1.errorFlag.value = '0';
			return true;
		}
		else if (document.form1.errorFlag.value == '3') // value == '3': Hubo un error de validacion
		{											
				document.form1.errorFlag.value = '0';
				alert(document.form1.error.value);
		}
		// No ha pasado por Validación correcta
		document.form1.CJX19REL.disabled 	= true;
		document.form1.CJX20NUM.disabled 	= true;	
		document.form1.CJX21LIN.disabled 	= true;
		return false;
	}
	
	seleccionado('GAT');
	<!---*************************************************************************************************** --->
	function AgregarComboGR(combo,codigo) {
		var cont = 0;
		var valor = "";
		combo.length=0;
		document.form1.CGM1ID.value = '';
		document.form1.CGM1IM.value = '';
		document.form1.CGM1CD.value = '';			
		<cfoutput query="rsGRUPO">
			combo.length=cont+1;
	
			combo.options[cont].value='#rsGRUPO.LLAVE#';
			combo.options[cont].text='#rsGRUPO.DES#';
			<cfif mododet NEQ "ALTA" and #rsGRUPO.LLAVE# EQ #TraeSqlDet.CJM12ID#>
				combo.options[cont].selected=true;
			</cfif> 
			cont++;
		</cfoutput>
		AgregarComboCTA(document.form1.PR1COD,document.form1.CJM13ID.value);
	}
	
	function AgregarComboSG(combo,codigo) {
		var cont = 0;
		var valor = "";
		combo.length=0;
		<cfoutput query="rsSG">
			if (#Trim(rsSG.CJM12ID)#==codigo) 
			{
				combo.length=cont+1;
				if(combo.length == 1){
					valor = '#rsSG.CJM07COD#';
				}
				combo.options[cont].value='#rsSG.LLAVE#';
				combo.options[cont].text='#rsSG.DES#';
				<cfif mododet NEQ "ALTA" and #rsSG.LLAVE# EQ #TraeSqlDet.CJM13ID#>
					combo.options[cont].selected=true;
				</cfif> 
				cont++;
			};
		</cfoutput>
		ActivaDet(valor)
		AgregarComboCTA(document.form1.PR1COD,document.form1.CJM13ID.value)
	}
	<!---*************************************************************************************************** --->
	function AgregarComboCTA(combo,codigo) {
		var cont = 0;
		var SEG = document.form1.CGE5COD.value;
		combo.length=0;
		<cfoutput query="rsSG">
			if ((#Trim(rsSG.LLAVE)#==codigo) && (#Trim(rsSG.CJM12ID)# == document.form1.CJM12ID.value)) 
			{
				document.form1.CP6RUB.value = '#rsSG.CP6RUB#';
				document.form1.CP7SUB.value = '#rsSG.CP7SUB#';
				document.form1.CJM07COD.value = '#rsSG.CJM07COD#';
			};
		</cfoutput>
		ActivaDet(document.form1.CJM07COD.value)
		<cfoutput query="rsCTA">
			if ((#rsCTA.CGE5COD#==document.form1.CGE5COD.value) && (#Trim(rsCTA.CP6RUB)#==document.form1.CP6RUB.value) &&(#Trim(rsCTA.CP7SUB)#==document.form1.CP7SUB.value)) {
				combo.length=cont+1;
				combo.options[cont].value='#rsCTA.LLAVE#';
				combo.options[cont].text='#rsCTA.DES#';
				<cfif mododet NEQ "ALTA" and #rsCTA.LLAVE# EQ #TraeSqlDet.PR1COD#>
					combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
		AgregarComboPROY(document.form1.PRT7IDE,document.form1.PR1COD.value)
	}
	<!---*************************************************************************************************** --->
	function AgregarComboPROY(combo,codigo) {
		var cont = 0;
		combo.length=0;

		<cfoutput query="rsPROY">
			if (#Trim(rsPROY.PR1COD)#==codigo) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsPROY.LLAVE#';
				combo.options[cont].text='#rsPROY.DES#';
				<cfif mododet NEQ "ALTA" and #rsPROY.LLAVE# EQ #TraeSqlDet.PRT7IDE#>
					combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
		Cargar_CN();
	}
	function Cargar_CN() {
		document.form1.CGM1ID.value = '';
		document.form1.CGM1IM.value = '';
		document.form1.CGM1CD.value = '';
		<cfoutput query="rsCTA">
			if ((#Trim(rsCTA.LLAVE)#==document.form1.PR1COD.value) && (#Trim(rsCTA.PRT7IDE)#==document.form1.PRT7IDE.value) && (#rsCTA.CGE5COD#==document.form1.CGE5COD.value) && (#Trim(rsCTA.CP6RUB)#==document.form1.CP6RUB.value) &&(#Trim(rsCTA.CP7SUB)#==document.form1.CP7SUB.value)) {
				document.form1.CGM1ID.value = '#rsCTA.CGM1ID#';
				document.form1.CGM1IM.value = '#rsCTA.CGM1IM#';
				document.form1.CGM1CD.value = '#rsCTA.CGM1CD#';
			};
		</cfoutput>		
		if (document.cajaNegra)
			llenacaja();	
	}
	<!---*************************************************************************************************** --->
	function ActivaDet(item) {
		document.form1.CJM07COD.value = item;
		var ACFI  = document.getElementById("ACFI")
		var CA06  = document.getElementById("CA06")
		var CA01  = document.getElementById("CA01")
		var CA02  = document.getElementById("CA02")
		var CA07  = document.getElementById("CA07")
		var C1 	  = document.getElementById("C1")
		var C2    = document.getElementById("C2")
		var CA03  = document.getElementById("CA03")
		var C4    = document.getElementById("C4")
		var CA04  = document.getElementById("CA04")
		var CA05  = document.getElementById("CA05")
		var C3    = document.getElementById("C3")
		var TRAN2 = document.getElementById("TRAN2")
		var TRANS = document.getElementById("TRANS")
		if (item == "ACFI") {
			objform1.AF4PL.required = true;
			objform1.AF4PL.description="Placa";
			objform1.AF25C.required = true;
			objform1.AF25C.description="Cédula";
			objform1.AF2CA.required = false;
			objform1.AF2CA.description="Categoría";	
			objform1.AF3CO.required = false;
			objform1.AF3CO.description="Clase";
			objform1.CENFU.required = false;
			objform1.CENFU.description="Centro Func.";
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;				
			
			ACFI.style.display 	= ""
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"	
		}
		else if (item == "CA01") {
			objform1.CEDF.required = true;
			objform1.CEDF.description="Céd. Fisica";
			objform1.EMPL.required = false;
			objform1.EMPL.description="Empleado";
			objform1.VALE.required = true;
			objform1.VALE.description="Vale";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;				
			
			ACFI.style.display 	= "none"
			CA06.style.display 	= ""
			CA01.style.display 	= ""
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= ""
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"	
		}
		else if (item == "CA02") {
			objform1.ORDEN.required = true;
			objform1.ORDEN.description="Orden de Compra";
			objform1.NOME.required = true;
			objform1.NOME.description="Empresa";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;		
		
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= ""
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"	
		}
		else if (item == "CA03") {
			objform1.TIPEN.required = true;
			objform1.TIPEN.description="Tipo Entidad";
			objform1.NUM.required = true;
			objform1.NUM.description="Número";
			objform1.NOM.required = true;
			objform1.NOM.description="Nombre";
			objform1.RECIB.required = true;
			objform1.RECIB.description="Recibo";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;
	
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= ""
			CA03.style.display 	= ""
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= ""	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"	
		}		
		else if (item == "CA04") {
			objform1.TIPEN.required = true;
			objform1.TIPEN.description="Tipo Entidad";
			objform1.NUMEN.required = true;
			objform1.NUMEN.description="Número";
			objform1.NOMEN.required = true;
			objform1.NOMEN.description="Nombre";				
			objform1.TIPDO.required = true;
			objform1.TIPDO.description="Tipo Documento";
			objform1.DOC.required = true;
			objform1.DOC.description="Documento";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;
	
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= ""
			CA03.style.display 	= "none"
			C4.style.display 	= ""
			CA04.style.display 	= ""	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"
		}
		else if (item == "CA05") {
			objform1.TIPEN.required = true;
			objform1.TIPEN.description="Tipo Entidad";
			objform1.NUMEN.required = true;
			objform1.NUMEN.description="Número";
			objform1.NOMEN.required = true;
			objform1.NOMEN.description="Nombre";			
			objform1.NUMRE.required = true;
			objform1.NUMRE.description="Número Recibo";
			objform1.FECRE.required = true;
			objform1.FECRE.description="Fecha Recibo";			
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;
	
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= ""
			CA03.style.display 	= "none"
			C4.style.display 	= ""
			CA04.style.display 	= "none"	
			CA05.style.display 	= ""	
			C3.style.display 	= ""	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"
		}
		else if (item == "CA06") {
			objform1.CEDF.required = true;
			objform1.CEDF.description="Céd. Fisica";
			objform1.EMPL.required = false;
			objform1.EMPL.description="Empleado";			
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;
	
			ACFI.style.display 	= "none"
			CA06.style.display 	= ""
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"		
		}
		else if (item == "CA07") {
			objform1.ORDEN.required = true;
			objform1.ORDEN.description="Orden de Compra";
			objform1.NOME.required = true;
			objform1.NOME.description="Empresa";
			objform1.POLIZ.required = true;
			objform1.POLIZ.description="No. Poliza";
			objform1.FECHA.required = true;
			objform1.FECHA.description="Fecha";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;				
	
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= ""
			CA07.style.display 	= ""
			C1.style.display 	= ""
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"		
		}
		else if (item == "TRAN2") {
			objform1.NOVEH.required = true;
			objform1.NOVEH.description="No. Vehículo";
			objform1.KILOM.required = true;
			objform1.KILOM.description="Kilometraje";
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.CANT.required = false;				
		
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = ""	
			TRANS.style.display = "none"
		}
		else if (item == "TRANS") {
			objform1.NOVEH.required = true;
			objform1.NOVEH.description="No. Vehículo";
			objform1.KILOM.required = true;
			objform1.KILOM.description="Kilometraje";
			objform1.CANT.required = true;
			objform1.CANT.description="Cantidad Lts."				
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
					
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = ""	
			TRANS.style.display = ""
		}
		else {
			objform1.AF4PL.required = false;
			objform1.AF25C.required = false;
			objform1.AF2CA.required = false;
			objform1.AF3CO.required = false;
			objform1.CENFU.required = false;
			objform1.CEDF.required = false;
			objform1.EMPL.required = false;
			objform1.VALE.required = false;
			objform1.ORDEN.required = false;
			objform1.NOME.required = false;
			objform1.POLIZ.required = false;
			objform1.FECHA.required = false;
			objform1.TIPEN.required = false;
			objform1.NUM.required = false;
			objform1.NOM.required = false;
			objform1.RECIB.required = false;
			objform1.NUMEN.required = false;
			objform1.NOMEN.required = false;
			objform1.TIPDO.required = false;
			objform1.DOC.required = false;
			objform1.NUMRE.required = false;
			objform1.FECRE.required = false;
			objform1.NOVEH.required = false;
			objform1.KILOM.required = false;
			objform1.CANT.required = false;			
			ACFI.style.display 	= "none"
			CA06.style.display 	= "none"
			CA01.style.display 	= "none"
			CA02.style.display 	= "none"
			CA07.style.display 	= "none"
			C1.style.display 	= "none"
			C2.style.display 	= "none"
			CA03.style.display 	= "none"
			C4.style.display 	= "none"
			CA04.style.display 	= "none"	
			CA05.style.display 	= "none"	
			C3.style.display 	= "none"	
			TRAN2.style.display = "none"	
			TRANS.style.display = "none"	
		}	
	
	}
	
	<!---*************************************************************************************************** --->
	
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	
	qFormAPI.errorColor = "#FFFFCC";
	
	objform1 = new qForm("form1");
	objform1.CJX20FEF.required = true;
	objform1.EMPCED.description="Empleado";	
	objform1.EMPCOD.description="ID Empleado";	  
	objform1.DEPCOD.required = true;
	objform1.DEPCOD.description="Centro Funcional";	 
	objform1.CP9COD.required = true;
	objform1.CP9COD.description="Autorizador";	
	objform1.PROCED.required = true;
	objform1.PROCED.description="Proveedor";
	objform1.CJX20FEF.description="Fecha";
	objform1.EMPCED.required = true;
    objform1.EMPCOD.required 	= true;
	objform1.CJX20NUF.required = true;
	objform1.CJX20NUF.description="Factura"; 
	
	//Detalle
	objform1.CJX21CAN.required = true;
	objform1.CJX21CAN.description="Cantidad";	
	objform1.CJX21MDU.required = true;
	objform1.CJX21MDU.description="Monto";	
	objform1.CJX21DSC.required = true;
	objform1.CJX21DSC.description="Descripción";	
	objform1.CJM16COD.required = true;
	objform1.CJM16COD.description="Orden de servicio";	
	objform1.CGM1CD.required = true;
	objform1.CGM1CD.description="Cuenta no valida";	 
	objform1.CGE5COD.required = true;
	objform1.CGE5COD.description="Segmento";	 
	objform1.CJM12ID.required = true;
	objform1.CJM12ID.description="Grupo";	 	 
	objform1.CJM13ID.required = true;
	objform1.CJM13ID.description="Subgrupo";	 
	objform1.PR1COD.required = true;
	objform1.PR1COD.description="Cta. Presup.";	 	 
	objform1.PRT7IDE.required = true;
	objform1.PRT7IDE.description="Proyecto";	 	
	AgregarComboGR(document.form1.CJM12ID,document.form1.CGE5COD.value);
	AgregarComboSG(document.form1.CJM13ID,document.form1.CJM12ID.value);
	<cfif mododet eq "CAMBIO">
		llenacajaCambio();
	</cfif>	
	
	_addValidator("isCantidad", Cantidad_valida);
	objform1.CJX21CAN.validateCantidad();
	//_addValidator("isCuenta", validacampos);
	//objform1.CGM1CD.validateCuenta();
	
	// Funciones para Manejo de Botones
	botonActual = "";
	
	function setBtn(obj) {
		botonActual = obj.name;
	}
	
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	function validaLIQ (){
		var PROCEDIMG = document.getElementById("PROCEDIMG")
		if (document.form1.CJX20TIP.value == "V"){
			document.form1.PROCED.value  = "";
			document.form1.PRONOM.value  = "";
			document.form1.PROCOD.value  = "";
			document.form1.CJX20NUF.value  = "";
			objform1.PROCED.required = false;
			objform1.CJX20NUF.required = false;
			document.form1.CJX20NUF.value  = "";
			PROCEDIMG.style.visibility='hidden'
		}
		else{
			objform1.PROCED.required = true;
			objform1.CJX20NUF.required = true;
			PROCEDIMG.style.visibility='visible'	
		}
	}
	
	function Llenado_Auto (){
		var frame = document.getElementById("FRAMECJNEGRA");
		var CJX19REL		= document.form1.CJX19REL.value;
		params = "?CJX19REL="+CJX19REL+"&TIPO=G";
		frame.src = "/cfmx/sif/fondos/operacion/cjc_CargaAuto.cfm"+params;
	}
	validaLIQ ()

