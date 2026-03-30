<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-8-2005.
		Motivo: Nuevo porlet de Cierre de trámites.
 --->
<!---
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Lista de Tr&aacute;mites por Cerrar</title>
<cf_templatecss>
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">
</head>
<!--- Style para que los botones sean de colores --->
<body style="margin:0">
---> <cf_template> <cf_templatearea name="title"> Lista de Tr&aacute;mites por cerrar </cf_templatearea> <cf_templatearea name="body">

<cfif isdefined("url.filtro_cedula") and len(trim(url.filtro_cedula)) and not isdefined("form.filtro_cedula")>
  <cfset form.filtro_cedula= url.filtro_cedula>
</cfif>
<cfif isdefined("url.filtro_nombre") and len(trim(url.filtro_nombre)) and not isdefined("form.filtro_nombre")>
  <cfset form.filtro_nombre= url.filtro_nombre>
</cfif>
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha)) and not isdefined("form.filtro_fecha")>
  <cfset form.filtro_fecha= url.filtro_fecha>
</cfif>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("form.filtro_cedula") and len(trim(form.filtro_cedula)) NEQ 0>
  <cfset navegacion = navegacion & "&filtro_cedula=#form.filtro_cedula#">
</cfif>
<cfif isdefined("form.filtro_nombre") and len(trim(form.filtro_nombre)) NEQ 0>
  <cfset navegacion = navegacion & "&nombre=#form.filtro_nombre#">
</cfif>
<cfif isdefined("form.filtro_fecha") and len(trim(form.filtro_fecha)) NEQ 0>
  <cfset navegacion = navegacion & "&fecha_inicio=#form.filtro_fecha#">
</cfif>
<cfquery name="rsLista" datasource="#session.tramites.dsn#">
	select 
		p.identificacion_persona as cedula,
		substring((rtrim(p.nombre) || ' ' || rtrim(p.apellido1) || ' '  || rtrim(p.apellido2)),1,35) as nombre,
		rtrim(t.nombre_tramite) as tramite,
		a.fecha_inicio as fecha,
		a.id_instancia
	
	from TPInstanciaTramite a
	
		inner join TPPersona p
			on a.id_persona = p.id_persona
	
		inner join TPTramite t
			on a.id_tramite = t.id_tramite
	
	
	where 
		a.completo =0
		and not exists 
			(
				select b.id_instancia 
				from TPInstanciaRequisito b
					join TPRequisito r
						on r.id_requisito = b.id_requisito
				where a.id_instancia = b.id_instancia 
				and b.completado = 0
				and r.es_cita = 0
			)
	<cfif isdefined("form.filtro_cedula") and len(trim(form.filtro_cedula))>
		and p.identificacion_persona like'%#form.filtro_cedula#%'
	</cfif>
	<cfif isdefined("form.filtro_nombre") and len(trim(form.filtro_nombre))>
		and upper(substring((rtrim(p.nombre) || ' ' || rtrim(p.apellido1) || ' '  || rtrim(p.apellido2)),1,25)) like'%#ucase(form.filtro_nombre)#%'
	</cfif>
	<cfif isdefined("form.filtro_tramite") and len(trim(form.filtro_tramite))>
		and upper(t.nombre_tramite) like'%#ucase(form.filtro_tramite)#%'
	</cfif>
	<cfif isdefined("form.filtro_fecha") and len(trim(form.filtro_fecha))>
		and a.fecha_inicio = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.filtro_fecha)#">
	</cfif>
	<cfif Len(session.tramites.id_inst)>
		and t.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	</cfif>
	order by t.nombre_tramite,	a.fecha_inicio
