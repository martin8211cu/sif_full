<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se corrige la navegación del form en la pantalla por tabs para que tengan un orden lógico.
 --->

<!--- DEFINE EL MODO DEL ENCABEZADO --->
<cfif isdefined("Url.PCCEclaid") and not isdefined("Form.PCCEclaid")>
	<cfset Form.PCCEclaid = Url.PCCEclaid>
</cfif>

<cfif isDefined("Form.PCCEclaid") and len(trim(Form.PCCEclaid)) neq 0>
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>

<cfif isDefined("Form.btnNuevo")>
	<cfset MODO = "ALTA">
</cfif>

<cfif MODO EQ "CAMBIO" and isDefined("Form.PCCDclaid") and len(trim(Form.PCCDclaid))>
	<cfset DMODO = "CAMBIO">
<cfelse>
	<cfset DMODO = "ALTA">
</cfif>

<cfparam name="Url.F_PCCDvalor" default="">
<cfparam name="Url.F_PCCDdescripcion" default="">

<cfif isdefined("Url.F_PCCDvalor") and not isdefined("Form.F_PCCDvalor")>
	<cfset Form.F_PCCDvalor = Url.F_PCCDvalor>
</cfif>
<cfif isdefined("Url.F_PCCDdescripcion") and not isdefined("Form.F_PCCDdescripcion")>
	<cfset Form.F_PCCDdescripcion = Url.F_PCCDdescripcion>
</cfif>

<cfset filtro = "">	
<cfif isdefined("Form.PCCEclaid") and len(trim(Form.PCCEclaid))>
	<cfset navegacion = "PCCEclaid=" & Form.PCCEclaid>
</cfif>
 
<cfif isdefined('form.F_PCCDvalor') and Len(Trim(form.F_PCCDvalor))>
	<cfset filtro = filtro & " and Upper(PCCDvalor) like Upper('%#form.F_PCCDvalor#%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "F_PCCDvalor=" & Form.F_PCCDvalor>
</cfif>	  
<cfif isdefined('form.F_PCCDdescripcion') and Len(Trim(form.F_PCCDdescripcion))>
	<cfset filtro = filtro & " and Upper(PCCDdescripcion) like Upper('%#form.F_PCCDdescripcion#%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "F_PCCDdescripcion=" & Form.F_PCCDdescripcion>
</cfif>	 


<!--- Consultas del Encabezado --->
<cfif MODO eq "CAMBIO">
	<!--- Consultas que se ejecutan solo en MODO CAMBIO --->
	<cfquery name="rsPCE" datasource="#Session.DSN#">
		select PCCEclaid ,CEcodigo, PCCEcodigo, PCCEdescripcion ,PCCEempresa, PCCEactivo, ts_rversion, BMUsucodigo
		from PCClasificacionE
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCCEclaid#">
	</cfquery>
	<cfif rsPCE.RecordCount neq 1>
		<cfif rsPCE.RecordCount lt 1>
			<cfset url.errMsg = "La consulta del encabezado de la Clasificacion no produjo ningun resultado.">
		<cfelse>
			<cfset url.errMsg = "La consulta del encabezado de la Clasificacion produjo mas de 1 resultado.">
		</cfif>
		<cflocation url="/sif/errorPages/BDerror.cfm?errMsg=#errMsg#">
	</cfif>
</cfif>

<!--- Consultas del Detalle --->
<cfif DMODO eq "CAMBIO">
	<!--- Consultas que se ejecutan solo en DMODO CAMBIO --->
	<cfquery name="rsPCD" datasource="#Session.DSN#">
		select PCCEclaid, PCCDclaid, Ecodigo, PCCDvalor, PCCDdescripcion, PCCDactivo, Usucodigo, ts_rversion, BMUsucodigo
		from PCClasificacionD
		where PCCDclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCCDclaid#">
	</cfquery>
	<cfif rsPCD.RecordCount neq 1>
		<cfif rsPCD.RecordCount lt 1>
			<cfset url.errMsg = "La consulta del detalle de la Clasificacion no produjo ningun resultado.">
		<cfelse>
			<cfset url.errMsg = "La consulta del detalle de la Clasificacion produjo mas de 1 resultado.">
		</cfif>
		<cflocation url="/sif/errorPages/BDerror.cfm?errMsg=#errMsg#">
	</cfif>
