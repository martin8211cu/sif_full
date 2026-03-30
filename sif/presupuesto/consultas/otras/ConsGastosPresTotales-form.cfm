<cfquery name="anos" datasource="minisif">
	select distinct CPCano
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	order by CPCano
</cfquery>
<cfquery name="monedas" datasource="minisif">
	Select distinct a.Mcodigo, b.Mnombre
	from CPTipoCambioProyectadoMes a inner join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where a.Ecodigo = #session.ecodigo#
	order by Mnombre
</cfquery>
<cfquery name="rsOficinas" datasource="minisif">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = #session.ecodigo#
</cfquery>
<cfquery name="meses" datasource="minisif">
	select distinct CPCmes, case when CPCmes = 1 then 'Enero' 
								 when CPCmes = 2 then 'Febrero' 
								 when CPCmes = 3 then 'Marzo' 
								 when CPCmes = 4 then 'Abril' 
								 when CPCmes = 5 then 'Mayo' 
								 when CPCmes = 6 then 'Junio' 
								 when CPCmes = 7 then 'Julio' 
								 when CPCmes = 8 then 'Agosto' 
								 when CPCmes = 9 then 'Septiembre' 
								 when CPCmes = 10 then 'Octubre' 
								 when CPCmes = 11 then 'Noviembre' 
								when CPCmes = 12 then 'Diciembre' 
							end as mes
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	order by CPCmes
</cfquery>
<cfinclude template="../../Utiles/ConlisCuentasFinancierasParams.cfm">
<cfif isdefined("Request.ConCuentasFinancieras")>
	<cfset LvarCFM = "../../Utiles/ConCuentasFinancieras.cfm">
<cfelse>
	<cfset LvarCFM = "../../Utiles/ConlisCuentasFinancieras.cfm">
</cfif>
<cfset LvarCFM = "">
<cfset filtro = "">
<cfset navegacion = "">
<cfset Lvar_CMayorError = false>
<cfset Lvar_ConPlanCtas = false>
<cfif isdefined("form.Cmayor")>
	<cfquery name="rsMayor" datasource="#Session.DSN#">
		select Cmayor, Cdescripcion, PCEMid, Cmascara 
		  from CtasMayor
		 where Ecodigo=#session.Ecodigo# 
		   and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
	</cfquery>

	<cfif rsMayor.recordCount EQ 0>
		<cfset Lvar_CMayorError = true>
	<cfelse>
	
		<cfquery name="rsCPvigencia" datasource="#Session.DSN#">
			select 	v.Ecodigo, v.Cmayor, CPVdesdeAnoMes, CPVhastaAnoMes,
					v.CPVid, v.PCEMid, 
					m.PCEMplanCtas, m.PCEMformato as PCEMformatoF, m.PCEMformatoC, m.PCEMformatoP
			  from CPVigencia v
				left outer join PCEMascaras m
					 ON m.PCEMid = v.PCEMid
				inner join PCNivelMascara n
				     ON n.PCEMid = v.PCEMid
				     and n.PCNpresupuesto = 1
			 where v.Ecodigo = #session.Ecodigo#
			   and v.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			   and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(LSparseDateTime(form.CPVfecha),'YYYYMM')#"> between CPVdesdeAnoMes and CPVhastaAnoMes
		</cfquery>
		<cfif rsCPvigencia.recordCount EQ 0>
			<cfset Lvar_CMayorError = true>
		<cfelse>
			<cfset Lvar_ConPlanCtas = (rsCPvigencia.PCEMid NEQ "" AND rsCPvigencia.PCEMplanCtas EQ "1")>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
