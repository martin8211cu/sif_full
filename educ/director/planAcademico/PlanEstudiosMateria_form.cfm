<!--- Establecimiento del modoPE --->
<cfparam name="form.MPcodigo" default="">
<cfparam name="form.Mcodigo" default="">
<cfparam name="form.CILcodigo" default="#rsPES.CILcodigo#">

<cfif form.MPcodigo EQ "">
  <cfif form.Mcodigo EQ "">
	<cfset modoPE="ALTA">
  <cfelse>
	<cfset modoPE="ALTA_CAMBIO">
  </cfif>
<cfelse>
	<cfset modoPE="CAMBIO">
</cfif>

<!---      Consultas      --->
<cfquery name="rsMateria" datasource="#session.DSN#">
	<cfif modoPE EQ "ALTA">
	  select null as Mcodigo
	  		, PBLnombre
		    ,CILtipoCicloDuracion as MtipoCicloDuracion, NULL as MtipoCicloDuracion2
		from PlanEstudiosBloque pbl, 
			 CicloLectivo cil
	   where pbl.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
	     and pbl.PBLsecuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PBLsecuencia#">
	     and cil.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 and cil.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	<cfelseif modoPE EQ "ALTA_CAMBIO">
	  select m.Mcodigo, Mtipo, Mnombre, Mcreditos, MotrasCarreras, McursoLibre, Mactivo, Mcodificacion
	  		 ,Mcodificacion as MPcodificacion, Mnombre as MPnombre
		     ,PBLnombre
			 ,isnull (MtipoCicloDuracion, CILtipoCicloDuracion) as MtipoCicloDuracion, MtipoCicloDuracion as MtipoCicloDuracion2
		from Materia m, 
			 PlanEstudiosBloque pbl, 
			 CicloLectivo cil
	   where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	     and pbl.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
	     and pbl.PBLsecuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PBLsecuencia#">
		 and cil.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 and cil.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
	<cfelseif modoPE EQ "CAMBIO">
	  select  m.Mcodigo, m.Mtipo, 
	  			m.Mcodificacion,
				m.Mnombre, 
	  			case m.Mtipo
					when 'M' then m.Mcodificacion
					else mp.MPcodificacion
				end as MPcodificacion, 
	  			case m.Mtipo
					when 'M' then m.Mnombre
					else mp.MPnombre
				end as MPnombre, 
				m.Mcreditos, m.MotrasCarreras, m.McursoLibre, m.Mactivo
			 ,PBLnombre
			 ,isnull (MtipoCicloDuracion, CILtipoCicloDuracion) as MtipoCicloDuracion, MtipoCicloDuracion as MtipoCicloDuracion2
		from MateriaPlan mp, Materia m, 
			 PlanEstudiosBloque pbl, 
			 PlanEstudios pes, CicloLectivo cil
	   where mp.MPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MPcodigo#">
	     and m.Mcodigo = mp.Mcodigo
	     and pbl.PEScodigo = mp.PEScodigo
	     and pbl.PBLsecuencia = mp.PBLsecuencia
	     and pes.PEScodigo = mp.PEScodigo
		 and cil.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 and cil.CILcodigo = pes.CILcodigo
	</cfif>
</cfquery>
 
<cfquery name="qryCarrera" datasource="#Session.DSN#">
	Select CARcodificacion
	from Carrera
	where CARcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CARcodigo#">
</cfquery>

<cfif modoPE EQ 'ALTA'>
	<cfquery name="qryCodificacion" datasource="#Session.DSN#">
		Select Mcodificacion
		from Materia
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
		order by Mcodificacion
	</cfquery>
</cfif>

<cfquery name="qryQuitarMaterias" datasource="#Session.DSN#">
	Select mp.Mcodigo
		, mp.PBLsecuencia
	from MateriaPlan mp
		, Materia m
		, PlanEstudiosBloque peb
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
		and mp.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
		and Mtipo != 'E'
<!--- 		and mp.PBLsecuencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PBLsecuencia#">		 --->
		and mp.Mcodigo=m.Mcodigo
		and mp.PEScodigo = peb.PEScodigo
		and mp.PBLsecuencia=peb.PBLsecuencia
</cfquery>


