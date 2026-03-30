<cfset def = QueryNew('dato')>

<cfset labelsontop = 0>
<cfset labelsonleft = 1>

<cfparam name="Attributes.labelstyle" default="#labelsontop#" type="numeric"> <!--- 0 = Labels on Top, 1 = Labels on Left --->
<cfparam name="Attributes.Conlis" default="true" type="boolean"> <!--- Indica si se levanta el Conlis o No --->
<cfparam name="Attributes.labelcategoria" default="Categor&iacute;a" type="string"> <!--- Etiqueta de la categoría --->
<cfparam name="Attributes.labelpaso" default="Paso" type="string"> <!--- Etiqueta de la paso --->
<cfparam name="Attributes.labeltipotabla" default="Tipo Tabla" type="string"> <!--- Etiqueta de la tabla --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.size" default="40" type="numeric"> <!--- Tamaño del campo Descripción Tipo Tabla --->
<cfparam name="Attributes.puesto" default="false" type="boolean"> <!--- Tamaño del campo Descripción Tipo Tabla --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	<!--// 
<cfif Attributes.Conlis>
	function doConlis_catsal<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var puesto = "";
		<cfoutput>
			<cfset campos = "&p0=RHTCid#index#&p1=RHTTcodigo#index#&p2=RHTTdescripcion#index#&p3=RHMCcodigo#index#&p4=RHMCpaso#index#">
			<cfif Attributes.puesto>
				if (document.<cfoutput>#Attributes.form#.RHPcodigo#index#</cfoutput>.value==""){alert('Debe seleccionar el puesto.');return;}
				puesto=puesto+'&RHPcodigo='+document.<cfoutput>#Attributes.form#.RHPcodigo#index#</cfoutput>.value;
				puesto=puesto+'&RHPcodigoext='+document.<cfoutput>#Attributes.form#.RHPcodigoext#index#</cfoutput>.value;
			</cfif>
			var params = "f=#Attributes.form##campos#"+puesto;
			var nuevo = window.open('/cfmx/rh/Utiles/Conliscatsal.cfm?'+params,'Listacatsal','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
</cfif>
<cfif Attributes.puesto>
	function funcRHPcodigo(){
		Resetcatsal<cfoutput>#index#</cfoutput>();
	}
</cfif>
	function Resetcatsal<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.RHTCid#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHMCcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHMCpaso#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHTTcodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.RHTTdescripcion#index#</cfoutput>.value = "";
	}
	//-->
</script>

<cfoutput>
			<input <cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTCid#index#")>value="#Evaluate('Attributes.query.RHTCid#index#')#"</cfif>
						type="hidden" 
						name="RHTCid#index#" 
						id="RHTCid#index#">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfif Attributes.labelstyle eq labelsontop>
				<tr>
					<td height="25"><strong>#Attributes.labelcategoria#</strong></td>
					<td height="25"><strong>#Attributes.labelpaso#</strong></td>
			  </tr>
				</cfif>
			  <tr>
				<cfif Attributes.labelstyle eq labelsonleft>
				<td height="25" width="50%">
					<strong>#Attributes.labelcategoria# / #Attributes.labelpaso#</strong>
				</td>
				</cfif>
				<td height="25">
					<input <cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHMCcodigo#index#")>value="#Evaluate('Attributes.query.RHMCcodigo#index#')#"</cfif>
						<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
						type="text"
						name="RHMCcodigo#index#" id="RHMCcodigo#index#"
						maxlength="5"
						size="10"
						disabled>
				</td>
				<td height="25">
					<input <cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHMCpaso#index#")>value="#Evaluate('Attributes.query.RHMCpaso#index#')#"</cfif>
						<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
						type="text"
						name="RHMCpaso#index#" id="RHMCpaso#index#"
						maxlength="10"
						size="10"
						disabled>
						<cfif Attributes.Conlis><a href="javascript: doConlis_catsal#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Categor&iacute;s" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></cfif>
				</td>
			  </tr>
			  <cfif Attributes.labelstyle eq labelsontop>
				<tr>
				<td height="25" colspan="2"><strong>#Attributes.labeltipotabla#</strong></td>
			  </tr>
				</cfif>
			  <tr>
				<cfif Attributes.labelstyle eq labelsonleft>
				<td height="25">
					<strong>#Attributes.labeltipotabla#</strong>
				</td>
				</cfif>
				<td height="25">
				<input <cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTcodigo#index#")>value="#Evaluate('Attributes.query.RHTTcodigo#index#')#"</cfif>
						<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
						type="text"
						name="RHTTcodigo#index#" id="RHTTcodigo#index#"
						maxlength="10"
						size="10"
						disabled>
				</td>
				<td height="25">
				<input <cfif isdefined("Attributes.query") and isdefined("Attributes.query.RHTTdescripcion#index#")>value="#Evaluate('Attributes.query.RHTTdescripcion#index#')#"</cfif>
						<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>tabindex="#Attributes.tabindex#"</cfif>
						type="text"
						name="RHTTdescripcion#index#" id="RHTTdescripcion#index#"
						maxlength="80"
						size="#Attributes.size#"
						disabled>
			  </tr>
		  </table>
</cfoutput>