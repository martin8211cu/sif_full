<!---

	Modificado por: Andres Lara
	Fecha: 18 de Octubre de 2017
	Motivo: Nuevas opciones por Sistema Crédito y Cobranza.
 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroSocio" default = "N&uacute;mero de Socio" returnvariable="LB_NumeroSocio" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_EmpresaOrigen" default = "Empresa origen" returnvariable="LB_EmpresaOrigen" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GenerarSocioCorporacion" default = "Generar Socio en Corporaci&oacute;n" returnvariable="LB_GenerarSocioCorporacion" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoPersona" default = "Tipo de Persona" returnvariable="LB_TipoPersona" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Identificacion" default = "Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fisica" default = "F&iacute;sica" returnvariable="LB_Fisica" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Juridica" default = "Jur&iacute;dica" returnvariable="LB_Juridica" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Extranjero" default = "Extranjero" returnvariable="LB_Extranjero" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ninguno" default = "Ninguno" returnvariable="LB_Ninguno" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_IdentificacionSecundaria" default = "Identificaci&oacute;n (Secundaria)" returnvariable="LB_IdentificacionSecundaria" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Inactivo" default = "Inactivo" returnvariable="LB_Inactivo" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ClienteCorporativo" default = "Cliente Corporativo" returnvariable="LB_ClienteCorporativo" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SincIntfaz" default = "Sincroniza Interfaz" returnvariable="LB_SincIntfaz" xmlfile = "SociosDGenerales.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Dist" default = "Distribuidor" returnvariable="LB_Dist" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TarjH" default = "Tarjetahabiente" returnvariable="LB_TarjH" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Mayor" default = "Mayorista" returnvariable="LB_Mayor" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Tipo" default = "Tipo de Socio" returnvariable="LB_Tipo" xmlfile = "SociosDGenerales.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_InterCompany" default = "Inter Company" returnvariable="LB_InterCompany" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nombre" default = "Nombre" returnvariable="LB_Nombre" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CodigoSocioSistemasExterno" default = "Grupo Socio de Negocios" returnvariable="LB_CodigoSocioSistemasExterno" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_EmpresaPertenece" default = "Empresa a la que Pertenece" returnvariable="LB_EmpresaPertenece" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoSePuedeRelacionarYaQueHayOtrosSociosRelacionadosConEste" default = "No se puede relacionar, ya que hay otros socios relacionados con &eacute;ste." returnvariable="MSG_NoSePuedeRelacionarYaQueHayOtrosSociosRelacionadosConEste" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Telefono" default = "Tel&eacute;fono" returnvariable="LB_Telefono" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fax" default = "Fax" returnvariable="LB_Fax" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CorreoElectronico" default = "Correo Electr&oacute;nico" returnvariable="LB_CorreoElectronico" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_EstadoSocioNegocios" default = "Estado Socio de Negocios" returnvariable="LB_EstadoSocioNegocios" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Idioma" default = "Idioma" returnvariable="LB_Idioma" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_UsuarioAsignadoParaUsoDelSistema" default = "Usuario asignado para uso del Sistema" returnvariable="MSG_UsuarioAsignadoParaUsoDelSistema" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoSeHaAsignadoUsuario" default = "No se ha asignado usuario" returnvariable="MSG_NoSeHaAsignadoUsuario" xmlfile = "SociosDGenerales.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_IDFisc" default = "ID Fiscal" returnvariable="LB_IDFisc" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NAci" default = "Nacionalidad" returnvariable="LB_NAci" xmlfile = "SociosDGenerales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Nac" default = "Nacional" returnvariable="LB_Nac" xmlfile = "SociosDGenerales.xml">

<cfif isdefined("Form.SNcodigo") and len(Form.SNcodigo) gt 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfparam name="LvarSNtipo" default="">

<cfquery name="rsEstadoSNegocios" datasource="#Session.DSN#">
	select ESNid, ESNcodigo, ESNdescripcion, ESNfacturacion
	from EstadoSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

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

