<cfset modo = 'ALTA' >
<cfif isdefined("form.Modo") and form.Modo NEQ 'ALTA'>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCPValidacionConfiguracion" datasource="#Session.DSN#">
		select CPVCid, CPVid, Descripcion, PCEcatid, Valor
		from CPValidacionConfiguracion
		where CPVCid = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPVCid#" >	
			and Ecodigo = #Session.Ecodigo#	  
	</cfquery>
</cfif> 

<cfif modo EQ "CAMBIO">
		<cfquery name="rsCatalago" datasource="#Session.DSN#">
			select PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud
			from PCECatalogo
			where CEcodigo = #Session.CEcodigo#
			  and PCEcatid = #rsCPValidacionConfiguracion.PCEcatid#
			  and PCEactivo = 1
		</cfquery>
</cfif>

<cfquery name="rsNiveles" datasource="#Session.DSN#">
	SELECT a.CPVid, a.Descripcion 
	from CPValidacionValores a
	left join CPValidacionConfiguracion b
	on a.CPVid = b.CPVid
	where 1= 1
	<cfif modo EQ 'ALTA'>
		and b.CPVid is null
	<cfelse>
		and  b.CPVid is null
		or b.CPVid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCPValidacionConfiguracion.CPVid#" >
	</cfif>
	order by a.CPVid
</cfquery>


<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//Funciones que utilizan el objeto Qform.
	function deshabilitarValidacion(obj) {
		if (obj!='TratarDiferente') {
			<!--- objForm.PCEMid.required = false;
			objForm.PCNid.required = false;
			objForm.PCNlongitud.required = false;
			objForm.PCNdescripcion.required = false; --->
			<!--- <cfif rsForm.PCEMplanCtas EQ "1">
			objForm.PCEcatid.required = false;
			</cfif> --->
			//objForm.PCNdep.required = false;
		}
	}
	function cambiarDepende(obj) {
		if (trim(obj) == '') 
		{
			objForm.PCEcatid.required = true;	
			objForm.PCNlongitud.disabled = false;	
			objForm.PCNlongitud.required = true;	
			objForm.PCNdescripcion.disable = true;	
		}
		else 
		{
			objForm.PCEcatid.required = false;
			objForm.PCNlongitud.value = "";	
			objForm.PCNlongitud.disabled = true;	
			objForm.PCNlongitud.required = false;	
			objForm.PCNdescripcion.disable = true;	
		}
	}	
	
	function activarCampos() {
		var f = document.form3;
		f.PCEMid.disabled = false;
		f.PCNlongitud.disabled = false;
		f.PCNdescripcion.disabled = false;
		f.PCNcontabilidad.disabled = false;
		f.PCNpresupuesto.disabled = false;

		<!--- <cfif rsForm.PCEMplanCtas EQ 1>
		f.PCEcatid.disabled = false;
		f.PCNdep.disabled = false;
		</cfif> --->
	}
	function limpiarCatalogo() {
		var f = document.form3;
		f.PCNlongitud.value = '';
		f.PCNdescripcion.value = '';
		f.PCNcontabilidad.checked = true;
		f.PCNpresupuesto.checked = false;

		f.PCNlongitud.disabled = false;		
		f.PCNdescripcion.disabled = false;
		f.PCNcontabilidad.disabled = false;
		f.PCNpresupuesto.disabled = false;

		<!--- <cfif rsForm.PCEMplanCtas EQ 1>
		f.PCEcodigo.value = '';
		f.PCEdescripcion.value = '';

		f.PCEcatid.value = '';
		f.PCNdep.disabled = false;
		</cfif> --->
	}
	function cambiarCatalogo(obj) {
		var f = document.form3;
		<!--- <cfoutput query="rsCatalgos">--->
			f.PCNdescripcion.disabled = true;
			f.PCNdescripcion.value = f.PCEdescripcion.value;
			f.CPDescripcion.value = f.PCEdescripcion.value;
			
		<!---</cfoutput> --->
	}
	
</script><!--- <fieldset><legend>Niveles</legend> --->
<cf_templatecss>

<form action="CPValidacionConfiguracion-SQL.cfm" method="post" name="form3" style="margin:0;">
<cfif MODO eq "Cambio">
	<cfset ts = "">
	<!--- <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsNivel.ts_rversion#" returnvariable="ts"> 
	</cfinvoke>--->
	<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
</cfif>
	  
