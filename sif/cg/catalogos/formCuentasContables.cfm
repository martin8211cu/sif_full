<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha 27-1-2006.
		Motivo: En la siguiente línea de codigo sobraba un >:
				<input type="hidden" name="Ccuenta" value="<cfif modo NEQ "ALTA" and isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>><cfoutput>#Form.Ccuenta#</cfoutput></cfif>" size="32"> 
				lo que provocava valores: ">50000000012765" y al no ser numeric, se caía la aplición.
--->

<cfif isdefined("Form.Cambio") and isdefined("form.ccuenta") and len(trim(form.ccuenta))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif (Form.modo EQ "CAMBIO") and isdefined("form.ccuenta") and len(trim(form.ccuenta))>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Para cuando viene de la nueva lista de Cuentas de Mayor para agregar directamente subcuentas sin pasar por el mantenimiento de Cuentas de Mayor --->
<cfif isdefined("form.modo2")>
	<cfset modo = form.modo2>
</cfif>

<cfif (not isdefined("form.ccuenta")) or (isdefined("form.ccuenta") and len(trim(form.ccuenta)) eq 0)>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.Cmayor") and Form.Cmayor NEQ "">
	<cfquery name="rsCuentasContables" datasource="#Session.DSN#">
		select Ccuenta, cc.Ecodigo, cc.Cmayor, cc.Cdescripcion, Cformato, Cpadre, Cmovimiento, Mcodigo, SCid , cc.Cbalancen, cc.ts_rversion, cm.ts_rversion as tsVersionPadre
		from CContables cc
             , CtasMayor cm
		where cc.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			and cc.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif isdefined("Form.Ccuenta") and Form.Ccuenta NEQ "">		  
			  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			</cfif>
			and cc.Cmayor=cm.Cmayor
			and cc.Ecodigo=cm.Ecodigo
	</cfquery>
</cfif>

<cfquery name="rsCuentasPadre" datasource="#Session.DSN#">
	select Ccuenta, Cformato from CContables 
	where Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and {fn length(rtrim(ltrim(Cformato)))} <  #Len(Trim(Form.formato))#
	order by Cformato
</cfquery>
 
<cfquery name="rsCaract" datasource="#Session.DSN#">
	select a.Mcodigo, a.Cdescripcion, a.Ctipo 
	from Caracteristicas a, CtasMayor b 
	where b.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and rtrim(a.Ctipo) = b.Ctipo 
</cfquery>

<cfif modo neq "ALTA" and isDefined("Form.Ccuenta") and Trim(Form.Ccuenta) NEQ "">
	<cfquery name="rsBuscaPadre" datasource="#Session.DSN#">
		select a.Cpadre, b.Cdescripcion 
		from CContables a, CContables b 
		where a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
		  and b.Ccuenta = a.Cpadre
	</cfquery>
</cfif>
<cfquery name="rsSubClase" datasource="#Session.DSN#">
	select SCid, a.SCdescripcion
	from SubClaseCuentas a, CtasMayor b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and b.Ctipo = a.SCtipo
	  and b.Ecodigo = a.Ecodigo
	  and b.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
</cfquery>

<cfquery name="rs" datasource="#Session.DSN#">
	select ltrim(rtrim(Cformato)) as Cformato
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  	  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
	  <cfif modo neq 'ALTA'>
		and Cformato != '#rsCuentasContables.Cformato#'
	  </cfif>
</cfquery>