<!---Marcara del Socio de Negocios--->
<cfquery name="rsMasksSN" datasource="#Session.dsn#">
	select Pvalor as MaskSN
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 611
</cfquery>

<cfset MascaraNumeroSN= 'XXX-XXXX'>

<cfif isdefined("rsMasksSN") and len(trim(rsMasksSN.MaskSN))>
	<cfset MascaraNumeroSN= rsMasksSN.MaskSN>
</cfif>

<cfif rsMasksSN.recordcount EQ 0>
    <cfquery datasource="#Session.dsn#">
        insert into Parametros (
            Ecodigo,
            Pcodigo,
            Mcodigo,
            Pdescripcion,
            Pvalor
            )
        values (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
            611,
            'CC',
            'Formato de Máscara de Socio de Negocios',
            'XXX-XXXX'
            )
    </cfquery>
</cfif>

<cfquery name="rsIntercompany" datasource="#Session.dsn#">
	select Edescripcion,Ecodigo
	from Empresas
	order by Edescripcion
</cfquery>

<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>


<script language="JavaScript" type="text/JavaScript">


function validar_numeros(obj){
	var url = 'SociosRepetidos.cfm?<cfif modo neq 'ALTA'><cfoutput>SNcodigo=#form.SNcodigo#</cfoutput>&</cfif>SNnumero=' + escape(obj.value);
	document.getElementById('framedupnumero').src = url		
}

function validar_identificacion(obj){
	window.open('SociosRepetidos.cfm?<cfif modo neq 'ALTA'>SNcodigo=#JSStringFormat(url.SNcodigo)#&</cfif>SNidentificacion=' + escape(obj.value), 'framedupnumero');
}

function socio_generico(){
	// no se puede borrar el SN generico
	<cfif modo neq 'ALTA'>
		<cfif isdefined("rsSocios.SNcodigo") and rsSocios.SNcodigo eq '9999' >
			return true;
		<cfelse>
			return false;
		</cfif>
	<cfelse>
		return false;
	</cfif>
}

function validarDGenerales(form){
	if(form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo'){
		if(document.form.esIntercompany.checked){
			if(document.form.Intercompany.value == '-1'){
				alert('La empresa a la que pertenece, es requerida.');
				document.form.Intercompany.focus();
				return false;
			}
		}
	}
/*
	if ( form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo' ){
		if (form.SNDirFiscSATmx.checked){
			socios_validateForm(form,'SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNFecha','','R','Calle','','R','NumExt','','R','Colonia','','R','MuniDel','','R','estado','','R','codPostal','','R');
			}
		else{
			socios_validateForm(form,'SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNFecha','','R');
			}
		return document.MM_returnValue
	}
	else{
		if (form.botonSel.value == 'Baja' && socio_generico() ) {
			alert('El Socio de Negocios Genrico no puede ser eliminado.');
			return false;
		}
	}
	*/

	return true;
}

function funcNuevo(){
	location.href='Socios.cfm';
	return false;
}


</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>
<!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> --->

