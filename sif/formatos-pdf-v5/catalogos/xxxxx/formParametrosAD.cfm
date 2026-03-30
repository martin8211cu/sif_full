<cfset hayFormatoCuentasContables = 0 >
<cfset hayPeriodo = 0 >
<cfset hayMes = 0 >
<cfset hayPeriodoAux = 0 >
<cfset hayMesAux = 0 >
<cfset hayMesFiscal = 0 >
<cfset hayFormatoPlacas = 0 >

<!--- Estos parámetros son siempre fijos o sea siempre se insertan --->
<cfset hayInterfazConta = 0 >
<cfset hayUsaConlis = 0 >

<!--- Este parámetro se muy importante ya que dice si están definidos todos los parámetros generales (S o N) --->
<cfset hayParametrosDefinidos = 0 >

 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset definidos = ObtenerDato(5)>
<cfset PvalorPeriodo = ObtenerDato(30)>
<cfset PvalorMes = ObtenerDato(40)>
<cfset mask = ObtenerDato(10)>
<cfset PvalorPeriodoAux = ObtenerDato(50)>
<cfset PvalorMesAux = ObtenerDato(60)>
<cfset PvalorMesFiscal = ObtenerDato(45)>
<cfset maskPlacas = ObtenerDato(250)>

<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>
<cfif mask.Recordcount GT 0 ><cfset hayFormatoCuentasContables = 1 ></cfif>
<cfif PvalorPeriodo.Recordcount GT 0 ><cfset hayPeriodo = 1 ></cfif>
<cfif PvalorMes.Recordcount GT 0 ><cfset hayMes = 1 ></cfif>
<cfif PvalorPeriodoAux.Recordcount GT 0 ><cfset hayPeriodoAux = 1 ></cfif>
<cfif PvalorMesAux.Recordcount GT 0 ><cfset hayMesAux = 1 ></cfif>
<cfif PvalorMesFiscal.Recordcount GT 0 ><cfset hayMesFiscal = 1 ></cfif>
<cfif maskPlacas.Recordcount GT 0 ><cfset hayFormatoPlacas = 1 ></cfif>

<!--- Verifica si es posible insertar/modificar los parámetros para esta empresa si hay datos en:
 las tablas EContables o en SaldosContables o en Cuentas Contables --->
<cfquery name="rsExistenDatos" datasource="#Session.DSN#">
	if exists(
		select 1 from EContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	)
		select 1 as existe		
	else
		if exists(
			select 1 from SaldosContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		)
			select 1 as existe		
		else
			if exists(
				select 1 from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			)
				select 1 as existe
			else
				select 0 as existe
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select convert(varchar,Mcodigo) as Mcodigo, Mnombre from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
	select convert(varchar,Mcodigo) as Mcodigo from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<script language="JavaScript" type="text/JavaScript">
<!--
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
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>


