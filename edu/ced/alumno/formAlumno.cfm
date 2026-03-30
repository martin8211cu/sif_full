
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 
<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 

<cfif isdefined("Url.modo") and not isdefined("Form.modo")>
	<cfparam name="Form.modo" default="#Url.modo#">
</cfif>			

<cfset modo = 'Alta'>
<cfif isdefined("Form.persona") and len(trim(form.persona))>
	<cfset modo = 'Cambio'>
</cfif>

<cfset GvarCambioPromocion = true>
<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select convert(varchar,a.persona) as persona, 
		       convert(varchar,a.CEcodigo) as CEcodigo, 
			   a.Pnombre, 
			   Papellido1, 
			   Papellido2, 
			   a.Ppais, 
			   b.Pnombre, 
			   a.TIcodigo, 
			   TInombre, 
			   Pid, 
			   convert(varchar,Pnacimiento,103) as Pnacimiento, 
			   Psexo, 
			   Pemail1, 
			   Pemail2, 
			   Pdireccion, 
			   Pcasa, 
			   Pfoto, 
			   PfotoType, 
			   PfotoName, 
			   Pemail1validado, 
			   convert(varchar,d.PRcodigo) as PRcodigo, 
			   Aretirado,
			   d.CEcontrato,
			   isnull(Gdescripcion,'sin grado asociado') as Gdescripcion,
			   e.autorizado,
			   (select count(1) from Curso cu
			    inner join AlumnoCalificacionCurso ac
				   on ac.Ccodigo  = cu.Ccodigo
				  and ac.CEcodigo = cu.CEcodigo
			     where ac.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				   and ac.Ecodigo  = e.Ecodigo
				   and cu.SPEcodigo = f.SPEcodigo
				   and cu.PEcodigo  = f.PEcodigo
				) as CursosMatriculados
		from PersonaEducativo a
		inner join Alumnos d
		   on a.persona = d.persona
		inner join Estudiante e
		   on d.Ecodigo = e.Ecodigo
		inner join Promocion f
		   on d.PRcodigo = f.PRcodigo
		inner join Grado g
		   on f.Gcodigo = g.Gcodigo
		inner join Pais b
		   on a.Ppais = b.Ppais
		inner join TipoIdentificacion c
		   on a.TIcodigo = c.TIcodigo
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>
	
	<cfset GvarCambioPromocion = rsForm.CursosMatriculados EQ 0>

	<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" por si se retira o no --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsform_Ecodigo">
		Select convert(varchar,a.Ecodigo) as Ecodigo
		from Alumnos a
		inner join Estudiante b
		   on a.persona=b.persona
		  and a.Ecodigo=b.Ecodigo
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
	</cfquery>	
	<cfquery datasource="#Session.Edu.DSN#" name="rsEncargado">
		select convert(varchar,a.EEcodigo) as EEcodigo, convert(varchar,e.persona) as persona , 
		convert(varchar,a.CEcodigo) as CEcodigo, 
		convert(varchar,a.Ecodigo) as Ecodigo,
		(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as Nombre,
		Pid
		from EncargadoEstudiante a
		inner join Alumnos b
		   on a.CEcodigo = b.CEcodigo
		  and a.Ecodigo = b.Ecodigo
		  and b.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		inner join Estudiante c
		   on b.Ecodigo = c.Ecodigo
		inner join Encargado d
		   on a.EEcodigo = d.EEcodigo 
		inner join PersonaEducativo e
		  on d.persona = e.persona
		where a.CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  order by Nombre
	</cfquery>	
	
</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsContratos">
select distinct rtrim(ltrim(CEcontrato)) as CEcontrato
from Alumnos 
where  CEcontrato is not null
 and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromo">
	select convert(varchar,PRcodigo) as PRcodigo,(PRdescripcion + ': ' + Gdescripcion) as PRdescripcion 
	from Nivel b
	inner join Grado c
	   on b.Ncodigo = c.Ncodigo
	inner join Promocion a
	   on a.Gcodigo = c.Gcodigo
	  and a.Ncodigo = c.Ncodigo
	  and a.PRactivo = 1
	where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	order by b.Norden,c.Gorden,a.PRcodigo
</cfquery>


<!--- ------------------------------------------------------------------------------- --->

<form action="SQLAlumno.cfm" method="post" name="form1" enctype="multipart/form-data">
	<cfoutput>
		<input name="persona" id="persona" value="<cfif isdefined("Form.persona")>#form.persona#</cfif>"  type="hidden"> 
		<input name="tab" type="hidden"  value="<cfif isdefined("Form.tab")>#Form.tab#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<cfif modo NEQ 'ALTA'>
		<input name="hayEncargado" id="hayEncargado" value="<cfif rsEncargado.RecordCount NEQ 0>#rsEncargado.RecordCount#></cfif>" type="hidden">
		<input name="EEcodigo" id="EEcodigo" value="<cfif rsEncargado.RecordCount NEQ 0>#rsEncargado.EEcodigo#</cfif>" type="hidden">
		<input name="Nombre" id="Nombre" value="<cfif rsEncargado.RecordCount NEQ 0>#rsEncargado.Nombre#</cfif>" type="hidden">
	</cfif>
	<input name="form_Ecodigo" id="form_Ecodigo" value="<cfif modo NEQ 'ALTA'>#rsform_Ecodigo.Ecodigo#</cfif>" type="hidden">
	<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.Filtro_Estado")>
		<input type="hidden" name="Filtro_Estado" value="#Form.Filtro_Estado#">
	</cfif>		   
	<cfif isdefined("Form.Filtro_Grado")>
		<input type="hidden" name="Filtro_Grado" value="#Form.Filtro_Grado#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Ndescripcion")>
		<input type="hidden" name="Filtro_Ndescripcion" value="#Form.Filtro_Ndescripcion#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Nombre")>
		<input type="hidden" name="Filtro_Nombre" value="#Form.Filtro_Nombre#">
	</cfif>
	<cfif isdefined("Form.Filtro_Pid")>
		<input type="hidden" name="Filtro_Pid" value="#Form.Filtro_Pid#">
	</cfif>
	<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
		  		  
	</cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="2">
		<cfoutput>
    	<cfif modo EQ 'CAMBIO'>
			<tr><td colspan="5" class="tituloAlterno">Modificaci&oacute;n de Alumno </td></tr>
			<tr><td colspan="5" class="tituloAlterno">Grado: <cfoutput>#rsForm.Gdescripcion#</cfoutput></td></tr>
        <cfelse>
        	<tr><td colspan="5" class="tituloAlterno">Ingreso de Alumno </td></tr>
        </cfif>
		<tr> 
			<td  width="25%" valign="middle" align="center"rowspan="13"> 
				<table width="108" height="159" border="1">
             		<tr> 
                		<td width="102" align="center" valign="top"> 
							<cfif modo NEQ 'ALTA'>
                    			<cfif Len(rsForm.Pfoto) EQ 0>Fotograf&iacute;a no disponible 
                      			<cfelse>
									<cf_LoadImage tabla="PersonaEducativo" columnas="Pfoto as contenido, persona as codigo" condicion="persona=#rsForm.persona#" imgname="Foto" width="109" height="154" alt="#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#">
                   		 		</cfif>
                    		<cfelse>Fotograf&iacute;a </cfif> 
						</td>
              		</tr>
            	</table>
			</td>
			<td><strong>Nombre</strong></td>
			<td><strong>Primer Apellido</strong></td>
			<td><strong>Segundo Apellido</strong></td>
		</tr>
		<tr>
			<td><input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.Pnombre#<cfelseif isdefined("form.Pnombre")>#form.Pnombre#</cfif>"></td>
			<td><input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.Papellido1#<cfelseif isdefined("form.Papellido1")>#form.Papellido1#</cfif>"></td>
			<td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.Papellido2#<cfelseif isdefined("form.Papellido2")>#form.Papellido2#</cfif>"></td>
		</tr>
		<tr>
			<td><strong>Identificaci&oacute;n</strong></td>
			<td><strong>Tipo Identificaci&oacute;n</strong></td>
			<td><strong>Ruta de Imagen</strong></td>
		</tr>
		</cfoutput>
		<tr>
			<td><input name="Pid" type="text" id="Pid" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pid#</cfoutput></cfif>"></td>
          	<td>
				<select name="TIcodigo" id="TIcodigo" tabindex="1">
              		<cfoutput query="rsTipoIdentif"> 
                		<cfif modo EQ 'CAMBIO' and #rsForm.TIcodigo# EQ #rsTipoIdentif.TIcodigo#>
                  			<option value="#rsTipoIdentif.TIcodigo#" selected>#rsTipoIdentif.TInombre#</option>
                  		<cfelse>
                  			<option value="#rsTipoIdentif.TIcodigo#">#rsTipoIdentif.TInombre#</option>
                		</cfif>
              		</cfoutput>
				</select> 
			</td>
			<td><input type="file" name="Pfoto"  tabindex="1"></td>
		</tr>
		<tr>
			<td><strong>Fecha de Nacimiento</strong></font></td>
			<td><strong>Sexo</strong></td>
			<td><strong>Pa&iacute;s</strong></td>
		</tr>
		<tr>
			<td>
				<cfif isdefined('rsForm')><cfset fecha= rsForm.Pnacimiento><cfelse><cfset fecha= LSDateFormat(Now(),'dd/mm/yyyy')></cfif>
				<cf_sifcalendario name="Pnacimiento" value="#fecha#" tabindex="1">
			</td>
			<td>
				<select name="Psexo" id="Psexo" tabindex="1">
              		<option value="M" <cfif isdefined('rsForm') and rsForm.Psexo EQ 'M'>selected</cfif>>Masculino</option>
              		<option value="F" <cfif isdefined('rsForm') and rsForm.Psexo EQ 'F'>selected</cfif>>Femenino</option>
          		</select>
			</td>
			<td>
				<select name="Ppais" id="select" tabindex="1">
					<cfoutput query="rsPaises">
					<option value="#Ppais#" <cfif (modo EQ "CAMBIO" and rsForm.Ppais EQ rsPaises.Ppais) or (modo EQ "ALTA" and rsPaises.Ppais EQ "CR")>selected</cfif>>#Pnombre#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Tel&eacute;fono Casa</strong></td>
			<td colspan="2"><strong>Direcci&oacute;n*</strong></td>
		</tr>
		<cfoutput>
		<tr>
			<td><input name="Pcasa" type="text" id="Pcasa" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.Pcasa#<cfelseif isdefined("form.Pcasa")>#form.Pcasa#</cfif>"></td>
			<td colspan="2"><input name="Pdireccion" onFocus="this.select()" tabindex="1" type="text" id="Pdireccion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif>" size="70" maxlength="255"></td>
		</tr>
		<tr>
			<td><strong>Mail Principal</strong></td>
			<td colspan="2"><strong>Mail Secundario</strong></td>
		</tr>
		<tr>
			<td><input name="Pemail1" type="text" id="Pemail1" tabindex="1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail1#<cfelseif isdefined("form.Pemail1")>#form.Pemail1#</cfif>" size="30"></td>
			<td colspan="2"><input name="Pemail2" type="text" tabindex="1" id="Pemail22"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail2#<cfelseif isdefined("form.Pemail2")>#form.Pemail2#</cfif>" size="30"></td>
		</tr>
		<tr>
			<td><input name="Aretirado" type="checkbox" id="Aretirado" tabindex="1"  onClick="javascript: Retirar(this);" value="Aretirado" <cfif modo NEQ 'ALTA' and #rsForm.Aretirado# EQ '1'>checked</cfif>><label for="Aretirado">Retirado</label></td>
			<td colspan="2"><input name="autorizado" type="checkbox" id="autorizado" tabindex="1" value="1" <cfif modo NEQ 'ALTA' and rsForm.autorizado EQ '1'>checked<cfelseif modo EQ 'ALTA'>checked</cfif>><label for="autorizado">Autorizado</label></td>
		</tr>
		<tr>
			<td colspan="2"><strong>Promoci&oacute;n <cfif isdefined("rsForm")><cfoutput> (#rsForm.CursosMatriculados# cursos matriculados)</cfoutput></cfif></strong></td>
			<td><cfif modo NEQ "ALTA"><strong>Contrato</strong><cfelse>&nbsp;</cfif></td>
		</tr>
		</cfoutput>
		<tr>
			<td nowrap colspan="2">
				<select name="PRcodigo" id="select3" tabindex="1" 
					<cfif Not GvarCambioPromocion>
						onFocus="GvarIdx = this.selectedIndex";
						onChange="alert('Existen Cursos Matriculados para el alumno. Para cambiar la Promoción primero desmatricule al alumno con la opción:\n\tAdministracion del Centro de Estudios -> Alumnos -> Matrícula Individual -> Desmatricular.'); this.selectedIndex=GvarIdx;"
					</cfif>>
					<cfif modo NEQ "ALTA">
						<option value="-1">-- Crear Nuevo Contrato --</option>
					</cfif> 
					<cfoutput query="rsPromo"> 
						<option value="#rsPromo.PRcodigo#" <cfif modo EQ 'CAMBIO' and #rsForm.PRcodigo# EQ #rsPromo.PRcodigo#>selected</cfif>>#rsPromo.PRdescripcion#</option>
					</cfoutput>
				</select>
			</td>
			<td>
				<select name="CboCEcontrato" tabindex="1">
					<option value="0" selected>-- No Asignar Contrato --</option>
					<cfoutput query="rsContratos"> 
						<option value="#rsContratos.CEcontrato#" <cfif modo NEQ "ALTA" and #rsContratos.CEcontrato# EQ #rsForm.CEcontrato#>selected</cfif>>#rsContratos.CEcontrato#</option>
					</cfoutput> 
				</select>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4" align="center"><cf_botones modo=#modo# tabindex="1"></td></tr>
       
  </table>  
</form>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formAlumno.js">//</script> 

<cf_qforms> 
 
<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
	function deshabilitarValidacion() {
		objForm.Pnombre.required = false;
		objForm.Pid.required = false;	
		objForm.Papellido1.required = false;			
		objForm.Ppais.required = false;			
		objForm.PRcodigo.required = false;					
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Pnombre.required = true;
		objForm.Pid.required = true;
		objForm.Papellido1.required = true;								
		objForm.Ppais.required = true;			
		objForm.PRcodigo.required = true;							
	}	

//------------------------------------------------------------------------------------------							
function Retirar(obj) {
	 var msg = "Al retirar el alumno, que no tenga mas hermanos, tanto él como sus encargados, se les revoca el acceso al expediente estudiantil."+
		" Para rectivar nuevamente los usuarios, será necesario seguir el proceso de activar Alumnos Retirados. Desea retirarlo?"
	if (obj.checked == true) {	 
		if (confirm(msg)) {
			obj.checked = true;
		} else {
			 obj.checked = false;
		}
	}
}

//------------------------------------------------------------------------------------------							
	function  funcCambio(){
		habilitarValidacion();
	}

//------------------------------------------------------------------------------------------							
	function  funcBaja(){
		if(confirm('Desea borrar el registro?')){
			//deshabilitarValidacion();
			return true;
		}else{ return false;}
	}
	
	
//------------------------------------------------------------------------------------------							
	function __isTieneEncargado() {
		if (btnSelected("btnCambiar")) {
			// Valida que el Alumno tenga por lo menos un encargado.
			var msg = "";
			//alert(new Number(this.obj.form.hayEncargado.value));
			if (new Number(this.obj.form.hayEncargado.value) == 0 && new Number(this.obj.form.CboCEcontrato.value) != 0) {
				msg = msg + " Encargado (s)"
			}
			if (msg != "" && new Number(this.obj.form.CboCEcontrato.value) == -1){
				//if (new Number(this.obj.form.CboCEcontrato.value) != -1){
				//	this.error = "Usted no puede asignar el contrato No. '" + this.obj.form.CboCEcontrato.value + "' porque no tiene asociado (s): " + msg + ", por favor  asocie primero el encargado!";
				//}
				//else {
					this.error = "Usted no puede crear un nuevo contrato, porque no tiene asociado (s): " + msg + ", por favor  asocie primero el encargado!";			
				//}
				this.obj.form.CboCEcontrato.focus();
			}
		}
	}
//------------------------------------------------------------------------------------------						
	_addValidator("isTieneEncargado", __isTieneEncargado);
//------------------------------------------------------------------------------------------					
	<cfif modo EQ "ALTA">
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";
		objForm.PRcodigo.required = true;
		objForm.PRcodigo.description = "Promoción";		
	<cfelse>
		
		objForm.CboCEcontrato.required = true;
		objForm.CboCEcontrato.description = "contrato";
		objForm.CboCEcontrato.validateTieneEncargado();																	
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";																	
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";
		objForm.PRcodigo.required = true;
		objForm.PRcodigo.description = "Promoción";				
	</cfif> 
</script>
