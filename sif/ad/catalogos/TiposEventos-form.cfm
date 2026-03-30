<style>
	#layer1 {
	position: absolute;
	visibility: hidden;
	width: 400px;
	height: 90px;
	left: 20px;
	top: 300px;
	background-color: #ccc;
	border: 1px solid #000;
	padding: 10px;
}
#close {
	float: right;
}
</style>

<cfparam name="Request.jsMask" default="false">
<cfparam name="ETELeligido.TEVECodigo" default="">

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>

<cfif isdefined("url.TEVECodigo") and not isdefined("form.TEVECodigo") and len(trim(url.TEVECodigo))>
	<cfset form.TEVECodigo = url.TEVECodigo>
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="TE" datasource="#session.dsn#">
		select TEVid  , TEVcodigo, TEVDescripcion
		from TipoEvento
		where TEVid  = #form.TEVid#
	</cfquery>
	<cfif isdefined('form.TEVECodigo') and len(trim(form.TEVECodigo)) GT 0>
		<cfinvoke component="sif.Componentes.ControlEventos" method="GET_ESTADOS" returnvariable="ETELeligido">
			<cfinvokeargument name="TEVid"       value="#form.TEVid#">
			<cfinvokeargument name="TEVECodigo"  value="#form.TEVECodigo#">
	</cfinvoke>
	</cfif>
	<cfset MostrarValoreLista = 'YES'>
</cfif>

<cfif isdefined('form.TEVid') and len(trim(form.TEVid)) and isdefined('form.TEVECodigo') and len(trim(form.TEVECodigo)) and not isdefined('url.Nuevo') >
	<cfset modoDet = 'CAMBIO'>
	<cfset modoDete = 'ALTA'>
<cfelseif isdefined('form.btnNuevo') OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo'))>
	<cfset modoDet = 'ALTA'>
	<cfset modoDete = 'ALTA'>
<cfelse>
	<cfset modoDet = 'ALTA'>
	<cfset modoDete = 'ALTA'>
</cfif>

