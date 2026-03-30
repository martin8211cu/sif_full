<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!--- 
	Autor: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Implementa el control de lecturas pendientes en el submit de campos que envían a TraerDatos por medio de un Iframe,
	*	cuando se presiona Enter en el campo del Conlis, o cuando el servidor está muy lerdo.
	* Para conlis está completamente implementado si se utilizan el <CF_conlis>
	* 
	* Este tag debe utilizarse en todos los tags antiguos que hacen la función de conlis 
	* o en cualquier form que tenga campos asociados a un IFrame
	*
	* UTILIZACION:
	* 
	* Si se utiliza <CF_conlis>:
	* 	No hay nada adicional que hacer
	* 
	* Si hay campos asociados a un IFrame o un tag antiguo (que no sea CF_conlis) (4 pasos):
	* 	- Inicializar el control de la forma con: <cf_IFramesStatus form="#FORM#" action="intiForm">
	* 	- En cada Script que invoca el IFrame:
	* 		i.  Agregar el control del campo con: <cf_IFramesStatus form="#FORM#" campo="#CAMPO#" action="jsAppend">
	* 		ii. Agregar en el url de la invocacion al IFrame el parametro "&CampoOnTrae=#CAMPO#"
	* 	- En el fuente del IFrame, en todo proceso indicar su final dentro de un js script con: <cf_IFramesStatus form="#FORM#" action="jsIFrameEnd">
	* 
	* - En detalle:
	* 	A.	En el fuente del FORM (si no es un tag) o del TAG que contiene campos asociados a un IFrame:
	* 		1.	Al inicio del FORM (si no es un tag) o del TAG:
	* 			a.	Inicializar el IFramesStatus del form:
	* 				<cf_IFramesStatus form="#FORM#" action="intiForm">
	* 
	* 		2.	En la definción de cada CAMPO asociado a un IFrame 
	* 			(que no se definió con cf_conlis):
	* 			a.	CAMPO.onblur ="funcionParaInvocarIframe();"
	* 			b.	function funcionParaInvocarIframe() (generalmente es TraeCAMPO):
	* 				{
	* 					if (se_invoca_iframe_para_traer_datos)
	* 					{
	* 						<cf_IFramesStatus form="#FORM#" campo="#CAMPO#" action="jsAppend">
	* 						IFRAME.src = "..." + "&CampoOnTrae=#CAMPO#";
	* 					}
	* 				}
	* 			
	* 	B.	En el fuente del IFrame, en TODO LUGAR donde termine la ejecución del IFrame 
	* 		y se halla terminado de modificar los valores del window.parent (aunque sea en blanco).
	* 		OJO: Si no coloca este tag, no se podrá realizar NUNCA el submit de la forma en la pantalla original.
	* 		(recuerde que es obligatorio que se haya enviado por url el parámetro CampoOnTrae=#CAMPO#):
	* 			<cf_IFramesStatus form="#FORM#" action="jsIFrameEnd">
	* 			Si se necesita cancelar el submit de la pantalla original, por ejemplo, porque se requiere 
	*			levantar el WindowPopUp, se indica con:
	* 			<cf_IFramesStatus form="#FORM#" action="jsIFrameEnd" IFramePending="yes">
	* 
--->
<cfparam name="Attributes.form" 			type="string">
<cfparam name="Attributes.campo" 			type="string"  default="">
<cfparam name="Attributes.action"			type="string"  default="intiForm">
<cfparam name="Attributes.IFramePending"	type="boolean" default="no">		

<cfset Attributes.action = lcase(Attributes.action)>
<cfif NOT listFind("initform,jsappend,jsiframeend", Attributes.action)>
	<cf_errorCode	code = "50674" msg = "ERROR EN LA DEFINICION DEL CF_IFramesStatus: El atributo ACTION unicamente puede tener los valores: intiForm,jsAppend,jsIFrameEnd">
</cfif>
<cfif Attributes.action EQ "jsappend" AND Attributes.Campo EQ "">
	<cf_errorCode	code = "50675" msg = "ERROR EN LA DEFINICION DEL CF_IFramesStatus: El Action='jsAppend' requiere el atributo campo='NOMBRE_CAMPO'">
</cfif>
</cfsilent>
<cfif Attributes.action EQ "initform">
	<cfsilent>
	<cfif isdefined("request.IFramesStatus.#Attributes.form#")>
		<cfreturn>
	</cfif>
	<cfset request.IFramesStatus[Attributes.form] = true>
	</cfsilent>
	<cfoutput>
	<!-- Rutinas de Control del CF_IFramesStatus para #Attributes.form# -->
	<script language="javascript">
		var GvarCF_IFramesStatus_#Attributes.form#_reading	= false;
		var GvarCF_IFramesStatus_#Attributes.form#_pending	= false;
		var GvarCF_IFramesStatus_#Attributes.form#_timeout	= 1000;
		var GvarCF_IFramesStatus_#Attributes.form#_ontrae	= "";
		
		function fnCF_IFramesStatus_#Attributes.form#_ontraeNotFind (pValue)
		{
			return ((","+GvarCF_IFramesStatus_#Attributes.form#_ontrae+",").indexOf(","+pValue+",") == -1);
		}
		
		function sbCF_IFramesStatus_#Attributes.form#_ontraeAppend (name)
		{
			if (GvarCF_IFramesStatus_#Attributes.form#_ontrae == "")
				GvarCF_IFramesStatus_#Attributes.form#_ontrae = name;
			else if (fnCF_IFramesStatus_#Attributes.form#_ontraeNotFind(name))
				GvarCF_IFramesStatus_#Attributes.form#_ontrae += "," + name;
		}

		function sbCF_IFramesStatus_#Attributes.form#_ontraeDelete (pValue, pPending)
		{
			if (pPending)
			{
				GvarCF_IFramesStatus_#Attributes.form#_pending = true;
				setTimeout ("GvarCF_IFramesStatus_#Attributes.form#_pending = false; sbCF_IFramesStatus_#Attributes.form#_ontraeDelete ('"+pValue+"', false);", GvarCF_IFramesStatus_#Attributes.form#_timeout);
				return;
			}
			
			if (GvarCF_IFramesStatus_#Attributes.form#_ontrae == pValue)
			{
				GvarCF_IFramesStatus_#Attributes.form#_ontrae 	= "";
				return;
			}
			
			var LvarN 	= pValue.length;
			var LvarPto	= (","+GvarCF_IFramesStatus_#Attributes.form#_ontrae+",").indexOf(","+pValue+",");
			if (LvarPto == 0)
				GvarCF_IFramesStatus_#Attributes.form#_ontrae 	= GvarCF_IFramesStatus_#Attributes.form#_ontrae.substr(LvarN+1);
			else if (LvarPto > 0)
				GvarCF_IFramesStatus_#Attributes.form#_ontrae 	= GvarCF_IFramesStatus_#Attributes.form#_ontrae.substr(0,LvarPto-1)
																+ GvarCF_IFramesStatus_#Attributes.form#_ontrae.substr(LvarPto+LvarN);
		}

		function fnCF_IFramesStatus_#Attributes.form#_onsubmit ()
		{
			if (GvarCF_IFramesStatus_#Attributes.form#_ontrae == "")
			{
				GvarCF_IFramesStatus_#Attributes.form#_reading = false;
			}
			else
			{
				if (GvarCF_IFramesStatus_#Attributes.form#_pending)
				{
					return false;
				}
				else if (!GvarCF_IFramesStatus_#Attributes.form#_reading || GvarCF_IFramesStatus_#Attributes.form#_pending)
				{
					GvarCF_IFramesStatus_#Attributes.form#_reading = true;
					setTimeout ('Gvar_CF_onEnter_submit.click();', GvarCF_IFramesStatus_#Attributes.form#_timeout);
					return false;
				}
				else
				{
					GvarCF_IFramesStatus_#Attributes.form#_reading = false;
					if (confirm("Todavía existen procesos de lectura que no han terminado. ¿Desea reintentar de nuevo?"))
						setTimeout ('Gvar_CF_onEnter_submit.click();', GvarCF_IFramesStatus_#Attributes.form#_timeout);
					return false;
				}
			}
			return true;
		}

		function sbCF_IFramesStatus_#Attributes.form#_Initializate()
		{
			var LvarNewEvent = "sbCF_IFramesStatus_#Attributes.form#_changeOnsubmit ();";
			var LvarOldEvent = false;
			if (window.Event)
				LvarOldEvent = window.onload ? window.onload : false;
			else
				LvarOldEvent = document.body.onload ? document.body.onload : false;
		
			if (LvarOldEvent)
			{
				LvarOldEvent = LvarOldEvent.toString();
				if (LvarOldEvent.indexOf(LvarNewEvent) == -1)
					LvarNewEvent += LvarOldEvent.substring(LvarOldEvent.indexOf("{"),LvarOldEvent.lastIndexOf("}")+1);
				else
					return;
			}
		
			if (window.Event)
				window.onload = new Function(LvarNewEvent);
			else
				document.body.onload = new Function(LvarNewEvent);
		}

		function sbCF_IFramesStatus_#Attributes.form#_changeOnsubmit ()
		{
			var LvarOnSubmit = "";
			if (document.#Attributes.form#)
			{
				if (document.#Attributes.form#.onsubmit)
				{
					LvarOnSubmit = document.#Attributes.form#.onsubmit.toString();
					
					if (LvarOnSubmit.indexOf("fnCF_IFramesStatus_#Attributes.form#_onsubmit ()") == -1)
					{
						try
						{
							LvarOnSubmit 	= "if (!fnCF_IFramesStatus_#Attributes.form#_onsubmit ()) return false; else " 
											+ LvarOnSubmit.substring(LvarOnSubmit.indexOf("{"),LvarOnSubmit.lastIndexOf("}")+1);
							document.#Attributes.form#.onsubmit = new Function(LvarOnSubmit);
						return;
						}
						catch (e) {;}
					}
				}
				document.#Attributes.form#.onsubmit = new Function("return fnCF_IFramesStatus_#Attributes.form#_onsubmit();");
			}
		}

		sbCF_IFramesStatus_#Attributes.form#_Initializate ();
	</script>
	<cfif not isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
	</cfoutput>
<cfelseif Attributes.action EQ "jsappend">
	<cfsilent>
	<cfif not isdefined("request.IFramesStatus.#Attributes.form#")>
		<cf_errorCode	code = "50676"
						msg  = "ERROR EN LA DEFINICION DEL CF_IFrameStatus: No se ha inicializado el form='@errorDat_1@' con Action='intiForm'"
						errorDat_1="#Attributes.form#"
		>
	</cfif>
	</cfsilent>
	<cfoutput>
								sbCF_IFramesStatus_#Attributes.form#_ontraeAppend("#Attributes.campo#");
	</cfoutput>
<cfelseif Attributes.action EQ "jsiframeend">
	<cfif NOT isdefined("url.CampoOnTrae")>
		<cf_errorCode	code = "50677" msg = "ERROR EN LA DEFINICION DEL CF_IFramesStatus: No se invocó el IFrame con el parametro URL: CampoOnTrae='CAMPO'">
	</cfif>
	<cfoutput>
	if (window.parent.sbCF_IFramesStatus_#Attributes.form#_ontraeDelete)
		window.parent.sbCF_IFramesStatus_#Attributes.form#_ontraeDelete("#url.CampoOnTrae#",<cfif Attributes.IFramePending>true<cfelse>false</cfif>);
	else
	{
		var LvarMSG = "";
		LvarMSG += 'if (window.parent.sbCF_IFramesStatus_#Attributes.form#_ontraeDelete)';
		LvarMSG += ' window.parent.sbCF_IFramesStatus_#Attributes.form#_ontraeDelete("#url.CampoOnTrae#");';
		LvarMSG += ' else';
		LvarMSG += ' alert ("ERROR EN LA DEFINICION DEL CF_IFrameStatus: no se inicializó el form=#Attributes.form# con Action=intiForm en el documento parent: " + window.parent.document.location.pathname);';
		setTimeout (LvarMSG,100);
	}
	</cfoutput>
</cfif>

