<cfparam name="url.id_persona" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona =
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
</cfquery>

<cfquery datasource="#session.dsn#" name="entrada">
	select 
		e.id_programa, e.id_vigencia,
		p.nombre_programa, v.nombre_vigencia,
		v.fecha_desde, v.fecha_hasta, e.codigo_barras, e.fila, e.asiento
	from sa_entrada e
		join sa_afiliaciones a
			on  e.id_programa = a.id_programa
			and e.id_vigencia = a.id_vigencia
		join sa_vigencia v
			on  a.id_programa = v.id_programa
			and a.id_vigencia = v.id_vigencia
			and e.id_programa = v.id_programa
			and e.id_vigencia = v.id_vigencia
		join sa_programas p
			on  a.id_programa = p.id_programa
			and v.id_programa = p.id_programa
			and e.id_programa = p.id_programa
	where p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and a.id_persona  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) is 0#">
	  and e.id_persona  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) is 0#">
</cfquery>

	<!--- start of action=input --->
	<cfquery datasource="asp" name="rsPais">
		select Ppais, Pnombre
		from Pais
		order by Pnombre
	</cfquery>
	
	<cf_direccion action="select" key="#data.id_direccion#" name="userdata_direccion">

<cfoutput>
<script type="text/javascript" src="personas.js"></script>
<script type="text/javascript">
<!--
function funcAfiliaciones() {
	location.href='afiliar_paso1.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
	return false;
}
function funcFamiliares() {
	location.href='familiares.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
	return false;
}
function validar(formulario)
{
	var error_input;
	var error_msg = '';
	blur_cedula(formulario.Pid);
	// Validando tabla: sa_personas - sa_personas
	
	// Columna: Pnombre Nombre varchar(60)
	if (formulario.Pnombre.value == "") {
		error_msg += "\n - Nombre no puede quedar en blanco.";
		error_input = formulario.Pnombre;
	}
	// Columna: Papellido1 Primer Apellido varchar(60)
	if (formulario.Papellido1.value == "") {
		error_msg += "\n - Primer Apellido no puede quedar en blanco.";
		error_input = formulario.Papellido1;
	}
		
	// Validacion terminada
	if (error_msg != "") {
		alert("Por favor revise los siguiente datos:"+error_msg);
		error_input.focus();
		return false;
	}
	return true;
}
//-->
</script>
		<form action="sa_personas-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1" enctype="multipart/form-data">
			<table cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			  <!--DWLayoutTable-->
			<tr>
			  <td colspan="4" class="subTitulo">
			Datos Personales </td>
			  </tr>
			<tr>
			  <td valign="top">N&uacute;mero de C&eacute;dula</td>
			  <td valign="top">