</cfif>

<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	//Funciones que utilizan el objeto Qform.
	function deshabilitar(who)	{
		if (who==1)	{
			objForm.PCCEcodigo.required = false;
			objForm.PCCEdescripcion.required = false;
		}
		if (who==2)	{
			objForm.PCCDvalor.required = false;
			objForm.PCCDdescripcion.required = false;
		}
	}
	function deshabilitarValidacion(obj) {
		if (obj.name=='Baja'||obj.name=='Nuevo'||obj.name=='DNuevo'||obj.name=='DBaja'||obj.name=='btnLista') {
			deshabilitar(1);
			deshabilitar(2);
		} else if (obj.name=='Cambio') {
			deshabilitar(2);
		}
	}
	
	function validar() {
		document.form1.PCCEempresa.disabled = false;
		return true;
	}

</script>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0;">
<form action="Clasificacion-sql.cfm" method="post" name="form1" onSubmit="javascript: return validar();" style="margin:0;" >
<!--------------------------------------------------ENCABEZADO--------------------------------------------------------------->
    <tr> 
      	<td nowrap colspan="6">
			<cfif MODO eq "CAMBIO">
				<input type="hidden" name="PCCEclaid" value="#rsPCE.PCCEclaid#" tabindex="-1">
				<cfset ts = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsPCE.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#" tabindex="-1">
			</cfif>
			<div align="center" class="tituloAlterno">Encabezado de la Clasificaci&oacute;n</div>
		</td>
    </tr>
    <tr> 
      <td height="20" colspan="6" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap><div align="right">C&oacute;digo &nbsp;&nbsp;</div></td>
      <td nowrap >
	  	<input name="PCCEcodigo" type="text" id="PCCEcodigo" value="<cfif MODO EQ "CAMBIO">#Trim(rsPCE.PCCEcodigo)#</cfif>" maxlength="10" tabindex="1">
	  	<span align="left"> </span>
	  </td>
      <td nowrap ><div align="right">Descripci&oacute;n: &nbsp;&nbsp;</div></td>
      <td nowrap ><input name="PCCEdescripcion" type="text" id="PCCEdescripcion" value="<cfif MODO EQ "CAMBIO">#Trim(rsPCE.PCCEdescripcion)#</cfif>" size="60" maxlength="80" tabindex="1"></td>
      <td nowrap ><span align="left" >
        <input <cfif MODO EQ "CAMBIO">disabled</cfif> <cfif MODO EQ "CAMBIO" and rsPCE.PCCEempresa EQ 1> checked</cfif> name="PCCEempresa" type="checkbox" id="PCCEempresa" value="checkbox" tabindex="1">
Valores por Empresa </span></td>
      <td nowrap ><span >
        <input name="PCCEactivo" type="checkbox" id="PCCEactivo" value="checkbox" tabindex="1" <cfif MODO eq "CAMBIO" and rsPCE.PCCEactivo EQ 1> checked<cfelseif modo eq 'ALTA'> checked</cfif>>
Activo</span></td>
    </tr>
	
    <cfif MODO eq "CAMBIO">
 <!--------------------------------------------------DETALLE----------------------------------------------------------------->
	  <tr> 
        <td nowrap colspan="6">
			<cfif DMODO eq "CAMBIO">
				<input type="hidden" name="PCCDclaid" value="#rsPCD.PCCDclaid#" tabindex="-1">
				<cfset tsd = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsPCD.ts_rversion#" returnvariable="tsd">
				</cfinvoke>
				<input type="hidden" name="dtimestamp" value="#tsd#" tabindex="-1">
			</cfif>
		</td>
      </tr>
      <tr> 
        <td nowrap colspan="6"><div align="center" class="tituloAlterno">Detalle de la Clasificaci&oacute;n</div></td>
      </tr>
	  <tr>
        <td nowrap colspan="6">&nbsp;</td>
      </tr>
      <tr> 
        <td nowrap colspan="6"> 
          <!--- INICIA PINTADO DEL DETALLE --->
            <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr> 
                <td nowrap ><div align="left" >Valor</div></td>
                <td nowrap ><input name="PCCDvalor" type="text" id="PCCDvalor2" tabindex="2" value="<cfif DMODO EQ "CAMBIO">#Trim(rsPCD.PCCDvalor)#</cfif>" maxlength="20"></td>
                <td nowrap ><div align="left" >Descripci&oacute;n</div></td>
                <td nowrap ><input name="PCCDdescripcion" type="text" id="PCCDdescripcion2" tabindex="2" value="<cfif DMODO EQ "CAMBIO">#Trim(rsPCD.PCCDdescripcion)#</cfif>" size="60" maxlength="80"></td>
                <td nowrap ><div align="left" >Activo
                  <input name="PCCDactivo" type="checkbox" id="PCCDactivo3" value="checkbox" tabindex="2" <cfif DMODO EQ 'CAMBIO' and rsPCD.PCCDactivo EQ 1>checked<cfelseif DMODO eq 'ALTA'>checked</cfif>>
                </div></td>
              </tr>
            </table>
            <!--- FINALIZA PINTADO DEL DETALLE --->
          </td>
      </tr>
    </cfif>
