<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Cuentas Financieras</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<cfinclude template="/sif/Utiles/ConlisCuentasFinancierasParams.cfm">
<cfif isdefined("Request.ConCuentasFinancieras")>
	<cfset LvarCFM = "ConCuentasFinancieras.cfm">
<cfelse>
	<cfset LvarCFM = "ConlisCuentasFinancieras.cfm">
</cfif>
<cfquery name="rsMayor" datasource="#Session.DSN#">
	select m.Cmayor, m.Cdescripcion, v.PCEMid, v.CPVformatoF as Cmascara, m.Ctipo 
	  from CtasMayor m
		  inner join CPVigencia v
		  	 on v.Ecodigo = m.Ecodigo
			and v.Cmayor  = m.Cmayor
			and #dateformat(now(),"YYYYMM")#
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

<cfoutput>
<script language="javascript" type="text/javascript">
	function fnBodyOnLoad()
	{
<cfif not Lvar_CMayorError>
		document.frmLista.Cmayor.value = "#form.Cmayor#";
		var LvarCFformato = "#form.Cmayor#";
		<cfif Lvar_ConPlanCtas>
		var LvarFormatos = "#form.CFdetalle#".split("-");
		for (var i=0; i<LvarFormatos.length; i++)
		{
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
					LvarIframe.style.display = (LvarIframe.name == LprmNombre) ? "" : "none";
			}
		}
	}
	function fnCmayor_onChange(e,o)
	{
		o.value = fnConCeros(o.value, 4);
		var LvarParam;
		LvarParam = "#GvarUrlToFormParam#".replace(/Cmayor=.*&/,"Cmayor="+o.value+"&");
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
			alert ("No ha escogido ninguna cuenta");
			return;
		}
		var LvarCFformato = document.getElementById("CFformato").value;
		if (window.opener && window.opener.sbResultadoConLis) 
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+"&ConLis=S"+"&Ecodigo="+'<cfoutput>#form.Ecodigo#</cfoutput>';
		else
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+"&ConLis=N"+"&Ecodigo="+'<cfoutput>#form.Ecodigo#</cfoutput>';
//		sbSeleccionarOK();
	}

	function sbSeleccionarOK()
	{
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
<form name="frmLista" action="#LvarCFM#" method="post" onSubmit="return (Cmayor.value != Cmayor.defaultValue);">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="120" nowrap>
				<cfif form.Ctipo EQ 'A'>Cuenta Mayor <strong>Activo</strong>:
				<cfelseif form.Ctipo EQ 'P'>Cuenta Mayor <strong>Pasivo</strong>:
				<cfelseif form.Ctipo EQ 'C'>Cuenta Mayor <strong>Capital</strong>:
				<cfelseif form.Ctipo EQ 'I'>Cuenta Mayor <strong>Ingreso</strong>:
				<cfelseif form.Ctipo EQ 'G'>Cuenta Mayor <strong>Gasto</strong>:
				<cfelse>
				Cuenta Mayor:
				</cfif>
			</td>
			<td>
				<input type="text" name="Cmayor" id="Cmayor" value="#form.Cmayor#" maxlength="4" tabindex="1"
						 onChange="fnCmayor_onChange(event, this);"
						 onKeyPress="if (fnKeyIsEnter(event)) {fnCmayor_onChange(event, this); return false;} else return fnKeyPressNumber(event,this);"
						 onFocus="this.select();fnVerFrame('ifrCmayor');"
						 style="font-size:10px; width:35px"
				>
<cfif Lvar_CMayorError >
				<font color="##FF0000"><strong>
				<cfif isdefined("rsCPvigencia")>
					- La cuenta Mayor '#form.Cmayor#' no tiene vigencia para el '#form.CPVfecha#'
					<cfset form.Cmayor = "1">
				<cfelseif form.Cmayor NEQ "" AND rsMayor.recordcount EQ 0>
					- CUENTA MAYOR NO EXISTE
				<cfelseif form.Cmayor NEQ "" AND form.Ctipo NEQ "">
					- CUENTA MAYOR NO ES 
						<cfif form.Ctipo EQ 'A'>ACTIVO
						<cfelseif form.Ctipo EQ 'P'>PASIVO
						<cfelseif form.Ctipo EQ 'C'>CAPITAL
						<cfelseif form.Ctipo EQ 'I'>INGRESO
						<cfelseif form.Ctipo EQ 'G'>GASTO
						</cfif>
				</cfif>
				</strong></font>
			</td>
		</tr>
	</table>
	<iframe id="ifrCmayor" width="100%" height="350" src="ConlisCuentasFinancierasMayor.cfm?Ctipo=#form.Ctipo#&Ecodigo=#form.Ecodigo#">
	</iframe>
</form>
</body>
</html>
<cfexit>
</cfif>
				<strong> - #rsMayor.Cdescripcion#</strong>
			</td>
			<td align="right">
				<input type="button" value="Ver cuentas existentes"
						 onClick="fnVerFrame('ifrCuentas');">
			</td>
		</tr>
	<cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
	<cfif NOT Lvar_ConPlanCtas>
		<tr>
			<td width="120" nowrap>
				Mascara de la Cuenta: 
			</td>
			<td style="font-size:10px;" colspan="2">
				<strong>#form.Cmayor#</strong>#mid(rsMayor.Cmascara,5,100)#
			</td>
		</tr>
		<tr>
			<td width="120" nowrap>
				Cuenta Financiera:
			</td>
			<td colspan="2">
				<strong>#form.Cmayor#</strong>-<input type="text" name="CFdetalle" id="CFdetalle" size="#len(rsMayor.Cmascara)-5#" maxlength="#len(rsMayor.Cmascara)-5#" style="font-size:10px;" onFocus="this.select();" onChange="document.getElementById('CFformato').value = document.getElementById('Cmayor').value + '.' + this.value;">
				<input type="hidden" name="CFformato" id="CFformato">
				<input type="text" name="CFdescripcion" id="CFdescripcion" size="40" disabled style="font-size:10px;border:none;">
				<input type="button" value="OK" onClick="sbSeleccionar();">
			</td>
		</tr>
	<cfelse>
		<cfquery name="rsMascara" datasource="#Session.DSN#">
			select PCNid, PCEcatid, PCNlongitud, PCNdep
			  from PCNivelMascara
			 where PCEMid = #rsCPvigencia.PCEMid#
			 order by PCNid
		</cfquery>
		<cfif rsMascara.recordCount NEQ arrayLen(LvarMascara)-1>
			<cf_errorCode	code = "50028" msg = "Error en la definición de los Niveles de la Máscara del <BR> Plan de Cuentas: el número de niveles no coincide con la <BR> máscara asignada a la Cuenta Mayor">
		</cfif>
		<cfloop query="rsMascara">
			<cfset i=rsMascara.currentRow + 1>
			<cfif rsMascara.PCNlongitud NEQ len(LvarMascara[i])>
				<cf_errorCode	code = "50029"
								msg  = "Error en la definición de los Niveles de la Máscara del <BR> Plan de Cuentas: el tamaño del nivel @errorDat_1@ no coincide<BR> con la máscara asignada a la Cuenta Mayor"
								errorDat_1="#i-1#"
				>
			</cfif>
		</cfloop>
		<tr>
			<td width="120" nowrap>
				Mascara del Plan: 
			</td>
			<td rowspan="2" colspan="2">
				<table>
					<tr>
						<cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
						<td style="font-size:10px;">
							<strong>#form.Cmayor#</strong>
						</td>
					<cfloop index="i" from="2" to="#arrayLen(LvarMascara)#">
						<td>-</td>
						<td align="center">#LvarMascara[i]#</td>
					</cfloop>
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
											document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&nivelDepende=#i#&Ecodigo=#form.Ecodigo#&refID=' + document.getElementById('refID#i#').value + '&refValor=' + this.value;fnVerFrame('ifrCFnivel#i#');
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
							<input type="button" value="OK" onClick="sbSeleccionar();">
						</td>
					</tr>
				</table>
			</td>
			<td rowspan="2" align="left">
			</td>
		</tr>
		<tr>
			<td width="120" nowrap>
				Cuenta Financiera:
			</td>
		</tr>
	</cfif>
	</table>
	<iframe id="ifrVerifica" name="ifrVerifica" width="100%" height="310" src="" style="display:none">
	</iframe>
	<iframe id="ifrCuentas" name="ifrCuentas" width="100%" height="310" src="ConlisCuentasFinancierasCtas.cfm?Cmayor=#Form.Cmayor#&movimiento=#form.movimiento#&auxiliares=#form.auxiliares#&Ecodigo=#form.Ecodigo#">
	</iframe>
	<cfif Lvar_ConPlanCtas>
		<cfloop query="rsMascara">
			<cfset i=rsMascara.currentRow>
			<cfif rsMascara.PCNdep EQ "">
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasNivel.cfm?nivel=#i#&Ecodigo=#form.Ecodigo#&CatalogoID=#rsMascara.PCEcatid#&nivelDepende=#rsMascara.PCNdep#" style="display:none">
			<cfelseif false>
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasSubNivel.cfm?nivel=#i#&Ecodigo=#form.Ecodigo#&nivelDepende=#rsMascara.PCNdep#&refID=421&refValor=02" style="display:none">
			<cfelse>
			<iframe id="ifrCFnivel#i#" name="ifrCFnivel#i#" width="100%" height="310" src="ConlisCuentasFinancierasSubNivel.cfm?nivel=#i#&Ecodigo=#form.Ecodigo#&nivelDepende=#rsMascara.PCNdep#" style="display:none">
			</cfif>
			</iframe>
		</cfloop>
	</cfif>
	<iframe id="ifrCmayor" name="ifrCmayor" width="100%" height="310" src="ConlisCuentasFinancierasMayor.cfm?Ctipo=#form.Ctipo#&Ecodigo=#form.Ecodigo#" style="display:none">
	</iframe>
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
</html>


