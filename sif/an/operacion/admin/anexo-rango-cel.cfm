<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfparam name="url.MultipleCell" default="0">
<cfparam name="modo" default="ALTA">

<cfif isdefined('url.Ppagina')>
	<cfset form.Ppagina = #url.Ppagina#>
</cfif>

<cfparam name="url.AnexoCelId" default="">

<cfif Len(trim(url.AnexoCelId)) NEQ 0>
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	SELECT CAcodigo, CAdescripcion FROM ConceptoAnexos
</cfquery>

<cfif rsConceptos.recordCount NEQ 36>
	<cfset rsConceptos = fnActualizaConceptos()>
</cfif>

<cfquery name="rsFormulaciones" datasource="#Session.DSN#">
	SELECT ANFid, ANFcodigo, ANFdescripcion FROM ANformulacion
</cfquery>

<cfquery name="rsHomologaciones" datasource="#Session.DSN#">
	SELECT ANHid, ANHcodigo, ANHdescripcion FROM ANhomologacion
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	SELECT Ocodigo, Odescripcion FROM Oficinas where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="vars" datasource="#Session.DSN#">
	SELECT AVid, AVnombre, AVdescripcion
	from AnexoVar
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by AVnombre
</cfquery>

<cfquery name="rsMesFiscal" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 45
	and Ecodigo = #session.Ecodigo#
</cfquery>
<cfset LvarMesCierre = rsMesFiscal.Pvalor>

<cfquery name="rsMesCorporativo" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 46
	and Ecodigo = #session.Ecodigo#
</cfquery>
<cfset LvarMesCierreCorporativo = rsMesCorporativo.Pvalor>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as VSvalor, b.VSdesc
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsLinea" datasource="#Session.DSN#">
	select 
		AnexoFila, AnexoColumna, AnexoFor,
		<cf_dbfunction name="to_char" args="AnexoCelId"> as AnexoCelId, 
		<cf_dbfunction name="to_char" args="AnexoId"> as AnexoId, 
		AnexoHoja, AnexoRan, AnexoCon, 
		AnexoRel, AnexoMes, AnexoPer, AnexoNeg ,
		AVid, 
		Ecodigocel, Ocodigo, GOid, GEid
		, CPtipoSaldo, ANFid, ANHid, ANHCid
		, coalesce(Mcodigo,-1) as Mcodigo, ACmLocal
	from AnexoCel 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	 <cfif isdefined("url.AnexoCelId") and Len(Trim(url.AnexoCelId)) neq 0>
	  and AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
	 </cfif>
</cfquery>

<cfquery name="rsAnexo" datasource="#Session.DSN#">
	select AnexoSaldoConvertido
	  from Anexo
	 where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>


