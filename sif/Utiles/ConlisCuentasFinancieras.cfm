<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Titulo" returnvariable="LB_Titulo" default = "Cuenta Mayor" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaMayor" returnvariable="LB_CuentaMayor" default = "Cuenta Mayor" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Activo" returnvariable="LB_Activo" default = "Activo" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pasivo" returnvariable="LB_Pasivo" default = "Pasivo" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Capital" returnvariable="LB_Capital" default = "Capital" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ingresos" returnvariable="LB_Ingresos" default = "Ingresos" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Gasto" returnvariable="LB_Gasto" default = "Gasto" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoTieneVigencia" returnvariable="MSG_NoTieneVigencia" default = "no tiene vigencia para el" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_CuentaMayorNoExiste" returnvariable="MSG_CuentaMayorNoExiste" default = "CUENTA MAYOR NO EXISTE" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_CuentaMayorNoEs" returnvariable="MSG_CuentaMayorNoEs" default = "CUENTA MAYOR NO ES" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MascaraPlan" returnvariable="LB_MascaraPlan" default = "Mascara del Plan" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaFinanciera" returnvariable="LB_CuentaFinanciera" default = "Cuenta Financiera" xmlfile="ConlisCuentasFinancieras.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_VerCuentasExistentes"Default="Ver cuentas existentes" returnvariable="BTN_VerCuentasExistentes" xmlfile="ConlisCuentasFinancieras.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Mask" Default="M&aacute;scara" returnvariable="BTN_Mask" xmlfile="ConlisCuentasFinancieras.xml"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Oficina"Default="Oficina" returnvariable="LB_Oficina" xmlfile="ConlisCuentasFinancieras.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TodasOficinas" Default="Todas las Oficinas" returnvariable="LB_TodasOficinas" xmlfile="ConlisCuentasFinancieras.xml"/>	

<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<cfinclude template="ConlisCuentasFinancierasParams.cfm">
<cfif isdefined("Request.ConCuentasFinancieras")>
	<cfset LvarCFM = "ConCuentasFinancieras.cfm">
<cfelse>
	<cfset LvarCFM = "ConlisCuentasFinancieras.cfm">
</cfif>
<!---Parametro para tomar la descripcion de la cuenta de mayor segun el idioma--->
<cfquery datasource="#session.dsn#" name="rsParametroIdioma">
    select coalesce(Pvalor,0) as Valor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Pcodigo = 200010
</cfquery>
<cfset varParametroI = rsParametroIdioma.Valor>

            
<cfquery name="rsMayor" datasource="#Session.DSN#">
	select m.Cmayor, 
    <cfif varParametroI EQ 1>
    	coalesce(im.CdescripcionMI, m.Cdescripcion) as Cdescripcion,
    <cfelse>
	    m.Cdescripcion, 
    </cfif>
    v.PCEMid, v.CPVformatoF as Cmascara, m.Ctipo <!--- ABG: Esta descripcion es para cuando se selecciona la CM --->
	  from CtasMayor m
		<cfif varParametroI EQ 1>
            left join CtasMayorIdioma im
                inner join Idiomas i 
                on im.Iid = i.Iid 
                and i.Icodigo =  '#session.Idioma#' 
             on m.Ecodigo = im.Ecodigo and m.Cmayor = im.Cmayor
        </cfif>
		  inner join CPVigencia v
		  	 on v.Ecodigo = m.Ecodigo
			and v.Cmayor  = m.Cmayor
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(LSparseDateTime(form.CPVfecha),'YYYYMM')#">
				between CPVdesdeAnoMes and coalesce(CPVhastaAnoMes,600000)
	 where m.Ecodigo=#form.Ecodigo# 
	   and m.Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
</cfquery>

<cfset Lvar_CMayorError = false>
<cfset Lvar_ConPlanCtas = false>
<cfif rsMayor.recordCount EQ 0>
	<cfset Lvar_CMayorError = true>
<cfelseif form.Ctipo NEQ "" and form.Ctipo NEQ rsMayor.Ctipo>
	<cfset Lvar_CMayorError = true>
