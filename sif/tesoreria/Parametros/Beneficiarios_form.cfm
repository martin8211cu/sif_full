<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-6-2005.
		Motivo: Creación del Mantenimiento para beneficiarios.
	Modificado por: Gustavo Fonseca Hernández.
		Fecha 14-7-2005.
		Motivo: Se permite el mantenimiento de la cédula.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 26-7-2005.
		Motivo: Se incluyen las Cuentas destino del benefiario.	
 --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "ListaEmpleados" default = "Lista Empleados" returnvariable="ListaEmpleados" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default = "Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nombre" default = "Nombre" returnvariable="LB_Nombre" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Apellido1" default = "Apellido 1" returnvariable="LB_Apellido1" xmlfile = "LiquidacionAnticipos_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Apellido2" default = "Apellido 2" returnvariable="LB_Apellido2" xmlfile = "LiquidacionAnticipos_form.xml">
<cf_dbfunction name="op_concat" returnvariable="CAT">
<cfif isdefined('url.fTESBeneficiario') and not isdefined('form.fTESBeneficiario')>
	<cfset form.fTESBeneficiario = url.fTESBeneficiario>
</cfif>
<cfif isdefined('url.fTESBeneficiarioID') and not isdefined('form.fTESBeneficiarioID')>
	<cfset form.fTESBeneficiarioID = url.fTESBeneficiarioID>
</cfif>
<cfif isdefined('url.TESBId') and not isdefined('form.TESBId')>
	<cfset form.TESBId = url.TESBId>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("url.PageNum2") and len(trim(url.PageNum2))>
	<cfset form.Pagina2 = url.PageNum2>
</cfif>

<cfif not isdefined("form.solicitudmanual")>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cf_templateheader title="Mantenimiento a Beneficiarios de Contado">
		<cf_web_portlet_start titulo="Mantenimiento a Beneficiarios de Contado">
			<cfset fnCarnita()>
		<cf_web_portlet_end>
	<cf_templatefooter>	

<cfelse>
	<cfset fnCarnita()>
</cfif>

