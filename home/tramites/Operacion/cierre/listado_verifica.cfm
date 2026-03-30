<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-8-2005.
		Motivo: Nuevo porlet de Cierre de trámites.
 --->
 

<cf_template> <cf_templatearea name="title"> Lista de Tr&aacute;mites por cerrar </cf_templatearea> <cf_templatearea name="body">
<cf_web_portlet_start titulo="Lista de tr&aacute;mites por cerrar">
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfif isdefined("form.chk")>
	<cfparam name="url.id_instancia" default="#form.chk#">
<cfelse>
	<cfparam name="url.id_instancia" default="0">
</cfif>

<cfquery name="data" datasource="#session.tramites.dsn#">
	select 
		p.id_persona,
		p.identificacion_persona,
		p.nombre, p.apellido1, p.apellido2,
		rtrim(t.nombre_tramite) as tramite,
		a.fecha_inicio as fecha,
		a.id_instancia,
		a.id_tramite
		<!--- a.id_instancia as checked --->
	
	from TPInstanciaTramite a
	
		inner join TPPersona p
			on a.id_persona = p.id_persona
	
		inner join TPTramite t
			on a.id_tramite = t.id_tramite
	
	
	where a.completo =0
	and not exists (
				select b.id_instancia 
				from TPInstanciaRequisito b
					join TPRequisito r
						on r.id_requisito = b.id_requisito
				where a.id_instancia = b.id_instancia 
				and b.completado =0
				and r.es_cita = 0
				   )
	and a.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
	order by t.nombre_tramite,	a.fecha_inicio
</cfquery>
<cfif data.recordcount eq 0>
	<cflocation url="listado.cfm">
</cfif>

<cfquery datasource="#session.tramites.dsn#" name="infotramite">
	select t.id_documento_generado, t.id_metodo_generado,
		ident_generada.id_tipoident,
		ident_generada.es_fisica, ident_generada.mascara,
		p.*
	from TPInstanciaTramite ti
		join TPTramite t
			on t.id_tramite = ti.id_tramite
		join TPPersona p
			on p.id_persona = ti.id_persona
		left join TPTipoIdent ident_generada
			on ident_generada.id_documento = t.id_documento_generado
	where ti.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
</cfquery>

<cfinvoke component="home.tramites.componentes.mascara"
	method="mascara2regex"
	mascara="#infotramite.mascara#"
	returnvariable="mascara_js">
</cfinvoke>

<!---
<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select nombre_inst, codigo_inst, id_inst
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
</cfquery>
--->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<form name="form2" method="post" action="listado_sql.cfm" style="margin:0" onsubmit="return validarFormulario(this);" >
	<cfoutput><input name="id_instancia" type="hidden" value="#url.id_instancia#"></cfoutput>


	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr style="background-color:#ededed">
			<td colspan="4" style="border-bottom:1px solid black">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr style="background-color:#ededed">
					  <td style="font-size:14px">&nbsp;</td>
					  <td align="center" style="font-size:14px"><strong>Verificaci&oacute;n de Tr&aacute;mites por Cerrar</strong></td>
					</tr>
				</table>
			</td>
		</tr>
</tr></table>
<cfset form.id_instancia=form.chk>
<cfinclude template="encabezado.cfm">


<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#data.id_persona#"
	id_tramite="#tramite.id_tramite#"
	id_funcionario="#session.tramites.id_funcionario#"
	returnvariable="instancia" />

<script type="text/javascript">
<!--
var popUpWin = 0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function infoRequisito(requisito,tramite) {
	var params ="";
	params = "?id_requisito="+requisito;
	params += "&id_tramite="+tramite;
	popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,250,200,650,400);
}

-->
</script>


<cfoutput>
<table cellpadding="2" cellspacing="0" width="100%">
	<tr id="tr_#instancia.id_requisito#" class="tituloListas" >
	  <td align="center">&nbsp;</td>
	  <td>&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td><strong>Requisito</strong></td>
	  <td><strong>Registrado por </strong></td>
	  <td><strong>Fecha de registro </strong></td>
	</tr>
<cfloop query="instancia">
	<tr id="tr_#instancia.id_requisito#" 
		class="<cfif instancia.currentrow mod 2>listaPar<cfelse>listaNon</cfif>"  >
		<td align="center">&nbsp;</td>
		<cfif not isdefined("iconos") ><td><img src="../../images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#"></td>
		</cfif>
		<td align="center">#CurrentRow#.</td>
		<td>#instancia.nombre_requisito#</td>
	<td>#instancia.nombre_funcionario#</td>
	<td>#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</td>
	</tr>