Fecha de nacimiento				
			  </td>
			  <td valign="top">Sexo</td>

				<td rowspan="6" valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td>
						
							<cfif isdefined("url.id_persona") and len(trim(url.id_persona))>
								<cfquery datasource="#session.DSN#" name="imagents">
									select imagen, ts_rversion 
									from sa_imagenpersona
									where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
								</cfquery>
								<cfinvoke component="sif.Componentes.DButils"
										  method="toTimeStamp"
										  returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#imagents.ts_rversion#"/>
								</cfinvoke>
								<img src="/cfmx/hosting/afiliaciones/catalogos/personas/imagen_persona.cfm?id_persona=#url.id_persona#&ts=#tsurl#" height="100" border="0" id="new_image_loader" name="new_image_loader">
							</cfif>
						</td></tr>
				</table></td>
			</tr>

				<tr>
				  <td valign="top"><input name="Pid" id="Pid" type="text" style="width:135px" value="#HTMLEditFormat(data.Pid)#" 
						maxlength="60" onBlur="blur_cedula(this)"
						onFocus="this.select()"  ></td>
				  <td valign="top"><cf_sifcalendario form="form1" name="Pnacimiento" value="#DateFormat(data.Pnacimiento,'dd/mm/yyyy')#"></td>
				  <td valign="top"><select name="Psexo" id="Psexo" style="width:135px" >
                    <option value=""></option>
                    <option value="M" <cfif data.Psexo is 'M'>selected</cfif>>Masculino</option>
                    <option value="F" <cfif data.Psexo is 'F'>selected</cfif>>Femenino</option>
                  </select>
			      </td>
	          </tr>
				<tr><td valign="top">Nombre
				</td>
				  <td valign="top">Primer Apellido </td>
				  <td valign="top"> Segundo Apellido </td>
		        </tr>
				<tr>
				  <td valign="top"><input name="Pnombre" id="Pnombre" type="text" style="width:135px" value="#HTMLEditFormat(data.Pnombre)#" 
						maxlength="60"
						onFocus="this.select()"  ></td>
				  <td valign="top"><input name="Papellido1" id="Papellido1" type="text" style="width:135px" value="#HTMLEditFormat(data.Papellido1)#" 
						maxlength="60"
						onFocus="this.select()"  ></td>
				  <td valign="top"><input name="Papellido2" id="Papellido2" type="text" style="width:135px" value="#HTMLEditFormat(data.Papellido2)#" 
						maxlength="60"
						onfocus="this.select()"  >
                  </td>
	          </tr>

				<tr>
				  <td valign="top">Tel&eacute;fonos: Casa </td>
				  <td valign="top">Oficina</td>
				  <td valign="top"> Celular </td>
		        </tr>
				
				<tr><td valign="top"><input name="Pcasa" id="Pcasa" type="text" style="width:135px" value="#HTMLEditFormat(data.Pcasa)#" 
						maxlength="30"
						onFocus="this.select()"  ></td>
				  <td valign="top">			      <input name="Poficina" id="Poficina" type="text" style="width:135px" value="#HTMLEditFormat(data.Poficina)#" 
						maxlength="30"
						onFocus="this.select()"  ></td>
				  <td valign="top"><input name="Pcelular" id="Pcelular" type="text" style="width:135px" value="#HTMLEditFormat(data.Pcelular)#" 
						maxlength="30"
						onFocus="this.select()"  ></td>
		        </tr>
				<tr><td colspan="2" valign="top">Correo Electr&oacute;nico </td>
				  <td valign="top"> N&uacute;mero de fax </td>
			      <td valign="top">Seleccionar Foto</td>
				</tr>
				
				<tr><td colspan="2" align="left" nowrap><input name="Pemail1" type="text" style="width:284px" id="Pemail1"
						onFocus="this.select()" value="#HTMLEditFormat(data.Pemail1)#" size="60" 
						maxlength="60"  ></td>
				  <td valign="top"><input name="Pfax" id="Pfax" type="text" style="width:135px" value="#HTMLEditFormat(data.Pfax)#" 
						maxlength="30"
						onfocus="this.select()"  >
                  </td>
			      <td valign="top"><input type="file" name="foto"  onChange="(document.all?document.all.new_image_loader:document.getElementById('new_image_loader')).src = this.value"></td>
				</tr>
				<tr><td colspan="3"><!--DWLayoutEmptyCell-->&nbsp;</td>
			      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
				</tr>
	 
		    <tr align="left">
	      <td colspan="3" class="tituloListas">Direcci&oacute;n</td>
          <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		    </tr> 
	    <tr>
	      <td colspan="3" align="left" nowrap><input type="text" style="width:435px" name="direccion1" id="direccion1" onFocus="this.select()" size="60" maxlength="60" value="#userdata_direccion.direccion1#" ></td>
          <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td colspan="3" align="left" nowrap><input type="text" style="width:435px" name="direccion2" id="direccion2" onFocus="this.select()" size="60" maxlength="60"  value="#userdata_direccion.direccion2#"  ></td>
          <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td valign="top">Provincia</td>
	      <td align="left">Pa&iacute;s:&nbsp;</td>
	      <td align="left">&nbsp;</td>
	      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td valign="top"><input name="estado" type="text" style="width:135px" id="estado" onFocus="this.select()" value="#userdata_direccion.estado#" maxlength="30" ></td>
	      <td colspan="2" align="left"><select name="pais" id="pais" style="width:285px ">
            <cfloop query="rsPais">
              <option value="#rsPais.Ppais#" <cfif userdata_direccion.pais eq  rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
            </cfloop>
          </select></td>
          <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td align="left">Ciudad</td>
	      <td valign="top">C&oacute;digo Postal:&nbsp;</td>
          <td valign="top">&nbsp;</td>
	      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td align="left"><input name="ciudad" type="text" style="width:135px" id="ciudad" onFocus="this.select()" value="#userdata_direccion.ciudad#" maxlength="30" ></td>
	      <td valign="top"><input name="codPostal" type="text" style="width:135px" id="codPostal" onFocus="this.select()" value="#userdata_direccion.codPostal#" size="10" maxlength="60"></td>
          <td valign="top">&nbsp;</td>
	      <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr>
	    <tr>
	      <td align="left">&nbsp;</td>
	      <td colspan="2" valign="top">&nbsp;
          </td>
          <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
	    </tr> 
	
			
			<tr><td colspan="3" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include="Afiliaciones,Familiares">
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
			  <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			</tr>
			</table>
			
			<cfif entrada.RecordCount>
				
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="subTitulo">Afiliaciones vigentes </td>
                        <td class="subTitulo">V&aacute;lido desde </td>
                        <td class="subTitulo">V&aacute;lido hasta </td>
                        <td class="subTitulo">Fila</td>
                        <td class="subTitulo">Asiento</td>
                        <td colspan="2" class="subTitulo">Carnet</td>
                      </tr>
					  <cfloop query="entrada">
						<cfset link = "afiliar_paso2.cfm?id_persona="&URLEncodedFormat(data.id_persona) & "&programa=" & URLEncodedFormat(entrada.id_programa & ',' & entrada.id_vigencia)>
                      <tr height="24">
                        <td><a href="#link#">#entrada.nombre_programa# #entrada.nombre_vigencia# </a></td>
                        <td><a href="#link#">#DateFormat(entrada.fecha_desde,'dd/mm/yyyy')#</a></td>
                        <td><a href="#link#">#DateFormat(entrada.fecha_hasta,'dd/mm/yyyy')#</a></td>
                        <td><a href="#link#">#entrada.fila#</a></td>
                        <td><a href="#link#">#entrada.asiento#</a></td>
                        <td><a href="#link#">#entrada.codigo_barras#</a></td>
                        <td>
						<a href="#link#">
						<img src="../../font/barcode-sample.gif" width="110" height="22" border="0"></a></td>
                      </tr></cfloop>
                    </table>
		  </cfif>
					
					<input type="hidden" name="id_persona" value="#HTMLEditFormat(data.id_persona)#">
			
				
					<cfset ts = "">
      				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#data.ts_rversion#" returnvariable="ts">
      				</cfinvoke>
      				<input type="hidden" name="ts_rversion" value="#ts#">
				
			
				
					<input type="hidden" name="CEcodigo" value="#HTMLEditFormat(data.CEcodigo)#">
				
			
				
					<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
				
			
				
					<input type="hidden" name="BMfechamod" value="#HTMLEditFormat(data.BMfechamod)#">
				
			
				
					<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
				
			
		</form>
	</cfoutput>


