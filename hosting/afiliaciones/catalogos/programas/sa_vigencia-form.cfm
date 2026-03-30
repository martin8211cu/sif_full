<cfoutput>
<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script type="text/javascript">
<!--
	function funcRegresar(){
		location.href='sa_programas.cfm?id_programa=#JSStringFormat(url.id_programa)#';
		return false;
	}
	function funcAfiliados(){
		location.href='afiliados.cfm?id_programa=#JSStringFormat(url.id_programa)#&id_vigencia=#JSStringFormat(url.id_vigencia)#';
		return false;
	}

	function validar(formulario)
	{
		var thisinput;
		var error_msg = '';
		// Validando tabla: sa_vigencia - sa_vigencia
				// Columna: id_programa id programa numeric
				if (formulario.id_programa.value == "") {
					error_msg += "\n - ID programa no puede quedar en blanco.";
					thisinput = formulario.id_programa;
				}
				if (formulario.nombre_vigencia.value == "") {
					error_msg += "\n - La descripción no puede quedar en blanco.";
					thisinput = formulario.nombre_vigencia.periodicidad;
				}
				if (formulario.fecha_desde.value == "") {
					error_msg += "\n - Especifique la fecha de inicio (Válido desde).";
					thisinput = formulario.fecha_desde.periodicidad;
				}
				if (formulario.fecha_hasta.value == "") {
					error_msg += "\n - Especifique la fecha de final (Válido hasta).";
					thisinput = formulario.fecha_hasta.periodicidad;
				}
				// Columna: periodicidad periodicidad int
				if (formulario.costo.value == "") {
					error_msg += "\n - El costo no puede quedar en blanco.";
					thisinput = formulario.costo;
				}
				// Columna: periodicidad periodicidad int
				if (formulario.periodicidad.value == "") {
					error_msg += "\n - Periodo de cobro no puede quedar en blanco.";
					thisinput = formulario.periodicidad;
				}
				// Columna: tipo_periodo tipo_periodo char(1)
				if (formulario.tipo_periodo.value == "") {
					error_msg += "\n - Tipo de periodo no puede quedar en blanco.";
					thisinput = formulario.tipo_periodo;
				}
				// Columna: cantidad_carnes generar carnés int
				if (formulario.cantidad_carnes.value == "") {
					error_msg += "\n - La cantidad de carnés no puede quedar en blanco.";
					thisinput = formulario.cantidad_carnes;
				}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			thisinput.focus();
			return false;
		}
		return true;
	}
