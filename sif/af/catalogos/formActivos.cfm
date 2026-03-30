<cfif isdefined("Form.Cambio")>
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

<cfif isDefined("session.Ecodigo") and isDefined("Form.Aid") and Form.Aid NEQ "">
	<cfquery name="rsActivos" datasource="#Session.DSN#" >
		select 
			<cf_dbfunction name="to_char" args="a.Aid"> as Aid
			,<cf_dbfunction name="to_char" args="a.AFMid"> as AFMid
			,AFMcodigo
			,AFMdescripcion
			,<cf_dbfunction name="to_char" args="a.AFMMid"> as AFMMid
			, AFMMcodigo
			, AFMMdescripcion
			,a.Ecodigo
			, cf.Ocodigo
			, cf.Dcodigo
			, a.SNcodigo
			, a.ACid
			, a.ACcodigo
			, a.ARcodigo
			, a.Adescripcion
			, AFMdescripcion
			, AFMMdescripcion
			, a.Aserie
			, a.Aplaca
			, a.Astatus
			, <cf_dbfunction name="to_char" args="a.Aid_padre"> 	as Aid_padre
			, <cf_dbfunction name="to_date" args="ATfechainidep"> 	as ATfechainidep
			, <cf_dbfunction name="to_date" args="ATfechainirev">  	as ATfechainirev
			,Amonto=35
			, ATmonto
			, a.Areflin
			, a.ts_rversion
			, ac.ACdescripcion as Categoria
			, c.ACdescripcion as Clase
			, Odescripcion
			, Ddescripcion
			, case ac.ACmetododep when 1 then 'Línea Recta' when 2 then 'Suma de Dígitos' else '' end as MetodoDep
			, c.ACvutil, case c.ACdepreciable when 'S' then 'SI' when 'N' then 'NO' else '' end as ACdepreciable
			, case c.ACrevalua when 'S' then 'SI' when 'N' then 'NO' else '' end as ACrevalua 	
		from Activos a
			, AFResponsables res
			, CFuncional cf
			, ACategoria ac
			, AClasificacion c
			, ATransActivos ta
			, Oficinas ofi
			, Departamentos de
			, AFMarcas mar
			, AFMModelos mod
		where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >			
			and a.Ecodigo=res.Ecodigo
			and  a.Aid=res.Aid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between  AFRfini and AFRffin
			and res.Ecodigo=cf.Ecodigo
			and res.CFid=cf.CFid
			and cf.Ecodigo=ac.Ecodigo
			and a.ACcodigo=ac.ACcodigo
			and ac.Ecodigo = c.Ecodigo
			and ac.ACcodigo = c.ACcodigo 
			and a.ACid = c.ACid 
			and c.Ecodigo = ta.Ecodigo 
			and a.Aid = ta.Aid 
			and IDtrans=1	
			and ta.Ecodigo=ofi.Ecodigo
			and cf.Ocodigo=ofi.Ocodigo
			and ofi.Ecodigo=de.Ecodigo
			and cf.Dcodigo=de.Dcodigo
			and a.AFMid=mar.AFMid
			and de.Ecodigo = mar.Ecodigo 
			and mar.AFMid=mod.AFMid
			and mar.Ecodigo = mod.Ecodigo 
			and a.AFMMid=mod.AFMMid
	</cfquery>
	
 	<cfif isdefined('rsActivos') and rsActivos.recordCount GT 0 and rsActivos.AFMid NEQ '' and rsActivos.AFMMid NEQ ''>
		<cfquery name="rsMarcaMod" datasource="#Session.DSN#">
			Select <cf_dbfunction name="to_char" args="ma.AFMid"> 	as AFMid
				, <cf_dbfunction name="to_char" args="AFMMid">  	as AFMMid
				, AFMcodigo
				, AFMdescripcion
				, AFMMcodigo
				, AFMMdescripcion
			from AFMarcas ma,
				AFMModelos mo
			where ma.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ma.AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActivos.AFMid#">
				and mo.AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActivos.AFMMid#">
				and ma.Ecodigo=mo.Ecodigo
				and ma.AFMid=mo.AFMid
		</cfquery>	
	</cfif>	
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Aid") and Form.Aid NEQ "">
	<cfquery name="rsAImagen" datasource="#Session.DSN#" >
		select max(AFAlinea) as AFAlinea 
		from AFImagenes 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >		  
	</cfquery>
</cfif>
<cfquery name="rsMask" datasource="#Session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="250">
	  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="AF">
</cfquery>
<cfset Mascara = UCase(rsMask.Pvalor)>

