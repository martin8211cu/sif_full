
<!--- VARIABLES Y PARAMETROS --->
<cfset LvarSinSaldosCero = false>
<cfset LvarModo = "">
<cfset ctainicial = "">
<cfset ctafinal = "">
<cfset navegacion = "">
<cfif isDefined("url.modo")>
	<cfset LvarModo = "#url.modo#">
</cfif>
<cfif isDefined("url.periodo")>
	<cfset form.periodo = "#url.periodo#">
</cfif>
<cfif isDefined("url.mes")>
	<cfset form.mes = "#url.mes#">
</cfif>
<cfif isDefined("url.ctainicial")>
	<cfset form.cmayor_ccuenta1 = "#url.cmayor_ccuenta1#">
</cfif>
<cfif isDefined("url.ctafinal")>
	<cfset form.cmayor_ccuenta2 = "#url.cmayor_ccuenta2#">
</cfif>
<cfif isDefined("url.sinsaldoscero")>
	<cfset LvarSinSaldosCero = true>
</cfif>
<cfif isDefined("url.fechaIni")>
	<cfset form.fechaIni = "#url.fechaIni#">
</cfif>
<cfif isDefined("url.fechaFin")>
	<cfset form.fechaFin = "#url.fechaFin#">
</cfif>

<cfif isDefined("form.sinsaldoscero")>
	<cfset LvarSinSaldosCero = true>
</cfif>
<cfif isDefined("form.modo")>
	<cfset LvarModo = "#form.modo#">
</cfif>

<cfset navegacion = navegacion & "modo=#LvarModo#">



<cfif isDefined("form.cmayor_ccuenta1")>
	<cfset ctainicial = "#form.cmayor_ccuenta1#">
</cfif>

<cfif isDefined("form.cmayor_ccuenta2")>
	<cfset ctafinal = "#form.cmayor_ccuenta2#">
</cfif>


<!--- QUERYS --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Eperiodo desc
</cfquery>

<cfquery name="rsMeses" datasource="sifControl" cachedwithin="#createtimespan(0,1,0,0)#">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
	from Idiomas a, VSidioma b
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>
<!--- <cfdump var="#form.sinsaldoscero#"> --->
<cfif isDefined("LvarModo") AND #LvarModo# EQ "consulta">
	<cfset navegacion = navegacion & "&periodo=#form.periodo#">
	<cfset navegacion = navegacion & "&mes=#form.mes#">

	<cfquery name="nivel" datasource="#Session.DSN#">
		SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="valOrden" datasource="#Session.DSN#">
		SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfset lvarValorN = "">
	<cfset lvarValorS = "">
	<cfif #nivel.Pvalor# neq '-1'>
		<cfset lvarValorN = "AND (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
		<cfelse>
		<cfset lvarValorS = "and cc.Cmovimiento = 'S'">
	</cfif>

	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		SELECT cc.Ccuenta, cc.Cformato as cuenta, cc.Cmayor,
		       det.SLinicial as saldoInicial,
		       (det.SLinicial + det.DLdebitos - det.CLcreditos) as saldoFinal,
		       det.CEBperiodo,
		       det.CEBmes,
		       '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' style=''cursor:pointer'' alt=''Ver'' onclick=''verDetallePoliza('+ cast(cc.Ccuenta as varchar) + ');''>' as logoVer
		FROM CContables cc,
		     CEBalanzaSAT ba,
		     CEBalanzaDetSAT det,
		     HEContables he,
		     HDContables hd
		WHERE cc.Ccuenta = det.Ccuenta
		  AND cc.Ccuenta = hd.Ccuenta #PreserveSingleQuotes(lvarValorS)# #PreserveSingleQuotes(lvarValorN)#
  	      AND hd.IDcontable = he.IDcontable
		  AND det.CEBalanzaId = ba.CEBalanzaId
		  AND ba.CEBperiodo = det.CEBperiodo
		  AND ba.CEBmes = det.CEBmes
		  AND ba.CEBperiodo = he.Eperiodo
		  AND ba.CEBmes = he.Emes
		  AND ba.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
		  AND ba.CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
		  and ba.GEid = -1
		  <cfif isDefined("form.cmayor_ccuenta1") AND #form.cmayor_ccuenta1# NEQ "">
		  	AND cc.Cmayor >= <cfqueryparam value="#Trim(form.cmayor_ccuenta1)#" cfsqltype="cf_sql_varchar">
		  	<cfset navegacion = navegacion & "&ctainicial=#form.cmayor_ccuenta1#">
		  </cfif>
		  <cfif isDefined("form.cmayor_ccuenta2") AND #form.cmayor_ccuenta2# NEQ "">
		  	AND cc.Cmayor <= <cfqueryparam value="#Trim(form.cmayor_ccuenta2)#" cfsqltype="cf_sql_varchar">
		  	<cfset navegacion = navegacion & "&ctafinal=#form.cmayor_ccuenta2#">
		  </cfif>

		  <cfif isDefined("LvarSinSaldosCero") AND LvarSinSaldosCero>
		  	AND det.SLinicial != 0
		  	AND (det.SLinicial + det.DLdebitos - det.CLcreditos) != 0
		  	<cfset navegacion = navegacion & "&sinsaldoscero=true">
		  </cfif>
		  <cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
		  	AND he.ECfechacreacion >= <cfqueryparam value="#form.fechaIni#" cfsqltype="cf_sql_date">
		  	<cfset navegacion = navegacion & "&fechaIni=#form.fechaIni# ">
		  </cfif>
		  <cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
		  	AND he.ECfechacreacion <= <cfqueryparam value="#form.fechaFin#" cfsqltype="cf_sql_date">
		  	<cfset navegacion = navegacion & "&fechaFin=#form.fechaFin#">
		  </cfif>
		GROUP BY cc.Ccuenta,
         cc.Cmayor, cc.Cformato,
         det.SLinicial,
         (det.SLinicial + det.DLdebitos - det.CLcreditos),
         det.CEBperiodo,
         det.CEBmes
		ORDER BY cc.Cmayor
	</cfquery>
