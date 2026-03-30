<html>
<head>
<title>Lista de Transportes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfif isdefined("Url.OCid") and not isdefined("Form.OCid")>
		<cfparam name="Form.OCid" default="#Url.OCid#">
	</cfif>
	
	
	<cfif isdefined("Url.OCTtipo") and not isdefined("Form.OCTtipo")>
		<cfparam name="Form.OCTtipo" default="#Url.OCTtipo#">
		<cfset Form.F_OCTtipo = Url.OCTtipo>
	</cfif>
	
	
	<cfset purl = "">
	<cfif isdefined("Form.OCid")>
		<cfset purl = purl & "&OCid=" & #Form.OCid#>
	</cfif>
	
	
	<cfif isdefined("Form.OCTtipo")>
		<cfset purl = purl & "&OCTtipo=" & #Form.OCTtipo#>
	</cfif>
	
	
	<script language="JavaScript" type="text/javascript">
	function Asignar(v1, v2, v3) {
		if (window.opener != null) {
			<cfoutput>
				window.opener.document.form1.OCTid.value=v1;
				window.opener.document.form1.OCTtipo.value=v2;
				window.opener.document.form1.OCTtransporte.value=v3;
			</cfoutput>
			window.close();
		}
	}
	</script>
	
	<cfset filtro = "">
	<cfset navegacion = "">
	
	<cfif isdefined("Form.F_OCTtipo") and Len(Trim(Form.F_OCTtipo)) NEQ 0>
		<cfset filtro = filtro & " and OCTtipo = '" & #Form.F_OCTtipo# & "'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_OCTtipo=" & Form.F_OCTtipo>
	</cfif>
	
	<cfif isdefined("Form.F_OCTtransporte") and Len(Trim(Form.F_OCTtransporte)) NEQ 0>
		<cfset filtro = filtro & " and OCTtransporte = '" & #Form.F_OCTtransporte# & "'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_OCTtransporte=" & Form.F_OCTtransporte>
	</cfif>
	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE(""), DE("x=1")) & #purl#>
	
	<cfoutput>
	<form style="margin:0; " name="filtroUsuario" method="post" action="#CurrentPage#">
	
	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	   <tr>
		<td colspan="5">&nbsp;</td>
	   </tr>
	  <tr> 
		<td align="left">Tipo</td>
		 <td align="left">Transporte</td>
	  </tr>
	  
	  <tr> 
		<td> 
			<select id="F_OCTtipo" name="F_OCTtipo" >
				<option value="B" <cfif isdefined("Form.F_OCTtipo") and Form.F_OCTtipo EQ "B">selected</cfif>>Barco</option>
				<option value="A" <cfif isdefined("Form.F_OCTtipo") and Form.F_OCTtipo EQ "A">selected</cfif>>Avion</option>
				<option value="T" <cfif isdefined("Form.F_OCTtipo") and Form.F_OCTtipo EQ "T">selected</cfif>>Terrestre</option>
				<option value="F" <cfif isdefined("Form.F_OCTtipo") and Form.F_OCTtipo EQ "F">selected</cfif>>Ferrocarril</option>
				<option value="O" <cfif isdefined("Form.F_OCTtipo") and Form.F_OCTtipo EQ "O">selected</cfif>>Otro</option>
			</select>	
		</td>
	
		<td> 
		  <input name="F_OCTtransporte" type="text" id="F_OCTtransporte" size="20" maxlength="20" value="<cfif isdefined("Form.F_OCTtransporte")>#Form.F_OCTtransporte#</cfif>">
		</td>
		<td align="center">
		<cfif isdefined("Form.OCid") and len(trim(form.OCid))>
		  <input name="OCid" type="hidden" value="#form.OCid#">
		</cfif>
		  <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar">
		</td>
	  </tr>  
	  
	  
	</table>
	</form>
	</cfoutput>

	<cfif isdefined("Form.OCid") and len(trim(form.OCid))>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="debug" value="N">
			<cfinvokeargument name="tabla" value="OCtransporte a
												  inner join OCtransporteProducto b
														 on b.OCTid		= a.OCTid
														and b.Ecodigo	= a.Ecodigo
														and b.OCid 		= #form.OCid#  
												"/>
			<cfinvokeargument name="columnas" value="distinct a.OCTid ,a.OCTtipo,case a.OCTtipo when 'B' then 'Barco' when 'A' then 'Aéreo'  when 'T' then 'Terrestre' when 'F' then 'Ferrocarril' when 'O' then 'Otro' end as OCTtipoL ,a.OCTtransporte "/>
			<cfinvokeargument name="desplegar" value="OCTtipoL,OCTtransporte"/>
			<cfinvokeargument name="etiquetas" value="Tipo,Transporte"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="filtro" value="
												a.Ecodigo	= #Session.Ecodigo#  
											and a.OCTestado	= 'A'
											#filtro#
											order by OCTtipo,OCTtransporte
										"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="ConlisTransporte.cfm"/>
			<cfinvokeargument name="formName" value="listaTransporte"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="MaxRowsQuery" value="500"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="OCTid,OCTtipo,OCTtransporte"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
		</cfinvoke>
	<cfelse>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="debug" value="N">
			<cfinvokeargument name="tabla" value="OCtransporte a"/>
			<cfinvokeargument name="columnas" value="OCTid,OCTtipo,case OCTtipo when 'B' then 'Barco' when 'A' then 'Avion'  when 'T' then 'Terrestre' when 'F' then 'Ferrocarril' end as  OCTtipoL,OCTtransporte"/>
			<cfinvokeargument name="desplegar" value="OCTtipoL,OCTtransporte"/>
			<cfinvokeargument name="etiquetas" value="Tipo,Transporte"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="filtro" value="
												a.Ecodigo 	= #Session.Ecodigo#  
											and a.OCTestado	= 'T'
											#filtro#
											order by OCTtipo,OCTtransporte
										"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="ConlisTransporte.cfm"/>
			<cfinvokeargument name="formName" value="listaTransporte"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="MaxRowsQuery" value="500"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="OCTid,OCTtipo,OCTtransporte"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
		</cfinvoke>
	</cfif>
</body>
</html>
