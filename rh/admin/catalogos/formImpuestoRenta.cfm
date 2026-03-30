<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonCambiar"
	Default="Modificar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonCambiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonBorrar"
	Default="Eliminar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonNuevo"
	Default="Nuevo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonNuevo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonAgregar"
	Default="Agregar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonAgregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Regresar"
	Default="Regresar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="Regresar"/>		



<cfif isdefined("url.IRcodigo") and len(trim(url.IRcodigo))>
	<cfset form.IRcodigo = url.IRcodigo>
</cfif>
<!--- Asigna modos Concepto Deduc y Detalle Cconcepto Dedudccion (ConceptoDeduc/DConceptoDeduc)--->
<cfif isDefined("Form.CDid") and len(trim(Form.CDid)) gt 0>
	<cfset emodo = "CAMBIO">
</cfif>
<cfif isDefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0>	
	<cfset dmodo = "ALTA">
</cfif>
<cfif not isdefined("Form.emodo")>
	<cfset emodo='ALTA'>
<cfelseif Form.emodo EQ "CAMBIO">
	<cfset emodo="CAMBIO">
<cfelse>
	<cfset emodo='ALTA'>
</cfif>
<cfif not isdefined("Form.dmodo")>
	<cfset dmodo='ALTA'>
<cfelseif Form.dmodo EQ "CAMBIO">
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfset dmodo='ALTA'>
</cfif>

<!--- Asigna valor a frame cuando no llega definido--->
<cfif not isDefined("Form.frame") or not (Form.frame eq "IR" or Form.frame eq "CD" or Form.frame eq "SM")>
	<cfset frame = "IR">
</cfif>

<!--- Asigna modo IR --->
<cfif not isdefined("Form.modo")>
	<cfset modo='ALTA'>
<cfelseif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo='ALTA'>
</cfif>
<cfif isDefined("Form.IRcodigo") and len(trim(Form.IRcodigo)) gt 0>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Impuesto de Renta --->
<cfif frame EQ "IR">
	<!--- Asigna modos EIR y DIR --->
	<cfif isDefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0>
		<cfset emodo = "CAMBIO">
	</cfif>
	<cfif isDefined("Form.DIRid") and len(trim(Form.DIRid)) gt 0>
		<cfset dmodo = "CAMBIO">
	</cfif>
	<cfif not isdefined("Form.emodo")>
		<cfset emodo='ALTA'>
	<cfelseif Form.emodo EQ "CAMBIO">
		<cfset emodo="CAMBIO">
	<cfelse>
		<cfset emodo='ALTA'>
	</cfif>
</cfif>

<!--- Conceptos de Deducciones --->
<cfif frame EQ "CD">
	<!--- Asigna modos Concepto Deduc y Detalle Cconcepto Dedudccion (ConceptoDeduc/DConceptoDeduc)--->
	<cfif isDefined("Form.CDid") and len(trim(Form.CDid)) gt 0>
		<cfset emodo = "CAMBIO">
	</cfif>
</cfif>

	<!--- Consultas EIR y DIR --->
	<cfif emodo eq "CAMBIO" and modo EQ "CAMBIO">
		<cfquery name="rsEIR" datasource="sifcontrol">
			select EIRid, IRcodigo, EIRdesde, EIRhasta, EIRestado, ts_rversion 
			from EImpuestoRenta
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
	</cfif>


<!--- Consultas IR --->
<cfquery name="rsIRCodigos" datasource="sifcontrol">
	select IRcodigo
	from ImpuestoRenta
</cfquery>
<cfif modo eq "CAMBIO">
	<cfquery name="rsIR" datasource="sifcontrol">
		select 
			IRcodigo,
			IRdescripcion,
			IRcodigoPadre,
			IRfactormeses,
			IRCreditoAntes,
			IRTipoPeriodo,
			ts_rversion 
		from ImpuestoRenta
		where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
	</cfquery>
</cfif>


<cfif modo eq "CAMBIO">
	<cfquery name="rsEIRlista" datasource="sifcontrol">
		select EIRid, EIRdesde, EIRhasta, EIRestado, case EIRestado when 0 then 'Captura' when 1 then 'Listo' end as EIRestadodesc
		from EImpuestoRenta
		where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		order by EIRdesde
	</cfquery>
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsCDlista" datasource="sifcontrol">
		select CDid, IRcodigo, CDcodigo, CDdescripcion, ts_rversion 
		from ConceptoDeduc
		where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		order by CDcodigo
	</cfquery>