<form action="SQLParametrosAD.cfm" method="post" name="form1" onSubmit="MM_validateForm('periodo','','R','periodoAux','','RinRange1950:2099');return document.MM_returnValue">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="50%"><div align="right">Formato de M&aacute;scara de Cuentas 
          Contables:</div></td>
      <td width="50%"><input name="mascara" type="text" size="25" maxlength="100" value="<cfoutput>#mask.Pvalor#</cfoutput>"></td>
    </tr>
    <tr> 
      <td><div align="right">Periodo Contable:</div></td>
      <td><input name="periodo" type="text" value="<cfoutput>#PvalorPeriodo.Pvalor#</cfoutput>" size="4" maxlength="4"></td>
    </tr>
    <tr> 
      <td><div align="right">Mes Contable:</div></td>
      <td> <select name="mes">
          <option value="1" <cfif PvalorMes.Pvalor EQ "1">selected</cfif>>Enero</option>
          <option value="2" <cfif PvalorMes.Pvalor EQ "2">selected</cfif>>Febrero</option>
          <option value="3" <cfif PvalorMes.Pvalor EQ "3">selected</cfif>>Marzo</option>
          <option value="4" <cfif PvalorMes.Pvalor EQ "4">selected</cfif>>Abril</option>
          <option value="5" <cfif PvalorMes.Pvalor EQ "5">selected</cfif>>Mayo</option>
          <option value="6" <cfif PvalorMes.Pvalor EQ "6">selected</cfif>>Junio</option>
          <option value="7" <cfif PvalorMes.Pvalor EQ "7">selected</cfif>>Julio</option>
          <option value="8" <cfif PvalorMes.Pvalor EQ "8">selected</cfif>>Agosto</option>
          <option value="9" <cfif PvalorMes.Pvalor EQ "9">selected</cfif>>Setiembre</option>
          <option value="10" <cfif PvalorMes.Pvalor EQ "10">selected</cfif>>Octubre</option>
          <option value="11"<cfif PvalorMes.Pvalor EQ "11">selected</cfif>>Noviembre</option>
          <option value="12" <cfif PvalorMes.Pvalor EQ "12">selected</cfif>>Diciembre</option>
        </select></td>
    </tr>
    <tr> 
      <td><div align="right">Periodo Auxiliares:</div></td>
      <td> <input name="periodoAux" type="text" value="<cfoutput>#PvalorPeriodoAux.Pvalor#</cfoutput>" size="4" maxlength="4"> 
        <input name="UsaConlis" type="hidden" value="1"> <input name="InterfazConta" type="hidden" value="Sí"> 
        <input name="ParametrosDefinidos" type="hidden" value="S"> </td>
    </tr>
    <tr> 
      <td><div align="right">Mes Auxiliares:</div></td>
      <td><select name="mesAux">
          <option value="1" <cfif PvalorMesAux.Pvalor EQ "1">selected</cfif>>Enero</option>
          <option value="2" <cfif PvalorMesAux.Pvalor EQ "2">selected</cfif>>Febrero</option>
          <option value="3" <cfif PvalorMesAux.Pvalor EQ "3">selected</cfif>>Marzo</option>
          <option value="4" <cfif PvalorMesAux.Pvalor EQ "4">selected</cfif>>Abril</option>
          <option value="5" <cfif PvalorMesAux.Pvalor EQ "5">selected</cfif>>Mayo</option>
          <option value="6" <cfif PvalorMesAux.Pvalor EQ "6">selected</cfif>>Junio</option>
          <option value="7" <cfif PvalorMesAux.Pvalor EQ "7">selected</cfif>>Julio</option>
          <option value="8" <cfif PvalorMesAux.Pvalor EQ "8">selected</cfif>>Agosto</option>
          <option value="9" <cfif PvalorMesAux.Pvalor EQ "9">selected</cfif>>Setiembre</option>
          <option value="10" <cfif PvalorMesAux.Pvalor EQ "10">selected</cfif>>Octubre</option>
          <option value="11"<cfif PvalorMesAux.Pvalor EQ "11">selected</cfif>>Noviembre</option>
          <option value="12" <cfif PvalorMesAux.Pvalor EQ "12">selected</cfif>>Diciembre</option>
        </select></td>
    </tr>
    <tr> 
      <td><div align="right">Mes Fiscal:</div></td>
      <td><select name="mesFiscal">
          <option value="1" <cfif PvalorMesFiscal.Pvalor EQ "1">selected</cfif>>Enero</option>
          <option value="2" <cfif PvalorMesFiscal.Pvalor EQ "2">selected</cfif>>Febrero</option>
          <option value="3" <cfif PvalorMesFiscal.Pvalor EQ "3">selected</cfif>>Marzo</option>
          <option value="4" <cfif PvalorMesFiscal.Pvalor EQ "4">selected</cfif>>Abril</option>
          <option value="5" <cfif PvalorMesFiscal.Pvalor EQ "5">selected</cfif>>Mayo</option>
          <option value="6" <cfif PvalorMesFiscal.Pvalor EQ "6">selected</cfif>>Junio</option>
          <option value="7" <cfif PvalorMesFiscal.Pvalor EQ "7">selected</cfif>>Julio</option>
          <option value="8" <cfif PvalorMesFiscal.Pvalor EQ "8">selected</cfif>>Agosto</option>
          <option value="9" <cfif PvalorMesFiscal.Pvalor EQ "9">selected</cfif>>Setiembre</option>
          <option value="10" <cfif PvalorMesFiscal.Pvalor EQ "10">selected</cfif>>Octubre</option>
          <option value="11"<cfif PvalorMesFiscal.Pvalor EQ "11">selected</cfif>>Noviembre</option>
          <option value="12" <cfif PvalorMesFiscal.Pvalor EQ "12">selected</cfif>>Diciembre</option>
        </select></td>
    </tr>
    <tr> 
      <td><div align="right">Formato de Máscara de Placas:</div></td>
      <td><input name="mascaraPlacas" type="text" size="25" maxlength="100" value="<cfoutput>#maskPlacas.Pvalor#</cfoutput>"></td>
    </tr>
    <tr>
      <td><div align="right">Moneda Local de la Empresa:</div></td>
      <td><select name="Mcodigo" <cfif hayParametrosDefinidos EQ 1 and definidos.Pvalor EQ "O"> disabled </cfif>>
		<cfoutput query="rsMonedas">
        	<option value="#rsMonedas.Mcodigo#" <cfif rsMonedaEmpresa.Mcodigo EQ rsMonedas.Mcodigo> selected </cfif>>#rsMonedas.Mnombre#</option>
		</cfoutput>
        </select></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><div align="center"> 
          <input type="submit" name="Aceptar" value="Aceptar" onClick="javascript: return valida();">
        </div></td>
    </tr>
  </table>