<body>
<form action="SociosDGenerales-sql.cfm" method="post" name="form" onSubmit="return validarDGenerales(this);">
<cfoutput>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<!---PRUEBA Row en donde se encuentra la fecha--->
	<!---PRUEBA Row #1 --->
	<tr >
	  	<td  align="right" valign="top" width="1%">&nbsp;</td>
		<td width="40%" rowspan="4">
			<table>
				<tr>
					<td>
						<strong>#LB_NumeroSocio#</strong>:&nbsp;
					</td>
					<td>
						<cfif Modo neq 'ALTA'>
							<strong>#LB_EmpresaOrigen#: </strong>
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap><input tabindex="1" type="text" size="12" maxlength="11" name="SNnumero" value="<cfif modo neq 'ALTA' and
					isDefined("rsSocios.SNnumero")>#Trim(rsSocios.SNnumero)#</cfif>"
					onFocus="javascript:this.select();" onchange="validar_numeros(this);"
					alt="El N&uacute;mero de Socio" > &nbsp;</br> <b>#MascaraNumeroSN#</b>
						<input type="hidden" id="SNnumeroOK" name="SNnumeroOK" value="true">
						<iframe  tabindex="-1" width="1" height="1" frameborder="0" style="display:none;" name="framedupnumero" id="framedupnumero" src="about:blank"></iframe>
					</td>
					<td>
						<cfif Modo neq 'ALTA'>
							<cfoutput>#HTMLEditFormat(rsSocios.EnombreInclusion)#</cfoutput>
							<cfif modalidad.readonly>
							  (modificaciones restringidas)
							</cfif>
						<cfelseif Len(session.EcodigoCorp) And (session.Ecodigo neq session.EcodigoCorp)>
							<cfset ac_disabled = not modalidad.altalocal or not modalidad.altacorp>
							<cfset ac_checked = modalidad.altacorp>
							<input  tabindex="1" type="checkbox" name="ALTA_CORPORATIVO" id="ALTA_CORPORATIVO" value="1"
								<cfif ac_disabled>disabled</cfif> <cfif ac_checked>checked</cfif>
							>
							<label for="ALTA_CORPORATIVO"><strong>#LB_GenerarSocioCorporacion#</strong></label>
						</cfif>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap><strong>#LB_TipoPersona#:</strong>&nbsp;</td>
			      	<td valign="top"><strong>#LB_Identificacion#:</strong>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
						<cfif modo EQ "ALTA"> <!---rsMasks.Fisica  se manda el campo como hidden para poder deshabilitarlo en cambio --->
							<cfset LvarSNtipo = rsMasks.Fisica>
							<select  tabindex="1" name="SNtipo" id="SNtipo" <cfif LvarSNtipo NEQ ''>onChange="getMask(false,SNMid);evalua();"<cfelse>
								onChange="getMask(false,SNMid);evalua();"</cfif>>
								<option value="F" <cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>selected</cfif>>#LB_Fisica#</option>
								<option value="J" <cfif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>selected</cfif>>#LB_Juridica#</option>
								<option value="E" <cfif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>selected</cfif>>#LB_Extranjero#</option>
							</select>
						<cfelse>
							<cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>
								<cfset LvarSNtipo = rsMasks.Fisica>
								<input  tabindex="-1" type="hidden" value="F" name="SNtipo" id="SNtipo">
						<input  tabindex="1" type="text" readonly value="#LB_Fisica#" style="border:none;" size="10">
							<cfelseif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>
								<cfset LvarSNtipo = rsMasks.Juridica>
								<input tabindex="-1" type="hidden" value="J" name="SNtipo" id="SNtipo">
						<input  tabindex="1" type="text" readonly value="#LB_Juridica#" style="border:none;" size="10">
							<cfelseif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>
								<cfset LvarSNtipo = rsMasks.Extranjera>
								<input tabindex="-1" type="hidden" value="E" name="SNtipo" id="SNtipo">
								<input  tabindex="1" type="text" readonly value="Extranjero" style="border:none;" size="10">
							</cfif>
						</cfif>
                		<!---►►►►MASCARAS DE LOS SOCIOS DE NEGOCIO◄◄◄◄--->
              			<cfinvoke component="sif.Componentes.SocioNegocios" method="GetSNMascaras" returnvariable="rsSNMascaras"></cfinvoke>
                        <script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
                		<BR>&nbsp;&nbsp;
               			<select tabindex="1" name="SNMid" id="SNMid" onChange="getMask('true',this.value)">
                       		<option value="">--#LB_Ninguno#--</option>
						</select>
					</td>
					<td>
						<!---<cfif modo NEQ "ALTA" and Len(Trim(rsSocios.SNidentificacion))> readonly </cfif>--->
						<input  tabindex="1" type="text" name="SNidentificacion" id="SNidentificacion" size="50"
							 value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNidentificacion)#</cfif>"
							 onfocus="javascript:this.select();"
							 alt="Identificación" >
						<input  tabindex="-1" type="text" name="SNmask" size="50" readonly value="#LvarSNtipo#" style="border:none;">
						<input  tabindex="-1" type="hidden" name="SNidentificacion_BD" value="<cfif modo NEQ "ALTA" >#trim(rsSocios.SNidentificacion)#</cfif>">
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap/>
			      	<td valign="top"><strong>#LB_IdentificacionSecundaria#:</strong>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" nowrap/>
			      	<td valign="top">
						<input  tabindex="1" type="text" name="SNidentificacion2" size="20" maxlength="20"
						 onblur="javascript:ValidarID(this);"
						 value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNidentificacion2)#</cfif>"
						 onfocus="javascript:this.select();"
						 alt="Identificación (adicional)" >
					</td>
				</tr>
			</table>
	  	</td>
		<td width="40%">
			<strong>#LB_Fecha#: </strong>
		</td>

	</tr>


	<tr>
		<td>&nbsp;</td>
		<td valign="top">
			<input tabindex="1" type="text" name="SNFecha" readonly size="12"
			value="<cfif #modo# NEQ "ALTA">#LSDateFormat(rsSocios.SNFecha, 'dd/mm/yyyy')#<cfelse>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfif>"
			alt="El campo Fecha de inclusin del Socio">
		</td>
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td valign="middle">

			<cfif modo neq 'ALTA'>
				<input  tabindex="1" type="checkbox" name="SNinactivo" id="SNinactivo"
					<cfif modalidad.readonly or (modo NEQ "ALTA" and rsSocios.SNcodigo eq 9999)>disabled</cfif> value="1"
					<cfif modo NEQ "ALTA" and rsSocios.SNinactivo EQ 1>checked</cfif>>
				<label for="SNinactivo"><strong>#LB_Inactivo#</strong></label>

				<cfif modalidad.modalidad>
					<input  tabindex="1" type="checkbox" name="es_corporativo" id="es_corporativo" value=""	<cfif Len(rsSocios.SNidCorporativo)>checked</cfif>
						disabled><label for="es_corporativo"><strong>#LB_ClienteCorporativo#</strong></label>
				</cfif>

				<cfif modalidad.modalidad>
					<input  tabindex="1" type="checkbox" name="sincIntfaz" id="sincIntfaz" value=""	<cfif Len(rsSocios.sincIntfaz)>checked</cfif>disabled>
					<label for="sincIntfaz"><strong>#LB_SincIntfaz#</strong></label>
				</cfif>
			<cfelse>
				<strong>#LB_Tipo#: &nbsp;</strong> &nbsp;
					<input  tabindex="1" type="checkbox" name="disT" id="disT" value="">
					 <strong>#LB_Dist#</strong> &nbsp;
					<input  tabindex="1" type="checkbox" name="TarjH" id="TarjH" value="">
		    		<strong>#LB_TarjH#</strong>&nbsp;
					<input  tabindex="1" type="checkbox" name="mayoR" id="Mayor" value="">
					 <strong>#LB_Mayor#</strong>
			</cfif>


		</td>
	</tr>


	<tr>
		<td>&nbsp;</td>
		<td>
	  		<!--- ANTES INCLUYE INEE---->
	  		<cfif modo neq 'ALTA'>
	  			<strong>#LB_Tipo#</strong> &nbsp;
	  				<input  tabindex="1" type="checkbox" name="disT" id="disT" value=""
	  				<cfif modo NEQ "ALTA" and rsSocios.disT EQ 1> disabled checked</cfif>>
					 <strong>#LB_Dist#</strong> &nbsp;
					<input  tabindex="1" type="checkbox" name="TarjH" id="TarjH" value=""
					<cfif modo NEQ "ALTA" and rsSocios.TarjH EQ 1> disabled checked</cfif>>
		    		<strong>#LB_TarjH#</strong>&nbsp;
					<input  tabindex="1" type="checkbox" name="mayoR" id="Mayor" value=""
					<cfif modo NEQ "ALTA" and rsSocios.mayoR EQ 1> disabled checked</cfif>>
					 <strong>#LB_Mayor#</strong>
			</cfif>
      	</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
			<input  tabindex="1" type="checkbox" name="esIntercompany" value="1"
				<cfif modalidad.readonly> disabled</cfif>
				<cfif modo NEQ "ALTA" and rsSocios.esIntercompany EQ 1> checked</cfif>>
		    <strong>#LB_InterCompany#</strong>
      	</td>
	</tr>
    <tr>
		<td/>
	    <td/>
		<td>
			<input  tabindex="1" type="checkbox" name="sincIntfaz" id="sincIntfaz" value="1" <cfif modalidad.readonly> disabled</cfif>
				<cfif modo NEQ "ALTA" and rsSocios.sincIntfaz EQ 1> checked</cfif>>
		    <strong>#LB_SincIntfaz#</strong>
      	</td>
	</tr>
