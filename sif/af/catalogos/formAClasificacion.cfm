<cfif isdefined("url.ACid") and not isdefined("form.ACid")>
	<cfset form.Acid = url.ACid>
</cfif>
<cfif isdefined("url.ACcodigo") and not isdefined("form.ACcodigo")>
	<cfset form.ACcodigo = url.ACcodigo>
</cfif>

<cfif isdefined("form.ACid") and len(trim(form.ACid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select 	ACcodigo,
			ACcodigodesc,
			ACdescripcion,
			ACvutil,
			ACcatvutil,
			ACmetododep
	from ACategoria
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif (MODO NEQ "ALTA")>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 	ACcodigo,
				ACcodigodesc,
				ACid,
				ACdescripcion,
				ACvutil,
				ACdepreciable,
				ACrevalua,
				ACexigeVale,
				ACcsuperavit,
				ACcadq,
				ACcdepacum,
				ACcrevaluacion,
				ACcdepacumrev,
				ACccomodato,   <!--- Cuenta del comodato --->
				ACgastodep,
				ACgastorev,
				ACtipo,
				ACvalorres,
				cuentac,
				ACgastoret,
				ACingresoret,
				ACNegarMej,
				ts_rversion,
                ACVidaUtilFiscal,
                ACImporteMaximo,
                ACPorcentajeFiscal,
                ACPorcentajePTU,
				ACcgastodepreciacion as ACcgastodepreciacion,
				ACfgastodepreciacion as ACfgastodepreciacion,
                ACmascara
		from AClasificacion
		where Ecodigo 	 = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
		  	and ACid 	 = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfquery name="rsParam" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	and Pcodigo = '1360'
</cfquery>

<!---SML. 26/02/2014 Consulta para obtener el parametro de Generar Placa Automatica --->

<cfquery name="rsGenPlacaAut" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
		  and Pcodigo = '200050'
</cfquery>

<script language="JavaScript" type="text/javascript">
	<!--//
	function fm_2(campo,ndec){
		var s = "";
		if (campo.name){
			s=campo.value
		}
		else{
			s=campo
		}

		if( s=='' && ndec>0 ){
			s='0'
		}

	   var nc=""
	   var s1=""
	   var s2=""

		if (s != '') {
			str = new String("")
			str_temp = new String(s)
			t1 = str_temp.length
			cero_izq = false

			if (t1 > 0) {
				for(i=0;i<t1;i++) {
					c = str_temp.charAt(i)
					str += c
				}
			}

			t1 = str.length
			p1 = str.indexOf(".")
			p2 = str.lastIndexOf(".")

			if ((p1 == p2) && t1 > 0){

				if (p1>0){
					str+="00000000"
				}
				else{
					str+=".0000000"
				}

				p1 = str.indexOf(".")
				s1 = str.substring(0,p1)
				s2 = str.substring(p1+1,p1+1+ndec)
				t1 = s1.length
				n = 0

				for(i=t1-1;i>=0;i--) {
					c=s1.charAt(i)
					if (c == ".") { flag=0;nc="."+nc;n=0 }

					if (c>="0" && c<="9") {
					if (n < 2) {
					   nc = c+nc;
					   n++;
					}
					else {
						n=0
						nc=c+nc
						if (i > 0){
							nc = nc
						 }
					}
				}
			}
			if (nc != "" && ndec > 0)
				nc+="."+s2
			}
			else {ok=1}
		}

		if(campo.name) {
			if(ndec>0) {
				campo.value=nc
			}
			else {
				campo.value=qf(nc)
			}
		}
		else {
			return nc
		}
	}

	function snumber_2(obj,e,d){
		str= new String("")
		str= obj.value
		var tam=obj.size
		var t=Key(e)
		var ok=false

		if(tam>d) {tam=tam-d}
		if(tam>1) {tam=tam-1}

		if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;

		// acepta guiones
		//if(t==109 || t==189)  return true;

		if(t>=16 && t<=20) return false;
		if(t>=33 && t<=40) return false;
		if(t>=112 && t<=123) return false;
		if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
		if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)

		if(t>=48 && t<=57)  ok=true
		if(t>=96 && t<=105) ok=true
		//if(d>=0) {if(t==188) ok=true} //LA COMA

		if(d>0)
		{
		if(t==110) ok=true
		if(t==190) ok=true
		}

		if(!ok){
			str=fm_2(str,d)
			obj.value=str
		}

		return true
	}
	//-->
	function acceptX(evt){
		// NOTE: x = 120, X = 88, Enter = 13, - = 45
		var key = nav4 ? evt.which : evt.keyCode;
		return (key == 13 || key == 45 || key == 88 || key == 8 || key == 0);
	}
</script>

<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/UtilesMonto.js"></script>

<!--- Pintado de la Pantalla --->
<cfoutput>
  <form action="SQLAClasificacion.cfm" method="post" name="form1" onsubmit="return _finalizar();" >
	<table align="left" border="0" width="60%">
		<tr valign="baseline">
			<td nowrap colspan="2" align="left">
				<strong>
					<cfif modo neq "ALTA">
						Cambio de Clasificaci&oacute;n #rsForm.ACcodigodesc# - #rsForm.ACdescripcion#
					<cfelse>
						Registro de Nueva Clasificaci&oacute;n
					</cfif>
				</strong>
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap colspan="2" align="center" class="subTitulo">
				Categoría #rsCategorias.ACdescripcion#
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo:&nbsp;</td>
			<td nowrap>
				<input type="hidden" name="ACcodigo" value="#form.ACcodigo#">
				<input type="text" name="ACcodigodesc" tabindex="1"
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ACcodigodesc#</cfoutput></cfif>" size="10" maxlength="10" onfocus="this.select();">
			</td>
			<cfif modo eq "CAMBIO">
				<td>
					<input type="hidden" name="ACcodigodescL" id="ACcodigodescL" tabindex="1"
					value="#trim(rsForm.ACcodigodesc)#"></td>
			</cfif>
		</tr>

		<tr>
			<td nowrap align="right">Descripci&oacute;n:&nbsp;</td>
			<td nowrap>
				<input o name="ACdescripcion" type="text" tabindex="1"
					value="<cfif modo NEQ "ALTA">#HTMLEditFormat(rsForm.ACdescripcion)#</cfif>" size="40" maxlength="60" onfocus="this.select();">
			</td>
		</tr>

		<tr>
			<td nowrap align="right">Vida &uacute;til:&nbsp;</td>
			<td nowrap>
				<input name="ACvutil" id="ACvutil" type="text"  <cfif rsCategorias.ACcatvutil eq 'S'>disabled</cfif> tabindex="1"
					value="<cfif modo NEQ "ALTA">#rsForm.ACvutil#<cfelseif rsCategorias.ACcatvutil eq 'S'>#rsCategorias.ACvutil#</cfif>"
					size="5" maxlength="5" style="text-align: right;"
					onblur="javascript:fm(this,0); "
					onfocus="javascript:this.value=qf(this); this.select();"
					onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>

        <tr>
			<td nowrap align="right">Vida &Uacute;til Fiscal:&nbsp;</td>
			<td nowrap>
				<input name="ACvutilfiscal" id="ACvutilfiscal" type="text"  tabindex="1"
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ACVidaUtilFiscal#</cfoutput></cfif>"
					size="5" maxlength="5" style="text-align: right;"
					onblur="javascript:fm(this,0); "
					onfocus="javascript:this.value=qf(this); this.select();"
					onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>

        <tr>
			<td nowrap align="right">Importe Max:&nbsp;</td>
			<td nowrap>
           	<input type="text" name="ACimportemax" tabindex="1"
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ACImporteMaximo#</cfoutput></cfif>" size="10" maxlength="10" style="text-align: right;"
                    onBlur="javascript:fm(this,0); "
                    onFocus="javascript:this.value=qf(this); this.select();"
                    onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>

        <tr>
			<td nowrap align="right">Porcentaje Fiscal:&nbsp;</td>
			<td nowrap>
            	<input name="ACporfiscal" type="text" size="6" maxlength="6" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ACPorcentajeFiscal#</cfoutput></cfif>"
                	onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"
                    onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}} if(this.value > 100){ this.value = 100}"
                    alt="Porcentaje Fiscal"> %
			</td>
		</tr>

        <tr>
			<td nowrap align="right">Porcentaje Deduccion PTU:&nbsp;</td>
			<td nowrap>
            	<input name="ACpordeducPTU" type="text" size="6" maxlength="6" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.ACPorcentajePTU#</cfoutput></cfif>"
                	onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"
                    onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}} if(this.value > 100){ this.value = 100}"
                    alt="Porcentaje Deduccion PTU"> %
			</td>
		</tr>

		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<input 	type="checkbox" tabindex="1"
			          	name="ACdepreciable"
					   	value="<cfif modo NEQ "ALTA">#rsForm.ACdepreciable#</cfif>"
					   	<cfif modo NEQ "ALTA">
					   		<cfif #rsForm.ACdepreciable# EQ "S"> checked </cfif>
						</cfif>
					   	onclick="javascript:if(document.form1.ACdepreciable.value=='N') document.form1.ACdepreciable.value='S'; else document.form1.ACdepreciable.value='N';"
				>Depreciable
			</td>
		</tr>

		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<input 	type="checkbox"  tabindex="1"
			           	name="ACrevalua"
					   	value="<cfif modo NEQ "ALTA">#rsForm.ACrevalua#</cfif>"
				       	<cfif modo NEQ "ALTA">
							<cfif #rsForm.ACrevalua# EQ "S"> checked </cfif>
						</cfif>
				       onclick="javascript:if(document.form1.ACrevalua.value=='N') document.form1.ACrevalua.value='S'; else document.form1.ACrevalua.value='N';"
			    >Reval&uacute;a
			</td>
		</tr>