<script language="javascript" type="text/javascript">
	function fnBodyOnLoad()
	{
<cfif not Lvar_CMayorError and isdefined("form.Cmayor") and len(trim(form.Cmayor)) neq 0>
		document.form1.Cmayor.value = "#form.Cmayor#";
		var LvarCFformato = "#form.Cmayor#";
		<cfif Lvar_ConPlanCtas>
		var LvarFormatos = "#form.CFdetalle#".split("-");
		
		for (var i=0; i<LvarFormatos.length; i++)
		{
			if (LvarFormatos[i].length){
				document.getElementById("CFnivel"+(i+1)).value = LvarFormatos[i];
				LvarCFformato = LvarCFformato + "-" + LvarFormatos[i];
			}
			else {
				document.getElementById("CFnivel"+(i+1)).value = '00';
			}
		}
		<cfelse>
			LvarCFformato = "#form.Cmayor#-#form.CFdetalle#";
			document.form1.CFdetalle.value = "#form.CFdetalle#";
		</cfif>
		document.form1.CFformato.value = LvarCFformato;
		
		<cfset LvarPtoIni = find("CFdetalle=",GvarUrlToFormParam)>
		<cfset LvarPtoFin = find("&",GvarUrlToFormParam,LvarPtoIni+10)>
		<cfif LvarPtoIni LT LvarPtoFin>
			<cfset GvarUrlToFormParam = mid(GvarUrlToFormParam, 1, LvarPtoIni-1) & "CFdetalle=" & mid(GvarUrlToFormParam, LvarPtoFin, 100)>
		<cfelseif LvarPtoIni GT 0>
			<cfset GvarUrlToFormParam = mid(GvarUrlToFormParam, 1, LvarPtoIni-1) & "CFdetalle=">
		</cfif>
	</cfif>
	}

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
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
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+"&ConLis=S";
		else
			document.getElementById("ifrVerifica").src="ConlisCuentasFinancierasVerif.cfm?CFformato="+LvarCFformato+"&ConLis=N";
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
	function validar(form){

	var cuantos = new Number(document.form1.tienePresupuesto.value);
	var cuenta  = new Number(document.form1.Cmayor.value);
	
		if (cuenta == 0) {
			alert ("No ha escogido ninguna cuenta");
			return false;
		}
		if (cuantos == 0) {
			alert("Esta cuenta no puede ser consultada");
			return false;
		}
	}
</script>
</cfoutput>
<cfoutput>
<body onLoad="fnBodyOnLoad();">
<form name="form1" method="post" action="ConsGastosPresTotales-reporte.cfm" >

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="92" nowrap class="fileLabel"><strong> Del Per&iacute;odo: </strong></td>
	<td width="831"><select name="CPCano" accesskey="1" tabindex="1">
					
            <cfloop query="anos">
                <option value="#anos.CPCano#">#anos.CPCano#</option>
             </cfloop>       </select>
			 
			 <input type="hidden" name="tienePresupuesto" id="tienePresupuesto" value="<cfif isdefined("rsCPvigencia")>#rsCPvigencia.RecordCount#<cfelse>0</cfif>">
			 </td>
    </tr>
  <tr>
    <td nowrap class="fileLabel"><strong>Del Mes</strong></td>
	<td><select name="CPCmes">
		
      <cfloop query="meses">
        <option value="#meses.CPCmes#">#meses.mes#</option>
      </cfloop>
    </select>	</td>
	</tr>
  <tr>
    <td align="left" nowrap><strong>Oficina:</strong></td>
    <td align="left" nowrap><select name="Oficina">
		<option value="">Todos</option>
      <cfloop query="rsOficinas">
        <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
      </cfloop>
    </select></td>
  </tr>
  <tr>
    <!--- <td align="left" nowrap><div align="left"><strong>Formato:&nbsp; </strong></div></td>
    <td align="left" nowrap><select name="formato">
        <option value="html">En l&iacute;nea (HTML)</option>
        <option value="pdf">Adobe PDF</option>
        <option value="xls">Microsoft Excel</option>
    </select></td> --->
    </tr>
