<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha 9-3-2006.
		Motivo: Se corrige la navegación del formulario por tabs.
 --->
 <cfsavecontent variable="helpimg">
	<img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0"/>
</cfsavecontent>
<cfif isDefined("Form.MODODET")> <cfset Form.MODO = Form.MODODET></cfif> 
<cfif isDefined("Form.MODO") 
		and Form.MODO eq "CAMBIO" 
		and isDefined("Form.PCEMid") 
		and len(trim(Form.PCEMid)) neq 0
		and isDefined("Form.PCNid") 
		and len(trim(Form.PCNid)) neq 0>
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>
<!--- Consultas --->
<cfif MODO eq "Cambio">
  <cfquery name="rsNivel" datasource="#Session.DSN#">
	select PCEMid, 
		PCNid, 
		PCEcatid, 
		PCNlongitud, 
		PCNdep, 
		PCNcontabilidad,
		PCNpresupuesto,
		PCNdescripcion,
        PCNDescripCta,
		ts_rversion
	from PCNivelMascara 
	where PCEMid = #form.PCEMid#
	  and PCNid  = #form.PCNid#	
  </cfquery>
  <cfif rsNivel.PCNcontabilidad and rsUtilizadoE.Cantidad GT 0>
	<cfset LvarEsContable = true>
  <cfelse>
	<cfset LvarEsContable = false>
  </cfif>
<cfelse>
	<cfset LvarEsContable = false>
</cfif>
<cfquery name="rsNiveles" datasource="#Session.DSN#">
	select pc.PCEMid, pc.PCNid, pc.PCEcatid, pc.PCNlongitud, pc.PCNdep
	from PCNivelMascara pc
	where pc.PCEMid = #form.PCEMid#
	<cfif isDefined("rsNivel.PCNid") and len(trim(rsNivel.PCNid)) gt 0>
		and #rsNivel.PCNid# > pc.PCNid
	</cfif>
	and (
		select count(1) 
		from PCDCatalogo p
        inner join PCNivelMascara pcm
        on pcm.PCEcatid = p.PCEcatid
        where pcm.PCEMid=#form.PCEMid#
		and PCEcatidref is not null or PCEcatidref is null ) > 0
</cfquery>

<cfif MODO eq "CAMBIO">	
	<cfif Len(Trim(rsNivel.PCEcatid)) GT 0>
		<!--- Trae el catálogo seleccionado --->
		<cfquery name="rsCatalago" datasource="#Session.DSN#">
			select PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud
			from PCECatalogo
			where CEcodigo = #Session.CEcodigo#
			  and PCEcatid = #rsNivel.PCEcatid#
			  and PCEactivo = 1
		</cfquery>
	</cfif>
		
	<cfquery name="rsMaxNivel" datasource="#Session.DSN#">
		select coalesce(max(PCNid), 0) as maximo 
		from PCNivelMascara
		where PCEMid = #form.PCEMid#
	</cfquery>
	<!--- Si el nivel ya ha sido utilizado por alguna cuenta --->
	<cfquery name="rsUtilizado" datasource="#Session.DSN#">
		select 1 
		from PCDCatalogoCuenta 
		where PCEMid  = #form.PCEMid# 
		  and PCDCniv = #form.PCNid#
	</cfquery>
</cfif>
<!--- 
	Si no se permite cambiar de catalogo, 
	no se requiere generar las funciones de cambio de catalogo
	para hacer mas pequeñas las paginas HTML y mejorar el tiempo de respuesta
	Se utiliza PCEcatid < 0 para no generar registros. 