<!---- Antes Valores INEE---->
	<tr>
	  <td align="right" valign="top" nowrap>&nbsp;</td>
	  <td valign="top"><strong>#LB_Nombre#:</strong>&nbsp;</td>
	  <td valign="top"><strong>Fecha Nacimiento:</strong>&nbsp;</td>
<!---ANTES GRUPOS SOCIO DE NEGOCIO----->
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td valign="top">
			<input tabindex="1" type="text" name="SNnombre" size="75" style="width:400px" maxlength="255" <cfif modalidad.readonly>readonly</cfif>
			value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNnombre)#</cfif>" onFocus="javascript:this.select();"  alt="El campo Nombre del Socio" >
		</td>
		<td valign="top">
			<cfif modo NEQ "ALTA" and trim(rsSocios.SNFechaNacimiento) neq "">
				<cf_sifcalendario  tabindex="1" form="form" name="SNFechaNacimiento" id="SNFechaNacimiento" 
				value="#LSDateFormat(rsSocios.SNFechaNacimiento,'dd/mm/yyyy')#" obligatorio="1">
			<cfelse>
				<cf_sifcalendario  tabindex="1" form="form" name="SNFechaNacimiento"  id="SNFechaNacimiento" obligatorio="1">
			</cfif>
		</td>
