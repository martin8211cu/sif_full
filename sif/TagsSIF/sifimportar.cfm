<!---

Modificado el 10/23/2014

Se incluye el importador complejo. Ademas se incluye un nuevo parametro (encabezado), para indicar si las hojas incluyen o no un encabezado con el objetivo de saltarselo al momento de realizar el escaneo


Modificación realizada por Gustavo A. Gutiérrez Alfaro  23/06/06

Se solicitaron las siguientes modificaciones al TAG
1.	Incluir para cada exportador una seguridad por empresa
2.	Incluir para cada exportador una seguridad por empresa / usuario.
3.	Si el TAG ejecuta un exportador que tiene asociado un cfm que pinta los parámetros solicitados por el mismo (exportador), el TAG pueda pintar esta pantalla.
4.	Que por medio de TAG se pueda pintar una pantalla en la cual se muestra todos aquellos exportadores a los que un usuario tenga derechos según la empresa y modulo en el que se encuentra.
5.	Que además de los cambios anteriores el TAG continúe funcionando como hasta ahora.

Las modificaciones que se realizaron al TAG son las siguientes:

Se agregaron 3 nuevos parámetros:

Nuevo="true"   : Parámetro para indicar que se desea utilizar el TAG con las nuevas  modificaciones. 
				 Si este parámetro no se envía el TAG continua  funcionando como esta actualmente. 
				 Este parámetro además valida si el usuario tiene derecho de ejecutar este exportador.

El default de este parámetro es FALSE

**** los siguientes parámetros dependen de que el anterior este así  Nuevo="true" 
  
ListaDeExportacion ="true" : Si se envía este parámetro  se mostrara una lista de aquellos exportadores que el usuario (que se encuentra en sesión ) tiene derecho a ejecutar  ya sea para un modulo en especial o para todos.  El default de este parámetro es FALSE

Cuando se desea mostrar la lista , no es necesario enviar los parámetros en el TAG.


Modulo = "rh.reppag" : Si se envía este parámetro  con valor , me mostrara en la lista todos aquellos exportadores que tengo derecho de ejecución para el modulo que estoy indicando  

*** nota el valor del modulo es el mismo que se indica cuando estoy parametrizando el exportador en PSO.

Ejemplos de cómo invocar el TAG

Si se desea invocar de la manera tradicional seria de la siguiente manera :

<cf_sifimportar 
EIcodigo="EX_BCR" 
EIid="1207" 
mode="out">
<cf_sifimportarparam name="Bid" value="14">
<cf_sifimportarparam name="ERNid" value="540">

Si se desea invocar de la con la nueva modificación seria de la siguiente manera :

<cf_sifimportar 
EIcodigo="EX_BCR" 
EIid="1207"
Nuevo="true" 
mode="out">
<cf_sifimportarparam name="Bid" value="14">
<cf_sifimportarparam name="ERNid" value="540">

Si se envia el parámetro Nuevo="true"  Ya no sera necesario tener que pintar una pantalla previa para pintar los parámetro y luego invocar el componente.

Ya el TAG pintara dinámicamente estos campos o anexara el cfm de parámetros si el exportador lo tiene.

Si lo que deseamos es que el TAG nos pinte la lista exportadores a que el usuario tiene derecho seria de la siguiente manera :

<cf_sifimportar  
mode="out" 
Nuevo="true" 
Modulo = "rh.reppag" 
ListaDeExportacion ="true" >

si no se indica el modulo mostrara todos exportadores a los que el usuario tiene derecho  de lo contrario solo mostrara los del modulo indicado.

Nótese que de esta manera no se envian parámetros.

NOTA:  NO USE el </cf_sifimportar>  porque se dispara dos veces la invocacion del TAG

rmasis

Cuando una variable vienen con el simbolo $ indica que es una variable dinamica por lo que se debe de hacer un procedimiento para obtener su valor, este valor es
obteneido al presionar el boton importar. Es necesario pasar el nombre del form al cual pertenecen las variables.
<cf_sifimportarparam name="RHPOPid" value="$RHPOPid$,Cuenta">
Explicacion:

name="RHPOPid" = Este atributo nos indica el nombre de la variable que le daremos en el importador y la cual utilizaremos en la ejecucion de la importacion de los datos.
value="$RHPOPid$,Cuenta" = Esta dividido por una coma.
						   El 1° parametro nos indica el nombre del objeto del form al cual invocaremos y su valor lo colocaremos en la variable anterior creada. 
						   El segundo parametro es la descripcion del campo para mandar un mensaje de error si es necesario.


