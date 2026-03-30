<!---
	Esta pantalla se invoca desde dos lugares:
	1. Lista de Reportes
	2. Conlis de Reportes
--->

<!--- Si es un conlis debe invocarse la función de Asignar --->
<cfif CompareNoCase(CurrentPage, 'analisis-salarial-conlisReportes.cfm') EQ 0>
	<cfset Conlis = true>
	<script language="javascript" type="text/javascript">
		function Asignar(idReporte) {
			window.opener.document.form1.RHASid_Rec.value = idReporte;
			window.opener.document.form1.submit();
			window.close();
		}
	</script>
<cfelse>
	<cfset Conlis = false>
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select  a.RHASid, a.Ecodigo, a.EEid, a.ETid, a.Eid, a.Mcodigo, a.NoSalario, a.RHASdescripcion, a.RHASref, a.RHASaplicar, a.RHASnumper, a.BMUsucodigo, 
			b.EEnombre, c.ETdescripcion, d.Edescripcion, e.Mnombre,
			'1' as paso
	from RHASalarial a
		inner join EncuestaEmpresa b
			on b.EEid = a.EEid
		inner join EmpresaOrganizacion c
			on c.ETid = a.ETid
		inner join Encuesta d
			on d.Eid = a.Eid
		inner join Monedas e
			on e.Mcodigo = a.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.RHAStipo = 0
	order by RHASid desc
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td>
		<cfset navegacion = ''>
		<cfif isdefined('form.paso')>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paso=" & Form.paso>
		</cfif>
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="RHASdescripcion, RHASref, EEnombre, ETdescripcion, Edescripcion, Mnombre"/>
			<cfinvokeargument name="etiquetas" value="Reporte, Evaluaci&oacute;n, Encuestadora, Tipo, Encuesta, Moneda"/>
			<cfinvokeargument name="formatos" value="V,D,V,V,V,V"/>
			<cfinvokeargument name="align" value="left, center, left, left, left, left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#CurrentPage#"/>
			<cfinvokeargument name="keys" value="RHASid"/>
		<cfif Conlis>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="RHASid"/>
		</cfif>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="botones" value=""/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<!--- <cfinvokeargument name="mostrar_filtro" value="yes">
			<cfinvokeargument name="filtrar_automatico" value="yes"> --->
		</cfinvoke>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