</cfloop>
</table>
</cfoutput>




<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
		  <td colspan="3">&nbsp;</td>
    </tr>
		<tr>
		  <td colspan="3"	  
		  bgcolor="#ECE9D8" style="padding:3px; font-size:20px;" align="left"><strong>Indique la manera en que desea completar este tr&aacute;mite: </strong></td>
    </tr>
	<cfif Len(Trim(infotramite.id_metodo_generado)) >
		<tr>
		  <td width="4%">&nbsp;
		  </td>
    <td width="4%"><input name="genera" id="genera1" type="radio" value="1" checked></td>
	<td width="92%" style="font-size:18px"><label for="genera1">Generar documento Institucional </label></td>
	</tr>
	</cfif>
		<tr>
		  <td>&nbsp;</td>
    <td><input name="genera" id="genera2" type="radio" value="2" checked></td>
	<td style="font-size:18px"><label for="genera2">Guardar solamente en el expediente </label></td>
	</tr>
		<tr>
		  <td>&nbsp;</td>
    <td><input name="genera" id="genera3" type="radio" value="3"></td>
	<td style="font-size:18px"><label for="genera3">Solamente cerrar el tr&aacute;mite sin generar documento </label></td>
	</tr>
		<tr>
		  <td colspan="3">&nbsp;</td>
  </tr></table>
  <cfif Len(infotramite.id_documento_generado)>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
		  <td colspan="3" bgcolor="#ECE9D8" style="padding:3px; font-size:20px;"><strong>Registre la informaci&oacute;n relacionada con el documento que se va a expedir (si aplica) </strong></td>
    </tr>
		<tr>
		  <td>&nbsp;</td>
    <td colspan="2">
	<cfinclude template="/home/tramites/vistas/datos-cierre.cfm">
	</td>
	</tr>
		<tr>
		  <td colspan="3">&nbsp;</td>
    </tr>
		<tr>
			<td colspan="3">&nbsp;
			</td>
		</tr>
		</table>
		</cfif>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="3" align="center">
				 
				  <input type="button"  onClick="javascript:funcCerrar();" value="Cerrar" class="boton">			
				 
				<input type="button"  onClick="javascript:funcCancelar();" value="Cancelar" class="boton">
			</td>
		</tr>
  </table>
</form>

<script type="text/javascript">
<!--
	function funcCerrar(){
		//alert('En construcción');
		if (validarFormulario(document.form2)){
			document.form2.submit();
		}
	}
	function funcCancelar(){
		location.href = 'listado_form.cfm';
	}

	function validar_identificacion() {
		var mascara = <cfoutput>/#mascara_js#/</cfoutput>;
		var f = document.forms.form2;
		// regresa true si la identificacion es valida o si no esta restringida
		var ident = f.P_IDN.value;
		var imal = document.all ? document.all.img_ident_mal : document.getElementById('img_ident_mal');
		var iok = document.all ? document.all.img_ident_ok : document.getElementById('img_ident_ok');
		iok.style.display  = ident.length && mascara && mascara.test(ident) ? 'inline' : 'none';
		imal.style.display = ident.length && mascara && !mascara.test(ident) ? 'inline' : 'none';
		return mascara.test(ident);
	}
	
	function validarFormulario(f){
		var msg = '';
		<cfif Len(infotramite.id_tipoident)>
			if( f.P_IDN.value == '' ){
				msg += ' - La identificación es requerida.\n';
			} else if (!validar_identificacion()){
				msg += ' - La identificación tiene un formato incorrecto.\n';
			}
			
			<cfif infotramite.es_fisica>
			if (f.P_NOM.value == ''){
				msg += "- El nombre es requerido.\n";
			}
			if (f.P_AP1.value == ''){
				msg += "- El primer apellido es requerido.\n";
			}
			if (f.P_AP2.value == ''){
				msg += "- El segundo apellido es requerido.\n";
			}
			</cfif>
		</cfif>
		if(msg.length){
			alert('Valide la siguiente información:\n'+msg);
			return false;
		}
		return true;
	}
	
//-->
</script>
<cf_web_portlet_end>
</cf_templatearea> </cf_template>
