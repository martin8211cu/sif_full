<cf_template>
<cf_templatearea name="title">
	Familiares
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navegacion=ListToArray('index.cfm,Registro de Personas;sa_personas.cfm?id_persona=#URLEncodedFormat(url.id_persona)#,Datos Personales;javascript:void(0),Familiares',';')>
	<cfinclude template="../../pNavegacion.cfm">

<cfparam name="url.id_persona" type="numeric">
<cfparam name="url.pariente" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="fam">
	select fam.id_persona, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid, fam.Psexo, fam.ts_rversion,
		case when fam.Psexo = 'F' then par.nombre_fem else par.nombre_masc end as parentesco
	from sa_pariente p
		join sa_personas fam
			on fam.id_persona = p.pariente
		left join sa_parentesco par
			on par.id_parentesco = p.id_parentesco
	where p.sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="pariente_edit">
	select fam.id_persona, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid, fam.Psexo, p.id_parentesco
	from sa_pariente p
		join sa_personas fam
			on fam.id_persona = p.pariente
	where p.sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and p.pariente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pariente#" null="#Len(url.pariente) Is 0#">
	  and p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>


<cfquery datasource="#session.dsn#" name="parentescos">
	select id_parentesco, nombre_masc, nombre_fem, upper(nombre_masc) as nombre_masc_upper
	from  sa_parentesco
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by nombre_masc_upper
</cfquery>