--->
<cfquery name="rsCatalgos" datasource="#Session.DSN#">
	select PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud
	from PCECatalogo
	where CEcodigo = #Session.CEcodigo#
	and PCEactivo = 1
	<cfif LvarEsContable> and PCEcatid < 0 </cfif>
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
			objForm.PCEMid.required = false;
			objForm.PCNid.required = false;
			objForm.PCNlongitud.required = false;
			objForm.PCNdescripcion.required = false;
			<cfif rsForm.PCEMplanCtas EQ "1">
			objForm.PCEcatid.required = false;
			</cfif>
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
	function validaChecks(){
		if(!document.form3.PCNcontabilidad.checked){
			if(!document.form3.PCNpresupuesto.checked){
				alert('El Nivel de la Cuenta debe ser de Contable o Presupuestal, favor marque uno o ambos indicadores');
			}else{
				return true;			
			}
		}else{
			return true;		
		}
						
		return false;
	}
	function activarCampos() {
		var f = document.form3;
		f.PCEMid.disabled = false;
		f.PCNlongitud.disabled = false;
		f.PCNdescripcion.disabled = false;
		f.PCNcontabilidad.disabled = false;
		f.PCNpresupuesto.disabled = false;

		<cfif rsForm.PCEMplanCtas EQ 1>
		f.PCEcatid.disabled = false;
		f.PCNdep.disabled = false;
		</cfif>
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

		<cfif rsForm.PCEMplanCtas EQ 1>
		f.PCEcodigo.value = '';
		f.PCEdescripcion.value = '';

		f.PCEcatid.value = '';
		f.PCNdep.disabled = false;
		</cfif>
	}
	function cambiarCatalogo(obj) {
		var f = document.form3;
		<cfoutput query="rsCatalgos">
			if (obj=='#PCEcatid#') {
				f.PCNlongitud.value = "#PCElongitud#";
				f.PCNdep.disabled = true;
				f.PCNdep.value = '';
				f.PCNlongitud.disabled = true;
				f.PCNdescripcion.disabled = true;
				f.PCNdescripcion.value = f.PCEdescripcion.value;
			}
		</cfoutput>
	}
</script><!--- <fieldset><legend>Niveles</legend> --->
<cf_templatecss>
<form action="SQLMascarasCuentas.cfm" method="post" name="form3" onSubmit="javascript:activarCampos(); return validaChecks(this);" style="margin:0;">
<cfif MODO eq "Cambio">
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsNivel.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
</cfif>
	  
