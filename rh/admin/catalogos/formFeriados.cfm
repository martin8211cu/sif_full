<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHFid, RHFdescripcion, RHFfecha, RHFregional, ts_rversion, RHFpagooblig
		from RHFeriados
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
	</cfquery>

	<cfquery name="rsDForm" datasource="#session.DSN#">
		select a.Ocodigo, b.Odescripcion
		from RHDFeriados a, Oficinas b
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
		  and a.Ecodigo=b.Ecodigo
		  and a.Ocodigo=b.Ocodigo
		order by Odescripcion
	</cfquery>
</cfif>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq "ALTA" >
		and Ocodigo not in ( select Ocodigo	from RHDFeriados where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
															   and RHFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#"> )
	</cfif>														   
</cfquery>

<cfquery name="rsDias" datasource="#session.DSN#">
	select RHFfecha
	from RHFeriados
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and RHFid<><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
	</cfif>
</cfquery>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 1 from RHFeriados where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function regional(){
		var tr = document.getElementById("trOficinas");
		tr.style.display = ( document.form1.RHFregional.checked ) ? "" : "none";
	}
	
	function asignar(codigo){
		document.form1.LOcodigo.value = codigo;
	}
	
	function valida_oficina(desde){
		if ( ( document.form1.botonSel.value == "btnEliminar") ||  ( document.form1.botonSel.value == "btnModificar") || ( document.form1.botonSel.value == "btnNuevo") ){
				objForm.Ocodigo.required = false;		
		}
		else{
				objForm.Ocodigo.required = true;		
		}
	}
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function copiar(){
		popUpWindow("CopiarFeriados.cfm",250,200,550,200);
	}

</script>

<form name="form1" method="post" action="SQLFeriados.cfm" >
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		
		<tr> 
			<td align="right"><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate>:&nbsp;</td>
			<td>
				<cfif isdefined("rsForm") and rsForm.RecordCount NEQ 0>
					<cfset vRHFfecha = LSDateFormat(rsForm.RHFfecha,'dd/mm/yyyy')>
				<cfelse>
					<cfset vRHFfecha = ''>
				</cfif>
				<cfif modo neq "ALTA">
					<cf_sifcalendario  tabindex="1" form="form1" name="RHFfecha" value="#vRHFfecha#">
				<cfelse>
					<cf_sifcalendario form="form1" name="RHFfecha" value="" tabindex="1">
				</cfif>	
			</td>
		</tr>
		
		<tr> 
			<td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<input name="RHFdescripcion" type="text"  size="70" maxlength="80" tabindex="1"
					value="<cfif modo neq 'ALTA'>#rsForm.RHFdescripcion#</cfif>" onFocus="javascript:this.select();" >
			</td>
		</tr>		
		<tr>
			<td align="right">&nbsp;</td>
			<td>
				<table width="476">
					<tr>
						<td width="23" align="right">
							<input type="checkbox" name="RHFregional" tabindex="1" <cfif modo neq "ALTA" and rsForm.RHFregional eq 1>checked</cfif>><!--- onclick="javascript:regional();" ---></td>
						<td width="76"><cf_translate key="LB_Regional">Regional</cf_translate></td>
						<td width="29" align="right">
							<input type="checkbox" name="RHFpagooblig" <cfif modo neq "ALTA" and rsForm.RHFpagooblig eq 1>checked</cfif>>						
						</td>
						<td width="328">
							<cf_translate key="LB_PagoObligatorioAEmpleados">Pago obligatorio a empleados</cf_translate>
						</td>
					</tr>
			  </table>
			</td>	
		</tr>
		
		<cfif modo neq "ALTA">
			<tr id="trOficinas" style="display: none">
				<td colspan="2" align="center">
					<fieldset>
						<legend><cf_translate key="LB_Oficinas" XmlFile="/rh/generales.xml">Oficinas</cf_translate>&nbsp;</legend>	
						<table>
							<tr>
								<td><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate>:</td>
								<td>
									<select name="Ocodigo" tabindex="1">
										<option value="">--- <cf_translate key="CMB_SeleccioneUna" XmlFile="/rh/generales.xml">Seleccione Una</cf_translate> ---</option>
										<cfloop query="rsOficinas">
											<option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
										</cfloop>
									</select>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Agregar"
										Default="Agregar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Agregar"/>
									<input type="submit" name="btnAgregar" value="#BTN_Agregar#" tabindex="1"
										onClick="javascript:this.form.botonSel.value=this.name; valida_oficina(1);">
								</td>
							</tr>
							
							<tr>
								<td colspan="2" align="center">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr><td colspan="3" class="tituloListas"><cf_translate key="LB_Oficinas" XmlFile="/rh/generales.xml">Oficinas</cf_translate></td></tr>
										<cfloop query="rsDForm">
											<tr <cfif rsDForm.CurrentRow MOD 2> class="listaNon"<cfelse> class="listaPar"</cfif>>
												<td width="1%">
													<input  name="btnBorrar" type="image" alt="Eliminar Oficina" width="13" height="13" tabindex="-1"
														onClick="javascript: asignar(#rsDform.Ocodigo#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" >
												</td>													
												<td><a href="javascript:asignar(#rsDForm.Ocodigo#)">#rsDForm.Odescripcion#</a></td>
											</tr>
										</cfloop>
										<tr><td><input type="hidden" name="LOcodigo" value=""></td></tr>
									</table>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
		<cfelse>
			<tr id="trOficinas" style="display: none">
				<td align="right"><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate>:&nbsp;</td>
				<td>
					<select name="Ocodigo" tabindex="1">
						<option value="">--- <cf_translate key="LB_SeleccioneUna" XmlFile="/rh/generales.xml">Seleccione Una</cf_translate> ---</option>
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif not isdefined('modo')>
					<cfset modo = "ALTA">
				</cfif>
				<input type="hidden" name="botonSel" value="">
				<cfif modo EQ "ALTA">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
					<input type="submit" name="Alta" value="#BTN_Agregar#" tabindex="1"
						onClick="javascript: this.form.botonSel.value = this.name; objForm.Ocodigo.required = false; ">
					<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="1"
						onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Eliminar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DeseaEliminarElReg"
						Default="Desea Eliminar el Registro?"
						XmlFile="/rh/generales.xml"
						returnvariable="MSG_DeseaEliminarElReg"/>
				
					<input type="submit" name="Cambio" value="#BTN_Modificar#" tabindex="1"
						onClick="javascript: this.form.botonSel.value = this.name; objForm.Ocodigo.required = false; ">
					<input type="submit" name="Baja" value="#BTN_Eliminar#" tabindex="1" 
						onclick="javascript: this.form.botonSel.value = this.name; objForm.Ocodigo.required = false; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('#MSG_DeseaEliminarElReg#');">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" tabindex="1"
						onClick="javascript: this.form.botonSel.value = this.name; objForm.Ocodigo.required = false; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>
				<cfif rsDatos.RecordCount gt 0>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Copiar"
						Default="Copiar"
						returnvariable="BTN_Copiar"/>
					<input type="button" name="Copiar" value="#BTN_Copiar#" tabindex="1" onClick="javascript: copiar();" >
				</cfif>
			</td>
		</tr>
		
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		
		<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"></td></tr>
		
		<cfif modo neq "ALTA">
			<tr><td><input type="hidden" name="RHFid" value="#rsForm.RHFid#"></td></tr>	
		</cfif>
		
		<!--- filtros de la lista ini --->
		<cfif isdefined("btnFiltrar")>
			<input type="hidden" name="btnFiltrar" value="Filtrar">
		</cfif>
		<cfif isdefined("form.fRHFfecha") and len( trim(form.fRHFfecha) ) gt 0>
			<input type="hidden" name="fRHFfecha" value="#fRHFfecha#">
		<cfelse>
			<input type="hidden" name="fRHFfecha" value="01/01/#datepart('yyyy', Now())#">
		</cfif>	

		<!--- filtros de la lista fin --->

	</table>  
	</cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LaFechaSeleccionadaYaEstaDefinida"
						Default="La Fecha seleccionada ya esta definida."
						returnvariable="MSG_LaFechaSeleccionadaYaEstaDefinida"/>
<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Fecha"
						XmlFile="/rh/generales.xml"
						Default="Fecha"
						returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Descripcion"
						XmlFile="/rh/generales.xml"
						Default="Descripción"
						returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Oficina"
						XmlFile="/rh/generales.xml"
						Default="Oficina"
						returnvariable="MSG_Oficina"/>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function fecha_valida(){
		<cfoutput query="rsDias">
			if ( this.value == "#LSDateFormat(rsDias.RHFfecha,'dd/mm/yyyy')#" ){
				this.error = "#MSG_LaFechaSeleccionadaYaEstaDefinida#";
			}		
		</cfoutput>
	}
	_addValidator("isFecha", fecha_valida);
	<cfoutput>
	objForm.RHFfecha.required = true;
	objForm.RHFfecha.description="#MSG_Fecha#";
	objForm.RHFdescripcion.required = true;
	objForm.RHFdescripcion.description="#MSG_Descripcion#";
	</cfoutput>
	objForm.RHFfecha.validateFecha();

	<cfif modo neq 'ALTA' and rsForm.RHFregional eq 1>
		regional(document.form1.RHFregional);
	</cfif>
	objForm.Ocodigo.required = false;
	objForm.Ocodigo.description="#MSG_Oficina#";
	
	function deshabilitarValidacion(){
		objForm.RHFfecha.required = false;
		objForm.RHFdescripcion.required = false;
	}
	
</script>