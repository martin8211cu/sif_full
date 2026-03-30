<!---
	Creado por Gustavo Fonseca Hernández.
	Fecha: 8-6-2005.
	Motivo: Creación del tag para los beneficiarios.
 --->

<!--- parametros para llamado del conlis --->

<!---
<cfdump var="#form#">
<cf_dump var="#url#">--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Titulo" default="Lista de Beneficiarios" returnvariable="LB_Titulo"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nombre" default="Nombre" returnvariable="LB_Nombre"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fax" 	 default="Fax" 	 returnvariable="LB_Fax" xmlfile="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fisica" default="F&iacute;sica" returnvariable="LB_Fisica"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Juridica" default="Jur&iacute;dica" returnvariable="LB_Juridica"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Extranjero" default="Extranjero" returnvariable="LB_Extranjero"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NomBen" default="Nombre Beneficiario" returnvariable="LB_NomBen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Activo" default="Activo" returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConcPagoTer" default="Concepto Pago a Terceros Default" returnvariable="LB_ConcPagoTer"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Telefono" default="Tel&eacute;fono" returnvariable="LB_Telefono"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CorreoElect" default="Correo&nbsp;electr&oacute;nico" returnvariable="LB_CorreoElect"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CmpFaxBene" default="El campo Fax del Beneficiario" returnvariable="LB_CmpFaxBene"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CmpTelBene" default="El campo Tel&eacute;fono del Beneficiario" returnvariable="LB_CmpTelBene"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CmpMailBene" default="El campo E-Mail del Beneficiario" returnvariable="LB_CmpMailBene"
xmlfile="ConlisBeneficiarios.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Beneficiario" default="Beneficiario" returnvariable="LB_Beneficiario"
xmlfile="ConlisBeneficiarios.xml"/>


<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>

	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>

<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>

<cfif isdefined("Url.CargaCtaOrigen") and not isdefined("Form.CargaCtaOrigen")>
	<cfparam name="Form.CargaCtaOrigen" default="#Url.CargaCtaOrigen#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo, desc) {
	if (window.opener != null) {
		<cfoutput>
		<!--- valida llamada a datos cta origen (Eduardo González) --->
		<cfif isDefined("Form.CargaCtaOrigen") AND #Form.CargaCtaOrigen# EQ "SI">
			fnCargaCtaOrigenBen(id);
			fnCargaMEOrigenBen(id);
		</cfif>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;

		if (window.opener.funcLimpia#form.id#) {window.opener.funcLimpia#form.id#()}
		window.opener.document.#form.formulario#.#form.codigo#.focus();
		</cfoutput>
		window.close();
	}
}

function fnCargaCtaOrigenBen(SNcodigo) {
	    var ajaxRequest; // The variable that makes Ajax possible!
	    var vID_tipo_gasto = '';
	    var vmodoD = '';
	    try {
	        // Opera 8.0+, Firefox, Safari
	        ajaxRequest = new XMLHttpRequest();
	    } catch (e) {
	        // Internet Explorer Browsers
	        try {
	            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
	        } catch (e) {
	            try {
	                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
	            } catch (e) {
	                // Something went wrong
	                alert("Your browser broke!");
	                return false;
	            }
	        }
	    }
	    ajaxRequest.open("GET", '/cfmx/sif/tesoreria/Solicitudes/ajaxTESMedioPago.cfm?modo=solPagoManualCTABen&SNcodigo='+SNcodigo, false);
	    ajaxRequest.send(null);
	    window.opener.document.getElementById("datosCtaOrigen").innerHTML = ajaxRequest.responseText;
	}

	function fnCargaMEOrigenBen(SNcodigo) {
	    var ajaxRequest; // The variable that makes Ajax possible!
	    var vID_tipo_gasto = '';
	    var vmodoD = '';
	    try {
	        // Opera 8.0+, Firefox, Safari
	        ajaxRequest = new XMLHttpRequest();
	    } catch (e) {
	        // Internet Explorer Browsers
	        try {
	            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
	        } catch (e) {
	            try {
	                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
	            } catch (e) {
	                // Something went wrong
	                alert("Your browser broke!");
	                return false;
	            }
	        }
	    }
	    ajaxRequest.open("GET", '/cfmx/sif/tesoreria/Solicitudes/ajaxTESMedioPago.cfm?modo=solPagoManualMPBen&SNcodigo='+SNcodigo, false);
	    ajaxRequest.send(null);
	    window.opener.document.getElementById("medioPago").innerHTML = ajaxRequest.responseText;
	}