</cfif>

<cfinclude template="../../../Utiles/sifConcat.cfm">

<cf_templateheader title="Reporte Auxiliar de Cuentas y/o Subcuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="XML Reporte Auxiliar de Cuentas y/o Subcuentas">
		<cfinclude template="../../../portlets/pNavegacion.cfm">
		<cfoutput>
			<cfform action="list.cfm" method="post" name="form1" style="margin:0;">
			<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td><strong><cf_translate key=LB_Todos>Periodo</cf_translate>:</td>
					<td><strong><cf_translate key=LB_Todos>Mes</cf_translate>:</td>
					<td><strong><cf_translate key=LB_Todos>Fecha inicial</cf_translate>:</strong></td>
					<td><strong><cf_translate key=LB_Todos>Fecha final</cf_translate>:</strong></td>
				</tr>
				<tr>
					<!--- CUENTA INICIAL --->
					<td><strong><cf_translate key=LB_Todos>Cuenta Inicial</cf_translate>:</strong></td>
					<td nowrap>
						<cfset ctamayor = "">
						<cfif isdefined('form.cmayor_ccuenta1') and form.cmayor_ccuenta1 NEQ "">
							<cfset ctamayor = form.cmayor_ccuenta1>
						</cfif>
						<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" idquery="#ctamayor#" size="30" tabindex="9">
					</td>
					<!--- <td>
						 <input type="text" name="CtaInicial" id="CtaInicial" size="45" value="#ctainicial#">
					</td> --->
					<td width="70">&nbsp;</td>
					<!--- PERIODO --->
					<td>
						<select name="periodo">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsPeriodo">
								<option value="#Eperiodo#" <cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>>
									#Eperiodo#
								</option>
							</cfloop>
						</select>
					</td>
					<!--- MES --->
					<td>
						<select name="mes">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsMeses">
								<option value="#VSvalor#" <cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>>
									#VSdesc#
								</option>
							</cfloop>
						</select>
					</td>


					<td>
						<cfset fechaIni = ''>
						<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
						<cfset fechaIni = form.fechaIni>
						</cfif>
						<cf_sifcalendario name="fechaIni" value="#fechaIni#" form="form1">
					</td>

					<td>
						<cfset fechaFin = ''>
						<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
						<cfset fechaFin = form.fechaFin>
						</cfif>
						<cf_sifcalendario name="fechaFin" value="#fechaFin#" form="form1">
					</td>
				</tr>
				<tr>
					<td><strong><cf_translate key=LB_Todos>Cuenta Final</cf_translate>:</strong></td>
					<td nowrap>
						<cfset ctamayor2 = "">
						<cfif isdefined('form.cmayor_ccuenta2') and form.cmayor_ccuenta2 NEQ "">
							<cfset ctamayor2 = form.cmayor_ccuenta2>
						</cfif>
						<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2" idquery="#ctamayor2#" size="30" tabindex="10">
					</td>
					<!--- <td>
						<input type="text" name="CtaFinal" id="CtaFinal" size="45" value="#ctafinal#">
					</td> --->
					<td colspan="2">
						<input type="checkbox" name="sinSaldosCero" id="sinSaldosCero" <cfif LvarSinSaldosCero> checked<cfelse> unchecked</cfif>><b><i><cf_translate key = LB_CierreAnual>No incluir Saldos cero</cf_translate></i></b>
					</td>
					<td>
						<cfif isDefined("LvarModo") AND #LvarModo# EQ "consulta" AND #rsConsulta.recordcount# GT 0>
							<input type="button" class="btnAplicar" value="Preparar" onClick="AbreVentanaModal()" />
						</cfif>
					</td>
					<td>
						<cfif isDefined("LvarModo") AND #LvarModo# EQ "consulta" AND #rsConsulta.recordcount# GT 0>
							<input type="button" name="btnFiltrar" id="btnFiltrar" onClick="imprimir()" value="Imprimir" class="btnImprimir">
						</cfif>
					</td>
					<td align="center">
						<input type="hidden" name="modo" id="modo" value="#LvarModo#">
						<input type="button" name="btnFiltrar" id="btnFiltrar" onClick="validaDatos()" value="Filtrar" class="btnFiltrar">
						<INPUT type="hidden" id="tipoSol">
						<INPUT type="hidden" id="NumSol">
						<INPUT type="hidden" id="NumTram">

					</td>
				</tr>
				<tr>
					<td valign="top" colspan="7">
						<cfif isDefined("LvarModo") AND #LvarModo# EQ "consulta" AND #rsConsulta.recordcount# GT 0>
							<cf_sifIncluirSelloDigital mostrar="h" nombre="incSelloDigital">
							<cfelse>
								&nbsp;	
						</cfif>
					</td>
				</tr>
			</table>
		</cfform>
		<cfif isDefined("LvarModo") AND #LvarModo# EQ "consulta">

			<cfinvoke
             component="sif.Componentes.pListas"
             method="pListaQuery"
             returnvariable="pListaRet">
                <cfinvokeargument name="query" 				value="#rsConsulta#"/>
                <cfinvokeargument name="desplegar" 			value="cuenta,saldoInicial,saldoFinal,logoVer"/>
                <cfinvokeargument name="etiquetas" 			value="Cuenta,Saldo Inicial,Saldo Final,Ver"/>
                <cfinvokeargument name="formatos"           value="V,M,M,V"/>
                <cfinvokeargument name="align" 				value="left,right,right,center"/>
                <cfinvokeargument name="ajustar" 			value="S"/>
                <cfinvokeargument name="irA" 				value="list.cfm"/>
                <cfinvokeargument name="keys" 				value="Ccuenta"/>
                <cfinvokeargument name="incluyeform"		value="false"/>
                <cfinvokeargument name="formname" 			value="form1"/>
                <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                <cfinvokeargument name="showLink" 			value="false"/>
				<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
				<cfinvokeargument name="EmptyListMsg" 		value="No se encontraron registros. Revise que para el periodo #form.periodo# mes #form.mes# haya una balanza de comprobación."/>
                <cfinvokeargument name="debug" value="N"/>
            </cfinvoke>
		</cfif>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>