<!--------------------------------------------------BOTONES----------------------------------------------------------------->
    <tr> 
      <td nowrap colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap colspan="6"><div align="center"> 

			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
			<input type="hidden" name="botonSel" value="" tabindex="-1">
			<cfif MODO eq "CAMBIO">
				<!--- DEFINE BOTONES PARA ENCABEZADO Y DETALLE EN MODO CAMBIO--->
				<cfif DMODO eq "ALTA">
					<input type="submit" name="DAlta" 	value="Agregar" onClick="javascript: this.form.botonSel.value = this.name;" tabindex="2">
					<input type="reset"  name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name;" tabindex="2">
					<input type="submit" name="Cambio" value="Modificar Clasificación" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;" tabindex="2">
					<input type="submit" name="Baja" 	value="Eliminar Clasificación" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el encabezado y todos sus detalles?')){return false;}else{deshabilitarValidacion(this); return true;}" tabindex="2">
					<input type="submit" name="Nuevo" 	value="Nuevo Clasificación" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;" tabindex="2">
				<cfelse>	
					<input type="submit" name="DCambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name;" tabindex="2">
					<input type="submit" name="DBaja" 	value="Eliminar detalle" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el detalle?')){return false;}else{deshabilitarValidacion(this); return true;}" tabindex="2">
					<input type="submit" name="DNuevo" 	value="Nuevo detalle" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;" tabindex="2">
					<input type="submit" name="Baja" 	value="Eliminar Clasificación" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el encabezado y todos sus detalles?')){return false;}else{deshabilitarValidacion(this); return true;}" tabindex="2">
				</cfif>
            <cfelse>
				<!--- DEFINE BOTONES PARA ENCABEZADO EN MODO ALTA--->
				<input type="submit" name="Alta" 	value="Agregar" onClick="javascript: this.form.botonSel.value = this.name;" tabindex="2">
				<input type="reset"  name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name;" tabindex="2">
			</cfif>
			<input type="submit" name="btnLista" value="Ir a Lista" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;" tabindex="2">
        </div></td>
    </tr>
</form>