<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>
<form action="" method="post" name="formMP" onSubmit="return valida(this);" style="boder:none;">

 <cfoutput> 
  <input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
  <input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
  <input name="CILcodigo" type="hidden" value="#form.CILcodigo#">    
  <input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">   
  <input name="MPcodigo" type="hidden" value="#form.MPcodigo#">    
  <input name="modo" type="hidden" value="#iif(isdefined("form.modo"),"form.modo","'CAMBIO'")#">  
  <input name="nivel" type="hidden" value="2">  
  <input name="TabsPlan" type="hidden" value="3">
  <cfif rsMateria.Mcodigo NEQ "">
  	<cfset form.Mcodigo = rsMateria.Mcodigo>
  </cfif>
  
  
  <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
    <tr> 
      <td class="tituloMantenimiento" colspan="3" align="center">
		<cfif modoPE EQ "ALTA">
		  Agregar una Materia Nueva al Plan
		<cfelseif modoPE EQ "ALTA_CAMBIO">
		  Incluir una Materia Existente al Plan
		<cfelseif modoPE EQ "CAMBIO">
		  Modificar la Materia en el Plan
		</cfif>
       </td>
    </tr>

      <tr> 
        <td align="right" nowrap> <strong>Bloque #form.PBLsecuencia#:</strong></td>
        <td align="left">#rsMateria.PBLnombre#</td>
      </tr>
      <tr> 
        <td align="right" nowrap> <strong>Tipo Materia:</strong></td>
        <td align="left"> 
			<select name="Mtipo" id="Mtipo" tabindex="2" <cfif modoPE NEQ 'ALTA'> disabled</cfif>
					onchange="javascript: cambioTipoMateria(this);">
            	<option value="M" <cfif modoPE NEQ 'ALTA' and rsMateria.Mtipo EQ 'M'> selected</cfif>>Regular</option>
            	<option value="E" <cfif modoPE NEQ 'ALTA' and rsMateria.Mtipo EQ 'E'> selected</cfif>>Electiva</option>
        	</select>
			<input type="hidden" name="T" value="<cfif modoPE NEQ 'ALTA'>#rsMateria.Mtipo#</cfif>">
		</td>
      </tr>
      <tr> 
        <td align="right" nowrap> <strong>C&oacute;digo Materia:</strong></td>
        <td align="left" nowrap> 
			<input name="Mcodigo" type="hidden" value="<cfif modoPE NEQ "ALTA">#form.Mcodigo#</cfif>">
			
			<input name="Mcodificacion" <cfif modoPE NEQ "ALTA"> class="cajasinborde" readonly="true"</cfif> type="text" id="Mcodificacion" value="<cfif modoPE NEQ "ALTA">#rsMateria.Mcodificacion#<cfelseif isdefined('qryCarrera')>#qryCarrera.CARcodificacion#</cfif>" size="15" maxlength="15" alt="El c&oacute;digo de la materia">
			<cfif modoPE EQ "ALTA">
			<a href="javascript: doConlisMat();" tabindex="-1"><img src="/cfmx/educ/imagenes/Description.gif" alt="Seleccionar una materia existente" name="imagen" width="18" height="14" border="0" align="absmiddle"> Seleccionar una materia existente</a>
			</cfif>
		</td>
      </tr>
      <tr> 
        <td align="right" nowrap> <strong>Nombre:</strong></td>
        <td align="left"> <input name="Mnombre" <cfif modoPE NEQ "ALTA">  class="cajasinborde" readonly="true"</cfif> type="text" value="<cfif modoPE NEQ "ALTA">#rsMateria.Mnombre#</cfif>" size="50" maxlength="50" alt="La descripci&oacute;n de la Materia"> 
        </td>
      </tr>
	  <tr id="verParaElectivas1"> 
		<td align="right" nowrap> <strong>C&oacute;digo Materia en Plan:</strong></td>
		<td align="left" nowrap> 
			<input name="MPcodificacion" 
					<cfif modoPE NEQ "ALTA" AND isdefined ("rsMateria.Mtipo") AND rsMateria.Mtipo NEQ 'E'>  class="cajasinborde" readonly="true"</cfif>
					type="text" id="MPcodificacion" value="<cfif modoPE NEQ "ALTA">#rsMateria.MPcodificacion#</cfif>" size="15" maxlength="15" alt="El c&oacute;digo de la materia en el plan">
		</td>
	  </tr>
	  <tr id="verParaElectivas2">
		<td align="right" nowrap> <strong>Nombre en Plan:</strong></td>
		<td align="left"> <input name="MPnombre" type="text" 
				<cfif modoPE NEQ "ALTA" AND isdefined ("rsMateria.Mtipo") AND rsMateria.Mtipo NEQ 'E'>  class="cajasinborde" readonly="true"</cfif>
				value="<cfif modoPE NEQ "ALTA">#rsMateria.MPnombre#</cfif>" size="50" maxlength="50" alt="La descripci&oacute;n de la Materia en el plan"> 
		</td>
	  </tr>
	  <tr id="verCreditos">
		<td align="right" nowrap> <strong>Cr&eacute;ditos:</strong></td>
		<td align="left"> 
			<cfif modoPE EQ "ALTA">  
				<input name="Mcreditos" style="text-align: right;" type="text" id="Mcreditos" size="5" maxlength="2" value="0" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); poneCero(this);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 			 
			<cfelse>
				<input name="Mcreditos" class="cajasinborde"  readonly="true" style="text-align: right;" type="text" id="Mcreditos" size="5" maxlength="2" value="#rsMateria.Mcreditos#"> 			 			
			</cfif>
		</td>
	  </tr>
    </cfoutput> 
    <tr> 
      <td align="center" colspan="3"> 
			<input type="hidden" name="botonSel" value="">
			<cfif form.MPcodigo EQ ""> 
			<!--- Agregando una Materia al Plan --->
				<cfif form.Mcodigo EQ "">
				<!--- Agregando una Materia Nueva --->
					<input type="submit" name="btnMPagregar" value="Agregar" 
							onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); this.form.action='PlanEstudiosBloques_SQL.cfm';">
				<cfelse>
				<!--- Incluyendo una Materia Existente --->
					<input type="submit" name="btnMPincluir" value="Incluir" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); this.form.action='PlanEstudiosBloques_SQL.cfm';">
				</cfif>
			<cfelse>	
				<input type="submit" name="btnMPcambiar" value="Cambiar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); this.form.action='PlanEstudiosBloques_SQL.cfm';">
				<input type="submit" name="btnMPIrMateria" value="Ir a Materia" onClick="javascript: this.form.action = ''; if (window.deshabilitarValidacion) deshabilitarValidacion(); this.form.modo.value='MPcambioE';">
			</cfif>
			<input type="submit" name="btnMPlimpiar" value="Limpiar" onClick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); this.form.botonSel.value = this.name; this.form.Mcodigo.value='';">		
			<input type="submit" name="btnMPlista" value="Ir a Lista" onClick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); this.form.botonSel.value = this.name; this.form.modo.value='CAMBIO';">		
		</td>
    </tr>
  </table>