<script language="JavaScript" type="text/JavaScript">
	<!--
	/*
	<!--- 
	function MostrarCuentas(){
	<cfoutput>
		window.open("anexo.cfm?tab=2&cta=1&AnexoId=#JSStringFormat(url.AnexoId)#&AnexoCelId=#JSStringFormat(url.AnexoCelId)#&pagina=#PageNum_rsRangosUnion#",'_self');
	</cfoutput>
	 --->
	}*/
	
	var GvarConceptoAnt = 0;
	function OcultarPer(valor) {
		if (! document.getElementById("AnexoCon") )
			return;
			
		var LvarConcepto = parseInt(document.getElementById("AnexoCon").value)
		if ( (LvarConcepto >= 35) && (LvarConcepto <= 39) )
		{
			valor = false;
			document.formAnexoRangoCel.AnexoRel.checked = false;
		}
			
		if (valor) 
		{
			document.formAnexoRangoCel.AnexoPer.value=0;

			document.formAnexoRangoCel.Meses.style.display="none";
			document.formAnexoRangoCel.AnexoPer.style.display="none";
			document.formAnexoRangoCel.lblPeriodo.style.display="none";
			document.formAnexoRangoCel.AnexoMes.style.display="inline";
		}
		else 
		{
			document.formAnexoRangoCel.Meses.style.display="inline";
			document.formAnexoRangoCel.AnexoPer.style.display="inline";
			document.formAnexoRangoCel.lblPeriodo.style.display="inline";
			document.formAnexoRangoCel.AnexoMes.style.display="none";
		}
	}
	
	function onchange_concepto(valor,ini) {
		<cfif modo EQ "CAMBIO">
		/*
		if (document.formAnexoRangoCel.btnCuentas){
			document.formAnexoRangoCel.btnCuentas.style.visibility=(parseInt(valor)<20)?"hidden":"visible";
		}
		*/
		</cfif>
		
		/*Habilita el botón de Filtro por Concepto solamente si el concepto es alguno de los siguientes:
		Débitos Mes, Créditos Mes, Movimiento Mes, Débitos Periodo, Créditos Período, Movimiento Período.*/
		if (valor == 22 || valor == 23 || valor == 24 || valor == 32 || valor == 33 || valor == 34) {
			document.formAnexoRangoCel.btnFiltroPorConcepto.disabled = false;} 
		else {
			document.formAnexoRangoCel.btnFiltroPorConcepto.disabled = true;
		}

		<!-- Manejo de los campos adicionales al concepto --->		
		document.formAnexoRangoCel.colWidth.style.display			= "none";
		document.formAnexoRangoCel.colWidth.disabled 				= true;
		document.formAnexoRangoCel.AVid.style.display				= "none";
		document.formAnexoRangoCel.AVid.disabled 					= true;
		document.formAnexoRangoCel.CPtipoSaldo.style.display		= "none";
		document.formAnexoRangoCel.CPtipoSaldo.disabled 			= true;
		document.formAnexoRangoCel.ANFid.style.display	= "none";
		document.formAnexoRangoCel.ANFid.disabled 		= true;
		document.getElementById("Moneda").style.display		= "none";
		document.getElementById("Moneda").disabled 			= true;

		if (parseInt(valor) == 3)
		{
			document.formAnexoRangoCel.AVid.style.display				= "";
			document.formAnexoRangoCel.AVid.disabled 					= false;
		}
		else if (parseInt(valor) >= 20 && parseInt(valor) <= 34)
		{
			document.getElementById("Moneda").style.display		= "";
			document.getElementById("Moneda").disabled 			= false;
		}
		else if (parseInt(valor) >= 35 && parseInt(valor) <= 39)
		{
			if ( (ini != true) && !(GvarConceptoAnt >= 35 && GvarConceptoAnt <= 39) )
			{
			<cfif LvarMesCierre EQ "">
				alert("No se ha definido Mes de Cierre Fiscal");
			<cfelse>
				if (document.getElementById("AnexoRel").checked || document.getElementById("Meses").selectedIndex != <cfoutput>#LvarMesCierre-1#</cfoutput>)
					alert("Se cambia el Mes al Mes de Cierre Fiscal");
				document.getElementById("Meses").selectedIndex = <cfoutput>#LvarMesCierre-1#</cfoutput>;
			</cfif>
			}
			document.getElementById("Moneda").style.display		= "";
			document.getElementById("Moneda").disabled 			= false;
			document.getElementById("AnexoRel").checked 		= false;
			OcultarPer(false);
		}
		else if (parseInt(valor) >= 50 && parseInt(valor) <= 59)
		{
			document.formAnexoRangoCel.CPtipoSaldo.style.display		= "";
			document.formAnexoRangoCel.CPtipoSaldo.disabled 			= false;
		}
		else if (parseInt(valor) >= 60 && parseInt(valor) <= 69)
		{
			document.formAnexoRangoCel.ANFid.style.display	= "";
			document.formAnexoRangoCel.ANFid.disabled 		= false;
		}
		else
		{
			document.formAnexoRangoCel.colWidth.style.display			= "";
			document.formAnexoRangoCel.colWidth.style.visibility		= "hidden";
		}
		GvarConceptoAnt = parseInt(valor);
	}
	
	function my_submit(){
		MM_validateForm('AnexoRan','','R','AnexoMes','','RinRange0:99','AnexoPer','','R');
		if (document.MM_returnValue){
			document.formAnexoRangoCel.AVid.disabled = false;
		}
		return document.MM_returnValue;
	}
	//-->
</script>

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
			if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccin de correo electrnica vlida.\n';
		  } else if (test!='R') { num = parseFloat(val);
			if (isNaN(val)) errors+='- '+nm+' debe ser numrico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); max=test.substring(p+1);
			  if (num<min || max<num) errors+='- '+nm+' debe ser un nmero entre '+min+' y '+max+'.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}
	//-->
</script>

<script>
	var anx_popUpWinimAyuda=0;
	function anx_popUpWindowimAyuda(AnexoRan)
	{		
		ww = 500;					
		if (AnexoRan == "")
		{
			wh = 380;
		}
		else
		{
			wh = 300;
		}
		wl = 50;					
		wt = 250;			
		if (AnexoRan == "")
		{	
			URLStr = "/cfmx/sif/an/operacion/admin/Instruccionesanx.cfm"
		}	
		else
		{	
			URLStr = "/cfmx/sif/an/operacion/calculo/CalculoCeldaPopup.cfm?AnexoId=<cfoutput>#url.AnexoId#</cfoutput>"
		}
		<cfif isdefined("url.AnexoCelId")>
			if (AnexoRan != "")
			{				
				URLStr = URLStr + "&AnexoCelId=<cfoutput>#url.AnexoCelId#</cfoutput>&AnexoRan=" + escape(AnexoRan);
			}
		</cfif>
		anx_popUpWinimAyuda = open(URLStr, 'anx_popUpWinimAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height='+wh+',left=200, top='+wt+',screenX='+wl+',screenY='+wt+'');
		anx_popUpWinimAyuda.focus();
	}

	function anx_mostrarimAyuda(AnexoRan)
	{
		anx_popUpWindowimAyuda(AnexoRan);
	}
</script>

<script>
	var anx_popUpWinConcepto=0;
	function anx_popUpWindowConcepto()
	{		
		URLStr = "/cfmx/sif/an/operacion/admin/anexo-conceptos.cfm";
		URLStr = URLStr + "?AnexoId=<cfoutput>#url.AnexoId#</cfoutput>&AnexoCelId=<cfoutput>#url.AnexoCelId#</cfoutput>";
		anx_popUpWinConcepto = open(URLStr, 'anx_popUpWinConcepto', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=800,height=300,left=100,top=180,screenX=1,screenY=1');
	}

	function anx_mostrarConcepto()
	{
		anx_popUpWindowConcepto();
	}
</script>

<cfoutput> 
  <form action="anexo-rango-apply.cfm" method="post" name="formAnexoRangoCel" onSubmit="return my_submit();">
    <table width="439" align="center" border="0">
    <tr valign="baseline">
		  <td colspan="10">
		  <input type="hidden" name="AnexoHoja" value="<cfif isdefined("url.AnexoHoja")><cfoutput>#url.AnexoHoja#</cfoutput></cfif>">
		  </td>
	</tr>
	<tr valign="baseline">
		<td colspan="9" align="left" nowrap>

			<table align="center" width="100%">
			<tr>
				<td width="4%">
				<img name="imAyuda" src="/cfmx/sif/imagenes/Help01_T.gif" border="0" onClick="javascript:anx_mostrarimAyuda('');" style="cursor:hand;" alt="Mostrar Ayuda">
				</td>
				<td width="96%" colspan="8" align="left" nowrap class="subTitulo">
					Propiedades del Rango 
				</td>
			</tr>
			</table>
		
		</td>		
    </tr>
    <tr valign="baseline"> 
        <td align="right" nowrap >Rango en Excel:</td>
        <td colspan="2">
			<input type="text" name="AnexoRan" readonly value="<cfif isdefined("url.AnexoRan")>#Trim(url.AnexoRan)#<cfelseif isdefined('rsLinea.AnexoRan') and Len(trim(url.AnexoCelId)) GT 0>#Trim(rsLinea.AnexoRan)#</cfif>" size="32" onfocus="javascript:this.select();" alt="El nombre del Rango">
			<cfif url.MultipleCell>
			<div style="color:red;font-weight:bold;">Precauci&oacute;n: Este rango abarca varias celdas.  El valor aqu&iacute; especificado se aplicar&aacute; a cada una de &eacute;stas.</div>
			</cfif>

			<cfif rsLinea.AnexoFila GT 0>
				Hoja=<strong>#trim(rsLinea.AnexoHoja)#</strong>, Fila=<strong>#rsLinea.AnexoFila#</strong>, Col=<strong>#rsLinea.AnexoColumna#</strong>, Celda=<strong>#fnAdressExcel(rsLinea.AnexoFila,rsLinea.AnexoColumna)#</strong>
			<cfelseif rsLinea.AnexoFila EQ -1>
				<strong>El Rango en Excel está referenciando a varias celdas: no se puede asignar un Concepto</strong>
			<cfelse>
				<strong>El Rango en Excel no está referenciando niguna celda: no se puede asignar un Concepto</strong>
			</cfif>
			<cfif rsLinea.AnexoFor neq "">
					<BR>Formula:&nbsp;&nbsp;<strong>#rsLinea.AnexoFor#</strong><BR>
				<cfif rsLinea.AnexoCon eq "">
					Si escoge un concepto se pierde la Fórmula en Cálculo
				<cfelse>
					La Fórmula que se va a perder en Cálculo al sobreponele el Concepto
				</cfif>
			</cfif>
		</td>    
    </tr>
    <tr valign="baseline"> 
        <td nowrap align="right">Concepto de Cálculo:</td>
        <td nowrap="nowrap" style="width:620px;"> 
			<select name="AnexoCon" id="AnexoCon" onChange="javascript:onchange_concepto(this.value);">
			<cfif NOT (isDefined("rsLinea.AnexoCon") AND rsLinea.AnexoCon NEQ "")>
				  <option value="-1">(Escoja un concepto)</option>
			</cfif>
			<optgroup label="Textos">
            <cfloop query="rsConceptos">
				<cfif rsConceptos.CAcodigo EQ 20>		
					</optgroup>
					<optgroup label="Datos Predefinidos">
						<option value="3" <cfif (isDefined("rsLinea.AnexoCon") AND 3 EQ rsLinea.AnexoCon) and modo NEQ "ALTA">selected</cfif>>&nbsp;&nbsp;Variables</option>
					</optgroup>
					<optgroup label="Saldos Contables">
				<cfelseif rsConceptos.CAcodigo EQ 32>
					<option value="20" <cfif (isDefined("rsLinea.AnexoCon") AND 20 EQ rsLinea.AnexoCon) and modo NEQ "ALTA">selected</cfif>>&nbsp;&nbsp;Saldo Final</option>
				<cfelseif rsConceptos.CAcodigo EQ 35>
					</optgroup>
					<optgroup label="Movimientos Bancarios">
						<option value="25" <cfif (isDefined("rsLinea.AnexoCon") AND 25 EQ rsLinea.AnexoCon) and modo NEQ "ALTA">selected</cfif>>&nbsp;&nbsp;Flujo de Efectivo en el Mes</option>
					</optgroup>
					<optgroup label="Saldos Contables de Cierres">
				<cfelseif rsConceptos.CAcodigo EQ 40>
					</optgroup>
					<optgroup label="Presupuesto Contable">
				<cfelseif rsConceptos.CAcodigo EQ 50>
					</optgroup>
					<optgroup label="Saldos de Control de Presupuesto">
				<cfelseif rsConceptos.CAcodigo EQ 60>
					</optgroup>
					<optgroup label="Formulación de Presupuesto">
				</cfif>
				<cfif not listFind("3,20,25",rsConceptos.CAcodigo)>
					<option value="#rsConceptos.CAcodigo#" <cfif (isDefined("rsLinea.AnexoCon") AND rsConceptos.CAcodigo EQ rsLinea.AnexoCon) and modo NEQ "ALTA">selected</cfif>>&nbsp;&nbsp;#rsConceptos.CAdescripcion#</option>
				</cfif>
            </cfloop>
			</optgroup>
          	</select> 

			<!--- CAMPO ADICIONAL: AVid (variable), CPtipoSaldo (Control Presupuesto), ANFid (Formulacion Presupuesto de Anexos) --->
			<cfset LvarStyleCol	= "width:400px;visibility:hidden;">
			<cfset LvarStyleAV	= "width:400px;display:none;">
			<cfset LvarStyleMoneda	= "width:400px;display:none;">
			<cfset LvarStyleCP	= "width:400px;display:none;">
			<cfset LvarStyleANF	= "width:400px;display:none;">
			<cfif isDefined("rsLinea.AnexoCon")>
				<cfif rsLinea.AnexoCon EQ 3>
					<cfset LvarStyleCol	= "width:400px;display:none;">
					<cfset LvarStyleAV	= "width:400px;">
				<cfelseif rsLinea.AnexoCon GTE 20 AND rsLinea.AnexoCon LTE 39>
					<cfset LvarStyleCol		= "width:400px;display:none;">
					<cfset LvarStyleMoneda	= "width:400px;">
				<cfelseif rsLinea.AnexoCon GTE 50 AND rsLinea.AnexoCon LTE 59>
					<cfset LvarStyleCol	= "width:400px;display:none;">
					<cfset LvarStyleCP	= "width:400px;">
				<cfelseif rsLinea.AnexoCon GTE 60 AND rsLinea.AnexoCon LTE 69>
					<cfset LvarStyleCol	= "width:400px;display:none;">
					<cfset LvarStyleANF	= "width:400px;">
				</cfif>
			</cfif>
			
			<!--- CAMPO ADICIONAL: Campo comodín para manejo del tamaño de pantalla --->
			<input name="colWidth" style="width:400px;" style="#LvarStyleCol#">

			<!--- CAMPO ADICIONAL: Moneda de expresión --->
			<cfquery name="monedas" datasource="#session.DSN#">
				select Mcodigo id, Mnombre as descripcion
				from Monedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				order by Mnombre
			</cfquery>
			<span id="Moneda" style="#LvarStyleMoneda#">
			<cfif rsAnexo.AnexoSaldoConvertido eq 2>
				En
				<select name="Mcodigo" style="width:210px" onChange="if(this.value==-1){this.form.ACmLocal.disabled=true;this.form.ACmLocal.checked=true;} else if (this.form.ACmLocal.disabled){this.form.ACmLocal.disabled=false;this.form.ACmLocal.checked=false;}">
					  <option value="-1" >- Todas las monedas -</option>
					  <cfloop query="monedas">
						<option value="#monedas.id#" <cfif monedas.id EQ rsLinea.Mcodigo>selected</cfif>>#monedas.descripcion#</option>
					  </cfloop>
				</select><input type="checkbox" name="ACmLocal" value="1" <cfif rsLinea.Mcodigo EQ -1>checked disabled<cfelseif rsLinea.ACmLocal>checked</cfif>	>expresado en Local
			</cfif>
			</span>

			<!--- CAMPO ADICIONAL: Variable --->
			<select name="AVid" id="AVid" style="#LvarStyleAV#">
			<option value="">(Escoja una Variable de Usuario)</option>
			<cfloop query="vars">
			<option value="#HTMLEditFormat(AVid)#" <cfif rsLinea.AVid EQ vars.AVid>selected</cfif> >#HTMLEditFormat(AVnombre)# - #HTMLEditFormat(AVdescripcion)#</option>
			</cfloop>
			</select>

			<!--- CAMPO ADICIONAL: Tipo de Saldo en Control de Presupuesto --->
			<cfif isdefined("rsLinea.CPtipoSaldo")>
				<cfset LvarValor = rsLinea.CPtipoSaldo>
			<cfelse>
				<cfset LvarValor = "">
			</cfif>
			<select name="CPtipoSaldo" id="CPtipoSaldo" style="#LvarStyleCP#">
				<option value="" 		<cfif LvarValor EQ "">		selected</cfif>>(Escoja un tipo de Saldo de Presupuesto)</option>
				<option value="[A]" 	<cfif LvarValor EQ "[A]">	selected</cfif>>[A]  = Aprobación Presupuesto Ordinario</option>
				<option value="[M]" 	<cfif LvarValor EQ "[M]">	selected</cfif>>[M]  = Modificación Presupuesto Extraordinario</option>
				<option value="[*PF]" 	<cfif LvarValor EQ "[*PF]">	selected</cfif>>SALDOS DE FORMULACION ([A]+[M])</option>
				<option value="[T]" 	<cfif LvarValor EQ "[T]">	selected</cfif>>[T]  = Traslados de Presupuesto Internos</option>
				<option value="[TE]" 	<cfif LvarValor EQ "[TE]">	selected</cfif>>[TE] = Traslados con Autorización Externa</option>
				<option value="[VC]" 	<cfif LvarValor EQ "[VC]">	selected</cfif>>[VC] = Variación Cambiaria</option>
				<option value="[*PP]" 	<cfif LvarValor EQ "[*PP]">	selected</cfif>>SALDOS DE PRESUPUESTO PLANEADO ([A]+[M]+[T]+[TE]+[VC])</option>
				<option value="[ME]"	<cfif LvarValor EQ "[ME]">	selected</cfif>>[ME] = Modificación por Excesos Autorizados</option>
				<option value="[*PA]" 	<cfif LvarValor EQ "[*PA]">	selected</cfif>>SALDOS DE PRESUPUESTO AUTORIZADO ([A]+[M]+[T]+[TE]+[VC]+[ME])</option>
				<option value="[RA]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RA] = Presupuesto Reservado Período Anterior</option>
				<option value="[CA]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CA] = Presupuesto Comprometido Período Anterior</option>
				<option value="[RC]" 	<cfif LvarValor EQ "[RC]">	selected</cfif>>[RC] = Presupuesto Reservado</option>
				<option value="[CC]" 	<cfif LvarValor EQ "[CC]">	selected</cfif>>[CC] = Presupuesto Comprometido</option>
				<option value="[E]" 	<cfif LvarValor EQ "[E]">	selected</cfif>>[E]  = Ejecutado Contable</option>
				<option value="[E2]" 	<cfif LvarValor EQ "[E2]">	selected</cfif>>[E2] = Ejecutado No Contable</option>
				<option value="[ET]" 	<cfif LvarValor EQ "[ET]">	selected</cfif>>[ET]: EJECUTADO TOTAL ([E]+[E2])</option>
				<option value="[*PCA]" 	<cfif LvarValor EQ "[*PCA]">selected</cfif>>SALDOS DE CONSUMO DE AUX/CONTA ([RA]+[CA]+[RC]+[CC]+[E]+[E2])</option>
				<option value="[RP]" 	<cfif LvarValor EQ "[RP]">	selected</cfif>>[RP] = Provisiones Presupuestarias</option>
				<option value="[*PC]" 	<cfif LvarValor EQ "[*PC]">	selected</cfif>>PRESUPUESTO CONSUMIDO ([RA]+[CA]+[RC]+[CC]+[E]+[E2]+[RP])</option>
				<option value="[*PD]" 	<cfif LvarValor EQ "[*PD]">	selected</cfif>>PRESUPUESTO DISPONIBLE ([AUTORIZADO]-[DISPONIBLE])</option>
				<option disabled>Movimientos de Flujo de Efectivo</option>
				<option value="[E3]" 	<cfif LvarValor EQ "[E3]">	selected</cfif>>[E3] = Devengado o Ejecutado No Pagado</option>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 1140
			</cfquery>
			<cfif rsSQL.Pvalor EQ "S">
				<option value="[EJ]" 	<cfif LvarValor EQ "[EJ]">	selected</cfif>>[EJ]  = Ejercido Total</option>
				<option value="[EJ3]" 	<cfif LvarValor EQ "[EJ3]">	selected</cfif>>[EJ3] = Ejercido no Pagado</option>
				<option value="[P]" 	<cfif LvarValor EQ "[P]">	selected</cfif>>[P]   = Presupuesto Pagado</option>
			<cfelse>
				<option value="[P]" 	<cfif LvarValor EQ "[P]">	selected</cfif>>[P]  = Presupuesto Pagado</option>
			</cfif>
				<option value="[PA]" 	<cfif LvarValor EQ "[PA]">	selected</cfif>>[PA] =Presupuesto Pagado de Devengados Años Anteriores</option>
			</select>		

			<!--- CAMPO ADICIONAL: Formulación de Control de Presupuesto --->
			<cfif isdefined("rsLinea.ANFid")>
				<cfset LvarValor = rsLinea.ANFid>
			<cfelse>
				<cfset LvarValor = "">
			</cfif>
			<select name="ANFid" id="ANFid" style="#LvarStyleANF#">
			<option value="">(Escoja una Formulación de Presupuesto)</option>
			<cfloop query="rsFormulaciones">
			<option value="#HTMLEditFormat(ANFid)#" <cfif LvarValor EQ rsFormulaciones.ANFid>selected</cfif> >#HTMLEditFormat(ANFcodigo)# - #HTMLEditFormat(ANFdescripcion)#</option>
			</cfloop>
			</select>

		</td>
        <td nowrap="nowrap">
			<input type="checkbox" id="AnexoNeg"  name="AnexoNeg" 
	  					value="<cfif modo neq 'ALTA'>#rsLinea.AnexoNeg#<cfelse>0</cfif>"
						<cfif modo neq 'ALTA' and rsLinea.AnexoNeg EQ 1>checked</cfif>  >
          <label for="AnexoNeg">Presentar resultado en negativo</label>
		</td>		
	</tr>
    <tr valign="baseline"> 
        <td  nowrap align="right" valign="top">
			Origen:
		</td>
        <td>
			<cfif modo EQ "ALTA">
				<cf_cboANubicacion Ecodigo="#session.Ecodigo#" modo="ALTA" tipo="CELDA">
			<cfelse>
				<cf_cboANubicacion
							Ecodigo="#rsLinea.Ecodigocel#" 
							Ocodigo="#rsLinea.Ocodigo#" 
							GOid="#rsLinea.GOid#" 
							GEid="#rsLinea.GEid#" 
							modo="CAMBIO" tipo="DISEÑO">
			</cfif>
		</td>	
        <td nowrap align="left" valign="top"> 
          	<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="300" nowrap="nowrap" colspan="4">
						<input type="checkbox" id="AnexoRel"  name="AnexoRel" 
							onClick="javascript:OcultarPer(this.checked);"
							value="<cfif modo neq 'ALTA'>#rsLinea.AnexoRel#<cfelse>0</cfif>"
									<cfif modo EQ 'ALTA' OR rsLinea.AnexoRel EQ 1>checked</cfif> 
						>
						<label for="AnexoRel">Meses Relativos Atrás</label>
					</td>
				</tr>
				<tr>
					<td>
						<input name="lblMes" type="text" class="cajasinbordeb" tabindex="-1" value="Mes:" size="4" maxlength="16" readonly style="text-align:right">
						<input type="text" name="AnexoMes" id="AnexoMes" value="<cfif modo neq 'ALTA'>#rsLinea.AnexoMes#<cfelse>0</cfif>" size="3" maxlength="3" onFocus="javascript:this.select()" 
								onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"					
								alt="El valor del Mes">
					</td>
					<td>
						<select name="Meses" id="Meses">
							<cfloop query="rsMeses">
								<option value="#rsMeses.VSvalor#" <cfif (isDefined("rsLinea.AnexoMes") AND rsMeses.VSvalor EQ rsLinea.AnexoMes)>selected</cfif>>#rsMeses.VSdesc#</option>
							</cfloop>
						</select>	
					</td>
					<td nowrap="nowrap">
						<input name="lblPeriodo" type="text" class="cajasinbordeb" tabindex="-1" value="De:" size="4" maxlength="16" readonly style="text-align:right">
						<select  name="AnexoPer"  id="AnexoPer">
							<option value="0" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 0>selected</cfif>>Año Actual</option>
							<option value="1" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 1>selected</cfif>>Año Anterior</option>
							<option value="2" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 2>selected</cfif>>Hace 2 años</option>
							<option value="3" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 3>selected</cfif>>Hace 3 años</option>
							<option value="4" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 4>selected</cfif>>Hace 4 años</option>
							<option value="5" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 5>selected</cfif>>Hace 5 años</option>
							<option value="6" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 6>selected</cfif>>Hace 6 años</option>
							<option value="7" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 7>selected</cfif>>Hace 7 años</option>
							<option value="8" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 8>selected</cfif>>Hace 8 años</option>
							<option value="9" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 9>selected</cfif>>Hace 9 años</option>
							<option value="10" <cfif modo neq 'ALTA' AND rsLinea.AnexoPer EQ 10>selected</cfif>>Hace 10 años</option>
						</select>
					</td>
				</tr>
			</table>
        </td>
	</tr>
    <tr> 
	<cfif rsLinea.AnexoCon GTE 20>
		<td>Cuentas&nbsp;Financieras:</td>
	
		<td colspan="2">
			<table>
				<tr>
					<td>
			<select name="ANHid" id="ANHid" style="" alt="Tipo de Homologación de Cuentas Financieras"
			 onchange="setReadOnly_formAnexoRangoCel_ANHCid(this.value == '');"
			>
			<option value="">(Digitar Mascaras de Cuentas Financieras)</option>
			<cfif rsHomologaciones.recordCount GT 0>
				<cfif isdefined("rsLinea.ANHid")>
					<cfset LvarANHid = rsLinea.ANHid>
				<cfelse>
					<cfset LvarANHid = "">
				</cfif>
				<optgroup label="Homologación de Cuentas Financieras:">
				<cfloop query="rsHomologaciones">
					<option value="#HTMLEditFormat(ANHid)#" <cfif LvarANHid EQ rsHomologaciones.ANHid>selected</cfif> >#HTMLEditFormat(rsHomologaciones.ANHcodigo)# - #HTMLEditFormat(rsHomologaciones.ANHdescripcion)#</option>
				</cfloop>
				</optgroup>
			</cfif>
			</select>
			Cuenta:
		</td><td> 
				<cfif isdefined("rsLinea.ANHCid")>
					<cfset LvarValor = rsLinea.ANHCid>
				<cfelse>
					<cfset LvarValor = "">
				</cfif>
			<cf_conlis
				form="formAnexoRangoCel" 
				Campos="ANHCid, ANHCcodigo, ANHCdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				tabindex="1"
				Title="Lista de Cuentas Homologadas"
				Tabla="ANhomologacionCta"
				traerInicial="#LvarValor NEQ ''#"
				traerFiltro="Ecodigo = #session.Ecodigo# and ANHCid = #LvarValor#"
				Filtro="Ecodigo = #session.Ecodigo# and ANHid = $ANHid,numeric$ "
				Columnas="ANHCid, ANHCcodigo, ANHCdescripcion"
				Desplegar="ANHCcodigo, ANHCdescripcion"
				Etiquetas="Codigo, Descripcion"
				Formatos="S,S"
				Align="left,left"
				MaxRowsQuery="200"
			/>
					</td></tr></table>
		</td>
	</cfif>
    </tr>
    <!--- <tr valign="baseline">Variable</tr> --->
    <tr valign="baseline"> 
		<td>&nbsp;</td>
    </tr>
    <!---<tr valign="baseline">Oficina </tr>--->
    <!--- <tr valign="baseline">Negativo</tr> --->
    <tr valign="baseline"> 
        <td colspan="9" align="center" nowrap>
			
			<div align="center"> 
		    <input type="hidden" name="AnexoCelId" value="<cfif modo NEQ "ALTA">#url.AnexoCelId#</cfif>">
		    <input type="hidden" name="AnexoId" value="#url.AnexoId#">

			<input type="hidden" name="botonSel" value="">
	
			<cfif isdefined("form.Ppagina") and len(trim(form.Ppagina))>
				<input type="hidden" name="Ppagina" value="#form.Ppagina#">
			</cfif>

			<cfif rsLinea.AnexoFila GT 0>
				<input type="submit" name="Cambio" id="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; return fnVerificaCelda();">
			</cfif>
			<cfif modo NEQ 'ALTA'>
				<cfif  rsLinea.AnexoFor neq "">
					<cfif rsLinea.AnexoCon neq "">
						<input type="submit" name="Quitar" id="Quitar" value="Quitar Concepto">
					</cfif>
				</cfif>
				<input type="submit" name="Baja" id="Baja" value="Eliminar" onClick="return confirm('¿Desea Eliminar este registro?')">
			</cfif>
			<input type="Button" name="btnRegresar" value="Regresar" onclick="regresarenc()">
			<cfif modo EQ "CAMBIO" AND rsLinea.AnexoFila GT 0>
				<cfif modo NEQ 'ALTA' and rsLinea.AnexoCon neq "">
					<input type="button" name="btnCalcularCeld" id="btnCalcularCeld" value="CalcularCelda" onclick="javascript:anx_mostrarimAyuda(document.formAnexoRangoCel.AnexoRan.value);">
				</cfif>			
			</cfif>
			<cfif modo EQ "CAMBIO">
				<input type="button" name="btnFiltroPorConcepto" id="btnFiltroPorConcepto" value="Filtro por Concepto" onclick="javascript:anx_mostrarConcepto();">
				&nbsp;&nbsp;&nbsp;
				<cfif rsLinea.AnexoFila GT 0>
					&nbsp;
					<span style="background-color:##D4D0C8"><input type="submit" name="btnFilaA" id="btnFilaA" value="<--" style="border:1px solid ##888888; cursor=pointer;"> Fila <input type="submit" name="btnFilaS" id="btnFilaS" value="-->" style="border:1px solid ##888888; cursor=pointer;"></span>
				</cfif>
				<cfif rsLinea.AnexoColumna GT 0>
					&nbsp;
					<span style="background-color:##D4D0C8"><input type="submit" name="btnColA" id="btnColA" value="<--" style="border:1px solid ##888888; cursor=pointer;"> Columna <input type="submit" name="btnColS" id="btnColS" value="-->" style="border:1px solid ##888888; cursor=pointer;"></span>
				</cfif>
			</cfif>
			<!--- 
			<cfif modo EQ "CAMBIO">
            	<input type="button" name="btnCuentas" id="btnCuentas" value="Ver Cuentas..." onclick="javascript:MostrarCuentas();"
					<cfif rsLinea.AnexoCon LT 20 >style="visibility:hidden;"</cfif>
				>
			</cfif> --->
			</div>
		</td>		
    </tr>
    </table>

	<cfif isdefined("url.nav") and len(trim(url.nav)) gt 0>
		<input type="hidden" name="nav" value="#url.nav#">
	</cfif>	
	<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
		<input type="hidden" name="F_Hoja" value="#url.F_Hoja#">
	</cfif>
	<cfif isdefined("url.F_columna") and url.F_columna gt 0>
		<input type="hidden" name="F_columna" value="#url.F_columna#">
	</cfif>
	<cfif isdefined("url.F_fila") and url.F_fila gt 0>
		<input type="hidden" name="F_fila" value="#url.F_fila#">
	</cfif>
	<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
		<input type="hidden" name="F_Rango" value="#url.F_Rango#">
	</cfif>				
	<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
		<input type="hidden" name="F_Estado" value="#url.F_Estado#">
	</cfif>		
	<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt -1>
		<input type="hidden" name="F_Cuentas" value="#url.F_Cuentas#">
	</cfif>		
	
	
</form>
</cfoutput>
<script language="JavaScript1.2">
<!--
<!---
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
--->
	<cfif modo EQ 'ALTA' OR rsLinea.AnexoRel EQ 1>
		OcultarPer(true);
	<cfelse>
		OcultarPer(false);
	</cfif>
	<cfif modo EQ 'ALTA'>
		onchange_concepto("0");
	<cfelse>
		onchange_concepto("<cfoutput>#rsLinea.AnexoCon#</cfoutput>",true);
	</cfif>
	document.formAnexoRangoCel.AnexoRan.focus();	
//-->
</script>
<script>
	function fnVerificaCelda()
	{
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			Select count(1) as cantidad
			  from AnexoCelD a
			 where a.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
		</cfquery>

		if (document.getElementById("AnexoCon").value == -1)
		{
			alert("Debe especificar un Concepto");
			document.getElementById("AnexoCon").focus();
			return false;
		}
		else if (document.getElementById("AnexoCon").value >= 35 && document.getElementById("AnexoCon").value <= 39
				 && !((document.getElementById("Meses").value == "<cfoutput>#LvarMesCierre#</cfoutput>") || (document.getElementById("Meses").value == "<cfoutput>#LvarMesCierreCorporativo#</cfoutput>"))
				)
		{
			document.getElementById("Meses").focus();
			return confirm("El Mes no corresponde al Mes de Cierre Fiscal (<cfoutput>#LvarMesCierre#</cfoutput>) ni Corporativo (<cfoutput>#LvarMesCierreCorporativo#</cfoutput>), ¿desea continuar?");
			return false;
		}
	<cfif rsSQL.cantidad NEQ 0>
		else if (document.getElementById("AnexoCon").value < 20)
		{
			alert("No se puede especificar el Concepto de Cálculo porque la celda contiene máscaras de Cuentas Financieras definidas.");
			document.getElementById("AnexoCon").focus();
			return false;
		}
		else if (document.getElementById("ANHid").value != "")
		{
			alert("No se puede especificar un Tipo de Cuenta Homologada porque la celda contiene máscaras de Cuentas Financieras definidas.");
			document.getElementById("ANHid").focus();
			return false;
		}
	</cfif>
		else if (document.getElementById("AnexoCon").value == 3
				 && document.getElementById("AVid").value == "")
		{
			alert("Debe especificar la Variable de Usuario");
			document.getElementById("AVid").focus();
			return false;
		}
		else if (document.getElementById("AnexoCon").value >= 50 && document.getElementById("AnexoCon").value <= 59
				 && document.getElementById("CPtipoSaldo").value == "")
		{
			alert("Debe especificar un Tipo de Saldo de Control de Presupuesto");
			document.getElementById("CPtipoSaldo").focus();
			return false;
		}
		else if (document.getElementById("AnexoCon").value >= 60 && document.getElementById("AnexoCon").value <= 69
				 && document.getElementById("ANFid").value == "")
		{
			alert("Debe especificar la Formulacion de Presupuesto");
			document.getElementById("ANFid").focus();
			return false;
		}
		else if (document.getElementById("ANHid").value != "" && document.getElementById("ANHCid").value == "")
		{
			alert("Debe especificar una Cuenta Homologada");
			document.getElementById("ANHCcodigo").focus();
			return false;
		}
			
		return fnANubicaVerifica();
	}
	function regresarenc(){
	<cfoutput>

		<cfset fltr = "&nav=1">
		<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
			<cfset fltr = fltr & "&F_Hoja=#url.F_Hoja#">
		</cfif>
		<cfif isdefined("url.F_columna") and url.F_columna gt 0>
			<cfset fltr = fltr & "&F_columna=#url.F_columna#">
		</cfif>
		<cfif isdefined("url.F_fila") and url.F_fila gt 0>
			<cfset fltr = fltr & "&F_fila=#url.F_fila#">
		</cfif>
		<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
			<cfset fltr = fltr & "&F_Rango=#url.F_Rango#">
		</cfif>				
		<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
			<cfset fltr = fltr & "&F_Estado=#url.F_Estado#">
		</cfif>
		<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt -1>
			<cfset fltr = fltr & "&F_Cuentas=#url.F_Cuentas#">
		</cfif>		
		
		
		<cfif isdefined("form.Ppagina")><cfset npag=form.Ppagina><cfelse><cfset npag=1></cfif>
		window.open("anexo.cfm?tab=2&AnexoId=#JSStringFormat(url.AnexoId)#&AnexoCelId=#JSStringFormat(url.AnexoCelId)#&pagina=#npag##fltr#",'_self');
	</cfoutput>
	}
</script>

<cffunction name="fnAdressExcel" returntype="string" output="false">
	<cfargument name="Fila" type="numeric">
	<cfargument name="Columna" type="numeric">
	
	<cfset var LvarLetraS = "">
	<cfset var LvarLetraN = 0>
	<cfset var LvarColS = "">
	<cfset var LvarColN = Columna>
	<cfloop condition="LvarColN GT 0">
		<cfset LvarLetraN = int((LvarColN-1) mod 26) + 1>
		<cfset LvarLetraS = chr(LvarLetraN + 64)>
		<cfset LvarColS = LvarLetraS & LvarColS>

		<cfset LvarColN = int((LvarColN-1) / 26)>
	</cfloop>
	<cfreturn "#LvarColS##Fila#">
</cffunction>

<cffunction name="fnActualizaConceptos" output="false" access="private" returntype="query">
	<cfscript>
		sbActualiza (1, 'Nombre Empresa');
		sbActualiza (2, 'Nombre Oficina');
		sbActualiza (3, 'Variable');
		sbActualiza (4, 'Unidad Expresion');
		sbActualiza (10, 'Mes: MM');
		sbActualiza (11, 'Nombre Mes');
		sbActualiza (12, 'Año: YYYY');
		sbActualiza (13, 'Año Mes: MM/YYYY');
		sbActualiza (14, 'Leyenda Fin Mes');
		sbActualiza (15, 'Mes: MMM');
		sbActualiza (16, 'Año Mes: MMM/YYYY');
		sbActualiza (17, 'Año Mes: YYYY-MM');
		sbActualiza (18, 'Leyenda Ini-Fin Periodo');
		sbActualiza (20, 'Saldo Final');
		sbActualiza (21, 'Saldo Inicial');
		sbActualiza (22, 'Débitos Mes');
		sbActualiza (23, 'Créditos Mes');
		sbActualiza (24, 'Movimientos Mes');
		sbActualiza (25, 'Flujo Efectivo Mes');
		sbActualiza (32, 'Débitos Acum.');
		sbActualiza (33, 'Créditos Acum.');
		sbActualiza (34, 'Movimientos Acum.');
		sbActualiza (35, 'Saldo Inicial Cierre');
		sbActualiza (36, 'Débitos Cierre');
		sbActualiza (37, 'Créditos Cierre');
		sbActualiza (38, 'Movimientos Cierre');
		sbActualiza (39, 'Saldo Final Cierre');
		sbActualiza (40, 'Presupuesto Contable Ini.', true);
		sbActualiza (41, 'Presupuesto Contable Mes', true);
		sbActualiza (42, 'Presupuesto Contable Fin.', true);
		sbActualiza (50, 'Control Presupuesto Mes', true);
		sbActualiza (51, 'Control Presupuesto Acum', true);
		sbActualiza (52, 'Control Presupuesto Per.', true);
		sbActualiza (60, 'Formulación Presup. Mes', true);
		sbActualiza (61, 'Formulación Presup. Acum', true);
		sbActualiza (62, 'Formulación Presup. Per.', true);
	</cfscript>
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		SELECT * FROM ConceptoAnexos
	</cfquery>
	<cfreturn rsConceptos>
</cffunction>

<cffunction name="sbActualiza" output="false" access="private" returntype="void">
	<cfargument name="Concepto"		type="numeric">
	<cfargument name="Descripcion"	type="string">
	<cfargument name="Actualizar"	type="boolean" default="no">

	<cfquery name="rsSQL" datasource="#Session.DSN#">
		SELECT CAcodigo 
		  FROM ConceptoAnexos
		 WHERE CAcodigo = #Arguments.Concepto#
	</cfquery>
	<cfif rsSQL.CAcodigo EQ "">
		<cfquery datasource="#Session.DSN#">
			insert into ConceptoAnexos (CAcodigo, CAdescripcion)
			values (#Arguments.Concepto#, '#Arguments.Descripcion#')
		</cfquery>
	<cfelseif Arguments.Actualizar>
		<cfquery datasource="#Session.DSN#">
			UPDATE ConceptoAnexos
			   SET CAdescripcion = '#Arguments.Descripcion#'
			 WHERE CAcodigo = #Arguments.Concepto#
		</cfquery>
	</cfif>
</cffunction>