<!--- Permitir letras en la máscara --->
<cfif not isdefined("request.CFctasConLetras")>
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 12
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Pvalor, Mcodigo, Pdescripcion)
			values (#session.Ecodigo#, 12, 'N', 'CO', 'Permite letras en Cuenta Financiera')
		</cfquery>
	</cfif>
	<cfset request.CFctasConLetras = (rsSQL.Pvalor EQ "S")>
</cfif>

<cfset array = ListToArray("#Form.formato#", "-")>
<cfset sizeArray = ArrayLen(array)>
<cfset NombresObjetos = "UNO,DOS,TRES,CUATRO,CINCO,SEIS,SIETE,OCHO,NUEVE,DIEZ,ONCE,DOCE,TRECE,CATORCE">
<cfset arrNombres = ListToArray(NombresObjetos, ",")>
<cfset cantNombres = ArrayLen(arrNombres)>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//-->
</SCRIPT>

<script language="JavaScript1.2">
	function ES_NUM_LETRA(aVALOR)
	{
		var CARACTER=""
		var VALOR = aVALOR.toString();
		
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (!((CARACTER >= "A" && CARACTER <= "Z") || (CARACTER >= "0" && CARACTER <= "9"))) {
				return false;
				} 
			}

		return true;
	}

	function validass(object){
		object.value = trim(object.value.toUpperCase());	
		var cadena = new String(object.value);						   
		var tam = object.value.length;
		
		if(<cfif request.CFctasConLetras>ES_NUM_LETRA(cadena)<cfelse>ESNUMERO(cadena)</cfif>)
		{	 
			 var ceros="";
			 for(var i=0; i<object.size-tam;i++)
					ceros+="0";
			 object.value = ceros+object.value;
		}
		else
			object.value="";
	}           

function verasig(object){    
	if(document.form1.ts_rversion.value==""){	   
	   var total = new Number(document.form1.totalmascara.value)
	   var nombres = new Array("UNO","DOS","TRES","CUATRO","CINCO","SEIS","SIETE","OCHO","NUEVE","DIEZ","ONCE","DOCE","TRECE","CATORCE")        

	   if((new Number(object.length) == 1) || (object.options[object.selectedIndex].text.length==4)){		   
			for(var s=2; s < total; s++){				
						eval("document.form1."+nombres[s]+".disabled=true")            
			}                 
	   }
	}   
}

function asig(object){       
	var nombres = new Array("UNO","DOS","TRES","CUATRO","CINCO","SEIS","SIETE","OCHO","NUEVE","DIEZ","ONCE","DOCE","TRECE","CATORCE")        
	var valores = new Array("","","","","","","","","","","","","","")        
	var valoractual = object.options[object.selectedIndex].text
	var aux=""
	var caracter=""
	var j = 0            
	var total = new Number(document.form1.totalmascara.value)  

	for(var a=0; a < total; a++){                
		eval("document.form1."+nombres[a]+".disabled=false")
		eval("document.form1."+nombres[a]+".value=''")
	}    
				
	for(var i=0; i <= valoractual.length; i++){        
			caracter = valoractual.substring(i,i+1)
								
			if(caracter=='-'){                       
				eval("document.form1."+nombres[j]+".value='"+aux+"'")                
				eval("document.form1."+nombres[j]+".disabled=true")
				aux=""
				caracter=""
				j++
			}                    
			aux += caracter                    
		}
	 
		eval("document.form1."+nombres[j]+".value='"+aux+"'")
		eval("document.form1."+nombres[j]+".disabled=true")                        
		eval("document.form1."+nombres[j+1]+".focus()")
		
		if(j+2 < total){                    
			for(var s=j+2; s < total; s++){                        
					eval("document.form1."+nombres[s]+".disabled=true")            
			}
		}            
}