<iframe frameborder="0" name="fr" height="0" width="0"></iframe>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function Anotacion(data) {
	if (data!="") {
		document.form.action='Anotaciones.cfm';
		document.form.submit();
	}
	return false;
}

//-->
</script>

<style type="text/css">
.cajasinbordeb {
	border: 0px none;
	background-color: buttonface;
}
</style>

<body onLoad="MM_preloadImages('/cfmx/sif/imagenes/DATE_D.gif');">
<form action="SQLActivos.cfm" method="post" name="form">
  
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<!--- Encabezado --->
		<tr>
			<td colspan="4"> 
				<table width="50%" align="center" cellpadding="0" cellspacing="0" class="areaFiltro">
				<!--- <table width="50%" border="1" align="center" cellpadding="0" cellspacing="0"> --->
					<tr valign="baseline" ><td align="center" nowrap colspan="4"><b>Datos Generales</b></td></tr>
			
					<tr valign="baseline"> 
						<td height="24" align="right" nowrap>Oficina:&nbsp;</td>
						<td><input type="text" class="cajasinbordeb" name="Aoficina"  value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Odescripcion#</cfoutput></cfif>" size="32" readonly="" alt="El campo Descripción de Oficina"></td>
						<td nowrap align="right">Departamento:&nbsp;</td>
						<td><input type="text" name="Adepartamento"  class="cajasinbordeb" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Ddescripcion#</cfoutput></cfif>" size="32" readonly="" alt="El campo Descripción del Departamento"></td>
					</tr>
			
					<tr valign="baseline"> 
						<td align="right" nowrap>Categor&iacute;a:&nbsp;</td>
						<td><input type="text" name="Acategoria"  class="cajasinbordeb" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Categoria#</cfoutput></cfif>" size="32" readonly="" alt="El campo Descripción de la Categoría"></td>
						<td nowrap align="right">Clasificaci&oacute;n:&nbsp;</td>
						<td><input type="text" name="Aclasificacion" class="cajasinbordeb" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsActivos.Clase#</cfoutput></cfif>" size="20" readonly="" alt="El campo Descripción de la Clasificación"></td>
					</tr>
			
					<tr valign="baseline"> 
						<td align="right" nowrap>Inicio Deprec.:&nbsp;</td>
						<td><input name="ATfechainidep" class="cajasinbordeb" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.ATfechainidep#</cfoutput></cfif>" size="10" maxlength="10" readonly="" alt="El campo fecha de inicio de depreciación"></td>
						<td nowrap align="right">Inicio Rev.:&nbsp;</td>
						<td><input name="ATfechainirev" class="cajasinbordeb" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.ATfechainirev#</cfoutput></cfif>" size="10" maxlength="10" readonly="" alt="El campo fecha de inicio de reevaluación"></td>
					</tr>
			
					<tr valign="baseline"> 
						<td align="right" nowrap>Monto:&nbsp;</td>
						<td align="left" nowrap>
							<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar','','/cfmx/sif/imagenes/DATE_D.gif',1)"></a> 
							<input name="ATmonto" type="text" onBlur="" class="cajasinbordeb" value="<cfif modo NEQ "ALTA"><cfoutput>#LSNumberFormat(rsActivos.ATmonto,',9.00')#</cfoutput></cfif>" size="32" readonly="" alt="El campo Monto de Activo ">
						</td>
						<td nowrap>M&eacute;todo de Depreciaci&oacute;n:&nbsp;</td>
						<td><input name="ACmetododep" type="text" class="cajasinbordeb" id="ACmetododep"  value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsActivos.MetodoDep#</cfoutput></cfif>" size="20" readonly="" alt="El Método de Depreciación"></td>
					</tr>
			
					<tr valign="baseline">
						<td align="right" nowrap>Vida &Uacute;til (meses):&nbsp;</td>
						<td nowrap><input name="ACvutil" type="text" id="ACvutil" class="cajasinbordeb" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.ACvutil#</cfoutput></cfif>" size="10" maxlength="10" readonly="" alt="El campo de vida útil"></td>
						<td nowrap align="right">Depreciable:&nbsp;</td>
						<td><cfif modo NEQ "ALTA"><strong><cfoutput>#rsActivos.ACdepreciable#</cfoutput></strong></cfif></td>
					</tr>
			
					<tr valign="baseline">
						<td nowrap colspan="2">&nbsp;</td>
						<td nowrap align="right">Reval&uacute;a:&nbsp;</td>
						<td><cfif modo NEQ "ALTA"><strong><cfoutput>#rsActivos.ACrevalua#</cfoutput></strong></cfif></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr valign="baseline"><td align="right" nowrap colspan="4">&nbsp;</td></tr>

		<!--- Mantenimiento --->
		<tr valign="baseline"> 
			<td width="14%" align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td width="42%"><input type="text" tabindex="1" name="Adescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsActivos.Adescripcion)#</cfoutput></cfif>" size="32" onFocus="javascript:this.select();" alt="La Descripción del Activo"></td>
			<td width="10%" align="right" nowrap>Responsable:&nbsp;</td>
			<td width="34%"><input tabindex="2" type="text" name="ARcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsActivos.ARcodigo)#</cfoutput></cfif>" size="32" onFocus="javascript:this.select();"></td>
		</tr>
		<tr valign="baseline"> 
			<td align="right" nowrap>Marca:&nbsp;</td>
			<td rowspan="2">
			  <cfif modo NEQ 'ALTA' and isdefined('rsMarcaMod') and rsMarcaMod.recordCount GT 0>
				<cf_sifMarcaMod 
					form="form"
					altMar="Marca"							
					altMod="Modelo"
					size="30"
					query="#rsMarcaMod#"																		
					tabindexMar="3"
					tabindexMod="5">	  
				<cfelse>
					<cf_sifMarcaMod 
						form="form"
						altMar="Marca"
						altMod="Modelo"
						size="30"
						tabindexMar="3"
						tabindexMod="5">	  
			  </cfif>
			</td>
			<td align="right" nowrap>Serie:&nbsp;</td>
			<td><input type="text" tabindex="4" name="Aserie" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsActivos.Aserie)#</cfoutput></cfif>" size="32" onFocus="javascript:this.select();"></td>
		</tr>
		<tr valign="baseline"> 
			<td align="right" nowrap>Modelo:</td>
			<td align="right" nowrap>Placa:&nbsp;</td>
			<td><input name="Aplaca" tabindex="6" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsActivos.Aplaca)#</cfoutput></cfif>" size="15" maxlength="10" onFocus="javascript:this.select();">
			  <b><cfoutput>#Mascara#</cfoutput></b></td>
		</tr>		
		<tr valign="baseline"><td colspan="4">&nbsp;</td></tr>
		<tr valign="baseline"> 
			<td colspan="4" align="center" nowrap>
				<cfif isdefined('rsActivos') and rsActivos.recordCount GT 0>
					<input name="Cambio" type="submit" value="Modificar">
					<cfif modo NEQ "ALTA">
						<input name="btnAnotacion" type="button" value="Anotaciones"  onClick="javascript:Anotacion('<cfoutput>#rsActivos.Aid#</cfoutput>')">
					</cfif>
				</cfif>
			</td>
		</tr>
		
		<cfif modo neq 'ALTA' >
			<tr><td colspan="4" >&nbsp;</td></tr>
			<tr>
				<td  colspan="4" valign="middle" align="center">&nbsp;
					<cfif rsAImagen.RecordCount gt 0 and rsAImagen.AFAlinea neq "" >	
						<cf_sifleerimagen Tabla="AFImagenes" Campo="AFimagen" Condicion="Ecodigo=#session.Ecodigo# and Aid=#form.Aid# and AFAlinea=#rsAImagen.AFAlinea#" Conexion="#session.DSN#" autosize="true" border="false">
					</cfif>
				</td>
			</tr>
		</cfif>	
	</table>

	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsActivos.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
	<input type="hidden" name="Aid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Aid#</cfoutput></cfif>">
	<input type="hidden" name="Astatus" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Astatus#</cfoutput></cfif>">
	<input type="hidden" name="Aid_padre" value="<cfif modo NEQ "ALTA"><cfoutput>#rsActivos.Aid_padre#</cfoutput></cfif>">
</form>

  <SCRIPT LANGUAGE="JavaScript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");

	objForm.AFMid.required = true;
	objForm.AFMid.description="Marca";
	objForm.AFMMid.required = true;
	objForm.AFMMid.description="Modelo";	
	objForm.Adescripcion.required = true;
	objForm.Adescripcion.description="Descripción";	

	objForm.Aplaca.trim();
	objForm.Aplaca.toUpperCase();
	
	objForm.Aplaca.validate=true;
	objForm.Aplaca.required = true;
	objForm.Aplaca.description="Placa";
	var strErrorMsg="El valor de la placa no concuerda con el formato <cfoutput>#Mascara#</cfoutput>";
	objForm.Aplaca.validateFormat("<cfoutput>#Lcase(Mascara)#</cfoutput>", "alphanumeric");
	//-->
  </SCRIPT>