<cffunction name="fnCarnita" output="true">
	<style type="text/css">
	<!--
	.style1 {
		color: FF0000;
		font-weight: bold;
	}
	-->
	</style>

	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	
	<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
	<cfset LvarDEid = ''>
	<cfparam name="form.TESBid" default="0">
	<cfif isdefined("form.TESBid") and form.TESBid gt 0>
		<cfquery datasource="#session.dsn#" name="data">
			select TESBeneficiarioId, 
					TESBeneficiario, 
					TESBid, TESBactivo,
					TESBtipoId, 
					id_direccion, 
					TESBtelefono, 
					TESBfax, 
					TESBemail, TESRPTCid,
					ts_rversion,TESBidentificacion,
					DEid
			  from TESbeneficiario
			 where TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESBid#">
			   and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.CEcodigo#">
		</cfquery>



		<cfset LvarDEid = data.DEid>
	</cfif>
	<!--- <cfdump var="#LvarDEid#"> --->
	<cfquery name="rsMasks" datasource="#Session.dsn#">
		select J.Pvalor Juridica, F.Pvalor Fisica, E.Pvalor Extranjera
		from Parametros J, Parametros F, Parametros E
		where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and J.Pcodigo = 620
		  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and F.Pcodigo = 630
		  and E.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and E.Pcodigo = 5600
	</cfquery>
	
	
	<cfif isdefined("form.TESBid") and form.TESBid gt 0>
		<cfset CAMBIO = data.RecordCount>
	<cfelse>
		<cfset CAMBIO = 0>
	</cfif>

	<cfoutput>
	<form action="Beneficiarios_sql.cfm"  method="post" name="form1">
	<cfif isdefined('form.fTESbeneficiario')>
		<input name="fTESbeneficiario" type="hidden" value="#form.fTESbeneficiario#">
	</cfif>
	<cfif isdefined('form.fTESbeneficiarioID')>
		<input name="fTESbeneficiarioID" type="hidden" value="#form.fTESbeneficiarioID#">
	</cfif>
	<cfif isdefined("form.solicitudmanual")>
		<input name="solicitudmanual" type="hidden" value="true">
	</cfif>
	<input name="Pagina" type="hidden" value="#form.Pagina#">
		<table summary="Tabla de entrada" border="0" width="60%" align="center">
			<tr>
				<td width="10%" valign="top" colspan="4" nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" class="subTitulo">
					Beneficiarios
				</td>
			</tr>
			<tr>
					<input name="TESBId" id="TESBId" type="hidden" value="#HTMLEditFormat(form.TESBId)#">
				<td valign="top" nowrap><strong>Tipo&nbsp;de&nbsp;Beneficiario:</strong>&nbsp;</td>
				<td valign="top"><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
			</tr>
			<tr>
				<td valign="middle">
				<cfif CAMBIO NEQ 1> <!--- se manda el campo como hidden para poder deshabilitarlo en cambio --->
					<cfset LvarSNtipo = rsMasks.Fisica>
					<select name="TESBtipoId" onChange="cambiarMascara(this.value);" tabindex="1">
						<option value="F" <cfif (isDefined("data.TESBtipoId") AND "F" EQ data.TESBtipoId)>selected</cfif>>F&iacute;sica</option>
						<option value="J" <cfif (isDefined("data.TESBtipoId") AND "J" EQ data.TESBtipoId)>selected</cfif>>Jur&iacute;dica</option>
						<option value="E" <cfif (isDefined("data.TESBtipoId") AND "E" EQ data.TESBtipoId)>selected</cfif>>Extranjero</option>
					</select>
				<cfelse>
					<cfif (isDefined("data.TESBtipoId") AND "F" EQ data.TESBtipoId)>
						<cfset LvarSNtipo = rsMasks.Fisica>
						<input type="hidden" value="F" name="TESBtipoId" tabindex="-1">
						<input type="text" readonly value="F&iacute;sica" size="10" tabindex="-1">
					<cfelseif (isDefined("data.TESBtipoId") AND "J" EQ data.TESBtipoId)>
						<cfset LvarSNtipo = rsMasks.Juridica>
						<input type="hidden" value="J" name="TESBtipoId">
                        <input name="text" type="text" value="Jur&iacute;dica" size="10" readonly tabindex="-1">
					<cfelseif (isDefined("data.TESBtipoId") AND "E" EQ data.TESBtipoId)>
						<cfset LvarSNtipo = RepeatString("*", 30)>
						<input type="hidden" value="E" name="TESBtipoId">
                        <input name="text" type="text" value="Extranjero" size="10" readonly tabindex="-1">
					</cfif>
				</cfif>
					<!--- <cfif modo neq 'ALTA'>
						<input type="checkbox" name="SNinactivo" id="SNinactivo" <cfif modalidad.readonly or (modo NEQ "ALTA" and rsSocios.SNcodigo eq 9999)>disabled</cfif> value="1" 
							<cfif modo NEQ "ALTA" and rsSocios.SNinactivo EQ 1>checked</cfif>>
						<label for="SNinactivo"><strong>Inactivo</strong></label>
					</cfif> --->
				</td>
				<!--- <td valign="middle">
					<cfif modo neq 'ALTA'>
						<cfif modalidad.modalidad>
							<input type="checkbox" name="es_corporativo" id="es_corporativo" value=""
								<cfif Len(rsSocios.SNidCorporativo)>checked</cfif>
								disabled><label for="es_corporativo">Cliente corporativo</label>
						</cfif>
					</cfif></td> --->
				<td>
					<input type="text" name="TESBeneficiarioId" 
                        style="width:200px" tabindex="1"
                        onfocus="javascript:this.select();"
                        value="<cfif CAMBIO>#trim(data.TESBeneficiarioId)#</cfif><cfif isdefined("form.TESBeneficiarioIdPopUp") and len(trim(form.TESBeneficiarioIdPopUp))>#form.TESBeneficiarioIdPopUp#</cfif>" 
                   	>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<input type="text" name="TESBmask" readonly value="#LvarSNtipo#" style="border:none; width:200px;" tabindex="-1">
				</td>
			</tr>
	
			</tr>
			<tr>
				<td valign="top" nowrap><strong>Nombre&nbsp;Beneficiario:&nbsp;</strong></td>
				<td valign="top" nowrap><strong>Concepto Pago a Terceros:&nbsp;</strong></td>
			</tr>
			<tr>
				<td valign="top">
					<input name="TESBeneficiario" id="TESBeneficiario" type="text" maxlength="255" size="60" tabindex="1"
						value="<cfif isdefined("data.TESBeneficiario")>#HTMLEditFormat(data.TESBeneficiario)#</cfif>" onfocus="this.select()">
				</td>
				<td>
					<cfif CAMBIO>
						<cf_cboTESRPTCid query="#data#" tabindex="1">
					<cfelse>
						<cf_cboTESRPTCid tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td valign="top" nowrap><strong>Empleado:&nbsp;</strong></td>
				<td valign="top" nowrap><strong>&nbsp;</strong></td>
			</tr>
			<tr>
				<td>
					<cfif LvarDEID NEQ ''>
						<cfquery datasource="#session.dsn#" name="dEmpleado">
							select d.DEid, DEidentificacion, DEnombre #CAT#' '#CAT# DEapellido1 #CAT#' '#CAT# coalesce(DEapellido2,'') as DEnombreTodo,DEnombre,DEapellido1,DEapellido2
							from DatosEmpleado d
							where DEid=#LvarDEID#
						</cfquery>
						<input type="hidden" value="DEid" name="#LvarDEID#">
						<input name="nameEmpelado" id="nameEmpelado" type="text" maxlength="255" size="60" tabindex="1"
						value="#dEmpleado.DEnombreTodo#" readonly>
					<cfelse>
						<cf_conlis title="#ListaEmpleados#"
                                    campos = "DEid, DEidentificacion, DEnombreTodo,RFC"
                                    desplegables = "N,S,S,N"
                                    modificables = "N,S,N,N"
                                    size = "0,15,34,35"
                                    asignar="DEid, DEidentificacion, DEnombreTodo,RFC"
                                    asignarformatos="S,S,S"
                                    tabla="DatosEmpleado d
											left outer join TESbeneficiario b
												on d.DEid = b.DEid"
                                    columnas="distinct d.DEid, DEidentificacion+'' as DEidentificacion, DEnombre #CAT#' '#CAT# DEapellido1 #CAT#' '#CAT# coalesce(DEapellido2,'') as DEnombreTodo,DEnombre,DEapellido1,DEapellido2,RFC"
                                    filtro=" b.TESBid is null and d.Ecodigo = #Session.Ecodigo# order by DEidentificacion"
                                    desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
                                    etiquetas="#LB_Identificacion#,#LB_Nombre#,#LB_Apellido1#,#LB_Apellido2#"
                                    formatos="S,S,S,S,S"
                                    align="left,left,left,left,left"
                                    showEmptyListMsg="true"
                                    EmptyListMsg=""
                                    form="form1"
                                    width="800"
                                    height="500"
                                    left="70"
                                    top="20"
                                    filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
                                    index="1"
                                    traerInicial="#LvarDEID NEQ ''#"
                                    traerFiltro="d.DEid=#LvarDEid#"
                                    funcion="funcCambiaDEid"
                                    />
					</cfif>
					
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			 
            <!--- SML. 15/10/2014 Modificacion para agregar el RFC al beneficiario --->
            <tr>
            	<td>
                	<strong>RFC:</strong>&nbsp;
            	</td>
           		<td>
                </td>
			</tr>
            <tr>
            	<td>
                	<input type="text" name="TESBidentificacion" id="TESBidentificacion" value="<cfif isdefined("data.TESBeneficiario")>#HTMLEditFormat(data.TESBidentificacion)#</cfif>" />
            	</td>
           		<td>
                </td>
			</tr>
            <!---SML--->
			<tr>
            	<td>
                	<strong>Activo:</strong>&nbsp;
            		<input type="checkbox" name="TESBactivo" <cfif (isDefined("data.TESBactivo") AND data.TESBactivo EQ "1")>checked</cfif> value="1"/>
            	</td>
                <cfif CAMBIO>
                    <td style="display:none">
                        <cf_conlis
                            form="form1"
                            Campos="BITACORA"
                            Desplegables="S"
                            Modificables="N"
                            Size="10"
        
                            Title="Bitacora de Modificaciones a #data.TESBeneficiario#"
                            Tabla="TESbeneficiarioBitacora b
                                    left join Usuario u
                                       on u.Usucodigo = b.BMUsucodigo
                                     "
                            Columnas="
                                    0 as BITACORA,
                                    TESBfecha,
                                    case TESBactivo when 1 then 'ACTIVO' else 'INACTIVO' end as Activo,
                                    TESBtipoId,
                                    TESBeneficiarioId,
                                    TESBeneficiario,
                                    TESRPTCid,
                                    Usulogin	
                                "
                            Filtrar_por=""
                            Filtro="
                                    TESBid = #form.TESBid#
                                    order by TESBfecha desc
                                    "
                            Desplegar="TESBfecha, Activo, TESBtipoId,TESBeneficiarioId,TESBeneficiario,TESRPTCid, Usulogin"
                            Etiquetas="Cambio, Status, Tipo, Identificacion, Nombre, Concepto Pago, Usuario"
                            Formatos="DT,S,S,S,S,S"
                            Align="left,left,center,left,left,left"
        
                            MaxRowsQuery="200"
                            width="800"
                        />
                    </td>
                </cfif>
			</tr>
			<tr>
				<td style="width:40%" colspan="1" rowspan="6" valign="top">
					<cfif IsDefined('data.id_direccion') And Len(data.id_direccion)>
						<!--- <cfif modalidad.readonly>
							<div style="width:80% ">
						  <cf_sifdireccion action="display" key="#data.id_direccion#"></div>
						<cfelse> --->
						  <cf_sifdireccion action="input" key="#data.id_direccion#"  tabindex="1">
						<!--- </cfif> --->
					<cfelse>
						  <cf_sifdireccion action="input" tabindex="1">
					</cfif></td>
				<td valign="top"><strong>Tel&eacute;fono:&nbsp;</strong></td>
			</tr>
			<tr>
				<td valign="top">
					<input name="TESBtelefono" type="text" style="width:200px" maxlength="30" tabindex="1"
						value="<cfif CAMBIO>#trim(data.TESBtelefono)#</cfif>" 
						onFocus="javascript:this.select();" alt="El campo Tel&eacute;fono del Beneficiario">
				</td>
			</tr>
			<tr>
				<td valign="top"><strong>Fax:&nbsp;</strong></td>
			</tr>
			<tr>
				<td valign="top">
					<input name="TESBfax" type="text" style="width:200px" maxlength="30" tabindex="1"
					onFocus="javascript:this.select();" 
					value="<cfif CAMBIO>#trim(data.TESBfax)#</cfif>" alt="El campo Fax del Beneficiario"></td>
			</tr>	
			<tr>
				<td valign="top"><strong>Correo&nbsp;electr&oacute;nico:</strong></td>
			</tr>
			<tr>
				<td valign="top">
					<input name="TESBemail" type="text" style="width:200px"  maxlength="100" tabindex="1"
						onBlur="return document.MM_returnValue" 
						value="<cfif CAMBIO>#Trim(data.TESBemail)#</cfif>" 
						onFocus="javascript:this.select();" alt="El campo E-Mail del Beneficiario">
				</td>
			</tr>
			<tr>
				<!--- <td width="10%" valign="top" nowrap>&nbsp;</td> --->
				<td colspan="5" class="formButtons" align="center">
				<cfif isdefined("data") and data.RecordCount>
					<cf_botones modo='CAMBIO' include="Bitacora,IrLista" includevalues="Bitacora,Lista Beneficiarios" tabindex="1">
				<cfelse>
					<cf_botones modo='ALTA' include="IrLista" includevalues="Lista Beneficiarios" tabindex="1"	>
				</cfif>
				</td>
			</tr>
		</table>
		
			
		
		<cfset ts = "">
		<cfif CAMBIO>
		  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		  </cfinvoke>
		  <input type="hidden" name="ts_rversion" value="<cfif CAMBIO>#ts#</cfif>" size="32">
		</cfif>
		
	</form>
	</cfoutput>
	
	
	<script type="text/javascript" language="javascript">
		var f = document.form1;
		<cfoutput>
		var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
		oCedulaMask.attach(document.form1.TESBeneficiarioId, oCedulaMask.mask, "string");
	
		function cambiarMascara(v) 
		{
			document.form1.TESBeneficiarioId.value = "";
			if (v == 'F')
			{
				oCedulaMask.mask = "#replace(rsMasks.Fisica,'X','##','ALL')#";
				document.form1.TESBmask.value = "#rsMasks.Fisica#";
			}
			else if (v == 'J')
			{
				oCedulaMask.mask = "#replace(rsMasks.Juridica,'X','##','ALL')#";
				document.form1.TESBmask.value = "#rsMasks.Juridica#";
			}
			else if (v == 'E')
			{
				oCedulaMask.mask = "#replace(rsMasks.Extranjera,'X','##','ALL')#";
				document.form1.TESBmask.value = "#rsMasks.Extranjera#";
			}
		}
		</cfoutput>
	</script>
	
	 
	<cf_qforms form ="form1" objForm = "objForm1">
	<script language="javascript" type="text/javascript">


		function funcCambiaDEid(){

			
			$("input[name=TESBeneficiarioId]").val($("##DEidentificacion").val());
			$("input[name=TESBeneficiario]").val($("##DEnombreTodo").val());

			$("input[name=TESBidentificacion]").val($("##RFC").val());
		}
		
	<!-- //
		function validaform()
		{
			objForm1.TESBeneficiarioId.required = true;
			objForm1.TESBeneficiarioId.description="Identificacion";
			objForm1.TESBeneficiario.required = true;
			objForm1.TESBeneficiario.description="Beneficiario";
			objForm1.TESBidentificacion.required = true;
			objForm1.TESBidentificacion.description="RFC";
			objForm1.TESBemail.validateEmail();
		}
		function NOvalidaform()
		{
			objForm1.TESBeneficiarioId.required = false;
			objForm1.TESBeneficiario.required = false;
		}
		
		function funcAlta()
		{
			validaform();
		}
		function funcCambio()
		{
			validaform();
		}
	
		function funcIrLista()
		{ 
			NOvalidaform();
			location.href = 'Beneficiarios.cfm?Pagina=#form.Pagina#<cfif isdefined('form.fTESbeneficiario')>&fTESbeneficiario=#form.fTESbeneficiario#</cfif><cfif isdefined('form.fTESbeneficiarioID')>&fTESbeneficiarioID=#form.fTESbeneficiarioID#</cfif>';
			return false;
		}
		function funcBitacora()
		{ 
			doConlisBITACORA();
			return false;
		}
	//-->	
	</script><!--- --->
</cffunction>