<cfelse>

	<cfquery name="rsCPvigencia" datasource="#Session.DSN#">
		select 	v.Ecodigo, v.Cmayor, CPVdesdeAnoMes, CPVhastaAnoMes,
				v.CPVid, v.PCEMid, 
				m.PCEMplanCtas, m.PCEMformato as PCEMformatoF, m.PCEMformatoC, m.PCEMformatoP
		  from CPVigencia v
			left outer join PCEMascaras m
				 ON m.PCEMid = v.PCEMid
		 where v.Ecodigo = #form.Ecodigo#
		   and v.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		   and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(LSparseDateTime(form.CPVfecha),'YYYYMM')#"> between CPVdesdeAnoMes and CPVhastaAnoMes
	</cfquery>
	<cfif rsCPvigencia.recordCount EQ 0>
		<cfset Lvar_CMayorError = true>
	<cfelse>
		<cfset Lvar_ConPlanCtas = (rsCPvigencia.PCEMid NEQ "" AND rsCPvigencia.PCEMplanCtas EQ "1")>
	</cfif>
</cfif>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfoutput>
<script language="javascript" type="text/javascript">
	function fnBodyOnLoad()
	{
	<cfif not Lvar_CMayorError>
		document.frmLista.Cmayor.value = "#form.Cmayor#";
		var LvarCFformato = "#form.Cmayor#";
		<cfif Lvar_ConPlanCtas>
			var LvarFormatos = "#form.CFdetalle#".split("-");
			var LvarLongitudes = "#replaceNoCase(mid(rsCPvigencia.PCEMformatoF,6,100),"X","0","ALL")#".split("-");
			<cfset LvarLongitudes = listToArray(listDeleteAt(rsCPvigencia.PCEMformatoF,1,"-"),"-")>
			for (var i=0; (i<LvarFormatos.length) && (i<LvarLongitudes.length) && (LvarFormatos[i] != ""); i++)
			{
				LvarFormatos[i] = right(LvarLongitudes[i] + LvarFormatos[i], LvarLongitudes[i].length);
				document.getElementById("CFnivel"+(i+1)).value = LvarFormatos[i];
				LvarCFformato = LvarCFformato + "-" + LvarFormatos[i];
			}
		<cfelse>
			LvarCFformato = "#form.Cmayor#-#form.CFdetalle#";
			document.frmLista.CFdetalle.value = "#form.CFdetalle#";
		</cfif>
		document.frmLista.CFformato.value = LvarCFformato;
		fnLlenarDeps();
		<cfset LvarPtoIni = find("CFdetalle=",GvarUrlToFormParam)>
		<cfset LvarPtoFin = find("&",GvarUrlToFormParam,LvarPtoIni+10)>
		<cfif LvarPtoIni LT LvarPtoFin>
			<cfset GvarUrlToFormParam = mid(GvarUrlToFormParam, 1, LvarPtoIni-1) & "CFdetalle=" & mid(GvarUrlToFormParam, LvarPtoFin, 100)>
		<cfelseif LvarPtoIni GT 0>
			<cfset GvarUrlToFormParam = mid(GvarUrlToFormParam, 1, LvarPtoIni-1) & "CFdetalle=">
		</cfif>
	</cfif>
	}
	function right(valor, lon)
	{
		var n = valor.length;
		if (n <= 0)
			return "";
		else
			return valor.substr(n-lon, lon);
	}
	function fnKeyIsEnter(e) 
	{
		e = (e) ? e : event;
		var charCode = (e.charCode) ? e.charCode : ((e.which) ? e.which : e.keyCode);
		return (charCode == 13);
	}
	function fnKeyPressNumber(e,o)
	{
		var whichASC = (document.layers) ? e.which : event.keyCode;
		return (whichASC >= 48 && whichASC <= 57)
	}
	function fnVerFrame(LprmNombre) 
	{
		for (var i=0; i<window.frames.length; i++)
		{
			if (window.frames[i].name != "")
			{
				LvarIframe = document.getElementById(window.frames[i].name);
				if (LvarIframe) 
				{
					if (LvarIframe.name == LprmNombre)
					{
						VarURL = LvarIframe.src; 
						pos=VarURL.indexOf('&Ocodigo=');
						finalURL = VarURL;
						resto=finalURL;
						if (pos != -1)
							resto=VarURL.substring(0,pos);						
						finalURL = resto + "&Ocodigo=" + document.frmLista.Ocodigo.value;					
						LvarIframe.src = finalURL;
					}
					LvarIframe.style.display = (LvarIframe.name == LprmNombre) ? "" : "none";
				}
			}
		}
	}
	function fnCmayor_onChange(e,o)
	{
		o.value = fnConCeros(o.value, 4);
		var LvarParam;
		LvarParam = "#GvarUrlToFormParam#".replace(/Cmayor=.*&/,"Cmayor="+o.value+"&");
	<cfif isdefined("url.Cmayores")>
		LvarParam = LvarParam + '&Cmayores=#URLEncodedFormat(url.Cmayores)#';
	</cfif>
		location.href="#LvarCFM#?"+LvarParam;
	}
	function fnConCeros(LprmHilera, LprmLong)
	{
		if (fnTrim(LprmHilera).length > 0)
		{
			var s = "";
			for (var i=0;i<LprmLong;i++) s=s+"0";
			return fnRight(s + LprmHilera, LprmLong);
		}
		else
			return "";
	}		 
	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		 
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}
	function sbResultadoConLisCmayor(LprmValor, LprmDescripcion)
	{
		var LvarCmayor = document.getElementById("Cmayor");
		LvarCmayor.value = LprmValor;
		fnCmayor_onChange(null,LvarCmayor)
		//LvarCmayor.form.submit();
	}
	function sbResultadoConLisCFformato(LprmValor, LprmDescripcion)
	{
		var LvarCFformato = document.getElementById("CFformato");
		LvarCFformato.value = LprmValor;
		document.getElementById("CFdescripcion").value = LprmDescripcion
		<cfif Lvar_ConPlanCtas>
			var LvarMascaraN = "#rsMayor.Cmascara#".split("-").length;
			var LvarNiveles = LprmValor.split("-");
			for (var i=1; i < LvarMascaraN; i++)
			{
				if (i < LvarNiveles.length)
			 	 document.getElementById("CFnivel"+i).value = LvarNiveles[i];
				else
				  document.getElementById("CFnivel"+i).value = "";
			}
		<cfelse>
			document.getElementById("CFdetalle").value = LprmValor.substring(5);
		</cfif>
	}
	function sbCFnivelToCFformato()
	{
		var LvarMascaraN = "#rsMayor.Cmascara#".split("-").length;
		var LvarFormato = "#form.Cmayor#";
		var LvarValor = "";
		var LvarTermino = false;
		for (var i=1; i<LvarMascaraN; i++)
		{
			LvarValor = document.getElementById("CFnivel"+i).value;
			if (LvarValor == "")
				LvarTermino = true;
			else if (!LvarTermino)
				LvarFormato = LvarFormato + "-" + LvarValor;
		}
		document.getElementById("CFformato").value = LvarFormato;
	}
	function sbResultadoConLisCFnivel(LprmValor, LprmDescripcion, LprmNivel)
	{
		var LvarCFnivel = document.getElementById("CFnivel"+LprmNivel);
		LvarCFnivel.value = LprmValor;
		LvarCFnivel.focus();
		LvarCFnivel.select();
		document.getElementById("CFdescripcion").value = LprmDescripcion
		sbCFnivelToCFformato();
	}

	function sbSeleccionar()
	{
		if (document.getElementById("CFformato").value == "")
		{
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoHaEscogidoNingunaCuenta"
			Default="No ha escogido ninguna cuenta"
			returnvariable="MSG_NoHaEscogidoNingunaCuenta"/>
			
			alert ("<cfoutput>#MSG_NoHaEscogidoNingunaCuenta#</cfoutput>");
			return;
		}
		var LvarCFformato = document.getElementById("CFformato").value;
		var LvarOcodigo = fnOcodigo();
		var LvarCFid = "#url.CFid#";

		sbSeleccionarVerif(LvarOcodigo, LvarCFid);
	}

	function fnOcodigo()
	{
		if (document.getElementById("Ocodigo"))
			return document.getElementById("Ocodigo").value;
		else
			return "#url.Ocodigo#";
	}

	function sbSeleccionarVerif(LvarOcodigo, LvarCFid)
	{
		var LvarCFformato = document.getElementById("CFformato").value;
		var LvarFecha = "";
		
		if (document.getElementById("CPVfecha"))
			LvarFecha = document.getElementById("CPVfecha").value;

		if (window.opener && window.opener.sbResultadoConLis)
		{
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+<cfoutput>"&ConLis=S&fecha="+LvarFecha+"&Ecodigo=#form.Ecodigo#&Ocodigo="+LvarOcodigo+"&CFid="+LvarCFid</cfoutput>;
			sbSeleccionarOK(1);
		}
		else
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+<cfoutput>"&ConLis=N&fecha="+LvarFecha+"&Ecodigo=#form.Ecodigo#&Ocodigo="+LvarOcodigo+"&CFid="+LvarCFid</cfoutput>;
	}
	
	function sbSeleccionarOK(brincar )
	{
		if (brincar && brincar != 1)
		{
			var LvarOcodigo = fnOcodigo();
			var LvarCFid = "#url.CFid#";
			if (LvarOcodigo != -1 || LvarCFid != -1)
				sbSeleccionarVerif(LvarOcodigo,LvarCFid);
		}

		if (window.opener && window.opener.sbResultadoConLis) 
		{
			var LvarValor = document.getElementById("CFformato").value;
			var LvarDescripcion = document.getElementById("CFdescripcion").value;
			window.opener.sbResultadoConLis(LvarValor, LvarDescripcion, "#rsMayor.Cmascara#", "#form.id#", "#form.mayor#", "#form.fmt#", "#form.desc#");
			window.close();
		}
	}
