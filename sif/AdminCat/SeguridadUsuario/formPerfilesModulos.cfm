<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se cambiaron las consulta para agregar el nuevo campo Crevaluable 
			de la tabla CtasMayor, ademas de agregar en la forma un check 
			para indicar si la cuenta es revaluable o no.

	Modificado por Gustavo Fonseca H.
		Fecha: 23-2-2006.
		Motivo: Se modifica para corregir la navegación del formulario por tabs (Ordenado) y se actualiza para 
		que utilize el cf_botones y poder así asignarle un orden (tabindex).
		También se corrige la función valida por que permitía grabar cuentas con letras.
--->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="c.ADSPPid"            returnvariable="ADSPPid">
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
<!---
<cfquery name="rsTCHistorico" datasource="#Session.DSN#">
    select TCHid,Ecodigo,TCHcodigo,TCHdescripcion
    from HtiposcambioConversionE
    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>--->


    <cfif isdefined("url.ADSPid") and url.modo EQ "CAMBIODET">
		  <cfset modo="CAMBIODET">
    <cfelseif isdefined("url.ADSPid") and url.modo EQ "CAMBIO">
		  <cfset modo="CAMBIO">
    </cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
		select ADSPid, ADSPcodigo, ADSPdescripcion
		  from ADSEPerfil
		 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   and ADSPid = <cfqueryparam value="#Form.ADSPid#" cfsqltype="cf_sql_integer">
	</cfquery>
    

  <cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
		select * from ADSPerfilProceso a
        where ADSPPid not in(
                select c.ADSPPid from ADSEPerfil a
                    inner join ADSDPerfil b
                        on a.ADSPid = b.ADSPid
                    inner join ADSPerfilProceso c
                        on b.ADSPPid = c.ADSPPid
                where a.ADSPid = #form.ADSPid#)           
				order by SMcodigo
	</cfquery>

<cfquery name="rsPerfilesSeguridad" datasource="#Session.DSN#">
           select * from ADSEPerfil a
            	inner join ADSDPerfil b
                	on a.ADSPid = b.ADSPid
                    and a.Ecodigo = b.Ecodigo
            	inner join ADSPerfilProceso c
                	on b.ADSPPid = c.ADSPPid
           where a.ADSPid = #form.ADSPid#
		  	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
<!---
<cfquery name="rs" datasource="#Session.DSN#">
	select ltrim(rtrim(Cmayor)) as Cmayor from CtasMayor 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	order by Cmayor
</cfquery>

<cfquery name="rsMascaras" datasource="#Session.DSN#">
	select 
		PCEMid
		, PCEMformato, PCEMformatoC, PCEMformatoP
		, PCEMplanCtas
		, PCEMdesc
	from PCEMascaras 
	where CEcodigo=<cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric"> 
	  and PCEMformato <> ' ' and PCEMformato <> 'XXXX-'
	order by PCEMdesc
</cfquery>

<cfquery name="rsCuentaDefault" datasource="#Session.DSN#">
	select Pvalor 
	  from Parametros 
	 where Pcodigo=10 
	   and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsMesConta" datasource="#Session.DSN#">
	select a.Pvalor Ano, m.Pvalor Mes
	  from Parametros a, Parametros m
	 where a.Pcodigo=30 
	   and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and m.Pcodigo=40 
	   and m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Btn_Idioma = t.Translate('Btn_Idioma','Idioma')>

<form method="post" name="form1" action="SQLPerfiles.cfm" onSubmit="javascript: return valida(); ">
  <cfoutput>
  <cfif isdefined("Form.PageNum10") and Len(Trim(Form.PageNum10))>
  	<input type="hidden" name="PageNum_lista10" value="#Form.PageNum10#" />
  <cfelseif isdefined("Form.PageNum_lista10") and Len(Trim(Form.PageNum_lista10))>
  	<input type="hidden" name="PageNum_lista10" value="#Form.PageNum_lista10#" />
  </cfif>
  
  <cfif isdefined("Form.ADSPcodigo") and Len(Trim(Form.ADSPcodigo))>
 	<input type="hidden" name="ADSPcodigo" value="#Form.ADSPcodigo#" />
  <cfelseif isdefined("Form.ADSPcodigoF") and Len(Trim(Form.ADSPcodigoF))>
   	<input type="hidden" name="ADSPcodigoF" value="#Form.ADSPcodigoF#" />
  </cfif>
  
  <cfif isdefined("Form.ADSPdescripcion") and Len(Trim(Form.ADSPdescripcion))>
  	<input type="hidden" name="ADSPdescripcion" value="#Form.ADSPdescripcion#" />
  <cfelseif isdefined("Form.ADSPdescripcionF") and Len(Trim(Form.ADSPdescripcionF))>
	<input type="hidden" name="ADSPdescripcionF" value="#Form.ADSPdescripcionF#" />
  </cfif>
  
    <cfif isdefined("Form.ADSPid") and Len(Trim(Form.ADSPid))>
  	<input type="hidden" name="ADSPid" value="#Form.ADSPid#" />
  </cfif>
  </cfoutput>

<cfif modo EQ "ALTA">
  
      <cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
        select * from ADSPerfilProceso
<!---        where ADSPPid not in(
                select c.ADSPPid from ADSEPerfil a
                    inner join ADSDPerfil b
                        on a.ADSPid = b.ADSPid
                    inner join ADSPerfilProceso c
                        on b.ADSPPid = c.ADSPPid
                where a.ADSPid = #form.ADSPid#)   --->        
                order by SMcodigo
        </cfquery>

</cfif>

  <table border="0" cellpadding="2" cellspacing="0">
    
    
	
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<!--- ********************************************************************************* --->	
	<tr>
		
		<td colspan="2"><fieldset><legend><strong>Opciones de Seguridad:</strong></legend>
			<table>

    
    <!---►►►Tipo de Cambio para estados Financieros◄◄◄--->
    

  
      <td align="right"><strong>Opción de Seguridad:&nbsp;</strong></td>
      <td colspan="1">
		   <table cellpadding="2" cellspacing="0">
			 
                   <select name="PerfilProceso">
                   <option value="">---Seleccionar Opción de Seguridad---</option>
                        <cfoutput query="rsPerfilProceso">
                          <cfif modo EQ "ALTA">
                            <option value="#rsPerfilProceso.ADSPPid#">#rsPerfilProceso.SPdescripcion#</option>
                          <cfelse>
                            <option value="#rsPerfilProceso.ADSPPid#" <cfif rsPerfilesSeguridad.ADSPPid EQ rsPerfilProceso.ADSPPid>selected></cfif>
                            <b>#rsPerfilProceso.SMdescripcion#-#rsPerfilProceso.SPdescripcion#</b></option>
                          </cfif>
                		</cfoutput>
              </select>
            
		
            
			<cf_botones value="AltaD" name="AltaD" exclude="Limpiar">
		  	</table>
         
		<cfif MODO NEQ "ALTA">
                   <cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
                    select '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Está seguro(a) de que desea eliminar el registro?")) return false; location.href=
                    "SQLPerfiles.cfm?BorraD='+'1'+'&ADSPid=#form.ADSPid#'+'&ADSPDid=' #_Cat# <cf_dbfunction name="to_Char" args="ADSPDid">
						#_Cat# '";''>' as eli,* from ADSEPerfil a
                       inner join ADSDPerfil b
                        on a.ADSPid = b.ADSPid
                       inner join ADSPerfilProceso c
                        on  b.ADSPPid = c.ADSPPid   
                        where a.Ecodigo = b.Ecodigo
                        and a.ADSPid = #form.ADSPid# 
                        order by ADSPcodigo
                    </cfquery>

            
            		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#rsPerfilProceso#"
							desplegar="eli,SMdescripcion, SPdescripcion"
							etiquetas=" ,Modulo, Proceso"
							formatos="S,S,S"
							ajustar="N,S,S"
							align="left,left,left"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ADSPid,ADSPPid"
						/>		
       
		</cfif>
		</td>
    </tr>
   
	<!--- ********************************************************************************* --->
			</table></fieldset>
		</td>
	</tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    
    
    
  </table>
</form>
<script language="JavaScript1.2">document.form1.Cmayor.focus();</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>

<script language="JavaScript" type="text/javascript">
	function changeTipo(ctl) {
		// Escoge el balance según el tipo de cuenta
		ctl.form.Cbalancen.selectedIndex = (ctl.value == 'A' || ctl.value == 'G') ? 0 : 1;
		// Si la cuenta es de tipo ingreso o gasto solicita un subtipo para éstas
		var a = document.getElementById("tdSubtipo1");
		var b = document.getElementById("tdSubtipo2");
		var c = document.getElementById("tdSubtipo3");
		if (ctl.value == 'I' || ctl.value == 'G') {
			if (a) a.style.display = ""; 
			if (ctl.value == 'I') {
				if (b) b.style.display = "";
				if (c) c.style.display = "none";
			} else {
				if (b) b.style.display = "none";
				if (c) c.style.display = "";
			}
		} else { 
			if (a) a.style.display = "none";
			if (b) b.style.display = "none";
			if (c) c.style.display = "none";
		}
	}

	function objCPVid (PCEMid, CPVformatoF, CPVformatoPropio, CPVcuentaUtilizada, 
						CPVtieneFinancieras, CPVtieneContables, CPVtienePresupuesto, 
						CPVtieneReglas, CPVtieneFormulacion)
	{
		this.PCEMid					= PCEMid;
		this.CPVformatoF			= CPVformatoF;
		this.CPVformatoPropio		= CPVformatoPropio;
		this.CPVcuentaUtilizada		= CPVcuentaUtilizada;
		this.CPVtieneFinancieras	= CPVtieneFinancieras;
		this.CPVtieneContables		= CPVtieneContables;
		this.CPVtienePresupuesto	= CPVtienePresupuesto;
		this.CPVtieneReglas			= CPVtieneReglas;
		this.CPVtieneFormulacion	= CPVtieneFormulacion;
	}
	function objPCEMid (formatoF, formatoC, formatoP)
	{
		this.formatoF = formatoF;
		this.formatoC = formatoC;
		this.formatoP = formatoP;
	}
	var LarrCPVid = new Array();
	var LarrPCEMid = new Array();
<!---	
	<cfif MODO EQ "ALTA">
		<cfoutput>
		LarrCPVid[0] = new objCPVid ("-1", "#rsCuentaDefault.Pvalor#", "#rsCuentaDefault.Pvalor#", "0", "");
		</cfoutput>
	<cfelse>
		<cfoutput query="rsVigencia">
			LarrCPVid[#currentRow-1#] = new objCPVid ("#PCEMid#","#CPVformatoF#","#CPVformatoPropio#","<cfif (CPVtieneFinancieras+CPVtieneContables+CPVtienePresupuesto+CPVtieneReglas+CPVtieneFormulacion GT 0)>1</cfif>","<cfif CPVtieneFinancieras GT 0>1</cfif>","<cfif CPVtieneContables GT 0>1</cfif>","<cfif CPVtienePresupuesto GT 0>1</cfif>","<cfif CPVtieneReglas GT 0>1</cfif>","<cfif CPVtieneFormulacion GT 0>1</cfif>");
		</cfoutput>
	</cfif>
	<cfoutput>
	LarrPCEMid[0] = new objPCEMid ("#rsCuentaDefault.Pvalor#","#rsCuentaDefault.Pvalor#","");
	</cfoutput>
	LarrPCEMid[1] = new objPCEMid ("","","");
	<cfoutput query="rsMascaras">
	LarrPCEMid[#currentRow+1#] = new objPCEMid ("#PCEMformato#","#PCEMformatoC#","#PCEMformatoP#");
	</cfoutput> 
--->
	function fnCambiaCPVid(pCPVid){
		var opc = pCPVid.selectedIndex;
		var cboPCEMid = document.getElementById("PCEMid");
		LarrPCEMid[1].formatoF = LarrCPVid[opc].CPVformatoF;
		LarrPCEMid[1].formatoC = LarrCPVid[opc].CPVformatoF;
		LarrPCEMid[1].formatoP = "";
		if (LarrCPVid[opc].PCEMid == "")
			cboPCEMid.selectedIndex = parseInt(LarrCPVid[opc].CPVformatoPropio);
		else
			for (var i=0; i < cboPCEMid.options.length; i++)
				if (cboPCEMid.options[i].value == LarrCPVid[opc].PCEMid)
				{
					cboPCEMid.selectedIndex = i;
					break;
				}

		cboPCEMid.disabled = (LarrCPVid[opc].CPVcuentaUtilizada == "1");
		<cfif MODO NEQ "ALTA">
			document.getElementById("CPVcuentaUtilizada").style.display 	= (LarrCPVid[opc].CPVcuentaUtilizada != "1") ? "none" : "";

			document.getElementById("CPVtieneFinancieras").style.display 	= (LarrCPVid[opc].CPVtieneFinancieras != "1") ? "none" : "";
			document.getElementById("CPVtieneContables").style.display 		= (LarrCPVid[opc].CPVtieneContables != "1") ? "none" : "";
			document.getElementById("CPVtienePresupuesto").style.display 	= (LarrCPVid[opc].CPVtienePresupuesto != "1") ? "none" : "";
			document.getElementById("CPVtieneReglas").style.display 		= (LarrCPVid[opc].CPVtieneReglas != "1") ? "none" : "";
			document.getElementById("CPVtieneFormulacion").style.display 	= (LarrCPVid[opc].CPVtieneFormulacion != "1") ? "none" : "";
			document.getElementById("Ctipo").disabled 						= (LarrCPVid[opc].CPVtienePresupuesto == "1");
		</cfif>
		fnCambiaPCEMid(cboPCEMid);
	}

	function fnCambiaPCEMid(pPCEMid)
	{
		var opc = pPCEMid.selectedIndex;
		pPCEMid.form.Cmascara.value									= LarrPCEMid[opc].formatoF;
		document.getElementById("CPVformatoF").disabled				= (opc != 1 || pPCEMid.disabled);
		document.getElementById("CPVformatoF").value 				= LarrPCEMid[opc].formatoF;
		document.getElementById("FormatoC").value 					= LarrPCEMid[opc].formatoC;
		document.getElementById("FormatoP").value 					= LarrPCEMid[opc].formatoP;
		<cfif MODO NEQ "ALTA">
		document.form1.btnCuentas_Financieras.style.display 		= (opc <= 1) ? "none" : "";
		<!--- document.form1.btnCuentas_Contables.style.display 			= (opc <= 1) ? "none" : ""; --->
		document.form1.btnCuentas_Presupuestarias.style.display 	= (trim(LarrPCEMid[opc].formatoP) == "") ? "none" : "";
		document.form1.btnReglas_por_Mascara.style.display          = (opc <= 1) ? "none" : "";
		</cfif>
	}
	
	//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
	function ESNUMERO(aVALOR)
	{
		//var NUMEROS="0123456789."
		var NUMEROS="0123456789"
		var CARACTER=""
		var CONT=0
		//var PUNTO="."
		var VALOR = aVALOR.toString();
		
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (NUMEROS.indexOf(CARACTER)<0) {
				return false;
				} 
			}
		if (CONT>1) {
			return false;
		}
		
		return true;
	}

	function validaNumero(dato) {
		dato = trim(dato);
		document.form1.Cmayor.value = dato;
		var tam = dato.length;
		if (tam > 0) {
			if (ESNUMERO(dato)) {
				if (tam==3) dato = "0"+dato;
				if (tam==2)	dato = "00"+dato;
				if (tam==1)	dato = "000"+dato;
				if (tam==0)	dato = "0000"+dato;
				document.form1.Cmayor.value = dato;				
				return true;
			}		
			else {
				alert('Debe ser numérico.');							
				return false;
			}
		}
		return false;	
	}

	function ReglasXMascaraC() {
		document.form1.PCEMid.disabled = false;
		document.form1.action = "ReglasXMascaraCuenta.cfm";
		document.form1.submit();
	}
	
	function CuentasC(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasContables.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	function CuentasF(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasFinancieras.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	function CuentasP(data) {
		if(document.form1.Cmascara.value != ""){
			var vformat = document.form1.Cmascara.value;
			var vTipoMasck = "";			

			for(var i=0; i<vformat.length;i++){
				newstr = vformat.replace("X", "0");
				vformat = newstr;
			}

			<cfif modo NEQ 'ALTA'>
					vTipoMasck = document.form1.PCEMid.value;
			</cfif>			
			
			document.form1.action="CuentasPresupuesto.cfm?Cmayor="+
							data+
							"&Formato="+
							vformat+
							"&tipoMascara=" +
							vTipoMasck;
							 
			document.form1.submit();
		}else{
			alert('Error, no se ha seleccionado o digitado el detalle de la máscara');
		}
		
		return false;
	}

	<!---function existeFormatoCuenta(dato) {
		var Existe_formato = false;
		<cfloop query="rs">
			if (dato == "<cfoutput>#rs.Cmayor#</cfoutput>") 
				Existe_formato = true;		
		</cfloop>
		return Existe_formato;
	}--->
	
	function TCHistorico() {
		var indice = document.form1.CTCconversion.selectedIndex 
   		var valor = document.form1.CTCconversion.options[indice].value 
		if (valor == 4){
			document.getElementById("TCHidD").style.position = "relative";
			document.getElementById("TCHidD").style.visibility = "visible";
		}
		else{
			document.getElementById("TCHidD").style.position = "absolute";
			document.getElementById("TCHidD").style.visibility = "hidden";
		}
	}
	
	//ELIMINA LOS ESPACIOS EN BLANCO DE LA IZQUIERDA DE UN CAMPO
	function ltrim(tira)
	{
		var CARACTER="",HILERA=""
		 if (tira.name)
		   {VALOR=tira.value}
		  else
		   {VALOR=tira}
		 
		HILERA=VALOR
		INICIO = VALOR.lastIndexOf(" ")
		if(INICIO>-1){
		  for (var i=0; i<VALOR.length; i++)
		   { 
			 CARACTER=VALOR.substring(i,i+1);
			 if (CARACTER!=" ")
			 {
			   HILERA = VALOR.substring(i,VALOR.length)
			   i = VALOR.length      
			 }
		  }
		}
		return HILERA
	}
	
	
	function trim(tira)
	{
		return ltrim(rtrim(tira))
	}
	
	//ELIMINA LOS ESPACIOS EN BLANCO DE LA DERECHA DE UN CAMPO 
	function rtrim(tira)
	{
		if (tira.name)
			VALOR=tira.value
		else
			VALOR=tira
		var CARACTER=""
		var HILERA=VALOR
		INICIO = VALOR.lastIndexOf(" ")
		if (INICIO>-1)
		{
			for(var i=VALOR.length; i>0; i--)
			{  
				CARACTER= VALOR.substring(i,i-1)
				if(CARACTER==" ")
					HILERA = VALOR.substring(0,i-1)
				else
					i=-200
			}
		}
		return HILERA
	}

	function valida()
	{
		
		if (!ValTCH()){
			return false;
		}
		
		if (btnSelected("Alta",document.form1)) {	
			if (existeFormatoCuenta(document.form1.Cmayor.value)) {
				alert('Cuenta Mayor ya existe'); 
				
				return false;
			}
			
			if(document.form1.Cmascara.value != ''){
				if(!revisaFormato(document.form1.Cmascara.value))
					return false;
			}
		}

		document.form1.Ctipo.disabled = false;
		document.form1.PCEMid.disabled = false;
		document.form1.CPVformatoF.disabled = false;
		if (validaNumero(document.form1.Cmayor.value)){
			return true;		}
		else
			{
			return false;
			}
	}
//------------------------------------------------------------------------------------------							
	function revisaFormato(cadena){
		var error = false;
		
		if(cadena.length < 5){
			error = true;
		}else{
			if(cadena.substring(0,5) == 'XXXX-'){
				var band = 0;								
				my_array = stringToArray(cadena);
				
				for (i = 5; i < my_array.length; i++){
					if(my_array[i] == 'X' || my_array[i] == '-'){
						if(my_array[i] == '-'){
							if(band == 0){
								band++;
							}else{
								error = true;							
							}
						}
						
						if(my_array[i] == 'X')
							band=0;
					}else{
						error = true;							
					}
				}
				if(my_array[my_array.length-1] == '-'){
					error = true;											
				}
			}else{
				error = true;										
			}
		}
		
		if(error){
			alert("Formato de Máscara '" + cadena + "' inválido. Ejemplo: 'XXXX-XXX-XX-X'");			
			return false;
		}else{
			return true;
		}
	}
//------------------------------------------------------------------------------------------							
	function stringToArray(formato){
		var my_array = new Array();
		for (var i = 0; i < formato.length; i++){
			my_array[i] = formato.substring(i,i+1);
		}

		return my_array;
	}
//------------------------------------------------------------------------------------------							
	function deshabilitarValidacion(){
		objForm.Cmayor.required = false;
		objForm.Cdescripcion.required = false;
		objForm.Cmascara.required= false;
		objForm.CPVformatoF.required= false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.Cmayor.required = true;
		objForm.Cdescripcion.required = true;
		objForm.Cmascara.required= true;
		objForm.CPVformatoF.required= false;
	}	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
//------------------------------------------------------------------------------------------	
	objForm.Cmayor.required = true;
	objForm.Cmayor.description="Cuenta";				
	objForm.Cdescripcion.required= true;
	objForm.Cdescripcion.description="Descripción";
	objForm.CPVformatoF.required= true;
	objForm.CPVformatoF.description="Formato Financiero de la Cuenta";		
	fnCambiaCPVid(document.getElementById("CPVid"));
	changeTipo(document.form1.Ctipo);
//------------------------------------------------------------------------------------------		
function ValTCH() {
	var indice = document.form1.TCHid.selectedIndex;
	var valor = document.form1.TCHid.options[indice].value;
	
	var indice2 = document.form1.CTCconversion.selectedIndex;
	var valor2 = document.form1.CTCconversion.options[indice2].value;
	
	if (valor2 == 4 && valor == -1){
		document.getElementById("TCHid").style.backgroundColor = "#FFFFCC";
		alert ('No existen Tipos de Cambio Historicos, seleccione otro tipo de conversion');
		return false;
	}
	else{
		return true;
	}
}
//------------------------------------------------------------------------------------------
//	function ReglasXMascaraC() {
//		document.form1.PCEMid.disabled = false;
//		document.form1.action = "ReglasXMascaraCuenta.cfm";
//		document.form1.submit();
//	}
	function Valida(){
		return confirm('¿Está seguro(a) de que desea eliminar el registro?')
	}
	 <cfoutput>
	function borraDet(ADSPDid){
		if (Valida()){
			ADSPDid = ADSPDid
			alert(ADSPDid);
			BorraD = 1
			location.href = 'SQLPerfiles.cfm?ADSPDid='+ADSPDid+'&BorraD='+BorraD;
			document.form1.ADSPDid.value = ADSPDid;
			document.form1.nosubmit.value 	 = 'true';
			document.form1.submit();
		}else
		document.form1.nosubmit.value = 'false';
	}
	</cfoutput>


<!---    <cfoutput>
	function borrar(documento, linea){
		if ( confirm('#MSG_Borrar#') ) {
			document.form2.action 			 = "SQLRegistroDocumentosCP.cfm";
			document.form2.IDdocumento.value = documento;
			document.form2.Linea.value	 	 = linea;
			document.form2.nosubmit.value 	 = 'true';
			document.form2.submit();
		}else
		document.form2.nosubmit.value = 'false';
	}
    </cfoutput>--->
function goCatDescIdioma() {
	document.form1.PCEMid.disabled = false;
	document.form1.action = 'CtasMayorIdioma.cfm';
	document.form1.submit();
}
</script>



