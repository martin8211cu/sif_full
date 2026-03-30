<cfset hayFormatoCuentasContables = 0 >
<cfset hayPeriodo = 0 >
<cfset hayMes = 0 >
<cfset hayPeriodoAux = 0 >
<cfset hayMesAux = 0 >
<cfset hayMesFiscal = 0 >
<cfset hayFormatoPlacas = 0 >
<cfset hayFormatoSNegocios = 0 >
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
		where Ecodigo = #Session.Ecodigo#  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn rs>
</cffunction>

<cfset definidos 			 = ObtenerDato(5)>
<cfset PvalorPeriodo 		 = ObtenerDato(30)>
<cfset PvalorMes 			 = ObtenerDato(40)>
<cfset mask 				 = ObtenerDato(10)>
<cfset PvalorPeriodoAux 	 = ObtenerDato(50)>
<cfset PvalorMesAux 		 = ObtenerDato(60)>
<cfset PvalorMesFiscal 		 = ObtenerDato(45)>
<cfset PvalorMesCorporativo	 = ObtenerDato(46)>
<cfset maskPlacas 			 = ObtenerDato(250)>
<cfset maskSNegocios 		 = ObtenerDato(611)>
<cfset rsPlanCuentas 		 = ObtenerDato(1)>
<cfset rsConLetras 			 = ObtenerDato(12)>
<cfset rsActividadEmprearial = ObtenerDato(2200)>
<cfset rsformularPor         = ObtenerDato(2300)>
<cfset rsOrdenCtsAnti		 = ObtenerDato(2500)>
<cfset rsProveduriaCorp		 = ObtenerDato(5100)>


<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>
<cfif mask.Recordcount GT 0 ><cfset hayFormatoCuentasContables = 1 ></cfif>
<cfif PvalorPeriodo.Recordcount GT 0 ><cfset hayPeriodo = 1 ></cfif>
<cfif PvalorMes.Recordcount GT 0 ><cfset hayMes = 1 ></cfif>
<cfif PvalorPeriodoAux.Recordcount GT 0 ><cfset hayPeriodoAux = 1 ></cfif>
<cfif PvalorMesAux.Recordcount GT 0 ><cfset hayMesAux = 1 ></cfif>
<cfif PvalorMesFiscal.Recordcount GT 0 ><cfset hayMesFiscal = 1 ></cfif>
<cfif maskPlacas.Recordcount GT 0 ><cfset hayFormatoPlacas = 1 ></cfif>
<cfif maskSNegocios.Recordcount GT 0 >
	<cfset hayFormatoSNegocios = 1 >
	<cfset maskSNegociosR=maskSNegocios.Pvalor>
<cfelse>
	 <cfset maskSNegociosR= 'XXX-XXXX'>
</cfif>