<input type="hidden" name="hayParametrosDefinidos" value="<cfoutput>#hayParametrosDefinidos#</cfoutput>">
<input type="hidden" name="hayFormatoCuentasContables" value="<cfoutput>#hayFormatoCuentasContables#</cfoutput>">
<input type="hidden" name="hayPeriodo" value="<cfoutput>#hayPeriodo#</cfoutput>">
<input type="hidden" name="hayMes" value="<cfoutput>#hayMes#</cfoutput>">
<input type="hidden" name="hayPeriodoAux" value="<cfoutput>#hayPeriodoAux#</cfoutput>">
<input type="hidden" name="hayMesAux" value="<cfoutput>#hayMesAux#</cfoutput>">
<input type="hidden" name="hayMesFiscal" value="<cfoutput>#hayMesFiscal#</cfoutput>">
<input type="hidden" name="hayUsaConlis" value="<cfoutput>#hayUsaConlis#</cfoutput>">                  
<input type="hidden" name="hayInterfazConta" value="<cfoutput>#hayInterfazConta#</cfoutput>">                  
<input type="hidden" name="hayFormatoPlacas" value="<cfoutput>#hayFormatoPlacas#</cfoutput>">


</form>

<script language="JavaScript1.2">
	
	function valida() {
		<cfif rsExistenDatos.existe EQ "0">		
			if (document.form1.mascara.value == '') {
				alert("Debe digitar una máscara para el formato de cuentas contables");
				document.form1.mascara.select();
				return false;
			}
						
			if (document.form1.mes.value == '') {
				alert("Debe seleccionar un mes contable");
				document.form1.mes.focus();
				return false;
			}
	
			if (document.form1.mesAux.value == '') {
				alert("Debe seleccionar un mes para auxiliares");
				document.form1.mesAux.focus();
				return false;
			}
	
			if (document.form1.mascaraPlacas.value == '') {
				alert("Debe digitar una máscara para el formato de placas de activos fijos");
				document.form1.mascaraPlacas.select();
				return false;
			}			
			var estado = document.form1.Mcodigo.disabled;
			if (!estado) {
				if (document.form1.Mcodigo.value == '') {
					alert("Debe seleccionar una moneda para la empresa");
					document.form1.Mcodigo.focus();
					return false;
				}
			}
			
		<cfelse>
			alert('¡No es posible modificar dichos parámetros debido a que existen datos relacionados!');
			return false;
		</cfif>		
		return true;		
	}
	
</script>




