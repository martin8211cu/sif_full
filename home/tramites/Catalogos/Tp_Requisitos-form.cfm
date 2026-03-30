<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 22-8-2005.
		Motivo: Se permite guardar "Institución Responsable" y "Tipo de Servicio" con la opción "Ninguna" y "Ninguno" respectivamente (guarda nulos).
		

 --->


<cfquery datasource="asp" name="monedas">
	select Miso4217, Mnombre
	from Moneda
	order by Miso4217
</cfquery>

<cfquery name="tipoiden" datasource="#session.tramites.dsn#">
	select a.id_tipoident, a.codigo_tipoident,a.nombre_tipoident,case when b.id_tipoident is null then 0 else 1 end as existe
	from TPTipoIdent a
	left outer join TPTipoIdentReq b
	on a.id_tipoident =  b.id_tipoident
	<cfif modo NEQ "ALTA">
		and  b.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	<cfelse>
		and  b.id_requisito = -1
	</cfif>
	order by a.codigo_tipoident

</cfquery>

<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select * 
		from TPRequisito  req
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	
	<cfset modo = 'CAMBIO'>
</cfif>

<cfoutput>
<form name="formR" method="post" action="Tp_RequisitosSQL.cfm" onsubmit="activacampos();">
	<table width="100%"  border="0">
		<tr>
			<td valign="top" width="60%">
				<table align="center" width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td bgcolor="##ECE9D8" style="padding:3px;" colspan="2">
							<font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif>&nbsp;Requisito</font>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr valign="baseline"> 
						<td width="19%" align="right" nowrap>C&oacute;digo:</td>
						<td width="81%">
							<input type="text" name="codigo_requisito" style="text-transform:uppercase;" 
							value="<cfif modo NEQ "ALTA">#trim(rsDatos.codigo_requisito)#</cfif>" 
							size="13" maxlength="10" onFocus="javascript:this.select();" >
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Nombre:</td>
						<td>
							<input type="text" name="nombre_requisito" 
							value="<cfif modo NEQ "ALTA">#rsDatos.nombre_requisito#</cfif>" 
							size="60" maxlength="100" onFocus="javascript:this.select();" >
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Tipo de Requisito:</td>
						<td>
							<select name="id_tiporeq">
								<cfloop query="rstipos">
									<option value="#rstipos.id_tiporeq#" <cfif modo NEQ "ALTA" and  isdefined('rsDatos.id_tiporeq') and rsDatos.id_tiporeq eq rstipos.id_tiporeq>selected</cfif>>#rstipos.codigo_tiporeq#-#rstipos.nombre_tiporeq#</option>
								</cfloop>
							</select>	
						</td>
					</tr>
					<tr valign="baseline"> 
						<td nowrap align="right">Instituci&oacute;n&nbsp;Resposable:</td>
						<td>
							<select name="id_inst" onChange="javascript: Cargatiposerv();">
								<option value="">Ninguna</option>
								<cfloop query="rsInstitucion">
									<option value="#rsInstitucion.id_inst#" <cfif modo NEQ "ALTA" and  isdefined('rsDatos.id_inst') and rsDatos.id_inst eq rsInstitucion.id_inst>selected</cfif>>#rsInstitucion.codigo_inst#-#rsInstitucion.nombre_inst#</option>
								</cfloop>
							</select>
						</td>
					</tr>	
					<tr valign="baseline"> 
						<td nowrap align="right">Tipo de Servicio:</td>
						<td>
							<select name="id_tiposerv" >
								<!--- <option value="0">Ninguna</option> --->
							</select>	
						</td>
					</tr>
					<tr valign="baseline">
					  <td nowrap align="right">Comportamiento:</td>
					  <td><select name="comportamiento">
					    <option value="D" <cfif Modo NEQ 'ALTA' AND rsDatos.comportamiento EQ 'D'>selected</cfif> >Documental</option>
					    <option value="C" <cfif Modo NEQ 'ALTA' AND rsDatos.comportamiento EQ 'C'>selected</cfif>> Servicio de Citas</option>
					    <option value="P" <cfif Modo NEQ 'ALTA' AND rsDatos.comportamiento EQ 'P'>selected</cfif> >Pago</option>
					    <option value="A" <cfif Modo NEQ 'ALTA' AND rsDatos.comportamiento EQ 'A'>selected</cfif> >Aprobación o Visto Bueno</option>
				      </select></td>
				  </tr>						
				</table>
			</td>
			<td valign="top" width="40%">
				<table align="center" width="100%" cellpadding="0" border="0" cellspacing="0">
					<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Este requisito aplica para los siguientes tipos de identificación</font></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>				
					<tr>
						<td style="padding:0;"></td>
						<td style="padding:0;">
							<table width="100%" cellpadding="0" cellspacing="0">
								<cfset ubica = 0>
								<cfloop query="tipoiden">
									<cfif ubica EQ 0>	
										<tr>
											<td nowrap><input  type="checkbox"  <cfif tipoiden.existe eq 1>checked</cfif> value="#tipoiden.id_tipoident#" name="tipoiden" id="#tipoiden.id_tipoident#"></td>					
											<td align="left" nowrap><label for="#tipoiden.id_tipoident#">#tipoiden.nombre_tipoident#&nbsp;</label></td>
											<cfset ubica = 1>
										<cfelse>
											<td nowrap><input  type="checkbox"  <cfif tipoiden.existe eq 1>checked</cfif>  value="#tipoiden.id_tipoident#" name="tipoiden" id="#tipoiden.id_tipoident#"></td>					
											<td align="left" nowrap><label for="#tipoiden.id_tipoident#">#tipoiden.nombre_tipoident#&nbsp;</label></td>
										</tr>
										<cfset ubica = 0>
									</cfif>
								</cfloop>
								<cfif ubica EQ 1>
									</tr>
								</cfif>
							</table>
						</td>
					<!--- </tr> --->
					<tr>
						<td colspan="2">
							<cfif modo neq 'ALTA'>
								<cf_vigente form="formR" desde="#rsDatos.vigente_desde#" hasta="#rsDatos.vigente_hasta#">
							<cfelse>
								<cf_vigente form="formR">
							</cfif>
						</td>
					</tr>	
				</table>
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../sif/portlets/pBotones.cfm">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
				<input type="hidden" name="id_requisito" value="<cfif modo NEQ "ALTA">#rsDatos.id_requisito#</cfif>">
			</td>
		</tr>	  
	</table>