</cfif>

<cfif modo eq "CAMBIO">
	<cfset LIRcodigoPadre = Form.IRcodigo>
	<cfset LIRpath = "'#Form.IRcodigo#'">
	<cfset bpath = "">
	<cfloop condition="1 eq 1">
		<cfquery name="rsL11" datasource="sifcontrol">
			select IRcodigo
			from ImpuestoRenta
			where IRcodigoPadre = <cfqueryparam cfsqltype="cf_sql_char" value="#LIRcodigoPadre#">
		</cfquery>
		<cfif rsL11.recordcount and len(trim(rsL11.IRcodigo))>
			<cfset LIRcodigoPadre = rsL11.IRcodigo>
			<cfset LIRpath = LIRpath & ",'" & rsL11.IRcodigo & "'">
			<cfset bpath = bpath & ',' & rsL11.IRcodigo>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfquery name="rsListaPadres" datasource="sifcontrol">
		select IRcodigo, IRdescripcion
		from ImpuestoRenta a
		where not exists( 
			select IRcodigoPadre
			from ImpuestoRenta b
			where a.IRcodigo = b.IRcodigoPadre
		)
		and IRcodigo not in (#PreserveSingleQuotes(LIRpath)#)
		union
		select IRcodigo, IRdescripcion
		from ImpuestoRenta a
		where IRcodigo = ( 
			select IRcodigoPadre
			from ImpuestoRenta b
			where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		)
	</cfquery>
</cfif>

<!--- Javascript --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js"></script>

<!--- Estilos --->
<cf_templatecss>

<form action="SQLImpuestoRenta.cfm" method="post" name="form"  onSubmit="javascript: validar();" >
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<!--- IR --->
		<cfoutput>
		  <tr>
			<td nowrap class="filelabel">&nbsp;C&oacute;digo :</td>	
			<td nowrap>
				<cfif modo neq 'ALTA'>
					<input type="text" name="IRcodigo" tabindex="1" size="10" maxlength="5" value="#rsIR.IRcodigo#" readonly disabled>&nbsp;
				<cfelse>
					<input type="text" name="IRcodigo" tabindex="1" size="10" maxlength="5">&nbsp;
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td nowrap class="filelabel">&nbsp;Descripci&oacute;n :</td>
			<td nowrap>
				<cfif modo neq 'ALTA'>
					<input type="text" name="IRdescripcion" tabindex="1" size="40" maxlength="80" value="#rsIR.IRdescripcion#">&nbsp;
				<cfelse>
					<input type="text" name="IRdescripcion" tabindex="1" size="40" maxlength="80">&nbsp;
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td nowrap class="filelabel">&nbsp;Factor de Meses :</td>
			<td nowrap>
				<cfif modo neq 'ALTA'>
					<cf_inputNumber enteros="2" decimales="0" name="IRfactormeses" value="#rsIR.IRfactormeses#" tabIndex ="1">
				<cfelse>
					<cf_inputNumber enteros="2" decimales="0" name="IRfactormeses" value="1" tabIndex="1">
				</cfif>
			</td>
		  </tr>
		  <cfif modo neq 'ALTA'>
		  <tr>
				<td nowrap class="filelabel">
					&nbsp;Tabla Padre Relacionada:
				</td>
				<td>
					<select name="IRcodigoPadre">
						<option value="">-- No Aplica --</option>
						<cfloop query="rsListaPadres">
							<option value="#IRcodigo#" <cfif rsIR.IRcodigoPadre EQ rsListaPadres.IRcodigo>selected</cfif>>#IRcodigo#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>
		<!--- OPARRALES 2019-04-23 Modificacion para el tipo de periodo en el que aplicara la tabla de ISR --->
		<tr>
			<td nowrap class="filelabel">
				&nbsp;Tipo Periodo:
			</td>
			<td>
				<select name="IRTipoPeriodo">
					<option value="0" selected>-- Seleccione una opción --</option>
					<option value="1" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 1>selected</cfif>>Diaria</option>
					<option value="2" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 2>selected</cfif>>Semanal</option>
					<option value="3" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 3>selected</cfif>>Decenal</option>
					<option value="4" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 4>selected</cfif>>Quincenal</option>
					<option value="5" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 5>selected</cfif>>Mensual</option>
					<option value="6" <cfif modo eq "CAMBIO" and rsIR.IRTipoPeriodo eq 6>selected</cfif>>Anual</option>
				</select>
			</td>
		</tr>
		  <tr>
			<td nowrap align="right">
				<input type="checkbox" name="IRCreditoAntes" id="IRCreditoAntes" <cfif modo neq 'ALTA' and rsIR.IRCreditoAntes EQ 1>checked</cfif>>
			</td>
			<td nowrap class="filelabel">&nbsp;Aplicar cr&eacute;ditos fiscales antes de renta</td>
		  </tr>
		</table>
	</td>
	<cfif modo neq 'ALTA'>
    <td valign="top">
		<cfinclude template="ImpuestoRenta-frameJerarquia.cfm">
	</td>
	</cfif>
  </tr>
</table>
<br>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  <td colspan="3" align="center">&nbsp;
	<cfif modo neq 'ALTA'>
		<input type="submit"  alt="1" name='Cambio' 	value="#BotonCambiar#" onClick="javascript: return setBtn(this);" tabindex="1">
		<input type="submit" alt="2" name='Baja' 	value="#BotonBorrar#" onClick="javascript: return setBtn(this);" tabindex="1">
		<input type="submit" alt="3" name="Nuevo" value="#BotonNuevo#" onClick="javascript: return setBtn(this);" tabindex="1" >
	<cfelse>
		<input type="submit" alt="0" name='Alta' 	value="#BotonAgregar#" tabindex="1">
	</cfif>
	<input type="button" alt="4" name="btnRegresar" value="#Regresar#" onClick="javascript: regresa();" tabindex="1">
  </td>
  </tr>
  <cfif modo neq 'ALTA'>
	<cfset ts = "">
	<cfinvoke
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts"
		arTimeStamp="#rsIR.ts_rversion#"/>
	<input type="hidden" name="IRtimestamp" value="<cfoutput>#ts#</cfoutput>">
  </cfif>		
  </cfoutput>
  
<!--- Tabs --->
<cfif modo neq 'ALTA'>
	<tr><td nowrap colspan="3">&nbsp;</td></tr>
	
	<tr>
		<td nowrap colspan="3">

			<!--- Tablas de Impuesto de Renta --->
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Encabezado Tablas de Impuesto'>	
			
			<table border="0" width="100%" align="center">
			  <cfoutput>
							  
			  <tr>
				<td nowrap class="filelabel">&nbsp;Fecha Desde :</td>	
				<td nowrap class="filelabel">&nbsp;<cfif emodo NEQ 'ALTA'>Fecha Hasta :</cfif></td>
				<td nowrap class="filelabel">&nbsp;</td>
			  </tr>
			  
			  <tr>
				<td nowrap>
					<cfif emodo neq 'ALTA'>
						<cfif rsEIR.EIRestado neq 1>
							&nbsp;<cf_sifcalendario name="EIRdesde" form="form" value="#LSDateFormat(rsEIR.EIRdesde,'dd/mm/yyyy')#" tabindex="2" >&nbsp;
						<cfelse>
							&nbsp;#DateFormat(rsEIR.EIRdesde,'dd/mm/yyyy')#
						</cfif>
					<cfelse>
						&nbsp;<cf_sifcalendario name="EIRdesde" form="form" tabindex="2" >&nbsp;
					</cfif>
				</td>
				<td nowrap>
					<cfif emodo neq 'ALTA'>
						<cfif rsEIR.EIRestado neq 1>
							&nbsp;<cf_sifcalendario name="EIRhasta" form="form" value="#LSDateFormat(rsEIR.EIRhasta,'dd/mm/yyyy')#" tabindex="2" >&nbsp;								
						<cfelse>
							&nbsp;#DateFormat(rsEIR.EIRhasta,'dd/mm/yyyy')#
						</cfif>
					<cfelse>
						<input type="hidden" name="EIRhasta" value="01/01/6100">
					</cfif>
				</td>
				<td nowrap>
					<cfif emodo neq 'ALTA'>
						<cfif rsEIR.EIRestado neq 1>&nbsp;<input type="submit" alt="5" name='ECambio' 	value="#BotonCambiar#" onClick="javascript: return setBtn(this);" tabindex="2"></cfif>
						<input type="submit" alt="7" name="ENuevo" value="#BotonNuevo#" onClick="javascript: return setBtn(this);" tabindex="2">
					<cfelse>
						&nbsp;<input type="submit" alt="4" name='EAlta' 	value="#BotonAgregar#" onClick="javascript: return setBtn(this);" tabindex="2">
					</cfif>		
				</td>
				<cfif emodo neq 'ALTA'>
					<input type="hidden" name="EIRid" value="#rsEIR.EIRid#">
				<cfelse>
					<input type="hidden" name="EIRid" value="">
				</cfif>
				
				<cfif emodo neq 'ALTA'>
					<cfset ts = "">
					<cfinvoke
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsEIR.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="EIRtimestamp" value="<cfoutput>#ts#</cfoutput>">
				</cfif>
			  </tr>
			  
			  </cfoutput>
	
			  <tr><td nowrap colspan="3">&nbsp;</td></tr>
			  <tr><td nowrap colspan="3">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
				
					<tr bgcolor="FAFAFA"> 
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;<b>Fecha Desde</b></td>
						<td nowrap>&nbsp;<b>Fecha Hasta</b></td>
						<td nowrap>&nbsp;<b>Estado</b></td>
						<td nowrap>&nbsp;</td>
					</tr>
				
					<cfoutput query="rsEIRlista"> 
					<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
					  <td nowrap> 
						<cfif emodo neq "ALTA" and EIRid eq rsEIR.EIRid>
						  <input name="btnEMArcar#EIRid#" type="image" alt="Elemento en edición" 
					onClick="javascript: return false;" src="/cfmx/rh/imagenes/edita.gif" width="16" height="16">
						  <cfelse>
						  &nbsp; </cfif> </td>
					  <td nowrap><a href="javascript: Modificar(#EIRid#);">&nbsp;#DateFormat(EIRdesde,'dd/mm/yyyy')#</a></td>
					  <td nowrap><a href="javascript: Modificar(#EIRid#);">&nbsp;
						<cfif DateFormat(EIRhasta,'dd/mm/yyyy') EQ "01/01/6100">
							<b>INDEFINIDO</b>
						<cfelse>
							#DateFormat(EIRhasta,'dd/mm/yyyy')#
						</cfif>					  
					  	</a></td>
					  <td nowrap><a href="javascript: Modificar(#EIRid#);">&nbsp;#EIRestadodesc#</a></td>
					  <td nowrap>
                      	<cfif EIRestado eq 0>
                            <input  name="btnEBorrar#EIRid#" type="image" alt="Eliminar elemento" onClick="javascript: return Eliminar(#EIRid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
                            <input name="btnEEditar#EIRid#" type="image" alt="Editar elemento" 	onClick="javascript: return Modificar(#EIRid#);" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">
                        </cfif>	
					  </td>
					</tr>					
					</cfoutput> 						
				</table>
				
				</td>
			</tr>			
			<tr><td nowrap colspan="3">&nbsp;</td></tr>			
			</table>			
			<cf_web_portlet_end>
							
		</td>
	</tr>	
	<tr><td nowrap colspan="3">&nbsp;</td>
	
	<cfif emodo EQ "CAMBIO">
		
		<!--- Títulos del Tab --->		
		<tr>
		  <td nowrap colspan="3">  
		  <cfoutput>
			<table border="0" cellspacing="0" cellpadding="5" width="100%">
			<tr>
			  <td class="<cfif frame eq 'IR'>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<a href="javascript:Conceptos('1');" tabindex="-1">						
					Historial de Rangos de Impuestos
				</a>
			  </td>
			  <td class="<cfif frame eq 'CD'>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<a href="javascript:Conceptos('2')" tabindex="-1">						
					Conceptos de Deducciones
				</a>
			  </td>
			  <!--- Este es nuevo no borrar
			  <td class="<cfif frame eq 'SM'>tabSelected<cfelse>tabNormal</cfif>" nowrap>
				<a href="javascript:Conceptos('3')" tabindex="-1">						
					Salarios M&iacute;nimos
				</a>
			  </td>
			  --->	  
			  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
			</tr>
			</table>    
			</cfoutput> 
		  </td>
		</tr>
		
		<!--- Forms --->
		<tr>
			<td nowrap colspan="3">
				<cfif frame eq 'IR'>
					<cfinclude template="frame-ImpuestoRenta.cfm">
				<cfelseif frame eq 'CD'>
					<cfinclude template="frame-ConceptoDeduc.cfm">
				<cfelseif frame eq 'SM'>
					<!--- Saldof Mínimos --->
				</cfif>
			</td>
		</tr>
	</cfif>
</cfif>

<tr><td nowrap colspan="3">&nbsp;</td></tr>
</table>

  <input type="hidden" name="Accion" value='ALTA'>
  <input type="hidden" name="frame" value='<cfoutput>#frame#</cfoutput>'>
</form>
<cfif modo neq 'ALTA'>
<form action="ImpuestoRenta.cfm" method="post" name="formDeduc">
  <input type="hidden" name="IRcodigo" value="<cfoutput>#rsIR.IRcodigo#</cfoutput>">
  <input type="hidden" name="EIRid" value="<cfif isDefined("Form.EIRid")><cfoutput>#Form.EIRid#</cfoutput></cfif>">   
  <input type="hidden" name="emodo" value="CAMBIO">  
  <input type="hidden" name="modo" value="CAMBIO">  
  <input type="hidden" name="frame" value="">
</form>
</cfif>

<script language="javascript1.2" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");	
	//Inicializaciones de la página
	function initPage(f){
		
	}
	//Inicializa algunos detalles de la pantalla	
	initPage(document.form);

	function validar(){
		document.form.IRcodigo.disabled = false;
		return true;
	}
	
	function regresa() {
		location.href = '/cfmx/sif/index.cfm';		
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	// Impuesto de Renta /////////////////////////////////////////////////////////////////////////////////////////////////	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	<cfif frame eq 'IR'>	
		function setBtn(objBoton) {
			var result = true;
			switch (objBoton.alt) {
			case '0' :
				document.form.Accion.value='Alta';
				<cfif modo neq 'ALTA'>
					fnNoValidarE();
				</cfif>
				break;
			case '1' :
				document.form.Accion.value='Cambio';
				<cfif modo neq 'ALTA'>
					fnNoValidarE();
				</cfif>
				break;
			case '2' :
				if (confirm('¿Desea Eliminar el Registro completo del Impuesto sobre la Renta y todos sus Detalles?'))
					document.form.Accion.value='Baja';
				else
					result = false;
				break;
			case '3' :
				document.form.Accion.value='Nuevo';
				break;
			<cfif modo neq 'ALTA'>
			case '4' :
				document.form.Accion.value='EAlta';
				<cfif emodo neq 'ALTA'>
					fnNoValidarD();
				</cfif>

				break;
			case '5' :
				document.form.Accion.value='ECambio';
				<cfif emodo neq 'ALTA'>
					fnNoValidarD();
				</cfif>
				break;
			case '6' :
				if (confirm('¿Desea Eliminar el Rango del Historico del Impuesto sobre la Renta y todos sus Detalles?'))
					document.form.Accion.value='EBaja';
				else
					result = false;
				break;		
			case '7' :
				document.form.Accion.value='ENuevo';
				break;
			</cfif>
			<cfif emodo neq 'ALTA'>
			case '8' :				
				if (objForm.DIRsup.isRango('<cfoutput>#rsMinimo.minimo#</cfoutput>','999999999'))
					if (objForm.DIRmontofijo.isRango('0',qf(document.form.DIRsup))) {
						document.form.Accion.value='DAlta';
						// quita las comas
						document.form.DIRsup.value = qf(document.form.DIRsup.value);
						document.form.DIRporcentaje.value = qf(document.form.DIRporcentaje);
						document.form.DIRmontofijo.value = qf(document.form.DIRmontofijo);
						
						document.form.DIRporcexc.value = qf(document.form.DIRporcexc);
						document.form.DIRmontoexc.value = qf(document.form.DIRmontoexc);
						
					}
					else {
						alert(objForm.DIRmontofijo.error);
						result = false;
					}
				else {
					alert(objForm.DIRsup.error);
					result = false;
				}
				break;
			case '9' :
				if (objForm.DIRsup.isRango('<cfoutput>#rsMinimo.minimo#</cfoutput>','999999999'))
					if (objForm.DIRmontofijo.isRango('0',qf(document.form.DIRsup)))
						document.form.Accion.value='DCambio';
					else {
						alert(objForm.DIRmontofijo.error);
						result = false;
					}
				else {
					alert(objForm.DIRsup.error);
					result = false;
				}
				break;
			case '10' :
				if (confirm('¿Desea Eliminar el Rango Impuestos?')) {
					document.form.Accion.value='DBaja';
				}
				else
					result = false;
				break;		
			case '11' :
				document.form.Accion.value='DNuevo';
				break;
			case '12' :	
				if (confirm('¿Desea Aplicar el Rango del Historico del\nImpuesto sobre la Renta?. Una vez aplicado\nno podra modificarlo.')) {
					document.form.Accion.value='EAplicar';
				}
				else
					result = false;
				break;
			</cfif>
			}
			//Para que no valide en Baja ni Baja Detalle
			if (document.form.Accion.value=='Baja' || document.form.Accion.value=='EBaja' || 
				document.form.Accion.value=='DBaja' || document.form.Accion.value=='EAplicar' ||
				document.form.Accion.value=='Nuevo' || document.form.Accion.value=='ENuevo' || 
				document.form.Accion.value=='DNuevo')
				fnNoValidar();
			//Resultado de la función
			
			return result;
		}
		function Eliminar(id) {
			if (confirm('¿Desea Eliminar el Rango del Historico del Impuesto sobre la Renta y todos sus Detalles?')) {
				document.form.EIRid.value = id;
				document.form.Accion.value='EBaja';
				fnNoValidar();
				document.form.submit();
				return true;
			}
			return false;
		}
		function Modificar(id) {
			document.form.EIRid.value = id;
			document.form.Accion.value = 'EModificar';
			fnNoValidar();
			fnfinalizar(document.form);
			document.form.submit();
		}
		function fnNoValidar() {
			objForm.IRcodigo.required = false;
			objForm.IRdescripcion.required = false;
			objForm.IRfactormeses.required = false;
			<cfif not isDefined("rsEIR") or rsEIR.EIRestado neq 1>
				<cfif modo neq 'ALTA'>
				fnNoValidarE();
				</cfif>
				<cfif emodo neq 'ALTA'>
				fnNoValidarD();
				</cfif>
			</cfif>
		}
		function fnNoValidarE() {
			objForm.EIRdesde.required = false;
			objForm.EIRhasta.required = false;
		}
		function fnNoValidarD() {
			objForm.DIRsup.required = false;
			objForm.DIRporcentaje.required = false;
			objForm.DIRmontofijo.required = false;
			objForm.DIRporcexc.required = false;
			objForm.DIRmontoexc.required = false;
		}
		function fnfinalizar(f) {
			f.IRcodigo.disabled = false;
			f.IRcodigo.readonly = false;
			<cfif (not isDefined("rsEIR") or rsEIR.EIRestado neq 1) and emodo neq 'ALTA'>
			f.DIRsup.value = qf(f.DIRsup);
			f.DIRporcentaje.value = qf(f.DIRporcentaje);
			f.DIRmontofijo.value = qf(f.DIRmontofijo);
			
			f.DIRporcexc.value = qf(f.DIRporcexc);
			f.DIRmontoexc.value = qf(f.DIRmontoexc);
			
			
			</cfif>
		}
		//Funciones adicionales de validación
		function _Field_isAlfaNumerico()
		{
			var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
			var tmp="";
			var string = this.value;
			var lc=string.toLowerCase();
			for(var i=0;i<string.length;i++) {
				if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
			}
			if (tmp.length!=this.value.length)
			{
				this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
			}
		}
		function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
		var high=_param(arguments[1], 9999999, "number");
		var iValue=parseInt(qf(this.value));
		if(isNaN(iValue))iValue=0;
		if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}}
		function _Field_isExiste(){
			var existe = new Boolean;
			existe = false;
			<cfoutput query="rsIRCodigos">
				if ('#IRcodigo#'==this.value)
					existe = true;
			</cfoutput>
			if (existe){this.error="El campo "+this.description+" contiene un valor que ya existe, debe digitar uno diferente.";}
		}
				
		_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
		_addValidator("isRango", _Field_isRango);
		_addValidator("isExiste", _Field_isExiste);
		//Validaciones
		//Código solo se valida en Alta porque después no se puede modificar.
		<cfif modo eq 'ALTA'>
			objForm.IRcodigo.description = "Código";
			objForm.IRcodigo.validateAlfaNumerico();
			objForm.IRcodigo.validateExiste();
			objForm.IRcodigo.validate = true;
			objForm.IRcodigo.required = true;
		</cfif>
		objForm.IRdescripcion.description = "Descripción";
		objForm.IRdescripcion.validateAlfaNumerico();
		objForm.IRdescripcion.validate = true;
		objForm.IRdescripcion.required = true;
		objForm.IRfactormeses.description = "Factor de Meses";
		objForm.IRfactormeses.validate = true;
		objForm.IRfactormeses.required = true;
		objForm.IRfactormeses.validateRango('1','12');
		<cfif not isDefined("rsEIR") or rsEIR.EIRestado neq 1>
			<cfif modo neq 'ALTA'>
				objForm.EIRdesde.required = true;
				objForm.EIRdesde.description = "Fecha desde";
				objForm.EIRhasta.required = true;
				objForm.EIRhasta.description = "Fecha hasta";
				<cfif emodo neq 'ALTA'>	
					objForm.DIRsup.required = true;
					objForm.DIRsup.description = "Monto hasta";
					objForm.DIRporcentaje.required = true;
					objForm.DIRporcentaje.validateRango('0','100');
					objForm.DIRporcentaje.validate = true;
					objForm.DIRporcentaje.description = "Porcentaje de impuesto";
					objForm.DIRmontofijo.required = true;
					objForm.DIRmontofijo.description = "Monto fijo de impuesto";
					
					
					
					objForm.DIRporcexc.required = true;
					objForm.DIRporcexc.validateRango('0','100');
					objForm.DIRporcexc.validate = true;
					objForm.DIRporcexc.description = "Porcentaje de Exceso";
					objForm.DIRmontoexc.required = true;
					objForm.DIRmontoexc.description = "Monto fijo de impuesto";
					
					
				</cfif>
			</cfif>
			//Asigna el foco dependiendo del modo
			<cfif dmodo eq 'CAMBIO'>
				objForm.DIRsup.obj.focus();	
			<cfelseif emodo eq 'CAMBIO'>
				objForm.DIRsup.obj.focus();
			<cfelseif modo eq 'CAMBIO'>
				objForm.EIRdesde.obj.focus();
			<cfelse>
				objForm.IRcodigo.obj.focus();
			</cfif>
		<cfelse>
			objForm.ENuevo.obj.focus();
		</cfif>		


	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	// Concepto de Deducciones ///////////////////////////////////////////////////////////////////////////////////////////	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////			
	<cfelseif frame eq 'CD'>
		function setBtn(objBoton) {
			var result = true;
			switch (objBoton.alt) {
			case '0' :
				document.form.Accion.value='Alta';
				<cfif modo neq 'ALTA'>
					fnNoValidarE();
				</cfif>
				break;
			case '1' :
				document.form.Accion.value='Cambio';
				<cfif modo neq 'ALTA'>
					fnNoValidarE();
				</cfif>
				break;
			case '2' :
				if (confirm('¿Desea Eliminar el Registro completo del Impuesto sobre la Renta y todos sus Detalles?'))
					document.form.Accion.value='Baja';
				else
					result = false;
				break;
			case '3' :
				document.form.Accion.value='Nuevo';
				break;
			<cfif modo neq 'ALTA'>
			case '4' :
				document.form.Accion.value='EAlta';
				<cfif emodo neq 'ALTA'>
					fnNoValidarD();
				</cfif>
				break;
			case '5' :
				document.form.Accion.value='ECambio';
				<cfif emodo neq 'ALTA'>
					fnNoValidarD();
				</cfif>
				break;
			case '6' :
				if (confirm('¿Desea Eliminar el Rango del Historico del Impuesto sobre la Renta y todos sus Detalles?'))
					document.form.Accion.value='EBaja';
				else
					result = false;
				break;		
			case '7' :
				document.form.Accion.value='ENuevo';
				break;
			</cfif>
			<cfif emodo neq 'ALTA'>
			case '8' :
				document.form.Accion.value='DAlta';
				document.form.DCDvalor.value = qf(document.form.DCDvalor);
				break;
			case '9' :
				document.form.DCDvalor.value = qf(document.form.DCDvalor);
				document.form.Accion.value='DCambio';
				break;
			case '10' :
				if (confirm('¿Desea Eliminar el Rango Impuestos?')) {
					document.form.Accion.value='DBaja';
				}
				else
					result = false;
				break;		
			case '11' :
				document.form.Accion.value='DNuevo';
				break;
			</cfif>
			}
			//Para que no valide en Baja ni Baja Detalle
			if (document.form.Accion.value=='Baja' || document.form.Accion.value=='Nuevo' || 
				document.form.Accion.value=='EBaja' || document.form.Accion.value=='ENuevo' || 
				document.form.Accion.value=='DBaja' || document.form.Accion.value=='DNuevo')
				fnNoValidar();
				
			//Resultado de la función
			return result;
		}
		function fnNoValidar() {
			objForm.IRcodigo.required = false;
			objForm.IRdescripcion.required = false;
			objForm.IRfactormeses.required = false;
			<cfif modo neq 'ALTA'>
			fnNoValidarE();
			</cfif>
			<cfif emodo neq 'ALTA'>
			fnNoValidarD();
			</cfif>
		}
		function fnNoValidarE() {		
			//objForm.CDcodigo.required = false;
			//objForm.CDdescripcion.required = false;
		}
		function fnNoValidarD() {
			objForm.EIRid.required = false;
			objForm.CDcodigo.required = false;
			objForm.CDdescripcion.required = false;			
			objForm.DCDvalor.required = false;
		}
		function fnfinalizar(f) {
			f.IRcodigo.disabled = false;
			f.IRcodigo.readonly = false;
			<cfif emodo neq 'ALTA'>
				f.CDcodigo.disabled = false;
				f.CDcodigo.readonly = false;
				f.DCDvalor.value = qf(f.DCDvalor);
			</cfif>
		}
		function Eliminar(id) {
			if (confirm('¿Desea Eliminar el Concepto de Deducción y todos sus Detalles?')) {
				document.form.CDid.value = id;
				document.form.Accion.value='EBaja';
				fnNoValidar();
				document.form.submit();
				return true;
			}
			return false;
		}
		
		function Modificar(id) {		
			document.form.EIRid.value = id;
			document.form.Accion.value = 'EModificar';
			fnNoValidar();
			fnfinalizar(document.form);
			document.form.submit();
		}

		//Funciones adicionales de validación
		function _Field_isAlfaNumerico()
		{
			var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
			var tmp="";
			var string = this.value;
			var lc=string.toLowerCase();
			for(var i=0;i<string.length;i++) {
				if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
			}
			if (tmp.length!=this.value.length)
			{
				this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
			}
		}
		function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
		var high=_param(arguments[1], 9999999, "number");
		var iValue=parseInt(qf(this.value));
		if(isNaN(iValue))iValue=0;
		if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}}
		function _Field_isExiste(){
			var existe = new Boolean;
			existe = false;
			<cfoutput query="rsIRCodigos">
				if ('#IRcodigo#'==this.value)
					existe = true;
			</cfoutput>
			if (existe){this.error="El campo "+this.description+" contiene un valor que ya existe, debe digitar uno diferente.";}
		}
		function _Field_isExisteCDcodigo(){
			var existe = new Boolean;
			existe = false;
			
			if (existe){this.error="El campo "+this.description+" contiene un valor que ya existe, debe digitar uno diferente.";}
		}
		_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
		_addValidator("isRango", _Field_isRango);
		_addValidator("isExiste", _Field_isExiste);
		_addValidator("isExisteCDcodigo", _Field_isExisteCDcodigo);
		//Validaciones
		//Código solo se valida en Alta porque después no se puede modificar.
		<cfif modo eq 'ALTA'>
			objForm.IRcodigo.description = "Código";
			objForm.IRcodigo.validateAlfaNumerico();
			objForm.IRcodigo.validateExiste();
			objForm.IRcodigo.validate = true;
			objForm.IRcodigo.required = true;
		</cfif>
		objForm.IRdescripcion.description = "Descripción";
		objForm.IRdescripcion.validateAlfaNumerico();
		objForm.IRdescripcion.validate = true;
		objForm.IRdescripcion.required = true;
		objForm.IRfactormeses.description = "Factor de Meses";
		objForm.IRfactormeses.validate = true;
		objForm.IRfactormeses.required = true;
		objForm.IRfactormeses.validateRango('1','12');
		<cfif modo neq 'ALTA' and emodo neq 'ALTA'>
		
			objForm.CDcodigo.required = true;
			objForm.CDcodigo.description = "Código";
			objForm.CDcodigo.validateAlfaNumerico();
			objForm.CDcodigo.validateExisteCDcodigo();
			objForm.CDcodigo.validate = true;
			objForm.CDdescripcion.required = true;
			objForm.CDdescripcion.description = "Descripción";
			objForm.CDdescripcion.validateAlfaNumerico();
		
			<cfif emodo neq 'ALTA'>	
				objForm.EIRid.required = true;
				objForm.EIRid.description = "Periodo";
				objForm.DCDvalor.required = true;
				objForm.DCDvalor.validateRango('0','999999999');
				objForm.DCDvalor.validate = true;
				objForm.DCDvalor.description = "Monto";
			</cfif>
		</cfif>
	</cfif>	
	///////////
</script>
