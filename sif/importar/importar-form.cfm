<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<!---
	Despliega un formulario para importar
	Parámetros:
		url.fmt	( requerido ) Número de formato, EImportador.EIid
--->
<head>
<title><cf_translate key="Importacion">Importaci&oacute;n</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body style="margin:0">

<cfset session.Importador.Avance = -1>
<cfparam name="url.fmt" type="numeric" default="0">
<cfquery datasource="sifcontrol" name="formatos">
	select * from EImportador
	where (Ecodigo is null
	   or Ecodigo = #Session.Ecodigo#)
	  and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fmt#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PorFavorIndiqueElArchivoQueDeseaImportar"
	Default="Por favor indique el archivo que desea importar"
	returnvariable="MSG_PorFavorIndiqueElArchivoQueDeseaImportar"/>

<cfif formatos.RecordCount EQ 1>
	<script type="text/javascript">
		function checkForm(f) {
			if(f.archivo.value=='') {
				alert("<cfoutput>#MSG_PorFavorIndiqueElArchivoQueDeseaImportar#</cfoutput>");
				return false;
			}
			if(fnInputNames()){
				f.importar.disabled=true;
				return true;
			}else
				return false;
		}
	</script>
	<form name="form1" id="form1" method="post" action="/cfmx/sif/importar/importar-avance.cfm" 
		enctype="multipart/form-data"
		onsubmit="return checkForm(this)">
		<cfif isdefined("url.parameters") and ListLen(url.parameters,'|') GT 0>
		<cfloop index="listItem" List="#url.parameters#" delimiters="|">
			<cfoutput>
			<input type="hidden" name="#ListGetAt(listItem,1,',')#" value="#ListGetAt(listItem,2,',')#">
			</cfoutput>
		</cfloop>
		</cfif>
        <cfif isdefined("url.InputNames") and ListLen(url.InputNames,'|') GT 0>
            <cfloop index="listItem" List="#url.InputNames#" delimiters="|">
                <cfoutput>
                <input type="hidden" name="#ListGetAt(listItem,1,',')#" value="">
                </cfoutput>
            </cfloop>
		</cfif>
	<table border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="2">
			<cfoutput>
				<input type="hidden" name="fmt" value="#formatos.EIid#">
				<option value="#formatos.EIid#">#formatos.EIdescripcion#
			</cfoutput>
			</select></td>
		</tr>
		<tr>
			<td><cf_translate key="LB_Archivo">Archivo</cf_translate>:&nbsp;</td>
			<td nowrap="nowrap">
				<input name="archivo" type="file">
				<input size="1" style="border:none;"
					onclick="if (this.value == '*') this.form.importar.disabled = false;"
				>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Importar"
					Default="Importar"
					XmlFile="/sif/generales.xml"
					returnvariable="BTN_Importar"/>			
				<input name="importar" type="submit" id="importar" value="<cfoutput>#BTN_Importar#</cfoutput>">
			</td>
		</tr>
	</table>
	</form>
    <script language="javascript1.2">
		<cfif isdefined("url.InputNames") and ListLen(url.InputNames,'|') GT 0>
			function fnInputNames(){
            <cfloop index="listItem" List="#url.InputNames#" delimiters="|">
                <cfoutput>
				<cfif Len(Trim(ListGetAt(listItem,3,','))) gt 0>
					valor = window.parent.document.#url.form#.#ListGetAt(listItem,1,',')#.value;
					if(valor == ''){
						alert("El campo #ListGetAt(listItem,3,',')# es requerido.");
						return false;
					}
				</cfif>
				document.form1.#ListGetAt(listItem,2,',')#.value = window.parent.document.#url.form#.#ListGetAt(listItem,1,',')#.value;
                </cfoutput>
            </cfloop>
			return true;
			}
		</cfif>
	</script>
<cfelse>
	
	<cf_translate key="LB_Formato">Formato</cf_translate> <cfoutput> #url.fmt# </cfoutput> <cf_translate key="LB_NoExiste">no existe</cf_translate>
</cfif>
</body>
</html>