</script>
</cfoutput>
</head>

<body onLoad="fnBodyOnLoad();">
<cfoutput>
<form name="frmLista" action="#LvarCFM#" method="post" onSubmit="return (Cmayor.value != Cmayor.defaultValue); sinbotones();">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="120" nowrap>
				<cfif form.Ctipo EQ 'A'>#LB_CuentaMayor#<strong>#LB_Activo#</strong>:
				<cfelseif form.Ctipo EQ 'P'>#LB_CuentaMayor#<strong>#LB_Pasivo#</strong>:
				<cfelseif form.Ctipo EQ 'C'>#LB_CuentaMayor#<strong>#LB_Capital#</strong>:
				<cfelseif form.Ctipo EQ 'I'>#LB_CuentaMayor#<strong>#LB_Ingresos#</strong>:
				<cfelseif form.Ctipo EQ 'G'>#LB_CuentaMayor#<strong>#LB_Gasto#</strong>:
				<cfelse>
				#LB_CuentaMayor#:
				</cfif>
			</td>
			<td>
			<cfif isdefined("url.Cmayores")>
				<select name="Cmayor" id="Cmayor"
						 onChange="fnCmayor_onChange(event, this);"
				>
				<cfset LvarCmayorSelected = false>
				<cfloop index="i" list="#url.Cmayores#">
					<option value="#i#"<cfif #form.Cmayor# EQ i> selected	<cfset LvarCmayorSelected = true></cfif>>#i#</option>
				</cfloop>
				</select>
			<cfelse>				
				<input type="text" name="Cmayor" id="Cmayor" value="#form.Cmayor#" maxlength="4" tabindex="1"
						 onChange="fnCmayor_onChange(event, this);"
						 onKeyPress="if (fnKeyIsEnter(event)) {fnCmayor_onChange(event, this); return false;} else return fnKeyPressNumber(event,this);"
						 onFocus="this.select();fnVerFrame('ifrCmayor');"
						 style="font-size:10px; width:35px"
				>
			</cfif>