</script>
</script>

<!--- if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()} --->

<!--- Filtro --->
<cfif isdefined("Url.TESBeneficiarioId") and not isdefined("Form.TESBeneficiarioId")>
	<cfparam name="Form.TESBeneficiarioId" default="#Url.TESBeneficiarioId#">
</cfif>
<cfif isdefined("Url.TESBeneficiario") and not isdefined("Form.TESBeneficiario")>
	<cfparam name="Form.TESBeneficiario" default="#Url.TESBeneficiario#">
</cfif>
<cfif isdefined("Url.TESBid") and not isdefined("Form.TESBid")>
	<cfparam name="Form.TESBid" default="#Url.TESBid#">
</cfif>

<cfset sbAgregar()>

<cfset filtro = "">
<cfset descripcion = "Beneficiarios" >

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >
<cfif isdefined("Form.TESBeneficiarioId") and Len(Trim(Form.TESBeneficiarioId)) NEQ 0>
	<cfset filtro = filtro & " and upper(TESBeneficiarioId) like '%" & UCase(Form.TESBeneficiarioId) & "%'">
	<cfset navegacion = navegacion & "&TESBeneficiarioId=" & Form.TESBeneficiarioId>
</cfif>
<cfif isdefined("Form.TESBeneficiario") and Len(Trim(Form.TESBeneficiario)) NEQ 0>
 	<cfset filtro = filtro & " and upper(TESBeneficiario) like '%" & UCase(Form.TESBeneficiario) & "%'">
	<cfset navegacion = navegacion & "&TESBeneficiario=" & Form.TESBeneficiario>
</cfif>

<html>
<head>
<!---<title>Lista de <cfoutput>#descripcion#</cfoutput></title>--->
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table id="table1" width="100%" cellpadding="2" cellspacing="0">

	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisBeneficiarios.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong><cf_translate key=LB_Identificacion>Identificaci&oacute;n</cf_translate>:</strong></td>
				<td>
					<input name="TESBeneficiarioId" type="text" id="codigo" size="20" maxlength="20" onClick="this.select();" value="<cfif isdefined("Form.TESBeneficiarioId")>#Form.TESBeneficiarioId#</cfif>">
				</td>
				<td align="right"><strong><cf_translate key=LB_Nombre>Nombre</cf_translate>:</strong></td>
				<td>
					<input name="TESBeneficiario" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.TESBeneficiario")>#Form.TESBeneficiario#</cfif>">
				</td>
				<td align="center">
					<cfoutput><input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#"></cfoutput>
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<cfif isdefined("form.CargaCtaOrigen") and len(trim(form.CargaCtaOrigen))>
						<input type="hidden" name="CargaCtaOrigen" value="#form.CargaCtaOrigen#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>

	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select TESBid, TESBeneficiarioId, TESBeneficiario
			from TESbeneficiario
			where CEcodigo = #session.CEcodigo#
			  		#preserveSingleQuotes(filtro)#
            and TESBactivo = 1
			order by TESBeneficiarioId

		</cfquery>

		<cfinvoke
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="TESBeneficiarioId, TESBeneficiario"/>
			<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisBeneficiarios.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="TESBid, TESBeneficiarioId, TESBeneficiario"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>
	<tr><td align="center">
    	<cfoutput>
        	<input type="button" value="#BTN_Nuevo#" onClick="getElementById('table1').style.display='none';getElementById('table2').style.display='';">
		</cfoutput>
    </td></tr>