<table border="0" cellspacing="3" cellpadding="0" align="center">
	<tr>
		<td width="1%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
		<td width="1%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" style="text-align:center;font-weight:bold;border-top:1px solid ##FF0000;border-bottom:1px solid ##FF0000;">Nivel de la Máscara</td>
	</tr>
	<tr>
		<td nowrap  ><div align="right">Nivel:</div></td>
		<td>
			<select name="CPCNivel" id="CPCNivel" tabindex="2">
							<cfoutput query="rsNiveles"> 
							<option value="#rsNiveles.CPVid#" <cfif (isDefined("rsCPValidacionConfiguracion.CPVid") AND rsCPValidacionConfiguracion.CPVid EQ rsNiveles.CPVid)>selected</cfif>>#rsNiveles.Descripcion#</option>
							</cfoutput> 
			</select>
		</td>
		<td nowrap  ><div align="right">Valor:</div></td>
		<td>
			<select name="CPCNValor" id="CPCNValor" tabindex="2">
							 <option value="Clasificacion" <cfif (isDefined("rsCPValidacionConfiguracion.Valor") AND rsCPValidacionConfiguracion.Valor EQ "Clasificacion")>selected</cfif>>Clasificación</option>
							 <option value="Referencia" <cfif (isDefined("rsCPValidacionConfiguracion.Valor") AND rsCPValidacionConfiguracion.Valor EQ "Referencia")>selected</cfif>>Referencia</option>
							 <option value="Valor" <cfif (isDefined("rsCPValidacionConfiguracion.Valor") AND rsCPValidacionConfiguracion.Valor EQ "Valor")>selected</cfif>>Valor</option>
			</select>
		</td>

	</tr>

	<cfif 1 EQ 1> 
	<tr id="trCatalogo">		
    	<td nowrap  ><div align="right">Cat&aacute;logos:</div></td>		
    	<td nowrap colspan="3">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td>		  
						<cfif MODO NEQ 'ALTA'>	  
							<cf_sifcatalogos form="form3" query="#rsCatalago#" funcion="cambiarCatalogo" tabindex="2" readonly="false" >
						<cfelse>	
							<cf_sifcatalogos form="form3" funcion="cambiarCatalogo" tabindex="2" readonly="false">		
						</cfif>		  		  						
					</td>
					<td nowrap>
						&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfif>
	
	<tr>
		<td nowrap><div align="right">Descripcion:</div></td>		
		<td nowrap colspan="3">
			<cfif isDefined("rsNivel.PCNdescripcion") and find("(",rsNivel.PCNdescripcion) GT 0>
				<cfset rsNivel.PCNdescripcion = mid(rsNivel.PCNdescripcion,1,find("(",rsNivel.PCNdescripcion)-1)>
			</cfif>
			<input 	type="text" name="PCNdescripcion" id="PCNdescripcion" tabindex="2" size="60" maxlength="80" disabled value="<cfif (isDefined("rsCPValidacionConfiguracion.Descripcion"))><cfoutput>#rsCPValidacionConfiguracion.Descripcion#</cfoutput></cfif>"
			onkeypress="var LvarKeyPress = (event.charCode) ? event.charCode : ((event.which) ? event.which : event.keyCode);
						if (LvarKeyPress == 40) return false;">
			<input type="hidden" name="CPDescripcion" value="<cfif (isDefined("rsCPValidacionConfiguracion.Descripcion"))><cfoutput>#rsCPValidacionConfiguracion.Descripcion#</cfoutput></cfif>" tabindex="2">
			<input type="hidden" name="CPVCid" value="<cfif (isDefined("rsCPValidacionConfiguracion.CPVCid"))><cfoutput>#rsCPValidacionConfiguracion.CPVCid#</cfoutput></cfif>" tabindex="2">
			<input type="hidden" name="PCEMid" value="1" tabindex="2"> </td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;
			<!--- <input type="submit" class="btnPrueba"  name="Prueba" tabindex="3"  value="Prueba" > --->
		</td>
	</tr>
	
    <tr> 
      <td nowrap colspan="4"><div align="center"> 
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfif MODO eq "CAMBIO">
				<input type="submit" class="btnGuardar"  name="Cambio" tabindex="3"  value="Modificar" >
				<input type="submit" class="btnEliminar" name="Baja" 	 tabindex="3" value="Eliminar" onClick="javascript: if (!confirm('¿Desea eliminar el registro?')){return false;}else{return true;}">
				<input type="submit" class="btnNuevo" 	 name="Nuevo" 	 tabindex="3" value="Nuevo">
            <cfelse>
					<input type="submit" class="btnGuardar"  name="Alta" 	 tabindex="3" value="Agregar">
					<input type="reset"  class="btnLimpiar"  name="Limpiar" tabindex="3" value="Limpiar">
			</cfif>
			
        </div></td>
    </tr>
</table>
</form>

<cf_qforms form="form3">
	<cf_qformsRequiredField  name="CPCNivel" description="Nivel">
	<cf_qformsRequiredField  name="PCNdescripcion" description="Descripción">
	<cf_qformsRequiredField name="PCEdescripcion" description="Catálogo">
</cf_qforms>

<script language="JavaScript1.2" type="text/javascript">
	//cambiarMascara(document.form3.PCEMid.value);
	<<!--- cfif MODO EQ 'ALTA'>limpiarCatalogo();</cfif> --->
		
	//definicion del color de los campos con errores de validación para cualquier instancia de qforms
	qFormAPI.errorColor = "#FFFFCC";
	//instancias de qforms
	objForm = new qForm("form3");
	//descripciones de los campos para la validación de qforms
	<!--- objForm.PCEMid.description = "Máscara";
	objForm.PCNid.description = "Nivel";
	objForm.PCNlongitud.description = "Longitud";
	objForm.PCNdescripcion.description = "Descripcion";
	<!--- <cfif rsForm.PCEMplanCtas EQ 1>
		objForm.PCEcatid.description = "Catálogo";
		//objForm.PCNdep.description = "Depende";
	</cfif> --->
	//campos requeridos
	<cfif MODO NEQ 'ALTA'> objForm.PCNid.required = true; </cfif>	
	objForm.PCEMid.required = true;
	objForm.PCNlongitud.required = true;
	objForm.PCNdescripcion.required = true; --->
	<!--- <cfif rsForm.PCEMplanCtas EQ 1>
		cambiarCatalogo(document.form3.PCEcatid.value);
		objForm.PCEcatid.required = true;
		//objForm.PCNdep.required = true;
		cambiarDepende(document.form3.PCNdep.value);
	</cfif> --->
</script>