<cfif Lvar_CMayorError >
				<font color="##FF0000"><strong>
				<cfif isdefined("rsCPvigencia")>
					- #LB_CuentaMayor# '#form.Cmayor#' '#form.CPVfecha#'
					<cfset form.Cmayor = "1">
				<cfelseif form.Cmayor NEQ "" AND rsMayor.recordcount EQ 0>
					- #UCase(MSG_CuentaMayorNoExiste)#
				<cfelseif form.Cmayor NEQ "" AND form.Ctipo NEQ "">
					- #UCase(MSG_CuentaMayorNoEs)#
						<cfif form.Ctipo EQ 'A'> #Ucase(LB_Activo)#
						<cfelseif form.Ctipo EQ 'P'>#Ucase(LB_Pasivo)#
						<cfelseif form.Ctipo EQ 'C'>#Ucase(LB_Capital)#
						<cfelseif form.Ctipo EQ 'I'>#Ucase(LB_Ingresos)#
						<cfelseif form.Ctipo EQ 'G'>#Ucase(LB_Gasto)#
						</cfif>
				</cfif>
				</strong></font>
			</td>
		</tr>
	</table>
<cfif not isdefined("url.Cmayores")>
  <iframe id="ifrCmayor" width="100%" height="350" src="ConlisCuentasFinancierasMayor.cfm?Ctipo=#form.Ctipo#&Ecodigo=#form.Ecodigo#&CFid=#form.CFid#"> </iframe>