<cfif MODO eq "CAMBIO">
 <!--------------------------------------------------DETALLE----------------------------------------------------------------->
      <tr> 
        <td nowrap colspan="6">&nbsp;</td>
      </tr>

      <tr> 
        <td nowrap colspan="6"><div align="center" class="subTitulo">Lista de Detalles de la Clasificaci&oacute;n</div></td>
      </tr>	  

      <tr> 
        <td nowrap colspan="6" align="center">
		  <form style="margin:0;" name="formFiltro" method="post" action="Clasificacion.cfm">
				<cfif MODO eq "CAMBIO">
					<input type="hidden" name="PCCEclaid" value="#rsPCE.PCCEclaid#" tabindex="-1">		  
					<input type="hidden" name="MODO" value="#MODO#" tabindex="-1">		  					
				</cfif>				
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
				  <tr>
					<td><strong>Valor</strong></td>
					<td><strong>Descripci&oacute;n</strong></td>
					<td rowspan="2" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="3"></td>
				  </tr>
				  <tr>
					<td><input name="F_PCCDvalor" type="text" id="F_PCCDvalor" value="<cfif isdefined('form.F_PCCDvalor') and form.F_PCCDvalor NEQ "">#form.F_PCCDvalor#</cfif>" maxlength="20" tabindex="2"></td>
					<td><input name="F_PCCDdescripcion" type="text" id="F_PCCDdescripcion" value="<cfif isdefined('form.F_PCCDdescripcion') and form.F_PCCDdescripcion NEQ "">#form.F_PCCDdescripcion#</cfif>" size="60" maxlength="80" tabindex="2"></td>
				  </tr>
			</table>
			  
		  </form>		
		</td>
      </tr>	  

      <tr>
      <td nowrap colspan="6">
		<cfset porEmpresa = IIf(isDefined("rsPCE.PCCEempresa") AND rsPCE.PCCEempresa eq 1, DE("and b.Ecodigo = #Session.Ecodigo#"), DE(""))>
		
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="PCClasificacionE a, PCClasificacionD b"/>
			<cfinvokeargument name="columnas" value="'#Form.F_PCCDvalor#' as F_PCCDvalor,
													'#Form.F_PCCDdescripcion#' as F_PCCDdescripcion,
													a.PCCEclaid, 
													b.PCCDclaid, 
													coalesce(a.PCCEdescripcion,'Ninguno') as PCCEdescripcion, 
													case b.PCCDactivo when 1 then 'Sí' else 'No' end as PCDactivo, 
													b.PCCDvalor,
													b.PCCDdescripcion,
													'CAMBIO' as DMODO"/>
			<cfinvokeargument name="desplegar" value="PCCDvalor, PCCDdescripcion, PCDactivo"/>
			<cfinvokeargument name="etiquetas" value="Valor, Descripción, Activo"/>
			<cfinvokeargument name="formatos" value="S, S, S"/>
			<cfinvokeargument name="filtro" value="a.PCCEclaid = #Form.PCCEclaid# 
												   and a.PCCEclaid = b.PCCEclaid
												   #porEmpresa# 
												   #filtro#  
												   order by PCCDvalor"/>
			<cfinvokeargument name="align" value="left, left, center "/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="Clasificacion.cfm"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="PageIndex" value="2"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
		</td>
      </tr>
	</cfif>
</table>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	//validaciones adicionadas al API de qforms
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
	function _Field_isRango(low, high){
		if(this.obj.form.botonSel.value != 'btnLista'){
			var low=_param(arguments[0], 0, "number");
			var high=_param(arguments[1], 9999999, "number");
			var iValue=parseInt(qf(this.value));
			
			if(isNaN(iValue))
				iValue=0;
				
			if((low>iValue)||(high<iValue)){
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}		
		}
	}
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isRango", _Field_isRango);
	_addValidator("isFecha", _Field_isFecha);
	//definicion del color de los campos con errores de validación para cualquier instancia de qforms
	qFormAPI.errorColor = "#FFFFCC";
	//instancias de qforms
	objForm = new qForm("form1");
	//descripciones de objetos de la instancia de qform definida
	objForm.PCCEcodigo.description = "Código de la Clasificación";
	objForm.PCCEdescripcion.description = "Descripción";
	objForm.PCCEempresa.description = "Valores Definidos por Empresa";
	objForm.PCCEactivo.description = "Clasificación Activo";
	//campos requeridos de la instancia de qform definida
	objForm.PCCEcodigo.required = true;
	objForm.PCCEdescripcion.required = true;
	//validaciones de los objetos de la instancia de qform definida
	objForm.PCCEcodigo.validateAlfaNumerico();
	objForm.PCCEdescripcion.validateAlfaNumerico();

	//Define el objecto que obtiene el foco
	objForm.PCCEcodigo.obj.focus();
	<cfif MODO eq "CAMBIO">
		//descripciones de los campos requeridos del detalle
		objForm.PCCDvalor.description = "Valor";
		objForm.PCCDdescripcion.description = "Descripción";
		//campos requeridos del detalle
		objForm.PCCDvalor.required = true;
		objForm.PCCDdescripcion.required = true;
		//validaciones del detalle
		objForm.PCCDvalor.validateAlfaNumerico();
		objForm.PCCDdescripcion.validateAlfaNumerico();
	</cfif>
</script>