</table>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>


<cfquery name="rsMasks" datasource="#Session.dsn#">
	select J.Pvalor Juridica, F.Pvalor Fisica
	from Parametros J, Parametros F
	where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and J.Pcodigo = 620
	  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and F.Pcodigo = 630
</cfquery>
<cfoutput>
	<form id="table2" action="ConlisBeneficiarios.cfm?#CGI.QUERY_STRING#"  method="post" name="formTESB" style="display:none;">
		<table summary="Tabla de entrada" border="0" width="60%" align="center" style="font-size:9px">
			<tr>
					<td valign="top"><strong>#LB_Identificacion#:</strong>&nbsp;</td>
			</tr>
			<tr>
				<td valign="middle" nowrap="nowrap">
					<cfset LvarSNtipo = rsMasks.Fisica>
					<select name="TESBtipoId" onChange="cambiarMascara(this.value);" tabindex="1">
						<option value="F">#LB_Fisica#</option>
						<option value="J">#LB_Juridica#</option>
						<option value="E">#LB_Extranjero#</option>
					</select>
					<input type="text" name="TESBeneficiarioId"
                        style="width:200px" tabindex="1"
                        onfocus="javascript:this.select();"
                        value=""
                   	>
					&nbsp;&nbsp;
					<input type="text" name="TESBmask" readonly value="#LvarSNtipo#" style="border:none; width:200px;" tabindex="-1">
				</td>
			</tr>

			</tr>
			<tr>
				<td valign="top" nowrap><strong>#LB_NomBen#:&nbsp;</strong></td>
			</tr>
			<tr>
				<td valign="top">
					<input name="TESBeneficiario" id="TESBeneficiario" type="text" maxlength="255" size="60" tabindex="1"
						value="<cfif isdefined("data.TESBeneficiario")>#HTMLEditFormat(data.TESBeneficiario)#</cfif>" onFocus="this.select()">
				</td>
				<td>
				</td>
			</tr>
			<tr>
            	<td nowrap="nowrap">
                	<strong>#LB_Activo#:</strong>&nbsp;
            		<input type="checkbox" name="TESBactivo" <cfif NOT isDefined("data.TESBactivo") OR data.TESBactivo EQ "1">checked</cfif> value="1"/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>#LB_ConcPagoTer#:&nbsp;</strong>
					<cf_cboTESRPTCid tabindex="1">
            	</td>
			</tr>
			<!---  --->
			<tr>
				<td style="width:40%" colspan="1" valign="top">
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
			</tr>
			<tr><td><table>
			<tr>
				<td valign="top" align="right"><strong>#LB_Telefono#:&nbsp;</strong></td>
				<td valign="top">
					<input name="TESBtelefono" type="text" style="width:200px" maxlength="30" tabindex="1"
						value=""
						onFocus="javascript:this.select();" alt="#LB_CmpTelBene#">
				</td>
			</tr>
			<tr>
				<td valign="top" align="right"><strong>#LB_Fax#:&nbsp;</strong></td>
				<td valign="top">
					<input name="TESBfax" type="text" style="width:200px" maxlength="30" tabindex="1"
					onFocus="javascript:this.select();"
					value="" alt="#LB_CmpFaxBene#"></td>
			</tr>
			<tr>
				<td valign="top" align="right"><strong>#LB_CorreoElect#:</strong></td>
				<td valign="top">
					<input name="TESBemail" type="text" style="width:200px"  maxlength="100" tabindex="1"
						onBlur="return document.MM_returnValue"
						value=""
						onFocus="javascript:this.select();" alt="#LB_CmpMailBene#">
				</td>
			</tr>
			</table></td></tr>
			<tr>
				<!--- <td width="10%" valign="top" nowrap>&nbsp;</td> --->
				<td colspan="5" class="formButtons" align="center">
					<cf_botones modo='ALTA' include="IrLista" includevalues="Ir a Lista" tabindex="1"	>
				</td>
			</tr>
		</table>



		<cfset ts = "">
	</form>
	</cfoutput>

	<script type="text/javascript" language="javascript">
		var f = document.formTESB;
		<cfoutput>
		var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
		oCedulaMask.attach(document.formTESB.TESBeneficiarioId, oCedulaMask.mask, "string");

		function cambiarMascara(v)
		{
			document.formTESB.TESBeneficiarioId.value = "";
			if (v == 'F')
			{
				oCedulaMask.mask = "#replace(rsMasks.Fisica,'X','##','ALL')#";
				document.formTESB.TESBmask.value = "#rsMasks.Fisica#";
			}
			else if (v == 'J')
			{
				oCedulaMask.mask = "#replace(rsMasks.Juridica,'X','##','ALL')#";
				document.formTESB.TESBmask.value = "#rsMasks.Juridica#";
			}
			else if (v == 'E')
			{
				oCedulaMask.mask = "#RepeatString("*", 30)#";
				document.formTESB.TESBmask.value = "";
			}
		}
		</cfoutput>
	</script>


	<cf_qforms form ="formTESB" objForm = "objformTESB">
	<script language="javascript" type="text/javascript">
	<!-- //
		<cfoutput>
		function validaform()
		{
			objformTESB.TESBeneficiarioId.required = true;
			objformTESB.TESBeneficiarioId.description="#LB_Identificacion#";
			objformTESB.TESBeneficiario.required = true;
			objformTESB.TESBeneficiario.description="#LB_Beneficiario#";
			objformTESB.TESBemail.validateEmail();
		}
		</cfoutput>
		function NOvalidaform()
		{
			objformTESB.TESBeneficiarioId.required = false;
			objformTESB.TESBeneficiario.required = false;
		}

		function funcAlta()
		{
			validaform();
		}
		function funcIrLista()
		{
			NOvalidaform();
			getElementById('table1').style.display='';getElementById('table2').style.display='none';
			return false;
		}
	//-->
	</script><!--- --->