</cfif>
</form>
</body>
</html>
<cfexit>
</cfif>
				<strong> - #rsMayor.Cdescripcion#</strong>
			</td>
			<!---td align="center">
			   												
			</td--->
			<td align="right">
				 <input name="btnMask" type="button" value="#BTN_Mask#" onClick="sbPintaMascaras();">
				 &nbsp;&nbsp;&nbsp;		
				<input type="button" value="<cfoutput>#BTN_VerCuentasExistentes#</cfoutput>"
						 onClick="fnVerFrame('ifrCuentas');">
			</td>
		</tr>
	<cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
	<cfif NOT Lvar_ConPlanCtas>
		<tr>
			<td width="120" nowrap>
				#LB_MascaraPlan# : 
			</td>
			<td style="font-size:10px;" colspan="3">
				<strong>#form.Cmayor#</strong>#mid(rsMayor.Cmascara,5,100)#
			</td>
		</tr>
		<tr>
			<td width="120" nowrap>
				#LB_CuentaFinanciera#:
			</td>
			<td colspan="2">
				<strong>#form.Cmayor#</strong>-<input 
						type="text" name="CFdetalle" id="CFdetalle"
						size="#len(rsMayor.Cmascara)-5#" 
						maxlength="#len(rsMayor.Cmascara)-5#" 
						style="font-size:10px;" 
						onFocus="fnVerFrame('ifrCuentas');" 
						onChange="document.getElementById('CFformato').value = document.getElementById('Cmayor').value + '.' + this.value;"
						>
				<input type="hidden" name="CFformato" id="CFformato">
				<input type="text" name="CFdescripcion" id="CFdescripcion" size="40" disabled style="font-size:10px;border:none;">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_OK"
				Default="OK"
				returnvariable="BTN_OK"/>
				
				<input type="button" value="<cfoutput>#BTN_OK#</cfoutput>" onClick="sbSeleccionar();">
			</td>

			<td align="right">
				<cfset fnCboOficina()>
			</td>
		</tr>
	<cfelse>
		<cfquery name="rsMascara" datasource="#Session.DSN#">
			select PCNid, PCEcatid, PCNlongitud, PCNdep, PCNdescripcion
			  from PCNivelMascara
			 where PCEMid = #rsCPvigencia.PCEMid#
			 order by PCNid
		</cfquery>
		<cfif rsMascara.recordCount NEQ arrayLen(LvarMascara)-1>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascara"
			Default="Error en la definición de los Niveles de la Máscara del <BR>
							  Plan de Cuentas: el número de niveles no coincide con la <br>
							  máscara asignada a la Cuenta Mayor"
			returnvariable="MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascara"/>
		
			<cfthrow message="#MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascara#">
		</cfif>
		<cfset LvarDescripciones = arraynew(1)>
		<cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
		<cfset LvarMascaraN = arrayLen(LvarMascara)>
		<cfloop query="rsMascara">
			<cfset i=rsMascara.currentRow + 1>
			<cfset LvarDescripciones[i] = rsMascara.PCNdescripcion>
			<cfif rsMascara.PCNlongitud NEQ len(LvarMascara[i])>
				<cfinvoke 	component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascaraPlandeCuentas"
							Default="Error en la definición de los Niveles de la Máscara del <BR>
												  Plan de Cuentas: el tamaño del nivel"
							returnvariable="MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascaraPlandeCuentas"
				/>
					
				<cfinvoke 	component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_ConLaMascaraAsignadaALaCuentaMayor"
							Default="no coincide<br>con la máscara asignada a la Cuenta Mayor"
							returnvariable="MSG_ConLaMascaraAsignadaALaCuentaMayor"
				/>
				
				<cf_errorCode	code = "50131"
								msg  = "@errorDat_1@ @errorDat_2@ @errorDat_3@"
								errorDat_1="#MSG_ErrorEnLaDefinicionDeLosNivelesDeLaMascaraPlandeCuentas#"
								errorDat_2="#i-1#"
								errorDat_3="#MSG_ConLaMascaraAsignadaALaCuentaMayor#"
				>
			</cfif>
		</cfloop>
		<tr>
			<td width="120" nowrap>
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td nowrap="nowrap">
							#LB_MascaraPlan#:
						</td>
						<td>
							<img	alt="Estructura de Máscara y Detalle del Plan de Cuentas" 
									onClick="sbPintaMascara();"
									style="cursor:pointer;"
									src="../imagenes/Base.gif"
							>&nbsp;
						</td>
					</tr>
				</table>
			</td>
			<script language="javascript">
				function sbPintaMascara()
				{
					var LvarOcodigo = document.frmLista.Ocodigo.value;					
					var LvarParam = "ConlisCuentasFinancierasL.cfm?Ecodigo=#URLEncodedFormat(form.Ecodigo)#&Cmayor=#URLEncodedFormat(form.Cmayor)#&CPVfecha=#URLEncodedFormat(form.CPVfecha)#&Ocodigo="+LvarOcodigo;
					var x = window.open(LvarParam,"PlanCuentas","resizable=yes,menu=no,scrollbars=no,toolbar=no,menubar=no,personalbar=no,status=no,location=no");
					x.focus();
				}	

				function sbPintaMascaras()
				{
					var LvarOcodigo = document.frmLista.Ocodigo.value;					
					var LvarParam = "ConlisCuentasFinancierasTot.cfm?Ecodigo=#URLEncodedFormat(form.Ecodigo)#&CPVfecha=#URLEncodedFormat(form.CPVfecha)
					#&Ocodigo="+LvarOcodigo;
					var x = window.open(LvarParam,"PlanCuentas2","scrollbars=yes,toolbar=yes,menubar=yes,personalbar=yes");
					x.focus();  
				}
		
			</script>
			<td rowspan="2" colspan="2">
				<table width="100%">
					<tr>
						<td style="font-size:10px; cursor:pointer;"  title="Cuenta Mayor" onClick="alert('Cuenta Mayor');">
							<strong>#form.Cmayor#</strong>
						</td>
					<cfloop index="i" from="2" to="#LvarMascaraN#">
						<td>-</td>
						<td align="center" style="cursor:pointer;"  title="#LvarDescripciones[i]#"  onClick="alert('#JSstringFormat(replace(LvarDescripciones[i],"'","´","ALL"))#');">#LvarMascara[i]#</td>
					</cfloop>
					<cfif NOT(isdefined("url.Ocodigo") AND url.Ocodigo NEQ "" AND url.Ocodigo GTE 0)>
						<td colspan="2" align="right">
							<cf_sifcalendario name="CPVfecha" form="frmLista" value="#form.CPVfecha#">
						</td>
					</cfif>
					</tr>
					<tr>
						<cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
						<td style="font-size:10px;">
							<strong>#form.Cmayor#</strong>
						</td>
					<cfset LvarLlenarDeps = "">
					<cfloop query="rsMascara">
						<cfset i=rsMascara.currentRow>
						<cfquery name="rsMascaraDep" dbtype="query">
							select PCNid
							  from rsMascara
							 where PCNdep = #i#
						</cfquery>
						<td>-</td>
						<td align="center">
							<input type="hidden" name="refID#i#" id="refID#i#" 
									<cfif rsMascaraDep.recordCount EQ 0>
									value=""
									<cfelse>
									value="#rsMascara.PCEcatid#"
									</cfif>
							>
							<input type="text" name="CFnivel#i#" id="CFnivel#i#" value=""
									style="width:#len(LvarMascara[i+1])#em;font-size:10px;"
									maxlength="#len(LvarMascara[i+1])#"
									onBlur="this.value=fnConCeros(this.value,#len(LvarMascara[i+1])#);sbCFnivelToCFformato();
									<cfif rsMascaraDep.recordCount GT 0>
											document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&nivelDepende=#i#&Ecodigo=#form.Ecodigo#&Cmayor=#form.Cmayor#&refID=' + document.getElementById('refID#i#').value + '&refValor=' + this.value;fnVerFrame('ifrCFnivel#i#');
											<cfset LvarLlenarDeps = LvarLlenarDeps & "|document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&Ecodigo=#form.Ecodigo#&nivelDepende=#i#&refID=#rsMascara.PCEcatid#&refValor='+document.getElementById('CFnivel#i#').value;">
									</cfif>
											"
									onFocus="this.select();fnVerFrame('ifrCFnivel#i#');"
