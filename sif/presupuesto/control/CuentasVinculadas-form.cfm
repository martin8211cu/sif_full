<cfif isdefined("Form.CPCVid") and Len(Trim(Form.CPCVid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>
<cfif isdefined("Form.CPPid") and Len(Trim(Form.CPPid))>
	<cfset form.CPPid_Filtro = Form.CPPid>
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		Select cv.CPPid,CPCVid,CPformato,CPdescripcion,CPCVporcentaje,cv.ts_rversion
		from CPCtaVinculada cv
			inner join CPresupuestoPeriodo pp
				on cv.CPPid = pp.CPPid
					and cv.Ecodigo = pp.Ecodigo
		where cv.Ecodigo=#Session.Ecodigo#
			and CPCVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCVid#">
	</cfquery>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsPerPres" datasource="#Session.DSN#">
	Select 	CPPid,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as DescripcionPer	
	from CPresupuestoPeriodo
	where Ecodigo=#Session.Ecodigo#
		and CPPestado in (0,1)
</cfquery>

<cfif rsPerPres.recordcount EQ 0>
	<cf_errorCode	code = "50465" msg = "No existen Períodos de Presupuestos Abiertos o Inactivos">
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td valign="top" width="51%">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>		 		
			<form method="post" name="formFiltro" action="CuentasVinculadas.cfm">
				<cfif modo NEQ 'ALTA' and isdefined('form.CPCVid') and form.CPCVid NEQ ''>
					<input type="hidden" name="CPCVid" value="<cfoutput>#form.CPCVid#</cfoutput>">
				</cfif>
			  <tr class="areaFiltro">
				<td width="26%" nowrap align="right"><strong>Per&iacute;odo Presupuestario:</strong></td>
				<td width="54%">
					<cfif isdefined('form.CPPid_Filtro') and form.CPPid_Filtro NEQ ''>
						<cf_cboCPPid CPPestado="0,1" value="#form.CPPid_Filtro#" onChange="filtrar();" CPPid="CPPid_Filtro"></td>
					<cfelse>
						<cf_cboCPPid CPPestado="0,1" CPPid="CPPid_Filtro">
					</cfif>				
				</td>
			  </tr>
			  <tr class="areaFiltro">
			  	<td>&nbsp;</td>
			  	<td>
			  		<input type="submit" name="btnImportar" value="Importar"
					 onClick="this.form.action='';this.form.submit()">
				</td>
			  </tr>
			</form>			
			<script language="javascript" type="text/javascript">
				function filtrar(){
					<cfif modo NEQ 'ALTA' and isdefined('form.CPCVid') and form.CPCVid NEQ ''>
						document.formFiltro.CPCVid.value = '';
					</cfif>	
					document.formFiltro.submit();
				}
				<cfif not isdefined('form.CPPid_Filtro')>
					filtrar();
				</cfif>
			</script>			
		  <tr>
			<td colspan="2"><hr></td>
		  </tr>		  
		  <tr>
			<td colspan="2">
				<cfquery name="rsCuentasVin" datasource="#session.DSN#">
					Select 	CPCVid,
							CPformato,
							CPdescripcion,
							CPCVporcentaje,
							'%' as signo
							<cfif isdefined('form.CPPid_Filtro')>
								,#form.CPPid_Filtro# as CPPid_Filtro
							</cfif>
					from CPCtaVinculada cv
						inner join CPresupuestoPeriodo pp
							on cv.CPPid = pp.CPPid
								and cv.Ecodigo = pp.Ecodigo
					where cv.Ecodigo=#session.ecodigo#
						<cfif isdefined('form.CPPid_Filtro') and form.CPPid_Filtro NEQ ''>
							and cv.CPPid = <cfqueryparam value="#form.CPPid_Filtro#" cfsqltype="cf_sql_numeric">
						</cfif>
				</cfquery>
				
				<cfinvoke component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsCuentasVin#"/> 
					<cfinvokeargument name="desplegar" value="CPformato,CPdescripcion,CPCVporcentaje,signo"/>
					<cfinvokeargument name="etiquetas" value="Cuenta,Descripcion,Porcentaje,&nbsp;"/>
					<cfinvokeargument name="formatos" value="S,S,M,S"/> 
					<cfinvokeargument name="align" value="left,left,right,left"/> 
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="keys" value="CPCVid"/>
					<cfinvokeargument name="irA" value="CuentasVinculadas.cfm"/> 
					<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				</cfinvoke>
			</td>
		  </tr>
		</table>
	</td>
	<td valign="top" width="49%">
		<table width="200" border="0" align="center">
			<!--- ENCABEZADO con la Cuenta Vinculada --->
			<tr>
				<td>
					<cfoutput>
						<form method="post" name="form1" action="CuentasVinculadas-sql.cfm">
						  <cfif modo EQ "CAMBIO">
							<input type="hidden" name="CPCVid" value="#rsForm.CPCVid#">
						  </cfif>
						  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr>
								<td align="right" nowrap><strong>Per&iacute;odo Presupuestario:</strong></td>
								<td nowrap>
									 <cfif isdefined('form.CPPid_Filtro') and form.CPPid_Filtro NEQ ''>
										<input type="hidden" name="CPPid" value="#form.CPPid_Filtro#">										
									
										<cfquery dbtype="query" name="PerCambio">
											Select *
											from rsPerPres
											where CPPid = <cfqueryparam value="#form.CPPid_Filtro#" cfsqltype="cf_sql_numeric">
										</cfquery>
										<cfif isdefined('PerCambio') and PerCambio.recordCount GT 0>
											<cfoutput>#PerCambio.DescripcionPer#</cfoutput>
										<cfelse>
											- No se encontro el Periodo Presupuestario -
										</cfif>
									</cfif>
								</td>
							</tr>
							<tr>
								<td nowrap align="right"><strong>Formato Cta.Vinculada:</strong></td>
								<td>
									<cfset LvarCPformato = "">
									<cfif isdefined("rsForm.CPformato")>
										<cfset LvarCPformato = trim(rsForm.CPformato)>
									</cfif>
									<cfif modo EQ "CAMBIO">
										<input type="hidden" name="CPformato" value="#LvarCPformato#">
										<strong>#LvarCPformato#</strong>
									<cfelse>
										<cf_CuentaPresupuesto name="CPformato" CPdescripcion="CPdescripcion" size="30" value="#LvarCPformato#">
									</cfif>
								</td>
							</tr>
							<tr>
							  <td align="right"><strong>Descripci&oacute;n:</strong></td>
							  <td>
								<input 
									name="CPdescripcion" 
									type="text" 
									id="CPdescripcion" 
									size="60" 
									maxlength="60"
									value="<cfif modo EQ "CAMBIO" and len(trim(rsForm.CPdescripcion)) and rsForm.CPdescripcion neq 0 >#rsForm.CPdescripcion#</cfif>">
							  </td>
							</tr>
							<tr>
							  <td align="right"><strong>Porcentaje:</strong></td>
							  <td>
								<input type="text" name="CPCVporcentaje" id="CPCVporcentaje" style="text-align:right;"
								   size="22" maxlength="20" 
								   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								   onFocus="javascript:this.select();" 
								   onChange="javascript: fm(this,2);"
								   value="<cfif modo EQ "CAMBIO" and len(trim(rsForm.CPCVporcentaje)) and rsForm.CPCVporcentaje neq 0 >#rsForm.CPCVporcentaje#<cfelse>0.00</cfif>"
								   onBlur="fm(this,2);">%
							  </td>
							</tr>							
							<cfif modo EQ "CAMBIO">
								<tr>
								  <td colspan="2"><hr></td>
								</tr>
								<!--- DETALLE con cuentas Padre --->
								<tr>
								  <td colspan="2" align="center">
								  	<cfinclude template="CuentasVinculadas-Det.cfm">
								  </td>
								</tr>	
								<tr>
								  <td colspan="2">&nbsp;</td>
								</tr>															
							</cfif>
							<tr>
							  <td colspan="2" align="center" nowrap>
								<cfset ts = "">
								<cfif modo NEQ "ALTA">
								  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts">
								  </cfinvoke>
								  <input type="hidden" name="ts_rversion" value="#ts#">
								</cfif>
								
								<cfinclude template="/sif/portlets/pBotones.cfm">
							  </td>
							</tr>
						  </table>
						</form>
					</cfoutput>						  
				</td>
			</tr>
		</table>
	</td>
  </tr>
</table> 
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript">
	function __isPorcentaje() {
		if (this.value <= 0 || this.value > 100 )
			this.error = " El porcentaje debe estar en el rango 0.01-100.00"
	}
		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isPorcentaje", __isPorcentaje);
	
	objForm.CPPid.required = true;
	objForm.CPPid.description = "Periodo";
	objForm.CPformato.required = true;
	objForm.CPformato.description = "Formato";
	objForm.CPdescripcion.required = true;
	objForm.CPdescripcion.description = "Descripción";
	objForm.CPCVporcentaje.validatePorcentaje();
</script>


