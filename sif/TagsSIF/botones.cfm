
<!--- ************************************************** TAG de Botones ************************************************** --->
<!--- RESUMEN
	Este TAG pinta un set botones como el tradicional portlet de botones, pero con varias ventajas:
		1. Utilice por defecto para pintar como el tradicional portlet de botones: 
							ejemplo <cf_botones modo="#modo#">, donde modo = ALTA / CAMBIO.
		2. Puede utilizar los atributos exclude, o excludeArray para excluir algunos botones del set de botones por defecto:
							ejemplo <cf_botones modo="#modo#" exclude="CAMBIO">, excluye el botn de CAMBIO.
		3. Puede utilizar los atributos include, o includeArray para incluir algunos botones adicionales al set de botones por defecto:
							ejemplo <cf_botones modo="#modo#" include="Regresar">, incluye el botn de REGRESAR.
				alternamente puede utilizar el includevalues para poner un valor complejo a los botones incluidos:
							ejemplo <cf_botones modo="#modo#" includevalues="Regresar a la pantalla anterior" include="Regresar">, incluye el botn de REGRESAR. 
				LOS BOTONES SE INCLUYEN AL FINAL PARA INCLUIR AL INICIO UTILIZAR PARMETRO SIGUIENTE.
		4. Puede utilizar los atributos includebefore, o includebeforeArray igual que el punto anterior y los botones se incluyen al principio de los botones.
				LOS BOTONES SE INCLUYEN AL INICIO PARA INCLUIR AL FINAL UTILIZAR PARMETRO ANTERIOR.
		5. Puede utilizar los atributos values para no pintar el set por defecto de botones y en su lugar pintar los botones indicados a traves de este parmetro.
							ejemplo <cf_botones values="Anterior,Siguiente">
		6. Puede utilizar los atributos names, o namesArray para definir nombres los botones que se incluyen por medio del parmetro values, 
							util para poner nombre complejos a los botones, los values llevaran el nombre que se muestra, el complejo, y los names llevaran los
							nombres reales de los botones.
							ejemplo <cf_botones values="<< Anterior,Siguiente >>" names="Anterior,Siguiente">
		7. Puede utilizar los atributos functions, o functionsArray para llamar estas funciones personalizadas en cada boton en el evento onclick.
							ejemplo <cf_botones values="Aceptar,Rechazar" functions="return confirm('Confirma Aceptar?');,return confirm('Confirma Rechazar?');">
		8. Otros atributos
--->

<!--- Atributos --->
<!--- 1. Utilice por defecto para pintar como el tradicional portlet de botones: 
			ejemplo <cf_botones modo="#modo#">, donde modo = ALTA / CAMBIO. --->
<!--- Comportamiento por defecto --->
<!--- Define funcionamiento por defecto --->

<cfparam name="Attributes.bydefault" type="boolean" default="#not (isdefined('Attributes.values') and len(trim(Attributes.values))) and not (isdefined('Attributes.mododet') and len(trim(Attributes.mododet)))#">
<cfparam name="Attributes.bydefaultcondetalles" type="boolean" default="#not (isdefined('Attributes.values') and len(trim(Attributes.values))) and (isdefined('Attributes.mododet') and len(trim(Attributes.mododet)))#">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Regresar"
Default="Regresar"
XmlFile="/sif/generales.xml"
returnvariable="BTN_Regresar"/>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_DeseaEliminarelRegistro"
Default="¿Desea Eliminar el Registro?"
XmlFile="/sif/generales.xml"
returnvariable="MSG_DeseaEliminarelRegistro"/>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_DeseaEliminar"
Default="¿Desea Eliminar"
XmlFile="/sif/generales.xml"
returnvariable="MSG_DeseaEliminar"/>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_el"
Default="el"
XmlFile="/sif/generales.xml"
returnvariable="MSG_el"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_la"
Default="la"
XmlFile="/sif/generales.xml"
returnvariable="MSG_la"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Todo"
Default="Todo"
XmlFile="/sif/generales.xml"
returnvariable="MSG_Todo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_O"
Default="o"
XmlFile="/sif/generales.xml"
returnvariable="MSG_O"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_A"
Default="a"
XmlFile="/sif/generales.xml"
returnvariable="MSG_A"/>

<cfset list1 = " ,.,á,é,í,ó,ú,>,<,&aacute;,&eacute;,&iacute;,&oacute;,&uacute;">
<cfset list2 = "_,_,a,e,i,o,u,,a,e,i,o,u">