<!---
 									<cfif rsMascara.PCNdep EQ "">
									onFocus="this.select();fnVerFrame('ifrCFnivel#i#');"
									<cfelse>
									<cfquery name="rsMascaraRef" dbtype="query">
										select PCEcatid
										  from rsMascara
										 where PCNid = #rsMascara.PCNdep#
									</cfquery>
									onFocus="this.select();document.getElementById('ifrCFnivel#i#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#i#&nivelDepende=#rsMascara.PCNdep#&refID=#rsMascaraRef.PCEcatid#&refValor='+document.getElementById('CFnivel#rsMascara.PCNdep#').value;fnVerFrame('ifrCFnivel#i#');"
									</cfif>
 --->
 									<!--- document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&nivelDepende=#i#&refID=#rsMascara.PCEcatid#&refValor='+this.value; --->
									<cfif rsMascaraDep.recordCount GT 0>
									onChange="form.CFdescripcion.value='';document.getElementById('CFnivel#rsMascaraDep.PCNid#').value='';"
									<cfelse>
									onChange="form.CFdescripcion.value='';"
									</cfif>
									onKeyPress="return fnKeyPressNumber(event,this);"
							  >
						</td>
					</cfloop>
						<td align="left" nowrap>	
							<input type="hidden" name="CFformato" id="CFformato">
							<input type="text" name="CFdescripcion" id="CFdescripcion" size="40" disabled style="font-size:10px;border:none;">
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_OK"
							Default="OK"
							returnvariable="BTN_OK"/>
							<input type="button" value="<cfoutput>#BTN_OK#</cfoutput>" onClick="sbSeleccionar();">							
						</td>
						<td align="right">
							<cfset fnCboOficina()>
						</td>
					</tr>
				</table>
			</td>
			<td rowspan="2" align="left">
			</td>
		</tr>
		<tr>
			<td width="130" nowrap>
				#LB_CuentaFinanciera#:
			</td>
		</tr>
	</cfif>
	</table>
	<iframe id="ifrVerifica" name="ifrVerifica" width="100%" height="310" src="" style="display:none">
	</iframe>
	<iframe id="ifrCuentas" name="ifrCuentas" width="100%" height="310" src="ConlisCuentasFinancierasCtas.cfm?Cmayor=#Form.Cmayor#&movimiento=#form.movimiento#&auxiliares=#form.auxiliares#&Ecodigo=#form.Ecodigo#&CFid=#form.CFid#">
	</iframe>
	<cfif Lvar_ConPlanCtas>
		<cfloop query="rsMascara">
			<cfset i=rsMascara.currentRow>
			<cfif rsMascara.PCNdep EQ "">
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasNivel.cfm?Cmayor=#Form.Cmayor#&nivel=#i#&Ecodigo=#form.Ecodigo#&CatalogoID=#rsMascara.PCEcatid#&nivelDepende=#rsMascara.PCNdep#" style="display:none">
			<cfelseif false>
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasSubNivel.cfm?Cmayor=#Form.Cmayor#&nivel=#i#&Ecodigo=#form.Ecodigo#&nivelDepende=#rsMascara.PCNdep#&refID=421&refValor=02" style="display:none">
			<cfelse>
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasSubNivel.cfm?Cmayor=#Form.Cmayor#&nivel=#i#&Ecodigo=#form.Ecodigo#&nivelDepende=#rsMascara.PCNdep#" style="display:none">
			</cfif>
			</iframe>
		</cfloop>
	</cfif>