<table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td width="1%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" style="text-align:center;font-weight:bold;border-top:1px solid ##FF0000;border-bottom:1px solid ##FF0000;">Nivel de la Máscara</td>
	</tr>
	<tr>
		<td nowrap  ><div align="right">Nivel:</div></td>
		<td colspan="3" nowrap >
			<input name="PCNid" size="5" maxlength="4" type="text" id="PCNid" value="<cfif (isDefined("rsNivel.PCNid"))><cfoutput>#rsNivel.PCNid#</cfoutput></cfif>" readonly="true">
			&nbsp;&nbsp;&nbsp;
			<span >Nivel Contable:</span>
			<input type="checkbox" name="PCNcontabilidad" id="PCNcontabilidad" tabindex="2" value="1" <cfif (isDefined("rsNivel.PCNcontabilidad") AND rsNivel.PCNcontabilidad EQ 1)>checked</cfif><cfif LvarEsContable> disabled</cfif>>
			&nbsp;&nbsp;Nivel Presupuestal:
			<input type="checkbox" name="PCNpresupuesto" id="PCNpresupuesto" tabindex="2" value="1" <cfif (isDefined("rsNivel.PCNpresupuesto")  AND rsNivel.PCNpresupuesto  EQ 1)>checked</cfif>>
            &nbsp; &nbsp;
						Incluir en Descripci&oacute;n:
						<input  type="checkbox" name="PCNDescripCta" id="PCNDescripCta" tabindex="2" value="1" <cfif (isDefined("rsNivel.PCNDescripCta")  AND rsNivel.PCNDescripCta  EQ 1)>checked</cfif>>
						<cf_notas titulo="Incluir en Descripci&oacute;n de la Cuenta" link="#helpimg#" pageIndex="1" msg = "Se emplea para incluir la descripci&oacute;n del Nivel dentro de la descripci&oacute;n de la Cuenta" animar="true" position="left">
		</td>
	</tr>

	<cfif rsForm.PCEMplanCtas EQ 1> 
	<tr>		
    	<td nowrap  ><div align="right">Cat&aacute;logos:</div></td>		
    	<td nowrap colspan="2">
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td>		  
						<cfif MODO NEQ 'ALTA' and Len(Trim(rsNivel.PCEcatid)) GT 0 >	  
							<cf_sifcatalogos form="form3" query="#rsCatalago#" funcion="cambiarCatalogo" tabindex="2" readonly="#LvarEsContable#" >
						<cfelse>	
							<cf_sifcatalogos form="form3" funcion="cambiarCatalogo" tabindex="2" readonly="#LvarEsContable#">		
						</cfif>		  		  						
					</td>
					<td nowrap>
						&nbsp;
						<cfif not LvarEsContable>
							<a href="#" tabindex="-1"><img src="../../imagenes/delete.small.png" alt="Limpiar Catálogo" name="imagenLimpiar" width="16" height="16" border="0" align="absmiddle" onClick="javascript:limpiarCatalogo();"></a>
						</cfif>
						&nbsp;&nbsp;
					</td>
					<td nowrap>
						<span  align="left">Depende de Nivel:</span>
						<select name="PCNdep" id="PCNdep" onChange="javascript: cambiarDepende(this.value);" tabindex="2">
							<option value="" <cfif (isDefined("rsNivel.PCNdep") AND Len(Trim(rsNivel.PCNdep)) EQ 0)>selected</cfif>>Ninguno</option>
							<cfoutput query="rsNiveles"> 
							<option value="#rsNiveles.PCNid#" <cfif (isDefined("rsNivel.PCNdep") AND rsNiveles.PCNid EQ rsNivel.PCNdep)>selected</cfif>>#rsNiveles.PCNid#</option>
							</cfoutput> 
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfif>
	
	<tr>
		<td nowrap><div align="right">Longitud:</div></td>		
		<td nowrap colspan="3">
			<input 	name="PCNlongitud" type="text" size="5" maxlength="4" id="PCNlongitud" 
					value="<cfif (isDefined("rsNivel.PCNlongitud"))><cfoutput>#rsNivel.PCNlongitud#</cfoutput></cfif>" 
					onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					<cfif isDefined("rsNivel.PCEcatid") and Len(Trim(rsNivel.PCEcatid)) GT 0> readonly </cfif>
					tabindex="2"
			>
			&nbsp;&nbsp;&nbsp;
			Descripcion:
			<cfif isDefined("rsNivel.PCNdescripcion") and find("(",rsNivel.PCNdescripcion) GT 0>
				<cfset rsNivel.PCNdescripcion = mid(rsNivel.PCNdescripcion,1,find("(",rsNivel.PCNdescripcion)-1)>
			</cfif>
			<input 	type="text" name="PCNdescripcion" id="PCNdescripcion" tabindex="2" size="60" maxlength="80" value="<cfif (isDefined("rsNivel.PCNdescripcion"))><cfoutput>#rsNivel.PCNdescripcion#</cfoutput></cfif>"
			onkeypress="var LvarKeyPress = (event.charCode) ? event.charCode : ((event.which) ? event.which : event.keyCode);
						if (LvarKeyPress == 40) return false;">
			<input type="hidden" name="PCEMid" value="<cfoutput>#Form.PCEMid#</cfoutput>" tabindex="2"> </td>
	</tr>
	<tr>
		<td nowrap colspan="3">&nbsp;
			
		</td>
	</tr>
	
    <tr> 
      <td nowrap colspan="3"><div align="center"> 
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfif MODO eq "CAMBIO">
				<cfif rsUtilizado.RecordCount EQ 0>
					<input type="submit" class="btnGuardar"  name="Cambio3" tabindex="3"  value="Modificar" >
				</cfif>				
				<cfif rsMaxNivel.maximo EQ rsNivel.PCNid and rsUtilizado.RecordCount EQ 0 and not LvarEsContable>
					<input type="submit" class="btnEliminar" name="Baja3" 	 tabindex="3" value="Eliminar" onClick="javascript: if (!confirm('¿Desea eliminar el registro?')){return false;}else{deshabilitarValidacion(this.name); return true;}">
				</cfif>
					<input type="submit" class="btnNuevo" 	 name="Nuevo3" 	 tabindex="3" value="Nuevo"  onClick="javascript: deshabilitarValidacion(this.name); return true;">
            <cfelse>
					<input type="submit" class="btnGuardar"  name="Alta3" 	 tabindex="3" value="Agregar">
					<input type="reset"  class="btnLimpiar"  name="Limpiar3" tabindex="3" value="Limpiar">
			</cfif>
        </div></td>
    </tr>
	
	<cfif MODO eq "CAMBIO" and rsMaxNivel.maximo NEQ rsNivel.PCNid>
		<tr>
			<td nowrap colspan="5"><div align="center"><font color="#FF0000">El registro
	      actual no se puede eliminar porque no es el &uacute;ltimo nivel.</font></div></td>
		</tr>
	<cfelseif MODO eq "CAMBIO" and rsMaxNivel.maximo EQ rsNivel.PCNid and rsUtilizado.RecordCount gt 0>
		<tr>
			<td nowrap colspan="3"><div align="center"><font color="#FF0000">El registro Actual no se puede eliminar porque tiene referencias.</font></div></td>
		</tr>
	</cfif>
	</form>
	<tr>
		<td nowrap colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">
        <cfif rsForm.PCEMplanCtas EQ "1">
        		<cfset desplegar ="PCNid, desc1, nivel, PCNlongitud, Conta, Presup,  DescripCTA"/>
				<cfset etiquetas ="Nivel, Descripcion, Depende, Longitud, Conta, Presup, Desc"/>
        <cfelse>
        		<cfset desplegar ="PCNid, desc1, PCNlongitud, Conta, Presup,  DescripCTA"/>
				<cfset etiquetas ="Nivel, Descripcion, Longitud, Conta, Presup, Desc"/>        
       </cfif>
	   <cf_dbfunction name="OP_Concat" returnvariable = "_CAT">
	   <cf_dbfunction name="to_char" args="a.PCNid" returnvariable = "LvarPCNid">
			<cfinvoke  component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					PCNivelMascara a
						inner join PCEMascaras b
							on a.PCEMid = b.PCEMid  
						left outer join PCECatalogo c
							on a.PCEcatid = c.PCEcatid "/>
				<cfinvokeargument name="columnas" value="
				a.PCEMid, 
				a.PCNid, 
				a.PCEcatid, 
				a.PCNlongitud, a.PCNdep, 
				{fn concat(b.PCEMdesc ,{fn concat(' (' ,{fn concat(b.PCEMformato ,')' )})} )} as Mascara,
				a.PCNdescripcion as desc1,
				a.PCNdep as nivel
				,case when a.PCNcontabilidad = 1 then 'SI'
				else null
				end as Conta
				,case when a.PCNpresupuesto = 1 then 'SI'
				else null
				end as Presup,
                case when a.PCNDescripCta = 1 then
                    '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif'' onclick=''fnDesc(' #_CAT# #LvarPCNid# #_CAT# ', 0);''>'
                else 
                    '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif'' onclick=''fnDesc(' #_CAT# #LvarPCNid# #_CAT# ', 1);''>'
				end as DescripCTA
				"/>
                <cfinvokeargument name="desplegar" value="#desplegar#"/>
				<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
				<cfinvokeargument name="filtro" value="a.PCEMid = #form.PCEMid# order by a.PCNid"/>
				<cfinvokeargument name="align" value="left, left, left, left, center, center, center"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="formName" value="lista1"/>
				<cfinvokeargument name="keys" value="PCEMid,PCNid"/>
				<cfinvokeargument name="irA" value="MascarasCuentas.cfm"/>
				<cfinvokeargument name="PageIndex" value="321"/>
				<cfinvokeargument name="MaxRows" value="0"/>
			</cfinvoke>
			<script language="javascript">
				function fnDesc(PCNid, tipo)
				{
					<cfoutput>
					document.getElementById("ifrPCNid").src="SQLMascarasCuentas.cfm?id1=#form.PCEMid#&id2=" + PCNid + "&OP=" + tipo;
					</cfoutput>
				}
			</script>
			<iframe id="ifrPCNid" style="display:none;">
			</iframe>
		</td>
	</tr>
