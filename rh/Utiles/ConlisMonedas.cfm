<cfif isdefined("url.form") and not isdefined("form.form")>
	<cfset form.form= url.form >
</cfif>
<cfif isdefined("url.id") and not isdefined("form.id")>
	<cfset form.id= url.id >
</cfif>
<cfif isdefined("url.desc") and not isdefined("form.desc")>
	<cfset form.desc= url.desc >
</cfif>
<cfif isdefined("url.fmt") and not isdefined("form.fmt")>
	<cfset form.fmt= url.fmt >
</cfif>
<cfif isdefined("url.quitar") and not isdefined("form.quitar")>
	<cfset form.quitar= url.quitar >
</cfif>
<cfif isdefined("url.Miso4217_F") and not isdefined("form.Miso4217_F")>
	<cfset form.Miso4217_F= url.Miso4217_F >
</cfif>
<cfif isdefined("url.Mnombre_F") and not isdefined("form.Mnombre_F")>
	<cfset form.Mnombre_F= url.Mnombre_F >
</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(valor1, valor2, valor3) {
		window.opener.document.<cfoutput>#form.form#.#form.id#</cfoutput>.value=valor1;
		window.opener.document.<cfoutput>#form.form#.#form.desc#</cfoutput>.value=valor2;
		<cfif isdefined("form.fmt") and Trim(form.fmt) NEQ "">
			window.opener.document.<cfoutput>#form.form#.#form.fmt#</cfoutput>.value=valor3;
		</cfif>
		window.close();
	}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.id") and Len(Trim(Form.id)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id=" & Form.id>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.fmt") and Len(Trim(Form.fmt)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fmt=" & Form.fmt>
</cfif>

<html>
<head>
<title>Lista de Monedas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfoutput>
	<form style="margin:0;" name="filtroMonedasConlis" action="ConlisMonedas.cfm" method="post">
		<cfif isdefined("form.form") and form.form NEQ ''>
			<input type="hidden" name="form" value="#form.form#">
		</cfif>
		<cfif isdefined("form.id") and form.id NEQ ''>
			<input type="hidden" name="id" value="#form.id#">
		</cfif>
		<cfif isdefined("form.desc") and form.desc NEQ ''>
			<input type="hidden" name="desc" value="#form.desc#">
		</cfif>	
		<cfif isdefined("form.fmt") and form.fmt NEQ ''>
			<input type="hidden" name="fmt" value="#form.fmt#">
		</cfif>	
		<cfif isdefined("form.quitar") and form.quitar NEQ ''>
			<input type="hidden" name="quitar" value="#form.quitar#">
		</cfif>	
	
		<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="14%" align="right"><strong>C&oacute;digo:</strong></td>
				<td width="11%"><input name="Miso4217_F" type="text" id="Miso4217_F" size="5" maxlength="3" value="<cfif isdefined("Form.Miso4217_F")>#Form.Miso4217_F#</cfif>" onFocus="javascript:this.select();" ></td>
				<td width="13%" align="right"><strong>Descripci&oacute;n:</strong>
				</td>
				<td width="42%"><input name="Mnombre_F" type="text" id="Mnombre_F" size="30" maxlength="30" value="<cfif isdefined("Form.Mnombre_F")>#Form.Mnombre_F#</cfif>" onFocus="javascript:this.select();" ></td>
				<td width="20%"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select Mcodigo, Mnombre, Msimbolo, Miso4217 
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	<cfif isdefined("Form.btnFiltrar") and (Form.Miso4217_F NEQ "")>
  	 	and upper(Miso4217) like '%#Ucase(Form.Miso4217_F)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Miso4217_F=" & Form.Miso4217_F>
	</cfif>
	<cfif isdefined("Form.btnFiltrar") and (Form.Mnombre_F NEQ "")>
		and upper(Mnombre) like '%#Ucase(Form.Mnombre_F)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre_F=" & Form.Mnombre_F>
	</cfif>	  	
	<cfif isdefined('form.quitar') and len(trim(form.quitar))>
		and Mcodigo not in (#form.quitar#)
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "quitar=" & Form.quitar>
	</cfif>	
	order by Miso4217, Mnombre  
</cfquery>

<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#conlis#"/>
		<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Moneda"/>
		<cfinvokeargument name="desplegar" value=" Miso4217,Mnombre"/>
		<cfinvokeargument name="formatos" value="V,V"/>
		<cfinvokeargument name="formName" value="formConlisMon"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="ConlisMonedas.cfm"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="Mcodigo,Mnombre,Miso4217"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>	
		<cfinvokeargument name="showemptylistmsg" value="true"/>
	</cfinvoke>
</body>
</html>