<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Se modifico para mejorar el formato de la pantalla.

	Modificado por: Ana Villavicencio
	Fecha: 27 de febrero del 2006
	Motivo: se corrigió el formato de la consulta, se quito codigo común en los tabs para colocarlo en un archivo.

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 19-1-2006.
		Motivo: Se soluciona la leyenda del socio relacionado en caso de venir en null.
	
	Creado por Gustavo Fonseca H.
		Fecha: 8-12-2005.
		Motivo: Crear una pantalla donde solo se muestre los datos generales del Socio de Negocios.
 --->


<script language="JavaScript" type="text/JavaScript">
<!--
<cfoutput>
function Regresarant(){
	document.form.action = "../../cc/consultas/analisisSocio.cfm?SNcodigo=#form.SNcodigo#&Ocodigo_F=#form.Ocodigo_F#";
	document.form.submit();
}
</cfoutput>

function validar_numeros(obj){
	window.open('SociosRepetidos.cfm?<cfif modo neq 'ALTA'>SNcodigo=#JSStringFormat(url.SNcodigo)#&</cfif>SNnumero=' + escape(obj.value), 'framedupnumero');
}

function validar_identificacion(obj){
	window.open('SociosRepetidos.cfm?<cfif modo neq 'ALTA'>SNcodigo=#JSStringFormat(url.SNcodigo)#&</cfif>SNidentificacion=' + escape(obj.value), 'framedupnumero');
}


// ========================================================================================================
var valor = ""

function valido(origen){
	for(var i=0; i<origen.length-1; i++){
		if ( origen.charAt(i)=='-' && i != 3 ){
			return false;
		}
	}
	return true;
}

function formato(obj){
	if (obj.value != ""){
		var origen = new String(obj.value);
		if (origen.length < 8 || origen.charAt(3) != '-' || !valido(origen) ){
			alert('El Numero de Socio debe tener el formato XXX-XXXX');
			obj.focus();
			return false;
		}
		validar_numeros(obj);
	}	
}

function anterior(obj, e, d){
	valor = obj.value;
}

//Permite solamente digitar numeros (se usa en el evento onKeyUp)
function mascara(obj,e,d){
	str= new String("")
	str= obj.value
	var tam=obj.size
	var t=Key(e)
	var ok=false
	
	if(tam>d) {tam=tam-d}
	if(tam>1) {tam=tam-1}
	 
	/* ============================================ */
	// valida que no pueda borrar el '-'
	if ( (t==46 || t==8) && obj.value.length != 0 ){
	//alert('1')
		if ( obj.value.charAt(3) != '-' ){
			obj.value = valor;
		}
	}
	/* ============================================ */

	if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
	if(t>=16 && t<=20) return false;
	if(t>=33 && t<=40) return false;
	if(t>=112 && t<=123) return false;

	if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
	if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
	 
	if(t==109) ok = false;  // nuevo por jgr
	if(t>=48 && t<=57)  ok=true
	if(t>=96 && t<=105) ok=true

	if(t==189) ok=true

	if(d>0){
		if(t==110) ok=true
		if(t==190) ok=true
	}
	 
	// validaciones para mascara XXX-XXXX

	// inserta un '-' cuando la posicio es 3
	if (obj.value.length == 3 ){
		obj.value = obj.value + '-';

		if ( obj.value.charAt(2) == '-' ){
			obj.value = valor;
		}
	}

	if (obj.value.length < 3 ){
		if ( obj.value.charAt(1) == '-' || obj.value.charAt(2) == '-' ){
			obj.value = valor;
		}
	}
	
	if (obj.value.length > 3 ){
		if ( obj.value.charAt(3) != '-' ){
			obj.value = valor;
		}
	}

	if(!ok){
		obj.value = valor;
	}
	return true
}


//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--

function socio_generico(){
	// no se puede borrar el SN generico
	<cfif modo neq 'ALTA'>
		<cfif rsSocios.SNcodigo eq '9999' >
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

	if ( form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo' ){
		socios_validateForm(form,'SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNFecha','','R');
		return document.MM_returnValue
	}
	else{ 
		if (form.botonSel.value == 'Baja' && socio_generico() ) {
			alert('El Socio de Negocios Genrico no puede ser eliminado.');
			return false;
		}
	}
	
	return true;	
}	

function funcNuevo(){
	location.href='Socios.cfm';
	return false;
}
//-->

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

<body>

