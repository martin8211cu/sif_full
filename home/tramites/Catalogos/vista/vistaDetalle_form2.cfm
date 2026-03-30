<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->		

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<cfparam name="url.es_requisito" default="0">

<cfif (not isdefined("url.id_vista")) OR len(trim(url.id_vista)) EQ 0>
	Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;de&nbsp;la&nbsp;Vista
	<cfabort>
</cfif>

<cfquery name="rslista" datasource="#session.tramites.dsn#">
		select distinct
			dd.id_vista,
			a.id_tipo, 	
			a.id_campo, 
			a.id_tipocampo, 
			a.nombre_campo, 
			b.nombre_tipo,
			vg.etiqueta,
			vg.orden,
			dd.orden_campo,
			dd.es_encabezado,
			dd.es_obligatorio,
			dd.etiqueta_campo,
			dd.id_vistagrupo,
			dd.ts_rversion 
			
		from DDVista v
			join DDTipoCampo a
				on a.id_tipo = v.id_tipo
			left outer join  DDVistaCampo dd
				on  a.id_campo = dd.id_campo
				and dd.id_vista = v.id_vista
			 inner join DDTipo b
				on b.id_tipo = a.id_tipocampo
			left outer join DDVistaGrupo vg
				on dd.id_vistagrupo = vg.id_vistagrupo
			
		where v.id_vista =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vista#">
		
		order by coalesce (dd.id_vistagrupo,100000), coalesce(dd.orden_campo,a.orden_campo,100000), a.nombre_campo asc
	</cfquery>
	<!--- <cfdump var="#rslista#"> --->

	 <cfquery name="rsVistasGrupos" datasource="#session.tramites.dsn#">
		select * 
		from DDVistaGrupo
		where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vista#">
	</cfquery><!--- --->


<html><head>
<cf_templatecss>
</head><body style=" margin:0 ">