<!--- Verifica si es posible insertar/modificar los parámetros para esta empresa si hay datos en:
 las tablas EContables o en SaldosContables o en Cuentas Contables --->

	<cfset varExiste = false>
	<cfquery name="rsExistenDatosEC" datasource="#Session.DSN#">
		select count(1)
		from EContables 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined('rsExistenDatosEC') and rsExistenDatosEC.recordCount GT 0>
		<cfset varExiste = true>
	<cfelse>
		<cfquery name="rsExistenDatosSC" datasource="#Session.DSN#">
			select count(1)
			from SaldosContables 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
		<cfif isdefined('rsExistenDatosSC') and rsExistenDatosSC.recordCount GT 0>
			<cfset varExiste = true>
		<cfelse>
			<cfquery name="rsExistenDatosCC" datasource="#Session.DSN#">
				select count(1) 
				from CContables 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfif isdefined('rsExistenDatosCC') and rsExistenDatosCC.recordCount GT 0>
				<cfset varExiste = true>
			</cfif>			
		</cfif>
	</cfif>
	

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
	select Mcodigo from Empresas 
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
	<table width="95%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right" nowrap valign="middle">M&aacute;scara de Cat&aacute;logo Contable:&nbsp;</td>
			<td valign="top">
				<input name="mascara" type="text" size="25" maxlength="100" value="<cfoutput>#mask.Pvalor#</cfoutput>">
			</td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Formato de m&aacute;scara que utilizar&aacute; el Cat&aacute;logo Contable de su Empresa.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><td colspan="5"><hr size=0></td></tr>
		<tr>
			<td align="right" nowrap>Per&iacute;odo Contable:&nbsp;</td>
			<td><input name="periodo" type="text" value="<cfoutput>#PvalorPeriodo.Pvalor#</cfoutput>" size="4" maxlength="4"></td>
			<td align="center" rowspan="2">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
							<p align="justify">Indique el <strong>per&iacute;odo</strong> (a&ntilde;o fiscal) y el <strong>mes</strong> (mes fiscal) en que se iniciar&aacute; con la operaci&oacute;n del sistema. Una vez definido este per&iacute;odo y mes se generar&aacute;n saldos iniciales en cero para todas las cuentas de arranque.</p>
						</td>
					</tr>
				</table>	
			</td>
		</tr>	
		<tr>
			<td nowrap align="right">Mes Contable:&nbsp;</td>
			<td>
				<select name="mes">
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
				</select>
			</td>
		</tr>

		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right">Per&iacute;odo Auxiliares:&nbsp;</td>
			<td>
				<input name="periodoAux" type="text" value="<cfoutput>#PvalorPeriodoAux.Pvalor#</cfoutput>" size="4" maxlength="4"> 
				<input name="UsaConlis" type="hidden" value="1">
				<input name="InterfazConta" type="hidden" value="Sí"> 
				<input name="ParametrosDefinidos" type="hidden" value="S">
			</td>
			<td rowspan="2">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Al igual que el m&oacute;dulo de contabilidad, los auxiliares contables manejan su propio per&iacute;odo y mes de operaci&oacute;n. El <strong>per&iacute;odo</strong> y <strong>mes</strong> de auxiliares (el cual es el mismo para todos los sistemas perif&eacute;ricos a la contabilidad), nunca podr&aacute; ser menor al per&iacute;odo y mes de la contabilidad. Indique estos par&aacute;metros de arranque de los auxiliares.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>

		<tr> 
			<td align="right">Mes Auxiliares:&nbsp;</td>
			<td>
				<select name="mesAux">
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
				</select>
			</td>
		</tr>
		
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right">Mes de Cierre Fiscal:&nbsp;</td>
			<td>
				<select name="mesFiscal">
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
				</select>
			</td>
			<td rowspan="2">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Como parte de la legislaci&oacute;n tributaria y fiscal de cada pa&iacute;s, es necesario definir el &uacute;ltimo <strong>mes</strong> contable sobre el cual se realizar&aacute; el cierre anual de operaci&oacute;n de la compa&ntilde;&iacute;a. Indique el mes donde se realizar&aacute; el corte anual. </p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<tr> 
		<cfif PvalorMesFiscal.Pvalor NEQ "">
			<cfif PvalorMesCorporativo.Pvalor EQ "">
				<cfset PvalorMesCorporativo = PvalorMesFiscal>
			</cfif>
			<td align="right">Mes de Cierre Corporativo:&nbsp;</td>
			<td>
				<cfif PvalorMesCorporativo.Pvalor NEQ PvalorMesFiscal.Pvalor>
				<strong><font color="#0000FF">
				</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "1">Enero</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "2">Febrero</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "3">Marzo</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "4">Abril</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "5">Mayo</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "6">Junio</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "7">Julio</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "8">Agosto</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "9">Setiembre</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "10">Octubre</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "11">Noviembre</cfif>
					<cfif PvalorMesCorporativo.Pvalor EQ "12">Diciembre</cfif>
				<cfif PvalorMesCorporativo.Pvalor NEQ PvalorMesFiscal.Pvalor>
				</font></strong>
				</cfif>
			</td>
		</cfif>
		</tr>
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right">Máscara de Placas:&nbsp;</td>
			<td><input name="mascaraPlacas" type="text" size="25" maxlength="100" value="<cfoutput>#maskPlacas.Pvalor#</cfoutput>"></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Formato de m&aacute;scara que utilizaran las placas en Activos Fijos.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<!---Mascara del socio de Negocios--->
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right">Máscara del Socio de Negocios:&nbsp;</td>
			<td><input name="mascaraSNegocios" type="text" size="25" maxlength="100" value="<cfoutput>#maskSNegociosR#</cfoutput>"></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Formato de m&aacute;scara que utilizaran en los Socios de Negocios. Utilice 'X' para letras, '?' para numeros y '*' para letras y números. </p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><td colspan=5><hr size=0></td></tr>

		<tr>
			<td align="right">Moneda Local de la Empresa:&nbsp;</td>
			<td>
				<select name="Mcodigo" <cfif hayParametrosDefinidos EQ 1 and definidos.Pvalor EQ "O"> disabled </cfif>>
					<cfoutput query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#" <cfif rsMonedaEmpresa.Mcodigo EQ rsMonedas.Mcodigo> selected </cfif>>#rsMonedas.Mnombre#</option>
					</cfoutput>
				</select>
			</td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Moneda por defecto que utilizar&aacute; la empresa.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>

		<tr><td colspan=5><hr size=0></td></tr>
		<tr>
			<td align="right">Usa Plan de Cuentas:&nbsp;</td>
			<td><input type="checkbox" name="chkPlanCuentas" <cfif rsPlanCuentas.RecordCount gt 0 and rsPlanCuentas.Pvalor eq 'S' >checked</cfif> ></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Utiliza Plan de Cuentas.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>

		<tr><td colspan=5><hr size=0></td></tr>
		<tr>
			<td align="right" nowrap>Permite Letras en la Cuenta Financiera:&nbsp;</td>
			<td><input type="checkbox" name="chkConLetras" <cfif rsConLetras.RecordCount gt 0 and rsConLetras.Pvalor eq 'S' >checked</cfif>></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Permite Letras en la Cuenta Financiera.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<!---►►Parametro 2: Construcción de Cuentas por Complemento Financiero del Origen Contable◄◄--->
		<!---►►Tipos S=Normal, N=Por Origen Contable◄◄--->
		<cfset rsCtaOrigenCotable	 = ObtenerDato(2)>
        <tr><td colspan=5><hr size=0></td></tr>
        <tr>
			<td align="right" nowrap>Construcción de Cuentas por Origen Contable:&nbsp;</td>
			<td><input type="checkbox" name="chkCtaOrigenCotable" <cfif rsCtaOrigenCotable.RecordCount GT 0 AND rsCtaOrigenCotable.Pvalor EQ 'N' >checked</cfif> <cfif rsCtaOrigenCotable.RecordCount eq 0 >checked</cfif>></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Construcción de Cuentas por Complemento Financiero del Origen Contable.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>		
		<tr><td colspan=5><hr size=0></td></tr>
        <!---►►Parametro 5200: Indicar Cuentas Contables Manualmente◄◄--->
        <cfset rsCuentaManual = ObtenerDato(5200)>
        <!---►►Parametro 5400: Indicar Cuentas Contables Manualmente en CxC◄◄--->
        <cfset rsCuentaManualCxC = ObtenerDato(5400)>
        <!---►►Parametro 890: Construcción de Cuentas para Conceptos de Servicio◄◄--->
        <cfset rsConsCuentConSer = ObtenerDato(890)>
        <!---►►Parametro 892: Construcción de Cuentas para Consumo de Invbentarios◄◄--->
        <cfset rsConsCuentConInv = ObtenerDato(892)>
        <tr>
			<td align="right" nowrap>Permitir cambiar Cuentas Manualmente:&nbsp;</td>
			<td><input type="checkbox" name="chkCuentaManual" <cfif rsCuentaManual.RecordCount gt 0 and rsCuentaManual.Pvalor eq 'S' >checked</cfif> <cfif rsCuentaManual.RecordCount eq 0 >checked</cfif>></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Construcción de Cuentas para Conceptos de Servicio</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
        <tr>
			<td align="right" nowrap>Permitir cambiar Cuentas Manualmente en CxC:&nbsp;</td>
			<td><input type="checkbox" name="chkCuentaManualCxC" <cfif rsCuentaManualCxC.RecordCount gt 0 and rsCuentaManualCxC.Pvalor eq 'S' >checked</cfif> <cfif rsCuentaManualCxC.RecordCount eq 0 >checked</cfif>></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Construcción de Cuentas para Conceptos de Servicio en CxC</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>		
        <tr>
			<td align="right" nowrap>
				Construcción de Cuentas para Servicios:&nbsp;
			</td>
			<td colspan="2">
            	<select name="ConsCuentConSer">
                    <option value=""  <cfif rsConsCuentConSer.Pvalor eq ''>selected</cfif>>Mascara de Gasto en CF + complemento en Clasificacion/Concepto Servicio</option>
                    <option value="2" <cfif rsConsCuentConSer.Pvalor eq 2>selected</cfif> >Mascara de Gasto en Concepto Servicio + complemento en SN</option>
					<option value="3" <cfif rsConsCuentConSer.Pvalor eq 3>selected</cfif> >Mascara de Gasto en Concepto Servicio + complemento en Centro Funcional + Complemento en Socio de Negocio</option>
                </select>
			</td>
        </tr>
        <tr>
			<td align="right" nowrap>
				Construcción de Cuentas para Consumo de Inventarios:&nbsp;
			</td>
			<td colspan="2">
            	<select name="ConsCuentConInv">
                    <option value="1" <cfif rsConsCuentConInv.Pvalor eq 1>selected</cfif> >Mascara de Gasto por Consumo en Centro Funcional + Complemento de Objeto del Gasto</option>                    
                    <option value="2" <cfif rsConsCuentConInv.Pvalor eq 2>selected</cfif> >Mascara de Gasto por Consumo en Clasificación de Artículo + Complemento en CF + Complemento en Socio de Negocio</option>                    
                </select>
			</td>
        </tr>
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td align="right">Formular Por:&nbsp;</td>
			<td>
				<select name="formularPor">
					<option value="0" <cfif rsformularPor.Pvalor EQ "0">selected</cfif>>Cuentas</option>
					<option value="1" <cfif rsformularPor.Pvalor EQ "1">selected</cfif>>Plan de compras</option>					
				</select>
			</td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Concepto De Formulación.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<tr><td colspan=5><hr size=0></td></tr>
		<!---Activar Transaccionabilidad de Actividad Empresarial--->
		<tr>
			<td align="right" nowrap>Activar Transaccionabilidad de Actividad Empresarial:&nbsp;</td>
			<td><input type="checkbox" name="chkActividadEmpresarial" value="S" <cfif rsActividadEmprearial.RecordCount gt 0 and rsActividadEmprearial.Pvalor eq 'S' >checked</cfif>></td>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
							<p align="justify">Activar para utilizar la actividad empresarial  para remplazar los "_" de las máscaras Financieras.</p>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<!---Orden de las cuentas para Anticipos--->
		<tr><td colspan=5><hr size=0></td></tr>
		<tr>
			<td align="right" nowrap>Orden de las cuentas para Anticipos(CXP/CXC):&nbsp;</td>
			<td>
				 <select name="rsOrdenCtsAnti">
					<option value="1" <cfif rsOrdenCtsAnti.Pvalor EQ "1">selected</cfif>>Configuración Default</option>
					<option value="2" <cfif rsOrdenCtsAnti.Pvalor EQ "2">selected</cfif>>Configuracion Avanzada</option>					
				</select>
			<td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td align="center">
						  <p align="center"><strong>Configuración Default</strong></p>
						  	<p align="left"> 1-Cta de Excepción por Transacciones<br />2-Cta predeterminada para el Socio</p>
						  <p align="center"><strong>Configuración Avanzada</strong></p>
							 <p align="left">1-Cta de Excepción por Transacciones<br />2-Cta Parámetro de cuenta de Anticipos<br />3-Cta predeterminada para el Socio</p>						
						</td>	
					</tr>
				</table>
			</td>
		</tr>
        <!--- Activar Proveeduría Corporativa  --->
		<tr><td colspan=5><hr size=0></td></tr>
        <tr>
			<td align="right" nowrap>Activar Proveedur&iacute;a Corporativa:&nbsp;</td>
			<td><input type="checkbox" name="chkProvCorp" value="S" <cfif rsProveduriaCorp.RecordCount gt 0 and rsProveduriaCorp.Pvalor eq 'S' >checked</cfif>><td>
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
						  <p>Activar Proveedur&iacute;a Corporativa</p>					
						</td>	
					</tr>
				</table>
			</td>
		</tr>
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td colspan="4" align="center">
				<input type="submit" class="btnGuardar" name="<cfif varExiste EQ false>Aceptar<cfelse>Modificar</cfif>" value="Aceptar" 
					   onClick="javascript: return valida();">

			</td>
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
<input type="hidden" name="hayFormatoSNegocios" value="<cfoutput>#hayFormatoSNegocios#</cfoutput>">
<input type="hidden" name="hayPlanCuentas" value="<cfif rsPlanCuentas.RecordCount gt 0 and rsPlanCuentas.Pvalor eq 'S'>1<cfelseif rsPlanCuentas.RecordCount gt 0 and rsPlanCuentas.Pvalor eq 'N'>0<cfelse>-1</cfif>">
<input type="hidden" name="hayCuentaManual" value="<cfif rsCuentaManual.RecordCount gt 0 and rsCuentaManual.Pvalor eq 'S'>1<cfelseif rsCuentaManual.RecordCount gt 0 and rsCuentaManual.Pvalor eq 'N'>0<cfelse>-1</cfif>">
<input type="hidden" name="hayConLetras" value="<cfif rsConLetras.RecordCount gt 0 and rsConLetras.Pvalor eq 'S'>1<cfelseif rsConLetras.RecordCount gt 0 and rsConLetras.Pvalor eq 'N'>0<cfelse>-1</cfif>">


<!---<input type="hidden" name="hayNomina" value="<cfif rsNomina.RecordCount gt 0 and rsNomina.Pvalor eq 'S'>1<cfelseif rsNomina.RecordCount gt 0 and rsNomina.Pvalor eq 'N'>0<cfelse>-1</cfif>">--->

</form>

<script language="JavaScript1.2">
	function valida() {
		<cfif varExiste EQ false>		
			document.form1.Modificar.value = 'SiAceptaCC';
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
			if (document.form1.mascaraSNegocios.value == '') {
				alert("Debe digitar una máscara para el Socio de Negocios");
				document.form1.mascaraSNegocios.select();
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
			alert('Los únicos parámetros que puede modificar son: \n  - Máscara del Socio de Negocios (si existe solo el socio genérico) \n  - Indicador de Plan Contable \n  - Indicador de Cuenta Manual\n  - Permite Letras en Cuenta Financiera \n  - Activar Transaccionabilidad de Actividad Empresarial\n  - Orden de las cuentas para Anticipos(CXP/CXC)\nLos demás parámetros que tienen datos relacionados no van a ser modificados.');
			return true;
		</cfif>		
		return true;		
	}
</script>