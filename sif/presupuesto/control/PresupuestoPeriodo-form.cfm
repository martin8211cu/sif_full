<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<cfparam name="rsPeriodoPresupuesto.CPPestado" default="0">

<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsPeriodoPresupuesto" datasource="#Session.DSN#">
		select CPPid, Ecodigo, CPPtipoPeriodo, CPPfechaDesde, CPPfechaHasta, CPPfechaUltmodif, Mcodigo, CPPestado, 
				CPPcrearCtaCalculo, CPPcrearFrmCalculo, ts_rversion
		from CPresupuestoPeriodo
		where Ecodigo = #Session.Ecodigo#
		and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	</cfquery>
<cfelse>
	<cfquery name="rsNuevoPeriodo" datasource="#Session.DSN#">
		select max(CPPfechaHasta) as CPPfechaHasta
		from CPresupuestoPeriodo
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>
<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
	select Mcodigo
	  from Empresas 
	 where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select m.Mcodigo, m.Mnombre
	  from Monedas m
		inner join Empresas e
	 		on e.Ecodigo = m.Ecodigo
			and e.Mcodigo = m.Mcodigo
	where m.Ecodigo = #Session.Ecodigo#
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td valign="top" width="40%">
	  <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="LvarDesde">
	  <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="LvarHasta">
	  <cf_dbfunction name="OP_concat" returnvariable="_Cat">
	  <cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="CPresupuestoPeriodo a"/>
		  <cfinvokeargument name="columnas" value= "a.CPPid, 
		  										   	case a.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end as CPPtipoPeriodo, 
												   	a.CPPfechaDesde, a.CPPfechaHasta, 
												   		case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end 
														#_Cat# ' ' #_Cat# #LvarDesde# 
													as Desde,
														case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
														#_Cat# ' ' #_Cat# #LvarHasta#
													as Hasta,
													a.CPPfechaUltmodif, case a.CPPestado when 0 then 'Inactivo' when 1 then 'Abierto' when 2 then 'Cerrado' when 5 then 'Sin Presup' else '????' end as CPPestado"/>
		  <cfinvokeargument name="desplegar" value="CPPtipoPeriodo, Desde, Hasta, CPPestado"/>
		  <cfinvokeargument name="etiquetas" value="Tipo de Per&iacute;odo, Desde, Hasta, Estado"/>
		  <cfinvokeargument name="formatos" value="V, S, S, C"/>
		  <cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
		  										 order by a.CPPfechaDesde, a.CPPfechaHasta"/>
		  <cfinvokeargument name="align" value="left, left, left, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="CPPid"/>
		  <cfinvokeargument name="irA" value="PresupuestoPeriodo.cfm"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="PresupuestoPeriodo-sql.cfm"
				onsubmit="
					var LvarCboCalDefault = document.getElementById('cboCalculoDefault');
					if (!LvarCboCalDefault.disabled && LvarCboCalDefault.selectedIndex == 0)
					{
						alert ('Se requeriere indicar el tipo de Cálculo de Control para la generación dinámica');
						return false;
					}
					return true;
				"
		>
		  <cfif modo EQ "CAMBIO">
		  	<input type="hidden" name="CPPid" value="#Form.CPPid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td align="right" nowrap>Tipo de Per&iacute;odo:</td>
			  	<td>
					<select name="CPPtipoPeriodo" <cfif rsPeriodoPresupuesto.CPPestado NEQ 0>disabled</cfif>>
						<option value="12" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 12> selected</cfif>>Anual</option>
						<option value="6" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 6> selected</cfif>>Semestral</option>
						<option value="4" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 4> selected</cfif>>Cuatrimestral</option>
						<option value="3" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 3> selected</cfif>>Trimestral</option>
						<option value="2" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 2> selected</cfif>>Bimestral</option>
						<option value="1" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.CPPtipoPeriodo EQ 1> selected</cfif>>Mensual</option>
					</select>				</td>
		    </tr>
			<tr>
			  <td nowrap align="right">Desde:</td>
			  <td>
				<input name="CPPfechaDesde1" type="text" 
					<cfif rsPeriodoPresupuesto.CPPestado NEQ 0>disabled</cfif>
					onFocus="javascript:this.select();"
					size="4" maxlength="4"
					onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}};"					
					onBlur="if (this.value.length == 1) this.value = '200' + this.value; else if (this.value.length == 2) this.value = '20' + this.value; else if (this.value.length != 4) { alert('Año incorrecto'); this.value = new Date().getYear();}"
					<cfif modo EQ 'CAMBIO'>
						value="#DatePart('yyyy', rsPeriodoPresupuesto.CPPfechaDesde)#"
						<cfset LvarCboMES = DatePart('m', rsPeriodoPresupuesto.CPPfechaDesde)>
					<cfelse>
						<cfif rsNuevoPeriodo.CPPfechaHasta EQ "">
							value="#DatePart('yyyy', now())#"
							<cfset LvarCboMES = 1>
						<cfelseif DatePart('m', rsNuevoPeriodo.CPPfechaHasta) EQ "12">
							value="#DatePart('yyyy', rsNuevoPeriodo.CPPfechaHasta+1)#"
							<cfset LvarCboMES = 1>
						<cfelse>
							value="#DatePart('yyyy', rsNuevoPeriodo.CPPfechaHasta)#"
							<cfset LvarCboMES = DatePart('m', rsNuevoPeriodo.CPPfechaHasta) + 1>
						</cfif>
					</cfif>
				>
				
				<select name="CPPfechaDesde2" <cfif rsPeriodoPresupuesto.CPPestado NEQ 0>disabled</cfif>>
				  <cfloop index="i" from="1" to="#ListLen(meses, ',')#">
					  <option value="#i#" <cfif LvarCboMES EQ i> selected</cfif>>#ListGetAt(meses, i, ',')#</option>
				  </cfloop>
			    </select>			  </td>
			</tr>
			<tr>
			  <td align="right">Hasta:</td>
			  <td>
			  	<input type="text" name="CPPfechaHasta1" value="<cfif modo EQ 'CAMBIO'>#DatePart('yyyy', rsPeriodoPresupuesto.CPPfechaHasta)#</cfif>" size="4" maxlength="4" readonly>
			  	<input type="text" name="CPPfechaHasta2" value="<cfif modo EQ 'CAMBIO'>#ListGetAt(meses, DatePart('m', rsPeriodoPresupuesto.CPPfechaHasta), ',')#</cfif>" size="20" maxlength="20" readonly>			  </td>
			</tr>
			<tr>
              <td align="right" nowrap>Moneda:</td>
              <td>
			  	<select name="Mcodigo" <cfif rsPeriodoPresupuesto.CPPestado NEQ 0>disabled</cfif>>
				<cfloop query="rsMonedas">
                  <option value="#rsMonedas.Mcodigo#" <cfif modo EQ 'CAMBIO' and rsPeriodoPresupuesto.Mcodigo EQ rsMonedas.Mcodigo> selected</cfif>>#rsMonedas.Mnombre#</option>
				</cfloop> 
              	</select>			  </td>
		    </tr>
			<tr>
              <td align="right" nowrap="nowrap">Estado:</td>
			  <td><select name="CPPestado"
						<cfif rsPeriodoPresupuesto.CPPestado EQ 0 OR rsPeriodoPresupuesto.CPPestado EQ 5>
							onChange="LvarDisabled = (this.value != 0); document.form1.CPPfechaDesde1.disabled = LvarDisabled; document.form1.CPPfechaDesde2.disabled = LvarDisabled; document.form1.CPPtipoPeriodo.disabled = LvarDisabled; document.form1.Mcodigo.disabled = LvarDisabled;"
						</cfif>
			  		>
                  <cfif modo EQ "ALTA">
                    <option value="0" selected="selected">Inactivo</option>
                    <option value="5">Sin Presupuesto</option>
                    <cfelseif rsPeriodoPresupuesto.CPPestado EQ 0 OR rsPeriodoPresupuesto.CPPestado EQ 5>
                    <option value="0" <cfif rsPeriodoPresupuesto.CPPestado EQ 0>selected</cfif>>Inactivo</option>
                    <option value="5" <cfif rsPeriodoPresupuesto.CPPestado EQ 5>selected</cfif>>Sin Presupuesto</option>
                    <cfelse>
                    <option value="1" <cfif rsPeriodoPresupuesto.CPPestado EQ 1>selected</cfif>>Abierto</option>
                    <option value="2" <cfif rsPeriodoPresupuesto.CPPestado EQ 2>selected</cfif>>Cerrado</option>
                  </cfif>
              </select></td>
		    </tr>
			<tr>
				<td align="right" valign="top">
					Parámetros:
				</td>
				<cfif modo EQ "ALTA">
					<cfset rsPeriodoPresupuesto.CPPcrearCtaCalculo 	= "0">
					<cfset rsPeriodoPresupuesto.CPPcrearFrmCalculo	= "0">
				</cfif>
				<cfset LvarChkCrearCta = (rsPeriodoPresupuesto.CPPcrearCtaCalculo NEQ "0")>
				<cfset LvarChkCrearFrm = (rsPeriodoPresupuesto.CPPcrearFrmCalculo NEQ "0")>
				<td>
					<table>
						<tr>
							<TD>
								<input type="checkbox" name="chkCrearCta" id="chkCrearCta"
										<cfif LvarChkCrearCta>checked</cfif>
										onclick="
											var LvarCboCalDefault = document.getElementById('cboCalculoDefault');
											var LvarChkCrearFrm = document.getElementById('chkCrearFrm');
										 	if (this.checked) 
											{
												LvarCboCalDefault.disabled = false;
												LvarChkCrearFrm.checked = true;
												LvarChkCrearFrm.disabled = true;
											}
											else
											{
												LvarCboCalDefault.selectedIndex = 0;
												LvarCboCalDefault.disabled = true;
												LvarChkCrearFrm.checked = false;
												LvarChkCrearFrm.disabled = false;
											}
										"
								/>
							</TD>
							<TD>
							Generación dinámica de Cuentas de Presupuesto</TD>
						</tr>
						<tr>
							<TD>
								<input type="checkbox" name="chkCrearFrm" id="chkCrearFrm"
									<cfif LvarChkCrearCta>checked disabled
									<cfelseif LvarChkCrearFrm>checked</cfif>
										onclick="
											var LvarCboCalDefault = document.getElementById('cboCalculoDefault');
										 	if (this.checked) 
											{
												LvarCboCalDefault.disabled = false;
											}
											else
											{
												LvarCboCalDefault.selectedIndex = 0;
												LvarCboCalDefault.disabled = true;
											}
										"
								/>
							</TD>
							<TD>
							Generación dinámica de Formulación en Cero</TD>
						</tr>
						<tr>
							<TD>&nbsp;
								
							</TD>
							<TD>
								Defaults:<BR>
								Control Abierto, Calculo 
								<select name="cboCalculoDefault" id="cboCalculoDefault" 
										<cfif NOT (LvarChkCrearCta OR LvarChkCrearFrm)>disabled</cfif>
										onclick="
										 	if (this.selectedIndex == 0)
												this.selectedIndex = 1;
										"
								>
									<option value="0">N/A</option>
									<option value="1" <cfif rsPeriodoPresupuesto.CPPcrearCtaCalculo EQ "1" OR rsPeriodoPresupuesto.CPPcrearFrmCalculo EQ "1">selected</cfif>>Mensual</option>
									<option value="2" <cfif rsPeriodoPresupuesto.CPPcrearCtaCalculo EQ "2" OR rsPeriodoPresupuesto.CPPcrearFrmCalculo EQ "2">selected</cfif>>Acumulado</option>
									<option value="3" <cfif rsPeriodoPresupuesto.CPPcrearCtaCalculo EQ "3" OR rsPeriodoPresupuesto.CPPcrearFrmCalculo EQ "3">selected</cfif>>Total</option>
								</select>
							</TD>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsPeriodoPresupuesto.ts_rversion#" returnvariable="ts">				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
				<cfif rsPeriodoPresupuesto.CPPestado NEQ "0">
					<cf_botones MODO="#MODO#" exclude="Baja">
				<cfelse>
					<cf_botones MODO="#MODO#">
				</cfif>			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CPPtipoPeriodo.required = true;
	objForm.CPPtipoPeriodo.description = "Tipo de Período";
	objForm.CPPfechaDesde1.required = true;
	objForm.CPPfechaDesde1.description = "Año Desde";
	objForm.CPPfechaDesde2.required = true;
	objForm.CPPfechaDesde2.description = "Mes Desde";
	/*
	objForm.CPPfechaHasta1.required = true;
	objForm.CPPfechaHasta1.description = "Año Hasta";
	objForm.CPPfechaHasta2.required = true;
	objForm.CPPfechaHasta2.description = "Mes Hasta";
	*/
	
</script>