<!---Exigir vale en el proceso de conciliacion--->
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<input 	type="checkbox"  tabindex="1"
			           	name="ACexigeVale"
					   	value="<cfif modo NEQ "ALTA">#rsForm.ACexigeVale#</cfif>"
				       	<cfif modo NEQ "ALTA">
							<cfif #rsForm.ACexigeVale# EQ "S"> checked </cfif>
						</cfif>
				       onclick="javascript:if(document.form1.ACexigeVale.value=='N') document.form1.ACexigeVale.value='S'; else document.form1.ACexigeVale.value='N';"
			    >
				Exigir Doc de Responsabilidad en el proceso de conciliación
			</td>
		</tr>
<!---No permite mejoras o adiciones--->
		<cfquery name="rs3100" datasource="#session.dsn#">
			select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 3100
		</cfquery>
		<cfif rs3100.recordcount GT 0 and rs3100.Pvalor EQ 1>
			<tr>
				<td nowrap>&nbsp;</td>
				<td nowrap>
					<input type="checkbox" tabindex="1" name="ACNegarMej" value="1" <cfif modo NEQ "ALTA" and rsForm.ACNegarMej EQ 1>checked</cfif>>
					No permite mejoras o adiciones
				</td>
			</tr>
		</cfif>

		<tr>
			<td nowrap align="right">Tipo de Valor Residual:&nbsp;</td>
			<td nowrap>
				<select name="ACtipo" id="ACtipo" tabindex="1">
					<option value="M" <cfif modo NEQ "ALTA" and Compare(Trim(rsForm.ACtipo),"M") eq 0>selected</cfif>>Monto</option>
					<option value="P" <cfif modo NEQ "ALTA" and Compare(Trim(rsForm.ACtipo),"P") eq 0>selected</cfif>>Porcentaje</option>
			  </select>
			</td>
		</tr>

		<tr>
			<td nowrap align="right">Valor Residual:&nbsp;</td>
			<td nowrap>
				<cfif (modo neq "ALTA")>
					<cf_monto name="ACvalorres" value="#rsForm.ACvalorres#" tabindex="1">
				<cfelse>
					<cf_monto name="ACvalorres" tabindex="1">
				</cfif>
			</td>
		</tr>

        <!---SML Modificacion para agregar la mascara en la clasificacion de activos--->
        <cfif isdefined('rsGenPlacaAut') and rsGenPlacaAut.Pvalor NEQ 1>
		<tr valign="baseline">
			<td align="right" nowrap>M&aacute;scara:&nbsp;</td>
			<td>
				<input name="ACmascara" type="text" tabindex="1" value="<cfif modo NEQ "ALTA">#trim(rsForm.ACmascara)#</cfif>"
					size="20" maxlength="20" onFocus="this.select();" onKeyPress="javascript: return acceptX(event);">
			</td>
		</tr>
        <tr valign="baseline" id="trMsjMascara">
			<td align="right" nowrap>&nbsp;</td>
			<td>* Solo se permite agregar el valor X para la m&aacute;scara</td>
		</tr>
        <cfelse>
        <tr valign="baseline">
			<td align="right" nowrap>M&aacute;scara:&nbsp;</td>
			<td>
				<input name="ACmascara" type="text" tabindex="1" size="20" maxlength="20" value="<cfif modo NEQ "ALTA">#trim(rsForm.ACmascara)#</cfif>"/>
			</td>
		</tr>
        <tr valign="baseline" id="trMsjMascaraA">
			<td align="right" nowrap>&nbsp;</td>
			<td>* Solo se permite el comodin * para la m&aacute;scara</td>
		</tr>
        </cfif>

		<tr>
			<td nowrap colspan="2">
				<fieldset>
				<legend>Interf&aacute;z Contable (Cuenta de)</legend>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td nowrap align="right">Super&aacute;vit:&nbsp;</td>
							<td nowrap colspan="2" >
								<cfif modo NEQ 'ALTA' >
									<cfquery datasource="#session.DSN#" name="rsCuenta1">
										select Ccuenta, Cdescripcion, Cformato
										from AClasificacion a, CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACcsuperavit#" cfsqltype="cf_sql_numeric">
									</cfquery>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame0" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcsuperavit" cdescripcion="DACcsuperavit"
										cformato="FACcsuperavit" query="#rsCuenta1#" tabindex="1">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame0" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcsuperavit" cdescripcion="DACcsuperavit"
										cformato="FACcsuperavit" tabindex="1" size = "10">
								</cfif>
							</td>
						</tr>
						<tr>
							<td nowrap align="right">Adquisici&oacute;n:&nbsp;</td>
							<td nowrap colspan="2">
								<cfif modo NEQ 'ALTA' >
									<cfquery datasource="#session.DSN#" name="rsCuenta2">
										select Ccuenta, Cdescripcion, Cformato
										from CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACcadq#" cfsqltype="cf_sql_numeric">
									</cfquery>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcadq" cdescripcion="DACcadq" cformato="FACcadq"
										query="#rsCuenta2#" tabindex="2">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcadq" cdescripcion="DACcadq" cformato="FACcadq"
										 tabindex="2">
								</cfif>
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Depr. Acumulada:&nbsp;</td>
							<td nowrap colspan="2">
								<cfif modo NEQ 'ALTA' >
									<cfquery datasource="#session.DSN#" name="rsCuenta3">
										select Ccuenta, Cdescripcion, Cformato
										from CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACcdepacum#" cfsqltype="cf_sql_numeric">
									</cfquery>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcdepacum" cdescripcion="DACcdepacum"
										cformato="FACcdepacum" query="#rsCuenta3#" tabindex="3">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcdepacum" cdescripcion="DACcdepacum"
										cformato="FACcdepacum" tabindex="3">
								</cfif>
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Revaluaci&oacute;n:&nbsp;</td>
							<td nowrap colspan="2">
								<cfif modo NEQ 'ALTA' >
									<cfquery datasource="#session.DSN#" name="rsCuenta4">
										select Ccuenta, Cdescripcion, Cformato
										from CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACcrevaluacion#" cfsqltype="cf_sql_numeric">
									</cfquery>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame3" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcrevaluacion" cdescripcion="DACcrevaluacion"
										cformato="FACcrevaluacion" query="#rsCuenta4#" tabindex="4">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame3" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcrevaluacion" cdescripcion="DACcrevaluacion"
										cformato="FACcrevaluacion" tabindex="4">
								</cfif>
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Depr. Acum. Revaluaci&oacute;n:&nbsp;</td>
							<td nowrap colspan="2">
								<cfif modo NEQ 'ALTA' >
									<cfquery datasource="#session.DSN#" name="rsCuenta5">
										select Ccuenta, Cdescripcion, Cformato
										from CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACcdepacumrev#" cfsqltype="cf_sql_numeric">
									</cfquery>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame4" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcdepacumrev" cdescripcion="DACcdepacumrev"
										cformato="FACcdepacumrev" query="#rsCuenta5#" tabindex="5">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame4" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACcdepacumrev" cdescripcion="DACcdepacumrev"
										cformato="FACcdepacumrev" tabindex="5">
								</cfif>
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Gastos por depreciaci&oacute;n:&nbsp;</td>
							<td nowrap colspan="0">
							<cfif modo EQ "ALTA">
								<cf_cuentasanexo
								auxiliares="S"
								movimiento="N"
								conlis="S"
								ccuenta="Ccuenta"
								cdescripcion="Cdescripcion"
								cformato="Cformato"
								conexion="#Session.DSN#"
								form="form1"
								frame="frame5"
								comodin="?" tabindex="1">
							<cfelse>
								<cfquery dbtype="query" name="rsCuenta6">
									select ACcgastodepreciacion as Ccuenta, '' as Cdescripcion, ACfgastodepreciacion as Cformato
									from rsForm
								</cfquery>
								<cf_cuentasanexo
								auxiliares="S"
								movimientos="N"
								conlis="S"
								ccuenta="Ccuenta"
								cdescripcion="Cdescripcion"
								cformato="Cformato"
								conexion="#Session.DSN#"
								form="form1"
								frame="frame5"
								query="#rsCuenta6#"
								comodin="?" tabindex="1">
							</cfif>
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Comodato:&nbsp;</td>
							<td nowrap colspan="2">
								<cfif modo NEQ 'ALTA' and rsForm.ACccomodato neq ''>
									<cfquery datasource="#session.DSN#" name="rsCuenta6">
										select Ccuenta, Cdescripcion, Cformato
										from CContables b
										where b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
											and b.Ccuenta  = <cfqueryparam value="#rsForm.ACccomodato#" cfsqltype="cf_sql_numeric">
									</cfquery>

									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame4" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACccomodato" cdescripcion="DACccomodato"
										cformato="FACccomodato" query="#rsCuenta6#" tabindex="5">
								<cfelse>
									<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame4" auxiliares="N"
										movimiento="S" form="form1" ccuenta="ACccomodato" cdescripcion="DACccomodato"
										cformato="FACccomodato" tabindex="5">
								</cfif>
							</td>
						</tr>


						<tr>
							<td nowrap align="right">Compl. Depreciaci&oacute;n:&nbsp;</td>
							<td nowrap colspan="1">
								<input name="ACgastodep" type="text" tabindex="5" size="50" maxlength="100"
									value="<cfif modo NEQ "ALTA">#trim(rsForm.ACgastodep)#</cfif>" style="text-align:left"
									onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
									onblur="javascript:fm_2(this,0);"
									onfocus="javascript:this.select();"  >
							</td>
						</tr>

						<tr>
							<td nowrap align="right">Compl. Revaluaci&oacute;n:&nbsp;</td>
							<td nowrap colspan="2">
								<input name="ACgastorev" type="text" tabindex="5"
									value="<cfif modo NEQ "ALTA">#trim(rsForm.ACgastorev)#</cfif>"
									size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber_2(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onblur="javascript:fm_2(this,0);" onfocus="javascript:this.select();"  >
							</td>
						</tr>

						<tr>
						  	<td nowrap align="right">Compl. Inversi&oacute;n:&nbsp;</td>
						  	<td nowrap colspan="2">
								<input name="cuentac" type="text" value="<cfif modo NEQ "ALTA">#trim(rsForm.cuentac)#</cfif>" size="50" maxlength="100" onfocus="this.select();">
							</td>
						</tr>

						<tr>
						  	<td nowrap align="right">Compl. Gasto Retiro:&nbsp;</td>
						  	<td nowrap colspan="2">
								<input name="ACgastoret" type="text" size="50" maxlength="100" tabindex="5"
									value="<cfif modo NEQ "ALTA">#trim(rsForm.ACgastoret)#</cfif>" onfocus="this.select();">
							</td>
						</tr>

						<tr>
						  	<td nowrap align="right">Compl. Ingreso Retiro:&nbsp;</td>
						  	<td nowrap colspan="2">
								<input name="ACingresoret" type="text" size="50" maxlength="100" tabindex="5"
									value="<cfif modo NEQ "ALTA">#trim(rsForm.ACingresoret)#</cfif>" onfocus="this.select();">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>

		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfset include="">
				<cfif modo NEQ "ALTA">
					<cfset include="Excepciones,Porcentaje_Retiro">
				</cfif>

				<cfset include=include&iif(len(include),DE(','),DE(''))&"Regresar">
				<cf_botones modo="#modo#" include="#include#" tabindex="5">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ACid" value="<cfif modo NEQ "ALTA">#rsForm.ACid#</cfif>">
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
				<input type="hidden" name="Pagina2"
					value="
						<cfif isdefined("form.pagenum2") and form.pagenum2 NEQ "">
							#form.pagenum2#
						<cfelseif isdefined("url.PageNum_lista2") and url.PageNum_lista2 NEQ "">
							#url.PageNum_lista2#
						</cfif>">

				<input type="hidden" name="modo" value="">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="JavaScript1.2" type="text/javascript">
		function _Field_isRango(){
			var low = 0;
			var high = 99999999999999.99;
			var iValue = parseInt(qf(this.value));

			if (document.form1.ACtipo.value=="P"){
				high = 100.00;
			}

			if(isNaN(iValue)){
				iValue=0;
			}

			if((low>iValue)||(high<iValue)){
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}

		_addValidator("isRango", _Field_isRango);
		objForm.ACtipo.description = "#JSStringFormat('Tipo de Valor Residual')#";
		objForm.ACcadq.description = "#JSStringFormat('Cuenta de Adquisición')#";
		objForm.ACvutil.description = "#JSStringFormat('Vida Útil')#";
		objForm.ACvalorres.description = "#JSStringFormat('Valor Residual')#";
		objForm.ACcdepacum.description = "#JSStringFormat('Cuenta de Depreciación Acumulada')#";
		objForm.ACcsuperavit.description = "#JSStringFormat('Cuenta de Superavit')#";
		objForm.ACcodigodesc.description = "#JSStringFormat('Código')#";
		objForm.ACcdepacumrev.description = "#JSStringFormat('Cuenta de Depr. Acum. de Revaluación')#";
		objForm.ACdescripcion.description = "#JSStringFormat('Descripción')#";
		objForm.ACcrevaluacion.description = "#JSStringFormat('Cuenta de Revaluación')#";
		objForm.ACccomodato.description = "#JSStringFormat('Cuenta de Comodato')#";
		<!---objForm.ACcgastodepreciacion.description = "#JSStringFormat('Cuenta de de Gastos por Depreciación')#";--->
		objForm.ACvalorres.validateRango();

		function _finalizar(){
			var vufiscal = parseFloat(document.getElementById("ACvutilfiscal").value);
			var vu = parseFloat(document.getElementById("ACvutil").value);
			if (vufiscal>vu){
				alert("La vida Util Fiscal no debe ser mayor que la Vida Util del Activo");
				document.getElementById("ACvutilfiscal").value = '';
				return false;
			}
			else {
			objForm.ACvutil.obj.disabled = false;
			objForm.ACvalorres.obj.value = qf(objForm.ACvalorres.obj);
			return true;
			}
		}

		function habilitarValidacion(){
			objForm.ACtipo.required = true;
			objForm.ACcadq.required = true;
			objForm.ACvutil.required = true;
			objForm.ACvalorres.required = true;
			objForm.ACcdepacum.required = true;
			objForm.ACcsuperavit.required = true;
			objForm.ACcodigodesc.required = true;
			objForm.ACcdepacumrev.required = true;
			objForm.ACdescripcion.required = true;
			objForm.ACcrevaluacion.required = true;
			objForm.ACccomodato.required = true;
<!---			objForm.ACcgastodepreciacion.required = true;--->
		}

		function deshabilitarValidacion(){
			objForm.ACtipo.required = false;
			objForm.ACcadq.required = false;
			objForm.ACvutil.required = false;
			objForm.ACvalorres.required = false;
			objForm.ACcdepacum.required = false;
			objForm.ACcsuperavit.required = false;
			objForm.ACcodigodesc.required = false;
			objForm.ACcdepacumrev.required = false;
			objForm.ACdescripcion.required = false;
			objForm.ACcrevaluacion.required = false;
			objForm.ACcgastodepreciacion.required = false;
			objForm.ACfgastodepreciacion.required = false;
		}

		habilitarValidacion();

		function funcRegresar(){
			deshabilitarValidacion();
			location.href = 'ACategoria.cfm?ACcodigo=#form.ACcodigo#';
			return false;
		}
		<cfif modo NEQ "ALTA">
			function funcExcepciones(){
				location.href = 'ClasificacionCF.cfm?Padre_ACcodigo=#form.ACcodigo#&Padre_ACid=#form.ACid#';
				return false;
			}
			function funcPorcentaje_Retiro(){
				location.href = 'PorcentajeRetiroFiscal.cfm?Padre_ACcodigo=#form.ACcodigo#&Padre_ACid=#form.ACid#&VieneClas';
				return false;
			}
		</cfif>
		objForm.ACcodigodesc.obj.focus();

		function funcImportar(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/af/catalogos/importaClase.cfm'
	}

	</script>
</cfoutput>