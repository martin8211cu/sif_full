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
<cfset navegacion= "">
<cfif isdefined("url.CPcodigo") and not isdefined("form.CPcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo >
</cfif>
<cfif isdefined('form.CPcodigo') and LEN(TRIM(form.CCTcodigo))>
	<cfset navegacion = "CPcodigo=" & form.CCTcodigo>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cf_templateheader title="Catálogo para Configuración de Validación de Compromisos ">
<cf_web_portlet_start titulo="Catálogo para Configuración de Validación de Compromisos">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<table width="95%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" width="50%">
		<cf_dbfunction name="OP_Concat" returnvariable = "_CAT">
	   <cf_dbfunction name="to_char" args="a.PCNid" returnvariable = "LvarPCNid">
			<cfinvoke  component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CPValidacionConfiguracion a
						inner JOIN CPValidacionValores b
							ON a.CPVid = b.CPVid
						left outer join PCECatalogo c
							on a.PCEcatid = c.PCEcatid "/>
				<cfinvokeargument name="columnas" value="a.CPVCid,b.Descripcion, a.PCEcatid,a.Valor,a.Descripcion as Catalogo"/>
                <cfinvokeargument name="desplegar" value="Descripcion, Catalogo, Valor"/>
				<cfinvokeargument name="etiquetas" value="Nivel, Catálogo, Valor"/>
				<cfinvokeargument name="formatos" value="S,S,S,S"/>
				<cfinvokeargument name="filtro" value="1=1 order by a.CPVid"/>
				<cfinvokeargument name="align" value="left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="formName" value="lista1"/>
				<cfinvokeargument name="keys" value="CPVCid"/>
				<cfinvokeargument name="irA" value="CPValidacionConfiguracion.cfm"/>
				<cfinvokeargument name="PageIndex" value="321"/>
			</cfinvoke>
			<script language="javascript">
				function fnDesc(PCNid, tipo)
				{
					<cfoutput>
					document.getElementById("ifrPCNid").src="SQLMascarasCuentas.cfm?id1=#1#&id2=" + PCNid + "&OP=" + tipo;
					</cfoutput>
				}
			</script>
			<iframe id="ifrPCNid" style="display:none;">
			</iframe>
		</td>
		<td><cfinclude template="CPValidacionConfiguracion-form.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
