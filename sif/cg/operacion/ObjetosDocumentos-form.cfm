<cfinvoke  key="BTN_Agregar" default="Agregar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Agregar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Modificar" default="Modificar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Modificar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Eliminar" default="Eliminar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Eliminar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Nuevo" default="Nuevo" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Nuevo" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="Lbl_DescArch" default="Descripción del Archivo" component="sif.Componentes.Translate" method="Translate"
returnvariable="Lbl_DescArch" />
<cfinvoke  key="Lbl_DebeSelArch" default="Debe seleccionar un archivo" component="sif.Componentes.Translate" method="Translate"
returnvariable="Lbl_DebeSelArch" />

<cfset modo = 'ALTA'>
<cfif isdefined("form.IDdocsoporte") and len(trim(form.IDdocsoporte))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsdataObj" datasource="#session.DSN#">
		select 	IDdocsoporte, IDcontable, ECSdescripcion, ECScontenttype, 
				ECStipo, ECStexto,ts_rversion, ECScontenido
		from EContableSoporte
		where IDdocsoporte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocsoporte#">
			and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">
	</cfquery>
</cfif>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	
	//-->	
	function funcCambiar(parvalor){
		var _Etitexto = document.getElementById("Etitexto");
		var _DivECStexto = document.getElementById("DivECStexto");
		var _EtiArchivo = document.getElementById("EtiArchivo");
		var _DivArchivo = document.getElementById("DivArchivo");
		
		if(parvalor=="t"){
			_Etitexto.style.display = '';
			_DivECStexto.style.display = '';
			_EtiArchivo.style.display = 'none';
			_DivArchivo.style.display = 'none';
			document.form1.tipo.value = 1;
		}
		else{			
			_Etitexto.style.display = 'none';
			_DivECStexto.style.display = 'none';		
			_EtiArchivo.style.display = '';
			_DivArchivo.style.display = '';	
			document.form1.tipo.value = 0;
		}	
	}
</script>
<cfoutput>
	<form enctype="multipart/form-data" action="ObjetosDocumentos#sufix#-sql.cfm" method="post" name="form1" onsubmit="javascript:return funcValidar()" ><!----document.form1.dir.value=document.form1.ECScontenido.value;---->
		<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >		
			<!---Si este input tiene valor 1 es solamente cuando el tipo es de texto digitable--->
			<input type="hidden" name="tipo" value="<cfif modo NEQ 'ALTA'>#rsdataObj.ECStipo#<cfelse>0</cfif>">
			<tr>
				<td align="right" nowrap><strong><cf_translate key=LB_DescripcionArchivo>Descripción Archivo</cf_translate>:</strong>&nbsp;</td>
				<td><input type="text" name="ECSdescripcion"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.ECSdescripcion)#</cfif>" size="60" maxlength="100"></td>
			</tr>			
			<tr>
				<td align="right" nowrap><strong><cf_translate key=LB_Tipo>Tipo</cf_translate>:</strong>&nbsp;</td>
				<td>
					<table>
						<tr>
							<td>
								<input type="radio" name="rdTipo" id="" value="t" onClick="javascript: funcCambiar('t');"><label for="rdTipo"><cf_translate key=LB_DigitarTexto>Digitar Texto</cf_translate></label>				
							</td>
							<td>
								<input type="radio" name="rdTipo" id="" value="i" onClick="javascript: funcCambiar('i');"><label for="rdTipo"><cf_translate key=LB_Imagen>Imagen</cf_translate></label>
							</td>
							<td>
								<input type="radio" name="rdTipo" id="" value="o" onClick="javascript: funcCambiar('o');"><label for="rdTipo"><cf_translate key=LB_Archivo>Archivo</cf_translate></label>
							</td>	
						</tr>
					</table>
				</td>
			</tr>		
			<tr>
				<td align="right" nowrap valign="top" >
					<div id="Etitexto" style="display: none ;" ><strong><cf_translate key=LB_DigitarTexto>Digite el texto</cf_translate>:</strong>&nbsp;</div>
				</td>
				<td nowrap>
					<div id="DivECStexto" style="display: none ;" >
						<textarea name="txaECStexto" rows="10" cols="45"><cfif modo NEQ 'ALTA'><cfoutput>#rsdataObj.ECStexto#</cfoutput></cfif></textarea>
					</div>	
				</td>
			</tr>		 
			<tr>
				<td align="right" nowrap><div id="EtiArchivo" style="display: 'none' ;" ><strong><cf_translate key=LB_Archivo>Archivo</cf_translate>:</strong>&nbsp;</div></td>
				<td>
					<div id="DivArchivo" style="display: 'none' ;" >
						<input type="file" name="ECScontenido" value=""  onChange="javascript:extraeNombre(this.value);">
						<input type="hidden" name="nArchivo" value="">
					</div>	
					<input type="hidden" name="IDcontable" value="<cfif modo NEQ 'ALTA'>#rsdataObj.IDcontable#<cfelseif isdefined("form.IDcontable")>#form.IDcontable#</cfif>">
				</td>
			</tr>				
			<cfif modo NEQ 'ALTA'>
				<cfif rsdataObj.ECStipo EQ 0>
					<script type="text/javascript" language="JavaScript1.2">
						funcCambiar("t");
					</script>
				<cfelse>					
					<script type="text/javascript" language="JavaScript1.2">
						funcCambiar("i");
					</script>
				</cfif>
			</cfif>
			<tr><td colspan="2" nowrap>&nbsp;</td></tr>						  
			<tr>
				<td colspan="2" align="center">
					<cfif modo EQ "ALTA">
						<input type="submit" name="Alta" value="#BTN_Agregar#"  >
						<input type="reset" name="Limpiar" value="#BTN_Limpiar#" >
					<cfelse>	
						<input type="submit" name="Cambio" value="#BTN_Modificar#" >					
						<input type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
						<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript:deshabilitarValidacion();" >			
					</cfif>
					<input name="Regresar" type="button" value="#BTN_Regresar#" onClick="javascript:funcRegresar('#form.IDcontable#');">		 
				</td>
			</tr>			
			<cfif modo neq "ALTA">
				<cfset ts = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataObj.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
				<input type="hidden" name="IDdocsoporte" value="#rsdataObj.IDdocsoporte#">			
			</cfif>
		</table>
	</form>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>	
	objForm.ECSdescripcion.required = true;
	objForm.ECSdescripcion.description="#Lbl_DescArch#";
	</cfoutput>
	<!---<cfif modo EQ 'ALTA'>---> 
		/*objForm.ECScontenido.required = true;
		objForm.ECScontenido.description="Archivo";*/
	<!----</cfif>---->
	
	function funcValidar(){
		if(document.form1.tipo.value != 1){
			<cfif modo EQ 'ALTA'>
				if(document.form1.ECScontenido.value == ''){
					<cfoutput>	
					alert('#Lbl_DebeSelArch#')
					</cfoutput>	
					return false;
				}
			</cfif>	
		}		
		document.form1.dir.value=document.form1.ECScontenido.value;
		return true;		
	}
	
	function deshabilitarValidacion(){		
		objForm.ECSdescripcion.required = false;
		objForm.ECScontenido.required = false;
	}

	function funcRegresar(data) {
		if (data!="") {
			document.form1.action='DocumentosContables<cfoutput>#sufix#</cfoutput>.cfm';
			document.form1.submit();
		}
		return false;
	}
	
	function extraeNombre(value){
		var tmp =  value.split('\\');
		var dato = tmp[tmp.length-1];
		document.form1.nArchivo.value=value; 
		document.form1.ECScontenido.value=dato;
	}
	
</script>