<cfif not isdefined("url.Cmayores")>
	<iframe id="ifrCmayor" name="ifrCmayor" width="100%" height="310" src="ConlisCuentasFinancierasMayor.cfm?Ctipo=#form.Ctipo#&Ecodigo=#form.Ecodigo#&CFid=#form.CFid#" style="display:none">
	</iframe>
</cfif>
</form>
<script language="javascript">
	function fnLlenarDeps()
	{
<cfif isdefined("LvarLlenarDeps") AND form.CFdetalle NEQ "" AND LvarLlenarDeps NEQ "">
    <cfset LvarLlenarDeps = listtoarray(LvarLlenarDeps,"|")>
	
	<cfloop index="i" from="1" to="#arrayLen(LvarLlenarDeps)#">
		#LvarLlenarDeps[i]#
	</cfloop>
</cfif>
	return;
	}
</script>

</cfoutput>
</body>
<script language="javascript" type="text/javascript">
	fnBodyOnLoad();
</script>
</html>
<cffunction name="fnCboOficina" output="true">
	<cfif isdefined("url.CFid") AND url.CFid NEQ "" AND url.CFid GT 0>
		<cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:
		<cfquery name="rsCF" datasource="#session.DSN#">
			select o.Ocodigo, o.Odescripcion, cf.CFcodigo
			  from CFuncional cf
				  inner join Oficinas o
					 on o.Ecodigo = cf.Ecodigo
					and o.Ocodigo = cf.Ocodigo
			 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CFid#">
		</cfquery>
		<cfset url.Ocodigo = rsCF.Ocodigo>
		<cfoutput>
			<input type="hidden" name="Ocodigo" value="#rsCF.Ocodigo#">
			#rsCF.CFcodigo# (Ofi: #rsCF.Odescripcion#)
		</cfoutput>
	<cfelse>
		#LB_Oficina#:
		<cfquery name="rsOficinas" datasource="#session.DSN#">
			select Ocodigo, Oficodigo, Odescripcion
			  from Oficinas
			 where Ecodigo = #session.Ecodigo#
			 <cfif isdefined("url.Ocodigo") AND url.Ocodigo NEQ "" AND url.Ocodigo GTE 0>
			   and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			 </cfif>
			 order by Odescripcion
		</cfquery>
		<select name="Ocodigo" id="Ocodigo">
		 <cfif NOT(isdefined("url.Ocodigo") AND url.Ocodigo NEQ "" AND url.Ocodigo GTE 0)>
			<option value="-1">(#LB_TodasOficinas#)</option>
		 </cfif>
		<cfloop query="rsOficinas">
			<option value="#Ocodigo#">#Odescripcion#</option>
		</cfloop>
		</select>
	</cfif>
	
</cffunction>