</form>  
<iframe name="frame_QRYmateria" id="frame_QRYmateria" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

<script language="JavaScript" type="text/javascript">

	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//---------------------------------------------------------------------------------------		
	function validaCodificacion(){
		if(btnSelected('btnMPagregar',document.formMP)){
			if(document.formMP.Mcodificacion.value != '') {
				if(document.formMP.Mcodificacion.value == "<cfoutput>#qryCarrera.CARcodificacion#</cfoutput>"){
					alert('Error, el código de la materia debe ser diferente que el c[odigo de la Carrera');
					document.formMP.Mcodificacion.focus();
					return false;
				}else{
					var existeMcodific = false;
					var ordenList = "";
					<cfif isdefined('qryCodificacion')>
						ordenList = "<cfoutput>#ValueList(qryCodificacion.Mcodificacion,'~')#</cfoutput>"
					</cfif>
					
					var ordenArray = ordenList.split("~");
					for (var i=0; i<ordenArray.length; i++) {
						<cfif modoPE NEQ "ALTA">
							if ((ordenArray[i] == document.formMP.Mcodificacion.value) && (ordenArray[i] != '<cfoutput>#rsMateria.Mcodificacion#</cfoutput>')) {
						<cfelse>
							if (ordenArray[i] == document.formMP.Mcodificacion.value) {
						</cfif>
							existeMcodific = true;
							break;
						}
					}
					if (existeMcodific){
						alert('Error, el código de la materia ya existe, favor digitar uno diferente');
						document.formMP.Mcodificacion.focus();
						return false;
					}
				}
			}
		}
		
		return true;
	}	
//---------------------------------------------------------------------------------------			
		function cambioTipoMateria(obj) {
			obj.form.T.value = obj.value;
			var connverParaElectivas1= document.getElementById("verParaElectivas1");
			var connverParaElectivas2= document.getElementById("verParaElectivas2");
			var connverCreditos= document.getElementById("verCreditos");			
			
			
			if (obj.value == 'M'){	//Regular
				connverParaElectivas1.style.display = "none";
				connverParaElectivas2.style.display = "none";				
				connverCreditos.style.display = "";								
			}else{					// Electiva
				connverParaElectivas1.style.display = "";
				connverParaElectivas2.style.display = "";
				connverCreditos.style.display = "none";								
			}
		}
//---------------------------------------------------------------------------------------		
	function poneCero(obj){
		if(obj.value == '')
			obj.value = 0;
	}		
//---------------------------------------------------------------------------------------					
	botonActual = "";
	
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//---------------------------------------------------------------------------------------		
	function abreConlisMat(){	
		var params ="";
		var codQuitar = "<cfoutput>#ValueList(qryQuitarMaterias.Mcodigo,',')#</cfoutput>";			
		
		params = "?form=formMP&cod=Mcodigo&quitar=" + codQuitar + "&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/director/planAcademico/ConlisMateriasRequisitos.cfm"+params,250,200,650,400);
	}