<form action="DatosSocio.cfm" method="post" name="form"> 
<cfoutput>
			<cf_web_portlet_start border="true" titulo="Socios de Negocios Corporativos" >
			
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<tr>
		<td valign="top" width="50%">
			<table border="0" width="100%" cellpadding="3" cellspacing="0">
				<tr>
					<td><strong>N&uacute;mero&nbsp;de&nbsp;Socio</strong>:&nbsp;</td>
					<td>
						<cfif modo neq 'ALTA'>#Trim(rsSocios.SNnumero)#</cfif>&nbsp;&nbsp;&nbsp; XXX-XXXX
					</td>
				</tr>
				<tr>
					<td nowrap>
						<cfif Modo neq 'ALTA'>
							<strong>Empresa origen: </strong>
						</cfif>
					</td>
					<td>
						<cfoutput>#HTMLEditFormat(rsSocios.EnombreInclusion)#</cfoutput>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap><strong>Tipo&nbsp;de&nbsp;persona:</strong>&nbsp;</td>
			      	<td valign="top">
						<cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>
							F&iacute;sica
						<cfelseif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>
							Jur&iacute;dica
						<cfelseif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>
							Extranjero
						</cfif>
				  </td>
				</tr>
				<tr>
					<td valign="top"><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
					<td>#trim(rsSocios.SNidentificacion)#</td>
				</tr>
				<tr>
					<td valign="top"><strong>Nombre:</strong>&nbsp;</td>
					<td nowrap>#Trim(rsSocios.SNnombre)#</td>
				</tr>
				<tr>
					<td valign="baseline"><strong>C&oacute;digo&nbsp;en&nbsp;Sistema&nbsp;Externo:</strong></td>
					<td>#Trim(rsSocios.SNcodigoext)#</td>
				</tr>
				<tr>
					<td colspan="2" valign="top"> 
						<input type="checkbox" disabled name="SNcertificado" id="SNcertificado" <cfif rsSocios.SNcertificado eq 9999 or modalidad.readonly>disabled</cfif> value="1" 
						<cfif rsSocios.SNcertificado EQ 1>checked</cfif> >
						<label for="SNcertificado"><strong>Certificado&nbsp;ISO</strong></label>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<cfif IsDefined('rsSocios.id_direccion') And Len(rsSocios.id_direccion)>
							  <cf_sifdireccion action="display" key="#rsSocios.id_direccion#">
						</cfif>
					</td>
				</tr>
	  		</table>	 
		</td>
		<td width="50%" valign="top">
			<table width="100%" border="0" cellpadding="3" cellspacing="0">
				<tr>
					<td><strong>Fecha: </strong></td>
					<td>#LSDateFormat(rsSocios.SNFecha, 'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="checkbox" name="SNinactivo" id="SNinactivo" disabled value="1" 
						<cfif rsSocios.SNinactivo EQ 1>checked</cfif>>
							<strong>Inactivo</strong>
						&nbsp;
						<cfif modalidad.modalidad>
							<input type="checkbox" name="es_corporativo" id="es_corporativo" value=""
							<cfif Len(rsSocios.SNidCorporativo)>checked</cfif>
							disabled><strong>Cliente corporativo</strong>
						</cfif>
					</td>	
				</tr>
				<tr>
					<td colspan="2">
						<input type="checkbox" name="esIntercompany" value="1" disabled
							<cfif rsSocios.esIntercompany EQ 1> checked</cfif>>	    
						<strong>Inter Company</strong>
					</td>
				</tr>
				<tr>
					<td><strong>Grupo Socio de Negocios:</strong>&nbsp;</td>
					<td>
						<cfif rsSocios.GSNid gt 0>
							<cfquery name="rsGrupoSNCon" datasource="#session.DSN#">
								select a.GSNid, a.GSNcodigo, a.GSNdescripcion 
								from GrupoSNegocios a, GrupoSNegocios b
								where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and b.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.GSNid#">
									and a.Ecodigo = b.Ecodigo
									and a.GSNid = b.GSNid			
							</cfquery>
							<cfoutput>#rsGrupoSNCon.GSNcodigo#&nbsp;&nbsp;#rsGrupoSNCon.GSNdescripcion#</cfoutput>
						<cfelse>
							<cfoutput>N/A</cfoutput>
					</cfif>					</td>
				</tr>
				<tr>
					<td valign="top" nowrap><strong>Empresa a la que Pertenece:&nbsp;</strong></td>
					<td>
						<cfif isdefined("rsSocios") and rsSocios.Intercompany gt 0>
							<cfif rsIntercompany.recordcount eq 1>
								#HTMLEditFormat(rsIntercompany.Edescripcion)#
							</cfif>
						<cfelseif not len(trim(rsSocios.Intercompany))>
							Ninguna
						</cfif>
					</td>
				</tr>
				<tr>
					<td valign="top"><strong>Socio Relacionado: </strong></td>
					<td>
						<cfset SNcodigoPadre = rsSocios.SNcodigoPadre>
						<cfset excepto = rsSocios.SNid>
						<cfif not tengo_hijos>
							<!---
								si tengo hijos, no puede adoptar un padre.  de esta manera se evitan jerarquias
								adicionalemente, sifsociosrelacionados evita los que tengan papa
							 --->
							<cfif isdefined("SNcodigoPadre") and len(trim(SNcodigoPadre))>
								<cfquery name="rsSocioRelacionado" datasource="#session.DSN#">
									select SNcodigo, SNnumero, SNnombre, GSNid
									from SNegocios 
									where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
									  and SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigoPadre#">
									  <cfif Len(excepto)>
									  and SNid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#excepto#">
									  </cfif>
									<cfif isdefined("SNtiposocio") and len(trim(SNtiposocio))>
										<cfif SNtiposocio neq 'A'>
											and SNtiposocio in ('A', '#SNtiposocio#')
										<cfelse>
											and SNtiposocio = 'A'
										</cfif>
									</cfif> 
									<!--- no quito el query para mostrar los datos aunque estén "malos", ie, el padre tenga padre --->
									and SNidPadre is null 
								</cfquery>
								<cfoutput>#rsSocioRelacionado.SNnumero#&nbsp;&nbsp;#rsSocioRelacionado.SNnombre#</cfoutput><!---  --->
							<cfelse>
								<cfoutput>Sin Asignar</cfoutput>
							</cfif>
						<cfelse>
							No se puede relacionar, ya que hay otros socios relacionados con &eacute;ste.
					</cfif>					</td>
				</tr>
				<tr>
					<td><strong>Tel&eacute;fono:&nbsp;</strong></td>
					<td>
						<cfif LEN(TRIM(rsSocios.SNtelefono))>
						#trim(rsSocios.SNtelefono)#
						<cfelse>
						No ha sido registrado
						</cfif>
					</td>
				</tr>
				<tr>
					<td><strong>Fax:&nbsp;</strong></td>
					<td>
						<cfif LEN(TRIM(rsSocios.SNFax))>
						#trim(rsSocios.SNFax)#
						<cfelse>
						No ha sido registrado
						</cfif>
					</td>
				</tr>
				<tr>
					<td><strong>Correo Electr&oacute;nico:&nbsp;</strong></td>
					<td>
						<cfif LEN(TRIM(rsSocios.SNemail))>
						#trim(rsSocios.SNemail)#
						<cfelse>
						No ha sido registrado
						</cfif>
					</td>
				</tr>
				<tr>
					<td><strong>Estado del Socio de Negocio:&nbsp;</strong></td>
					<td>#rsEstadosS.ESNdescripcion#</td>
				</tr>
				<tr>
					<td><strong>Idioma:&nbsp;</strong></td>
					<td>
						<cfif LEN(TRIM(rsIdioma.LOCIdescripcion))>
						#rsIdioma.LOCIdescripcion#
						<cfelse>
						No ha sido registrado
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2">
			<cfif modo neq 'ALTA'>
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
				<cfset usuario_existente = sec.getUsuarioByRef(form.SNcodigo, Session.EcodigoSDC, 'SNegocios')>
				<cfif usuario_existente.RecordCount>
					<cfif usuario_existente.Utemporal>
						<cfset el_login='Temporal'>
					<cfelseif not usuario_existente.Uestado>
						<cfset el_login='Inactivo. Consulte con el administrador de la seguridad'>
					<cfelse>
						<cfset el_login=usuario_existente.Usulogin>
					</cfif>
				<cfelse>
					<cfset el_login='No se ha asignado usuario'>
				</cfif>
					<strong>Usuario&nbsp;asignado&nbsp;para&nbsp;uso&nbsp;del&nbsp;Sistema:</strong>&nbsp;#HTMLEditFormat(el_login)#
			</cfif>
			</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<input type="hidden" name="DGenerales" value="DGenerales">
	<tr> 
		<td colspan="4" align="center" valign="top" nowrap> 
			<cf_botones Regresar="#Regresa#" exclude="Alta,Baja,Cambio,Limpiar">
		</td>
	</tr>
</table>
</form><cf_web_portlet_end>

</cfoutput>
	<!--- </cf_templatearea>
</cf_template> --->