function valida() {		
	var nombres = new Array("UNO","DOS","TRES","CUATRO","CINCO","SEIS","SIETE","OCHO","NUEVE","DIEZ","ONCE","DOCE","TRECE","CATORCE");
	var fin = new Number(document.form1.totalmascara.value);
	var obj ="";
	
	if(document.form1.Ccuenta.value=="")       
		document.form1.Cformato.value= "";
																			
	var banderavalida=0;
	
	if(document.form1.Ccuenta.value==""){		
		for(var i=0;i < fin;i++){			
			obj = eval("document.form1."+nombres[i]+".value");
			obj2 = eval("document.form1."+nombres[i]+".disabled");
			
			if((obj=="")){				
			   if(!obj2){				   
				  alert('Formato de cuenta inválido');
				  return false;
			   }     
			} else
				document.form1.Cformato.value += obj+"-";
		}
		
		document.form1.Cformato.value = document.form1.Cformato.value.substring(0,document.form1.Cformato.value.length-1);                             
	}				

// MODIFICACION PARA QUE VALIDE LA INSERCIÓN DE UNA CUENTA QUE NO EXISTA 	
	//-- advv -- if (existeFormatoCuenta(document.form1.Cformato.value)) {alert('Cuenta contable ya existe'); return false;}		   
		// MODIFICACION PARA QUE VALIDE LA INSERCIÓN DE UNA CUENTA QUE NO EXISTA

		if(document.form1.ts_rversion.value==""){
			if (document.form1.Cformato.value == ""){
				
				alert ("Debe digitar el formato de la cuenta");        
				banderavalida=0;
				return false;
			}else{			

	/*			var total = new Number(document.form1.totalmascara.value);
				var dat = eval("document.form1."+nombres[total-1]+".value");
	
				if(dat!="")
					document.form1.Cmovimiento.value="S";
				else
					document.form1.Cmovimiento.value="N";
					*/
 
/*
	El campo Cmovimiento siempre sera S si el campo del Formato de la cuenta es valido,
	porque existe un Trigger para la tabla CFinanciera que dice que si el campo Ccuenta no es null
	el campo de CFmovimiento debe ser 'S', y como el campo de Formato se esta validando para que sea requerido
	el campo de Ccuenta de la tabla de CFinanciera nunca sera null porque contendra el nuevo codigo generado (identity) 
	de la tabla de CContables y por consiguiente el campo de CFmovimiento de la tabla de CFinanciera se guardar[a con una 'S'
*/
 
			document.form1.Cmovimiento.value="S";
		}   
	}
	
	if (document.form1.Cdescripcion.value == ""){			
		alert ("Debe digitar la descripción");
		document.form1.Cdescripcion.select();
		return false;
	}																
																							
	return true;
}
/*
function existeFormatoCuenta(dato) {

	var Existe_formato = false;
	<!--- <cfloop query="rs"> --->
		if (dato == <!--- <cfoutput>#rs.Cformato#</cfoutput> --->) 
			Existe_formato = true;		
	<!--- </cfloop> --->
	return Existe_formato;
}*/

function CuentasM() {
	document.form1.action='CuentasMayor.cfm';
	document.form1.modo.value = "CAMBIO";
	document.form1.submit();
	return false;
}

