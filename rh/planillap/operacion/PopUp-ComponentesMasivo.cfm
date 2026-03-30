<cf_templatecss>
<!----Verificar el parámetro de Estructura Salarial---->
<cfquery name="rsParametro" datasource="#session.DSN#">
	select CSusatabla
	from ComponentesSalariales 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and  CSsalariobase = 1
</cfquery>
<!----Definicion de variables boleanas---->
<cfset vb_categoria 	= false>
<cfset vb_puestopresup 	= false>
<cfset vb_puestorh 		= false>
<cfset vb_finicio 		= false>
<cfset vb_ffin 			= false>
<cfset vb_tablasalarial	= false>
<cfset vb_cantidad		= true>
<cfset vb_fechasNuevoComp = false>

<cfparam name="url.RHEid" default="0" >
<cfparam name="url.RHETEid" default="0" >
<cfparam name="url.prs_origen" default="" >

<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHETEid") and len(trim(url.RHETEid))>
	<cfset form.RHETEid = url.RHETEid>
</cfif>
<cfif isdefined("url.prs_origen") and len(trim(url.prs_origen))>
	<cfset form.origen = url.prs_origen>
	<cfif url.prs_origen EQ 'tablas'>
		<cfset vb_categoria 	= true>
		<cfset vb_puestopresup 	= true>
		<cfset vb_cantidad		= false>
		<cfset vb_fechasNuevoComp = true>
	</cfif>
	<cfif url.prs_origen EQ 'sitactual'>		
		<cfset vb_puestorh 		= true>
		<cfset vb_puestopresup 	= true>
		<cfset vb_finicio 		= true>
		<cfset vb_ffin 			= true>
	</cfif>
	<cfif url.prs_origen EQ 'psolicitadas' and rsParametro.RecordCount NEQ 0>
		<cfset vb_puestorh 		= true>
		<cfset vb_puestopresup 	= true>
		<cfset vb_tablasalarial = true>
		<cfset vb_categoria 	= true>
	</cfif>
</cfif>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function funcOpcion(){
		var td_PuestoPresup = document.getElementById("PuestoPresup");
		var td_PuestoRH    	= document.getElementById("PuestoRH");
		if (document.form1.opt_puesto[0].checked){//Option de puesto presupuestario
			document.form1.RHPcodigo.value = '';
			document.form1.RHPdescpuesto.value ='';			
			td_PuestoPresup.style.display = '';
			td_PuestoRH.style.display = 'none';
		}
		else{
			if (document.form1.opt_puesto[1].checked){//Option de puesto RH
				document.form1.RHMPPcodigo.value = '';
				document.form1.RHMPPdescripcion.value = '';			
				td_PuestoPresup.style.display = 'none';
				td_PuestoRH.style.display = '';
			}
		}
	}
</script>	