<cfoutput>
	<script type="text/javascript" src="personas.js"></script>
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_personas.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
		function validar(f){
			return true;
		}
		function quitar_familiar(pariente){
			location.href='familiares-quitar.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))
				#&pariente=' + escape(pariente);
		}
	//-->
	</script>
	<form action="familiares-add.cfm" onsubmit="return validar(this);" method="post" enctype="multipart/form-data" name="form1" id="form1">
			<table width="610" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Registro de familiares</td>
			  </tr>
				<tr><td width="140" valign="top">Nombre
				</td>
				  <td valign="top">#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#</td>
			      <td colspan="2" rowspan="4" valign="top">
				  <cfinvoke component="sif.Componentes.DButils"
					  method="toTimeStamp"
					  returnvariable="tsurl"
					  arTimeStamp="#data.ts_rversion#"/> 
					  <a href="sa_personas.cfm?id_persona=#URLEncodedFormat(data.id_persona)#&amp;push=yes">
					  <img src="imagen_persona.cfm?id_persona=#data.id_persona#&ts=#tsurl#" height="100" border="0" 
					  alt="#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#"></a></td>
		        </tr>
				<tr>
				  <td valign="top">Correo Electr&oacute;nico </td>
				  <td valign="top">#HTMLEditFormat(data.Pemail1)#                  </td>
		      </tr>
				<tr><td valign="top">C&eacute;dula</td>
				  <td valign="top">#HTMLEditFormat(data.Pid)#</td>
		        </tr>
			    <tr>
			      <td align="left">&nbsp;</td>
		          <td align="left">&nbsp;</td>
	          </tr>
			    <tr>
			      <td colspan="4" align="left">
				  
				  <table width="100%" cellpadding="2" cellspacing="0" summary="Tabla de entrada">
                    <cfif fam.RecordCount>
					<tr class="tituloListas">
                      <td valign="top" colspan="#fam.RecordCount#">Familiares registrados</td>
                    </tr></cfif>
					<tr>
					<cfloop query="fam">
					<cfif fam.CurrentRow mod 5 is 0>
						#'<'#/tr>#'<'#tr>
					</cfif>
					<td><table>
                    <tr>
                      <td>
					  <a href="sa_personas.cfm?id_persona=#URLEncodedFormat(fam.id_persona)#&amp;push=yes">
					  <cfinvoke component="sif.Componentes.DButils"
											  method="toTimeStamp"
											  returnvariable="tsurl"
											  arTimeStamp="#fam.ts_rversion#"/> 
							<img src="imagen_persona.cfm?id_persona=#fam.id_persona#&ts=#tsurl#" height="100" border="0" alt="#HTMLEditFormat(fam.Pnombre)# #HTMLEditFormat(fam.Papellido1)# #HTMLEditFormat(fam.Papellido2)#">
						</a></td>
                    </tr>
                    <tr>
                      <td>&nbsp;#HTMLEditFormat(fam.Pnombre)# #HTMLEditFormat(fam.Papellido1)# #HTMLEditFormat(fam.Papellido2)#&nbsp;</td>
                    </tr>
                    <tr>
                      <td>&nbsp;C&eacute;dula #HTMLEditFormat(fam.Pid)#&nbsp;</td>
                    </tr>
                    <tr>
                      <td>&nbsp;<a href="familiares.cfm?id_persona=#URLEncodedFormat(url.id_persona)#&pariente=#URLEncodedFormat(fam.id_persona)#">#HTMLEditFormat(fam.parentesco)#&nbsp;</a></td>
                    </tr>
                    <tr>
                      <td><input type="button" value="Quitar" onClick="quitar_familiar(#fam.id_persona#)">&nbsp;</td>
                    </tr>
					</table></td>
					</cfloop></tr>
					</table>
				  
				  </td>
			    </tr>
			    <tr>
                  <td colspan="4" align="left" class="subTitulo">Registrar familiar adicional </td>
		      </tr>
			    <tr>
			      <td colspan="4" align="left"><table cellpadding="2" cellspacing="0" width="100%" summary="Tabla de entrada">
                    <tr class="tituloListas">
                      <td valign="top">Parentesco</td>
                      <td valign="top">C&eacute;dula</td>
                      <td valign="top">Nombre </td>
                      <td valign="top" colspan="2">Apellidos</td>
                      <td valign="top">Foto</td>
                    </tr>
                    <tr>
                      <td valign="top">
					  <select name="parentesco" id="parentesco">
                          <option value="">&nbsp;</option>
                          <cfloop query="parentescos">
                            <option value="F,#parentescos.id_parentesco#" <cfif pariente_edit.id_parentesco is parentescos.id_parentesco and pariente_edit.Psexo is 'F'>selected</cfif>> #HTMLEditFormat(parentescos.nombre_fem)#</option>
                            <option value="M,#parentescos.id_parentesco#" <cfif pariente_edit.id_parentesco is parentescos.id_parentesco and pariente_edit.Psexo neq 'F'>selected</cfif>> #HTMLEditFormat(parentescos.nombre_masc)#</option>
                          </cfloop>
                      </select></td>
                      <td valign="top">
					  <input name="Pid" id="Pid" type="text" style="width:90px"  
					  value="#HTMLEditFormat(pariente_edit.Pid)#"
						maxlength="60" onBlur="blur_cedula(this)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()" ></td>
                      <td valign="top"><input name="Pnombre" id="Pnombre" type="text" style="width:75px"  
					  value="#HTMLEditFormat(pariente_edit.Pnombre)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()"  ></td>
                      <td valign="top"><input name="Papellido1" id="Papellido1" type="text" style="width:75px" 
					  value="#HTMLEditFormat(pariente_edit.Papellido1)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onFocus="this.select()"  ></td>
                      <td valign="top"><input name="Papellido2" id="Papellido2" type="text" style="width:75px"  
					  value="#HTMLEditFormat(pariente_edit.Papellido2)#"
						maxlength="60" onBlur="blur_nombre(this.form)" onChange="reset_persona_nueva(this.form)" 
						onfocus="this.select()"  >
                      </td>
                      <td><input type="file" name="foto" style="width:75px" size="5" onChange="(document.all?document.all.new_image_loader:document.getElementById('new_image_loader')).src = this.value">
                      </td>
                    </tr>
                    <tr>
                      <td valign="top" colspan="2"><input type="submit" name="btnAgregar" value="Agregar">
                  &nbsp;<input type="button" name="btnBuscar" value="Buscar" onClick="location.href='familiares2.cfm?id_persona=#URLEncodedFormat(url.id_persona)#'"></td>
                      <td colspan="3" valign="top"><input id="buscar_status" style="background-color:inherit;color:inherit;border-style:none" name="buscar_status" value="" type="text" readonly="" size="40" >
					  <iframe src="about:blank" name="frame_buscar_persona" style="display:none" id="frame_buscar_persona" frameborder="0" width="0" height="0"></iframe>
					  </td>
                      <td><img src="blank.gif" height="100" width="85" border="0" name="new_image_loader" id="new_image_loader"></td>
                    </tr>
                  </table></td>
		      </tr>
		<tr><td colspan="4" class="formButtons">
			<input type="button" name="btnRegresar" value="&lt;&lt; Regresar" onClick="funcRegresar()">
			
		</td></tr>
	  </table>
	<input type="hidden" name="id_persona" value="#HTMLEditFormat(data.id_persona)#">
	<input type="hidden" name="pariente" value="#HTMLEditFormat(pariente_edit.id_persona)#">
				
</form>


</cfoutput>	

</cf_templatearea>
</cf_template>