//-->
</script>

	<cfparam name="url.id_programa" default="">

	<cfparam name="url.id_vigencia" default="">
	
	<cfquery datasource="#session.dsn#" name="monedas">
		select Miso4217, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by Mnombre
	</cfquery>

	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  sa_vigencia
			where id_programa=
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" null="#Len(url.id_programa) Is 0#">
		
			and 
			id_vigencia =
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#" null="#Len(url.id_vigencia) Is 0#">
		
	</cfquery>
	<cfquery datasource="#session.dsn#" name="programa">
		select id_programa,nombre_programa
		from  sa_programas
			where id_programa=
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" null="#Len(url.id_programa) Is 0#">
		
		
	</cfquery>
	
		<form action="sa_vigencia-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
			<table summary="Tabla de entrada">
			<tr>
			  <td colspan="3" class="subTitulo">
			Registro de Vigencia </td>
			</tr>
			<tr>
			  <td colspan="3" valign="top">Programa</td>
			  </tr>
			<tr>
			  <td colspan="3" valign="top"><input name="nombre_programa" type="text" id="nombre_programa"
						 readonly="readonly"  value="#HTMLEditFormat(programa.nombre_programa)#" size="60" 
						maxlength="60"  ></td>
			  </tr>
			<tr>
              <td valign="top">Descripci&oacute;n</td>
              <td colspan="2" valign="top">&nbsp;              </td>
			  </tr>
			
			
				
				
			
				
				
					
				
			
				
				
				<tr>
				  <td colspan="3" valign="top"><input name="nombre_vigencia" type="text" id="nombre_vigencia"
						onFocus="this.select()" value="#HTMLEditFormat(data.nombre_vigencia)#" size="60" 
						maxlength="60"  ></td>
			  </tr>
				<tr>
				  <td valign="top">V&aacute;lido desde</td>
				  <td colspan="2" valign="top">Hasta
				
					
				
				</td></tr>
				
			
				
				
				<tr>
				  <td valign="top"><cf_sifcalendario form="form1" name="fecha_desde" value="#DateFormat(data.fecha_desde,'dd/mm/yyyy')#"></td>
				  <td colspan="2" valign="top">
				
					<cf_sifcalendario form="form1" name="fecha_hasta" value="#DateFormat(data.fecha_hasta,'dd/mm/yyyy')#">
				
				</td></tr>
				
			
				
				
				<tr>
				  <td valign="top">Costo
				</td><td colspan="2" valign="top">Periodo de cobro 
				
				</td></tr>
				
			
				
				
				<tr>
				  <td valign="top" nowrap><input name="costo" id="costo" type="text" value="#HTMLEditFormat(NumberFormat(data.costo,',0.00'))#" 
						maxlength="15" style="text-align:right " size="13"
						onFocus="this.select()"  onBlur="fm(this,2)" >
						<select name="moneda" id="moneda">
						<cfloop query="monedas">
						<option value="#HTMLEditFormat(monedas.Miso4217)#">#HTMLEditFormat(monedas.Miso4217)#</option>
						</cfloop>
						</select>
						</td>
				  <td colspan="2" valign="top">
				
					<input name="periodicidad" id="periodicidad" type="text" value="#HTMLEditFormat(data.periodicidad)#" 
						maxlength="4" style="text-align:right " size="4"
						onfocus="this.select()" <cfif data.tipo_periodo is 'U'>disabled</cfif>  >
					<select name="tipo_periodo" id="tipo_periodo" onChange="this.form.periodicidad.disabled=this.value=='U';if(this.value=='U')this.form.periodicidad.value=0">
                      <option value="S" <cfif data.tipo_periodo is 'S'>selected</cfif> > Semanas </option>
                      <option value="M" <cfif data.tipo_periodo is 'M'>selected</cfif> > Meses </option>
                      <option value="U" <cfif data.tipo_periodo is 'U'>selected</cfif> > &Uacute;nico </option>
                                        </select>				</td>
			  </tr>

				
			
				
				<tr>
				  <td colspan="3" valign="top">Beneficios incluidos en esta membres&iacute;a </td>
			  </tr>
				<tr>
				  <td colspan="3" valign="top">
				
				<textarea rows="6" cols="60" name="beneficios" onfocus="this.select()">#HTMLEditFormat(data.beneficios)#</textarea>				</td></tr>
				
			
				
				
				<tr>
				  <td colspan="3" valign="top">Cantidad de carn&eacute;s para cada afiliado				</td>
			    </tr>
				
			
				
				
				<tr>
				  <td valign="top"><input name="cantidad_carnes" id="cantidad_carnes" type="text" value="#HTMLEditFormat(data.cantidad_carnes)#" 
						maxlength="11"
						onFocus="this.select()"  ></td>
				  <td valign="top">
				
					<input name="generar_carnes" id="generar_carnes" type="checkbox" value="1" <cfif Len(data.generar_carnes) And data.generar_carnes>checked</cfif> >					</td>
				  <td valign="top"><label for="generar_carnes">Generar c&oacute;digo de barras<br> 
			      para cada carn&eacute;</label></td>
				</tr>
				
			
				
				
				<tr>
				  <td valign="top">Total de entradas </td><td colspan="2" valign="top">
					Cantidad de entradas <br>
					asignadas hasta el momento
				</td>
				</tr>
				
			
				
				
				<tr>
				  <td valign="top"><input name="total_entradas" id="total_entradas" type="text" value="#HTMLEditFormat(data.total_entradas)#" 
						maxlength="11"
						onFocus="this.select()"  ></td><td colspan="2" valign="top">
				
					<input name="entradas_asignadas" id="entradas_asignadas" type="text" value="#HTMLEditFormat(data.entradas_asignadas)#" 
						maxlength="11"
						readonly >
				
				</td></tr>
			<tr><td colspan="3" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include='Afiliados,Regresar'>
				<cfelse>
					<cf_botones modo='ALTA' include='Regresar'>
				</cfif>
			</td></tr>
			</table>
			
			
				
					<input name="id_programa" id="id_programa" type="hidden" value="#HTMLEditFormat(programa.id_programa)#">
					<input type="hidden" name="id_vigencia" value="#HTMLEditFormat(data.id_vigencia)#">
				
			
				
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