//---------------------------------------------------------------------------------------	
	function doConlisMat(){
		var params ="";
		var codQuitar = "<cfoutput>#ValueList(qryQuitarMaterias.Mcodigo,',')#</cfoutput>";		
		
		if(document.formMP.Mcodificacion.value != ''){
			params = "&cod=Mcodigo&name=Mcodificacion&desc=Mnombre&conexion=<cfoutput>#session.DSN#</cfoutput>&quitar=" + codQuitar;
			var fr = document.getElementById("frame_QRYmateria");
			
			fr.src = "/cfmx/educ/director/planAcademico/QueryMaterias.cfm?dato="+document.formMP.Mcodificacion.value+"&form=formMP"+params;
		}else{
			params = "?form=formMP&cod=Mcodigo&tipo=" + document.formMP.Mtipo.value + "&quitar=" + codQuitar + "&conexion=<cfoutput>#session.DSN#</cfoutput>";
			popUpWindow("/cfmx/educ/director/planAcademico/ConlisMateriasRequisitos.cfm"+params,250,200,650,400);
		}
	}
//---------------------------------------------------------------------------------	
	function valida(f){
		f.Mtipo.disabled = false;
		<cfif modoPE EQ 'ALTA'>
			if(btnSelected('btnMPagregar',document.formMP)){
				if(f.Mcodificacion.value != '') {
					var existeMcodific = false;
	
					var ordenList = "<cfoutput>#ValueList(qryCodificacion.Mcodificacion,'~')#</cfoutput>"
					var ordenArray = ordenList.split("~");
					for (var i=0; i<ordenArray.length; i++) {
						if (ordenArray[i] == f.Mcodificacion.value) {
							existeMcodific = true;
							break;
						}
					}
					if (existeMcodific){
						alert('Error, el código de la materia ya existe, favor digitar uno diferente');
						f.Mcodificacion.focus();
						return false;
					}
				}
			}
			
			if(!validaCodificacion())
				return false;
		</cfif>
		return true;
	}
//---------------------------------------------------------------------------------------		
	function poneCero(obj){
		if(obj.value == '')
			obj.value = 0;
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.Mtipo.required = false;
		objForm.Mnombre.required = false;
		objForm.Mcodificacion.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Mtipo.required = true;
		objForm.Mnombre.required = true;
		objForm.Mcodificacion.required = true;	
	}
//---------------------------------------------------------------------------------------	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formMP");
//---------------------------------------------------------------------------------------
	objForm.Mtipo.required = true;
	objForm.Mtipo.description = "Tipo de la materia ";	
	objForm.Mcodificacion.required = true;
	objForm.Mcodificacion.description = "Código de la materia ";	
	objForm.Mnombre.required = true;
	objForm.Mnombre.description = "Nombre de la materia ";
	
	cambioTipoMateria(document.formMP.Mtipo);	
</script>