<tr>
			<td width="120" nowrap><strong>
			  Cuenta Mayor: 
			</strong></td>
			<td >
				<input type="text" name="Cmayor" id="Cmayor" value="<cfif isdefined("form.Cmayor")>#form.Cmayor#</cfif>" maxlength="4" tabindex="1"
						 onChange="fnCmayor_onChange(event, this);"
						 onKeyPress="if (fnKeyIsEnter(event)) {fnCmayor_onChange(event, this); return false;} else return fnKeyPressNumber(event,this);"
						 onFocus="this.select();fnVerFrame('ifrCmayor');"
						 style="font-size:10px; width:35px"
				>
				<cfif Lvar_CMayorError >
					<font color="##FF0000"><strong>
					<cfif isdefined("rsCPvigencia")>
						- La cuenta Mayor '#form.Cmayor#' no tiene vigencia para <br> el '#form.CPVfecha#' o no tiene Presupuesto
						<cfset form.Cmayor = "1">
					<cfelseif form.Cmayor NEQ "">
						- CUENTA MAYOR NO EXISTE
					</cfif>
					</strong></font>
				<cfelse>
					<strong> - #rsMayor.Cdescripcion#</strong>
				</cfif>
				
			</td>
	  </tr>
 
  
  <cfset LvarMascara = listtoarray(rsMayor.Cmascara,"-")>
	<cfif NOT Lvar_ConPlanCtas>
	<!---
		<tr>
			<td width="120" nowrap><strong>
			  Mascara de la Cuenta: 
			</strong></td>
			<td style="font-size:10px;" colspan="2">
				<strong>#form.Cmayor#</strong>#mid(rsMayor.Cmascara,5,100)#
			</td>
		</tr>
		<tr>
			<td width="120" nowrap><strong>
			  Cuenta Financiera:
			</strong></td>
			<td colspan="2">
				<strong>#form.Cmayor#</strong>-<input type="text" name="CFdetalle" id="CFdetalle" size="#len(rsMayor.Cmascara)-5#" maxlength="#len(rsMayor.Cmascara)-5#" style="font-size:10px;" onFocus="this.select();" onChange="document.getElementById('CFformato').value = document.getElementById('Cmayor').value + '.' + this.value; document.getElementById('CFformato2').value = document.getElementById('Cmayor').value + '.' + this.value;">
				<input type="hidden" name="CFformato" id="CFformato">
				<input type="text" name="CFdescripcion" id="CFdescripcion" size="40" disabled style="font-size:10px;border:none;">
				<!--- <input type="button" value="OK" onClick="sbSeleccionar();"> --->
			</td>
		</tr> --->
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
			<td width="120" nowrap><strong>
			  Mascara del Plan: 
			</strong></td>
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
							<input type="text" name="CFnivel#i#" id="CFnivel#i#" 
									value="<cfif #len(LvarMascara[i+1])# EQ 1>0
											<cfelseif #len(LvarMascara[i+1])# EQ 2>00
											<cfelseif #len(LvarMascara[i+1])# EQ 3>000
											<cfelseif #len(LvarMascara[i+1])# EQ 4>00000
											<cfelseif #len(LvarMascara[i+1])# EQ 5>000000
											<cfelseif #len(LvarMascara[i+1])# EQ 6>0000000
											<cfelseif #len(LvarMascara[i+1])# EQ 7>00000000
											<cfelseif #len(LvarMascara[i+1])# EQ 8>000000000
											<cfelseif #len(LvarMascara[i+1])# EQ 9>0000000000
											<cfelseif #len(LvarMascara[i+1])# EQ 10>00000000000
											<cfelse>0
											</cfif>"
									 
									style="width:#len(LvarMascara[i+1])#em;font-size:10px;"
									maxlength="#len(LvarMascara[i+1])#"
									onBlur="this.value=fnConCeros(this.value,#len(LvarMascara[i+1])#);sbCFnivelToCFformato();
									<cfif rsMascaraDep.recordCount GT 0>
											document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&nivelDepende=#i#&refID=' + document.getElementById('refID#i#').value + '&refValor=' + this.value;fnVerFrame('ifrCFnivel#i#');
											<cfset LvarLlenarDeps = LvarLlenarDeps & "|document.getElementById('ifrCFnivel#rsMascaraDep.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel=#rsMascaraDep.PCNid#&nivelDepende=#i#&refID=#rsMascara.PCEcatid#&refValor='+document.getElementById('CFnivel#i#').value;">
									</cfif>"
									onFocus="this.select();fnVerFrame('ifrCFnivel#i#');"
									<cfif rsMascaraDep.recordCount GT 0>
									onChange="form.CFdescripcion.value='';document.getElementById('CFnivel#rsMascaraDep.PCNid#').value='';"
									<cfelse>
									onChange="form.CFdescripcion.value='';"
									</cfif>
									onKeyPress="return fnKeyPressNumber(event,this);">
						</td>
					</cfloop>
						<td align="left" nowrap>	
							<input type="hidden" name="CFformato" id="CFformato">
							<input type="text" name="CFdescripcion" id="CFdescripcion" size="40" disabled style="font-size:10px;border:none;">
							<!--- <input type="button" value="OK" onClick="sbSeleccionar();"> --->
						</td>
					</tr>
				</table>
			</td>
			<td rowspan="2" align="left">
			</td>
		</tr>
		<tr>
			<td width="120" nowrap><strong>
			  Cuenta Inicial:
			</strong></td>
		</tr>
		<cfquery name="rsMascara2" datasource="#Session.DSN#">
			select PCNid, PCEcatid, PCNlongitud, PCNdep
			  from PCNivelMascara
			 where PCEMid = #rsCPvigencia.PCEMid#
			   
			 order by PCNid
		</cfquery>
		
		<cfif rsMascara2.recordCount NEQ arrayLen(LvarMascara)-1>
			<cf_errorCode	code = "50028" msg = "Error en la definición de los Niveles de la Máscara del <BR> Plan de Cuentas: el número de niveles no coincide con la <BR> máscara asignada a la Cuenta Mayor">
		</cfif>
		<cfloop query="rsMascara2">
			<cfset i=rsMascara2.currentRow + 1>
			<cfif rsMascara2.PCNlongitud NEQ len(LvarMascara[i])>
				<cf_errorCode	code = "50029"
								msg  = "Error en la definición de los Niveles de la Máscara del <BR> Plan de Cuentas: el tamaño del nivel @errorDat_1@ no coincide<BR> con la máscara asignada a la Cuenta Mayor"
								errorDat_1="#i-1#"
				>
			</cfif>
		</cfloop>
		<tr>
			<td width="120" nowrap><strong>
			  Mascara del Plan: 
			</strong></td>
			<td rowspan="2" colspan="2">
				<table>
					<tr>
						<cfset LvarMascara2 = listtoarray(rsMayor.Cmascara,"-")>
						<td style="font-size:10px;">
							<strong>#form.Cmayor#</strong>
						</td>
					<cfloop index="i" from="2" to="#arrayLen(LvarMascara2)#">
						<td>-</td>
						<td align="center">#LvarMascara2[i]#</td>
					</cfloop>
					</tr>
					<tr>
						<cfset LvarMascara2 = listtoarray(rsMayor.Cmascara,"-")>
						<td style="font-size:10px;">
							<strong>#form.Cmayor#</strong>
						</td>
					<cfset LvarLlenarDeps2 = "">
					<cfloop query="rsMascara2">
						<cfset i=rsMascara2.currentRow>
						<cfquery name="rsMascaraDep2" dbtype="query">
							select PCNid
							  from rsMascara
							 where PCNdep = #i#
						</cfquery>
						<td>-</td>
						<td align="center">
							<input type="hidden" name="refID2#i#" id="refID2#i#" 
									<cfif rsMascaraDep2.recordCount EQ 0>
									value=""
									<cfelse>
									value="#rsMascara2.PCEcatid#"
									</cfif>
							>
							<input type="text" name="CFnivel2#i#" id="CFnivel2#i#" value="9999999999"
									 
									style="width:#len(LvarMascara2[i+1])#em;font-size:10px;"
									maxlength="#len(LvarMascara2[i+1])#"
									onBlur="this.value=fnConCeros(this.value,#len(LvarMascara2[i+1])#);sbCFnivelToCFformato();
									<cfif rsMascaraDep2.recordCount GT 0>
											document.getElementById('ifrCFnivel2#rsMascaraDep2.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel2=#rsMascaraDep2.PCNid#&nivelDepende2=#i#&refID2=' + document.getElementById('refID2#i#').value + '&refValor2=' + this.value;fnVerFrame('ifrCFnivel2#i#');
											<cfset LvarLlenarDeps2 = LvarLlenarDeps2 & "|document.getElementById('ifrCFnivel2#rsMascaraDep2.PCNid#').src='ConlisCuentasFinancierasSubNivel.cfm?nivel2=#rsMascaraDep2.PCNid#&nivelDepende2=#i#&refID2=#rsMascara2.PCEcatid#&refValor2='+document.getElementById('CFnivel2#i#').value;">
									</cfif>
											"
									onFocus="this.select();fnVerFrame('ifrCFnivel2#i#'); "
									<cfif rsMascaraDep2.recordCount GT 0>
									onChange="form.CFdescripcion2.value='';document.getElementById('CFnivel2#rsMascaraDep2.PCNid#').value='';"
									<cfelse>
									onChange="form.CFdescripcion2.value='';"
									</cfif>
									onKeyPress="return fnKeyPressNumber(event,this);"
							  >
						</td>
					</cfloop>
						<td align="left" nowrap>	
							<input type="hidden" name="CFformato2" id="CFformato2">
							<input type="text" name="CFdescripcion2" id="CFdescripcion2" size="40" disabled style="font-size:10px;border:none;">
							<!--- <input type="button" value="OK" onClick="sbSeleccionar();"> --->
						</td>
					</tr>
				</table>
			</td>
			<td rowspan="2" align="left">
			</td>
		</tr>
		<tr>
			<td width="120" nowrap><strong>
			  Cuenta Final:
			</strong></td>
		</tr>
	</cfif>
	 <tr>
	   <td valign="middle" align="center">&nbsp;</td>
       <td valign="middle" align="center">&nbsp;</td>
	 </tr>
	 <tr>
	   <td valign="middle" align="center">&nbsp;</td>
       <td valign="middle" align="center">&nbsp;</td>
	 </tr>
	 <tr>
  	<td colspan="2" valign="middle" align="center"><input type="submit" value="Consultar" name="Reporte" onClick="javascript: return validar(this);">  
	</td>
  </tr>
</table>
</form>
</body>
</cfoutput>