</cfquery>
<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select id_inst, nombre_inst, codigo_inst
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#" null="#Len(session.tramites.id_inst) EQ 0#">
</cfquery>
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cf_web_portlet_start titulo="Lista de tr&aacute;mites por cerrar">
<cfinclude template="/home/menu/pNavegacion.cfm">
<form name="form1" method="post" action="listado_verifica.cfm" style="margin:0" >
  <table width="100%" border="0" cellpadding="2" cellspacing="0">
    <tr style="background-color:#ededed">
      <td colspan="4" style="border-bottom:1px solid black">
	  	<table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr style="background-color:#ededed">
            <td style="font-size:14px">&nbsp;</td>
            <td align="center" style="font-size:14px"><strong>Tr&aacute;mites&nbsp;por&nbsp;Cerrar</strong> </td>
			<!---
            <td width="8%" align="right" style="font-size:16px"><a href="javascript:imprimir();" id="imp"> <img src="../../images/impresora.gif" border="0" alt="Imprimir"> </a> </td>
			--->
          </tr>
        </table>
		</td>
    </tr>
    <tr>
      <td colspan="2"><cfif (isdefined("form.Listado") and len(trim(form.listado)) and form.Listado EQ 1) or not isdefined("form.Listado")>
          <!--- Listo por aprobar --->
          <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsLista#">
            <cfinvokeargument name="desplegar" value="id_instancia,cedula, nombre, fecha"/>
            <cfinvokeargument name="etiquetas" value="N&uacute;mero,Cédula, Nombre, Fecha"/>
            <cfinvokeargument name="formatos" value="S,S,S,D"/>
            <cfinvokeargument name="align" value="left,left, left, left"/>
            <cfinvokeargument name="ajustar" value="S,S,N,S"/>
            <cfinvokeargument name="Cortes" value="tramite"/>
            <cfinvokeargument name="radios" value="S"/>
            <cfinvokeargument name="incluyeForm" value="no"/>
            <cfinvokeargument name="formName" value="form1"/>
            <cfinvokeargument name="showEmptyListMsg" value="true"/>
            <cfinvokeargument name="irA" value=""/>
            <cfinvokeargument name="showLink" value="false"/>
            <cfinvokeargument name="keys" value="id_instancia"/>
            <cfinvokeargument name="navegacion" value="#navegacion#"/>
            <cfinvokeargument name="MaxRows" value="10"/>
            <cfinvokeargument name="mostrar_filtro" value="true"/>
          </cfinvoke>
          <cfelseif (isdefined("form.Listado") and len(trim(form.listado))) and (form.Listado EQ 2 or  form.Listado EQ 3)>
          <!--- Pendientes --->
          <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsLista#">
            <cfinvokeargument name="desplegar" value="cedula, nombre, fecha"/>
            <cfinvokeargument name="etiquetas" value="Cédula, Nombre, Fecha"/>
            <cfinvokeargument name="formatos" value="S,S,D"/>
            <cfinvokeargument name="align" value="left, left, left"/>
            <cfinvokeargument name="ajustar" value="S,N,S"/>
            <cfinvokeargument name="Cortes" value="tramite"/>
            <cfinvokeargument name="checkboxes" value="N"/>
            <cfinvokeargument name="incluyeForm" value="no"/>
            <cfinvokeargument name="formName" value="form1"/>
            <cfinvokeargument name="showEmptyListMsg" value="true"/>
            <cfinvokeargument name="irA" value=""/>
            <cfinvokeargument name="showLink" value="false"/>
            <cfinvokeargument name="keys" value="id_instancia"/>
            <cfinvokeargument name="navegacion" value="#navegacion#"/>
            <cfinvokeargument name="MaxRows" value="10"/>
            <cfinvokeargument name="mostrar_filtro" value="true"/>
          </cfinvoke>
        </cfif>
      </td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td id="botones" align="center" colspan="2"><cfif (isdefined("form.Listado") and len(trim(form.listado)) and form.Listado EQ 1) or not isdefined("form.Listado")>
          <input type="button"  onClick="javascript:funcCerrar();" value="Cerrar" class="boton">
		  <!---
          <input type="button"  onClick="javascript:ImprimirLista();" value="Imprimir Lista" class="boton">
		  --->
        </cfif>
      </td>
    </tr>
  </table>
</form>
<cf_web_portlet_end>
<script type="text/javascript">
<!--
	function funcCerrar()
	{
		//alert('En Construcción');
		document.form1.submit();
	}

	function ImprimirLista()
	{
		alert('En Construcción');
		//document.form1.action="Imprimelista.cfm"
		//window.open('ImprimirLista.cfm','_self');
		//return false;
	}
	
	function EjecutarPantalla()
	{
		document.form1.action="listado_form.cfm";
		document.form1.submit();
	}
	
	function imprimir() {
			var botones = document.getElementById("botones");
			var imp = document.getElementById("imp");
			//var det = document.getElementById("reqlista_det");
			imp.style.display = 'none';
			botones.style.display = 'none';
			//det.style.display = '';
			window.print()	
			botones.style.display = ''
			imp.style.display = ''
			//det.style.display = 'none';
		}	
	
	/*function MarcaChk(valor){
		alert(valor);
		alert(this.value);
		var LvarValor = valor;
		if(document.form1.chk.value==LvarValor)
			{alert('hola');
				document.form1.chk.checked;
			}
	}*/
	
//-->
</script>
</cf_templatearea> </cf_template>
<!---

</body>
</html>--->
