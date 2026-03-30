<cfset modo='ALTA'>
<cfif isdefined("Form.id_tipo") and len(trim("Form.id_tipo")) NEQ 0 and Form.id_tipo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!----------------------------------------------- CONSULTAS ------------------------------------------------->

<!--- 1. Form Encabezado --->
<cfquery datasource="#Session.Edu.DSN#" name="rsBibliotecas">
		
		declare @id numeric
		if not exists ( select 1 from BibliotecaCentroE BCE, MABiblioteca MAB
			where BCE.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			  and MAB.id_biblioteca = BCE.id_biblioteca
		)
		begin
			insert into MABiblioteca (nombre_biblio)
			values('Biblioteca')
		
			select @id = @@identity
			
			insert into BibliotecaCentroE (CEcodigo, id_biblioteca)
			values(<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,@id)
		end
		else  
			select 1
			
</cfquery>
<cfquery datasource="#Session.Edu.DSN#" name="rsMABiblioteca">
	select a.id_biblioteca as id_biblioteca , a.nombre_biblio 
	from MABiblioteca a, BibliotecaCentroE b
	where a.id_biblioteca = b.id_biblioteca
	  and b.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
</cfquery>

<cfif modo NEQ 'ALTA' and isdefined("Form.id_tipo") and len(trim(Form.id_tipo))>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsMAtipoDocumento">
		select nombre_tipo, convert(varchar,id_tipo) from MATipoDocumento 
		where id_tipo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMADocumento">
		<!--- Existen dependencias con MADocumento --->
		select 1 from MADocumento a, MATipoDocumento b
		where a.id_tipo = <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
		  and a.id_tipo = b.id_tipo
	</cfquery> 
	
</cfif>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
	  <td colspan="2" class="tituloAlterno"><cfif (modo NEQ 'ALTA')>Modificar <cfelse>Nuevo </cfif>Tipo de Documento</td>
	</tr>
</table>

<form name="form1" method="post" action="SQLBiblioteca.cfm" style="margin:0">
	<input name="id_tipo" id="id_tipo" value="<cfif (modo NEQ 'ALTA')>#Form.id_tipo#</cfif>" type="hidden">
	<input name="Pagina" id="Pagina" value="#Form.Pagina#" type="hidden">
	<input type="hidden" name="MaxRows2" value="#form.MaxRows2#">
	<input name="Filtro_nombre_tipo" id="Filtro_nombre_tipo" value="#Form.Filtro_nombre_tipo#" type="hidden">
	
	<fieldset><legend>Tipo de Documento</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
		  <td nowrap><input name="nombre_tipo" type="text" id="nombre_tipo2" size="80" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsMAtipoDocumento.nombre_tipo#</cfif>"></td>
		</tr>
		<tr> 
		  <td align="right" nowrap>Biblioteca:&nbsp;</td>
		  <td width="70%" nowrap><select name="id_biblioteca" id="id_biblioteca">
			  <option value="#rsMABiblioteca.id_biblioteca#" <cfif (isDefined("form.id_biblioteca") AND #form.id_biblioteca# EQ #rsMABiblioteca.id_biblioteca#)>selected</cfif>>#rsMABiblioteca.nombre_biblio# 
			  </option>
			</select>
		  </td>
		</tr>
	</table>
	</fieldset>
	<cfif (modo NEQ 'ALTA')>
		<fieldset><legend>Atributos</legend>
			<cfinclude template="formBibliotecaDet.cfm">
		</fieldset>
	</cfif>
	<cfparam name="mododet" default="ALTA">
	<cf_botones modo="#modo#" nameEnc="Tipo" generoEnc="M" tabindex="3" include="Lista" mododet="#mododet#">
</form>

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlisMantValores() {
		//alert(document.form1.id_atributo2.value);
		popUpWindow("ConlisValores.cfm?id_tipo="+document.form1.id_atributo.value+"&nombre="+document.form1.nombre_atributo.value,250,100,650,500);
	}
	
	function es_valor()
	{
		var valor = document.form1.tipo_atributo.value;
		if (valor == 'V')
		{
			document.getElementById('btnValores').style.display='';	
		}
		else{
			document.getElementById('btnValores').style.display='none';	
		}
	}
	<cfif modoDet NEQ "ALTA">
		document.getElementById('btnValores').style.display='none';
		es_valor();
	</cfif>
	
</script>

<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--
	objForm.nombre_tipo.description = "Descripción";
	<cfif (modo NEQ 'ALTA')>
		objForm.nombre_tipo.description = "Descripción";
		objForm.nombre_atributo.description = "nombre de Atributo";
		objForm.tipo_atributo.description = "Tipo de Atributo";
	</cfif>
	function funcAltaDet() {
		habilitarValidacion(true);
	}
	function funcCambioDet() {
		habilitarValidacion(true);
	}
	
	function funcCambioDet() {
		habilitarValidacion(true);
	}
	
	function habilitarValidacion(validar_detalles) {
		objForm.nombre_tipo.required = true;
		<cfif (modo NEQ 'ALTA')>
			objForm.nombre_atributo.required = validar_detalles;
			objForm.tipo_atributo.required = validar_detalles;	
		</cfif>
	}
	function deshabilitarValidacion() {
		objForm.nombre_tipo.required = false;
		<cfif (modo NEQ 'ALTA')>
			objForm.nombre_atributo.required = false;
			objForm.tipo_atributo.required = false;	
		</cfif>
	}
	function funcNuevo() {
		location.href = "Biblioteca.cfm?PageNum_Lista=#form.Pagina#&Filtro_nombre_tipo=#Form.Filtro_nombre_tipo#";
		return false;
	}
	function funcLista() {
		<cfset Paramid_tipo = "">
		<cfif isdefined("form.id_tipo") and len(trim(form.id_tipo))>
			<cfset Paramid_tipo = "&id_tipo=#form.id_tipo#">
		</cfif>
		location.href = "listaBiblioteca.cfm?Pagina=#form.Pagina#&Filtro_nombre_tipo=#Form.Filtro_nombre_tipo##Paramid_tipo#";
		return false;
	}
	function validaForm(f){
	}
	<cfif (modo NEQ 'ALTA')>
		objForm.nombre_atributo.obj.focus();
	<cfelse>
		objForm.nombre_tipo.obj.focus();
	</cfif>
	-->
</script>

</cfoutput>