<cfparam name="Attributes.nameEnc" type="string" default=""><cfparam name="Attributes.generoEnc" type="string" default="M"><!---Nombre y Genero del Encabezado para ponerlo como descripcin agregada en los botones que corresponden al encabezado cuando aplica--->
<cfif isdefined("Attributes.MODOCAMBIO") and not isdefined("Attributes.MODO")><cfif Attributes.MODOCAMBIO><cfset Attributes.MODO = "CAMBIO"><cfelse><cfset Attributes.MODO = "ALTA"></cfif></cfif><!---Si se define MODOCAMBIO y no se define MODO se usa el valor del MODOCAMBIO--->
<cfif Attributes.bydefault>
	<cfif isdefined("Attributes.MODO") and Attributes.MODO eq "CAMBIO">
		<cfset Classic.Names = "Cambio,Baja,Nuevo">
		<cfset Classic.Values = "Modificar,Eliminar,Nuevo">
		<cfset Classic.Functions = "if (window.habilitarValidacion) habilitarValidacion();,if ( confirm('#MSG_DeseaEliminarelRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;},if (window.deshabilitarValidacion) deshabilitarValidacion();">
	<cfelse>
		<cfset Classic.Names = "Alta,Limpiar">
		<cfset Classic.Values = "Agregar,Limpiar">
		<cfset Classic.Functions = "if (window.habilitarValidacion) habilitarValidacion();if (1==2)alert('No haga nada');">
	</cfif>