</table>
<!--- </fieldset> --->

<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	//cambiarMascara(document.form3.PCEMid.value);
	<cfif MODO EQ 'ALTA'>limpiarCatalogo();</cfif>
		
	//definicion del color de los campos con errores de validación para cualquier instancia de qforms
	qFormAPI.errorColor = "#FFFFCC";
	//instancias de qforms
	objForm = new qForm("form3");
	//descripciones de los campos para la validación de qforms
	objForm.PCEMid.description = "Máscara";
	objForm.PCNid.description = "Nivel";
	objForm.PCNlongitud.description = "Longitud";
	objForm.PCNdescripcion.description = "Descripcion";
	<cfif rsForm.PCEMplanCtas EQ 1>
		objForm.PCEcatid.description = "Catálogo";
		//objForm.PCNdep.description = "Depende";
	</cfif>
	//campos requeridos
	<cfif MODO NEQ 'ALTA'> objForm.PCNid.required = true; </cfif>	
	objForm.PCEMid.required = true;
	objForm.PCNlongitud.required = true;
	objForm.PCNdescripcion.required = true;
	<cfif rsForm.PCEMplanCtas EQ 1>
		cambiarCatalogo(document.form3.PCEcatid.value);
		objForm.PCEcatid.required = true;
		//objForm.PCNdep.required = true;
		cambiarDepende(document.form3.PCNdep.value);
	</cfif>
</script>