<!--- ANTES GRUPO SOCIOS DE NEGOCIO ---->
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td valign="baseline"><strong>#LB_CodigoSocioSistemasExterno#:</strong></td>
		<td valign="top" nowrap><strong>#LB_EmpresaPertenece#</strong></td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td valign="baseline">
			<input  tabindex="1" name="SNcodigoext" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNcodigoext)#</cfif>" ><!---- onFocus="javascript:this.select();" ----->
		</td>
		<td valign="top" nowrap>
			<select  tabindex="1" name="Intercompany" id="Intercompany">
				<option value="-1">- #LB_Ninguno# -</option>
				<cfif isdefined('rsIntercompany') and rsIntercompany.recordCount GT 0>
 					<cfloop query="rsIntercompany">
						<option value="#rsIntercompany.Ecodigo#" <cfif modo NEQ 'ALTA' and rsIntercompany.Ecodigo EQ rsSocios.Intercompany>selected</cfif>>#HTMLEditFormat(rsIntercompany.Edescripcion)#</option>
					</cfloop>
				</cfif>
		  	</select>
		</td>
	</tr>


	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
	</tr>
<!--- ANTES SOCIOS RELACIONADOS --->
<!--- ANTES AQUI GENERA CONTRATOS --->
	<tr>
	  <td colspan="2" rowspan="10" valign="top">
			<cfset modoReadOnly = "return true;">
			<cfset id_direccion = -1>
			<cfif IsDefined('rsSocios.id_direccion') And Len(rsSocios.id_direccion)>
				<cfset id_direccion = rsSocios.id_direccion>
				<!--- <cfdump var="#rsSocios.id_direccion#"> --->
				<cfif modalidad.readonly>
					<div style="width:80% ">
		          		<cf_sifdireccion tabindex="1" action="display" key="#rsSocios.id_direccion#">
						<cfset modoReadOnly = "return false;">
					</div>
				<cfelse>
		          <cf_sifdireccion tabindex="1" action="input" key="#rsSocios.id_direccion#">
				</cfif>
			<cfelse>
		          <cf_sifdireccion  tabindex="1" action="input">
			</cfif>
			<div style="width:80%" align="center">
				<cfquery name="q_dir" datasource="#session.dsn#">
					select SNDfacturacion,SNDenvio,SNDactivo from SNDirecciones where id_direccion = #id_direccion#;
				</cfquery>
				<cfset d_chk = [false,false,false]>
				<cfif q_dir.RecordCount gt 0>
					<cfif q_dir.SNDfacturacion eq 1> <cfset d_chk[1] = true>	</cfif>
					<cfif q_dir.SNDenvio eq 1>		 <cfset d_chk[2] = true>	</cfif>
					<cfif q_dir.SNDactivo eq 1>		 <cfset d_chk[3] = true	>	</cfif>
				</cfif>
				<b><i>
				<input name="d_fac" type="checkbox" onclick="#modoReadOnly#" <cfif d_chk[1]>checked</cfif>>&nbsp;Facturaci&oacute;n
				<input name="d_env" type="checkbox" onclick="#modoReadOnly#" <cfif d_chk[2]>checked</cfif>>&nbsp;Env&iacute;o
				<input name="d_act" type="checkbox" onclick="#modoReadOnly#" <cfif d_chk[3]>checked</cfif>>&nbsp;Activo
				</i></b>
			</div>
		</td>
	  <td valign="top"><strong>#LB_Telefono#:&nbsp;</strong></td>
	</tr>

	<tr>
	  <td valign="top"><input  tabindex="1" name="SNtelefono" type="text" 
		size="30" maxlength="15" onFocus="javascript:this.select();" onkeypress="return soloNumeros(event);"
		value="<cfif #modo# NEQ "ALTA">#trim(rsSocios.SNtelefono)#</cfif>"  alt="El campo Tel&eacute;fono del Socio" <cfif modalidad.readonly>disabled</cfif>>
      </td>
	</tr>
	<tr>
	  <td valign="top"><strong>#LB_Fax#:&nbsp;</strong></td>
	</tr>
	<tr>
	  <td valign="top"><input  tabindex="1" name="SNFax" type="text" 
	  onFocus="javascript:this.select();" onkeypress="return soloNumeros(event)"
	  value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNFax)#</cfif>" size="30" maxlength="30" alt="El campo Fax del Socio "  <cfif modalidad.readonly>disabled</cfif>></td>
	</tr>
	<tr>
	  <td valign="top"><strong>#LB_CorreoElectronico#:</strong></td>
	</tr>
	<tr >
	  <td valign="top"><input  tabindex="1" name="SNemail" type="email" 
		size="75" style="width:400px"  maxlength="100" placeholder="nombre@example.com"
		onBlur="return document.MM_returnValue" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNemail)#</cfif>" onFocus="javascript:this.select();" alt="El campo E-Mail del Socio " <cfif modalidad.readonly>disabled</cfif>>
      </td>
	</tr>
	<tr height="30" valign="top"> 
	  <td valign="top">
	  	<input  tabindex="1" name="SNenviarEmail" type="checkbox" <cfif modo NEQ "ALTA" && rsSocios.SNenviarEmail eq 1>checked</cfif> <cfif modalidad.readonly>disabled</cfif>>
		<font>Enviar Resumen de Corte por Email</font>
      </td>
	</tr>
	<tr>
	  <td valign="top"><strong>#LB_EstadoSocioNegocios#:</strong>&nbsp;</td>
	</tr>
	<tr>
	  <td valign="top">
		  <select  tabindex="1" name="ESNid" id="ESNid" <cfif modalidad.readonly>disabled</cfif>>
			  <cfloop query="rsEstadoSNegocios">
				  <option value="#rsEstadoSNegocios.ESNid#" <cfif modo NEQ 'ALTA' and rsEstadoSNegocios.ESNid EQ rsSocios.ESNid>selected</cfif>>#HTMLEditFormat(rsEstadoSNegocios.ESNdescripcion)#</option>
			  </cfloop>
       	  </select>
	  </td>
	</tr>
	<tr>
	  <td valign="top" ><strong>#LB_Idioma#:&nbsp;</strong>
		  <select  tabindex="1" name="LOCIdioma" id="LOCIdioma" <cfif modalidad.readonly>disabled</cfif>>
			  <option value="">-- #LB_Ninguno# --</option>
           	  <cfloop query="rsIdiomas">
           		  <option value="#rsIdiomas.LOCIdioma#" <cfif modo NEQ 'ALTA' and rsIdiomas.LOCIdioma EQ rsSocios.LOCIdioma>selected</cfif>>#HTMLEditFormat(rsIdiomas.LOCIdescripcion)#</option>
			  </cfloop>
       	  </select>
	  </td>
	</tr>
	<tr id="tipoExt" <cfif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>style="visibility:visible;"<cfelse> style="visibility:hidden;"</cfif>>
		<td></td>
		<td align="right" nowrap>
			<table>
			 	<td align="right"><strong>#LB_IDFisc#:&nbsp;</strong></td>
	 			<td><input name="IDFis" id="IDFis" size="30" maxlength="30" value="<cfif modo NEQ "ALTA">#rsSocios.IdFisc#</cfif>"></td>
			 	<td width="41%">&nbsp;</td>
				<tr>
				   	<td align="right" nowrap><strong>#LB_NAci#:&nbsp;</strong></td>
				 	<td ><input name="Nacion" id="Nacion" size="30" maxlength="18" value="<cfif modo NEQ "ALTA">#rsSocios.Nacional#</cfif>"></td>
			   </tr>
			</table>
	 	</td>
	</tr>
	<tr>
	  	<td colspan="4" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<!--- Botones --->
	<tr>
		<td colspan="4" align="center" valign="top" nowrap>
			<div align="center">
				<cf_botones tabindex="2" modo="#modo#">
			</div>
		</td>
	</tr>
	<tr>
	  	<td colspan="4" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<cfif modo neq "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSocios.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input  tabindex="-1" type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
  	<input  tabindex="-1" type="hidden" name="SNcodigo" value="<cfif modo NEQ "ALTA">#rsSocios.SNcodigo#</cfif>">
	<input  tabindex="-1" type="hidden" name="DGenerales" value="DGenerales">