--->
<cfsetting enablecfoutputonly="yes" requesttimeout="3600">


<cfif ThisTag.ExecutionMode IS 'Start' AND ThisTag.HasEndTag IS 'YES'>

<cfelseif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'NO' >
	
	<cfparam name="Attributes.EIid"     type="numeric" default="0">
	<cfparam name="Attributes.EIcodigo" type="string"  default="">
	<cfparam name="Attributes.mode"     type="string">
	<cfparam name="Attributes.width"    type="string" default="300">
	<cfparam name="Attributes.height"   type="string" default="300">
	<cfparam name="Attributes.form"     type="string"  default="formexport">
	<cfparam name="Attributes.exec"     type="boolean" default="no">
	
	
	<!--- solo para exportación --->
	<cfparam name="Attributes.html"     type="boolean" default="no">
	<cfparam name="Attributes.header"   type="boolean" default="#Attributes.html#">
	<cfparam name="Attributes.name"     type="string"  default="">
	<cfparam Name="ThisTag.parameters"  default="#arrayNew(1)#">
	<!--- solo para exportación (nuevos)--->
	<cfparam name="Attributes.Modulo" 		  		type="string"  default="TODOS">
	<cfparam name="Attributes.ListaDeExportacion" 	type="boolean" default="false">
	<cfparam name="Attributes.Nuevo" 				type="boolean" default="false">
	<cfparam name="Attributes.ExtraccAsientos" 		type="boolean" default="false">
	<!--- importacion compleja --->
	<cfparam name="Attributes.Encabezado" 		type="boolean" default="false">
	
	<cfif Attributes.Nuevo>
		<!---  	En esta opcion lo que hace es pintar el combo de exportadores a los que el usuario tiene acceso 	--->
		<cfif Attributes.ListaDeExportacion eq "true" and Attributes.mode eq "out">
			<cfset ListParams = "">
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
				<cfset ListParams = ListAppend(ListParams,"#ThisTag.parameters[i].name#=#ThisTag.parameters[i].value#","|")>
			</cfloop>
			<cflocation url="/cfmx/sif/importar/IMP_SeleccionExportadores.cfm?Modulo=#Attributes.Modulo#&PARAMETROS=#ListParams#">
		<!---  pinta el exportador que esta ejecutando si este tiene un cfm para los parametros los pinta.	--->
		<cfelseif Attributes.mode eq "out" and isdefined("Attributes.EIid") and len(trim(Attributes.EIid)) gt 0 and isdefined("Attributes.EIcodigo") and len(trim(Attributes.EIcodigo)) gt 0 >
			<cfset ListParams = "">
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
				<cfset ListParams = ListAppend(ListParams,"#ThisTag.parameters[i].name#=#ThisTag.parameters[i].value#","|")>
			</cfloop>		
			<cflocation url="/cfmx/sif/importar/IMP_SolicitarParametros.cfm?Directo=S&Modulo=#Attributes.Modulo#&PARAMETROS=#ListParams#&EIcodigo=#Attributes.EIcodigo#&EIid=#Attributes.EIid#">
		</cfif>
	<cfelse>
		<!---  Invocacion normal del exportador . (version anterior)	--->
		
		<!----=============== TRADUCCION ==================--->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Debe_especificarse_al_menos_uno_de_los_siguientes_atributos_EIid_EIcodigo"
			Default="Debe especificarse al menos uno de los siguientes atributos:  EIid, EIcodigo"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_Atributos"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_cfsifimportar_No_se_debe_especificar_mode_in_y_exec_yes"
			Default="cfsifimportar No se debe especificar mode=in y exec=yes"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_cfsifimportar_No_se_debe_especificar_mode"/>
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_atributo_mode_debe_ser_in_o_out"
			Default="El atributo mode debe ser in o out	"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_El_atributo_mode_debe_ser_in_o_out"/>		
		
			
		<cfif Attributes.EIid EQ 0 AND Len(Attributes.EIcodigo) EQ 0>
			<cfoutput><cfthrow message="#MSG_Atributos#"></cfoutput>
		</cfif>
		
		<cfquery datasource="sifcontrol" name="formatos">
			select * from EImportador
			where (Ecodigo is null
			   or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" null="#Len(session.Ecodigo) is 0#">)
			<cfif Attributes.EIid NEQ 0>
			  and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EIid#">
			</cfif>
			<cfif Len(Attributes.EIcodigo) NEQ 0>
			  and rtrim(EIcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(Attributes.EIcodigo)#">
			</cfif>
		</cfquery>
		
		<cfif formatos.RecordCount EQ 1>
			<cfif Attributes.mode EQ "out" and formatos.EIexporta EQ 0>
				<cfoutput><cf_translate key="LB_Este_format_no_esta_habilitado_para_exportacion" XmlFile="/sif/generales.xml">Este formato no est&aacute; habilitado para exportaci&oacute;n.</cf_translate></cfoutput>
			<cfelseif Attributes.mode EQ "out" and Attributes.exec EQ "yes">
				<cfinclude template="/sif/importar/export-function.cfm">
				<cfset parms = StructNew()>
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
					<cfset parms[ThisTag.parameters[i].name] = ThisTag.parameters[i].value>
				</cfloop>
				<cfif Len(Attributes.name) EQ 0>
					<cfset LvarArchivo=exportar(formatos.EIid,Attributes.html,Attributes.header,parms)>
					<cfif not Attributes.html>
						<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
						<cfheader  name="Content-Disposition"	value="attachment;filename=#Attributes.EIcodigo#.txt">
						<cfcontent type="text/plain" reset="yes" file="#LvarArchivo#" deletefile="yes">
					</cfif>
					<cfabort>
				<cfelse>
					<!---
						exec=yes  se hace obsoleto para modificar la funcion exportar()
								  para que no use una variable temporal.
								  danim, 03-ene-2005
					--->
					<cf_errorCode	code = "50702" msg = "exec=yes,name=var está obsoleto.">
					<cfset "Caller.#Attributes.name#" = ret_value>
				</cfif>
			<cfelseif Attributes.mode EQ "out" and Attributes.ExtraccAsientos EQ "false">
				<cfinclude template="/sif/importar/export-form.cfm">
		
			<cfelseif Attributes.mode EQ "out" and Attributes.ExtraccAsientos EQ  "true">
				<cfinclude template="/sif/importar/ExportSeatsAcounts-form.cfm">	
											
			<cfelseif Attributes.mode EQ "in" and formatos.EIimporta EQ 0>
				<cfoutput><cf_translate key="LB_Este_formato_no_esta_habilitado_para_importacion" XmlFile="/sif/generales.xml">Este formato no est&aacute; habilitado para importaci&oacute;n.</cf_translate></cfoutput>
			<cfelseif Attributes.mode EQ "in" AND Attributes.exec EQ "yes">			
				<cfthrow message="#MSG_cfsifimportar_No_se_debe_especificar_mode#">
			<cfelseif Attributes.mode EQ "in">
				<cfset ListParams = "">
				<cfset InputNames = "">
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
					<cfset lvarValue = ThisTag.parameters[i].value>
                	<cfif Find('$',lvarValue)>
                    	<cfset InputNames = "&#ListAppend(InputNames,"InputNames=#ThisTag.parameters[i].name#,#Replace(ThisTag.parameters[i].value,'$','','ALL')#","&")#">
                    <cfelse>
						<cfset ListParams = "&#ListAppend(ListParams,"parameters=#ThisTag.parameters[i].name#,#ThisTag.parameters[i].value#","&")#">
                    </cfif>
				</cfloop>
				<cfoutput>
					<iframe name="ifrImportar" id="ifrImportar"
						width ="#Attributes.width#"
						height="#Attributes.height#"
						frameborder="0"
						src="/cfmx/sif/importar/importar-form.cfm?fmt=#URLEncodedFormat(formatos.EIid)#&form=#URLEncodedFormat(Attributes.form)##ListParams##URLEncodedFormat(InputNames)#">
					</iframe>
				</cfoutput>
			<cfelseif Attributes.mode EQ "inComplejo" and formatos.EIimportaComplejo EQ 0>
				<!--- 


				ACA EMPIEZA A SECCION DE LOS IMPORTADORES COMPLEJOS

				--->

				<cfoutput><cf_translate key="LB_Este_formato_no_esta_habilitado_para_importacion" XmlFile="/sif/generales.xml">Este formato no est&aacute; habilitado para importacion compleja.</cf_translate></cfoutput>

			<cfelseif Attributes.mode EQ "inComplejo" >


					<cfinclude template="/sif/importar/importarComplejo-form.cfm">
					
					
			
					
			<cfelse>
				<cfthrow message="#MSG_El_atributo_mode_debe_ser_in_o_out#">
			</cfif>
		</cfif>
	</cfif>
</cfif> 
<!--- ThisTag.ExecutionMode IS 'End' --->
<cfsetting enablecfoutputonly="no">