</form>

<cf_qforms form="formR">
<SCRIPT LANGUAGE="JavaScript">

	objForm.codigo_requisito.description="#JSStringFormat('Código')#";
	objForm.nombre_requisito.description="#JSStringFormat('Nombre')#";

	function habilitarValidacion(){
		objForm.codigo_requisito.required = true;		
		objForm.nombre_requisito.required = true;
	}

	function deshabilitarValidacion(){
		objForm.codigo_requisito.required = false;
		objForm.nombre_requisito.required = false;
	}

	function Cargatiposerv() {
		var combo = document.formR.id_tiposerv;
		var cont = 0;
		codigo = document.formR.id_inst.value;
		combo.length=0;
		<cfloop query="rstiposserv">
			if ( #Trim(id_inst)# == codigo) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rstiposserv.id_tiposerv#';
				combo.options[cont].text='#trim(rstiposserv.codigo_tiposerv)#-#trim(rstiposserv.nombre_tiposerv)#';
				<cfif isdefined("rsDatos.id_tiposerv") and trim(rstiposserv.id_tiposerv) EQ trim(rsDatos.id_tiposerv)>
					combo.options[cont].selected=true;
				</cfif>						
				cont++;
			}
			else{ if (codigo==''){
				combo.length=cont+1;
				combo.options[cont].value='';
				combo.options[cont].text='Ninguno';
				combo.options[cont].selected=true;}
			}
		</cfloop>
	}


	function ValidarServicios(){
		objForm.id_inst.required = true;
		objForm.id_inst.description="Institución";
		objForm.id_tiposerv.required = true;
		objForm.id_tiposerv.description="Tipo de Servicio";
	}

	function ValidarPago(){ 
		if(! document.formR.es_pago.checked){
			objForm.id_inst.required = false;
			objForm.id_tiposerv.required = false;
		}
		else{
			objForm.id_inst.required = true;
			objForm.id_inst.description="Institución";
			objForm.id_tiposerv.required = true;
			objForm.id_tiposerv.description="Tipo de Servicio";			

		}
	}
	
	function activacampos(){
		document.formR.id_tiposerv.disabled = false;
	}
	<cfif modo NEQ "ALTA">
		//ValidarPago();
		Cargatiposerv(document.formR.id_inst.value);
		//ValidarServicios();
	</cfif>			
</SCRIPT>
</cfoutput>