<cfelseif Attributes.bydefaultcondetalles>
	<cfif isdefined("Attributes.MODO") and Attributes.MODO eq "CAMBIO">
		<cfif isdefined("Attributes.MODODET") and Attributes.MODODET eq "CAMBIO">
			
			<cfset Classic.Names = "CambioDet,BajaDet,Baja,NuevoDet">
			<cfset Classic.Values = "Modificar,Eliminar,Eliminar #Attributes.NameEnc#,Nuevo">
			<cfset Classic.Functions = "if (window.habilitarValidacion) habilitarValidacion();,
																	if ( confirm('#MSG_DeseaEliminarelRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;},
																	if ( confirm('#MSG_DeseaEliminar# #iif(Attributes.GeneroEnc eq 'M',DE('#MSG_el#'),DE('#MSG_la#'))# #Attributes.NameEnc##iif(len(trim(Attributes.NameEnc)),DE(''),DE('#MSG_Todo#'))#?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;},
																	if (window.deshabilitarValidacion) deshabilitarValidacion();">
		<cfelse>
			<cfset Classic.Names = "AltaDet,Cambio,Baja,Nuevo">
			<cfset Classic.Values = "Agregar,Modificar #iif(len(trim(Attributes.NameEnc)),DE(Attributes.NameEnc),DE('#MSG_Todo#'))#,Eliminar #iif(len(trim(Attributes.NameEnc)),DE(Attributes.NameEnc),DE('#MSG_Todo#'))#,Nuev#iif(Attributes.GeneroEnc eq 'M',DE('#MSG_O#'),DE('#MSG_A#'))# #iif(len(trim(Attributes.NameEnc)),DE(Attributes.NameEnc),DE('#MSG_Todo#'))#">
			<cfset Classic.Functions = "if (window.habilitarValidacion) habilitarValidacion(),
																	if (window.habilitarValidacion) habilitarValidacion(),
																	if ( confirm('#MSG_DeseaEliminar# #iif(Attributes.GeneroEnc eq 'M',DE('#MSG_el#'),DE('#MSG_la#'))# #Attributes.NameEnc##iif(len(trim(Attributes.NameEnc)),DE(''),DE('#MSG_Todo#'))#?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;},
																	if (window.deshabilitarValidacion) deshabilitarValidacion();">
		</cfif>
	<cfelse>
		<cfset Classic.Names = "Alta,Limpiar">
		<cfset Classic.Values = "Agregar,Limpiar">
		<cfset Classic.Functions = "if (window.habilitarValidacion) habilitarValidacion();if (1==2)alert('No haga nada');">
	</cfif>
<cfelse>
	<cfset Classic.Values = "">
	<cfset Classic.Names = "">
	<cfset Classic.Functions = "">
</cfif>
<!--- 2. Puede utilizar los atributos exclude, o excludeArray para excluir algunos botones del set de botones por defecto:
			ejemplo <cf_botones modo="#modo#" exclude="CAMBIO">, excluye el botn de CAMBIO. --->
<cfparam name="Attributes.exclude" type="string" default="">
<cfparam name="Attributes.excludearray" type="array" default="#ListToArray(Attributes.exclude)#">
<!--- 3. Puede utilizar los atributos include, o includeArray para incluir algunos botones adicionales al set de botones por defecto:
							ejemplo <cf_botones modo="#modo#" include="Regresar">, incluye el botn de REGRESAR.
				alternamente puede utilizar el includevalues para poner un valor complejo a los botones incluidos:
							ejemplo <cf_botones modo="#modo#" includevalues="Regresar a la pantalla anterior" include="Regresar">, incluye el botn de REGRESAR. 
				LOS BOTONES SE INCLUYEN AL FINAL PARA INCLUIR AL INICIO UTILIZAR PARMETRO SIGUIENTE. --->
<cfparam name="Attributes.include" type="string" default="">
<cfparam name="Attributes.includearray" type="array" default="#ListToArray(Attributes.include)#">
<cfparam name="Attributes.includevalues" type="string" default="">
<cfparam name="Attributes.includevaluesarray" type="array" default="#ListToArray(Attributes.includevalues)#">
<!--- 4. Puede utilizar los atributos includebefore, o includebeforeArray igual que el punto anterior y los botones se incluyen al principio de los botones.
				LOS BOTONES SE INCLUYEN AL INICIO PARA INCLUIR AL FINAL UTILIZAR PARMETRO ANTERIOR. --->
<cfparam name="Attributes.includebefore" type="string" default="">
<cfparam name="Attributes.includebeforearray" type="array" default="#ListToArray(Attributes.includebefore)#">
<cfparam name="Attributes.includebeforevalues" type="string" default="">
<cfparam name="Attributes.includebeforevaluesarray" type="array" default="#ListToArray(Attributes.includebeforevalues)#">
<!--- 5. Puede utilizar los atributos values para no pintar el set por defecto de botones y en su lugar pintar los botones indicados a traves de este parmetro.
							ejemplo <cf_botones values="Anterior,Siguiente"> --->
<cfparam name="Attributes.values" type="string" default="#Classic.Values#">
<cfparam name="Attributes.valuesarray" type="array" default="#ListToArray(Attributes.values)#">
<!--- 		6. Puede utilizar los atributos names, o namesArray para definir nombres los botones que se incluyen por medio del parmetro values, 
							util para poner nombre complejos a los botones, los values llevaran el nombre que se muestra, el complejo, y los names llevaran los
							nombres reales de los botones.
							ejemplo <cf_botones values="<< Anterior,Siguiente >>" names="Anterior,Siguiente"> --->
<cfparam name="Attributes.names" type="string" default="#Classic.Names#">
<cfparam name="Attributes.namesarray" type="array" default="#ListToArray(Attributes.names)#">
<!--- 7. Puede utilizar los atributos functions, o functionsArray para llamar estas funciones personalizadas en cada boton en el evento onclick.
							ejemplo <cf_botones values="Aceptar,Rechazar" functions="return confirm('Confirma Aceptar?');,return confirm('Confirma Rechazar?');"> --->
<cfparam name="Attributes.functions" type="string" default="#Classic.Functions#">
<cfparam name="Attributes.functionsarray" type="array" default="#ListToArray(Attributes.functions)#">
<!--- 8. Otros atributos --->
<cfparam name="Attributes.nbspbefore" type="numeric" default="0">
<cfparam name="Attributes.nbspafter" type="numeric" default="0">
<cfparam name="Attributes.incluyeForm" type="boolean" default="false">
<cfparam name="Attributes.formName" type="string" default="formbtn">
<cfparam name="Attributes.formAttr" type="string" default="">
<cfparam name="Attributes.irA" type="string" default="#GetFileFromPath(GetTemplatePath())#">
<cfparam name="Attributes.tabindex" type="numeric" default="0">
<cfparam name="Attributes.sufijo" type="string" default="">
<cfparam name="Attributes.regresar" type="string" default="">
<cfparam name="Attributes.regresarMenu" type="string" default="">
<cfparam name="Attributes.width" type="string" default="100%">
<cfparam name="Attributes.align" type="string" default="center">
<!--- JavaScript --->
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn<cfoutput>#Attributes.sufijo#</cfoutput>(obj) {
		botonActual = obj.name;
	}
	function btnSelected<cfoutput>#Attributes.sufijo#</cfoutput>(name, f) {
		if (f != null) {
			return (f["botonSel<cfoutput>#Attributes.sufijo#</cfoutput>"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>
<!--- Procesamiento Previo de los arreglos  -- Aqu se excluyen e incluyen botones y otras cosas interesantes -- --->
<cfset arraytmp = ArrayNew(1)>
<cfloop from="1" to="#ArrayLen(Attributes.excludearray)#" index="idx">
	<cfloop from="1" to="#ArrayLen(Attributes.namesarray)#" index="idy">
		<cfif Attributes.excludearray[idx] eq Attributes.namesarray[idy]>
			<cfset ArrayAppend(arraytmp, idy)>
		</cfif>
	</cfloop>
</cfloop>
<cfset ArraySort(arraytmp, "numeric", "desc")>
<cfloop from="1" to="#ArrayLen(arraytmp)#" index="idx">
	<cfset ArrayDeleteAt(Attributes.namesarray, arraytmp[idx])>
	<cfset ArrayDeleteAt(Attributes.valuesarray, arraytmp[idx])>
	<cfif ArrayLen(Attributes.functionsarray) and (arraytmp[idx] lte ArrayLen(Attributes.functionsarray))>
		<cfset ArrayDeleteAt(Attributes.functionsarray, arraytmp[idx])>
	</cfif>
</cfloop>
<cfset arraytmp = ArrayNew(1)>
<cfloop from="1" to="#ArrayLen(Attributes.includearray)#" index="idx">
	<cfset ArrayAppend(Attributes.namesarray, Attributes.includearray[idx])>
	<cfif ArrayLen(Attributes.includevaluesarray) gte idx>
		<cfset ArrayAppend(Attributes.valuesarray, Attributes.includevaluesarray[idx])>
	<cfelse>
		<cfset ArrayAppend(Attributes.valuesarray, Attributes.includearray[idx])>
	</cfif>
</cfloop>
<cfloop from="1" to="#ArrayLen(Attributes.includebeforearray)#" index="idx">
	<cfset ArrayInsertAt(Attributes.namesarray, idx, Attributes.includebeforearray[idx])>
	<cfif ArrayLen(Attributes.includebeforevaluesarray) gte idx>
		<cfset ArrayInsertAt(Attributes.valuesarray, idx, Attributes.includebeforevaluesarray[idx])>
	<cfelse>
		<cfset ArrayInsertAt(Attributes.valuesarray, idx, Attributes.includebeforearray[idx])>
	</cfif>
    <cfif ArrayLen(Attributes.functionsarray) GT 0>
		<cfset ArrayInsertAt(Attributes.functionsarray, idx, '')>
    </cfif>
</cfloop>
<!--- Agrega sufijo a los nombres --->
<cfif len(trim(Attributes.sufijo)) gt 0>
	<cfloop from="1" to="#ArrayLen(Attributes.namesarray)#" index="idy">
		<cfset Attributes.namesarray[idy] = Attributes.namesarray[idy] & Attributes.sufijo>
	</cfloop>
</cfif>
<!--- Traducción Magica --->
<cfset lvar_translatedvaluesarray = ArrayNew(1)>
 <cfloop from="1" to="#ArrayLen(Attributes.valuesarray)#" index="i">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate" 
	Key="BTN_#ReplaceList(trim(Attributes.valuesarray[i]),list1,list2)#"
	Default="#trim(Attributes.valuesarray[i])#"
	XmlFile="/sif/generales.xml"
	returnvariable="value"/>
	<cfset lvar_translatedvaluesarray[i] = value>
	<!---<cfset lvar_translatedvaluesarray[i] =trim(Attributes.valuesarray[i])>--->
</cfloop> 
<!--- Set de Botones --->
<cf_templatecss>
<cfif (Attributes.incluyeForm)>
	<cfoutput>
		<form style="margin: 0" action="#Attributes.irA#" method="post" name="#Attributes.formName#" id="#Attributes.formName#" #Attributes.formAttr#>
	</cfoutput>
</cfif>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" width="#Attributes.width#">
  <tr>
    <td align="#Attributes.align#">
		<input type="hidden" name="botonSel#Attributes.sufijo#" value="">
		<cfif Attributes.bydefault>
			<input name="txtEnterSI#Attributes.sufijo#" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="display:none;">
		</cfif>
		<cfloop from="1" to="#ArrayLen(Attributes.valuesarray)#" index="btidx">
			<cfset value = lvar_translatedvaluesarray[btidx]>
			<cfif ArrayLen(Attributes.namesarray) and (btidx lte ArrayLen(Attributes.namesarray))>
				<cfset name = trim(Attributes.namesarray[btidx])>
			<cfelse>
				<cfset name = 'btn'&trim(Attributes.valuesarray[btidx])>
			</cfif>
			<cfif ArrayLen(Attributes.namesarray) and (btidx lte ArrayLen(Attributes.namesarray))>
				<cfset funcion = 'if (window.func#Trim(trim(Attributes.namesarray[btidx]))#) return func#Trim(trim(Attributes.namesarray[btidx]))#();'>
			<cfelse>
				<cfset funcion = 'if (window.func#Trim(trim(Attributes.valuesarray[btidx]))#) return func#Trim(trim(Attributes.valuesarray[btidx]))#();'>
			</cfif>
			<cfif ArrayLen(Attributes.functionsarray) and (btidx lte ArrayLen(Attributes.functionsarray))>
				<cfset funcion = funcion & trim(Attributes.functionsarray[btidx])>
			</cfif>
			<cfif ucase(name) eq "LIMPIAR#Attributes.sufijo#" or ucase(name) eq "BTNLIMPIAR#Attributes.sufijo#"><cfset type = "reset"><cfelse><cfset type = "submit"></cfif>
			<cfset nbspbefore = ""><cfloop from="1" to="#Attributes.nbspbefore#" index="i"><cfset nbspbefore = nbspbefore & '&nbsp;'></cfloop>
			<cfset nbspafter = ""><cfloop from="1" to="#Attributes.nbspafter#" index="i"><cfset nbspafter = nbspafter & '&nbsp;'></cfloop>

<!---  danim, 12-oct-2005, clase predeterminada según el botón --->
			<cfset cf_botones__className = cf_botones_ClassName_segun_Name(name)>
<!--- /danim, 12-oct-2005, clase predeterminada según el botón --->
			<input type="#type#" name="#name#" class="#cf_botones__className#" value="#replace(nbspbefore & value & nbspafter,'_',' ','all')#" onclick="javascript: this.form.botonSel#Attributes.sufijo#.value = this.name; #funcion#" tabindex="#Attributes.tabindex#">
		</cfloop>
		<cfif len(Attributes.regresar)>
			<input type="button" name="Regresar" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript:location.href='#Attributes.regresar#';" tabindex="#Attributes.tabindex#">
		</cfif>
		<cfif len(Attributes.regresarMenu)>
			<cfif not isdefined("session.menues.id_root") and IsDefined('session.menues.SScodigo') and IsDefined('session.menues.SMcodigo')>
				<input type="button" name="RegresarM" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript: location.href='/cfmx/home/menu/modulo.cfm?s=#session.menues.SScodigo#&m=#session.menues.SMcodigo#';" tabindex="#Attributes.tabindex#">
			</cfif>	
		</cfif>
	</td>
  </tr>
</table>
</cfoutput>
<cfif (Attributes.incluyeForm)>
	</form>
</cfif>

<cfscript>
//  danim, 12-oct-2005, clase predeterminada según el botón
function cf_botones_ClassName_segun_Name(name)
{
	if (FindNoCase('alta',name) or FindNoCase('cambio',name) or FindNoCase('agrega',name) or FindNoCase('guarda',name) or FindNoCase('genera',name)) {
		return 'btnGuardar';
	} else if (FindNoCase('baja', name) or FindNoCase('elimina',name) or FindNoCase('anula',name)) {
		return 'btnEliminar';
	} else if (FindNoCase('nuevo', name)) {
		return 'btnNuevo';
	} else if (FindNoCase('limpiar', name) or FindNoCase('restablecer', name)) {
		return 'btnLimpiar';
	} else if (FindNoCase('filtr', name)) {
		return 'btnFiltrar';
	} else if (FindNoCase('aplica', name) or FindNoCase('procesa',name) or FindNoCase('recuperar',name)) {
		return 'btnAplicar';
	} else if (FindNoCase('impr', name)) {
		return 'btnImprimir';
	} else if (FindNoCase('refre', name)) {
		return 'btnRefresh';
	} else if (FindNoCase('mail', name) or FindNoCase('correo', name) or FindNoCase('enviar', name)) {
		return 'btnEmail';
	} else if (FindNoCase('publica', name)) {
		return 'btnPublicar';
	} else if (FindNoCase('regresa', name) or FindNoCase('anterior', name) or FindNoCase('lista', name)) {
		return 'btnAnterior';
	} else if (FindNoCase('siguiente', name)) {
		return 'btnSiguiente';
	} else {
		return 'btnNormal';
	}
	
}
/* className validos según CSS: 
.btnFiltrar,
.btnAplicar, .btnEmail, .btnPublicar,
.btnDetalle, .btnAnterior, .btnSiguiente */
/* /danim, 12-oct-2005, clase predeterminada según el botón */
</cfscript>
<cfif not isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>