<style type="text/css">
	.encabReporte {
		background-color:  #E1E1E1;
		font-weight: bolder;
		color: #000000;
		padding-top: 15px;
		padding-bottom: 15px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>


<cfoutput>
<form name="form2" method="post" action="vistaDetalle_sql.cfm" onSubmit="return validar(this);">
	<input name="id_tipo" value="#rslista.id_tipo#" type="hidden">
	<input name="id_vista" value="#url.id_vista#" type="hidden">
	<input name="es_requisito" value="#url.es_requisito#" type="hidden">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
		<td bgcolor="##ECE9D8" style="padding:3px;" colspan="4"><font size="1">
		<cfif url.es_requisito eq 0>
		Definir&nbsp;Campos&nbsp;de&nbsp;la&nbsp;Vista
		<cfelse>
		Definir datos de comprobaci&oacute;n para este requisito
		</cfif>
		</font>
		</td>
	</tr>

<!--- <cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" > --->

  <tr> 
	<td valign="top">

		<!--- Lista pintada sin el componente de listas --->
		<!--- <cfdump var="#rslista#"> --->
		<table width="100%">
			<tr>
			<td align="left">
			
		
		<table width="100%" align="left" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
			<td align="left"> 
					<strong>Instrucciones:<br></strong>
					<font style="font-style:italic "> 
					<cfif url.es_requisito eq 0>
					
					Seleccione y ordene los campos que desea que aparezcan en la vista, <br> 
					indicando cuales deben deben aparecer en el encabezado o en el detalle en las pantallas de Registro.
					
					<cfelse>
					
					Indique cuales datos del documento se deben capturar en la validaci&oacute;n de
					este en la ventanilla, y cu&aacute;les 
					de esos datos son de captura obligada. 
					</cfif><br>
					Adicionalmente puede indicar el orden 
					de captura si desea alterar el orden en que aparecer&aacute;n
					estos datos </font>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
		<td>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<cfif isdefined("rslista") and rslista.RecordCount GT 0>
					<cfset Lvarid_vista = "*">
						<cfloop query="rslista"><!--- pintado del corte --->
							<cfif (currentRow Mod 2) eq 1>
								<cfset color = "Non">
							<cfelse>
								<cfset color = "Par">
							</cfif>
							<cfif Lvarid_vista NEQ rslista.id_vistagrupo>
							<cfset Lvarid_vista = rslista.id_vistagrupo>
							<!--- <cfset tipo = "nada"> --->
								<tr>
									<td colspan="6">&nbsp;</td>
								</tr>
								<tr height="18" class="encabReporte"><td colspan="6">
									<cfif rslista.id_vistagrupo eq ''>
										<strong>&nbsp;&nbsp;&nbsp;Campos que no aparecen</strong>
									<cfelse>
										<strong>&nbsp;&nbsp;&nbsp;#Ucase(rslista.etiqueta)#</strong>
									</cfif>
									</td>
								</tr>
								<tr height="18" bgcolor="F5F5F0">
										<cfif url.es_requisito eq 0>
								  <td colspan="2" align="center"><strong>Mostrar en </strong></td>
								  <cfelse>
								  <td  align="center"></td>
								  <td  align="center"><strong>Mostrar en </strong></td>
								  </cfif>
								  <td align="center"><strong>Captura</strong></td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td>&nbsp;</td>
					 			</tr>
								<tr height="18" bgcolor="F5F5F0">
									<td width="10%" align="center">
										<cfif url.es_requisito eq 0>
										<strong>Encabezado</strong>
										</cfif>
									</td>
									<td width="10%" align="center">
										<cfif url.es_requisito eq 0>
											<strong>Detalle</strong>
										<cfelse>
											<strong>Ventanilla</strong>
										</cfif></td>
									<td width="15%" align="center"><strong>Obligada</strong></td>
									<td width="15%" align="center"><strong>Orden</strong></td>
									<td align="center" width="50%"><strong>Campo</strong></td>
									<td align="center" width="50%">
										<cfif url.es_requisito eq 0>
											<strong>Grupo</strong>
										</cfif>
									</td>
								
									<td width="2">&nbsp;</td>
								</tr>
								
						
							</cfif>
							
							<tr>
								<td width="10%" class="lista#color#" align="center">
									<cfif url.es_requisito eq 0>
									<input type="checkbox" value="1" name="chk_enc_#rslista.id_campo#" <cfif rslista.es_encabezado EQ 1 and rslista.id_vista NEQ '' >checked</cfif> onClick="javascript:document.form2.chk_det_#rslista.id_campo#.checked=false; document.form2.orden_#rslista.id_campo#.disabled=false; document.form2.idcampo_#rslista.id_campo#.value='<cfif isdefined("rslista") and rslista.recordcount gt 0>#rslista.id_campo#</cfif>';  <cfif url.es_requisito eq 0>document.form2.id_vistagrupo_#rslista.id_campo#.disabled=false;</cfif>   if (!document.form2.chk_enc_#rslista.id_campo#.checked) {document.form2.orden_#rslista.id_campo#.disabled=true; document.form2.idcampo_#rslista.id_campo#.value='<cfif isdefined("rslista") and rslista.recordcount gt 0>#rslista.id_campo#</cfif>';  <cfif url.es_requisito eq 0>document.form2.id_vistagrupo_#rslista.id_campo#.disabled=true;</cfif> document.form2.orden_#rslista.id_campo#.value=' ';}">
									</cfif>
								</td>
								<td width="10%" class="lista#color#" align="center">
									<input type="checkbox" value="0" name="chk_det_#rslista.id_campo#" <cfif rslista.es_encabezado EQ 0 and rslista.id_vista NEQ ''>checked</cfif> onClick="javascript:if (document.form2.chk_enc_#rslista.id_campo#)document.form2.chk_enc_#rslista.id_campo#.checked=false; document.form2.orden_#rslista.id_campo#.disabled=false; document.form2.idcampo_#rslista.id_campo#.value='<cfif isdefined("rslista") and rslista.recordcount gt 0>#rslista.id_campo#</cfif>';  <cfif url.es_requisito eq 0>document.form2.id_vistagrupo_#rslista.id_campo#.disabled=false;</cfif>   if (!document.form2.chk_det_#rslista.id_campo#.checked) {document.form2.orden_#rslista.id_campo#.disabled=true; document.form2.idcampo_#rslista.id_campo#.value='<cfif isdefined("rslista") and rslista.recordcount gt 0>#rslista.id_campo#</cfif>';  <cfif url.es_requisito eq 0>document.form2.id_vistagrupo_#rslista.id_campo#.disabled=true;</cfif>  document.form2.orden_#rslista.id_campo#.value=' '; }">
								</td>
								<td width="15%" class="lista#color#" align="center">
									<input type="checkbox" value="0" name="chk_req_#rslista.id_campo#" <cfif rslista.es_obligatorio EQ 1>checked</cfif> >
								</td>
								<td width="15%"class="lista#color#" align="center">
									<input align="right" name="orden_#rslista.id_campo#" 
										type="text" size="6" disabled maxlength="10" 
										onfocus="this.select()"
										value="<cfif len(trim(rslista.orden_campo)) gt 0>#rslista.CurrentRow*10#</cfif>">
										
									 <input name="idcampo_#rslista.id_campo#" 
										type="hidden" value=""> 
								</td>
								<td width="50%" align="left" class="lista#color#">#rslista.nombre_campo#</td>
								<td width="10%" class="lista#color#" align="center">
									<cfif url.es_requisito eq 0>
										<select name="id_vistagrupo_#rslista.id_campo#" disabled>
											<cfset LvarIdVistaGrupos = rslista.id_vistagrupo>
											<cfloop query="rsVistasGrupos">
												<option value="#id_vistagrupo#" <cfif isdefined("rslista") and (LvarIdVistaGrupos EQ rsVistasGrupos.id_vistagrupo)>selected</cfif>>#rsVistasGrupos.etiqueta#</option>
											</cfloop>
										</select>
									</cfif>
									
								</td>

							</tr>
						</cfloop>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
	</td>
  </tr>
  <tr> 
	<td>&nbsp;</td>
  </tr>
  <!--- Botones --->
	<tr> 
		<td colspan="2" align="center" valign="top" nowrap> 
			<div align="center"> 
				<input name="btnGuardar" type="submit" value="Guardar">
				<input name="btnRegresar" type="button" value="Regresar a la lista"  onClick="javascript: return funcRegresar2();">
			</div>
		</td>
	</tr>
	<tr>
	  	<td colspan="2" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rslista.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">

</table>
</form>


</cfoutput>

<script language="javascript" type="text/javascript">
<cfoutput>
validainicio();

	function validainicio(){
		<cfloop query="rslista">
			<cfif trim(rslista.orden_campo) EQ "">
				document.form2.orden_#rslista.id_campo#.disabled = true;
				<cfif url.es_requisito eq 0>
					document.form2.id_vistagrupo_#rslista.id_campo#.disabled=true;
				</cfif>
			<cfelse>
				document.form2.orden_#rslista.id_campo#.disabled = false;
				<cfif url.es_requisito eq 0>
					document.form2.id_vistagrupo_#rslista.id_campo#.disabled=false;
				</cfif>
			</cfif>
		</cfloop>
	}

	function funcRegresar2(){
		window.parent.location.href = "listaVista.cfm";
		return false;
	}


	function validar(formulario){
			var error_input;
			var error_msg = '';
		<cfloop query="rslista">
			<cfif url.es_requisito eq 0>
			if (document.form2.chk_enc_#rslista.id_campo#.checked && 
				!document.form2.chk_det_#rslista.id_campo#.checked ) {
				document.form2.idcampo_#rslista.id_campo#.value='#rslista.id_campo#';
	
				if (isNaN(formulario.orden_#rslista.id_campo#.value)) {
					error_msg += "\n - Orden,  #rslista.nombre_campo#.";
					error_input = formulario.orden_#rslista.id_campo#;
				}

				// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
	
						return false;
					}
					
				}
			</cfif>


			if (document.form2.chk_det_#rslista.id_campo#.checked
				<cfif url.es_requisito eq 0>
				&&  !document.form2.chk_enc_#rslista.id_campo#.checked
				</cfif>){
				document.form2.idcampo_#rslista.id_campo#.value='#rslista.id_campo#';
				<!---
				if (isNaN(formulario.orden_#rslista.id_campo#.value)) {
					error_msg += "\n - Orden, #rslista.nombre_campo#.";
					error_input = formulario.orden_#rslista.id_campo#;
				}
				--->

				// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
	
						return false;
					}
					
				}
					
			if (<cfif url.es_requisito eq 0>
				!document.form2.chk_enc_#rslista.id_campo#.checked && 
				</cfif>
				!document.form2.chk_det_#rslista.id_campo#.checked) {
				document.form2.idcampo_#rslista.id_campo#.value=' ';
			}
			
			
		</cfloop>
	}
	
	</cfoutput>
</script>
<!--- formulario.orden_#rslista.id_campo#.value == "" || --->
<!------> 
</body></html>