<script language="javascript" type="text/javascript">

var popupDetallesPoliza

	function validaDatos(){
		document.form1.modo.value = "consulta"
		var anio = document.form1.periodo.value
		var mes = document.form1.mes.value
		if(anio == "-1"){
			alert('Favor de seleccionar un periodo.')
		}else if(mes == "-1"){
			alert('Favor de seleccionar un mes.')
		}else{
			document.form1.action = "list.cfm?"
			document.form1.submit();
		}

	}

	function prepararXML(varUrl){
		document.form1.action = "generarXML.cfm"+varUrl
		document.form1.submit();
	}

	function imprimir(){
		var url = "<cfoutput>#navegacion#</cfoutput>";
		document.form1.action = "print.cfm?"+url
		document.form1.submit();
	}

	function verDetallePoliza(cuentaID){
		var pagina = "infoPoliza.cfm";
		var url = "<cfoutput>#navegacion#</cfoutput>";
		popupDetallesPoliza = window.open(pagina+"?"+url+"&cuentaID="+cuentaID,"Detalle_de_polizas","left=250px,top=85px,width=800px,height=550px,status=no,directories=no,menubar=no,toolbar=no,scrollbars=yes,location=no,resizable=no,titlebar=no")
	}
	function AbreVentanaModal(){
	//creamos una variable de tipo array para pasar y recuperar los datos
	var datos=new Array();
		var tipoSolicitud = "";
		var numOrden = "";
		var numTramite = "";
		var url = "";
		var stop = false;
		
		var varincSellado = document.getElementById("chk_incSelloDigital");
		var incSellado = false;
		if(varincSellado) 
			incSellado = varincSellado.checked;
		var extKey;
		var extCer;
		
		

		if(incSellado){
			var key_incSelloDigital = document.getElementById("key_incSelloDigital").value;
			var cer_incSelloDigital = document.getElementById("cer_incSelloDigital").value;
			var psw_incSelloDigital = document.getElementById("psw_incSelloDigital");


			if(key_incSelloDigital == ""){
				stop = true;
				alert("Favor de seleccionar el archivo llave.");
			} else if((key_incSelloDigital.substring(key_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".key"){
				stop = true;
				alert("Favor de seleccionar un archivo llave valido.");
			} else if(cer_incSelloDigital == ""){
				stop = true;
				alert("Favor de seleccionar el certificado.");
			} else if((cer_incSelloDigital.substring(cer_incSelloDigital.lastIndexOf("."))).toLowerCase() != ".cer"){
				stop = true;
				alert("Favor de seleccionar un certificado valido.");
			} else if(psw_incSelloDigital.value == ""){
				stop = true;
				alert("Favor de ingresar la clave.");
				psw_incSelloDigital.focus();
			} else{
				stop = false;
			}
		}


		if(stop == false){
			datos[0]=document.getElementById('tipoSol').value;
			datos[1]=document.getElementById('NumSol').value;
			datos[2]=document.getElementById('NumTram').value;

			//aqui paso los datos a la ventana hija
		datos=showModalDialog('popupInfoAdicional.cfm',datos,'status:no;resizable:yes;dialogTop:250px;dialogLeft:430px;dialogWidth:400px;dialogHeight:270px;scroll:yes');
		//aqui recuepero datos de la ventana hija
		document.getElementById("tipoSol").value=datos[0];
		document.getElementById("NumSol").value=datos[1];
		document.getElementById("NumTram").value=datos[2];
		tipoSolicitud = document.getElementById("tipoSol").value;
		numOrden = document.getElementById("NumSol").value;
		numTramite = document.getElementById("NumTram").value;
		// Validacion de datos recuperados
		url = "<cfoutput>?#navegacion#</cfoutput>"+"&tipoSolicitud="+tipoSolicitud+"&numOrden="+numOrden+"&numTramite="+numTramite;
		prepararXML(url);
}
	}
</script>