<table border="0" width="100%">
		<tr>
			<td colspan="2" align="center">
			<form name="form1" action="TiposEventos-sql.cfm" method="post">
				<table>
					<tr>
						<td><input type="hidden" name="MostrarValoreLista" value="<cfoutput>#MostrarValoreLista#</cfoutput>">	</td>
						<td><cfif modo EQ 'CAMBIO'><input type="hidden" name="TEVid" value="<cfoutput>#form.TEVid#</cfoutput>"></cfif>	</td>
					</tr>
				
					<tr>
						<td align="right">Codigo:</td><td><input name="TEVcodigo" 	 type="text" value="<cfoutput>#TE.TEVcodigo#</cfoutput>" 	 size="30" maxlength="10"> 
						</td>
					</tr>
					<tr>
						<td align="right">Descripción:</td>
						<td><input name="TEVDescripcion" type="text" value="<cfoutput>#TE.TEVDescripcion#</cfoutput>" size="30" maxlength="100"></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="2"><cfif modo eq 'CAMBIO'><cf_botones modo="#modo#" include="Regresar"><cfelse><cf_botones modo="#modo#"></cfif></td><tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
					<cf_qforms objForm="objForm1" form="form1">
						<cf_qformsRequiredField name="TEVcodigo" 	 		description="Codigo">
						<cf_qformsRequiredField name="TEVDescripcion" 	description="Descripción">
					</cf_qforms>
			</td>
		</tr>
	
			<cfif modo EQ 'CAMBIO'>
			<tr>
				<td width="50%" class="tituloListas">Datos Variables
					<table>
						<form name="form3" action="TiposEventos-sql.cfm" method="post">
							<td><cfif modo EQ 'CAMBIO'><input type="hidden" name="TEVid" value="<cfoutput>#form.TEVid#</cfoutput>"></cfif>	</td>
						 <tr>
							<td> 
								 <cfinclude template="conlisTipoEvento.cfm">
								 <cfset Tipificacion = StructNew()>
									<cfset temp = StructInsert(Tipificacion, "TEV", "#TE.TEVid#")> 
									<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="rsDatosVariables">
										<cfinvokeargument name="DVTcodigoValor"       value="TEV">
										<cfinvokeargument name="Tipificacion"         value="#Tipificacion#">
										<cfinvokeargument name="DVVidTablaVal"        value="#TE.TEVid#">
										<cfinvokeargument name="FunctionDelete"       value="changeFormActionforDetalles">
										<cfinvokeargument name="DVidname"       		 value="idDatoVariable">
									</cfinvoke>
							</td>
							<td align="center"><cf_botones sufijo='Dete' modo='#modoDete#' exclude="Limpiar,baja,Nuevo,Cambio" tabindex="2"></td>
						</tr>
							<td>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
								<cfinvokeargument name="query" 				value="#rsDatosVariables#"/>
								<cfinvokeargument name="desplegar" 			value="DVcodigo, DVdescripcion, DVtipoDato, DVobligatorio,borrar"/>
								<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion,Tipo,Obligatorio,"/>
								<cfinvokeargument name="formatos" 			value="S,S,S,U,US"/>
								<cfinvokeargument name="align" 				value="left,left,left,left,left"/>
								<cfinvokeargument name="formName" 			value="form3"/>
								<cfinvokeargument name="checkboxes" 		value="N"/>
								<cfinvokeargument name="keys" 				value="idDatoVariable"/>
								<cfinvokeargument name="ira" 					value="TiposEventos.cfm"/>
								<cfinvokeargument name="MaxRows" 			value="10"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="PageIndex" 			value="3"/>
							</cfinvoke>	
						</form>	
				</table>
				</td>
		</cfif>

		<cfif modo EQ 'CAMBIO'>
			<td width="50%" class="tituloListas">Estados
				<table>
						<cfinvoke component="sif.Componentes.ControlEventos" method="GET_ESTADOS" returnvariable="CamposForm">
							<cfinvokeargument name="TEVid"  value="#form.TEVid#">
						</cfinvoke>

					<form name="form2" action="TiposEventos-sql.cfm" method="post">
					
						<tr><td>Codigo:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<cfoutput><input name="codigo" type="text" value="#ETELeligido.TEVECodigo#" size="30" maxlength="10"></cfoutput> 
						</td></tr>
						
						<tr><td>Descripción:<input name="descripcion" type="text" value="<cfif modoDet EQ 'CAMBIO'><cfoutput>#ETELeligido.TEVEDescripcion#</cfoutput></cfif>" size="30" maxlength="100"></td></tr>
						
						<tr><td>Notifica:<input type="checkbox" name="TEVENotifica_chk" tabindex="1"  value="1"
						<cfif modoDet EQ 'CAMBIO' and #ETELeligido.TEVENotifica# EQ 1> checked </cfif>></td></tr>

						<tr><td colspan="2"><cf_botones sufijo='Det' modo='#modoDet#' tabindex="2"></td><tr>
						<td><cfif modo EQ 'CAMBIO'><input type="hidden" name="idTEV" value="<cfoutput>#form.TEVid#</cfoutput>"></cfif>	</td>
						
						
						<cfquery name="rsEstad" dbtype="query">
							select TEVid,TEVECodigo,TEVEDescripcion,TEVEdefaultlabel,TEVENotificalabel from CamposForm order by TEVECodigo
						</cfquery>
						
						
						<tr><td><cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
						<cfinvokeargument name="query" 					value="#rsEstad#"/>
						<cfinvokeargument name="desplegar" 				value="TEVECodigo,TEVEDescripcion,TEVEdefaultlabel,TEVENotificalabel"/>
						<cfinvokeargument name="etiquetas" 				value="Codigo,Descripción,Default,Notifica"/>
						<cfinvokeargument name="formatos" 				value="S,S,US,US"/>
						<cfinvokeargument name="align" 					value="left,left,left,left"/>
						<cfinvokeargument name="checkboxes" 			value="N"/>
						<cfinvokeargument name="keys" 					value="TEVid,TEVECodigo"/>
						<cfinvokeargument name="MaxRows" 				value="10"/>
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						<cfinvokeargument name="PageIndex" 				value="2"/>
						<cfinvokeargument name="lineaAzul" 		    	value="true"/>
						<cfinvokeargument name="formName" 		    	value="form2"/>
						<cfinvokeargument name="ira" 						value="TiposEventos.cfm"/>
						<cfinvokeargument name="incluyeForm" 			value="false"/>
					</cfinvoke>	</td></tr>
					</form>
					
	
					<cfif modo EQ 'CAMBIO'>
						<cf_qforms objForm="objForm2" form="form2">
							<cf_qformsRequiredField name="codigo" 	 		description="Codigo">
							<cf_qformsRequiredField name="descripcion" 	description="Descripción">
						</cf_qforms>	
					</cfif>
				</table>
			</td></tr></cfif>	
	</table>

<script language="javascript" type="text/javascript">
	<cfif modo EQ 'CAMBIO'>
		var Mask_1 = new Mask("##", "string");
		Mask_1.attach(document.form2.codigo, Mask_1.mask, "string");
	</cfif>

	function funcAlta(){
			objForm1.TEVcodigo.description = "Código";
			objForm1.TEVDescripcion.description = "Descripción";
			setRequired(true,false)
	 } 
	 
			
	function funcCambio(){
			objForm1.TEVcodigo.description = "Código";
			objForm1.TEVDescripcion.description = "Descripción";
			setRequired(true,false)
	 } 
	
	function funcAltaDet(){
			objForm2.codigo.description = "Código";
			objForm2.descripcion.description = "Descripción";
			setRequired(false,true)
	 } 
	 
	function funcAltaDete(){
			setRequired(false,false)
	 } 	
	 
	
	 function funcCambioDet(){
	 
			objForm2.codigo.description = "Código";
			objForm2.descripcion.description = "Descripción";
			setRequired(false,true)
	 }
	
	function setRequired(e,d){
			objForm1.TEVcodigo.required = e;
			objForm1.TEVDescripcion.required = e;
	
			objForm2.codigo.required = d;
			objForm2.descripcion.required = d;
	}
	
		function funcRegresar(){
			setRequired(false,false)
			location.href = 'TiposEventos.cfm';
			return false;
		}
		
	// Cambia el Action del Form
	<cfif (modo eq "CAMBIO")>
		function changeFormActionforDetalles() { 
			if (confirm('¿Desea Eliminar el Registro?')){
			setRequired(false,false)
				document.form3.action = "TiposEventos-sql.cfm?BAJADETE=true";
			}
		}	
	</cfif>
</script>

	