//ELIMINA LOS ESPACIOS EN BLANCO DE LA IZQUIERDA DE UN CAMPO
function ltrim(tira){
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
 {return ltrim(rtrim(tira))}

//ELIMINA LOS ESPACIOS EN BLANCO DE LA DERECHA DE UN CAMPO 
function rtrim(tira){
if (tira.name)
  {VALOR=tira.value}
  else
  {VALOR=tira}
var CARACTER=""
var HILERA=VALOR
INICIO = VALOR.lastIndexOf(" ")
   if(INICIO>-1){
     for(var i=VALOR.length; i>0; i--){  
         CARACTER= VALOR.substring(i,i-1)
         if(CARACTER==" ")
            HILERA = VALOR.substring(0,i-1)
         else
            i=-200
      }
   }
return HILERA
}
</script>

<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<form method="post" name="form1" action="SQLCuentasContables.cfm">

 <cfif #trim(form.tipoMascara)# EQ "0">
	<cfset form.tipoMascara = "">
 </cfif> 

 <input name="tipoMascara" type="hidden" value="<cfoutput>#trim(form.tipoMascara)#</cfoutput>">

 <cfif isdefined("url.PageNum_Lista") and not isdefined("url.PageNum")>
 	<input name="Pagina" type="hidden" value="<cfoutput>#url.PageNum_Lista#</cfoutput>">
 <cfelseif isdefined("form.Pagenum")>
 	<input name="Pagina" type="hidden" value="<cfoutput>#form.PageNum#</cfoutput>">
 <cfelseif isdefined("form.Pagina")>
 	<input name="Pagina" type="hidden" value="<cfoutput>#form.Pagina#</cfoutput>">
 </cfif>
 

 <table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr> 
      <td width="25%">&nbsp;</td>
      <td width="14%" nowrap><div align="left">Cuenta Padre:&nbsp;</div></td>
      <td width="64%">

	   <input name="totalmascara" type="hidden" value="<cfoutput>#sizeArray#</cfoutput>"> 
        <cfif modo NEQ "ALTA">
          <input name="CpadreLabel" type="text" readonly 
		  value="<cfif isDefined("Form.Cpadre") and Trim(Form.Cpadre) NEQ ""><cfoutput>#rsBuscaPadre.Cdescripcion#</cfoutput></cfif>" size="32" onfocus="javascript:this.select();" >
          <input type="hidden" name="Cpadre" value="<cfif isdefined("rsBuscaPadre") and len(trim(rsBuscaPadre.Cpadre))><cfoutput>#rsBuscaPadre.Cpadre#</cfoutput></cfif>" size="32" readonly onchange="javascript:asig(this);" onclick="javascript:verasig(this);">
          <cfelse>
          <input name="CpadreLabel" type="hidden" value="xxxxxxxxx">
          <select name="Cpadre"  onchange="javascript:asig(this);" onclick="javascript:verasig(this);" >
            <cfoutput query="rsCuentasPadre"> 
              <option value="#rsCuentasPadre.Ccuenta#" <cfif (isDefined("Form.Cpadre") AND Form.Cpadre EQ rsCuentasPadre.Ccuenta)>selected</cfif>>#rsCuentasPadre.Cformato#</option>
            </cfoutput> 
          </select>
        </cfif> </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td nowrap><div align="left">Formato:&nbsp;</div></td>
      <td> <cfif modo NEQ "ALTA">
          <input name="Cformato" type="text" size="32" value="<cfoutput>#trim(rsCuentasContables.Cformato)#</cfoutput>" readonly onfocus="javascript:this.select();" >
          <cfelse>
          <input type="hidden" name="Cformato" value="" size="32">
          <cfloop index="i" from="1" to="#sizeArray#" step="1">
            <cfset size = Len(array[i])>
            <cfif i EQ 1>
              <cfset val = Form.Cmayor>
              <cfset fun = " disabled ">
              <cfelse>
              <cfset val = "">
              <cfset fun = ' onblur="javascript:validass(this);" onclick="javascript:verasig(Cpadre); this.select();" '>
            </cfif>
            <input 	type="text" name="<cfoutput>#arrNombres[i]#</cfoutput>" 
					value="<cfoutput>#val#</cfoutput>" 
					style="text-transform:uppercase; text-align:right;"
					size="<cfoutput>#size#</cfoutput>" maxlength="<cfoutput>#size#</cfoutput>"  
					<cfoutput>#fun#</cfoutput> onfocus="javascript:this.select();" 
			>
          </cfloop>
        </cfif></td>
    </tr>
	<tr> 
	  <td>&nbsp;</td>
	  <td nowrap><div align="left">Auxiliar:&nbsp;</div></td>
	  <td>
		  <select name="Mcodigo">
			<option value="1" <cfif modo NEQ "ALTA" and (rsCuentasContables.Mcodigo EQ 1)>selected</cfif>>Contabilidad General</option>			  		  
			  <cfoutput query="rsCaract"> 
				<option value="#rsCaract.Mcodigo#" <cfif modo NEQ "ALTA" and (rsCaract.Mcodigo EQ rsCuentasContables.Mcodigo)>selected</cfif>>#rsCaract.Cdescripcion#</option>
			  </cfoutput> 
		  </select>
	  </td>
	</tr>	

<!---
    <tr> 
      <td>&nbsp;</td>
      <td nowrap><div align="left">SubClase:&nbsp;</div></td>
      <td><select name="SCid" 
			<cfif modo NEQ 'ALTA' and isdefined('form.tipoMascara') and form.tipoMascara NEQ 'N'>
				disabled
			</cfif> 		  
		  >
		<cfif rsSubClase.RecordCount EQ 0>
			<option value="-1"></option>
		</cfif>	  
          <cfoutput query="rsSubClase"> 
            <option value="#rsSubClase.SCid#" <cfif modo NEQ "ALTA" and (rsSubClase.SCid EQ rsCuentasContables.SCid)>selected</cfif>>#rsSubClase.SCdescripcion#</option>
          </cfoutput> </select></td>
    </tr>
--->	

    <tr> 
      <td>&nbsp;</td>
      <td nowrap><div align="left">Descripci&oacute;n:&nbsp;</div></td>
      <td><input
			 type="text" name="Cdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentasContables.Cdescripcion#</cfoutput></cfif>" size="32" onfocus="javascript:this.select();" > 
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td nowrap><div align="left">Balance Normal:&nbsp;</div></td>
      <td><select name="Cbalancen" required>
          <option value=""> -- Seleccione -- </option>
          <option value="D" <cfif modo NEQ "ALTA" and rsCuentasContables.CBalancen EQ "D">selected</cfif>>D&eacute;bito</option>
          <option value="C" <cfif modo NEQ "ALTA" and rsCuentasContables.CBalancen EQ "C">selected</cfif>>Cr&eacute;dito</option>
        </select></td>
      <td width="0%">
      <td width="1%"></tr>
    <tr> 
      <td> 
	  <cfset ts = ""> 
	  <cfset tsPadre = ""> 	  
	  <cfif modo NEQ "ALTA">
          <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentasContables.ts_rversion#" returnvariable="ts"></cfinvoke>
          <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentasContables.tsVersionPadre#" returnvariable="tsPadre"></cfinvoke>		  
        </cfif> </td>
      <td><div align="right"></div></td>
      <td>
	  	<input type="hidden" name="Cmayor" value="<cfoutput>#Form.Cmayor#</cfoutput>" size="32"> 
		<input type="hidden" name="Ccuenta" value="<cfif modo NEQ "ALTA" and isdefined("form.Ccuenta") and len(trim(form.Ccuenta))><cfoutput>#Form.Ccuenta#</cfoutput></cfif>" size="32"> 
        <input type="hidden" name="formato" value="<cfoutput>#Form.formato#</cfoutput>"></td>
        <input type="hidden" name="Cmovimiento" value="<cfif modo NEQ "ALTA" and isdefined("Form.Cmovimiento") and len(trim(Form.Cmovimiento))><cfoutput>#Form.Cmovimiento#</cfoutput></cfif>" size="32"> 
      	<input type="hidden" name="modo" value=""></td>
      	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>"></td>
      	<input type="hidden" name="ts_rversPadre" value="<cfif modo NEQ "ALTA"><cfoutput>#tsPadre#</cfoutput></cfif>"></td>		
    </tr>

    <tr> 
      <td>&nbsp;</td>
      <td colspan="2" nowrap>
			<div align="center"> 
          		<cfif modo EQ "ALTA">
            		<input <cfif isdefined('form.tipoMascara') and trim(form.tipoMascara) NEQ ''>disabled</cfif> type="submit" name="Alta" value="Agregar" onClick="javascript: return valida(); ">
					<input type="reset" name="Limpiar" value="Limpiar" >
				<cfelse>
					<cfif isdefined("rsBuscaPadre") and rsBuscaPadre.RecordCount gt 0>
						<input type="submit" name="Cambio" value="Modificar" onclick="javascript: return valida();" >
						<input <cfif isdefined('form.tipoMascara') and trim(form.tipoMascara) NEQ ''>disabled</cfif> type="submit" name="Baja" value="Eliminar" onclick="javascript:return confirm('¿Desea Eliminar la Cuenta Contable?');">
					<cfelse>
						<input type="submit" name="CambioPadre" value="Modificar">					
					</cfif>
					<input <cfif isdefined('form.tipoMascara') and trim(form.tipoMascara) NEQ ''>disabled</cfif> type="submit" name="Nuevo" value="Nuevo" >
			  	</cfif>
          		<input name="CuentasMayor" type="button" value="Cuentas Mayor" onClick="CuentasM();">
          		<!---<cf_sifayuda name="imAyuda" imagen="3" Tip="true" url="/cfmx/sif/Utiles/sifayudahelp.cfm">---->
			</div>
		</td>
    </tr>

  </table>
</form>

	<!--- Mantenimiento de cuentas inactivas --->	
	<cfif modo NEQ "ALTA">	
		<br />
		<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid gray;">
		<tr><td colspan="3" align="center" class="tituloListas"><b>Inactivaci&oacute;n de Cuenta Contable</b></td></tr>	
		<tr>
		  <td>&nbsp;</td>
		  <td colspan="2" nowrap><div align="center"><cfinclude template="formCuentasInactivas.cfm"></div></td>
		</tr>
		</table>
	</cfif>

<script language="JavaScript1.2">
	<cfif modo EQ "ALTA">
		asig(document.form1.Cpadre);
	<cfelse>
		document.form1.Cdescripcion.select();
	</cfif>	
</script>