</table>
</form>
<!--- Frame para validar que no se repitan la identificación secundaria del socio de negocios --->
<iframe frameborder="0" name="fr" height="0" width="0" src=""></iframe>
</cfoutput>


<!--- <script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script> --->


<cfoutput>
<!--- <script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script> --->
<script language="javascript" type="text/javascript">
function ValidarID(obj) {
			var identificacion = obj.value;
			<cfoutput>
			<cfif (modo neq "ALTA")>
				document.all["fr"].src="valida_ID2.cfm?SNcodigo=#form.SNcodigo#&SNidentificacion2="+identificacion;
			<cfelse>
				document.all["fr"].src="valida_ID2.cfm?SNidentificacion2="+identificacion;
			</cfif>
			</cfoutput>
		}
<!---
Formato del js Mask: x=letras, #=Numeros *=Ambos
Formato del usuario: X=letras, ?=Numeros *=Ambos
--->

function Validaciones(){

    var falta = "";

    if(document.form.SNnumero.value == ''){falta += "\n- Número de Socio"; }
		else{ validar_numeros(document.form.SNnumero.value); }
    if(document.form.SNnumeroOK.value == 'false'){ falta += "\n- Numero de Socio ya esta en uso"; }
    if(document.form.SNidentificacion.value == ''){ falta += "\n- Identificacion"; }
    if(document.form.SNnombre.value == ''){ falta +=  "\n- Nombre"; }
    if(document.form.direccion1.value == ''){ falta +=  "\n- Dirección"; }
    if(document.form.SNenviarEmail.checked && document.form[0].SNemail.value == ''){ falta +=  "\n- Email"; }
    if($('##disT').prop('checked') == '' && $('##TarjH').prop('checked') == '' && $('##Mayor').prop('checked') == ''){
        	falta +=  "\n   - Tipo Socio ";
    	}

	if(falta.length>0){
		alert("<b>Los siguientes datos hacen falta: </b>" + falta);
		return false;
		event.preventDefault();
	}

	return true;
}

