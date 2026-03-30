<style type="text/css">
<!--
.subtitulo_seccion_small {
	font-size: 12px;
	font-weight: bold;
	color: #FFFFFF; 
	background-color:#CCCCCC;
}
-->
</style>



<cfif isdefined("Form.Eid") and form.Eid NEQ ''>  
  <cfset modo="CAMBIO">
<cfelse>  
    <cfset modo="ALTA">
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select e.EEid, Eid, Edescripcion,Efechaanterior,Efecha,e.ts_rversion
		from Encuesta e
			inner join EncuestaEmpresa ee
				on e.EEid=ee.EEid
		where Eid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
	</cfquery>
	<cfif isdefined('rsForm') and rsForm.recordCount GT 0>
		<cfquery name="rsTipoOrga" datasource="#session.DSN#" maxrows="1">
			Select ETid
			from EncuestaSalarios
			where EEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EEid#">	
				and Eid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">	
		</cfquery>
	</cfif>
</cfif>

<cfquery name="rsEmpresasOrga" datasource="#session.DSN#">
	Select ee.EEid,(EEcodigo || '--' || EEnombre) as nombre,ETid,ETdescripcion
	from EncuestaEmpresa ee
		inner join EmpresaOrganizacion eo
			on eo.EEid=ee.EEid
	order by ee.EEid
</cfquery>

<cfquery name="rsEncuestadoras" dbtype="query">
	Select distinct EEid,nombre
	from rsEmpresasOrga
</cfquery>

<form method="post" name="formEncuesta" action="Encuesta-sql.cfm" onSubmit="javascript: return validaEnc(this);" style="margin: '0'">
	<input type="image" id="imgDel" src='/cfmx/rh/imagenes/Borrar01_S.gif' title="Eliminar" style="display:none;">
	<cfoutput>
		<cfif modo neq "ALTA">
			<input type="hidden" name="Eid" value="#rsform.Eid#">
			<cfset ts = "">	
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>

		<cfset orga = '' >
		<cfif modo neq 'ALTA' and isdefined('rsTipoOrga') and rsTipoOrga.recordCount GT 0>
			<cfset orga = rsTipoOrga.ETid >
		</cfif>		
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="17%" nowrap align="right"><strong>Empresa Encuestadora:</strong></td>
            <td width="38%"><select name="EEid" onChange="javascript: cambioEmpresa(this,'#orga#')">
              <cfloop query="rsEncuestadoras">
                <option value="#EEid#" <cfif modo NEQ 'ALTA' and rsForm.EEid EQ rsEncuestadoras.EEid> selected</cfif>>#nombre#</option>
              </cfloop>
            </select></td>
            <td width="45%" rowspan="5" valign="top" align="center">
				<cfif modo NEQ 'ALTA'>
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select distinct Moneda, Mnombre, Miso4217
						from EncuestaSalarios es
							inner join Monedas m
								on Mcodigo=Moneda
						where Eid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">	
					</cfquery>
					<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
						<table width="100%"  border="0" cellpadding="0" cellspacing="0">
							  <tr>
								<td colspan="2" class="subtitulo_seccion_small">Monedas Seleccionadas</td>
							  </tr>						
							<cfloop query="rsMonedas">
							  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
								<td>#Mnombre#</td>
								<td>#Miso4217#</td>
							  </tr>
							</cfloop>
						</table>
					</cfif>
				<cfelse>
					<fieldset><legend></legend>
						<table id="tblMoneda" width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td class="subtitulo_seccion_small" colspan="4">Monedas</td>
						  </tr>
						  <tr>
							<td width="4%">&nbsp;</td>
							<td width="17%" align="right"><strong>Moneda:</strong>&nbsp;&nbsp;&nbsp;</td>
							<td width="38%" nowrap>
								<cf_sifmonedas form="formEncuesta" Conlis="S">
							</td>
							<td width="41%" nowrap align="left">
								<input type="hidden" name="LastOneMoneda" id="LastOneMoneda" value="">
								&nbsp;<input type="button" name="agregarMoneda" onClick="javascript:if (window.fnNuevaMoneda) fnNuevaMoneda();" value="+" tabindex="4">
							</td>
						  </tr>
						  <tbody>
						  </tbody>
						  <tr><td>&nbsp;</td></tr>
						  <tr><td>&nbsp;</td></tr>
						</table>
					</fieldset>
				</cfif>
			</td>
          </tr>
          <tr>
            <td align="right"><strong>Tipos de Organizaci&oacute;n:</strong></td>
            <td><select name="ETid">
            </select></td>
          </tr>
          <tr>
            <td align="right"><strong>Fecha:</strong></td>
            <td>
				<cfif modo NEQ 'ALTA'>
					<cf_sifcalendario form="formEncuesta" value="#LSDateFormat(rsForm.Efecha,'dd/mm/yyyy')#" name="Efecha">	
				<cfelse>
					<cf_sifcalendario form="formEncuesta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="Efecha">	
				</cfif>			
			</td>
          </tr>
          <tr>
            <td align="right"><strong>Fecha Anterior:</strong></td>
            <td>
				<cfif modo NEQ 'ALTA'>
					<cf_sifcalendario form="formEncuesta" value="#LSDateFormat(rsForm.Efechaanterior,'dd/mm/yyyy')#" name="Efechaanterior">	
				<cfelse>
					<cf_sifcalendario form="formEncuesta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="Efechaanterior">	
				</cfif>			
			</td>
          </tr>
          <tr>
            <td align="right"><strong>Descripción:</strong></td>
            <td><input type="text" name="Edescripcion" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.Edescripcion#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  ></td>
          </tr>
          <tr>
            <td colspan="3" align="center" valign="baseline">
				<cfif modo NEQ 'ALTA'>
					<cf_botones modo="#modo#" include="Siguiente">
				<cfelse>
					<cf_botones modo="#modo#" exclude="Limpiar">
				</cfif>				
			</td>
          </tr>
        </table>		
	</cfoutput>		   