<cfoutput>
<form name="form1" action="ComponentesMasivos-SQL.cfm" method="post">	
	<input type="hidden" name="origen" value="<cfif isdefined("form.origen") and len(trim(form.origen))>#form.origen#</cfif>">			<!----LLave del escenario (RHEid)----->
	<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHETEid" value="<cfif isdefined("form.RHETEid") and len(trim(form.RHETEid))>#form.RHETEid#</cfif>">
    <table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="5%" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Componentes Masivos</strong></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="4" align="center">
				<table width="100%" align="center">
					<tr>
						<td><hr /></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="4%">&nbsp;</td>
			<td colspan="4" align="center">
				<fieldset>
				<table width="99%" align="center">
					<tr>
						<td>
							<div align="justify">
								<p> 
								Seleccione el componente que será agregado o eliminado según los parámetros indicados en 
								la parte inferior.								
								</p>
							</div>
						</td>
					</tr>
				</table>
				</fieldset>
	  	  </td>
		  <td width="2%">&nbsp;</td>
		</tr>				
      	<tr><td>&nbsp;</td></tr>
      	<tr>
        	<td width="4%">&nbsp;</td>
        	<td align="right" nowrap="nowrap" width="14%"><strong>Componente:&nbsp;</strong></td>
        	<td width="21%">
				<cf_conlis 
					campos="CScomplemento, CSid, CScodigo, CSdescripcion"
					asignar="CScomplemento, CSid, CScodigo, CSdescripcion"
					size="0,0,8,25"
					desplegables="N,N,S,S"
					modificables="N,N,S,N"						
					title="Lista de Componentes"
					tabla="ComponentesSalariales a"
					columnas="CScomplemento, CSid, CScodigo, CSdescripcion"
					filtro="a.Ecodigo = #Session.Ecodigo# "
					filtrar_por="CScodigo, CSdescripcion"
					desplegar="CScodigo, CSdescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- No se encontraron registros --- "
				/>
       	  </td>
        	<td align="right" nowrap="nowrap" height="25" width="11%"><strong>Monto:&nbsp;</strong></td>
        	<td>
				<input type="text" name="Monto" value="" size="25" maxlength="25" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" />
			</td>
   	  </tr>
      	<tr style="display:<cfif vb_fechasNuevoComp>''<cfelse>none</cfif>">
        	<td width="4%">&nbsp;</td>
        	<td align="right" nowrap="nowrap" width="14%">
				<strong>Fecha Incial:&nbsp;</strong>			</td>
        	<td width="21%">
				<cf_sifcalendario conexion="#session.DSN#" form="form1" name="finicial">
		  </td>
			<td align="right" nowrap="nowrap" width="11%">
				<strong>Fecha Final:&nbsp;</strong>			</td>
        	<td width="48%">
				<cf_sifcalendario conexion="#session.DSN#" form="form1" name="ffinal">
   		  </td>
		</tr>
      	<tr style="display:<cfif vb_cantidad>''<cfelse>none</cfif>">
			<td width="4%">&nbsp;</td>
			<td align="right" nowrap="nowrap" width="14%">
				<strong>Cantidad:&nbsp;</strong>			</td>
			<td>
				<input type="text" name="Cantidad" value="" size="20" maxlength="20" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" />
			</td>
      	</tr>
      	<tr><td>&nbsp;</td></tr>
      	<tr><td>&nbsp;</td></tr>
      	<tr>
        	<td>&nbsp;</td>
        	<td align="right"><strong style="color:##003366;font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px">Par&aacute;metros:</strong></td>
      	</tr>
      	<tr>
        	<td>&nbsp;</td>
        	<td colspan="4">
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
            	<tr id="TRCategoria" style="display:<cfif vb_categoria>''<cfelse>none</cfif>">
              		<td colspan="3">&nbsp;</td>
              		<td width="22%" align="right" nowrap="nowrap"><strong>Categor&iacute;a:&nbsp;</strong></td>
              		<!----Categorias ---->
              		<td>
						<cf_conlis 
							campos="RHCid, RHCcodigo, RHCdescripcion"
							asignar="RHCid, RHCcodigo, RHCdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,S,N"						
							title="Lista de Categor&iacute;as"
							tabla="RHCategoria "
							columnas="RHCid, RHCcodigo, RHCdescripcion"
							filtro="Ecodigo = #Session.Ecodigo# "
							filtrar_por="RHCcodigo, RHCdescripcion"
							desplegar="RHCcodigo, RHCdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/>              
					</td>
            	</tr>
            	<tr id="TRFechaInicio" style="display:<cfif vb_finicio>''<cfelse>none</cfif>">
              		<td colspan="3">&nbsp;</td>
              		<td width="22%" align="right" nowrap="nowrap"><strong>Fecha Inicio Corte:&nbsp;</strong></td>
           		  <td width="63%"><cf_sifcalendario conexion="#session.DSN#" form="form1" name="fdesde"></td>
           		</tr>
           		<tr id="TRFechaFin" style="display:<cfif vb_finicio>''<cfelse>none</cfif>">
              		<td colspan="3">&nbsp;</td>
              		<td width="22%" align="right" nowrap="nowrap"><strong>Fecha Fin Corte:&nbsp;</strong></td>
           		  <td width="63%"><cf_sifcalendario conexion="#session.DSN#" form="form1" name="fhasta"></td>
            	</tr>
				<tr id="TRFechaFin" style="display:<cfif vb_tablasalarial>''<cfelse>none</cfif>">
					<td colspan="3">&nbsp;</td>					
					<td width="22%" align="right" nowrap="nowrap"><strong>Tabla Salarial:&nbsp;</strong></td>
					<td width="63%">
						<cf_conlis 
							campos="RHTTid, RHTTcodigo, RHTTdescripcion"
							asignar="RHTTid, RHTTcodigo, RHTTdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,S,N"						
							title="Lista de Tablas Salariales"
							tabla="RHTTablaSalarial "
							columnas="RHTTid, RHTTcodigo, RHTTdescripcion"
							filtro="Ecodigo = #Session.Ecodigo# "
							filtrar_por="RHTTcodigo, RHTTdescripcion"
							desplegar="RHTTcodigo, RHTTdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/>              
				  </td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td width="15%" align="right">
						<cfif vb_puestopresup>
						  <input type="radio" name="opt_puesto" onclick="javascript: funcOpcion();" checked="checked" />
						<cfelse>
							&nbsp;
						</cfif>
				  </td>
					<td width="22%" align="right" nowrap="nowrap" style="display:<cfif vb_puestopresup>''<cfelse>none</cfif>;">
						<strong>Puesto Presupuestario:&nbsp;</strong></td>
				  	<td id="PuestoPresup" style="display:<cfif vb_puestopresup>''<cfelse>none</cfif>;">
				  		<cf_conlis 
							campos="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
							asignar="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
							size="0,8,25"
							desplegables="N,S,S"
							modificables="N,S,N"						
							title="Lista de Puestos Presupuestarios"
							tabla="RHMaestroPuestoP "
							columnas="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
							filtro="Ecodigo = #Session.Ecodigo# "
							filtrar_por="RHMPPcodigo, RHMPPdescripcion"
							desplegar="RHMPPcodigo, RHMPPdescripcion"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/> 
				  	</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td align="right">
						<cfif vb_puestorh>
						  <input type="radio" name="opt_puesto" onclick="javascript: funcOpcion();" />
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					<td width="22%" align="right" nowrap="nowrap" style="display:<cfif vb_puestorh>''<cfelse>none</cfif>;">
						<strong>Puesto Recursos Humanos:&nbsp;</strong></td>
				  	<td id="PuestoRH" style="display:<cfif vb_puestopresup>none<cfelse>''</cfif>;">
						<cf_conlis 
							campos="RHPcodigo, RHPdescpuesto"
							asignar="RHPcodigo, RHPdescpuesto"
							size="8,25"
							desplegables="S,S"
							modificables="S,N"						
							title="Lista de Puestos Recursos Humanos"
							tabla="RHPuestos"
							columnas="RHPcodigo, RHPdescpuesto"
							filtro="Ecodigo = #Session.Ecodigo# "
							filtrar_por="RHPcodigo, RHPdescpuesto"
							desplegar="RHPcodigo, RHPdescpuesto"
							etiquetas="C&oacute;digo, Descripci&oacute;n"
							formatos="S,S"
							align="left,left"								
							asignarFormatos="S,S"
							form="form1"
							showEmptyListMsg="true"
							EmptyListMsg=" --- No se encontraron registros --- "
						/>              
					</td>
				</tr		
				><tr><td width="0%">&nbsp;</td>
				</tr>            
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
      	<tr>
        	<td colspan="5" align="center">
				<table cellpadding="5" cellspacing="0">
          			<tr>
              			<td><input type="submit" name="btn_aceptar" value="Agregar" /></td>
						<td><input type="submit" name="btn_eliminar" value="Eliminar" onclick="javascript: funcDeshabilitaValidacion();"/></td>
            			<td><input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();" /></td>
          			</tr>
        		</table>
			</td>
      	</tr>
    </table>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.ffinal.description="Fecha final";				
	objForm.finicial.description="Fecha inicial";	
	objForm.Monto.description="Monto";	
	objForm.CSid.description="Componente";
	objForm.Cantidad.description="Cantidad";

	objForm.Monto.required = true;
	objForm.CSid.required = true;
	
	<cfif vb_fechasNuevoComp>
		objForm.ffinal.required = true;
		objForm.finicial.required = true;		
	</cfif>
	
	<cfif vb_cantidad>
		objForm.Cantidad.required = true;
	</cfif>
	
	function funcDeshabilitaValidacion(){
		objForm.Monto.required = false;
		objForm.Cantidad.required = false;
		objForm.ffinal.required = false;
		objForm.finicial.required = false;
	}
</script>