function funcCambio (){
	return Validaciones();
}
function funcAlta (){
	return Validaciones();
}

function soloNumeros(e){
		var key = window.Event ? e.which : e.keyCode
		return (key >= 48 && key <= 57)
	}
function evalua(){
var inpSNtipo   = document.getElementById("SNtipo");
var inpSNMid    = document.getElementById("SNMid");

			if (inpSNtipo.value== 'E')
			{
				document.getElementById("tipoExt").style.visibility = "visible";
			}else{
				document.getElementById("tipoExt").style.visibility = "hidden";
			}
}

function getMask(seleccionar,SNMid)
{
	<cfwddx action="cfml2js" input="#rsSNMascaras#" topLevelVariable="SNMascaras">
	var inpSNtipo   = document.getElementById("SNtipo");
	var inpSNMid    = document.getElementById("SNMid");
	var inpIdenti   = document.getElementById("SNidentificacion");
	var CantCombo   = 0;
 	var nRows       = SNMascaras.getRowCount();
	var usarMaskPar = true;
	var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
		oCedulaMask.attach(document.form.SNidentificacion, oCedulaMask.mask, "string");
	//Elimina Todos los Valor del combo de Mascaras Extendidas, excepto el Index 0

	for(row = 1; row < inpSNMid.length; ++row)
		inpSNMid.options[row] = null
	//Si existen mascaras extendidas para la empresa
 	if(nRows > 0)
	{
			for(row = 0; row < nRows; ++row)
			{
				//Si la mascara extendida es del tipo de indentificacion del Socio de Negocio Actual
				if (SNMascaras.getField(row, "SNtipo") == inpSNtipo.value)
				{
					//Si La mascara Extendida Actual es la que ya posse el SN, por lo que se coloca como seleccionada, de lo contrario coloca el defaultSelected
					if(seleccionar && SNMid == SNMascaras.getField(row, "SNMid"))
						selected = true;
					else
						selected = false;
					CantCombo++;
					valorCombo = new Option(SNMascaras.getField(row, "SNMDescripcion"),SNMascaras.getField(row, "SNMid"),0,selected)
					inpSNMid.options[inpSNMid.length] = valorCombo;
					if (selected)
					{
						usarMaskPar 	 = false;
						masktemp         = SNMascaras.getField(row,"SNMascara").replace(/X/g,'x');
						oCedulaMask.mask = masktemp.replace(/\?/g,'##');
						document.form.SNmask.value = SNMascaras.getField(row,"SNMascara");
					}
				}
			}
			//Si posse Mascaras Extendidas para el tipo de Indentificacion pinta el combo de lo contrario lo oculta
			if(CantCombo > 0)
				inpSNMid.style.visibility = "visible";
			else
				inpSNMid.style.visibility = "hidden";
	}
	//No existen mascaras extenidas para la empresa
	else
		inpSNMid.style.visibility   = "hidden";
	//Aplica la mascara de los parametros
		 if (usarMaskPar)
		 {
			if (inpSNtipo.value == 'F')
			{
				oCedulaMask.mask 		   = "#replace(replace(rsMasks.Fisica,'X','x','ALL'),'?','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Fisica#";
			}
			else if (inpSNtipo.value == 'J')
			{
				oCedulaMask.mask 		   = "#replace(replace(rsMasks.Juridica,'X','x','ALL'),'?','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Juridica#";
			}
			else if (inpSNtipo.value== 'E')
			{
				oCedulaMask.mask 		   = "#replace(replace(rsMasks.Extranjera,'X','x','ALL'),'?','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Extranjera#";
			}
		 }
		 inpIdenti.onblur();
}

<cfif modo NEQ 'ALTA' AND LEN(rsSocios.SNMid)>
	getMask('true',#rsSocios.SNMid#);
<cfelse>
	getMask('false',-1);
</cfif>
function VerSociosRelacionados(Socio){
    window.open('SociosRelacionados.cfm?Socio=' + Socio + '','popup','width=450,height=400');
}

</script>
</cfoutput>