</body>
</html>
<cffunction name="sbAgregar">
	<cfif IsDefined("form.Alta")>
		<cf_sifdireccion action="readform" name="la_direccion">
		<cf_sifdireccion action="insert" name="la_direccion" data="#la_direccion#">
		<cftransaction>
			<cfparam name="form.TESBactivo" default="0">
			<cfquery name="rsInsertaTESbeneficiario" datasource="#session.dsn#">
				insert into TESbeneficiario (
					CEcodigo,
					TESBeneficiarioId,
					TESBeneficiario,
					TESBtipoId,
					TESRPTCid,
					id_direccion,
					TESBtelefono,
					TESBfax,
					TESBemail,
					TESBactivo,
					BMUsucodigo
					)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBeneficiarioId)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBeneficiario)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBtipoId)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#" null="#TESRPTCid EQ ""#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#la_direccion.id_direccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBtelefono)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBfax)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.TESBemail)#">,
					<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Form.TESBactivo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
					<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="rsInsertaTESbeneficiario">
			<cfquery datasource="#session.dsn#">
				insert into TESbeneficiarioBitacora (
				   TESBid,
				   TESBtipoId,
				   TESBeneficiarioId,
				   TESBeneficiario,
				   TESRPTCid,
				   DEid,
				   TESBactivo,
				   BMUsucodigo)
				select    TESBid,
				   TESBtipoId,
				   TESBeneficiarioId,
				   TESBeneficiario,
				   TESRPTCid,
				   DEid,
				   TESBactivo,
				   BMUsucodigo
				from TESbeneficiario
			   where TESBid = #rsInsertaTESbeneficiario.identity#
			</cfquery>
		</cftransaction>
		<script language="javascript">
			<cfoutput>
				Asignar("#rsInsertaTESbeneficiario.identity#", "#trim(form.TESBeneficiarioId)#", "#trim(form.TESBeneficiario)#");
			</cfoutput>
		</script>
		<cfabort>
	</cfif>
</cffunction>