</form>

<cf_qforms form="formEncuesta" objForm="objformEncuesta">

<script language="JavaScript">	
	objformEncuesta.EEid.required = true;
	objformEncuesta.EEid.description="Empresa Encuestadora";
	objformEncuesta.ETid.required = true;
	objformEncuesta.ETid.description="Tipo de Organizaci&oacute;n";	
	objformEncuesta.Edescripcion.required = true;
	objformEncuesta.Edescripcion.description="Descripción de la Encuesta";
	objformEncuesta.Efecha.required = true;
	objformEncuesta.Efecha.description="Fecha";
	var vnContadorListas = 0;
	
	function validaEnc(f){
		if(vnContadorListas == 0){
			if (document.formEncuesta.botonSel.value != 'Cambio' && document.formEncuesta.botonSel.value != 'Baja' && document.formEncuesta.botonSel.value != 'Nuevo' ){		
				alert('Error, debe seleccionar al menos una moneda');
				return false;
			}
		}
	
		return true;
	}
	
	function habilitarValidacion(){
		objformEncuesta.EEid.required = true;
		objformEncuesta.ETid.required = true;
		objformEncuesta.Edescripcion.required = true;
		objformEncuesta.Efecha.required = true;
	}
		
	function deshabilitarValidacion(){
		if (document.formEncuesta.botonSel.value == 'Baja' || document.formEncuesta.botonSel.value == 'Nuevo' ){
			objformEncuesta.EEid.required = false;
			objformEncuesta.ETid.required = false;
			objformEncuesta.Edescripcion.required = false;
			objformEncuesta.Efecha.required = false;
		}
	}	

	function cambioEmpresa( cb, selected ) {		
		if ( cb.value != "" ) {
			i = 0;
			<cfoutput query="rsEmpresasOrga">
				if ( #Trim(rsEmpresasOrga.EEid)# == cb.value ){
					document.formEncuesta.ETid.length = i+1;
					document.formEncuesta.ETid.options[i].value = '#rsEmpresasOrga.ETid#';
					document.formEncuesta.ETid.options[i].text  = '#rsEmpresasOrga.ETdescripcion#';
					
					if ( selected != '' && selected == #Trim(rsEmpresasOrga.ETid)# )
						document.formEncuesta.ETid.options[i].selected=true; 	
					
					i++;
				}

			</cfoutput>
			return;			
		}
	}		

	function fnNuevaMoneda(){
	  if (document.formEncuesta.Mcodigo.value != ''){
	  	vnContadorListas = vnContadorListas + 1;
	  }
	  
	  var LvarTable = document.getElementById("tblMoneda");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");
	  
	  var Lclass 	= document.formEncuesta.LastOneMoneda;
	  var p1 		= document.formEncuesta.Mcodigo.value.toString();//cod
	  var p2 		= document.formEncuesta.Mnombre.value;//desc

	  document.formEncuesta.Mcodigo.value="";
	  document.formEncuesta.Miso4217.value="";
	  document.formEncuesta.Mnombre.value="";

	  // Valida no agregar vacíos
	  if (p1=="") return;
	  
	  // Valida no agregar repetidos
	  if (existeMoneda(p1)) {alert('Esta Moneda ya fue agregada.');return;}
  	  
	  // Agrega Columna 0
	  sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "MonedaIdList");

	  // Agrega Columna 1
	  sbAgregaTdText  (LvarTR, Lclass.value, p2);
	  	
	  // Agrega Evento de borrado en Columna 2
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);
	
	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);
	  
	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}	

	//Función para agregar TDs con Objetos
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
	  var LvarTD    = document.createElement("TD");
	
	  var LvarInp   = document.createElement("INPUT");
	  LvarInp.type = LprmType;
	  if (LprmName!="") LvarInp.name = LprmName;
	  if (LprmValue!="") LvarInp.value = LprmValue;
	  LvarTD.appendChild(LvarInp);
	  if (LprmClass!="") LvarTD.className = LprmClass;
	  GvarNewTD = LvarTD;
	  LprmTR.appendChild(LvarTD);
	}
	
	//Función para agregar Imagenes
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
	  // Copia una imagen existente
	  var LvarTDimg    = document.createElement("TD");
	  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
	  LvarImg.style.display="";
	  LvarImg.align=align;
	  LvarTDimg.appendChild(LvarImg);
	  if (LprmClass != "") LvarTDimg.className = LprmClass;
	
	  GvarNewTD = LvarTDimg;
	  LprmTR.appendChild(LvarTDimg);
	}	
	
	//Función para eliminar TRs
	function sbEliminarTR(e){
	  vnContadorListas = vnContadorListas - 1;
	  
	  var LvarTR;

	  if (document.all)
		LvarTR = e.srcElement;
	  else
		LvarTR = e.currentTarget;
	
	  while (LvarTR.name != "XXXXX")
		LvarTR = LvarTR.parentNode;
		
	  LvarTR.parentNode.removeChild(LvarTR);
	}	
	
	//Función para agregar TDs con texto
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
	  var LvarTD    = document.createElement("TD");
	
	  var LvarTxt   = document.createTextNode(LprmValue);
	  LvarTD.appendChild(LvarTxt);
	  if (LprmClass!="") LvarTD.className = LprmClass;

	  GvarNewTD = LvarTD;

	  LvarTD.noWrap = true;
	  LprmTR.appendChild(LvarTD);
	}	
	
	function existeMoneda(v){
		var LvarTable = document.getElementById("tblMoneda");
		for (var i=0; i<LvarTable.rows.length; i++){

			var value = new String(fnTdValue(LvarTable.rows[i]));
			
			var data = value.split('|');
			
			if (data[0] == v){
				return true;
			}
		}
		return false;
	}	
	
	function fnTdValue(LprmNode){
	  var LvarNode = LprmNode;
	
	  while (LvarNode.hasChildNodes()){
		LvarNode = LvarNode.firstChild;
		if (document.all == null){
		  if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes())
			LvarNode = LvarNode.nextSibling;
		}
	  }
	  if (LvarNode.value)
		return LvarNode.value;
	  else
		return LvarNode.nodeValue;
	}	

	cambioEmpresa(document.formEncuesta.EEid,'<cfoutput>#orga#</cfoutput>');
	
</script>